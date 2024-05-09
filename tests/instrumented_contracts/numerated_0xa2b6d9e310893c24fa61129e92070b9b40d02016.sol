1 pragma solidity ^0.4.18;
2 
3 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
4 library SafeMath {
5   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6     assert(b <= a);
7     return a - b;
8   }
9 
10   function add(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a + b;
12     assert(c >= a);
13     return c;
14   }
15 }
16 
17 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
18 contract Ownable {
19   address public owner;
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23   function Ownable() public {
24     owner = msg.sender;
25   }
26 
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 }
38 
39 // https://github.com/ethereum/EIPs/issues/179
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) public view returns (uint256);
43   function transfer(address to, uint256 value) public returns (bool);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 // https://github.com/ethereum/EIPs/issues/20
48 contract ERC20 is ERC20Basic {
49   function allowance(address owner, address spender) public view returns (uint256);
50   function transferFrom(address from, address to, uint256 value) public returns (bool);
51   function approve(address spender, uint256 value) public returns (bool);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/DetailedERC20.sol
56 contract DetailedERC20 is ERC20 {
57   string public name;
58   string public symbol;
59   uint8 public decimals;
60 
61   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
62     name = _name;
63     symbol = _symbol;
64     decimals = _decimals;
65   }
66 }
67 
68 // RoyalForkToken has the following properties:
69 // - users create an "account", which consists of a unique username, and token count.
70 // - tokens are minted at the discretion of "owner" and "minter".
71 // - tokens can only be transferred to existing token holders.
72 // - each token holder is entitled to a share of all donations sent to contract 
73 //   on a per-month basis and regardless of total token holdings; a dividend. 
74 //   (eg: 10 eth is sent to the contract in January.  There are 100 token 
75 //   holders on Jan 31.  At any time in February, each token holder can 
76 //   withdraw .1 eth for their January share).
77 // - dividends not collected for a given month become donations for the next month.
78 contract RoyalForkToken is Ownable, DetailedERC20("RoyalForkToken", "RFT", 0) {
79   using SafeMath for uint256;
80 
81   struct Hodler {
82     bytes16 username;
83     uint64 balance;
84     uint16 canWithdrawPeriod;
85   }
86 
87   mapping(address => Hodler) public hodlers;
88   mapping(bytes16 => address) public usernames;
89 
90   uint256 public epoch = now;
91   uint16 public currentPeriod = 1;
92   uint64 public numHodlers;
93   uint64 public prevHodlers;
94   uint256 public prevBalance;
95 
96   address minter;
97 
98   mapping(address => mapping (address => uint256)) internal allowed;
99 
100   event Mint(address indexed to, uint256 amount);
101   event PeriodEnd(uint16 indexed period, uint256 amount, uint64 hodlers);
102   event Donation(address indexed from, uint256 amount);
103   event Withdrawal(address indexed to, uint16 indexed period, uint256 amount);
104 
105   modifier onlyMinter() {
106     require(msg.sender == minter);
107     _;
108   }
109 
110   // === Private Functions
111   // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ECRecovery.sol
112   function recover(bytes32 hash, bytes sig) internal pure returns (address) {
113     bytes32 r;
114     bytes32 s;
115     uint8 v;
116 
117     //Check the signature length
118     if (sig.length != 65) {
119       return (address(0));
120     }
121 
122     // Divide the signature in r, s and v variables
123     assembly {
124       r := mload(add(sig, 32))
125       s := mload(add(sig, 64))
126       v := byte(0, mload(add(sig, 96)))
127     }
128 
129     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
130     if (v < 27) {
131       v += 27;
132     }
133 
134     // If the version is correct return the signer address
135     if (v != 27 && v != 28) {
136       return (address(0));
137     } else {
138       return ecrecover(hash, v, r, s);
139     }
140   }
141 
142   // Ensures that username isn't taken, and account doesn't already exist for 
143   // user's address.
144   function newHodler(address user, bytes16 username, uint64 endowment) private {
145     require(usernames[username] == address(0));
146     require(hodlers[user].canWithdrawPeriod == 0);
147 
148     hodlers[user].canWithdrawPeriod = currentPeriod;
149     hodlers[user].balance = endowment;
150     hodlers[user].username = username;
151     usernames[username] = user;
152 
153     numHodlers += 1;
154     totalSupply += endowment;
155     Mint(user, endowment);
156   }
157 
158   // === Owner Functions
159   function setMinter(address newMinter) public onlyOwner {
160     minter = newMinter;
161   }
162 
163   // Owner should call this on 1st of every month.
164   function newPeriod() public onlyOwner {
165     require(now >= epoch + 28 days);
166     currentPeriod++;
167     prevHodlers = numHodlers;
168     prevBalance = this.balance;
169     PeriodEnd(currentPeriod-1, prevBalance, prevHodlers);
170   }
171 
172   // === Minter Functions
173   function createHodler(address to, bytes16 username, uint64 amount) public onlyMinter {
174     newHodler(to, username, amount);
175   }
176 
177   // Send tokens to existing account.
178   function mint(address user, uint64 amount) public onlyMinter {
179     require(hodlers[user].canWithdrawPeriod != 0);
180     require(hodlers[user].balance + amount > hodlers[user].balance);
181 
182     hodlers[user].balance += amount;
183     totalSupply += amount;
184     Mint(user, amount);
185   }
186 
187   // === User Functions
188   // Owner will sign hash(amount, address), and address owner uses this 
189   // signature to create their account.
190   function create(bytes16 username, uint64 endowment, bytes sig) public {
191     require(recover(keccak256(endowment, msg.sender), sig) == owner);
192     newHodler(msg.sender, username, endowment);
193   }
194 
195   // User can withdraw their share of donations from the previous month.
196   function withdraw() public {
197     require(hodlers[msg.sender].canWithdrawPeriod != 0);
198     require(hodlers[msg.sender].canWithdrawPeriod < currentPeriod);
199 
200     hodlers[msg.sender].canWithdrawPeriod = currentPeriod;
201     uint256 payment = prevBalance / prevHodlers;
202     prevHodlers -= 1;
203     prevBalance -= payment;
204     msg.sender.send(payment);
205     Withdrawal(msg.sender, currentPeriod-1, payment);
206   }
207 
208   // ERC20 Functions
209   function balanceOf(address _owner) public view returns (uint256 balance) {
210     return hodlers[_owner].balance;
211   }
212 
213   function transfer(address _to, uint256 _value) public returns (bool) {
214     require(hodlers[_to].canWithdrawPeriod != 0);
215     require(_value <= hodlers[msg.sender].balance);
216     require(hodlers[_to].balance + uint64(_value) > hodlers[_to].balance);
217 
218     hodlers[msg.sender].balance -= uint64(_value);
219     hodlers[_to].balance += uint64(_value);
220     Transfer(msg.sender, _to, _value);
221     return true;
222   }
223 
224   function allowance(address _owner, address _spender) public view returns (uint256) {
225     return allowed[_owner][_spender];
226   }
227 
228   function approve(address _spender, uint256 _value) public returns (bool) {
229     allowed[msg.sender][_spender] = _value;
230     Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241     uint oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue > oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
252     require(hodlers[_to].canWithdrawPeriod != 0);
253     require(_value <= hodlers[_from].balance);
254     require(_value <= allowed[_from][msg.sender]);
255     require(hodlers[_to].balance + uint64(_value) > hodlers[_to].balance);
256 
257     hodlers[_from].balance -= uint64(_value);
258     hodlers[_to].balance += uint64(_value);
259     allowed[_from][msg.sender] -= _value;
260     Transfer(_from, _to, _value);
261     return true;
262   }
263 
264   // === Constructor/Default
265   function RoyalForkToken() public {
266     minter = msg.sender;
267   }
268 
269   function() payable public {
270     Donation(msg.sender, msg.value);
271   }
272 }