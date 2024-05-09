1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.18;
4 pragma abicoder v2;
5 
6 /******************************************/
7 /*           IERC20 starts here           */
8 /******************************************/
9 
10 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 /******************************************/
91 /*           Context starts here          */
92 /******************************************/
93 
94 // File: @openzeppelin/contracts/GSN/Context.sol
95 
96 /*
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data. While these are generally available
99  * via msg.sender and msg.data, they should not be accessed in such a direct
100  * manner, since when dealing with meta-transactions the account sending and
101  * paying for execution may not be the actual sender (as far as an application
102  * is concerned).
103  *
104  * This contract is only required for intermediate, library-like contracts.
105  */
106 abstract contract Context {
107     function _msgSender() internal view virtual returns (address) {
108         return msg.sender;
109     }
110 
111     function _msgData() internal view virtual returns (bytes calldata) {
112         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
113         return msg.data;
114     }
115 }
116 
117 /******************************************/
118 /*           Ownable starts here          */
119 /******************************************/
120 
121 /**
122  * @dev Contract module which provides a basic access control mechanism, where
123  * there is an account (an owner) that can be granted exclusive access to
124  * specific functions.
125  *
126  * By default, the owner account will be the one that deploys the contract. This
127  * can later be changed with {transferOwnership}.
128  *
129  * This module is used through inheritance. It will make available the modifier
130  * `onlyOwner`, which can be applied to your functions to restrict their use to
131  * the owner.
132  */
133 
134 abstract contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor() {
143         address msgSender = _msgSender();
144         _owner = msgSender;
145         emit OwnershipTransferred(address(0), msgSender);
146     }
147 
148     /**
149      * @dev Returns the address of the current owner.
150      */
151     function owner() public view virtual returns (address) {
152         return _owner;
153     }
154 
155     /**
156      * @dev Throws if called by any account other than the owner.
157      */
158     modifier onlyOwner() {
159         require(owner() == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     /**
164      * @dev Leaves the contract without owner. It will not be possible to call
165      * `onlyOwner` functions anymore. Can only be called by the current owner.
166      *
167      * NOTE: Renouncing ownership will leave the contract without an owner,
168      * thereby removing any functionality that is only available to the owner.
169      */
170     function renounceOwnership() public virtual onlyOwner {
171         emit OwnershipTransferred(_owner, address(0));
172         _owner = address(0);
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Can only be called by the current owner.
178      */
179     function transferOwnership(address newOwner) public virtual onlyOwner {
180         require(newOwner != address(0), "Ownable: new owner is the zero address");
181         emit OwnershipTransferred(_owner, newOwner);
182         _owner = newOwner;
183     }
184 }
185 
186 /******************************************/
187 /*      IERC20Metadata starts here        */
188 /******************************************/
189 
190 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
191 
192 /**
193  * @dev Interface for the optional metadata functions from the ERC20 standard.
194  *
195  * _Available since v4.1._
196  */
197 interface IERC20Metadata is IERC20 {
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the symbol of the token.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the decimals places of the token.
210      */
211     function decimals() external view returns (uint8);
212 }
213 
214 /******************************************/
215 /*           ERC20 starts here            */
216 /******************************************/
217 
218 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
219 
220 /**
221  * @dev Implementation of the {IERC20} interface.
222  *
223  * This implementation is agnostic to the way tokens are created. This means
224  * that a supply mechanism has to be added in a derived contract using {_mint}.
225  * For a generic mechanism see {ERC20PresetMinterPauser}.
226  *
227  * TIP: For a detailed writeup see our guide
228  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
229  * to implement supply mechanisms].
230  *
231  * We have followed general OpenZeppelin guidelines: functions revert instead
232  * of returning `false` on failure. This behavior is nonetheless conventional
233  * and does not conflict with the expectations of ERC20 applications.
234  *
235  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
236  * This allows applications to reconstruct the allowance for all accounts just
237  * by listening to said events. Other implementations of the EIP may not emit
238  * these events, as it isn't required by the specification.
239  *
240  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
241  * functions have been added to mitigate the well-known issues around setting
242  * allowances. See {IERC20-approve}.
243  */
244 contract ERC20 is Context, IERC20, IERC20Metadata {
245     mapping(address => uint256) private _balances;
246 
247     mapping(address => mapping(address => uint256)) private _allowances;
248 
249     uint256 private _totalSupply;
250 
251     string private _name;
252     string private _symbol;
253 
254     /**
255      * @dev Sets the values for {name} and {symbol}.
256      *
257      * The default value of {decimals} is 18. To select a different value for
258      * {decimals} you should overload it.
259      *
260      * All two of these values are immutable: they can only be set once during
261      * construction.
262      */
263     constructor(string memory name_, string memory symbol_) {
264         _name = name_;
265         _symbol = symbol_;
266     }
267 
268     /**
269      * @dev Returns the name of the token.
270      */
271     function name() public view virtual override returns (string memory) {
272         return _name;
273     }
274 
275     /**
276      * @dev Returns the symbol of the token, usually a shorter version of the
277      * name.
278      */
279     function symbol() public view virtual override returns (string memory) {
280         return _symbol;
281     }
282 
283     /**
284      * @dev Returns the number of decimals used to get its user representation.
285      * For example, if `decimals` equals `2`, a balance of `505` tokens should
286      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
287      *
288      * Tokens usually opt for a value of 18, imitating the relationship between
289      * Ether and Wei. This is the value {ERC20} uses, unless this function is
290      * overridden;
291      *
292      * NOTE: This information is only used for _display_ purposes: it in
293      * no way affects any of the arithmetic of the contract, including
294      * {IERC20-balanceOf} and {IERC20-transfer}.
295      */
296     function decimals() public view virtual override returns (uint8) {
297         return 18;
298     }
299 
300     /**
301      * @dev See {IERC20-totalSupply}.
302      */
303     function totalSupply() public view virtual override returns (uint256) {
304         return _totalSupply;
305     }
306 
307     /**
308      * @dev See {IERC20-balanceOf}.
309      */
310     function balanceOf(address account) public view virtual override returns (uint256) {
311         return _balances[account];
312     }
313 
314     /**
315      * @dev See {IERC20-transfer}.
316      *
317      * Requirements:
318      *
319      * - `recipient` cannot be the zero address.
320      * - the caller must have a balance of at least `amount`.
321      */
322     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
323         _transfer(_msgSender(), recipient, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-allowance}.
329      */
330     function allowance(address owner, address spender) public view virtual override returns (uint256) {
331         return _allowances[owner][spender];
332     }
333 
334     /**
335      * @dev See {IERC20-approve}.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function approve(address spender, uint256 amount) public virtual override returns (bool) {
342         _approve(_msgSender(), spender, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-transferFrom}.
348      *
349      * Emits an {Approval} event indicating the updated allowance. This is not
350      * required by the EIP. See the note at the beginning of {ERC20}.
351      *
352      * Requirements:
353      *
354      * - `sender` and `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      * - the caller must have allowance for ``sender``'s tokens of at least
357      * `amount`.
358      */
359     function transferFrom(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) public virtual override returns (bool) {
364         _transfer(sender, recipient, amount);
365 
366         uint256 currentAllowance = _allowances[sender][_msgSender()];
367         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
368         unchecked {
369             _approve(sender, _msgSender(), currentAllowance - amount);
370         }
371 
372         return true;
373     }
374 
375     /**
376      * @dev Atomically increases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
389         return true;
390     }
391 
392     /**
393      * @dev Atomically decreases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      * - `spender` must have allowance for the caller of at least
404      * `subtractedValue`.
405      */
406     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
407         uint256 currentAllowance = _allowances[_msgSender()][spender];
408         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
409         unchecked {
410             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
411         }
412 
413         return true;
414     }
415 
416     /**
417      * @dev Moves tokens `amount` from `sender` to `recipient`.
418      *
419      * This is internal function is equivalent to {transfer}, and can be used to
420      * e.g. implement automatic token fees, slashing mechanisms, etc.
421      *
422      * Emits a {Transfer} event.
423      *
424      * Requirements:
425      *
426      * - `sender` cannot be the zero address.
427      * - `recipient` cannot be the zero address.
428      * - `sender` must have a balance of at least `amount`.
429      */
430     function _transfer(
431         address sender,
432         address recipient,
433         uint256 amount
434     ) internal virtual {
435         require(sender != address(0), "ERC20: transfer from the zero address");
436         require(recipient != address(0), "ERC20: transfer to the zero address");
437 
438         _beforeTokenTransfer(sender, recipient, amount);
439 
440         uint256 senderBalance = _balances[sender];
441         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
442         unchecked {
443             _balances[sender] = senderBalance - amount;
444         }
445         _balances[recipient] += amount;
446 
447         emit Transfer(sender, recipient, amount);
448     }
449 
450     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
451      * the total supply.
452      *
453      * Emits a {Transfer} event with `from` set to the zero address.
454      *
455      * Requirements:
456      *
457      * - `account` cannot be the zero address.
458      */
459     function _mint(address account, uint256 amount) internal virtual {
460         require(account != address(0), "ERC20: mint to the zero address");
461 
462         _beforeTokenTransfer(address(0), account, amount);
463 
464         _totalSupply += amount;
465         _balances[account] += amount;
466         emit Transfer(address(0), account, amount);
467     }
468 
469     /**
470      * @dev Destroys `amount` tokens from `account`, reducing the
471      * total supply.
472      *
473      * Emits a {Transfer} event with `to` set to the zero address.
474      *
475      * Requirements:
476      *
477      * - `account` cannot be the zero address.
478      * - `account` must have at least `amount` tokens.
479      */
480     function _burn(address account, uint256 amount) internal virtual {
481         require(account != address(0), "ERC20: burn from the zero address");
482 
483         _beforeTokenTransfer(account, address(0), amount);
484 
485         uint256 accountBalance = _balances[account];
486         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
487         unchecked {
488             _balances[account] = accountBalance - amount;
489         }
490         _totalSupply -= amount;
491 
492         emit Transfer(account, 0x000000000000000000000000000000000000dEaD, amount);
493     }
494 
495     /**
496      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
497      *
498      * This internal function is equivalent to `approve`, and can be used to
499      * e.g. set automatic allowances for certain subsystems, etc.
500      *
501      * Emits an {Approval} event.
502      *
503      * Requirements:
504      *
505      * - `owner` cannot be the zero address.
506      * - `spender` cannot be the zero address.
507      */
508     function _approve(
509         address owner,
510         address spender,
511         uint256 amount
512     ) internal virtual {
513         require(owner != address(0), "ERC20: approve from the zero address");
514         require(spender != address(0), "ERC20: approve to the zero address");
515 
516         _allowances[owner][spender] = amount;
517         emit Approval(owner, spender, amount);
518     }
519 
520     /**
521      * @dev Hook that is called before any transfer of tokens. This includes
522      * minting and burning.
523      *
524      * Calling conditions:
525      *
526      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
527      * will be to transferred to `to`.
528      * - when `from` is zero, `amount` tokens will be minted for `to`.
529      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
530      * - `from` and `to` are never both zero.
531      *
532      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
533      */
534     function _beforeTokenTransfer(
535         address from,
536         address to,
537         uint256 amount
538     ) internal virtual {}
539 }
540 
541 /***************************************************/
542 /*   ILayerZeroUserApplicationConfig starts here   */
543 /***************************************************/
544 
545 interface ILayerZeroUserApplicationConfig {
546     // @notice set the configuration of the LayerZero messaging library of the specified version
547     // @param _version - messaging library version
548     // @param _chainId - the chainId for the pending config change
549     // @param _configType - type of configuration. every messaging library has its own convention.
550     // @param _config - configuration in the bytes. can encode arbitrary content.
551     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
552 
553     // @notice set the send() LayerZero messaging library version to _version
554     // @param _version - new messaging library version
555     function setSendVersion(uint16 _version) external;
556 
557     // @notice set the lzReceive() LayerZero messaging library version to _version
558     // @param _version - new messaging library version
559     function setReceiveVersion(uint16 _version) external;
560 
561     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
562     // @param _srcChainId - the chainId of the source chain
563     // @param _srcAddress - the contract address of the source contract at the source chain
564     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
565 }
566 
567 /******************************************/
568 /*     ILayerZeroEndpoint starts here     */
569 /******************************************/
570 
571 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
572     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
573     // @param _dstChainId - the destination chain identifier
574     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
575     // @param _payload - a custom bytes payload to send to the destination contract
576     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
577     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
578     // @param _adapterParams - parameters for custom functionality. ie: pay for a specified destination gasAmount, or receive airdropped native gas from the relayer on destination
579     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
580 
581     // @notice used by the messaging library to publish verified payload
582     // @param _srcChainId - the source chain identifier
583     // @param _srcAddress - the source contract (as bytes) at the source chain
584     // @param _dstAddress - the address on destination chain
585     // @param _nonce - the unbound message ordering nonce
586     // @param _gasLimit - the gas limit for external contract execution
587     // @param _payload - verified payload to send to the destination contract
588     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
589 
590     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
591     // @param _srcChainId - the source chain identifier
592     // @param _srcAddress - the source chain contract address
593     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
594 
595     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
596     // @param _srcAddress - the source chain contract address
597     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
598 
599     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
600     // @param _dstChainId - the destination chain identifier
601     // @param _userApplication - the user app address on this EVM chain
602     // @param _payload - the custom message to send over LayerZero
603     // @param _payInZRO - if false, user app pays the protocol fee in native token
604     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
605     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
606 
607     // @notice get this Endpoint's immutable source identifier
608     function getChainId() external view returns (uint16);
609 
610     // @notice the interface to retry failed message on this Endpoint destination
611     // @param _srcChainId - the source chain identifier
612     // @param _srcAddress - the source chain contract address
613     // @param _payload - the payload to be retried
614     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
615 
616     // @notice query if any STORED payload (message blocking) at the endpoint.
617     // @param _srcChainId - the source chain identifier
618     // @param _srcAddress - the source chain contract address
619     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
620 
621     // @notice query if the _libraryAddress is valid for sending msgs.
622     // @param _userApplication - the user app address on this EVM chain
623     function getSendLibraryAddress(address _userApplication) external view returns (address);
624 
625     // @notice query if the _libraryAddress is valid for receiving msgs.
626     // @param _userApplication - the user app address on this EVM chain
627     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
628 
629     // @notice query if the non-reentrancy guard for send() is on
630     // @return true if the guard is on. false otherwise
631     function isSendingPayload() external view returns (bool);
632 
633     // @notice query if the non-reentrancy guard for receive() is on
634     // @return true if the guard is on. false otherwise
635     function isReceivingPayload() external view returns (bool);
636 
637     // @notice get the configuration of the LayerZero messaging library of the specified version
638     // @param _version - messaging library version
639     // @param _chainId - the chainId for the pending config change
640     // @param _userApplication - the contract address of the user application
641     // @param _configType - type of configuration. every messaging library has its own convention.
642     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
643 
644     // @notice get the send() LayerZero messaging library version
645     // @param _userApplication - the contract address of the user application
646     function getSendVersion(address _userApplication) external view returns (uint16);
647 
648     // @notice get the lzReceive() LayerZero messaging library version
649     // @param _userApplication - the contract address of the user application
650     function getReceiveVersion(address _userApplication) external view returns (uint16);
651 }
652 
653 /******************************************/
654 /*     ILayerZeroReceiver starts here     */
655 /******************************************/
656 
657 interface ILayerZeroReceiver {
658     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
659     // @param _srcChainId - the source endpoint identifier
660     // @param _srcAddress - the source sending contract address from the source chain
661     // @param _nonce - the ordered message nonce
662     // @param _payload - the signed payload is the UA bytes has encoded to be sent
663     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
664 }
665 
666 /******************************************/
667 /*   OmnichainFungibleToken starts here   */
668 /******************************************/
669 
670 contract OmnichainFungibleToken is ERC20, Ownable, ILayerZeroReceiver, ILayerZeroUserApplicationConfig {
671     // the only endpointId these tokens will ever be minted on
672     // required: the LayerZero endpoint which is passed in the constructor
673     ILayerZeroEndpoint immutable public endpoint;
674     // a map of our connected contracts
675     mapping(uint16 => bytes) public dstContractLookup;
676     // pause the sendTokens()
677     bool public paused;
678     bool public isMain;
679 
680     event Paused(bool isPaused);
681     event SendToChain(uint16 dstChainId, bytes to, uint256 qty);
682     event ReceiveFromChain(uint16 srcChainId, uint64 nonce, uint256 qty);
683     event Mint(address _to, uint256 _amount);
684     event Burn(address _from, uint256 _amount);
685 
686     constructor(
687         string memory _name,
688         string memory _symbol,
689         address _endpoint,
690         uint16 _mainChainId,
691         uint256 initialSupplyOnMainEndpoint
692     ) ERC20(_name, _symbol) {
693         if (ILayerZeroEndpoint(_endpoint).getChainId() == _mainChainId) {
694             _mint(msg.sender, initialSupplyOnMainEndpoint);
695             isMain = true;
696         }
697         // set the LayerZero endpoint
698         endpoint = ILayerZeroEndpoint(_endpoint);
699     }
700 
701     function pauseSendTokens(bool _pause) external onlyOwner {
702         paused = _pause;
703         emit Paused(_pause);
704     }
705 
706     function setDestination(uint16 _dstChainId, bytes calldata _destinationContractAddress) public onlyOwner {
707         dstContractLookup[_dstChainId] = abi.encodePacked(_destinationContractAddress, address(this));
708     }
709 
710     function chainId() external view returns (uint16){
711         return endpoint.getChainId();
712     }
713 
714     function sendTokens(
715         uint16 _dstChainId, // send tokens to this chainId
716         bytes calldata _to, // where to deliver the tokens on the destination chain
717         uint256 _qty, // how many tokens to send
718         address zroPaymentAddress, // ZRO payment address
719         bytes calldata adapterParam // txParameters
720     ) public payable {
721         require(!paused, "OFT: sendTokens() is currently paused");
722 
723         // lock if leaving the safe chain, otherwise burn
724         if (isMain) {
725             // ... transferFrom the tokens to this contract for locking purposes
726             _transfer(msg.sender, address(this), _qty);
727         } else {
728             _burn(msg.sender, _qty);
729         }
730 
731         // abi.encode() the payload with the values to send
732         bytes memory payload = abi.encode(_to, _qty);
733 
734         // send LayerZero message
735         endpoint.send{value: msg.value}(
736             _dstChainId, // destination chainId
737             dstContractLookup[_dstChainId], // destination UA address
738             payload, // abi.encode()'ed bytes
739             payable(msg.sender), // refund address (LayerZero will refund any extra gas back to caller of send()
740             zroPaymentAddress, // 'zroPaymentAddress' unused for this mock/example
741             adapterParam // 'adapterParameters' unused for this mock/example
742         );
743         emit SendToChain(_dstChainId, _to, _qty);
744     }
745 
746     function lzReceive(
747         uint16 _srcChainId,
748         bytes memory _fromAddress,
749         uint64 nonce,
750         bytes memory _payload
751     ) external override {
752         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
753         require(
754             _fromAddress.length == dstContractLookup[_srcChainId].length && keccak256(_fromAddress) == keccak256(dstContractLookup[_srcChainId]),
755             "OFT: invalid source sending contract"
756         );
757 
758         // decode
759         (bytes memory _to, uint256 _qty) = abi.decode(_payload, (bytes, uint256));
760         address toAddress;
761         // load the toAddress from the bytes
762         assembly {
763             toAddress := mload(add(_to, 20))
764         }
765 
766         // mint the tokens back into existence, to the receiving address
767         if (isMain) {
768             _transfer(address(this), toAddress, _qty);
769         } else {
770             _mint(toAddress, _qty);
771         }
772 
773         emit ReceiveFromChain(_srcChainId, nonce, _qty);
774     }
775 
776     function estimateSendTokensFee(uint16 _dstChainId, bool _useZro, bytes calldata txParameters) external view returns (uint256 nativeFee, uint256 zroFee) {
777         return endpoint.estimateFees(_dstChainId, address(this), bytes(""), _useZro, txParameters);
778     }
779 
780     function setConfig(
781         uint16 _version,
782         uint16 _chainId,
783         uint256 _configType,
784         bytes calldata _config
785     ) external override onlyOwner {
786         endpoint.setConfig(_version, _chainId, _configType, _config);
787     }
788 
789     function setSendVersion(uint16 version) external override onlyOwner {
790         endpoint.setSendVersion(version);
791     }
792 
793     function setReceiveVersion(uint16 version) external override onlyOwner {
794         endpoint.setReceiveVersion(version);
795     }
796 
797     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external override onlyOwner {
798         endpoint.forceResumeReceive(_srcChainId, _srcAddress);
799     }
800 
801     function mint(address _to, uint256 _amount) external onlyOwner {
802         _mint(_to, _amount);
803         emit Mint(_to, _amount);
804     }
805 
806     function burn(address _from, uint256 _amount) external onlyOwner {
807         _burn(_from, _amount);
808         emit Burn(_from, _amount);
809     }
810 
811     function renounceOwnership() public override onlyOwner {}
812 }
813 
814 /******************************************/
815 /*       AltitudeToken starts here        */
816 /******************************************/
817 
818 contract AltitudeToken is OmnichainFungibleToken {
819     constructor(
820         string memory _name,
821         string memory _symbol,
822         address _endpoint,
823         uint16 _mainEndpointId,
824         uint256 _initialSupplyOnMainEndpoint
825     ) OmnichainFungibleToken(_name, _symbol, _endpoint, _mainEndpointId, _initialSupplyOnMainEndpoint) {}
826 }