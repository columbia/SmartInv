1 pragma solidity >=0.6.0;
2 interface IERC20 {
3    
4     function totalSupply() external view returns (uint256);
5 
6   
7     function balanceOf(address account) external view returns (uint256);
8 
9     
10     function transfer(address recipient, uint256 amount) external returns (bool);
11     function transferWithoutDeflationary(address recipient, uint256 amount) external returns (bool) ;
12    
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     
16     function approve(address spender, uint256 amount) external returns (bool);
17 
18     
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20 
21     
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 library SafeMath {
28    
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36    
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49    
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52         // benefit is lost if 'b' is also tested.
53         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54         if (a == 0) {
55             return 0;
56         }
57 
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60 
61         return c;
62     }
63 
64     
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         // Solidity only automatically asserts when dividing by 0
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         return mod(a, b, "SafeMath: modulo by zero");
82     }
83 
84     
85     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b != 0, errorMessage);
87         return a % b;
88     }
89 }
90 library Address {
91     /**
92      * @dev Returns true if `account` is a contract.
93      *
94      * [IMPORTANT]
95      * ====
96      * It is unsafe to assume that an address for which this function returns
97      * false is an externally-owned account (EOA) and not a contract.
98      *
99      * Among others, `isContract` will return false for the following
100      * types of addresses:
101      *
102      *  - an externally-owned account
103      *  - a contract in construction
104      *  - an address where a contract will be created
105      *  - an address where a contract lived, but was destroyed
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
110         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
111         // for accounts without code, i.e. `keccak256('')`
112         bytes32 codehash;
113         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
114         // solhint-disable-next-line no-inline-assembly
115         assembly { codehash := extcodehash(account) }
116         return (codehash != accountHash && codehash != 0x0);
117     }
118 
119     /**
120      * @dev Converts an `address` into `address payable`. Note that this is
121      * simply a type cast: the actual underlying value is not changed.
122      *
123      * _Available since v2.4.0._
124      */
125     function toPayable(address account) internal pure returns (address payable) {
126         return address(uint160(account));
127     }
128 
129     /**
130      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
131      * `recipient`, forwarding all available gas and reverting on errors.
132      *
133      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
134      * of certain opcodes, possibly making contracts go over the 2300 gas limit
135      * imposed by `transfer`, making them unable to receive funds via
136      * `transfer`. {sendValue} removes this limitation.
137      *
138      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
139      *
140      * IMPORTANT: because control is transferred to `recipient`, care must be
141      * taken to not create reentrancy vulnerabilities. Consider using
142      * {ReentrancyGuard} or the
143      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
144      *
145      * _Available since v2.4.0._
146      */
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
151         (bool success, ) = recipient.call.value(amount)("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 }
155 library SafeERC20 {
156     using SafeMath for uint256;
157     using Address for address;
158 
159     function safeTransfer(IERC20 token, address to, uint256 value) internal {
160         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
161     }
162 
163     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
164         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
165     }
166 
167     function safeApprove(IERC20 token, address spender, uint256 value) internal {
168         // safeApprove should only be called when setting an initial allowance,
169         // or when resetting it to zero. To increase and decrease it, use
170         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
171         // solhint-disable-next-line max-line-length
172         require((value == 0) || (token.allowance(address(this), spender) == 0),
173             "SafeERC20: approve from non-zero to non-zero allowance"
174         );
175         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
176     }
177 
178     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
179         uint256 newAllowance = token.allowance(address(this), spender).add(value);
180         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
181     }
182 
183     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
184         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
185         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
186     }
187 
188     /**
189      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
190      * on the return value: the return value is optional (but if data is returned, it must not be false).
191      * @param token The token targeted by the call.
192      * @param data The call data (encoded using abi.encode or one of its variants).
193      */
194     function callOptionalReturn(IERC20 token, bytes memory data) private {
195         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
196         // we're implementing it ourselves.
197 
198         // A Solidity high level call has three parts:
199         //  1. The target address is checked to verify it contains contract code
200         //  2. The call itself is made, and success asserted
201         //  3. The return value is decoded, which in turn checks the size of the returned data.
202         // solhint-disable-next-line max-line-length
203         require(address(token).isContract(), "SafeERC20: call to non-contract");
204 
205         // solhint-disable-next-line avoid-low-level-calls
206         (bool success, bytes memory returndata) = address(token).call(data);
207         require(success, "SafeERC20: low-level call failed");
208 
209         if (returndata.length > 0) { // Return data is optional
210             // solhint-disable-next-line max-line-length
211             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
212         }
213     }
214 }
215 contract Context {
216     // Empty internal constructor, to prevent people from mistakenly deploying
217     // an instance of this contract, which should be used via inheritance.
218     constructor () internal { }
219 
220     function _msgSender() internal view virtual returns (address payable) {
221         return msg.sender;
222     }
223 
224     function _msgData() internal view virtual returns (bytes memory) {
225         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
226         return msg.data;
227     }
228 }
229 contract Ownable is Context {
230     address private _owner;
231 
232     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234     /**
235      * @dev Initializes the contract setting the deployer as the initial owner.
236      */
237     constructor () internal {
238         address msgSender = _msgSender();
239         _owner = msgSender;
240         emit OwnershipTransferred(address(0), msgSender);
241     }
242 
243     /**
244      * @dev Returns the address of the current owner.
245      */
246     function owner() public view returns (address) {
247         return _owner;
248     }
249 
250     /**
251      * @dev Throws if called by any account other than the owner.
252      */
253     modifier onlyOwner() {
254         require(isOwner(), "Ownable: caller is not the owner");
255         _;
256     }
257 
258     /**
259      * @dev Returns true if the caller is the current owner.
260      */
261     function isOwner() public view returns (bool) {
262         return _msgSender() == _owner;
263     }
264 
265     /**
266      * @dev Leaves the contract without owner. It will not be possible to call
267      * `onlyOwner` functions anymore. Can only be called by the current owner.
268      *
269      * NOTE: Renouncing ownership will leave the contract without an owner,
270      * thereby removing any functionality that is only available to the owner.
271      */
272     function renounceOwnership() public virtual onlyOwner {
273         emit OwnershipTransferred(_owner, address(0));
274         _owner = address(0);
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      * Can only be called by the current owner.
280      */
281     function transferOwnership(address newOwner) public virtual onlyOwner {
282         _transferOwnership(newOwner);
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      */
288     function _transferOwnership(address newOwner) internal virtual {
289         require(newOwner != address(0), "Ownable: new owner is the zero address");
290         emit OwnershipTransferred(_owner, newOwner);
291         _owner = newOwner;
292     }
293 }
294 abstract contract ReentrancyGuard {
295     uint256 private constant _NOT_ENTERED = 1;
296     uint256 private constant _ENTERED = 2;
297 
298     uint256 private _status;
299 
300     constructor() internal {
301         _status = _NOT_ENTERED;
302     }
303 
304     /**
305      * @dev Prevents a contract from calling itself, directly or indirectly.
306      * Calling a `nonReentrant` function from another `nonReentrant`
307      * function is not supported. It is possible to prevent this from happening
308      * by making the `nonReentrant` function external, and make it call a
309      * `private` function that does the actual work.
310      */
311     modifier nonReentrant() {
312         // On the first call to nonReentrant, _notEntered will be true
313         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
314 
315         // Any calls to nonReentrant after this point will fail
316         _status = _ENTERED;
317 
318         _;
319 
320         // By storing the original value once again, a refund is triggered (see
321         // https://eips.ethereum.org/EIPS/eip-2200)
322         _status = _NOT_ENTERED;
323     }
324 }
325 
326 
327 
328 library ECDSA {
329     /**
330      * @dev Recover signer address from a message by using their signature
331      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
332      * @param signature bytes signature, the signature is generated using web3.eth.sign()
333      */
334     function recover(bytes32 hash, bytes memory signature)
335         internal
336         pure
337         returns (address)
338     {
339         bytes32 r;
340         bytes32 s;
341         uint8 v;
342 
343         // Check the signature length
344         if (signature.length != 65) {
345             return (address(0));
346         }
347 
348         // Divide the signature in r, s and v variables with inline assembly.
349         assembly {
350             r := mload(add(signature, 0x20))
351             s := mload(add(signature, 0x40))
352             v := byte(0, mload(add(signature, 0x60)))
353         }
354 
355         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
356         if (v < 27) {
357             v += 27;
358         }
359 
360         // If the version is correct return the signer address
361         if (v != 27 && v != 28) {
362             return (address(0));
363         } else {
364             // solium-disable-next-line arg-overflow
365             return ecrecover(hash, v, r, s);
366         }
367     }
368 
369     /**
370      * toEthSignedMessageHash
371      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
372      * and hash the result
373      */
374     function toEthSignedMessageHash(bytes32 hash)
375         internal
376         pure
377         returns (bytes32)
378     {
379         return
380             keccak256(
381                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
382             );
383     }
384 }
385 
386 contract PolkabridgeLaunchPadV2 is Ownable, ReentrancyGuard {
387     string public name = "PolkaBridge: LaunchPad V2";
388     using SafeMath for uint256;
389     using SafeERC20 for IERC20;
390     using ECDSA for bytes32;
391 
392     address payable private ReceiveToken;
393     uint256 MinimumStakeAmount;
394     struct IDOPool {
395         uint256 Id;
396         uint256 Begin;
397         uint256 End;
398         uint256 Type; //1: comminity round, 2 stackers round, 3 whitelist, 4 guaranteed
399         IERC20 IDOToken;
400         uint256 MaxPurchaseTier1;
401         uint256 MaxPurchaseTier2; //==comminity tier
402         uint256 MaxPurchaseTier3;
403         uint256 MaxSpecialPurchase;
404         uint256 TotalCap;
405         uint256 MinimumTokenSoldout;
406         uint256 TotalToken; //total sale token for this pool
407         uint256 RatePerETH;
408         uint256 TotalSold; //total number of token sold
409         
410     }
411 
412     struct ClaimInfo {
413         uint256 ClaimTime1;
414         uint256 PercentClaim1;
415         uint256 ClaimTime2;
416         uint256 PercentClaim2;
417         uint256 ClaimTime3;
418         uint256 PercentClaim3;
419         uint256 ClaimTime4;
420         uint256 PercentClaim4;
421         uint256 ClaimTime5;
422         uint256 PercentClaim5;
423          uint256 ClaimTime6;
424         uint256 PercentClaim6;
425          uint256 ClaimTime7;
426         uint256 PercentClaim7;
427     }
428 
429     struct User {
430         uint256 Id;
431         
432         bool IsWhitelist;
433         uint256 TotalTokenPurchase;
434         uint256 TotalETHPurchase;
435         uint256 PurchaseTime;
436         uint256 LastClaimed;
437         uint256 TotalPercentClaimed;
438         uint256 NumberClaimed;
439         
440         uint256 PurchaseAllocation;
441     }
442 
443     mapping(uint256 => mapping(address => User)) public users; //poolid - listuser
444 
445     IDOPool[] pools;
446 
447     mapping(uint256 => ClaimInfo) public claimInfos; //pid
448 
449     constructor(address payable receiveTokenAdd) public {
450         ReceiveToken = receiveTokenAdd;
451         MinimumStakeAmount=10000*1e18;
452     }
453 
454     function addMulWhitelist(address[] memory user,uint256[] memory allocation, uint256 pid)///need pid in constantfile
455         public
456         onlyOwner
457     {
458         for (uint256 i = 0; i < user.length; i++) {
459             users[pid][user[i]].Id = pid;
460              users[pid][user[i]].PurchaseAllocation = allocation[i];
461             users[pid][user[i]].IsWhitelist = true;
462            
463         }
464     }
465 
466     function sign(address[] memory user, uint256 pid)///need pid in constantfile
467         public
468         onlyOwner
469     {
470         uint256 poolIndex = pid.sub(1);
471         uint256 maxSpeical= pools[poolIndex].MaxSpecialPurchase;
472         uint256 tokenAmount = maxSpeical.mul(pools[poolIndex].RatePerETH).div(1e18);
473 
474         for (uint256 i = 0; i < user.length; i++) {
475           
476             users[pid][user[i]].TotalTokenPurchase = tokenAmount;
477             
478         }
479     }
480 
481     function updateWhitelist(
482         address user,
483         uint256 pid,
484         bool isWhitelist
485     ) public onlyOwner {
486         users[pid][user].IsWhitelist = isWhitelist;
487        
488     }
489 
490     function updateMinimumStake(
491        uint256 _minimum
492     ) public onlyOwner {
493         MinimumStakeAmount=_minimum;
494        
495     }
496 
497     function IsWhitelist(
498         address user,
499         uint256 pid,
500         uint256 stackAmount
501     ) public view returns (bool) {
502         uint256 poolIndex = pid.sub(1);
503         if (pools[poolIndex].Type == 1) // community round
504         {
505             return true;
506         } else if (pools[poolIndex].Type == 2) // stakers round
507         {
508             if (stackAmount >= MinimumStakeAmount) return true;
509             return false;
510         } else if (pools[poolIndex].Type == 3 ) //special round  
511         {
512             if (users[pid][user].IsWhitelist) return true;
513             return false;
514         }
515         else if (pools[poolIndex].Type ==4) //guaranteed round  
516         {
517             if (users[pid][user].IsWhitelist && stackAmount >= MinimumStakeAmount) return true;
518             return false;
519         } else {
520             return false;
521         }
522     }
523 
524     function addPool(
525         uint256 begin,
526         uint256 end,
527         uint256 _type,
528         IERC20 idoToken,
529         uint256 maxPurchaseTier1,
530         uint256 maxPurchaseTier2,
531         uint256 maxPurchaseTier3,
532         uint256 maxSpecialPurchase,
533         uint256 totalCap,
534         uint256 totalToken,
535         uint256 ratePerETH,
536         uint256 minimumTokenSoldout
537        
538     ) public onlyOwner {
539         uint256 id = pools.length.add(1);
540         pools.push(
541             IDOPool({
542                 Id: id,
543                 Begin: begin,
544                 End: end,
545                 Type: _type,
546                 IDOToken: idoToken,
547                 MaxPurchaseTier1: maxPurchaseTier1,
548                 MaxPurchaseTier2: maxPurchaseTier2,
549                 MaxPurchaseTier3: maxPurchaseTier3,
550                 MaxSpecialPurchase:maxSpecialPurchase,
551                 TotalCap: totalCap,
552                 TotalToken: totalToken,
553                 RatePerETH: ratePerETH,
554                 TotalSold: 0,
555                 MinimumTokenSoldout: minimumTokenSoldout
556                
557             })
558         );
559     }
560 
561     function addClaimInfo(
562         uint256 percentClaim1,
563         uint256 claimTime1,
564         uint256 percentClaim2,
565         uint256 claimTime2,
566         uint256 percentClaim3,
567         uint256 claimTime3,
568          uint256 percentClaim4,
569         uint256 claimTime4,
570          uint256 percentClaim5,
571         uint256 claimTime5,
572          uint256 percentClaim6,
573         uint256 claimTime6,
574          uint256 percentClaim7,
575         uint256 claimTime7,
576         uint256 pid
577     ) public onlyOwner {
578         claimInfos[pid].ClaimTime1 = claimTime1;
579         claimInfos[pid].PercentClaim1 = percentClaim1;
580         claimInfos[pid].ClaimTime2 = claimTime2;
581         claimInfos[pid].PercentClaim2 = percentClaim2;
582         claimInfos[pid].ClaimTime3 = claimTime3;
583         claimInfos[pid].PercentClaim3 = percentClaim3;
584         claimInfos[pid].ClaimTime4 = claimTime4;
585         claimInfos[pid].PercentClaim4 = percentClaim4;
586         claimInfos[pid].ClaimTime5 = claimTime5;
587         claimInfos[pid].PercentClaim5 = percentClaim5;
588          claimInfos[pid].ClaimTime6 = claimTime6;
589         claimInfos[pid].PercentClaim6 = percentClaim6;
590          claimInfos[pid].ClaimTime7 = claimTime7;
591         claimInfos[pid].PercentClaim7 = percentClaim7;
592     }
593 
594     function updateClaimInfo(
595         uint256 percentClaim1,
596         uint256 claimTime1,
597         uint256 percentClaim2,
598         uint256 claimTime2,
599         uint256 percentClaim3,
600         uint256 claimTime3,
601           uint256 percentClaim4,
602         uint256 claimTime4,
603           uint256 percentClaim5,
604         uint256 claimTime5,
605          uint256 percentClaim6,
606         uint256 claimTime6,
607          uint256 percentClaim7,
608         uint256 claimTime7,
609         uint256 pid
610     ) public onlyOwner {
611         if (claimTime1 > 0) {
612             claimInfos[pid].ClaimTime1 = claimTime1;
613         }
614 
615         if (percentClaim1 > 0) {
616             claimInfos[pid].PercentClaim1 = percentClaim1;
617         }
618         if (claimTime2 > 0) {
619             claimInfos[pid].ClaimTime2 = claimTime2;
620         }
621 
622         if (percentClaim2 > 0) {
623             claimInfos[pid].PercentClaim2 = percentClaim2;
624         }
625 
626         if (claimTime3 > 0) {
627             claimInfos[pid].ClaimTime3 = claimTime3;
628         }
629 
630         if (percentClaim3 > 0) {
631             claimInfos[pid].PercentClaim3 = percentClaim3;
632         }
633 
634           if (claimTime4 > 0) {
635             claimInfos[pid].ClaimTime4 = claimTime4;
636         }
637 
638         if (percentClaim4 > 0) {
639             claimInfos[pid].PercentClaim4 = percentClaim4;
640         }
641 
642            if (claimTime5 > 0) {
643             claimInfos[pid].ClaimTime5 = claimTime5;
644         }
645 
646         if (percentClaim5 > 0) {
647             claimInfos[pid].PercentClaim5 = percentClaim5;
648         }
649 
650            if (claimTime6 > 0) {
651             claimInfos[pid].ClaimTime6 = claimTime6;
652         }
653 
654         if (percentClaim6 > 0) {
655             claimInfos[pid].PercentClaim6 = percentClaim6;
656         }
657 
658            if (claimTime7 > 0) {
659             claimInfos[pid].ClaimTime7 = claimTime7;
660         }
661 
662         if (percentClaim7 > 0) {
663             claimInfos[pid].PercentClaim7 = percentClaim7;
664         }
665     }
666 
667     function updatePool(
668         uint256 pid,
669         uint256 begin,
670         uint256 end,
671         uint256 maxPurchaseTier1,
672         uint256 maxPurchaseTier2,
673         uint256 maxPurchaseTier3,
674          uint256 maxSpecialPurchase,
675         uint256 totalCap,
676         uint256 totalToken,
677         uint256 ratePerETH,
678         IERC20 idoToken,
679        
680         uint256 pooltype
681       
682     ) public onlyOwner {
683         uint256 poolIndex = pid.sub(1);
684         if (begin > 0) {
685             pools[poolIndex].Begin = begin;
686         }
687         if (end > 0) {
688             pools[poolIndex].End = end;
689         }
690 
691         if (maxPurchaseTier1 > 0) {
692             pools[poolIndex].MaxPurchaseTier1 = maxPurchaseTier1;
693         }
694         if (maxPurchaseTier2 > 0) {
695             pools[poolIndex].MaxPurchaseTier2 = maxPurchaseTier2;
696         }
697         if (maxPurchaseTier3 > 0) {
698             pools[poolIndex].MaxPurchaseTier3 = maxPurchaseTier3;
699         }
700           if (maxSpecialPurchase > 0) {
701             pools[poolIndex].MaxSpecialPurchase = maxSpecialPurchase;
702         }
703         if (totalCap > 0) {
704             pools[poolIndex].TotalCap = totalCap;
705         }
706         if (totalToken > 0) {
707             pools[poolIndex].TotalToken = totalToken;
708         }
709         if (ratePerETH > 0) {
710             pools[poolIndex].RatePerETH = ratePerETH;
711         }
712 
713        
714       
715         if (pooltype > 0) {
716             pools[poolIndex].Type = pooltype;
717         }
718         pools[poolIndex].IDOToken = idoToken;
719     }
720 
721     function withdrawErc20(IERC20 token) public onlyOwner {
722         token.transfer(owner(), token.balanceOf(address(this)));
723     }
724 
725     //withdraw ETH after IDO
726     function withdrawPoolFund() public onlyOwner {
727         uint256 balance = address(this).balance;
728         require(balance > 0, "not enough fund");
729         ReceiveToken.transfer(balance);
730     }
731 
732     function purchaseIDO(
733         uint256 stakeAmount,
734         uint256 pid,
735         uint8 v,
736         bytes32 r,
737         bytes32 s
738     ) public payable nonReentrant {
739         uint256 poolIndex = pid.sub(1);
740 
741         if (pools[poolIndex].Type == 2 || pools[poolIndex].Type == 4) {
742             bytes32 _hash = keccak256(abi.encodePacked(msg.sender, stakeAmount));
743             bytes32 messageHash = _hash.toEthSignedMessageHash();
744 
745             require(
746                 owner() == ecrecover(messageHash, v, r, s),
747                 "owner should sign purchase info"
748             );
749         }
750 
751         require(
752             block.timestamp >= pools[poolIndex].Begin &&
753                 block.timestamp <= pools[poolIndex].End,
754             "invalid time"
755         );
756         //check user
757         require(IsWhitelist(msg.sender, pid, stakeAmount), "invalid user");
758 
759         //check amount
760         uint256 ethAmount = msg.value;
761         users[pid][msg.sender].TotalETHPurchase = users[pid][msg.sender]
762             .TotalETHPurchase
763             .add(ethAmount);
764 
765         if (pools[poolIndex].Type == 2) {
766             //stackers round
767             if (stakeAmount < 1500 * 1e18) {
768                 require(
769                     users[pid][msg.sender].TotalETHPurchase <=
770                         pools[poolIndex].MaxPurchaseTier1,
771                     "invalid maximum purchase for tier1"
772                 );
773             } else if (
774                 stakeAmount >= 1500 * 1e18 && stakeAmount < 3000 * 1e18
775             ) {
776                 require(
777                     users[pid][msg.sender].TotalETHPurchase <=
778                         pools[poolIndex].MaxPurchaseTier2,
779                     "invalid maximum purchase for tier2"
780                 );
781             } else {
782                 require(
783                     users[pid][msg.sender].TotalETHPurchase <=
784                         pools[poolIndex].MaxPurchaseTier3,
785                     "invalid maximum purchase for tier3"
786                 );
787             }
788         } else if (pools[poolIndex].Type == 1) {
789             //community round
790 
791             require(
792                 users[pid][msg.sender].TotalETHPurchase <=
793                     pools[poolIndex].MaxPurchaseTier2,
794                 "invalid maximum contribute"
795             );
796         } else  if (pools[poolIndex].Type == 3){//special
797             
798             require(
799                 users[pid][msg.sender].TotalETHPurchase <=
800                     pools[poolIndex].MaxSpecialPurchase,
801                 "invalid contribute"
802             );
803         }else{//4 guaranteed
804             
805             require(
806                 users[pid][msg.sender].TotalETHPurchase <=
807                      users[pid][msg.sender].PurchaseAllocation,
808                 "invalid contribute"
809             );
810         }
811 
812         uint256 tokenAmount = ethAmount.mul(pools[poolIndex].RatePerETH).div(
813             1e18
814         );
815 
816         uint256 remainToken = getRemainIDOToken(pid);
817         require(
818             remainToken > pools[poolIndex].MinimumTokenSoldout,
819             "IDO sold out"
820         );
821         require(remainToken >= tokenAmount, "IDO sold out");
822 
823         users[pid][msg.sender].TotalTokenPurchase = users[pid][msg.sender]
824             .TotalTokenPurchase
825             .add(tokenAmount);
826 
827         pools[poolIndex].TotalSold = pools[poolIndex].TotalSold.add(
828             tokenAmount
829         );
830     }
831 
832     function claimToken(uint256 pid) public nonReentrant {
833         require(
834             users[pid][msg.sender].TotalPercentClaimed < 100,
835             "you have claimed enough"
836         );
837         uint256 userBalance = getUserTotalPurchase(pid);
838         require(userBalance > 0, "invalid claim");
839 
840         uint256 poolIndex = pid.sub(1);
841         if (users[pid][msg.sender].NumberClaimed == 0) {
842             require(
843                 block.timestamp >= claimInfos[poolIndex].ClaimTime1,
844                 "invalid time"
845             );
846             pools[poolIndex].IDOToken.safeTransfer(
847                 msg.sender,
848                 userBalance.mul(claimInfos[poolIndex].PercentClaim1).div(100)
849             );
850           users[pid][msg.sender].TotalPercentClaimed=  users[pid][msg.sender].TotalPercentClaimed.add(
851                 claimInfos[poolIndex].PercentClaim1
852             );
853         } else if (users[pid][msg.sender].NumberClaimed == 1) {
854             require(
855                 block.timestamp >= claimInfos[poolIndex].ClaimTime2,
856                 "invalid time"
857             );
858             pools[poolIndex].IDOToken.safeTransfer(
859                 msg.sender,
860                 userBalance.mul(claimInfos[poolIndex].PercentClaim2).div(100)
861             );
862             users[pid][msg.sender].TotalPercentClaimed=users[pid][msg.sender].TotalPercentClaimed.add(
863                 claimInfos[poolIndex].PercentClaim2
864             );
865         } else if (users[pid][msg.sender].NumberClaimed == 2) {
866             require(
867                 block.timestamp >= claimInfos[poolIndex].ClaimTime3,
868                 "invalid time"
869             );
870             pools[poolIndex].IDOToken.safeTransfer(
871                 msg.sender,
872                 userBalance.mul(claimInfos[poolIndex].PercentClaim3).div(100)
873             );
874            users[pid][msg.sender].TotalPercentClaimed= users[pid][msg.sender].TotalPercentClaimed.add(
875                 claimInfos[poolIndex].PercentClaim3
876             );
877         }
878 
879          else if (users[pid][msg.sender].NumberClaimed == 3) {
880             require(
881                 block.timestamp >= claimInfos[poolIndex].ClaimTime4,
882                 "invalid time"
883             );
884             pools[poolIndex].IDOToken.safeTransfer(
885                 msg.sender,
886                 userBalance.mul(claimInfos[poolIndex].PercentClaim4).div(100)
887             );
888            users[pid][msg.sender].TotalPercentClaimed= users[pid][msg.sender].TotalPercentClaimed.add(
889                 claimInfos[poolIndex].PercentClaim4
890             );
891         }
892          else if (users[pid][msg.sender].NumberClaimed == 4) {
893             require(
894                 block.timestamp >= claimInfos[poolIndex].ClaimTime5,
895                 "invalid time"
896             );
897             pools[poolIndex].IDOToken.safeTransfer(
898                 msg.sender,
899                 userBalance.mul(claimInfos[poolIndex].PercentClaim5).div(100)
900             );
901            users[pid][msg.sender].TotalPercentClaimed= users[pid][msg.sender].TotalPercentClaimed.add(
902                 claimInfos[poolIndex].PercentClaim5
903             );
904         }
905         else if (users[pid][msg.sender].NumberClaimed == 5) {
906             require(
907                 block.timestamp >= claimInfos[poolIndex].ClaimTime6,
908                 "invalid time"
909             );
910             pools[poolIndex].IDOToken.safeTransfer(
911                 msg.sender,
912                 userBalance.mul(claimInfos[poolIndex].PercentClaim6).div(100)
913             );
914            users[pid][msg.sender].TotalPercentClaimed= users[pid][msg.sender].TotalPercentClaimed.add(
915                 claimInfos[poolIndex].PercentClaim6
916             );
917         }
918         else if (users[pid][msg.sender].NumberClaimed == 6) {
919             require(
920                 block.timestamp >= claimInfos[poolIndex].ClaimTime7,
921                 "invalid time"
922             );
923             pools[poolIndex].IDOToken.safeTransfer(
924                 msg.sender,
925                 userBalance.mul(claimInfos[poolIndex].PercentClaim7).div(100)
926             );
927            users[pid][msg.sender].TotalPercentClaimed= users[pid][msg.sender].TotalPercentClaimed.add(
928                 claimInfos[poolIndex].PercentClaim7
929             );
930         }
931 
932         users[pid][msg.sender].LastClaimed = block.timestamp;
933         users[pid][msg.sender].NumberClaimed=users[pid][msg.sender].NumberClaimed.add(1);
934     }
935 
936     function getUserTotalPurchase(uint256 pid) public view returns (uint256) {
937         return users[pid][msg.sender].TotalTokenPurchase;
938     }
939 
940     function getRemainIDOToken(uint256 pid) public view returns (uint256) {
941         uint256 poolIndex = pid.sub(1);
942         uint256 tokenBalance = getBalanceTokenByPoolId(pid);
943         if (pools[poolIndex].TotalSold > tokenBalance) {
944             return 0;
945         }
946 
947         return tokenBalance.sub(pools[poolIndex].TotalSold);
948     }
949 
950     function getBalanceTokenByPoolId(uint256 pid)
951         public
952         view
953         returns (uint256)
954     {
955         uint256 poolIndex = pid.sub(1);
956 
957         return pools[poolIndex].TotalToken;
958     }
959 
960     function getPoolInfo(uint256 pid)
961         public
962         view
963         returns (
964             uint256,
965             uint256,
966             uint256,
967             uint256,
968             uint256,
969             uint256,
970              uint256,
971             IERC20
972         )
973     {
974         uint256 poolIndex = pid.sub(1);
975         return (
976             pools[poolIndex].Begin,
977             pools[poolIndex].End,
978             pools[poolIndex].Type,
979             pools[poolIndex].RatePerETH,
980             pools[poolIndex].TotalSold,
981             pools[poolIndex].TotalToken,
982             pools[poolIndex].TotalCap,
983             pools[poolIndex].IDOToken
984         );
985     }
986 
987     function getClaimInfo(uint256 pid)
988         public
989         view
990         returns (
991             uint256,
992             uint256,
993             uint256,
994             uint256,
995             uint256,
996             uint256
997         )
998     {
999         uint256 poolIndex = pid.sub(1);
1000         return (
1001             claimInfos[poolIndex].ClaimTime1,
1002             claimInfos[poolIndex].PercentClaim1,
1003             claimInfos[poolIndex].ClaimTime2,
1004             claimInfos[poolIndex].PercentClaim2,
1005             claimInfos[poolIndex].ClaimTime3,
1006             claimInfos[poolIndex].PercentClaim3
1007         );
1008     }
1009 
1010     function getPoolSoldInfo(uint256 pid) public view returns (uint256) {
1011         uint256 poolIndex = pid.sub(1);
1012         return (pools[poolIndex].TotalSold);
1013     }
1014 
1015     function getWhitelistfo(uint256 pid)
1016         public
1017         view
1018         returns (
1019           
1020             bool,
1021             uint256,
1022             uint256
1023         )
1024     {
1025         return (
1026            
1027             users[pid][msg.sender].IsWhitelist,
1028             users[pid][msg.sender].TotalTokenPurchase,
1029             users[pid][msg.sender].TotalETHPurchase
1030         );
1031     }
1032 
1033     function getUserInfo(uint256 pid, address user)
1034         public
1035         view
1036         returns (
1037             bool,
1038             uint256,
1039             uint256,
1040             uint256
1041         )
1042     {
1043         return (
1044             users[pid][user].IsWhitelist,
1045             users[pid][user].TotalTokenPurchase,
1046             users[pid][user].TotalETHPurchase,
1047             users[pid][user].TotalPercentClaimed
1048         );
1049     }
1050 
1051     function getUserPurchaseAllocation(uint256 pid, address user)
1052         public
1053         view
1054         returns (
1055             uint256
1056         )
1057     {
1058         return (
1059             users[pid][user].PurchaseAllocation
1060         );
1061     }
1062 }