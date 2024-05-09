1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract ReentrancyGuard {
18   /**
19    * @dev We use a single lock for the whole contract.
20    */
21   bool private rentrancy_lock = false;
22 
23   /**
24    * @dev Prevents a contract from calling itself, directly or indirectly.
25    * @notice If you mark a function `nonReentrant`, you should also
26    * mark it `external`. Calling one nonReentrant function from
27    * another is not supported. Instead, you can implement a
28    * `private` function doing the actual work, and a `external`
29    * wrapper marked as `nonReentrant`.
30    */
31   modifier nonReentrant() {
32     require(!rentrancy_lock);
33     rentrancy_lock = true;
34     _;
35     rentrancy_lock = false;
36   }
37 }
38 
39 contract AccessControl {
40   /// @dev Emited when contract is upgraded
41   event ContractUpgrade(address newContract);
42 
43   address public owner;
44 
45   // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
46   bool public paused = false;
47 
48   /**
49    * @dev The AccessControl constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function AccessControl() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     owner = newOwner;
71   }
72 
73   /// @dev Modifier to allow actions only when the contract IS NOT paused
74   modifier whenNotPaused() {
75     require(!paused);
76     _;
77   }
78 
79   /// @dev Modifier to allow actions only when the contract IS paused
80   modifier whenPaused() {
81     require(paused);
82     _;
83   }
84 
85   /// @dev Called by owner role to pause the contract. Used only when
86   ///  a bug or exploit is detected and we need to limit damage.
87   function pause() external onlyOwner whenNotPaused {
88     paused = true;
89   }
90 
91   /// @dev Unpauses the smart contract. Can only be called owner.
92   /// @notice This is public rather than external so it can be called by
93   ///  derived contracts.
94   function unpause() public onlyOwner whenPaused {
95     // can't unpause if contract was upgraded
96     paused = false;
97   }
98 }
99 
100 library SafeMath {
101   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102     uint256 c = a * b;
103     assert(a == 0 || c / a == b);
104     return c;
105   }
106 
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   function add(uint256 a, uint256 b) internal pure returns (uint256) {
120     uint256 c = a + b;
121     assert(c >= a);
122     return c;
123   }
124 }
125 
126 contract BasicToken is AccessControl, ERC20Basic {
127   using SafeMath for uint256;
128 
129   mapping(address => uint256) balances;
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     emit Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public constant returns (uint256 balance) {
149     return balances[_owner];
150   }
151 }
152 
153 contract StandardToken is ERC20, BasicToken {
154   mapping (address => mapping (address => uint256)) allowed;
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amout of tokens to be transfered
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
163     uint256 _allowance = allowed[_from][msg.sender];
164 
165     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
166     // require (_value <= _allowance);
167 
168     balances[_to] = balances[_to].add(_value);
169     balances[_from] = balances[_from].sub(_value);
170     allowed[_from][msg.sender] = _allowance.sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
181     // To change the approve amount you first have to reduce the addresses`
182     //  allowance to zero by calling `approve(_spender, 0)` if it is not
183     //  already 0 to mitigate the race condition described here:
184     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
186 
187     allowed[msg.sender][_spender] = _value;
188     emit Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifing the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
199     return allowed[_owner][_spender];
200   }
201 }
202 
203 contract LockableToken is StandardToken, ReentrancyGuard {
204   struct LockedBalance {
205     address owner;
206     uint256 value;
207     uint256 releaseTime;
208   }
209 
210   mapping (uint => LockedBalance) public lockedBalances;
211   uint public lockedBalanceCount;
212 
213   event TransferLockedToken(address indexed from, address indexed to, uint256 value, uint256 releaseTime);
214   event ReleaseLockedBalance(address indexed owner, uint256 value, uint256 releaseTime);
215 
216   /**
217   * @dev transfer and lock token for a specified address
218   * @param _to The address to transfer to.
219   * @param _value The amount to be transferred.
220   * @param _releaseTime The time to be locked.
221   */
222   function transferLockedToken(address _to, uint256 _value, uint256 _releaseTime) public whenNotPaused nonReentrant returns (bool) {
223     require(_releaseTime > now);
224     //require(_releaseTime.sub(1 years) < now);
225     balances[msg.sender] = balances[msg.sender].sub(_value);
226     lockedBalances[lockedBalanceCount] = LockedBalance({owner: _to, value: _value, releaseTime: _releaseTime});
227     lockedBalanceCount++;
228     emit TransferLockedToken(msg.sender, _to, _value, _releaseTime);
229     return true;
230   }
231 
232   /**
233   * @dev Gets the locked balance of the specified address.
234   * @param _owner The address to query the the locked balance of.
235   * @return An uint256 representing the amount owned by the passed address.
236   */
237   function lockedBalanceOf(address _owner) public constant returns (uint256 value) {
238     for (uint i = 0; i < lockedBalanceCount; i++) {
239       LockedBalance storage lockedBalance = lockedBalances[i];
240       if (_owner == lockedBalance.owner) {
241         value = value.add(lockedBalance.value);
242       }
243     }
244     return value;
245   }
246 
247   /**
248   * @dev Release the locked balance if its releaseTime arrived.
249   * @return An uint256 representing the amount.
250   */
251   function releaseLockedBalance() public whenNotPaused returns (uint256 releaseAmount) {
252     uint index = 0;
253     while (index < lockedBalanceCount) {
254       if (now >= lockedBalances[index].releaseTime) {
255         releaseAmount += lockedBalances[index].value;
256         unlockBalanceByIndex(index);
257       } else {
258         index++;
259       }
260     }
261     return releaseAmount;
262   }
263 
264   function unlockBalanceByIndex(uint index) internal {
265     LockedBalance storage lockedBalance = lockedBalances[index];
266     balances[lockedBalance.owner] = balances[lockedBalance.owner].add(lockedBalance.value);
267     emit ReleaseLockedBalance(lockedBalance.owner, lockedBalance.value, lockedBalance.releaseTime);
268     lockedBalances[index] = lockedBalances[lockedBalanceCount - 1];
269     delete lockedBalances[lockedBalanceCount - 1];
270     lockedBalanceCount--;
271   }
272 }
273 
274 contract ReleaseableToken is LockableToken {
275   uint256 public createTime;
276   uint256 public nextReleaseTime;
277   uint256 public nextReleaseAmount;
278   uint256 standardDecimals = 10000;
279   uint256 public totalSupply;
280   uint256 public releasedSupply;
281 
282   function ReleaseableToken(uint256 initialSupply, uint256 initReleasedSupply, uint256 firstReleaseAmount) public {
283     createTime = now;
284     nextReleaseTime = now;
285     nextReleaseAmount = firstReleaseAmount;
286     totalSupply = standardDecimals.mul(initialSupply);
287     releasedSupply = standardDecimals.mul(initReleasedSupply);
288     balances[msg.sender] = standardDecimals.mul(initReleasedSupply);
289   }
290 
291   /**
292   * @dev Release a part of the frozen token(totalSupply - releasedSupply) every 26 weeks.
293   * @return An uint256 representing the amount.
294   */
295   function release() public whenNotPaused returns(uint256 _releaseAmount) {
296     require(nextReleaseTime <= now);
297 
298     uint256 releaseAmount = 0;
299     uint256 remainderAmount = totalSupply.sub(releasedSupply);
300     if (remainderAmount > 0) {
301       releaseAmount = standardDecimals.mul(nextReleaseAmount);
302       if (releaseAmount > remainderAmount)
303         releaseAmount = remainderAmount;
304       releasedSupply = releasedSupply.add(releaseAmount);
305       balances[owner] = balances[owner].add(releaseAmount);
306       emit Release(msg.sender, releaseAmount, nextReleaseTime);
307       nextReleaseTime = nextReleaseTime.add(26 * 1 weeks);
308       nextReleaseAmount = nextReleaseAmount.sub(nextReleaseAmount.div(4));
309     }
310     return releaseAmount;
311   }
312 
313   event Release(address receiver, uint256 amount, uint256 releaseTime);
314 }
315 
316 contract N2Contract is ReleaseableToken {
317   string public name = 'N2Chain';
318   string public symbol = 'N2C';
319   uint8 public decimals = 4;
320 
321   // Set in case the core contract is broken and an upgrade is required
322   address public newContractAddress;
323 
324   function N2Contract() public ReleaseableToken(1000000000, 200000000, 200000000) {}
325 
326   /// @dev Used to mark the smart contract as upgraded, in case there is a serious
327   ///  breaking bug. This method does nothing but keep track of the new contract and
328   ///  emit a message indicating that the new address is set. It's up to clients of this
329   ///  contract to update to the new contract address in that case. (This contract will
330   ///  be paused indefinitely if such an upgrade takes place.)
331   /// @param _v2Address new address
332   function setNewAddress(address _v2Address) external onlyOwner whenPaused {
333     newContractAddress = _v2Address;
334     emit ContractUpgrade(_v2Address);
335   }
336 
337   /// @dev Override unpause so it requires all external contract addresses
338   ///  to be set before contract can be unpaused. Also, we can't have
339   ///  newContractAddress set either, because then the contract was upgraded.
340   /// @notice This is public rather than external so we can call super.unpause
341   ///  without using an expensive CALL.
342   function unpause() public onlyOwner whenPaused {
343     require(newContractAddress == address(0));
344 
345     // Actually unpause the contract.
346     super.unpause();
347   }
348 }