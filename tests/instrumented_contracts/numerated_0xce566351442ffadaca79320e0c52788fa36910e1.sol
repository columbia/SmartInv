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
90 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
91 
92 /**
93  * @title Ownable
94  * @dev The Ownable contract has an owner address, and provides basic authorization control
95  * functions, this simplifies the implementation of "user permissions".
96  */
97 contract Ownable {
98   address public owner;
99 
100 
101   event OwnershipRenounced(address indexed previousOwner);
102   event OwnershipTransferred(
103     address indexed previousOwner,
104     address indexed newOwner
105   );
106 
107 
108   /**
109    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
110    * account.
111    */
112   constructor() public {
113     owner = msg.sender;
114   }
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(msg.sender == owner);
121     _;
122   }
123 
124   /**
125    * @dev Allows the current owner to relinquish control of the contract.
126    * @notice Renouncing to ownership will leave the contract without an owner.
127    * It will not be possible to call the functions with the `onlyOwner`
128    * modifier anymore.
129    */
130   function renounceOwnership() public onlyOwner {
131     emit OwnershipRenounced(owner);
132     owner = address(0);
133   }
134 
135   /**
136    * @dev Allows the current owner to transfer control of the contract to a newOwner.
137    * @param _newOwner The address to transfer ownership to.
138    */
139   function transferOwnership(address _newOwner) public onlyOwner {
140     _transferOwnership(_newOwner);
141   }
142 
143   /**
144    * @dev Transfers control of the contract to a newOwner.
145    * @param _newOwner The address to transfer ownership to.
146    */
147   function _transferOwnership(address _newOwner) internal {
148     require(_newOwner != address(0));
149     emit OwnershipTransferred(owner, _newOwner);
150     owner = _newOwner;
151   }
152 }
153 
154 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
155 
156 /**
157  * @title SafeERC20
158  * @dev Wrappers around ERC20 operations that throw on failure.
159  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
160  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
161  */
162 library SafeERC20 {
163   function safeTransfer(
164     ERC20Basic _token,
165     address _to,
166     uint256 _value
167   )
168     internal
169   {
170     require(_token.transfer(_to, _value));
171   }
172 
173   function safeTransferFrom(
174     ERC20 _token,
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     internal
180   {
181     require(_token.transferFrom(_from, _to, _value));
182   }
183 
184   function safeApprove(
185     ERC20 _token,
186     address _spender,
187     uint256 _value
188   )
189     internal
190   {
191     require(_token.approve(_spender, _value));
192   }
193 }
194 
195 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
196 
197 /**
198  * @title Contracts that should be able to recover tokens
199  * @author SylTi
200  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
201  * This will prevent any accidental loss of tokens.
202  */
203 contract CanReclaimToken is Ownable {
204   using SafeERC20 for ERC20Basic;
205 
206   /**
207    * @dev Reclaim all ERC20Basic compatible tokens
208    * @param _token ERC20Basic The address of the token contract
209    */
210   function reclaimToken(ERC20Basic _token) external onlyOwner {
211     uint256 balance = _token.balanceOf(this);
212     _token.safeTransfer(owner, balance);
213   }
214 
215 }
216 
217 // File: contracts/interface/IBasicMultiToken.sol
218 
219 contract IBasicMultiToken is ERC20 {
220     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
221     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
222 
223     function tokensCount() public view returns(uint256);
224     function tokens(uint i) public view returns(ERC20);
225     function bundlingEnabled() public view returns(bool);
226     
227     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
228     function bundle(address _beneficiary, uint256 _amount) public;
229 
230     function unbundle(address _beneficiary, uint256 _value) public;
231     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
232 
233     // Owner methods
234     function disableBundling() public;
235     function enableBundling() public;
236 
237     bytes4 public constant InterfaceId_IBasicMultiToken = 0xd5c368b6;
238       /**
239        * 0xd5c368b6 ===
240        *   bytes4(keccak256('tokensCount()')) ^
241        *   bytes4(keccak256('tokens(uint256)')) ^
242        *   bytes4(keccak256('bundlingEnabled()')) ^
243        *   bytes4(keccak256('bundleFirstTokens(address,uint256,uint256[])')) ^
244        *   bytes4(keccak256('bundle(address,uint256)')) ^
245        *   bytes4(keccak256('unbundle(address,uint256)')) ^
246        *   bytes4(keccak256('unbundleSome(address,uint256,address[])')) ^
247        *   bytes4(keccak256('disableBundling()')) ^
248        *   bytes4(keccak256('enableBundling()'))
249        */
250 }
251 
252 // File: contracts/interface/IMultiToken.sol
253 
254 contract IMultiToken is IBasicMultiToken {
255     event Update();
256     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
257 
258     function weights(address _token) public view returns(uint256);
259     function changesEnabled() public view returns(bool);
260     
261     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
262     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
263 
264     // Owner methods
265     function disableChanges() public;
266 
267     bytes4 public constant InterfaceId_IMultiToken = 0x81624e24;
268       /**
269        * 0x81624e24 ===
270        *   InterfaceId_IBasicMultiToken(0xd5c368b6) ^
271        *   bytes4(keccak256('weights(address)')) ^
272        *   bytes4(keccak256('changesEnabled()')) ^
273        *   bytes4(keccak256('getReturn(address,address,uint256)')) ^
274        *   bytes4(keccak256('change(address,address,uint256,uint256)')) ^
275        *   bytes4(keccak256('disableChanges()'))
276        */
277 }
278 
279 // File: contracts/ext/CheckedERC20.sol
280 
281 library CheckedERC20 {
282     using SafeMath for uint;
283 
284     function isContract(address addr) internal view returns(bool result) {
285         // solium-disable-next-line security/no-inline-assembly
286         assembly {
287             result := gt(extcodesize(addr), 0)
288         }
289     }
290 
291     function handleReturnBool() internal pure returns(bool result) {
292         // solium-disable-next-line security/no-inline-assembly
293         assembly {
294             switch returndatasize()
295             case 0 { // not a std erc20
296                 result := 1
297             }
298             case 32 { // std erc20
299                 returndatacopy(0, 0, 32)
300                 result := mload(0)
301             }
302             default { // anything else, should revert for safety
303                 revert(0, 0)
304             }
305         }
306     }
307 
308     function handleReturnBytes32() internal pure returns(bytes32 result) {
309         // solium-disable-next-line security/no-inline-assembly
310         assembly {
311             switch eq(returndatasize(), 32) // not a std erc20
312             case 1 {
313                 returndatacopy(0, 0, 32)
314                 result := mload(0)
315             }
316 
317             switch gt(returndatasize(), 32) // std erc20
318             case 1 {
319                 returndatacopy(0, 64, 32)
320                 result := mload(0)
321             }
322 
323             switch lt(returndatasize(), 32) // anything else, should revert for safety
324             case 1 {
325                 revert(0, 0)
326             }
327         }
328     }
329 
330     function asmTransfer(address token, address to, uint256 value) internal returns(bool) {
331         require(isContract(token));
332         // solium-disable-next-line security/no-low-level-calls
333         require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, value));
334         return handleReturnBool();
335     }
336 
337     function asmTransferFrom(address token, address from, address to, uint256 value) internal returns(bool) {
338         require(isContract(token));
339         // solium-disable-next-line security/no-low-level-calls
340         require(token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), from, to, value));
341         return handleReturnBool();
342     }
343 
344     function asmApprove(address token, address spender, uint256 value) internal returns(bool) {
345         require(isContract(token));
346         // solium-disable-next-line security/no-low-level-calls
347         require(token.call(bytes4(keccak256("approve(address,uint256)")), spender, value));
348         return handleReturnBool();
349     }
350 
351     //
352 
353     function checkedTransfer(ERC20 token, address to, uint256 value) internal {
354         if (value > 0) {
355             uint256 balance = token.balanceOf(this);
356             asmTransfer(token, to, value);
357             require(token.balanceOf(this) == balance.sub(value), "checkedTransfer: Final balance didn't match");
358         }
359     }
360 
361     function checkedTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
362         if (value > 0) {
363             uint256 toBalance = token.balanceOf(to);
364             asmTransferFrom(token, from, to, value);
365             require(token.balanceOf(to) == toBalance.add(value), "checkedTransfer: Final balance didn't match");
366         }
367     }
368 
369     //
370 
371     function asmName(address token) internal view returns(bytes32) {
372         require(isContract(token));
373         // solium-disable-next-line security/no-low-level-calls
374         require(token.call(bytes4(keccak256("name()"))));
375         return handleReturnBytes32();
376     }
377 
378     function asmSymbol(address token) internal view returns(bytes32) {
379         require(isContract(token));
380         // solium-disable-next-line security/no-low-level-calls
381         require(token.call(bytes4(keccak256("symbol()"))));
382         return handleReturnBytes32();
383     }
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
494         require(fromToken.asmTransfer(target, amount));
495         if (data.length != 0) {
496             // solium-disable-next-line security/no-low-level-calls
497             require(target.call(data));
498         }
499     }
500 
501     function transferTokenProportion(address target, bytes data, ERC20 fromToken, uint256 mul, uint256 div) external {
502         uint256 amount = fromToken.balanceOf(this).mul(mul).div(div);
503         require(fromToken.asmTransfer(target, amount));
504         if (data.length != 0) {
505             // solium-disable-next-line security/no-low-level-calls
506             require(target.call(data));
507         }
508     }
509 
510     function transferTokenProportionToOrigin(ERC20 token, uint256 mul, uint256 div) external {
511         uint256 amount = token.balanceOf(this).mul(mul).div(div);
512         // solium-disable-next-line security/no-tx-origin
513         require(token.asmTransfer(tx.origin, amount));
514     }
515 
516     // Multitoken
517 
518     function multitokenChangeAmount(IMultiToken mtkn, ERC20 fromToken, ERC20 toToken, uint256 minReturn, uint256 amount) external {
519         if (fromToken.allowance(this, mtkn) == 0) {
520             fromToken.asmApprove(mtkn, uint256(-1));
521         }
522         mtkn.change(fromToken, toToken, amount, minReturn);
523     }
524 
525     function multitokenChangeProportion(IMultiToken mtkn, ERC20 fromToken, ERC20 toToken, uint256 minReturn, uint256 mul, uint256 div) external {
526         uint256 amount = fromToken.balanceOf(this).mul(mul).div(div);
527         this.multitokenChangeAmount(mtkn, fromToken, toToken, minReturn, amount);
528     }
529 
530     // Ether token
531 
532     function withdrawEtherTokenAmount(IEtherToken etherToken, uint256 amount) external {
533         etherToken.withdraw(amount);
534     }
535 
536     function withdrawEtherTokenProportion(IEtherToken etherToken, uint256 mul, uint256 div) external {
537         uint256 amount = etherToken.balanceOf(this).mul(mul).div(div);
538         etherToken.withdraw(amount);
539     }
540 
541     // Bancor Network
542 
543     function bancorSendEthValue(IBancorNetwork bancor, address[] path, uint256 value) external {
544         bancor.convert.value(value)(path, value, 1);
545     }
546 
547     function bancorSendEthProportion(IBancorNetwork bancor, address[] path, uint256 mul, uint256 div) external {
548         uint256 value = address(this).balance.mul(mul).div(div);
549         bancor.convert.value(value)(path, value, 1);
550     }
551 
552     function bancorApproveTokenAmount(IBancorNetwork bancor, address[] path, uint256 amount) external {
553         if (ERC20(path[0]).allowance(this, bancor) == 0) {
554             ERC20(path[0]).asmApprove(bancor, uint256(-1));
555         }
556         bancor.claimAndConvert(path, amount, 1);
557     }
558 
559     function bancorApproveTokenProportion(IBancorNetwork bancor, address[] path, uint256 mul, uint256 div) external {
560         uint256 amount = ERC20(path[0]).balanceOf(this).mul(mul).div(div);
561         if (ERC20(path[0]).allowance(this, bancor) == 0) {
562             ERC20(path[0]).asmApprove(bancor, uint256(-1));
563         }
564         bancor.claimAndConvert(path, amount, 1);
565     }
566 
567     function bancorTransferTokenAmount(IBancorNetwork bancor, address[] path, uint256 amount) external {
568         ERC20(path[0]).asmTransfer(bancor, amount);
569         bancor.convert(path, amount, 1);
570     }
571 
572     function bancorTransferTokenProportion(IBancorNetwork bancor, address[] path, uint256 mul, uint256 div) external {
573         uint256 amount = ERC20(path[0]).balanceOf(this).mul(mul).div(div);
574         ERC20(path[0]).asmTransfer(bancor, amount);
575         bancor.convert(path, amount, 1);
576     }
577 
578     function bancorAlreadyTransferedTokenAmount(IBancorNetwork bancor, address[] path, uint256 amount) external {
579         bancor.convert(path, amount, 1);
580     }
581 
582     function bancorAlreadyTransferedTokenProportion(IBancorNetwork bancor, address[] path, uint256 mul, uint256 div) external {
583         uint256 amount = ERC20(path[0]).balanceOf(bancor).mul(mul).div(div);
584         bancor.convert(path, amount, 1);
585     }
586 
587     // Kyber Network
588 
589     function kyberSendEthProportion(IKyberNetworkProxy kyber, ERC20 fromToken, address toToken, uint256 mul, uint256 div) external {
590         uint256 value = address(this).balance.mul(mul).div(div);
591         kyber.trade.value(value)(
592             fromToken,
593             value,
594             toToken,
595             this,
596             1 << 255,
597             0,
598             0
599         );
600     }
601 
602     function kyberApproveTokenAmount(IKyberNetworkProxy kyber, ERC20 fromToken, address toToken, uint256 amount) external {
603         if (fromToken.allowance(this, kyber) == 0) {
604             fromToken.asmApprove(kyber, uint256(-1));
605         }
606         kyber.trade(
607             fromToken,
608             amount,
609             toToken,
610             this,
611             1 << 255,
612             0,
613             0
614         );
615     }
616 
617     function kyberApproveTokenProportion(IKyberNetworkProxy kyber, ERC20 fromToken, address toToken, uint256 mul, uint256 div) external {
618         uint256 amount = fromToken.balanceOf(this).mul(mul).div(div);
619         this.kyberApproveTokenAmount(kyber, fromToken, toToken, amount);
620     }
621 }