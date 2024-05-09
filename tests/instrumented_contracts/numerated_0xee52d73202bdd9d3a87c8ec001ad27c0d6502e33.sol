1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address _owner, address _spender)
25     public view returns (uint256);
26 
27   function transferFrom(address _from, address _to, uint256 _value)
28     public returns (bool);
29 
30   function approve(address _spender, uint256 _value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: contracts/interface/IBasicMultiToken.sol
39 
40 contract IBasicMultiToken is ERC20 {
41     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
42     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
43 
44     ERC20[] public tokens;
45 
46     function tokensCount() public view returns(uint256);
47 
48     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
49     function bundle(address _beneficiary, uint256 _amount) public;
50 
51     function unbundle(address _beneficiary, uint256 _value) public;
52     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
53 
54     function disableBundling() public;
55     function enableBundling() public;
56 }
57 
58 // File: contracts/interface/IMultiToken.sol
59 
60 contract IMultiToken is IBasicMultiToken {
61     event Update();
62     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
63 
64     mapping(address => uint256) public weights;
65 
66     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
67     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
68 
69     function disableChanges() public;
70 }
71 
72 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79 
80   /**
81   * @dev Multiplies two numbers, throws on overflow.
82   */
83   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
84     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
85     // benefit is lost if 'b' is also tested.
86     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87     if (_a == 0) {
88       return 0;
89     }
90 
91     c = _a * _b;
92     assert(c / _a == _b);
93     return c;
94   }
95 
96   /**
97   * @dev Integer division of two numbers, truncating the quotient.
98   */
99   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
100     // assert(_b > 0); // Solidity automatically throws when dividing by 0
101     // uint256 c = _a / _b;
102     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
103     return _a / _b;
104   }
105 
106   /**
107   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
108   */
109   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
110     assert(_b <= _a);
111     return _a - _b;
112   }
113 
114   /**
115   * @dev Adds two numbers, throws on overflow.
116   */
117   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
118     c = _a + _b;
119     assert(c >= _a);
120     return c;
121   }
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
424     function change(
425         bytes _callDatas,
426         uint[] _starts // including 0 and LENGTH values
427     )
428         internal
429     {
430         for (uint i = 0; i < _starts.length - 1; i++) {
431             require(externalCall(this, 0, _callDatas, _starts[i], _starts[i + 1] - _starts[i]));
432         }
433     }
434 
435     function sendEthValue(address _target, bytes _data, uint256 _value) external {
436         // solium-disable-next-line security/no-call-value
437         require(_target.call.value(_value)(_data));
438     }
439 
440     function sendEthProportion(address _target, bytes _data, uint256 _mul, uint256 _div) external {
441         uint256 value = address(this).balance.mul(_mul).div(_div);
442         // solium-disable-next-line security/no-call-value
443         require(_target.call.value(value)(_data));
444     }
445 
446     function approveTokenAmount(address _target, bytes _data, ERC20 _fromToken, uint256 _amount) external {
447         if (_fromToken.allowance(this, _target) != 0) {
448             _fromToken.asmApprove(_target, 0);
449         }
450         _fromToken.asmApprove(_target, _amount);
451         // solium-disable-next-line security/no-low-level-calls
452         require(_target.call(_data));
453     }
454 
455     function approveTokenProportion(address _target, bytes _data, ERC20 _fromToken, uint256 _mul, uint256 _div) external {
456         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
457         if (_fromToken.allowance(this, _target) != 0) {
458             _fromToken.asmApprove(_target, 0);
459         }
460         _fromToken.asmApprove(_target, amount);
461         // solium-disable-next-line security/no-low-level-calls
462         require(_target.call(_data));
463     }
464 
465     function transferTokenAmount(address _target, bytes _data, ERC20 _fromToken, uint256 _amount) external {
466         _fromToken.asmTransfer(_target, _amount);
467         // solium-disable-next-line security/no-low-level-calls
468         require(_target.call(_data));
469     }
470 
471     function transferTokenProportion(address _target, bytes _data, ERC20 _fromToken, uint256 _mul, uint256 _div) external {
472         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
473         _fromToken.asmTransfer(_target, amount);
474         // solium-disable-next-line security/no-low-level-calls
475         require(_target.call(_data));
476     }
477 
478     // Ether token
479 
480     function withdrawEtherTokenAmount(IEtherToken _etherToken, uint256 _amount) external {
481         _etherToken.withdraw(_amount);
482     }
483 
484     function withdrawEtherTokenProportion(IEtherToken _etherToken, uint256 _mul, uint256 _div) external {
485         uint256 amount = _etherToken.balanceOf(this).mul(_mul).div(_div);
486         _etherToken.withdraw(amount);
487     }
488 
489     // Bancor Network
490 
491     function bancorSendEthValue(IBancorNetwork _bancor, address[] _path, uint256 _value) external {
492         _bancor.convert.value(_value)(_path, _value, 1);
493     }
494 
495     function bancorSendEthProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
496         uint256 value = address(this).balance.mul(_mul).div(_div);
497         _bancor.convert.value(value)(_path, value, 1);
498     }
499 
500     function bancorApproveTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
501         if (ERC20(_path[0]).allowance(this, _bancor) == 0) {
502             ERC20(_path[0]).asmApprove(_bancor, uint256(-1));
503         }
504         _bancor.claimAndConvert(_path, _amount, 1);
505     }
506 
507     function bancorApproveTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
508         uint256 amount = ERC20(_path[0]).balanceOf(this).mul(_mul).div(_div);
509         if (ERC20(_path[0]).allowance(this, _bancor) == 0) {
510             ERC20(_path[0]).asmApprove(_bancor, uint256(-1));
511         }
512         _bancor.claimAndConvert(_path, amount, 1);
513     }
514 
515     function bancorTransferTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
516         ERC20(_path[0]).asmTransfer(_bancor, _amount);
517         _bancor.convert(_path, _amount, 1);
518     }
519 
520     function bancorTransferTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
521         uint256 amount = ERC20(_path[0]).balanceOf(this).mul(_mul).div(_div);
522         ERC20(_path[0]).asmTransfer(_bancor, amount);
523         _bancor.convert(_path, amount, 1);
524     }
525 
526     function bancorAlreadyTransferedTokenAmount(IBancorNetwork _bancor, address[] _path, uint256 _amount) external {
527         _bancor.convert(_path, _amount, 1);
528     }
529 
530     function bancorAlreadyTransferedTokenProportion(IBancorNetwork _bancor, address[] _path, uint256 _mul, uint256 _div) external {
531         uint256 amount = ERC20(_path[0]).balanceOf(_bancor).mul(_mul).div(_div);
532         _bancor.convert(_path, amount, 1);
533     }
534 
535     // Kyber Network
536 
537     function kyberSendEthProportion(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _mul, uint256 _div) external {
538         uint256 value = address(this).balance.mul(_mul).div(_div);
539         _kyber.trade.value(value)(
540             _fromToken,
541             value,
542             _toToken,
543             this,
544             1 << 255,
545             0,
546             0
547         );
548     }
549 
550     function kyberApproveTokenAmount(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _amount) external {
551         if (_fromToken.allowance(this, _kyber) == 0) {
552             _fromToken.asmApprove(_kyber, uint256(-1));
553         }
554         _kyber.trade(
555             _fromToken,
556             _amount,
557             _toToken,
558             this,
559             1 << 255,
560             0,
561             0
562         );
563     }
564 
565     function kyberApproveTokenProportion(IKyberNetworkProxy _kyber, ERC20 _fromToken, address _toToken, uint256 _mul, uint256 _div) external {
566         uint256 amount = _fromToken.balanceOf(this).mul(_mul).div(_div);
567         this.kyberApproveTokenAmount(_kyber, _fromToken, _toToken, amount);
568     }
569 }
570 
571 // File: contracts/registry/MultiBuyer.sol
572 
573 contract MultiBuyer is MultiChanger {
574     using CheckedERC20 for ERC20;
575 
576     function buy(
577         IMultiToken _mtkn,
578         uint256 _minimumReturn,
579         bytes _callDatas,
580         uint[] _starts // including 0 and LENGTH values
581     )
582         public
583         payable
584     {
585         change(_callDatas, _starts);
586 
587         uint mtknTotalSupply = _mtkn.totalSupply(); // optimization totalSupply
588         uint256 bestAmount = uint256(-1);
589         for (uint i = _mtkn.tokensCount(); i > 0; i--) {
590             ERC20 token = _mtkn.tokens(i - 1);
591             if (token.allowance(this, _mtkn) == 0) {
592                 token.asmApprove(_mtkn, uint256(-1));
593             }
594 
595             uint256 amount = mtknTotalSupply.mul(token.balanceOf(this)).div(token.balanceOf(_mtkn));
596             if (amount < bestAmount) {
597                 bestAmount = amount;
598             }
599         }
600 
601         require(bestAmount >= _minimumReturn, "buy: return value is too low");
602         _mtkn.bundle(msg.sender, bestAmount);
603         if (address(this).balance > 0) {
604             msg.sender.transfer(address(this).balance);
605         }
606         for (i = _mtkn.tokensCount(); i > 0; i--) {
607             token = _mtkn.tokens(i - 1);
608             if (token.balanceOf(this) > 0) {
609                 token.asmTransfer(msg.sender, token.balanceOf(this));
610             }
611         }
612     }
613 
614     function buyFirstTokens(
615         IMultiToken _mtkn,
616         bytes _callDatas,
617         uint[] _starts // including 0 and LENGTH values
618     )
619         public
620         payable
621     {
622         change(_callDatas, _starts);
623 
624         uint tokensCount = _mtkn.tokensCount();
625         uint256[] memory amounts = new uint256[](tokensCount);
626         for (uint i = 0; i < tokensCount; i++) {
627             ERC20 token = _mtkn.tokens(i);
628             amounts[i] = token.balanceOf(this);
629             if (token.allowance(this, _mtkn) == 0) {
630                 token.asmApprove(_mtkn, uint256(-1));
631             }
632         }
633 
634         _mtkn.bundleFirstTokens(msg.sender, msg.value.mul(1000), amounts);
635         if (address(this).balance > 0) {
636             msg.sender.transfer(address(this).balance);
637         }
638         for (i = _mtkn.tokensCount(); i > 0; i--) {
639             token = _mtkn.tokens(i - 1);
640             if (token.balanceOf(this) > 0) {
641                 token.asmTransfer(msg.sender, token.balanceOf(this));
642             }
643         }
644     }
645 
646     // DEPRECATED:
647 
648     function buyOnApprove(
649         IMultiToken _mtkn,
650         uint256 _minimumReturn,
651         ERC20 _throughToken,
652         address[] _exchanges,
653         bytes _datas,
654         uint[] _datasIndexes, // including 0 and LENGTH values
655         uint256[] _values
656     )
657         public
658         payable
659     {
660         require(_datasIndexes.length == _exchanges.length + 1, "buy: _datasIndexes should start with 0 and end with LENGTH");
661         require(_values.length == _exchanges.length, "buy: _values should have the same length as _exchanges");
662 
663         for (uint i = 0; i < _exchanges.length; i++) {
664             bytes memory data = new bytes(_datasIndexes[i + 1] - _datasIndexes[i]);
665             for (uint j = _datasIndexes[i]; j < _datasIndexes[i + 1]; j++) {
666                 data[j - _datasIndexes[i]] = _datas[j];
667             }
668 
669             if (_throughToken != address(0) && _values[i] == 0) {
670                 if (_throughToken.allowance(this, _exchanges[i]) == 0) {
671                     _throughToken.asmApprove(_exchanges[i], uint256(-1));
672                 }
673                 require(_exchanges[i].call(data), "buy: exchange arbitrary call failed");
674             } else {
675                 require(_exchanges[i].call.value(_values[i])(data), "buy: exchange arbitrary call failed");
676             }
677         }
678 
679         j = _mtkn.totalSupply(); // optimization totalSupply
680         uint256 bestAmount = uint256(-1);
681         for (i = _mtkn.tokensCount(); i > 0; i--) {
682             ERC20 token = _mtkn.tokens(i - 1);
683             if (token.allowance(this, _mtkn) == 0) {
684                 token.asmApprove(_mtkn, uint256(-1));
685             }
686 
687             uint256 amount = j.mul(token.balanceOf(this)).div(token.balanceOf(_mtkn));
688             if (amount < bestAmount) {
689                 bestAmount = amount;
690             }
691         }
692 
693         require(bestAmount >= _minimumReturn, "buy: return value is too low");
694         _mtkn.bundle(msg.sender, bestAmount);
695         if (address(this).balance > 0) {
696             msg.sender.transfer(address(this).balance);
697         }
698         if (_throughToken != address(0) && _throughToken.balanceOf(this) > 0) {
699             _throughToken.asmTransfer(msg.sender, _throughToken.balanceOf(this));
700         }
701     }
702 }