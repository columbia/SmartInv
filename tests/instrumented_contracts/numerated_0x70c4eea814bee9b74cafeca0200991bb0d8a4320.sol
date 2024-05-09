1 pragma solidity ^0.4.15;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   function allowance(address owner, address spender) constant returns (uint);
7 
8   function transfer(address to, uint value) returns (bool ok);
9   function transferFrom(address from, address to, uint value) returns (bool ok);
10   function approve(address spender, uint value) returns (bool ok);
11   event Transfer(address indexed from, address indexed to, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 /**
16  * Math operations with safety checks
17  */
18 contract SafeMath {
19   function safeMul(uint a, uint b) internal returns (uint) {
20     uint c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function safeDiv(uint a, uint b) internal returns (uint) {
26     assert(b > 0);
27     uint c = a / b;
28     assert(a == b * c + a % b);
29     return c;
30   }
31 
32   function safeSub(uint a, uint b) internal returns (uint) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function safeAdd(uint a, uint b) internal returns (uint) {
38     uint c = a + b;
39     assert(c>=a && c>=b);
40     return c;
41   }
42 
43   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
44     return a >= b ? a : b;
45   }
46 
47   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a < b ? a : b;
49   }
50 
51   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
52     return a >= b ? a : b;
53   }
54 
55   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a < b ? a : b;
57   }
58 
59 }
60 
61 contract StandardToken is ERC20, SafeMath {
62 
63   /* Token supply got increased and a new owner received these tokens */
64   event Minted(address receiver, uint amount);
65 
66   /* Actual balances of token holders */
67   mapping(address => uint) balances;
68 
69   /* approve() allowances */
70   mapping (address => mapping (address => uint)) allowed;
71 
72   /* Interface declaration */
73   function isToken() public constant returns (bool weAre) {
74     return true;
75   }
76 
77   function transfer(address _to, uint _value) returns (bool success) {
78     balances[msg.sender] = safeSub(balances[msg.sender], _value);
79     balances[_to] = safeAdd(balances[_to], _value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
85     uint _allowance = allowed[_from][msg.sender];
86 
87     balances[_to] = safeAdd(balances[_to], _value);
88     balances[_from] = safeSub(balances[_from], _value);
89     allowed[_from][msg.sender] = safeSub(_allowance, _value);
90     Transfer(_from, _to, _value);
91     return true;
92   }
93 
94   function balanceOf(address _owner) constant returns (uint balance) {
95     return balances[_owner];
96   }
97 
98   function approve(address _spender, uint _value) returns (bool success) {
99 
100     // To change the approve amount you first have to reduce the addresses`
101     //  allowance to zero by calling `approve(_spender, 0)` if it is not
102     //  already 0 to mitigate the race condition described here:
103     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
105 
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   function allowance(address _owner, address _spender) constant returns (uint remaining) {
112     return allowed[_owner][_spender];
113   }
114 
115 }
116 
117 contract QVT is StandardToken {
118 
119     string public name = "QVT";
120     string public symbol = "QVT";
121     uint public decimals = 0;
122 
123     /**
124      * Boolean contract states
125      */
126     bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency
127     bool public preIco = true; //Pre-ico state
128     bool public freeze = true; //Freeze state
129 
130     /**
131      * Initial founder address (set in constructor)
132      * All deposited ETH will be forwarded to this address.
133      * Address is a multisig wallet.
134      */
135     address public founder = 0x0;
136     address public owner = 0x0;
137 
138     /**
139      * Token count
140      */
141     uint public totalTokens = 218750000;
142     uint public team = 41562500;
143     uint public bounty = 2187500; // Bounty count
144 
145     /**
146      * Ico and pre-ico cap
147      */
148     uint public preIcoCap = 17500000; // Max amount raised during pre ico 17500 ether (10%)
149     uint public icoCap = 175000000; // Max amount raised during crowdsale 175000 ether
150 
151     /**
152      * Statistic values
153      */
154     uint public presaleTokenSupply = 0; // This will keep track of the token supply created during the crowdsale
155     uint public presaleEtherRaised = 0; // This will keep track of the Ether raised during the crowdsale
156     uint public preIcoTokenSupply = 0; // This will keep track of the token supply created during the pre-ico
157 
158     event Buy(address indexed sender, uint eth, uint fbt);
159 
160     /* This generates a public event on the blockchain that will notify clients */
161     event TokensSent(address indexed to, uint256 value);
162     event ContributionReceived(address indexed to, uint256 value);
163     event Burn(address indexed from, uint256 value);
164 
165     function QVT(address _founder) payable {
166         owner = msg.sender;
167         founder = _founder;
168 
169         // Move team token pool to founder balance
170         balances[founder] = team;
171         // Sub from total tokens team pool
172         totalTokens = safeSub(totalTokens, team);
173         // Sub from total tokens bounty pool
174         totalTokens = safeSub(totalTokens, bounty);
175         // Total supply is 175000000
176         totalSupply = totalTokens;
177         balances[owner] = totalSupply;
178     }
179 
180     /**
181      * 1 QVT = 1 FINNEY
182      * Rrice is 1000 Qvolta for 1 ETH
183      */
184     function price() constant returns (uint){
185         return 1 finney;
186     }
187 
188     /**
189       * The basic entry point to participate the crowdsale process.
190       *
191       * Pay for funding, get invested tokens back in the sender address.
192       */
193     function buy() public payable returns(bool) {
194         processBuy(msg.sender, msg.value);
195 
196         return true;
197     }
198 
199     function processBuy(address _to, uint256 _value) internal returns(bool) {
200         // Buy allowed if contract is not on halt
201         require(!halted);
202         // Amount of wei should be more that 0
203         require(_value>0);
204 
205         // Count expected tokens price
206         uint tokens = _value / price();
207 
208         // Total tokens should be more than user want's to buy
209         require(balances[owner]>tokens);
210 
211         // Gave +50% of tokents on pre-ico
212         if (preIco) {
213             tokens = tokens + (tokens / 2);
214         }
215 
216         // Check how much tokens already sold
217         if (preIco) {
218             // Check that required tokens count are less than tokens already sold on pre-ico
219             require(safeAdd(presaleTokenSupply, tokens) < preIcoCap);
220         } else {
221             // Check that required tokens count are less than tokens already sold on ico sub pre-ico
222             require(safeAdd(presaleTokenSupply, tokens) < safeSub(icoCap, preIcoTokenSupply));
223         }
224 
225         // Send wei to founder address
226         founder.transfer(_value);
227 
228         // Add tokens to user balance and remove from totalSupply
229         balances[_to] = safeAdd(balances[_to], tokens);
230         // Remove sold tokens from total supply count
231         balances[owner] = safeSub(balances[owner], tokens);
232 
233         // Update stats
234         if (preIco) {
235             preIcoTokenSupply  = safeAdd(preIcoTokenSupply, tokens);
236         }
237         presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
238         presaleEtherRaised = safeAdd(presaleEtherRaised, _value);
239 
240         // Send buy Qvolta token action
241         Buy(_to, _value, tokens);
242 
243         // /* Emit log events */
244         TokensSent(_to, tokens);
245         ContributionReceived(_to, _value);
246         Transfer(owner, _to, tokens);
247 
248         return true;
249     }
250 
251     /**
252      * Pre-ico state.
253      */
254     function setPreIco() onlyOwner() {
255         preIco = true;
256     }
257 
258     function unPreIco() onlyOwner() {
259         preIco = false;
260     }
261 
262     /**
263      * Emergency Stop ICO.
264      */
265     function halt() onlyOwner() {
266         halted = true;
267     }
268 
269     function unHalt() onlyOwner() {
270         halted = false;
271     }
272 
273     /**
274      * Transfer bounty to target address from bounty pool
275      */
276     function sendTeamTokens(address _to, uint256 _value) onlyOwner() {
277         balances[founder] = safeSub(balances[founder], _value);
278         balances[_to] = safeAdd(balances[_to], _value);
279         // /* Emit log events */
280         TokensSent(_to, _value);
281         Transfer(owner, _to, _value);
282     }
283 
284     /**
285      * Transfer team tokens to target address
286      */
287     function sendBounty(address _to, uint256 _value) onlyOwner() {
288         bounty = safeSub(bounty, _value);
289         balances[_to] = safeAdd(balances[_to], _value);
290         // /* Emit log events */
291         TokensSent(_to, _value);
292         Transfer(owner, _to, _value);
293     }
294 
295     /**
296      * Transfer bounty to target address from bounty pool
297      */
298     function sendSupplyTokens(address _to, uint256 _value) onlyOwner() {
299         balances[owner] = safeSub(balances[owner], _value);
300         balances[_to] = safeAdd(balances[_to], _value);
301         // /* Emit log events */
302         TokensSent(_to, _value);
303         Transfer(owner, _to, _value);
304     }
305 
306     /**
307      * ERC 20 Standard Token interface transfer function
308      *
309      * Prevent transfers until halt period is over.
310      */
311     function transfer(address _to, uint256 _value) isAvailable() returns (bool success) {
312         return super.transfer(_to, _value);
313     }
314 
315     /**
316      * ERC 20 Standard Token interface transfer function
317      *
318      * Prevent transfers until halt period is over.
319      */
320     function transferFrom(address _from, address _to, uint256 _value) isAvailable() returns (bool success) {
321         return super.transferFrom(_from, _to, _value);
322     }
323 
324     /**
325      * Burn all tokens from a balance.
326      */
327     function burnRemainingTokens() isAvailable() onlyOwner() {
328         Burn(owner, balances[owner]);
329         balances[owner] = 0;
330     }
331 
332     modifier onlyOwner() {
333         require(msg.sender == owner);
334         _;
335     }
336 
337     modifier isAvailable() {
338         require(!halted && !freeze);
339         _;
340     }
341 
342     /**
343      * Just being sent some cash? Let's buy tokens
344      */
345     function() payable {
346         buy();
347     }
348 
349     /**
350      * Freeze and unfreeze ICO.
351      */
352     function freeze() onlyOwner() {
353          freeze = true;
354     }
355 
356      function unFreeze() onlyOwner() {
357          freeze = false;
358      }
359 
360     /**
361      * Replaces an owner
362      */
363     function changeOwner(address _to) onlyOwner() {
364         balances[_to] = balances[owner];
365         balances[owner] = 0;
366         owner = _to;
367     }
368 
369     /**
370      * Replaces a founder, transfer team pool to new founder balance
371      */
372     function changeFounder(address _to) onlyOwner() {
373         balances[_to] = balances[founder];
374         balances[founder] = 0;
375         founder = _to;
376     }
377 }