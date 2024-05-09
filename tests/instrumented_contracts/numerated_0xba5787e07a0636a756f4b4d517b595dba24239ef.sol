1 /**
2  *  NotaryPlatformToken.sol v1.0.0
3  * 
4  *  Bilal Arif - https://twitter.com/furusiyya_
5  *  Notary Platform
6  */
7 
8 pragma solidity ^0.4.16;
9 
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16     
17     function div(uint256 a, uint256 b) internal constant returns (uint256) {
18         uint256 c = a / b;
19         return c;
20     }
21     
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26     
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 contract Ownable {
34      /*
35       @title Ownable
36       @dev The Ownable contract has an owner address, and provides basic authorization control
37       functions, this simplifies the implementation of "user permissions".
38     */
39 
40   address public owner;
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable(address _owner){
49     owner = _owner;
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) onlyOwner public {
57     require(newOwner != address(0));
58     OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61   
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 }
71 contract ReentrancyGuard {
72 
73   /**
74    * @dev We use a single lock for the whole contract.
75    */
76   bool private rentrancy_lock = false;
77 
78   /**
79    * @dev Prevents a contract from calling itself, directly or indirectly.
80    * @notice If you mark a function `nonReentrant`, you should also
81    * mark it `external`. Calling one nonReentrant function from
82    * another is not supported. Instead, you can implement a
83    * `private` function doing the actual work, and a `external`
84    * wrapper marked as `nonReentrant`.
85    */
86   modifier nonReentrant() {
87     require(!rentrancy_lock);
88     rentrancy_lock = true;
89     _;
90     rentrancy_lock = false;
91   }
92 
93 }
94 contract Pausable is Ownable {
95   
96   event Pause(bool indexed state);
97 
98   bool private paused = false;
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev return the current state of contract
118    */
119   function Paused() external constant returns(bool){ return paused; }
120 
121   /**
122    * @dev called by the owner to pause or unpause, triggers stopped state
123    * on first call and returns to normal state on second call
124    */
125   function tweakState() external onlyOwner {
126     paused = !paused;
127     Pause(paused);
128   }
129 
130 }
131 contract Allocations{
132 
133 	// timestamp when token release is enabled
134   	uint256 private releaseTime;
135 
136 	mapping (address => uint256) private allocations;
137 
138 	function Allocations(){
139 		releaseTime = now + 200 days;
140 		allocate();
141 	}
142 
143 	/**
144 	 * @notice NTRY Token distribution between team members.
145 	 */
146     function allocate() private {
147       allocations[0xab1cb1740344A9280dC502F3B8545248Dc3045eA] = 4000000 * 1 ether;
148       allocations[0x330709A59Ab2D1E1105683F92c1EE8143955a357] = 4000000 * 1 ether;
149       allocations[0xAa0887fc6e8896C4A80Ca3368CFd56D203dB39db] = 3000000 * 1 ether;
150       allocations[0x1fbA1d22435DD3E7Fa5ba4b449CC550a933E72b3] = 200000 * 1 ether;
151       allocations[0xC9d5E2c7e40373ae576a38cD7e62E223C95aBFD4] = 200000 * 1 ether;
152       allocations[0xabc0B64a38DE4b767313268F0db54F4cf8816D9C] = 220000 * 1 ether;
153       allocations[0x5d85bCDe5060C5Bd00DBeDF5E07F43CE3Ccade6f] = 50000 * 1 ether;
154       allocations[0xecb1b0231CBC0B04015F9e5132C62465C128B578] = 500000 * 1 ether;
155       allocations[0xFF22FA2B3e5E21817b02a45Ba693B7aC01485a9C] = 2955000 * 1 ether;
156     }
157 
158 	/**
159 	 * @notice Transfers tokens held by timelock to beneficiary.
160 	 */
161 	function release() internal returns (uint256 amount){
162 		amount = allocations[msg.sender];
163 		allocations[msg.sender] = 0;
164 		return amount;
165 	}
166 
167 	/**
168   	 * @dev returns releaseTime
169   	 */
170 	function RealeaseTime() external constant returns(uint256){ return releaseTime; }
171 
172     modifier timeLock() { 
173 		require(now >= releaseTime);
174 		_; 
175 	}
176 
177 	modifier isTeamMember() { 
178 		require(allocations[msg.sender] >= 10000 * 1 ether); 
179 		_; 
180 	}
181 
182 }
183 
184 
185 contract NotaryPlatformToken is Pausable, Allocations, ReentrancyGuard{
186 
187   using SafeMath for uint256;
188 
189   string constant name = "Notary Platform Token";
190   string constant symbol = "NTRY";
191   uint8 constant decimals = 18;
192   uint256 totalSupply = 150000000 * 1 ether;
193 
194   mapping(address => uint256) private balances;
195   mapping (address => mapping (address => uint256)) private allowed;
196 
197   event Approval(address indexed owner, address indexed spender, uint256 value);
198   event Transfer(address indexed from, address indexed to, uint256 value);
199 
200   function NotaryPlatformToken() Ownable(0x1538EF80213cde339A333Ee420a85c21905b1b2D){
201     // Allocate initial balance to the owner //
202     balances[0x244092a2FECFC48259cf810b63BA3B3c0B811DCe] = 134875000 * 1 ether;  
203   }
204 
205 
206   /** Externals **/
207 
208   /**
209   * @dev transfer token for a specified address
210   * @param _to The address to transfer to.
211   * @param _value The amount to be transferred.
212   */
213   function transfer(address _to, uint256 _value) external whenNotPaused onlyPayloadSize(2 * 32) returns (bool) {
214     require(_to != address(0));
215     balances[msg.sender] = balances[msg.sender].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     Transfer(msg.sender, _to, _value);
218     return true;
219   }
220 
221   /**
222   * @dev Gets the balance of the specified address.
223   * @param _owner The address to query the the balance of.
224   * @return An uint256 representing the amount owned by the passed address.
225   */
226   function balanceOf(address _owner) external constant returns (uint256 balance) {
227     return balances[_owner];
228   }
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amount of tokens to be transferred
235    */
236   function transferFrom(address _from, address _to, uint256 _value) external whenNotPaused returns (bool) {
237     require(_to != address(0));
238 
239     uint256 _allowance = allowed[_from][msg.sender];
240 
241     balances[_from] = balances[_from].sub(_value);
242     balances[_to] = balances[_to].add(_value);
243     allowed[_from][msg.sender] = _allowance.sub(_value);
244     Transfer(_from, _to, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
250    *
251    * Beware that changing an allowance with this method brings the risk that someone may use both the old
252    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    * @param _spender The address which will spend the funds.
256    * @param _value The amount of tokens to be spent.
257    */
258   function approve(address _spender, uint256 _value) external whenNotPaused returns (bool) {
259     allowed[msg.sender][_spender] = _value;
260     Approval(msg.sender, _spender, _value);
261     return true;
262   }
263 
264   /**
265    * @dev Function to check the amount of tokens that an owner allowed to a spender.
266    * @param _owner address The address which owns the funds.
267    * @param _spender address The address which will spend the funds.
268    * @return A uint256 specifying the amount of tokens still available for the spender.
269    */
270   function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
271     return allowed[_owner][_spender];
272   }
273 
274   /**
275    * approve should be called when allowed[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    */
280   function increaseApproval (address _spender, uint _addedValue) external whenNotPaused returns (bool success) {
281     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
282     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   function decreaseApproval (address _spender, uint _subtractedValue) external whenNotPaused returns (bool success) {
287     uint oldValue = allowed[msg.sender][_spender];
288     if (_subtractedValue > oldValue) {
289       allowed[msg.sender][_spender] = 0;
290     } else {
291       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
292     }
293     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294     return true;
295   }
296 
297   /**
298   * @notice Transfers tokens held by timelock to beneficiary.
299   */
300   function claim() external whenNotPaused nonReentrant timeLock isTeamMember {
301     balances[msg.sender] = balances[msg.sender].add(release());
302   }
303 
304   /**
305    *                  ========== Token migration support ========
306    */
307   uint256 public totalMigrated;
308   bool private upgrading = false;
309   MigrationAgent private agent;
310   event Migrate(address indexed _from, address indexed _to, uint256 _value);
311   event Upgrading(bool status);
312 
313   function migrationAgent() external constant returns(address){ return agent; }
314   function upgradingEnabled()  external constant returns(bool){ return upgrading; }
315 
316   /**
317    * @notice Migrate tokens to the new token contract.
318    * @dev Required state: Operational Migration
319    * @param _value The amount of token to be migrated
320    */
321   function migrate(uint256 _value) external nonReentrant isUpgrading {
322     require(_value > 0);
323     require(_value <= balances[msg.sender]);
324     require(agent.isMigrationAgent());
325 
326     balances[msg.sender] = balances[msg.sender].sub(_value);
327     totalSupply = totalSupply.sub(_value);
328     totalMigrated = totalMigrated.add(_value);
329     
330     if(!agent.migrateFrom(msg.sender, _value)){
331       revert();
332     }
333     Migrate(msg.sender, agent, _value);
334   }
335 
336   /**
337    * @notice Set address of migration target contract and enable migration
338    * process.
339    * @param _agent The address of the MigrationAgent contract
340    */
341   function setMigrationAgent(address _agent) external isUpgrading onlyOwner {
342     require(_agent != 0x00);
343     agent = MigrationAgent(_agent);
344     if(!agent.isMigrationAgent()){
345       revert();
346     }
347     
348     if(agent.originalSupply() != totalSupply){
349       revert();
350     }
351   }
352 
353   /**
354    * @notice Enable upgrading to allow tokens migration to new contract
355    * process.
356    */
357   function tweakUpgrading() external onlyOwner{
358       upgrading = !upgrading;
359       Upgrading(upgrading);
360   }
361 
362 
363   /** Interface marker */
364   function isTokenContract() external constant returns (bool) {
365     return true;
366   }
367 
368   modifier isUpgrading() { 
369     require(upgrading); 
370     _; 
371   }
372 
373 
374   /**
375    * Fix for the ERC20 short address attack
376    *
377    * http://vessenes.com/the-erc20-short-address-attack-explained/
378    */
379   modifier onlyPayloadSize(uint size) {
380      require(msg.data.length > size + 4);
381      _;
382   }
383 
384   function () {
385     //if ether is sent to this address, send it back.
386     revert();
387   }
388 
389 }
390 
391 /// @title Migration Agent interface
392 contract MigrationAgent {
393 
394   uint256 public originalSupply;
395   
396   function migrateFrom(address _from, uint256 _value) external returns(bool);
397   
398   /** Interface marker */
399   function isMigrationAgent() external constant returns (bool) {
400     return true;
401   }
402 }