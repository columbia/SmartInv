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
124 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
125 
126 /**
127  * @title Ownable
128  * @dev The Ownable contract has an owner address, and provides basic authorization control
129  * functions, this simplifies the implementation of "user permissions".
130  */
131 contract Ownable {
132   address public owner;
133 
134 
135   event OwnershipRenounced(address indexed previousOwner);
136   event OwnershipTransferred(
137     address indexed previousOwner,
138     address indexed newOwner
139   );
140 
141 
142   /**
143    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
144    * account.
145    */
146   constructor() public {
147     owner = msg.sender;
148   }
149 
150   /**
151    * @dev Throws if called by any account other than the owner.
152    */
153   modifier onlyOwner() {
154     require(msg.sender == owner);
155     _;
156   }
157 
158   /**
159    * @dev Allows the current owner to relinquish control of the contract.
160    * @notice Renouncing to ownership will leave the contract without an owner.
161    * It will not be possible to call the functions with the `onlyOwner`
162    * modifier anymore.
163    */
164   function renounceOwnership() public onlyOwner {
165     emit OwnershipRenounced(owner);
166     owner = address(0);
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param _newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address _newOwner) public onlyOwner {
174     _transferOwnership(_newOwner);
175   }
176 
177   /**
178    * @dev Transfers control of the contract to a newOwner.
179    * @param _newOwner The address to transfer ownership to.
180    */
181   function _transferOwnership(address _newOwner) internal {
182     require(_newOwner != address(0));
183     emit OwnershipTransferred(owner, _newOwner);
184     owner = _newOwner;
185   }
186 }
187 
188 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
189 
190 /**
191  * @title SafeERC20
192  * @dev Wrappers around ERC20 operations that throw on failure.
193  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
194  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
195  */
196 library SafeERC20 {
197   function safeTransfer(
198     ERC20Basic _token,
199     address _to,
200     uint256 _value
201   )
202     internal
203   {
204     require(_token.transfer(_to, _value));
205   }
206 
207   function safeTransferFrom(
208     ERC20 _token,
209     address _from,
210     address _to,
211     uint256 _value
212   )
213     internal
214   {
215     require(_token.transferFrom(_from, _to, _value));
216   }
217 
218   function safeApprove(
219     ERC20 _token,
220     address _spender,
221     uint256 _value
222   )
223     internal
224   {
225     require(_token.approve(_spender, _value));
226   }
227 }
228 
229 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
230 
231 /**
232  * @title Contracts that should be able to recover tokens
233  * @author SylTi
234  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
235  * This will prevent any accidental loss of tokens.
236  */
237 contract CanReclaimToken is Ownable {
238   using SafeERC20 for ERC20Basic;
239 
240   /**
241    * @dev Reclaim all ERC20Basic compatible tokens
242    * @param _token ERC20Basic The address of the token contract
243    */
244   function reclaimToken(ERC20Basic _token) external onlyOwner {
245     uint256 balance = _token.balanceOf(this);
246     _token.safeTransfer(owner, balance);
247   }
248 
249 }
250 
251 // File: contracts/ext/CheckedERC20.sol
252 
253 library CheckedERC20 {
254     using SafeMath for uint;
255 
256     function isContract(address addr) internal view returns(bool result) {
257         // solium-disable-next-line security/no-inline-assembly
258         assembly {
259             result := gt(extcodesize(addr), 0)
260         }
261     }
262 
263     function handleReturnBool() internal pure returns(bool result) {
264         // solium-disable-next-line security/no-inline-assembly
265         assembly {
266             switch returndatasize()
267             case 0 { // not a std erc20
268                 result := 1
269             }
270             case 32 { // std erc20
271                 returndatacopy(0, 0, 32)
272                 result := mload(0)
273             }
274             default { // anything else, should revert for safety
275                 revert(0, 0)
276             }
277         }
278     }
279 
280     function handleReturnBytes32() internal pure returns(bytes32 result) {
281         // solium-disable-next-line security/no-inline-assembly
282         assembly {
283             if eq(returndatasize(), 32) { // not a std erc20
284                 returndatacopy(0, 0, 32)
285                 result := mload(0)
286             }
287             if gt(returndatasize(), 32) { // std erc20
288                 returndatacopy(0, 64, 32)
289                 result := mload(0)
290             }
291             if lt(returndatasize(), 32) { // anything else, should revert for safety
292                 revert(0, 0)
293             }
294         }
295     }
296 
297     function asmTransfer(address _token, address _to, uint256 _value) internal returns(bool) {
298         require(isContract(_token));
299         // solium-disable-next-line security/no-low-level-calls
300         require(_token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
301         return handleReturnBool();
302     }
303 
304     function asmTransferFrom(address _token, address _from, address _to, uint256 _value) internal returns(bool) {
305         require(isContract(_token));
306         // solium-disable-next-line security/no-low-level-calls
307         require(_token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
308         return handleReturnBool();
309     }
310 
311     function asmApprove(address _token, address _spender, uint256 _value) internal returns(bool) {
312         require(isContract(_token));
313         // solium-disable-next-line security/no-low-level-calls
314         require(_token.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
315         return handleReturnBool();
316     }
317 
318     //
319 
320     function checkedTransfer(ERC20 _token, address _to, uint256 _value) internal {
321         if (_value > 0) {
322             uint256 balance = _token.balanceOf(this);
323             asmTransfer(_token, _to, _value);
324             require(_token.balanceOf(this) == balance.sub(_value), "checkedTransfer: Final balance didn't match");
325         }
326     }
327 
328     function checkedTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) internal {
329         if (_value > 0) {
330             uint256 toBalance = _token.balanceOf(_to);
331             asmTransferFrom(_token, _from, _to, _value);
332             require(_token.balanceOf(_to) == toBalance.add(_value), "checkedTransfer: Final balance didn't match");
333         }
334     }
335 
336     //
337 
338     function asmName(address _token) internal view returns(bytes32) {
339         require(isContract(_token));
340         // solium-disable-next-line security/no-low-level-calls
341         require(_token.call(bytes4(keccak256("name()"))));
342         return handleReturnBytes32();
343     }
344 
345     function asmSymbol(address _token) internal view returns(bytes32) {
346         require(isContract(_token));
347         // solium-disable-next-line security/no-low-level-calls
348         require(_token.call(bytes4(keccak256("symbol()"))));
349         return handleReturnBytes32();
350     }
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
574     function buy(
575         IMultiToken _mtkn,
576         uint256 _minimumReturn,
577         bytes _callDatas,
578         uint[] _starts // including 0 and LENGTH values
579     )
580         public
581         payable
582     {
583         change(_callDatas, _starts);
584 
585         uint mtknTotalSupply = _mtkn.totalSupply(); // optimization totalSupply
586         uint256 bestAmount = uint256(-1);
587         for (uint i = _mtkn.tokensCount(); i > 0; i--) {
588             ERC20 token = _mtkn.tokens(i - 1);
589             if (token.allowance(this, _mtkn) == 0) {
590                 token.asmApprove(_mtkn, uint256(-1));
591             }
592 
593             uint256 amount = mtknTotalSupply.mul(token.balanceOf(this)).div(token.balanceOf(_mtkn));
594             if (amount < bestAmount) {
595                 bestAmount = amount;
596             }
597         }
598 
599         require(bestAmount >= _minimumReturn, "buy: return value is too low");
600         _mtkn.bundle(msg.sender, bestAmount);
601         if (address(this).balance > 0) {
602             msg.sender.transfer(address(this).balance);
603         }
604         for (i = _mtkn.tokensCount(); i > 0; i--) {
605             token = _mtkn.tokens(i - 1);
606             if (token.balanceOf(this) > 0) {
607                 token.asmTransfer(msg.sender, token.balanceOf(this));
608             }
609         }
610     }
611 
612     function buyFirstTokens(
613         IMultiToken _mtkn,
614         bytes _callDatas,
615         uint[] _starts // including 0 and LENGTH values
616     )
617         public
618         payable
619     {
620         change(_callDatas, _starts);
621 
622         uint tokensCount = _mtkn.tokensCount();
623         uint256[] memory amounts = new uint256[](tokensCount);
624         for (uint i = 0; i < tokensCount; i++) {
625             ERC20 token = _mtkn.tokens(i);
626             amounts[i] = token.balanceOf(this);
627             if (token.allowance(this, _mtkn) == 0) {
628                 token.asmApprove(_mtkn, uint256(-1));
629             }
630         }
631 
632         _mtkn.bundleFirstTokens(msg.sender, msg.value.mul(1000), amounts);
633         if (address(this).balance > 0) {
634             msg.sender.transfer(address(this).balance);
635         }
636         for (i = _mtkn.tokensCount(); i > 0; i--) {
637             token = _mtkn.tokens(i - 1);
638             if (token.balanceOf(this) > 0) {
639                 token.asmTransfer(msg.sender, token.balanceOf(this));
640             }
641         }
642     }
643 }