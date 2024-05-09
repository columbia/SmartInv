1 pragma solidity >= 0.6.6;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address account) external view returns (uint256);
6   function transfer(address recipient, uint256 amount) external returns (bool);
7   function allowance(address owner, address spender) external view returns (uint256);
8   function approve(address spender, uint256 amount) external returns (bool);
9   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10   function mint(address account, uint256 amount) external;
11   function burn(uint256 amount) external;
12   event Transfer(address indexed from, address indexed to, uint256 value);
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 contract Owned is Context {
28     address private _owner;
29 
30     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32     constructor () internal {
33         address msgSender = _msgSender();
34         _owner = msgSender;
35         emit OwnershipTransferred(address(0), msgSender);
36     }
37 
38     function owner() public view returns (address) {
39         return _owner;
40     }
41 
42     modifier onlyOwner() {
43         require(_owner == _msgSender(), "Ownable: caller is not the owner");
44         _;
45     }
46 
47     function renounceOwnership() public virtual onlyOwner {
48         emit OwnershipTransferred(_owner, address(0));
49         _owner = address(0);
50     }
51 
52     function transferOwnership(address newOwner) public virtual onlyOwner {
53         require(newOwner != address(0), "Ownable: new owner is the zero address");
54         emit OwnershipTransferred(_owner, newOwner);
55         _owner = newOwner;
56     }
57 }
58 
59 
60 contract unistake is Owned {
61   using SafeMath for uint256;
62 
63   constructor() public {
64     synPerLPTNKPerDay = 1 * 10**18;
65     startTime = block.timestamp;
66     endTime =  block.timestamp.add(30 days);
67     totalSynRewards = 2 * 10**6 * 10**18;
68   }
69 
70   IERC20 public SYN = IERC20(0x1695936d6a953df699C38CA21c2140d497C08BD9);
71   IERC20 public LPTKN = IERC20(0xdF27A38946a1AcE50601Ef4e10f07A9CC90d7231);
72 
73   uint256 public synPerLPTNKPerDay;
74   uint256 public startTime;
75   uint256 public endTime;
76 
77   uint256 public totalSynRewards;
78   uint256 public totalStaked;
79   uint256 public totalTime;
80   uint256 public totalStaking;
81 
82   mapping(address => uint256) public balances;
83   mapping(address => uint256) public timeEntered;
84 
85   function stake(uint256 amount) public {
86     require(amount > 0);
87     uint256 time = timeEntered[msg.sender];
88     claimReward();
89     if(block.timestamp < endTime && block.timestamp >= startTime) {
90       require(LPTKN.transferFrom(msg.sender, address(this), amount));
91       if(time == timeEntered[msg.sender]) timeEntered[msg.sender] = block.timestamp;
92       totalStaking = totalStaking.add(amount);
93       balances[msg.sender] = balances[msg.sender].add(amount);
94     }
95   }
96   function unstake() public {
97     require(balances[msg.sender] > 0);
98     claimReward();
99     uint256 amount = balances[msg.sender];
100     totalStaking = totalStaking.sub(amount);
101     balances[msg.sender] = balances[msg.sender].sub(amount);
102     LPTKN.transfer(msg.sender, amount);
103   }
104   function claimReward() public {
105     updateTotals();
106     if(timeEntered[msg.sender] != 0) {
107       uint256 syndue = getReward(balances[msg.sender], timeEntered[msg.sender]);
108       if(syndue > 0) {
109         timeEntered[msg.sender] = block.timestamp > endTime ? endTime : block.timestamp;
110         SYN.transfer(msg.sender, syndue);
111       }
112     }
113   }
114   function updateTotals() public {
115     uint256 time = block.timestamp > endTime ? endTime : block.timestamp;
116     uint256 timediff = time.sub(totalTime);
117     uint256 reward = totalStaking.mul(timediff).mul(synPerLPTNKPerDay).div(1 days).div(10**18);
118     if(reward > 0) totalStaked = totalStaked.add(reward);
119     if(totalTime != time) totalTime = time;
120     if(totalStaked >= totalSynRewards && block.timestamp == time)
121       endTime = block.timestamp;
122   }
123   //GET BACK UNI-V2 TOKENS WITHOUT CLAIMING SYN REWARDS
124   function emergencyRemove(uint256 amount) public {
125     require(balances[msg.sender] >= amount);
126     balances[msg.sender] = balances[msg.sender].sub(amount);
127     totalStaking = totalStaking.sub(amount);
128     LPTKN.transfer(msg.sender, amount);
129   }
130 
131   //VIEW
132   function getReward(uint256 amount, uint256 time) public view returns(uint256) {
133     uint256 timediff = block.timestamp > endTime ? endTime.sub(time) : block.timestamp.sub(time);
134     uint256 reward = amount.mul(timediff).mul(synPerLPTNKPerDay).div(1 days).div(10**18);
135     return(reward);
136   }
137 
138   //ADMIN
139   function setStartTime(uint256 time) public onlyOwner() {
140     startTime = time;
141   }
142   function setEndTime(uint256 time) public onlyOwner() {
143     endTime = time;
144   }
145   function setTotalSynRewards(uint256 amount) public onlyOwner() {
146     totalSynRewards = amount;
147   }
148   function tokenremove(IERC20 token, uint256 amount) public onlyOwner() {
149     require(token != LPTKN);
150     token.transfer(msg.sender, amount);
151   }
152   function ethremove() public onlyOwner() {
153     address payable owner = msg.sender;
154     owner.transfer(address(this).balance);
155   }
156 
157 
158 }
159 
160 /**
161  * @dev Wrappers over Solidity's arithmetic operations with added overflow
162  * checks.
163  *
164  * Arithmetic operations in Solidity wrap on overflow. This can easily result
165  * in bugs, because programmers usually assume that an overflow raises an
166  * error, which is the standard behavior in high level programming languages.
167  * `SafeMath` restores this intuition by reverting the transaction when an
168  * operation overflows.
169  *
170  * Using this library instead of the unchecked operations eliminates an entire
171  * class of bugs, so it's recommended to use it always.
172  */
173 library SafeMath {
174     /**
175      * @dev Returns the addition of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `+` operator.
179      *
180      * Requirements:
181      *
182      * - Addition cannot overflow.
183      */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;
186         require(c >= a, "SafeMath: addition overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      *
199      * - Subtraction cannot overflow.
200      */
201     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202         return sub(a, b, "SafeMath: subtraction overflow");
203     }
204 
205     /**
206      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
207      * overflow (when the result is negative).
208      *
209      * Counterpart to Solidity's `-` operator.
210      *
211      * Requirements:
212      *
213      * - Subtraction cannot overflow.
214      */
215     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b <= a, errorMessage);
217         uint256 c = a - b;
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the multiplication of two unsigned integers, reverting on
224      * overflow.
225      *
226      * Counterpart to Solidity's `*` operator.
227      *
228      * Requirements:
229      *
230      * - Multiplication cannot overflow.
231      */
232     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
233         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
234         // benefit is lost if 'b' is also tested.
235         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
236         if (a == 0) {
237             return 0;
238         }
239 
240         uint256 c = a * b;
241         require(c / a == b, "SafeMath: multiplication overflow");
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the integer division of two unsigned integers. Reverts on
248      * division by zero. The result is rounded towards zero.
249      *
250      * Counterpart to Solidity's `/` operator. Note: this function uses a
251      * `revert` opcode (which leaves remaining gas untouched) while Solidity
252      * uses an invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function div(uint256 a, uint256 b) internal pure returns (uint256) {
259         return div(a, b, "SafeMath: division by zero");
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
264      * division by zero. The result is rounded towards zero.
265      *
266      * Counterpart to Solidity's `/` operator. Note: this function uses a
267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
268      * uses an invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
275         require(b > 0, errorMessage);
276         uint256 c = a / b;
277         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * Reverts when dividing by zero.
285      *
286      * Counterpart to Solidity's `%` operator. This function uses a `revert`
287      * opcode (which leaves remaining gas untouched) while Solidity uses an
288      * invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      *
292      * - The divisor cannot be zero.
293      */
294     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
295         return mod(a, b, "SafeMath: modulo by zero");
296     }
297 
298     /**
299      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
300      * Reverts with custom message when dividing by zero.
301      *
302      * Counterpart to Solidity's `%` operator. This function uses a `revert`
303      * opcode (which leaves remaining gas untouched) while Solidity uses an
304      * invalid opcode to revert (consuming all remaining gas).
305      *
306      * Requirements:
307      *
308      * - The divisor cannot be zero.
309      */
310     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
311         require(b != 0, errorMessage);
312         return a % b;
313     }
314 }