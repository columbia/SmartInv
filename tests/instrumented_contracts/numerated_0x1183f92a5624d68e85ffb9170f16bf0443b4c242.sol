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
121     uint public decimals = 18;
122     uint public multiplier = 1000000000000000000; // two decimals to the left
123 
124     /**
125      * Boolean contract states
126      */
127     bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency
128     bool public freeze = true; //Freeze state
129 
130     uint public roundCount = 1; //Round state
131     bool public isDayFirst = false; //Pre-ico state
132     bool public isDaySecond = false; //Pre-ico state
133     bool public isDayThird = false; //Pre-ico state
134     bool public isPreSale = false; // Pre-sale bonus
135 
136     /**
137      * Initial founder address (set in constructor)
138      * All deposited ETH will be forwarded to this address.
139      * Address is a multisig wallet.
140      */
141     address public founder = 0x0;
142     address public owner = 0x0;
143 
144     /**
145      * Token count
146      */
147     uint public totalTokens = 21600000;
148     uint public team = 3420000;
149     uint public bounty = 180000 * multiplier; // Bounty count
150     uint public preIcoSold = 0;
151 
152     /**
153      * Ico and pre-ico cap
154      */
155     uint public icoCap = 18000000; // Max amount raised during crowdsale 18000 ether
156 
157     /**
158      * Statistic values
159      */
160     uint public presaleTokenSupply = 0; // This will keep track of the token supply created during the crowdsale
161     uint public presaleEtherRaised = 0; // This will keep track of the Ether raised during the crowdsale
162 
163     event Buy(address indexed sender, uint eth, uint fbt);
164 
165     /* This generates a public event on the blockchain that will notify clients */
166     event TokensSent(address indexed to, uint256 value);
167     event ContributionReceived(address indexed to, uint256 value);
168     event Burn(address indexed from, uint256 value);
169 
170     function QVT(address _founder) payable {
171         owner = msg.sender;
172         founder = _founder;
173 
174         team = safeMul(team, multiplier);
175 
176         // Total supply is 18000000
177         totalSupply = safeMul(totalTokens, multiplier);
178         balances[owner] = safeSub(totalSupply, team);
179 
180         // Move team token pool to founder balance
181         balances[founder] = team;
182 
183         TokensSent(founder, team);
184         Transfer(owner, founder, team);
185     }
186 
187     /**
188      * 1 QVT = 1 FINNEY
189      * Rrice is 1000 Qvolta for 1 ETH
190      */
191     function price() constant returns (uint){
192         return 1 finney;
193     }
194 
195     /**
196       * The basic entry point to participate the crowdsale process.
197       *
198       * Pay for funding, get invested tokens back in the sender address.
199       */
200     function buy() public payable returns(bool) {
201         processBuy(msg.sender, msg.value);
202 
203         return true;
204     }
205 
206     function processBuy(address _to, uint256 _value) internal returns(bool) {
207         // Buy allowed if contract is not on halt
208         require(!halted);
209         // Amount of wei should be more that 0
210         require(_value>0);
211 
212         // Count expected tokens price
213         uint tokens = _value / price();
214 
215         // Total tokens should be more than user want's to buy
216         require(balances[owner]>safeMul(tokens, multiplier));
217 
218         // Gave pre-sale bonus
219         if (isPreSale) {
220             tokens = tokens + (tokens / 2);
221         }
222 
223         // Gave +30% of tokents on first day
224         if (isDayFirst) {
225             tokens = tokens + safeMul(safeDiv(tokens, 10), 3);
226         }
227 
228         // Gave +20% of tokents on second day
229         if (isDaySecond) {
230             tokens = tokens + safeDiv(tokens, 5);
231         }
232 
233         // Gave +10% of tokents on third day
234         if (isDayThird) {
235             tokens = tokens + safeDiv(tokens, 10);
236         }
237 
238         // Check that required tokens count are less than tokens already sold on ico sub pre-ico
239         require(safeAdd(presaleTokenSupply, tokens) < icoCap);
240 
241         // Send wei to founder address
242         founder.transfer(_value);
243 
244         // Add tokens to user balance and remove from totalSupply
245         balances[_to] = safeAdd(balances[_to], safeMul(tokens, multiplier));
246         // Remove sold tokens from total supply count
247         balances[owner] = safeSub(balances[owner], safeMul(tokens, multiplier));
248 
249         presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
250         presaleEtherRaised = safeAdd(presaleEtherRaised, _value);
251 
252         // /* Emit log events */
253         Buy(_to, _value, safeMul(tokens, multiplier));
254         TokensSent(_to, safeMul(tokens, multiplier));
255         ContributionReceived(_to, _value);
256         Transfer(owner, _to, safeMul(tokens, multiplier));
257 
258         return true;
259     }
260 
261     /**
262      * Emit log events
263      */
264     function sendEvents(address to, uint256 value, uint tokens) internal {
265         // Send buy Qvolta token action
266         Buy(to, value, safeMul(tokens, multiplier));
267         TokensSent(to, safeMul(tokens, multiplier));
268         ContributionReceived(to, value);
269         Transfer(owner, to, safeMul(tokens, multiplier));
270     }
271 
272     /**
273      * Run mass transfers with pre-ico *2 bonus
274      */
275     function proceedPreIcoTransactions(address[] toArray, uint[] valueArray) onlyOwner() {
276         uint tokens = 0;
277         address to = 0x0;
278         uint value = 0;
279 
280         for (uint i = 0; i < toArray.length; i++) {
281             to = toArray[i];
282             value = valueArray[i];
283             tokens = value / price();
284             tokens = tokens + tokens;
285             balances[to] = safeAdd(balances[to], safeMul(tokens, multiplier));
286             balances[owner] = safeSub(balances[owner], safeMul(tokens, multiplier));
287             preIcoSold = safeAdd(preIcoSold, tokens);
288             sendEvents(to, value, tokens);
289         }
290     }
291 
292     /**
293      * Emergency Stop ICO.
294      */
295     function halt() onlyOwner() {
296         halted = true;
297     }
298 
299     function unHalt() onlyOwner() {
300         halted = false;
301     }
302 
303     /**
304      * Transfer team tokens to target address
305      */
306     function sendBounty(address _to, uint256 _value) onlyOwner() {
307         require(bounty > _value);
308 
309         bounty = safeSub(bounty, _value);
310         balances[_to] = safeAdd(balances[_to], safeMul(_value, multiplier));
311         // /* Emit log events */
312         TokensSent(_to, safeMul(_value, multiplier));
313         Transfer(owner, _to, safeMul(_value, multiplier));
314     }
315 
316     /**
317      * Transfer bounty to target address from bounty pool
318      */
319     function sendSupplyTokens(address _to, uint256 _value) onlyOwner() {
320         balances[owner] = safeSub(balances[owner], safeMul(_value, multiplier));
321         balances[_to] = safeAdd(balances[_to], safeMul(_value, multiplier));
322 
323         // /* Emit log events */
324         TokensSent(_to, safeMul(_value, multiplier));
325         Transfer(owner, _to, safeMul(_value, multiplier));
326     }
327 
328     /**
329      * ERC 20 Standard Token interface transfer function
330      *
331      * Prevent transfers until halt period is over.
332      */
333     function transfer(address _to, uint256 _value) isAvailable() returns (bool success) {
334         return super.transfer(_to, _value);
335     }
336 
337     /**
338      * ERC 20 Standard Token interface transfer function
339      *
340      * Prevent transfers until halt period is over.
341      */
342     function transferFrom(address _from, address _to, uint256 _value) isAvailable() returns (bool success) {
343         return super.transferFrom(_from, _to, _value);
344     }
345 
346     /**
347      * Burn all tokens from a balance.
348      */
349     function burnRemainingTokens() isAvailable() onlyOwner() {
350         Burn(owner, balances[owner]);
351         balances[owner] = 0;
352     }
353 
354     /**
355      * Set day first bonus
356      */
357     function setDayFirst() onlyOwner() {
358         isDayFirst = true;
359         isDaySecond = false;
360         isDayThird = false;
361     }
362 
363     /**
364      * Set day second bonus
365      */
366     function setDaySecond() onlyOwner() {
367         isDayFirst = false;
368         isDaySecond = true;
369         isDayThird = false;
370     }
371 
372     /**
373      * Set day first bonus
374      */
375     function setDayThird() onlyOwner() {
376         isDayFirst = false;
377         isDaySecond = false;
378         isDayThird = true;
379     }
380 
381     /**
382      * Set day first bonus
383      */
384     function setBonusOff() onlyOwner() {
385         isDayFirst = false;
386         isDaySecond = false;
387         isDayThird = false;
388     }
389 
390    /**
391     * Set pre-sale bonus
392     */
393    function setPreSaleOn() onlyOwner() {
394        isPreSale = true;
395    }
396 
397    /**
398     * Set pre-sale bonus off
399     */
400    function setPreSaleOff() onlyOwner() {
401        isPreSale = false;
402    }
403 
404     /**
405      * Start new investment round
406      */
407     function startNewRound() onlyOwner() {
408         require(roundCount < 5);
409         roundCount = roundCount + 1;
410 
411         balances[owner] = safeAdd(balances[owner], safeMul(icoCap, multiplier));
412     }
413 
414     modifier onlyOwner() {
415         require(msg.sender == owner);
416         _;
417     }
418 
419     modifier isAvailable() {
420         require(!halted && !freeze);
421         _;
422     }
423 
424     /**
425      * Just being sent some cash? Let's buy tokens
426      */
427     function() payable {
428         buy();
429     }
430 
431     /**
432      * Freeze and unfreeze ICO.
433      */
434     function freeze() onlyOwner() {
435          freeze = true;
436     }
437 
438      function unFreeze() onlyOwner() {
439          freeze = false;
440      }
441 
442     /**
443      * Replaces an owner
444      */
445     function changeOwner(address _to) onlyOwner() {
446         balances[_to] = balances[owner];
447         balances[owner] = 0;
448         owner = _to;
449     }
450 
451     /**
452      * Replaces a founder, transfer team pool to new founder balance
453      */
454     function changeFounder(address _to) onlyOwner() {
455         balances[_to] = balances[founder];
456         balances[founder] = 0;
457         founder = _to;
458     }
459 }