1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 /**
73  * @title Pausable
74  * @dev Base contract which allows children to implement an emergency stop mechanism.
75  */
76 contract Pausable is Ownable {
77   event Pause();
78   event Unpause();
79 
80   bool public paused = false;
81 
82 
83   /**
84    * @dev modifier to allow actions only when the contract IS paused
85    */
86   modifier whenNotPaused() {
87     require(!paused);
88     _;
89   }
90 
91   /**
92    * @dev modifier to allow actions only when the contract IS NOT paused
93    */
94   modifier whenPaused {
95     require(paused);
96     _;
97   }
98 
99   /**
100    * @dev called by the owner to pause, triggers stopped state
101    */
102   function pause() onlyOwner whenNotPaused returns (bool) {
103     paused = true;
104     Pause();
105     return true;
106   }
107 
108   /**
109    * @dev called by the owner to unpause, returns to normal state
110    */
111   function unpause() onlyOwner whenPaused returns (bool) {
112     paused = false;
113     Unpause();
114     return true;
115   }
116 }
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   uint256 public totalSupply;
125   function balanceOf(address who) constant returns (uint256);
126   function transfer(address to, uint256 value) returns (bool);
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances. 
133  */
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) returns (bool) {
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     Transfer(msg.sender, _to, _value);
148     return true;
149   }
150 
151   /**
152   * @dev Gets the balance of the specified address.
153   * @param _owner The address to query the the balance of. 
154   * @return An uint256 representing the amount owned by the passed address.
155   */
156   function balanceOf(address _owner) constant returns (uint256 balance) {
157     return balances[_owner];
158   }
159 
160 }
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/20
165  */
166 contract ERC20 is ERC20Basic {
167   function allowance(address owner, address spender) constant returns (uint256);
168   function transferFrom(address from, address to, uint256 value) returns (bool);
169   function approve(address spender, uint256 value) returns (bool);
170   event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 /**
174  * @title Standard ERC20 token
175  *
176  * @dev Implementation of the basic standard token.
177  * @dev https://github.com/ethereum/EIPs/issues/20
178  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
179  */
180 contract StandardToken is ERC20, BasicToken {
181 
182   mapping (address => mapping (address => uint256)) allowed;
183 
184 
185   /**
186    * @dev Transfer tokens from one address to another
187    * @param _from address The address which you want to send tokens from
188    * @param _to address The address which you want to transfer to
189    * @param _value uint256 the amout of tokens to be transfered
190    */
191   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
192     var _allowance = allowed[_from][msg.sender];
193 
194     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
195     // require (_value <= _allowance);
196 
197     balances[_to] = balances[_to].add(_value);
198     balances[_from] = balances[_from].sub(_value);
199     allowed[_from][msg.sender] = _allowance.sub(_value);
200     Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) returns (bool) {
210 
211     // To change the approve amount you first have to reduce the addresses`
212     //  allowance to zero by calling `approve(_spender, 0)` if it is not
213     //  already 0 to mitigate the race condition described here:
214     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
216 
217     allowed[msg.sender][_spender] = _value;
218     Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens that an owner allowed to a spender.
224    * @param _owner address The address which owns the funds.
225    * @param _spender address The address which will spend the funds.
226    * @return A uint256 specifing the amount of tokens still avaible for the spender.
227    */
228   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
229     return allowed[_owner][_spender];
230   }
231 
232 }
233 
234 /**
235  * @title HoQuToken
236  * @dev HoQu.io token contract.
237  */
238 contract HoQuToken is StandardToken, Pausable {
239     
240     string public constant name = "HOQU Token";
241     string public constant symbol = "HQX";
242     uint32 public constant decimals = 18;
243     
244     /**
245      * @dev Give all tokens to msg.sender.
246      */
247     function HoQuToken(uint _totalSupply) {
248         require (_totalSupply > 0);
249         totalSupply = balances[msg.sender] = _totalSupply;
250     }
251 
252     function transfer(address _to, uint _value) whenNotPaused returns (bool) {
253         return super.transfer(_to, _value);
254     }
255 
256     function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
257         return super.transferFrom(_from, _to, _value);
258     }
259 }
260 
261 /**
262  * @title BaseCrowdSale
263  * @title HoQu.io base crowdsale contract for managing a token crowdsale.
264  */
265 contract BaseCrowdsale is Pausable {
266     using SafeMath for uint256;
267 
268     // all accepted ethers go to this address
269     address beneficiaryAddress;
270 
271     // all remain tokens after ICO should go to that address
272     address public bankAddress;
273 
274     // token instance
275     HoQuToken public token;
276 
277     uint256 public maxTokensAmount;
278     uint256 public issuedTokensAmount = 0;
279     uint256 public minBuyableAmount;
280     uint256 public tokenRate; // amount of HQX per 1 ETH
281     
282     uint256 endDate;
283 
284     bool public isFinished = false;
285 
286     /**
287     * Event for token purchase logging
288     * @param buyer who paid for the tokens
289     * @param tokens amount of tokens purchased
290     * @param amount ethers paid for purchase
291     */
292     event TokenBought(address indexed buyer, uint256 tokens, uint256 amount);
293 
294     modifier inProgress() {
295         require (!isFinished);
296         require (issuedTokensAmount < maxTokensAmount);
297         require (now <= endDate);
298         _;
299     }
300     
301     /**
302     * @param _tokenAddress address of a HQX token contract
303     * @param _bankAddress address for remain HQX tokens accumulation
304     * @param _beneficiaryAddress accepted ETH go to this address
305     * @param _tokenRate rate HQX per 1 ETH
306     * @param _minBuyableAmount min ETH per each buy action (in ETH)
307     * @param _maxTokensAmount ICO HQX capacity (in HQX)
308     * @param _endDate the date when ICO will expire
309     */
310     function BaseCrowdsale(
311         address _tokenAddress,
312         address _bankAddress,
313         address _beneficiaryAddress,
314         uint256 _tokenRate,
315         uint256 _minBuyableAmount,
316         uint256 _maxTokensAmount,
317         uint256 _endDate
318     ) {
319         token = HoQuToken(_tokenAddress);
320 
321         bankAddress = _bankAddress;
322         beneficiaryAddress = _beneficiaryAddress;
323 
324         tokenRate = _tokenRate;
325         minBuyableAmount = _minBuyableAmount.mul(1 ether);
326         maxTokensAmount = _maxTokensAmount.mul(1 ether);
327     
328         endDate = _endDate;
329     }
330 
331     /*
332      * @dev Set new HoQu token exchange rate.
333      */
334     function setTokenRate(uint256 _tokenRate) onlyOwner inProgress {
335         require (_tokenRate > 0);
336         tokenRate = _tokenRate;
337     }
338 
339     /*
340      * @dev Set new minimum buyable amount in ethers.
341      */
342     function setMinBuyableAmount(uint256 _minBuyableAmount) onlyOwner inProgress {
343         require (_minBuyableAmount > 0);
344         minBuyableAmount = _minBuyableAmount.mul(1 ether);
345     }
346 
347     /**
348      * Buy HQX. Check minBuyableAmount and tokenRate.
349      * @dev Performs actual token sale process. Sends all ethers to beneficiary.
350      */
351     function buyTokens() payable inProgress whenNotPaused {
352         require (msg.value >= minBuyableAmount);
353     
354         uint256 payAmount = msg.value;
355         uint256 returnAmount = 0;
356 
357         // calculate token amount to be transfered to investor
358         uint256 tokens = tokenRate.mul(payAmount);
359     
360         if (issuedTokensAmount + tokens > maxTokensAmount) {
361             tokens = maxTokensAmount.sub(issuedTokensAmount);
362             payAmount = tokens.div(tokenRate);
363             returnAmount = msg.value.sub(payAmount);
364         }
365     
366         issuedTokensAmount = issuedTokensAmount.add(tokens);
367         require (issuedTokensAmount <= maxTokensAmount);
368 
369         // send token to investor
370         token.transfer(msg.sender, tokens);
371         // notify listeners on token purchase
372         TokenBought(msg.sender, tokens, payAmount);
373 
374         // send ethers to special address
375         beneficiaryAddress.transfer(payAmount);
376     
377         if (returnAmount > 0) {
378             msg.sender.transfer(returnAmount);
379         }
380     }
381 
382     /**
383      * Trigger emergency token pause.
384      */
385     function pauseToken() onlyOwner returns (bool) {
386         require(!token.paused());
387         token.pause();
388         return true;
389     }
390 
391     /**
392      * Unpause token.
393      */
394     function unpauseToken() onlyOwner returns (bool) {
395         require(token.paused());
396         token.unpause();
397         return true;
398     }
399     
400     /**
401      * Finish ICO.
402      */
403     function finish() onlyOwner {
404         require (issuedTokensAmount >= maxTokensAmount || now > endDate);
405         require (!isFinished);
406         isFinished = true;
407         token.transfer(bankAddress, token.balanceOf(this));
408     }
409     
410     /**
411      * Buy HQX. Check minBuyableAmount and tokenRate.
412      */
413     function() external payable {
414         buyTokens();
415     }
416 }
417 
418 /**
419  * @title PrivatePlacement
420  * @dev HoQu.io Private Token Placement contract
421  */
422 contract PrivatePlacement is BaseCrowdsale {
423 
424     // internal addresses for HoQu tokens allocation
425     address public foundersAddress;
426     address public supportAddress;
427     address public bountyAddress;
428 
429     // initial amount distribution values
430     uint256 public constant totalSupply = 888888000 ether;
431     uint256 public constant initialFoundersAmount = 266666400 ether;
432     uint256 public constant initialSupportAmount = 8888880 ether;
433     uint256 public constant initialBountyAmount = 35555520 ether;
434 
435     // whether initial token allocations was performed or not
436     bool allocatedInternalWallets = false;
437     
438     /**
439     * @param _bankAddress address for remain HQX tokens accumulation
440     * @param _foundersAddress founders address
441     * @param _supportAddress support address
442     * @param _bountyAddress bounty address
443     * @param _beneficiaryAddress accepted ETH go to this address
444     */
445     function PrivatePlacement(
446         address _bankAddress,
447         address _foundersAddress,
448         address _supportAddress,
449         address _bountyAddress,
450         address _beneficiaryAddress
451     ) BaseCrowdsale(
452         createToken(totalSupply),
453         _bankAddress,
454         _beneficiaryAddress,
455         10000, /* rate HQX per 1 ETH (includes 100% private placement bonus) */
456         100, /* min amount in ETH */
457         23111088, /* cap in HQX */
458         1507939200 /* end 10/14/2017 @ 12:00am (UTC) */
459     ) {
460         foundersAddress = _foundersAddress;
461         supportAddress = _supportAddress;
462         bountyAddress = _bountyAddress;
463     }
464 
465     /*
466      * @dev Perform initial token allocation between founders' addresses.
467      * Is only executed once after presale contract deployment and is invoked manually.
468      */
469     function allocateInternalWallets() onlyOwner {
470         require (!allocatedInternalWallets);
471 
472         allocatedInternalWallets = true;
473 
474         token.transfer(foundersAddress, initialFoundersAmount);
475         token.transfer(supportAddress, initialSupportAmount);
476         token.transfer(bountyAddress, initialBountyAmount);
477     }
478     
479     /*
480      * @dev HoQu Token factory.
481      */
482     function createToken(uint256 _totalSupply) internal returns (HoQuToken) {
483         return new HoQuToken(_totalSupply);
484     }
485 }