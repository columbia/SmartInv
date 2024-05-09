1 // File: @openzeppelin/contracts/GSN/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.7.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 
92 /**
93  * @dev Interface of the ERC20 standard as defined in the EIP.
94  */
95 interface IERC20 {
96     /**
97      * @dev Returns the amount of tokens in existence.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     /**
102      * @dev Returns the amount of tokens owned by `account`.
103      */
104     function balanceOf(address account) external view returns (uint256);
105 
106     /**
107      * @dev Moves `amount` tokens from the caller's account to `recipient`.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transfer(address recipient, uint256 amount) external returns (bool);
114 
115     /**
116      * @dev Returns the remaining number of tokens that `spender` will be
117      * allowed to spend on behalf of `owner` through {transferFrom}. This is
118      * zero by default.
119      *
120      * This value changes when {approve} or {transferFrom} are called.
121      */
122     function allowance(address owner, address spender) external view returns (uint256);
123 
124     /**
125      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * IMPORTANT: Beware that changing an allowance with this method brings the risk
130      * that someone may use both the old and the new allowance by unfortunate
131      * transaction ordering. One possible solution to mitigate this race
132      * condition is to first reduce the spender's allowance to 0 and set the
133      * desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address spender, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Moves `amount` tokens from `sender` to `recipient` using the
142      * allowance mechanism. `amount` is then deducted from the caller's
143      * allowance.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Emitted when `value` tokens are moved from one account (`from`) to
153      * another (`to`).
154      *
155      * Note that `value` may be zero.
156      */
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     /**
160      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
161      * a call to {approve}. `value` is the new allowance.
162      */
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 /**
167  * @dev Wrappers over Solidity's arithmetic operations with added overflow
168  * checks.
169  *
170  * Arithmetic operations in Solidity wrap on overflow. This can easily result
171  * in bugs, because programmers usually assume that an overflow raises an
172  * error, which is the standard behavior in high level programming languages.
173  * `SafeMath` restores this intuition by reverting the transaction when an
174  * operation overflows.
175  *
176  * Using this library instead of the unchecked operations eliminates an entire
177  * class of bugs, so it's recommended to use it always.
178  */
179 library SafeMath {
180     /**
181      * @dev Returns the addition of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `+` operator.
185      *
186      * Requirements:
187      *
188      * - Addition cannot overflow.
189      */
190     function add(uint256 a, uint256 b) internal pure returns (uint256) {
191         uint256 c = a + b;
192         require(c >= a, "SafeMath: addition overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the subtraction of two unsigned integers, reverting on
199      * overflow (when the result is negative).
200      *
201      * Counterpart to Solidity's `-` operator.
202      *
203      * Requirements:
204      *
205      * - Subtraction cannot overflow.
206      */
207     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
208         return sub(a, b, "SafeMath: subtraction overflow");
209     }
210 
211     /**
212      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
213      * overflow (when the result is negative).
214      *
215      * Counterpart to Solidity's `-` operator.
216      *
217      * Requirements:
218      *
219      * - Subtraction cannot overflow.
220      */
221     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b <= a, errorMessage);
223         uint256 c = a - b;
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the multiplication of two unsigned integers, reverting on
230      * overflow.
231      *
232      * Counterpart to Solidity's `*` operator.
233      *
234      * Requirements:
235      *
236      * - Multiplication cannot overflow.
237      */
238     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
239         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
240         // benefit is lost if 'b' is also tested.
241         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
242         if (a == 0) {
243             return 0;
244         }
245 
246         uint256 c = a * b;
247         require(c / a == b, "SafeMath: multiplication overflow");
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the integer division of two unsigned integers. Reverts on
254      * division by zero. The result is rounded towards zero.
255      *
256      * Counterpart to Solidity's `/` operator. Note: this function uses a
257      * `revert` opcode (which leaves remaining gas untouched) while Solidity
258      * uses an invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function div(uint256 a, uint256 b) internal pure returns (uint256) {
265         return div(a, b, "SafeMath: division by zero");
266     }
267 
268     /**
269      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
270      * division by zero. The result is rounded towards zero.
271      *
272      * Counterpart to Solidity's `/` operator. Note: this function uses a
273      * `revert` opcode (which leaves remaining gas untouched) while Solidity
274      * uses an invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b > 0, errorMessage);
282         uint256 c = a / b;
283         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284 
285         return c;
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290      * Reverts when dividing by zero.
291      *
292      * Counterpart to Solidity's `%` operator. This function uses a `revert`
293      * opcode (which leaves remaining gas untouched) while Solidity uses an
294      * invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
301         return mod(a, b, "SafeMath: modulo by zero");
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * Reverts with custom message when dividing by zero.
307      *
308      * Counterpart to Solidity's `%` operator. This function uses a `revert`
309      * opcode (which leaves remaining gas untouched) while Solidity uses an
310      * invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
317         require(b != 0, errorMessage);
318         return a % b;
319     }
320 }
321 
322 pragma experimental ABIEncoderV2;
323 
324 contract KeyfiToken is IERC20, Ownable {
325     using SafeMath for uint256;
326 
327     string public constant name = "KeyFi Token";
328     string public constant symbol = "KEYFI";
329     uint8 public constant decimals = 18;
330     uint256 public override totalSupply = 10000000e18;
331 
332     mapping (address => mapping (address => uint256)) internal allowances;
333     mapping (address => uint256) internal balances;
334     mapping (address => address) public delegates;
335 
336 
337     address public minter;
338     uint256 public mintingAllowedAfter;
339     uint32 public minimumMintGap = 1 days * 365;
340     uint8 public mintCap = 2;
341 
342     struct Checkpoint {
343         uint256 fromBlock;
344         uint256 votes;
345     }
346 
347     mapping (address => mapping (uint256 => Checkpoint)) public checkpoints;    
348     mapping (address => uint256) public numCheckpoints;
349     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
350     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
351 
352     mapping (address => uint) public nonces;
353 
354     event MinterChanged(address minter, address newMinter);
355     event MinimumMintGapChanged(uint32 previousMinimumGap, uint32 newMinimumGap);
356     event MintCapChanged(uint8 previousCap, uint8 newCap);
357     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);    
358     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
359 
360     constructor(address account, address _minter, uint256 _mintingAllowedAfter) {
361         balances[account] = totalSupply;
362         minter = _minter;
363         mintingAllowedAfter = _mintingAllowedAfter;
364         
365         emit Transfer(address(0), account, totalSupply);
366         emit MinterChanged(address(0), minter);
367     }
368 
369     /**
370      * @dev Change the minter address
371      * @param _minter The address of the new minter
372      */
373     function setMinter(address _minter) 
374         external 
375         onlyOwner
376     {
377         emit MinterChanged(minter, _minter);
378         minter = _minter;
379     }
380 
381     function setMintCap(uint8 _cap) 
382         external 
383         onlyOwner 
384     {
385         emit MintCapChanged(mintCap, _cap);
386         mintCap = _cap;
387     }
388 
389     function setMinimumMintGap(uint32 _gap) 
390         external
391         onlyOwner
392     {
393         emit MinimumMintGapChanged(minimumMintGap, _gap);
394         minimumMintGap = _gap;
395     }
396 
397     function mint(address _to, uint256 _amount) 
398         external 
399     {
400         require(msg.sender == minter, "KeyfiToken::mint: only the minter can mint");
401         require(block.timestamp >= mintingAllowedAfter, "KeyfiToken::mint: minting not allowed yet");
402         require(_to != address(0), "KeyfiToken::mint: cannot transfer to the zero address");
403         require(_amount <= (totalSupply.mul(mintCap)).div(100), "KeyfiToken::mint: exceeded mint cap");
404 
405         mintingAllowedAfter = (block.timestamp).add(minimumMintGap);
406         totalSupply = totalSupply.add(_amount);
407         balances[_to] = balances[_to].add(_amount);
408 
409         _moveDelegates(address(0), delegates[_to], _amount);
410         emit Transfer(address(0), _to, _amount);
411     }
412 
413     /**
414      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
415      * @param account The address of the account holding the funds
416      * @param spender The address of the account spending the funds
417      * @return The number of tokens approved
418      */
419     function allowance(address account, address spender) 
420         public
421         view 
422         override 
423         returns (uint256) 
424     {
425         return allowances[account][spender];
426     }
427 
428     /**
429      * @notice Approve `spender` to transfer up to `amount` from `src`
430      * @dev This will overwrite the approval amount for `spender`
431      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
432      * @param spender The address of the account which may transfer tokens
433      * @param amount The number of tokens that are approved (2^256-1 means infinite)
434      * @return Whether or not the approval succeeded
435      */
436     function approve(address spender, uint256 amount) 
437         public 
438         override
439         returns (bool) 
440     {
441         require(spender != address(0), "KeyfiToken: cannot approve zero address");
442 
443         allowances[msg.sender][spender] = amount;
444         emit Approval(msg.sender, spender, amount);
445         return true;
446     }
447 
448     /**
449      * @notice Get the number of tokens held by the `account`
450      * @param account The address of the account to get the balance of
451      * @return The number of tokens held
452      */
453     function balanceOf(address account) 
454         external 
455         view 
456         override 
457         returns (uint256) 
458     {
459         return balances[account];
460     }
461 
462     /**
463      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
464      * @param dst The address of the destination account
465      * @param amount The number of tokens to transfer
466      * @return Whether or not the transfer succeeded
467      */
468     function transfer(address dst, uint256 amount) 
469         external 
470         override
471         returns (bool) 
472     {
473         _transferTokens(msg.sender, dst, amount);
474         return true;
475     }
476 
477     /**
478      * @notice Transfer `amount` tokens from `src` to `dst`
479      * @param src The address of the source account
480      * @param dst The address of the destination account
481      * @param amount The number of tokens to transfer
482      * @return Whether or not the transfer succeeded
483      */
484     function transferFrom(address src, address dst, uint256 amount) 
485         external 
486         override
487         returns (bool) 
488     {
489         address spender = msg.sender;
490         uint256 spenderAllowance = allowances[src][spender];
491 
492         if (spender != src && spenderAllowance != uint256(-1)) {
493             uint256 newAllowance = sub256(spenderAllowance, amount, "KeyfiToken::transferFrom: transfer amount exceeds spender allowance");
494             allowances[src][spender] = newAllowance;
495 
496             emit Approval(src, spender, newAllowance);
497         }
498 
499         _transferTokens(src, dst, amount);
500         return true;
501     }
502 
503     /**
504      * @notice Delegate votes from `msg.sender` to `delegatee`
505      * @param delegatee The address to delegate votes to
506      */
507     function delegate(address delegatee) 
508         external 
509     {
510         return _delegate(msg.sender, delegatee);
511     }
512 
513     /**
514      * @notice Delegates votes from signatory to `delegatee`
515      * @param delegatee The address to delegate votes to
516      * @param nonce The contract state required to match the signature
517      * @param expiry The time at which to expire the signature
518      * @param v The recovery byte of the signature
519      * @param r Half of the ECDSA signature pair
520      * @param s Half of the ECDSA signature pair
521      */
522     function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) 
523         external 
524     {
525         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
526         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
527         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
528         address signatory = ecrecover(digest, v, r, s);
529         require(signatory != address(0), "KeyfiToken::delegateBySig: invalid signature");
530         require(nonce == nonces[signatory]++, "KeyfiToken::delegateBySig: invalid nonce");
531         require(block.timestamp <= expiry, "KeyfiToken::delegateBySig: signature expired");
532         return _delegate(signatory, delegatee);
533     }
534 
535     /**
536      * @notice Gets the current votes balance for `account`
537      * @param account The address to get votes balance
538      * @return The number of current votes for `account`
539      */
540     function getCurrentVotes(address account) 
541         external 
542         view 
543         returns (uint256) 
544     {
545         uint256 nCheckpoints = numCheckpoints[account];
546         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
547     }
548 
549     /**
550      * @notice Determine the prior number of votes for an account as of a block number
551      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
552      * @param account The address of the account to check
553      * @param blockNumber The block number to get the vote balance at
554      * @return The number of votes the account had as of the given block
555      */
556     function getPriorVotes(address account, uint256 blockNumber) 
557         external 
558         view 
559         returns (uint256) 
560     {
561         require(blockNumber < block.number, "KeyfiToken::getPriorVotes: not yet determined");
562 
563         uint256 nCheckpoints = numCheckpoints[account];
564         if (nCheckpoints == 0) {
565             return 0;
566         }
567 
568         // First check most recent balance
569         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
570             return checkpoints[account][nCheckpoints - 1].votes;
571         }
572 
573         // Next check implicit zero balance
574         if (checkpoints[account][0].fromBlock > blockNumber) {
575             return 0;
576         }
577 
578         uint256 lower = 0;
579         uint256 upper = nCheckpoints - 1;
580         while (upper > lower) {
581             uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
582             Checkpoint memory cp = checkpoints[account][center];
583             if (cp.fromBlock == blockNumber) {
584                 return cp.votes;
585             } else if (cp.fromBlock < blockNumber) {
586                 lower = center;
587             } else {
588                 upper = center - 1;
589             }
590         }
591         return checkpoints[account][lower].votes;
592     }
593 
594     function _delegate(address delegator, address delegatee) 
595         internal 
596     {
597         address currentDelegate = delegates[delegator];
598         uint256 delegatorBalance = balances[delegator];
599         delegates[delegator] = delegatee;
600 
601         emit DelegateChanged(delegator, currentDelegate, delegatee);
602 
603         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
604     }
605 
606     function _transferTokens(address src, address dst, uint256 amount) 
607         internal 
608     {
609         require(src != address(0), "KeyfiToken::_transferTokens: cannot transfer from the zero address");
610         require(dst != address(0), "KeyfiToken::_transferTokens: cannot transfer to the zero address");
611 
612         balances[src] = sub256(balances[src], amount, "KeyfiToken::_transferTokens: transfer amount exceeds balance");
613         balances[dst] = add256(balances[dst], amount, "KeyfiToken::_transferTokens: transfer amount overflows");
614         emit Transfer(src, dst, amount);
615 
616         _moveDelegates(delegates[src], delegates[dst], amount);
617     }
618 
619     function _moveDelegates(address srcRep, address dstRep, uint256 amount) 
620         internal 
621     {
622         if (srcRep != dstRep && amount > 0) {
623             if (srcRep != address(0)) {
624                 uint256 srcRepNum = numCheckpoints[srcRep];
625                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
626                 uint256 srcRepNew = sub256(srcRepOld, amount, "KeyfiToken::_moveVotes: vote amount underflows");
627                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
628             }
629 
630             if (dstRep != address(0)) {
631                 uint256 dstRepNum = numCheckpoints[dstRep];
632                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
633                 uint256 dstRepNew = add256(dstRepOld, amount, "KeyfiToken::_moveVotes: vote amount overflows");
634                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
635             }
636         }
637     }
638 
639     function _writeCheckpoint(address delegatee, uint256 nCheckpoints, uint256 oldVotes, uint256 newVotes) 
640         internal 
641     {
642         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == block.number) {
643             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
644         } else {
645             checkpoints[delegatee][nCheckpoints] = Checkpoint(block.number, newVotes);
646             numCheckpoints[delegatee] = nCheckpoints + 1;
647         }
648 
649         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
650     }
651 
652     function add256(uint256 a, uint256 b, string memory errorMessage) 
653         internal 
654         pure 
655         returns (uint256) 
656     {
657         uint256 c = a + b;
658         require(c >= a, errorMessage);
659         return c;  
660     }
661 
662     function sub256(uint256 a, uint256 b, string memory errorMessage) 
663         internal 
664         pure 
665         returns (uint256) 
666     {
667         require(b <= a, errorMessage);
668         return a - b;
669     }
670 
671     function getChainId() 
672         internal 
673         pure 
674         returns (uint256) 
675     {
676         uint256 chainId;
677         assembly { chainId := chainid() }
678         return chainId;
679     }
680 
681     /**
682      * @dev Destroys `amount` tokens from `account`, reducing the
683      * total supply.
684      *
685      * Emits a {Transfer} event with `to` set to the zero address.
686      *
687      * Requirements
688      *
689      * - `account` cannot be the zero address.
690      * - `account` must have at least `amount` tokens.
691      */
692     function _burn(address account, uint256 amount)
693         internal 
694     {
695         require(account != address(0), "ERC20: burn from the zero address");
696 
697         balances[account] = balances[account].sub(amount, "ERC20: burn amount exceeds balance");
698         totalSupply = totalSupply.sub(amount);
699         emit Transfer(account, address(0), amount);
700         
701         _moveDelegates(delegates[account], address(0), amount);
702     }
703 
704     /**
705      * @dev Destroys `amount` tokens from the caller.
706      */
707     function burn(uint256 amount) 
708         external 
709         returns (bool)
710     {
711         _burn(msg.sender, amount);
712         return true;
713     }
714 
715     /**
716      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
717      * allowance.
718      *
719      * Requirements:
720      *
721      * - the caller must have allowance for ``accounts``'s tokens of at least
722      * `amount`.
723      */
724     function burnFrom(address account, uint256 amount) 
725         external
726         returns (bool)
727     {
728         address spender = msg.sender;
729         uint256 spenderAllowance = allowances[account][spender];
730 
731         if (spender != account && spenderAllowance != uint256(-1)) {
732             uint256 newAllowance = sub256(spenderAllowance, amount, "KeyfiToken::burnFrom: burn amount exceeds spender allowance");
733             allowances[account][spender] = newAllowance;
734 
735             emit Approval(account, spender, newAllowance);
736         }
737 
738         _burn(account, amount);
739         return true;
740     }
741 }