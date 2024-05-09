1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   function Ownable() {
64     owner = msg.sender;
65   }
66 
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) onlyOwner {
82     require(newOwner != address(0));      
83     owner = newOwner;
84   }
85 
86 }
87 
88 /*
89  * Haltable
90  *
91  * Abstract contract that allows children to implement an
92  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
93  *
94  *
95  * Originally envisioned in FirstBlood ICO contract.
96  */
97 contract Haltable is Ownable {
98   bool public halted;
99 
100   modifier stopInEmergency {
101     require (!halted);
102     _;
103   }
104 
105   modifier onlyInEmergency {
106     require (halted);
107     _;
108   }
109 
110   // called by the owner on emergency, triggers stopped state
111   function halt() external onlyOwner {
112     halted = true;
113   }
114 
115   // called by the owner on end of emergency, returns to normal state
116   function unhalt() external onlyOwner onlyInEmergency {
117     halted = false;
118   }
119 
120 }
121 
122 /**
123  * @title ERC20Basic
124  * @dev Simpler version of ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/179
126  */
127 contract ERC20Basic {
128   uint256 public totalSupply;
129   function balanceOf(address who) constant returns (uint256);
130   function transfer(address to, uint256 value) returns (bool);
131   event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address owner, address spender) constant returns (uint256);
141   function transferFrom(address from, address to, uint256 value) returns (bool);
142   function approve(address spender, uint256 value) returns (bool);
143   event Approval(address indexed owner, address indexed spender, uint256 value);
144 }
145 
146 
147 
148 /**
149  * @title Basic token
150  * @dev Basic version of StandardToken, with no allowances. 
151  */
152 contract BasicToken is ERC20Basic {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) balances;
156 
157   /**
158   * @dev transfer token for a specified address
159   * @param _to The address to transfer to.
160   * @param _value The amount to be transferred.
161   */
162   function transfer(address _to, uint256 _value) returns (bool) {
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of. 
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) constant returns (uint256 balance) {
175     return balances[_owner];
176   }
177 
178 }
179 
180 /**
181  * @title Standard ERC20 token
182  *
183  * @dev Implementation of the basic standard token.
184  * @dev https://github.com/ethereum/EIPs/issues/20
185  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  */
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) allowed;
190 
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amout of tokens to be transfered
197    */
198   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
199     var _allowance = allowed[_from][msg.sender];
200 
201     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
202     // require (_value <= _allowance);
203 
204     balances[_to] = balances[_to].add(_value);
205     balances[_from] = balances[_from].sub(_value);
206     allowed[_from][msg.sender] = _allowance.sub(_value);
207     Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    * @param _spender The address which will spend the funds.
214    * @param _value The amount of tokens to be spent.
215    */
216   function approve(address _spender, uint256 _value) returns (bool) {
217 
218     // To change the approve amount you first have to reduce the addresses`
219     //  allowance to zero by calling `approve(_spender, 0)` if it is not
220     //  already 0 to mitigate the race condition described here:
221     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
223 
224     allowed[msg.sender][_spender] = _value;
225     Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    * @return A uint256 specifing the amount of tokens still available for the spender.
234    */
235   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
236     return allowed[_owner][_spender];
237   }
238 
239 }
240 
241 /**
242  * @title SimpleToken
243  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator. 
244  * Note they can later distribute these tokens as they wish using `transfer` and other
245  * `StandardToken` functions.
246  */
247 contract AhooleeToken is StandardToken {
248 
249   string public name = "Ahoolee Token";
250   string public symbol = "AHT";
251   uint256 public decimals = 18;
252   uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
253 
254   /**
255    * @dev Contructor that gives msg.sender all of existing tokens. 
256    */
257   function AhooleeToken() {
258     totalSupply = INITIAL_SUPPLY;
259     balances[msg.sender] = INITIAL_SUPPLY;
260   }
261 
262 }
263 
264 
265 contract AhooleeTokenSale is Haltable {
266     using SafeMath for uint;
267 
268     string public name = "Ahoolee Token Sale";
269 
270     AhooleeToken public token;
271     address public beneficiary;
272 
273     uint public hardCapLow;
274     uint public hardCapHigh;
275     uint public softCap;
276     uint public hardCapLowUsd;
277     uint public hardCapHighUsd;
278     uint public softCapUsd;
279     uint public collected;
280     uint public priceETH;
281     
282     uint public investorCount = 0;
283     uint public weiRefunded = 0;
284 
285     uint public startTime;
286     uint public endTime;
287 
288     bool public softCapReached = false;
289     bool public crowdsaleFinished = false;
290     
291     uint constant HARD_CAP_TOKENS = 25000000;
292 
293     mapping (address => bool) refunded;
294     mapping (address => uint256) saleBalances ;  
295     mapping (address => bool) claimed;   
296 
297     event GoalReached(uint amountRaised);
298     event SoftCapReached(uint softCap);
299     event NewContribution(address indexed holder, uint256 etherAmount);
300     event Refunded(address indexed holder, uint256 amount);
301     event LogClaim(address indexed holder, uint256 amount, uint price);
302 
303     modifier onlyAfter(uint time) {
304         require (now > time);
305         _;
306     }
307 
308     modifier onlyBefore(uint time) {
309         require (now < time);
310         _;
311     }
312 
313     function AhooleeTokenSale(
314         uint _hardCapLowUSD,
315         uint _hardCapHighUSD,
316         uint _softCapUSD,
317         address _token,
318         address _beneficiary,
319         uint _priceETH,
320 
321         uint _startTime,
322         uint _durationHours
323     ) {
324         priceETH = _priceETH;
325         hardCapLowUsd = _hardCapLowUSD;
326         hardCapHighUsd = _hardCapHighUSD;
327         softCapUsd = _softCapUSD;
328         
329         calculatePrice();
330         
331         token = AhooleeToken(_token);
332         beneficiary = _beneficiary;
333 
334         startTime = _startTime;
335         endTime = _startTime + _durationHours * 1 hours;
336     }
337 
338     function calculatePrice() internal{
339         hardCapLow = hardCapLowUsd  * 1 ether / priceETH;
340         hardCapHigh = hardCapHighUsd  * 1 ether / priceETH;
341         softCap = softCapUsd * 1 ether / priceETH;
342     }
343 
344     function setEthPrice(uint _priceETH) onlyBefore(startTime) onlyOwner {
345         priceETH = _priceETH;
346         calculatePrice();
347     }
348 
349     function () payable stopInEmergency{
350         assert (msg.value > 0.01 * 1 ether || msg.value == 0);
351         if(msg.value > 0.01 * 1 ether) doPurchase(msg.sender);
352     }
353 
354     function saleBalanceOf(address _owner) constant returns (uint256) {
355       return saleBalances[_owner];
356     }
357 
358     function claimedOf(address _owner) constant returns (bool) {
359       return claimed[_owner];
360     }
361 
362     function doPurchase(address _owner) private onlyAfter(startTime) onlyBefore(endTime) {
363         
364         require(crowdsaleFinished == false);
365 
366         require (collected.add(msg.value) <= hardCapHigh);
367 
368         if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {
369             softCapReached = true;
370             SoftCapReached(softCap);
371         }
372 
373         if (saleBalances[msg.sender] == 0) investorCount++;
374       
375         collected = collected.add(msg.value);
376 
377         saleBalances[msg.sender] = saleBalances[msg.sender].add(msg.value);
378 
379         NewContribution(_owner, msg.value);
380 
381         if (collected == hardCapHigh) {
382             GoalReached(hardCapHigh);
383         }
384     }
385 
386     function claim() {
387         require (crowdsaleFinished);
388         require (!claimed[msg.sender]);
389         
390         uint price = HARD_CAP_TOKENS * 1 ether / hardCapLow;
391         if(collected > hardCapLow){
392           price = HARD_CAP_TOKENS * 1 ether / collected; 
393         } 
394         uint tokens = saleBalances[msg.sender] * price;
395 
396         require(token.transfer(msg.sender, tokens));
397         claimed[msg.sender] = true;
398         LogClaim(msg.sender, tokens, price);
399     }
400 
401     function returnTokens() onlyOwner {
402         require (crowdsaleFinished);
403 
404         uint tokenAmount = token.balanceOf(this);
405         if(collected < hardCapLow){
406           tokenAmount = (hardCapLow - collected) * HARD_CAP_TOKENS * 1 ether / hardCapLow;
407         } 
408         require (token.transfer(beneficiary, tokenAmount));
409     }
410 
411     function withdraw() onlyOwner {
412         require (softCapReached);
413         require (beneficiary.send(collected));
414         crowdsaleFinished = true;
415     }
416 
417     function refund() public onlyAfter(endTime) {
418         require (!softCapReached);
419         require (!refunded[msg.sender]);
420         require (saleBalances[msg.sender] != 0) ;
421 
422         uint refund = saleBalances[msg.sender];
423         require (msg.sender.send(refund));
424         refunded[msg.sender] = true;
425         weiRefunded = weiRefunded.add(refund);
426         Refunded(msg.sender, refund);
427     }
428 
429 }