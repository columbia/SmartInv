1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * Utility library of inline functions on addresses
6  */
7 library AddressUtils {
8 
9   /**
10    * Returns whether the target address is a contract
11    * @dev This function will return false if invoked during the constructor of a contract,
12    * as the code is not actually created until after the constructor finishes.
13    * @param _addr address to check
14    * @return whether the target address is a contract
15    */
16   function isContract(address _addr) internal view returns (bool) {
17     uint256 size;
18     // XXX Currently there is no better way to check if there is a contract in an address
19     // than to check the size of the code at that address.
20     // See https://ethereum.stackexchange.com/a/14016/36603
21     // for more details about how this works.
22     // TODO Check this again before the Serenity release, because all addresses will be
23     // contracts then.
24     // solium-disable-next-line security/no-inline-assembly
25     assembly { size := extcodesize(_addr) }
26     return size > 0;
27   }
28 }
29 
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, throws on overflow.
39   */
40   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
41     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
42     // benefit is lost if 'b' is also tested.
43     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44     if (_a == 0) {
45       return 0;
46     }
47 
48     c = _a * _b;
49     assert(c / _a == _b);
50     return c;
51   }
52 
53   /**
54   * @dev Integer division of two numbers, truncating the quotient.
55   */
56   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
57     // assert(_b > 0); // Solidity automatically throws when dividing by 0
58     // uint256 c = _a / _b;
59     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
60     return _a / _b;
61   }
62 
63   /**
64   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
67     assert(_b <= _a);
68     return _a - _b;
69   }
70 
71   /**
72   * @dev Adds two numbers, throws on overflow.
73   */
74   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
75     c = _a + _b;
76     assert(c >= _a);
77     return c;
78   }
79 }
80 
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract has an owner address, and provides basic authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 contract Ownable {
88   address public owner;
89 
90 
91   event OwnershipRenounced(address indexed previousOwner);
92   event OwnershipTransferred(
93     address indexed previousOwner,
94     address indexed newOwner
95   );
96 
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   constructor() public {
103     owner = msg.sender;
104   }
105 
106   /**
107    * @dev Throws if called by any account other than the owner.
108    */
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113 
114   /**
115    * @dev Allows the current owner to relinquish control of the contract.
116    * @notice Renouncing to ownership will leave the contract without an owner.
117    * It will not be possible to call the functions with the `onlyOwner`
118    * modifier anymore.
119    */
120   function renounceOwnership() public onlyOwner {
121     emit OwnershipRenounced(owner);
122     owner = address(0);
123   }
124 
125   /**
126    * @dev Allows the current owner to transfer control of the contract to a newOwner.
127    * @param _newOwner The address to transfer ownership to.
128    */
129   function transferOwnership(address _newOwner) public onlyOwner {
130     _transferOwnership(_newOwner);
131   }
132 
133   /**
134    * @dev Transfers control of the contract to a newOwner.
135    * @param _newOwner The address to transfer ownership to.
136    */
137   function _transferOwnership(address _newOwner) internal {
138     require(_newOwner != address(0));
139     emit OwnershipTransferred(owner, _newOwner);
140     owner = _newOwner;
141   }
142 }
143 
144 
145 /**
146  * @title Contactable token
147  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
148  * contact information.
149  */
150 contract Contactable is Ownable {
151 
152   string public contactInformation;
153 
154   /**
155     * @dev Allows the owner to set a string with their contact information.
156     * @param _info The contact information to attach to the contract.
157     */
158   function setContactInformation(string _info) public onlyOwner {
159     contactInformation = _info;
160   }
161 }
162 
163 
164 contract IERC223Basic {
165   function balanceOf(address _owner) public constant returns (uint);
166   function transfer(address _to, uint _value) public;
167   function transfer(address _to, uint _value, bytes _data) public;
168   event Transfer(
169     address indexed from,
170     address indexed to,
171     uint value,
172     bytes data
173   );
174 }
175 
176 
177 contract IERC223 is IERC223Basic {
178   function allowance(address _owner, address _spender)
179     public view returns (uint);
180 
181   function transferFrom(address _from, address _to, uint _value, bytes _data)
182     public;
183 
184   function approve(address _spender, uint _value) public;
185   event Approval(address indexed owner, address indexed spender, uint value);
186 }
187 
188 
189 contract IERC223BasicReceiver {
190   function tokenFallback(address _from, uint _value, bytes _data) public;
191 }
192 
193 
194 contract IERC223Receiver is IERC223BasicReceiver {
195   function receiveApproval(address _owner, uint _value) public;
196 }
197 
198 
199 /**
200  * @title Basic contract that will hold ERC223 tokens
201  */
202 contract ERC223BasicReceiver is IERC223BasicReceiver {
203   event TokensReceived(address sender, address origin, uint value, bytes data);
204 
205   /**
206    * @dev Standard ERC223 function that will handle incoming token transfers
207    * @param _from address the tokens owner
208    * @param _value uint the sent tokens amount
209    * @param _data bytes metadata
210    */
211   function tokenFallback(address _from, uint _value, bytes _data) public {
212     require(_from != address(0));
213     emit TokensReceived(msg.sender, _from, _value, _data);
214   }
215 }
216 
217 
218 /**
219  * @title Contract that will hold ERC223 tokens
220  */
221 contract ERC223Receiver is ERC223BasicReceiver, IERC223Receiver {
222   event ApprovalReceived(address sender, address owner, uint value);
223 
224   /**
225    * @dev Function that will handle incoming token approvals
226    * @param _owner address the tokens owner
227    * @param _value uint the approved tokens amount
228    */
229   function receiveApproval(address _owner, uint _value) public {
230     require(_owner != address(0));
231     emit ApprovalReceived(msg.sender, _owner, _value);
232   }
233 }
234 
235 
236 /**
237  * @title Contract that can hold and transfer ERC-223 tokens
238  */
239 contract Fund is ERC223Receiver, Contactable {
240   IERC223 public token;
241   string public fundName;
242 
243   /**
244    * @dev Constructor that sets the initial contract parameters
245    * @param _token ERC223 address of the ERC-223 token
246    * @param _fundName string the fund name
247    */
248   constructor(IERC223 _token, string _fundName) public {
249     require(address(_token) != address(0));
250     token = _token;
251     fundName = _fundName;
252   }
253 
254   /**
255    * @dev ERC-20 compatible function to transfer tokens
256    * @param _to address the tokens recepient
257    * @param _value uint amount of the tokens to be transferred
258    */
259   function transfer(address _to, uint _value) public onlyOwner {
260     token.transfer(_to, _value);
261   }
262 
263   /**
264    * @dev Function to transfer tokens
265    * @param _to address the tokens recepient
266    * @param _value uint amount of the tokens to be transferred
267    * @param _data bytes metadata
268    */
269   function transfer(address _to, uint _value, bytes _data) public onlyOwner {
270     token.transfer(_to, _value, _data);
271   }
272 
273   /**
274    * @dev Function to transfer tokens from the approved `msg.sender` account
275    * @param _from address the tokens owner
276    * @param _to address the tokens recepient
277    * @param _value uint amount of the tokens to be transferred
278    * @param _data bytes metadata
279    */
280   function transferFrom(
281     address _from,
282     address _to,
283     uint _value,
284     bytes _data
285   )
286     public
287     onlyOwner
288   {
289     token.transferFrom(_from, _to, _value, _data);
290   }
291 
292   /**
293    * @dev Function to approve account to spend owned tokens
294    * @param _spender address the tokens spender
295    * @param _value uint amount of the tokens to be approved
296    */
297   function approve(address _spender, uint _value) public onlyOwner {
298     token.approve(_spender, _value);
299   }
300 }
301 
302 
303 /**
304  * @title HEdpAY
305  */
306 contract Hedpay is IERC223, Contactable {
307   using AddressUtils for address;
308   using SafeMath for uint;
309 
310   string public constant name = "HEdpAY";
311   string public constant symbol = "Hdp.ф";
312   uint8 public constant decimals = 4;
313   uint8 public constant secondPhaseBonus = 33;
314   uint8[3] public thirdPhaseBonus = [10, 15, 20];
315   uint public constant totalSupply = 10000000000000;
316   uint public constant secondPhaseStartTime = 1537401600; //20.09.2018
317   uint public constant secondPhaseEndTime = 1540943999; //30.10.2018
318   uint public constant thirdPhaseStartTime = 1540944000;//31.10.2018
319   uint public constant thirdPhaseEndTime = 1543622399;//30.11.2018
320   uint public constant cap = 200000 ether;
321   uint public constant goal = 25000 ether;
322   uint public constant rate = 100;
323   uint public constant minimumWeiAmount = 100 finney;
324   uint public constant salePercent = 14;
325   uint public constant bonusPercent = 1;
326   uint public constant teamPercent = 2;
327   uint public constant preSalePercent = 3;
328 
329   uint public creationTime;
330   uint public weiRaised;
331   uint public tokensSold;
332   uint public buyersCount;
333   uint public saleAmount;
334   uint public bonusAmount;
335   uint public teamAmount;
336   uint public preSaleAmount;
337   uint public unsoldTokens;
338 
339   address public teamAddress = 0x7d4E738477B6e8BaF03c4CB4944446dA690f76B5;
340   
341   Fund public reservedFund;
342 
343   mapping (address => uint) internal balances;
344   mapping (address => mapping (address => uint)) internal allowed;
345   mapping (address => uint) internal bonuses;
346 
347   /**
348    * @dev Constructor that sets initial contract parameters
349    */
350   constructor() public {
351     balances[owner] = totalSupply;
352     creationTime = block.timestamp;
353     saleAmount = totalSupply.div(100).mul(salePercent).mul(
354       10 ** uint(decimals)
355     );
356     bonusAmount = totalSupply.div(100).mul(bonusPercent).mul(
357       10 ** uint(decimals)
358     );
359     teamAmount = totalSupply.div(100).mul(teamPercent).mul(
360       10 ** uint(decimals)
361     );
362     preSaleAmount = totalSupply.div(100).mul(preSalePercent).mul(
363       10 ** uint(decimals)
364     );
365   }
366 
367   /**
368    * @dev Gets an account tokens balance
369    * @param _owner address the tokens owner
370    * @return uint the specified address owned tokens amount
371    */
372   function balanceOf(address _owner) public view returns (uint) {
373     require(_owner != address(0));
374     return balances[_owner];
375   }
376 
377   /**
378    * @dev Gets the specified accounts approval value
379    * @param _owner address the tokens owner
380    * @param _spender address the tokens spender
381    * @return uint the specified accounts spending tokens amount
382    */
383   function allowance(address _owner, address _spender)
384     public view returns (uint)
385   {
386     require(_owner != address(0));
387     require(_spender != address(0));
388     return allowed[_owner][_spender];
389   }
390 
391   /**
392    * @dev Checks whether the ICO has started
393    * @return bool true if the crowdsale began
394    */
395   function hasStarted() public view returns (bool) {
396     return block.timestamp >= secondPhaseStartTime;
397   }
398 
399   /**
400    * @dev Checks whether the ICO has ended
401    * @return bool `true` if the crowdsale is over
402    */
403   function hasEnded() public view returns (bool) {
404     return block.timestamp > thirdPhaseEndTime;
405   }
406 
407   /**
408    * @dev Checks whether the cap has reached
409    * @return bool `true` if the cap has reached
410    */
411   function capReached() public view returns (bool) {
412     return weiRaised >= cap;
413   }
414 
415   /**
416    * @dev Gets the current tokens amount can be purchased for the specified
417    * @dev wei amount
418    * @param _weiAmount uint wei amount
419    * @return uint tokens amount
420    */
421   function getTokenAmount(uint _weiAmount) public pure returns (uint) {
422     return _weiAmount.mul(rate).div((18 - uint(decimals)) ** 10);
423   }
424 
425   /**
426    * @dev Gets the current tokens amount can be purchased for the specified
427    * @dev wei amount (including bonuses)
428    * @param _weiAmount uint wei amount
429    * @return uint tokens amount
430    */
431   function getTokenAmountBonus(uint _weiAmount)
432     public view returns (uint)
433   {
434     if (hasStarted() && secondPhaseEndTime >= block.timestamp) {
435       return(
436         getTokenAmount(_weiAmount).
437         add(
438           getTokenAmount(_weiAmount).
439           div(100).
440           mul(uint(secondPhaseBonus))
441         )
442       );
443     } else if (thirdPhaseStartTime <= block.timestamp && !hasEnded()) {
444       if (_weiAmount > 0 && _weiAmount < 2500 finney) {
445         return(
446           getTokenAmount(_weiAmount).
447           add(
448             getTokenAmount(_weiAmount).
449             div(100).
450             mul(uint(thirdPhaseBonus[0]))
451           )
452         );
453       } else if (_weiAmount >= 2510 finney && _weiAmount < 10000 finney) {
454         return(
455           getTokenAmount(_weiAmount).
456           add(
457             getTokenAmount(_weiAmount).
458             div(100).
459             mul(uint(thirdPhaseBonus[1]))
460           )
461         );
462       } else if (_weiAmount >= 10000 finney) {
463         return(
464           getTokenAmount(_weiAmount).
465           add(
466             getTokenAmount(_weiAmount).
467             div(100).
468             mul(uint(thirdPhaseBonus[2]))
469           )
470         );
471       }
472     } else {
473       return getTokenAmount(_weiAmount);
474     }
475   }
476 
477   /**
478    * @dev Gets an account tokens bonus
479    * @param _owner address the tokens owner
480    * @return uint owned tokens bonus
481    */
482   function bonusOf(address _owner) public view returns (uint) {
483     require(_owner != address(0));
484     return bonuses[_owner];
485   }
486 
487   /**
488    * @dev Gets an account tokens balance without freezed part of the bonuses
489    * @param _owner address the tokens owner
490    * @return uint owned tokens amount without freezed bonuses
491    */
492   function balanceWithoutFreezedBonus(address _owner)
493     public view returns (uint)
494   {
495     require(_owner != address(0));
496     if (block.timestamp >= thirdPhaseEndTime.add(90 days)) {
497       if (bonusOf(_owner) < 10000) {
498         return balanceOf(_owner);
499       } else {
500         return balanceOf(_owner).sub(bonuses[_owner].div(2));
501       }
502     } else if (block.timestamp >= thirdPhaseEndTime.add(180 days)) {
503       return balanceOf(_owner);
504     } else {
505       return balanceOf(_owner).sub(bonuses[_owner]);
506     }
507   }
508 
509   /**
510    * @dev ERC-20 compatible function to transfer tokens
511    * @param _to address the tokens recepient
512    * @param _value uint amount of the tokens to be transferred
513    */
514   function transfer(address _to, uint _value) public {
515     transfer(_to, _value, "");
516   }
517 
518   /**
519    * @dev Function to transfer tokens
520    * @param _to address the tokens recepient
521    * @param _value uint amount of the tokens to be transferred
522    * @param _data bytes metadata
523    */
524   function transfer(address _to, uint _value, bytes _data) public {
525     require(_value <= balanceWithoutFreezedBonus(msg.sender));
526     require(_to != address(0));
527 
528     balances[msg.sender] = balances[msg.sender].sub(_value);
529     balances[_to] = balances[_to].add(_value);
530     _safeTransfer(msg.sender, _to, _value, _data);
531 
532     emit Transfer(msg.sender, _to, _value, _data);
533   }
534 
535   /**
536    * @dev Function to transfer tokens from the approved `msg.sender` account
537    * @param _from address the tokens owner
538    * @param _to address the tokens recepient
539    * @param _value uint amount of the tokens to be transferred
540    * @param _data bytes metadata
541    */
542   function transferFrom(
543     address _from,
544     address _to,
545     uint _value,
546     bytes _data
547   )
548     public
549   {
550     require(_from != address(0));
551     require(_to != address(0));
552     require(_value <= allowance(_from, msg.sender));
553 
554     balances[_from] = balances[_from].sub(_value);
555     balances[_to] = balances[_to].add(_value);
556     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
557     _safeTransfer(_from, _to, _value, _data);
558 
559     emit Transfer(_from, _to, _value, _data);
560     emit Approval(_from, msg.sender, allowance(_from, msg.sender));
561   }
562 
563   /**
564    * @dev Function to approve account to spend owned tokens
565    * @param _spender address the tokens spender
566    * @param _value uint amount of the tokens to be approved
567    */
568   function approve(address _spender, uint _value) public {
569     require(_spender != address(0));
570     require(_value <= balanceWithoutFreezedBonus(msg.sender));
571     allowed[msg.sender][_spender] = _value;
572     _safeApprove(_spender, _value);
573     emit Approval(msg.sender, _spender, _value);
574   }
575 
576   /**
577    * @dev Function to increase spending tokens amount
578    * @param _spender address the tokens spender
579    * @param _value uint increase tokens amount
580    */
581   function increaseApproval(address _spender, uint _value) public {
582     require(_spender != address(0));
583     require(
584       allowance(msg.sender, _spender).add(_value) <=
585       balanceWithoutFreezedBonus(msg.sender)
586     );
587 
588     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_value);
589     _safeApprove(_spender, allowance(msg.sender, _spender));
590     emit Approval(msg.sender, _spender, allowance(msg.sender, _spender));
591   }
592 
593   /**
594    * @dev Function to decrease spending tokens amount
595    * @param _spender address the tokens spender
596    * @param _value uint decrease tokens amount
597    */
598   function decreaseApproval(address _spender, uint _value) public {
599     require(_spender != address(0));
600     require(_value <= allowance(msg.sender, _spender));
601     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_value);
602     _safeApprove(_spender, allowance(msg.sender, _spender));
603     emit Approval(msg.sender, _spender, allowance(msg.sender, _spender));
604   }
605 
606   /**
607    * @dev Function to set an account bonus
608    * @param _owner address the tokens owner
609    * @param _value uint bonus tokens amount
610    */
611   function setBonus(address _owner, uint _value, bool preSale)
612     public onlyOwner
613   {
614     require(_owner != address(0));
615     require(_value <= balanceOf(_owner));
616     require(bonusAmount > 0);
617     require(_value <= bonusAmount);
618 
619     bonuses[_owner] = _value;
620     if (preSale) {
621       preSaleAmount = preSaleAmount.sub(_value);
622       transfer(_owner, _value, abi.encode("transfer the bonus"));
623     } else {
624       if (_value <= bonusAmount) {
625         bonusAmount = bonusAmount.sub(_value);
626         transfer(_owner, _value, abi.encode("transfer the bonus"));
627       }
628     }
629 
630   }
631 
632   /**
633    * @dev Function to refill balance of the specified account
634    * @param _to address the tokens recepient
635    * @param _weiAmount uint amount of the tokens to be transferred
636    */
637   function refill(address _to, uint _weiAmount) public onlyOwner {
638     require(_preValidateRefill(_to, _weiAmount));
639     setBonus(
640       _to,
641       getTokenAmountBonus(_weiAmount).sub(
642         getTokenAmount(_weiAmount)
643       ),
644       false
645     );
646     buyersCount = buyersCount.add(1);
647     saleAmount = saleAmount.sub(getTokenAmount(_weiAmount));
648     transfer(_to, getTokenAmount(_weiAmount), abi.encode("refill"));
649   }
650 
651   /**
652    * @dev Function to refill balances of the specified accounts
653    * @param _to address[] the tokens recepients
654    * @param _weiAmount uint[] amounts of the tokens to be transferred
655    */
656   function refillArray(address[] _to, uint[] _weiAmount) public onlyOwner {
657     require(_to.length == _weiAmount.length);
658     for (uint i = 0; i < _to.length; i++) {
659       refill(_to[i], _weiAmount[i]);
660     }
661   }
662   
663   /**
664    * @dev Function that transfers tokens to team address
665    */
666   function setTeamFund() public onlyOwner{
667     transfer(
668       teamAddress,
669       teamAmount,
670       abi.encode("transfer reserved for team tokens to the team fund")
671       );
672     teamAmount = 0;
673   }
674 
675   /**
676    * @dev Function to finalize the sale and define reservedFund
677    * @param _reservedFund fund that holds unsold tokens 
678    */
679   function finalize(Fund _reservedFund) public onlyOwner {
680     require(saleAmount > 0);
681     transfer(
682       address(_reservedFund),
683       saleAmount,
684       abi.encode("transfer reserved for team tokens to the team fund")
685     );
686     saleAmount = 0;
687   }
688 
689   /**
690    * @dev Internal function to call the `tokenFallback` if the tokens
691    * @dev recepient is the smart-contract. If the contract doesn't implement
692    * @dev this function transaction fails
693    * @param _from address the tokens owner
694    * @param _to address the tokens recepient (perhaps the contract)
695    * @param _value uint amount of the tokens to be transferred
696    * @param _data bytes metadata
697    */
698   function _safeTransfer(
699     address _from,
700     address _to,
701     uint _value,
702     bytes _data
703   )
704     internal
705   {
706     if (_to.isContract()) {
707       IERC223BasicReceiver receiver = IERC223BasicReceiver(_to);
708       receiver.tokenFallback(_from, _value, _data);
709     }
710   }
711 
712   /**
713    * @dev Internal function to call the `receiveApproval` if the tokens
714    * @dev recepient is the smart-contract. If the contract doesn't implement
715    * @dev this function transaction fails
716    * @param _spender address the tokens recepient (perhaps the contract)
717    * @param _value uint amount of the tokens to be approved
718    */
719   function _safeApprove(address _spender, uint _value) internal {
720     if (_spender.isContract()) {
721       IERC223Receiver receiver = IERC223Receiver(_spender);
722       receiver.receiveApproval(msg.sender, _value);
723     }
724   }
725 
726   /**
727    * @dev Internal function to prevalidate refill before execution
728    * @param _to address the tokens recepient
729    * @param _weiAmount uint amount of the tokens to be transferred
730    * @return bool `true` if the refill can be executed
731    */
732   function _preValidateRefill(address _to, uint _weiAmount)
733     internal view returns (bool)
734   {
735     return(
736       hasStarted() && _weiAmount > 0 &&  weiRaised.add(_weiAmount) <= cap
737       && _to != address(0) && _weiAmount >= minimumWeiAmount &&
738       getTokenAmount(_weiAmount) <= saleAmount
739     );
740   }
741 }