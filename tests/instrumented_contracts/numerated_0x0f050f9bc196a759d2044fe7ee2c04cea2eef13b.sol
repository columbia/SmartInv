1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount)
24         external
25         returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender)
35         external
36         view
37         returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(
83         address indexed owner,
84         address indexed spender,
85         uint256 value
86     );
87 }
88 
89 /*
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with GSN meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 contract Context {
100   // Empty internal constructor, to prevent people from mistakenly deploying
101   // an instance of this contract, which should be used via inheritance.
102   constructor () { }
103 
104   function _msgSender() internal view returns (address payable) {
105     return payable(msg.sender);
106   }
107 
108   function _msgData() internal view returns (bytes memory) {
109     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
110     return msg.data;
111   }
112 }
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128   /**
129    * @dev Returns the addition of two unsigned integers, reverting on
130    * overflow.
131    *
132    * Counterpart to Solidity's `+` operator.
133    *
134    * Requirements:
135    * - Addition cannot overflow.
136    */
137   function add(uint256 a, uint256 b) internal pure returns (uint256) {
138     uint256 c = a + b;
139     require(c >= a, "SafeMath: addition overflow");
140 
141     return c;
142   }
143 
144   /**
145    * @dev Returns the subtraction of two unsigned integers, reverting on
146    * overflow (when the result is negative).
147    *
148    * Counterpart to Solidity's `-` operator.
149    *
150    * Requirements:
151    * - Subtraction cannot overflow.
152    */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     return sub(a, b, "SafeMath: subtraction overflow");
155   }
156 
157   /**
158    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159    * overflow (when the result is negative).
160    *
161    * Counterpart to Solidity's `-` operator.
162    *
163    * Requirements:
164    * - Subtraction cannot overflow.
165    */
166   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167     require(b <= a, errorMessage);
168     uint256 c = a - b;
169 
170     return c;
171   }
172 
173   /**
174    * @dev Returns the multiplication of two unsigned integers, reverting on
175    * overflow.
176    *
177    * Counterpart to Solidity's `*` operator.
178    *
179    * Requirements:
180    * - Multiplication cannot overflow.
181    */
182   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184     // benefit is lost if 'b' is also tested.
185     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186     if (a == 0) {
187       return 0;
188     }
189 
190     uint256 c = a * b;
191     require(c / a == b, "SafeMath: multiplication overflow");
192 
193     return c;
194   }
195 
196   /**
197    * @dev Returns the integer division of two unsigned integers. Reverts on
198    * division by zero. The result is rounded towards zero.
199    *
200    * Counterpart to Solidity's `/` operator. Note: this function uses a
201    * `revert` opcode (which leaves remaining gas untouched) while Solidity
202    * uses an invalid opcode to revert (consuming all remaining gas).
203    *
204    * Requirements:
205    * - The divisor cannot be zero.
206    */
207   function div(uint256 a, uint256 b) internal pure returns (uint256) {
208     return div(a, b, "SafeMath: division by zero");
209   }
210 
211   /**
212    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213    * division by zero. The result is rounded towards zero.
214    *
215    * Counterpart to Solidity's `/` operator. Note: this function uses a
216    * `revert` opcode (which leaves remaining gas untouched) while Solidity
217    * uses an invalid opcode to revert (consuming all remaining gas).
218    *
219    * Requirements:
220    * - The divisor cannot be zero.
221    */
222   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223     // Solidity only automatically asserts when dividing by 0
224     require(b > 0, errorMessage);
225     uint256 c = a / b;
226     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228     return c;
229   }
230 
231   /**
232    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233    * Reverts when dividing by zero.
234    *
235    * Counterpart to Solidity's `%` operator. This function uses a `revert`
236    * opcode (which leaves remaining gas untouched) while Solidity uses an
237    * invalid opcode to revert (consuming all remaining gas).
238    *
239    * Requirements:
240    * - The divisor cannot be zero.
241    */
242   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243     return mod(a, b, "SafeMath: modulo by zero");
244   }
245 
246   /**
247    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248    * Reverts with custom message when dividing by zero.
249    *
250    * Counterpart to Solidity's `%` operator. This function uses a `revert`
251    * opcode (which leaves remaining gas untouched) while Solidity uses an
252    * invalid opcode to revert (consuming all remaining gas).
253    *
254    * Requirements:
255    * - The divisor cannot be zero.
256    */
257   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258     require(b != 0, errorMessage);
259     return a % b;
260   }
261 }
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 contract Ownable is Context {
276   address private _owner;
277 
278   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280   /**
281    * @dev Initializes the contract setting the deployer as the initial owner.
282    */
283   constructor () {
284     address msgSender = _msgSender();
285     _owner = msgSender;
286     emit OwnershipTransferred(address(0), msgSender);
287   }
288 
289   /**
290    * @dev Returns the address of the current owner.
291    */
292   function owner() public view returns (address) {
293     return _owner;
294   }
295 
296   /**
297    * @dev Throws if called by any account other than the owner.
298    */
299   modifier onlyOwner() {
300     require(_owner == _msgSender(), "Ownable: caller is not the owner");
301     _;
302   }
303 
304   /**
305    * @dev Leaves the contract without owner. It will not be possible to call
306    * `onlyOwner` functions anymore. Can only be called by the current owner.
307    *
308    * NOTE: Renouncing ownership will leave the contract without an owner,
309    * thereby removing any functionality that is only available to the owner.
310    */
311   function renounceOwnership() public onlyOwner {
312     emit OwnershipTransferred(_owner, address(0));
313     _owner = address(0);
314   }
315 
316   /**
317    * @dev Transfers ownership of the contract to a new account (`newOwner`).
318    * Can only be called by the current owner.
319    */
320   function transferOwnership(address newOwner) public onlyOwner {
321     _transferOwnership(newOwner);
322   }
323 
324   /**
325    * @dev Transfers ownership of the contract to a new account (`newOwner`).
326    */
327   function _transferOwnership(address newOwner) internal {
328     require(newOwner != address(0), "Ownable: new owner is the zero address");
329     emit OwnershipTransferred(_owner, newOwner);
330     _owner = newOwner;
331   }
332 }
333 
334 contract Claiming is Ownable{
335     
336     using SafeMath for uint256;
337     
338     /**
339      * Structure of an object to pass for allowance list
340      */
341     struct allowedUser {
342         address wallet;
343         uint256 amount;
344     }
345 
346     IERC20 public token;
347     bool internal isClaimOpen;
348     uint256 internal totalUnclaimed;
349 
350     mapping(address => uint256) allowanceAmounts;
351 
352     constructor(IERC20 _token){
353         token = _token;
354         isClaimOpen = false;
355         totalUnclaimed = 0;
356     }
357 
358     event UnsuccessfulTransfer(address recipient);
359 
360     /**
361     * Ensures that claiming tokens is currently allowed by the owner.
362     */
363     modifier openClaiming() {
364         require(
365             isClaimOpen,
366             "Claiming tokens is not currently allowed."
367         );
368         _;
369     }
370 
371     /**
372     * Ensures that the amount of claimed tokens is not bigger than the user is allowed to claim.
373     */
374     modifier userHasEnoughClaimableTokens (uint256 amount) {
375         require(
376             allowanceAmounts[msg.sender] >= amount,
377             "The users token amount is smaller than the requested."
378         );
379         _;
380     }
381 
382     /**
383     * Ensures that contract has enough tokens for the transaction.
384     */
385     modifier enoughContractAmount(uint256 amount) {
386         require(
387             token.balanceOf(address(this)) >= amount, 
388             "Owned token amount is too small."
389         );
390         _;
391     }
392     
393     /**
394     * Ensures that only people from the allowance list can claim tokens.
395     */
396     modifier userHasClaimableTokens() {
397         require(
398             allowanceAmounts[msg.sender] > 0,
399             "There is no tokens for the user to claim or the user is not allowed to do so."
400         );
401         _;
402     }
403     
404     modifier hasContractTokens() {
405         require(
406             token.balanceOf(address(this)) > 0,
407             "There is no tokens for the user to claim or the user is not allowed to do so."
408         );
409         _;
410     }
411 
412     /** @dev Transfers the spacified number of tokens to the user requesting
413      *
414      * Substracts the requested amount of tokens from the allowance amount of the user
415      * Transfers tokens from contract to the message sender
416      * In case of failure restores the previous allowance amount
417      *
418      * Requirements:
419      *
420      * - message sender cannot be address(0) and has to be in AllowanceList
421      */
422     function claimCustomAmountTokens(uint256 amount)
423         public 
424         openClaiming 
425         userHasEnoughClaimableTokens(amount)
426         enoughContractAmount(amount)
427     {
428         require(msg.sender != address(0), "Sender is address zero");
429         allowanceAmounts[msg.sender] = allowanceAmounts[msg.sender].sub(amount);
430         token.approve(address(this), amount);
431         if (!token.transferFrom(address(this), msg.sender, amount)){
432             allowanceAmounts[msg.sender].add(amount);
433             emit UnsuccessfulTransfer(msg.sender);
434         }
435         else {
436             totalUnclaimed = totalUnclaimed.sub(amount);
437         }
438     }
439 
440     /** @dev Transfers the spacified number of tokens to the user requesting
441      *
442      * Makes the allowance equal to zero
443      * Transfers all allowed tokens from contract to the message sender
444      * In case of failure restores the previous allowance amount
445      *
446      * Requirements:
447      *
448      * - message sender cannot be address(0) and has to be in AllowanceList
449      */
450     function claimRemainingTokens()
451         public
452         openClaiming
453         userHasClaimableTokens   
454     {   
455         
456         require(msg.sender != address(0), "Sender is address zero");
457         uint256 amount = allowanceAmounts[msg.sender];
458         
459         require(token.balanceOf(address(this)) >= amount, "Insufficient amount of tokens in contract");
460         
461         allowanceAmounts[msg.sender] = 0;
462         token.approve(address(this), amount);
463         if (!token.transferFrom(address(this), msg.sender, amount)){
464             allowanceAmounts[msg.sender] = amount;
465             emit UnsuccessfulTransfer(msg.sender);
466         }
467         else{
468             totalUnclaimed = totalUnclaimed.sub(amount);
469         }
470     }
471 
472     /** @dev Adds the provided address to Allowance list with allowed provided amount of tokens
473      * Available only for the owner of contract
474      */
475     function addToAllowanceListSingle(address addAddress, uint256 amount) 
476         public 
477         onlyOwner 
478     {
479         allowanceAmounts[addAddress] = allowanceAmounts[addAddress].add(amount);
480         totalUnclaimed = totalUnclaimed.add(amount);
481     }
482     
483     /** @dev Adds the provided address to Allowance list with allowed provided amount of tokens
484      * Available only for the owner
485      */
486     function substractFromAllowanceListSingle(address subAddress, uint256 amount) 
487         public 
488         onlyOwner 
489     {
490         require(allowanceAmounts[subAddress] != 0, "The address does not have allowance to substract from.");
491         allowanceAmounts[subAddress] = allowanceAmounts[subAddress].sub(amount);
492         totalUnclaimed = totalUnclaimed.sub(amount);
493     }
494 
495 
496     /** @dev Adds the provided address list to Allowance list with allowed provided amounts of tokens
497      * Available only for the owner
498      */
499     function addToAllowanceListMultiple(allowedUser[] memory addAddresses)
500         public
501         onlyOwner
502     {
503         for (uint256 i = 0; i < addAddresses.length; i++) {
504             allowanceAmounts[addAddresses[i].wallet] = allowanceAmounts[addAddresses[i].wallet].add(addAddresses[i].amount);
505             totalUnclaimed = totalUnclaimed.add(addAddresses[i].amount);
506         }
507     }
508     
509     /** @dev Removes the provided address from Allowance list by setting his allowed sum to zero
510      * Available only for the owner of contract
511      */
512     function removeFromAllowanceList(address remAddress) 
513         public 
514         onlyOwner 
515     {
516         totalUnclaimed = totalUnclaimed.sub(allowanceAmounts[remAddress]);
517         delete allowanceAmounts[remAddress];
518     }
519 
520     /** @dev Allows the owner to turn the claiming on.
521      */
522     function turnClaimingOn() 
523         public 
524         onlyOwner
525     {
526         isClaimOpen = true;
527     }
528 
529     /** @dev Allows the owner to turn the claiming off.
530      */
531     function turnClaimingOff() 
532         public 
533         onlyOwner
534     {
535         isClaimOpen = false;
536     }
537 
538     /** @dev Allows the owner to withdraw all the remaining tokens from the contract
539      */
540     function withdrawAllTokensOwner() 
541         public 
542         onlyOwner
543     {
544         token.approve(address(this), token.balanceOf(address(this)));
545         if (!token.transferFrom(address(this), msg.sender, token.balanceOf(address(this)))){
546             emit UnsuccessfulTransfer(msg.sender);
547         }
548     }
549     
550     /** @dev Allows the owner to withdraw the specified amount of tokens from the contract
551      */
552      function withdrawCustomTokensOwner(uint256 amount) 
553         public 
554         onlyOwner 
555         enoughContractAmount(amount)
556     {
557         token.approve(address(this), amount);
558         if (!token.transferFrom(address(this), msg.sender, amount)){
559             emit UnsuccessfulTransfer(msg.sender);
560         }
561     }
562     
563     /** @dev Allows the owner to withdraw the residual tokens from the contract
564      */
565      function withdrawResidualTokensOwner() 
566         public 
567         onlyOwner 
568     {
569         uint256 amount = token.balanceOf(address(this)).sub(totalUnclaimed);
570         require(token.balanceOf(address(this)) >= amount, "Insufficient amount of tokens in contract");
571         token.approve(address(this), amount);
572         if (!token.transferFrom(address(this), msg.sender, amount)){
573             emit UnsuccessfulTransfer(msg.sender);
574         }
575     }
576     
577     /** @dev Allows the owner to withdraw the specified amount of any IERC20 tokens from the contract
578      */
579     function withdrawAnyContractTokens(IERC20 tokenAddress, address recipient) 
580         public 
581         onlyOwner 
582     {
583         require(msg.sender != address(0), "Sender is address zero");
584         require(recipient != address(0), "Receiver is address zero");
585         tokenAddress.approve(address(this), tokenAddress.balanceOf(address(this)));
586         if(!tokenAddress.transferFrom(address(this), recipient, tokenAddress.balanceOf(address(this)))){
587             emit UnsuccessfulTransfer(msg.sender);
588         }
589     } 
590     
591     /** @dev Shows the amount of total unclaimed tokens in the contract
592      */
593     function totalUnclaimedTokens() 
594         public 
595         view 
596         onlyOwner
597         returns (uint256)
598     {
599         return totalUnclaimed;
600     }
601     
602     /** @dev Shows the residual tokens of the user sending request
603      */
604     function myResidualTokens() 
605         public
606         view
607         returns (uint256)
608     {
609         return allowanceAmounts[msg.sender];
610     } 
611     
612     /** @dev Shows the owner residual tokens of any address (owner only function)
613      */
614     function residualTokensOf(address user) 
615         public  
616         view
617         onlyOwner 
618         returns (uint256)
619     {
620         return allowanceAmounts[user];
621     }
622 
623     /** @dev Shows the amount of total tokens in the contract
624      */
625     function tokenBalance() 
626         public 
627         view 
628         returns (uint256)
629     {
630         return token.balanceOf(address(this));
631     }
632 
633     /** @dev Shows whether claiming is allowed right now.
634      */
635     function isClaimingOn() 
636         public
637         view 
638         returns (bool)
639     {
640         return isClaimOpen;
641     }
642     
643 }