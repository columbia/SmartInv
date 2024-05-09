1 /*  
2 *            _..oo8"""Y8888b.._
3 *          .88888888o.       "Yb.
4 *        .d888P""Y8888b         "b.
5 *       o88888    88888)          "b
6 *      d888888b..d8888P            'b
7 *      88888888888888"              8
8 *     (88DWB8888888P                8)
9 *      8888888888P                  8
10 *      Y88888888P       ee         .P
11 *       Y888888(       8888       oP
12 *        "Y88888b       ""      oP"
13 *          "Y8888o._        _.oP"
14 *            `""Y888bood888P""'
15 * 
16 *                YANG V2
17 *
18 *               yangue.me
19 * 
20 */
21 
22 pragma solidity 0.4.24;
23 
24 contract Ownable {
25     address owner;
26 
27     constructor() public {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 }
36 
37 contract Initializable {
38 
39   /**
40    * @dev Indicates that the contract has been initialized.
41    */
42   bool private initialized;
43 
44   /**
45    * @dev Indicates that the contract is in the process of being initialized.
46    */
47   bool private initializing;
48 
49   /**
50    * @dev Modifier to use in the initializer function of a contract.
51    */
52   modifier initializer() {
53     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
54 
55     bool isTopLevelCall = !initializing;
56     if (isTopLevelCall) {
57       initializing = true;
58       initialized = true;
59     }
60 
61     _;
62 
63     if (isTopLevelCall) {
64       initializing = false;
65     }
66   }
67 
68   /// @dev Returns true if and only if the function is running in the constructor
69   function isConstructor() private view returns (bool) {
70     // extcodesize checks the size of the code stored in an address, and
71     // address returns the current address. Since the code is still not
72     // deployed when running a constructor, any checks on its code size will
73     // yield zero, making it an effective way to detect if a contract is
74     // under construction or not.
75     uint256 cs;
76     assembly { cs := extcodesize(address) }
77     return cs == 0;
78   }
79 
80   // Reserved storage space to allow for layout changes in the future.
81   uint256[50] private ______gap;
82 }
83 
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 interface IERC20 {
90   function totalSupply() external view returns (uint256);
91 
92   function balanceOf(address who) external view returns (uint256);
93 
94   function allowance(address owner, address spender)
95     external view returns (uint256);
96 
97   function transfer(address to, uint256 value) external returns (bool);
98 
99   function approve(address spender, uint256 value)
100     external returns (bool);
101 
102   function transferFrom(address from, address to, uint256 value)
103     external returns (bool);
104 
105   event Transfer(
106     address indexed from,
107     address indexed to,
108     uint256 value
109   );
110 
111   event Approval(
112     address indexed owner,
113     address indexed spender,
114     uint256 value
115   );
116 }
117 
118 // File: openzeppelin-eth/contracts/token/ERC20/ERC20Detailed.sol
119 
120 
121 /**
122  * @title ERC20Detailed token
123  * @dev The decimals are only for visualization purposes.
124  * All the operations are done using the smallest and indivisible token unit,
125  * just as on Ethereum all the operations are done in wei.
126  */
127 contract ERC20Detailed is Initializable, IERC20 {
128   string private _name;
129   string private _symbol;
130   uint8 private _decimals;
131 
132   function initialize(string name, string symbol, uint8 decimals) public initializer {
133     _name = name;
134     _symbol = symbol;
135     _decimals = decimals;
136   }
137 
138   /**
139    * @return the name of the token.
140    */
141   function name() public view returns(string) {
142     return _name;
143   }
144 
145   /**
146    * @return the symbol of the token.
147    */
148   function symbol() public view returns(string) {
149     return _symbol;
150   }
151 
152   /**
153    * @return the number of decimals of the token.
154    */
155   function decimals() public view returns(uint8) {
156     return _decimals;
157   }
158 
159   uint256[50] private ______gap;
160 }
161 
162 
163 contract Yangue is ERC20Detailed, Ownable {
164     using SafeMathInt for int256;
165     using UInt256Lib for uint256;
166     using SafeMath for uint256;
167 
168     uint256 constant public zero = uint256(0);
169 
170     uint256 private constant MAX_SUPPLY = ~uint128(0);
171     uint256 public constant MAX_UINT256 = ~uint256(0);
172     uint256 public constant INITIAL_FRAGMENTS_SUPPLY = 6 * (10**4) * (10**DECIMALS);
173 
174     // TOTAL_GONS is a multiple of INITIAL_FRAGMENTS_SUPPLY so that _gonsPerFragment is an integer.
175     // Use the highest value that fits in a uint256 for max granularity.
176     uint256 public constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
177 
178     uint256 public constant MAG = 10 ** 18;
179     uint256 public  rateOfChange = MAG;
180 
181 	uint256 constant public DECIMALS = 18;
182 
183     uint256 public _totalSupply;
184     uint256 public _gonsPerFragment;
185     mapping(address => uint256) public _gonBalances;
186 
187     // This is denominated in Fragments, because the gons-fragments conversion might change before
188     // it's fully paid.
189     mapping (address => mapping (address => uint256)) public _allowedFragments;
190 
191 
192 	event Transfer(address indexed from, address indexed to, uint256 tokens);
193 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
194 
195  
196 
197 	constructor() public {
198         ERC20Detailed.initialize("Yangue v2", "YANG", uint8(DECIMALS));
199         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
200         _gonBalances[owner] = TOTAL_GONS;
201         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
202 	}
203 
204     /**
205      * @return The total number of fragments.
206      */
207     function totalSupply()
208         public
209         view
210         returns (uint256)
211     {
212         return _totalSupply;
213     }
214 
215     /**
216      * @param who The address to query.
217      * @return The balance of the specified address.
218      */
219     function balanceOf(address who)
220         public
221         view
222         returns (uint256)
223     {
224         return _gonBalances[who].div(_gonsPerFragment);
225     }
226     
227     
228     function computeSupplyDelta(uint256 rate, uint256 targetRate)
229         private
230         view
231         returns (int256)
232     {
233 
234         // supplyDelta = totalSupply * (rate - targetRate) / targetRate
235         int256 targetRateSigned = targetRate.toInt256Safe();
236         return totalSupply().toInt256Safe()
237             .mul(rate.toInt256Safe().sub(targetRateSigned))
238             .div(targetRateSigned);
239     }    
240     
241     
242     //two rebase functions deffo work just need to integrate them in the transfers, do this tomorrow then deploy on uniswap
243     function rebasePlus(uint256 _amount) private {
244          uint256 proportion_ = (((_amount.div(10)).mul(MAG))).div(_totalSupply);		
245          proportion_ = MAG.add(proportion_);
246          int256 supplyDelta = computeSupplyDelta(proportion_, MAG);
247          if (supplyDelta < 0) {
248             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
249         } else {
250             _totalSupply = _totalSupply.add(uint256(supplyDelta));
251         }
252 
253 
254         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
255 
256     }
257     
258     function rebaseMinus(uint256 _amount) private {
259          uint256 proportion_ = (((_amount.div(10)).mul(MAG))).div(_totalSupply);		
260          proportion_ = MAG.sub(proportion_);
261          int256 supplyDelta = computeSupplyDelta(proportion_, MAG);
262          if (supplyDelta < 0) {
263             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
264         } else {
265             _totalSupply = _totalSupply.add(uint256(supplyDelta));
266         } 
267         
268         if (_totalSupply > MAX_SUPPLY) {
269             _totalSupply = MAX_SUPPLY;
270         }
271 
272 
273         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
274 
275     }    
276 
277     /**
278      * @dev Transfer tokens to a specified address.
279      * @param to The address to transfer to.
280      * @param value The amount to be transferred.
281      * @return True on success, false otherwise.
282      */
283     function transfer(address to, uint256 value)
284         public
285         returns (bool)
286     {
287 	    bool isNewUser = balanceOf(to) == zero;
288         uint256 gonValue = value.mul(_gonsPerFragment);
289         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
290         _gonBalances[to] = _gonBalances[to].add(gonValue);
291         if(isNewUser && balanceOf(msg.sender) > zero) {
292             rebasePlus(value);
293         } else if( balanceOf(msg.sender) == zero) {
294             rebaseMinus(value);
295         }
296         emit Transfer(msg.sender, to, value);
297         return true;
298     }
299 
300     /**
301      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
302      * @param owner_ The address which owns the funds.
303      * @param spender The address which will spend the funds.
304      * @return The number of tokens still available for the spender.
305      */
306     function allowance(address owner_, address spender)
307         public
308         view
309         returns (uint256)
310     {
311         return _allowedFragments[owner_][spender];
312     }
313 
314     /**
315      * @dev Transfer tokens from one address to another.
316      * @param from The address you want to send tokens from.
317      * @param to The address you want to transfer to.
318      * @param value The amount of tokens to be transferred.
319      */
320     function transferFrom(address from, address to, uint256 value)
321         public
322         returns (bool)
323     {
324 	    bool isNewUser = balanceOf(to) == zero;
325         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
326         uint256 gonValue = value.mul(_gonsPerFragment);
327         _gonBalances[from] = _gonBalances[from].sub(gonValue);
328         _gonBalances[to] = _gonBalances[to].add(gonValue);
329         if(isNewUser && balanceOf(from) > zero) {
330             rebasePlus(value);
331         } else if(balanceOf(from) == zero) {
332             rebaseMinus(value);
333         }
334         emit Transfer(from, to, value);
335         return true;
336     }
337 
338     /**
339      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
340      * msg.sender. This method is included for ERC20 compatibility.
341      * increaseAllowance and decreaseAllowance should be used instead.
342      * Changing an allowance with this method brings the risk that someone may transfer both
343      * the old and the new allowance - if they are both greater than zero - if a transfer
344      * transaction is mined before the later approve() call is mined.
345      *
346      * @param spender The address which will spend the funds.
347      * @param value The amount of tokens to be spent.
348      */
349     function approve(address spender, uint256 value)
350         public
351         returns (bool)
352     {
353         _allowedFragments[msg.sender][spender] = value;
354         emit Approval(msg.sender, spender, value);
355         return true;
356     }
357 
358     /**
359      * @dev Increase the amount of tokens that an owner has allowed to a spender.
360      * This method should be used instead of approve() to avoid the double approval vulnerability
361      * described above.
362      * @param spender The address which will spend the funds.
363      * @param addedValue The amount of tokens to increase the allowance by.
364      */
365     function increaseAllowance(address spender, uint256 addedValue)
366         public
367         returns (bool)
368     {
369         _allowedFragments[msg.sender][spender] =
370             _allowedFragments[msg.sender][spender].add(addedValue);
371         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
372         return true;
373     }
374 
375     /**
376      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
377      *
378      * @param spender The address which will spend the funds.
379      * @param subtractedValue The amount of tokens to decrease the allowance by.
380      */
381     function decreaseAllowance(address spender, uint256 subtractedValue)
382         public
383         returns (bool)
384     {
385         uint256 oldValue = _allowedFragments[msg.sender][spender];
386         if (subtractedValue >= oldValue) {
387             _allowedFragments[msg.sender][spender] = 0;
388         } else {
389             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
390         }
391         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
392         return true;
393     }
394 	
395 }
396 
397 library SafeMath {
398     int256 private constant MIN_INT256 = int256(1) << 255;
399 
400     /**
401      * @dev Returns the addition of two unsigned integers, reverting on
402      * overflow.
403      *
404      * Counterpart to Solidity's `+` operator.
405      *
406      * Requirements:
407      *
408      * - Addition cannot overflow.
409      */
410     function add(uint256 a, uint256 b) internal pure returns (uint256) {
411         uint256 c = a + b;
412         require(c >= a, "SafeMath: addition overflow");
413 
414         return c;
415     }
416 
417     /**
418      * @dev Returns the subtraction of two unsigned integers, reverting on
419      * overflow (when the result is negative).
420      *
421      * Counterpart to Solidity's `-` operator.
422      *
423      * Requirements:
424      *
425      * - Subtraction cannot overflow.
426      */
427     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
428         return sub(a, b, "SafeMath: subtraction overflow");
429     }
430 
431     /**
432      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
433      * overflow (when the result is negative).
434      *
435      * Counterpart to Solidity's `-` operator.
436      *
437      * Requirements:
438      *
439      * - Subtraction cannot overflow.
440      */
441     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
442         require(b <= a, errorMessage);
443         uint256 c = a - b;
444 
445         return c;
446     }
447 
448     /**
449      * @dev Returns the multiplication of two unsigned integers, reverting on
450      * overflow.
451      *
452      * Counterpart to Solidity's `*` operator.
453      *
454      * Requirements:
455      *
456      * - Multiplication cannot overflow.
457      */
458     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
459         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
460         // benefit is lost if 'b' is also tested.
461         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
462         if (a == 0) {
463             return 0;
464         }
465 
466         uint256 c = a * b;
467         require(c / a == b, "SafeMath: multiplication overflow");
468 
469         return c;
470     }
471 
472     /**
473      * @dev Returns the integer division of two unsigned integers. Reverts on
474      * division by zero. The result is rounded towards zero.
475      *
476      * Counterpart to Solidity's `/` operator. Note: this function uses a
477      * `revert` opcode (which leaves remaining gas untouched) while Solidity
478      * uses an invalid opcode to revert (consuming all remaining gas).
479      *
480      * Requirements:
481      *
482      * - The divisor cannot be zero.
483      */
484     function div(uint256 a, uint256 b) internal pure returns (uint256) {
485         return div(a, b, "SafeMath: division by zero");
486     }
487 
488     /**
489      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
490      * division by zero. The result is rounded towards zero.
491      *
492      * Counterpart to Solidity's `/` operator. Note: this function uses a
493      * `revert` opcode (which leaves remaining gas untouched) while Solidity
494      * uses an invalid opcode to revert (consuming all remaining gas).
495      *
496      * Requirements:
497      *
498      * - The divisor cannot be zero.
499      */
500     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
501         require(b > 0, errorMessage);
502         uint256 c = a / b;
503         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
504 
505         return c;
506     }
507 
508     /**
509      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
510      * Reverts when dividing by zero.
511      *
512      * Counterpart to Solidity's `%` operator. This function uses a `revert`
513      * opcode (which leaves remaining gas untouched) while Solidity uses an
514      * invalid opcode to revert (consuming all remaining gas).
515      *
516      * Requirements:
517      *
518      * - The divisor cannot be zero.
519      */
520     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
521         return mod(a, b, "SafeMath: modulo by zero");
522     }
523 
524     /**
525      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
526      * Reverts with custom message when dividing by zero.
527      *
528      * Counterpart to Solidity's `%` operator. This function uses a `revert`
529      * opcode (which leaves remaining gas untouched) while Solidity uses an
530      * invalid opcode to revert (consuming all remaining gas).
531      *
532      * Requirements:
533      *
534      * - The divisor cannot be zero.
535      */
536     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
537         require(b != 0, errorMessage);
538         return a % b;
539     }
540     
541     function abs(int256 a)
542         internal
543         pure
544         returns (int256)
545     {
546         require(a != MIN_INT256);
547         return a < 0 ? -a : a;
548     }
549     
550 }
551 
552 library UInt256Lib {
553 
554     uint256 private constant MAX_INT256 = ~(uint256(1) << 255);
555 
556     /**
557      * @dev Safely converts a uint256 to an int256.
558      */
559     function toInt256Safe(uint256 a)
560         internal
561         pure
562         returns (int256)
563     {
564         require(a <= MAX_INT256);
565         return int256(a);
566     }
567 }
568 
569 library SafeMathInt {
570     int256 private constant MIN_INT256 = int256(1) << 255;
571     int256 private constant MAX_INT256 = ~(int256(1) << 255);
572 
573     /**
574      * @dev Multiplies two int256 variables and fails on overflow.
575      */
576     function mul(int256 a, int256 b)
577         internal
578         pure
579         returns (int256)
580     {
581         int256 c = a * b;
582 
583         // Detect overflow when multiplying MIN_INT256 with -1
584         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
585         require((b == 0) || (c / b == a));
586         return c;
587     }
588 
589     /**
590      * @dev Division of two int256 variables and fails on overflow.
591      */
592     function div(int256 a, int256 b)
593         internal
594         pure
595         returns (int256)
596     {
597         // Prevent overflow when dividing MIN_INT256 by -1
598         require(b != -1 || a != MIN_INT256);
599 
600         // Solidity already throws when dividing by 0.
601         return a / b;
602     }
603 
604     /**
605      * @dev Subtracts two int256 variables and fails on overflow.
606      */
607     function sub(int256 a, int256 b)
608         internal
609         pure
610         returns (int256)
611     {
612         int256 c = a - b;
613         require((b >= 0 && c <= a) || (b < 0 && c > a));
614         return c;
615     }
616 
617     /**
618      * @dev Adds two int256 variables and fails on overflow.
619      */
620     function add(int256 a, int256 b)
621         internal
622         pure
623         returns (int256)
624     {
625         int256 c = a + b;
626         require((b >= 0 && c >= a) || (b < 0 && c < a));
627         return c;
628     }
629 
630     /**
631      * @dev Converts to absolute value, and fails on overflow.
632      */
633     function abs(int256 a)
634         internal
635         pure
636         returns (int256)
637     {
638         require(a != MIN_INT256);
639         return a < 0 ? -a : a;
640     }
641 }