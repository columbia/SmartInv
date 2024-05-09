1 pragma solidity 0.6.12;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 library EnumerableSet {
30 
31     struct Set {
32         bytes32[] _values;
33 
34         mapping (bytes32 => uint256) _indexes;
35     }
36 
37     function _add(Set storage set, bytes32 value) private returns (bool) {
38         if (!_contains(set, value)) {
39             set._values.push(value);
40 
41             set._indexes[value] = set._values.length;
42             return true;
43         } else {
44             return false;
45         }
46     }
47 
48     function _remove(Set storage set, bytes32 value) private returns (bool) {
49         // We read and store the value's index to prevent multiple reads from the same storage slot
50         uint256 valueIndex = set._indexes[value];
51 
52         if (valueIndex != 0) { // Equivalent to contains(set, value)
53         
54             uint256 toDeleteIndex = valueIndex - 1;
55             uint256 lastIndex = set._values.length - 1;
56 
57 
58             bytes32 lastvalue = set._values[lastIndex];
59 
60             // Move the last value to the index where the value to delete is
61             set._values[toDeleteIndex] = lastvalue;
62             // Update the index for the moved value
63             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
64 
65             // Delete the slot where the moved value was stored
66             set._values.pop();
67 
68             // Delete the index for the deleted slot
69             delete set._indexes[value];
70 
71             return true;
72         } else {
73             return false;
74         }
75     }
76 
77     /**
78      * @dev Returns true if the value is in the set. O(1).
79      */
80     function _contains(Set storage set, bytes32 value) private view returns (bool) {
81         return set._indexes[value] != 0;
82     }
83 
84     function _length(Set storage set) private view returns (uint256) {
85         return set._values.length;
86     }
87 
88     function _at(Set storage set, uint256 index) private view returns (bytes32) {
89         require(set._values.length > index, "EnumerableSet: index out of bounds");
90         return set._values[index];
91     }
92 
93     // AddressSet
94 
95     struct AddressSet {
96         Set _inner;
97     }
98 
99     function add(AddressSet storage set, address value) internal returns (bool) {
100         return _add(set._inner, bytes32(uint256(value)));
101     }
102 
103     function remove(AddressSet storage set, address value) internal returns (bool) {
104         return _remove(set._inner, bytes32(uint256(value)));
105     }
106 
107     /**
108      * @dev Returns true if the value is in the set. O(1).
109      */
110     function contains(AddressSet storage set, address value) internal view returns (bool) {
111         return _contains(set._inner, bytes32(uint256(value)));
112     }
113 
114     /**
115      * @dev Returns the number of values in the set. O(1).
116      */
117     function length(AddressSet storage set) internal view returns (uint256) {
118         return _length(set._inner);
119     }
120 
121     function at(AddressSet storage set, uint256 index) internal view returns (address) {
122         return address(uint256(_at(set._inner, index)));
123     }
124 
125 
126     // UintSet
127 
128     struct UintSet {
129         Set _inner;
130     }
131 
132     function add(UintSet storage set, uint256 value) internal returns (bool) {
133         return _add(set._inner, bytes32(value));
134     }
135 
136     function remove(UintSet storage set, uint256 value) internal returns (bool) {
137         return _remove(set._inner, bytes32(value));
138     }
139 
140     /**
141      * @dev Returns true if the value is in the set. O(1).
142      */
143     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
144         return _contains(set._inner, bytes32(value));
145     }
146 
147     function length(UintSet storage set) internal view returns (uint256) {
148         return _length(set._inner);
149     }
150 
151     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
152         return uint256(_at(set._inner, index));
153     }
154 }
155 
156 contract Ownable {
157   address public owner;
158 
159 
160   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162   constructor() public {
163     owner = msg.sender;
164   }
165 
166   modifier onlyOwner() {
167     require(msg.sender == owner);
168     _;
169   }
170 
171   function transferOwnership(address newOwner) onlyOwner public {
172     require(newOwner != address(0));
173     emit OwnershipTransferred(owner, newOwner);
174     owner = newOwner;
175   }
176 }
177 
178 
179 interface Token {
180     function transferFrom(address, address, uint) external returns (bool);
181     function transfer(address, uint) external returns (bool);
182 }
183 
184 contract B26Staking_Vault2 is Ownable {
185     using SafeMath for uint;
186     using EnumerableSet for EnumerableSet.AddressSet;
187     
188     event RewardsTransferred(address holder, uint amount);
189     
190     // B26 token contract address
191     address public constant tokenAddress = 0x481dE76d5ab31e28A33B0EA1c1063aDCb5B1769A;
192     
193     // reward rate 416.00% per year
194     uint public constant rewardRate = 41600;
195     uint public constant rewardInterval = 365 days;  // 8% per week
196     
197     // staking fee 1 %
198     uint public constant stakingFeeRate = 100;
199     
200     // unstaking fee 0.5 %
201     uint public constant unstakingFeeRate = 50;
202     
203     // unstaking possible after 30 days
204     uint public constant cliffTime = 30 days;
205     
206     uint public totalClaimedRewards = 0;
207     
208     EnumerableSet.AddressSet private holders;
209     
210     mapping (address => uint) public depositedTokens;
211     mapping (address => uint) public stakingTime;
212     mapping (address => uint) public lastClaimedTime;
213     mapping (address => uint) public totalEarnedTokens;
214     
215     function updateAccount(address account) private {
216         uint pendingDivs = getPendingDivs(account);
217         if (pendingDivs > 0) {
218             require(Token(tokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
219             totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
220             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
221             emit RewardsTransferred(account, pendingDivs);
222         }
223         lastClaimedTime[account] = now;
224     }
225     
226     function getPendingDivs(address _holder) public view returns (uint) {
227         if (!holders.contains(_holder)) return 0;
228         if (depositedTokens[_holder] == 0) return 0;
229 
230         uint timeDiff = now.sub(lastClaimedTime[_holder]);
231         uint stakedAmount = depositedTokens[_holder];
232         
233         uint pendingDivs = stakedAmount
234                             .mul(rewardRate)
235                             .mul(timeDiff)
236                             .div(rewardInterval)
237                             .div(1e4);
238             
239         return pendingDivs;
240     }
241     
242     function getNumberOfHolders() public view returns (uint) {
243         return holders.length();
244     }
245     
246     
247     function deposit(uint amountToStake) public {
248         require(amountToStake > 0, "Cannot deposit 0 Tokens");
249         require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
250         
251         updateAccount(msg.sender);
252         
253         uint fee = amountToStake.mul(stakingFeeRate).div(1e4);
254         uint amountAfterFee = amountToStake.sub(fee);
255         require(Token(tokenAddress).transfer(owner, fee), "Could not transfer deposit fee.");
256         
257         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountAfterFee);
258         
259         if (!holders.contains(msg.sender)) {
260             holders.add(msg.sender);
261             stakingTime[msg.sender] = now;
262         }
263     }
264     
265     function withdraw(uint amountToWithdraw) public {
266         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
267         
268         require(now.sub(stakingTime[msg.sender]) > cliffTime, "You recently staked, please wait before withdrawing.");
269         
270         updateAccount(msg.sender);
271         
272         uint fee = amountToWithdraw.mul(unstakingFeeRate).div(1e4);
273         uint amountAfterFee = amountToWithdraw.sub(fee);
274         
275         require(Token(tokenAddress).transfer(owner, fee), "Could not transfer withdraw fee.");
276         require(Token(tokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
277         
278         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
279         
280         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
281             holders.remove(msg.sender);
282         }
283     }
284     
285     function claimDivs() public {
286         updateAccount(msg.sender);
287     }
288     
289     
290     uint private constant stakingAndDaoTokens = 7250e18;
291     
292     function getStakingAndDaoAmount() public view returns (uint) {
293         if (totalClaimedRewards >= stakingAndDaoTokens) {
294             return 0;
295         }
296         uint remaining = stakingAndDaoTokens.sub(totalClaimedRewards);
297         return remaining;
298     }
299     
300     // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
301     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
302         require (_tokenAddr != tokenAddress, "Cannot Transfer Out B26");
303         Token(_tokenAddr).transfer(_to, _amount);
304     }
305 }