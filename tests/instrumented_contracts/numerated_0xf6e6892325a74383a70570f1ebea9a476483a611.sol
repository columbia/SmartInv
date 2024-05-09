1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-21
3 */
4 
5 pragma solidity 0.4.24;
6     
7     
8     /**
9      * @title SafeMath
10      * @dev Math operations with safety checks that revert on error
11      */
12     library SafeMath {
13     
14       /**
15       * @dev Multiplies two numbers, reverts on overflow.
16       */
17       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19         // benefit is lost if 'b' is also SATOed.
20         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21         if (a == 0) {
22           return 0;
23         }
24     
25         uint256 c = a * b;
26         require(c / a == b);
27     
28         return c;
29       }
30     
31       /**
32       * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
33       */
34       function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b > 0); // Solidity only automatically asserts when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     
39         return c;
40       }
41     
42       /**
43       * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44       */
45       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b <= a);
47         uint256 c = a - b;
48     
49         return c;
50       }
51     
52       /**
53       * @dev Adds two numbers, reverts on overflow.
54       */
55       function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a);
58     
59         return c;
60       }
61     
62       /**
63       * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
64       * reverts when dividing by zero.
65       */
66       function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b != 0);
68         return a % b;
69       }
70     }
71     
72     /**
73      * @title Initializable
74      *
75      * @dev Helper contract to support initializer functions. To use it, replace
76      * the constructor with a function that has the `initializer` modifier.
77      * WARNING: Unlike constructors, initializer functions must be manually
78      * invoked. This applies both to deploying an Initializable contract, as well
79      * as extending an Initializable contract via inheritance.
80      * WARNING: When used with inheritance, manual care must be taken to not invoke
81      * a parent initializer twice, or ensure that all initializers are idempotent,
82      * because this is not dealt with automatically as with constructors.
83      */
84     contract Initializable {
85     
86       /**
87        * @dev Indicates that the contract has been initialized.
88        */
89       bool private initialized;
90     
91       /**
92        * @dev Indicates that the contract is in the process of being initialized.
93        */
94       bool private initializing;
95     
96       /**
97        * @dev Modifier to use in the initializer function of a contract.
98        */
99       modifier initializer() {
100         require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
101     
102         bool wasInitializing = initializing;
103         initializing = true;
104         initialized = true;
105     
106         _;
107     
108         initializing = wasInitializing;
109       }
110     
111       /// @dev Returns true if and only if the function is running in the constructor
112       function isConstructor() private view returns (bool) {
113         // extcodesize checks the size of the code stored in an address, and
114         // address returns the current address. Since the code is still not
115         // deployed when running a constructor, any checks on its code size will
116         // yield zero, making it an effective way to detect if a contract is
117         // under construction or not.
118         uint256 cs;
119         assembly { cs := extcodesize(address) }
120         return cs == 0;
121       }
122     
123       // Reserved storage space to allow for layout changes in the future.
124       uint256[50] private ______gap;
125     }
126     
127     /**
128      * @title Ownable
129      * @dev The Ownable contract has an owner address, and provides basic authorization control
130      * functions, this simplifies the implementation of "user permissions".
131      */
132     contract Ownable is Initializable {
133       address private _owner;
134     
135     
136       event OwnershipRenounced(address indexed previousOwner);
137       event OwnershipTransferred(
138         address indexed previousOwner,
139         address indexed newOwner
140       );
141     
142     
143       /**
144        * @dev The Ownable constructor sets the original `owner` of the contract to the sender
145        * account.
146        */
147       function initialize(address sender) public initializer {
148         _owner = sender;
149       }
150     
151       /**
152        * @return the address of the owner.
153        */
154       function owner() public view returns(address) {
155         return _owner;
156       }
157     
158       /**
159        * @dev Throws if called by any account other than the owner.
160        */
161       modifier onlyOwner() {
162         require(isOwner());
163         _;
164       }
165     
166       /**
167        * @return true if `msg.sender` is the owner of the contract.
168        */
169       function isOwner() public view returns(bool) {
170         return msg.sender == _owner;
171       }
172     
173       /**
174        * @dev Allows the current owner to relinquish control of the contract.
175        * @notice Renouncing to ownership will leave the contract without an owner.
176        * It will not be possible to call the functions with the `onlyOwner`
177        * modifier anymore.
178        */
179       function renounceOwnership() public onlyOwner {
180         emit OwnershipRenounced(_owner);
181         _owner = address(0);
182       }
183     
184       /**
185        * @dev Allows the current owner to transfer control of the contract to a newOwner.
186        * @param newOwner The address to transfer ownership to.
187        */
188       function transferOwnership(address newOwner) public onlyOwner {
189         _transferOwnership(newOwner);
190       }
191     
192       /**
193        * @dev Transfers control of the contract to a newOwner.
194        * @param newOwner The address to transfer ownership to.
195        */
196       function _transferOwnership(address newOwner) internal {
197         require(newOwner != address(0));
198         emit OwnershipTransferred(_owner, newOwner);
199         _owner = newOwner;
200       }
201     
202       uint256[50] private ______gap;
203     }
204     
205     /**
206      * @title ERC20 interface
207      * @dev see https://github.com/ethereum/EIPs/issues/20
208      */
209     interface IERC20 {
210       function totalSupply() external view returns (uint256);
211     
212       function balanceOf(address who) external view returns (uint256);
213     
214       function allowance(address owner, address spender)
215         external view returns (uint256);
216     
217       function transfer(address to, uint256 value) external returns (bool);
218     
219       function approve(address spender, uint256 value)
220         external returns (bool);
221     
222       function transferFrom(address from, address to, uint256 value)
223         external returns (bool);
224     
225       event Transfer(
226         address indexed from,
227         address indexed to,
228         uint256 value
229       );
230     
231       event Approval(
232         address indexed owner,
233         address indexed spender,
234         uint256 value
235       );
236     }
237     
238     /**
239      * @title ERC20Detailed token
240      * @dev The decimals are only for visualization purposes.
241      * All the operations are done using the smallest and indivisible token unit,
242      * just as on Ethereum all the operations are done in wei.
243      */
244     contract ERC20Detailed is Initializable, IERC20 {
245       string private _name;
246       string private _symbol;
247       uint8 private _decimals;
248     
249       function initialize(string name, string symbol, uint8 decimals) internal initializer {
250         _name = name;
251         _symbol = symbol;
252         _decimals = decimals;
253       }
254     
255       /**
256        * @return the name of the token.
257        */
258       function name() public view returns(string) {
259         return _name;
260       }
261     
262       /**
263        * @return the symbol of the token.
264        */
265       function symbol() public view returns(string) {
266         return _symbol;
267       }
268     
269       /**
270        * @return the number of decimals of the token.
271        */
272       function decimals() public view returns(uint8) {
273         return _decimals;
274       }
275     
276       uint256[50] private ______gap;
277     }
278     
279     /*
280     MIT License
281     
282     Copyright (c) 2018 requestnetwork
283     Copyright (c) 2018 SATOs, Inc.
284     
285     Permission is hereby granted, free of charge, to any person obtaining a copy
286     of this software and associated documentation files (the "Software"), to deal
287     in the Software without restriction, including without limitation the rights
288     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
289     copies of the Software, and to permit persons to whom the Software is
290     furnished to do so, subject to the following conditions:
291     
292     The above copyright notice and this permission notice shall be included in all
293     copies or substantial portions of the Software.
294     
295     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
296     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
297     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
298     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
299     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
300     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
301     SOFTWARE.
302     */
303     /**
304      * @title SafeMathInt
305      * @dev Math operations for int256 with overflow safety checks.
306      */
307     library SafeMathInt {
308         int256 private constant MIN_INT256 = int256(1) << 255;
309         int256 private constant MAX_INT256 = ~(int256(1) << 255);
310     
311         /**
312          * @dev Multiplies two int256 variables and fails on overflow.
313          */
314         function mul(int256 a, int256 b)
315             internal
316             pure
317             returns (int256)
318         {
319             int256 c = a * b;
320     
321             // Detect overflow when multiplying MIN_INT256 with -1
322             require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
323             require((b == 0) || (c / b == a));
324             return c;
325         }
326     
327         /**
328          * @dev Division of two int256 variables and fails on overflow.
329          */
330         function div(int256 a, int256 b)
331             internal
332             pure
333             returns (int256)
334         {
335             // Prevent overflow when dividing MIN_INT256 by -1
336             require(b != -1 || a != MIN_INT256);
337     
338             // Solidity already throws when dividing by 0.
339             return a / b;
340         }
341     
342         /**
343          * @dev Subtracts two int256 variables and fails on overflow.
344          */
345         function sub(int256 a, int256 b)
346             internal
347             pure
348             returns (int256)
349         {
350             int256 c = a - b;
351             require((b >= 0 && c <= a) || (b < 0 && c > a));
352             return c;
353         }
354     
355         /**
356          * @dev Adds two int256 variables and fails on overflow.
357          */
358         function add(int256 a, int256 b)
359             internal
360             pure
361             returns (int256)
362         {
363             int256 c = a + b;
364             require((b >= 0 && c >= a) || (b < 0 && c < a));
365             return c;
366         }
367     
368         /**
369          * @dev Converts to absolute value, and fails on overflow.
370          */
371         function abs(int256 a)
372             internal
373             pure
374             returns (int256)
375         {
376             require(a != MIN_INT256);
377             return a < 0 ? -a : a;
378         }
379     }
380     
381     /**
382      * @title SATO ERC20 token
383      * @dev This is part of an implementation of the SATO Ideal Money protocol.
384      *      SATO is a normal ERC20 token, but its supply can be adjusted by splitting and
385      *      combining tokens proportionally across all wallets.
386      *
387      *      SATO balances are internally represented with a hidden denomination, 'gons'.
388      *      We support splitting the currency in expansion and combining the currency on contraction by
389      *      changing the exchange rate between the hidden 'gons' and the public 'SATOs'.
390      */
391     contract SATO is ERC20Detailed, Ownable {
392         // PLEASE READ BEFORE CHANGING ANY ACCOUNTING OR MATH
393         // Anytime there is division, there is a risk of numerical instability from rounding errors. In
394         // order to minimize this risk, we adhere to the following guidelines:
395         // 1) The conversion rate adopted is the number of gons that equals 1 SATO.
396         //    The inverse rate must not be used--TOTAL_GONS is always the numerator and _totalSupply is
397         //    always the denominator. (i.e. If you want to convert gons to SATOs instead of
398         //    multiplying by the inverse rate, you should divide by the normal rate)
399         // 2) Gon balances converted into SATOs are always rounded down (truncated).
400         //
401         // We make the following guarantees:
402         // - If address 'A' transfers x SATOs to address 'B'. A's resulting external balance will
403         //   be decreased by precisely x SATOs, and B's external balance will be precisely
404         //   increased by x SATOs.
405         //
406         // We do not guarantee that the sum of all balances equals the result of calling totalSupply().
407         // This is because, for any conversion function 'f()' that has non-zero rounding error,
408         // f(x0) + f(x1) + ... + f(xn) is not always equal to f(x0 + x1 + ... xn).
409         using SafeMath for uint256;
410         using SafeMathInt for int256;
411     
412         event LogRebase(uint256 indexed epoch, uint256 totalSupply);
413         event LogRebasePaused(bool paused);
414         event LogTokenPaused(bool paused);
415         event LogSATOPolicyUpdated(address SATOPolicy);
416     
417         // Used for authentication
418         address public SATOPolicy;
419     
420         modifier onlySATOPolicy() {
421             require(msg.sender == SATOPolicy);
422             _;
423         }
424     
425         // Precautionary emergency controls.
426         bool public rebasePaused;
427         bool public tokenPaused;
428     
429         modifier whenRebaseNotPaused() {
430             require(!rebasePaused);
431             _;
432         }
433     
434         modifier whenTokenNotPaused() {
435             require(!tokenPaused);
436             _;
437         }
438     
439         modifier validRecipient(address to) {
440             require(to != address(0x0));
441             require(to != address(this));
442             _;
443         }
444     
445         uint256 private constant DECIMALS = 18;
446         uint256 private constant MAX_UINT256 = ~uint256(0);
447         uint256 private constant INITIAL_SATO_SUPPLY = 5000000 * 10**DECIMALS;
448     
449         // TOTAL_GONS is a multiple of INITIAL_SATO_SUPPLY so that _gonsPerFragment is an integer.
450         // Use the highest value that fits in a uint256 for max granularity.
451         uint256 private constant TOTAL_GONS = MAX_UINT256 -
452             (MAX_UINT256 % INITIAL_SATO_SUPPLY);
453     
454         // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
455         uint256 private constant MAX_SUPPLY = ~uint128(0); // (2^128) - 1
456     
457         uint256 private _totalSupply;
458         uint256 private _gonsPerFragment;
459         mapping(address => uint256) private _gonBalances;
460     
461         // This is denominated in SATOs, because the gons-SATOs conversion might change before
462         // it's fully paid.
463         mapping(address => mapping(address => uint256)) private _allowedSATOs;
464     
465         /**
466          * @param SATOPolicy_ The address of the SATO policy contract to use for authentication.
467          */
468         function setSATOPolicy(address SATOPolicy_) external onlyOwner {
469             SATOPolicy = SATOPolicy_;
470             emit LogSATOPolicyUpdated(SATOPolicy_);
471         }
472     
473         /**
474          * @dev Pauses or unpauses the execution of rebase operations.
475          * @param paused Pauses rebase operations if this is true.
476          */
477         function setRebasePaused(bool paused) external onlyOwner {
478             rebasePaused = paused;
479             emit LogRebasePaused(paused);
480         }
481     
482         /**
483          * @dev Pauses or unpauses execution of ERC-20 transactions.
484          * @param paused Pauses ERC-20 transactions if this is true.
485          */
486         function setTokenPaused(bool paused) external onlyOwner {
487             tokenPaused = paused;
488             emit LogTokenPaused(paused);
489         }
490     
491         /**
492          * @dev Notifies SATOs contract about a new rebase cycle.
493          * @param supplyDelta The number of new SATO tokens to add into circulation via expansion.
494          * @return The total number of SATOs after the supply adjustment.
495          */
496         function rebase(uint256 epoch, int256 supplyDelta)
497             external
498             onlySATOPolicy
499             whenRebaseNotPaused
500             returns (uint256)
501         {
502             if (supplyDelta == 0) {
503                 emit LogRebase(epoch, _totalSupply);
504                 return _totalSupply;
505             }
506     
507             if (supplyDelta < 0) {
508                 _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
509             } else {
510                 _totalSupply = _totalSupply.add(uint256(supplyDelta));
511             }
512     
513             if (_totalSupply > MAX_SUPPLY) {
514                 _totalSupply = MAX_SUPPLY;
515             }
516     
517             _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
518     
519             // From this point forward, _gonsPerFragment is taken as the source of truth.
520             // We recalculate a new _totalSupply to be in agreement with the _gonsPerFragment
521             // conversion rate.
522             // This means our applied supplyDelta can deviate from the requested supplyDelta,
523             // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
524             //
525             // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
526             // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
527             // ever increased, it must be re-included.
528             // _totalSupply = TOTAL_GONS.div(_gonsPerFragment)
529     
530             emit LogRebase(epoch, _totalSupply);
531             return _totalSupply;
532         }
533     
534         function initialize(address owner_) public initializer {
535             ERC20Detailed.initialize("Super Algorithmic Token", "SATO", uint8(DECIMALS));
536             Ownable.initialize(owner_);
537     
538             rebasePaused = false;
539             tokenPaused = false;
540     
541             _totalSupply = INITIAL_SATO_SUPPLY;
542             _gonBalances[owner_] = TOTAL_GONS;
543             _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
544     
545             emit Transfer(address(0x0), owner_, _totalSupply);
546         }
547     
548         /**
549          * @return The total number of SATOs.
550          */
551         function totalSupply() public view returns (uint256) {
552             return _totalSupply;
553         }
554     
555         /**
556          * @param who The address to query.
557          * @return The balance of the specified address.
558          */
559         function balanceOf(address who) public view returns (uint256) {
560             return _gonBalances[who].div(_gonsPerFragment);
561         }
562     
563         /**
564          * @dev Transfer tokens to a specified address.
565          * @param to The address to transfer to.
566          * @param value The amount to be transferred.
567          * @return True on success, false otherwise.
568          */
569         function transfer(address to, uint256 value)
570             public
571             validRecipient(to)
572             whenTokenNotPaused
573             returns (bool)
574         {
575             uint256 gonValue = value.mul(_gonsPerFragment);
576             _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
577             _gonBalances[to] = _gonBalances[to].add(gonValue);
578             emit Transfer(msg.sender, to, value);
579             return true;
580         }
581     
582         /**
583          * @dev Function to check the amount of tokens that an owner has allowed to a spender.
584          * @param owner_ The address which owns the funds.
585          * @param spender The address which will spend the funds.
586          * @return The number of tokens still available for the spender.
587          */
588         function allowance(address owner_, address spender)
589             public
590             view
591             returns (uint256)
592         {
593             return _allowedSATOs[owner_][spender];
594         }
595     
596         /**
597          * @dev Transfer tokens from one address to another.
598          * @param from The address you want to send tokens from.
599          * @param to The address you want to transfer to.
600          * @param value The amount of tokens to be transferred.
601          */
602         function transferFrom(
603             address from,
604             address to,
605             uint256 value
606         ) public validRecipient(to) whenTokenNotPaused returns (bool) {
607             _allowedSATOs[from][msg.sender] = _allowedSATOs[from][msg
608                 .sender]
609                 .sub(value);
610     
611             uint256 gonValue = value.mul(_gonsPerFragment);
612             _gonBalances[from] = _gonBalances[from].sub(gonValue);
613             _gonBalances[to] = _gonBalances[to].add(gonValue);
614             emit Transfer(from, to, value);
615     
616             return true;
617         }
618     
619         /**
620          * @dev Approve the passed address to spend the specified amount of tokens on behalf of
621          * msg.sender. This method is included for ERC20 compatibility.
622          * increaseAllowance and decreaseAllowance should be used instead.
623          * Changing an allowance with this method brings the risk that someone may transfer both
624          * the old and the new allowance - if they are both greater than zero - if a transfer
625          * transaction is mined before the later approve() call is mined.
626          *
627          * @param spender The address which will spend the funds.
628          * @param value The amount of tokens to be spent.
629          */
630         function approve(address spender, uint256 value)
631             public
632             whenTokenNotPaused
633             returns (bool)
634         {
635             _allowedSATOs[msg.sender][spender] = value;
636             emit Approval(msg.sender, spender, value);
637             return true;
638         }
639     
640         /**
641          * @dev Increase the amount of tokens that an owner has allowed to a spender.
642          * This method should be used instead of approve() to avoid the double approval vulnerability
643          * described above.
644          * @param spender The address which will spend the funds.
645          * @param addedValue The amount of tokens to increase the allowance by.
646          */
647         function increaseAllowance(address spender, uint256 addedValue)
648             public
649             whenTokenNotPaused
650             returns (bool)
651         {
652             _allowedSATOs[msg.sender][spender] = _allowedSATOs[msg
653                 .sender][spender]
654                 .add(addedValue);
655             emit Approval(
656                 msg.sender,
657                 spender,
658                 _allowedSATOs[msg.sender][spender]
659             );
660             return true;
661         }
662     
663         /**
664          * @dev Decrease the amount of tokens that an owner has allowed to a spender.
665          *
666          * @param spender The address which will spend the funds.
667          * @param subtractedValue The amount of tokens to decrease the allowance by.
668          */
669         function decreaseAllowance(address spender, uint256 subtractedValue)
670             public
671             whenTokenNotPaused
672             returns (bool)
673         {
674             uint256 oldValue = _allowedSATOs[msg.sender][spender];
675             if (subtractedValue >= oldValue) {
676                 _allowedSATOs[msg.sender][spender] = 0;
677             } else {
678                 _allowedSATOs[msg.sender][spender] = oldValue.sub(
679                     subtractedValue
680                 );
681             }
682             emit Approval(
683                 msg.sender,
684                 spender,
685                 _allowedSATOs[msg.sender][spender]
686             );
687             return true;
688         }
689     }