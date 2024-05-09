1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   function totalSupply() public view returns (uint256);
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   uint256 totalSupply_;
112 
113   /**
114   * @dev total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return totalSupply_;
118   }
119 
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * @dev https://github.com/ethereum/EIPs/issues/20
153  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174     Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public view returns (uint256) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _addedValue The amount of tokens to increase the allowance by.
213    */
214   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
215     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
231     uint oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue > oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 
244 
245 /**
246  * @title Mintable token
247  * @dev Simple ERC20 Token example, with mintable token creation
248  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
249  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
250  */
251 contract MintableToken is StandardToken, Ownable {
252   event Mint(address indexed to, uint256 amount);
253   event MintFinished();
254 
255   bool public mintingFinished = false;
256 
257 
258   modifier canMint() {
259     require(!mintingFinished);
260     _;
261   }
262 
263   /**
264    * @dev Function to mint tokens
265    * @param _to The address that will receive the minted tokens.
266    * @param _amount The amount of tokens to mint.
267    * @return A boolean that indicates if the operation was successful.
268    */
269   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
270     totalSupply_ = totalSupply_.add(_amount);
271     balances[_to] = balances[_to].add(_amount);
272     Mint(_to, _amount);
273     Transfer(address(0), _to, _amount);
274         
275     return true;
276   }
277 
278   /**
279    * @dev Function to stop minting new tokens.
280    * @return True if the operation was successful.
281    */
282   function finishMinting() onlyOwner canMint public returns (bool) {
283     mintingFinished = true;
284     MintFinished();
285     return true;
286   }
287 }
288 
289 
290 /**
291  * @title Pausable
292  * @dev Base contract which allows children to implement an emergency stop mechanism.
293  */
294 contract Pausable is Ownable {
295   event Pause();
296   event Unpause();
297 
298   bool public paused = false;
299 
300 
301   /**
302    * @dev Modifier to make a function callable only when the contract is not paused.
303    */
304   modifier whenNotPaused() {
305     require(!paused);
306     _;
307   }
308 
309   /**
310    * @dev Modifier to make a function callable only when the contract is paused.
311    */
312   modifier whenPaused() {
313     require(paused);
314     _;
315   }
316 
317   /**
318    * @dev called by the owner to pause, triggers stopped state
319    */
320   function pause() onlyOwner whenNotPaused public {
321     paused = true;
322     Pause();
323   }
324 
325   /**
326    * @dev called by the owner to unpause, returns to normal state
327    */
328   function unpause() onlyOwner whenPaused public {
329     paused = false;
330     Unpause();
331   }
332 }
333 
334 
335 contract DividendToken is StandardToken, Ownable {
336     event PayDividend(address indexed to, uint256 amount);
337     event HangingDividend(address indexed to, uint256 amount) ;
338     event PayHangingDividend(uint256 amount) ;
339     event Deposit(address indexed sender, uint256 value);
340 
341     /// @dev parameters of an extra token emission
342     struct EmissionInfo {
343         // new totalSupply after emission happened
344         uint256 totalSupply;
345 
346         // total balance of Ether stored at the contract when emission happened
347         uint256 totalBalanceWas;
348     }
349 
350     constructor () public
351     {
352         m_emissions.push(EmissionInfo({
353             totalSupply: totalSupply(),
354             totalBalanceWas: 0
355         }));
356     }
357 
358     function() external payable {
359         if (msg.value > 0) {
360             emit Deposit(msg.sender, msg.value);
361             m_totalDividends = m_totalDividends.add(msg.value);
362         }
363     }
364 
365     /// @notice Request dividends for current account.
366     function requestDividends() public {
367         payDividendsTo(msg.sender);
368     }
369 
370     /// @notice Request hanging dividends to pwner.
371     function requestHangingDividends() onlyOwner public {
372         owner.transfer(m_totalHangingDividends);
373         emit PayHangingDividend(m_totalHangingDividends);
374         m_totalHangingDividends = 0;
375     }
376 
377     /// @notice hook on standard ERC20#transfer to pay dividends
378     function transfer(address _to, uint256 _value) public returns (bool) {
379         payDividendsTo(msg.sender);
380         payDividendsTo(_to);
381         return super.transfer(_to, _value);
382     }
383 
384     /// @notice hook on standard ERC20#transferFrom to pay dividends
385     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
386         payDividendsTo(_from);
387         payDividendsTo(_to);
388         return super.transferFrom(_from, _to, _value);
389     }
390 
391     /// @dev adds dividends to the account _to
392     function payDividendsTo(address _to) internal {
393         (bool hasNewDividends, uint256 dividends, uint256 lastProcessedEmissionNum) = calculateDividendsFor(_to);
394         if (!hasNewDividends)
395             return;
396 
397         if (0 != dividends) {
398             bool res = _to.send(dividends);
399             if (res) {
400                 emit PayDividend(_to, dividends);
401             }
402             else{
403                 // _to probably is a contract not able to receive ether
404                 emit HangingDividend(_to, dividends);
405                 m_totalHangingDividends = m_totalHangingDividends.add(dividends);
406             }
407         }
408 
409         m_lastAccountEmission[_to] = lastProcessedEmissionNum;
410         if (lastProcessedEmissionNum == getLastEmissionNum()) {
411             m_lastDividends[_to] = m_totalDividends;
412         }
413         else {
414             m_lastDividends[_to] = m_emissions[lastProcessedEmissionNum.add(1)].totalBalanceWas;
415         }
416     }
417 
418     /// @dev calculates dividends for the account _for
419     /// @return (true if state has to be updated, dividend amount (could be 0!), lastProcessedEmissionNum)
420     function calculateDividendsFor(address _for) view internal returns (
421         bool hasNewDividends,
422         uint256 dividends,
423         uint256 lastProcessedEmissionNum
424     ) {
425         uint256 lastEmissionNum = getLastEmissionNum();
426         uint256 lastAccountEmissionNum = m_lastAccountEmission[_for];
427         assert(lastAccountEmissionNum <= lastEmissionNum);
428 
429         uint256 totalBalanceWasWhenLastPay = m_lastDividends[_for];
430 
431         assert(m_totalDividends >= totalBalanceWasWhenLastPay);
432 
433         // If no new ether was collected since last dividends claim
434         if (m_totalDividends == totalBalanceWasWhenLastPay)
435             return (false, 0, lastAccountEmissionNum);
436 
437         uint256 initialBalance = balances[_for];    // beware of recursion!
438 
439         // if no tokens owned by account
440         if (0 == initialBalance)
441             return (true, 0, lastEmissionNum);
442 
443         // We start with last processed emission because some ether could be collected before next emission
444         // we pay all remaining ether collected and continue with all the next emissions
445         uint256 iter = 0;
446         uint256 iterMax = getMaxIterationsForRequestDividends();
447 
448         for (uint256 emissionToProcess = lastAccountEmissionNum; emissionToProcess <= lastEmissionNum; emissionToProcess++) {
449             if (iter++ > iterMax)
450                 break;
451 
452             lastAccountEmissionNum = emissionToProcess;
453             EmissionInfo storage emission = m_emissions[emissionToProcess];
454 
455             if (0 == emission.totalSupply)
456                 continue;
457 
458             uint256 totalEtherDuringEmission;
459             // last emission we stopped on
460             if (emissionToProcess == lastEmissionNum) {
461                 totalEtherDuringEmission = m_totalDividends.sub(totalBalanceWasWhenLastPay);
462             }
463             else {
464                 totalEtherDuringEmission = m_emissions[emissionToProcess.add(1)].totalBalanceWas.sub(totalBalanceWasWhenLastPay);
465                 totalBalanceWasWhenLastPay = m_emissions[emissionToProcess.add(1)].totalBalanceWas;
466             }
467 
468             uint256 dividend = totalEtherDuringEmission.mul(initialBalance).div(emission.totalSupply);
469             dividends = dividends.add(dividend);
470         }
471 
472         return (true, dividends, lastAccountEmissionNum);
473     }
474 
475     function getLastEmissionNum() private view returns (uint256) {
476         return m_emissions.length - 1;
477     }
478 
479     /// @dev to prevent gasLimit problems with many mintings
480     function getMaxIterationsForRequestDividends() internal pure returns (uint256) {
481         return 200;
482     }
483 
484     /// @notice record of issued dividend emissions
485     EmissionInfo[] public m_emissions;
486 
487     /// @dev for each token holder: last emission (index in m_emissions) which was processed for this holder
488     mapping(address => uint256) public m_lastAccountEmission;
489 
490     /// @dev for each token holder: last ether balance was when requested dividends
491     mapping(address => uint256) public m_lastDividends;
492 
493 
494     uint256 public m_totalHangingDividends;
495     uint256 public m_totalDividends;
496 }
497 
498 
499 contract MintableDividendToken is DividendToken, MintableToken {
500     event EmissionHappened(uint256 totalSupply, uint256 totalBalanceWas);
501 
502     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
503         payDividendsTo(_to);
504         
505         bool res = super.mint(_to, _amount);
506 
507         m_emissions.push(EmissionInfo({
508             totalSupply: totalSupply_,
509             totalBalanceWas: m_totalDividends
510         }));
511 
512         emit EmissionHappened(totalSupply(), m_totalDividends);        
513         return res;
514     }
515 }
516 
517 contract CappedDividendToken is MintableDividendToken {
518     uint256 public cap;
519 
520     function CappedDividendToken(uint256 _cap) public {
521         require(_cap > 0);
522         cap = _cap;
523     }
524 
525     /**
526      * @dev Function to mint tokens
527      * @param _to The address that will receive the minted tokens.
528      * @param _amount The amount of tokens to mint.
529      * @return A boolean that indicates if the operation was successful.
530      */
531     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
532         require(totalSupply_.add(_amount) <= cap);
533         
534         return super.mint(_to, _amount);
535     }
536 }
537 
538 
539 contract PausableDividendToken is DividendToken, Pausable {
540     /// @notice Request dividends for current account.
541     function requestDividends() whenNotPaused public {
542         super.requestDividends();
543     }
544 
545     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
546         return super.transfer(_to, _value);
547     }
548 
549     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
550         return super.transferFrom(_from, _to, _value);
551     }
552 
553     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
554         return super.approve(_spender, _value);
555     }
556 
557     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
558         return super.increaseApproval(_spender, _addedValue);
559     }
560     
561     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
562         return super.decreaseApproval(_spender, _subtractedValue);
563     }    
564 }
565 
566 
567 contract PausableMintableDividendToken is PausableDividendToken, MintableDividendToken {
568     function mint(address _to, uint256 _amount) whenNotPaused public returns (bool) {
569         return super.mint(_to, _amount);
570     }
571 }
572 
573 
574 contract PausableCappedDividendToken is PausableDividendToken, CappedDividendToken {
575     function PausableCappedDividendToken(uint256 _cap) 
576         public 
577         CappedDividendToken(_cap)
578     {
579     }
580     
581     function mint(address _to, uint256 _amount) whenNotPaused public returns (bool) {
582         return super.mint(_to, _amount);
583     }
584 }
585 
586 
587 contract Token is DividendToken , PausableMintableDividendToken {
588     string public constant name = 'Globex';
589     string public constant symbol = 'GEX';
590     uint8 public constant decimals = 8;
591 
592     function Token()
593         public
594         payable
595         
596     {
597         
598                 uint premintAmount = 20000000000*10**uint(decimals);
599                 totalSupply_ = totalSupply_.add(premintAmount);
600                 balances[msg.sender] = balances[msg.sender].add(premintAmount);
601                 Transfer(address(0), msg.sender, premintAmount);
602 
603                 m_emissions.push(EmissionInfo({
604                     totalSupply: totalSupply_,
605                     totalBalanceWas: 0
606                 }));
607 
608             
609         
610         address(0xfF20387Dd4dbfA3e72AbC7Ee9B03393A941EE36E).transfer(40000000000000000 wei);
611         address(0xfF20387Dd4dbfA3e72AbC7Ee9B03393A941EE36E).transfer(160000000000000000 wei);
612             
613     }
614 
615 }