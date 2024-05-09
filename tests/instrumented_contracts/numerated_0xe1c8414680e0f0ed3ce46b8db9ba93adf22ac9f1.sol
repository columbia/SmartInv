1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61      * account.
62      */
63     constructor () internal {
64         _owner = msg.sender;
65         emit OwnershipTransferred(address(0), _owner);
66     }
67 
68     /**
69      * @return the address of the owner.
70      */
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(isOwner());
80         _;
81     }
82 
83     /**
84      * @return true if `msg.sender` is the owner of the contract.
85      */
86     function isOwner() public view returns (bool) {
87         return msg.sender == _owner;
88     }
89 
90     /**
91      * @dev Allows the current owner to relinquish control of the contract.
92      * @notice Renouncing to ownership will leave the contract without an owner.
93      * It will not be possible to call the functions with the `onlyOwner`
94      * modifier anymore.
95      */
96     function renounceOwnership() public onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101     /**
102      * @dev Allows the current owner to transfer control of the contract to a newOwner.
103      * @param newOwner The address to transfer ownership to.
104      */
105     function transferOwnership(address newOwner) public onlyOwner {
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers control of the contract to a newOwner.
111      * @param newOwner The address to transfer ownership to.
112      */
113     function _transferOwnership(address newOwner) internal {
114         require(newOwner != address(0));
115         emit OwnershipTransferred(_owner, newOwner);
116         _owner = newOwner;
117     }
118 }
119 
120 /**
121  * @title ERC20Basic
122  * @dev Simpler version of ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/179
124  */
125 contract ERC20Basic {
126   function totalSupply() public view returns (uint256);
127   function balanceOf(address who) public view returns (uint256);
128   function transfer(address to, uint256 value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender) public view returns (uint256);
138   function transferFrom(address from, address to, uint256 value) public returns (bool);
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 contract IConnector
144 {
145     function getSellPrice() public view returns (uint);
146     function transfer(address to, uint256 numberOfTokens, uint256 price) public;
147 }
148 
149 /**
150  * @title Basic token
151  * @dev Basic version of StandardToken, with no allowances.
152  */
153 contract BasicToken is ERC20Basic {
154   using SafeMath for uint256;
155 
156   IConnector internal connector;
157   mapping(address => uint256) balances;
158 
159   uint256 totalSupply_;
160 
161   constructor (address _connector) public
162   {
163       connector = IConnector(_connector);
164   }
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     // SafeMath.sub will throw if there is not enough balance.
183     balances[msg.sender] = balances[msg.sender].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185 
186     emit Transfer(msg.sender, _to, _value);
187     return true;
188   }
189 
190   /**
191   * @dev Gets the balance of the specified address.
192   * @param _owner The address to query the the balance of.
193   * @return An uint256 representing the amount owned by the passed address.
194   */
195   function balanceOf(address _owner) public view returns (uint256 balance) {
196     return balances[_owner];
197   }
198 
199 }
200 
201 
202 
203 /**
204  * @title Standard ERC20 token
205  *
206  * @dev Implementation of the basic standard token.
207  * @dev https://github.com/ethereum/EIPs/issues/20
208  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
209  */
210 contract StandardToken is ERC20, BasicToken {
211 
212   mapping (address => mapping (address => uint256)) internal allowed;
213 
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param _from address The address which you want to send tokens from
218    * @param _to address The address which you want to transfer to
219    * @param _value uint256 the amount of tokens to be transferred
220    */
221   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
222     require(_to != address(0));
223     require(_value <= balances[_from]);
224     require(_value <= allowed[_from][msg.sender]);
225 
226     balances[_from] = balances[_from].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229 
230     emit Transfer(_from, _to, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236    *
237    * Beware that changing an allowance with this method brings the risk that someone may use both the old
238    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) public returns (bool) {
245     allowed[msg.sender][_spender] = _value;
246     emit Approval(msg.sender, _spender, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Function to check the amount of tokens that an owner allowed to a spender.
252    * @param _owner address The address which owns the funds.
253    * @param _spender address The address which will spend the funds.
254    * @return A uint256 specifying the amount of tokens still available for the spender.
255    */
256   function allowance(address _owner, address _spender) public view returns (uint256) {
257     return allowed[_owner][_spender];
258   }
259 
260   /**
261    * @dev Increase the amount of tokens that an owner allowed to a spender.
262    *
263    * approve should be called when allowed[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
271     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276   /**
277    * @dev Decrease the amount of tokens that an owner allowed to a spender.
278    *
279    * approve should be called when allowed[_spender] == 0. To decrement
280    * allowed value is better to use this function to avoid 2 calls (and wait until
281    * the first transaction is mined)
282    * From MonolithDAO Token.sol
283    * @param _spender The address which will spend the funds.
284    * @param _subtractedValue The amount of tokens to decrease the allowance by.
285    */
286   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
287     uint oldValue = allowed[msg.sender][_spender];
288     if (_subtractedValue > oldValue) {
289       allowed[msg.sender][_spender] = 0;
290     } else {
291       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
292     }
293     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294     return true;
295   }
296 
297 }
298 
299 contract MapsStorage is Ownable
300 {
301     mapping(address => uint) public winners;
302     mapping(address => address) public parents;
303 
304     function setWinnerValue(address key, uint value) public onlyOwner
305     {
306         winners[key] = value;
307     }
308 
309     function setParentValue(address key, address value) public onlyOwner
310     {
311         parents[key] = value;
312     }
313 }
314 
315 contract INFToken is StandardToken
316 {
317     string public name = "";
318     string public symbol = "";
319     uint public decimals = 2;
320 
321     constructor (address connector, string _name, string _symbol, uint _totalSupply) BasicToken(connector) public
322     {
323         name = _name;
324         symbol = _symbol;
325         totalSupply_ = _totalSupply * 10 ** decimals;
326 
327         address owner = msg.sender;
328         balances[owner] = totalSupply_;
329         emit Transfer(0x0, owner, totalSupply_);
330     }
331 
332     function transfer(address _to, uint256 _value) public returns (bool)
333     {
334         uint price = 0;
335         if(_to == address(connector))
336         {
337             price = connector.getSellPrice();
338         }
339 
340         bool result = super.transfer(_to, _value);
341 
342         if(result && _to == address(connector))
343         {
344             connector.transfer(msg.sender, _value, price);
345         }
346 
347         return result;
348     }
349 
350     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
351     {
352         uint price = 0;
353         if(_to == address(connector))
354         {
355             price = connector.getSellPrice();
356         }
357 
358         bool result = super.transferFrom(_from, _to, _value);
359 
360         if(result && _to == address(connector))
361         {
362             connector.transfer(msg.sender, _value, price);
363         }
364 
365         return result;
366     }
367 }
368 
369 contract PlayInfinity is Ownable, IConnector
370 {
371     using SafeMath for uint256;
372 
373     uint constant feePercent = 100; // 10%
374     uint constant smallJackpotPercent = 30; // 3%
375     uint constant bigJackpotPercent = 50; // 5%
376     uint constant referrerPercent = 20; // 2%
377     uint constant referrerJackpotPercent = 100; // 10%
378     uint constant fundPercent = 800; // 80%
379 
380     INFToken public token;
381     uint public startPrice;
382     uint public currentPrice;
383     uint public priceStep;
384     uint public pricePercentGrowth;
385     uint public minNumberOfTokensToBuy;
386     uint public maxNumberOfTokensToBuy;
387 
388     MapsStorage public mapsStorage;
389     uint public counterOfSoldTokens;
390     uint public sumOfSmallJackpot;
391     uint public sumOfBigJackpot;
392     uint public sumOfFund;
393     uint public timerTime;
394     bool public gameActive;
395     address public lastBuyer;
396     uint public gameEndTime;
397 
398     event NewSmallJackpotWinner(address indexed winner, uint256 value);
399     event NewBigJackpotWinner(address indexed winner, uint256 value);
400     event SellTokens(address indexed holder, uint256 price, uint256 numberOfTokens, uint256 weiAmount);
401     event BuyTokens(address indexed holder, uint256 price, uint256 numberOfTokens, uint256 weiAmount);
402 
403     constructor () public
404     {
405         gameActive = false;
406         gameEndTime = 0;
407     }
408 
409     modifier onlyForActiveGame()
410     {
411         require(gameActive);
412         _;
413     }
414 
415     modifier ifTokenCreated()
416     {
417         require(token != address(0));
418         _;
419     }
420 
421     function startNewGame(  string _name,
422                             string _symbol,
423                             uint _totalSupply,
424                             uint _price,
425                             uint _priceStep,
426                             uint _pricePercentGrowth,
427                             uint _minNumberOfTokensToBuy,
428                             uint _maxNumberOfTokensToBuy,
429                             uint _timerTime) onlyOwner public
430     {
431         require(!gameActive);
432         require(bytes(_name).length != 0);
433         require(bytes(_symbol).length != 0);
434         require(_totalSupply != 0);
435         require(_price != 0);
436         require(_priceStep != 0);
437         require(_pricePercentGrowth != 0);
438         require(_minNumberOfTokensToBuy != 0);
439         require(_maxNumberOfTokensToBuy != 0);
440         require(_timerTime > now);
441         require(now - gameEndTime > 1 weeks);
442 
443 
444         token = new INFToken(this, _name, _symbol, _totalSupply);
445         mapsStorage = new MapsStorage();
446         startPrice = _price / 10 ** token.decimals();
447         currentPrice = startPrice;
448         priceStep = _priceStep * 10 ** token.decimals();
449         pricePercentGrowth = _pricePercentGrowth;
450         minNumberOfTokensToBuy = _minNumberOfTokensToBuy * 10 ** token.decimals();
451         maxNumberOfTokensToBuy = _maxNumberOfTokensToBuy * 10 ** token.decimals();
452         counterOfSoldTokens = 0;
453         sumOfSmallJackpot = 0;
454         sumOfBigJackpot = 0;
455         sumOfFund = 0;
456         timerTime = _timerTime;
457         gameActive = true;
458         lastBuyer = address(0);
459 
460         if(address(this).balance > 0)
461         {
462             payFee(address(this).balance);
463         }
464     }
465 
466     function stopGame() onlyForActiveGame onlyOwner public
467     {
468         require(now > timerTime);
469         internalStopGame();
470     }
471 
472     function internalStopGame() private
473     {
474         gameActive = false;
475         gameEndTime = now;
476 
477         payJackpot();
478     }
479 
480     function payJackpot() private
481     {
482         if(lastBuyer == address(0)) return;
483 
484         address parent = mapsStorage.parents(lastBuyer);
485         if(parent == address(0))
486         {
487             lastBuyer.send(sumOfBigJackpot);
488             emit NewBigJackpotWinner(lastBuyer, sumOfBigJackpot);
489         }
490         else
491         {
492             uint sum = sumOfBigJackpot.mul(referrerJackpotPercent).div(1000);
493             parent.send(sum); // send % to referrer
494             sum = sumOfBigJackpot.sub(sum);
495             lastBuyer.send(sum);
496             emit NewBigJackpotWinner(lastBuyer, sum);
497 
498         }
499 
500         lastBuyer = address(0);
501         sumOfBigJackpot = 0;
502     }
503 
504     function isGameEnd() public view returns(bool)
505     {
506         return  now > timerTime;
507     }
508 
509     function () onlyForActiveGame public payable
510     {
511         if(now > timerTime)
512         {
513             internalStopGame();
514             return;
515         }
516 
517         if(msg.value == 0) // get prize
518         {
519             getPrize(msg.sender);
520         }
521         else // get tokens
522         {
523             buyTokens(msg.sender, msg.value);
524         }
525     }
526 
527     function getTotalAvailableTokens() onlyForActiveGame public view returns (uint)
528     {
529         return token.balanceOf(this);
530     }
531 
532     function getTotalSoldTokens() ifTokenCreated public view returns (uint)
533     {
534         return token.totalSupply().sub(token.balanceOf(this));
535     }
536 
537     function getAvailableTokensAtCurrentPrice() onlyForActiveGame public view returns (uint)
538     {
539         uint tokens = priceStep - counterOfSoldTokens % priceStep;
540         uint modulo = tokens % 10 ** token.decimals();
541         if(modulo != 0) return tokens.sub(modulo);
542         return tokens;
543     }
544 
545     function getPrize(address sender) private
546     {
547         uint value = mapsStorage.winners(sender);
548         require(value > 0);
549 
550         mapsStorage.setWinnerValue(sender, 0);
551         sender.transfer(value);
552     }
553 
554     function buyTokens(address sender, uint weiAmount) private
555     {
556         uint tokens = calcNumberOfTokens(weiAmount);
557         require(tokens >= minNumberOfTokensToBuy);
558 
559 
560         uint availableTokens = getAvailableTokensAtCurrentPrice();
561         uint maxNumberOfTokens = availableTokens > maxNumberOfTokensToBuy ? maxNumberOfTokensToBuy : availableTokens;
562         tokens = tokens > maxNumberOfTokens ? maxNumberOfTokens : tokens;
563         uint actualWeiAmount = tokens.mul(currentPrice);
564         counterOfSoldTokens = counterOfSoldTokens.add(tokens);
565 
566 
567         sumOfSmallJackpot = sumOfSmallJackpot.add(actualWeiAmount.mul(smallJackpotPercent).div(1000));
568         sumOfBigJackpot = sumOfBigJackpot.add(actualWeiAmount.mul(bigJackpotPercent).div(1000));
569         sumOfFund = sumOfFund.add(actualWeiAmount.mul(fundPercent).div(1000)); //80%;
570 
571         uint fee = 0;
572         if(payReferralRewards(actualWeiAmount))
573         {
574             fee = actualWeiAmount.mul(feePercent).div(1000);
575         }
576         else
577         {
578             fee = actualWeiAmount.mul(feePercent.add(referrerPercent)).div(1000);
579         }
580         payFee(fee);
581 
582         lastBuyer = msg.sender;
583 
584         emit BuyTokens(sender, currentPrice, tokens, actualWeiAmount);
585 
586         if(tokens == availableTokens)
587         {
588             mapsStorage.setWinnerValue(sender, mapsStorage.winners(sender).add(sumOfSmallJackpot));
589 
590             emit NewSmallJackpotWinner(sender, sumOfSmallJackpot);
591             sumOfSmallJackpot = 0;
592             currentPrice = getNewBuyPrice();
593         }
594 
595         timerTime = getNewTimerTime(timerTime, tokens);
596 
597         token.transfer(sender, tokens);
598 
599 
600 
601         uint cashback = weiAmount.sub(actualWeiAmount);
602         if(cashback > 0)
603         {
604             sender.transfer(cashback);
605         }
606     }
607 
608     function getNewTimerTime(uint currentTimerTime, uint numberOfTokens) public view returns (uint)
609     {
610         require(currentTimerTime >= now);
611 
612         uint maxTimerTime = now.add(24 hours);
613         uint newTime = currentTimerTime.add(numberOfTokens.mul(1 minutes));
614         return newTime > maxTimerTime ? maxTimerTime : newTime;
615     }
616 
617     function payReferralRewards(uint actualWeiAmount) private returns (bool)
618     {
619         address referrerAddress = bytesToAddress(bytes(msg.data));
620         address parent = mapsStorage.parents(msg.sender);
621 
622         if(parent == address(0))
623         {
624             if(referrerAddress != address(0) && token.balanceOf(referrerAddress) > 0 && msg.sender != referrerAddress)
625             {
626                 mapsStorage.setParentValue(msg.sender, referrerAddress);
627                 uint value = actualWeiAmount.mul(referrerPercent).div(1000).div(2);
628                 referrerAddress.send(value);
629                 msg.sender.transfer(value);
630                 return true;
631             }
632 
633         }
634         else
635         {
636             parent.send(actualWeiAmount.mul(referrerPercent).div(1000));
637             return true;
638         }
639 
640         return false;
641     }
642 
643     function payFee(uint weiAmount) private
644     {
645         address(0xB6c0889c8C0f47C87F003E9a161dC1C323624033).transfer(weiAmount.mul(40).div(100));
646         address(0x8d1e5C1A7d3F8e18BFB5068825F10C3f5c380d71).transfer(weiAmount.mul(50).div(100));
647         address(0x1E8eD35588a0B48C9920eC837eEbD698bC740f3D).transfer(weiAmount.mul(10).div(100));
648     }
649 
650     function getNewBuyPrice() onlyForActiveGame public view returns (uint)
651     {
652         return currentPrice.add(currentPrice.mul(pricePercentGrowth).div(1000));
653     }
654 
655     function getSellPrice() ifTokenCreated public view returns (uint)
656     {
657         return sumOfFund.div(getTotalSoldTokens());
658     }
659 
660     function calcNumberOfTokens(uint weiAmount) onlyForActiveGame public view returns (uint)
661     {
662         uint modulo = weiAmount % currentPrice.mul(10 ** token.decimals());
663         if(modulo != 0) return weiAmount.sub(modulo).div(currentPrice);
664         return weiAmount.div(currentPrice);
665     }
666 
667     function bytesToAddress(bytes source) internal pure returns(address parsedAddress)
668     {
669         assembly {
670             parsedAddress := mload(add(source,0x14))
671         }
672         return parsedAddress;
673     }
674 
675     function transfer(address to, uint256 numberOfTokens, uint256 price) ifTokenCreated public
676     {
677         require(msg.sender == address(token));
678         uint weiAmount = numberOfTokens.mul(price);
679         emit SellTokens(to, price, numberOfTokens, weiAmount);
680         sumOfFund = sumOfFund.sub(weiAmount);
681         to.transfer(weiAmount);
682     }
683 }