1 pragma solidity 0.6.12;
2 
3 // SPDX-License-Identifier: none
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 library EnumerableSet {
32 
33     struct Set {
34         bytes32[] _values;
35 
36         mapping (bytes32 => uint256) _indexes;
37     }
38 
39     function _add(Set storage set, bytes32 value) private returns (bool) {
40         if (!_contains(set, value)) {
41             set._values.push(value);
42 
43             set._indexes[value] = set._values.length;
44             return true;
45         } else {
46             return false;
47         }
48     }
49 
50     function _remove(Set storage set, bytes32 value) private returns (bool) {
51         // We read and store the value's index to prevent multiple reads from the same storage slot
52         uint256 valueIndex = set._indexes[value];
53 
54         if (valueIndex != 0) { // Equivalent to contains(set, value)
55         
56             uint256 toDeleteIndex = valueIndex - 1;
57             uint256 lastIndex = set._values.length - 1;
58 
59 
60             bytes32 lastvalue = set._values[lastIndex];
61 
62             // Move the last value to the index where the value to delete is
63             set._values[toDeleteIndex] = lastvalue;
64             // Update the index for the moved value
65             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
66 
67             // Delete the slot where the moved value was stored
68             set._values.pop();
69 
70             // Delete the index for the deleted slot
71             delete set._indexes[value];
72 
73             return true;
74         } else {
75             return false;
76         }
77     }
78 
79     /**
80      * @dev Returns true if the value is in the set. O(1).
81      */
82     function _contains(Set storage set, bytes32 value) private view returns (bool) {
83         return set._indexes[value] != 0;
84     }
85 
86     function _length(Set storage set) private view returns (uint256) {
87         return set._values.length;
88     }
89 
90     function _at(Set storage set, uint256 index) private view returns (bytes32) {
91         require(set._values.length > index, "EnumerableSet: index out of bounds");
92         return set._values[index];
93     }
94 
95     // AddressSet
96 
97     struct AddressSet {
98         Set _inner;
99     }
100 
101     function add(AddressSet storage set, address value) internal returns (bool) {
102         return _add(set._inner, bytes32(uint256(value)));
103     }
104 
105     function remove(AddressSet storage set, address value) internal returns (bool) {
106         return _remove(set._inner, bytes32(uint256(value)));
107     }
108 
109     /**
110      * @dev Returns true if the value is in the set. O(1).
111      */
112     function contains(AddressSet storage set, address value) internal view returns (bool) {
113         return _contains(set._inner, bytes32(uint256(value)));
114     }
115 
116     /**
117      * @dev Returns the number of values in the set. O(1).
118      */
119     function length(AddressSet storage set) internal view returns (uint256) {
120         return _length(set._inner);
121     }
122 
123     function at(AddressSet storage set, uint256 index) internal view returns (address) {
124         return address(uint256(_at(set._inner, index)));
125     }
126 
127 
128     // UintSet
129 
130     struct UintSet {
131         Set _inner;
132     }
133 
134     function add(UintSet storage set, uint256 value) internal returns (bool) {
135         return _add(set._inner, bytes32(value));
136     }
137 
138     function remove(UintSet storage set, uint256 value) internal returns (bool) {
139         return _remove(set._inner, bytes32(value));
140     }
141 
142     /**
143      * @dev Returns true if the value is in the set. O(1).
144      */
145     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
146         return _contains(set._inner, bytes32(value));
147     }
148 
149     function length(UintSet storage set) internal view returns (uint256) {
150         return _length(set._inner);
151     }
152 
153     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
154         return uint256(_at(set._inner, index));
155     }
156 }
157 
158 contract Ownable {
159   address public owner;
160 
161 
162   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164   constructor() public {
165     owner = msg.sender;
166   }
167 
168   modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173   function transferOwnership(address newOwner) onlyOwner public {
174     require(newOwner != address(0));
175     emit OwnershipTransferred(owner, newOwner);
176     owner = newOwner;
177   }
178 }
179 
180 
181 interface Token {
182     function transferFrom(address, address, uint) external returns (bool);
183     function transfer(address, uint) external returns (bool);
184 }
185 
186 contract VaultVidiachange is Ownable {
187     using SafeMath for uint;
188     using EnumerableSet for EnumerableSet.AddressSet;
189     
190     event RewardsTransferred(address holder, uint amount);
191     
192     // LA VIDA Token Contract Address
193     address public constant tokenAddress = 0xE35f19E4457A114A951781aaF421EC5266eF25Fe;
194     
195     // reward rate 200.00% per year
196     uint public constant rewardRate = 20000;             // 20000 ÷ 100 = 200 %
197     uint public constant rewardInterval = 365 days;      
198     
199     // staking fee 2 percent
200     uint public constant stakingFeeRate = 200;           // 200 ÷ 100 = 2 %
201     
202     // unstaking fee 2 percent
203     uint public constant unstakingFeeRate = 200;         // 200 ÷ 100 = 2 %
204     
205     // unstaking possible after 1 year
206     uint public constant cliffTime = 365 days;
207     
208     uint public totalClaimedRewards = 0;
209     
210     EnumerableSet.AddressSet private holders;
211     
212     mapping (address => uint) public depositedTokens;
213     mapping (address => uint) public stakingTime;
214     mapping (address => uint) public lastClaimedTime;
215     mapping (address => uint) public totalEarnedTokens;
216     
217     function updateAccount(address account) private {
218         uint pendingDivs = getPendingDivs(account);
219         if (pendingDivs > 0) {
220             require(Token(tokenAddress).transfer(account, pendingDivs), "Could not transfer tokens.");
221             totalEarnedTokens[account] = totalEarnedTokens[account].add(pendingDivs);
222             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
223             emit RewardsTransferred(account, pendingDivs);
224         }
225         lastClaimedTime[account] = now;
226     }
227     
228     function getPendingDivs(address _holder) public view returns (uint) {
229         if (!holders.contains(_holder)) return 0;
230         if (depositedTokens[_holder] == 0) return 0;
231 
232         uint timeDiff = now.sub(lastClaimedTime[_holder]);
233         uint stakedAmount = depositedTokens[_holder];
234         
235         uint pendingDivs = stakedAmount
236                             .mul(rewardRate)
237                             .mul(timeDiff)
238                             .div(rewardInterval)
239                             .div(1e4);
240             
241         return pendingDivs;
242     }
243     
244     function getNumberOfHolders() public view returns (uint) {
245         return holders.length();
246     }
247     
248     
249     function deposit(uint amountToStake) public {
250         require(amountToStake > 0, "Cannot deposit 0 Tokens");
251         require(Token(tokenAddress).transferFrom(msg.sender, address(this), amountToStake), "Insufficient Token Allowance");
252         
253         updateAccount(msg.sender);
254         
255         uint fee = amountToStake.mul(stakingFeeRate).div(1e4);
256         uint amountAfterFee = amountToStake.sub(fee);
257         require(Token(tokenAddress).transfer(owner, fee), "Could not transfer deposit fee.");
258         
259         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amountAfterFee);
260         
261         if (!holders.contains(msg.sender)) {
262             holders.add(msg.sender);
263             stakingTime[msg.sender] = now;
264         }
265     }
266     
267     function withdraw(uint amountToWithdraw) public {
268         require(depositedTokens[msg.sender] >= amountToWithdraw, "Invalid amount to withdraw");
269         
270         require(now.sub(stakingTime[msg.sender]) > cliffTime, "You recently staked, please wait before withdrawing.");
271         
272         updateAccount(msg.sender);
273         
274         uint fee = amountToWithdraw.mul(unstakingFeeRate).div(1e4);
275         uint amountAfterFee = amountToWithdraw.sub(fee);
276         
277         require(Token(tokenAddress).transfer(owner, fee), "Could not transfer withdraw fee.");
278         require(Token(tokenAddress).transfer(msg.sender, amountAfterFee), "Could not transfer tokens.");
279         
280         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amountToWithdraw);
281         
282         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
283             holders.remove(msg.sender);
284         }
285     }
286     
287     function claimDivs() public {
288         updateAccount(msg.sender);
289     }
290     
291     
292     uint private constant stakingAndDaoTokens = 875e18;       // 875 LA VIDA (18 Decimals) are staked by LA VIDA Owner   
293                                                               // Stakers will be Rewarded by these 875 Tokens
294     
295     function getStakingAndDaoAmount() public view returns (uint) {
296         if (totalClaimedRewards >= stakingAndDaoTokens) {
297             return 0;
298         }
299         uint remaining = stakingAndDaoTokens.sub(totalClaimedRewards);
300         return remaining;
301     }
302     
303     // function to allow Creator to claim *other than LA VIDA* ERC20 Tokens, sent to this contract (by mistake) like USDT
304     // LA VIDA can't be withdrawal because it will be staked for period of time with criteria
305     
306     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
307         if (_tokenAddr == tokenAddress) {
308             if (_amount > getStakingAndDaoAmount()) {
309                 revert();
310             }
311             totalClaimedRewards = totalClaimedRewards.add(_amount);
312         }
313         Token(_tokenAddr).transfer(_to, _amount);
314     }
315 }