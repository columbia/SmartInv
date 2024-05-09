1 // File: contracts/zeppelin/SafeMath.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11     /**
12     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
13     */
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b <= a);
16         uint256 c = a - b;
17 
18         return c;
19     }
20 
21     /**
22     * @dev Adds two numbers, reverts on overflow.
23     */
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a);
27 
28         return c;
29     }
30 }
31 
32 // File: contracts/ZTUSDImplementation.sol
33 
34 pragma solidity ^0.4.24;
35 pragma experimental "v0.5.0";
36 
37 
38 
39 /**
40  * @title ZTUSDImplementation
41  * @dev this contract is a Pausable ERC20 token with Burn and Mint
42  * controleld by a central SupplyController. By implementing Zap Theory Implementation
43  * this contract also includes external methods for setting
44  * a new implementation contract for the Proxy.
45  * NOTE: The storage defined here will actually be held in the Proxy
46  * contract and all calls to this contract should be made through
47  * the proxy, including admin actions done as owner or supplyController.
48  * Any call to transfer against this contract should fail
49  * with insufficient funds since no tokens will be issued there.
50  */
51 contract ZTUSDImplementation {
52 
53     /**
54      * MATH
55      */
56 
57     using SafeMath for uint256;
58 
59     /**
60      * DATA
61      */
62 
63     // INITIALIZATION DATA
64     bool private initialized = false;
65 
66     // ERC20 BASIC DATA
67     mapping(address => uint256) internal balances;
68     uint256 internal totalSupply_;
69     string public constant name = "ZTUSD"; // solium-disable-line uppercase
70     string public constant symbol = "ZTUSD"; // solium-disable-line uppercase
71     uint8 public constant decimals = 18; // solium-disable-line uppercase
72 
73     // ERC20 DATA
74     mapping (address => mapping (address => uint256)) internal allowed;
75 
76     // OWNER DATA
77     address public owner;
78 
79     // PAUSABILITY DATA
80     bool public paused = false;
81 
82     // EMERGENCY CONTROLLER DATA
83     address public emergencyControllerRole;
84     mapping(address => bool) internal frozen;
85 
86     // SUPPLY CONTROL DATA
87     address public supplyController;
88 
89     /**
90      * EVENTS
91      */
92 
93     // ERC20 BASIC EVENTS
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     // ERC20 EVENTS
97     event Approval(
98         address indexed owner,
99         address indexed spender,
100         uint256 value
101     );
102 
103     // OWNABLE EVENTS
104     event OwnershipTransferred(
105         address indexed oldOwner,
106         address indexed newOwner
107     );
108 
109     // PAUSABLE EVENTS
110     event Pause();
111     event Unpause();
112 
113     // EMERGENCY CONTROLLER EVENTS
114     event AddressFrozen(address indexed addr);
115     event AddressUnfrozen(address indexed addr);
116     event FrozenAddressWiped(address indexed addr);
117     event EmergencyControllerRoleSet (
118         address indexed oldEmergencyControllerRole,
119         address indexed newEmergencyControllerRole
120     );
121 
122     // SUPPLY CONTROL EVENTS
123     event SupplyIncreased(address indexed to, uint256 value);
124     event SupplyDecreased(address indexed from, uint256 value);
125     event SupplyControllerSet(
126         address indexed oldSupplyController,
127         address indexed newSupplyController
128     );
129 
130     /**
131      * FUNCTIONALITY
132      */
133 
134     // INITIALIZATION FUNCTIONALITY
135 
136     /**
137      * @dev sets 0 initials tokens, the owner, and the supplyController.
138      * this serves as the constructor for the proxy but compiles to the
139      * memory model of the Implementation contract.
140      */
141     function initialize() public {
142         require(!initialized, "already initialized");
143         owner = msg.sender;
144         emergencyControllerRole = address(0);
145         totalSupply_ = 0;
146         supplyController = msg.sender;
147         initialized = true;
148     }
149 
150     /**
151      * The constructor is used here to ensure that the implementation
152      * contract is initialized. An uncontrolled implementation
153      * contract might lead to misleading state
154      * for users who accidentally interact with it.
155      */
156     constructor() public {
157         initialize();
158         pause();
159     }
160 
161     // ERC20 BASIC FUNCTIONALITY
162 
163     /**
164     * @dev Total number of tokens in existence
165     */
166     function totalSupply() public view returns (uint256) {
167         return totalSupply_;
168     }
169 
170     /**
171     * @dev Transfer token for a specified address
172     * @param _to The address to transfer to.
173     * @param _value The amount to be transferred.
174     */
175     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
176         require(_to != address(0), "cannot transfer to address zero");
177         require(!frozen[_to] && !frozen[msg.sender], "address frozen");
178         require(_value <= balances[msg.sender], "insufficient funds");
179 
180         balances[msg.sender] = balances[msg.sender].sub(_value);
181         balances[_to] = balances[_to].add(_value);
182         emit Transfer(msg.sender, _to, _value);
183         return true;
184     }
185 
186     /**
187     * @dev Gets the balance of the specified address.
188     * @param _addr The address to query the the balance of.
189     * @return An uint256 representing the amount owned by the passed address.
190     */
191     function balanceOf(address _addr) public view returns (uint256) {
192         return balances[_addr];
193     }
194 
195     // ERC20 FUNCTIONALITY
196 
197     /**
198      * @dev Transfer tokens from one address to another
199      * @param _from address The address which you want to send tokens from
200      * @param _to address The address which you want to transfer to
201      * @param _value uint256 the amount of tokens to be transferred
202      */
203     function transferFrom(
204         address _from,
205         address _to,
206         uint256 _value
207     )
208     public
209     whenNotPaused
210     returns (bool)
211     {
212         require(_to != address(0), "cannot transfer to address zero");
213         require(!frozen[_to] && !frozen[_from] && !frozen[msg.sender], "address frozen");
214         require(_value <= balances[_from], "insufficient funds");
215         require(_value <= allowed[_from][msg.sender], "insufficient allowance");
216 
217         balances[_from] = balances[_from].sub(_value);
218         balances[_to] = balances[_to].add(_value);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220         emit Transfer(_from, _to, _value);
221         return true;
222     }
223 
224     /**
225      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226      * Beware that changing an allowance with this method brings the risk that someone may use both the old
227      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230      * @param _spender The address which will spend the funds.
231      * @param _value The amount of tokens to be spent.
232      */
233     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
234         require(!frozen[_spender] && !frozen[msg.sender], "address frozen");
235         allowed[msg.sender][_spender] = _value;
236         emit Approval(msg.sender, _spender, _value);
237         return true;
238     }
239 
240     /**
241      * @dev Function to check the amount of tokens that an owner allowed to a spender.
242      * @param _owner address The address which owns the funds.
243      * @param _spender address The address which will spend the funds.
244      * @return A uint256 specifying the amount of tokens still available for the spender.
245      */
246     function allowance(
247         address _owner,
248         address _spender
249     )
250     public
251     view
252     returns (uint256)
253     {
254         return allowed[_owner][_spender];
255     }
256 
257     // OWNER FUNCTIONALITY
258 
259     /**
260      * @dev Throws if called by any account other than the owner.
261      */
262     modifier onlyOwner() {
263         require(msg.sender == owner, "onlyOwner");
264         _;
265     }
266 
267     /**
268      * @dev Allows the current owner to transfer control of the contract to a newOwner.
269      * @param _newOwner The address to transfer ownership to.
270      */
271     function transferOwnership(address _newOwner) public onlyOwner {
272         require(_newOwner != address(0), "cannot transfer ownership to address zero");
273         emit OwnershipTransferred(owner, _newOwner);
274         owner = _newOwner;
275     }
276 
277     // PAUSABILITY FUNCTIONALITY
278 
279     /**
280      * @dev Modifier to make a function callable only when the contract is not paused.
281      */
282     modifier whenNotPaused() {
283         require(!paused, "whenNotPaused");
284         _;
285     }
286 
287     /**
288      * @dev called by the owner to pause, triggers stopped state
289      */
290     function pause() public onlyOwner {
291         require(!paused, "already paused");
292         paused = true;
293         emit Pause();
294     }
295 
296     /**
297      * @dev called by the owner to unpause, returns to normal state
298      */
299     function unpause() public onlyOwner {
300         require(paused, "already unpaused");
301         paused = false;
302         emit Unpause();
303     }
304 
305     // EMERGENCY CONTROLLER FUNCTIONALITY
306 
307     /**
308      * @dev Sets a new emergency controller role address.
309      * @param _newEmergencyControllerRole The new address allowed to freeze/unfreeze addresses and seize their tokens.
310      */
311     function setEmergencyControllerRole(address _newEmergencyControllerRole) public {
312         require(msg.sender == emergencyControllerRole || msg.sender == owner, "only emergencyControllerRole or Owner");
313         emit EmergencyControllerRoleSet(emergencyControllerRole, _newEmergencyControllerRole);
314         emergencyControllerRole = _newEmergencyControllerRole;
315     }
316 
317     modifier onlyEmergencyControllerRole() {
318         require(msg.sender == emergencyControllerRole, "onlyEmergencyControllerRole");
319         _;
320     }
321 
322     /**
323      * @dev Freezes an address balance from being transferred.
324      * @param _addr The new address to freeze.
325      */
326     function freeze(address _addr) public onlyEmergencyControllerRole {
327         require(!frozen[_addr], "address already frozen");
328         frozen[_addr] = true;
329         emit AddressFrozen(_addr);
330     }
331 
332     /**
333      * @dev Unfreezes an address balance allowing transfer.
334      * @param _addr The new address to unfreeze.
335      */
336     function unfreeze(address _addr) public onlyEmergencyControllerRole {
337         require(frozen[_addr], "address already unfrozen");
338         frozen[_addr] = false;
339         emit AddressUnfrozen(_addr);
340     }
341 
342     /**
343      * @dev Wipes the balance of a frozen address, burning the tokens
344      * and setting the approval to zero.
345      * @param _addr The new frozen address to wipe.
346      */
347     function wipeFrozenAddress(address _addr) public onlyEmergencyControllerRole {
348         require(frozen[_addr], "address is not frozen");
349         uint256 _balance = balances[_addr];
350         balances[_addr] = 0;
351         totalSupply_ = totalSupply_.sub(_balance);
352         emit FrozenAddressWiped(_addr);
353         emit SupplyDecreased(_addr, _balance);
354         emit Transfer(_addr, address(0), _balance);
355     }
356 
357     /**
358     * @dev Gets the balance of the specified address.
359     * @param _addr The address to check if frozen.
360     * @return A bool representing whether the given address is frozen.
361     */
362     function isFrozen(address _addr) public view returns (bool) {
363         return frozen[_addr];
364     }
365 
366     // SUPPLY CONTROL FUNCTIONALITY
367 
368     /**
369      * @dev Sets a new supply controller address.
370      * @param _newSupplyController The address allowed to burn/mint tokens to control supply.
371      */
372     function setSupplyController(address _newSupplyController) public {
373         require(msg.sender == supplyController || msg.sender == owner, "only SupplyController or Owner");
374         require(_newSupplyController != address(0), "cannot set supply controller to address zero");
375         emit SupplyControllerSet(supplyController, _newSupplyController);
376         supplyController = _newSupplyController;
377     }
378 
379     modifier onlySupplyController() {
380         require(msg.sender == supplyController, "onlySupplyController");
381         _;
382     }
383 
384     /**
385      * @dev Increases the total supply by minting the specified number of tokens to the supply controller account.
386      * @param _value The number of tokens to add.
387      * @return A boolean that indicates if the operation was successful.
388      */
389     function increaseSupply(uint256 _value) public onlySupplyController returns (bool success) {
390         totalSupply_ = totalSupply_.add(_value);
391         balances[supplyController] = balances[supplyController].add(_value);
392         emit SupplyIncreased(supplyController, _value);
393         emit Transfer(address(0), supplyController, _value);
394         return true;
395     }
396 
397     /**
398      * @dev Decreases the total supply by burning the specified number of tokens from the supply controller account.
399      * @param _value The number of tokens to remove.
400      * @return A boolean that indicates if the operation was successful.
401      */
402     function decreaseSupply(uint256 _value) public onlySupplyController returns (bool success) {
403         require(_value <= balances[supplyController], "not enough supply");
404         balances[supplyController] = balances[supplyController].sub(_value);
405         totalSupply_ = totalSupply_.sub(_value);
406         emit SupplyDecreased(supplyController, _value);
407         emit Transfer(supplyController, address(0), _value);
408         return true;
409     }
410 }