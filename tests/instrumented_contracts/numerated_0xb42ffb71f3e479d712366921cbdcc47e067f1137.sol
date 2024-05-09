1 pragma solidity 0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 /**
113  * @title ERC20Basic
114  * @dev Simpler version of ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/179
116  */
117 contract ERC20Basic {
118   function totalSupply() public view returns (uint256);
119   function balanceOf(address who) public view returns (uint256);
120   function transfer(address to, uint256 value) public returns (bool);
121   event Transfer(address indexed from, address indexed to, uint256 value);
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender)
130     public view returns (uint256);
131 
132   function transferFrom(address from, address to, uint256 value)
133     public returns (bool);
134 
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(
137     address indexed owner,
138     address indexed spender,
139     uint256 value
140   );
141 }
142 
143 /**
144  * @title EIP20/ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract EIP20 is ERC20 {
148     string public name;
149     uint8 public decimals;
150     string public symbol;
151 }
152 
153 interface NonCompliantEIP20 {
154     function transfer(address _to, uint _value) external;
155     function transferFrom(address _from, address _to, uint _value) external;
156     function approve(address _spender, uint _value) external;
157 }
158 
159 /**
160  * @title EIP20/ERC20 wrapper that will support noncompliant ERC20s
161  * @dev see https://github.com/ethereum/EIPs/issues/20
162  * @dev see https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
163  */
164 contract EIP20Wrapper {
165 
166     function eip20Transfer(
167         address token,
168         address to,
169         uint256 value)
170         internal
171         returns (bool result) {
172 
173         NonCompliantEIP20(token).transfer(to, value);
174 
175         assembly {
176             switch returndatasize()   
177             case 0 {                        // non compliant ERC20
178                 result := not(0)            // result is true
179             }
180             case 32 {                       // compliant ERC20
181                 returndatacopy(0, 0, 32) 
182                 result := mload(0)          // result == returndata of external call
183             }
184             default {                       // not an not an ERC20 token
185                 revert(0, 0) 
186             }
187         }
188 
189         require(result, "eip20Transfer failed");
190     }
191 
192     function eip20TransferFrom(
193         address token,
194         address from,
195         address to,
196         uint256 value)
197         internal
198         returns (bool result) {
199 
200         NonCompliantEIP20(token).transferFrom(from, to, value);
201 
202         assembly {
203             switch returndatasize()   
204             case 0 {                        // non compliant ERC20
205                 result := not(0)            // result is true
206             }
207             case 32 {                       // compliant ERC20
208                 returndatacopy(0, 0, 32) 
209                 result := mload(0)          // result == returndata of external call
210             }
211             default {                       // not an not an ERC20 token
212                 revert(0, 0) 
213             }
214         }
215 
216         require(result, "eip20TransferFrom failed");
217     }
218 
219     function eip20Approve(
220         address token,
221         address spender,
222         uint256 value)
223         internal
224         returns (bool result) {
225 
226         NonCompliantEIP20(token).approve(spender, value);
227 
228         assembly {
229             switch returndatasize()   
230             case 0 {                        // non compliant ERC20
231                 result := not(0)            // result is true
232             }
233             case 32 {                       // compliant ERC20
234                 returndatacopy(0, 0, 32) 
235                 result := mload(0)          // result == returndata of external call
236             }
237             default {                       // not an not an ERC20 token
238                 revert(0, 0) 
239             }
240         }
241 
242         require(result, "eip20Approve failed");
243     }
244 }
245 
246 // This provides a gatekeeping modifier for functions that can only be used by the bZx contract
247 // Since it inherits Ownable provides typical ownership functionality with a slight modification to the transferOwnership function
248 // Setting owner and bZxContractAddress to the same address is not supported.
249 contract BZxOwnable is Ownable {
250 
251     address public bZxContractAddress;
252 
253     event BZxOwnershipTransferred(address indexed previousBZxContract, address indexed newBZxContract);
254 
255     // modifier reverts if bZxContractAddress isn't set
256     modifier onlyBZx() {
257         require(msg.sender == bZxContractAddress, "only bZx contracts can call this function");
258         _;
259     }
260 
261     /**
262     * @dev Allows the current owner to transfer the bZx contract owner to a new contract address
263     * @param newBZxContractAddress The bZx contract address to transfer ownership to.
264     */
265     function transferBZxOwnership(address newBZxContractAddress) public onlyOwner {
266         require(newBZxContractAddress != address(0) && newBZxContractAddress != owner, "transferBZxOwnership::unauthorized");
267         emit BZxOwnershipTransferred(bZxContractAddress, newBZxContractAddress);
268         bZxContractAddress = newBZxContractAddress;
269     }
270 
271     /**
272     * @dev Allows the current owner to transfer control of the contract to a newOwner.
273     * @param newOwner The address to transfer ownership to.
274     * This overrides transferOwnership in Ownable to prevent setting the new owner the same as the bZxContract
275     */
276     function transferOwnership(address newOwner) public onlyOwner {
277         require(newOwner != address(0) && newOwner != bZxContractAddress, "transferOwnership::unauthorized");
278         emit OwnershipTransferred(owner, newOwner);
279         owner = newOwner;
280     }
281 }
282 
283 interface ExchangeInterface {
284     event LogError(uint8 indexed errorId, bytes32 indexed orderHash);
285 
286     function fillOrder(
287           address[5] orderAddresses,
288           uint[6] orderValues,
289           uint fillTakerTokenAmount,
290           bool shouldThrowOnInsufficientBalanceOrAllowance,
291           uint8 v,
292           bytes32 r,
293           bytes32 s)
294           external
295           returns (uint filledTakerTokenAmount);
296 
297     function fillOrdersUpTo(
298         address[5][] orderAddresses,
299         uint[6][] orderValues,
300         uint fillTakerTokenAmount,
301         bool shouldThrowOnInsufficientBalanceOrAllowance,
302         uint8[] v,
303         bytes32[] r,
304         bytes32[] s)
305         external
306         returns (uint);
307 
308     function isValidSignature(
309         address signer,
310         bytes32 hash,
311         uint8 v,
312         bytes32 r,
313         bytes32 s)
314         external
315         constant
316         returns (bool);
317 }
318 
319 contract BZxTo0x is EIP20Wrapper, BZxOwnable {
320     using SafeMath for uint256;
321 
322     address public exchangeContract;
323     address public zrxTokenContract;
324     address public tokenTransferProxyContract;
325 
326     constructor(
327         address _exchange, 
328         address _zrxToken,
329         address _proxy) 
330         public 
331     {
332         exchangeContract = _exchange;
333         zrxTokenContract = _zrxToken;
334         tokenTransferProxyContract = _proxy;
335     }
336 
337     function() 
338         public {
339         revert();
340     }
341 
342    function take0xTrade(
343         address trader,
344         address vaultAddress,
345         uint sourceTokenAmountToUse,
346         bytes orderData0x, // 0x order arguments, converted to hex, padded to 32 bytes and concatenated
347         bytes signature0x) // ECDSA of the 0x order
348         public
349         onlyBZx
350         returns (
351             address destTokenAddress,
352             uint destTokenAmount,
353             uint sourceTokenUsedAmount)
354     {
355         (address[5][] memory orderAddresses0x, uint[6][] memory orderValues0x) = getOrderValuesFromData(orderData0x);
356 
357         (sourceTokenUsedAmount, destTokenAmount) = _take0xTrade(
358             trader,
359             sourceTokenAmountToUse,
360             orderAddresses0x,
361             orderValues0x,
362             signature0x);
363 
364         if (sourceTokenUsedAmount < sourceTokenAmountToUse) {
365             // all sourceToken has to be traded
366             revert("BZxTo0x::take0xTrade: sourceTokenUsedAmount < sourceTokenAmountToUse");
367         }
368 
369         // transfer the destToken to the vault
370         eip20Transfer(
371             orderAddresses0x[0][2],
372             vaultAddress,
373             destTokenAmount);
374 
375         destTokenAddress = orderAddresses0x[0][2]; // makerToken (aka destTokenAddress)
376     }
377 
378     function getOrderValuesFromData(
379         bytes orderData0x)
380         public
381         pure
382         returns (
383             address[5][] orderAddresses,
384             uint[6][] orderValues) 
385     {
386         address maker;
387         address taker;
388         address makerToken;
389         address takerToken;
390         address feeRecipient;
391         uint makerTokenAmount;
392         uint takerTokenAmount;
393         uint makerFee;
394         uint takerFee;
395         uint expirationTimestampInSec;
396         uint salt;
397         orderAddresses = new address[5][](orderData0x.length/352);
398         orderValues = new uint[6][](orderData0x.length/352);
399         for (uint i = 0; i < orderData0x.length/352; i++) {
400             assembly {
401                 maker := mload(add(orderData0x, add(mul(i, 352), 32)))
402                 taker := mload(add(orderData0x, add(mul(i, 352), 64)))
403                 makerToken := mload(add(orderData0x, add(mul(i, 352), 96)))
404                 takerToken := mload(add(orderData0x, add(mul(i, 352), 128)))
405                 feeRecipient := mload(add(orderData0x, add(mul(i, 352), 160)))
406                 makerTokenAmount := mload(add(orderData0x, add(mul(i, 352), 192)))
407                 takerTokenAmount := mload(add(orderData0x, add(mul(i, 352), 224)))
408                 makerFee := mload(add(orderData0x, add(mul(i, 352), 256)))
409                 takerFee := mload(add(orderData0x, add(mul(i, 352), 288)))
410                 expirationTimestampInSec := mload(add(orderData0x, add(mul(i, 352), 320)))
411                 salt := mload(add(orderData0x, add(mul(i, 352), 352)))
412             }
413             orderAddresses[i] = [
414                 maker,
415                 taker,
416                 makerToken,
417                 takerToken,
418                 feeRecipient
419             ];
420             orderValues[i] = [
421                 makerTokenAmount,
422                 takerTokenAmount,
423                 makerFee,
424                 takerFee,
425                 expirationTimestampInSec,
426                 salt
427             ];
428         }
429     }
430 
431     /// @param signatures ECDSA signatures in raw bytes (rsv).
432     function getSignatureParts(
433         bytes signatures)
434         public
435         pure
436         returns (
437             uint8[] vs,
438             bytes32[] rs,
439             bytes32[] ss)
440     {
441         vs = new uint8[](signatures.length/65);
442         rs = new bytes32[](signatures.length/65);
443         ss = new bytes32[](signatures.length/65);
444         for (uint i = 0; i < signatures.length/65; i++) {
445             uint8 v;
446             bytes32 r;
447             bytes32 s;
448             assembly {
449                 r := mload(add(signatures, add(mul(i, 65), 32)))
450                 s := mload(add(signatures, add(mul(i, 65), 64)))
451                 v := mload(add(signatures, add(mul(i, 65), 65)))
452             }
453             if (v < 27) {
454                 v = v + 27;
455             }
456             vs[i] = v;
457             rs[i] = r;
458             ss[i] = s;
459         }
460     }
461 
462     /// @dev Calculates partial value given a numerator and denominator.
463     /// @param numerator Numerator.
464     /// @param denominator Denominator.
465     /// @param target Value to calculate partial of.
466     /// @return Partial value of target.
467     function getPartialAmount(uint numerator, uint denominator, uint target)
468         public
469         pure
470         returns (uint)
471     {
472         return SafeMath.div(SafeMath.mul(numerator, target), denominator);
473     }
474 
475     function set0xExchange (
476         address _exchange)
477         public
478         onlyOwner
479     {
480         exchangeContract = _exchange;
481     }
482 
483     function setZRXToken (
484         address _zrxToken)
485         public
486         onlyOwner
487     {
488         zrxTokenContract = _zrxToken;
489     }
490 
491     function set0xTokenProxy (
492         address _proxy)
493         public
494         onlyOwner
495     {
496         tokenTransferProxyContract = _proxy;
497     }
498 
499     function approveFor (
500         address token,
501         address spender,
502         uint value)
503         public
504         onlyOwner
505         returns (bool)
506     {
507         eip20Approve(
508             token,
509             spender,
510             value);
511 
512         return true;
513     }
514 
515     function _take0xTrade(
516         address trader,
517         uint sourceTokenAmountToUse,
518         address[5][] orderAddresses0x,
519         uint[6][] orderValues0x,
520         bytes signature)
521         internal
522         returns (uint sourceTokenUsedAmount, uint destTokenAmount) 
523     {
524         uint[3] memory summations; // takerTokenAmountTotal, makerTokenAmountTotal, zrxTokenAmount
525 
526         for (uint i = 0; i < orderAddresses0x.length; i++) {
527             summations[0] += orderValues0x[0][1]; // takerTokenAmountTotal
528             summations[1] += orderValues0x[0][0]; // makerTokenAmountTotal
529             
530             if (orderAddresses0x[i][4] != address(0) && // feeRecipient
531                     orderValues0x[i][3] > 0 // takerFee
532             ) {
533                 summations[2] += orderValues0x[i][3]; // zrxTokenAmount
534             }
535         }
536         if (summations[2] > 0) {
537             // The 0x TokenTransferProxy already has unlimited transfer allowance for ZRX from this contract (set during deployment of this contract)
538             eip20TransferFrom(
539                 zrxTokenContract,
540                 trader,
541                 this,
542                 summations[2]);
543         }
544 
545         (uint8[] memory v, bytes32[] memory r, bytes32[] memory s) = getSignatureParts(signature);
546 
547         // Increase the allowance for 0x Exchange Proxy to transfer the sourceToken needed for the 0x trade
548         // orderAddresses0x[0][3] -> takerToken/sourceToken
549         eip20Approve(
550             orderAddresses0x[0][3],
551             tokenTransferProxyContract,
552             EIP20(orderAddresses0x[0][3]).allowance(this, tokenTransferProxyContract).add(sourceTokenAmountToUse));
553 
554         if (orderAddresses0x.length > 0) {
555             sourceTokenUsedAmount = ExchangeInterface(exchangeContract).fillOrdersUpTo(
556                 orderAddresses0x,
557                 orderValues0x,
558                 sourceTokenAmountToUse,
559                 false, // shouldThrowOnInsufficientBalanceOrAllowance
560                 v,
561                 r,
562                 s);
563         } else {
564             sourceTokenUsedAmount = ExchangeInterface(exchangeContract).fillOrder(
565                 orderAddresses0x[0],
566                 orderValues0x[0],
567                 sourceTokenAmountToUse,
568                 false, // shouldThrowOnInsufficientBalanceOrAllowance
569                 v[0],
570                 r[0],
571                 s[0]);
572         }
573 
574         destTokenAmount = getPartialAmount(
575             sourceTokenUsedAmount,
576             summations[0], // takerTokenAmountTotal (aka sourceTokenAmount)
577             summations[1]  // makerTokenAmountTotal (aka destTokenAmount)
578         );
579     }
580 }