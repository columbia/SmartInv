1 /**
2  *  CE7.sol v1.0.0
3  * 
4  *  Bilal Arif - https://twitter.com/furusiyya_
5  *  Draglet GbmH
6  */
7 
8 pragma solidity ^0.4.18;
9 
10 library SafeMath {
11   function mul(uint256 a, uint256 b) pure internal returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) pure internal returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) pure internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) pure internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) pure internal returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) pure internal returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) pure internal returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) pure internal returns (uint256) {
46     return a < b ? a : b;
47   }
48 
49 }
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() public {
65     owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));      
84     owner = newOwner;
85   }
86 
87 }
88 
89 contract Pausable is Ownable {
90   
91   event Pause(bool indexed state);
92 
93   bool private paused = false;
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is not paused.
97    */
98   modifier whenNotPaused() {
99     require(!paused);
100     _;
101   }
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is paused.
105    */
106   modifier whenPaused() {
107     require(paused);
108     _;
109   }
110 
111   /**
112    * @dev return the current state of contract
113    */
114   function Paused() external constant returns(bool){ return paused; }
115 
116   /**
117    * @dev called by the owner to pause or unpause, triggers stopped state
118    * on first call and returns to normal state on second call
119    */
120   function tweakState() external onlyOwner {
121     paused = !paused;
122     Pause(paused);
123   }
124 
125 }
126 
127 contract ReentrancyGuard {
128 
129   /**
130    * @dev We use a single lock for the whole contract.
131    */
132   bool private rentrancy_lock = false;
133 
134   /**
135    * @dev Prevents a contract from calling itself, directly or indirectly.
136    * @notice If you mark a function `nonReentrant`, you should also
137    * mark it `external`. Calling one nonReentrant function from
138    * another is not supported. Instead, you can implement a
139    * `private` function doing the actual work, and a `external`
140    * wrapper marked as `nonReentrant`.
141    */
142   modifier nonReentrant() {
143     require(!rentrancy_lock);
144     rentrancy_lock = true;
145     _;
146     rentrancy_lock = false;
147   }
148 
149 }
150 
151 contract CE7 is Pausable, ReentrancyGuard {
152 
153   using SafeMath for *;
154 
155   string constant public name = "ACT Curation Engine";
156   string constant public symbol = "CE7";
157   uint8 constant public decimals = 4;
158   uint256 private supply = 10e6 * 1e4; // 10 Million + 4 decimals
159   string constant public version = "v1.0.0";
160 
161   mapping(address => uint256) private balances;
162   mapping (address => mapping (address => uint256)) private allowed;
163 
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165   event Transfer(address indexed from, address indexed to, uint256 value);
166 
167   function CE7() public {
168     owner = msg.sender;
169     balances[msg.sender] = supply;
170   }
171 
172 
173   /** Externals **/
174 
175   /**
176   * @dev transfer token for a specified address
177   * @param _to The address to transfer to.
178   * @param _value The amount to be transferred.
179   */
180   function transfer(address _to, uint256 _value) external whenNotPaused onlyPayloadSize(2 * 32) returns (bool) {
181     require(_to != address(0));
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) external constant returns (uint256 balance) {
194     return balances[_owner];
195   }
196 
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(address _from, address _to, uint256 _value) external whenNotPaused returns (bool) {
204     require(_to != address(0));
205 
206     uint256 _allowance = allowed[_from][msg.sender];
207 
208     balances[_from] = balances[_from].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     allowed[_from][msg.sender] = _allowance.sub(_value);
211     Transfer(_from, _to, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    *
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) external whenNotPaused returns (bool) {
226     allowed[msg.sender][_spender] = _value;
227     Approval(msg.sender, _spender, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Function to check the amount of tokens that an owner allowed to a spender.
233    * @param _owner address The address which owns the funds.
234    * @param _spender address The address which will spend the funds.
235    * @return A uint256 specifying the amount of tokens still available for the spender.
236    */
237   function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
238     return allowed[_owner][_spender];
239   }
240 
241   /**
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    */
247   function increaseApproval (address _spender, uint _addedValue) external whenNotPaused returns (bool success) {
248     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   function decreaseApproval (address _spender, uint _subtractedValue) external whenNotPaused returns (bool success) {
254     uint oldValue = allowed[msg.sender][_spender];
255     if (_subtractedValue > oldValue) {
256       allowed[msg.sender][_spender] = 0;
257     } else {
258       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259     }
260     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264   function totalSupply() public constant returns (uint256) {
265     return supply;
266   }
267 
268   /**
269    *                  ========== Token migration support ========
270    */
271   uint256 public totalMigrated;
272   bool private upgrading = false;
273   MigrationAgent private agent;
274   event Migrate(address indexed _from, address indexed _to, uint256 _value);
275   event Upgrading(bool status);
276 
277   function migrationAgent() external constant returns(address) { return agent; }
278   function upgradingEnabled()  external constant returns(bool) { return upgrading; }
279 
280   /**
281    * @notice Migrate tokens to the new token contract.
282    * @dev Required state: Operational Migration
283    * @param _value The amount of token to be migrated
284    */   
285   function migrate(uint256 _value) external nonReentrant isUpgrading {
286     require(_value > 0);
287     require(_value <= balances[msg.sender]);
288     require(agent.isMigrationAgent());
289 
290     balances[msg.sender] = balances[msg.sender].sub(_value);
291     supply = supply.sub(_value);
292     totalMigrated = totalMigrated.add(_value);
293     
294     if (!agent.migrateFrom(msg.sender, _value)) {
295       revert();
296     }
297     Migrate(msg.sender, agent, _value);
298   }
299 
300   /**
301    * @notice Set address of migration target contract and enable migration
302    * process.
303    * @param _agent The address of the MigrationAgent contract
304    */
305   function setMigrationAgent(address _agent) external isUpgrading onlyOwner {
306     require(_agent != 0x00);
307     agent = MigrationAgent(_agent);
308     if (!agent.isMigrationAgent()) {
309       revert();
310     }
311     
312     if (agent.originalSupply() != supply) {
313       revert();
314     }
315   }
316 
317   /**
318    * @notice Enable upgrading to allow tokens migration to new contract
319    * process.
320    */
321   function tweakUpgrading() external onlyOwner {
322       upgrading = !upgrading;
323       Upgrading(upgrading);
324   }
325 
326 
327   /** Interface marker */
328   function isTokenContract() external pure returns (bool) {
329     return true;
330   }
331 
332   modifier isUpgrading() { 
333     require(upgrading); 
334     _; 
335   }
336 
337 
338   /**
339    * Fix for the ERC20 short address attack
340    *
341    * http://vessenes.com/the-erc20-short-address-attack-explained/
342    */
343   modifier onlyPayloadSize(uint size) {
344      require(msg.data.length == size + 4);
345      _;
346   }
347 
348   function () external {
349     //if ether is sent to this address, send it back.
350     revert();
351   }
352   
353 }
354 
355 /// @title Migration Agent interface
356 contract MigrationAgent {
357 
358   uint256 public originalSupply;
359   
360   function migrateFrom(address _from, uint256 _value) external returns(bool);
361   
362   /** Interface marker */
363   function isMigrationAgent() external pure returns (bool) {
364     return true;
365   }
366 }