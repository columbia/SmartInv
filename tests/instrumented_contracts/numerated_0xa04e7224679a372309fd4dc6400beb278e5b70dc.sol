1 // File: openzeppelin\contracts\utils\introspection\IERC165.sol
2 // SPDX-License-Identifier: MIT
3 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 // File: openzeppelin\contracts\token\ERC721\IERC721.sol
25 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34     /**
35      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
36      */
37     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
38     /**
39      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
40      */
41     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
42     /**
43      * @dev Returns the number of tokens in ``owner``'s account.
44      */
45     function balanceOf(address owner) external view returns (uint256 balance);
46     /**
47      * @dev Returns the owner of the `tokenId` token.
48      *
49      * Requirements:
50      *
51      * - `tokenId` must exist.
52      */
53     function ownerOf(uint256 tokenId) external view returns (address owner);
54     /**
55      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
56      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
57      *
58      * Requirements:
59      *
60      * - `from` cannot be the zero address.
61      * - `to` cannot be the zero address.
62      * - `tokenId` token must exist and be owned by `from`.
63      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
64      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
65      *
66      * Emits a {Transfer} event.
67      */
68     function safeTransferFrom(
69         address from,
70         address to,
71         uint256 tokenId
72     ) external;
73     /**
74      * @dev Transfers `tokenId` token from `from` to `to`.
75      *
76      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
77      *
78      * Requirements:
79      *
80      * - `from` cannot be the zero address.
81      * - `to` cannot be the zero address.
82      * - `tokenId` token must be owned by `from`.
83      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address from,
89         address to,
90         uint256 tokenId
91     ) external;
92     /**
93      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
94      * The approval is cleared when the token is transferred.
95      *
96      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
97      *
98      * Requirements:
99      *
100      * - The caller must own the token or be an approved operator.
101      * - `tokenId` must exist.
102      *
103      * Emits an {Approval} event.
104      */
105     function approve(address to, uint256 tokenId) external;
106     /**
107      * @dev Returns the account approved for `tokenId` token.
108      *
109      * Requirements:
110      *
111      * - `tokenId` must exist.
112      */
113     function getApproved(uint256 tokenId) external view returns (address operator);
114     /**
115      * @dev Approve or remove `operator` as an operator for the caller.
116      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
117      *
118      * Requirements:
119      *
120      * - The `operator` cannot be the caller.
121      *
122      * Emits an {ApprovalForAll} event.
123      */
124     function setApprovalForAll(address operator, bool _approved) external;
125     /**
126      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
127      *
128      * See {setApprovalForAll}
129      */
130     function isApprovedForAll(address owner, address operator) external view returns (bool);
131     /**
132      * @dev Safely transfers `tokenId` token from `from` to `to`.
133      *
134      * Requirements:
135      *
136      * - `from` cannot be the zero address.
137      * - `to` cannot be the zero address.
138      * - `tokenId` token must exist and be owned by `from`.
139      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
140      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
141      *
142      * Emits a {Transfer} event.
143      */
144     function safeTransferFrom(
145         address from,
146         address to,
147         uint256 tokenId,
148         bytes calldata data
149     ) external;
150 }
151 // File: openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol
152 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
153 /**
154  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
155  * @dev See https://eips.ethereum.org/EIPS/eip-721
156  */
157 interface IERC721Enumerable is IERC721 {
158     /**
159      * @dev Returns the total amount of tokens stored by the contract.
160      */
161     function totalSupply() external view returns (uint256);
162     /**
163      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
164      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
165      */
166     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
167     /**
168      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
169      * Use along with {totalSupply} to enumerate all tokens.
170      */
171     function tokenByIndex(uint256 index) external view returns (uint256);
172 }
173 // File: openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
174 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
175 /**
176  * @title ERC721 token receiver interface
177  * @dev Interface for any contract that wants to support safeTransfers
178  * from ERC721 asset contracts.
179  */
180 interface IERC721Receiver {
181     /**
182      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
183      * by `operator` from `from`, this function is called.
184      *
185      * It must return its Solidity selector to confirm the token transfer.
186      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
187      *
188      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
189      */
190     function onERC721Received(
191         address operator,
192         address from,
193         uint256 tokenId,
194         bytes calldata data
195     ) external returns (bytes4);
196 }
197 // File: openzeppelin\contracts\security\ReentrancyGuard.sol
198 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
199 /**
200  * @dev Contract module that helps prevent reentrant calls to a function.
201  *
202  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
203  * available, which can be applied to functions to make sure there are no nested
204  * (reentrant) calls to them.
205  *
206  * Note that because there is a single `nonReentrant` guard, functions marked as
207  * `nonReentrant` may not call one another. This can be worked around by making
208  * those functions `private`, and then adding `external` `nonReentrant` entry
209  * points to them.
210  *
211  * TIP: If you would like to learn more about reentrancy and alternative ways
212  * to protect against it, check out our blog post
213  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
214  */
215 abstract contract ReentrancyGuard {
216     // Booleans are more expensive than uint256 or any type that takes up a full
217     // word because each write operation emits an extra SLOAD to first read the
218     // slot's contents, replace the bits taken up by the boolean, and then write
219     // back. This is the compiler's defense against contract upgrades and
220     // pointer aliasing, and it cannot be disabled.
221     // The values being non-zero value makes deployment a bit more expensive,
222     // but in exchange the refund on every call to nonReentrant will be lower in
223     // amount. Since refunds are capped to a percentage of the total
224     // transaction's gas, it is best to keep them low in cases like this one, to
225     // increase the likelihood of the full refund coming into effect.
226     uint256 private constant _NOT_ENTERED = 1;
227     uint256 private constant _ENTERED = 2;
228     uint256 private _status;
229     constructor() {
230         _status = _NOT_ENTERED;
231     }
232     /**
233      * @dev Prevents a contract from calling itself, directly or indirectly.
234      * Calling a `nonReentrant` function from another `nonReentrant`
235      * function is not supported. It is possible to prevent this from happening
236      * by making the `nonReentrant` function external, and making it call a
237      * `private` function that does the actual work.
238      */
239     modifier nonReentrant() {
240         // On the first call to nonReentrant, _notEntered will be true
241         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
242         // Any calls to nonReentrant after this point will fail
243         _status = _ENTERED;
244         _;
245         // By storing the original value once again, a refund is triggered (see
246         // https://eips.ethereum.org/EIPS/eip-2200)
247         _status = _NOT_ENTERED;
248     }
249 }
250 // File: bapestoken.sol
251 
252 interface IBEP20 {
253   function totalSupply() external view returns (uint256);
254   function decimals() external view returns (uint8);
255   function symbol() external view returns (string memory);
256   function name() external view returns (string memory);
257   function getOwner() external view returns (address);
258   function balanceOf(address account) external view returns (uint256);
259   function transfer(address recipient, uint256 amount) external returns (bool);
260   function allowance(address _owner, address spender) external view returns (uint256);
261   function approve(address spender, uint256 amount) external returns (bool);
262   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
263   event Transfer(address indexed from, address indexed to, uint256 value);
264   event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 interface IPancakeERC20 {
267     event Approval(address indexed owner, address indexed spender, uint value);
268     event Transfer(address indexed from, address indexed to, uint value);
269     function name() external pure returns (string memory);
270     function symbol() external pure returns (string memory);
271     function decimals() external pure returns (uint8);
272     function totalSupply() external view returns (uint);
273     function balanceOf(address owner) external view returns (uint);
274     function allowance(address owner, address spender) external view returns (uint);
275     function approve(address spender, uint value) external returns (bool);
276     function transfer(address to, uint value) external returns (bool);
277     function transferFrom(address from, address to, uint value) external returns (bool);
278     function DOMAIN_SEPARATOR() external view returns (bytes32);
279     function PERMIT_TYPEHASH() external pure returns (bytes32);
280     function nonces(address owner) external view returns (uint);
281     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
282 }
283 interface IPancakeFactory {
284     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
285     function feeTo() external view returns (address);
286     function feeToSetter() external view returns (address);
287     function getPair(address tokenA, address tokenB) external view returns (address pair);
288     function allPairs(uint) external view returns (address pair);
289     function allPairsLength() external view returns (uint);
290     function createPair(address tokenA, address tokenB) external returns (address pair);
291     function setFeeTo(address) external;
292     function setFeeToSetter(address) external;
293 }
294 interface IPancakeRouter01 {
295     function addLiquidity(
296         address tokenA,
297         address tokenB,
298         uint amountADesired,
299         uint amountBDesired,
300         uint amountAMin,
301         uint amountBMin,
302         address to,
303         uint deadline
304     ) external returns (uint amountA, uint amountB, uint liquidity);
305     function addLiquidityETH(
306         address token,
307         uint amountTokenDesired,
308         uint amountTokenMin,
309         uint amountETHMin,
310         address to,
311         uint deadline
312     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
313     function removeLiquidity(
314         address tokenA,
315         address tokenB,
316         uint liquidity,
317         uint amountAMin,
318         uint amountBMin,
319         address to,
320         uint deadline
321     ) external returns (uint amountA, uint amountB);
322     function removeLiquidityETH(
323         address token,
324         uint liquidity,
325         uint amountTokenMin,
326         uint amountETHMin,
327         address to,
328         uint deadline
329     ) external returns (uint amountToken, uint amountETH);
330     function removeLiquidityWithPermit(
331         address tokenA,
332         address tokenB,
333         uint liquidity,
334         uint amountAMin,
335         uint amountBMin,
336         address to,
337         uint deadline,
338         bool approveMax, uint8 v, bytes32 r, bytes32 s
339     ) external returns (uint amountA, uint amountB);
340     function removeLiquidityETHWithPermit(
341         address token,
342         uint liquidity,
343         uint amountTokenMin,
344         uint amountETHMin,
345         address to,
346         uint deadline,
347         bool approveMax, uint8 v, bytes32 r, bytes32 s
348     ) external returns (uint amountToken, uint amountETH);
349     function swapExactTokensForTokens(
350         uint amountIn,
351         uint amountOutMin,
352         address[] calldata path,
353         address to,
354         uint deadline
355     ) external returns (uint[] memory amounts);
356     function swapTokensForExactTokens(
357         uint amountOut,
358         uint amountInMax,
359         address[] calldata path,
360         address to,
361         uint deadline
362     ) external returns (uint[] memory amounts);
363     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
364         external
365         payable
366         returns (uint[] memory amounts);
367     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
368         external
369         returns (uint[] memory amounts);
370     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
371         external
372         returns (uint[] memory amounts);
373     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
374         external
375         payable
376         returns (uint[] memory amounts);
377     function factory() external pure returns (address);
378     function WETH() external pure returns (address);
379     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
380     function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
381     function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
382     function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
383     function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
384 }
385 interface IPancakeRouter02 is IPancakeRouter01 {
386     function removeLiquidityETHSupportingFeeOnTransferTokens(
387         address token,
388         uint liquidity,
389         uint amountTokenMin,
390         uint amountETHMin,
391         address to,
392         uint deadline
393     ) external returns (uint amountETH);
394     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
395         address token,
396         uint liquidity,
397         uint amountTokenMin,
398         uint amountETHMin,
399         address to,
400         uint deadline,
401         bool approveMax, uint8 v, bytes32 r, bytes32 s
402     ) external returns (uint amountETH);
403     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
404         uint amountIn,
405         uint amountOutMin,
406         address[] calldata path,
407         address to,
408         uint deadline
409     ) external;
410     function swapExactETHForTokensSupportingFeeOnTransferTokens(
411         uint amountOutMin,
412         address[] calldata path,
413         address to,
414         uint deadline
415     ) external payable;
416     function swapExactTokensForETHSupportingFeeOnTransferTokens(
417         uint amountIn,
418         uint amountOutMin,
419         address[] calldata path,
420         address to,
421         uint deadline
422     ) external;
423 }
424 /**
425  * @dev Contract module which provides a basic access control mechanism, where
426  * there is an account (an owner) that can be granted exclusive access to
427  * specific functions.
428  *
429  * By default, the owner account will be the one that deploys the contract. This
430  * can later be changed with {transferOwnership}.
431  *
432  * This module is used through inheritance. It will make available the modifier
433  * `onlyOwner`, which can be applied to your functions to restrict their use to
434  * the owner.
435  */
436 abstract contract Ownable {
437     address private _owner;
438     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
439     /**
440      * @dev Initializes the contract setting the deployer as the initial owner.
441      */
442     constructor () {
443         address msgSender = msg.sender;
444         _owner = msgSender;
445         emit OwnershipTransferred(address(0), msgSender);
446     }
447     /**
448      * @dev Returns the address of the current owner.
449      */
450     function owner() public view returns (address) {
451         return _owner;
452     }
453     /**
454      * @dev Throws if called by any account other than the owner.
455      */
456     modifier onlyOwner() {
457         require(owner() == msg.sender, "Ownable: caller is not the owner");
458         _;
459     }
460     /**
461      * @dev Leaves the contract without owner. It will not be possible to call
462      * `onlyOwner` functions anymore. Can only be called by the current owner.
463      *
464      * NOTE: Renouncing ownership will leave the contract without an owner,
465      * thereby removing any functionality that is only available to the owner.
466      */
467     function renounceOwnership() public onlyOwner {
468         emit OwnershipTransferred(_owner, address(0));
469         _owner = address(0);
470     }
471     /**
472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
473      * Can only be called by the current owner.
474      */
475     function transferOwnership(address newOwner) public onlyOwner {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         emit OwnershipTransferred(_owner, newOwner);
478         _owner = newOwner;
479     }
480 }
481 /**
482  * @dev Collection of functions related to the address type
483  */
484 library Address {
485     /**
486      * @dev Returns true if `account` is a contract.
487      *
488      * [IMPORTANT]
489      * ====
490      * It is unsafe to assume that an address for which this function returns
491      * false is an externally-owned account (EOA) and not a contract.
492      *
493      * Among others, `isContract` will return false for the following
494      * types of addresses:
495      *
496      *  - an externally-owned account
497      *  - a contract in construction
498      *  - an address where a contract will be created
499      *  - an address where a contract lived, but was destroyed
500      * ====
501      */
502     function isContract(address account) internal view returns (bool) {
503         // This method relies on extcodesize, which returns 0 for contracts in
504         // construction, since the code is only stored at the end of the
505         // constructor execution.
506         uint256 size;
507         // solhint-disable-next-line no-inline-assembly
508         assembly { size := extcodesize(account) }
509         return size > 0;
510     }
511     /**
512      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
513      * `recipient`, forwarding all available gas and reverting on errors.
514      *
515      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
516      * of certain opcodes, possibly making contracts go over the 2300 gas limit
517      * imposed by `transfer`, making them unable to receive funds via
518      * `transfer`. {sendValue} removes this limitation.
519      *
520      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
521      *
522      * IMPORTANT: because control is transferred to `recipient`, care must be
523      * taken to not create reentrancy vulnerabilities. Consider using
524      * {ReentrancyGuard} or the
525      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
526      */
527     function sendValue(address payable recipient, uint256 amount) internal {
528         require(address(this).balance >= amount, "Address: insufficient balance");
529         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
530         (bool success, ) = recipient.call{ value: amount }("");
531         require(success, "Address: unable to send value, recipient may have reverted");
532     }
533     /**
534      * @dev Performs a Solidity function call using a low level `call`. A
535      * plain`call` is an unsafe replacement for a function call: use this
536      * function instead.
537      *
538      * If `target` reverts with a revert reason, it is bubbled up by this
539      * function (like regular Solidity function calls).
540      *
541      * Returns the raw returned data. To convert to the expected return value,
542      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
543      *
544      * Requirements:
545      *
546      * - `target` must be a contract.
547      * - calling `target` with `data` must not revert.
548      *
549      * _Available since v3.1._
550      */
551     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
552       return functionCall(target, data, "Address: low-level call failed");
553     }
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
556      * `errorMessage` as a fallback revert reason when `target` reverts.
557      *
558      * _Available since v3.1._
559      */
560     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
561         return functionCallWithValue(target, data, 0, errorMessage);
562     }
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
565      * but also transferring `value` wei to `target`.
566      *
567      * Requirements:
568      *
569      * - the calling contract must have an ETH balance of at least `value`.
570      * - the called Solidity function must be `payable`.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
575         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
576     }
577     /**
578      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
579      * with `errorMessage` as a fallback revert reason when `target` reverts.
580      *
581      * _Available since v3.1._
582      */
583     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
584         require(address(this).balance >= value, "Address: insufficient balance for call");
585         require(isContract(target), "Address: call to non-contract");
586         // solhint-disable-next-line avoid-low-level-calls
587         (bool success, bytes memory returndata) = target.call{ value: value }(data);
588         return _verifyCallResult(success, returndata, errorMessage);
589     }
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
597         return functionStaticCall(target, data, "Address: low-level static call failed");
598     }
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
601      * but performing a static call.
602      *
603      * _Available since v3.3._
604      */
605     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
606         require(isContract(target), "Address: static call to non-contract");
607         // solhint-disable-next-line avoid-low-level-calls
608         (bool success, bytes memory returndata) = target.staticcall(data);
609         return _verifyCallResult(success, returndata, errorMessage);
610     }
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
613      * but performing a delegate call.
614      *
615      * _Available since v3.4._
616      */
617     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
618         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
619     }
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
627         require(isContract(target), "Address: delegate call to non-contract");
628         // solhint-disable-next-line avoid-low-level-calls
629         (bool success, bytes memory returndata) = target.delegatecall(data);
630         return _verifyCallResult(success, returndata, errorMessage);
631     }
632     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
633         if (success) {
634             return returndata;
635         } else {
636             // Look for revert reason and bubble it up if present
637             if (returndata.length > 0) {
638                 // The easiest way to bubble the revert reason is using memory via assembly
639                 // solhint-disable-next-line no-inline-assembly
640                 assembly {
641                     let returndata_size := mload(returndata)
642                     revert(add(32, returndata), returndata_size)
643                 }
644             } else {
645                 revert(errorMessage);
646             }
647         }
648     }
649 }
650 /**
651  * @dev Library for managing
652  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
653  * types.
654  *
655  * Sets have the following properties:
656  *
657  * - Elements are added, removed, and checked for existence in constant time
658  * (O(1)).
659  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
660  *
661  * ```
662  * contract Example {
663  *     // Add the library methods
664  *     using EnumerableSet for EnumerableSet.AddressSet;
665  *
666  *     // Declare a set state variable
667  *     EnumerableSet.AddressSet private mySet;
668  * }
669  * ```
670  *
671  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
672  * and `uint256` (`UintSet`) are supported.
673  */
674 library EnumerableSet {
675     // To implement this library for multiple types with as little code
676     // repetition as possible, we write it in terms of a generic Set type with
677     // bytes32 values.
678     // The Set implementation uses private functions, and user-facing
679     // implementations (such as AddressSet) are just wrappers around the
680     // underlying Set.
681     // This means that we can only create new EnumerableSets for types that fit
682     // in bytes32.
683     struct Set {
684         // Storage of set values
685         bytes32[] _values;
686         // Position of the value in the `values` array, plus 1 because index 0
687         // means a value is not in the set.
688         mapping (bytes32 => uint256) _indexes;
689     }
690     /**
691      * @dev Add a value to a set. O(1).
692      *
693      * Returns true if the value was added to the set, that is if it was not
694      * already present.
695      */
696     function _add(Set storage set, bytes32 value) private returns (bool) {
697         if (!_contains(set, value)) {
698             set._values.push(value);
699             // The value is stored at length-1, but we add 1 to all indexes
700             // and use 0 as a sentinel value
701             set._indexes[value] = set._values.length;
702             return true;
703         } else {
704             return false;
705         }
706     }
707     /**
708      * @dev Removes a value from a set. O(1).
709      *
710      * Returns true if the value was removed from the set, that is if it was
711      * present.
712      */
713     function _remove(Set storage set, bytes32 value) private returns (bool) {
714         // We read and store the value's index to prevent multiple reads from the same storage slot
715         uint256 valueIndex = set._indexes[value];
716         if (valueIndex != 0) { // Equivalent to contains(set, value)
717             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
718             // the array, and then remove the last element (sometimes called as 'swap and pop').
719             // This modifies the order of the array, as noted in {at}.
720             uint256 toDeleteIndex = valueIndex - 1;
721             uint256 lastIndex = set._values.length - 1;
722             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
723             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
724             bytes32 lastvalue = set._values[lastIndex];
725             // Move the last value to the index where the value to delete is
726             set._values[toDeleteIndex] = lastvalue;
727             // Update the index for the moved value
728             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
729             // Delete the slot where the moved value was stored
730             set._values.pop();
731             // Delete the index for the deleted slot
732             delete set._indexes[value];
733             return true;
734         } else {
735             return false;
736         }
737     }
738     /**
739      * @dev Returns true if the value is in the set. O(1).
740      */
741     function _contains(Set storage set, bytes32 value) private view returns (bool) {
742         return set._indexes[value] != 0;
743     }
744     /**
745      * @dev Returns the number of values on the set. O(1).
746      */
747     function _length(Set storage set) private view returns (uint256) {
748         return set._values.length;
749     }
750    /**
751     * @dev Returns the value stored at position `index` in the set. O(1).
752     *
753     * Note that there are no guarantees on the ordering of values inside the
754     * array, and it may change when more values are added or removed.
755     *
756     * Requirements:
757     *
758     * - `index` must be strictly less than {length}.
759     */
760     function _at(Set storage set, uint256 index) private view returns (bytes32) {
761         require(set._values.length > index, "EnumerableSet: index out of bounds");
762         return set._values[index];
763     }
764     // Bytes32Set
765     struct Bytes32Set {
766         Set _inner;
767     }
768     /**
769      * @dev Add a value to a set. O(1).
770      *
771      * Returns true if the value was added to the set, that is if it was not
772      * already present.
773      */
774     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
775         return _add(set._inner, value);
776     }
777     /**
778      * @dev Removes a value from a set. O(1).
779      *
780      * Returns true if the value was removed from the set, that is if it was
781      * present.
782      */
783     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
784         return _remove(set._inner, value);
785     }
786     /**
787      * @dev Returns true if the value is in the set. O(1).
788      */
789     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
790         return _contains(set._inner, value);
791     }
792     /**
793      * @dev Returns the number of values in the set. O(1).
794      */
795     function length(Bytes32Set storage set) internal view returns (uint256) {
796         return _length(set._inner);
797     }
798    /**
799     * @dev Returns the value stored at position `index` in the set. O(1).
800     *
801     * Note that there are no guarantees on the ordering of values inside the
802     * array, and it may change when more values are added or removed.
803     *
804     * Requirements:
805     *
806     * - `index` must be strictly less than {length}.
807     */
808     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
809         return _at(set._inner, index);
810     }
811     // AddressSet
812     struct AddressSet {
813         Set _inner;
814     }
815     /**
816      * @dev Add a value to a set. O(1).
817      *
818      * Returns true if the value was added to the set, that is if it was not
819      * already present.
820      */
821     function add(AddressSet storage set, address value) internal returns (bool) {
822         return _add(set._inner, bytes32(uint256(uint160(value))));
823     }
824     /**
825      * @dev Removes a value from a set. O(1).
826      *
827      * Returns true if the value was removed from the set, that is if it was
828      * present.
829      */
830     function remove(AddressSet storage set, address value) internal returns (bool) {
831         return _remove(set._inner, bytes32(uint256(uint160(value))));
832     }
833     /**
834      * @dev Returns true if the value is in the set. O(1).
835      */
836     function contains(AddressSet storage set, address value) internal view returns (bool) {
837         return _contains(set._inner, bytes32(uint256(uint160(value))));
838     }
839     /**
840      * @dev Returns the number of values in the set. O(1).
841      */
842     function length(AddressSet storage set) internal view returns (uint256) {
843         return _length(set._inner);
844     }
845    /**
846     * @dev Returns the value stored at position `index` in the set. O(1).
847     *
848     * Note that there are no guarantees on the ordering of values inside the
849     * array, and it may change when more values are added or removed.
850     *
851     * Requirements:
852     *
853     * - `index` must be strictly less than {length}.
854     */
855     function at(AddressSet storage set, uint256 index) internal view returns (address) {
856         return address(uint160(uint256(_at(set._inner, index))));
857     }
858     // UintSet
859     struct UintSet {
860         Set _inner;
861     }
862     /**
863      * @dev Add a value to a set. O(1).
864      *
865      * Returns true if the value was added to the set, that is if it was not
866      * already present.
867      */
868     function add(UintSet storage set, uint256 value) internal returns (bool) {
869         return _add(set._inner, bytes32(value));
870     }
871     /**
872      * @dev Removes a value from a set. O(1).
873      *
874      * Returns true if the value was removed from the set, that is if it was
875      * present.
876      */
877     function remove(UintSet storage set, uint256 value) internal returns (bool) {
878         return _remove(set._inner, bytes32(value));
879     }
880     /**
881      * @dev Returns true if the value is in the set. O(1).
882      */
883     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
884         return _contains(set._inner, bytes32(value));
885     }
886     /**
887      * @dev Returns the number of values on the set. O(1).
888      */
889     function length(UintSet storage set) internal view returns (uint256) {
890         return _length(set._inner);
891     }
892    /**
893     * @dev Returns the value stored at position `index` in the set. O(1).
894     *
895     * Note that there are no guarantees on the ordering of values inside the
896     * array, and it may change when more values are added or removed.
897     *
898     * Requirements:
899     *
900     * - `index` must be strictly less than {length}.
901     */
902     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
903         return uint256(_at(set._inner, index));
904     }
905 }
906 ////////////////////////////////////////////////////////////////////////////////////////////////////////
907 //BallerX Contract ////////////////////////////////////////////////////////////////////////////////
908 ////////////////////////////////////////////////////////////////////////////////////////////////////////
909 contract BAPE is IBEP20, Ownable, IERC721Receiver, ReentrancyGuard
910 {
911     using Address for address;
912     using EnumerableSet for EnumerableSet.AddressSet;
913     mapping (address => uint256) private _balances;
914     mapping (address => mapping (address => uint256)) private _allowances;
915     EnumerableSet.AddressSet private _excluded;
916     //Token Info 
917     string private constant _name = 'BAPE';
918     string private constant _symbol = 'BAPE';
919     uint8 private constant _decimals = 9;
920     uint256 public constant InitialSupply= 1 * 10**9 * 10**_decimals;
921     uint256 swapLimit = 5 * 10**6 * 10**_decimals; // 0,5%
922     bool isSwapPegged = false;
923     //Divider for the buyLimit based on circulating Supply (1%)
924     uint16 public constant BuyLimitDivider=1;
925     //Divider for the MaxBalance based on circulating Supply (1.5%)
926     uint8 public constant BalanceLimitDivider=1;
927     //Divider for the Whitelist MaxBalance based on initial Supply(1.5%)
928     uint16 public constant WhiteListBalanceLimitDivider=1;
929     //Divider for sellLimit based on circulating Supply (1%)
930     uint16 public constant SellLimitDivider=100;
931     // Chef address
932     address public chefAddress = 0x000000000000000000000000000000000000dEaD;
933     // Limits control 
934     bool sellLimitActive = true;
935     bool buyLimitActive = true;
936     bool balanceLimitActive = true;
937     // Team control switch
938     bool _teamEnabled = true;
939     // Team wallets
940     address public constant marketingWallet=0xECB1C6fa4fAea49047Fa0748B0a1d30136Baa73F;
941     address public constant developmentWallet=0x4223b10d22bF8634d5128F588600C65F854cd20c;
942     address public constant charityWallet=0x65685081E64FCBD2377C95E5ccb6167ff5f503d3;
943     // Uniswap v2 Router
944     address private constant PancakeRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
945     // Cooldown vars 
946     bool cooldown = true;
947     mapping(address => bool) hasTraded;
948     mapping(address => uint256) lastTrade;
949     uint256 cooldownTime = 1 seconds;
950     //variables that track balanceLimit and sellLimit,
951     //can be updated based on circulating supply and Sell- and BalanceLimitDividers
952     uint256 private _circulatingSupply =InitialSupply;
953     uint256 public  balanceLimit = _circulatingSupply;
954     uint256 public  sellLimit = _circulatingSupply;
955     uint256 public  buyLimit = _circulatingSupply;
956     address[] public triedToDump;
957     //Limits max tax, only gets applied for tax changes, doesn't affect inital Tax
958     uint8 public constant MaxTax=49;
959     // claim Settings
960     uint256 public claimFrequency = 86400 seconds;
961     mapping(address => uint256) private _nftHolderLastTransferTimestamp;
962     mapping(uint256 => uint256) private _nftStakeTime;
963     mapping(uint256 => uint256) private _nftStakePeriod;
964     bool public claimEnabled = true;
965     bool public checkTxSigner = true;
966     bool public checkClaimFrequency = true;
967     bool public checkTxMsgSigner = true;
968     address private passwordSigner = 0x81bEE9fF7f8d1D9c32B7BB5714A4236e078E9eCC;
969     mapping(uint256 => bool) private _txMsgSigner;
970     //Tracks the current Taxes, different Taxes can be applied for buy/sell/transfer
971     uint8 private _buyTax;
972     uint8 private _sellTax;
973     uint8 private _transferTax;
974     uint8 private _liquidityTax;
975     uint8 private _distributedTax;
976     bool isTokenSwapManual = true;
977     address private _pancakePairAddress; 
978     IPancakeRouter02 private  _pancakeRouter;
979     //modifier for functions only the team can call
980     modifier onlyTeam() {
981         require(_isTeam(msg.sender), "Caller not in Team");
982         _;
983     }
984     modifier onlyChef() {
985         require(_isChef(msg.sender), "Caller is not chef");
986         _;
987     }
988     //Checks if address is in Team, is needed to give Team access even if contract is renounced
989     //Team doesn't have access to critical Functions that could turn this into a Rugpull(Exept liquidity unlocks)
990     function _isTeam(address addr) private view returns (bool){
991         if(!_teamEnabled) {
992             return false;
993         }
994         return addr==owner()||addr==marketingWallet||addr==charityWallet||addr==developmentWallet;
995     }
996     function _isChef(address addr) private view returns (bool) {
997         return addr==chefAddress;
998     }
999     //erc1155 receiver
1000     //addresses 
1001     using EnumerableSet for EnumerableSet.UintSet; 
1002     address nullAddress = 0x0000000000000000000000000000000000000000;
1003     address public bapesNftAddress;
1004         // mappings 
1005     mapping(address => EnumerableSet.UintSet) private _deposits;
1006     bool public _addBackLiquidity = false;
1007     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1008     //Constructor///////////////////////////////////////////////////////////////////////////////////////////
1009     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1010     constructor () {
1011         //contract creator gets 90% of the token to create LP-Pair
1012         uint256 deployerBalance=_circulatingSupply*9/10;
1013         _balances[msg.sender] = deployerBalance;
1014         emit Transfer(address(0), msg.sender, deployerBalance);
1015         //contract gets 10% of the token to generate LP token and Marketing Budget fase
1016         //contract will sell token over the first 200 sells to generate maximum LP and BNB
1017         uint256 injectBalance=_circulatingSupply-deployerBalance;
1018         _balances[address(this)]=injectBalance;
1019        emit Transfer(address(0), address(this),injectBalance);
1020         // Pancake Router
1021         _pancakeRouter = IPancakeRouter02(PancakeRouter);
1022         //Creates a Pancake Pair
1023         _pancakePairAddress = IPancakeFactory(_pancakeRouter.factory()).createPair(address(this), _pancakeRouter.WETH());
1024         //Sets Buy/Sell limits
1025         balanceLimit=InitialSupply/BalanceLimitDivider;
1026         sellLimit=InitialSupply/SellLimitDivider;
1027         buyLimit=InitialSupply/BuyLimitDivider;
1028         _buyTax=8;
1029         _sellTax=10;
1030         _transferTax=0;
1031         _distributedTax=100;
1032         _liquidityTax=0;
1033         //Team wallet and deployer are excluded from Taxes
1034         _excluded.add(charityWallet);
1035         _excluded.add(developmentWallet);
1036         _excluded.add(marketingWallet);
1037         _excluded.add(developmentWallet);
1038         _excluded.add(msg.sender);
1039     }
1040     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1041     //Transfer functionality////////////////////////////////////////////////////////////////////////////////
1042     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1043     //transfer function, every transfer runs through this function
1044     function _transfer(address sender, address recipient, uint256 amount) private{
1045         require(sender != address(0), "Transfer from zero");
1046         require(recipient != address(0), "Transfer to zero");
1047         //Manually Excluded adresses are transfering tax and lock free
1048         bool isExcluded = (_excluded.contains(sender) || _excluded.contains(recipient));
1049         //Transactions from and to the contract are always tax and lock free
1050         bool isContractTransfer=(sender==address(this) || recipient==address(this));
1051         //transfers between PancakeRouter and PancakePair are tax and lock free
1052         address pancakeRouter=address(_pancakeRouter);
1053         bool isLiquidityTransfer = ((sender == _pancakePairAddress && recipient == pancakeRouter) 
1054         || (recipient == _pancakePairAddress && sender == pancakeRouter));
1055         //differentiate between buy/sell/transfer to apply different taxes/restrictions
1056         bool isBuy=sender==_pancakePairAddress|| sender == pancakeRouter;
1057         bool isSell=recipient==_pancakePairAddress|| recipient == pancakeRouter;
1058         //Pick transfer
1059         if(isContractTransfer || isLiquidityTransfer || isExcluded){
1060             _feelessTransfer(sender, recipient, amount);
1061         } else{
1062             require(tradingEnabled, "Trading is disabled");
1063             // Cooldown logic (excluded people have no cooldown and contract too) 
1064             if(cooldown) {
1065                 if (hasTraded[msg.sender]) {
1066                     lastTrade[msg.sender] = block.timestamp;
1067                     require(block.timestamp < (lastTrade[msg.sender] + cooldownTime));
1068                 } else {
1069                     hasTraded[msg.sender] = true;
1070                 }
1071             }
1072             _taxedTransfer(sender,recipient,amount,isBuy,isSell);                  
1073         }
1074     }
1075     //applies taxes, checks for limits, locks generates autoLP and stakingBNB, and autostakes
1076     function _taxedTransfer(address sender, address recipient, uint256 amount,bool isBuy,bool isSell) private{
1077         uint256 recipientBalance = _balances[recipient];
1078         uint256 senderBalance = _balances[sender];
1079         require(senderBalance >= amount, "Transfer exceeds balance");
1080         swapLimit = sellLimit/2;
1081         uint8 tax;
1082         if(isSell){
1083             if (sellLimitActive) {
1084                 require(amount<=sellLimit,"Dump protection");
1085             }
1086             tax=_sellTax;
1087         } else if(isBuy){
1088             //Checks If the recipient balance(excluding Taxes) would exceed Balance Limit
1089             if (balanceLimitActive) {
1090                 require(recipientBalance+amount<=(balanceLimit*2),"whale protection");
1091             }
1092             if (buyLimitActive) {
1093                 require(amount<=buyLimit, "whale protection");
1094             }
1095             tax=_buyTax;
1096         } else {//Transfer
1097             //Checks If the recipient balance(excluding Taxes) would exceed Balance Limit
1098             require(recipientBalance+amount<=balanceLimit,"whale protection");
1099             //Transfers are disabled in sell lock, this doesn't stop someone from transfering before
1100             //selling, but there is no satisfying solution for that, and you would need to pax additional tax
1101             tax=_transferTax;
1102         }     
1103         //Swapping AutoLP and MarketingBNB is only possible if sender is not pancake pair, 
1104         //if its not manually disabled, if its not already swapping and if its a Sell to avoid
1105         // people from causing a large price impact from repeatedly transfering when theres a large backlog of Tokens
1106         if((sender!=_pancakePairAddress)&&(!manualConversion)&&(!_isSwappingContractModifier))
1107             _swapContractToken(amount);
1108         //staking and liquidity Tax get treated the same, only during conversion they get split
1109         uint256 contractToken=_calculateFee(amount, tax, _distributedTax+_liquidityTax);
1110         //Subtract the Taxed Tokens from the amount
1111         uint256 taxedAmount=amount-(contractToken);
1112         //Removes token and handles staking
1113         _removeToken(sender,amount);
1114         //Adds the taxed tokens to the contract wallet
1115         _balances[address(this)] += contractToken;
1116         //Adds token and handles staking
1117         _addToken(recipient, taxedAmount);
1118         emit Transfer(sender,recipient,taxedAmount);
1119     }
1120     //Feeless transfer only transfers and autostakes
1121     function _feelessTransfer(address sender, address recipient, uint256 amount) private{
1122         uint256 senderBalance = _balances[sender];
1123         require(senderBalance >= amount, "Transfer exceeds balance");
1124         //Removes token and handles staking
1125         _removeToken(sender,amount);
1126         //Adds token and handles staking
1127         _addToken(recipient, amount);
1128         emit Transfer(sender,recipient,amount);
1129     }
1130     //Calculates the token that should be taxed
1131     function _calculateFee(uint256 amount, uint8 tax, uint8 taxPercent) private pure returns (uint256) {
1132         return (amount*tax*taxPercent) / 10000;
1133     }
1134     //removes Token, adds BNB to the toBePaid mapping and resets staking
1135     function _removeToken(address addr, uint256 amount) private {
1136         //the amount of token after transfer
1137         uint256 newAmount=_balances[addr]-amount;
1138         _balances[address(this)] += amount;
1139         _balances[addr]=newAmount;
1140         emit Transfer(addr, address(this), amount); 
1141     }
1142     //lock for the withdraw
1143     bool private _isTokenSwaping;
1144     //the total reward distributed through staking, for tracking purposes
1145     uint256 public totalTokenSwapGenerated;
1146     //the total payout through staking, for tracking purposes
1147     uint256 public totalPayouts;
1148     //marketing share of the TokenSwap tax
1149     uint8 public _marketingShare=40;
1150     //marketing share of the TokenSwap tax
1151     uint8 public _charityShare=20;
1152     //marketing share of the TokenSwap tax
1153     uint8 public _developmentShare=40;
1154     //balance that is claimable by the team
1155     uint256 public marketingBalance;
1156     uint256 public developmentBalance;
1157     uint256 public charityBalance;
1158     //Mapping of shares that are reserved for payout
1159     mapping(address => uint256) private toBePaid;
1160     //distributes bnb between marketing, development and charity
1161     function _distributeFeesBNB(uint256 BNBamount) private {
1162         // Deduct marketing Tax
1163         uint256 marketingSplit = (BNBamount * _marketingShare) / 100;
1164         uint256 charitySplit = (BNBamount * _charityShare) / 100;
1165         uint256 developmentSplit = (BNBamount * _developmentShare) / 100;
1166         // Safety check to avoid solidity division imprecision
1167         if ((marketingSplit+charitySplit+developmentSplit) > address(this).balance) {
1168             uint256 toRemove = (marketingSplit+charitySplit+developmentSplit) - address(this).balance;
1169             developmentSplit -= toRemove; 
1170         }
1171         // Updating balances
1172         marketingBalance+=marketingSplit;
1173         charityBalance+=charitySplit;
1174         developmentBalance += developmentSplit;
1175     }
1176     function _addToken(address addr, uint256 amount) private {
1177         //the amount of token after transfer
1178         uint256 newAmount=_balances[addr]+amount;
1179         _balances[addr]=newAmount;
1180     }
1181     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1182     //Swap Contract Tokens//////////////////////////////////////////////////////////////////////////////////
1183     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1184     //tracks auto generated BNB, useful for ticker etc
1185     uint256 public totalLPBNB;
1186     //Locks the swap if already swapping
1187     bool private _isSwappingContractModifier;
1188     modifier lockTheSwap {
1189         _isSwappingContractModifier = true;
1190         _;
1191         _isSwappingContractModifier = false;
1192     }
1193     //swaps the token on the contract for Marketing BNB and LP Token.
1194     //always swaps the sellLimit of token to avoid a large price impact
1195     function _swapContractToken(uint256 totalMax) private lockTheSwap{
1196         uint256 contractBalance=_balances[address(this)];
1197         uint16 totalTax=_liquidityTax+_distributedTax;
1198         uint256 tokenToSwap=swapLimit;
1199         if(tokenToSwap > totalMax) {
1200             if(isSwapPegged) {
1201                 tokenToSwap = totalMax;
1202             }
1203         }
1204         //only swap if contractBalance is larger than tokenToSwap, and totalTax is unequal to 0
1205         if(contractBalance<tokenToSwap||totalTax==0){
1206             return;
1207         }
1208         //splits the token in TokenForLiquidity and tokenForMarketing
1209         uint256 tokenForLiquidity=(tokenToSwap*_liquidityTax)/totalTax;
1210         uint256 tokenLeft = tokenToSwap - tokenForLiquidity;
1211         //splits tokenForLiquidity in 2 halves
1212         uint256 liqToken=tokenForLiquidity/2;
1213         uint256 liqBNBToken=tokenForLiquidity-liqToken;
1214         //swaps fees tokens and the liquidity token half for BNB
1215         uint256 swapToken=liqBNBToken+tokenLeft;
1216         //Gets the initial BNB balance, so swap won't touch any other BNB
1217         uint256 initialBNBBalance = address(this).balance;
1218         _swapTokenForBNB(swapToken);
1219         uint256 newBNB=(address(this).balance - initialBNBBalance);
1220         //calculates the amount of BNB belonging to the LP-Pair and converts them to LP
1221         if(_addBackLiquidity)
1222         {
1223             uint256 liqBNB = (newBNB*liqBNBToken)/swapToken;
1224             _addLiquidity(liqToken, liqBNB);
1225         }
1226         //Get the BNB balance after LP generation to get the
1227         //exact amount of bnb left to distribute
1228         uint256 generatedBNB=(address(this).balance - initialBNBBalance);
1229         //distributes remaining BNB between stakers and Marketing
1230         _distributeFeesBNB(generatedBNB);
1231     }
1232     //swaps tokens on the contract for BNB
1233     function _swapTokenForBNB(uint256 amount) private {
1234         _approve(address(this), address(_pancakeRouter), amount);
1235         address[] memory path = new address[](2);
1236         path[0] = address(this);
1237         path[1] = _pancakeRouter.WETH();
1238         _pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1239             amount,
1240             0,
1241             path,
1242             address(this),
1243             block.timestamp
1244         );
1245     }
1246     //Adds Liquidity directly to the contract where LP are locked
1247     function _addLiquidity(uint256 tokenamount, uint256 bnbamount) private {
1248         totalLPBNB+=bnbamount;
1249         _approve(address(this), address(_pancakeRouter), tokenamount);
1250         _pancakeRouter.addLiquidityETH{value: bnbamount}(
1251             address(this),
1252             tokenamount,
1253             0,
1254             0,
1255             address(this),
1256             block.timestamp
1257         );
1258     }
1259     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1260     //Settings//////////////////////////////////////////////////////////////////////////////////////////////
1261     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1262     bool public sellLockDisabled;
1263     uint256 public sellLockTime;
1264     bool public manualConversion;
1265     function mint(uint256 qty) public onlyChef {
1266         _circulatingSupply = _circulatingSupply + qty;
1267         _balances[chefAddress] = _balances[chefAddress] + qty;
1268         emit Transfer(address(0), chefAddress, qty);
1269     }
1270     function mintClaim(address account,uint256 qty) internal {
1271         _circulatingSupply = _circulatingSupply + qty;
1272         _balances[account] = _balances[account] + qty;
1273         emit Transfer(address(0), account, qty);
1274     }
1275     function burn(uint256 qty) public onlyChef {
1276         _circulatingSupply = _circulatingSupply + qty;
1277         _balances[chefAddress] = _balances[chefAddress] - qty;
1278         emit Transfer(address(0), chefAddress, qty);
1279     }
1280     // Cooldown control 
1281     function isCooldownEnabled(bool booly) public onlyTeam {
1282         cooldown = booly;
1283     }
1284     function setCooldownTime(uint256 time) public onlyTeam {
1285         cooldownTime = time;
1286     }
1287     // This will DISABLE every control from the team 
1288     function renounceTeam() public onlyTeam {
1289         _teamEnabled = false;
1290     }
1291     function TeamSetChef(address addy) public onlyTeam {
1292         chefAddress = addy;
1293     }
1294     function TeamIsActiveSellLimit(bool booly) public onlyTeam {
1295         sellLimitActive = booly;
1296     }
1297     function TeamIsActiveBuyLimit(bool booly) public onlyTeam {
1298         buyLimitActive = booly;
1299     }
1300     function TeamIsActiveBalanceLimit(bool booly) public onlyTeam {
1301         balanceLimitActive = booly;
1302     }
1303     function TeamEnableTrading() public onlyTeam {
1304         tradingEnabled = true;
1305     }
1306     function TeamWithdrawMarketingBNB() public onlyTeam{
1307         uint256 amount=marketingBalance;
1308         marketingBalance=0;
1309         (bool sent,) =marketingWallet.call{value: (amount)}("");
1310         require(sent,"withdraw failed");
1311     } 
1312     function TeamWithdrawCharityBNB() public onlyTeam{
1313         uint256 amount=charityBalance;
1314         charityBalance=0;
1315         (bool sent,) =charityWallet.call{value: (amount)}("");
1316         require(sent,"withdraw failed");
1317     } 
1318     function TeamWithdrawDevelopmentBNB() public onlyTeam{
1319         uint256 amount=developmentBalance;
1320         developmentBalance=0;
1321         (bool sent,) =developmentWallet.call{value: (amount)}("");
1322         require(sent,"withdraw failed");
1323     } 
1324     //switches autoLiquidity and marketing BNB generation during transfers
1325     function TeamSwitchManualBNBConversion(bool manual) public onlyTeam{
1326         manualConversion=manual;
1327     }
1328     //Sets Taxes, is limited by MaxTax(49%) to make it impossible to create honeypot
1329     function TeamSetTaxes(uint8 distributedTaxes, uint8 liquidityTaxes,uint8 buyTax, uint8 sellTax, uint8 transferTax) public onlyTeam{
1330         uint8 totalTax=liquidityTaxes+distributedTaxes;
1331         require(totalTax==100, "liq+distributed needs to equal 100%");
1332         require(buyTax<=MaxTax&&sellTax<=MaxTax&&transferTax<=MaxTax,"taxes higher than max tax");
1333         _liquidityTax=liquidityTaxes;
1334         _distributedTax=distributedTaxes;
1335         _buyTax=buyTax;
1336         _sellTax=sellTax;
1337         _transferTax=transferTax;
1338     }
1339     //manually converts contract token to LP and staking BNB
1340     function TeamManualGenerateTokenSwapBalance(uint256 _qty) public onlyTeam{
1341     _swapContractToken(_qty * 10**9);
1342     }
1343     //Exclude/Include account from fees (eg. CEX)
1344     function TeamExcludeAccountFromFees(address account) public onlyTeam {
1345         _excluded.add(account);
1346     }
1347     function TeamIncludeAccountToFees(address account) public onlyTeam {
1348         _excluded.remove(account);
1349     }
1350      //Limits need to be at least 0.5%, to avoid setting value to 0(avoid potential Honeypot)
1351     function TeamUpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit) public onlyTeam{
1352         uint256 minimumLimit = 5 * 10**6;
1353         //Adds decimals to limits
1354         newBalanceLimit=newBalanceLimit*10**_decimals;
1355         newSellLimit=newSellLimit*10**_decimals;
1356         require(newBalanceLimit>=minimumLimit && newSellLimit>=minimumLimit, "Limit protection");
1357         balanceLimit = newBalanceLimit;
1358         sellLimit = newSellLimit;     
1359     }
1360     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1361     //Setup Functions///////////////////////////////////////////////////////////////////////////////////////
1362     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1363     bool public tradingEnabled=false;
1364     address private _liquidityTokenAddress;
1365     //Enables whitelist trading and locks Liquidity for a short time
1366     //Sets up the LP-Token Address required for LP Release
1367     function SetupLiquidityTokenAddress(address liquidityTokenAddress) public onlyTeam{
1368         _liquidityTokenAddress=liquidityTokenAddress;
1369     }
1370     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1371     //external//////////////////////////////////////////////////////////////////////////////////////////////
1372     ////////////////////////////////////////////////////////////////////////////////////////////////////////
1373     receive() external payable {}
1374     fallback() external payable {}
1375     // IBEP20
1376     function getOwner() external view override returns (address) {
1377         return owner();
1378     }
1379     function name() external pure override returns (string memory) {
1380         return _name;
1381     }
1382     function symbol() external pure override returns (string memory) {
1383         return _symbol;
1384     }
1385     function decimals() external pure override returns (uint8) {
1386         return _decimals;
1387     }
1388     function totalSupply() external view override returns (uint256) {
1389         return _circulatingSupply;
1390     }
1391     function balanceOf(address account) external view override returns (uint256) {
1392         return _balances[account];
1393     }
1394     function transfer(address recipient, uint256 amount) external override returns (bool) {
1395         _transfer(msg.sender, recipient, amount);
1396         return true;
1397     }
1398     function allowance(address _owner, address spender) external view override returns (uint256) {
1399         return _allowances[_owner][spender];
1400     }
1401     function approve(address spender, uint256 amount) external override returns (bool) {
1402         _approve(msg.sender, spender, amount);
1403         return true;
1404     }
1405     function _approve(address owner, address spender, uint256 amount) private {
1406         require(owner != address(0), "Approve from zero");
1407         require(spender != address(0), "Approve to zero");
1408         _allowances[owner][spender] = amount;
1409         emit Approval(owner, spender, amount);
1410     }
1411     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
1412         _transfer(sender, recipient, amount);
1413         uint256 currentAllowance = _allowances[sender][msg.sender];
1414         require(currentAllowance >= amount, "Transfer > allowance");
1415         _approve(sender, msg.sender, currentAllowance - amount);
1416         return true;
1417     }
1418     // IBEP20 - Helpers
1419     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
1420         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
1421         return true;
1422     }
1423     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
1424         uint256 currentAllowance = _allowances[msg.sender][spender];
1425         require(currentAllowance >= subtractedValue, "<0 allowance");
1426         _approve(msg.sender, spender, currentAllowance - subtractedValue);
1427         return true;
1428     }
1429     function checkLastClaim(address to)  public view returns (uint256 )
1430     {
1431         return _nftHolderLastTransferTimestamp[to];
1432     }
1433     function gethash(address to,uint nid,uint nonce)  public pure  returns (bytes memory )
1434     {
1435         return abi.encodePacked(to, nid,nonce);
1436     }
1437     function getKeccak(address to,uint nid,uint nonce)  public pure  returns (bytes32)
1438     {
1439         return keccak256(gethash(to, nid,nonce));
1440     }
1441     function getKeccakHashed(address to,uint nid,uint nonce)  public pure  returns (bytes32)
1442     {
1443         return getEthSignedMessageHash(keccak256(gethash(to, nid,nonce)));
1444     }
1445    /* function checkSignature(address to,uint256 nid,uint256 nonce, bytes memory signature) public view returns (bool) {
1446         bytes32 messageHash = keccak256(abi.encode(to, nid,nonce));
1447         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
1448         return recoverSigner(ethSignedMessageHash, signature) == passwordSigner;
1449     }
1450     */
1451     function claimTokens(address to,uint256 amount,uint256 nounce,  bytes memory signature) public  {
1452        require(claimEnabled, "Claim Disabled");
1453        if(checkTxSigner)
1454        {
1455             require(verify(to, amount,nounce,signature), "Invalid Signature");
1456        }
1457         if(checkClaimFrequency)
1458         {
1459             require(block.timestamp > _nftHolderLastTransferTimestamp[to] + claimFrequency, "Not the Claim time.");
1460         }
1461         if(checkTxMsgSigner)
1462         {
1463             require(!_txMsgSigner[nounce], "Invalid Claim");
1464             _txMsgSigner[nounce] = true;
1465             _nftHolderLastTransferTimestamp[to] = block.timestamp;
1466         }
1467         _feelessTransfer(owner(), to, amount*10**9);
1468     }
1469      function getMessageHash(
1470         address _to,
1471         uint _amount,
1472         uint _nonce
1473     ) public pure returns (bytes32) {
1474         return keccak256(abi.encodePacked(_to, _amount, _nonce));
1475     }
1476        function getEthSignedMessageHash(bytes32 _messageHash)
1477         public
1478         pure
1479         returns (bytes32)
1480     {
1481         /*
1482         Signature is produced by signing a keccak256 hash with the following format:
1483         "\x19Ethereum Signed Message\n" + len(msg) + msg
1484         */
1485         return
1486             keccak256(
1487                 abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
1488             );
1489     }
1490     function verify(
1491         address _to,
1492         uint _amount,
1493         uint _nonce,
1494         bytes memory signature
1495     ) public view returns (bool) {
1496         bytes32 messageHash = getMessageHash(_to, _amount,  _nonce);
1497         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
1498         return recoverSigner(ethSignedMessageHash, signature) == passwordSigner;
1499     }
1500     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
1501         public
1502         pure
1503         returns (address)
1504     {
1505         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1506         return ecrecover(_ethSignedMessageHash, v, r, s);
1507     }
1508     function splitSignature(bytes memory sig)
1509         public
1510         pure
1511         returns (
1512             bytes32 r,
1513             bytes32 s,
1514             uint8 v
1515         )
1516     {
1517         require(sig.length == 65, "invalid signature length");
1518         assembly {
1519             /*
1520             First 32 bytes stores the length of the signature
1521             add(sig, 32) = pointer of sig + 32
1522             effectively, skips first 32 bytes of signature
1523             mload(p) loads next 32 bytes starting at the memory address p into memory
1524             */
1525             // first 32 bytes, after the length prefix
1526             r := mload(add(sig, 32))
1527             // second 32 bytes
1528             s := mload(add(sig, 64))
1529             // final byte (first byte of the next 32 bytes)
1530             v := byte(0, mload(add(sig, 96)))
1531         }
1532         // implicitly return (r, s, v)
1533     }
1534     function setnftClaimSettings(address _passwordSigner,uint256 _claimFrequency, bool _Enabled,bool _checkTxSigner,bool _checkTxMsgSigner,bool _checkClaimFrequency) external onlyOwner {
1535         require(_claimFrequency >= 600, "cannot set clain more often than every 10 minutes");
1536         claimFrequency = _claimFrequency;
1537         passwordSigner = _passwordSigner;
1538         claimEnabled = _Enabled;
1539         checkTxSigner = _checkTxSigner;
1540         checkClaimFrequency = _checkClaimFrequency;
1541         checkTxMsgSigner = _checkTxMsgSigner;
1542     }
1543     //=======================erc1155 receiving
1544     //alter rate and expiration 
1545     function updateNftAddress(address payable newFundsTo,bool addBackLiquidity) public onlyOwner {
1546         bapesNftAddress = newFundsTo;
1547         _addBackLiquidity = addBackLiquidity;
1548     }
1549     //check deposit amount. 
1550     function depositsOf(address account)
1551       external 
1552       view 
1553       returns (uint256[] memory)
1554     {
1555       EnumerableSet.UintSet storage depositSet = _deposits[account];
1556       uint256[] memory tokenIds = new uint256[] (depositSet.length());
1557       for (uint256 i; i<depositSet.length(); i++) {
1558         tokenIds[i] = depositSet.at(i);
1559       }
1560       return tokenIds;
1561     }
1562         //deposit function. 
1563     function deposit(uint256[] calldata tokenIds,uint256 prd) external {
1564         //claimRewards(tokenIds);
1565         for (uint256 i; i < tokenIds.length; i++) {
1566             _nftStakeTime[tokenIds[i]] = block.timestamp;
1567             _nftStakePeriod[tokenIds[i]] = prd;
1568             IERC721(bapesNftAddress).safeTransferFrom(
1569                 msg.sender,
1570                 address(this),
1571                 tokenIds[i],
1572                 ''
1573             );
1574             _deposits[msg.sender].add(tokenIds[i]);
1575         }
1576     }
1577     function getNftStakeTime(uint256 tid) public view returns (uint256)
1578     {
1579         return _nftStakeTime[tid];
1580     }
1581     function getNftStakePeriod(uint256 tid) public view returns (uint256)
1582     {
1583         return _nftStakePeriod[tid];
1584     }
1585     //withdrawal function.
1586     function withdraw(address to,uint256 amount,uint256 nounce,  bytes memory signature,uint256[] calldata tokenIds) external nonReentrant() {
1587        // claimRewards(tokenIds);
1588        if(amount>0)
1589        {
1590             require(verify(to, amount,nounce,signature), "Invalid Signature");
1591             require(!_txMsgSigner[nounce], "Invalid Claim");
1592             _txMsgSigner[nounce] = true;
1593             //_nftHolderLastTransferTimestamp[to] = block.timestamp;
1594        }
1595         for (uint256 i; i < tokenIds.length; i++) {
1596             require(
1597                 _deposits[msg.sender].contains(tokenIds[i]),
1598                 'Staking: token not deposited'
1599             );
1600             _nftStakeTime[tokenIds[i]] = 0;
1601             _deposits[msg.sender].remove(tokenIds[i]);
1602             IERC721(bapesNftAddress).safeTransferFrom(
1603                 address(this),
1604                 msg.sender,
1605                 tokenIds[i],
1606                 ''
1607             );
1608         }
1609         if(amount>0)
1610        {
1611         mintClaim(to, amount*10**9);
1612        }
1613        // _feelessTransfer(owner(), to, amount*10**9);
1614     }
1615     function onERC721Received(
1616         address,
1617         address,
1618         uint256,
1619         bytes calldata
1620     ) external pure override returns (bytes4) {
1621         return IERC721Receiver.onERC721Received.selector;
1622     }
1623 }