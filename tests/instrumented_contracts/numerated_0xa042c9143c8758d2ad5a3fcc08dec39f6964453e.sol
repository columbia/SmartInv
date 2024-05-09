1 pragma solidity ^0.5.9;
2 
3 // File: openzeppelin-solidity/contracts/introspection/ERC165Checker.sol
4 
5 /**
6  * @dev Library used to query support of an interface declared via `IERC165`.
7  *
8  * Note that these functions return the actual result of the query: they do not
9  * `revert` if an interface is not supported. It is up to the caller to decide
10  * what to do in these cases.
11  */
12 library ERC165Checker {
13     // As per the EIP-165 spec, no interface should ever match 0xffffffff
14     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
15 
16     /*
17      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
18      */
19     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
20 
21     /**
22      * @dev Returns true if `account` supports the `IERC165` interface,
23      */
24     function _supportsERC165(address account) internal view returns (bool) {
25         // Any contract that implements ERC165 must explicitly indicate support of
26         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
27         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
28             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
29     }
30 
31     /**
32      * @dev Returns true if `account` supports the interface defined by
33      * `interfaceId`. Support for `IERC165` itself is queried automatically.
34      *
35      * See `IERC165.supportsInterface`.
36      */
37     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
38         // query support of both ERC165 as per the spec and support of _interfaceId
39         return _supportsERC165(account) &&
40             _supportsERC165Interface(account, interfaceId);
41     }
42 
43     /**
44      * @dev Returns true if `account` supports all the interfaces defined in
45      * `interfaceIds`. Support for `IERC165` itself is queried automatically.
46      *
47      * Batch-querying can lead to gas savings by skipping repeated checks for
48      * `IERC165` support.
49      *
50      * See `IERC165.supportsInterface`.
51      */
52     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
53         // query support of ERC165 itself
54         if (!_supportsERC165(account)) {
55             return false;
56         }
57 
58         // query support of each interface in _interfaceIds
59         for (uint256 i = 0; i < interfaceIds.length; i++) {
60             if (!_supportsERC165Interface(account, interfaceIds[i])) {
61                 return false;
62             }
63         }
64 
65         // all interfaces supported
66         return true;
67     }
68 
69     /**
70      * @notice Query if a contract implements an interface, does not check ERC165 support
71      * @param account The address of the contract to query for support of an interface
72      * @param interfaceId The interface identifier, as specified in ERC-165
73      * @return true if the contract at account indicates support of the interface with
74      * identifier interfaceId, false otherwise
75      * @dev Assumes that account contains a contract that supports ERC165, otherwise
76      * the behavior of this method is undefined. This precondition can be checked
77      * with the `supportsERC165` method in this library.
78      * Interface identification is specified in ERC-165.
79      */
80     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
81         // success determines whether the staticcall succeeded and result determines
82         // whether the contract at account indicates support of _interfaceId
83         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
84 
85         return (success && result);
86     }
87 
88     /**
89      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
90      * @param account The address of the contract to query for support of an interface
91      * @param interfaceId The interface identifier, as specified in ERC-165
92      * @return success true if the STATICCALL succeeded, false otherwise
93      * @return result true if the STATICCALL succeeded and the contract at account
94      * indicates support of the interface with identifier interfaceId, false otherwise
95      */
96     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
97         private
98         view
99         returns (bool success, bool result)
100     {
101         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
102 
103         // solhint-disable-next-line no-inline-assembly
104         assembly {
105             let encodedParams_data := add(0x20, encodedParams)
106             let encodedParams_size := mload(encodedParams)
107 
108             let output := mload(0x40)    // Find empty storage location using "free memory pointer"
109             mstore(output, 0x0)
110 
111             success := staticcall(
112                 30000,                   // 30k gas
113                 account,                 // To addr
114                 encodedParams_data,
115                 encodedParams_size,
116                 output,
117                 0x20                     // Outputs are 32 bytes long
118             )
119 
120             result := mload(output)      // Load the result
121         }
122     }
123 }
124 
125 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
126 
127 /**
128  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
129  * the optional functions; to access them see `ERC20Detailed`.
130  */
131 interface IERC20 {
132     /**
133      * @dev Returns the amount of tokens in existence.
134      */
135     function totalSupply() external view returns (uint256);
136 
137     /**
138      * @dev Returns the amount of tokens owned by `account`.
139      */
140     function balanceOf(address account) external view returns (uint256);
141 
142     /**
143      * @dev Moves `amount` tokens from the caller's account to `recipient`.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a `Transfer` event.
148      */
149     function transfer(address recipient, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Returns the remaining number of tokens that `spender` will be
153      * allowed to spend on behalf of `owner` through `transferFrom`. This is
154      * zero by default.
155      *
156      * This value changes when `approve` or `transferFrom` are called.
157      */
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     /**
161      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * > Beware that changing an allowance with this method brings the risk
166      * that someone may use both the old and the new allowance by unfortunate
167      * transaction ordering. One possible solution to mitigate this race
168      * condition is to first reduce the spender's allowance to 0 and set the
169      * desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      *
172      * Emits an `Approval` event.
173      */
174     function approve(address spender, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Moves `amount` tokens from `sender` to `recipient` using the
178      * allowance mechanism. `amount` is then deducted from the caller's
179      * allowance.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a `Transfer` event.
184      */
185     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
186 
187     /**
188      * @dev Emitted when `value` tokens are moved from one account (`from`) to
189      * another (`to`).
190      *
191      * Note that `value` may be zero.
192      */
193     event Transfer(address indexed from, address indexed to, uint256 value);
194 
195     /**
196      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
197      * a call to `approve`. `value` is the new allowance.
198      */
199     event Approval(address indexed owner, address indexed spender, uint256 value);
200 }
201 
202 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
203 
204 /**
205  * @dev Interface of the ERC165 standard, as defined in the
206  * [EIP](https://eips.ethereum.org/EIPS/eip-165).
207  *
208  * Implementers can declare support of contract interfaces, which can then be
209  * queried by others (`ERC165Checker`).
210  *
211  * For an implementation, see `ERC165`.
212  */
213 interface IERC165 {
214     /**
215      * @dev Returns true if this contract implements the interface defined by
216      * `interfaceId`. See the corresponding
217      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
218      * to learn more about how these ids are created.
219      *
220      * This function call must use less than 30 000 gas.
221      */
222     function supportsInterface(bytes4 interfaceId) external view returns (bool);
223 }
224 
225 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
226 
227 /**
228  * @dev Implementation of the `IERC165` interface.
229  *
230  * Contracts may inherit from this and call `_registerInterface` to declare
231  * their support of an interface.
232  */
233 contract ERC165 is IERC165 {
234     /*
235      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
236      */
237     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
238 
239     /**
240      * @dev Mapping of interface ids to whether or not it's supported.
241      */
242     mapping(bytes4 => bool) private _supportedInterfaces;
243 
244     constructor () internal {
245         // Derived contracts need only register support for their own interfaces,
246         // we register support for ERC165 itself here
247         _registerInterface(_INTERFACE_ID_ERC165);
248     }
249 
250     /**
251      * @dev See `IERC165.supportsInterface`.
252      *
253      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
254      */
255     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
256         return _supportedInterfaces[interfaceId];
257     }
258 
259     /**
260      * @dev Registers the contract as an implementer of the interface defined by
261      * `interfaceId`. Support of the actual ERC165 interface is automatic and
262      * registering its interface id is not required.
263      *
264      * See `IERC165.supportsInterface`.
265      *
266      * Requirements:
267      *
268      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
269      */
270     function _registerInterface(bytes4 interfaceId) internal {
271         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
272         _supportedInterfaces[interfaceId] = true;
273     }
274 }
275 
276 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
277 
278 /**
279  * @title IERC1363 Interface
280  * @author Vittorio Minacori (https://github.com/vittominacori)
281  * @dev Interface for a Payable Token contract as defined in
282  *  https://github.com/ethereum/EIPs/issues/1363
283  */
284 contract IERC1363 is IERC20, ERC165 {
285     /*
286      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
287      * 0x4bbee2df ===
288      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
289      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
290      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
291      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
292      */
293 
294     /*
295      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
296      * 0xfb9ec8ce ===
297      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
298      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
299      */
300 
301     /**
302      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
303      * @param to address The address which you want to transfer to
304      * @param value uint256 The amount of tokens to be transferred
305      * @return true unless throwing
306      */
307     function transferAndCall(address to, uint256 value) public returns (bool);
308 
309     /**
310      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
311      * @param to address The address which you want to transfer to
312      * @param value uint256 The amount of tokens to be transferred
313      * @param data bytes Additional data with no specified format, sent in call to `to`
314      * @return true unless throwing
315      */
316     function transferAndCall(address to, uint256 value, bytes memory data) public returns (bool);
317 
318     /**
319      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
320      * @param from address The address which you want to send tokens from
321      * @param to address The address which you want to transfer to
322      * @param value uint256 The amount of tokens to be transferred
323      * @return true unless throwing
324      */
325     function transferFromAndCall(address from, address to, uint256 value) public returns (bool);
326 
327 
328     /**
329      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
330      * @param from address The address which you want to send tokens from
331      * @param to address The address which you want to transfer to
332      * @param value uint256 The amount of tokens to be transferred
333      * @param data bytes Additional data with no specified format, sent in call to `to`
334      * @return true unless throwing
335      */
336     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public returns (bool);
337 
338     /**
339      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
340      * and then call `onApprovalReceived` on spender.
341      * Beware that changing an allowance with this method brings the risk that someone may use both the old
342      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
343      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
344      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
345      * @param spender address The address which will spend the funds
346      * @param value uint256 The amount of tokens to be spent
347      */
348     function approveAndCall(address spender, uint256 value) public returns (bool);
349 
350     /**
351      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
352      * and then call `onApprovalReceived` on spender.
353      * Beware that changing an allowance with this method brings the risk that someone may use both the old
354      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
355      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
356      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
357      * @param spender address The address which will spend the funds
358      * @param value uint256 The amount of tokens to be spent
359      * @param data bytes Additional data with no specified format, sent in call to `spender`
360      */
361     function approveAndCall(address spender, uint256 value, bytes memory data) public returns (bool);
362 }
363 
364 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
365 
366 /**
367  * @title IERC1363Receiver Interface
368  * @author Vittorio Minacori (https://github.com/vittominacori)
369  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
370  *  from ERC1363 token contracts as defined in
371  *  https://github.com/ethereum/EIPs/issues/1363
372  */
373 contract IERC1363Receiver {
374     /*
375      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
376      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
377      */
378 
379     /**
380      * @notice Handle the receipt of ERC1363 tokens
381      * @dev Any ERC1363 smart contract calls this function on the recipient
382      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
383      * transfer. Return of other than the magic value MUST result in the
384      * transaction being reverted.
385      * Note: the token contract address is always the message sender.
386      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
387      * @param from address The address which are token transferred from
388      * @param value uint256 The amount of tokens transferred
389      * @param data bytes Additional data with no specified format
390      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
391      *  unless throwing
392      */
393     function onTransferReceived(address operator, address from, uint256 value, bytes memory data) public returns (bytes4); // solhint-disable-line  max-line-length
394 }
395 
396 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
397 
398 /**
399  * @title IERC1363Spender Interface
400  * @author Vittorio Minacori (https://github.com/vittominacori)
401  * @dev Interface for any contract that wants to support approveAndCall
402  *  from ERC1363 token contracts as defined in
403  *  https://github.com/ethereum/EIPs/issues/1363
404  */
405 contract IERC1363Spender {
406     /*
407      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
408      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
409      */
410 
411     /**
412      * @notice Handle the approval of ERC1363 tokens
413      * @dev Any ERC1363 smart contract calls this function on the recipient
414      * after an `approve`. This function MAY throw to revert and reject the
415      * approval. Return of other than the magic value MUST result in the
416      * transaction being reverted.
417      * Note: the token contract address is always the message sender.
418      * @param owner address The address which called `approveAndCall` function
419      * @param value uint256 The amount of tokens to be spent
420      * @param data bytes Additional data with no specified format
421      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
422      *  unless throwing
423      */
424     function onApprovalReceived(address owner, uint256 value, bytes memory data) public returns (bytes4);
425 }
426 
427 // File: erc-payable-token/contracts/payment/ERC1363Payable.sol
428 
429 /**
430  * @title ERC1363Payable
431  * @author Vittorio Minacori (https://github.com/vittominacori)
432  * @dev Implementation proposal of a contract that wants to accept ERC1363 payments
433  */
434 contract ERC1363Payable is IERC1363Receiver, IERC1363Spender, ERC165 {
435     using ERC165Checker for address;
436 
437     /**
438      * @dev Magic value to be returned upon successful reception of ERC1363 tokens
439      *  Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`,
440      *  which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
441      */
442     bytes4 internal constant _INTERFACE_ID_ERC1363_RECEIVER = 0x88a7ca5c;
443 
444     /**
445      * @dev Magic value to be returned upon successful approval of ERC1363 tokens.
446      * Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`,
447      * which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
448      */
449     bytes4 internal constant _INTERFACE_ID_ERC1363_SPENDER = 0x7b04a2d0;
450 
451     /*
452      * Note: the ERC-165 identifier for the ERC1363 token transfer
453      * 0x4bbee2df ===
454      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
455      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
456      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
457      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
458      */
459     bytes4 private constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
460 
461     /*
462      * Note: the ERC-165 identifier for the ERC1363 token approval
463      * 0xfb9ec8ce ===
464      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
465      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
466      */
467     bytes4 private constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
468 
469     event TokensReceived(
470         address indexed operator,
471         address indexed from,
472         uint256 value,
473         bytes data
474     );
475 
476     event TokensApproved(
477         address indexed owner,
478         uint256 value,
479         bytes data
480     );
481 
482     // The ERC1363 token accepted
483     IERC1363 private _acceptedToken;
484 
485     /**
486      * @param acceptedToken Address of the token being accepted
487      */
488     constructor(IERC1363 acceptedToken) public {
489         require(address(acceptedToken) != address(0));
490         require(
491             acceptedToken.supportsInterface(_INTERFACE_ID_ERC1363_TRANSFER) &&
492             acceptedToken.supportsInterface(_INTERFACE_ID_ERC1363_APPROVE)
493         );
494 
495         _acceptedToken = acceptedToken;
496 
497         // register the supported interface to conform to IERC1363Receiver and IERC1363Spender via ERC165
498         _registerInterface(_INTERFACE_ID_ERC1363_RECEIVER);
499         _registerInterface(_INTERFACE_ID_ERC1363_SPENDER);
500     }
501 
502     /*
503      * @dev Note: remember that the token contract address is always the message sender.
504      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
505      * @param from address The address which are token transferred from
506      * @param value uint256 The amount of tokens transferred
507      * @param data bytes Additional data with no specified format
508      */
509     function onTransferReceived(address operator, address from, uint256 value, bytes memory data) public returns (bytes4) { // solhint-disable-line  max-line-length
510         require(msg.sender == address(_acceptedToken));
511 
512         emit TokensReceived(operator, from, value, data);
513 
514         _transferReceived(operator, from, value, data);
515 
516         return _INTERFACE_ID_ERC1363_RECEIVER;
517     }
518 
519     /*
520      * @dev Note: remember that the token contract address is always the message sender.
521      * @param owner address The address which called `approveAndCall` function
522      * @param value uint256 The amount of tokens to be spent
523      * @param data bytes Additional data with no specified format
524      */
525     function onApprovalReceived(address owner, uint256 value, bytes memory data) public returns (bytes4) {
526         require(msg.sender == address(_acceptedToken));
527 
528         emit TokensApproved(owner, value, data);
529 
530         _approvalReceived(owner, value, data);
531 
532         return _INTERFACE_ID_ERC1363_SPENDER;
533     }
534 
535     /**
536      * @dev The ERC1363 token accepted
537      */
538     function acceptedToken() public view returns (IERC1363) {
539         return _acceptedToken;
540     }
541 
542     /**
543      * @dev Called after validating a `onTransferReceived`. Override this method to
544      * make your stuffs within your contract.
545      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
546      * @param from address The address which are token transferred from
547      * @param value uint256 The amount of tokens transferred
548      * @param data bytes Additional data with no specified format
549      */
550     function _transferReceived(address operator, address from, uint256 value, bytes memory data) internal {
551         // solhint-disable-previous-line no-empty-blocks
552 
553         // optional override
554     }
555 
556     /**
557      * @dev Called after validating a `onApprovalReceived`. Override this method to
558      * make your stuffs within your contract.
559      * @param owner address The address which called `approveAndCall` function
560      * @param value uint256 The amount of tokens to be spent
561      * @param data bytes Additional data with no specified format
562      */
563     function _approvalReceived(address owner, uint256 value, bytes memory data) internal {
564         // solhint-disable-previous-line no-empty-blocks
565 
566         // optional override
567     }
568 }
569 
570 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
571 
572 /**
573  * @dev Contract module which provides a basic access control mechanism, where
574  * there is an account (an owner) that can be granted exclusive access to
575  * specific functions.
576  *
577  * This module is used through inheritance. It will make available the modifier
578  * `onlyOwner`, which can be aplied to your functions to restrict their use to
579  * the owner.
580  */
581 contract Ownable {
582     address private _owner;
583 
584     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
585 
586     /**
587      * @dev Initializes the contract setting the deployer as the initial owner.
588      */
589     constructor () internal {
590         _owner = msg.sender;
591         emit OwnershipTransferred(address(0), _owner);
592     }
593 
594     /**
595      * @dev Returns the address of the current owner.
596      */
597     function owner() public view returns (address) {
598         return _owner;
599     }
600 
601     /**
602      * @dev Throws if called by any account other than the owner.
603      */
604     modifier onlyOwner() {
605         require(isOwner(), "Ownable: caller is not the owner");
606         _;
607     }
608 
609     /**
610      * @dev Returns true if the caller is the current owner.
611      */
612     function isOwner() public view returns (bool) {
613         return msg.sender == _owner;
614     }
615 
616     /**
617      * @dev Leaves the contract without owner. It will not be possible to call
618      * `onlyOwner` functions anymore. Can only be called by the current owner.
619      *
620      * > Note: Renouncing ownership will leave the contract without an owner,
621      * thereby removing any functionality that is only available to the owner.
622      */
623     function renounceOwnership() public onlyOwner {
624         emit OwnershipTransferred(_owner, address(0));
625         _owner = address(0);
626     }
627 
628     /**
629      * @dev Transfers ownership of the contract to a new account (`newOwner`).
630      * Can only be called by the current owner.
631      */
632     function transferOwnership(address newOwner) public onlyOwner {
633         _transferOwnership(newOwner);
634     }
635 
636     /**
637      * @dev Transfers ownership of the contract to a new account (`newOwner`).
638      */
639     function _transferOwnership(address newOwner) internal {
640         require(newOwner != address(0), "Ownable: new owner is the zero address");
641         emit OwnershipTransferred(_owner, newOwner);
642         _owner = newOwner;
643     }
644 }
645 
646 // File: openzeppelin-solidity/contracts/access/Roles.sol
647 
648 /**
649  * @title Roles
650  * @dev Library for managing addresses assigned to a Role.
651  */
652 library Roles {
653     struct Role {
654         mapping (address => bool) bearer;
655     }
656 
657     /**
658      * @dev Give an account access to this role.
659      */
660     function add(Role storage role, address account) internal {
661         require(!has(role, account), "Roles: account already has role");
662         role.bearer[account] = true;
663     }
664 
665     /**
666      * @dev Remove an account's access to this role.
667      */
668     function remove(Role storage role, address account) internal {
669         require(has(role, account), "Roles: account does not have role");
670         role.bearer[account] = false;
671     }
672 
673     /**
674      * @dev Check if an account has this role.
675      * @return bool
676      */
677     function has(Role storage role, address account) internal view returns (bool) {
678         require(account != address(0), "Roles: account is the zero address");
679         return role.bearer[account];
680     }
681 }
682 
683 // File: contracts/access/roles/DAORoles.sol
684 
685 /**
686  * @title DAORoles
687  * @author Vittorio Minacori (https://github.com/vittominacori)
688  * @dev It identifies the DAO roles
689  */
690 contract DAORoles is Ownable {
691     using Roles for Roles.Role;
692 
693     event OperatorAdded(address indexed account);
694     event OperatorRemoved(address indexed account);
695 
696     event DappAdded(address indexed account);
697     event DappRemoved(address indexed account);
698 
699     Roles.Role private _operators;
700     Roles.Role private _dapps;
701 
702     constructor () internal {} // solhint-disable-line no-empty-blocks
703 
704     modifier onlyOperator() {
705         require(isOperator(msg.sender));
706         _;
707     }
708 
709     modifier onlyDapp() {
710         require(isDapp(msg.sender));
711         _;
712     }
713 
714     /**
715      * @dev Check if an address has the `operator` role
716      * @param account Address you want to check
717      */
718     function isOperator(address account) public view returns (bool) {
719         return _operators.has(account);
720     }
721 
722     /**
723      * @dev Check if an address has the `dapp` role
724      * @param account Address you want to check
725      */
726     function isDapp(address account) public view returns (bool) {
727         return _dapps.has(account);
728     }
729 
730     /**
731      * @dev Add the `operator` role from address
732      * @param account Address you want to add role
733      */
734     function addOperator(address account) public onlyOwner {
735         _addOperator(account);
736     }
737 
738     /**
739      * @dev Add the `dapp` role from address
740      * @param account Address you want to add role
741      */
742     function addDapp(address account) public onlyOperator {
743         _addDapp(account);
744     }
745 
746     /**
747      * @dev Remove the `operator` role from address
748      * @param account Address you want to remove role
749      */
750     function removeOperator(address account) public onlyOwner {
751         _removeOperator(account);
752     }
753 
754     /**
755      * @dev Remove the `operator` role from address
756      * @param account Address you want to remove role
757      */
758     function removeDapp(address account) public onlyOperator {
759         _removeDapp(account);
760     }
761 
762     function _addOperator(address account) internal {
763         _operators.add(account);
764         emit OperatorAdded(account);
765     }
766 
767     function _addDapp(address account) internal {
768         _dapps.add(account);
769         emit DappAdded(account);
770     }
771 
772     function _removeOperator(address account) internal {
773         _operators.remove(account);
774         emit OperatorRemoved(account);
775     }
776 
777     function _removeDapp(address account) internal {
778         _dapps.remove(account);
779         emit DappRemoved(account);
780     }
781 }
782 
783 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
784 
785 /**
786  * @dev Wrappers over Solidity's arithmetic operations with added overflow
787  * checks.
788  *
789  * Arithmetic operations in Solidity wrap on overflow. This can easily result
790  * in bugs, because programmers usually assume that an overflow raises an
791  * error, which is the standard behavior in high level programming languages.
792  * `SafeMath` restores this intuition by reverting the transaction when an
793  * operation overflows.
794  *
795  * Using this library instead of the unchecked operations eliminates an entire
796  * class of bugs, so it's recommended to use it always.
797  */
798 library SafeMath {
799     /**
800      * @dev Returns the addition of two unsigned integers, reverting on
801      * overflow.
802      *
803      * Counterpart to Solidity's `+` operator.
804      *
805      * Requirements:
806      * - Addition cannot overflow.
807      */
808     function add(uint256 a, uint256 b) internal pure returns (uint256) {
809         uint256 c = a + b;
810         require(c >= a, "SafeMath: addition overflow");
811 
812         return c;
813     }
814 
815     /**
816      * @dev Returns the subtraction of two unsigned integers, reverting on
817      * overflow (when the result is negative).
818      *
819      * Counterpart to Solidity's `-` operator.
820      *
821      * Requirements:
822      * - Subtraction cannot overflow.
823      */
824     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
825         require(b <= a, "SafeMath: subtraction overflow");
826         uint256 c = a - b;
827 
828         return c;
829     }
830 
831     /**
832      * @dev Returns the multiplication of two unsigned integers, reverting on
833      * overflow.
834      *
835      * Counterpart to Solidity's `*` operator.
836      *
837      * Requirements:
838      * - Multiplication cannot overflow.
839      */
840     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
841         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
842         // benefit is lost if 'b' is also tested.
843         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
844         if (a == 0) {
845             return 0;
846         }
847 
848         uint256 c = a * b;
849         require(c / a == b, "SafeMath: multiplication overflow");
850 
851         return c;
852     }
853 
854     /**
855      * @dev Returns the integer division of two unsigned integers. Reverts on
856      * division by zero. The result is rounded towards zero.
857      *
858      * Counterpart to Solidity's `/` operator. Note: this function uses a
859      * `revert` opcode (which leaves remaining gas untouched) while Solidity
860      * uses an invalid opcode to revert (consuming all remaining gas).
861      *
862      * Requirements:
863      * - The divisor cannot be zero.
864      */
865     function div(uint256 a, uint256 b) internal pure returns (uint256) {
866         // Solidity only automatically asserts when dividing by 0
867         require(b > 0, "SafeMath: division by zero");
868         uint256 c = a / b;
869         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
870 
871         return c;
872     }
873 
874     /**
875      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
876      * Reverts when dividing by zero.
877      *
878      * Counterpart to Solidity's `%` operator. This function uses a `revert`
879      * opcode (which leaves remaining gas untouched) while Solidity uses an
880      * invalid opcode to revert (consuming all remaining gas).
881      *
882      * Requirements:
883      * - The divisor cannot be zero.
884      */
885     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
886         require(b != 0, "SafeMath: modulo by zero");
887         return a % b;
888     }
889 }
890 
891 // File: contracts/dao/Organization.sol
892 
893 /**
894  * @title Organization
895  * @author Vittorio Minacori (https://github.com/vittominacori)
896  * @dev Library for managing organization
897  */
898 library Organization {
899     using SafeMath for uint256;
900 
901     // structure defining a member
902     struct Member {
903         uint256 id;
904         address account;
905         bytes9 fingerprint;
906         uint256 creationDate;
907         uint256 stakedTokens;
908         uint256 usedTokens;
909         bytes32 data;
910         bool approved;
911     }
912 
913     // structure defining members status
914     struct Members {
915         uint256 count;
916         uint256 totalStakedTokens;
917         uint256 totalUsedTokens;
918         mapping(address => uint256) addressMap;
919         mapping(uint256 => Member) list;
920     }
921 
922     /**
923      * @dev Returns if an address is member or not
924      * @param members Current members struct
925      * @param account Address of the member you are looking for
926      * @return bool
927      */
928     function isMember(Members storage members, address account) internal view returns (bool) {
929         return members.addressMap[account] != 0;
930     }
931 
932     /**
933      * @dev Get creation date of a member
934      * @param members Current members struct
935      * @param account Address you want to check
936      * @return uint256 Member creation date, zero otherwise
937      */
938     function creationDateOf(Members storage members, address account) internal view returns (uint256) {
939         Member storage member = members.list[members.addressMap[account]];
940 
941         return member.creationDate;
942     }
943 
944     /**
945      * @dev Check how many tokens staked for given address
946      * @param members Current members struct
947      * @param account Address you want to check
948      * @return uint256 Member staked tokens
949      */
950     function stakedTokensOf(Members storage members, address account) internal view returns (uint256) {
951         Member storage member = members.list[members.addressMap[account]];
952 
953         return member.stakedTokens;
954     }
955 
956     /**
957      * @dev Check how many tokens used for given address
958      * @param members Current members struct
959      * @param account Address you want to check
960      * @return uint256 Member used tokens
961      */
962     function usedTokensOf(Members storage members, address account) internal view returns (uint256) {
963         Member storage member = members.list[members.addressMap[account]];
964 
965         return member.usedTokens;
966     }
967 
968     /**
969      * @dev Check if an address has been approved
970      * @param members Current members struct
971      * @param account Address you want to check
972      * @return bool
973      */
974     function isApproved(Members storage members, address account) internal view returns (bool) {
975         Member storage member = members.list[members.addressMap[account]];
976 
977         return member.approved;
978     }
979 
980     /**
981      * @dev Returns the member structure
982      * @param members Current members struct
983      * @param memberId Id of the member you are looking for
984      * @return Member
985      */
986     function getMember(Members storage members, uint256 memberId) internal view returns (Member storage) {
987         Member storage structure = members.list[memberId];
988 
989         require(structure.account != address(0));
990 
991         return structure;
992     }
993 
994     /**
995      * @dev Generate a new member and the member structure
996      * @param members Current members struct
997      * @param account Address you want to make member
998      * @return uint256 The new member id
999      */
1000     function addMember(Members storage members, address account) internal returns (uint256) {
1001         require(account != address(0));
1002         require(!isMember(members, account));
1003 
1004         uint256 memberId = members.count.add(1);
1005         bytes9 fingerprint = getFingerprint(account, memberId);
1006 
1007         members.addressMap[account] = memberId;
1008         members.list[memberId] = Member(
1009             memberId,
1010             account,
1011             fingerprint,
1012             block.timestamp, // solhint-disable-line not-rely-on-time
1013             0,
1014             0,
1015             "",
1016             false
1017         );
1018 
1019         members.count = memberId;
1020 
1021         return memberId;
1022     }
1023 
1024     /**
1025      * @dev Add tokens to member stack
1026      * @param members Current members struct
1027      * @param account Address you want to stake tokens
1028      * @param amount Number of tokens to stake
1029      */
1030     function stake(Members storage members, address account, uint256 amount) internal {
1031         require(isMember(members, account));
1032 
1033         Member storage member = members.list[members.addressMap[account]];
1034 
1035         member.stakedTokens = member.stakedTokens.add(amount);
1036         members.totalStakedTokens = members.totalStakedTokens.add(amount);
1037     }
1038 
1039     /**
1040      * @dev Remove tokens from member stack
1041      * @param members Current members struct
1042      * @param account Address you want to unstake tokens
1043      * @param amount Number of tokens to unstake
1044      */
1045     function unstake(Members storage members, address account, uint256 amount) internal {
1046         require(isMember(members, account));
1047 
1048         Member storage member = members.list[members.addressMap[account]];
1049 
1050         require(member.stakedTokens >= amount);
1051 
1052         member.stakedTokens = member.stakedTokens.sub(amount);
1053         members.totalStakedTokens = members.totalStakedTokens.sub(amount);
1054     }
1055 
1056     /**
1057      * @dev Use tokens from member stack
1058      * @param members Current members struct
1059      * @param account Address you want to use tokens
1060      * @param amount Number of tokens to use
1061      */
1062     function use(Members storage members, address account, uint256 amount) internal {
1063         require(isMember(members, account));
1064 
1065         Member storage member = members.list[members.addressMap[account]];
1066 
1067         require(member.stakedTokens >= amount);
1068 
1069         member.stakedTokens = member.stakedTokens.sub(amount);
1070         members.totalStakedTokens = members.totalStakedTokens.sub(amount);
1071 
1072         member.usedTokens = member.usedTokens.add(amount);
1073         members.totalUsedTokens = members.totalUsedTokens.add(amount);
1074     }
1075 
1076     /**
1077      * @dev Set the approved status for a member
1078      * @param members Current members struct
1079      * @param account Address you want to update
1080      * @param status Bool the new status for approved
1081      */
1082     function setApproved(Members storage members, address account, bool status) internal {
1083         require(isMember(members, account));
1084 
1085         Member storage member = members.list[members.addressMap[account]];
1086 
1087         member.approved = status;
1088     }
1089 
1090     /**
1091      * @dev Set data for a member
1092      * @param members Current members struct
1093      * @param account Address you want to update
1094      * @param data bytes32 updated data
1095      */
1096     function setData(Members storage members, address account, bytes32 data) internal {
1097         require(isMember(members, account));
1098 
1099         Member storage member = members.list[members.addressMap[account]];
1100 
1101         member.data = data;
1102     }
1103 
1104     /**
1105      * @dev Generate a member fingerprint
1106      * @param account Address you want to make member
1107      * @param memberId The member id
1108      * @return bytes9 It represents member fingerprint
1109      */
1110     function getFingerprint(address account, uint256 memberId) private pure returns (bytes9) {
1111         return bytes9(keccak256(abi.encodePacked(account, memberId)));
1112     }
1113 }
1114 
1115 // File: contracts/dao/DAO.sol
1116 
1117 /**
1118  * @title DAO
1119  * @author Vittorio Minacori (https://github.com/vittominacori)
1120  * @dev It identifies the DAO and Organization logic
1121  */
1122 contract DAO is ERC1363Payable, DAORoles {
1123     using SafeMath for uint256;
1124 
1125     using Organization for Organization.Members;
1126     using Organization for Organization.Member;
1127 
1128     event MemberAdded(
1129         address indexed account,
1130         uint256 id
1131     );
1132 
1133     event MemberStatusChanged(
1134         address indexed account,
1135         bool approved
1136     );
1137 
1138     event TokensStaked(
1139         address indexed account,
1140         uint256 value
1141     );
1142 
1143     event TokensUnstaked(
1144         address indexed account,
1145         uint256 value
1146     );
1147 
1148     event TokensUsed(
1149         address indexed account,
1150         address indexed dapp,
1151         uint256 value
1152     );
1153 
1154     Organization.Members private _members;
1155 
1156     constructor (IERC1363 acceptedToken) public ERC1363Payable(acceptedToken) {} // solhint-disable-line no-empty-blocks
1157 
1158     /**
1159      * @dev fallback. This function will create a new member
1160      */
1161     function () external payable { // solhint-disable-line no-complex-fallback
1162         require(msg.value == 0);
1163 
1164         _newMember(msg.sender);
1165     }
1166 
1167     /**
1168      * @dev Generate a new member and the member structure
1169      */
1170     function join() external {
1171         _newMember(msg.sender);
1172     }
1173 
1174     /**
1175      * @dev Generate a new member and the member structure
1176      * @param account Address you want to make member
1177      */
1178     function newMember(address account) external onlyOperator {
1179         _newMember(account);
1180     }
1181 
1182     /**
1183      * @dev Set the approved status for a member
1184      * @param account Address you want to update
1185      * @param status Bool the new status for approved
1186      */
1187     function setApproved(address account, bool status) external onlyOperator {
1188         _members.setApproved(account, status);
1189 
1190         emit MemberStatusChanged(account, status);
1191     }
1192 
1193     /**
1194      * @dev Set data for a member
1195      * @param account Address you want to update
1196      * @param data bytes32 updated data
1197      */
1198     function setData(address account, bytes32 data) external onlyOperator {
1199         _members.setData(account, data);
1200     }
1201 
1202     /**
1203      * @dev Use tokens from a specific account
1204      * @param account Address to use the tokens from
1205      * @param amount Number of tokens to use
1206      */
1207     function use(address account, uint256 amount) external onlyDapp {
1208         _members.use(account, amount);
1209 
1210         IERC20(acceptedToken()).transfer(msg.sender, amount);
1211 
1212         emit TokensUsed(account, msg.sender, amount);
1213     }
1214 
1215     /**
1216      * @dev Remove tokens from member stack
1217      * @param amount Number of tokens to unstake
1218      */
1219     function unstake(uint256 amount) public {
1220         _members.unstake(msg.sender, amount);
1221 
1222         IERC20(acceptedToken()).transfer(msg.sender, amount);
1223 
1224         emit TokensUnstaked(msg.sender, amount);
1225     }
1226 
1227     /**
1228      * @dev Returns the members number
1229      * @return uint256
1230      */
1231     function membersNumber() public view returns (uint256) {
1232         return _members.count;
1233     }
1234 
1235     /**
1236      * @dev Returns the total staked tokens number
1237      * @return uint256
1238      */
1239     function totalStakedTokens() public view returns (uint256) {
1240         return _members.totalStakedTokens;
1241     }
1242 
1243     /**
1244      * @dev Returns the total used tokens number
1245      * @return uint256
1246      */
1247     function totalUsedTokens() public view returns (uint256) {
1248         return _members.totalUsedTokens;
1249     }
1250 
1251     /**
1252      * @dev Returns if an address is member or not
1253      * @param account Address of the member you are looking for
1254      * @return bool
1255      */
1256     function isMember(address account) public view returns (bool) {
1257         return _members.isMember(account);
1258     }
1259 
1260     /**
1261      * @dev Get creation date of a member
1262      * @param account Address you want to check
1263      * @return uint256 Member creation date, zero otherwise
1264      */
1265     function creationDateOf(address account) public view returns (uint256) {
1266         return _members.creationDateOf(account);
1267     }
1268 
1269     /**
1270      * @dev Check how many tokens staked for given address
1271      * @param account Address you want to check
1272      * @return uint256 Member staked tokens
1273      */
1274     function stakedTokensOf(address account) public view returns (uint256) {
1275         return _members.stakedTokensOf(account);
1276     }
1277 
1278     /**
1279      * @dev Check how many tokens used for given address
1280      * @param account Address you want to check
1281      * @return uint256 Member used tokens
1282      */
1283     function usedTokensOf(address account) public view returns (uint256) {
1284         return _members.usedTokensOf(account);
1285     }
1286 
1287     /**
1288      * @dev Check if an address has been approved
1289      * @param account Address you want to check
1290      * @return bool
1291      */
1292     function isApproved(address account) public view returns (bool) {
1293         return _members.isApproved(account);
1294     }
1295 
1296     /**
1297      * @dev Returns the member structure
1298      * @param memberAddress Address of the member you are looking for
1299      * @return array
1300      */
1301     function getMemberByAddress(address memberAddress)
1302         public
1303         view
1304         returns (
1305             uint256 id,
1306             address account,
1307             bytes9 fingerprint,
1308             uint256 creationDate,
1309             uint256 stakedTokens,
1310             uint256 usedTokens,
1311             bytes32 data,
1312             bool approved
1313         )
1314     {
1315         return getMemberById(_members.addressMap[memberAddress]);
1316     }
1317 
1318     /**
1319      * @dev Returns the member structure
1320      * @param memberId Id of the member you are looking for
1321      * @return array
1322      */
1323     function getMemberById(uint256 memberId)
1324         public
1325         view
1326         returns (
1327             uint256 id,
1328             address account,
1329             bytes9 fingerprint,
1330             uint256 creationDate,
1331             uint256 stakedTokens,
1332             uint256 usedTokens,
1333             bytes32 data,
1334             bool approved
1335         )
1336     {
1337         Organization.Member storage structure = _members.getMember(memberId);
1338 
1339         id = structure.id;
1340         account = structure.account;
1341         fingerprint = structure.fingerprint;
1342         creationDate = structure.creationDate;
1343         stakedTokens = structure.stakedTokens;
1344         usedTokens = structure.usedTokens;
1345         data = structure.data;
1346         approved = structure.approved;
1347     }
1348 
1349     /**
1350      * @dev Allow to recover tokens from contract
1351      * @param tokenAddress address The token contract address
1352      * @param tokenAmount uint256 Number of tokens to be sent
1353      */
1354     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1355         if (tokenAddress == address(acceptedToken())) {
1356             uint256 currentBalance = IERC20(acceptedToken()).balanceOf(address(this));
1357             require(currentBalance.sub(_members.totalStakedTokens) >= tokenAmount);
1358         }
1359 
1360         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1361     }
1362 
1363     /**
1364      * @dev Called after validating a `onTransferReceived`
1365      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
1366      * @param from address The address which are token transferred from
1367      * @param value uint256 The amount of tokens transferred
1368      * @param data bytes Additional data with no specified format
1369      */
1370     function _transferReceived(
1371         address operator, // solhint-disable-line no-unused-vars
1372         address from,
1373         uint256 value,
1374         bytes memory data // solhint-disable-line no-unused-vars
1375     )
1376         internal
1377     {
1378         _stake(from, value);
1379     }
1380 
1381     /**
1382      * @dev Called after validating a `onApprovalReceived`
1383      * @param owner address The address which called `approveAndCall` function
1384      * @param value uint256 The amount of tokens to be spent
1385      * @param data bytes Additional data with no specified format
1386      */
1387     function _approvalReceived(
1388         address owner,
1389         uint256 value,
1390         bytes memory data // solhint-disable-line no-unused-vars
1391     )
1392         internal
1393     {
1394         IERC20(acceptedToken()).transferFrom(owner, address(this), value);
1395 
1396         _stake(owner, value);
1397     }
1398 
1399     /**
1400      * @dev Generate a new member and the member structure
1401      * @param account Address you want to make member
1402      * @return uint256 The new member id
1403      */
1404     function _newMember(address account) internal {
1405         uint256 memberId = _members.addMember(account);
1406 
1407         emit MemberAdded(account, memberId);
1408     }
1409 
1410     /**
1411      * @dev Add tokens to member stack
1412      * @param account Address you want to stake tokens
1413      * @param amount Number of tokens to stake
1414      */
1415     function _stake(address account, uint256 amount) internal {
1416         if (!isMember(account)) {
1417             _newMember(account);
1418         }
1419 
1420         _members.stake(account, amount);
1421 
1422         emit TokensStaked(account, amount);
1423     }
1424 }