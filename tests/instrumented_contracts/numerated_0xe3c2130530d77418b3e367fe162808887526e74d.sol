1 // File: contracts/StakeInterface.sol
2 
3 contract StakeInterface {
4   function hasStake(address _address) external view returns (bool);
5 }
6 
7 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15   /**
16   * @dev Multiplies two numbers, throws on overflow.
17   */
18   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19     if (a == 0) {
20       return 0;
21     }
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   function Ownable() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     emit OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95 }
96 
97 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 // File: contracts/MainframeStake.sol
125 
126 contract MainframeStake is Ownable, StakeInterface {
127   using SafeMath for uint256;
128 
129   ERC20 token;
130   uint256 public arrayLimit = 200;
131   uint256 public totalDepositBalance;
132   uint256 public requiredStake;
133   mapping (address => uint256) public balances;
134 
135   struct Staker {
136     uint256 stakedAmount;
137     address stakerAddress;
138   }
139 
140   mapping (address => Staker) public whitelist; // map of whitelisted addresses for efficient hasStaked check
141 
142   constructor(address tokenAddress) public {
143     token = ERC20(tokenAddress);
144     requiredStake = 1 ether; // ether = 10^18
145   }
146 
147   /**
148   * @dev Staking MFT for a node address
149   * @param whitelistAddress representing the address of the node you want to stake for
150   */
151 
152   function stake(address whitelistAddress) external returns (bool success) {
153     require(whitelist[whitelistAddress].stakerAddress == 0x0);
154 
155     whitelist[whitelistAddress].stakerAddress = msg.sender;
156     whitelist[whitelistAddress].stakedAmount = requiredStake;
157 
158     deposit(msg.sender, requiredStake);
159     emit Staked(msg.sender, whitelistAddress);
160     return true;
161   }
162 
163   /**
164   * @dev Unstake a staked node address, will remove from whitelist and refund stake
165   * @param whitelistAddress representing the staked node address
166   */
167 
168   function unstake(address whitelistAddress) external {
169     require(whitelist[whitelistAddress].stakerAddress == msg.sender);
170 
171     uint256 stakedAmount = whitelist[whitelistAddress].stakedAmount;
172     delete whitelist[whitelistAddress];
173 
174     withdraw(msg.sender, stakedAmount);
175     emit Unstaked(msg.sender, whitelistAddress);
176   }
177 
178   /**
179   * @dev Deposit stake amount
180   * @param fromAddress representing the address to deposit from
181   * @param depositAmount representing amount being deposited
182   */
183 
184   function deposit(address fromAddress, uint256 depositAmount) private returns (bool success) {
185     token.transferFrom(fromAddress, this, depositAmount);
186     balances[fromAddress] = balances[fromAddress].add(depositAmount);
187     totalDepositBalance = totalDepositBalance.add(depositAmount);
188     emit Deposit(fromAddress, depositAmount, balances[fromAddress]);
189     return true;
190   }
191 
192   /**
193   * @dev Withdraw funds after unstaking
194   * @param toAddress representing the stakers address to withdraw to
195   * @param withdrawAmount representing stake amount being withdrawn
196   */
197 
198   function withdraw(address toAddress, uint256 withdrawAmount) private returns (bool success) {
199     require(balances[toAddress] >= withdrawAmount);
200     token.transfer(toAddress, withdrawAmount);
201     balances[toAddress] = balances[toAddress].sub(withdrawAmount);
202     totalDepositBalance = totalDepositBalance.sub(withdrawAmount);
203     emit Withdrawal(toAddress, withdrawAmount, balances[toAddress]);
204     return true;
205   }
206 
207   function balanceOf(address _address) external view returns (uint256 balance) {
208     return balances[_address];
209   }
210 
211   function totalStaked() external view returns (uint256) {
212     return totalDepositBalance;
213   }
214 
215   function hasStake(address _address) external view returns (bool) {
216     return whitelist[_address].stakedAmount > 0;
217   }
218 
219   function requiredStake() external view returns (uint256) {
220     return requiredStake;
221   }
222 
223   function setRequiredStake(uint256 value) external onlyOwner {
224     requiredStake = value;
225   }
226 
227   function setArrayLimit(uint256 newLimit) external onlyOwner {
228     arrayLimit = newLimit;
229   }
230 
231   function refundBalances(address[] addresses) external onlyOwner {
232     require(addresses.length <= arrayLimit);
233     for (uint256 i = 0; i < addresses.length; i++) {
234       address _address = addresses[i];
235       require(balances[_address] > 0);
236       token.transfer(_address, balances[_address]);
237       totalDepositBalance = totalDepositBalance.sub(balances[_address]);
238       emit RefundedBalance(_address, balances[_address]);
239       balances[_address] = 0;
240     }
241   }
242 
243   function emergencyERC20Drain(ERC20 _token) external onlyOwner {
244     // owner can drain tokens that are sent here by mistake
245     uint256 drainAmount;
246     if (address(_token) == address(token)) {
247       drainAmount = _token.balanceOf(this).sub(totalDepositBalance);
248     } else {
249       drainAmount = _token.balanceOf(this);
250     }
251     _token.transfer(owner, drainAmount);
252   }
253 
254   function destroy() external onlyOwner {
255     require(token.balanceOf(this) == 0);
256     selfdestruct(owner);
257   }
258 
259   event Staked(address indexed owner, address whitelistAddress);
260   event Unstaked(address indexed owner, address whitelistAddress);
261   event Deposit(address indexed _address, uint256 depositAmount, uint256 balance);
262   event Withdrawal(address indexed _address, uint256 withdrawAmount, uint256 balance);
263   event RefundedBalance(address indexed _address, uint256 refundAmount);
264 }