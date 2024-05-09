1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor () {
25         address msgSender = _msgSender();
26         _owner = msgSender;
27         emit OwnershipTransferred(address(0), msgSender);
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(_owner == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Transfers ownership of the contract to a new account (`newOwner`).
59      * Can only be called by the current owner.
60      */
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         emit OwnershipTransferred(_owner, newOwner);
64         _owner = newOwner;
65     }
66 }
67 
68 library SafeMath {
69     /**
70      * @dev Returns the addition of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `+` operator.
74      *
75      * Requirements:
76      *
77      * - Addition cannot overflow.
78      */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `*` operator.
122      *
123      * Requirements:
124      *
125      * - Multiplication cannot overflow.
126      */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129         // benefit is lost if 'b' is also tested.
130         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131         if (a == 0) {
132             return 0;
133         }
134 
135         uint256 c = a * b;
136         require(c / a == b, "SafeMath: multiplication overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         return div(a, b, "SafeMath: division by zero");
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator. Note: this function uses a
162      * `revert` opcode (which leaves remaining gas untouched) while Solidity
163      * uses an invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b > 0, errorMessage);
171         uint256 c = a / b;
172         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         return mod(a, b, "SafeMath: modulo by zero");
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts with custom message when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b != 0, errorMessage);
207         return a % b;
208     }
209 }
210 
211 contract RoyalityPool is Ownable{
212 
213     using SafeMath for uint256;
214 
215     mapping (address => uint256 ) public rewardAmount;
216     mapping (address => uint256) public nftSetsAmount;
217     uint256 public shareValue;
218     mapping (uint256 => address) public rewardHolders;
219     uint256 public nftSetholdersAmount;                         // total amount of nft set holders of previous month
220     uint256 public totalSetAmount;
221     uint256 public currentRoyaltyAmount;
222     uint256 public ownerDepositRoyaltyAmount = 0;
223 
224     event OwnerSetHoldersRewards (address[] holders, uint256[] setAmounts, uint256 totalSetAmount);
225     event OwnerClearPreviousRewards ();
226     event UserWithdraw (address user, uint256 amount);
227 
228     function getRewardAmount (address holder) public view returns (uint256) {
229         return rewardAmount[holder];
230     }
231 
232     function getShareValue () public view returns (uint256) {
233         return shareValue;
234     }
235 
236     function getNFTSetsAmounts (address holder) public view returns (uint256) {
237         return nftSetsAmount[holder];
238     }
239 
240     function getCurrentTime () public view returns (uint256) {
241         return block.timestamp;
242     }
243 
244     function ownerDeposit() external payable {
245         ownerDepositRoyaltyAmount = 1;
246     }
247 
248     function clearPreviousRewards () public onlyOwner{
249         for (uint256 i = 0; i < nftSetholdersAmount; i++) {
250             rewardAmount[rewardHolders[i]] = 0;
251         }
252         emit OwnerClearPreviousRewards();
253     }
254 
255     function setHoldersRewards (address[] calldata holders, uint256[] calldata setAmounts, uint256 _totalSetAmount) public onlyOwner{
256         require(ownerDepositRoyaltyAmount == 1, "setHolderRewards : Royalty Amount is not deposited yet");
257         require(holders.length == setAmounts.length, "setHoldersRewards : Invalid input, holders lengt must be same as setAmounts length");
258         require(_totalSetAmount > 0, "setHoldersReward : there is no NFT sets");
259         uint256 sumSetAmount;
260         for (uint256 i = 0; i < setAmounts.length; i++) {
261             sumSetAmount += setAmounts[i];
262         }
263         require(sumSetAmount == _totalSetAmount, "setHoldersRewards : sum of setAmounts must be equal to the totalSetAmount");
264         clearPreviousRewards();
265         totalSetAmount = _totalSetAmount;
266         nftSetholdersAmount = holders.length;
267         currentRoyaltyAmount = address(this).balance;
268         shareValue = currentRoyaltyAmount.div(totalSetAmount);
269         for (uint256 i = 0; i < nftSetholdersAmount; i ++) {
270             rewardHolders[i] = holders[i];
271             rewardAmount[rewardHolders[i]] = shareValue.mul(setAmounts[i]);
272             nftSetsAmount[rewardHolders[i]] = setAmounts[i];
273         }
274         ownerDepositRoyaltyAmount = 0;
275         emit OwnerSetHoldersRewards(holders, setAmounts, _totalSetAmount);
276     }  
277 
278     function withdrawRewards () public {
279         require(rewardAmount[msg.sender] > 0, "withdrawRewards : Your reward amount is zero");
280         address payable to = payable(msg.sender);        
281         to.transfer(rewardAmount[to]);
282         rewardAmount[to] = 0;
283         emit UserWithdraw(to, rewardAmount[to]);
284     }
285 }