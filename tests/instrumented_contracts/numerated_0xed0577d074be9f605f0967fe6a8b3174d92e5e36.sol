1 pragma solidity ^0.4.23;
2 
3 /**
4  *
5  * @author Maciek Zielinski & Radek Ostrowski - https://startonchain.com
6  * @author Alex George - https://dexbrokerage.com
7  *
8 */
9 
10 
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 library SafeMath {
47 
48   /**
49   * @dev Multiplies two numbers, throws on overflow.
50   */
51   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52     if (a == 0) {
53       return 0;
54     }
55     uint256 c = a * b;
56     require(c / a == b);
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers, truncating the quotient.
62   */
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // require(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // require(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     return a - b;
76   }
77 
78   /**
79   * @dev Adds two numbers, throws on overflow.
80   */
81   function add(uint256 a, uint256 b) internal pure returns (uint256) {
82     uint256 c = a + b;
83     require(c >= a);
84     return c;
85   }
86 
87   /**
88   * @dev a to power of b, throws on overflow.
89   */
90   function pow(uint256 a, uint256 b) internal pure returns (uint256) {
91     uint256 c = a ** b;
92     require(c >= a);
93     return c;
94   }
95 
96 }
97 
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 contract ERC20 is ERC20Basic {
106   function allowance(address owner, address spender) public view returns (uint256);
107   function transferFrom(address from, address to, uint256 value) public returns (bool);
108   function approve(address spender, uint256 value) public returns (bool);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   uint256 totalSupply_;
118 
119   /**
120   * @dev total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _value The amount to be transferred.
130   */
131   function transfer(address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[msg.sender]);
134 
135     // SafeMath.sub will throw if there is not enough balance.
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256 balance) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 contract DexBrokerage is Ownable {
154   using SafeMath for uint256;
155 
156   address public feeAccount;
157   uint256 public makerFee;
158   uint256 public takerFee;
159   uint256 public inactivityReleasePeriod;
160   mapping (address => bool) public approvedCurrencyTokens;
161   mapping (address => uint256) public invalidOrder;
162   mapping (address => mapping (address => uint256)) public tokens;
163   mapping (address => bool) public admins;
164   mapping (address => uint256) public lastActiveTransaction;
165   mapping (bytes32 => uint256) public orderFills;
166   mapping (bytes32 => bool) public withdrawn;
167 
168   event Trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address maker, address taker);
169   event Deposit(address token, address user, uint256 amount, uint256 balance);
170   event Withdraw(address token, address user, uint256 amount, uint256 balance);
171   event MakerFeeUpdated(uint256 oldFee, uint256 newFee);
172   event TakerFeeUpdated(uint256 oldFee, uint256 newFee);
173 
174   modifier onlyAdmin {
175     require(msg.sender == owner || admins[msg.sender]);
176     _;
177   }
178 
179   constructor(uint256 _makerFee, uint256 _takerFee , address _feeAccount, uint256 _inactivityReleasePeriod) public {
180     owner = msg.sender;
181     makerFee = _makerFee;
182     takerFee = _takerFee;
183     feeAccount = _feeAccount;
184     inactivityReleasePeriod = _inactivityReleasePeriod;
185   }
186 
187   function approveCurrencyTokenAddress(address currencyTokenAddress, bool isApproved) onlyAdmin public {
188     approvedCurrencyTokens[currencyTokenAddress] = isApproved;
189   }
190 
191   function invalidateOrdersBefore(address user, uint256 nonce) onlyAdmin public {
192     require(nonce >= invalidOrder[user]);
193     invalidOrder[user] = nonce;
194   }
195 
196   function setMakerFee(uint256 _makerFee) onlyAdmin public {
197     //market maker fee will never be more than 1%
198     uint256 oldFee = makerFee;
199     if (_makerFee > 10 finney) {
200       _makerFee = 10 finney;
201     }
202     require(makerFee != _makerFee);
203     makerFee = _makerFee;
204     emit MakerFeeUpdated(oldFee, makerFee);
205   }
206 
207   function setTakerFee(uint256 _takerFee) onlyAdmin public {
208     //market taker fee will never be more than 2%
209     uint256 oldFee = takerFee;
210     if (_takerFee > 20 finney) {
211       _takerFee = 20 finney;
212     }
213     require(takerFee != _takerFee);
214     takerFee = _takerFee;
215     emit TakerFeeUpdated(oldFee, takerFee);
216   }
217 
218   function setInactivityReleasePeriod(uint256 expire) onlyAdmin public returns (bool) {
219     require(expire <= 50000);
220     inactivityReleasePeriod = expire;
221     return true;
222   }
223 
224   function setAdmin(address admin, bool isAdmin) onlyOwner public {
225     admins[admin] = isAdmin;
226   }
227 
228   function depositToken(address token, uint256 amount) public {
229     receiveTokenDeposit(token, msg.sender, amount);
230   }
231 
232   function receiveTokenDeposit(address token, address from, uint256 amount) public {
233     tokens[token][from] = tokens[token][from].add(amount);
234     lastActiveTransaction[from] = block.number;
235     require(ERC20(token).transferFrom(from, address(this), amount));
236     emit Deposit(token, from, amount, tokens[token][from]);
237   }
238 
239   function deposit() payable public {
240     tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].add(msg.value);
241     lastActiveTransaction[msg.sender] = block.number;
242     emit Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
243   }
244 
245   function withdraw(address token, uint256 amount) public returns (bool) {
246     require(block.number.sub(lastActiveTransaction[msg.sender]) >= inactivityReleasePeriod);
247     require(tokens[token][msg.sender] >= amount);
248     tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
249     if (token == address(0)) {
250       msg.sender.transfer(amount);
251     } else {
252       require(ERC20(token).transfer(msg.sender, amount));
253     }
254     emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
255     return true;
256   }
257 
258   function adminWithdraw(address token, uint256 amount, address user, uint256 nonce, uint8 v, bytes32 r, bytes32 s, uint256 gasCost) onlyAdmin public returns (bool) {
259     //gasCost will never be more than 30 finney
260     if (gasCost > 30 finney) gasCost = 30 finney;
261 
262     if(token == address(0)){
263       require(tokens[address(0)][user] >= gasCost.add(amount));
264     } else {
265       require(tokens[address(0)][user] >= gasCost);
266       require(tokens[token][user] >= amount);
267     }
268 
269     bytes32 hash = keccak256(address(this), token, amount, user, nonce);
270     require(!withdrawn[hash]);
271     withdrawn[hash] = true;
272     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user);
273 
274     if(token == address(0)){
275       tokens[address(0)][user] = tokens[address(0)][user].sub(gasCost.add(amount));
276       tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(gasCost);
277       user.transfer(amount);
278     } else {
279       tokens[token][user] = tokens[token][user].sub(amount);
280       tokens[address(0)][user] = tokens[address(0)][user].sub(gasCost);
281       tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(gasCost);
282       require(ERC20(token).transfer(user, amount));
283     }
284     lastActiveTransaction[user] = block.number;
285     emit Withdraw(token, user, amount, tokens[token][user]);
286     return true;
287   }
288 
289   function balanceOf(address token, address user) view public returns (uint256) {
290     return tokens[token][user];
291   }
292 
293     /* tradeValues
294        [0] amountBuy
295        [1] amountSell
296        [2] makerNonce
297        [3] takerAmountBuy
298        [4] takerAmountSell
299        [5] takerExpires
300        [6] takerNonce
301        [7] makerAmountBuy
302        [8] makerAmountSell
303        [9] makerExpires
304        [10] gasCost
305      tradeAddressses
306        [0] tokenBuy
307        [1] tokenSell
308        [2] maker
309        [3] taker
310      */
311 
312 
313   function trade(uint256[11] tradeValues, address[4] tradeAddresses, uint8[2] v, bytes32[4] rs) onlyAdmin public returns (bool) {
314     uint256 price = tradeValues[0].mul(1 ether).div(tradeValues[1]);
315     require(price >= tradeValues[7].mul(1 ether).div(tradeValues[8]).sub(100000 wei));
316     require(price <= tradeValues[4].mul(1 ether).div(tradeValues[3]).add(100000 wei));
317     require(block.number < tradeValues[9]);
318     require(block.number < tradeValues[5]);
319     require(invalidOrder[tradeAddresses[2]] <= tradeValues[2]);
320     require(invalidOrder[tradeAddresses[3]] <= tradeValues[6]);
321     bytes32 orderHash = keccak256(address(this), tradeAddresses[0], tradeValues[7], tradeAddresses[1], tradeValues[8], tradeValues[9], tradeValues[2], tradeAddresses[2]);
322     bytes32 tradeHash = keccak256(address(this), tradeAddresses[1], tradeValues[3], tradeAddresses[0], tradeValues[4], tradeValues[5], tradeValues[6], tradeAddresses[3]);
323     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) == tradeAddresses[2]);
324     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", tradeHash), v[1], rs[2], rs[3]) == tradeAddresses[3]);
325     require(tokens[tradeAddresses[0]][tradeAddresses[3]] >= tradeValues[0]);
326     require(tokens[tradeAddresses[1]][tradeAddresses[2]] >= tradeValues[1]);
327     if ((tradeAddresses[0] == address(0) || tradeAddresses[1] == address(0)) && tradeValues[10] > 30 finney) tradeValues[10] = 30 finney;
328     if ((approvedCurrencyTokens[tradeAddresses[0]] == true || approvedCurrencyTokens[tradeAddresses[1]] == true) && tradeValues[10] > 10 ether) tradeValues[10] = 10 ether;
329 
330     if(tradeAddresses[0] == address(0) || approvedCurrencyTokens[tradeAddresses[0]] == true){
331 
332       require(orderFills[orderHash].add(tradeValues[1]) <= tradeValues[8]);
333       require(orderFills[tradeHash].add(tradeValues[1]) <= tradeValues[3]);
334 
335       //tradeAddresses[0] is ether
336       uint256 valueInTokens = tradeValues[1];
337 
338       //move tokens
339       tokens[tradeAddresses[1]][tradeAddresses[2]] = tokens[tradeAddresses[1]][tradeAddresses[2]].sub(valueInTokens);
340       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].add(valueInTokens);
341 
342       //from taker, take ether payment, fee and gasCost
343       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(tradeValues[0]);
344       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(takerFee.mul(tradeValues[0]).div(1 ether));
345       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(tradeValues[10]);
346 
347       //to maker add ether payment, take fee
348       tokens[tradeAddresses[0]][tradeAddresses[2]] = tokens[tradeAddresses[0]][tradeAddresses[2]].add(tradeValues[0]);
349       tokens[tradeAddresses[0]][tradeAddresses[2]] = tokens[tradeAddresses[0]][tradeAddresses[2]].sub(makerFee.mul(tradeValues[0]).div(1 ether));
350 
351       // take maker fee, taker fee and gasCost
352       tokens[tradeAddresses[0]][feeAccount] = tokens[tradeAddresses[0]][feeAccount].add(makerFee.mul(tradeValues[0]).div(1 ether));
353       tokens[tradeAddresses[0]][feeAccount] = tokens[tradeAddresses[0]][feeAccount].add(takerFee.mul(tradeValues[0]).div(1 ether));
354       tokens[tradeAddresses[0]][feeAccount] = tokens[tradeAddresses[0]][feeAccount].add(tradeValues[10]);
355 
356       orderFills[orderHash] = orderFills[orderHash].add(tradeValues[1]);
357       orderFills[tradeHash] = orderFills[tradeHash].add(tradeValues[1]);
358 
359     } else {
360 
361       require(orderFills[orderHash].add(tradeValues[0]) <= tradeValues[7]);
362       require(orderFills[tradeHash].add(tradeValues[0]) <= tradeValues[4]);
363 
364       //tradeAddresses[0] is token
365       uint256 valueInEth = tradeValues[1];
366 
367       //move tokens //changed tradeValues to 0
368       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(tradeValues[0]);
369       tokens[tradeAddresses[0]][tradeAddresses[2]] = tokens[tradeAddresses[0]][tradeAddresses[2]].add(tradeValues[0]);
370 
371       //from maker, take ether payment and fee
372       tokens[tradeAddresses[1]][tradeAddresses[2]] = tokens[tradeAddresses[1]][tradeAddresses[2]].sub(valueInEth);
373       tokens[tradeAddresses[1]][tradeAddresses[2]] = tokens[tradeAddresses[1]][tradeAddresses[2]].sub(makerFee.mul(valueInEth).div(1 ether));
374 
375       //add ether payment to taker, take fee, take gasCost
376       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].add(valueInEth);
377       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].sub(takerFee.mul(valueInEth).div(1 ether));
378       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].sub(tradeValues[10]);
379 
380       //take maker fee, taker fee and gasCost
381       tokens[tradeAddresses[1]][feeAccount] = tokens[tradeAddresses[1]][feeAccount].add(makerFee.mul(valueInEth).div(1 ether));
382       tokens[tradeAddresses[1]][feeAccount] = tokens[tradeAddresses[1]][feeAccount].add(takerFee.mul(valueInEth).div(1 ether));
383       tokens[tradeAddresses[1]][feeAccount] = tokens[tradeAddresses[1]][feeAccount].add(tradeValues[10]);
384 
385       orderFills[orderHash] = orderFills[orderHash].add(tradeValues[0]);
386       orderFills[tradeHash] = orderFills[tradeHash].add(tradeValues[0]);
387     }
388 
389     lastActiveTransaction[tradeAddresses[2]] = block.number;
390     lastActiveTransaction[tradeAddresses[3]] = block.number;
391 
392     emit Trade(tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeAddresses[2], tradeAddresses[3]);
393     return true;
394   }
395 
396 }
397 
398 contract OptionFactory is Ownable {
399 
400     using SafeMath for uint256;
401 
402     mapping (address => bool) public admins;
403     mapping(uint 
404         => mapping(address 
405             => mapping(address 
406                 => mapping(uint
407                     => mapping(bool
408                         => mapping(uint8 
409                             => OptionToken)))))) register;
410 
411     DexBrokerage public exchangeContract;
412     ERC20        public dexb;
413     uint         public dexbTreshold;
414     address      public dexbAddress;
415 
416     // Fees for all.
417     uint public issueFee;
418     uint public executeFee;
419     uint public cancelFee;
420 
421     // Fees for DEXB holders.
422     uint public dexbIssueFee;
423     uint public dexbExecuteFee;
424     uint public dexbCancelFee;
425 
426     // Value represents 100%
427     uint public HUNDERED_PERCENT = 100000;
428 
429     // Max fee is 1%
430     uint public MAX_FEE = HUNDERED_PERCENT.div(100);
431 
432     constructor(address _dexbAddress, uint _dexbTreshold, address _dexBrokerageAddress) public {
433         dexbAddress      = _dexbAddress;
434         dexb             = ERC20(_dexbAddress);
435         dexbTreshold     = _dexbTreshold;
436         exchangeContract = DexBrokerage(_dexBrokerageAddress);
437 
438         // Set fee for everyone to 0.3%
439         setIssueFee(300);
440         setExecuteFee(300);
441         setCancelFee(300);
442 
443         // Set fee for DEXB holders to 0.2%
444         setDexbIssueFee(200);
445         setDexbExecuteFee(200);
446         setDexbCancelFee(200);
447     }
448 
449 
450     function getOptionAddress(
451         uint expiryDate, 
452         address firstToken, 
453         address secondToken, 
454         uint strikePrice,
455         bool isCall,
456         uint8 decimals) public view returns (address) {
457         
458         return address(register[expiryDate][firstToken][secondToken][strikePrice][isCall][decimals]);
459     }
460 
461     function createOption(
462         uint expiryDate, 
463         address firstToken, 
464         address secondToken, 
465         uint minIssueAmount,
466         uint strikePrice,
467         bool isCall,
468         uint8 decimals,
469         string name) public {
470 
471         require(address(0) == getOptionAddress(
472             expiryDate, firstToken, secondToken, strikePrice, isCall, decimals    
473         ));
474 
475         OptionToken newOption = new OptionToken(
476             this,
477             firstToken,
478             secondToken,
479             minIssueAmount,
480             expiryDate,
481             strikePrice,
482             isCall,
483             name,
484             decimals
485         );
486 
487         register[expiryDate][firstToken][secondToken]
488             [strikePrice][isCall][decimals] = newOption;
489     }
490 
491     modifier validFeeOnly(uint fee) { 
492         require (fee <= MAX_FEE); 
493         _;
494     }
495     
496     modifier onlyAdmin {
497         require(msg.sender == owner || admins[msg.sender]);
498         _;
499     }
500 
501     function setAdmin(address admin, bool isAdmin) onlyOwner public {
502         admins[admin] = isAdmin;
503     }
504 
505     function setIssueFee(uint fee) public onlyAdmin validFeeOnly(fee) {
506         issueFee = fee;
507     }
508 
509     function setExecuteFee(uint fee) public onlyAdmin validFeeOnly(fee) {
510         executeFee = fee;
511     }
512 
513     function setCancelFee(uint fee) public onlyAdmin validFeeOnly(fee) {
514         cancelFee = fee;
515     }
516 
517     function setDexbIssueFee(uint fee) public onlyAdmin validFeeOnly(fee) {
518         dexbIssueFee = fee;
519     }
520 
521     function setDexbExecuteFee(uint fee) public onlyAdmin validFeeOnly(fee) {
522         dexbExecuteFee = fee;
523     }
524 
525     function setDexbCancelFee(uint fee) public onlyAdmin validFeeOnly(fee) {
526         dexbCancelFee = fee;
527     }
528 
529     function setDexbTreshold(uint treshold) public onlyAdmin {
530         dexbTreshold = treshold;
531     }
532 
533     function calcIssueFeeAmount(address user, uint value) public view returns (uint) {
534         uint feeLevel = getFeeLevel(user, dexbIssueFee, issueFee);
535         return calcFee(feeLevel, value);
536     }
537 
538     function calcExecuteFeeAmount(address user, uint value) public view returns (uint) {
539         uint feeLevel = getFeeLevel(user, dexbExecuteFee, executeFee);
540         return calcFee(feeLevel, value);
541     }
542 
543     function calcCancelFeeAmount(address user, uint value) public view returns (uint) {
544         uint feeLevel = getFeeLevel(user, dexbCancelFee, cancelFee);
545         return calcFee(feeLevel, value);
546     }
547 
548     function getFeeLevel(address user, uint aboveTresholdFee, uint belowTresholdFee) internal view returns (uint) {
549         if(dexb.balanceOf(user) + exchangeContract.balanceOf(dexbAddress, user) >= dexbTreshold){
550             return aboveTresholdFee;
551         } else {
552             return belowTresholdFee;
553         }
554     }
555 
556     function calcFee(uint feeLevel, uint value) internal view returns (uint) {
557         return value.mul(feeLevel).div(HUNDERED_PERCENT);
558     }
559 }
560 
561 contract StandardToken is ERC20, BasicToken {
562 
563   mapping (address => mapping (address => uint256)) internal allowed;
564 
565 
566   /**
567    * @dev Transfer tokens from one address to another
568    * @param _from address The address which you want to send tokens from
569    * @param _to address The address which you want to transfer to
570    * @param _value uint256 the amount of tokens to be transferred
571    */
572   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
573     require(_to != address(0));
574     require(_value <= balances[_from]);
575     require(_value <= allowed[_from][msg.sender]);
576 
577     balances[_from] = balances[_from].sub(_value);
578     balances[_to] = balances[_to].add(_value);
579     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
580     emit Transfer(_from, _to, _value);
581     return true;
582   }
583 
584   /**
585    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
586    *
587    * Beware that changing an allowance with this method brings the risk that someone may use both the old
588    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
589    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
590    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
591    * @param _spender The address which will spend the funds.
592    * @param _value The amount of tokens to be spent.
593    */
594   function approve(address _spender, uint256 _value) public returns (bool) {
595     allowed[msg.sender][_spender] = _value;
596     emit Approval(msg.sender, _spender, _value);
597     return true;
598   }
599 
600   /**
601    * @dev Function to check the amount of tokens that an owner allowed to a spender.
602    * @param _owner address The address which owns the funds.
603    * @param _spender address The address which will spend the funds.
604    * @return A uint256 specifying the amount of tokens still available for the spender.
605    */
606   function allowance(address _owner, address _spender) public view returns (uint256) {
607     return allowed[_owner][_spender];
608   }
609 
610   /**
611    * @dev Increase the amount of tokens that an owner allowed to a spender.
612    *
613    * approve should be called when allowed[_spender] == 0. To increment
614    * allowed value is better to use this function to avoid 2 calls (and wait until
615    * the first transaction is mined)
616    * From MonolithDAO Token.sol
617    * @param _spender The address which will spend the funds.
618    * @param _addedValue The amount of tokens to increase the allowance by.
619    */
620   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
621     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
622     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
623     return true;
624   }
625 
626   /**
627    * @dev Decrease the amount of tokens that an owner allowed to a spender.
628    *
629    * approve should be called when allowed[_spender] == 0. To decrement
630    * allowed value is better to use this function to avoid 2 calls (and wait until
631    * the first transaction is mined)
632    * From MonolithDAO Token.sol
633    * @param _spender The address which will spend the funds.
634    * @param _subtractedValue The amount of tokens to decrease the allowance by.
635    */
636   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
637     uint oldValue = allowed[msg.sender][_spender];
638     if (_subtractedValue > oldValue) {
639       allowed[msg.sender][_spender] = 0;
640     } else {
641       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
642     }
643     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
644     return true;
645   }
646 
647   // ------------------------------------------------------------------------
648   // Token owner can approve for `_exchange` to transferFrom(...) `_amount` of
649   // tokens from the owner's account. The `_exchange` contract function
650   // `receiveTokenDeposit(...)` is then executed
651   // ------------------------------------------------------------------------
652 
653  function approveAndDeposit(DexBrokerage _exchange, uint _amount) public returns (bool success) {
654     allowed[msg.sender][_exchange] = _amount;
655     emit Approval(msg.sender, _exchange, _amount);
656     _exchange.receiveTokenDeposit(address(this), msg.sender, _amount);
657     return true;
658   }
659 
660 }
661 
662 
663 contract OptionToken is StandardToken {
664 
665     using SafeMath for uint256;
666 
667     OptionFactory public factory;
668     ERC20  public firstToken;
669     ERC20  public secondToken;
670     uint   public minIssueAmount;
671     uint   public expiry;
672     uint   public strikePrice;
673     bool   public isCall;
674     string public symbol;
675     uint  public decimals;
676 
677     struct Issuer {
678         address addr;
679         uint amount;
680     }
681 
682     Issuer[] internal issuers;
683 
684     constructor(
685         address _factory,
686         address _firstToken,
687         address _secondToken,
688         uint    _minIssueAmount,
689         uint    _expiry,
690         uint    _strikePrice,
691         bool    _isCall,
692         string  _symbol,
693         uint8   _decimals) public {
694 
695         require (_firstToken != _secondToken, 'Tokens should be different.');
696 
697         factory        = OptionFactory(_factory);
698         firstToken     = ERC20(_firstToken);
699         secondToken    = ERC20(_secondToken);
700         minIssueAmount = _minIssueAmount;
701         expiry         = _expiry;
702         strikePrice    = _strikePrice;
703         isCall         = _isCall;
704         symbol         = _symbol;
705         decimals       = uint(_decimals);
706     }
707 
708     modifier onlyAdmin {
709         require(factory.admins(msg.sender));
710         _;
711     }
712 
713     /** Public API */
714 
715     function setMinIssueAmount(uint minAmount) onlyAdmin public  {
716         minIssueAmount = minAmount;
717     }
718 
719     function issueWithToken(uint amount) public beforeExpiry canIssueWithToken returns (bool) {
720         require(amount >= minIssueAmount);
721         uint fee = factory.calcIssueFeeAmount(msg.sender, amount);
722         uint amountWithoutFee = amount - fee;
723         transferTokensInOnIssue(amountWithoutFee, fee);
724         issue(amountWithoutFee);
725         return true;
726     }
727 
728     function issueWithWei() public payable beforeExpiry canIssueWithWei returns (bool) {
729         require(msg.value >= minIssueAmount);
730         uint fee = factory.calcIssueFeeAmount(msg.sender, msg.value);
731         uint amountWithoutFee = msg.value - fee;
732         factory.owner().transfer(fee);
733         if(isCall){
734             issue(amountWithoutFee);
735         } else {
736             uint amount = amountWithoutFee.mul(uint(10).pow(decimals)).div(strikePrice);
737             issue(amount);
738         }
739         return true;
740     }
741 
742     function executeWithToken(uint amount) public beforeExpiry canExecuteWithToken returns (bool) {
743         transferTokensInOnExecute(amount);
744         execute(amount);
745         return true;
746     }
747 
748     function executeWithWei() public payable beforeExpiry canExecuteWithWei {
749         if(isCall){
750             uint amount = msg.value.mul(uint(10).pow(decimals)).div(strikePrice);
751             execute(amount);
752         } else {
753             execute(msg.value);
754         }
755     }
756 
757     function cancel(uint amount) public beforeExpiry {
758         burn(msg.sender, amount);
759         bool found = false;
760         for (uint i = 0; i < issuers.length; i++) {
761             if(issuers[i].addr == msg.sender) {
762                 found = true;
763                 issuers[i].amount = issuers[i].amount.sub(amount);
764                 transferTokensOrWeiOutToIssuerOnCancel(amount);
765                 break;
766             }
767         }
768         require(found);
769     }
770 
771     function refund() public afterExpiry {
772         // Distribute tokens or wei to issuers.
773         for(uint i = 0; i < issuers.length; i++) {
774             if(issuers[i].amount > 0){
775                 transferTokensOrWeiOutToIssuerOnRefund(issuers[i].addr, issuers[i].amount);
776             }
777         }
778     }
779 
780     /** Internal API */
781     function transferTokensInOnIssue(uint amountForContract, uint feeAmount) internal returns (bool) {
782         ERC20 token;
783         uint toTransferIntoContract;
784         uint toTransferFee;
785         if(isCall){
786             token = firstToken;
787             toTransferIntoContract = amountForContract;
788             toTransferFee = feeAmount;
789         } else {
790             token = secondToken;
791             toTransferIntoContract = strikePrice.mul(amountForContract).div(uint(10).pow(decimals));
792             toTransferFee = strikePrice.mul(feeAmount).div(uint(10).pow(decimals));
793         }
794         require(token != address(0));
795         require(transferTokensIn(token, toTransferIntoContract + toTransferFee));
796         require(transferTokensToOwner(token, toTransferFee));
797         return true;
798     }
799 
800     function transferTokensInOnExecute(uint amount) internal returns (bool) {
801         ERC20 token;
802         uint toTransfer;
803         if(isCall){
804             token = secondToken;
805             toTransfer = strikePrice.mul(amount).div(uint(10).pow(decimals));
806         } else {
807             token = firstToken;
808             toTransfer = amount;
809         }
810         require(token != address(0));
811         require(transferTokensIn(token, toTransfer));
812         return true;
813     }
814 
815     function transferTokensIn(ERC20 token, uint amount) internal returns (bool) {
816         require(token.transferFrom(msg.sender, this, amount));
817         return true;
818     }
819 
820     function transferTokensToOwner(ERC20 token, uint amount) internal returns (bool) {
821         require(token.transfer(factory.owner(), amount));
822         return true;
823     }
824 
825     function transfer(ERC20 token, uint amount) internal returns (bool) {
826         require(token.transferFrom(msg.sender, factory.owner(), amount));
827         return true;
828     }
829     function issue(uint amount) internal returns (bool){
830         mint(msg.sender, amount);
831         bool found = false;
832         for (uint i = 0; i < issuers.length; i++) {
833             if(issuers[i].addr == msg.sender) {
834                 issuers[i].amount = issuers[i].amount.add(amount);
835                 found = true;
836                 break;
837             }
838         }
839 
840         if(!found) {
841             issuers.push(Issuer(msg.sender, amount));
842         }
843     }
844 
845     function mint(address to, uint amount) internal returns (bool) {
846         totalSupply_ = totalSupply_.add(amount);
847         balances[to] = balances[to].add(amount);
848         emit Transfer(address(0), to, amount);
849         return true;
850     }
851 
852     function execute(uint amount) internal returns (bool) {
853         burn(msg.sender, amount);
854         transferTokensOrWeiOutToSenderOnExecute(amount);
855         // Distribute tokens to issuers.
856         uint amountToDistribute = amount;
857         uint i = issuers.length - 1;
858         while(amountToDistribute > 0){
859             if(issuers[i].amount > 0){
860                 if(issuers[i].amount >= amountToDistribute){
861                     transferTokensOrWeiOutToIssuerOnExecute(issuers[i].addr, amountToDistribute);
862                     issuers[i].amount = issuers[i].amount.sub(amountToDistribute);
863                     amountToDistribute = 0;
864                 } else {
865                     transferTokensOrWeiOutToIssuerOnExecute(issuers[i].addr, issuers[i].amount);
866                     amountToDistribute = amountToDistribute.sub(issuers[i].amount);
867                     issuers[i].amount = 0;
868                 }
869             }
870             i = i - 1;
871         }
872         return true;
873     }
874 
875     function transferTokensOrWeiOutToSenderOnExecute(uint amount) internal returns (bool) {
876         ERC20 token;
877         uint toTransfer = 0;
878         if(isCall){
879             token = firstToken;
880             toTransfer = amount;
881         } else {
882             token = secondToken;
883             toTransfer = strikePrice.mul(amount).div(uint(10).pow(decimals));
884         }
885         uint fee = factory.calcExecuteFeeAmount(msg.sender, toTransfer);
886         toTransfer = toTransfer - fee;
887         if(token == address(0)){
888             require(msg.sender.send(toTransfer));
889             if(fee > 0){
890                 require(factory.owner().send(fee));
891             }
892         } else {
893             require(token.transfer(msg.sender, toTransfer));
894             if(fee > 0){
895                 require(token.transfer(factory.owner(), fee));
896             }
897         }
898         return true;
899     }
900 
901     function transferTokensOrWeiOutToIssuerOnExecute(address issuer, uint amount) internal returns (bool) {
902         ERC20 token;
903         uint toTransfer;
904         if(isCall){
905             token = secondToken;
906             toTransfer = strikePrice.mul(amount).div(uint(10).pow(decimals));
907         } else {
908             token = firstToken;
909             toTransfer = amount;
910         }
911         if(token == address(0)){
912             require(issuer.send(toTransfer));
913         } else {
914             require(token.transfer(issuer, toTransfer));
915         }
916         return true;
917     }
918 
919     function burn(address from, uint256 amount) internal returns (bool) {
920         require(amount <= balances[from]);
921         balances[from] = balances[from].sub(amount);
922         totalSupply_ = totalSupply_.sub(amount);
923         emit Transfer(from, address(0), amount);
924         return true;
925     }
926 
927     function transferTokensOrWeiOutToIssuerOnCancel(uint amount) internal returns (bool){
928         ERC20 token;
929         uint toTransfer = 0;
930         if(isCall){
931             token = firstToken;
932             toTransfer = amount;
933         } else {
934             token = secondToken;
935             toTransfer = strikePrice.mul(amount).div(uint(10).pow(decimals));
936         }
937         uint fee = factory.calcCancelFeeAmount(msg.sender, toTransfer);
938         toTransfer = toTransfer - fee;
939         if(token == address(0)){
940             require(msg.sender.send(toTransfer));
941             if(fee > 0){
942                 require(factory.owner().send(fee));
943             }
944         } else {
945             require(token.transfer(msg.sender, toTransfer));
946             if(fee > 0){
947                 require(token.transfer(factory.owner(), fee));
948             }
949         }
950         return true;
951     }
952 
953 
954     function transferTokensOrWeiOutToIssuerOnRefund(address issuer, uint amount) internal returns (bool){
955         ERC20 token;
956         uint toTransfer = 0;
957         if(isCall){
958             token = firstToken;
959             toTransfer = amount;
960         } else {
961             token = secondToken;
962             toTransfer = strikePrice.mul(amount).div(uint(10).pow(decimals));
963         }
964         if(token == address(0)){
965             issuer.transfer(toTransfer);
966         } else {
967             require(token.transfer(issuer, toTransfer));
968         }
969         return true;
970     }
971 
972     /** Modifiers */
973     modifier canIssueWithWei() {
974         require(
975             (isCall  && firstToken == address(0)) ||
976             (!isCall && secondToken == address(0))
977         );
978         _;
979     }
980 
981     modifier canIssueWithToken() {
982         require(
983             (isCall  && firstToken != address(0)) ||
984             (!isCall && secondToken != address(0))
985         );
986         _;
987     }
988 
989     modifier canExecuteWithWei() {
990         require(
991             (isCall  && secondToken == address(0)) ||
992             (!isCall && firstToken == address(0))
993         );
994         _;
995     }
996 
997     modifier canExecuteWithToken() {
998         require(
999             (isCall  && secondToken != address(0)) ||
1000             (!isCall && firstToken != address(0))
1001         );
1002         _;
1003     }
1004 
1005     modifier beforeExpiry() {
1006         require (now <= expiry);
1007         _;
1008     }
1009 
1010     modifier afterExpiry() {
1011         require (now > expiry);
1012         _;
1013     }
1014 }