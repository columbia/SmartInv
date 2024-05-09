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
44     function tokensCount() public view returns(uint256);
45     function tokens(uint i) public view returns(ERC20);
46     function bundlingEnabled() public view returns(bool);
47     
48     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
49     function bundle(address _beneficiary, uint256 _amount) public;
50 
51     function unbundle(address _beneficiary, uint256 _value) public;
52     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
53 
54     // Owner methods
55     function disableBundling() public;
56     function enableBundling() public;
57 
58     bytes4 public constant InterfaceId_IBasicMultiToken = 0xd5c368b6;
59 	  /**
60 	   * 0xd5c368b6 ===
61 	   *   bytes4(keccak256('tokensCount()')) ^
62 	   *   bytes4(keccak256('tokens(uint256)')) ^
63        *   bytes4(keccak256('bundlingEnabled()')) ^
64        *   bytes4(keccak256('bundleFirstTokens(address,uint256,uint256[])')) ^
65        *   bytes4(keccak256('bundle(address,uint256)')) ^
66        *   bytes4(keccak256('unbundle(address,uint256)')) ^
67        *   bytes4(keccak256('unbundleSome(address,uint256,address[])')) ^
68        *   bytes4(keccak256('disableBundling()')) ^
69        *   bytes4(keccak256('enableBundling()'))
70 	   */
71 }
72 
73 // File: contracts/interface/IMultiToken.sol
74 
75 contract IMultiToken is IBasicMultiToken {
76     event Update();
77     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
78 
79     function weights(address _token) public view returns(uint256);
80     function changesEnabled() public view returns(bool);
81     
82     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
83     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
84 
85     // Owner methods
86     function disableChanges() public;
87 
88     bytes4 public constant InterfaceId_IMultiToken = 0x81624e24;
89 	  /**
90 	   * 0x81624e24 ===
91        *   InterfaceId_IBasicMultiToken(0xd5c368b6) ^
92 	   *   bytes4(keccak256('weights(address)')) ^
93        *   bytes4(keccak256('changesEnabled()')) ^
94        *   bytes4(keccak256('getReturn(address,address,uint256)')) ^
95 	   *   bytes4(keccak256('change(address,address,uint256,uint256)')) ^
96        *   bytes4(keccak256('disableChanges()'))
97 	   */
98 }
99 
100 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
101 
102 /**
103  * @title SafeMath
104  * @dev Math operations with safety checks that throw on error
105  */
106 library SafeMath {
107 
108   /**
109   * @dev Multiplies two numbers, throws on overflow.
110   */
111   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
112     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
113     // benefit is lost if 'b' is also tested.
114     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
115     if (_a == 0) {
116       return 0;
117     }
118 
119     c = _a * _b;
120     assert(c / _a == _b);
121     return c;
122   }
123 
124   /**
125   * @dev Integer division of two numbers, truncating the quotient.
126   */
127   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
128     // assert(_b > 0); // Solidity automatically throws when dividing by 0
129     // uint256 c = _a / _b;
130     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
131     return _a / _b;
132   }
133 
134   /**
135   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
136   */
137   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
138     assert(_b <= _a);
139     return _a - _b;
140   }
141 
142   /**
143   * @dev Adds two numbers, throws on overflow.
144   */
145   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
146     c = _a + _b;
147     assert(c >= _a);
148     return c;
149   }
150 }
151 
152 // File: contracts/ext/CheckedERC20.sol
153 
154 library CheckedERC20 {
155     using SafeMath for uint;
156 
157     function isContract(address addr) internal view returns(bool result) {
158         // solium-disable-next-line security/no-inline-assembly
159         assembly {
160             result := gt(extcodesize(addr), 0)
161         }
162     }
163 
164     function handleReturnBool() internal pure returns(bool result) {
165         // solium-disable-next-line security/no-inline-assembly
166         assembly {
167             switch returndatasize()
168             case 0 { // not a std erc20
169                 result := 1
170             }
171             case 32 { // std erc20
172                 returndatacopy(0, 0, 32)
173                 result := mload(0)
174             }
175             default { // anything else, should revert for safety
176                 revert(0, 0)
177             }
178         }
179     }
180 
181     function handleReturnBytes32() internal pure returns(bytes32 result) {
182         // solium-disable-next-line security/no-inline-assembly
183         assembly {
184             switch eq(returndatasize(), 32) // not a std erc20
185             case 1 {
186                 returndatacopy(0, 0, 32)
187                 result := mload(0)
188             }
189 
190             switch gt(returndatasize(), 32) // std erc20
191             case 1 {
192                 returndatacopy(0, 64, 32)
193                 result := mload(0)
194             }
195 
196             switch lt(returndatasize(), 32) // anything else, should revert for safety
197             case 1 {
198                 revert(0, 0)
199             }
200         }
201     }
202 
203     function asmTransfer(address token, address to, uint256 value) internal returns(bool) {
204         require(isContract(token));
205         // solium-disable-next-line security/no-low-level-calls
206         require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, value));
207         return handleReturnBool();
208     }
209 
210     function asmTransferFrom(address token, address from, address to, uint256 value) internal returns(bool) {
211         require(isContract(token));
212         // solium-disable-next-line security/no-low-level-calls
213         require(token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), from, to, value));
214         return handleReturnBool();
215     }
216 
217     function asmApprove(address token, address spender, uint256 value) internal returns(bool) {
218         require(isContract(token));
219         // solium-disable-next-line security/no-low-level-calls
220         require(token.call(bytes4(keccak256("approve(address,uint256)")), spender, value));
221         return handleReturnBool();
222     }
223 
224     //
225 
226     function checkedTransfer(ERC20 token, address to, uint256 value) internal {
227         if (value > 0) {
228             uint256 balance = token.balanceOf(this);
229             asmTransfer(token, to, value);
230             require(token.balanceOf(this) == balance.sub(value), "checkedTransfer: Final balance didn't match");
231         }
232     }
233 
234     function checkedTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
235         if (value > 0) {
236             uint256 toBalance = token.balanceOf(to);
237             asmTransferFrom(token, from, to, value);
238             require(token.balanceOf(to) == toBalance.add(value), "checkedTransfer: Final balance didn't match");
239         }
240     }
241 
242     //
243 
244     function asmName(address token) internal view returns(bytes32) {
245         require(isContract(token));
246         // solium-disable-next-line security/no-low-level-calls
247         require(token.call(bytes4(keccak256("name()"))));
248         return handleReturnBytes32();
249     }
250 
251     function asmSymbol(address token) internal view returns(bytes32) {
252         require(isContract(token));
253         // solium-disable-next-line security/no-low-level-calls
254         require(token.call(bytes4(keccak256("symbol()"))));
255         return handleReturnBytes32();
256     }
257 }
258 
259 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
260 
261 /**
262  * @title Ownable
263  * @dev The Ownable contract has an owner address, and provides basic authorization control
264  * functions, this simplifies the implementation of "user permissions".
265  */
266 contract Ownable {
267   address public owner;
268 
269 
270   event OwnershipRenounced(address indexed previousOwner);
271   event OwnershipTransferred(
272     address indexed previousOwner,
273     address indexed newOwner
274   );
275 
276 
277   /**
278    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
279    * account.
280    */
281   constructor() public {
282     owner = msg.sender;
283   }
284 
285   /**
286    * @dev Throws if called by any account other than the owner.
287    */
288   modifier onlyOwner() {
289     require(msg.sender == owner);
290     _;
291   }
292 
293   /**
294    * @dev Allows the current owner to relinquish control of the contract.
295    * @notice Renouncing to ownership will leave the contract without an owner.
296    * It will not be possible to call the functions with the `onlyOwner`
297    * modifier anymore.
298    */
299   function renounceOwnership() public onlyOwner {
300     emit OwnershipRenounced(owner);
301     owner = address(0);
302   }
303 
304   /**
305    * @dev Allows the current owner to transfer control of the contract to a newOwner.
306    * @param _newOwner The address to transfer ownership to.
307    */
308   function transferOwnership(address _newOwner) public onlyOwner {
309     _transferOwnership(_newOwner);
310   }
311 
312   /**
313    * @dev Transfers control of the contract to a newOwner.
314    * @param _newOwner The address to transfer ownership to.
315    */
316   function _transferOwnership(address _newOwner) internal {
317     require(_newOwner != address(0));
318     emit OwnershipTransferred(owner, _newOwner);
319     owner = _newOwner;
320   }
321 }
322 
323 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
324 
325 /**
326  * @title SafeERC20
327  * @dev Wrappers around ERC20 operations that throw on failure.
328  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
329  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
330  */
331 library SafeERC20 {
332   function safeTransfer(
333     ERC20Basic _token,
334     address _to,
335     uint256 _value
336   )
337     internal
338   {
339     require(_token.transfer(_to, _value));
340   }
341 
342   function safeTransferFrom(
343     ERC20 _token,
344     address _from,
345     address _to,
346     uint256 _value
347   )
348     internal
349   {
350     require(_token.transferFrom(_from, _to, _value));
351   }
352 
353   function safeApprove(
354     ERC20 _token,
355     address _spender,
356     uint256 _value
357   )
358     internal
359   {
360     require(_token.approve(_spender, _value));
361   }
362 }
363 
364 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
365 
366 /**
367  * @title Contracts that should be able to recover tokens
368  * @author SylTi
369  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
370  * This will prevent any accidental loss of tokens.
371  */
372 contract CanReclaimToken is Ownable {
373   using SafeERC20 for ERC20Basic;
374 
375   /**
376    * @dev Reclaim all ERC20Basic compatible tokens
377    * @param _token ERC20Basic The address of the token contract
378    */
379   function reclaimToken(ERC20Basic _token) external onlyOwner {
380     uint256 balance = _token.balanceOf(this);
381     _token.safeTransfer(owner, balance);
382   }
383 
384 }
385 
386 // File: contracts/network/MultiChanger.sol
387 
388 contract IEtherToken is ERC20 {
389     function deposit() public payable;
390     function withdraw(uint256 amount) public;
391 }
392 
393 
394 contract IBancorNetwork {
395     function convert(
396         address[] path,
397         uint256 amount,
398         uint256 minReturn
399     )
400         public
401         payable
402         returns(uint256);
403 
404     function claimAndConvert(
405         address[] path,
406         uint256 amount,
407         uint256 minReturn
408     )
409         public
410         payable
411         returns(uint256);
412 }
413 
414 
415 contract IKyberNetworkProxy {
416     function trade(
417         address src,
418         uint srcAmount,
419         address dest,
420         address destAddress,
421         uint maxDestAmount,
422         uint minConversionRate,
423         address walletId
424     )
425         public
426         payable
427         returns(uint);
428 }
429 
430 
431 contract MultiChanger is CanReclaimToken {
432     using SafeMath for uint256;
433     using CheckedERC20 for ERC20;
434 
435     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
436     // call has been separated into its own function in order to take advantage
437     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
438     function externalCall(address destination, uint value, bytes data, uint dataOffset, uint dataLength) internal returns (bool result) {
439         // solium-disable-next-line security/no-inline-assembly
440         assembly {
441             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
442             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
443             result := call(
444                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
445                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
446                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
447                 destination,
448                 value,
449                 add(d, dataOffset),
450                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
451                 x,
452                 0                  // Output is ignored, therefore the output size is zero
453             )
454         }
455     }
456 
457     function change(bytes callDatas, uint[] starts) public payable { // starts should include 0 and callDatas.length
458         for (uint i = 0; i < starts.length - 1; i++) {
459             require(externalCall(this, 0, callDatas, starts[i], starts[i + 1] - starts[i]));
460         }
461     }
462 
463     function sendEthValue(address target, bytes data, uint256 value) external {
464         // solium-disable-next-line security/no-call-value
465         require(target.call.value(value)(data));
466     }
467 
468     function sendEthProportion(address target, bytes data, uint256 mul, uint256 div) external {
469         uint256 value = address(this).balance.mul(mul).div(div);
470         // solium-disable-next-line security/no-call-value
471         require(target.call.value(value)(data));
472     }
473 
474     function approveTokenAmount(address target, bytes data, ERC20 fromToken, uint256 amount) external {
475         if (fromToken.allowance(this, target) != 0) {
476             fromToken.asmApprove(target, 0);
477         }
478         fromToken.asmApprove(target, amount);
479         // solium-disable-next-line security/no-low-level-calls
480         require(target.call(data));
481     }
482 
483     function approveTokenProportion(address target, bytes data, ERC20 fromToken, uint256 mul, uint256 div) external {
484         uint256 amount = fromToken.balanceOf(this).mul(mul).div(div);
485         if (fromToken.allowance(this, target) != 0) {
486             fromToken.asmApprove(target, 0);
487         }
488         fromToken.asmApprove(target, amount);
489         // solium-disable-next-line security/no-low-level-calls
490         require(target.call(data));
491     }
492 
493     function transferTokenAmount(address target, bytes data, ERC20 fromToken, uint256 amount) external {
494         fromToken.asmTransfer(target, amount);
495         if (target != address(0)) {
496             // solium-disable-next-line security/no-low-level-calls
497             require(target.call(data));
498         }
499     }
500 
501     function transferTokenProportion(address target, bytes data, ERC20 fromToken, uint256 mul, uint256 div) external {
502         uint256 amount = fromToken.balanceOf(this).mul(mul).div(div);
503         fromToken.asmTransfer(target, amount);
504         if (target != address(0)) {
505             // solium-disable-next-line security/no-low-level-calls
506             require(target.call(data));
507         }
508     }
509 
510     // Multitoken
511 
512     function multitokenChangeAmount(IMultiToken mtkn, ERC20 fromToken, ERC20 toToken, uint256 minReturn, uint256 amount) external {
513         if (fromToken.allowance(this, mtkn) == 0) {
514             fromToken.asmApprove(mtkn, uint256(-1));
515         }
516         mtkn.change(fromToken, toToken, amount, minReturn);
517     }
518 
519     function multitokenChangeProportion(IMultiToken mtkn, ERC20 fromToken, ERC20 toToken, uint256 minReturn, uint256 mul, uint256 div) external {
520         uint256 amount = fromToken.balanceOf(this).mul(mul).div(div);
521         this.multitokenChangeAmount(mtkn, fromToken, toToken, minReturn, amount);
522     }
523 
524     // Ether token
525 
526     function withdrawEtherTokenAmount(IEtherToken etherToken, uint256 amount) external {
527         etherToken.withdraw(amount);
528     }
529 
530     function withdrawEtherTokenProportion(IEtherToken etherToken, uint256 mul, uint256 div) external {
531         uint256 amount = etherToken.balanceOf(this).mul(mul).div(div);
532         etherToken.withdraw(amount);
533     }
534 
535     // Bancor Network
536 
537     function bancorSendEthValue(IBancorNetwork bancor, address[] path, uint256 value) external {
538         bancor.convert.value(value)(path, value, 1);
539     }
540 
541     function bancorSendEthProportion(IBancorNetwork bancor, address[] path, uint256 mul, uint256 div) external {
542         uint256 value = address(this).balance.mul(mul).div(div);
543         bancor.convert.value(value)(path, value, 1);
544     }
545 
546     function bancorApproveTokenAmount(IBancorNetwork bancor, address[] path, uint256 amount) external {
547         if (ERC20(path[0]).allowance(this, bancor) == 0) {
548             ERC20(path[0]).asmApprove(bancor, uint256(-1));
549         }
550         bancor.claimAndConvert(path, amount, 1);
551     }
552 
553     function bancorApproveTokenProportion(IBancorNetwork bancor, address[] path, uint256 mul, uint256 div) external {
554         uint256 amount = ERC20(path[0]).balanceOf(this).mul(mul).div(div);
555         if (ERC20(path[0]).allowance(this, bancor) == 0) {
556             ERC20(path[0]).asmApprove(bancor, uint256(-1));
557         }
558         bancor.claimAndConvert(path, amount, 1);
559     }
560 
561     function bancorTransferTokenAmount(IBancorNetwork bancor, address[] path, uint256 amount) external {
562         ERC20(path[0]).asmTransfer(bancor, amount);
563         bancor.convert(path, amount, 1);
564     }
565 
566     function bancorTransferTokenProportion(IBancorNetwork bancor, address[] path, uint256 mul, uint256 div) external {
567         uint256 amount = ERC20(path[0]).balanceOf(this).mul(mul).div(div);
568         ERC20(path[0]).asmTransfer(bancor, amount);
569         bancor.convert(path, amount, 1);
570     }
571 
572     function bancorAlreadyTransferedTokenAmount(IBancorNetwork bancor, address[] path, uint256 amount) external {
573         bancor.convert(path, amount, 1);
574     }
575 
576     function bancorAlreadyTransferedTokenProportion(IBancorNetwork bancor, address[] path, uint256 mul, uint256 div) external {
577         uint256 amount = ERC20(path[0]).balanceOf(bancor).mul(mul).div(div);
578         bancor.convert(path, amount, 1);
579     }
580 
581     // Kyber Network
582 
583     function kyberSendEthProportion(IKyberNetworkProxy kyber, ERC20 fromToken, address toToken, uint256 mul, uint256 div) external {
584         uint256 value = address(this).balance.mul(mul).div(div);
585         kyber.trade.value(value)(
586             fromToken,
587             value,
588             toToken,
589             this,
590             1 << 255,
591             0,
592             0
593         );
594     }
595 
596     function kyberApproveTokenAmount(IKyberNetworkProxy kyber, ERC20 fromToken, address toToken, uint256 amount) external {
597         if (fromToken.allowance(this, kyber) == 0) {
598             fromToken.asmApprove(kyber, uint256(-1));
599         }
600         kyber.trade(
601             fromToken,
602             amount,
603             toToken,
604             this,
605             1 << 255,
606             0,
607             0
608         );
609     }
610 
611     function kyberApproveTokenProportion(IKyberNetworkProxy kyber, ERC20 fromToken, address toToken, uint256 mul, uint256 div) external {
612         uint256 amount = fromToken.balanceOf(this).mul(mul).div(div);
613         this.kyberApproveTokenAmount(kyber, fromToken, toToken, amount);
614     }
615 }
616 
617 // File: contracts/network/MultiBuyer.sol
618 
619 contract MultiBuyer is MultiChanger {
620     using CheckedERC20 for ERC20;
621 
622     function buy(
623         IMultiToken mtkn,
624         uint256 minimumReturn,
625         bytes callDatas,
626         uint[] starts // including 0 and LENGTH values
627     )
628         public
629         payable
630     {
631         change(callDatas, starts);
632 
633         uint mtknTotalSupply = mtkn.totalSupply(); // optimization totalSupply
634         uint256 bestAmount = uint256(-1);
635         for (uint i = mtkn.tokensCount(); i > 0; i--) {
636             ERC20 token = mtkn.tokens(i - 1);
637             if (token.allowance(this, mtkn) == 0) {
638                 token.asmApprove(mtkn, uint256(-1));
639             }
640 
641             uint256 amount = mtknTotalSupply.mul(token.balanceOf(this)).div(token.balanceOf(mtkn));
642             if (amount < bestAmount) {
643                 bestAmount = amount;
644             }
645         }
646 
647         require(bestAmount >= minimumReturn, "buy: return value is too low");
648         mtkn.bundle(msg.sender, bestAmount);
649         if (address(this).balance > 0) {
650             msg.sender.transfer(address(this).balance);
651         }
652         for (i = mtkn.tokensCount(); i > 0; i--) {
653             token = mtkn.tokens(i - 1);
654             if (token.balanceOf(this) > 0) {
655                 token.asmTransfer(msg.sender, token.balanceOf(this));
656             }
657         }
658     }
659 
660     function buyFirstTokens(
661         IMultiToken mtkn,
662         bytes callDatas,
663         uint[] starts, // including 0 and LENGTH values
664         uint ethPriceMul,
665         uint ethPriceDiv
666     )
667         public
668         payable
669     {
670         change(callDatas, starts);
671 
672         uint tokensCount = mtkn.tokensCount();
673         uint256[] memory amounts = new uint256[](tokensCount);
674         for (uint i = 0; i < tokensCount; i++) {
675             ERC20 token = mtkn.tokens(i);
676             amounts[i] = token.balanceOf(this);
677             if (token.allowance(this, mtkn) == 0) {
678                 token.asmApprove(mtkn, uint256(-1));
679             }
680         }
681 
682         mtkn.bundleFirstTokens(msg.sender, msg.value.mul(ethPriceMul).div(ethPriceDiv), amounts);
683         if (address(this).balance > 0) {
684             msg.sender.transfer(address(this).balance);
685         }
686         for (i = mtkn.tokensCount(); i > 0; i--) {
687             token = mtkn.tokens(i - 1);
688             if (token.balanceOf(this) > 0) {
689                 token.asmTransfer(msg.sender, token.balanceOf(this));
690             }
691         }
692     }
693 }