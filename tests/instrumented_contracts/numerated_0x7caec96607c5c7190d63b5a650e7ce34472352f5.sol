1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 contract DSMath {
68     function add(uint x, uint y) internal pure returns (uint z) {
69         require((z = x + y) >= x, "ds-math-add-overflow");
70     }
71     function sub(uint x, uint y) internal pure returns (uint z) {
72         require((z = x - y) <= x, "ds-math-sub-underflow");
73     }
74     function mul(uint x, uint y) internal pure returns (uint z) {
75         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
76     }
77 
78     function min(uint x, uint y) internal pure returns (uint z) {
79         return x <= y ? x : y;
80     }
81     function max(uint x, uint y) internal pure returns (uint z) {
82         return x >= y ? x : y;
83     }
84     function imin(int x, int y) internal pure returns (int z) {
85         return x <= y ? x : y;
86     }
87     function imax(int x, int y) internal pure returns (int z) {
88         return x >= y ? x : y;
89     }
90 
91     uint constant WAD = 10 ** 18;
92     uint constant RAY = 10 ** 27;
93 
94     function wmul(uint x, uint y) internal pure returns (uint z) {
95         z = add(mul(x, y), WAD / 2) / WAD;
96     }
97     function rmul(uint x, uint y) internal pure returns (uint z) {
98         z = add(mul(x, y), RAY / 2) / RAY;
99     }
100     function wdiv(uint x, uint y) internal pure returns (uint z) {
101         z = add(mul(x, WAD), y / 2) / y;
102     }
103     function rdiv(uint x, uint y) internal pure returns (uint z) {
104         z = add(mul(x, RAY), y / 2) / y;
105     }
106 
107     // This famous algorithm is called "exponentiation by squaring"
108     // and calculates x^n with x as fixed-point and n as regular unsigned.
109     //
110     // It's O(log n), instead of O(n) for naive repeated multiplication.
111     //
112     // These facts are why it works:
113     //
114     //  If n is even, then x^n = (x^2)^(n/2).
115     //  If n is odd,  then x^n = x * x^(n-1),
116     //   and applying the equation for even x gives
117     //    x^n = x * (x^2)^((n-1) / 2).
118     //
119     //  Also, EVM division is flooring and
120     //    floor[(n-1) / 2] = floor[n / 2].
121     //
122     function rpow(uint x, uint n) internal pure returns (uint z) {
123         z = n % 2 != 0 ? x : RAY;
124 
125         for (n /= 2; n != 0; n /= 2) {
126             x = rmul(x, x);
127 
128             if (n % 2 != 0) {
129                 z = rmul(z, x);
130             }
131         }
132     }
133 }
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  * Altered from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/a466e76d26c394b1faa6e2797aefe34668566392/contracts/token/ERC20/ERC20.sol
139  */
140 interface ERC20 {
141   function totalSupply() public view returns (uint256);
142 
143   function balanceOf(address _who) public view returns (uint256);
144 
145   function allowance(address _owner, address _spender)
146     public view returns (uint256);
147 
148   function transfer(address _to, uint256 _value) public returns (bool);
149 
150   function approve(address _spender, uint256 _value) public returns (bool);
151 
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
153 
154   event Transfer(
155     address indexed from,
156     address indexed to,
157     uint256 value
158   );
159 
160   event Approval(
161     address indexed owner,
162     address indexed spender,
163     uint256 value
164   );
165 }
166 
167 /// @dev Just adds extra functions that we use elsewhere
168 contract ERC20WithFields is ERC20 {
169     string public symbol;
170     string public name;
171     uint8 public decimals;
172 }
173 
174 
175 /**
176  * @title Standard ERC20 token
177  *
178  * @dev Implementation of the basic standard token.
179  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
180  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
181  * Rearranged from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/a466e76d26c394b1faa6e2797aefe34668566392/contracts/token/ERC20/StandardToken.sol
182  */
183 contract StandardToken is ERC20 {
184     using SafeMath for uint256;
185 
186     mapping (address => uint256) balances;
187 
188     mapping (address => mapping (address => uint256)) allowed;
189 
190     uint256 totalSupply_;
191 
192     /**
193      * @dev Total number of tokens in existence
194      */
195     function totalSupply() public view returns (uint256) {
196         return totalSupply_;
197     }
198 
199     /**
200      * @dev Gets the balance of the specified address.
201      * @param _owner The address to query the the balance of.
202      * @return An uint256 representing the amount owned by the passed address.
203      */
204     function balanceOf(address _owner) public view returns (uint256) {
205         return balances[_owner];
206     }
207 
208     /**
209      * @dev Function to check the amount of tokens that an owner allowed to a spender.
210      * @param _owner address The address which owns the funds.
211      * @param _spender address The address which will spend the funds.
212      * @return A uint256 specifying the amount of tokens still available for the spender.
213      */
214     function allowance(
215         address _owner,
216         address _spender
217     )
218         public
219         view
220         returns (uint256)
221     {
222         return allowed[_owner][_spender];
223     }
224 
225     /**
226     * @dev Transfer token for a specified address
227     * @param _to The address to transfer to.
228     * @param _value The amount to be transferred.
229     */
230     function transfer(address _to, uint256 _value) public returns (bool) {
231         require(_value <= balances[msg.sender]);
232         require(_to != address(0));
233 
234         balances[msg.sender] = balances[msg.sender].sub(_value);
235         balances[_to] = balances[_to].add(_value);
236         emit Transfer(msg.sender, _to, _value);
237         return true;
238     }
239 
240     /**
241     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
242     * Beware that changing an allowance with this method brings the risk that someone may use both the old
243     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
244     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
245     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246     * @param _spender The address which will spend the funds.
247         * @param _value The amount of tokens to be spent.
248         */
249     function approve(address _spender, uint256 _value) public returns (bool) {
250         allowed[msg.sender][_spender] = _value;
251         emit Approval(msg.sender, _spender, _value);
252         return true;
253     }
254 
255     /**
256     * @dev Transfer tokens from one address to another
257     * @param _from address The address which you want to send tokens from
258     * @param _to address The address which you want to transfer to
259     * @param _value uint256 the amount of tokens to be transferred
260     */
261     function transferFrom(
262         address _from,
263         address _to,
264         uint256 _value
265     )
266         public
267         returns (bool)
268     {
269         require(_value <= balances[_from]);
270         require(_value <= allowed[_from][msg.sender]);
271         require(_to != address(0));
272 
273         balances[_from] = balances[_from].sub(_value);
274         balances[_to] = balances[_to].add(_value);
275         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
276         emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
277         emit Transfer(_from, _to, _value);
278         return true;
279     }
280 
281     /**
282     * @dev Increase the amount of tokens that an owner allowed to a spender.
283     * approve should be called when allowed[_spender] == 0. To increment
284     * allowed value is better to use this function to avoid 2 calls (and wait until
285     * the first transaction is mined)
286     * From MonolithDAO Token.sol
287     * @param _spender The address which will spend the funds.
288     * @param _addedValue The amount of tokens to increase the allowance by.
289     */
290     function increaseApproval(
291         address _spender,
292         uint256 _addedValue
293     )
294         public
295         returns (bool)
296     {
297         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
298         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299         return true;
300     }
301 
302     /**
303      * @dev Decrease the amount of tokens that an owner allowed to a spender.
304      * approve should be called when allowed[_spender] == 0. To decrement
305      * allowed value is better to use this function to avoid 2 calls (and wait until
306      * the first transaction is mined)
307      * From MonolithDAO Token.sol
308      * @param _spender The address which will spend the funds.
309      * @param _subtractedValue The amount of tokens to decrease the allowance by.
310      */
311     function decreaseApproval(
312         address _spender,
313         uint256 _subtractedValue
314     )
315         public
316         returns (bool)
317     {
318         uint256 oldValue = allowed[msg.sender][_spender];
319         if (_subtractedValue >= oldValue) {
320             allowed[msg.sender][_spender] = 0;
321         } else {
322             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
323         }
324         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
325         return true;
326     }
327 
328     /**
329     * @dev Internal function that mints an amount of the token and assigns it to
330     * an account. This encapsulates the modification of balances such that the
331     * proper events are emitted.
332     * @param _account The account that will receive the created tokens.
333     * @param _amount The amount that will be created.
334      */
335     function _mint(address _account, uint256 _amount) internal {
336         require(_account != 0);
337         totalSupply_ = totalSupply_.add(_amount);
338         balances[_account] = balances[_account].add(_amount);
339         emit Transfer(address(0), _account, _amount);
340     }
341 
342     /**
343      * @dev Internal function that burns an amount of the token of a given
344      * account.
345      * @param _account The account whose tokens will be burnt.
346      * @param _amount The amount that will be burnt.
347      */
348     function _burn(address _account, uint256 _amount) internal {
349         require(_account != 0);
350         require(_amount <= balances[_account]);
351 
352         totalSupply_ = totalSupply_.sub(_amount);
353         balances[_account] = balances[_account].sub(_amount);
354         emit Transfer(_account, address(0), _amount);
355     }
356 
357     /**
358      * @dev Internal function that burns an amount of the token of a given
359      * account, deducting from the sender's allowance for said account. Uses the
360      * internal _burn function.
361      * @param _account The account whose tokens will be burnt.
362      * @param _amount The amount that will be burnt.
363      */
364     function _burnFrom(address _account, uint256 _amount) internal {
365         require(_amount <= allowed[_account][msg.sender]);
366         allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
367         emit Approval(_account, msg.sender, allowed[_account][msg.sender]);
368         _burn(_account, _amount);
369     }
370 }
371 
372 
373 contract PreminedToken is StandardToken {
374     string public symbol;
375     string public  name;
376     uint8 public decimals;
377 
378     constructor(string _symbol, uint8 _decimals, string _name) public {
379         symbol = _symbol;
380         decimals = _decimals;
381         name = _name;
382         totalSupply_ = 1000000 * 10**uint(decimals);
383         balances[msg.sender] = totalSupply_;
384         emit Transfer(address(0), msg.sender, totalSupply_);
385     }
386 }
387 
388 
389 /// @dev Just a wrapper for premined tokens which can actually be burnt
390 contract BurnableToken is PreminedToken {
391     constructor(string _symbol, uint8 _decimals, string _name)
392         public
393         PreminedToken(_symbol, _decimals, _name)
394     {}
395 
396     function burn(uint _amount) public {
397         _burn(msg.sender, _amount);
398     }
399     
400     function burnFrom(address from, uint256 value) public {
401         _burnFrom(from, value);
402     }
403 }
404 
405 
406 /// @notice Must return a value for an asset
407 interface PriceSourceInterface {
408     event PriceUpdate(address[] token, uint[] price);
409 
410     function getQuoteAsset() external view returns (address);
411     function getLastUpdate() external view returns (uint);
412 
413     /// @notice Returns false if asset not applicable, or price not recent
414     function hasValidPrice(address) public view returns (bool);
415     function hasValidPrices(address[]) public view returns (bool);
416 
417     /// @notice Return the last known price, and when it was issued
418     function getPrice(address _asset) public view returns (uint price, uint timestamp);
419     function getPrices(address[] _assets) public view returns (uint[] prices, uint[] timestamps);
420 
421     /// @notice Get price info, and revert if not valid
422     function getPriceInfo(address _asset) view returns (uint price, uint decimals);
423     function getInvertedPriceInfo(address ofAsset) view returns (uint price, uint decimals);
424 
425     function getReferencePriceInfo(address _base, address _quote) public view returns (uint referencePrice, uint decimal);
426     function getOrderPriceInfo(address sellAsset, address buyAsset, uint sellQuantity, uint buyQuantity) public view returns (uint orderPrice);
427     function existsPriceOnAssetPair(address sellAsset, address buyAsset) public view returns (bool isExistent);
428     function convertQuantity(
429         uint fromAssetQuantity,
430         address fromAsset,
431         address toAsset
432     ) public view returns (uint);
433 }
434 
435 
436 contract DSAuthority {
437     function canCall(
438         address src, address dst, bytes4 sig
439     ) public view returns (bool);
440 }
441 
442 contract DSAuthEvents {
443     event LogSetAuthority (address indexed authority);
444     event LogSetOwner     (address indexed owner);
445 }
446 
447 contract DSAuth is DSAuthEvents {
448     DSAuthority  public  authority;
449     address      public  owner;
450 
451     constructor() public {
452         owner = msg.sender;
453         emit LogSetOwner(msg.sender);
454     }
455 
456     function setOwner(address owner_)
457         public
458         auth
459     {
460         owner = owner_;
461         emit LogSetOwner(owner);
462     }
463 
464     function setAuthority(DSAuthority authority_)
465         public
466         auth
467     {
468         authority = authority_;
469         emit LogSetAuthority(address(authority));
470     }
471 
472     modifier auth {
473         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
474         _;
475     }
476 
477     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
478         if (src == address(this)) {
479             return true;
480         } else if (src == owner) {
481             return true;
482         } else if (authority == DSAuthority(0)) {
483             return false;
484         } else {
485             return authority.canCall(src, address(this), sig);
486         }
487     }
488 }
489 
490 contract DSGuardEvents {
491     event LogPermit(
492         bytes32 indexed src,
493         bytes32 indexed dst,
494         bytes32 indexed sig
495     );
496 
497     event LogForbid(
498         bytes32 indexed src,
499         bytes32 indexed dst,
500         bytes32 indexed sig
501     );
502 }
503 
504 contract DSGuard is DSAuth, DSAuthority, DSGuardEvents {
505     bytes32 constant public ANY = bytes32(uint(-1));
506 
507     mapping (bytes32 => mapping (bytes32 => mapping (bytes32 => bool))) acl;
508 
509     function canCall(
510         address src_, address dst_, bytes4 sig
511     ) public view returns (bool) {
512         bytes32 src = bytes32(bytes20(src_));
513         bytes32 dst = bytes32(bytes20(dst_));
514 
515         return acl[src][dst][sig]
516             || acl[src][dst][ANY]
517             || acl[src][ANY][sig]
518             || acl[src][ANY][ANY]
519             || acl[ANY][dst][sig]
520             || acl[ANY][dst][ANY]
521             || acl[ANY][ANY][sig]
522             || acl[ANY][ANY][ANY];
523     }
524 
525     function permit(bytes32 src, bytes32 dst, bytes32 sig) public auth {
526         acl[src][dst][sig] = true;
527         emit LogPermit(src, dst, sig);
528     }
529 
530     function forbid(bytes32 src, bytes32 dst, bytes32 sig) public auth {
531         acl[src][dst][sig] = false;
532         emit LogForbid(src, dst, sig);
533     }
534 
535     function permit(address src, address dst, bytes32 sig) public {
536         permit(bytes32(bytes20(src)), bytes32(bytes20(dst)), sig);
537     }
538     function forbid(address src, address dst, bytes32 sig) public {
539         forbid(bytes32(bytes20(src)), bytes32(bytes20(dst)), sig);
540     }
541 
542 }
543 
544 contract DSGuardFactory {
545     mapping (address => bool)  public  isGuard;
546 
547     function newGuard() public returns (DSGuard guard) {
548         guard = new DSGuard();
549         guard.setOwner(msg.sender);
550         isGuard[address(guard)] = true;
551     }
552 }
553 
554 /// @notice Has one Hub
555 contract Spoke is DSAuth {
556     Hub public hub;
557     Hub.Routes public routes;
558     bool public initialized;
559 
560     modifier onlyInitialized() {
561         require(initialized, "Component not yet initialized");
562         _;
563     }
564 
565     modifier notShutDown() {
566         require(!hub.isShutDown(), "Hub is shut down");
567         _;
568     }
569 
570     constructor(address _hub) {
571         hub = Hub(_hub);
572         setAuthority(hub);
573         setOwner(hub); // temporary, to allow initialization
574     }
575 
576     function initialize(address[12] _spokes) external auth {
577         require(msg.sender == address(hub));
578         require(!initialized, "Already initialized");
579         routes = Hub.Routes(
580             _spokes[0],
581             _spokes[1],
582             _spokes[2],
583             _spokes[3],
584             _spokes[4],
585             _spokes[5],
586             _spokes[6],
587             _spokes[7],
588             _spokes[8],
589             _spokes[9],
590             _spokes[10],
591             _spokes[11]
592         );
593         initialized = true;
594         setOwner(address(0));
595     }
596 
597     function engine() public view returns (address) { return routes.engine; }
598     function mlnToken() public view returns (address) { return routes.mlnToken; }
599     function priceSource() public view returns (address) { return routes.priceSource; }
600     function version() public view returns (address) { return routes.version; }
601     function registry() public view returns (address) { return routes.registry; }
602 }
603 
604 
605 /// @notice Router for communication between components
606 /// @notice Has one or more Spokes
607 contract Hub is DSGuard {
608 
609     event FundShutDown();
610 
611     struct Routes {
612         address accounting;
613         address feeManager;
614         address participation;
615         address policyManager;
616         address shares;
617         address trading;
618         address vault;
619         address priceSource;
620         address registry;
621         address version;
622         address engine;
623         address mlnToken;
624     }
625 
626     Routes public routes;
627     address public manager;
628     address public creator;
629     string public name;
630     bool public isShutDown;
631     bool public spokesSet;
632     bool public routingSet;
633     bool public permissionsSet;
634     uint public creationTime;
635     mapping (address => bool) public isSpoke;
636 
637     constructor(address _manager, string _name) {
638         creator = msg.sender;
639         manager = _manager;
640         name = _name;
641         creationTime = block.timestamp;
642     }
643 
644     modifier onlyCreator() {
645         require(msg.sender == creator, "Only creator can do this");
646         _;
647     }
648 
649     function shutDownFund() external {
650         require(msg.sender == routes.version);
651         isShutDown = true;
652         emit FundShutDown();
653     }
654 
655     function setSpokes(address[12] _spokes) external onlyCreator {
656         require(!spokesSet, "Spokes already set");
657         for (uint i = 0; i < _spokes.length; i++) {
658             isSpoke[_spokes[i]] = true;
659         }
660         routes.accounting = _spokes[0];
661         routes.feeManager = _spokes[1];
662         routes.participation = _spokes[2];
663         routes.policyManager = _spokes[3];
664         routes.shares = _spokes[4];
665         routes.trading = _spokes[5];
666         routes.vault = _spokes[6];
667         routes.priceSource = _spokes[7];
668         routes.registry = _spokes[8];
669         routes.version = _spokes[9];
670         routes.engine = _spokes[10];
671         routes.mlnToken = _spokes[11];
672         spokesSet = true;
673     }
674 
675     function setRouting() external onlyCreator {
676         require(spokesSet, "Spokes must be set");
677         require(!routingSet, "Routing already set");
678         address[12] memory spokes = [
679             routes.accounting, routes.feeManager, routes.participation,
680             routes.policyManager, routes.shares, routes.trading,
681             routes.vault, routes.priceSource, routes.registry,
682             routes.version, routes.engine, routes.mlnToken
683         ];
684         Spoke(routes.accounting).initialize(spokes);
685         Spoke(routes.feeManager).initialize(spokes);
686         Spoke(routes.participation).initialize(spokes);
687         Spoke(routes.policyManager).initialize(spokes);
688         Spoke(routes.shares).initialize(spokes);
689         Spoke(routes.trading).initialize(spokes);
690         Spoke(routes.vault).initialize(spokes);
691         routingSet = true;
692     }
693 
694     function setPermissions() external onlyCreator {
695         require(spokesSet, "Spokes must be set");
696         require(routingSet, "Routing must be set");
697         require(!permissionsSet, "Permissioning already set");
698         permit(routes.participation, routes.vault, bytes4(keccak256('withdraw(address,uint256)')));
699         permit(routes.trading, routes.vault, bytes4(keccak256('withdraw(address,uint256)')));
700         permit(routes.participation, routes.shares, bytes4(keccak256('createFor(address,uint256)')));
701         permit(routes.participation, routes.shares, bytes4(keccak256('destroyFor(address,uint256)')));
702         permit(routes.feeManager, routes.shares, bytes4(keccak256('createFor(address,uint256)')));
703         permit(routes.participation, routes.accounting, bytes4(keccak256('addAssetToOwnedAssets(address)')));
704         permit(routes.trading, routes.accounting, bytes4(keccak256('addAssetToOwnedAssets(address)')));
705         permit(routes.trading, routes.accounting, bytes4(keccak256('removeFromOwnedAssets(address)')));
706         permit(routes.accounting, routes.feeManager, bytes4(keccak256('rewardAllFees()')));
707         permit(manager, routes.policyManager, bytes4(keccak256('register(bytes4,address)')));
708         permit(manager, routes.policyManager, bytes4(keccak256('batchRegister(bytes4[],address[])')));
709         permit(manager, routes.participation, bytes4(keccak256('enableInvestment(address[])')));
710         permit(manager, routes.participation, bytes4(keccak256('disableInvestment(address[])')));
711         permissionsSet = true;
712     }
713 
714     function vault() external view returns (address) { return routes.vault; }
715     function accounting() external view returns (address) { return routes.accounting; }
716     function priceSource() external view returns (address) { return routes.priceSource; }
717     function participation() external view returns (address) { return routes.participation; }
718     function trading() external view returns (address) { return routes.trading; }
719     function shares() external view returns (address) { return routes.shares; }
720     function registry() external view returns (address) { return routes.registry; }
721     function policyManager() external view returns (address) { return routes.policyManager; }
722 }
723 
724 
725 
726 
727 contract Registry is DSAuth {
728 
729     // EVENTS
730     event AssetUpsert (
731         address indexed asset,
732         string name,
733         string symbol,
734         uint decimals,
735         string url,
736         uint reserveMin,
737         uint[] standards,
738         bytes4[] sigs
739     );
740 
741     event ExchangeAdapterUpsert (
742         address indexed exchange,
743         address indexed adapter,
744         bool takesCustody,
745         bytes4[] sigs
746     );
747 
748     event AssetRemoval (address indexed asset);
749     event EfxWrapperRegistryChange(address indexed registry);
750     event EngineChange(address indexed engine);
751     event ExchangeAdapterRemoval (address indexed exchange);
752     event IncentiveChange(uint incentiveAmount);
753     event MGMChange(address indexed MGM);
754     event MlnTokenChange(address indexed mlnToken);
755     event NativeAssetChange(address indexed nativeAsset);
756     event PriceSourceChange(address indexed priceSource);
757     event VersionRegistration(address indexed version);
758 
759     // TYPES
760     struct Asset {
761         bool exists;
762         string name;
763         string symbol;
764         uint decimals;
765         string url;
766         uint reserveMin;
767         uint[] standards;
768         bytes4[] sigs;
769     }
770 
771     struct Exchange {
772         bool exists;
773         address exchangeAddress;
774         bool takesCustody;
775         bytes4[] sigs;
776     }
777 
778     struct Version {
779         bool exists;
780         bytes32 name;
781     }
782 
783     // CONSTANTS
784     uint public constant MAX_REGISTERED_ENTITIES = 20;
785     uint public constant MAX_FUND_NAME_BYTES = 66;
786 
787     // FIELDS
788     mapping (address => Asset) public assetInformation;
789     address[] public registeredAssets;
790 
791     // Mapping from adapter address to exchange Information (Adapters are unique)
792     mapping (address => Exchange) public exchangeInformation;
793     address[] public registeredExchangeAdapters;
794 
795     mapping (address => Version) public versionInformation;
796     address[] public registeredVersions;
797 
798     mapping (address => bool) public isFeeRegistered;
799 
800     mapping (address => address) public fundsToVersions;
801     mapping (bytes32 => bool) public versionNameExists;
802     mapping (bytes32 => address) public fundNameHashToOwner;
803 
804 
805     uint public incentive = 10 finney;
806     address public priceSource;
807     address public mlnToken;
808     address public nativeAsset;
809     address public engine;
810     address public ethfinexWrapperRegistry;
811     address public MGM;
812 
813     modifier onlyVersion() {
814         require(
815             versionInformation[msg.sender].exists,
816             "Only a Version can do this"
817         );
818         _;
819     }
820 
821     // METHODS
822 
823     constructor(address _postDeployOwner) {
824         setOwner(_postDeployOwner);
825     }
826 
827     // PUBLIC METHODS
828 
829     /// @notice Whether _name has only valid characters
830     function isValidFundName(string _name) public view returns (bool) {
831         bytes memory b = bytes(_name);
832         if (b.length > MAX_FUND_NAME_BYTES) return false;
833         for (uint i; i < b.length; i++){
834             bytes1 char = b[i];
835             if(
836                 !(char >= 0x30 && char <= 0x39) && // 9-0
837                 !(char >= 0x41 && char <= 0x5A) && // A-Z
838                 !(char >= 0x61 && char <= 0x7A) && // a-z
839                 !(char == 0x20 || char == 0x2D) && // space, dash
840                 !(char == 0x2E || char == 0x5F) && // period, underscore
841                 !(char == 0x2A) // *
842             ) {
843                 return false;
844             }
845         }
846         return true;
847     }
848 
849     /// @notice Whether _user can use _name for their fund
850     function canUseFundName(address _user, string _name) public view returns (bool) {
851         bytes32 nameHash = keccak256(_name);
852         return (
853             isValidFundName(_name) &&
854             (
855                 fundNameHashToOwner[nameHash] == address(0) ||
856                 fundNameHashToOwner[nameHash] == _user
857             )
858         );
859     }
860 
861     function reserveFundName(address _owner, string _name)
862         external
863         onlyVersion
864     {
865         require(canUseFundName(_owner, _name), "Fund name cannot be used");
866         fundNameHashToOwner[keccak256(_name)] = _owner;
867     }
868 
869     function registerFund(address _fund, address _owner, string _name)
870         external
871         onlyVersion
872     {
873         require(canUseFundName(_owner, _name), "Fund name cannot be used");
874         fundsToVersions[_fund] = msg.sender;
875     }
876 
877     /// @notice Registers an Asset information entry
878     /// @dev Pre: Only registrar owner should be able to register
879     /// @dev Post: Address _asset is registered
880     /// @param _asset Address of asset to be registered
881     /// @param _name Human-readable name of the Asset
882     /// @param _symbol Human-readable symbol of the Asset
883     /// @param _url Url for extended information of the asset
884     /// @param _standards Integers of EIP standards this asset adheres to
885     /// @param _sigs Function signatures for whitelisted asset functions
886     function registerAsset(
887         address _asset,
888         string _name,
889         string _symbol,
890         string _url,
891         uint _reserveMin,
892         uint[] _standards,
893         bytes4[] _sigs
894     ) external auth {
895         require(registeredAssets.length < MAX_REGISTERED_ENTITIES);
896         require(!assetInformation[_asset].exists);
897         assetInformation[_asset].exists = true;
898         registeredAssets.push(_asset);
899         updateAsset(
900             _asset,
901             _name,
902             _symbol,
903             _url,
904             _reserveMin,
905             _standards,
906             _sigs
907         );
908     }
909 
910     /// @notice Register an exchange information entry (A mapping from exchange adapter -> Exchange information)
911     /// @dev Adapters are unique so are used as the mapping key. There may be different adapters for same exchange (0x / Ethfinex)
912     /// @dev Pre: Only registrar owner should be able to register
913     /// @dev Post: Address _exchange is registered
914     /// @param _exchange Address of the exchange for the adapter
915     /// @param _adapter Address of exchange adapter
916     /// @param _takesCustody Whether this exchange takes custody of tokens before trading
917     /// @param _sigs Function signatures for whitelisted exchange functions
918     function registerExchangeAdapter(
919         address _exchange,
920         address _adapter,
921         bool _takesCustody,
922         bytes4[] _sigs
923     ) external auth {
924         require(!exchangeInformation[_adapter].exists, "Adapter already exists");
925         exchangeInformation[_adapter].exists = true;
926         require(registeredExchangeAdapters.length < MAX_REGISTERED_ENTITIES, "Exchange limit reached");
927         registeredExchangeAdapters.push(_adapter);
928         updateExchangeAdapter(
929             _exchange,
930             _adapter,
931             _takesCustody,
932             _sigs
933         );
934     }
935 
936     /// @notice Versions cannot be removed from registry
937     /// @param _version Address of the version contract
938     /// @param _name Name of the version
939     function registerVersion(
940         address _version,
941         bytes32 _name
942     ) external auth {
943         require(!versionInformation[_version].exists, "Version already exists");
944         require(!versionNameExists[_name], "Version name already exists");
945         versionInformation[_version].exists = true;
946         versionNameExists[_name] = true;
947         versionInformation[_version].name = _name;
948         registeredVersions.push(_version);
949         emit VersionRegistration(_version);
950     }
951 
952     function setIncentive(uint _weiAmount) external auth {
953         incentive = _weiAmount;
954         emit IncentiveChange(_weiAmount);
955     }
956 
957     function setPriceSource(address _priceSource) external auth {
958         priceSource = _priceSource;
959         emit PriceSourceChange(_priceSource);
960     }
961 
962     function setMlnToken(address _mlnToken) external auth {
963         mlnToken = _mlnToken;
964         emit MlnTokenChange(_mlnToken);
965     }
966 
967     function setNativeAsset(address _nativeAsset) external auth {
968         nativeAsset = _nativeAsset;
969         emit NativeAssetChange(_nativeAsset);
970     }
971 
972     function setEngine(address _engine) external auth {
973         engine = _engine;
974         emit EngineChange(_engine);
975     }
976 
977     function setMGM(address _MGM) external auth {
978         MGM = _MGM;
979         emit MGMChange(_MGM);
980     }
981 
982     function setEthfinexWrapperRegistry(address _registry) external auth {
983         ethfinexWrapperRegistry = _registry;
984         emit EfxWrapperRegistryChange(_registry);
985     }
986 
987     /// @notice Updates description information of a registered Asset
988     /// @dev Pre: Owner can change an existing entry
989     /// @dev Post: Changed Name, Symbol, URL and/or IPFSHash
990     /// @param _asset Address of the asset to be updated
991     /// @param _name Human-readable name of the Asset
992     /// @param _symbol Human-readable symbol of the Asset
993     /// @param _url Url for extended information of the asset
994     function updateAsset(
995         address _asset,
996         string _name,
997         string _symbol,
998         string _url,
999         uint _reserveMin,
1000         uint[] _standards,
1001         bytes4[] _sigs
1002     ) public auth {
1003         require(assetInformation[_asset].exists);
1004         Asset asset = assetInformation[_asset];
1005         asset.name = _name;
1006         asset.symbol = _symbol;
1007         asset.decimals = ERC20WithFields(_asset).decimals();
1008         asset.url = _url;
1009         asset.reserveMin = _reserveMin;
1010         asset.standards = _standards;
1011         asset.sigs = _sigs;
1012         emit AssetUpsert(
1013             _asset,
1014             _name,
1015             _symbol,
1016             asset.decimals,
1017             _url,
1018             _reserveMin,
1019             _standards,
1020             _sigs
1021         );
1022     }
1023 
1024     function updateExchangeAdapter(
1025         address _exchange,
1026         address _adapter,
1027         bool _takesCustody,
1028         bytes4[] _sigs
1029     ) public auth {
1030         require(exchangeInformation[_adapter].exists, "Exchange with adapter doesn't exist");
1031         Exchange exchange = exchangeInformation[_adapter];
1032         exchange.exchangeAddress = _exchange;
1033         exchange.takesCustody = _takesCustody;
1034         exchange.sigs = _sigs;
1035         emit ExchangeAdapterUpsert(
1036             _exchange,
1037             _adapter,
1038             _takesCustody,
1039             _sigs
1040         );
1041     }
1042 
1043     /// @notice Deletes an existing entry
1044     /// @dev Owner can delete an existing entry
1045     /// @param _asset address for which specific information is requested
1046     function removeAsset(
1047         address _asset,
1048         uint _assetIndex
1049     ) external auth {
1050         require(assetInformation[_asset].exists);
1051         require(registeredAssets[_assetIndex] == _asset);
1052         delete assetInformation[_asset];
1053         delete registeredAssets[_assetIndex];
1054         for (uint i = _assetIndex; i < registeredAssets.length-1; i++) {
1055             registeredAssets[i] = registeredAssets[i+1];
1056         }
1057         registeredAssets.length--;
1058         emit AssetRemoval(_asset);
1059     }
1060 
1061     /// @notice Deletes an existing entry
1062     /// @dev Owner can delete an existing entry
1063     /// @param _adapter address of the adapter of the exchange that is to be removed
1064     /// @param _adapterIndex index of the exchange in array
1065     function removeExchangeAdapter(
1066         address _adapter,
1067         uint _adapterIndex
1068     ) external auth {
1069         require(exchangeInformation[_adapter].exists, "Exchange with adapter doesn't exist");
1070         require(registeredExchangeAdapters[_adapterIndex] == _adapter, "Incorrect adapter index");
1071         delete exchangeInformation[_adapter];
1072         delete registeredExchangeAdapters[_adapterIndex];
1073         for (uint i = _adapterIndex; i < registeredExchangeAdapters.length-1; i++) {
1074             registeredExchangeAdapters[i] = registeredExchangeAdapters[i+1];
1075         }
1076         registeredExchangeAdapters.length--;
1077         emit ExchangeAdapterRemoval(_adapter);
1078     }
1079 
1080     function registerFees(address[] _fees) external auth {
1081         for (uint i; i < _fees.length; i++) {
1082             isFeeRegistered[_fees[i]] = true;
1083         }
1084     }
1085 
1086     function deregisterFees(address[] _fees) external auth {
1087         for (uint i; i < _fees.length; i++) {
1088             delete isFeeRegistered[_fees[i]];
1089         }
1090     }
1091 
1092     // PUBLIC VIEW METHODS
1093 
1094     // get asset specific information
1095     function getName(address _asset) external view returns (string) {
1096         return assetInformation[_asset].name;
1097     }
1098     function getSymbol(address _asset) external view returns (string) {
1099         return assetInformation[_asset].symbol;
1100     }
1101     function getDecimals(address _asset) external view returns (uint) {
1102         return assetInformation[_asset].decimals;
1103     }
1104     function getReserveMin(address _asset) external view returns (uint) {
1105         return assetInformation[_asset].reserveMin;
1106     }
1107     function assetIsRegistered(address _asset) external view returns (bool) {
1108         return assetInformation[_asset].exists;
1109     }
1110     function getRegisteredAssets() external view returns (address[]) {
1111         return registeredAssets;
1112     }
1113     function assetMethodIsAllowed(address _asset, bytes4 _sig)
1114         external
1115         view
1116         returns (bool)
1117     {
1118         bytes4[] memory signatures = assetInformation[_asset].sigs;
1119         for (uint i = 0; i < signatures.length; i++) {
1120             if (signatures[i] == _sig) {
1121                 return true;
1122             }
1123         }
1124         return false;
1125     }
1126 
1127     // get exchange-specific information
1128     function exchangeAdapterIsRegistered(address _adapter) external view returns (bool) {
1129         return exchangeInformation[_adapter].exists;
1130     }
1131     function getRegisteredExchangeAdapters() external view returns (address[]) {
1132         return registeredExchangeAdapters;
1133     }
1134     function getExchangeInformation(address _adapter)
1135         public
1136         view
1137         returns (address, bool)
1138     {
1139         Exchange exchange = exchangeInformation[_adapter];
1140         return (
1141             exchange.exchangeAddress,
1142             exchange.takesCustody
1143         );
1144     }
1145     function exchangeForAdapter(address _adapter) external view returns (address) {
1146         Exchange exchange = exchangeInformation[_adapter];
1147         return exchange.exchangeAddress;
1148     }
1149     function getAdapterFunctionSignatures(address _adapter)
1150         public
1151         view
1152         returns (bytes4[])
1153     {
1154         return exchangeInformation[_adapter].sigs;
1155     }
1156     function adapterMethodIsAllowed(
1157         address _adapter, bytes4 _sig
1158     )
1159         external
1160         view
1161         returns (bool)
1162     {
1163         bytes4[] memory signatures = exchangeInformation[_adapter].sigs;
1164         for (uint i = 0; i < signatures.length; i++) {
1165             if (signatures[i] == _sig) {
1166                 return true;
1167             }
1168         }
1169         return false;
1170     }
1171 
1172     // get version and fund information
1173     function getRegisteredVersions() external view returns (address[]) {
1174         return registeredVersions;
1175     }
1176 
1177     function isFund(address _who) external view returns (bool) {
1178         if (fundsToVersions[_who] != address(0)) {
1179             return true; // directly from a hub
1180         } else {
1181             address hub = Hub(Spoke(_who).hub());
1182             require(
1183                 Hub(hub).isSpoke(_who),
1184                 "Call from either a spoke or hub"
1185             );
1186             return fundsToVersions[hub] != address(0);
1187         }
1188     }
1189 
1190     function isFundFactory(address _who) external view returns (bool) {
1191         return versionInformation[_who].exists;
1192     }
1193 }
1194 
1195 
1196 /// @notice Liquidity contract and token sink
1197 contract Engine is DSMath {
1198 
1199     event RegistryChange(address registry);
1200     event SetAmguPrice(uint amguPrice);
1201     event AmguPaid(uint amount);
1202     event Thaw(uint amount);
1203     event Burn(uint amount);
1204 
1205     uint public constant MLN_DECIMALS = 18;
1206 
1207     Registry public registry;
1208     uint public amguPrice;
1209     uint public frozenEther;
1210     uint public liquidEther;
1211     uint public lastThaw;
1212     uint public thawingDelay;
1213     uint public totalEtherConsumed;
1214     uint public totalAmguConsumed;
1215     uint public totalMlnBurned;
1216 
1217     constructor(uint _delay, address _registry) {
1218         lastThaw = block.timestamp;
1219         thawingDelay = _delay;
1220         _setRegistry(_registry);
1221     }
1222 
1223     modifier onlyMGM() {
1224         require(
1225             msg.sender == registry.MGM(),
1226             "Only MGM can call this"
1227         );
1228         _;
1229     }
1230 
1231     /// @dev Registry owner is MTC
1232     modifier onlyMTC() {
1233         require(
1234             msg.sender == registry.owner(),
1235             "Only MTC can call this"
1236         );
1237         _;
1238     }
1239 
1240     function _setRegistry(address _registry) internal {
1241         registry = Registry(_registry);
1242         emit RegistryChange(registry);
1243     }
1244 
1245     /// @dev only callable by MTC
1246     function setRegistry(address _registry)
1247         external
1248         onlyMTC
1249     {
1250         _setRegistry(_registry);
1251     }
1252 
1253     /// @dev set price of AMGU in MLN (base units)
1254     /// @dev only callable by MGM
1255     function setAmguPrice(uint _price)
1256         external
1257         onlyMGM
1258     {
1259         amguPrice = _price;
1260         emit SetAmguPrice(_price);
1261     }
1262 
1263     function getAmguPrice() public view returns (uint) { return amguPrice; }
1264 
1265     function premiumPercent() public view returns (uint) {
1266         if (liquidEther < 1 ether) {
1267             return 0;
1268         } else if (liquidEther >= 1 ether && liquidEther < 5 ether) {
1269             return 5;
1270         } else if (liquidEther >= 5 ether && liquidEther < 10 ether) {
1271             return 10;
1272         } else if (liquidEther >= 10 ether) {
1273             return 15;
1274         }
1275     }
1276 
1277     function payAmguInEther() external payable {
1278         require(
1279             registry.isFundFactory(msg.sender) ||
1280             registry.isFund(msg.sender),
1281             "Sender must be a fund or the factory"
1282         );
1283         uint mlnPerAmgu = getAmguPrice();
1284         uint ethPerMln;
1285         (ethPerMln,) = priceSource().getPrice(address(mlnToken()));
1286         uint amguConsumed;
1287         if (mlnPerAmgu > 0 && ethPerMln > 0) {
1288             amguConsumed = (mul(msg.value, 10 ** uint(MLN_DECIMALS))) / (mul(ethPerMln, mlnPerAmgu));
1289         } else {
1290             amguConsumed = 0;
1291         }
1292         totalEtherConsumed = add(totalEtherConsumed, msg.value);
1293         totalAmguConsumed = add(totalAmguConsumed, amguConsumed);
1294         frozenEther = add(frozenEther, msg.value);
1295         emit AmguPaid(amguConsumed);
1296     }
1297 
1298     /// @notice Move frozen ether to liquid pool after delay
1299     /// @dev Delay only restarts when this function is called
1300     function thaw() external {
1301         require(
1302             block.timestamp >= add(lastThaw, thawingDelay),
1303             "Thawing delay has not passed"
1304         );
1305         require(frozenEther > 0, "No frozen ether to thaw");
1306         lastThaw = block.timestamp;
1307         liquidEther = add(liquidEther, frozenEther);
1308         emit Thaw(frozenEther);
1309         frozenEther = 0;
1310     }
1311 
1312     /// @return ETH per MLN including premium
1313     function enginePrice() public view returns (uint) {
1314         uint ethPerMln;
1315         (ethPerMln, ) = priceSource().getPrice(address(mlnToken()));
1316         uint premium = (mul(ethPerMln, premiumPercent()) / 100);
1317         return add(ethPerMln, premium);
1318     }
1319 
1320     function ethPayoutForMlnAmount(uint mlnAmount) public view returns (uint) {
1321         return mul(mlnAmount, enginePrice()) / 10 ** uint(MLN_DECIMALS);
1322     }
1323 
1324     /// @notice MLN must be approved first
1325     function sellAndBurnMln(uint mlnAmount) external {
1326         require(registry.isFund(msg.sender), "Only funds can use the engine");
1327         require(
1328             mlnToken().transferFrom(msg.sender, address(this), mlnAmount),
1329             "MLN transferFrom failed"
1330         );
1331         uint ethToSend = ethPayoutForMlnAmount(mlnAmount);
1332         require(ethToSend > 0, "No ether to pay out");
1333         require(liquidEther >= ethToSend, "Not enough liquid ether to send");
1334         liquidEther = sub(liquidEther, ethToSend);
1335         totalMlnBurned = add(totalMlnBurned, mlnAmount);
1336         msg.sender.transfer(ethToSend);
1337         mlnToken().burn(mlnAmount);
1338         emit Burn(mlnAmount);
1339     }
1340 
1341     /// @dev Get MLN from the registry
1342     function mlnToken()
1343         public
1344         view
1345         returns (BurnableToken)
1346     {
1347         return BurnableToken(registry.mlnToken());
1348     }
1349 
1350     /// @dev Get PriceSource from the registry
1351     function priceSource()
1352         public
1353         view
1354         returns (PriceSourceInterface)
1355     {
1356         return PriceSourceInterface(registry.priceSource());
1357     }
1358 }