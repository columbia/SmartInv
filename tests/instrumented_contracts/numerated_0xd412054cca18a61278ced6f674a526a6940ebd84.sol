1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-30
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0
6 //
7 // Original work by Pine.Finance
8 //  - https://github.com/pine-finance
9 //
10 // Authors:
11 //  - Ignacio Mazzara <@nachomazzara>
12 //  - Agustin Aguilar <@agusx1211>
13 
14 //
15 //                                                                                                    
16 //                                                /                                                   
17 //                                                @,                                                  
18 //                                               /&&                                                  
19 //                                              &&%%&/                                                
20 //                                            &%%%%&%%,..                                             
21 //                                         */%&,*&&&&&&%%&*                                           
22 //                                           /&%%%%%%%#.                                              
23 //                                    ./%&%%%&#/%%%%&#&%%%&#(*.                                       
24 //                                         .%%%%%%%&&%&/ ..,...                                       
25 //                                       .*,%%%%%%%%%&&%%%%(                                          
26 //                                     ,&&%%%&&*%%%%%%%%.*(#%&/                                       
27 //                                  ./,(*,*,#%%%%%%%%%%%%%%%(,                                        
28 //                                 ,(%%%%%%%%%%%%&%%%%%%%%%#&&%%%#/(*                                 
29 //                                     *#%%%%%%%&%%%&%%#%%%%%%(                                       
30 //                              .(####%%&%&#*&%%##%%%%%%%%%%%#.,,                                     
31 //                                      ,&%%%%%###%%%%%%%%%%%%#&&.                                    
32 //                             ..,(&%%%%%%%%%%%%%%%%%%&&%%%%#%&&%&%%%%&&#,                            
33 //                           ,##//%((#*/#%%%%%%%%%%%%%%%%%%%%%&(.                                     
34 //                                  (%%%%%%%%%%%%%%%%%%%#%%%%%%%%%&&&&#(*,                            
35 //                                   ./%%%%&%%%%#%&%%%%%%##%%&&&&%%(*,                                
36 //                                #%%%%%%&&%%%#%%%%%%%%%%%%%%%&#,*&&#.                                
37 //                            /%##%(%&/ #%%%%%%%%%%%%%%%%%%%%%%%%%&%%%.                               
38 //                                 *&%%%%&%%%%%%%%#%%%%%%%%%%%%%%%%%&%%%#%#%%,                        
39 //                        .*(#&%%%%%%%%&&%%%%%%%%%%#%%%%%%%%%%%%%%%(,                                 
40 //                    ./#%%%%%%%%%%%%%%%%%%%%%%%#%&%#%%%%%%%%%%%%%%%%%%%%&%%%#####(.                  
41 //                          .,,*#%%%%%%%%%%%%%##%%&&%#%%%%%%%%&&%%%%%%(&*#&**/(*                      
42 //                        .,(&%%%%%#((%%%%%%#%%%%%%%%%#%%%%%%%&&&&&%%%%&%*                            
43 //                         ,,,,,..*&%%%%%%%%%%%%%%%%%%%%%%%&%%%%%%%%%#/*.                             
44 //                           ,#&%%%%%%%%%%%%%%%%%%%%%%%%&%%%%%%%%%%%%%%%%%%/,                         
45 //           .     .,*(#%%%%%%%%%&&&&%%%%%%&&&%%%%%%%%%&&%##%%%%%#,(%%%%%%%%%%%(((*                   
46 //             ,/((%%%%%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#%%%%%%%&#  . . ...                       
47 //                      .,.,,**(%%%%%%%%&%##%%%%%%%%%%%%%%%%%%###%%%%%%%%%&*                          
48 //                       ,%&%%%%%&&%%%%%%%#%%%%%%%%%%%%%%%%%%&%%%%##%%%%%%%%%%%%%%%%&&#.              
49 //              .(&&&%%%%%%&#&&%&%%%%%%%##%%%%&&%%%#%%%%%%&%%%%%%&&%%%%&&&/*(,(#(,,.                  
50 //                         ..&%%%%%%#%#%%%%%%%%%%%##%%%%%%%&%%%%%%%%%%%%%%%%&&(.                      
51 //                      ,%%%%%%%%%##%%%&%%%%%%%%&%%#%%&&%%%%&%%%%%%&%%%%%&(#%%%#,                     
52 //              ./%&%%%%%%%%%%%%%%%%%%%%%%%%%&&&%%%##%%%%%%%%%%%%%&&&%%%%%%%%&#.//*/,..               
53 //      ,#%%%%%%%%%%%%%%%%%%&&%%%%%&&&&%%%%%&&&%%%%%#%%%%#%%%%%%%%%%%%%%%%%%%%%%%%%%&&(,..            
54 //            ,#* ,&&&%,.,*(%%%%%%%%%&%%%%&&&%%%%%&%%%%#%%%%##%%%%%%%&&%%%%%%%%%%%#%%%%%%%%&%(*.      
55 //          .,,/((#%&%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&&&%#%%%%%%%%%%%%%%%%%#%%%%%%%((*           
56 // *,//**,...,/#%%%%%%%%%%%&&&&%%%%%%%%%%%%%#%%%%%%&&&%%%%&&&&%%%#%%#%%%%%%%%%%%%%%%#*.       .,(#%&@*
57 //  .*%%(*(%%%%%%%%%%&&&&&&&&%%%%%%%&&%%%%%%%%%%%%%&&&%%%%%%%%%##%%%%%%%%%%%%%%%%%%%%%%%%%%%&%%%/..   
58 //      .,/%&%%%%%%@#(&%&%%%%%%%%%#&&%%##%#%%%#%%%%&&&%%%%%%%%###%%%%%&&&%%%%%%%%%%%%%%%%&(//%%/      
59 //          ,..     .(%%%%##%%%#%%%%%%#%%%%%##%%%%%&&&&%%%%%%%#&%#%%%%%%&&&%%%%%##//  ,,.             
60 //            .,(%#%%##%%%#%%%#%%%#%%*,.*%%%%%%%%%&.,/&%%%%%%% #&%%#%%%%%&%(&%((%&&&(*                
61 //                        ,/#/(%%,    ,&%%#%/.//         %*&(%#    .(,(%%%.          
62 
63 pragma solidity ^0.6.8;
64 
65 /**
66  * @dev Wrappers over Solidity's arithmetic operations with added overflow
67  * checks.
68  *
69  * Arithmetic operations in Solidity wrap on overflow. This can easily result
70  * in bugs, because programmers usually assume that an overflow raises an
71  * error, which is the standard behavior in high level programming languages.
72  * `SafeMath` restores this intuition by reverting the transaction when an
73  * operation overflows.
74  *
75  * Using this library instead of the unchecked operations eliminates an entire
76  * class of bugs, so it's recommended to use it always.
77  */
78 library SafeMath {
79     /**
80      * @dev Returns the addition of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `+` operator.
84      *
85      * Requirements:
86      * - Addition cannot overflow.
87      */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a, "SafeMath: addition overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      * - Subtraction cannot overflow.
103      */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return sub(a, b, "SafeMath: subtraction overflow");
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b <= a, errorMessage);
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return div(a, b, "SafeMath: division by zero");
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b > 0, errorMessage);
175         uint256 c = a / b;
176         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * Reverts when dividing by zero.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      */
192     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
193         return mod(a, b, "SafeMath: modulo by zero");
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts with custom message when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         require(b != 0, errorMessage);
209         return a % b;
210     }
211 }
212 
213 // File: contracts/libs/ECDSA.sol
214 
215 pragma solidity ^0.6.8;
216 
217 /**
218  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
219  *
220  * These functions can be used to verify that a message was signed by the holder
221  * of the private keys of a given address.
222  */
223 library ECDSA {
224     /**
225      * @dev Returns the address that signed a hashed message (`hash`) with
226      * `signature`. This address can then be used for verification purposes.
227      *
228      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
229      * this function rejects them by requiring the `s` value to be in the lower
230      * half order, and the `v` value to be either 27 or 28.
231      *
232      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
233      * verification to be secure: it is possible to craft signatures that
234      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
235      * this is by receiving a hash of the original message (which may otherwise
236      * be too long), and then calling {toEthSignedMessageHash} on it.
237      */
238     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
239         // Check the signature length
240         if (signature.length != 65) {
241             revert("ECDSA: invalid signature length");
242         }
243 
244         // Divide the signature in r, s and v variables
245         bytes32 r;
246         bytes32 s;
247         uint8 v;
248 
249         // ecrecover takes the signature parameters, and the only way to get them
250         // currently is to use assembly.
251         // solhint-disable-next-line no-inline-assembly
252         assembly {
253             r := mload(add(signature, 0x20))
254             s := mload(add(signature, 0x40))
255             v := byte(0, mload(add(signature, 0x60)))
256         }
257 
258         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
259         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
260         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
261         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
262         //
263         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
264         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
265         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
266         // these malleable signatures as well.
267         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
268             revert("ECDSA: invalid signature 's' value");
269         }
270 
271         if (v != 27 && v != 28) {
272             revert("ECDSA: invalid signature 'v' value");
273         }
274 
275         // If the signature is valid (and not malleable), return the signer address
276         address signer = ecrecover(hash, v, r, s);
277         require(signer != address(0), "ECDSA: invalid signature");
278 
279         return signer;
280     }
281 
282     /**
283      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
284      * replicates the behavior of the
285      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
286      * JSON-RPC method.
287      *
288      * See {recover}.
289      */
290     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
291         // 32 is the length in bytes of hash,
292         // enforced by the type signature above
293         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
294     }
295 }
296 
297 // File: contracts/interfaces/IERC20.sol
298 
299 
300 pragma solidity ^0.6.8;
301 
302 
303 /**
304  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
305  * the optional functions; to access them see {ERC20Detailed}.
306  */
307 interface IERC20 {
308     /**
309      * @dev Returns the amount of tokens in existence.
310      */
311     function totalSupply() external view returns (uint256);
312 
313     /**
314      * @dev Returns the amount of tokens owned by `account`.
315      */
316     function balanceOf(address account) external view returns (uint256);
317 
318     /**
319      * @dev Moves `amount` tokens from the caller's account to `recipient`.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transfer(address recipient, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Returns the remaining number of tokens that `spender` will be
329      * allowed to spend on behalf of `owner` through {transferFrom}. This is
330      * zero by default.
331      *
332      * This value changes when {approve} or {transferFrom} are called.
333      */
334     function allowance(address owner, address spender) external view returns (uint256);
335 
336     /**
337      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
338      *
339      * Returns a boolean value indicating whether the operation succeeded.
340      *
341      * IMPORTANT: Beware that changing an allowance with this method brings the risk
342      * that someone may use both the old and the new allowance by unfortunate
343      * transaction ordering. One possible solution to mitigate this race
344      * condition is to first reduce the spender's allowance to 0 and set the
345      * desired value afterwards:
346      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
347      *
348      * Emits an {Approval} event.
349      */
350     function approve(address spender, uint256 amount) external returns (bool);
351 
352     /**
353      * @dev Moves `amount` tokens from `sender` to `recipient` using the
354      * allowance mechanism. `amount` is then deducted from the caller's
355      * allowance.
356      *
357      * Returns a boolean value indicating whether the operation succeeded.
358      *
359      * Emits a {Transfer} event.
360      */
361     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
362 
363     /**
364      * @dev Emitted when `value` tokens are moved from one account (`from`) to
365      * another (`to`).
366      *
367      * Note that `value` may be zero.
368      */
369     event Transfer(address indexed from, address indexed to, uint256 value);
370 
371     /**
372      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
373      * a call to {approve}. `value` is the new allowance.
374      */
375     event Approval(address indexed owner, address indexed spender, uint256 value);
376 }
377 
378 // File: contracts/libs/Fabric.sol
379 
380 
381 pragma solidity ^0.6.8;
382 
383 
384 
385 /**
386  * @title Fabric
387  * @dev Create deterministics vaults.
388  *
389  * Original work by Pine.Finance
390  * - https://github.com/pine-finance
391  *
392  * Authors:
393  * - Agustin Aguilar <agusx1211>
394  * - Ignacio Mazzara <nachomazzara>
395  */
396 library Fabric {
397     /*Vault bytecode
398 
399         def _fallback() payable:
400             call cd[56] with:
401                 funct call.data[0 len 4]
402                 gas cd[56] wei
403                 args call.data[4 len 64]
404             selfdestruct(tx.origin)
405 
406         // Constructor bytecode
407         0x6012600081600A8239f3
408 
409         0x60 12 - PUSH1 12           // Size of the contract to return
410         0x60 00 - PUSH1 00           // Memory offset to return stored code
411         0x81    - DUP2  12           // Size of code to copy
412         0x60 0a - PUSH1 0A           // Start of the code to copy
413         0x82    - DUP3  00           // Dest memory for code copy
414         0x39    - CODECOPY 00 0A 12  // Code copy to memory
415         0xf3    - RETURN 00 12       // Return code to store
416 
417         // Deployed contract bytecode
418         0x60008060448082803781806038355AF132FF
419 
420         0x60 00 - PUSH1 00                    // Size for the call output
421         0x80    - DUP1  00                    // Offset for the call output
422         0x60 44 - PUSH1 44                    // Size for the call input
423         0x80    - DUP1  44                    // Size for copying calldata to memory
424         0x82    - DUP3  00                    // Offset for calldata copy
425         0x80    - DUP1  00                    // Offset for destination of calldata copy
426         0x37    - CALLDATACOPY 00 00 44       // Execute calldata copy, is going to be used for next call
427         0x81    - DUP2  00                    // Offset for call input
428         0x80    - DUP1  00                    // Amount of ETH to send during call
429         0x60 38 - PUSH1 38                    // calldata pointer to load value into stack
430         0x35    - CALLDATALOAD 38 (A)         // Load value (A), address to call
431         0x5a    - GAS                         // Remaining gas
432         0xf1    - CALL (A) (A) 00 00 44 00 00 // Execute call to address (A) with calldata mem[0:64]
433         0x32    - ORIGIN (B)                  // Dest funds for selfdestruct
434         0xff    - SELFDESTRUCT (B)            // selfdestruct contract, end of execution
435     */
436     bytes public constant code = hex"6012600081600A8239F360008060448082803781806038355AF132FF";
437     bytes32 public constant vaultCodeHash = bytes32(0xfa3da1081bc86587310fce8f3a5309785fc567b9b20875900cb289302d6bfa97);
438 
439     /**
440     * @dev Get a deterministics vault.
441     */
442     function getVault(bytes32 _key) internal view returns (address) {
443         return address(
444             uint256(
445                 keccak256(
446                     abi.encodePacked(
447                         byte(0xff),
448                         address(this),
449                         _key,
450                         vaultCodeHash
451                     )
452                 )
453             )
454         );
455     }
456 
457     /**
458     * @dev Create deterministic vault.
459     */
460     function executeVault(bytes32 _key, IERC20 _token, address _to) internal returns (uint256 value) {
461         address addr;
462         bytes memory slotcode = code;
463 
464         /* solium-disable-next-line */
465         assembly{
466           // Create the contract arguments for the constructor
467           addr := create2(0, add(slotcode, 0x20), mload(slotcode), _key)
468         }
469 
470         value = _token.balanceOf(addr);
471         /* solium-disable-next-line */
472         (bool success, ) = addr.call(
473             abi.encodePacked(
474                 abi.encodeWithSelector(
475                     _token.transfer.selector,
476                     _to,
477                     value
478                 ),
479                 address(_token)
480             )
481         );
482 
483         require(success, "Error pulling tokens");
484     }
485 }
486 
487 // File: contracts/interfaces/IModule.sol
488 
489 pragma solidity ^0.6.8;
490 
491 
492 
493 /**
494  * Original work by Pine.Finance
495  * - https://github.com/pine-finance
496  *
497  * Authors:
498  * - Ignacio Mazzara <nachomazzara>
499  * - Agustin Aguilar <agusx1211>
500  */
501 interface IModule {
502     /// @notice receive ETH
503     receive() external payable;
504 
505     /**
506      * @notice Executes an order
507      * @param _inputToken - Address of the input token
508      * @param _inputAmount - uint256 of the input token amount (order amount)
509      * @param _owner - Address of the order's owner
510      * @param _data - Bytes of the order's data
511      * @param _auxData - Bytes of the auxiliar data used for the handlers to execute the order
512      * @return bought - amount of output token bought
513      */
514     function execute(
515         IERC20 _inputToken,
516         uint256 _inputAmount,
517         address payable _owner,
518         bytes calldata _data,
519         bytes calldata _auxData
520     ) external returns (uint256 bought);
521 
522     /**
523      * @notice Check whether an order can be executed or not
524      * @param _inputToken - Address of the input token
525      * @param _inputAmount - uint256 of the input token amount (order amount)
526      * @param _data - Bytes of the order's data
527      * @param _auxData - Bytes of the auxiliar data used for the handlers to execute the order
528      * @return bool - whether the order can be executed or not
529      */
530     function canExecute(
531         IERC20 _inputToken,
532         uint256 _inputAmount,
533         bytes calldata _data,
534         bytes calldata _auxData
535     ) external view returns (bool);
536 }
537 
538 // File: contracts/commons/Order.sol
539 
540 
541 pragma solidity ^0.6.8;
542 
543 
544 contract Order {
545     address public constant ETH_ADDRESS = address(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
546 }
547 
548 // File: contracts/PineCore.sol
549 
550 
551 pragma solidity ^0.6.8;
552 
553 
554 
555 
556 
557 
558 
559 
560 /**
561  * Original work by Pine.Finance
562  * - https://github.com/pine-finance
563  *
564  * Authors:
565  * - Ignacio Mazzara <nachomazzara>
566  * - Agustin Aguilar <agusx1211>
567  */
568 contract PineCore is Order {
569     using SafeMath for uint256;
570     using Fabric for bytes32;
571 
572     // ETH orders
573     mapping(bytes32 => uint256) public ethDeposits;
574 
575     // Events
576     event DepositETH(
577         bytes32 indexed _key,
578         address indexed _caller,
579         uint256 _amount,
580         bytes _data
581     );
582 
583     event OrderExecuted(
584         bytes32 indexed _key,
585         address _inputToken,
586         address _owner,
587         address _witness,
588         bytes _data,
589         bytes _auxData,
590         uint256 _amount,
591         uint256 _bought
592     );
593 
594     event OrderCancelled(
595         bytes32 indexed _key,
596         address _inputToken,
597         address _owner,
598         address _witness,
599         bytes _data,
600         uint256 _amount
601     );
602 
603     /**
604      * @dev Prevent users to send Ether directly to this contract
605      */
606     receive() external payable {
607         require(
608             msg.sender != tx.origin,
609             "PineCore#receive: NO_SEND_ETH_PLEASE"
610         );
611     }
612 
613     /**
614      * @notice Create an ETH to token order
615      * @param _data - Bytes of an ETH to token order. See `encodeEthOrder` for more info
616      */
617     function depositEth(
618         bytes calldata _data
619     ) external payable {
620         require(msg.value > 0, "PineCore#depositEth: VALUE_IS_0");
621 
622         (
623             address module,
624             address inputToken,
625             address payable owner,
626             address witness,
627             bytes memory data,
628         ) = decodeOrder(_data);
629 
630         require(inputToken == ETH_ADDRESS, "PineCore#depositEth: WRONG_INPUT_TOKEN");
631 
632         bytes32 key = keyOf(
633             IModule(uint160(module)),
634             IERC20(inputToken),
635             owner,
636             witness,
637             data
638         );
639 
640         ethDeposits[key] = ethDeposits[key].add(msg.value);
641         emit DepositETH(key, msg.sender, msg.value, _data);
642     }
643 
644     /**
645      * @notice Cancel order
646      * @dev The params should be the same used for the order creation
647      * @param _module - Address of the module to use for the order execution
648      * @param _inputToken - Address of the input token
649      * @param _owner - Address of the order's owner
650      * @param _witness - Address of the witness
651      * @param _data - Bytes of the order's data
652      */
653     function cancelOrder(
654         IModule _module,
655         IERC20 _inputToken,
656         address payable _owner,
657         address _witness,
658         bytes calldata _data
659     ) external {
660         require(msg.sender == _owner, "PineCore#cancelOrder: INVALID_OWNER");
661         bytes32 key = keyOf(
662             _module,
663             _inputToken,
664             _owner,
665             _witness,
666             _data
667         );
668 
669         uint256 amount = _pullOrder(_inputToken, key, msg.sender);
670 
671         emit OrderCancelled(
672             key,
673             address(_inputToken),
674             _owner,
675             _witness,
676             _data,
677             amount
678         );
679     }
680 
681     /**
682      * @notice Get the calldata needed to create a token to token/ETH order
683      * @dev Returns the input data that the user needs to use to create the order
684      * The _secret is used to prevent a front-running at the order execution
685      * The _amount is used as the param `_value` for the ERC20 `transfer` function
686      * @param _module - Address of the module to use for the order execution
687      * @param _inputToken - Address of the input token
688      * @param _owner - Address of the order's owner
689      * @param _witness - Address of the witness
690      * @param _data - Bytes of the order's data
691      * @param _secret - Private key of the _witness
692      * @param _amount - uint256 of the order amount
693      * @return bytes - input data to send the transaction
694      */
695     function encodeTokenOrder(
696         IModule _module,
697         IERC20 _inputToken,
698         address payable _owner,
699         address _witness,
700         bytes calldata _data,
701         bytes32 _secret,
702         uint256 _amount
703     ) external view returns (bytes memory) {
704         return abi.encodeWithSelector(
705             _inputToken.transfer.selector,
706             vaultOfOrder(
707                 _module,
708                 _inputToken,
709                 _owner,
710                 _witness,
711                 _data
712             ),
713             _amount,
714             abi.encode(
715                 _module,
716                 _inputToken,
717                 _owner,
718                 _witness,
719                 _data,
720                 _secret
721             )
722         );
723     }
724 
725     /**
726      * @notice Get the calldata needed to create a ETH to token order
727      * @dev Returns the input data that the user needs to use to create the order
728      * The _secret is used to prevent a front-running at the order execution
729      * @param _module - Address of the module to use for the order execution
730      * @param _inputToken - Address of the input token
731      * @param _owner - Address of the order's owner
732      * @param _witness - Address of the witness
733      * @param _data - Bytes of the order's data
734      * @param _secret -  Private key of the _witness
735      * @return bytes - input data to send the transaction
736      */
737     function encodeEthOrder(
738         address _module,
739         address _inputToken,
740         address payable _owner,
741         address _witness,
742         bytes calldata _data,
743         bytes32 _secret
744     ) external pure returns (bytes memory) {
745         return abi.encode(
746             _module,
747             _inputToken,
748             _owner,
749             _witness,
750             _data,
751             _secret
752         );
753     }
754 
755     /**
756      * @notice Get order's properties
757      * @param _data - Bytes of the order
758      * @return module - Address of the module to use for the order execution
759      * @return inputToken - Address of the input token
760      * @return owner - Address of the order's owner
761      * @return witness - Address of the witness
762      * @return data - Bytes of the order's data
763      * @return secret -  Private key of the _witness
764      */
765     function decodeOrder(
766         bytes memory _data
767     ) public pure returns (
768         address module,
769         address inputToken,
770         address payable owner,
771         address witness,
772         bytes memory data,
773         bytes32 secret
774     ) {
775         (
776             module,
777             inputToken,
778             owner,
779             witness,
780             data,
781             secret
782         ) = abi.decode(
783             _data,
784             (
785                 address,
786                 address,
787                 address,
788                 address,
789                 bytes,
790                 bytes32
791             )
792         );
793     }
794 
795     /**
796      * @notice Get the vault's address of a token to token/ETH order
797      * @param _module - Address of the module to use for the order execution
798      * @param _inputToken - Address of the input token
799      * @param _owner - Address of the order's owner
800      * @param _witness - Address of the witness
801      * @param _data - Bytes of the order's data
802      * @return address - The address of the vault
803      */
804     function vaultOfOrder(
805         IModule _module,
806         IERC20 _inputToken,
807         address payable _owner,
808         address _witness,
809         bytes memory _data
810     ) public view returns (address) {
811         return keyOf(
812             _module,
813             _inputToken,
814             _owner,
815             _witness,
816             _data
817         ).getVault();
818     }
819 
820      /**
821      * @notice Executes an order
822      * @dev The sender should use the _secret to sign its own address
823      * to prevent front-runnings
824      * @param _module - Address of the module to use for the order execution
825      * @param _inputToken - Address of the input token
826      * @param _owner - Address of the order's owner
827      * @param _data - Bytes of the order's data
828      * @param _signature - Signature to calculate the witness
829      * @param _auxData - Bytes of the auxiliar data used for the handlers to execute the order
830      */
831     function executeOrder(
832         IModule _module,
833         IERC20 _inputToken,
834         address payable _owner,
835         bytes calldata _data,
836         bytes calldata _signature,
837         bytes calldata _auxData
838     ) external {
839         // Calculate witness using signature
840         address witness = ECDSA.recover(
841             keccak256(abi.encodePacked(msg.sender)),
842             _signature
843         );
844 
845         bytes32 key = keyOf(
846             _module,
847             _inputToken,
848             _owner,
849             witness,
850             _data
851         );
852 
853         // Pull amount
854         uint256 amount = _pullOrder(_inputToken, key, address(_module));
855         require(amount > 0, "PineCore#executeOrder: INVALID_ORDER");
856 
857         uint256 bought = _module.execute(
858             _inputToken,
859             amount,
860             _owner,
861             _data,
862             _auxData
863         );
864 
865         emit OrderExecuted(
866             key,
867             address(_inputToken),
868             _owner,
869             witness,
870             _data,
871             _auxData,
872             amount,
873             bought
874         );
875     }
876 
877      /**
878      * @notice Check whether an order exists or not
879      * @dev Check the balance of the order
880      * @param _module - Address of the module to use for the order execution
881      * @param _inputToken - Address of the input token
882      * @param _owner - Address of the order's owner
883      * @param _witness - Address of the witness
884      * @param _data - Bytes of the order's data
885      * @return bool - whether the order exists or not
886      */
887     function existOrder(
888         IModule _module,
889         IERC20 _inputToken,
890         address payable _owner,
891         address _witness,
892         bytes calldata _data
893     ) external view returns (bool) {
894         bytes32 key = keyOf(
895             _module,
896             _inputToken,
897             _owner,
898             _witness,
899            _data
900         );
901 
902         if (address(_inputToken) == ETH_ADDRESS) {
903             return ethDeposits[key] != 0;
904         } else {
905             return _inputToken.balanceOf(key.getVault()) != 0;
906         }
907     }
908 
909     /**
910      * @notice Check whether an order can be executed or not
911      * @param _module - Address of the module to use for the order execution
912      * @param _inputToken - Address of the input token
913      * @param _owner - Address of the order's owner
914      * @param _witness - Address of the witness
915      * @param _data - Bytes of the order's data
916      * @param _auxData - Bytes of the auxiliar data used for the handlers to execute the order
917      * @return bool - whether the order can be executed or not
918      */
919     function canExecuteOrder(
920         IModule _module,
921         IERC20 _inputToken,
922         address payable _owner,
923         address _witness,
924         bytes calldata _data,
925         bytes calldata _auxData
926     ) external view returns (bool) {
927         bytes32 key = keyOf(
928             _module,
929             _inputToken,
930             _owner,
931             _witness,
932             _data
933         );
934 
935         // Pull amount
936         uint256 amount;
937         if (address(_inputToken) == ETH_ADDRESS) {
938             amount = ethDeposits[key];
939         } else {
940             amount = _inputToken.balanceOf(key.getVault());
941         }
942 
943         return _module.canExecute(
944             _inputToken,
945             amount,
946             _data,
947             _auxData
948         );
949     }
950 
951     /**
952      * @notice Transfer the order amount to a recipient.
953      * @dev For an ETH order, the ETH will be transferred from this contract
954      * For a token order, its vault will be executed transferring the amount of tokens to
955      * the recipient
956      * @param _inputToken - Address of the input token
957      * @param _key - Order's key
958      * @param _to - Address of the recipient
959      * @return amount - amount transferred
960      */
961     function _pullOrder(
962         IERC20 _inputToken,
963         bytes32 _key,
964         address payable _to
965     ) private returns (uint256 amount) {
966         if (address(_inputToken) == ETH_ADDRESS) {
967             amount = ethDeposits[_key];
968             ethDeposits[_key] = 0;
969             (bool success,) = _to.call{value: amount}("");
970             require(success, "PineCore#_pullOrder: PULL_ETHER_FAILED");
971         } else {
972             amount = _key.executeVault(_inputToken, _to);
973         }
974     }
975 
976     /**
977      * @notice Get the order's key
978      * @param _module - Address of the module to use for the order execution
979      * @param _inputToken - Address of the input token
980      * @param _owner - Address of the order's owner
981      * @param _witness - Address of the witness
982      * @param _data - Bytes of the order's data
983      * @return bytes32 - order's key
984      */
985     function keyOf(
986         IModule _module,
987         IERC20 _inputToken,
988         address payable _owner,
989         address _witness,
990         bytes memory _data
991     ) public pure returns (bytes32) {
992         return keccak256(
993             abi.encode(
994                 _module,
995                 _inputToken,
996                 _owner,
997                 _witness,
998                 _data
999             )
1000         );
1001     }
1002 }