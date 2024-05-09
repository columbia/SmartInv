1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 library SafeMath {
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(b <= a, "SafeMath: subtraction overflow");
14         uint256 c = a - b;
15 
16         return c;
17     }
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26 
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0, "SafeMath: division by zero");
32         uint256 c = a / b;
33 
34         return c;
35     }
36 
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b != 0, "SafeMath: modulo by zero");
39         return a % b;
40     }
41 }
42 
43 library EnumerableSet {
44     struct Set {
45         bytes32[] _values;
46         mapping(bytes32 => uint256) _indexes;
47     }
48 
49     function _add(Set storage set, bytes32 value) private returns (bool) {
50         if (!_contains(set, value)) {
51             set._values.push(value);
52 
53             set._indexes[value] = set._values.length;
54             return true;
55         } else {
56             return false;
57         }
58     }
59 
60     function _remove(Set storage set, bytes32 value) private returns (bool) {
61         uint256 valueIndex = set._indexes[value];
62 
63         if (valueIndex != 0) {
64             uint256 toDeleteIndex = valueIndex - 1;
65             uint256 lastIndex = set._values.length - 1;
66 
67             bytes32 lastvalue = set._values[lastIndex];
68 
69             set._values[toDeleteIndex] = lastvalue;
70 
71             set._indexes[lastvalue] = toDeleteIndex + 1;
72 
73             set._values.pop();
74 
75             delete set._indexes[value];
76 
77             return true;
78         } else {
79             return false;
80         }
81     }
82 
83     function _contains(Set storage set, bytes32 value)
84         private
85         view
86         returns (bool)
87     {
88         return set._indexes[value] != 0;
89     }
90 
91     function _length(Set storage set) private view returns (uint256) {
92         return set._values.length;
93     }
94 
95     function _at(Set storage set, uint256 index)
96         private
97         view
98         returns (bytes32)
99     {
100         require(
101             set._values.length > index,
102             "EnumerableSet: index out of bounds"
103         );
104         return set._values[index];
105     }
106 
107     struct AddressSet {
108         Set _inner;
109     }
110 
111     function add(AddressSet storage set, address value)
112         internal
113         returns (bool)
114     {
115         return _add(set._inner, bytes32(uint256(value)));
116     }
117 
118     function remove(AddressSet storage set, address value)
119         internal
120         returns (bool)
121     {
122         return _remove(set._inner, bytes32(uint256(value)));
123     }
124 
125     function contains(AddressSet storage set, address value)
126         internal
127         view
128         returns (bool)
129     {
130         return _contains(set._inner, bytes32(uint256(value)));
131     }
132 
133     function length(AddressSet storage set) internal view returns (uint256) {
134         return _length(set._inner);
135     }
136 
137     function at(AddressSet storage set, uint256 index)
138         internal
139         view
140         returns (address)
141     {
142         return address(uint256(_at(set._inner, index)));
143     }
144 
145     // UintSet
146 
147     struct UintSet {
148         Set _inner;
149     }
150 
151     function add(UintSet storage set, uint256 value) internal returns (bool) {
152         return _add(set._inner, bytes32(value));
153     }
154 
155     function remove(UintSet storage set, uint256 value)
156         internal
157         returns (bool)
158     {
159         return _remove(set._inner, bytes32(value));
160     }
161 
162     function contains(UintSet storage set, uint256 value)
163         internal
164         view
165         returns (bool)
166     {
167         return _contains(set._inner, bytes32(value));
168     }
169 
170     function length(UintSet storage set) internal view returns (uint256) {
171         return _length(set._inner);
172     }
173 
174     function at(UintSet storage set, uint256 index)
175         internal
176         view
177         returns (uint256)
178     {
179         return uint256(_at(set._inner, index));
180     }
181 }
182 
183 interface IERC20 {
184     // ERC20 Optional Views
185     function name() external view returns (string memory);
186 
187     function symbol() external view returns (string memory);
188 
189     function decimals() external view returns (uint8);
190 
191     // Views
192     function totalSupply() external view returns (uint256);
193 
194     function balanceOf(address owner) external view returns (uint256);
195 
196     function allowance(address owner, address spender)
197         external
198         view
199         returns (uint256);
200 
201     // Mutative functions
202     function transfer(address to, uint256 value) external returns (bool);
203 
204     function approve(address spender, uint256 value) external returns (bool);
205 
206     function transferFrom(
207         address from,
208         address to,
209         uint256 value
210     ) external returns (bool);
211 
212     // Events
213     event Transfer(address indexed from, address indexed to, uint256 value);
214 
215     event Approval(
216         address indexed owner,
217         address indexed spender,
218         uint256 value
219     );
220 }
221 
222 contract PleStaking {
223     using SafeMath for uint256;
224     using EnumerableSet for EnumerableSet.AddressSet;
225     event RewardsTransferred(address holder, uint256 amount);
226 
227     IERC20 public tokenContract;
228 
229     address public tokenFeeAddress;
230 
231     // reward rate 40.00% per year
232     uint256 public constant rewardRate = 4000;
233     uint256 public constant rewardInterval = 365 days;
234 
235     // staking fee 1.50 percent
236     uint256 public constant stakingFeeRate = 150;
237 
238     // unstaking fee 0.50 percent
239     uint256 public constant unstakingFeeRate = 50;
240 
241     uint256 public totalClaimedRewards = 0;
242 
243     EnumerableSet.AddressSet private holders;
244 
245     mapping(address => uint256) public depositedTokens;
246     mapping(address => uint256) public stakingTime;
247     mapping(address => uint256) public lastClaimedTime;
248     mapping(address => uint256) public totalEarnedTokens;
249 
250     constructor(address _tokenAddress, address _tokenFeeAddress) public {
251         tokenContract = IERC20(_tokenAddress);
252         tokenFeeAddress = _tokenFeeAddress;
253     }
254 
255     function getBalance() private view returns (uint256) {
256         return tokenContract.balanceOf(address(this));
257     }
258 
259     function getRewardToken() private view returns (uint256) {
260         uint256 totalDepositedAmount = 0;
261         uint256 length = getNumberOfHolders();
262         for (uint256 i = 0; i < length; i = i.add(1)) {
263             uint256 depositedAmount = depositedTokens[holders.at(i)];
264             totalDepositedAmount = totalDepositedAmount.add(depositedAmount);
265         }
266 
267         return tokenContract.balanceOf(address(this)).sub(totalDepositedAmount);
268     }
269 
270     function distributeToken(address account) private {
271         uint256 pendingDivs = getPendingDivs(account);
272         if (pendingDivs > 0) {
273             tokenContract.balanceOf(address(this)).sub(pendingDivs);
274             tokenContract.balanceOf(account).add(pendingDivs);
275             require(
276                 tokenContract.transfer(account, pendingDivs),
277                 "Could not transfer tokens."
278             );
279             totalEarnedTokens[account] = totalEarnedTokens[account].add(
280                 pendingDivs
281             );
282             totalClaimedRewards = totalClaimedRewards.add(pendingDivs);
283             emit RewardsTransferred(account, pendingDivs);
284         }
285        lastClaimedTime[account] = now;
286     }
287   
288    
289     function getPendingDivs(address _holder) public view returns (uint256) {
290         if (!holders.contains(_holder)) return 0;
291         if (depositedTokens[_holder] == 0) return 0;
292         if (getRewardToken() == 0) return 0;
293 
294         uint256 timeDiff = now.sub(lastClaimedTime[_holder]);
295         uint256 stakedAmount = depositedTokens[_holder];
296         
297         uint256 pendingDivs = stakedAmount.mul(timeDiff).mul(rewardRate).div(rewardInterval).div(1e4);
298 
299         return pendingDivs;
300     }
301 
302     function getNumberOfHolders() public view returns (uint256) {
303         return holders.length();
304     }
305 
306     function stake(uint256 amountToStake) public {
307         require(amountToStake > 0, "Cannot deposit 0 Tokens");
308         require(
309             tokenContract.transferFrom(
310                 msg.sender,
311                 address(this),
312                 amountToStake
313             ),
314             "Insufficient Token Allowance"
315         );
316         
317       
318 
319         uint256 fee = amountToStake.mul(stakingFeeRate).div(1e4);
320         uint256 amountAfterFee = amountToStake.sub(fee);
321 
322         require(
323             tokenContract.transfer(tokenFeeAddress, fee),
324             "Could not transfer deposit fee."
325         );
326 
327         depositedTokens[msg.sender] = depositedTokens[msg.sender].add(
328             amountAfterFee
329         );
330 
331         if (!holders.contains(msg.sender)) {
332             holders.add(msg.sender);
333             stakingTime[msg.sender] = now;
334             lastClaimedTime[msg.sender] = now;
335         }
336     }
337 
338     function unstake(uint256 amountToWithdraw) public {
339         require(
340             depositedTokens[msg.sender] >= amountToWithdraw,
341             "Invalid amount to withdraw"
342         );
343         
344      
345         
346         uint256 fee = amountToWithdraw.mul(unstakingFeeRate).div(1e4);
347         uint256 amountAfterFee = amountToWithdraw.sub(fee);
348         require(
349             tokenContract.transfer(tokenFeeAddress, fee),
350             "Could not transfer unstaking fee."
351         );
352         require(
353             tokenContract.transfer(msg.sender, amountAfterFee),
354             "Could not transfer tokens."
355         );
356 
357         depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(
358             amountToWithdraw
359         );
360 
361         if (holders.contains(msg.sender) && depositedTokens[msg.sender] == 0) {
362             holders.remove(msg.sender);
363         }
364     }
365 
366     function claimDivs() public {
367         distributeToken(msg.sender);
368     }
369 
370     function getStakersList(uint256 startIndex, uint256 endIndex)
371         public
372         view
373         returns (
374             address[] memory stakers,
375             uint256[] memory stakingTimestamps,
376             uint256[] memory lastClaimedTimeStamps,
377             uint256[] memory stakedTokens
378         )
379     {
380         require(startIndex < endIndex);
381 
382         uint256 length = endIndex.sub(startIndex);
383         address[] memory _stakers = new address[](length);
384         uint256[] memory _stakingTimestamps = new uint256[](length);
385         uint256[] memory _lastClaimedTimeStamps = new uint256[](length);
386         uint256[] memory _stakedTokens = new uint256[](length);
387 
388         for (uint256 i = startIndex; i < endIndex; i = i.add(1)) {
389             address staker = holders.at(i);
390             uint256 listIndex = i.sub(startIndex);
391             _stakers[listIndex] = staker;
392             _stakingTimestamps[listIndex] = stakingTime[staker];
393             _lastClaimedTimeStamps[listIndex] = lastClaimedTime[staker];
394             _stakedTokens[listIndex] = depositedTokens[staker];
395         }
396 
397         return (
398             _stakers,
399             _stakingTimestamps,
400             _lastClaimedTimeStamps,
401             _stakedTokens
402         );
403     }
404 }