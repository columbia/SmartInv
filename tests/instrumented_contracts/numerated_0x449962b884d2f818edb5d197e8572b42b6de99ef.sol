1 /*
2 ███████╗██╗░░░██╗███╗░░░██╗░██████╗░░░░██████╗░░██████╗░██╗░░░░██╗███████╗██████╗░███████╗██████╗░
3 ██╔════╝╚██╗░██╔╝████╗░░██║██╔════╝░░░░██╔══██╗██╔═══██╗██║░░░░██║██╔════╝██╔══██╗██╔════╝██╔══██╗
4 ███████╗░╚████╔╝░██╔██╗░██║██║░░░░░░░░░██████╔╝██║░░░██║██║░█╗░██║█████╗░░██████╔╝█████╗░░██║░░██║
5 ╚════██║░░╚██╔╝░░██║╚██╗██║██║░░░░░░░░░██╔═══╝░██║░░░██║██║███╗██║██╔══╝░░██╔══██╗██╔══╝░░██║░░██║
6 ███████║░░░██║░░░██║░╚████║╚██████╗░░░░██║░░░░░╚██████╔╝╚███╔███╔╝███████╗██║░░██║███████╗██████╔╝
7 ╚══════╝░░░╚═╝░░░╚═╝░░╚═══╝░╚═════╝░░░░╚═╝░░░░░░╚═════╝░░╚══╝╚══╝░╚══════╝╚═╝░░╚═╝╚══════╝╚═════╝░
8 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
9 ░██████╗██████╗░██╗░░░██╗██████╗░████████╗░██████╗░██████╗░░██████╗░███╗░░░██╗██████╗░███████╗░░░░
10 ██╔════╝██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗██╔═══██╗████╗░░██║██╔══██╗██╔════╝░░░░
11 ██║░░░░░██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░░██║██████╔╝██║░░░██║██╔██╗░██║██║░░██║███████╗░░░░
12 ██║░░░░░██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░░██║██╔══██╗██║░░░██║██║╚██╗██║██║░░██║╚════██║░░░░
13 ╚██████╗██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚██████╔╝██████╔╝╚██████╔╝██║░╚████║██████╔╝███████║░░░░
14 ░╚═════╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚═════╝░╚═════╝░░╚═════╝░╚═╝░░╚═══╝╚═════╝░╚══════╝░░░░
15 */
16 
17 pragma solidity ^0.6.0;
18 
19 
20 interface ApproveAndCallFallBack {
21     function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
22 }
23 
24 
25 
26 
27 
28 
29 
30 
31 /*
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with GSN meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address payable) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes memory) {
47         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
48         return msg.data;
49     }
50 }
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * By default, the owner account will be the one that deploys the contract. This
58  * can later be changed with {transferOwnership}.
59  *
60  * This module is used through inheritance. It will make available the modifier
61  * `onlyOwner`, which can be applied to your functions to restrict their use to
62  * the owner.
63  */
64 contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor () internal {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     /**
79      * @dev Returns the address of the current owner.
80      */
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     /**
86      * @dev Throws if called by any account other than the owner.
87      */
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     /**
94      * @dev Leaves the contract without owner. It will not be possible to call
95      * `onlyOwner` functions anymore. Can only be called by the current owner.
96      *
97      * NOTE: Renouncing ownership will leave the contract without an owner,
98      * thereby removing any functionality that is only available to the owner.
99      */
100     function renounceOwnership() public virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Can only be called by the current owner.
108      */
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         emit OwnershipTransferred(_owner, newOwner);
112         _owner = newOwner;
113     }
114 }
115 
116 
117 
118 
119 /**
120  * @dev Wrappers over Solidity's arithmetic operations with added overflow
121  * checks.
122  *
123  * Arithmetic operations in Solidity wrap on overflow. This can easily result
124  * in bugs, because programmers usually assume that an overflow raises an
125  * error, which is the standard behavior in high level programming languages.
126  * `SafeMath` restores this intuition by reverting the transaction when an
127  * operation overflows.
128  *
129  * Using this library instead of the unchecked operations eliminates an entire
130  * class of bugs, so it's recommended to use it always.
131  */
132 library SafeMath {
133     /**
134      * @dev Returns the addition of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `+` operator.
138      *
139      * Requirements:
140      *
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         return sub(a, b, "SafeMath: subtraction overflow");
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      *
189      * - Multiplication cannot overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193         // benefit is lost if 'b' is also tested.
194         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195         if (a == 0) {
196             return 0;
197         }
198 
199         uint256 c = a * b;
200         require(c / a == b, "SafeMath: multiplication overflow");
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         return div(a, b, "SafeMath: division by zero");
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b > 0, errorMessage);
235         uint256 c = a / b;
236         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         return mod(a, b, "SafeMath: modulo by zero");
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts with custom message when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b != 0, errorMessage);
271         return a % b;
272     }
273 }
274 
275 
276 
277 
278 /**
279  * @dev Interface of the ERC20 standard as defined in the EIP.
280  */
281 interface IERC20 {
282     /**
283      * @dev Returns the amount of tokens in existence.
284      */
285     function totalSupply() external view returns (uint256);
286 
287     /**
288      * @dev Returns the amount of tokens owned by `account`.
289      */
290     function balanceOf(address account) external view returns (uint256);
291 
292     /**
293      * @dev Moves `amount` tokens from the caller's account to `recipient`.
294      *
295      * Returns a boolean value indicating whether the operation succeeded.
296      *
297      * Emits a {Transfer} event.
298      */
299     function transfer(address recipient, uint256 amount) external returns (bool);
300 
301     /**
302      * @dev Returns the remaining number of tokens that `spender` will be
303      * allowed to spend on behalf of `owner` through {transferFrom}. This is
304      * zero by default.
305      *
306      * This value changes when {approve} or {transferFrom} are called.
307      */
308     function allowance(address owner, address spender) external view returns (uint256);
309 
310     /**
311      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
312      *
313      * Returns a boolean value indicating whether the operation succeeded.
314      *
315      * IMPORTANT: Beware that changing an allowance with this method brings the risk
316      * that someone may use both the old and the new allowance by unfortunate
317      * transaction ordering. One possible solution to mitigate this race
318      * condition is to first reduce the spender's allowance to 0 and set the
319      * desired value afterwards:
320      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
321      *
322      * Emits an {Approval} event.
323      */
324     function approve(address spender, uint256 amount) external returns (bool);
325 
326     /**
327      * @dev Moves `amount` tokens from `sender` to `recipient` using the
328      * allowance mechanism. `amount` is then deducted from the caller's
329      * allowance.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Emitted when `value` tokens are moved from one account (`from`) to
339      * another (`to`).
340      *
341      * Note that `value` may be zero.
342      */
343     event Transfer(address indexed from, address indexed to, uint256 value);
344 
345     /**
346      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
347      * a call to {approve}. `value` is the new allowance.
348      */
349     event Approval(address indexed owner, address indexed spender, uint256 value);
350 }
351 
352 
353 
354 
355 
356 
357 
358 
359 
360 
361 
362 
363 
364 contract Sync is IERC20, Ownable {
365   using SafeMath for uint256;
366 
367   mapping (address => uint256) private balances;
368   mapping (address => mapping (address => uint256)) private allowed;
369   string public constant name  = "SYNC";
370   string public constant symbol = "SYNC";
371   uint8 public constant decimals = 18;
372   uint256 _totalSupply = 16000000 * (10 ** 18); // 16 million supply
373 
374   mapping (address => bool) public mintContracts;
375 
376   modifier isMintContract() {
377     require(mintContracts[msg.sender],"calling address is not allowed to mint");
378     _;
379   }
380 
381   constructor() public Ownable(){
382     balances[msg.sender] = _totalSupply;
383     emit Transfer(address(0), msg.sender, _totalSupply);
384   }
385 
386   function setMintAccess(address account, bool canMint) public onlyOwner {
387     mintContracts[account]=canMint;
388   }
389 
390   function _mint(address account, uint256 amount) public isMintContract {
391     require(account != address(0), "ERC20: mint to the zero address");
392     _totalSupply = _totalSupply.add(amount);
393     balances[account] = balances[account].add(amount);
394     emit Transfer(address(0), account, amount);
395   }
396 
397   function totalSupply() public view override returns (uint256) {
398     return _totalSupply;
399   }
400 
401   function balanceOf(address user) public view override returns (uint256) {
402     return balances[user];
403   }
404 
405   function allowance(address user, address spender) public view override returns (uint256) {
406     return allowed[user][spender];
407   }
408 
409   function transfer(address to, uint256 value) public override returns (bool) {
410     require(value <= balances[msg.sender],"insufficient balance");
411     require(to != address(0),"cannot send to zero address");
412 
413     balances[msg.sender] = balances[msg.sender].sub(value);
414     balances[to] = balances[to].add(value);
415 
416     emit Transfer(msg.sender, to, value);
417     return true;
418   }
419 
420   function approve(address spender, uint256 value) public override returns (bool) {
421     require(spender != address(0),"cannot approve the zero address");
422     allowed[msg.sender][spender] = value;
423     emit Approval(msg.sender, spender, value);
424     return true;
425   }
426 
427   function approveAndCall(address spender, uint256 tokens, bytes calldata data) external returns (bool) {
428         allowed[msg.sender][spender] = tokens;
429         emit Approval(msg.sender, spender, tokens);
430         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
431         return true;
432     }
433 
434   function transferFrom(address from, address to, uint256 value) public override returns (bool) {
435     require(value <= balances[from],"insufficient balance");
436     require(value <= allowed[from][msg.sender],"insufficient allowance");
437     require(to != address(0),"cannot send to the zero address");
438 
439     balances[from] = balances[from].sub(value);
440     balances[to] = balances[to].add(value);
441 
442     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
443 
444     emit Transfer(from, to, value);
445     return true;
446   }
447 
448   function burn(uint256 amount) external {
449     require(amount != 0,"must burn more than zero");
450     require(amount <= balances[msg.sender],"insufficient balance");
451     _totalSupply = _totalSupply.sub(amount);
452     balances[msg.sender] = balances[msg.sender].sub(amount);
453     emit Transfer(msg.sender, address(0), amount);
454   }
455 
456 }
457 
458 
459 
460 contract FRS is Ownable {
461   using SafeMath for uint256;
462 
463   //Constant and pseudo constant values
464   uint256 constant public INITIAL_DAILY_REWARD = 5000000 * (10**18); //Base daily reward amount. A reduction is applied to this which increases over time to compute the actual daily reward.
465   uint256 constant public TIME_INCREMENT=1 days;//Amount of time between each Sync release.
466 
467   //Variables related to the day index
468   mapping(uint256 => mapping(address => uint256)) public amountEntered; //Amount of Eth entered by day index, by user.
469   mapping(uint256 => uint256) public totalDailyContribution; //Total amount of Eth entered for the given day index.
470   mapping(uint256 => uint256) public totalDailyRewards; //Total amount of tokens to be distributed for the given day index.
471   mapping(uint256 => mapping(address => uint256)) public totalDailyPayouts; //Amount paid out to given user address for each given day index.
472   uint256 public currentDayIndex=0;//Current day index. Represents the number of Sync releases which have occurred. Will also represent the number of days which have passed since the contract started, minus the number of days which have been skipped due to inactivity.
473 
474   //Other mappings
475   mapping(uint256 => address payable) public maintainers;//A list of maintainer addresses, which are given a portion of Sync rewards.
476 
477   //Timing variables
478   uint256 public nextDayAt=0;//The timestamp at which the current release is finalized and the next one begins.
479   uint256 public firstEntryTime=0;//The time of the very first interaction with the contract, is the starting point for the first day.
480 
481   //External contracts
482   Sync public syncToken;//The Sync token contract. The FRS contract mints these tokens to reward to users daily.
483 
484   constructor(address token) public Ownable(){//(address tokenAddr,address fundAddr) public{
485     syncToken=Sync(token);
486     totalDailyRewards[currentDayIndex]=INITIAL_DAILY_REWARD;
487     maintainers[0]=0x464376466Ea0494Ff0bC90260c46f98c56c8c746;
488     maintainers[1]=0x2fFD215E32bF25366172a5470FCEA3182C6c718F;
489     maintainers[2]=0xaF35f3685C92b83E8e64880441FA39FE2B6Fcf48;
490     maintainers[3]=0x5ed7D8e2089B2B0e15439735B937CeC5F0ae811B;
491     maintainers[4]=0x73b8c96A1131C19B6A0Dc972099eE5E2B328f66B;
492     maintainers[5]=0x8AB0b38B5331ADAe0EDfB713c714521964C5bCCC;
493   }
494 
495   /*
496     Transfers the appropriate amount of Eth and Sync to the maintainers; to be called at the conclusion of each release.
497   */
498   function distributeToMaintainers(uint256 syncAmount) private{
499     if(syncAmount>0){
500       uint256 syncAmt1=syncAmount.mul(5).div(100);
501       uint256 syncAmt2=syncAmount.mul(283).div(1000);//28.3%, half of the remainder after 5*3%
502       syncToken._mint(maintainers[0],syncAmt1);
503       syncToken._mint(maintainers[1],syncAmt1);
504       syncToken._mint(maintainers[2],syncAmt1);
505 
506       syncToken._mint(maintainers[3],syncAmt2);
507       syncToken._mint(maintainers[4],syncAmt2);
508       syncToken._mint(maintainers[5],syncAmt2);
509     }
510     uint256 ethAmount=address(this).balance;
511     if(ethAmount>0){
512       uint256 ethAmt1=ethAmount.mul(5).div(100);//5%
513       uint256 ethAmt2=ethAmount.mul(283).div(1000);//28.3%
514 
515       //send used rather than transfer to remove possibility of denial of service by refusing transfer
516       maintainers[0].send(ethAmt1);
517       maintainers[1].send(ethAmt1);
518       maintainers[2].send(ethAmt1);
519 
520       maintainers[3].send(ethAmt2);
521       maintainers[4].send(ethAmt2);
522       maintainers[5].send(ethAmt2);
523     }
524   }
525 
526   /*
527     Function for entering Eth into the release for the current day.
528   */
529   function enter() external payable{
530     require(msg.value>0,"payment required");
531     //Concludes the previous contest if needed
532     updateDay();
533     //Record user contribution
534     amountEntered[currentDayIndex][msg.sender]+=msg.value;
535     totalDailyContribution[currentDayIndex]+=msg.value;
536   }
537 
538   /*
539     If the current release has concluded, perform all operations necessary to progress to the next release.
540   */
541   function updateDay() private{
542     //starts timer if first transaction
543     if(nextDayAt==0){
544       //The first transaction to this contract determines which time each day the release will conclude.
545       nextDayAt=block.timestamp.add(TIME_INCREMENT);
546       firstEntryTime=block.timestamp;
547     }
548     if(block.timestamp>=nextDayAt){
549       distributeToMaintainers(totalDailyRewards[currentDayIndex]);
550       //Determine the minimum number of days to add so that the next release ends at a future date. This is done so that every release will end at the same time of day.
551       uint256 daysToAdd=1+(block.timestamp-nextDayAt)/TIME_INCREMENT;
552       nextDayAt+=TIME_INCREMENT*daysToAdd;
553       currentDayIndex+=1;
554       //for every month until the 13th, rewards are cut in half.
555       uint256 numMonths=block.timestamp.sub(firstEntryTime).div(30 days);
556       if(numMonths>12){
557         totalDailyRewards[currentDayIndex]=0;
558       }
559       else{
560         totalDailyRewards[currentDayIndex]=INITIAL_DAILY_REWARD.div(2**numMonths);
561       }
562     }
563   }
564 
565   /*
566     Function for users to withdraw rewards for multiple days.
567   */
568   function withdrawForMultipleDays(uint256[] calldata dayList) external{
569     //Concludes the previous contest if needed
570     updateDay();
571     uint256 cumulativeAmountWon=0;
572     uint256 amountWon=0;
573     for(uint256 i=0;i<dayList.length;i++){
574       amountWon=_withdrawForDay(dayList[i],currentDayIndex,msg.sender);
575       cumulativeAmountWon+=amountWon;
576       totalDailyPayouts[dayList[i]][msg.sender]+=amountWon;//record how much was paid
577     }
578     syncToken._mint(msg.sender,cumulativeAmountWon);
579   }
580 
581   /*
582     Function for users to withdraw rewards for a single day.
583   */
584   function withdrawForDay(uint256 day) external{
585     //Concludes the previous contest if needed
586     updateDay();
587     uint256 amountWon=_withdrawForDay(day,currentDayIndex,msg.sender);
588     totalDailyPayouts[day][msg.sender]+=amountWon;//record how much was paid
589     syncToken._mint(msg.sender,amountWon);
590   }
591 
592   /*
593     Returns amount that should be withdrawn for the given day.
594   */
595   function _withdrawForDay(uint256 day,uint256 dayCursor,address user) public view returns(uint256){
596     if(day>=dayCursor){//you can only withdraw funds for previous days
597       return 0;
598     }
599     //Amount owed is proportional to the amount entered by the user vs the total amount of Eth entered.
600     uint256 amountWon=totalDailyRewards[day].mul(amountEntered[day][user]).div(totalDailyContribution[day]);
601     uint256 amountPaid=totalDailyPayouts[day][user];
602     return amountWon.sub(amountPaid);
603   }
604 
605   /*
606     The following functions are only used externally, intended to assist with frontend calculations, not meant to be called onchain.
607   */
608 
609   /*
610     Returns the current day index as it will be after updateDay is called.
611   */
612   function currentDayIndexActual() external view returns(uint256){
613     if(block.timestamp>=nextDayAt){
614       return currentDayIndex+1;
615     }
616     else{
617       return currentDayIndex;
618     }
619   }
620 
621   /*
622     Returns the amount of Sync the user will get if withdrawing for the provided day indices.
623   */
624   function getPayoutForMultipleDays(uint256[] calldata dayList,uint256 dayCursor,address addr) external view returns(uint256){
625     uint256 cumulativeAmountWon=0;
626     for(uint256 i=0;i<dayList.length;i++){
627       cumulativeAmountWon+=_withdrawForDay(dayList[i],dayCursor,addr);
628     }
629     return cumulativeAmountWon;
630   }
631 
632   /*
633     Returns a list of day indexes for which the given user has available rewards.
634   */
635   function getDaysWithFunds(uint256 start,uint256 end,address user) external view returns(uint256[] memory){
636     uint256 numDays=0;
637     for(uint256 i=start;i<min(currentDayIndex+1,end);i++){
638       if(amountEntered[i][user]>0){
639         numDays+=1;
640       }
641     }
642     uint256[] memory dwf=new uint256[](numDays);
643     uint256 cursor=0;
644     for(uint256 i=start;i<min(currentDayIndex+1,end);i++){
645       if(amountEntered[i][user]>0){
646         dwf[cursor]=i;
647         cursor+=1;
648       }
649     }
650     return dwf;
651   }
652 
653   /*
654     Utility function, returns the smaller number.
655   */
656   function min(uint256 n1,uint256 n2) internal pure returns(uint256){
657     if(n1<n2){
658       return n1;
659     }
660     else{
661       return n2;
662     }
663   }
664 }