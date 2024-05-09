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
101   *
102   * Karma/Token Rules:
103   * - Karma is created by initial user creation endowment.
104   * - Karma can also be minted by mod into an existing account.
105   * - Karma can only be transferred to existing account holder.
106   * - Karma implements the ERC20 token interface.
107   *
108   * Dividends:
109   * - each user can withdraw a dividend once per month.
110   * - dividend is total contract value at end of the month, divided by total number of users as end of the month.
111   * - user has 1 month to withdraw their dividend from the previous month.
112   * - if user does not withdraw their dividend, their share will be rolled over as a donation to the next month.
113   * - mod can place a user on a 1 month "timeout", whereby they won't be eligible for a dividend.
114 
115   * Eg: 10 eth is sent to the contract in January. There are 100 token holders on Jan 31. At any time in February, 
116   * each token holder can withdraw .1 eth for their January dividend (unless they were given a "timeout" in January).
117   */
118 contract Karma is Ownable, DetailedERC20("KarmaToken", "KARMA", 0) {
119   // SafeMath libs are responsible for checking overflow.
120   using SafeMath for uint256;
121   using SafeMath64 for uint64;
122 
123   // TODO ensure this all fits in a single 256 bit block.
124   struct User {
125     bytes20 username;
126     uint64 karma; 
127     uint16 canWithdrawPeriod;
128     uint16 birthPeriod;
129   }
130 
131   // Manage users.
132   mapping(address => User) public users;
133   mapping(bytes20 => address) public usernames;
134 
135   // Manage dividend payments.
136   uint256 public epoch;
137   uint256 public dividend;
138   uint64 public numUsers;
139   uint64 public newUsers;
140   uint16 public currentPeriod = 1;
141 
142   address public moderator;
143 
144   mapping(address => mapping (address => uint256)) internal allowed;
145 
146   event Mint(address indexed to, uint256 amount);
147   event PeriodEnd(uint16 period, uint256 amount, uint64 users);
148   event Donation(address indexed from, uint256 amount);
149   event Withdrawal(address indexed to, uint16 indexed period, uint256 amount);
150   event NewUser(address addr, bytes20 username, uint64 endowment);
151 
152   modifier onlyMod() {
153     require(msg.sender == moderator);
154     _;
155   }
156 
157   function Karma(uint256 _startEpoch) public {
158     epoch = _startEpoch;
159     moderator = msg.sender;
160   }
161 
162   function() payable public {
163     Donation(msg.sender, msg.value);
164   }
165 
166   /** 
167    * Owner Functions 
168    */
169 
170   function setMod(address _newMod) public onlyOwner {
171     moderator = _newMod;
172   }
173 
174   // Owner should call this on 1st of every month.
175   function newPeriod() public onlyOwner {
176     require(now >= epoch + 28 days);
177 
178     // Calculate dividend.
179     uint64 existingUsers = numUsers;
180     if (existingUsers == 0) {
181       dividend = 0;
182     } else {
183       dividend = this.balance / existingUsers;
184     }
185 
186     numUsers = numUsers.add(newUsers);
187     newUsers = 0;
188     currentPeriod++;
189     epoch = now;
190 
191     PeriodEnd(currentPeriod-1, this.balance, existingUsers);
192   }
193 
194   /**
195     * Mod Functions
196     */
197 
198   function createUser(address _addr, bytes20 _username, uint64 _amount) public onlyMod {
199     newUser(_addr, _username, _amount);
200   }
201 
202   // Send karma to existing account.
203   function mint(address _addr, uint64 _amount) public onlyMod {
204     require(users[_addr].canWithdrawPeriod != 0);
205 
206     users[_addr].karma = users[_addr].karma.add(_amount);
207     totalSupply = totalSupply.add(_amount);
208     Mint(_addr, _amount);
209   }
210 
211   // If a user has been bad, they won't be able to receive a dividend :(
212   function timeout(address _addr) public onlyMod {
213     require(users[_addr].canWithdrawPeriod != 0);
214 
215     users[_addr].canWithdrawPeriod = currentPeriod + 1;
216   }
217 
218   /**
219     * User Functions
220     */
221 
222   // Owner will sign hash(address, username, amount), and address owner uses this 
223   // signature to register their account.
224   function register(bytes20 _username, uint64 _endowment, bytes _sig) public {
225     require(recover(keccak256(msg.sender, _username, _endowment), _sig) == owner);
226     newUser(msg.sender, _username, _endowment);
227   }
228 
229   // User can withdraw their share of donations from the previous month.
230   function withdraw() public {
231     require(users[msg.sender].canWithdrawPeriod != 0);
232     require(users[msg.sender].canWithdrawPeriod < currentPeriod);
233 
234     users[msg.sender].canWithdrawPeriod = currentPeriod;
235     msg.sender.transfer(dividend);
236     Withdrawal(msg.sender, currentPeriod-1, dividend);
237   }
238 
239   /**
240     * ERC20 Functions
241     */
242 
243   function balanceOf(address _owner) public view returns (uint256 balance) {
244     return users[_owner].karma;
245   }
246 
247   // Contrary to most ERC20 implementations, require that recipient is existing user.
248   function transfer(address _to, uint256 _value) public returns (bool) {
249     require(users[_to].canWithdrawPeriod != 0);
250     require(_value <= users[msg.sender].karma);
251 
252     // Type assertion to uint64 is safe because we require that _value is < uint64 above.
253     users[msg.sender].karma = users[msg.sender].karma.sub(uint64(_value));
254     users[_to].karma = users[_to].karma.add(uint64(_value));
255     Transfer(msg.sender, _to, _value);
256     return true;
257   }
258 
259   function allowance(address _owner, address _spender) public view returns (uint256) {
260     return allowed[_owner][_spender];
261   }
262 
263   function approve(address _spender, uint256 _value) public returns (bool) {
264     allowed[msg.sender][_spender] = _value;
265     Approval(msg.sender, _spender, _value);
266     return true;
267   }
268 
269   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
270     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
271     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
276     uint oldValue = allowed[msg.sender][_spender];
277     if (_subtractedValue > oldValue) {
278       allowed[msg.sender][_spender] = 0;
279     } else {
280       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
281     }
282     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283     return true;
284   }
285 
286   // Contrary to most ERC20 implementations, require that recipient is existing user.
287   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
288     require(users[_to].canWithdrawPeriod != 0);
289     require(_value <= users[_from].karma);
290     require(_value <= allowed[_from][msg.sender]);
291 
292     users[_from].karma = users[_from].karma.sub(uint64(_value));
293     users[_to].karma = users[_to].karma.add(uint64(_value));
294     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
295     Transfer(_from, _to, _value);
296     return true;
297   }
298 
299   /**
300     * Private Functions
301     */
302 
303   // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ECRecovery.sol
304   function recover(bytes32 hash, bytes sig) internal pure returns (address) {
305     bytes32 r;
306     bytes32 s;
307     uint8 v;
308 
309     //Check the signature length
310     if (sig.length != 65) {
311       return (address(0));
312     }
313 
314     // Divide the signature in r, s and v variables
315     assembly {
316       r := mload(add(sig, 32))
317       s := mload(add(sig, 64))
318       v := byte(0, mload(add(sig, 96)))
319     }
320 
321     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
322     if (v < 27) {
323       v += 27;
324     }
325 
326     // If the version is correct return the signer address
327     if (v != 27 && v != 28) {
328       return (address(0));
329     } else {
330       return ecrecover(hash, v, r, s);
331     }
332   }
333 
334   // Ensures that username isn't taken, and account doesn't already exist for 
335   // user's address.
336   function newUser(address _addr, bytes20 _username, uint64 _endowment) private {
337     require(usernames[_username] == address(0));
338     require(users[_addr].canWithdrawPeriod == 0);
339 
340     users[_addr].canWithdrawPeriod = currentPeriod + 1;
341     users[_addr].birthPeriod = currentPeriod;
342     users[_addr].karma = _endowment;
343     users[_addr].username = _username;
344     usernames[_username] = _addr;
345 
346     newUsers = newUsers.add(1);
347     totalSupply = totalSupply.add(_endowment);
348     NewUser(_addr, _username, _endowment);
349   }
350 }