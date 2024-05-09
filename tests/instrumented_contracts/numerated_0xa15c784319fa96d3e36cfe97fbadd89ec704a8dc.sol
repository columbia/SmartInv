1 /*
2 file:   Base.sol
3 ver:    0.2.1
4 updated:18-Nov-2016
5 author: Darryl Morris (o0ragman0o)
6 email:  o0ragman0o AT gmail.com
7 
8 An basic contract furnishing inheriting contracts with ownership, reentry
9 protection and safe sending functions.
10 
11 This software is distributed in the hope that it will be useful,
12 but WITHOUT ANY WARRANTY; without even the implied warranty of
13 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14 GNU lesser General Public License for more details.
15 <http://www.gnu.org/licenses/>.
16 */
17 
18 pragma solidity ^0.4.0;
19 
20 contract Base
21 {
22 /* Constants */
23 
24     string constant VERSION = "Base 0.1.1 \n";
25 
26 /* State Variables */
27 
28     bool mutex;
29     address public owner;
30 
31 /* Events */
32 
33     event Log(string message);
34     event ChangedOwner(address indexed oldOwner, address indexed newOwner);
35 
36 /* Modifiers */
37 
38     // To throw call not made by owner
39     modifier onlyOwner() {
40         if (msg.sender != owner) throw;
41         _;
42     }
43 
44     // This modifier can be used on functions with external calls to
45     // prevent reentry attacks.
46     // Constraints:
47     //   Protected functions must have only one point of exit.
48     //   Protected functions cannot use the `return` keyword
49     //   Protected functions return values must be through return parameters.
50     modifier preventReentry() {
51         if (mutex) throw;
52         else mutex = true;
53         _;
54         delete mutex;
55         return;
56     }
57 
58     // This modifier can be applied to pulic access state mutation functions
59     // to protect against reentry if a `mutextProtect` function is already
60     // on the call stack.
61     modifier noReentry() {
62         if (mutex) throw;
63         _;
64     }
65 
66     // Same as noReentry() but intended to be overloaded
67     modifier canEnter() {
68         if (mutex) throw;
69         _;
70     }
71     
72 /* Functions */
73 
74     function Base() { owner = msg.sender; }
75 
76     function version() public constant returns (string) {
77         return VERSION;
78     }
79 
80     function contractBalance() public constant returns(uint) {
81         return this.balance;
82     }
83 
84     // Change the owner of a contract
85     function changeOwner(address _newOwner)
86         public onlyOwner returns (bool)
87     {
88         owner = _newOwner;
89         ChangedOwner(msg.sender, owner);
90         return true;
91     }
92     
93     function safeSend(address _recipient, uint _ether)
94         internal
95         preventReentry()
96         returns (bool success_)
97     {
98         if(!_recipient.call.value(_ether)()) throw;
99         success_ = true;
100     }
101 }
102 
103 /* End of Base */
104 
105 /*
106 file:   Math.sol
107 ver:    0.2.0
108 updated:18-Nov-2016
109 author: Darryl Morris
110 email:  o0ragman0o AT gmail.com
111 
112 An inheritable contract containing math functions and comparitors.
113 
114 This software is distributed in the hope that it will be useful,
115 but WITHOUT ANY WARRANTY; without even the implied warranty of
116 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
117 GNU lesser General Public License for more details.
118 <http://www.gnu.org/licenses/>.
119 */
120 
121 pragma solidity ^0.4.0;
122 
123 contract Math
124 {
125 
126 /* Constants */
127 
128     string constant VERSION = "Math 0.0.1 \n";
129     uint constant NULL = 0;
130     bool constant LT = false;
131     bool constant GT = true;
132     // No type bool <-> int type converstion in solidity :~(
133     uint constant iTRUE = 1;
134     uint constant iFALSE = 0;
135     uint constant iPOS = 1;
136     uint constant iZERO = 0;
137     uint constant iNEG = uint(-1);
138 
139 
140 /* Modifiers */
141 
142 /* Functions */
143     function version() public constant returns (string)
144     {
145         return VERSION;
146     }
147 
148     function assert(bool assertion) internal constant
149     {
150       if (!assertion) throw;
151     }
152     
153     // @dev Parametric comparitor for > or <
154     // !_sym returns a < b
155     // _sym  returns a > b
156     function cmp (uint a, uint b, bool _sym) internal constant returns (bool)
157     {
158         return (a!=b) && ((a < b) != _sym);
159     }
160 
161     /// @dev Parametric comparitor for >= or <=
162     /// !_sym returns a <= b
163     /// _sym  returns a >= b
164     function cmpEq (uint a, uint b, bool _sym) internal constant returns (bool)
165     {
166         return (a==b) || ((a < b) != _sym);
167     }
168     
169     /// Trichotomous comparitor
170     /// a < b returns -1
171     /// a == b returns 0
172     /// a > b returns 1
173 /*    function triCmp(uint a, uint b) internal constant returns (bool)
174     {
175         uint c = a - b;
176         return c & c & (0 - 1);
177     }
178     
179     function nSign(uint a) internal returns (uint)
180     {
181         return a & 2^255;
182     }
183     
184     function neg(uint a) internal returns (uint) {
185         return 0 - a;
186     }
187 */    
188     function safeMul(uint a, uint b) internal constant returns (uint)
189     {
190       uint c = a * b;
191       assert(a == 0 || c / a == b);
192       return c;
193     }
194 
195     function safeSub(uint a, uint b) internal constant returns (uint)
196     {
197       assert(b <= a);
198       return a - b;
199     }
200 
201     function safeAdd(uint a, uint b) internal constant returns (uint)
202     {
203       uint c = a + b;
204       assert(c>=a && c>=b);
205       return c;
206     }
207 }
208 
209 /* End of Math */
210 
211 
212 /*
213 file:   ERC20.sol
214 ver:    0.2.3
215 updated:18-Nov-2016
216 author: Darryl Morris
217 email:  o0ragman0o AT gmail.com
218 
219 An ERC20 compliant token.
220 
221 This software is distributed in the hope that it will be useful,
222 but WITHOUT ANY WARRANTY; without even the implied warranty of
223 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
224 GNU lesser General Public License for more details.
225 <http://www.gnu.org/licenses/>.
226 */
227 
228 //pragma solidity ^0.4.0;
229 
230 //import "Math.sol";
231 //import "Base.sol";
232 
233 // ERC20 Standard Token Interface with safe maths and reentry protection
234 contract ERC20Interface
235 {
236 /* Structs */
237 
238 /* Constants */
239     string constant VERSION = "ERC20 0.2.3-o0ragman0o\nMath 0.0.1\nBase 0.1.1\n";
240 
241 /* State Valiables */
242     uint public totalSupply;
243     uint8 public decimalPlaces;
244     string public name;
245     string public symbol;
246     
247     // Token ownership mapping
248     // mapping (address => uint) public balanceOf;
249     mapping (address => uint) balance;
250     
251     // Transfer allowances mapping
252     mapping (address => mapping (address => uint)) public allowance;
253 
254 /* Events */
255     // Triggered when tokens are transferred.
256     event Transfer(
257         address indexed _from,
258         address indexed _to,
259         uint256 _value);
260 
261     // Triggered whenever approve(address _spender, uint256 _value) is called.
262     event Approval(
263         address indexed _owner,
264         address indexed _spender,
265         uint256 _value);
266 
267 /* Modifiers */
268 
269 /* Function Abstracts */
270 
271     /* State variable Accessor Functions (for reference - leave commented) */
272 
273     // Returns the allowable transfer of tokens by a proxy
274     // function allowance (address tokenHolders, address proxy, uint allowance) public constant returns (uint);
275 
276     // Get the total token supply
277     // function totalSupply() public constant returns (uint);
278 
279     // Returns token symbol
280     // function symbol() public constant returns(string);
281 
282     // Returns token symbol
283     // function name() public constant returns(string);
284 
285     // Returns decimal places designated for unit of token.
286     // function decimalPlaces() public returns(uint);
287 
288     // Send _value amount of tokens to address _to
289     // function transfer(address _to, uint256 _value) public returns (bool success);
290 
291     // Send _value amount of tokens from address _from to address _to
292     // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
293 
294     // Allow _spender to withdraw from your account, multiple times, up to the
295     // _value amount.
296     // function approve(address _spender, uint256 _value) public returns (bool success);
297 }
298 
299 contract ERC20Token is Base, Math, ERC20Interface
300 {
301 
302 /* Events */
303 
304 /* Structs */
305 
306 /* Constants */
307 
308 /* State Valiables */
309 
310 /* Modifiers */
311 
312     modifier isAvailable(uint _amount) {
313         if (_amount > balance[msg.sender]) throw;
314         _;
315     }
316 
317     modifier isAllowed(address _from, uint _amount) {
318         if (_amount > allowance[_from][msg.sender] ||
319            _amount > balance[_from]) throw;
320         _;        
321     }
322 
323 /* Funtions Public */
324 
325     function ERC20Token(
326         uint _supply,
327         uint8 _decimalPlaces,
328         string _symbol,
329         string _name)
330     {
331         totalSupply = _supply;
332         decimalPlaces = _decimalPlaces;
333         symbol = _symbol;
334         name = _name;
335         balance[msg.sender] = totalSupply;
336     }
337     
338     function version() public constant returns(string) {
339         return VERSION;
340     }
341     
342     function balanceOf(address _addr)
343         public
344         constant
345         returns (uint)
346     {
347         return balance[_addr];
348     }
349 
350     // Send _value amount of tokens to address _to
351     function transfer(address _to, uint256 _value)
352         external
353         canEnter
354         isAvailable(_value)
355         returns (bool)
356     {
357         balance[msg.sender] = safeSub(balance[msg.sender], _value);
358         balance[_to] = safeAdd(balance[_to], _value);
359         Transfer(msg.sender, _to, _value);
360         return true;
361     }
362 
363     // Send _value amount of tokens from address _from to address _to
364     function transferFrom(address _from, address _to, uint256 _value)
365         external
366         canEnter
367         isAllowed(_from, _value)
368         returns (bool)
369     {
370         balance[_from] = safeSub(balance[_from], _value);
371         balance[_to] = safeAdd(balance[_to], _value);
372         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
373         Transfer(msg.sender, _to, _value);
374         return true;
375     }
376 
377     // Allow _spender to withdraw from your account, multiple times, up to the
378     // _value amount. If this function is called again it overwrites the current
379     // allowance with _value.
380     function approve(address _spender, uint256 _value)
381         external
382         canEnter
383         returns (bool success)
384     {
385         if (balance[msg.sender] == 0) throw;
386         allowance[msg.sender][_spender] = _value;
387         Approval(msg.sender, _spender, _value);
388         return true;
389     }
390 }
391 
392 /* End of ERC20 */
393 
394 
395 /*
396 file:   LibCLL.sol
397 ver:    0.3.1
398 updated:21-Sep-2016
399 author: Darryl Morris
400 email:  o0ragman0o AT gmail.com
401 
402 A Solidity library for implementing a data indexing regime using
403 a circular linked list.
404 
405 This library provisions lookup, navigation and key/index storage
406 functionality which can be used in conjunction with an array or mapping.
407 
408 NOTICE: This library uses internal functions only and so cannot be compiled
409 and deployed independently from its calling contract.
410 
411 This library is distributed in the hope that it will be useful,
412 but WITHOUT ANY WARRANTY; without even the implied warranty of
413 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
414 GNU lesser General Public License for more details.
415 <http://www.gnu.org/licenses/>.
416 */
417 
418 //pragma solidity ^0.4.0;
419 
420 // LibCLL using `uint` keys
421 library LibCLLu {
422 
423     string constant VERSION = "LibCLLu 0.3.1";
424     uint constant NULL = 0;
425     uint constant HEAD = NULL;
426     bool constant PREV = false;
427     bool constant NEXT = true;
428     
429     struct CLL{
430         mapping (uint => mapping (bool => uint)) cll;
431     }
432 
433     // n: node id  d: direction  r: return node id
434 
435     function version() internal constant returns (string) {
436         return VERSION;
437     }
438 
439     // Return existential state of a list.
440     function exists(CLL storage self)
441         internal
442         constant returns (bool)
443     {
444         if (self.cll[HEAD][PREV] != HEAD || self.cll[HEAD][NEXT] != HEAD)
445             return true;
446     }
447     
448     // Returns the number of elements in the list
449     function sizeOf(CLL storage self) internal constant returns (uint r) {
450         uint i = step(self, HEAD, NEXT);
451         while (i != HEAD) {
452             i = step(self, i, NEXT);
453             r++;
454         }
455         return;
456     }
457 
458     // Returns the links of a node as and array
459     function getNode(CLL storage self, uint n)
460         internal  constant returns (uint[2])
461     {
462         return [self.cll[n][PREV], self.cll[n][NEXT]];
463     }
464 
465     // Returns the link of a node `n` in direction `d`.
466     function step(CLL storage self, uint n, bool d)
467         internal  constant returns (uint)
468     {
469         return self.cll[n][d];
470     }
471 
472     // Can be used before `insert` to build an ordered list
473     // `a` an existing node to search from, e.g. HEAD.
474     // `b` value to seek
475     // `r` first node beyond `b` in direction `d`
476     function seek(CLL storage self, uint a, uint b, bool d)
477         internal  constant returns (uint r)
478     {
479         r = step(self, a, d);
480         while  ((b!=r) && ((b < r) != d)) r = self.cll[r][d];
481         return;
482     }
483 
484     // Creates a bidirectional link between two nodes on direction `d`
485     function stitch(CLL storage self, uint a, uint b, bool d) internal  {
486         self.cll[b][!d] = a;
487         self.cll[a][d] = b;
488     }
489 
490     // Insert node `b` beside and existing node `a` in direction `d`.
491     function insert (CLL storage self, uint a, uint b, bool d) internal  {
492         uint c = self.cll[a][d];
493         stitch (self, a, b, d);
494         stitch (self, b, c, d);
495     }
496     
497     function remove(CLL storage self, uint n) internal returns (uint) {
498         if (n == NULL) return;
499         stitch(self, self.cll[n][PREV], self.cll[n][NEXT], NEXT);
500         delete self.cll[n][PREV];
501         delete self.cll[n][NEXT];
502         return n;
503     }
504 
505     function push(CLL storage self, uint n, bool d) internal  {
506         insert(self, HEAD, n, d);
507     }
508     
509     function pop(CLL storage self, bool d) internal returns (uint) {
510         return remove(self, step(self, HEAD, d));
511     }
512 }
513 
514 // LibCLL using `int` keys
515 library LibCLLi {
516 
517     string constant VERSION = "LibCLLi 0.3.1";
518     int constant NULL = 0;
519     int constant HEAD = NULL;
520     bool constant PREV = false;
521     bool constant NEXT = true;
522     
523     struct CLL{
524         mapping (int => mapping (bool => int)) cll;
525     }
526 
527     // n: node id  d: direction  r: return node id
528 
529     function version() internal constant returns (string) {
530         return VERSION;
531     }
532 
533     // Return existential state of a node. n == HEAD returns list existence.
534     function exists(CLL storage self, int n) internal constant returns (bool) {
535         if (self.cll[HEAD][PREV] != HEAD || self.cll[HEAD][NEXT] != HEAD)
536             return true;
537     }
538     // Returns the number of elements in the list
539     function sizeOf(CLL storage self) internal constant returns (uint r) {
540         int i = step(self, HEAD, NEXT);
541         while (i != HEAD) {
542             i = step(self, i, NEXT);
543             r++;
544         }
545         return;
546     }
547 
548     // Returns the links of a node as and array
549     function getNode(CLL storage self, int n)
550         internal  constant returns (int[2])
551     {
552         return [self.cll[n][PREV], self.cll[n][NEXT]];
553     }
554 
555     // Returns the link of a node `n` in direction `d`.
556     function step(CLL storage self, int n, bool d)
557         internal  constant returns (int)
558     {
559         return self.cll[n][d];
560     }
561 
562     // Can be used before `insert` to build an ordered list
563     // `a` an existing node to search from, e.g. HEAD.
564     // `b` value to seek
565     // `r` first node beyond `b` in direction `d`
566     function seek(CLL storage self, int a, int b, bool d)
567         internal  constant returns (int r)
568     {
569         r = step(self, a, d);
570         while  ((b!=r) && ((b < r) != d)) r = self.cll[r][d];
571         return;
572     }
573 
574     // Creates a bidirectional link between two nodes on direction `d`
575     function stitch(CLL storage self, int a, int b, bool d) internal  {
576         self.cll[b][!d] = a;
577         self.cll[a][d] = b;
578     }
579 
580     // Insert node `b` beside existing node `a` in direction `d`.
581     function insert (CLL storage self, int a, int b, bool d) internal  {
582         int c = self.cll[a][d];
583         stitch (self, a, b, d);
584         stitch (self, b, c, d);
585     }
586     
587     function remove(CLL storage self, int n) internal returns (int) {
588         if (n == NULL) return;
589         stitch(self, self.cll[n][PREV], self.cll[n][NEXT], NEXT);
590         delete self.cll[n][PREV];
591         delete self.cll[n][NEXT];
592         return n;
593     }
594 
595     function push(CLL storage self, int n, bool d) internal  {
596         insert(self, HEAD, n, d);
597     }
598     
599     function pop(CLL storage self, bool d) internal returns (int) {
600         return remove(self, step(self, HEAD, d));
601     }
602 }
603 
604 
605 /* End of LibCLLi */
606 
607 /*
608 file:   ITT.sol
609 ver:    0.3.6
610 updated:18-Nov-2016
611 author: Darryl Morris (o0ragman0o)
612 email:  o0ragman0o AT gmail.com
613 
614 An ERC20 compliant token with currency
615 exchange functionality here called an 'Intrinsically Tradable
616 Token' (ITT).
617 
618 This software is distributed in the hope that it will be useful,
619 but WITHOUT ANY WARRANTY; without even the implied warranty of
620 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
621 GNU lesser General Public License for more details.
622 <http://www.gnu.org/licenses/>.
623 */
624 
625 //pragma solidity ^0.4.0;
626 
627 //import "Base.sol";
628 //import "Math.sol";
629 //import "ERC20.sol";
630 //import "LibCLL.sol";
631 
632 contract ITTInterface
633 {
634 
635     using LibCLLu for LibCLLu.CLL;
636 
637 /* Constants */
638 
639     string constant VERSION = "ITT 0.3.6\nERC20 0.2.3-o0ragman0o\nMath 0.0.1\nBase 0.1.1\n";
640     uint constant HEAD = 0;
641     uint constant MINNUM = uint(1);
642     // use only 128 bits of uint to prevent mul overflows.
643     uint constant MAXNUM = 2**128;
644     uint constant MINPRICE = uint(1);
645     uint constant NEG = uint(-1); //2**256 - 1
646     bool constant PREV = false;
647     bool constant NEXT = true;
648     bool constant BID = false;
649     bool constant ASK = true;
650 
651     // minimum gas required to prevent out of gas on 'take' loop
652     uint constant MINGAS = 100000;
653 
654     // For staging and commiting trade details.  This saves unneccessary state
655     // change gas usage during multi order takes but does increase logic
656     // complexity when encountering 'trade with self' orders
657     struct TradeMessage {
658         bool make;
659         bool side;
660         uint price;
661         uint tradeAmount;
662         uint balance;
663         uint etherBalance;
664     }
665 
666 /* State Valiables */
667 
668     // To allow for trade halting by owner.
669     bool public trading;
670 
671     // Mapping for ether ownership of accumulated deposits, sales and refunds.
672     mapping (address => uint) etherBalance;
673 
674     // Orders are stored in circular linked list FIFO's which are mappings with
675     // price as key and value as trader address.  A trader can have only one
676     // order open at each price. Reordering at that price will cancel the first
677     // order and push the new one onto the back of the queue.
678     mapping (uint => LibCLLu.CLL) orderFIFOs;
679     
680     // Order amounts are stored in a seperate lookup. The keys of this mapping
681     // are `sha3` hashes of the price and trader address.
682     // This mapping prevents more than one order at a particular price.
683     mapping (bytes32 => uint) amounts;
684 
685     // The pricebook is a linked list holding keys to lookup the price FIFO's
686     LibCLLu.CLL priceBook = orderFIFOs[0];
687 
688 
689 /* Events */
690 
691     // Triggered on a make sell order
692     event Ask (uint indexed price, uint amount, address indexed trader);
693 
694     // Triggered on a make buy order
695     event Bid (uint indexed price, uint amount, address indexed trader);
696 
697     // Triggered on a filled order
698     event Sale (uint indexed price, uint amount, address indexed buyer, address indexed seller);
699 
700     // Triggered when trading is started or halted
701     event Trading(bool trading);
702 
703 /* Functions Public constant */
704 
705     /// @notice Returns best bid or ask price. 
706     function spread(bool _side) public constant returns(uint);
707     
708     /// @notice Returns the order amount for trader `_trader` at '_price'
709     /// @param _trader Address of trader
710     /// @param _price Price of order
711     function getAmount(uint _price, address _trader) 
712         public constant returns(uint);
713 
714     /// @notice Returns the collective order volume at a `_price`.
715     /// @param _price FIFO for price.
716     function getPriceVolume(uint _price) public constant returns (uint);
717 
718     /// @notice Returns an array of all prices and their volumes.
719     /// @dev [even] indecies are the price. [odd] are the volume. [0] is the
720     /// index of the spread.
721     function getBook() public constant returns (uint[]);
722 
723 /* Functions Public non-constant*/
724 
725     /// @notice Will buy `_amount` tokens at or below `_price` each.
726     /// @param _bidPrice Highest price to bid.
727     /// @param _amount The requested amount of tokens to buy.
728     /// @param _make Value of true will make order if not filled.
729     function buy (uint _bidPrice, uint _amount, bool _make)
730         payable returns (bool);
731 
732     /// @notice Will sell `_amount` tokens at or above `_price` each.
733     /// @param _askPrice Lowest price to ask.
734     /// @param _amount The requested amount of tokens to buy.
735     /// @param _make A value of true will make an order if not market filled.
736     function sell (uint _askPrice, uint _amount, bool _make)
737         external returns (bool);
738 
739     /// @notice Will withdraw `_ether` to your account.
740     /// @param _ether The amount to withdraw
741     function withdraw(uint _ether)
742         external returns (bool success_);
743 
744     /// @notice Cancel order at `_price`
745     /// @param _price The price at which the order was placed.
746     function cancel(uint _price) 
747         external returns (bool);
748 
749     /// @notice Will set trading state to `_trading`
750     /// @param _trading State to set trading to.
751     function setTrading(bool _trading) 
752         external returns (bool);
753 }
754 
755 
756 /* Intrinsically Tradable Token code */ 
757 
758 contract ITT is ERC20Token, ITTInterface
759 {
760 
761 /* Structs */
762 
763 /* Modifiers */
764 
765     /// @dev Passes if token is currently trading
766     modifier isTrading() {
767         if (!trading) throw;
768         _;
769     }
770 
771     /// @dev Validate buy parameters
772     modifier isValidBuy(uint _bidPrice, uint _amount) {
773         if ((etherBalance[msg.sender] + msg.value) < (_amount * _bidPrice) ||
774             _amount == 0 || _amount > totalSupply ||
775             _bidPrice <= MINPRICE || _bidPrice >= MAXNUM) throw; // has insufficient ether.
776         _;
777     }
778 
779     /// @dev Validates sell parameters. Price must be larger than 1.
780     modifier isValidSell(uint _askPrice, uint _amount) {
781         if (_amount > balance[msg.sender] || _amount == 0 ||
782             _askPrice < MINPRICE || _askPrice > MAXNUM) throw;
783         _;
784     }
785     
786     /// @dev Validates ether balance
787     modifier hasEther(address _member, uint _ether) {
788         if (etherBalance[_member] < _ether) throw;
789         _;
790     }
791 
792     /// @dev Validates token balance
793     modifier hasBalance(address _member, uint _amount) {
794         if (balance[_member] < _amount) throw;
795         _;
796     }
797 
798 /* Functions */
799 
800     function ITT(
801         uint _totalSupply,
802         uint8 _decimalPlaces,
803         string _symbol,
804         string _name
805         )
806             ERC20Token(
807                 _totalSupply,
808                 _decimalPlaces,
809                 _symbol,
810                 _name
811                 )
812     {
813         // setup pricebook and maximum spread.
814         priceBook.cll[HEAD][PREV] = MINPRICE;
815         priceBook.cll[MINPRICE][PREV] = MAXNUM;
816         priceBook.cll[HEAD][NEXT] = MAXNUM;
817         priceBook.cll[MAXNUM][NEXT] = MINPRICE;
818         trading = true;
819         balance[owner] = totalSupply;
820     }
821 
822 /* Functions Getters */
823 
824     function version() public constant returns(string) {
825         return VERSION;
826     }
827 
828     function etherBalanceOf(address _addr) public constant returns (uint) {
829         return etherBalance[_addr];
830     }
831 
832     function spread(bool _side) public constant returns(uint) {
833         return priceBook.step(HEAD, _side);
834     }
835 
836     function getAmount(uint _price, address _trader) 
837         public constant returns(uint) {
838         return amounts[sha3(_price, _trader)];
839     }
840 
841     function sizeOf(uint l) constant returns (uint s) {
842         if(l == 0) return priceBook.sizeOf();
843         return orderFIFOs[l].sizeOf();
844     }
845     
846     function getPriceVolume(uint _price) public constant returns (uint v_)
847     {
848         uint n = orderFIFOs[_price].step(HEAD,NEXT);
849         while (n != HEAD) { 
850             v_ += amounts[sha3(_price, address(n))];
851             n = orderFIFOs[_price].step(n, NEXT);
852         }
853         return;
854     }
855 
856     function getBook() public constant returns (uint[])
857     {
858         uint i; 
859         uint p = priceBook.step(MINNUM, NEXT);
860         uint[] memory volumes = new uint[](priceBook.sizeOf() * 2 - 2);
861         while (p < MAXNUM) {
862             volumes[i++] = p;
863             volumes[i++] = getPriceVolume(p);
864             p = priceBook.step(p, NEXT);
865         }
866         return volumes; 
867     }
868     
869     function numOrdersOf(address _addr) public constant returns (uint)
870     {
871         uint c;
872         uint p = MINNUM;
873         while (p < MAXNUM) {
874             if (amounts[sha3(p, _addr)] > 0) c++;
875             p = priceBook.step(p, NEXT);
876         }
877         return c;
878     }
879     
880     function getOpenOrdersOf(address _addr) public constant returns (uint[])
881     {
882         uint i;
883         uint c;
884         uint p = MINNUM;
885         uint[] memory open = new uint[](numOrdersOf(_addr)*2);
886         p = MINNUM;
887         while (p < MAXNUM) {
888             if (amounts[sha3(p, _addr)] > 0) {
889                 open[i++] = p;
890                 open[i++] = amounts[sha3(p, _addr)];
891             }
892             p = priceBook.step(p, NEXT);
893         }
894         return open;
895     }
896 
897     function getNode(uint _list, uint _node) public constant returns(uint[2])
898     {
899         return [orderFIFOs[_list].cll[_node][PREV], 
900             orderFIFOs[_list].cll[_node][NEXT]];
901     }
902     
903 /* Functions Public */
904 
905 // Here non-constant public functions act as a security layer. They are re-entry
906 // protected so cannot call each other. For this reason, they
907 // are being used for parameter and enterance validation, while internal
908 // functions manage the logic. This also allows for deriving contracts to
909 // overload the public function with customised validations and not have to
910 // worry about rewritting the logic.
911 
912     function buy (uint _bidPrice, uint _amount, bool _make)
913         payable
914         canEnter
915         isTrading
916         isValidBuy(_bidPrice, _amount)
917         returns (bool)
918     {
919         trade(_bidPrice, _amount, BID, _make);
920         return true;
921     }
922 
923     function sell (uint _askPrice, uint _amount, bool _make)
924         external
925         canEnter
926         isTrading
927         isValidSell(_askPrice, _amount)
928         returns (bool)
929     {
930         trade(_askPrice, _amount, ASK, _make);
931         return true;
932     }
933 
934     function withdraw(uint _ether)
935         external
936         canEnter
937         hasEther(msg.sender, _ether)
938         returns (bool success_)
939     {
940         etherBalance[msg.sender] -= _ether;
941         safeSend(msg.sender, _ether);
942         success_ = true;
943     }
944 
945     function cancel(uint _price)
946         external
947         canEnter
948         returns (bool)
949     {
950         TradeMessage memory tmsg;
951         tmsg.price = _price;
952         tmsg.balance = balance[msg.sender];
953         tmsg.etherBalance = etherBalance[msg.sender];
954         cancelIntl(tmsg);
955         balance[msg.sender] = tmsg.balance;
956         etherBalance[msg.sender] = tmsg.etherBalance;
957         return true;
958     }
959     
960     function setTrading(bool _trading)
961         external
962         onlyOwner
963         canEnter
964         returns (bool)
965     {
966         trading = _trading;
967         Trading(true);
968         return true;
969     }
970 
971 /* Functions Internal */
972 
973 // Internal functions handle this contract's logic.
974 
975     function trade (uint _price, uint _amount, bool _side, bool _make) internal {
976         TradeMessage memory tmsg;
977         tmsg.price = _price;
978         tmsg.tradeAmount = _amount;
979         tmsg.side = _side;
980         tmsg.make = _make;
981         
982         // Cache state balances to memory and commit to storage only once after trade.
983         tmsg.balance  = balance[msg.sender];
984         tmsg.etherBalance = etherBalance[msg.sender] + msg.value;
985 
986         take(tmsg);
987         make(tmsg);
988         
989         balance[msg.sender] = tmsg.balance;
990         etherBalance[msg.sender] = tmsg.etherBalance;
991     }
992     
993     function take (TradeMessage tmsg)
994         internal
995     {
996         address maker;
997         bytes32 orderHash;
998         uint takeAmount;
999         uint takeEther;
1000         // use of signed math on unsigned ints is intentional
1001         uint sign = tmsg.side ? uint(1) : uint(-1);
1002         uint bestPrice = spread(!tmsg.side);
1003 
1004         // Loop with available gas to take orders
1005         while (
1006             tmsg.tradeAmount > 0 &&
1007             cmpEq(tmsg.price, bestPrice, !tmsg.side) && 
1008             msg.gas > MINGAS
1009         )
1010         {
1011             maker = address(orderFIFOs[bestPrice].step(HEAD, NEXT));
1012             orderHash = sha3(bestPrice, maker);
1013             if (tmsg.tradeAmount < amounts[orderHash]) {
1014                 // Prepare to take partial order
1015                 amounts[orderHash] = safeSub(amounts[orderHash], tmsg.tradeAmount);
1016                 takeAmount = tmsg.tradeAmount;
1017                 tmsg.tradeAmount = 0;
1018             } else {
1019                 // Prepare to take full order
1020                 takeAmount = amounts[orderHash];
1021                 tmsg.tradeAmount = safeSub(tmsg.tradeAmount, takeAmount);
1022                 closeOrder(bestPrice, maker);
1023             }
1024             takeEther = safeMul(bestPrice, takeAmount);
1025             // signed multiply on uints is intentional and so safeMaths will 
1026             // break here. Valid range for exit balances are 0..2**128 
1027             tmsg.etherBalance += takeEther * sign;
1028             tmsg.balance -= takeAmount * sign;
1029             if (tmsg.side) {
1030                 // Sell to bidder
1031                 if (msg.sender == maker) {
1032                     // bidder is self
1033                     tmsg.balance += takeAmount;
1034                 } else {
1035                     balance[maker] += takeAmount;
1036                 }
1037             } else {
1038                 // Buy from asker;
1039                 if (msg.sender == maker) {
1040                     // asker is self
1041                     tmsg.etherBalance += takeEther;
1042                 } else {                
1043                     etherBalance[maker] += takeEther;
1044                 }
1045             }
1046             // prep for next order
1047             bestPrice = spread(!tmsg.side);
1048             Sale (bestPrice, takeAmount, msg.sender, maker);
1049         }
1050     }
1051 
1052     function make(TradeMessage tmsg)
1053         internal
1054     {
1055         bytes32 orderHash;
1056         if (tmsg.tradeAmount == 0 || !tmsg.make || msg.gas < MINGAS) return;
1057         orderHash = sha3(tmsg.price, msg.sender);
1058         if (amounts[orderHash] != 0) {
1059             // Cancel any pre-existing owned order at this price
1060             cancelIntl(tmsg);
1061         }
1062         if (!orderFIFOs[tmsg.price].exists()) {
1063             // Register price in pricebook
1064             priceBook.insert(
1065                 priceBook.seek(HEAD, tmsg.price, tmsg.side),
1066                 tmsg.price, !tmsg.side);
1067         }
1068 
1069         amounts[orderHash] = tmsg.tradeAmount;
1070         orderFIFOs[tmsg.price].push(uint(msg.sender), PREV); 
1071 
1072         if (tmsg.side) {
1073             tmsg.balance -= tmsg.tradeAmount;
1074             Ask (tmsg.price, tmsg.tradeAmount, msg.sender);
1075         } else {
1076             tmsg.etherBalance -= tmsg.tradeAmount * tmsg.price;
1077             Bid (tmsg.price, tmsg.tradeAmount, msg.sender);
1078         }
1079     }
1080 
1081     function cancelIntl(TradeMessage tmsg) internal {
1082         uint amount = amounts[sha3(tmsg.price, msg.sender)];
1083         if (amount == 0) return;
1084         if (tmsg.price > spread(BID)) tmsg.balance += amount; // was ask
1085         else tmsg.etherBalance += tmsg.price * amount; // was bid
1086         closeOrder(tmsg.price, msg.sender);
1087     }
1088 
1089     function closeOrder(uint _price, address _trader) internal {
1090         orderFIFOs[_price].remove(uint(_trader));
1091         if (!orderFIFOs[_price].exists())  {
1092             priceBook.remove(_price);
1093         }
1094         delete amounts[sha3(_price, _trader)];
1095     }
1096 }