1 pragma solidity ^0.5.8;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9 
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14 }
15 
16 
17 interface IERC20 {
18   function balanceOf(address owner) external view returns (uint256 balance);
19   function transfer(address to, uint256 value) external returns (bool success);
20   function transferFrom(address from, address to, uint256 value) external returns (bool success);
21   function approve(address spender, uint256 value) external returns (bool success);
22   function allowance(address owner, address spender) external view returns (uint256 remaining);
23 
24   event Transfer(address indexed from, address indexed to, uint256 value);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 /// @dev This is taken from https://github.com/OpenZeppelin/openzeppelin-solidity project.
30 /// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/67bca857eedf99bf44a4b6a0fc5b5ed553135316/contracts/token/ERC20/ERC20.sol
31 contract ERC20 is IERC20 {
32   using SafeMath for uint256;
33 
34   string public constant name = "CAPZ";
35   string public constant symbol = "CAPZ";
36   uint8 public constant decimals = 18;
37 
38   /// @dev Total number of tokens in existence.
39   uint256 public totalSupply;
40 
41   mapping(address => uint256) internal balances;
42   mapping(address => mapping(address => uint256)) internal allowed;
43 
44   /// @dev Gets the balance of the specified address.
45   /// @param owner The address to query the balance of.
46   /// @return A uint256 representing the amount owned by the passed address.
47   function balanceOf(address owner) external view returns (uint256) {
48     return balances[owner];
49   }
50 
51   /// @dev Transfer token to a specified address.
52   /// @param to The address to transfer to.
53   /// @param value The amount to be transferred.
54   function transfer(address to, uint256 value) external returns (bool) {
55     _transfer(msg.sender, to, value);
56     return true;
57   }
58 
59   /// @dev Transfer tokens from one address to another.
60   /// Note that while this function emits an Approval event, this is not required as per the specification,
61   /// and other compliant implementations may not emit the event.
62   /// @param from The address which you want to send tokens from
63   /// @param to The address which you want to transfer to
64   /// @param value The amount of tokens to be transferred
65   function transferFrom(address from, address to, uint256 value) external returns (bool) {
66     _transfer(from, to, value);
67     _approve(from, msg.sender, allowed[from][msg.sender].sub(value));
68     return true;
69   }
70 
71   /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
72   /// Beware that changing an allowance with this method brings the risk that someone may use both the old
73   /// and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
74   /// race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
75   /// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76   /// @param spender The address which will spend the funds.
77   /// @param value The amount of tokens to be spent.
78   function approve(address spender, uint256 value) external returns (bool) {
79     _approve(msg.sender, spender, value);
80     return true;
81   }
82 
83   /// @dev Function to check the amount of tokens that an owner allowed to a spender.
84   /// @param owner The address which owns the funds.
85   /// @param spender The address which will spend the funds.
86   /// @return A uint256 specifying the amount of tokens still available for the spender.
87   function allowance(address owner, address spender) external view returns (uint256) {
88     return allowed[owner][spender];
89   }
90 
91   /// @dev Internal function that transfer token for a specified addresses.
92   /// @param from The address to transfer from.
93   /// @param to The address to transfer to.
94   /// @param value The amount to be transferred.
95   function _transfer(address from, address to, uint256 value) internal {
96     require(address(this) != to);
97     require(address(0) != to);
98 
99     balances[from] = balances[from].sub(value);
100     balances[to] = balances[to].add(value);
101 
102     emit Transfer(from, to, value);
103   }
104 
105   /// @dev Approve an address to spend another addresses' tokens.
106   /// @param owner The address that owns the tokens.
107   /// @param spender The address that will spend the tokens.
108   /// @param value The number of tokens that can be spent.
109   function _approve(address owner, address spender, uint256 value) internal {
110     require(address(0) != owner);
111     require(address(0) != spender);
112 
113     allowed[owner][spender] = value;
114 
115     emit Approval(owner, spender, value);
116   }
117 
118   /// @dev Internal function that mints an amount of the token and assigns it to
119   /// an account. This encapsulates the modification of balances such that the
120   /// proper events are emitted.
121   /// @param account The account that will receive the created tokens.
122   /// @param value The amount that will be created.
123   function _mint(address account, uint256 value) internal {
124     require(address(0) != account);
125 
126     totalSupply = totalSupply.add(value);
127     balances[account] = balances[account].add(value);
128 
129     emit Transfer(address(0), account, value);
130   }
131 }
132 
133 
134 /// @notice The CAPZ contract has a finite date span and a financial
135 /// goal set in wei. While this contract is in force, users may buy
136 /// tokens. After certain conditions are met, token holders may either
137 /// refund the paid amount or claim the tokens in the form of points
138 /// with us. The availability of each operation depends on the result
139 /// of this contract. During the period that the contract is in force
140 /// (w.r.t. the dates and goals) the funds are locked and can only be
141 /// unlocked when status is GoalReached or GoalNotReached.
142 contract CAPZ is ERC20 {
143   using SafeMath for uint256;
144 
145   /// @dev This is us. We use it internally to allow/deny usage of
146   /// admininstrative functions.
147   address internal owner;
148 
149   /// @notice The current wei amount that this contract has
150   /// received. It also represents the number of tokens that have been
151   /// granted.
152   uint256 public balanceInWei;
153 
154   /// @notice The soft limit that we check against for success at the
155   /// end of this contract. These limits may change over the course of
156   /// this crowdsale contract as we want to adjust these values to
157   /// match a certain amount in fiat currency.
158   uint256 public goalLimitMinInWei;
159 
160   /// @title Same as goalLimitMinInWei but defines the hard limit. In
161   /// the event this amount is received we do not wait for the end
162   /// date to collect received funds and close the contract.
163   uint256 public goalLimitMaxInWei;
164 
165   /// @notice The date (unix timestamp) which this contract terminates.
166   uint256 public endOn;
167 
168   /// @notice The date (unix timestamp) which this contract starts.
169   uint256 public startOn;
170 
171   /// @dev Internal struct that tracks the refunds made so far.
172   mapping(address => uint256) internal refunds;
173 
174   /// @title The current status of this contract.
175   enum ICOStatus {
176     /// @notice The contract is not yet in force.
177     NotOpen,
178     /// @notice The contract is in force, accepting payments and
179     /// granting tokens.
180     Open,
181     /// @notice The contract has terminated with success and the owner
182     /// of this contract may withdraw the amount in wei. The contract
183     /// may terminate prior the endOn date on the event that the
184     /// goalLimitMaxInWei has been reached.
185     GoalReached,
186     /// @notice The contract has terminated and the goal not been
187     /// reached. Token holders may refund the invested value.
188     GoalNotReached
189   }
190 
191   constructor (uint256 _startOn, uint256 _endOn, uint256 _goalLimitMinInWei, uint256 _goalLimitMaxInWei) public {
192     require(_startOn < _endOn);
193     require(_goalLimitMinInWei < _goalLimitMaxInWei);
194 
195     owner = msg.sender;
196     endOn = _endOn;
197     startOn = _startOn;
198     goalLimitMaxInWei = _goalLimitMaxInWei;
199     goalLimitMinInWei = _goalLimitMinInWei;
200   }
201 
202   function () external payable {
203     require(0 == msg.data.length);
204 
205     buyTokens();
206   }
207 
208   /// @notice The function that allow users to buy tokens. This
209   /// function shall grant the amount received in wei to tokens. As
210   /// this is an standard ERC20 contract you may trade these tokens at
211   /// any time if desirable. At the end of the contract, you may
212   /// either claim these tokens or refund the amount paid. Refer to
213   /// these two functions for more information about the rules.
214   /// @dev Receives wei and _mint the received amount to the
215   /// msg.sender. Emits a Transfer event, using address(0) as the
216   /// source address. It also increases the totalSupply and balanceInWei.
217   function buyTokens() public whenOpen payable {
218     uint256 receivedAmount = msg.value;
219     address beneficiary = msg.sender;
220     uint256 newBalance = balanceInWei.add(receivedAmount);
221     uint256 newRefundBalance = refunds[beneficiary].add(receivedAmount);
222 
223     _mint(beneficiary, receivedAmount);
224     refunds[beneficiary] = newRefundBalance;
225     balanceInWei = newBalance;
226   }
227 
228   /// @notice In the event the contract has terminated [status is
229   /// GoalNotReached] and the goal has not been reached users may
230   /// refund the amount paid [disregarding gas expenses].
231   function escrowRefund() external whenGoalNotReached {
232     uint256 amount = refunds[msg.sender];
233 
234     require(address(0) != msg.sender);
235     require(0 < amount);
236 
237     refunds[msg.sender] = 0;
238     msg.sender.transfer(amount);
239   }
240 
241   /// @notice This is an administrative function and can only be
242   /// called by the contract's owner when the status is
243   /// GoalReached. If these conditions are met the balance is
244   /// transferred to the contract's owner.
245   function escrowWithdraw() external onlyOwner whenGoalReached {
246     uint256 amount = address(this).balance;
247 
248     require(address(0) != msg.sender);
249     require(0 < amount);
250 
251     msg.sender.transfer(amount);
252   }
253 
254   /// @notice This function is used in the event the contract's status
255   /// is GoalReached. It allows the user to exchange tokens in
256   /// points. The conversion rate is variable and is not defined in
257   /// this contract.
258   /// @param amount The tokens you want to convert in points.
259   /// @dev Emits the Claim event.
260   function escrowClaim(uint256 amount) external whenGoalReached {
261     _transfer(msg.sender, owner, amount);
262     emit Claim(msg.sender, amount);
263   }
264 
265   /// @notice Administrative function that allows the contract's owner
266   /// to change the goals. As the goals are set in fiat currency, this
267   /// mechanism might be used to adjust the goal so that the goal
268   /// won't suffer from severe ETH fluctuations. Notice this function
269   /// can't be used when the status is GoalNotReached or GoalReached.
270   /// @dev Emits the GoalChange event.
271   function alterGoal(uint256 _goalLimitMinInWei, uint256 _goalLimitMaxInWei) external onlyOwner {
272     ICOStatus status = status(block.timestamp);
273 
274     require(ICOStatus.GoalReached != status);
275     require(ICOStatus.GoalNotReached != status);
276     require(_goalLimitMinInWei < _goalLimitMaxInWei);
277 
278     goalLimitMinInWei = _goalLimitMinInWei;
279     goalLimitMaxInWei = _goalLimitMaxInWei;
280 
281     emit GoalChange(_goalLimitMinInWei, _goalLimitMaxInWei);
282   }
283 
284   /// @notice Administrative function.
285   function transferOwnership(address newOwner) external onlyOwner {
286     require(address(0) != newOwner);
287     require(address(this) != newOwner);
288 
289     owner = newOwner;
290   }
291 
292   /// @notice Returns the current status of the contract. All functions
293   /// depend on this to enforce invariants, like allowing/denying
294   /// refund or withdraw. Please refer to ICOStatus enum documentation
295   /// for more information about each status in detail.
296   function status() external view returns (ICOStatus) {
297     return status(block.timestamp);
298   }
299 
300   /// @dev internal function that receives a timestamp instead of
301   /// reading from block.timestamp.
302   function status(uint256 timestamp) internal view returns (ICOStatus) {
303     if (timestamp < startOn) {
304       return ICOStatus.NotOpen;
305     } else if (timestamp < endOn && balanceInWei < goalLimitMaxInWei) {
306       return ICOStatus.Open;
307     } else if (balanceInWei >= goalLimitMinInWei) {
308       return ICOStatus.GoalReached;
309     } else {
310       return ICOStatus.GoalNotReached;
311     }
312   }
313 
314   /// @notice Event emitted when the contract's owner has adjusted the
315   /// goal. Refer to alterGoal function for more information.
316   event GoalChange(uint256 goalLimitMinInWei, uint256 goalLimitMaxInWei);
317 
318   /// @notice Event emitted when the user has exchanged tokens per
319   /// points.
320   event Claim(address beneficiary, uint256 value);
321 
322   modifier onlyOwner() {
323     require(owner == msg.sender);
324     _;
325   }
326 
327   modifier whenOpen() {
328     require(ICOStatus.Open == status(block.timestamp));
329     _;
330   }
331 
332   modifier whenGoalReached() {
333     require(ICOStatus.GoalReached == status(block.timestamp));
334     _;
335   }
336 
337   modifier whenGoalNotReached() {
338     require(ICOStatus.GoalNotReached == status(block.timestamp));
339     _;
340   }
341 }