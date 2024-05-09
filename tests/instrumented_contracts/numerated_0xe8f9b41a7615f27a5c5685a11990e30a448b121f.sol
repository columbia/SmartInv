1 pragma solidity ^0.5.17;
2 // SPDX-License-Identifier: MIT OR GPL-3.0
3 
4 /**
5 * https://mau.money
6 * https://t.me/maumoneyeth
7 * https://x.com/maumoneyeth
8 **/
9 
10 contract Context {
11     function _msgSender() internal view returns (address payable) {
12         return msg.sender;
13 
14     }
15 
16     function _msgData() internal view returns (bytes memory) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that revert on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, reverts on overflow.
30   */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33     // benefit is lost if 'b' is also tested.
34     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35     if (a == 0) {
36       return 0;
37     }
38 
39     uint256 c = a * b;
40     require(c / a == b);
41 
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b > 0); // Solidity only automatically asserts when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53     return c;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     require(b <= a);
61     uint256 c = a - b;
62 
63     return c;
64   }
65 
66   /**
67   * @dev Adds two numbers, reverts on overflow.
68   */
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     require(c >= a);
72 
73     return c;
74   }
75 
76   /**
77   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
78   * reverts when dividing by zero.
79   */
80   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81     require(b != 0);
82     return a % b;
83   }
84 }
85 
86 interface ILP {
87     function sync() external;
88 }
89 
90 interface IERC20 {
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 
105     /**
106      * @dev Returns the value of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the value of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves a `value` amount of tokens from the caller's account to `to`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transfer(address to, uint256 value) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through {transferFrom}. This is
127      * zero by default.
128      *
129      * This value changes when {approve} or {transferFrom} are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     /**
134      * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
135      * caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 value) external returns (bool);
149 
150     /**
151      * @dev Moves a `value` amount of tokens from `from` to `to` using the
152      * allowance mechanism. `value` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address from, address to, uint256 value) external returns (bool);
160 }
161 
162 contract ERC20Detailed is IERC20 {
163     string private _name;
164     string private _symbol;
165     uint8 private _decimals;
166 
167     /**
168      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
169      * these values are immutable: they can only be set once during
170      * construction.
171      */
172     constructor (string memory name, string memory symbol, uint8 decimals) public  {
173         _name = name;
174         _symbol = symbol;
175         _decimals = decimals;
176     }
177 
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() public view returns (string memory) {
182         return _name;
183     }
184 
185     /**
186      * @dev Returns the symbol of the token, usually a shorter version of the
187      * name.
188      */
189     function symbol() public view returns (string memory) {
190         return _symbol;
191     }
192 
193     /**
194      * @dev Returns the number of decimals used to get its user representation.
195      * For example, if `decimals` equals `2`, a balance of `505` tokens should
196      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
197      *
198      * Tokens usually opt for a value of 18, imitating the relationship between
199      * Ether and Wei.
200      *
201      * NOTE: This information is only used for _display_ purposes: it in
202      * no way affects any of the arithmetic of the contract, including
203      * {IERC20-balanceOf} and {IERC20-transfer}.
204      */
205     function decimals() public view returns (uint8) {
206         return _decimals;
207     }
208 }
209 
210 /**
211  * @title SafeMathInt
212  * @dev Math operations for int256 with overflow safety checks.
213  */
214 library SafeMathInt {
215     int256 private constant MIN_INT256 = int256(1) << 255;
216     int256 private constant MAX_INT256 = ~(int256(1) << 255);
217 
218     /**
219      * @dev Multiplies two int256 variables and fails on overflow.
220      */
221     function mul(int256 a, int256 b)
222         internal
223         pure
224         returns (int256)
225     {
226         int256 c = a * b;
227 
228         // Detect overflow when multiplying MIN_INT256 with -1
229         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
230         require((b == 0) || (c / b == a));
231         return c;
232     }
233 
234     /**
235      * @dev Division of two int256 variables and fails on overflow.
236      */
237     function div(int256 a, int256 b)
238         internal
239         pure
240         returns (int256)
241     {
242         // Prevent overflow when dividing MIN_INT256 by -1
243         require(b != -1 || a != MIN_INT256);
244 
245         // Solidity already throws when dividing by 0.
246         return a / b;
247     }
248 
249     /**
250      * @dev Subtracts two int256 variables and fails on overflow.
251      */
252     function sub(int256 a, int256 b)
253         internal
254         pure
255         returns (int256)
256     {
257         int256 c = a - b;
258         require((b >= 0 && c <= a) || (b < 0 && c > a));
259         return c;
260     }
261 
262     /**
263      * @dev Adds two int256 variables and fails on overflow.
264      */
265     function add(int256 a, int256 b)
266         internal
267         pure
268         returns (int256)
269     {
270         int256 c = a + b;
271         require((b >= 0 && c >= a) || (b < 0 && c < a));
272         return c;
273     }
274 
275     /**
276      * @dev Converts to absolute value, and fails on overflow.
277      */
278     function abs(int256 a)
279         internal
280         pure
281         returns (int256)
282     {
283         require(a != MIN_INT256);
284         return a < 0 ? -a : a;
285     }
286 }
287 
288 
289 /**
290  * @title Ownable
291  * @dev The Ownable contract has an owner address, and provides basic authorization control
292  * functions, this simplifies the implementation of "user permissions".
293  */
294 contract Ownable {
295   address public _owner;
296   address public _previousOwner;
297   uint256 public _lockTime;
298 
299   event OwnershipRenounced(address indexed previousOwner);
300   
301   event OwnershipTransferred(
302     address indexed previousOwner,
303     address indexed newOwner
304   );
305 
306   /**
307    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
308    * account.
309    */
310   constructor() public {
311     _owner = msg.sender;
312   }
313 
314   /**
315    * @return the address of the owner.
316    */
317   function owner() public view returns(address) {
318     return _owner;
319   }
320 
321   /**
322    * @dev Throws if called by any account other than the owner.
323    */
324   modifier onlyOwner() {
325     require(isOwner());
326     _;
327   }
328 
329   /**
330    * @return true if `msg.sender` is the owner of the contract.
331    */
332   function isOwner() public view returns(bool) {
333     return msg.sender == _owner;
334   }
335 
336   /**
337    * @dev Allows the current owner to relinquish control of the contract.
338    * @notice Renouncing to ownership will leave the contract without an owner.
339    * It will not be possible to call the functions with the `onlyOwner`
340    * modifier anymore.
341    */
342   function renounceOwnership() public onlyOwner {
343     emit OwnershipRenounced(_owner);
344     _owner = address(0);
345   }
346 
347   /**
348    * @dev Allows the current owner to transfer control of the contract to a newOwner.
349    * @param newOwner The address to transfer ownership to.
350    */
351   function transferOwnership(address newOwner) public onlyOwner {
352     _transferOwnership(newOwner);
353   }
354 
355   /**
356    * @dev Transfers control of the contract to a newOwner.
357    * @param newOwner The address to transfer ownership to.
358    */
359   function _transferOwnership(address newOwner) internal {
360     emit OwnershipTransferred(_owner, newOwner);
361     _owner = newOwner;
362   }
363   
364   function getUnlockTime() public view returns (uint256) {return _lockTime;}
365   	
366   function lock(uint256 time) public onlyOwner {
367 	_previousOwner = _owner;
368 	_owner = address(0);
369 	_lockTime = block.timestamp + time;
370 	emit OwnershipTransferred(_owner, address(0));
371 	}
372 	
373   function unlock() public {
374 	require(_previousOwner == msg.sender, "You don't have permission to unlock");
375 	require(block.timestamp > _lockTime , "Contract is locked");
376 	emit OwnershipTransferred(_owner, _previousOwner);
377 	_owner = _previousOwner;
378 	}
379 }
380 
381 /**
382  * @title MAU ERC20 token
383  * @dev  
384  *      The goal of MAU is to be meme money.
385  *      Based on the Ampleforth protocol.
386  */
387 contract MAU is Context, ERC20Detailed, Ownable {
388     using SafeMath for uint256;
389     using SafeMathInt for int256;
390     
391 	address BURN_ADDRESS = 0x0000000000000000000000000000000000000000;
392 	    
393     event SetLPEvent(address lpAddress);
394 
395     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
396 
397     // Used for authentication
398     address public master;
399     
400     // LP atomic sync
401     address public lp;
402     ILP public lpContract;
403 
404     modifier onlyMaster() {
405         require(msg.sender == master);
406         _;
407     }
408     
409     // Only the owner can transfer tokens in the initial phase.
410     // This is allow the AMM listing to happen in an orderly fashion.
411     bool public initialDistributionFinished;
412     
413     mapping (address => bool) allowTransfer;
414     
415     modifier initialDistributionLock {
416         require(initialDistributionFinished || isOwner() || allowTransfer[msg.sender]);
417         _;
418     }
419 
420     modifier validRecipient(address to) {
421         require(to != address(0x0));
422         require(to != address(this));
423         _;
424     }
425 
426     uint256 private constant DECIMALS = 18;
427     uint256 private constant MAX_UINT256 = ~uint256(0);
428     
429     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 10**14 * 10**DECIMALS;
430 
431     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
432     // Use the highest value that fits in a uint256 for max granularity.
433     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
434 
435     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
436     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
437 
438     uint256 public _totalSupply;
439     uint256 public _gonsPerFragment;
440     mapping(address => uint256) private _gonBalances;
441 
442     // This is denominated in Fragments, because the gons-fragments conversion might change before
443     // it's fully paid.
444     mapping (address => mapping (address => uint256)) private _allowedFragments;
445 
446     /**
447      * @dev Notifies Fragments contract about a new rebase cycle.
448      * @param supplyDelta The number of new fragment tokens to add into circulation via expansion.
449      * @return The total number of fragments after the supply adjustment.
450      */
451     function rebase(uint256 epoch, int256 supplyDelta)
452         external
453         onlyMaster
454         returns (uint256)
455     {
456         if (supplyDelta == 0) {
457             emit LogRebase(epoch, _totalSupply);
458             return _totalSupply;
459         }
460 
461         if (supplyDelta < 0) {
462             _totalSupply = _totalSupply.sub(uint256(-supplyDelta));
463         } else {
464             _totalSupply = _totalSupply.add(uint256(supplyDelta));
465         }
466 
467         if (_totalSupply > MAX_SUPPLY) {
468             _totalSupply = MAX_SUPPLY;
469         }
470         
471         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
472         lpContract.sync();
473 
474         emit LogRebase(epoch, _totalSupply);
475         return _totalSupply;
476     }
477 
478     constructor()
479         ERC20Detailed("Mau Money", "MAU", uint8(DECIMALS)) public
480     {
481         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
482         _gonBalances[msg.sender] = TOTAL_GONS;
483         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
484         
485         initialDistributionFinished = false;
486         emit Transfer(address(0x0), msg.sender, _totalSupply);
487     }
488 
489     /**
490      * @notice Sets a new master
491      */
492     function setMaster(address masterAddress)
493         external
494         onlyOwner
495     {
496         master = masterAddress;
497     }
498     
499     /**
500      * @notice Sets contract LP address
501      */
502     function setLP(address lpAddress)
503         external
504         onlyOwner
505     {
506         lp = lpAddress;
507         lpContract = ILP(lp);
508         emit SetLPEvent(lp);
509     }    
510 
511     /**
512      * @return The total number of fragments.
513      */
514     function totalSupply()
515         public
516         view
517         returns (uint256)
518     {
519         return _totalSupply;
520     }
521 
522    /**
523      * @param who The address to query.
524      * @return The balance of the specified address.
525      */
526     function balanceOf(address who)
527         external
528         view
529         returns (uint256)
530     {
531         return _gonBalances[who].div(_gonsPerFragment);
532     }
533 
534     /**
535      * @dev Transfer tokens to a specified address.
536      * @param to The address to transfer to.
537      * @param value The amount to be transferred.
538      * @return True on success, false otherwise.
539      */
540     function transfer(address to, uint256 value)
541         external
542         validRecipient(to)
543         initialDistributionLock
544         returns (bool)
545     {
546         uint256 gonValue = value.mul(_gonsPerFragment);
547         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
548         _gonBalances[to] = _gonBalances[to].add(gonValue);
549         emit Transfer(msg.sender, to, value);
550         return true;
551     }
552 
553     /**
554      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
555      * @param owner_ The address which owns the funds.
556      * @param spender The address which will spend the funds.
557      * @return The number of tokens still available for the spender.
558      */
559     function allowance(address owner_, address spender)
560         external
561         view
562         returns (uint256)
563     {
564         return _allowedFragments[owner_][spender];
565     }
566 
567     /**
568      * @dev Transfer tokens from one address to another.
569      * @param from The address you want to send tokens from.
570      * @param to The address you want to transfer to.
571      * @param value The amount of tokens to be transferred.
572      */
573     function transferFrom(address from, address to, uint256 value)
574         external
575         validRecipient(to)
576         returns (bool)
577     {
578         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
579 
580         uint256 gonValue = value.mul(_gonsPerFragment);
581         _gonBalances[from] = _gonBalances[from].sub(gonValue);
582         _gonBalances[to] = _gonBalances[to].add(gonValue);
583         emit Transfer(from, to, value);
584 
585         return true;
586     }
587 
588     /**
589      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
590      * msg.sender. This method is included for ERC20 compatibility.
591      * increaseAllowance and decreaseAllowance should be used instead.
592      * Changing an allowance with this method brings the risk that someone may transfer both
593      * the old and the new allowance - if they are both greater than zero - if a transfer
594      * transaction is mined before the later approve() call is mined.
595      *
596      * @param spender The address which will spend the funds.
597      * @param value The amount of tokens to be spent.
598      */
599     function approve(address spender, uint256 value)
600         external
601         initialDistributionLock
602         returns (bool)
603     {
604         _allowedFragments[msg.sender][spender] = value;
605         emit Approval(msg.sender, spender, value);
606         return true;
607     }
608 
609     /**
610      * @dev Increase the amount of tokens that an owner has allowed to a spender.
611      * This method should be used instead of approve() to avoid the double approval vulnerability
612      * described above.
613      * @param spender The address which will spend the funds.
614      * @param addedValue The amount of tokens to increase the allowance by.
615      */
616     function increaseAllowance(address spender, uint256 addedValue)
617         external
618         initialDistributionLock
619         returns (bool)
620     {
621         _allowedFragments[msg.sender][spender] =
622             _allowedFragments[msg.sender][spender].add(addedValue);
623         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
624         return true;
625     }
626 
627     /**
628      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
629      *
630      * @param spender The address which will spend the funds.
631      * @param subtractedValue The amount of tokens to decrease the allowance by.
632      */
633     function decreaseAllowance(address spender, uint256 subtractedValue)
634         external
635         initialDistributionLock
636         returns (bool)
637     {
638         uint256 oldValue = _allowedFragments[msg.sender][spender];
639         if (subtractedValue >= oldValue) {
640             _allowedFragments[msg.sender][spender] = 0;
641         } else {
642             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
643         }
644         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
645         return true;
646     }
647     
648     function setInitialDistributionFinished()
649         external 
650         onlyOwner 
651     {
652         initialDistributionFinished = true;
653     }
654     
655     function enableTransfer(address _addr)
656         external 
657         onlyOwner 
658     {
659         allowTransfer[_addr] = true;
660     }
661 
662 }