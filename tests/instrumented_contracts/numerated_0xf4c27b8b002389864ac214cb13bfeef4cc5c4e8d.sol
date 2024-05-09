1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     address public owner;
5 
6     function Ownable() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         if (newOwner != address(0)) {
17             owner = newOwner;
18         }
19     }
20 }
21 
22 /**
23  * @title Pausable
24  * @dev Base contract which allows children to implement an emergency stop mechanism.
25  */
26 contract Pausable is Ownable {
27     event Pause();
28     event Unpause();
29 
30     bool public paused = false;
31 
32     /**
33      * @dev Modifier to make a function callable only when the contract is not paused.
34      */
35     modifier whenNotPaused() {
36         require(!paused);
37         _;
38     }
39 
40     /**
41      * @dev Modifier to make a function callable only when the contract is paused.
42      */
43     modifier whenPaused() {
44         require(paused);
45         _;
46     }
47 
48     /**
49      * @dev called by the owner to pause, triggers stopped state
50      */
51     function pause() onlyOwner whenNotPaused public {
52         paused = true;
53         Pause();
54     }
55 
56     /**
57      * @dev called by the owner to unpause, returns to normal state
58      */
59     function unpause() onlyOwner whenPaused public {
60         paused = false;
61         Unpause();
62     }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71     /**
72     * @dev Multiplies two numbers, throws on overflow.
73     */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if (a == 0) {
76             return 0;
77         }
78         uint256 c = a * b;
79         assert(c / a == b);
80         return c;
81     }
82 
83     /**
84     * @dev Integer division of two numbers, truncating the quotient.
85     */
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         // assert(b > 0); // Solidity automatically throws when dividing by 0
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90         return c;
91     }
92 
93     /**
94     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95     */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         assert(b <= a);
98         return a - b;
99     }
100 
101     /**
102     * @dev Adds two numbers, throws on overflow.
103     */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         assert(c >= a);
107         return c;
108     }
109 }
110 
111 contract ERC20 {
112     function totalSupply() public constant returns (uint);
113     function balanceOf(address tokenOwner) public constant returns (uint balance);
114     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
115     function transfer(address to, uint tokens) public returns (bool success);
116     function approve(address spender, uint tokens) public returns (bool success);
117     function transferFrom(address from, address to, uint tokens) public returns (bool success);
118     event Transfer(address indexed from, address indexed to, uint tokens);
119     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
120 
121     string public constant name = "";
122     string public constant symbol = "";
123     uint8 public constant decimals = 0;
124 }
125 
126 // Ethen Decentralized Exchange Contract
127 // https://ethen.io/
128 contract Ethen is Pausable {
129     // Trade & order types
130     uint public constant BUY = 1; // order type BID
131     uint public constant SELL = 0; // order type ASK
132 
133     // Percent multiplier in makeFee & takeFee
134     uint public FEE_MUL = 1000000;
135 
136     // x1000000, 0.5%
137     uint public constant MAX_FEE = 5000;
138 
139     // Time after expiration, until order will still be valid to trade.
140     //
141     // All trades are signed by server so it should not be possible to trade
142     // expired orders. Let's say, signing happens at the last second.
143     // Some time needed for transaction to be mined. If we going to require
144     // here in contract that expiration time should always be less than
145     // a block.timestamp than such trades will not be successful.
146     // Instead we add some reasonable time, after which order still be valid
147     // to trade in contract.
148     uint public expireDelay = 300;
149 
150     uint public constant MAX_EXPIRE_DELAY = 600;
151 
152     // Value of keccak256(
153     //     "address Contract", "string Order", "address Token", "uint Nonce",
154     //     "uint Price", "uint Amount", "uint Expire"
155     // )
156     // See https://github.com/ethereum/EIPs/pull/712
157     bytes32 public constant ETH_SIGN_TYPED_DATA_ARGHASH =
158         0x3da4a05d8449a7bc291302cce8a490cf367b98ec37200076c3f13f1f2308fd74;
159 
160     // All prices are per 1e18 tokens
161     uint public constant PRICE_MUL = 1e18;
162 
163     //
164     // Public State Vars
165     //
166 
167     // That address gets all the fees
168     address public feeCollector;
169 
170     // x1000000
171     uint public makeFee = 0;
172 
173     // x1000000, 2500 == 0.25%
174     uint public takeFee = 2500;
175 
176     // user address to ether balances
177     mapping (address => uint) public balances;
178 
179     // user address to token address to token balance
180     mapping (address => mapping (address => uint)) public tokens;
181 
182     // user => order nonce => amount filled
183     mapping (address => mapping (uint => uint)) public filled;
184 
185     // user => nonce => true
186     mapping (address => mapping (uint => bool)) public trades;
187 
188     // Every trade should be signed by that address
189     address public signer;
190 
191     // Keep track of custom fee coefficients per user
192     // 0 means user will pay no fees, 50 - only 50% of fees
193     struct Coeff {
194         uint8   coeff; // 0-99
195         uint128 expire;
196     }
197     mapping (address => Coeff) public coeffs;
198 
199     // Users can pay to reduce fees
200     // (duration << 8) + coeff => price
201     mapping(uint => uint) public packs;
202 
203     //
204     // Events
205     //
206 
207     event NewMakeFee(uint makeFee);
208     event NewTakeFee(uint takeFee);
209 
210     event NewFeeCoeff(address user, uint8 coeff, uint128 expire, uint price);
211 
212     event DepositEther(address user, uint amount, uint total);
213     event WithdrawEther(address user, uint amount, uint total);
214     event DepositToken(address user, address token, uint amount, uint total);
215     event WithdrawToken(address user, address token, uint amount, uint total);
216 
217     event Cancel(
218         uint8 order,
219         address owner,
220         uint nonce,
221         address token,
222         uint price,
223         uint amount
224     );
225 
226     event Order(
227         address orderOwner,
228         uint orderNonce,
229         uint orderPrice,
230         uint tradeTokens,
231         uint orderFilled,
232         uint orderOwnerFinalTokens,
233         uint orderOwnerFinalEther,
234         uint fees
235     );
236 
237     event Trade(
238         address trader,
239         uint nonce,
240         uint trade,
241         address token,
242         uint traderFinalTokens,
243         uint traderFinalEther
244     );
245 
246     event NotEnoughTokens(
247         address owner, address token, uint shouldHaveAmount, uint actualAmount
248     );
249     event NotEnoughEther(
250         address owner, uint shouldHaveAmount, uint actualAmount
251     );
252 
253     //
254     // Constructor
255     //
256 
257     function Ethen(address _signer) public {
258         feeCollector = msg.sender;
259         signer       = _signer;
260     }
261 
262     //
263     // Admin Methods
264     //
265 
266     function setFeeCollector(address _addr) external onlyOwner {
267         feeCollector = _addr;
268     }
269 
270     function setSigner(address _addr) external onlyOwner {
271         signer = _addr;
272     }
273 
274     function setMakeFee(uint _makeFee) external onlyOwner {
275         require(_makeFee <= MAX_FEE);
276         makeFee = _makeFee;
277         NewMakeFee(makeFee);
278     }
279 
280     function setTakeFee(uint _takeFee) external onlyOwner {
281         require(_takeFee <= MAX_FEE);
282         takeFee = _takeFee;
283         NewTakeFee(takeFee);
284     }
285 
286     function addPack(
287         uint8 _coeff, uint128 _duration, uint _price
288     ) external onlyOwner {
289         require(_coeff < 100);
290         require(_duration > 0);
291         require(_price > 0);
292 
293         uint key = packKey(_coeff, _duration);
294         packs[key] = _price;
295     }
296 
297     function delPack(uint8 _coeff, uint128 _duration) external onlyOwner {
298         uint key = packKey(_coeff, _duration);
299         delete packs[key];
300     }
301 
302     function setExpireDelay(uint _expireDelay) external onlyOwner {
303         require(_expireDelay <= MAX_EXPIRE_DELAY);
304         expireDelay = _expireDelay;
305     }
306 
307     //
308     // User Custom Fees
309     //
310 
311     function getPack(
312         uint8 _coeff, uint128 _duration
313     ) public view returns (uint) {
314         uint key = packKey(_coeff, _duration);
315         return packs[key];
316     }
317 
318     // Buys new fee coefficient for given duration of time
319     function buyPack(
320         uint8 _coeff, uint128 _duration
321     ) external payable {
322         require(now >= coeffs[msg.sender].expire);
323 
324         uint key = packKey(_coeff, _duration);
325         uint price = packs[key];
326 
327         require(price > 0);
328         require(msg.value == price);
329 
330         updateCoeff(msg.sender, _coeff, uint128(now) + _duration, price);
331 
332         balances[feeCollector] = SafeMath.add(
333             balances[feeCollector], msg.value
334         );
335     }
336 
337     // Sets new fee coefficient for user
338     function setCoeff(
339         uint8 _coeff, uint128 _expire, uint8 _v, bytes32 _r, bytes32 _s
340     ) external {
341         bytes32 hash = keccak256(this, msg.sender, _coeff, _expire);
342         require(ecrecover(hash, _v, _r, _s) == signer);
343 
344         require(_coeff < 100);
345         require(uint(_expire) > now);
346         require(uint(_expire) <= now + 35 days);
347 
348         updateCoeff(msg.sender, _coeff, _expire, 0);
349     }
350 
351     //
352     // User Balance Related Methods
353     //
354 
355     function () external payable {
356         balances[msg.sender] = SafeMath.add(balances[msg.sender], msg.value);
357         DepositEther(msg.sender, msg.value, balances[msg.sender]);
358     }
359 
360     function depositEther() external payable {
361         balances[msg.sender] = SafeMath.add(balances[msg.sender], msg.value);
362         DepositEther(msg.sender, msg.value, balances[msg.sender]);
363     }
364 
365     function withdrawEther(uint _amount) external {
366         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _amount);
367         msg.sender.transfer(_amount);
368         WithdrawEther(msg.sender, _amount, balances[msg.sender]);
369     }
370 
371     function depositToken(address _token, uint _amount) external {
372         require(ERC20(_token).transferFrom(msg.sender, this, _amount));
373         tokens[msg.sender][_token] = SafeMath.add(
374             tokens[msg.sender][_token], _amount
375         );
376         DepositToken(msg.sender, _token, _amount, tokens[msg.sender][_token]);
377     }
378 
379     function withdrawToken(address _token, uint _amount) external {
380         tokens[msg.sender][_token] = SafeMath.sub(
381             tokens[msg.sender][_token], _amount
382         );
383         require(ERC20(_token).transfer(msg.sender, _amount));
384         WithdrawToken(msg.sender, _token, _amount, tokens[msg.sender][_token]);
385     }
386 
387     //
388     // User Trade Methods
389     //
390 
391     // Fills order so it cant be executed later
392     function cancel(
393         uint8   _order, // BUY for bid orders or SELL for ask orders
394         address _token,
395         uint    _nonce,
396         uint    _price, // Price per 1e18 (PRICE_MUL) tokens
397         uint    _amount,
398         uint    _expire,
399         uint    _v,
400         bytes32 _r,
401         bytes32 _s
402     ) external {
403         require(_order == BUY || _order == SELL);
404 
405         if (now > _expire + expireDelay) {
406             // already expired
407             return;
408         }
409 
410         getVerifiedHash(
411             msg.sender,
412             _order, _token, _nonce, _price, _amount, _expire,
413             _v, _r, _s
414         );
415 
416         filled[msg.sender][_nonce] = _amount;
417 
418         Cancel(_order, msg.sender, _nonce, _token, _price, _amount);
419     }
420 
421     // Does trade, places order
422     // Argument hell because of "Stack to deep" errors.
423     function trade(
424         // _nums[0] 1=BUY, 0=SELL
425         // _nums[1] trade.nonce
426         // _nums[2] trade.v
427         // _nums[3] trade.expire
428         // _nums[4] order[0].nonce              First order should have
429         // _nums[5] order[0].price              best available price
430         // _nums[6] order[0].amount
431         // _nums[7] order[0].expire
432         // _nums[8] order[0].v
433         // _nums[9] order[0].tradeAmount
434         // ...
435         // _nums[6N-2] order[N-1].nonce         N -> 6N+4
436         // _nums[6N-1] order[N-1].price         N -> 6N+5
437         // _nums[6N]   order[N-1].amount        N -> 6N+6
438         // _nums[6N+1] order[N-1].expire        N -> 6N+7
439         // _nums[6N+2] order[N-1].v             N -> 6N+8
440         // _nums[6N+3] order[N-1].tradeAmount   N -> 6N+9
441         uint[] _nums,
442         // _addrs[0] token
443         // _addrs[1] order[0].owner
444         // ...
445         // _addrs[N] order[N-1].owner           N -> N+1
446         address[] _addrs,
447         // _rss[0] trade.r
448         // _rss[1] trade.s
449         // _rss[2] order[0].r
450         // _rss[3] order[0].s
451         // ...
452         // _rss[2N]   order[N-1].r              N -> 2N+2
453         // _rss[2N+1] order[N-1].s              N -> 2N+3
454         bytes32[] _rss
455     ) public whenNotPaused {
456         // number of orders
457         uint N = _addrs.length - 1;
458 
459         require(_nums.length == 6*N+4);
460         require(_rss.length == 2*N+2);
461 
462         // Type of trade
463         // _nums[0] BUY or SELL
464         require(_nums[0] == BUY || _nums[0] == SELL);
465 
466         // _nums[2] placeOrder.nonce
467         saveNonce(_nums[1]);
468 
469         // _nums[3] trade.expire
470         require(now <= _nums[3]);
471 
472         // Start building hash signed by server
473         // _nums[0] BUY or SELL
474         // _addrs[0] token
475         // _nums[1] nonce
476         // _nums[3] trade.expire
477         bytes32 tradeHash = keccak256(
478             this, msg.sender, uint8(_nums[0]), _addrs[0], _nums[1], _nums[3]
479         );
480 
481         // Hash of an order signed by its owner
482         bytes32 orderHash;
483 
484         for (uint i = 0; i < N; i++) {
485             checkExpiration(i, _nums);
486 
487             orderHash = verifyOrder(i, _nums, _addrs, _rss);
488 
489             // _nums[6N+3] order[N-1].tradeAmount   N -> 6N+9
490             tradeHash = keccak256(tradeHash, orderHash, _nums[6*i+9]);
491 
492             tradeOrder(i, _nums, _addrs);
493         }
494 
495         checkTradeSignature(tradeHash, _nums, _rss);
496 
497         sendTradeEvent(_nums, _addrs);
498     }
499 
500     //
501     // Private
502     //
503 
504     function saveNonce(uint _nonce) private {
505         require(trades[msg.sender][_nonce] == false);
506         trades[msg.sender][_nonce] = true;
507     }
508 
509     // Throws error if order is expired
510     function checkExpiration(
511         uint _i, // order number
512         uint[] _nums
513     ) private view {
514         // _nums[6N+1] order[N-1].expire        N -> 6N+7
515         require(now <= _nums[6*_i+7] + expireDelay);
516     }
517 
518     // Returns hash of order `_i`, signed by its owner
519     function verifyOrder(
520         uint _i, // order number
521         uint[] _nums,
522         address[] _addrs,
523         bytes32[] _rss
524     ) private view returns (bytes32 _orderHash) {
525         // _nums[0] BUY or SELL
526         // User is buying orders, that are selling, and vice versa
527         uint8 order = _nums[0] == BUY ? uint8(SELL) : uint8(BUY);
528 
529         // _addrs[N] order[N-1].owner       N -> N+1
530         // _addrs[0] token
531         address owner = _addrs[_i+1];
532         address token = _addrs[0];
533 
534         // _nums[6N-2] order[N-1].nonce         N -> 6N+4
535         // _nums[6N-1] order[N-1].price         N -> 6N+5
536         // _nums[6N]   order[N-1].amount        N -> 6N+6
537         // _nums[6N+1] order[N-1].expire        N -> 6N+7
538         uint nonce = _nums[6*_i+4];
539         uint price = _nums[6*_i+5];
540         uint amount = _nums[6*_i+6];
541         uint expire = _nums[6*_i+7];
542 
543         // _nums[6N+2] order[N-1].v             N -> 6N+8
544         // _rss[2N]   order[N-1].r              N -> 2N+2
545         // _rss[2N+1] order[N-1].s              N -> 2N+3
546         uint v = _nums[6*_i+8];
547         bytes32 r = _rss[2*_i+2];
548         bytes32 s = _rss[2*_i+3];
549 
550         _orderHash = getVerifiedHash(
551             owner,
552             order, token, nonce, price, amount,
553             expire, v, r, s
554         );
555     }
556 
557     // Returns number of traded tokens
558     function tradeOrder(
559         uint _i, // order number
560         uint[] _nums,
561         address[] _addrs
562     ) private {
563         // _nums[0] BUY or SELL
564         // _addrs[0] token
565         // _addrs[N] order[N-1].owner           N -> N+1
566         // _nums[6N-2] order[N-1].nonce         N -> 6N+4
567         // _nums[6N-1] order[N-1].price         N -> 6N+5
568         // _nums[6N]   order[N-1].amount        N -> 6N+6
569         // _nums[6N+3] order[N-1].tradeAmount   N -> 6N+9
570         executeOrder(
571             _nums[0],
572             _addrs[0],
573             _addrs[_i+1],
574             _nums[6*_i+4],
575             _nums[6*_i+5],
576             _nums[6*_i+6],
577             _nums[6*_i+9]
578         );
579     }
580 
581     function checkTradeSignature(
582         bytes32 _tradeHash,
583         uint[] _nums,
584         bytes32[] _rss
585     ) private view {
586         // _nums[2] trade.v
587         // _rss[0] trade.r
588         // _rss[1] trade.s
589         require(ecrecover(
590             _tradeHash, uint8(_nums[2]), _rss[0], _rss[1]
591         ) == signer);
592     }
593 
594     function sendTradeEvent(
595         uint[] _nums, address[] _addrs
596     ) private {
597         // _nums[1] nonce
598         // _nums[0] BUY or SELL
599         // _addrs[0] token
600         Trade(
601             msg.sender, _nums[1], _nums[0], _addrs[0],
602             tokens[msg.sender][_addrs[0]], balances[msg.sender]
603         );
604     }
605 
606     // Executes no more than _tradeAmount tokens from order
607     function executeOrder(
608         uint    _trade,
609         address _token,
610         address _orderOwner,
611         uint    _orderNonce,
612         uint    _orderPrice,
613         uint    _orderAmount,
614         uint    _tradeAmount
615     ) private {
616         var (tradeTokens, tradeEther) = getTradeParameters(
617             _trade, _token, _orderOwner, _orderNonce, _orderPrice,
618             _orderAmount, _tradeAmount
619         );
620 
621         filled[_orderOwner][_orderNonce] = SafeMath.add(
622             filled[_orderOwner][_orderNonce],
623             tradeTokens
624         );
625 
626         // Sanity check: orders should never overfill
627         require(filled[_orderOwner][_orderNonce] <= _orderAmount);
628 
629         uint makeFees = getFees(tradeEther, makeFee, _orderOwner);
630         uint takeFees = getFees(tradeEther, takeFee, msg.sender);
631 
632         swap(
633             _trade, _token, _orderOwner, tradeTokens, tradeEther,
634             makeFees, takeFees
635         );
636 
637         balances[feeCollector] = SafeMath.add(
638             balances[feeCollector],
639             SafeMath.add(takeFees, makeFees)
640         );
641 
642         sendOrderEvent(
643             _orderOwner, _orderNonce, _orderPrice, tradeTokens,
644             _token, SafeMath.add(takeFees, makeFees)
645         );
646     }
647 
648     function swap(
649         uint _trade,
650         address _token,
651         address _orderOwner,
652         uint _tradeTokens,
653         uint _tradeEther,
654         uint _makeFees,
655         uint _takeFees
656     ) private {
657         if (_trade == BUY) {
658             tokens[msg.sender][_token] = SafeMath.add(
659                 tokens[msg.sender][_token], _tradeTokens
660             );
661             tokens[_orderOwner][_token] = SafeMath.sub(
662                 tokens[_orderOwner][_token], _tradeTokens
663             );
664             balances[msg.sender] = SafeMath.sub(
665                 balances[msg.sender], SafeMath.add(_tradeEther, _takeFees)
666             );
667             balances[_orderOwner] = SafeMath.add(
668                 balances[_orderOwner], SafeMath.sub(_tradeEther, _makeFees)
669             );
670         } else {
671             tokens[msg.sender][_token] = SafeMath.sub(
672                 tokens[msg.sender][_token], _tradeTokens
673             );
674             tokens[_orderOwner][_token] = SafeMath.add(
675                 tokens[_orderOwner][_token], _tradeTokens
676             );
677             balances[msg.sender] = SafeMath.add(
678                 balances[msg.sender], SafeMath.sub(_tradeEther, _takeFees)
679             );
680             balances[_orderOwner] = SafeMath.sub(
681                 balances[_orderOwner], SafeMath.add(_tradeEther, _makeFees)
682             );
683         }
684     }
685 
686     function sendOrderEvent(
687         address _orderOwner,
688         uint _orderNonce,
689         uint _orderPrice,
690         uint _tradeTokens,
691         address _token,
692         uint _fees
693     ) private {
694         Order(
695             _orderOwner,
696             _orderNonce,
697             _orderPrice,
698             _tradeTokens,
699             filled[_orderOwner][_orderNonce],
700             tokens[_orderOwner][_token],
701             balances[_orderOwner],
702             _fees
703         );
704     }
705 
706     // Returns number of tokens that could be traded and its total price
707     function getTradeParameters(
708         uint _trade, address _token, address _orderOwner,
709         uint _orderNonce, uint _orderPrice, uint _orderAmount, uint _tradeAmount
710     ) private returns (uint _tokens, uint _totalPrice) {
711         // remains on order
712         _tokens = SafeMath.sub(
713             _orderAmount, filled[_orderOwner][_orderNonce]
714         );
715 
716         // trade no more than needed
717         if (_tokens > _tradeAmount) {
718             _tokens = _tradeAmount;
719         }
720 
721         if (_trade == BUY) {
722             // ask owner has less tokens than it is on ask
723             if (_tokens > tokens[_orderOwner][_token]) {
724                 NotEnoughTokens(
725                     _orderOwner, _token, _tokens, tokens[_orderOwner][_token]
726                 );
727                 _tokens = tokens[_orderOwner][_token];
728             }
729         } else {
730             // not possible to sell more tokens than sender has
731             if (_tokens > tokens[msg.sender][_token]) {
732                 NotEnoughTokens(
733                     msg.sender, _token, _tokens, tokens[msg.sender][_token]
734                 );
735                 _tokens = tokens[msg.sender][_token];
736             }
737         }
738 
739         uint shouldHave = getPrice(_tokens, _orderPrice);
740 
741         uint spendable;
742         if (_trade == BUY) {
743             // max ether sender can spent
744             spendable = reversePercent(
745                 balances[msg.sender],
746                 applyCoeff(takeFee, msg.sender)
747             );
748         } else {
749             // max ether bid owner can spent
750             spendable = reversePercent(
751                 balances[_orderOwner],
752                 applyCoeff(makeFee, _orderOwner)
753             );
754         }
755 
756         if (shouldHave <= spendable) {
757             // everyone have needed amount of tokens & ether
758             _totalPrice = shouldHave;
759             return;
760         }
761 
762         // less price -> less tokens
763         _tokens = SafeMath.div(
764             SafeMath.mul(spendable, PRICE_MUL), _orderPrice
765         );
766         _totalPrice = getPrice(_tokens, _orderPrice);
767 
768         if (_trade == BUY) {
769             NotEnoughEther(
770                 msg.sender,
771                 addFees(shouldHave, applyCoeff(takeFee, msg.sender)),
772                 _totalPrice
773             );
774         } else {
775             NotEnoughEther(
776                 _orderOwner,
777                 addFees(shouldHave, applyCoeff(makeFee, _orderOwner)),
778                 _totalPrice
779             );
780         }
781     }
782 
783     // Returns price of _tokens
784     // _orderPrice is price per 1e18 tokens
785     function getPrice(
786         uint _tokens, uint _orderPrice
787     ) private pure returns (uint) {
788         return SafeMath.div(
789             SafeMath.mul(_tokens, _orderPrice), PRICE_MUL
790         );
791     }
792 
793     function getFees(
794         uint _eth, uint _fee, address _payer
795     ) private view returns (uint) {
796         // _eth * (_fee / FEE_MUL)
797         return SafeMath.div(
798             SafeMath.mul(_eth, applyCoeff(_fee, _payer)),
799             FEE_MUL
800         );
801     }
802 
803     function applyCoeff(uint _fees, address _user) private view returns (uint) {
804         if (now >= coeffs[_user].expire) {
805             return _fees;
806         }
807         return SafeMath.div(
808             SafeMath.mul(_fees, coeffs[_user].coeff), 100
809         );
810     }
811 
812     function addFees(uint _eth, uint _fee) private view returns (uint) {
813         // _eth * (1 + _fee / FEE_MUL)
814         return SafeMath.div(
815             SafeMath.mul(_eth, SafeMath.add(FEE_MUL, _fee)),
816             FEE_MUL
817         );
818     }
819 
820     function subFees(uint _eth, uint _fee) private view returns (uint) {
821         // _eth * (1 - _fee / FEE_MUL)
822         return SafeMath.div(
823             SafeMath.mul(_eth, SafeMath.sub(FEE_MUL, _fee)),
824             FEE_MUL
825         );
826     }
827 
828     // Returns maximum ether that can be spent if percent _fee will be added
829     function reversePercent(
830         uint _balance, uint _fee
831     ) private view returns (uint) {
832         // _trade + _fees = _balance
833         // _trade * (1 + _fee / FEE_MUL) = _balance
834         // _trade = _balance * FEE_MUL / (FEE_MUL + _fee)
835         return SafeMath.div(
836             SafeMath.mul(_balance, FEE_MUL),
837             SafeMath.add(FEE_MUL, _fee)
838         );
839     }
840 
841     // Gets hash of an order, like it is done in `eth_signTypedData`
842     // See https://github.com/ethereum/EIPs/pull/712
843     function hashOrderTyped(
844         uint8 _order, address _token, uint _nonce, uint _price, uint _amount,
845         uint _expire
846     ) private view returns (bytes32) {
847         require(_order == BUY || _order == SELL);
848         return keccak256(
849             ETH_SIGN_TYPED_DATA_ARGHASH,
850             keccak256(
851                 this,
852                 _order == BUY ? "BUY" : "SELL",
853                 _token,
854                 _nonce,
855                 _price,
856                 _amount,
857                 _expire
858             )
859         );
860     }
861 
862     // Gets hash of an order for `eth_sign`
863     function hashOrder(
864         uint8 _order, address _token, uint _nonce, uint _price, uint _amount,
865         uint _expire
866     ) private view returns (bytes32) {
867         return keccak256(
868             "\x19Ethereum Signed Message:\n32",
869             keccak256(this, _order, _token, _nonce, _price, _amount, _expire)
870         );
871     }
872 
873     // Returns hash of an order
874     // Reverts if signature is incorrect
875     function getVerifiedHash(
876         address _signer,
877         uint8 _order, address _token,
878         uint _nonce, uint _price, uint _amount, uint _expire,
879         uint _v, bytes32 _r, bytes32 _s
880     ) private view returns (bytes32 _hash) {
881         if (_v < 1000) {
882             _hash = hashOrderTyped(
883                 _order, _token, _nonce, _price, _amount, _expire
884             );
885             require(ecrecover(_hash, uint8(_v), _r, _s) == _signer);
886         } else {
887             _hash = hashOrder(
888                 _order, _token, _nonce, _price, _amount, _expire
889             );
890             require(ecrecover(_hash, uint8(_v - 1000), _r, _s) == _signer);
891         }
892     }
893 
894     function packKey(
895         uint8 _coeff, uint128 _duration
896     ) private pure returns (uint) {
897         return (uint(_duration) << 8) + uint(_coeff);
898     }
899 
900     function updateCoeff(
901         address _user, uint8 _coeff, uint128 _expire, uint price
902     ) private {
903         coeffs[_user] = Coeff(_coeff, _expire);
904         NewFeeCoeff(_user, _coeff, _expire, price);
905     }
906 }