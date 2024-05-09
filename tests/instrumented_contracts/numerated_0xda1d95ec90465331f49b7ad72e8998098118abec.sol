1 pragma solidity ^0.4.24;
2 
3 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: node_modules\zeppelin-solidity\contracts\math\SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address _owner, address _spender)
123     public view returns (uint256);
124 
125   function transferFrom(address _from, address _to, uint256 _value)
126     public returns (bool);
127 
128   function approve(address _spender, uint256 _value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166     require(_to != address(0));
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue >= oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: node_modules\zeppelin-solidity\contracts\ownership\Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\MintableToken.sol
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
327  */
328 contract MintableToken is StandardToken, Ownable {
329   event Mint(address indexed to, uint256 amount);
330   event MintFinished();
331 
332   bool public mintingFinished = false;
333 
334 
335   modifier canMint() {
336     require(!mintingFinished);
337     _;
338   }
339 
340   modifier hasMintPermission() {
341     require(msg.sender == owner);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint.
349    * @return A boolean that indicates if the operation was successful.
350    */
351   function mint(
352     address _to,
353     uint256 _amount
354   )
355     public
356     hasMintPermission
357     canMint
358     returns (bool)
359   {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     emit Mint(_to, _amount);
363     emit Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() public onlyOwner canMint returns (bool) {
372     mintingFinished = true;
373     emit MintFinished();
374     return true;
375   }
376 }
377 
378 // File: contracts\StattmToken.sol
379 
380 contract StattmToken is MintableToken {
381 
382     string public constant name = "Stattm";
383     string public constant symbol = "STTM";
384 
385     uint256 public constant decimals = 18;
386     mapping(address => bool) public isWhiteListed;
387 
388 
389     function burn() public {
390         uint256 _b = balanceOf(msg.sender);
391         balances[msg.sender] = 0;
392         totalSupply_ = totalSupply_ - _b;
393     }
394 
395     function addToWhitelist(address _user) public onlyOwner {
396         isWhiteListed[_user] = true;
397     }
398 
399     function removeFromWhitelist(address _user) public onlyOwner {
400         isWhiteListed[_user] = false;
401     }
402 
403     function init(address privateSale, address ito, address ico, address projectManagementAndAirdrop) public {
404 
405         require(totalSupply_ == 0);
406         require(address(privateSale) != address(0));
407         require(address(ito) != address(0));
408         require(address(ico) != address(0));
409         require(address(projectManagementAndAirdrop) != address(0));
410         mint(address(privateSale), (10 ** decimals) * (5000000));
411         mint(address(ito), (10 ** decimals) * (25000000));
412         mint(address(ico), (10 ** decimals) * (35000000));
413         mint(address(projectManagementAndAirdrop), (10 ** decimals) * (35100100));
414         mintingFinished = true;
415     }
416 }
417 
418 // File: contracts\AbstractCrowdsale.sol
419 
420 contract AbstractCrowdsale is Ownable{
421 
422     StattmToken public token;
423     bool public softCapReached = false;
424     bool public hardCapReached = false;
425     uint256 private _now =0;
426 
427     event WhiteListReqested(address _adr);
428 
429 
430     address public beneficiary;
431 
432     function saleStartTime() public constant returns(uint256);
433     function saleEndTime() public constant returns(uint256);
434     function softCapInTokens() public constant returns(uint256);
435     function hardCapInTokens() public constant returns(uint256);
436 
437     function withdrawEndTime() public constant returns(uint256){
438       return saleEndTime() + 30 days;
439     }
440 
441     mapping(address => uint256) public ethPayed;
442     mapping(address => uint256) public tokensToTransfer;
443     uint256 public totalTokensToTransfer = 0;
444 
445     constructor(address _token, address _beneficiary) public {
446         token = StattmToken(_token);
447         beneficiary = _beneficiary;
448     }
449 
450     function getCurrentPrice() public  constant returns(uint256) ;
451 
452     function forceReturn(address _adr) public onlyOwner{
453 
454         if (token.isWhiteListed(_adr) == false) {
455           //send tokens, presale successful
456           require(msg.value == 0);
457           uint256 amountToSend = tokensToTransfer[msg.sender];
458           tokensToTransfer[msg.sender] = 0;
459           ethPayed[msg.sender] = 0;
460           totalTokensToTransfer=totalTokensToTransfer-amountToSend;
461           softCapReached = totalTokensToTransfer >= softCapInTokens();
462           require(token.transfer(msg.sender, amountToSend));
463         }
464     }
465 
466     function getNow() public constant returns(uint256){
467       if(_now!=0){
468         return _now;
469       }
470       return now;
471     }
472 
473     function setNow(uint256 _n) public returns(uint256){
474 /*Allowed only in tests*///      _now = _n;
475       return now;
476     }
477     event Stage(uint256 blockNumber,uint256 index);
478     event Stage2(address adr,uint256 index);
479     function buy() public payable {
480         require(getNow()  > saleStartTime());
481         if (getNow()  > saleEndTime()
482           && (softCapReached == false
483           || token.isWhiteListed(msg.sender) == false)) {
484 
485             //return funds, presale unsuccessful or user not whitelisteed
486             emit Stage(block.number,10);
487             require(msg.value == 0);
488             emit Stage(block.number,11);
489             uint256 amountToReturn = ethPayed[msg.sender];
490             totalTokensToTransfer=totalTokensToTransfer-tokensToTransfer[msg.sender];
491             tokensToTransfer[msg.sender] = 0;
492             ethPayed[msg.sender] = 0;
493             softCapReached = totalTokensToTransfer >= softCapInTokens();
494             emit Stage(block.number,12);
495             msg.sender.transfer(amountToReturn);
496             emit Stage(block.number,13);
497 
498         }
499         if (getNow()  > saleEndTime()
500           && softCapReached == true
501           && token.isWhiteListed(msg.sender)) {
502 
503             emit Stage(block.number,20);
504             //send tokens, presale successful
505             require(msg.value == 0);
506             emit Stage(block.number,21);
507             uint256 amountToSend = tokensToTransfer[msg.sender];
508             tokensToTransfer[msg.sender] = 0;
509             ethPayed[msg.sender] = 0;
510             require(token.transfer(msg.sender, amountToSend));
511             emit Stage(block.number,22);
512 
513         }
514         if (getNow()  <= saleEndTime() && getNow()  > saleStartTime()) {
515             emit Stage(block.number,30);
516             ethPayed[msg.sender] = ethPayed[msg.sender] + msg.value;
517             tokensToTransfer[msg.sender] = tokensToTransfer[msg.sender] + getCurrentPrice() * msg.value;
518             totalTokensToTransfer = totalTokensToTransfer + getCurrentPrice() * msg.value;
519 
520             if (totalTokensToTransfer >= hardCapInTokens()) {
521                 //hardcap exceeded - revert;
522                 emit Stage(block.number,31);
523                 revert();
524                 emit Stage(block.number,32);
525             }
526         }
527         if(tokensToTransfer[msg.sender] > 0 &&  token.isWhiteListed(msg.sender) && softCapInTokens()==0){
528           emit Stage(block.number,40);
529           uint256 amountOfTokens = tokensToTransfer[msg.sender] ;
530           tokensToTransfer[msg.sender] = 0;
531           emit Stage(block.number,41);
532           require(token.transfer(msg.sender,amountOfTokens));
533           emit Stage(block.number,42);
534         }
535         if (totalTokensToTransfer >= softCapInTokens()) {
536             emit Stage(block.number,50);
537             softCapReached = true;
538             emit Stage(block.number,51);
539         }
540         if (getNow()  > withdrawEndTime() && softCapReached == true && msg.sender == owner) {
541             emit Stage(block.number,60);
542             emit Stage(address(this).balance,60);
543             //sale end successfully all eth is send to beneficiary
544             beneficiary.transfer(address(this).balance);
545             emit Stage(address(this).balance,60);
546             emit Stage(block.number,61);
547             token.burn();
548             emit Stage(block.number,62);
549         }
550 
551     }
552 
553 }
554 
555 // File: contracts\StattmPrivSale.sol
556 
557 contract StattmPrivSale is AbstractCrowdsale{
558 
559     function softCapInTokens() public constant returns(uint256){
560       return uint256(0);
561     }
562 
563     function hardCapInTokens() public constant returns(uint256){
564       return uint256(5000000*(10**18));
565     }
566 
567     function saleStartTime() public constant returns(uint256){
568       return 1535223482;  // 2018-08-25 00:00:00 GMT - start time for pre sale
569     }
570 
571     function saleEndTime() public constant returns(uint256){
572       return 1539043200;// 2018-10-5 23:59:59 GMT - end time for pre sale
573     }
574     address private dev;
575     uint256 private devSum = 15 ether;
576 
577     constructor(address _token, address _dev, address _beneficiary) public AbstractCrowdsale(_token,_beneficiary) {
578       dev = _dev;
579     }
580 
581     function getCurrentPrice() public constant returns(uint256) {
582         return 3000;
583     }
584 
585     function() public payable {
586       buy();
587       if(softCapInTokens()==0 && token.isWhiteListed(msg.sender)==false){
588         revert('User needs to be immediatly whiteListed in Presale');
589       }
590 
591         if (address(this).balance < devSum) {
592             devSum = devSum - address(this).balance;
593             uint256 tmp = address(this).balance;
594             dev.transfer(tmp);
595 
596         } else {
597             dev.transfer(devSum);
598             emit Stage2(dev,70);
599             devSum = 0;
600         }
601         if(softCapInTokens()==0){
602           beneficiary.transfer(address(this).balance);
603         }
604     }
605 
606 }