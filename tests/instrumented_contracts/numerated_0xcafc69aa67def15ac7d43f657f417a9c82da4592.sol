1 pragma solidity ^0.4.24;
2 pragma experimental "v0.5.0";
3 
4 
5 library SafeMath {
6     /**
7     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
8     */
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10         require(b <= a);
11         uint256 c = a - b;
12 
13         return c;
14     }
15 
16     /**
17     * @dev Adds two numbers, reverts on overflow.
18     */
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a);
22 
23         return c;
24     }
25 }
26 
27 /**
28  * @title TrueCNY
29  */
30 contract TrueCNY {
31 
32     /**
33      * MATH
34      */
35 
36     using SafeMath for uint256;
37    
38     /**
39      * DATA
40      */
41 
42     // INITIALIZATION DATA
43     bool private initialized = false;
44 
45     // ERC20 BASIC DATA
46     mapping(address => uint256) internal balances;
47     uint256 internal totalSupply_;
48     string public constant name = "TrueCNY"; // solium-disable-line uppercase
49     string public constant symbol = "TCNY"; // solium-disable-line uppercase
50     uint8 public constant decimals = 18; // solium-disable-line uppercase
51 
52     // ERC20 DATA
53     mapping (address => mapping (address => uint256)) internal allowed;
54 
55     // OWNER DATA
56     address public owner;
57 
58     // PAUSABILITY DATA
59     bool public paused = false;
60 
61     // LAW ENFORCEMENT DATA
62     address public lawEnforcementRole;
63     mapping(address => bool) internal frozen;
64 
65     // SUPPLY CONTROL DATA
66     address public supplyController;
67 
68     /**
69      * EVENTS
70      */
71 
72     // ERC20 BASIC EVENTS
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     // ERC20 EVENTS
76     event Approval(
77         address indexed owner,
78         address indexed spender,
79         uint256 value
80     );
81 
82     // OWNABLE EVENTS
83     event OwnershipTransferred(
84         address indexed oldOwner,
85         address indexed newOwner
86     );
87 
88     // PAUSABLE EVENTS
89     event Pause();
90     event Unpause();
91 
92     // LAW ENFORCEMENT EVENTS
93     event AddressFrozen(address indexed addr);
94     event AddressUnfrozen(address indexed addr);
95     event FrozenAddressWiped(address indexed addr);
96     event LawEnforcementRoleSet (
97         address indexed oldLawEnforcementRole,
98         address indexed newLawEnforcementRole
99     );
100 
101     // SUPPLY CONTROL EVENTS
102     event SupplyIncreased(address indexed to, uint256 value);
103     event SupplyDecreased(address indexed from, uint256 value);
104     event SupplyControllerSet(
105         address indexed oldSupplyController,
106         address indexed newSupplyController
107     );
108 
109     /**
110      * FUNCTIONALITY
111      */
112 
113     // INITIALIZATION FUNCTIONALITY
114 
115     /**
116      * @dev sets 0 initials tokens, the owner, and the supplyController.
117      * this serves as the constructor for the proxy but compiles to the
118      * memory model of the Implementation contract.
119      */
120     function initialize() public {
121         require(!initialized, "already initialized");
122         owner = msg.sender;
123         lawEnforcementRole = address(0);
124         totalSupply_ = 0;
125         supplyController = msg.sender;
126         initialized = true;
127     }
128 
129     /**
130      * The constructor is used here to ensure that the implementation
131      * contract is initialized. An uncontrolled implementation
132      * contract might lead to misleading state
133      * for users who accidentally interact with it.
134      */
135     constructor() public {
136         initialize();
137         pause();
138     }
139     
140 
141     // ERC20 BASIC FUNCTIONALITY
142 
143     /**
144     * @dev Total number of tokens in existence
145     */
146     function totalSupply() public view returns (uint256) {
147         return totalSupply_;
148     }
149 
150     /**
151     * @dev Transfer token for a specified address
152     * @param _to The address to transfer to.
153     * @param _value The amount to be transferred.
154     */
155     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
156         require(_to != address(0), "cannot transfer to address zero");
157         require(!frozen[_to] && !frozen[msg.sender], "address frozen");
158         require(_value <= balances[msg.sender], "insufficient funds");
159 
160         balances[msg.sender] = balances[msg.sender].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         emit Transfer(msg.sender, _to, _value);
163         return true;
164     }
165 
166     /**
167     * @dev Gets the balance of the specified address.
168     * @param _addr The address to query the the balance of.
169     * @return An uint256 representing the amount owned by the passed address.
170     */
171     function balanceOf(address _addr) public view returns (uint256) {
172         return balances[_addr];
173     }
174 
175     // ERC20 FUNCTIONALITY
176 
177     /**
178      * @dev Transfer tokens from one address to another
179      * @param _from address The address which you want to send tokens from
180      * @param _to address The address which you want to transfer to
181      * @param _value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(
184         address _from,
185         address _to,
186         uint256 _value
187     )
188     public
189     whenNotPaused
190     returns (bool)
191     {
192         require(_to != address(0), "cannot transfer to address zero");
193         require(!frozen[_to] && !frozen[_from] && !frozen[msg.sender], "address frozen");
194         require(_value <= balances[_from], "insufficient funds");
195         require(_value <= allowed[_from][msg.sender], "insufficient allowance");
196 
197         balances[_from] = balances[_from].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200         emit Transfer(_from, _to, _value);
201         return true;
202     }
203 
204     /**
205      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206      * Beware that changing an allowance with this method brings the risk that someone may use both the old
207      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      * @param _spender The address which will spend the funds.
211      * @param _value The amount of tokens to be spent.
212      */
213     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
214         require(!frozen[_spender] && !frozen[msg.sender], "address frozen");
215         allowed[msg.sender][_spender] = _value;
216         emit Approval(msg.sender, _spender, _value);
217         return true;
218     }
219 
220     /**
221      * @dev Function to check the amount of tokens that an owner allowed to a spender.
222      * @param _owner address The address which owns the funds.
223      * @param _spender address The address which will spend the funds.
224      * @return A uint256 specifying the amount of tokens still available for the spender.
225      */
226     function allowance(
227         address _owner,
228         address _spender
229     )
230     public
231     view
232     returns (uint256)
233     {
234         return allowed[_owner][_spender];
235     }
236 
237     // OWNER FUNCTIONALITY
238 
239     /**
240      * @dev Throws if called by any account other than the owner.
241      */
242     modifier onlyOwner() {
243         require(msg.sender == owner, "onlyOwner");
244         _;
245     }
246 
247     /**
248      * @dev Allows the current owner to transfer control of the contract to a newOwner.
249      * @param _newOwner The address to transfer ownership to.
250      */
251     function transferOwnership(address _newOwner) public onlyOwner {
252         require(_newOwner != address(0), "cannot transfer ownership to address zero");
253         emit OwnershipTransferred(owner, _newOwner);
254         owner = _newOwner;
255     }
256 
257     // PAUSABILITY FUNCTIONALITY
258 
259     /**
260      * @dev Modifier to make a function callable only when the contract is not paused.
261      */
262     modifier whenNotPaused() {
263         require(!paused, "whenNotPaused");
264         _;
265     }
266 
267     /**
268      * @dev called by the owner to pause, triggers stopped state
269      */
270     function pause() public onlyOwner {
271         require(!paused, "already paused");
272         paused = true;
273         emit Pause();
274     }
275 
276     /**
277      * @dev called by the owner to unpause, returns to normal state
278      */
279     function unpause() public onlyOwner {
280         require(paused, "already unpaused");
281         paused = false;
282         emit Unpause();
283     }
284 
285     // LAW ENFORCEMENT FUNCTIONALITY
286 
287     /**
288      * @dev Sets a new law enforcement role address.
289      * @param _newLawEnforcementRole The new address allowed to freeze/unfreeze addresses and seize their tokens.
290      */
291     function setLawEnforcementRole(address _newLawEnforcementRole) public {
292         require(msg.sender == lawEnforcementRole || msg.sender == owner, "only lawEnforcementRole or Owner");
293         emit LawEnforcementRoleSet(lawEnforcementRole, _newLawEnforcementRole);
294         lawEnforcementRole = _newLawEnforcementRole;
295     }
296 
297     modifier onlyLawEnforcementRole() {
298         require(msg.sender == lawEnforcementRole, "onlyLawEnforcementRole");
299         _;
300     }
301 
302     /**
303      * @dev Freezes an address balance from being transferred.
304      * @param _addr The new address to freeze.
305      */
306     function freeze(address _addr) public onlyLawEnforcementRole {
307         require(!frozen[_addr], "address already frozen");
308         frozen[_addr] = true;
309         emit AddressFrozen(_addr);
310     }
311 
312     /**
313      * @dev Unfreezes an address balance allowing transfer.
314      * @param _addr The new address to unfreeze.
315      */
316     function unfreeze(address _addr) public onlyLawEnforcementRole {
317         require(frozen[_addr], "address already unfrozen");
318         frozen[_addr] = false;
319         emit AddressUnfrozen(_addr);
320     }
321 
322     /**
323      * @dev Wipes the balance of a frozen address, burning the tokens
324      * and setting the approval to zero.
325      * @param _addr The new frozen address to wipe.
326      */
327     function wipeFrozenAddress(address _addr) public onlyLawEnforcementRole {
328         require(frozen[_addr], "address is not frozen");
329         uint256 _balance = balances[_addr];
330         balances[_addr] = 0;
331         totalSupply_ = totalSupply_.sub(_balance);
332         emit FrozenAddressWiped(_addr);
333         emit SupplyDecreased(_addr, _balance);
334         emit Transfer(_addr, address(0), _balance);
335     }
336 
337     /**
338     * @dev Gets the balance of the specified address.
339     * @param _addr The address to check if frozen.
340     * @return A bool representing whether the given address is frozen.
341     */
342     function isFrozen(address _addr) public view returns (bool) {
343         return frozen[_addr];
344     }
345 
346     // SUPPLY CONTROL FUNCTIONALITY
347 
348     /**
349      * @dev Sets a new supply controller address.
350      * @param _newSupplyController The address allowed to burn/mint tokens to control supply.
351      */
352     function setSupplyController(address _newSupplyController) public {
353         require(msg.sender == supplyController || msg.sender == owner, "only SupplyController or Owner");
354         require(_newSupplyController != address(0), "cannot set supply controller to address zero");
355         emit SupplyControllerSet(supplyController, _newSupplyController);
356         supplyController = _newSupplyController;
357     }
358 
359     modifier onlySupplyController() {
360         require(msg.sender == supplyController, "onlySupplyController");
361         _;
362     }
363 
364     /**
365      * @dev Increases the total supply by minting the specified number of tokens to the supply controller account.
366      * @param _value The number of tokens to add.
367      * @return A boolean that indicates if the operation was successful.
368      */
369     function increaseSupply(uint256 _value) public onlySupplyController returns (bool success) {
370         totalSupply_ = totalSupply_.add(_value);
371         balances[supplyController] = balances[supplyController].add(_value);
372         emit SupplyIncreased(supplyController, _value);
373         emit Transfer(address(0), supplyController, _value);
374         return true;
375     }
376 
377     /**
378      * @dev Decreases the total supply by burning the specified number of tokens from the supply controller account.
379      * @param _value The number of tokens to remove.
380      * @return A boolean that indicates if the operation was successful.
381      */
382     function decreaseSupply(uint256 _value) public onlySupplyController returns (bool success) {
383         require(_value <= balances[supplyController], "not enough supply");
384         balances[supplyController] = balances[supplyController].sub(_value);
385         totalSupply_ = totalSupply_.sub(_value);
386         emit SupplyDecreased(supplyController, _value);
387         emit Transfer(supplyController, address(0), _value);
388         return true;
389     }
390 }