1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 /**
70  * @title Math
71  * @dev Assorted math operations
72  */
73 library Math {
74     /**
75     * @dev Returns the largest of two numbers.
76     */
77     function max(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a >= b ? a : b;
79     }
80 
81     /**
82     * @dev Returns the smallest of two numbers.
83     */
84     function min(uint256 a, uint256 b) internal pure returns (uint256) {
85         return a < b ? a : b;
86     }
87 
88     /**
89     * @dev Calculates the average of two numbers. Since these are integers,
90     * averages of an even and odd number cannot be represented, and will be
91     * rounded down.
92     */
93     function average(uint256 a, uint256 b) internal pure returns (uint256) {
94         // (a + b) / 2 can overflow, so we distribute
95         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
96     }
97 }
98 
99 
100 /**
101  * @title Roles
102  * @dev Library for managing addresses assigned to a Role.
103  */
104 library Roles {
105   struct Role {
106     mapping (address => bool) bearer;
107   }
108 
109   /**
110    * @dev give an account access to this role
111    */
112   function add(Role storage role, address account) internal {
113     require(account != address(0));
114     require(!has(role, account));
115 
116     role.bearer[account] = true;
117   }
118 
119   /**
120    * @dev remove an account's access to this role
121    */
122   function remove(Role storage role, address account) internal {
123     require(account != address(0));
124     require(has(role, account));
125 
126     role.bearer[account] = false;
127   }
128 
129   /**
130    * @dev check if an account has this role
131    * @return bool
132    */
133   function has(Role storage role, address account)
134     internal
135     view
136     returns (bool)
137   {
138     require(account != address(0));
139     return role.bearer[account];
140   }
141 }
142 
143 
144 contract DepositorRole {
145   using Roles for Roles.Role;
146 
147   event DepositorAdded(address indexed account);
148   event DepositorRemoved(address indexed account);
149 
150   Roles.Role private depositors;
151 
152   constructor() internal {
153     _addDepositor(msg.sender);
154   }
155 
156   modifier onlyDepositor() {
157     require(isDepositor(msg.sender));
158     _;
159   }
160 
161   function isDepositor(address account) public view returns (bool) {
162     return depositors.has(account);
163   }
164 
165   function addDepositor(address account) public onlyDepositor {
166     _addDepositor(account);
167   }
168 
169   function renounceDepositor() public {
170     _removeDepositor(msg.sender);
171   }
172 
173   function _addDepositor(address account) internal {
174     depositors.add(account);
175     emit DepositorAdded(account);
176   }
177 
178   function _removeDepositor(address account) internal {
179     depositors.remove(account);
180     emit DepositorRemoved(account);
181   }
182 }
183 
184 
185 contract TraderRole {
186   using Roles for Roles.Role;
187 
188   event TraderAdded(address indexed account);
189   event TraderRemoved(address indexed account);
190 
191   Roles.Role private traders;
192 
193   constructor() internal {
194     _addTrader(msg.sender);
195   }
196 
197   modifier onlyTrader() {
198     require(isTrader(msg.sender));
199     _;
200   }
201 
202   function isTrader(address account) public view returns (bool) {
203     return traders.has(account);
204   }
205 
206   function addTrader(address account) public onlyTrader {
207     _addTrader(account);
208   }
209 
210   function renounceTrader() public {
211     _removeTrader(msg.sender);
212   }
213 
214   function _addTrader(address account) internal {
215     traders.add(account);
216     emit TraderAdded(account);
217   }
218 
219   function _removeTrader(address account) internal {
220     traders.remove(account);
221     emit TraderRemoved(account);
222   }
223 }
224 
225 
226 /**
227  * @title Ownable
228  * @dev The Ownable contract has an owner address, and provides basic authorization control
229  * functions, this simplifies the implementation of "user permissions".
230  */
231 contract Ownable {
232     address private _owner;
233 
234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235 
236     /**
237      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
238      * account.
239      */
240     constructor () internal {
241         _owner = msg.sender;
242         emit OwnershipTransferred(address(0), _owner);
243     }
244 
245     /**
246      * @return the address of the owner.
247      */
248     function owner() public view returns (address) {
249         return _owner;
250     }
251 
252     /**
253      * @dev Throws if called by any account other than the owner.
254      */
255     modifier onlyOwner() {
256         require(isOwner());
257         _;
258     }
259 
260     /**
261      * @return true if `msg.sender` is the owner of the contract.
262      */
263     function isOwner() public view returns (bool) {
264         return msg.sender == _owner;
265     }
266 
267     /**
268      * @dev Allows the current owner to relinquish control of the contract.
269      * @notice Renouncing to ownership will leave the contract without an owner.
270      * It will not be possible to call the functions with the `onlyOwner`
271      * modifier anymore.
272      */
273     function renounceOwnership() public onlyOwner {
274         emit OwnershipTransferred(_owner, address(0));
275         _owner = address(0);
276     }
277 
278     /**
279      * @dev Allows the current owner to transfer control of the contract to a newOwner.
280      * @param newOwner The address to transfer ownership to.
281      */
282     function transferOwnership(address newOwner) public onlyOwner {
283         _transferOwnership(newOwner);
284     }
285 
286     /**
287      * @dev Transfers control of the contract to a newOwner.
288      * @param newOwner The address to transfer ownership to.
289      */
290     function _transferOwnership(address newOwner) internal {
291         require(newOwner != address(0));
292         emit OwnershipTransferred(_owner, newOwner);
293         _owner = newOwner;
294     }
295 }
296 
297 
298 /**
299  * @title ERC20 interface
300  * @dev see https://github.com/ethereum/EIPs/issues/20
301  */
302 interface IERC20 {
303   function totalSupply() external view returns (uint256);
304 
305   function balanceOf(address who) external view returns (uint256);
306 
307   function allowance(address owner, address spender)
308     external view returns (uint256);
309 
310   function transfer(address to, uint256 value) external returns (bool);
311 
312   function approve(address spender, uint256 value)
313     external returns (bool);
314 
315   function transferFrom(address from, address to, uint256 value)
316     external returns (bool);
317 
318   event Transfer(
319     address indexed from,
320     address indexed to,
321     uint256 value
322   );
323 
324   event Approval(
325     address indexed owner,
326     address indexed spender,
327     uint256 value
328   );
329 }
330 
331 
332 /**
333  * @title SafeERC20
334  * @dev Wrappers around ERC20 operations that throw on failure.
335  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
336  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
337  */
338 library SafeERC20 {
339     using SafeMath for uint256;
340 
341     function safeTransfer(IERC20 token, address to, uint256 value) internal {
342         require(token.transfer(to, value));
343     }
344 
345     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
346         require(token.transferFrom(from, to, value));
347     }
348 
349     function safeApprove(IERC20 token, address spender, uint256 value) internal {
350         // safeApprove should only be called when setting an initial allowance,
351         // or when resetting it to zero. To increase and decrease it, use
352         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
353         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
354         require(token.approve(spender, value));
355     }
356 
357     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
358         uint256 newAllowance = token.allowance(address(this), spender).add(value);
359         require(token.approve(spender, newAllowance));
360     }
361 
362     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
363         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
364         require(token.approve(spender, newAllowance));
365     }
366 }
367 
368 
369 /**
370  * @notice Token bank contract
371  * @dev To use Token Bank, mint ERC20 tokens for this contract
372  */
373 contract TokenBank is Ownable, DepositorRole, TraderRole {
374     using Math for uint256;
375     using SafeMath for uint256;
376     using SafeERC20 for IERC20;
377 
378     // this token bank contract will use this binded ERC20 token
379     IERC20 public bindedToken;
380 
381     // use deposited[user] to get the deposited ERC20 tokens
382     mapping(address => uint256) public deposited;
383 
384     // address of fee collector
385     address public feeCollector;
386    
387     event TokenBinded(
388         address indexed binder,
389         address indexed previousToken,
390         address indexed newToken
391     );
392 
393     event FeeCollectorSet(
394         address indexed setter,
395         address indexed previousFeeCollector,
396         address indexed newFeeCollector
397     );
398 
399     event FeeCollected(
400         address indexed collector,
401         address indexed collectTo,
402         uint256 amount
403     );
404 
405     event Deposited(
406         address indexed depositor,
407         address indexed receiver,
408         uint256 amount,
409         uint256 balance
410     );
411 
412     event BulkDeposited(
413         address indexed trader,
414         uint256 totalAmount,
415         uint256 requestNum
416     );
417 
418     event Withdrawn(
419         address indexed from,
420         address indexed to,
421         uint256 amount,
422         uint256 fee,
423         uint256 balance
424     );
425 
426     event BulkWithdrawn(
427         address indexed trader,
428         uint256 requestNum
429     );
430 
431     event Transferred(
432         address indexed from,
433         address indexed to,
434         uint256 amount,
435         uint256 fee,
436         uint256 balance
437     );
438 
439     event BulkTransferred(
440         address indexed trader,
441         uint256 requestNum
442     );
443 
444     /**
445      * @param addrs addrs[0]: ERC20; addrs[1]: fee collector
446      */
447     constructor(
448         address[] memory addrs
449     )
450         public
451     {
452         bindedToken = IERC20(addrs[0]);
453         feeCollector = addrs[1];
454     }
455 
456     /**
457      * @param token Address of ERC20 token to bind for bank
458      */
459     function bindToken(address token) external onlyOwner {
460         emit TokenBinded(msg.sender, address(bindedToken), token);
461         bindedToken = IERC20(token);
462     }
463 
464     /**
465      * @param collector New fee collector
466      */
467     function setFeeCollector(address collector) external onlyOwner {
468         emit FeeCollectorSet(msg.sender, feeCollector, collector);
469         feeCollector = collector;
470     }
471 
472     /**
473      * @dev Collect fee from Token Bank to ERC20 token
474      */
475     function collectFee() external onlyOwner {
476         uint256 amount = deposited[feeCollector];
477         deposited[feeCollector] = 0;
478         emit FeeCollected(msg.sender, feeCollector, amount);
479         bindedToken.safeTransfer(feeCollector, amount);
480     }
481 
482     /**
483      * @notice Deposit ERC20 token to receiver address
484      * @param receiver Address of who will receive the deposited tokens
485      * @param amount Amount of ERC20 token to deposit
486      */
487     function depositTo(address receiver, uint256 amount) external onlyDepositor {
488         deposited[receiver] = deposited[receiver].add(amount);
489         emit Deposited(msg.sender, receiver, amount, deposited[receiver]);
490         bindedToken.safeTransferFrom(msg.sender, address(this), amount);
491     }
492 
493     /**
494      * @notice Bulk deposit tokens to multiple receivers
495      * @param receivers Addresses of receivers
496      * @param amounts Individual amounts to deposit for receivers
497      */
498     function bulkDeposit(
499         address[] calldata receivers,
500         uint256[] calldata amounts
501     )
502         external
503         onlyDepositor
504     {
505         require(
506             receivers.length == amounts.length,
507             "Failed to bulk deposit due to illegal arguments."
508         );
509 
510         uint256 totalAmount = 0;
511         for (uint256 i = 0; i < amounts.length; i = i.add(1)) {
512             // accumulate total amount of tokens to transfer in token bank
513             totalAmount = totalAmount.add(amounts[i]);
514             // deposit tokens to token bank accounts
515             deposited[receivers[i]] = deposited[receivers[i]].add(amounts[i]);
516             emit Deposited(
517                 msg.sender, 
518                 receivers[i], 
519                 amounts[i],
520                 deposited[receivers[i]]
521             );
522         }
523         emit BulkDeposited(msg.sender, totalAmount, receivers.length);
524 
525         // if transfer fails, deposits will revert accordingly 
526         bindedToken.safeTransferFrom(msg.sender, address(this), totalAmount);  
527     }
528 
529     /**
530      * @notice withdraw tokens from token bank to specific receiver
531      * @param from Token will withdraw from this address
532      * @param to Withdrawn token transfer to this address
533      * @param amount Amount of ERC20 token to withdraw
534      * @param fee Withdraw fee
535      */
536     function _withdraw(address from, address to, uint256 amount, uint256 fee) private {
537         deposited[feeCollector] = deposited[feeCollector].add(fee);
538         uint256 total = amount.add(fee);
539         deposited[from] = deposited[from].sub(total);
540         emit Withdrawn(from, to, amount, fee, deposited[from]);
541         bindedToken.safeTransfer(to, amount);
542     }
543 
544     /**
545      * @notice Bulk withdraw tokens from token bank
546      * @dev Withdraw request will handle by off-chain API
547      * @dev Arguments must merge into arrays due to "Stack too deep" error
548      * @param nums See ./docs/nums.bulkWithdraw.param
549      * @param addrs See ./docs/addrs.bulkWithdraw.param
550      * @param rsSigParams See ./docs/rsSigParams.bulkWithdraw.param
551      */
552     function bulkWithdraw(
553         uint256[] calldata nums,
554         address[] calldata addrs,
555         bytes32[] calldata rsSigParams
556     )
557         external
558         onlyTrader
559     {
560         // length of nums = 4 * withdraw requests
561         uint256 total = nums.length.div(4);
562         require(
563             (total > 0) 
564             && (total.mul(4) == nums.length)
565             && (total.mul(2) == addrs.length)
566             && (total.mul(2) == rsSigParams.length),
567             "Failed to bulk withdraw due to illegal arguments."
568         );
569 
570         // handle withdraw requests one after another
571         for (uint256 i = 0; i < total; i = i.add(1)) {
572             _verifyWithdrawSigner(
573                 addrs[i.mul(2)],               // withdraw from (also signder)
574                 addrs[(i.mul(2)).add(1)],      // withdraw to
575                 nums[i.mul(4)],                // withdraw amount
576                 nums[(i.mul(4)).add(1)],       // withdraw fee
577                 nums[(i.mul(4)).add(2)],       // withdraw timestamp
578                 nums[(i.mul(4)).add(3)],       // signature param: v
579                 rsSigParams[i.mul(2)],         // signature param: r
580                 rsSigParams[(i.mul(2)).add(1)] // signature param: s
581             );
582 
583             _withdraw(
584                 addrs[i.mul(2)],          // withdraw from
585                 addrs[(i.mul(2)).add(1)], // withdraw to
586                 nums[i.mul(4)],           // withdraw amount
587                 nums[(i.mul(4)).add(1)]   // withdraw fee
588             );
589         }
590         emit BulkWithdrawn(msg.sender, total);
591     }
592 
593     /**
594      * @notice Verify withdraw request signer
595      * @dev Request signer must be owner of deposit account
596      * @param from Token will withdraw from this address
597      * @param to Token will withdraw into this address
598      * @param amount Amount of token to withdraw
599      * @param fee Withdraw fee
600      * @param timestamp Withdraw request timestamp
601      * @param v Signature parameter: v
602      * @param r Signature parameter: r
603      * @param s Signature parameter: s
604      */
605     function _verifyWithdrawSigner(
606         address from,
607         address to,
608         uint256 amount,
609         uint256 fee,
610         uint256 timestamp,
611         uint256 v,
612         bytes32 r,
613         bytes32 s
614     )
615         private
616         view
617     {
618         bytes32 hashed = keccak256(
619             abi.encodePacked(
620                 "\x19Ethereum Signed Message:\n32", 
621                 keccak256(
622                     abi.encodePacked(
623                         address(this), 
624                         from, 
625                         to, 
626                         amount,
627                         fee,
628                         timestamp
629                     )
630                 )
631             )
632         );
633 
634         require(
635             ecrecover(hashed, uint8(v), r, s) == from,
636             "Failed to withdraw due to request was not signed by singer."
637         );
638     }
639 
640     /**
641      * @notice Bulk transfer tokens in token bank
642      * @dev Transfer request will handle by off-chain API
643      * @dev Arguments must merge into arrays due to "Stack too deep" error
644      * @param nums See ./docs/nums.bulkTransfer.param
645      * @param addrs See ./docs/addrs.bulkTransfer.param
646      * @param rsSigParams See ./docs/rsSigParams.bulkTransfer.param
647      */
648     function bulkTransfer(
649         uint256[] calldata nums,
650         address[] calldata addrs,
651         bytes32[] calldata rsSigParams
652     )
653         external
654         onlyTrader
655     {
656         // length of nums = 4 * transfer requests
657         uint256 total = nums.length.div(4);
658         require(
659             (total > 0) 
660             && (total.mul(4) == nums.length)
661             && (total.mul(2) == addrs.length)
662             && (total.mul(2) == rsSigParams.length),
663             "Failed to bulk transfer due to illegal arguments."
664         );
665 
666         // handle transfer requests one after another
667         for (uint256 i = 0; i < total; i = i.add(1)) {
668             _verifyTransferSigner(
669                 addrs[i.mul(2)],               // transfer from (also signder)
670                 addrs[(i.mul(2)).add(1)],      // transfer to
671                 nums[i.mul(4)],                // transfer amount
672                 nums[(i.mul(4)).add(1)],       // transfer fee
673                 nums[(i.mul(4)).add(2)],       // transfer timestamp
674                 nums[(i.mul(4)).add(3)],       // signature param: v
675                 rsSigParams[i.mul(2)],         // signature param: r
676                 rsSigParams[(i.mul(2)).add(1)] // signature param: s
677             );
678 
679             _transfer(
680                 addrs[i.mul(2)],          // transfer from
681                 addrs[(i.mul(2)).add(1)], // transfer to
682                 nums[i.mul(4)],           // transfer amount
683                 nums[(i.mul(4)).add(1)]   // transfer fee
684             );
685         }
686         emit BulkTransferred(msg.sender, total);
687     }
688 
689     /**
690      * @dev Admin function: Transfer token in token bank
691      * @param from Token transfer from this address
692      * @param to Token transfer to this address
693      * @param amount Amount of token to transfer
694      * @param fee Transfer fee
695      */
696     function transfer(
697         address from,
698         address to,
699         uint256 amount,
700         uint256 fee
701     )
702         external
703         onlyOwner
704     {
705         _transfer(from, to, amount, fee);
706     }
707 
708     /**
709      * @dev Transfer token in token bank
710      * @param from Token transfer from this address
711      * @param to Token transfer to this address
712      * @param amount Amount of token to transfer
713      * @param fee Transfer fee
714      */
715     function _transfer(
716         address from,
717         address to,
718         uint256 amount,
719         uint256 fee
720     )
721         private
722     {
723         require(to != address(0));
724         uint256 total = amount.add(fee);
725         require(total <= deposited[from]);
726         deposited[from] = deposited[from].sub(total);
727         deposited[feeCollector] = deposited[feeCollector].add(fee);
728         deposited[to] = deposited[to].add(amount);
729         emit Transferred(from, to, amount, fee, deposited[from]);
730     }
731 
732     /**
733      * @notice Verify transfer request signer
734      * @dev Request signer must be owner of deposit account
735      * @param from Token will transfer from this address
736      * @param to Token will transfer into this address
737      * @param amount Amount of token to transfer
738      * @param fee Transfer fee
739      * @param timestamp Transfer request timestamp
740      * @param v Signature parameter: v
741      * @param r Signature parameter: r
742      * @param s Signature parameter: s
743      */
744     function _verifyTransferSigner(
745         address from,
746         address to,
747         uint256 amount,
748         uint256 fee,
749         uint256 timestamp,
750         uint256 v,
751         bytes32 r,
752         bytes32 s
753     )
754         private
755         view
756     {
757         bytes32 hashed = keccak256(
758             abi.encodePacked(
759                 "\x19Ethereum Signed Message:\n32", 
760                 keccak256(
761                     abi.encodePacked(
762                         address(this), 
763                         from, 
764                         to, 
765                         amount,
766                         fee,
767                         timestamp
768                     )
769                 )
770             )
771         );
772 
773         require(
774             ecrecover(hashed, uint8(v), r, s) == from,
775             "Failed to transfer due to request was not signed by singer."
776         );
777     }
778 }