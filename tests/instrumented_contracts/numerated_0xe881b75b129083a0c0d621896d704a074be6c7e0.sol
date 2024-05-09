1 // SPDX-License-Identifier: MIT
2 // dev: Team @Ecoterra - Robert
3 pragma solidity ^0.8.17;
4 
5 
6 interface AggregatorV3Interface {
7     function decimals() external view returns (uint8);
8 
9     function description() external view returns (string memory);
10 
11     function version() external view returns (uint256);
12 
13     function getRoundData(uint80 _roundId)
14         external
15         view
16         returns (
17             uint80 roundId,
18             int256 answer,
19             uint256 startedAt,
20             uint256 updatedAt,
21             uint80 answeredInRound
22         );
23 
24     function latestRoundData()
25         external
26         view
27         returns (
28             uint80 roundId,
29             int256 answer,
30             uint256 startedAt,
31             uint256 updatedAt,
32             uint80 answeredInRound
33         );
34 }
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Emitted when `value` tokens are moved from one account (`from`) to
42      * another (`to`).
43      *
44      * Note that `value` may be zero.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /**
49      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
50      * a call to {approve}. `value` is the new allowance.
51      */
52     event Approval(
53         address indexed owner,
54         address indexed spender,
55         uint256 value
56     );
57 
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `to`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address to, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender)
85         external
86         view
87         returns (uint256);
88 
89     /**
90      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * IMPORTANT: Beware that changing an allowance with this method brings the risk
95      * that someone may use both the old and the new allowance by unfortunate
96      * transaction ordering. One possible solution to mitigate this race
97      * condition is to first reduce the spender's allowance to 0 and set the
98      * desired value afterwards:
99      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100      *
101      * Emits an {Approval} event.
102      */
103     function approve(address spender, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Moves `amount` tokens from `from` to `to` using the
107      * allowance mechanism. `amount` is then deducted from the caller's
108      * allowance.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transferFrom(
115         address from,
116         address to,
117         uint256 amount
118     ) external returns (bool);
119 }
120 
121 /**
122  * @dev Interface for the optional metadata functions from the ERC20 standard.
123  *
124  * _Available since v4.1._
125  */
126 interface IERC20Metadata is IERC20 {
127     /**
128      * @dev Returns the name of the token.
129      */
130     function name() external view returns (string memory);
131 
132     /**
133      * @dev Returns the symbol of the token.
134      */
135     function symbol() external view returns (string memory);
136 
137     /**
138      * @dev Returns the decimals places of the token.
139      */
140     function decimals() external view returns (uint8);
141 }
142 
143 /**
144  * @dev Provides information about the current execution context, including the
145  * sender of the transaction and its data. While these are generally available
146  * via msg.sender and msg.data, they should not be accessed in such a direct
147  * manner, since when dealing with meta-transactions the account sending and
148  * paying for execution may not be the actual sender (as far as an application
149  * is concerned).
150  *
151  * This contract is only required for intermediate, library-like contracts.
152  */
153 abstract contract Context {
154     function _msgSender() internal view virtual returns (address) {
155         return msg.sender;
156     }
157 
158     function _msgData() internal view virtual returns (bytes calldata) {
159         return msg.data;
160     }
161 }
162 
163 /**
164  * @dev Contract module which provides a basic access control mechanism, where
165  * there is an account (an owner) that can be granted exclusive access to
166  * specific functions.
167  *
168  * By default, the owner account will be the one that deploys the contract. This
169  * can later be changed with {transferOwnership}.
170  *
171  * This module is used through inheritance. It will make available the modifier
172  * `onlyOwner`, which can be applied to your functions to restrict their use to
173  * the owner.
174  */
175 abstract contract Ownable is Context {
176     address private _owner;
177 
178     event OwnershipTransferred(
179         address indexed previousOwner,
180         address indexed newOwner
181     );
182 
183     /**
184      * @dev Initializes the contract setting the deployer as the initial owner.
185      */
186     constructor() {
187         _transferOwnership(_msgSender());
188     }
189 
190     /**
191      * @dev Throws if called by any account other than the owner.
192      */
193     modifier onlyOwner() {
194         _checkOwner();
195         _;
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view virtual returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if the sender is not the owner.
207      */
208     function _checkOwner() internal view virtual {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210     }
211 
212     /**
213      * @dev Leaves the contract without owner. It will not be possible to call
214      * `onlyOwner` functions anymore. Can only be called by the current owner.
215      *
216      * NOTE: Renouncing ownership will leave the contract without an owner,
217      * thereby removing any functionality that is only available to the owner.
218      */
219     function renounceOwnership() public virtual onlyOwner {
220         _transferOwnership(address(0));
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      * Can only be called by the current owner.
226      */
227     function transferOwnership(address newOwner) public virtual onlyOwner {
228         require(
229             newOwner != address(0),
230             "Ownable: new owner is the zero address"
231         );
232         _transferOwnership(newOwner);
233     }
234 
235     /**
236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
237      * Internal function without access restriction.
238      */
239     function _transferOwnership(address newOwner) internal virtual {
240         address oldOwner = _owner;
241         _owner = newOwner;
242         emit OwnershipTransferred(oldOwner, newOwner);
243     }
244 }
245 
246 /**
247  * @dev Contract module which allows children to implement an emergency stop
248  * mechanism that can be triggered by an authorized account.
249  *
250  * This module is used through inheritance. It will make available the
251  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
252  * the functions of your contract. Note that they will not be pausable by
253  * simply including this module, only once the modifiers are put in place.
254  */
255 abstract contract Pausable is Context {
256     /**
257      * @dev Emitted when the pause is triggered by `account`.
258      */
259     event Paused(address account);
260 
261     /**
262      * @dev Emitted when the pause is lifted by `account`.
263      */
264     event Unpaused(address account);
265 
266     bool private _paused;
267 
268     /**
269      * @dev Initializes the contract in unpaused state.
270      */
271     constructor() {
272         _paused = false;
273     }
274 
275     /**
276      * @dev Modifier to make a function callable only when the contract is not paused.
277      *
278      * Requirements:
279      *
280      * - The contract must not be paused.
281      */
282     modifier whenNotPaused() {
283         _requireNotPaused();
284         _;
285     }
286 
287     /**
288      * @dev Modifier to make a function callable only when the contract is paused.
289      *
290      * Requirements:
291      *
292      * - The contract must be paused.
293      */
294     modifier whenPaused() {
295         _requirePaused();
296         _;
297     }
298 
299     /**
300      * @dev Returns true if the contract is paused, and false otherwise.
301      */
302     function paused() public view virtual returns (bool) {
303         return _paused;
304     }
305 
306     /**
307      * @dev Throws if the contract is paused.
308      */
309     function _requireNotPaused() internal view virtual {
310         require(!paused(), "Pausable: paused");
311     }
312 
313     /**
314      * @dev Throws if the contract is not paused.
315      */
316     function _requirePaused() internal view virtual {
317         require(paused(), "Pausable: not paused");
318     }
319 
320     /**
321      * @dev Triggers stopped state.
322      *
323      * Requirements:
324      *
325      * - The contract must not be paused.
326      */
327     function _pause() internal virtual whenNotPaused {
328         _paused = true;
329         emit Paused(_msgSender());
330     }
331 
332     /**
333      * @dev Returns to normal state.
334      *
335      * Requirements:
336      *
337      * - The contract must be paused.
338      */
339     function _unpause() internal virtual whenPaused {
340         _paused = false;
341         emit Unpaused(_msgSender());
342     }
343 }
344 
345 /**
346  * @dev Contract module that helps prevent reentrant calls to a function.
347  *
348  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
349  * available, which can be applied to functions to make sure there are no nested
350  * (reentrant) calls to them.
351  *
352  * Note that because there is a single `nonReentrant` guard, functions marked as
353  * `nonReentrant` may not call one another. This can be worked around by making
354  * those functions `private`, and then adding `external` `nonReentrant` entry
355  * points to them.
356  *
357  * TIP: If you would like to learn more about reentrancy and alternative ways
358  * to protect against it, check out our blog post
359  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
360  */
361 abstract contract ReentrancyGuard {
362     // Booleans are more expensive than uint256 or any type that takes up a full
363     // word because each write operation emits an extra SLOAD to first read the
364     // slot's contents, replace the bits taken up by the boolean, and then write
365     // back. This is the compiler's defense against contract upgrades and
366     // pointer aliasing, and it cannot be disabled.
367 
368     // The values being non-zero value makes deployment a bit more expensive,
369     // but in exchange the refund on every call to nonReentrant will be lower in
370     // amount. Since refunds are capped to a percentage of the total
371     // transaction's gas, it is best to keep them low in cases like this one, to
372     // increase the likelihood of the full refund coming into effect.
373     uint256 private constant _NOT_ENTERED = 1;
374     uint256 private constant _ENTERED = 2;
375 
376     uint256 private _status;
377 
378     constructor() {
379         _status = _NOT_ENTERED;
380     }
381 
382     /**
383      * @dev Prevents a contract from calling itself, directly or indirectly.
384      * Calling a `nonReentrant` function from another `nonReentrant`
385      * function is not supported. It is possible to prevent this from happening
386      * by making the `nonReentrant` function external, and making it call a
387      * `private` function that does the actual work.
388      */
389     modifier nonReentrant() {
390         _nonReentrantBefore();
391         _;
392         _nonReentrantAfter();
393     }
394 
395     function _nonReentrantBefore() private {
396         // On the first call to nonReentrant, _status will be _NOT_ENTERED
397         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
398 
399         // Any calls to nonReentrant after this point will fail
400         _status = _ENTERED;
401     }
402 
403     function _nonReentrantAfter() private {
404         // By storing the original value once again, a refund is triggered (see
405         // https://eips.ethereum.org/EIPS/eip-2200)
406         _status = _NOT_ENTERED;
407     }
408 
409     /**
410      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
411      * `nonReentrant` function in the call stack.
412      */
413     function _reentrancyGuardEntered() internal view returns (bool) {
414         return _status == _ENTERED;
415     }
416 }
417 
418 contract PresaleContract is ReentrancyGuard, Ownable, Pausable {
419     struct User {
420         //token colectionati
421         uint256 tokens_amount;
422         //usdt depozitat
423         uint256 usdt_deposited;
424         //daca a dat claim sau nu
425         bool has_claimed;
426     }
427 
428     struct Round {
429         //adresa portofel in care sa ajunga bani
430         address payable wallet;
431         //cati token cumperi cu 1 usdt
432         uint256 usdt_to_token_rate;
433         //usdt + eth in usdt
434         uint256 usdt_round_raised;
435         //usdt + eth in usdt
436         uint256 usdt_round_cap;
437     }
438 
439     IERC20 public usdt_interface;
440     IERC20 public token_interface;
441     AggregatorV3Interface internal price_feed;
442 
443     mapping(address => User) public users_list;
444     Round[] public round_list;
445 
446     uint8 public current_round_index;
447     bool public presale_ended;
448 
449     event Deposit(address indexed _user_wallet, uint indexed _pay_method, uint _user_usdt_trans, uint _user_tokens_trans);
450     //  _pay_method = ( 1:eth, 2:eth_card, 3:usdt )
451 
452     constructor(
453         address oracle_, 
454         address usdt_, 
455         address token_,
456         address payable wallet_,
457         uint256 usdt_to_token_rate_,
458         uint256 usdt_round_cap_
459     ) {
460         usdt_interface = IERC20(usdt_);
461         token_interface = IERC20(token_);
462         price_feed = AggregatorV3Interface(oracle_);
463 
464         current_round_index = 0;
465         presale_ended = false;
466 
467         round_list.push(
468             Round(wallet_, usdt_to_token_rate_, 0, usdt_round_cap_ * (10**6))
469         );
470     }
471 
472     modifier canPurchase(address user, uint256 amount) {
473         require(user != address(0), "PURCHASE ERROR: User address is null!");
474         require(amount > 0, "PURCHASE ERROR: Amount is 0!");
475         require(presale_ended == false, "PURCHASE ERROR: Presale has ended!");
476         _;
477     }
478 
479     function get_eth_in_usdt() internal view returns (uint256) {
480         (, int256 price, , , ) = price_feed.latestRoundData();
481         price = price * 1e10;
482         return uint256(price);
483     }
484 
485     function buy_with_usdt(uint256 amount_)
486         external
487         nonReentrant
488         whenNotPaused
489         canPurchase(_msgSender(), amount_)
490         returns (bool)
491     {
492         uint256 amount_in_usdt = amount_;
493         require(
494             round_list[current_round_index].usdt_round_raised + amount_in_usdt <
495                 round_list[current_round_index].usdt_round_cap,
496             "BUY ERROR : Too much money already deposited."
497         );
498 
499         uint256 allowance = usdt_interface.allowance(msg.sender, address(this));
500 
501         require(amount_ <= allowance, "BUY ERROR: Allowance is too small!");
502 
503         (bool success_receive, ) = address(usdt_interface).call(
504             abi.encodeWithSignature(
505                 "transferFrom(address,address,uint256)",
506                 msg.sender,
507                 round_list[current_round_index].wallet,
508                 amount_in_usdt
509             )
510         );
511 
512         require(success_receive, "BUY ERROR: Transaction has failed!");
513 
514         uint256 amount_in_tokens = (amount_in_usdt *
515             round_list[current_round_index].usdt_to_token_rate) * 1e3;
516 
517         users_list[_msgSender()].usdt_deposited += amount_in_usdt;
518         users_list[_msgSender()].tokens_amount += amount_in_tokens;
519 
520         round_list[current_round_index].usdt_round_raised += amount_in_usdt;
521 
522         emit Deposit(_msgSender(), 3, amount_in_usdt, amount_in_tokens);
523 
524         return true;
525     }
526 
527     function buy_with_eth()
528         external
529         payable
530         nonReentrant
531         whenNotPaused
532         canPurchase(_msgSender(), msg.value)
533         returns (bool)
534     {
535 
536         uint256 amount_in_usdt = (msg.value * get_eth_in_usdt()) / 1e30;
537         require(
538             round_list[current_round_index].usdt_round_raised + amount_in_usdt <
539                 round_list[current_round_index].usdt_round_cap,
540             "BUY ERROR : Too much money already deposited."
541         );
542 
543         uint256 amount_in_tokens = (amount_in_usdt *
544             round_list[current_round_index].usdt_to_token_rate) * 1e3;
545 
546         users_list[_msgSender()].usdt_deposited += amount_in_usdt;
547         users_list[_msgSender()].tokens_amount += amount_in_tokens;
548 
549         round_list[current_round_index].usdt_round_raised += amount_in_usdt;
550 
551         (bool sent,) = round_list[current_round_index].wallet.call{value: msg.value}("");
552         require(sent, "Failed to send Ether");
553 
554         emit Deposit(_msgSender(), 1, amount_in_usdt, amount_in_tokens);
555 
556         return true;
557     }
558 
559     function buy_with_eth_wert(address user)
560         external
561         payable
562         nonReentrant
563         whenNotPaused
564         canPurchase(user, msg.value)
565         returns (bool)
566     {
567 
568         uint256 amount_in_usdt = (msg.value * get_eth_in_usdt()) / 1e30;
569         require(
570             round_list[current_round_index].usdt_round_raised + amount_in_usdt <
571                 round_list[current_round_index].usdt_round_cap,
572             "BUY ERROR : Too much money already deposited."
573         );
574 
575         uint256 amount_in_tokens = (amount_in_usdt *
576             round_list[current_round_index].usdt_to_token_rate) * 1e3;
577 
578         users_list[user].usdt_deposited += amount_in_usdt;
579         users_list[user].tokens_amount += amount_in_tokens;
580 
581         round_list[current_round_index].usdt_round_raised += amount_in_usdt;
582 
583         (bool sent,) = round_list[current_round_index].wallet.call{value: msg.value}("");
584         require(sent, "Failed to send Ether");
585 
586         emit Deposit(user, 2, amount_in_usdt, amount_in_tokens);
587 
588         return true;
589     }
590 
591     function claim_tokens() external returns (bool) {
592         require(presale_ended, "CLAIM ERROR : Presale has not ended!");
593         require(
594             users_list[_msgSender()].tokens_amount != 0,
595             "CLAIM ERROR : User already claimed tokens!"
596         );
597         require(
598             !users_list[_msgSender()].has_claimed,
599             "CLAIM ERROR : User already claimed tokens"
600         );
601 
602         uint256 tokens_to_claim = users_list[_msgSender()].tokens_amount;
603         users_list[_msgSender()].tokens_amount = 0;
604         users_list[_msgSender()].has_claimed = true;
605 
606         (bool success, ) = address(token_interface).call(
607             abi.encodeWithSignature(
608                 "transfer(address,uint256)",
609                 msg.sender,
610                 tokens_to_claim
611             )
612         );
613         require(success, "CLAIM ERROR : Couldn't transfer tokens to client!");
614 
615         return true;
616     }
617 
618     function start_next_round(
619         address payable wallet_,
620         uint256 usdt_to_token_rate_,
621         uint256 usdt_round_cap_
622     ) external onlyOwner {
623         current_round_index = current_round_index + 1;
624 
625         round_list.push(
626             Round(wallet_, usdt_to_token_rate_, 0, usdt_round_cap_ * (10**6))
627         );
628     }
629 
630     function set_current_round(
631         address payable wallet_,
632         uint256 usdt_to_token_rate_,
633         uint256 usdt_round_cap_
634     ) external onlyOwner {
635         round_list[current_round_index].wallet = wallet_;
636         round_list[current_round_index]
637             .usdt_to_token_rate = usdt_to_token_rate_;
638         round_list[current_round_index].usdt_round_cap = usdt_round_cap_ * (10**6);
639     }
640 
641     function get_current_round()
642         external
643         view
644         returns (
645             address,
646             uint256,
647             uint256,
648             uint256
649         )
650     {
651         return (
652             round_list[current_round_index].wallet,
653             round_list[current_round_index].usdt_to_token_rate,
654             round_list[current_round_index].usdt_round_raised,
655             round_list[current_round_index].usdt_round_cap
656         );
657     }
658 
659     function get_current_raised() external view returns (uint256) {
660         return round_list[current_round_index].usdt_round_raised;
661     }
662 
663     function end_presale() external onlyOwner {
664         presale_ended = true;
665     }
666 
667     function withdrawToken(address tokenContract, uint256 amount) external onlyOwner {
668         IERC20(tokenContract).transfer(_msgSender(), amount);
669     }
670 
671     function pause() external onlyOwner {
672         _pause();
673     }
674 
675     function unpause() external onlyOwner {
676         _unpause();
677     }
678 }