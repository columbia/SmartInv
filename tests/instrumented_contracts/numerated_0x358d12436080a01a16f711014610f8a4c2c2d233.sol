1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner {
68     require(newOwner != address(0));      
69     owner = newOwner;
70   }
71 
72 }
73 
74 
75 contract Crowdsale {
76   using SafeMath for uint256;
77 
78   // The token being sold
79   MintableToken public token;
80 
81   // start and end timestamps where investments are allowed (both inclusive)
82   uint256 public startTime;
83   uint256 public endTime;
84 
85   // address where funds are collected
86   address public wallet;
87 
88   // how many token units a buyer gets per wei
89   uint256 public rate;
90 
91   // amount of raised money in wei
92   uint256 public weiRaised;
93 
94   /**
95    * event for token purchase logging
96    * @param purchaser who paid for the tokens
97    * @param beneficiary who got the tokens
98    * @param value weis paid for purchase
99    * @param amount amount of tokens purchased
100    */ 
101   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
102 
103 
104   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
105     require(_startTime >= now);
106     require(_endTime >= _startTime);
107     require(_rate > 0);
108     require(_wallet != 0x0);
109 
110     token = createTokenContract();
111     startTime = _startTime;
112     endTime = _endTime;
113     rate = _rate;
114     wallet = _wallet;
115   }
116 
117   // creates the token to be sold. 
118   // override this method to have crowdsale of a specific mintable token.
119   function createTokenContract() internal returns (MintableToken) {
120     return new MintableToken();
121   }
122 
123 
124   // fallback function can be used to buy tokens
125   function () payable {
126     buyTokens(msg.sender);
127   }
128 
129   // low level token purchase function
130   function buyTokens(address beneficiary) payable {
131     require(beneficiary != 0x0);
132     require(validPurchase());
133 
134     uint256 weiAmount = msg.value;
135 
136     // calculate token amount to be created
137     uint256 tokens = weiAmount.mul(rate);
138 
139     // update state
140     weiRaised = weiRaised.add(weiAmount);
141 
142     token.mint(beneficiary, tokens);
143     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
144 
145     forwardFunds();
146   }
147 
148   // send ether to the fund collection wallet
149   // override to create custom fund forwarding mechanisms
150   function forwardFunds() internal {
151     wallet.transfer(msg.value);
152   }
153 
154   // @return true if the transaction can buy tokens
155   function validPurchase() internal constant returns (bool) {
156     bool withinPeriod = now >= startTime && now <= endTime;
157     bool nonZeroPurchase = msg.value != 0;
158     return withinPeriod && nonZeroPurchase;
159   }
160 
161   // @return true if crowdsale event has ended
162   function hasEnded() public constant returns (bool) {
163     return now > endTime;
164   }
165 
166 
167 }
168 
169 contract ERC20Basic {
170   uint256 public totalSupply;
171   function balanceOf(address who) constant returns (uint256);
172   function transfer(address to, uint256 value) returns (bool);
173   event Transfer(address indexed from, address indexed to, uint256 value);
174 }
175 
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender) constant returns (uint256);
178   function transferFrom(address from, address to, uint256 value) returns (bool);
179   function approve(address spender, uint256 value) returns (bool);
180   event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 contract BasicToken is ERC20Basic {
184   using SafeMath for uint256;
185 
186   mapping(address => uint256) balances;
187 
188   /**
189   * @dev transfer token for a specified address
190   * @param _to The address to transfer to.
191   * @param _value The amount to be transferred.
192   */
193   function transfer(address _to, uint256 _value) returns (bool) {
194     require(_to != address(0));
195 
196     // SafeMath.sub will throw if there is not enough balance.
197     balances[msg.sender] = balances[msg.sender].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     Transfer(msg.sender, _to, _value);
200     return true;
201   }
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of. 
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) constant returns (uint256 balance) {
209     return balances[_owner];
210   }
211 
212 }
213 
214 contract StandardToken is ERC20, BasicToken {
215 
216   mapping (address => mapping (address => uint256)) allowed;
217 
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param _from address The address which you want to send tokens from
222    * @param _to address The address which you want to transfer to
223    * @param _value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
226     require(_to != address(0));
227 
228     var _allowance = allowed[_from][msg.sender];
229 
230     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
231     // require (_value <= _allowance);
232 
233     balances[_from] = balances[_from].sub(_value);
234     balances[_to] = balances[_to].add(_value);
235     allowed[_from][msg.sender] = _allowance.sub(_value);
236     Transfer(_from, _to, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) returns (bool) {
246 
247     // To change the approve amount you first have to reduce the addresses`
248     //  allowance to zero by calling `approve(_spender, 0)` if it is not
249     //  already 0 to mitigate the race condition described here:
250     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
252 
253     allowed[msg.sender][_spender] = _value;
254     Approval(msg.sender, _spender, _value);
255     return true;
256   }
257 
258   /**
259    * @dev Function to check the amount of tokens that an owner allowed to a spender.
260    * @param _owner address The address which owns the funds.
261    * @param _spender address The address which will spend the funds.
262    * @return A uint256 specifying the amount of tokens still available for the spender.
263    */
264   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
265     return allowed[_owner][_spender];
266   }
267   
268   /**
269    * approve should be called when allowed[_spender] == 0. To increment
270    * allowed value is better to use this function to avoid 2 calls (and wait until 
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    */
274   function increaseApproval (address _spender, uint _addedValue) 
275     returns (bool success) {
276     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
277     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281   function decreaseApproval (address _spender, uint _subtractedValue) 
282     returns (bool success) {
283     uint oldValue = allowed[msg.sender][_spender];
284     if (_subtractedValue > oldValue) {
285       allowed[msg.sender][_spender] = 0;
286     } else {
287       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
288     }
289     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293 }
294 
295 contract BurnableToken is StandardToken {
296 
297     /**
298      * @dev Burns a specific amount of tokens.
299      * @param _value The amount of token to be burned.
300      */
301     function burn(uint _value)
302         public
303     {
304         require(_value > 0);
305 
306         address burner = msg.sender;
307         balances[burner] = balances[burner].sub(_value);
308         totalSupply = totalSupply.sub(_value);
309         Burn(burner, _value);
310     }
311 
312     event Burn(address indexed burner, uint indexed value);
313 }
314 
315 contract MintableToken is StandardToken, Ownable {
316   event Mint(address indexed to, uint256 amount);
317   event MintFinished();
318 
319   bool public mintingFinished = false;
320 
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   /**
328    * @dev Function to mint tokens
329    * @param _to The address that will receive the minted tokens.
330    * @param _amount The amount of tokens to mint.
331    * @return A boolean that indicates if the operation was successful.
332    */
333   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
334     totalSupply = totalSupply.add(_amount);
335     balances[_to] = balances[_to].add(_amount);
336     Mint(_to, _amount);
337     Transfer(0x0, _to, _amount);
338     return true;
339   }
340 
341   /**
342    * @dev Function to stop minting new tokens.
343    * @return True if the operation was successful.
344    */
345   function finishMinting() onlyOwner returns (bool) {
346     mintingFinished = true;
347     MintFinished();
348     return true;
349   }
350 }
351 
352 
353 contract PundiXToken is MintableToken, BurnableToken {
354 
355     event ShowCurrentIndex(address indexed to, uint256 value);
356     event ShowBonus(address indexed to, uint256 value);
357 
358     string public constant name = "Pundi X Token";
359     string public constant symbol = "PXS";
360     uint8 public constant decimals = 18;
361 
362     uint256 public totalSupplyBonus;
363 
364     uint64[] public bonusTimeList = [
365     1512057600,1514736000,1517414400,1519833600,1522512000,1525104000,1527782400,1530374400,1533052800,1535731200,1538323200,1541001600,
366     1543593600,1546272000,1548950400,1551369600,1554048000,1556640000,1559318400,1561910400,1564588800,1567267200,1569859200,1572537600,
367     1575129600,1577808000,1580486400,1582992000,1585670400,1588262400,1590940800,1593532800,1596211200,1598889600,1601481600,1604160000];
368 
369 
370     uint8 public currentTimeIndex;
371 
372     function PundiXToken() {
373         currentTimeIndex = 0;
374     }
375 
376     // --------------------------------------------------------
377     mapping(address=>uint256) weiBalance;
378     address[] public investors;
379 
380     function addWei(address _address, uint256 _value) onlyOwner canMint public {
381         uint256 value = weiBalance[_address];
382         if (value == 0) {
383             investors.push(_address);
384         }
385         weiBalance[_address] = value.add(_value);
386     }
387 
388     function getInvestorsCount() constant onlyOwner public returns (uint256 investorsCount) {
389         return investors.length;
390     }
391 
392     function getWeiBalance(address _address) constant onlyOwner public returns (uint256 balance) {
393         return weiBalance[_address];
394     }
395 
396     // --------------------------------------------------------
397 
398 
399     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
400         bool result = super.transferFrom(_from, _to, _value);
401         if (result && currentTimeIndex < bonusTimeList.length) {
402             bonus(_from);
403             bonus(_to);
404         }
405         return result;
406     }
407 
408     function transfer(address _to, uint256 _value) public returns (bool) {
409         bool result = super.transfer(_to, _value);
410         if (result && currentTimeIndex < bonusTimeList.length) {
411             bonus(msg.sender);
412             bonus(_to);
413         }
414         return result;
415     }
416 
417 
418     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
419         bool result = super.mint(_to, _amount);
420         if (result) {
421             bonus(_to);
422         }
423         return result;
424     }
425 
426     function burn(uint256 _value) public {
427         super.burn(_value);
428         if (currentTimeIndex < bonusTimeList.length) {
429             bonus(msg.sender);
430         }
431 
432     }
433     // --------------------------------------------------------
434 
435     mapping(address => User) public users;
436 
437     struct User {
438         uint256 txTimestamp;
439         uint256[] monthBalance;
440         uint8 monthIndex;
441         uint256[] receiveBonus;
442         uint8 receiveIndex;
443     }
444 
445     function bonus(address _address) internal {
446         User storage user = users[_address];
447         tryNextTimeRange();
448 
449         uint64 maxTime = bonusTimeList[currentTimeIndex];
450         if (user.txTimestamp > maxTime) {
451             return;
452         }
453 
454         uint64 minTime = 0;
455         if (currentTimeIndex > 0) {
456             minTime = bonusTimeList[currentTimeIndex-1];
457         }
458 
459         for (uint _i = user.monthBalance.length; _i <= currentTimeIndex; _i++) {
460             user.monthBalance.push(0);
461         }
462 
463         // first time
464         if (user.txTimestamp == 0) {
465             user.monthBalance[currentTimeIndex] = balances[_address];
466             user.monthIndex = currentTimeIndex;
467         } else if (user.txTimestamp >= minTime) {
468             user.monthBalance[currentTimeIndex] = balances[_address];
469         } else { // (user.txTimestamp < minTime) cross month
470             uint256 pBalance = user.monthBalance[user.monthIndex];
471             for (uint8 i = user.monthIndex; i < currentTimeIndex; i++) {
472                 user.monthBalance[i] = pBalance;
473             }
474             user.monthBalance[currentTimeIndex] = balances[_address];
475             user.monthIndex = currentTimeIndex;
476         }
477         user.txTimestamp = now;
478 
479     }
480 
481     function tryNextTimeRange() internal {
482         uint8 len = uint8(bonusTimeList.length) - 1;
483         uint64 _now = uint64(now);
484         for(; currentTimeIndex < len; currentTimeIndex++) {
485             if (bonusTimeList[currentTimeIndex] >= _now) {
486                 break;
487             }
488         }
489     }
490 
491     function receiveBonus() public {
492         tryNextTimeRange();
493 
494         if (currentTimeIndex == 0) {
495             return;
496         }
497 
498         address addr = msg.sender;
499 
500         User storage user = users[addr];
501 
502         if (user.monthIndex < currentTimeIndex) {
503             bonus(addr);
504         }
505 
506         User storage xuser = users[addr];
507 
508         if (xuser.receiveIndex == xuser.monthIndex || xuser.receiveIndex >= bonusTimeList.length) {
509             return;
510         }
511 
512 
513         require(user.receiveIndex < user.monthIndex);
514 
515         uint8 monthInterval = xuser.monthIndex - xuser.receiveIndex;
516 
517         uint256 bonusToken = 0;
518 
519         if (monthInterval > 6) {
520             uint8 _length = monthInterval - 6;
521 
522             for (uint8 j = 0; j < _length; j++) {
523                 xuser.receiveBonus.push(0);
524                 xuser.receiveIndex++;
525             }
526         }
527 
528         uint256 balance = xuser.monthBalance[xuser.monthIndex];
529 
530         for (uint8 i = xuser.receiveIndex; i < xuser.monthIndex; i++) {
531             uint256 preMonthBonus = calculateBonusToken(i, balance);
532             balance = preMonthBonus.add(balance);
533             bonusToken = bonusToken.add(preMonthBonus);
534             xuser.receiveBonus.push(preMonthBonus);
535             xuser.receiveIndex++;
536         }
537 
538         // 事件
539         ShowBonus(addr, bonusToken);
540 
541         if (bonusToken == 0) {
542             return;
543         }
544 
545         totalSupplyBonus = totalSupplyBonus.sub(bonusToken);
546 
547         this.transfer(addr, bonusToken);
548     }
549 
550     function calculateBonusToken(uint8 _monthIndex, uint256 _balance) internal returns (uint256) {
551         uint256 bonusToken = 0;
552         if (_monthIndex < 12) {
553             // 7.31606308769453%
554             bonusToken = _balance.div(10000000000000000).mul(731606308769453);
555         } else if (_monthIndex < 24) {
556             // 2.11637098909784%
557             bonusToken = _balance.div(10000000000000000).mul(211637098909784);
558         } else if (_monthIndex < 36) {
559             // 0.881870060450728%
560             bonusToken = _balance.div(100000000000000000).mul(881870060450728);
561         }
562 
563         return bonusToken;
564     }
565 
566 
567     function calculationTotalSupply() onlyOwner {
568         uint256 u1 = totalSupply.div(10);
569 
570         uint256 year1 = u1.mul(4);
571         uint256 year2 = u1.mul(2);
572         uint256 year3 = u1;
573 
574         totalSupplyBonus = year1.add(year2).add(year3);
575     }
576 
577     function recycleUnreceivedBonus(address _address) onlyOwner {
578         tryNextTimeRange();
579         require(currentTimeIndex > 34);
580 
581         uint64 _now = uint64(now);
582 
583         uint64 maxTime = bonusTimeList[currentTimeIndex];
584 
585         uint256 bonusToken = 0;
586 
587         // TODO 180 days
588         uint64 finalTime = 180 days + maxTime;
589 
590         if (_now > finalTime) {
591             bonusToken = totalSupplyBonus;
592             totalSupplyBonus = 0;
593         }
594 
595         require(bonusToken != 0);
596 
597         this.transfer(_address, bonusToken);
598     }
599 
600 }