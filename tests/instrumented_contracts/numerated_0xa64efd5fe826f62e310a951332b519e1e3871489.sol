1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.5.17;
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://eips.ethereum.org/EIPS/eip-20
71  */
72 interface IERC20 {
73     function transfer(address to, uint256 value) external returns (bool);
74 
75     function approve(address spender, uint256 value) external returns (bool);
76 
77     function transferFrom(address from, address to, uint256 value) external returns (bool);
78 
79     function totalSupply() external view returns (uint256);
80 
81     function balanceOf(address who) external view returns (uint256);
82 
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 /**
91  * @title ERC20Detailed token
92  * @dev The decimals are only for visualization purposes.
93  * All the operations are done using the smallest and indivisible token unit,
94  * just as on Ethereum all the operations are done in wei.
95  */
96 contract ERC20Detailed is IERC20 {
97     string private _name;
98     string private _symbol;
99     uint8 private _decimals;
100 
101     constructor (string memory name, string memory symbol, uint8 decimals) public {
102         _name = name;
103         _symbol = symbol;
104         _decimals = decimals;
105     }
106 
107     /**
108      * @return the name of the token.
109      */
110     function name() public view returns (string memory) {
111         return _name;
112     }
113 
114     /**
115      * @return the symbol of the token.
116      */
117     function symbol() public view returns (string memory) {
118         return _symbol;
119     }
120 
121     /**
122      * @return the number of decimals of the token.
123      */
124     function decimals() public view returns (uint8) {
125         return _decimals;
126     }
127 }
128 
129 contract BetaCarbon is ERC20Detailed {
130     using SafeMath for uint256;
131 
132     mapping (address => uint256) private _balances;
133 
134     mapping (address => mapping (address => uint256)) private _allowed;
135 
136     uint256 private _totalSupply;
137 
138     bool public paused = false;
139     
140     // ASSET PROTECTION DATA
141     address public assetProtectionRole;
142     mapping(address => bool) internal frozen;
143 
144     // SUPPLY CONTROL DATA
145     address public supplyController;
146 
147     // OWNER DATA
148     address public owner;
149     address public proposedOwner;
150     bool public initialized = false;
151 
152     /**
153      * @dev Constructor that gives msg.sender all of existing tokens.
154      */
155     constructor () public ERC20Detailed("BetaCarbon", "BCAU", 18) {
156        
157         initialize();
158          _mint(0);
159         pause();
160     }
161      function initialize() public {
162         require(!initialized, "already initialized");
163         owner = msg.sender;
164         proposedOwner = address(0);
165         assetProtectionRole = address(0);
166         supplyController = msg.sender;
167         initialized = true;
168     }  
169 
170     // OWNABLE EVENTS
171     event OwnershipTransferProposed(
172         address indexed currentOwner,
173         address indexed proposedOwner
174     );
175     event OwnershipTransferDisregarded(address indexed oldProposedOwner);
176     event OwnershipTransferred(
177         address indexed oldOwner,
178         address indexed newOwner
179     );
180 
181     // PAUSABLE EVENTS
182     event Pause();
183     event Unpause();
184 
185 // ASSET PROTECTION EVENTS
186     event AddressFrozen(address indexed addr);
187     event AddressUnfrozen(address indexed addr);
188     event FrozenAddressWiped(address indexed addr);
189     event AssetProtectionRoleSet(
190         address indexed oldAssetProtectionRole,
191         address indexed newAssetProtectionRole
192     );
193 
194 // SUPPLY CONTROL EVENTS
195     event SupplyIncreased(address indexed to, uint256 value);
196     event SupplyDecreased(address indexed from, uint256 value);
197     event SupplyControllerSet(
198         address indexed oldSupplyController,
199         address indexed newSupplyController
200     );
201     
202     /**
203      * @dev Total number of tokens in existence
204      */
205     function totalSupply() public view returns (uint256) {
206         return _totalSupply;
207     }
208 
209     /**
210      * @dev Gets the balance of the specified address.
211      * @param me The address to query the balance of.
212      * @return An uint256 representing the amount owned by the passed address.
213      */
214     function balanceOf(address me) public view returns (uint256) {
215         return _balances[me];
216     }
217 
218     /**
219      * @dev Function to check the amount of tokens that an owner allowed to a spender.
220      * @param me address The address which owns the funds.
221      * @param spender address The address which will spend the funds.
222      * @return A uint256 specifying the amount of tokens still available for the spender.
223      */
224     function allowance(address me, address spender) public view returns (uint256) {
225         return _allowed[me][spender];
226     }
227 
228     modifier whenNotPaused() {
229         require(!paused, "whenNotPaused");
230         _;
231     }
232 
233     /**
234      * @dev Transfer token to a specified address
235      * @param to The address to transfer to.
236      * @param value The amount to be transferred.
237      */
238     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
239          require(to != address(0), "cannot transfer to address zero");
240         require(!frozen[to] && !frozen[msg.sender], "address frozen");
241         require(value <= _balances[msg.sender], "insufficient funds");
242         _transfer(msg.sender, to, value);
243         return true;
244     }
245 
246    
247     /**
248      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249      * Beware that changing an allowance with this method brings the risk that someone may use both the old
250      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253      * @param spender The address which will spend the funds.
254      * @param value The amount of tokens to be spent.
255      */
256     function approve(address spender, uint256 value) public returns (bool) {
257         _approve(msg.sender, spender, value);
258         return true;
259     }
260 
261     /**
262      * @dev Transfer tokens from one address to another.
263      * Note that while this function emits an Approval event, this is not required as per the specification,
264      * and other compliant implementations may not emit the event.
265      * @param from address The address which you want to send tokens from
266      * @param to address The address which you want to transfer to
267      * @param value uint256 the amount of tokens to be transferred
268      */
269     function transferFrom(address from, address to, uint256 value) public returns (bool) {
270          require(to != address(0), "cannot transfer to address zero");
271         require(
272             !frozen[to] && !frozen[from] && !frozen[msg.sender],
273             "address frozen"
274         );
275         require(value <= _balances[from], "insufficient funds");
276         require(value <= _allowed[from][msg.sender], "insufficient allowance");
277         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
278         _transfer(from, to, value);
279         //_approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
280         return true;
281     }
282 
283     /**
284      * @dev Increase the amount of tokens that an owner allowed to a spender.
285      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
286      * allowed value is better to use this function to avoid 2 calls (and wait until
287      * the first transaction is mined)
288      * From MonolithDAO Token.sol
289      * Emits an Approval event.
290      * @param spender The address which will spend the funds.
291      * @param addedValue The amount of tokens to increase the allowance by.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
294         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
295         return true;
296     }
297 
298     /**
299      * @dev Decrease the amount of tokens that an owner allowed to a spender.
300      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
301      * allowed value is better to use this function to avoid 2 calls (and wait until
302      * the first transaction is mined)
303      * From MonolithDAO Token.sol
304      * Emits an Approval event.
305      * @param spender The address which will spend the funds.
306      * @param subtractedValue The amount of tokens to decrease the allowance by.
307      */
308     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
309         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
310         return true;
311     }
312 
313     /**
314      * @dev Transfer token for a specified addresses
315      * @param from The address to transfer from.
316      * @param to The address to transfer to.
317      * @param value The amount to be transferred.
318      */
319     function _transfer(address from, address to, uint256 value) internal {
320         require(to != address(0), "cannot transfer to address zero");
321 
322         require(value <= _balances[from], "insufficient funds");
323         _balances[from] = _balances[from].sub(value);
324         _balances[to] = _balances[to].add(value);
325         emit Transfer(from, to, value);
326     }
327 
328   
329 
330     /**
331      * @dev Approve an address to spend another addresses' tokens.
332      * @param me The address that owns the tokens.
333      * @param spender The address that will spend the tokens.
334      * @param value The number of tokens that can be spent.
335      */
336     function _approve(address me, address spender, uint256 value) internal {
337         require(spender != address(0));
338         require(me != address(0));
339 
340         _allowed[me][spender] = value;
341         emit Approval(me, spender, value);
342     }
343 
344    
345 
346     modifier onlySupplyController() {
347         require(msg.sender == supplyController, "onlySupplyController");
348         _;
349     }
350 
351     /**
352      * @dev Function to mint tokens
353      * @param value The amount of tokens to mint.
354      * @return A boolean that indicates if the operation was successful.
355      */
356     function mint(uint256 value) public onlySupplyController returns (bool) {
357         _mint(value);
358         return true;
359     }
360     
361       /**
362      * @dev Function to burn tokens
363 
364      * @param value The amount that will be burnt.
365      * @return A boolean that indicates if the operation was successful.
366      */
367     function burn(uint256 value) public onlySupplyController returns (bool) {
368         _burn(value);
369         return true;
370     }
371 
372      /**
373      * @dev Increases the total supply by minting the specified number of tokens to the supply controller account.
374      * @param _value The number of tokens to add.
375      * @return A boolean that indicates if the operation was successful.
376      */
377     
378     function _mint(uint256 _value)
379         internal
380         onlySupplyController
381         returns (bool success)
382     {
383         _totalSupply = _totalSupply.add(_value);
384         _balances[supplyController] = _balances[supplyController].add(_value);
385         emit SupplyIncreased(supplyController, _value);
386         emit Transfer(address(0), supplyController, _value);
387         return true;
388     }
389 
390      /**
391      * @dev Decrease the total supply by burning the specified number of tokens to the supply controller account.
392      * @param _value The number of tokens to burn.
393      * @return A boolean that indicates if the operation was successful.
394      */
395 
396      function _burn(uint256 _value)
397         internal
398         onlySupplyController
399         returns (bool success)
400     {
401         require(_value <= _balances[supplyController], "not enough supply");
402         //_value = _value* 10**18;
403         _balances[supplyController] = _balances[supplyController].sub(_value);
404         _totalSupply = _totalSupply.sub(_value);
405         emit SupplyDecreased(supplyController, _value);
406         emit Transfer(supplyController, address(0), _value);
407         return true;
408     }
409 
410     modifier onlyOwner() {
411         require(msg.sender == owner, "onlyOwner");
412         _;
413     }
414      function pause() public onlyOwner {
415         require(!paused, "already paused");
416         paused = true;
417         emit Pause();
418     }
419 
420      function unpause() public onlyOwner {
421         require(paused, "already unpaused");
422         paused = false;
423         emit Unpause();
424     }
425 
426     /**
427      * @dev Allows the current owner to begin transferring control of the contract to a proposedOwner
428      * @param _proposedOwner The address to transfer ownership to.
429     */
430 
431     function proposeOwner(address _proposedOwner) public onlyOwner {
432         require(
433             _proposedOwner != address(0),
434             "cannot transfer ownership to address zero"
435         );
436         require(msg.sender != _proposedOwner, "caller already is owner");
437         proposedOwner = _proposedOwner;
438         emit OwnershipTransferProposed(owner, proposedOwner);
439     }
440 
441     /**
442      * @dev Allows the current owner or proposed owner to cancel transferring control of the contract to a proposedOwner
443        commented out since this is not used
444     */
445 
446     function disregardProposeOwner() public {
447         require(
448             msg.sender == proposedOwner || msg.sender == owner,
449             "only proposedOwner or owner"
450         );
451         require(
452             proposedOwner != address(0),
453             "can only disregard a proposed owner that was previously set"
454         );
455         address _oldProposedOwner = proposedOwner;
456         proposedOwner = address(0);
457         emit OwnershipTransferDisregarded(_oldProposedOwner);
458     }
459  
460     /**
461      * @dev Allows the proposed owner to complete transferring control of the contract to the proposedOwner.
462     */
463 
464     function claimOwnership() public {
465         require(msg.sender == proposedOwner, "onlyProposedOwner");
466         address _oldOwner = owner;
467         owner = proposedOwner;
468         proposedOwner = address(0);
469         emit OwnershipTransferred(_oldOwner, owner);
470     }  
471 
472       // ASSET PROTECTION FUNCTIONALITY
473 
474     /**
475      * @dev Sets a new asset protection role address.
476      * @param _newAssetProtectionRole The new address allowed to freeze/unfreeze addresses and seize their tokens.
477      */
478 
479     function setAssetProtectionRole(address _newAssetProtectionRole) public {
480         require(
481             msg.sender == assetProtectionRole || msg.sender == owner,
482             "only assetProtectionRole or Owner"
483         );
484         emit AssetProtectionRoleSet(
485             assetProtectionRole,
486             _newAssetProtectionRole
487         );
488         assetProtectionRole = _newAssetProtectionRole;
489     }
490 
491     modifier onlyAssetProtectionRole() {
492         require(msg.sender == assetProtectionRole, "onlyAssetProtectionRole");
493         _;
494     }
495 
496      /**
497      * @dev Freezes an address balance from being transferred.
498      * @param _addr The new address to freeze.
499      */
500 
501     function freeze(address _addr) public onlyAssetProtectionRole {
502         require(!frozen[_addr], "address already frozen");
503         frozen[_addr] = true;
504         emit AddressFrozen(_addr);
505     }
506 
507     /**
508      * @dev Unfreezes an address balance allowing transfer.
509      * @param _addr The new address to unfreeze.
510     */
511 
512     function unfreeze(address _addr) public onlyAssetProtectionRole {
513         require(frozen[_addr], "address already unfrozen");
514         frozen[_addr] = false;
515         emit AddressUnfrozen(_addr);
516     }
517 
518     /**
519      * @dev Wipes the balance of a frozen address, burning the tokens
520      * and setting the approval to zero.
521      * @param _addr The new frozen address to wipe.
522     */
523 
524     function wipeFrozenAddress(address _addr) public onlyAssetProtectionRole {
525         require(frozen[_addr], "address is not frozen");
526         uint256 _balance = _balances[_addr];
527         _balances[_addr] = 0;
528         _totalSupply = _totalSupply.sub(_balance);
529         emit FrozenAddressWiped(_addr);
530         emit SupplyDecreased(_addr, _balance);
531         emit Transfer(_addr, address(0), _balance);
532     }
533 
534     /**
535      * @dev Gets whether the address is currently frozen.
536      * @param _addr The address to check if frozen.
537      * @return A bool representing whether the given address is frozen.
538      */
539     function isFrozen(address _addr) public view returns (bool) {
540         return frozen[_addr];
541     }
542     // SUPPLY CONTROL FUNCTIONALITY
543 
544     /**
545      * @dev Sets a new supply controller address.
546      * @param _newSupplyController The address allowed to burn/mint tokens to control supply.
547      */
548 
549     function setSupplyController(address _newSupplyController) public {
550         require(
551             msg.sender == supplyController || msg.sender == owner,
552             "only SupplyController or Owner"
553         );
554         require(
555             _newSupplyController != address(0),
556             "cannot set supply controller to address zero"
557         );
558         emit SupplyControllerSet(supplyController, _newSupplyController);
559         supplyController = _newSupplyController;
560     }  
561 }