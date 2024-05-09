1 pragma solidity ^0.4.17;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8     address public owner;
9 
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13 
14     /**
15      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16      * account.
17      */
18     function Ownable() public {
19         owner = msg.sender;
20     }
21 
22     /**
23      * @dev Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newOwner.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) public onlyOwner {
35         require(newOwner != address(0));
36         emit OwnershipTransferred(owner, newOwner);
37         owner = newOwner;
38     }
39 
40 }
41 
42 pragma solidity ^0.4.21;
43 
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51     function totalSupply() public view returns (uint256);
52     function balanceOf(address who) public view returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62 
63     /**
64     * @dev Multiplies two numbers, throws on overflow.
65     */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
67         if (a == 0) {
68             return 0;
69         }
70         c = a * b;
71         assert(c / a == b);
72         return c;
73     }
74 
75     /**
76     * @dev Integer division of two numbers, truncating the quotient.
77     */
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         // assert(b > 0); // Solidity automatically throws when dividing by 0
80         // uint256 c = a / b;
81         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82         return a / b;
83     }
84 
85     /**
86     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
87     */
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         assert(b <= a);
90         return a - b;
91     }
92 
93     /**
94     * @dev Adds two numbers, throws on overflow.
95     */
96     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
97         c = a + b;
98         assert(c >= a);
99         return c;
100     }
101 }
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108     function allowance(address owner, address spender) public view returns (uint256);
109     function transferFrom(address from, address to, uint256 value) public returns (bool);
110     function approve(address spender, uint256 value) public returns (bool);
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 contract BasicToken is ERC20Basic {
115     using SafeMath for uint256;
116 
117     mapping(address => uint256) balances;
118 
119     uint256 totalSupply_;
120 
121     /**
122     * @dev total number of tokens in existence
123     */
124     function totalSupply() public view returns (uint256) {
125         return totalSupply_;
126     }
127 
128     /**
129     * @dev transfer token for a specified address
130     * @param _to The address to transfer to.
131     * @param _value The amount to be transferred.
132     */
133     function transfer(address _to, uint256 _value) public returns (bool) {
134         require(_to != address(0));
135         require(_value <= balances[msg.sender]);
136 
137         balances[msg.sender] = balances[msg.sender].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         emit Transfer(msg.sender, _to, _value);
140         return true;
141     }
142 
143     /**
144     * @dev Gets the balance of the specified address.
145     * @param _owner The address to query the the balance of.
146     * @return An uint256 representing the amount owned by the passed address.
147     */
148     function balanceOf(address _owner) public view returns (uint256) {
149         return balances[_owner];
150     }
151 
152 }
153 
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165     mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168     /**
169      * @dev Transfer tokens from one address to another
170      * @param _from address The address which you want to send tokens from
171      * @param _to address The address which you want to transfer to
172      * @param _value uint256 the amount of tokens to be transferred
173      */
174     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175         require(_to != address(0));
176         require(_value <= balances[_from]);
177         require(_value <= allowed[_from][msg.sender]);
178 
179         balances[_from] = balances[_from].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182         emit Transfer(_from, _to, _value);
183         return true;
184     }
185 
186     /**
187      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188      *
189      * Beware that changing an allowance with this method brings the risk that someone may use both the old
190      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      * @param _spender The address which will spend the funds.
194      * @param _value The amount of tokens to be spent.
195      */
196     function approve(address _spender, uint256 _value) public returns (bool) {
197         allowed[msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     /**
203      * @dev Function to check the amount of tokens that an owner allowed to a spender.
204      * @param _owner address The address which owns the funds.
205      * @param _spender address The address which will spend the funds.
206      * @return A uint256 specifying the amount of tokens still available for the spender.
207      */
208     function allowance(address _owner, address _spender) public view returns (uint256) {
209         return allowed[_owner][_spender];
210     }
211 
212     /**
213      * @dev Increase the amount of tokens that an owner allowed to a spender.
214      *
215      * approve should be called when allowed[_spender] == 0. To increment
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      * @param _spender The address which will spend the funds.
220      * @param _addedValue The amount of tokens to increase the allowance by.
221      */
222     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228     /**
229      * @dev Decrease the amount of tokens that an owner allowed to a spender.
230      *
231      * approve should be called when allowed[_spender] == 0. To decrement
232      * allowed value is better to use this function to avoid 2 calls (and wait until
233      * the first transaction is mined)
234      * From MonolithDAO Token.sol
235      * @param _spender The address which will spend the funds.
236      * @param _subtractedValue The amount of tokens to decrease the allowance by.
237      */
238     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239         uint oldValue = allowed[msg.sender][_spender];
240         if (_subtractedValue > oldValue) {
241             allowed[msg.sender][_spender] = 0;
242         } else {
243             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244         }
245         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246         return true;
247     }
248 
249 }
250 
251 /**
252  * @title Roles
253  * @author Francisco Giordano (@frangio)
254  * @dev Library for managing addresses assigned to a Role.
255  *      See RBAC.sol for example usage.
256  */
257 library Roles {
258     struct Role {
259         mapping (address => bool) bearer;
260     }
261 
262     /**
263      * @dev give an address access to this role
264      */
265     function add(Role storage role, address addr)
266     internal
267     {
268         role.bearer[addr] = true;
269     }
270 
271     /**
272      * @dev remove an address' access to this role
273      */
274     function remove(Role storage role, address addr)
275     internal
276     {
277         role.bearer[addr] = false;
278     }
279 
280     /**
281      * @dev check if an address has this role
282      * // reverts
283      */
284     function check(Role storage role, address addr)
285     view
286     internal
287     {
288         require(has(role, addr));
289     }
290 
291     /**
292      * @dev check if an address has this role
293      * @return bool
294      */
295     function has(Role storage role, address addr)
296     view
297     internal
298     returns (bool)
299     {
300         return role.bearer[addr];
301     }
302 }
303 
304 contract RBAC {
305     using Roles for Roles.Role;
306 
307     mapping (string => Roles.Role) private roles;
308 
309     event RoleAdded(address addr, string roleName);
310     event RoleRemoved(address addr, string roleName);
311 
312     /**
313      * @dev reverts if addr does not have role
314      * @param addr address
315      * @param roleName the name of the role
316      * // reverts
317      */
318     function checkRole(address addr, string roleName)
319     view
320     public
321     {
322         roles[roleName].check(addr);
323     }
324 
325     /**
326      * @dev determine if addr has role
327      * @param addr address
328      * @param roleName the name of the role
329      * @return bool
330      */
331     function hasRole(address addr, string roleName)
332     view
333     public
334     returns (bool)
335     {
336         return roles[roleName].has(addr);
337     }
338 
339     /**
340      * @dev add a role to an address
341      * @param addr address
342      * @param roleName the name of the role
343      */
344     function addRole(address addr, string roleName)
345     internal
346     {
347         roles[roleName].add(addr);
348         emit RoleAdded(addr, roleName);
349     }
350 
351     /**
352      * @dev remove a role from an address
353      * @param addr address
354      * @param roleName the name of the role
355      */
356     function removeRole(address addr, string roleName)
357     internal
358     {
359         roles[roleName].remove(addr);
360         emit RoleRemoved(addr, roleName);
361     }
362 
363     /**
364      * @dev modifier to scope access to a single role (uses msg.sender as addr)
365      * @param roleName the name of the role
366      * // reverts
367      */
368     modifier onlyRole(string roleName)
369     {
370         checkRole(msg.sender, roleName);
371         _;
372     }
373 
374     /**
375      * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
376      * @param roleNames the names of the roles to scope access to
377      * // reverts
378      *
379      * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
380      *  see: https://github.com/ethereum/solidity/issues/2467
381      */
382     // modifier onlyRoles(string[] roleNames) {
383     //     bool hasAnyRole = false;
384     //     for (uint8 i = 0; i < roleNames.length; i++) {
385     //         if (hasRole(msg.sender, roleNames[i])) {
386     //             hasAnyRole = true;
387     //             break;
388     //         }
389     //     }
390 
391     //     require(hasAnyRole);
392 
393     //     _;
394     // }
395 }
396 
397 contract RBACWithAdmin is RBAC {
398     /**
399      * A constant role name for indicating admins.
400      */
401     string public constant ROLE_ADMIN = "admin";
402 
403     /**
404      * @dev modifier to scope access to admins
405      * // reverts
406      */
407     modifier onlyAdmin()
408     {
409         checkRole(msg.sender, ROLE_ADMIN);
410         _;
411     }
412 
413     /**
414      * @dev constructor. Sets msg.sender as admin by default
415      */
416     function RBACWithAdmin()
417     public
418     {
419         addRole(msg.sender, ROLE_ADMIN);
420     }
421 
422     /**
423      * @dev add a role to an address
424      * @param addr address
425      * @param roleName the name of the role
426      */
427     function adminAddRole(address addr, string roleName)
428     onlyAdmin
429     public
430     {
431         addRole(addr, roleName);
432     }
433 
434     /**
435      * @dev remove a role from an address
436      * @param addr address
437      * @param roleName the name of the role
438      */
439     function adminRemoveRole(address addr, string roleName)
440     onlyAdmin
441     public
442     {
443         removeRole(addr, roleName);
444     }
445 }
446 
447 contract NbtToken is StandardToken, Ownable, RBACWithAdmin {
448 
449     /*** EVENTS ***/
450 
451     event ExchangeableTokensInc(address indexed from, uint256 amount);
452     event ExchangeableTokensDec(address indexed to, uint256 amount);
453 
454     event CirculatingTokensInc(address indexed from, uint256 amount);
455     event CirculatingTokensDec(address indexed to, uint256 amount);
456 
457     event SaleableTokensInc(address indexed from, uint256 amount);
458     event SaleableTokensDec(address indexed to, uint256 amount);
459 
460     event StockTokensInc(address indexed from, uint256 amount);
461     event StockTokensDec(address indexed to, uint256 amount);
462 
463     event BbAddressUpdated(address indexed ethereum_address, string bb_address);
464 
465     /*** CONSTANTS ***/
466 
467     string public name = 'NiceBytes';
468     string public symbol = 'NBT';
469 
470     uint256 public decimals = 8;
471 
472     uint256 public INITIAL_SUPPLY = 10000000000 * 10**decimals; // One time total supply
473     uint256 public AIRDROP_START_AT = 1525780800; // May 8, 12:00 UTC
474     uint256 public AIRDROPS_COUNT = 82;
475     uint256 public AIRDROPS_PERIOD = 86400;
476     uint256 public CIRCULATING_BASE = 2000000000 * 10**decimals;
477     uint256 public MAX_AIRDROP_VOLUME = 2; // %
478     uint256 public INITIAL_EXCHANGEABLE_TOKENS_VOLUME = 1200000000 * 10**decimals;
479     uint256 public MAX_AIRDROP_TOKENS = 8000000000 * 10**decimals; // 8 billions
480     uint256 public MAX_SALE_VOLUME = 800000000 * 10**decimals;
481     uint256 public EXCHANGE_COMMISSION = 200 * 10**decimals; // NBT
482     uint256 public MIN_TOKENS_TO_EXCHANGE = 1000 * 10**decimals; // should be bigger than EXCHANGE_COMMISSION
483     uint256 public EXCHANGE_RATE = 1000;
484     string constant ROLE_EXCHANGER = "exchanger";
485 
486 
487     /*** STORAGE ***/
488 
489     uint256 public exchangeableTokens;
490     uint256 public exchangeableTokensFromSale;
491     uint256 public exchangeableTokensFromStock;
492     uint256 public circulatingTokens;
493     uint256 public circulatingTokensFromSale;
494     uint256 public saleableTokens;
495     uint256 public stockTokens;
496     address public crowdsale;
497     address public exchange_commission_wallet;
498 
499     mapping(address => uint256) exchangeBalances;
500     mapping(address => string) bbAddresses;
501 
502     /*** MODIFIERS ***/
503 
504     modifier onlyAdminOrExchanger()
505     {
506         require(
507             hasRole(msg.sender, ROLE_ADMIN) ||
508             hasRole(msg.sender, ROLE_EXCHANGER)
509         );
510         _;
511     }
512 
513     modifier onlyCrowdsale()
514     {
515         require(
516             address(msg.sender) == address(crowdsale)
517         );
518         _;
519     }
520 
521     /*** CONSTRUCTOR ***/
522 
523     function NbtToken() public {
524         totalSupply_ = INITIAL_SUPPLY;
525         balances[this] = INITIAL_SUPPLY;
526         stockTokens = INITIAL_SUPPLY;
527         emit StockTokensInc(address(0), INITIAL_SUPPLY);
528         addRole(msg.sender, ROLE_EXCHANGER);
529     }
530 
531     /*** PUBLIC AND EXTERNAL FUNCTIONS ***/
532 
533     /*** getters  ***/
534 
535     function getBbAddress(address _addr) public view returns (string _bbAddress) {
536         return bbAddresses[_addr];
537     }
538 
539     function howMuchTokensAvailableForExchangeFromStock() public view returns (uint256) {
540         uint256 _volume = INITIAL_EXCHANGEABLE_TOKENS_VOLUME;
541         uint256 _airdrops = 0;
542 
543         if (now > AIRDROP_START_AT) {
544             _airdrops = (now.sub(AIRDROP_START_AT)).div(AIRDROPS_PERIOD);
545             _airdrops = _airdrops.add(1);
546         }
547 
548         if (_airdrops > AIRDROPS_COUNT) {
549             _airdrops = AIRDROPS_COUNT;
550         }
551 
552         uint256 _from_airdrops = 0;
553         uint256 _base = CIRCULATING_BASE;
554         for (uint256 i = 1; i <= _airdrops; i++) {
555             _from_airdrops = _from_airdrops.add(_base.mul(MAX_AIRDROP_VOLUME).div(100));
556             _base = _base.add(_base.mul(MAX_AIRDROP_VOLUME).div(100));
557         }
558         if (_from_airdrops > MAX_AIRDROP_TOKENS) {
559             _from_airdrops = MAX_AIRDROP_TOKENS;
560         }
561 
562         _volume = _volume.add(_from_airdrops);
563 
564         return _volume;
565     }
566 
567     /*** setters  ***/
568 
569     function setBbAddress(string _bbAddress) public returns (bool) {
570         bbAddresses[msg.sender] = _bbAddress;
571         emit BbAddressUpdated(msg.sender, _bbAddress);
572         return true;
573     }
574 
575     function setCrowdsaleAddress(address _addr) onlyAdmin public returns (bool) {
576         require(_addr != address(0) && _addr != address(this));
577         crowdsale = _addr;
578         return true;
579     }
580 
581     function setExchangeCommissionAddress(address _addr) onlyAdmin public returns (bool) {
582         require(_addr != address(0) && _addr != address(this));
583         exchange_commission_wallet = _addr;
584         return true;
585     }
586 
587     /*** sale methods  ***/
588 
589     // For balancing of the sale limit between two networks
590     function moveTokensFromSaleToExchange(uint256 _amount) onlyAdminOrExchanger public returns (bool) {
591         require(_amount <= balances[crowdsale]);
592         balances[crowdsale] = balances[crowdsale].sub(_amount);
593         saleableTokens = saleableTokens.sub(_amount);
594         exchangeableTokensFromSale = exchangeableTokensFromSale.add(_amount);
595         balances[address(this)] = balances[address(this)].add(_amount);
596         exchangeableTokens = exchangeableTokens.add(_amount);
597         emit SaleableTokensDec(address(this), _amount);
598         emit ExchangeableTokensInc(address(crowdsale), _amount);
599         return true;
600     }
601 
602     function moveTokensFromSaleToCirculating(address _to, uint256 _amount) onlyCrowdsale public returns (bool) {
603         saleableTokens = saleableTokens.sub(_amount);
604         circulatingTokensFromSale = circulatingTokensFromSale.add(_amount) ;
605         circulatingTokens = circulatingTokens.add(_amount) ;
606         emit SaleableTokensDec(_to, _amount);
607         emit CirculatingTokensInc(address(crowdsale), _amount);
608         return true;
609     }
610 
611     /*** stock methods  ***/
612 
613     function moveTokensFromStockToExchange(uint256 _amount) onlyAdminOrExchanger public returns (bool) {
614         require(_amount <= stockTokens);
615         require(exchangeableTokensFromStock + _amount <= howMuchTokensAvailableForExchangeFromStock());
616         stockTokens = stockTokens.sub(_amount);
617         exchangeableTokens = exchangeableTokens.add(_amount);
618         exchangeableTokensFromStock = exchangeableTokensFromStock.add(_amount);
619         emit StockTokensDec(address(this), _amount);
620         emit ExchangeableTokensInc(address(this), _amount);
621         return true;
622     }
623 
624     function moveTokensFromStockToSale(uint256 _amount) onlyAdminOrExchanger public returns (bool) {
625         require(crowdsale != address(0) && crowdsale != address(this));
626         require(_amount <= stockTokens);
627         require(_amount + exchangeableTokensFromSale + saleableTokens + circulatingTokensFromSale <= MAX_SALE_VOLUME);
628 
629         stockTokens = stockTokens.sub(_amount);
630         saleableTokens = saleableTokens.add(_amount);
631         balances[address(this)] = balances[address(this)].sub(_amount);
632         balances[crowdsale] = balances[crowdsale].add(_amount);
633 
634         emit Transfer(address(this), crowdsale, _amount);
635         emit StockTokensDec(address(crowdsale), _amount);
636         emit SaleableTokensInc(address(this), _amount);
637         return true;
638     }
639 
640     /*** exchange methods  ***/
641 
642     function getTokensFromExchange(address _to, uint256 _amount) onlyAdminOrExchanger public returns (bool) {
643         require(_amount <= exchangeableTokens);
644         require(_amount <= balances[address(this)]);
645 
646         exchangeableTokens = exchangeableTokens.sub(_amount);
647         circulatingTokens = circulatingTokens.add(_amount);
648 
649         balances[address(this)] = balances[address(this)].sub(_amount);
650         balances[_to] = balances[_to].add(_amount);
651 
652         emit Transfer(address(this), _to, _amount);
653         emit ExchangeableTokensDec(_to, _amount);
654         emit CirculatingTokensInc(address(this), _amount);
655         return true;
656     }
657 
658     function sendTokensToExchange(uint256 _amount) public returns (bool) {
659         require(_amount <= balances[msg.sender]);
660         require(_amount >= MIN_TOKENS_TO_EXCHANGE);
661         require(!stringsEqual(bbAddresses[msg.sender], ''));
662         require(exchange_commission_wallet != address(0) && exchange_commission_wallet != address(this));
663 
664         balances[msg.sender] = balances[msg.sender].sub(_amount); // ! before sub(_commission)
665 
666         uint256 _commission = EXCHANGE_COMMISSION + _amount % EXCHANGE_RATE;
667         _amount = _amount.sub(_commission);
668 
669         circulatingTokens = circulatingTokens.sub(_amount);
670         exchangeableTokens = exchangeableTokens.add(_amount);
671         exchangeBalances[msg.sender] = exchangeBalances[msg.sender].add(_amount);
672 
673         balances[address(this)] = balances[address(this)].add(_amount);
674         balances[exchange_commission_wallet] = balances[exchange_commission_wallet].add(_commission);
675 
676         emit Transfer(msg.sender, address(exchange_commission_wallet), _commission);
677         emit Transfer(msg.sender, address(this), _amount);
678         emit CirculatingTokensDec(address(this), _amount);
679         emit ExchangeableTokensInc(msg.sender, _amount);
680         return true;
681     }
682 
683     function exchangeBalanceOf(address _addr) public view returns (uint256 _tokens) {
684         return exchangeBalances[_addr];
685     }
686 
687     function decExchangeBalanceOf(address _addr, uint256 _amount) onlyAdminOrExchanger public returns (bool) {
688         require (exchangeBalances[_addr] > 0);
689         require (exchangeBalances[_addr] >= _amount);
690         exchangeBalances[_addr] = exchangeBalances[_addr].sub(_amount);
691         return true;
692     }
693 
694     /*** INTERNAL FUNCTIONS ***/
695 
696     function stringsEqual(string storage _a, string memory _b) internal view returns (bool) {
697         bytes storage a = bytes(_a);
698         bytes memory b = bytes(_b);
699         if (a.length != b.length)
700             return false;
701         for (uint256 i = 0; i < a.length; i ++)
702             if (a[i] != b[i])
703                 return false;
704         return true;
705     }
706 }