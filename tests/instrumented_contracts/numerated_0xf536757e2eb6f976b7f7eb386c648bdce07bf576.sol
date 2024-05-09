1 pragma solidity ^0.4.13;
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
63     /* Token supply got increased and a new owner received these tokens */
64     event Minted(address receiver, uint amount);
65 
66     /* Actual balances of token holders */
67     mapping(address => uint) balances;
68 
69     /* approve() allowances */
70     mapping (address => mapping (address => uint)) allowed;
71 
72     /* Interface declaration */
73     function isToken() public constant returns (bool weAre) {
74         return true;
75     }
76 
77     /**
78      * Reviewed:
79      * - Interger overflow = OK, checked
80      */
81     function transfer(address _to, uint256 _value) returns (bool success) {
82         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
83             balances[msg.sender] -= _value;
84             balances[_to] += _value;
85             Transfer(msg.sender, _to, _value);
86             return true;
87         }
88         else {return false;}
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
92         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
93             balances[_to] += _value;
94             balances[_from] -= _value;
95             allowed[_from][msg.sender] -= _value;
96             Transfer(_from, _to, _value);
97             return true;
98         }
99         else {return false;}
100     }
101 
102     function balanceOf(address _owner) constant returns (uint balance) {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint _value) returns (bool success) {
107         // To change the approve amount you first have to reduce the addresses`
108         //  allowance to zero by calling `approve(_spender, 0)` if it is not
109         //  already 0 to mitigate the race condition described here:
110         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
112 
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) constant returns (uint remaining) {
119         return allowed[_owner][_spender];
120     }
121 
122     /*
123     * Fix for the ERC20 short address attack
124     */
125     modifier onlyPayloadSize(uint size) {
126         assert(msg.data.length >= size + 4);
127         _;
128     }
129 }
130 
131 contract LGBiT is StandardToken {
132 
133     string public name = "LGBiT";
134     string public symbol = "LGBiT";
135 
136     uint public decimals = 8;
137     uint public multiplier = 100000000; // decimals to the left
138 
139     /**
140      * Boolean contract states
141      */
142     bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency
143     bool public preIco = true; //Pre-ico state
144 
145     /**
146      * Initial founder address (set in constructor)
147      * All deposited ETH will be forwarded to this address.
148      * Address is a multisig  wallet.
149      */
150     address public founder = 0x0;
151     address public owner = 0x0;
152 
153     /**
154      * Token count
155      */
156     uint public totalTokens = 50750000;
157 
158     uint public bounty = 200000; // Bounty count
159 
160     /**
161      * Ico and pre-ico cap
162      */
163     uint public preIcoCap = 550000 * multiplier; // Max amount raised during pre ico 17500 ether (10%)
164     uint public icoCap = 50000000 * multiplier; // Max amount raised during crowdsale 175000 ether
165 
166     /**
167      * Statistic values
168      */
169     uint public presaleTokenSupply = 0; // This will keep track of the token supply created during the crowdsale
170     uint public presaleEtherRaised = 0; // This will keep track of the Ether raised during the crowdsale
171     uint public preIcoTokenSupply = 0; // This will keep track of the token supply created during the pre-ico
172 
173     event Buy(address indexed sender, uint eth, uint fbt);
174 
175     /* This generates a public event on the blockchain that will notify clients */
176     event TokensSent(address indexed to, uint256 value);
177     event ContributionReceived(address indexed to, uint256 value);
178     event Burn(address indexed from, uint256 value);
179 
180     function LGBiT() payable {
181         owner = msg.sender;
182         founder = 0x00A691299526E4DC3754F8e2A0d6788F27c0dc7e;
183 
184         // Sub from total tokens bounty pool
185         totalTokens = safeSub(totalTokens, bounty);
186         totalSupply = safeMul(totalTokens, multiplier);
187         balances[owner] = safeMul(totalSupply, multiplier);
188     }
189 
190     /**
191      * Price count
192      */
193     function price() constant returns (uint256){
194         if (preIco) {
195             return safeDiv(1 ether, 800);
196         } else {
197             if (presaleEtherRaised < 4999 ether) {
198                 return safeDiv(1 ether, 700);
199             } else if (presaleEtherRaised >= 5000 ether && presaleEtherRaised < 9999 ether) {
200                 return safeDiv(1 ether, 685);
201             } else if (presaleEtherRaised >= 10000 ether && presaleEtherRaised < 19999 ether) {
202                 return safeDiv(1 ether, 660);
203             } else {
204                 return safeDiv(1 ether, 600);
205             }
206         }
207     }
208 
209     /**
210       * The basic entry point to participate the crowdsale process.
211       *
212       * Pay for funding, get invested tokens back in the sender address.
213        */
214     function buy() public payable returns(bool) {
215         processBuy(msg.sender, msg.value);
216 
217         return true;
218     }
219 
220     function processBuy(address _to, uint256 _value) internal returns(bool) {
221         // Buy allowed if contract is not on halt
222         require(!halted);
223         // Amount of wei should be more that 0
224         require(_value>0);
225 
226         // Count expected tokens price
227         uint tokens = _value / price();
228 
229         if (_value > 99 ether && _value < 1000 ether) {
230             // Add 10% if you send > 100 but < 1000 eth
231             tokens = tokens + (tokens / 10);
232         } else if (_value > 999 ether) {
233             // Add 25% if you send > 1000
234             tokens = tokens + (tokens / 4);
235         }
236 
237         // Total tokens should be more than user want's to buy
238         require(balances[owner]>safeMul(tokens, multiplier));
239 
240         // Check how much tokens already sold
241         if (preIco) {
242             // Check that required tokens count are less than tokens already sold on pre-ico
243             require(safeAdd(presaleTokenSupply, tokens) < preIcoCap);
244         } else {
245             // Check that required tokens count are less than tokens already sold on ico sub pre-ico
246             require(safeAdd(presaleTokenSupply, tokens) < safeSub(icoCap, preIcoTokenSupply));
247         }
248 
249         // Send wei to founder address
250         founder.transfer(_value);
251 
252         // Add tokens to user balance and remove from totalSupply
253         balances[_to] = safeAdd(balances[_to], safeMul(tokens, multiplier));
254         // Remove sold tokens from total supply count
255         balances[owner] = safeSub(balances[owner], safeMul(tokens, multiplier));
256 
257         // Update stats
258         if (preIco) {
259             preIcoTokenSupply  = safeAdd(preIcoTokenSupply, tokens);
260         }
261 
262         presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
263         presaleEtherRaised = safeAdd(presaleEtherRaised, _value);
264 
265         // Send buy token action
266         Buy(_to, _value, safeMul(tokens, multiplier));
267 
268         // /* Emit log events */
269         TokensSent(_to, safeMul(tokens, multiplier));
270         ContributionReceived(_to, _value);
271         Transfer(owner, _to, safeMul(tokens, multiplier));
272 
273         return true;
274     }
275 
276     /**
277      * Pre-ico state.
278      */
279     function setPreIco() onlyOwner() {
280         preIco = true;
281     }
282 
283     function unPreIco() onlyOwner() {
284         preIco = false;
285     }
286 
287     /**
288      * Emergency Stop ICO.
289      */
290     function halt() onlyOwner() {
291         halted = true;
292     }
293 
294     function unHalt() onlyOwner() {
295         halted = false;
296     }
297 
298     /**
299      * Transfer bounty tokens to target address
300      */
301     function sendBounty(address _to, uint256 _value) onlyOwner() {
302         require(bounty>_value);
303 
304         bounty = safeSub(bounty, _value);
305         balances[_to] = safeAdd(balances[_to], safeMul(_value, multiplier));
306 
307         // Emit log events
308         TokensSent(_to, safeMul(_value, multiplier));
309         Transfer(owner, _to, safeMul(_value, multiplier));
310     }
311 
312     /**
313      * ERC 20 Standard Token interface transfer function
314      *
315      * Prevent transfers until halt period is over.
316      */
317     function transfer(address _to, uint256 _value) isAvailable() returns (bool success) {
318         return super.transfer(_to, _value);
319     }
320 
321     /**
322      * ERC 20 Standard Token interface transfer function
323      *
324      * Prevent transfers until halt period is over.
325      */
326     function transferFrom(address _from, address _to, uint256 _value) isAvailable() returns (bool success) {
327         return super.transferFrom(_from, _to, _value);
328     }
329 
330     modifier onlyOwner() {
331         require(msg.sender == owner);
332         _;
333     }
334 
335     modifier isAvailable() {
336         require(!halted);
337         _;
338     }
339 
340     /**
341      * Just being sent some cash? Let's buy tokens
342      */
343     function() payable {
344         buy();
345     }
346 
347     /**
348      * Replaces an owner
349      */
350     function changeOwner(address _to) onlyOwner() {
351         balances[_to] = balances[owner];
352         balances[owner] = 0;
353         owner = _to;
354     }
355 
356     /**
357      * Replaces a founder, transfer team pool to new founder balance
358      */
359     function changeFounder(address _to) onlyOwner() {
360         balances[_to] = balances[founder];
361         balances[founder] = 0;
362         founder = _to;
363     }
364 }