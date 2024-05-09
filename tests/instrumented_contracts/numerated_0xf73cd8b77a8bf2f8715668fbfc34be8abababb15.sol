1 pragma solidity ^0.4.24;
2 pragma experimental "v0.5.0";
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that revert on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, reverts on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (a == 0) {
20       return 0;
21     }
22 
23     uint256 c = a * b;
24     require(c / a == b);
25 
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     require(b > 0); // Solidity only automatically asserts when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37     return c;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     require(b <= a);
45     uint256 c = a - b;
46 
47     return c;
48   }
49 
50   /**
51   * @dev Adds two numbers, reverts on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     require(c >= a);
56 
57     return c;
58   }
59 
60   /**
61   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
62   * reverts when dividing by zero.
63   */
64   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65     require(b != 0);
66     return a % b;
67   }
68 }
69 
70 
71 /**
72  * @title PAXImplementation
73  * @dev this contract is a Pausable ERC20 token with Burn and Mint
74  * controleld by a central SupplyController. By implementing PaxosImplementation
75  * this contract also includes external methods for setting
76  * a new implementation contract for the Proxy.
77  * NOTE: The storage defined here will actually be held in the Proxy
78  * contract and all calls to this contract should be made through
79  * the proxy, including admin actions done as owner or supplyController.
80  * Any call to transfer against this contract should fail
81  * with insufficient funds since no tokens will be issued there.
82  */
83 contract PAXImplementation {
84 
85     /**
86      * MATH
87      */
88 
89     using SafeMath for uint256;
90 
91     /**
92      * DATA
93      */
94 
95     // INITIALIZATION DATA
96     bool private initialized = false;
97 
98     // ERC20 BASIC DATA
99     mapping(address => uint256) internal balances;
100     uint256 internal totalSupply_;
101     string public constant name = "Quick USD"; // solium-disable-line uppercase
102     string public constant symbol = "QUSD"; // solium-disable-line uppercase
103     uint8 public constant decimals = 18; // solium-disable-line uppercase
104 
105     // ERC20 DATA
106     mapping (address => mapping (address => uint256)) internal allowed;
107 
108     // OWNER DATA
109     address public owner;
110 
111     // PAUSABILITY DATA
112     bool public paused = false;
113 
114     // LAW ENFORCEMENT DATA
115     address public lawEnforcementRole;
116     mapping(address => bool) internal frozen;
117 
118     // SUPPLY CONTROL DATA
119     address public supplyController;
120 
121     /**
122      * EVENTS
123      */
124 
125     // ERC20 BASIC EVENTS
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     // ERC20 EVENTS
129     event Approval(
130         address indexed owner,
131         address indexed spender,
132         uint256 value
133     );
134 
135     // OWNABLE EVENTS
136     event OwnershipTransferred(
137         address indexed oldOwner,
138         address indexed newOwner
139     );
140 
141     // PAUSABLE EVENTS
142     event Pause();
143     event Unpause();
144 
145     // LAW ENFORCEMENT EVENTS
146     event AddressFrozen(address indexed addr);
147     event AddressUnfrozen(address indexed addr);
148     event FrozenAddressWiped(address indexed addr);
149     event LawEnforcementRoleSet (
150         address indexed oldLawEnforcementRole,
151         address indexed newLawEnforcementRole
152     );
153 
154     // SUPPLY CONTROL EVENTS
155     event SupplyIncreased(address indexed to, uint256 value);
156     event SupplyDecreased(address indexed from, uint256 value);
157     event SupplyControllerSet(
158         address indexed oldSupplyController,
159         address indexed newSupplyController
160     );
161 
162     /**
163      * FUNCTIONALITY
164      */
165 
166     // INITIALIZATION FUNCTIONALITY
167 
168     /**
169      * @dev sets 0 initials tokens, the owner, and the supplyController.
170      * this serves as the constructor for the proxy but compiles to the
171      * memory model of the Implementation contract.
172      */
173     function initialize() public {
174         require(!initialized, "already initialized");
175         owner = msg.sender;
176         lawEnforcementRole = address(0);
177         totalSupply_ = 0;
178         supplyController = msg.sender;
179         initialized = true;
180     }
181 
182     /**
183      * The constructor is used here to ensure that the implementation
184      * contract is initialized. An uncontrolled implementation
185      * contract might lead to misleading state
186      * for users who accidentally interact with it.
187      */
188     constructor() public {
189         initialize();
190         pause();
191     }
192 
193     // ERC20 BASIC FUNCTIONALITY
194 
195     /**
196     * @dev Total number of tokens in existence
197     */
198     function totalSupply() public view returns (uint256) {
199         return totalSupply_;
200     }
201 
202     /**
203     * @dev Transfer token for a specified address
204     * @param _to The address to transfer to.
205     * @param _value The amount to be transferred.
206     */
207     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
208         require(_to != address(0), "cannot transfer to address zero");
209         require(!frozen[_to] && !frozen[msg.sender], "address frozen");
210         require(_value <= balances[msg.sender], "insufficient funds");
211 
212         balances[msg.sender] = balances[msg.sender].sub(_value);
213         balances[_to] = balances[_to].add(_value);
214         emit Transfer(msg.sender, _to, _value);
215         return true;
216     }
217 
218     /**
219     * @dev Gets the balance of the specified address.
220     * @param _addr The address to query the the balance of.
221     * @return An uint256 representing the amount owned by the passed address.
222     */
223     function balanceOf(address _addr) public view returns (uint256) {
224         return balances[_addr];
225     }
226 
227     // ERC20 FUNCTIONALITY
228 
229     /**
230      * @dev Transfer tokens from one address to another
231      * @param _from address The address which you want to send tokens from
232      * @param _to address The address which you want to transfer to
233      * @param _value uint256 the amount of tokens to be transferred
234      */
235     function transferFrom(
236         address _from,
237         address _to,
238         uint256 _value
239     )
240     public
241     whenNotPaused
242     returns (bool)
243     {
244         require(_to != address(0), "cannot transfer to address zero");
245         require(!frozen[_to] && !frozen[_from] && !frozen[msg.sender], "address frozen");
246         require(_value <= balances[_from], "insufficient funds");
247         require(_value <= allowed[_from][msg.sender], "insufficient allowance");
248 
249         balances[_from] = balances[_from].sub(_value);
250         balances[_to] = balances[_to].add(_value);
251         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
252         emit Transfer(_from, _to, _value);
253         return true;
254     }
255 
256     /**
257      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
258      * Beware that changing an allowance with this method brings the risk that someone may use both the old
259      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
260      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
261      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262      * @param _spender The address which will spend the funds.
263      * @param _value The amount of tokens to be spent.
264      */
265     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
266         require(!frozen[_spender] && !frozen[msg.sender], "address frozen");
267         allowed[msg.sender][_spender] = _value;
268         emit Approval(msg.sender, _spender, _value);
269         return true;
270     }
271 
272     /**
273      * @dev Function to check the amount of tokens that an owner allowed to a spender.
274      * @param _owner address The address which owns the funds.
275      * @param _spender address The address which will spend the funds.
276      * @return A uint256 specifying the amount of tokens still available for the spender.
277      */
278     function allowance(
279         address _owner,
280         address _spender
281     )
282     public
283     view
284     returns (uint256)
285     {
286         return allowed[_owner][_spender];
287     }
288 
289     // OWNER FUNCTIONALITY
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(msg.sender == owner, "onlyOwner");
296         _;
297     }
298 
299     /**
300      * @dev Allows the current owner to transfer control of the contract to a newOwner.
301      * @param _newOwner The address to transfer ownership to.
302      */
303     function transferOwnership(address _newOwner) public onlyOwner {
304         require(_newOwner != address(0), "cannot transfer ownership to address zero");
305         emit OwnershipTransferred(owner, _newOwner);
306         owner = _newOwner;
307     }
308 
309     // PAUSABILITY FUNCTIONALITY
310 
311     /**
312      * @dev Modifier to make a function callable only when the contract is not paused.
313      */
314     modifier whenNotPaused() {
315         require(!paused, "whenNotPaused");
316         _;
317     }
318 
319     /**
320      * @dev called by the owner to pause, triggers stopped state
321      */
322     function pause() public onlyOwner {
323         require(!paused, "already paused");
324         paused = true;
325         emit Pause();
326     }
327 
328     /**
329      * @dev called by the owner to unpause, returns to normal state
330      */
331     function unpause() public onlyOwner {
332         require(paused, "already unpaused");
333         paused = false;
334         emit Unpause();
335     }
336 
337     // LAW ENFORCEMENT FUNCTIONALITY
338 
339     /**
340      * @dev Sets a new law enforcement role address.
341      * @param _newLawEnforcementRole The new address allowed to freeze/unfreeze addresses and seize their tokens.
342      */
343     function setLawEnforcementRole(address _newLawEnforcementRole) public {
344         require(msg.sender == lawEnforcementRole || msg.sender == owner, "only lawEnforcementRole or Owner");
345         emit LawEnforcementRoleSet(lawEnforcementRole, _newLawEnforcementRole);
346         lawEnforcementRole = _newLawEnforcementRole;
347     }
348 
349     modifier onlyLawEnforcementRole() {
350         
351         
352         require(msg.sender == lawEnforcementRole, "onlyLawEnforcementRole");
353         _;
354     }
355 
356     /**
357      * @dev Freezes an address balance from being transferred.
358      * @param _addr The new address to freeze.
359      */
360     function freeze(address _addr) public onlyLawEnforcementRole {
361         require(!frozen[_addr], "address already frozen");
362         frozen[_addr] = true;
363         emit AddressFrozen(_addr);
364     }
365 
366     /**
367      * @dev Unfreezes an address balance allowing transfer.
368      * @param _addr The new address to unfreeze.
369      */
370     function unfreeze(address _addr) public onlyLawEnforcementRole {
371         require(frozen[_addr], "address already unfrozen");
372         frozen[_addr] = false;
373         emit AddressUnfrozen(_addr);
374     }
375 
376     /**
377      * @dev Wipes the balance of a frozen address, burning the tokens
378      * and setting the approval to zero.
379      * @param _addr The new frozen address to wipe.
380      */
381     function wipeFrozenAddress(address _addr) public onlyLawEnforcementRole {
382         require(frozen[_addr], "address is not frozen");
383         uint256 _balance = balances[_addr];
384         balances[_addr] = 0;
385         totalSupply_ = totalSupply_.sub(_balance);
386         emit FrozenAddressWiped(_addr);
387         emit SupplyDecreased(_addr, _balance);
388         emit Transfer(_addr, address(0), _balance);
389     }
390 
391     /**
392     * @dev Gets the balance of the specified address.
393     * @param _addr The address to check if frozen.
394     * @return A bool representing whether the given address is frozen.
395     */
396     function isFrozen(address _addr) public view returns (bool) {
397         return frozen[_addr];
398     }
399 
400     // SUPPLY CONTROL FUNCTIONALITY
401 
402     /**
403      * @dev Sets a new supply controller address.
404      * @param _newSupplyController The address allowed to burn/mint tokens to control supply.
405      */
406     function setSupplyController(address _newSupplyController) public {
407         require(msg.sender == supplyController || msg.sender == owner, "only SupplyController or Owner");
408         require(_newSupplyController != address(0), "cannot set supply controller to address zero");
409         emit SupplyControllerSet(supplyController, _newSupplyController);
410         supplyController = _newSupplyController;
411     }
412 
413     modifier onlySupplyController() {
414         require(msg.sender == supplyController, "onlySupplyController");
415         _;
416     }
417 
418     /**
419      * @dev Increases the total supply by minting the specified number of tokens to the supply controller account.
420      * @param _value The number of tokens to add.
421      * @return A boolean that indicates if the operation was successful.
422      */
423     function increaseSupply(uint256 _value) public onlySupplyController returns (bool success) {
424         totalSupply_ = totalSupply_.add(_value);
425         balances[supplyController] = balances[supplyController].add(_value);
426         emit SupplyIncreased(supplyController, _value);
427         emit Transfer(address(0), supplyController, _value);
428         return true;
429     }
430 
431     /**
432      * @dev Decreases the total supply by burning the specified number of tokens from the supply controller account.
433      * @param _value The number of tokens to remove.
434      * @return A boolean that indicates if the operation was successful.
435      */
436     function decreaseSupply(uint256 _value) public onlySupplyController returns (bool success) {
437         require(_value <= balances[supplyController], "not enough supply");
438         balances[supplyController] = balances[supplyController].sub(_value);
439         totalSupply_ = totalSupply_.sub(_value);
440         emit SupplyDecreased(supplyController, _value);
441         emit Transfer(supplyController, address(0), _value);
442         return true;
443     }
444 }