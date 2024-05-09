1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      * - Addition cannot overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21 
22     /**
23      * @dev Returns the subtraction of two unsigned integers, reverting on
24      * overflow (when the result is negative).
25      *
26      * Counterpart to Solidity's `-` operator.
27      *
28      * Requirements:
29      * - Subtraction cannot overflow.
30      */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b > 0, errorMessage);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
111      * Reverts when dividing by zero.
112      *
113      * Counterpart to Solidity's `%` operator. This function uses a `revert`
114      * opcode (which leaves remaining gas untouched) while Solidity uses an
115      * invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      * - The divisor cannot be zero.
119      */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         return mod(a, b, "SafeMath: modulo by zero");
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts with custom message when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b != 0, errorMessage);
137         return a % b;
138     }
139 }
140 
141 interface IERC20 {
142     /**
143      * @dev Returns the amount of tokens in existence.
144      */
145     function totalSupply() external view returns (uint256);
146 
147     /**
148      * @dev Returns the amount of tokens owned by `account`.
149      */
150     function balanceOf(address account) external view returns (uint256);
151 
152     /**
153      * @dev Moves `amount` tokens from the caller's account to `recipient`.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transfer(address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Returns the remaining number of tokens that `spender` will be
163      * allowed to spend on behalf of `owner` through {transferFrom}. This is
164      * zero by default.
165      *
166      * This value changes when {approve} or {transferFrom} are called.
167      */
168     function allowance(address owner, address spender) external view returns (uint256);
169 
170     /**
171      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * IMPORTANT: Beware that changing an allowance with this method brings the risk
176      * that someone may use both the old and the new allowance by unfortunate
177      * transaction ordering. One possible solution to mitigate this race
178      * condition is to first reduce the spender's allowance to 0 and set the
179      * desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      *
182      * Emits an {Approval} event.
183      */
184     function approve(address spender, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Moves `amount` tokens from `sender` to `recipient` using the
188      * allowance mechanism. `amount` is then deducted from the caller's
189      * allowance.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
196 
197     /**
198      * @dev Returns the decimals places of the token.
199      */
200     function decimals() external view returns (uint8);
201 
202     /**
203      * @dev Emitted when `value` tokens are moved from one account (`from`) to
204      * another (`to`).
205      *
206      * Note that `value` may be zero.
207      */
208     event Transfer(address indexed from, address indexed to, uint256 value);
209 
210     /**
211      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
212      * a call to {approve}. `value` is the new allowance.
213      */
214     event Approval(address indexed owner, address indexed spender, uint256 value);
215 }
216 
217 contract VictoriaVRVesting {
218 
219     using SafeMath for uint256;
220 
221     IERC20 public token = IERC20(0x7d5121505149065b562C789A0145eD750e6E8cdD);
222 
223     address public owner;
224 
225     uint256 public startUnlockTime = 1654174800;  //2022-06-02 13:00:00 UTC
226 
227     uint256 public maxUnlockDay = 3 * 365;
228 
229     uint256 public unlockCycle = 1 days;
230 
231     uint256 public totalTokenLock = 0;
232 
233     struct UnlockInfo {
234         bool status;
235         uint256 amount;
236         uint256 unlockDayAmount;
237         uint256 unlockTotal;
238     }
239 
240     mapping(address => UnlockInfo) public userUnlockInfos;
241 
242     event EventUnlockToken(address indexed _address, uint256 _amount);
243 
244     modifier onlyOwner() {
245         require(
246             msg.sender == owner,
247             "You don't have permission."
248         );
249         _;
250     }
251 
252     constructor() public {
253         owner = msg.sender;
254     }
255 
256     function initializeDefaultWallet() public onlyOwner {
257         addAddressInfo(0x35ea0493e66724fb333180E5cB12cAadFaf96E70, tokenDecimals(915254));
258         addAddressInfo(0x395b5010425e814E6dCAfBcF2aA97703cD16CE5a, tokenDecimals(1525424));
259         addAddressInfo(0x68e41f435a7b5E64deb5eb2992dAd631d2778516, tokenDecimals(915254));
260         addAddressInfo(0x86D55d842c4E08bf30429b4363301A4F7427897b, tokenDecimals(1220339));
261         addAddressInfo(0x497a2566F804e36eEc34C3dffF79d66761D9B330, tokenDecimals(1220339));
262         addAddressInfo(0x90BBCbe91a042558ed9589ddf9f180E736886FC3, tokenDecimals(1220339));
263         addAddressInfo(0x228B858cFEE0EAe28231B6AFFb92eec6feca23a2, tokenDecimals(762712));
264         addAddressInfo(0x7694eeC0387d0C63C0483D33F48D7DB5b4077c83, tokenDecimals(1525424));
265         addAddressInfo(0x96F89B37334dBA99b867ab812C1bbDf2E2103D23, tokenDecimals(610169));
266         addAddressInfo(0xe92D80a90bc050A12F1c6fBE0e50e1B5A874B595, tokenDecimals(1830508));
267         addAddressInfo(0x565FF310603E3CE035a8433DE6b54Bf2ED925882, tokenDecimals(762712));
268         addAddressInfo(0x181348D19d4c5eDdb9383C34bdc7eAfacA6d127D, tokenDecimals(1830508));
269         addAddressInfo(0xBBd6e8B4a644a1a511fd95f6a0e81Db3C03a7E16, tokenDecimals(1372881));
270         addAddressInfo(0x31ac5eb1Dfe36C8981BCA66Fe0ab962fFE8E2b13, tokenDecimals(457627));
271         addAddressInfo(0x0036d68CCab1677179cD7A5c8c8568Dc7907eAc8, tokenDecimals(305085));
272         addAddressInfo(0x5bDdac61eF3549041B58347aC4615434E0898f84, tokenDecimals(610169));
273         addAddressInfo(0xd98d95dcA7e33bd5725ef56180bDAEe69877d819, tokenDecimals(1830508));
274         addAddressInfo(0xa29B56729C9a2F0bcCbD46eacf7DF7C07D9E2f6E, tokenDecimals(1525424));
275         addAddressInfo(0xBA715566ebB933102651465B02e8dBa50B29DD43, tokenDecimals(61017));
276         addAddressInfo(0x5b1aBc65B45C035108A17638AaC5eA53a83e9B88, tokenDecimals(15254237));
277         addAddressInfo(0x754A2193fe7Ede8e4630063E588cb0Ff5a02Fc28, tokenDecimals(15254237));
278         addAddressInfo(0x0Ae21aa1EfC542CF183aD0Ef8CD969bb11040aA8, tokenDecimals(15254237));
279         addAddressInfo(0xD35504BA8397a9f9ade45E7F20725F7987415425, tokenDecimals(3050847));
280         addAddressInfo(0xA47F5DfB53f617cBCE164f29B26273e9332631C4, tokenDecimals(6101695));
281         addAddressInfo(0x65Ac6d86c6bEBBfC84522b4E28861eBF66f6A1bA, tokenDecimals(3050847));
282         addAddressInfo(0x41E3FE77DE1EcA115902eB058b1FB57395358d62, tokenDecimals(3050847));
283         addAddressInfo(0xb73f8AbC0371b1AB67f9dAAEdb7eCBc1b1dD7e79, tokenDecimals(6711864));
284         addAddressInfo(0xA938924AA74Db378d77A1639e76D2cCc2226FB67, tokenDecimals(3050847));
285         addAddressInfo(0x40e400325Cff0833bcE814ddAEEF8EC6C6f24963, tokenDecimals(30508475));
286         addAddressInfo(0xB1799600bB5DB171760C2a9fF6e9795d46EB700D, tokenDecimals(14338983));
287         addAddressInfo(0x70031213C95DeECfa44a6C438BcA25134A292eef, tokenDecimals(9152542));
288         addAddressInfo(0x1b75c6DC2C2cff9E6eAF54c5d72b3447740f1e76, tokenDecimals(4423729));
289         addAddressInfo(0x505Ffa6194f6e443b86F2028b2a97A588c17b962, tokenDecimals(30508475));
290         addAddressInfo(0xc6717341508568AC9Da4821BE8e31ca650c42C79, tokenDecimals(15254237));
291         addAddressInfo(0x0aD7A09575e3eC4C109c4FaA3BE7cdafc5a4aDBa, tokenDecimals(173076712));
292         addAddressInfo(0x6782Be6D8e69C8790EA6079328DA96B7358093C5, tokenDecimals(17602780));
293         addAddressInfo(0x52B40914d9d42e0070CbA75A6879E65022D5B218, tokenDecimals(3050847));
294         addAddressInfo(0x86B337Be60C942e80f31e7Be097De1cA821c5f7F, tokenDecimals(15254237));
295         addAddressInfo(0xE9090c96795F8936b3bF5c72B23D4A244Cd0Db13, tokenDecimals(22881356));
296         addAddressInfo(0xfeD3a086D43B60D97E5CEF9E7C34F2c6BB11d2C7, tokenDecimals(7627119));
297         addAddressInfo(0x037B1624848Abfc22552f445475CeBb7e2414F18, tokenDecimals(7627119));
298         addAddressInfo(0xE72EB31b59F85b19499A0F3b3260011894FA0d65, tokenDecimals(7627119));
299         addAddressInfo(0xd61951E5983646AE63d1236cdd112BBB5E10E159, tokenDecimals(6101695));
300         addAddressInfo(0xa0fF757077B5D796259582b2b9Db99c906277007, tokenDecimals(9152542));
301         addAddressInfo(0xc11B259aF1B7791Ee1D78b19D35a3Caf1fd90cbD, tokenDecimals(3050847));
302         addAddressInfo(0xf6269806D9f8cc48B87167a19dbCF0214026D22D, tokenDecimals(342884746));
303         addAddressInfo(0xd999074F947f9813bDD161Fb2452332ac6a4D695, tokenDecimals(7932203));
304         addAddressInfo(0x704c7A3d5Cf7289751d2B5e2F129982b854C939d, tokenDecimals(15254237));
305         addAddressInfo(0xfb4334A5704e29DF37efc9F16255759670018D9A, tokenDecimals(9152542));
306     }
307 
308     function tokenDecimals(uint256 _amount) public view returns(uint256) {
309         return _amount * (10 ** uint256(token.decimals()));
310     }
311 
312     function tokenBalanceOf() public view returns(uint256) {
313         return token.balanceOf(address(this));
314     }
315     
316     function addAddressInfoNoDecimals(address _address, uint256 _amount) public onlyOwner {
317         addAddressInfo(_address, tokenDecimals(_amount));
318     }
319 
320     function addAddressInfo(address _address, uint256 _amount) public onlyOwner {
321         totalTokenLock = totalTokenLock.add(_amount);
322         UnlockInfo storage ui = userUnlockInfos[_address];
323         require(
324             ui.status == false,
325             "This wallet has been added to the unlock contract."
326         );
327         ui.status = true;
328         ui.amount = _amount;
329         ui.unlockDayAmount = _amount.div(maxUnlockDay);
330     }
331 
332     function deleteAddressInfo(address _address) public onlyOwner {
333         UnlockInfo storage ui = userUnlockInfos[_address];
334         require(
335             ui.status == true,
336             "This wallet is not in the current unlocking plan."
337         );
338         delete userUnlockInfos[_address];
339     }
340 
341     function blockTimestamp() public virtual view returns(uint256) {
342         return block.timestamp;
343     }
344 
345     function getAvailableDay() public virtual view returns(uint256) {
346         require(
347             blockTimestamp() > startUnlockTime,
348             "Unlocking time has not started yet."
349         );
350         return blockTimestamp().sub(startUnlockTime).div(unlockCycle);
351     }
352 
353     function unlockToken() public {
354         uint256 availableDay = getAvailableDay();
355         require(
356             availableDay > 0,
357             "Unlocking time has not started yet."
358         );
359         UnlockInfo storage ui = userUnlockInfos[msg.sender];
360         require(
361             ui.status == true,
362             "This wallet is not in the current unlocking plan."
363         );
364         require(
365             ui.amount > ui.unlockTotal,
366             "The user has no available unlocking limit."
367         );
368         uint256 availableAmount = availableDay.mul(ui.unlockDayAmount);
369         if(availableAmount > ui.amount) {
370             availableAmount = ui.amount;
371         }
372         availableAmount = availableAmount.sub(ui.unlockTotal);
373         require(
374             availableAmount > 0,
375             "The user has no available unlocking limit."
376         );
377         ui.unlockTotal = ui.unlockTotal.add(availableAmount);
378         _safeTransfer(msg.sender, availableAmount);
379     }
380 
381     function _safeTransfer(address _address, uint256 _amount) private {
382         token.transfer(_address, _amount);
383         totalTokenLock = totalTokenLock.sub(_amount);
384         emit EventUnlockToken(_address, _amount);
385     }
386 }