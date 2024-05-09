1 pragma solidity ^0.4.18;
2 
3 /** SafeMath libs are inspired by:
4   *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5   * There is debate as to whether this lib should use assert or require:
6   *  https://github.com/OpenZeppelin/zeppelin-solidity/issues/565
7 
8   * `require` is used in these libraries for the following reasons:
9   *   - overflows should not be checked in contract function bodies; DRY
10   *   - "valid" user input can cause overflows, which should not assert()
11   */
12 library SafeMath {
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     require(b <= a);
15     return a - b;
16   }
17 
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     require(c >= a);
21     return c;
22   }
23 }
24 
25 library SafeMath64 {
26   function sub(uint64 a, uint64 b) internal pure returns (uint64) {
27     require(b <= a);
28     return a - b;
29   }
30 
31   function add(uint64 a, uint64 b) internal pure returns (uint64) {
32     uint64 c = a + b;
33     require(c >= a);
34     return c;
35   }
36 }
37 
38 
39 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
40 contract Ownable {
41   address public owner;
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   function transferOwnership(address newOwner) public onlyOwner {
55     require(newOwner != address(0));
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 }
60 
61 
62 // https://github.com/ethereum/EIPs/issues/179
63 contract ERC20Basic {
64   uint256 public totalSupply;
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 
71 // https://github.com/ethereum/EIPs/issues/20
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender) public view returns (uint256);
74   function transferFrom(address from, address to, uint256 value) public returns (bool);
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/DetailedERC20.sol
81 contract DetailedERC20 is ERC20 {
82   string public name;
83   string public symbol;
84   uint8 public decimals;
85 
86   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
87     name = _name;
88     symbol = _symbol;
89     decimals = _decimals;
90   }
91 }
92 
93 
94 /** KarmaToken has the following properties:
95   *
96   * User Creation:
97   * - Self-registration
98   *   - Owner signs hash(address, username, endowment), and sends to user
99   *   - User registers with username, endowment, and signature to create new account.
100   * - Mod creates new user.
101   * - Users are first eligible to withdraw dividends for the period after account creation.
102   *
103   * Karma/Token Rules:
104   * - Karma is created by initial user creation endowment.
105   * - Karma can also be minted by mod into an existing account.
106   * - Karma can only be transferred to existing account holder.
107   * - Karma implements the ERC20 token interface.
108   *
109   * Dividends:
110   * - each user can withdraw a dividend once per month.
111   * - dividend is total contract value minus owner cut at end of the month, divided by total number of users at end of month.
112   * - owner cut is determined at beginning of new period.
113   * - user has 1 month to withdraw their dividend from the previous month.
114   * - if user does not withdraw their dividend, their share will be given to owner.
115   * - mod can place a user on a 1 month "timeout", whereby they won't be eligible for a dividend.
116 
117   * Eg: 10 eth is sent to the contract in January, owner cut is 30%. 
118   * There are 70 token holders on Jan 31. At any time in February, each token holder can withdraw .1 eth for their January 
119   * dividend (unless they were given a "timeout" in January).
120   */
121 contract Karma is Ownable, DetailedERC20("KarmaToken", "KARMA", 0) {
122   // SafeMath libs are responsible for checking overflow.
123   using SafeMath for uint256;
124   using SafeMath64 for uint64;
125 
126   struct User {
127     bytes20 username;
128     uint64 karma; 
129     uint16 canWithdrawPeriod;
130     uint16 birthPeriod;
131   }
132 
133   // Manage users.
134   mapping(address => User) public users;
135   mapping(bytes20 => address) public usernames;
136 
137   // Manage dividend payments.
138   uint256 public epoch; // Timestamp at start of new period.
139   uint256 dividendPool; // Total amount of dividends to pay out for last period.
140   uint256 public dividend; // Per-user share of last period's dividend.
141   uint256 public ownerCut; // Percentage, in basis points, of owner cut of this period's payments.
142   uint64 public numUsers; // Number of users created before this period.
143   uint64 public newUsers; // Number of users created during this period.
144   uint16 public currentPeriod = 1;
145 
146   address public moderator;
147 
148   mapping(address => mapping (address => uint256)) internal allowed;
149 
150   event Mint(address indexed to, uint256 amount);
151   event PeriodEnd(uint16 period, uint256 amount, uint64 users);
152   event Payment(address indexed from, uint256 amount);
153   event Withdrawal(address indexed to, uint16 indexed period, uint256 amount);
154   event NewUser(address addr, bytes20 username, uint64 endowment);
155 
156   modifier onlyMod() {
157     require(msg.sender == moderator);
158     _;
159   }
160 
161   function Karma(uint256 _startEpoch) public {
162     epoch = _startEpoch;
163     moderator = msg.sender;
164   }
165 
166   function() payable public {
167     Payment(msg.sender, msg.value);
168   }
169 
170   /** 
171    * Owner Functions 
172    */
173 
174   function setMod(address _newMod) public onlyOwner {
175     moderator = _newMod;
176   }
177 
178   // Owner should call this on 1st of every month.
179   // _ownerCut is new owner cut for new period.
180   function newPeriod(uint256 _ownerCut) public onlyOwner {
181     require(now >= epoch + 28 days);
182     require(_ownerCut <= 10000);
183 
184     uint256 unclaimedDividend = dividendPool;
185     uint256 ownerRake = (this.balance-unclaimedDividend) * ownerCut / 10000;
186 
187     dividendPool = this.balance - unclaimedDividend - ownerRake;
188 
189     // Calculate dividend.
190     uint64 existingUsers = numUsers;
191     if (existingUsers == 0) {
192       dividend = 0;
193     } else {
194       dividend = dividendPool / existingUsers;
195     }
196 
197     numUsers = numUsers.add(newUsers);
198     newUsers = 0;
199     currentPeriod++;
200     epoch = now;
201     ownerCut = _ownerCut;
202 
203     msg.sender.transfer(ownerRake + unclaimedDividend);
204     PeriodEnd(currentPeriod-1, this.balance, existingUsers);
205   }
206 
207   /**
208     * Mod Functions
209     */
210 
211   function createUser(address _addr, bytes20 _username, uint64 _amount) public onlyMod {
212     newUser(_addr, _username, _amount);
213   }
214 
215   // Send karma to existing account.
216   function mint(address _addr, uint64 _amount) public onlyMod {
217     require(users[_addr].canWithdrawPeriod != 0);
218 
219     users[_addr].karma = users[_addr].karma.add(_amount);
220     totalSupply = totalSupply.add(_amount);
221     Mint(_addr, _amount);
222   }
223 
224   // If a user has been bad, they won't be able to receive a dividend :(
225   function timeout(address _addr) public onlyMod {
226     require(users[_addr].canWithdrawPeriod != 0);
227 
228     users[_addr].canWithdrawPeriod = currentPeriod + 1;
229   }
230 
231   /**
232     * User Functions
233     */
234 
235   // Owner will sign hash(address, username, amount), and address owner uses this 
236   // signature to register their account.
237   function register(bytes20 _username, uint64 _endowment, bytes _sig) public {
238     require(recover(keccak256(msg.sender, _username, _endowment), _sig) == owner);
239     newUser(msg.sender, _username, _endowment);
240   }
241 
242   // User can withdraw their share of donations from the previous month.
243   function withdraw() public {
244     require(users[msg.sender].canWithdrawPeriod != 0);
245     require(users[msg.sender].canWithdrawPeriod < currentPeriod);
246 
247     users[msg.sender].canWithdrawPeriod = currentPeriod;
248     dividendPool -= dividend;
249     msg.sender.transfer(dividend);
250     Withdrawal(msg.sender, currentPeriod-1, dividend);
251   }
252 
253   /**
254     * ERC20 Functions
255     */
256 
257   function balanceOf(address _owner) public view returns (uint256 balance) {
258     return users[_owner].karma;
259   }
260 
261   // Contrary to most ERC20 implementations, require that recipient is existing user.
262   function transfer(address _to, uint256 _value) public returns (bool) {
263     require(users[_to].canWithdrawPeriod != 0);
264     require(_value <= users[msg.sender].karma);
265 
266     // Type assertion to uint64 is safe because we require that _value is < uint64 above.
267     users[msg.sender].karma = users[msg.sender].karma.sub(uint64(_value));
268     users[_to].karma = users[_to].karma.add(uint64(_value));
269     Transfer(msg.sender, _to, _value);
270     return true;
271   }
272 
273   function allowance(address _owner, address _spender) public view returns (uint256) {
274     return allowed[_owner][_spender];
275   }
276 
277   function approve(address _spender, uint256 _value) public returns (bool) {
278     allowed[msg.sender][_spender] = _value;
279     Approval(msg.sender, _spender, _value);
280     return true;
281   }
282 
283   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
284     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
285     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
290     uint oldValue = allowed[msg.sender][_spender];
291     if (_subtractedValue > oldValue) {
292       allowed[msg.sender][_spender] = 0;
293     } else {
294       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295     }
296     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300   // Contrary to most ERC20 implementations, require that recipient is existing user.
301   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
302     require(users[_to].canWithdrawPeriod != 0);
303     require(_value <= users[_from].karma);
304     require(_value <= allowed[_from][msg.sender]);
305 
306     users[_from].karma = users[_from].karma.sub(uint64(_value));
307     users[_to].karma = users[_to].karma.add(uint64(_value));
308     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
309     Transfer(_from, _to, _value);
310     return true;
311   }
312 
313   /**
314     * Private Functions
315     */
316 
317   // Ensures that username isn't taken, and account doesn't already exist for 
318   // user's address.
319   function newUser(address _addr, bytes20 _username, uint64 _endowment) private {
320     require(usernames[_username] == address(0));
321     require(users[_addr].canWithdrawPeriod == 0);
322 
323     users[_addr].canWithdrawPeriod = currentPeriod + 1;
324     users[_addr].birthPeriod = currentPeriod;
325     users[_addr].karma = _endowment;
326     users[_addr].username = _username;
327     usernames[_username] = _addr;
328 
329     newUsers = newUsers.add(1);
330     totalSupply = totalSupply.add(_endowment);
331     NewUser(_addr, _username, _endowment);
332   }
333 
334   // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ECRecovery.sol
335   function recover(bytes32 hash, bytes sig) internal pure returns (address) {
336     bytes32 r;
337     bytes32 s;
338     uint8 v;
339 
340     //Check the signature length
341     if (sig.length != 65) {
342       return (address(0));
343     }
344 
345     // Divide the signature in r, s and v variables
346     assembly {
347       r := mload(add(sig, 32))
348       s := mload(add(sig, 64))
349       v := byte(0, mload(add(sig, 96)))
350     }
351 
352     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
353     if (v < 27) {
354       v += 27;
355     }
356 
357     // If the version is correct return the signer address
358     if (v != 27 && v != 28) {
359       return (address(0));
360     } else {
361       return ecrecover(hash, v, r, s);
362     }
363   }
364 }