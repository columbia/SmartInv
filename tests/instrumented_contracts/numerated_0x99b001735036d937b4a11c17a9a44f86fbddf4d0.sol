1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * See https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address _who) public view returns (uint256);
65   function transfer(address _to, uint256 _value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address _owner, address _spender)
77     public view returns (uint256);
78 
79   function transferFrom(address _from, address _to, uint256 _value)
80     public returns (bool);
81 
82   function approve(address _spender, uint256 _value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: contracts/interface/IBasicMultiToken.sol
91 
92 contract IBasicMultiToken is ERC20 {
93     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
94     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
95 
96     ERC20[] public tokens;
97 
98     function tokensCount() public view returns(uint256);
99 
100     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
101     function bundle(address _beneficiary, uint256 _amount) public;
102 
103     function unbundle(address _beneficiary, uint256 _value) public;
104     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
105 
106     function disableBundling() public;
107     function enableBundling() public;
108 }
109 
110 // File: contracts/interface/IMultiToken.sol
111 
112 contract IMultiToken is IBasicMultiToken {
113     event Update();
114     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
115 
116     mapping(address => uint256) public weights;
117 
118     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
119     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
120 
121     function disableChanges() public;
122 }
123 
124 // File: contracts/ext/CheckedERC20.sol
125 
126 library CheckedERC20 {
127     using SafeMath for uint;
128 
129     function isContract(address addr) internal view returns(bool result) {
130         // solium-disable-next-line security/no-inline-assembly
131         assembly {
132             result := gt(extcodesize(addr), 0)
133         }
134     }
135 
136     function handleReturnBool() internal pure returns(bool result) {
137         // solium-disable-next-line security/no-inline-assembly
138         assembly {
139             switch returndatasize()
140             case 0 { // not a std erc20
141                 result := 1
142             }
143             case 32 { // std erc20
144                 returndatacopy(0, 0, 32)
145                 result := mload(0)
146             }
147             default { // anything else, should revert for safety
148                 revert(0, 0)
149             }
150         }
151     }
152 
153     function handleReturnBytes32() internal pure returns(bytes32 result) {
154         // solium-disable-next-line security/no-inline-assembly
155         assembly {
156             if eq(returndatasize(), 32) { // not a std erc20
157                 returndatacopy(0, 0, 32)
158                 result := mload(0)
159             }
160             if gt(returndatasize(), 32) { // std erc20
161                 returndatacopy(0, 64, 32)
162                 result := mload(0)
163             }
164             if lt(returndatasize(), 32) { // anything else, should revert for safety
165                 revert(0, 0)
166             }
167         }
168     }
169 
170     function asmTransfer(address _token, address _to, uint256 _value) internal returns(bool) {
171         require(isContract(_token));
172         // solium-disable-next-line security/no-low-level-calls
173         require(_token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
174         return handleReturnBool();
175     }
176 
177     function asmTransferFrom(address _token, address _from, address _to, uint256 _value) internal returns(bool) {
178         require(isContract(_token));
179         // solium-disable-next-line security/no-low-level-calls
180         require(_token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
181         return handleReturnBool();
182     }
183 
184     function asmApprove(address _token, address _spender, uint256 _value) internal returns(bool) {
185         require(isContract(_token));
186         // solium-disable-next-line security/no-low-level-calls
187         require(_token.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
188         return handleReturnBool();
189     }
190 
191     //
192 
193     function checkedTransfer(ERC20 _token, address _to, uint256 _value) internal {
194         if (_value > 0) {
195             uint256 balance = _token.balanceOf(this);
196             asmTransfer(_token, _to, _value);
197             require(_token.balanceOf(this) == balance.sub(_value), "checkedTransfer: Final balance didn't match");
198         }
199     }
200 
201     function checkedTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) internal {
202         if (_value > 0) {
203             uint256 toBalance = _token.balanceOf(_to);
204             asmTransferFrom(_token, _from, _to, _value);
205             require(_token.balanceOf(_to) == toBalance.add(_value), "checkedTransfer: Final balance didn't match");
206         }
207     }
208 
209     //
210 
211     function asmName(address _token) internal view returns(bytes32) {
212         require(isContract(_token));
213         // solium-disable-next-line security/no-low-level-calls
214         require(_token.call(bytes4(keccak256("name()"))));
215         return handleReturnBytes32();
216     }
217 
218     function asmSymbol(address _token) internal view returns(bytes32) {
219         require(isContract(_token));
220         // solium-disable-next-line security/no-low-level-calls
221         require(_token.call(bytes4(keccak256("symbol()"))));
222         return handleReturnBytes32();
223     }
224 }
225 
226 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
227 
228 /**
229  * @title Ownable
230  * @dev The Ownable contract has an owner address, and provides basic authorization control
231  * functions, this simplifies the implementation of "user permissions".
232  */
233 contract Ownable {
234   address public owner;
235 
236 
237   event OwnershipRenounced(address indexed previousOwner);
238   event OwnershipTransferred(
239     address indexed previousOwner,
240     address indexed newOwner
241   );
242 
243 
244   /**
245    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
246    * account.
247    */
248   constructor() public {
249     owner = msg.sender;
250   }
251 
252   /**
253    * @dev Throws if called by any account other than the owner.
254    */
255   modifier onlyOwner() {
256     require(msg.sender == owner);
257     _;
258   }
259 
260   /**
261    * @dev Allows the current owner to relinquish control of the contract.
262    * @notice Renouncing to ownership will leave the contract without an owner.
263    * It will not be possible to call the functions with the `onlyOwner`
264    * modifier anymore.
265    */
266   function renounceOwnership() public onlyOwner {
267     emit OwnershipRenounced(owner);
268     owner = address(0);
269   }
270 
271   /**
272    * @dev Allows the current owner to transfer control of the contract to a newOwner.
273    * @param _newOwner The address to transfer ownership to.
274    */
275   function transferOwnership(address _newOwner) public onlyOwner {
276     _transferOwnership(_newOwner);
277   }
278 
279   /**
280    * @dev Transfers control of the contract to a newOwner.
281    * @param _newOwner The address to transfer ownership to.
282    */
283   function _transferOwnership(address _newOwner) internal {
284     require(_newOwner != address(0));
285     emit OwnershipTransferred(owner, _newOwner);
286     owner = _newOwner;
287   }
288 }
289 
290 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
291 
292 /**
293  * @title SafeERC20
294  * @dev Wrappers around ERC20 operations that throw on failure.
295  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
296  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
297  */
298 library SafeERC20 {
299   function safeTransfer(
300     ERC20Basic _token,
301     address _to,
302     uint256 _value
303   )
304     internal
305   {
306     require(_token.transfer(_to, _value));
307   }
308 
309   function safeTransferFrom(
310     ERC20 _token,
311     address _from,
312     address _to,
313     uint256 _value
314   )
315     internal
316   {
317     require(_token.transferFrom(_from, _to, _value));
318   }
319 
320   function safeApprove(
321     ERC20 _token,
322     address _spender,
323     uint256 _value
324   )
325     internal
326   {
327     require(_token.approve(_spender, _value));
328   }
329 }
330 
331 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
332 
333 /**
334  * @title Contracts that should be able to recover tokens
335  * @author SylTi
336  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
337  * This will prevent any accidental loss of tokens.
338  */
339 contract CanReclaimToken is Ownable {
340   using SafeERC20 for ERC20Basic;
341 
342   /**
343    * @dev Reclaim all ERC20Basic compatible tokens
344    * @param _token ERC20Basic The address of the token contract
345    */
346   function reclaimToken(ERC20Basic _token) external onlyOwner {
347     uint256 balance = _token.balanceOf(this);
348     _token.safeTransfer(owner, balance);
349   }
350 
351 }
352 
353 // File: contracts/registry/MultiChanger.sol
354 
355 contract IEtherToken is ERC20 {
356     function deposit() public payable;
357     function withdraw(uint256 _amount) public;
358 }
359 
360 
361 contract IBancorNetwork {
362     function convert(
363         address[] _path,
364         uint256 _amount,
365         uint256 _minReturn
366     ) 
367         public
368         payable
369         returns(uint256);
370 
371     function claimAndConvert(
372         address[] _path,
373         uint256 _amount,
374         uint256 _minReturn
375     ) 
376         public
377         payable
378         returns(uint256);
379 }
380 
381 
382 contract IKyberNetworkProxy {
383     function trade(
384         address src,
385         uint srcAmount,
386         address dest,
387         address destAddress,
388         uint maxDestAmount,
389         uint minConversionRate,
390         address walletId
391     )
392         public
393         payable
394         returns(uint);
395 }
396 
397 
398 contract MultiChanger is CanReclaimToken {
399     using SafeMath for uint256;
400     using CheckedERC20 for ERC20;
401 
402     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
403     // call has been separated into its own function in order to take advantage
404     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
405     function externalCall(address destination, uint value, bytes data, uint dataOffset, uint dataLength) internal returns (bool result) {
406         // solium-disable-next-line security/no-inline-assembly
407         assembly {
408             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
409             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
410             result := call(
411                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
412                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
413                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
414                 destination,
415                 value,
416                 add(d, dataOffset),
417                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
418                 x,
419                 0                  // Output is ignored, therefore the output size is zero
420             )
421         }
422     }
423 
424     function change(bytes _callDatas, uint[] _starts) public payable { // _starts should include 0 and _callDatas.length
425         for (uint i = 0; i < _starts.length - 1; i++) {
426             require(externalCall(this, 0, _callDatas, _starts[i], _starts[i + 1] - _starts[i]));
427         }
428     }
429 
430     function sendEthValue(address _target, bytes _data, uint256 _value) external {
431         // solium-disable-next-line security/no-call-value
432         require(_target.call.value(_value)(_data));
433     }
434 
435     function sendEthProportion(address _target, bytes _data, uint256 _mul, uint256 _div) external {
436         uint256 value = address(this).balance.mul(_mul).div(_div);
437         // solium-disable-next-line security/no-call-value
438         require(_target.call.value(value)(_data));
439     }
440 
441     function approveTokenAmount(address _target, bytes _data, ERC20 _fromToken, uint256 _amount) external {
442         if (_fromToken.allowance(this, _target) != 0) {
443             _fromToken.asmApprove(_target, 0);
444         }
445         _fromToken.asmApprove(_target, _amount);
446         // solium-disable-next-line security/no-low-level-calls
447         require(_target.call(_data));
448     }
449 
450     function approveTokenProportion(address _target, bytes _data, ERC20 _fromToken, uint256 _mul, uint256 _div) external {
451         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
452         if (_fromToken.allowance(this, _target) != 0) {
453             _fromToken.asmApprove(_target, 0);
454         }
455         _fromToken.asmApprove(_target, amount);
456         // solium-disable-next-line security/no-low-level-calls
457         require(_target.call(_data));
458     }
459 
460     function transferTokenAmount(address _target, bytes _data, ERC20 _fromToken, uint256 _amount) external {
461         _fromToken.asmTransfer(_target, _amount);
462         if (_target != address(0)) {
463             // solium-disable-next-line security/no-low-level-calls
464             require(_target.call(_data));
465         }
466     }
467 
468     function transferTokenProportion(address _target, bytes _data, ERC20 _fromToken, uint256 _mul, uint256 _div) external {
469         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
470         _fromToken.asmTransfer(_target, amount);
471         if (_target != address(0)) {
472             // solium-disable-next-line security/no-low-level-calls
473             require(_target.call(_data));
474         }
475     }
476 
477     // Multitoken
478 
479     function multitokenChangeAmount(IMultiToken _mtkn, ERC20 _fromToken, ERC20 _toToken, uint256 _minReturn, uint256 _amount) external {
480         if (_fromToken.allowance(this, _mtkn) == 0) {
481             _fromToken.asmApprove(_mtkn, uint256(-1));
482         }
483         _mtkn.change(_fromToken, _toToken, _amount, _minReturn);
484     }
485 
486     function multitokenChangeProportion(IMultiToken _mtkn, ERC20 _fromToken, ERC20 _toToken, uint256 _minReturn, uint256 _mul, uint256 _div) external {
487         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
488         this.multitokenChangeAmount(_mtkn, _fromToken, _toToken, _minReturn, amount);
489     }
490 
491     // Ether token
492 
493     function withdrawEtherTokenAmount(IEtherToken _etherToken, uint256 _amount) external {
494         _etherToken.withdraw(_amount);
495     }
496 
497     function withdrawEtherTokenProportion(IEtherToken _etherToken, uint256 _mul, uint256 _div) external {
498         uint256 amount = _etherToken.balanceOf(this).mul(_mul).div(_div);
499         _etherToken.withdraw(amount);
500     }
501 
502     // Bancor Network
503 
504     function bancorSendEthValue(IBancorNetwork _bancor, address[] _path, uint256 _value) external {
505         _bancor.convert.value(_value)(_path, _value, 1);
506     }
507 
508     function bancorSendEthProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
509         uint256 value = address(this).balance.mul(_mul).div(_div);
510         _bancor.convert.value(value)(_path, value, 1);
511     }
512 
513     function bancorApproveTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
514         if (ERC20(_path[0]).allowance(this, _bancor) == 0) {
515             ERC20(_path[0]).asmApprove(_bancor, uint256(-1));
516         }
517         _bancor.claimAndConvert(_path, _amount, 1);
518     }
519 
520     function bancorApproveTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
521         uint256 amount = ERC20(_path[0]).balanceOf(this).mul(_mul).div(_div);
522         if (ERC20(_path[0]).allowance(this, _bancor) == 0) {
523             ERC20(_path[0]).asmApprove(_bancor, uint256(-1));
524         }
525         _bancor.claimAndConvert(_path, amount, 1);
526     }
527 
528     function bancorTransferTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
529         ERC20(_path[0]).asmTransfer(_bancor, _amount);
530         _bancor.convert(_path, _amount, 1);
531     }
532 
533     function bancorTransferTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
534         uint256 amount = ERC20(_path[0]).balanceOf(this).mul(_mul).div(_div);
535         ERC20(_path[0]).asmTransfer(_bancor, amount);
536         _bancor.convert(_path, amount, 1);
537     }
538 
539     function bancorAlreadyTransferedTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
540         _bancor.convert(_path, _amount, 1);
541     }
542 
543     function bancorAlreadyTransferedTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
544         uint256 amount = ERC20(_path[0]).balanceOf(_bancor).mul(_mul).div(_div);
545         _bancor.convert(_path, amount, 1);
546     }
547 
548     // Kyber Network
549 
550     function kyberSendEthProportion(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _mul, uint256 _div) external {
551         uint256 value = address(this).balance.mul(_mul).div(_div);
552         _kyber.trade.value(value)(
553             _fromToken,
554             value,
555             _toToken,
556             this,
557             1 << 255,
558             0,
559             0
560         );
561     }
562 
563     function kyberApproveTokenAmount(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _amount) external {
564         if (_fromToken.allowance(this, _kyber) == 0) {
565             _fromToken.asmApprove(_kyber, uint256(-1));
566         }
567         _kyber.trade(
568             _fromToken,
569             _amount,
570             _toToken,
571             this,
572             1 << 255,
573             0,
574             0
575         );
576     }
577 
578     function kyberApproveTokenProportion(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _mul, uint256 _div) external {
579         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
580         this.kyberApproveTokenAmount(_kyber, _fromToken, _toToken, amount);
581     }
582 }
583 
584 // File: contracts/registry/MultiSeller.sol
585 
586 contract MultiSeller is MultiChanger {
587     using CheckedERC20 for ERC20;
588     using CheckedERC20 for IMultiToken;
589 
590     function() public payable {
591         // solium-disable-next-line security/no-tx-origin
592         require(tx.origin != msg.sender);
593     }
594 
595     function sellForOrigin(
596         IMultiToken _mtkn,
597         uint256 _amount,
598         bytes _callDatas,
599         uint[] _starts // including 0 and LENGTH values
600     )
601         public
602     {
603         sell(
604             _mtkn,
605             _amount,
606             _callDatas,
607             _starts,
608             tx.origin   // solium-disable-line security/no-tx-origin
609         );
610     }
611 
612     function sell(
613         IMultiToken _mtkn,
614         uint256 _amount,
615         bytes _callDatas,
616         uint[] _starts, // including 0 and LENGTH values
617         address _for
618     )
619         public
620     {
621         _mtkn.asmTransferFrom(msg.sender, this, _amount);
622         _mtkn.unbundle(this, _amount);
623         change(_callDatas, _starts);
624         _for.transfer(address(this).balance);
625     }
626 
627     // DEPRECATED:
628 
629     function sellOnApproveForOrigin(
630         IMultiToken _mtkn,
631         uint256 _amount,
632         ERC20 _throughToken,
633         address[] _exchanges,
634         bytes _datas,
635         uint[] _datasIndexes // including 0 and LENGTH values
636     )
637         public
638     {
639         sellOnApprove(
640             _mtkn,
641             _amount,
642             _throughToken,
643             _exchanges,
644             _datas,
645             _datasIndexes,
646             tx.origin       // solium-disable-line security/no-tx-origin
647         );
648     }
649 
650     function sellOnApprove(
651         IMultiToken _mtkn,
652         uint256 _amount,
653         ERC20 _throughToken,
654         address[] _exchanges,
655         bytes _datas,
656         uint[] _datasIndexes, // including 0 and LENGTH values
657         address _for
658     )
659         public
660     {
661         if (_throughToken == address(0)) {
662             require(_mtkn.tokensCount() == _exchanges.length, "sell: _mtkn should have the same tokens count as _exchanges");
663         } else {
664             require(_mtkn.tokensCount() + 1 == _exchanges.length, "sell: _mtkn should have tokens count + 1 equal _exchanges length");
665         }
666         require(_datasIndexes.length == _exchanges.length + 1, "sell: _datasIndexes should start with 0 and end with LENGTH");
667 
668         _mtkn.transferFrom(msg.sender, this, _amount);
669         _mtkn.unbundle(this, _amount);
670 
671         for (uint i = 0; i < _exchanges.length; i++) {
672             bytes memory data = new bytes(_datasIndexes[i + 1] - _datasIndexes[i]);
673             for (uint j = _datasIndexes[i]; j < _datasIndexes[i + 1]; j++) {
674                 data[j - _datasIndexes[i]] = _datas[j];
675             }
676             if (data.length == 0) {
677                 continue;
678             }
679 
680             if (i == _exchanges.length - 1 && _throughToken != address(0)) {
681                 if (_throughToken.allowance(this, _exchanges[i]) == 0) {
682                     _throughToken.asmApprove(_exchanges[i], uint256(-1));
683                 }
684             } else {
685                 ERC20 token = _mtkn.tokens(i);
686                 if (_exchanges[i] == 0) {
687                     token.asmTransfer(_for, token.balanceOf(this));
688                     continue;
689                 }
690                 if (token.allowance(this, _exchanges[i]) == 0) {
691                     token.asmApprove(_exchanges[i], uint256(-1));
692                 }
693             }
694             // solium-disable-next-line security/no-low-level-calls
695             require(_exchanges[i].call(data), "sell: exchange arbitrary call failed");
696         }
697 
698         _for.transfer(address(this).balance);
699         if (_throughToken != address(0) && _throughToken.balanceOf(this) > 0) {
700             _throughToken.asmTransfer(_for, _throughToken.balanceOf(this));
701         }
702     }
703 }