1 pragma solidity ^0.5.16;
2 
3 /*
4     Marketing plan cube, works on VOMER technology, terms of service
5     1 line 50%
6     2 line 20%
7     bonus marketing up to 12 lines of 1%.
8     rules 1 connection opens 1 line additionally.
9     12/12/12
10 */
11 
12 library SafeMath {
13     /**
14      * @dev Returns the addition of two unsigned integers, reverting on
15      * overflow.
16      *
17      * Counterpart to Solidity's `+` operator.
18      *
19      * Requirements:
20      * - Addition cannot overflow.
21      */
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25 
26         return c;
27     }
28 
29     /**
30      * @dev Returns the subtraction of two unsigned integers, reverting on
31      * overflow (when the result is negative).
32      *
33      * Counterpart to Solidity's `-` operator.
34      *
35      * Requirements:
36      * - Subtraction cannot overflow.
37      */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a, "SafeMath: subtraction overflow");
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `*` operator.
50      *
51      * Requirements:
52      * - Multiplication cannot overflow.
53      */
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56         // benefit is lost if 'b' is also tested.
57         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58         if (a == 0) {
59             return 0;
60         }
61 
62         uint256 c = a * b;
63         require(c / a == b, "SafeMath: multiplication overflow");
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the integer division of two unsigned integers. Reverts on
70      * division by zero. The result is rounded towards zero.
71      *
72      * Counterpart to Solidity's `/` operator. Note: this function uses a
73      * `revert` opcode (which leaves remaining gas untouched) while Solidity
74      * uses an invalid opcode to revert (consuming all remaining gas).
75      *
76      * Requirements:
77      * - The divisor cannot be zero.
78      */
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Solidity only automatically asserts when dividing by 0
81         require(b > 0, "SafeMath: division by zero");
82         uint256 c = a / b;
83         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
90      * Reverts when dividing by zero.
91      *
92      * Counterpart to Solidity's `%` operator. This function uses a `revert`
93      * opcode (which leaves remaining gas untouched) while Solidity uses an
94      * invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b != 0, "SafeMath: modulo by zero");
101         return a % b;
102     }
103 }
104 
105 contract ERC20 {
106     uint public decimals;
107     function allowance(address, address) public view returns (uint);
108     function balanceOf(address) public view returns (uint);
109     function approve(address, uint) public;
110     function transfer(address, uint) public returns (bool);
111     function transferFrom(address, address, uint) public returns (bool);
112 }
113 
114 /**
115  * @dev Collection of functions related to the address type,
116  */
117 library Address {
118     /**
119      * @dev Returns true if `account` is a contract.
120      *
121      * This test is non-exhaustive, and there may be false-negatives: during the
122      * execution of a contract's constructor, its address will be reported as
123      * not containing a contract.
124      *
125      * > It is unsafe to assume that an address for which this function returns
126      * false is an externally-owned account (EOA) and not a contract.
127      */
128     function isContract(address account) internal view returns (bool) {
129         // This method relies in extcodesize, which returns 0 for contracts in
130         // construction, since the code is only stored at the end of the
131         // constructor execution.
132 
133         uint256 size;
134         // solhint-disable-next-line no-inline-assembly
135         assembly { size := extcodesize(account) }
136         return size > 0;
137     }
138 }
139 
140 /**
141  * @title SafeERC20
142  * @dev Wrappers around ERC20 operations that throw on failure (when the token
143  * contract returns false). Tokens that return no value (and instead revert or
144  * throw on failure) are also supported, non-reverting calls are assumed to be
145  * successful.
146  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
147  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
148  */
149 library SafeERC20 {
150     
151     using SafeMath for uint256;
152     using Address for address;
153 
154     function safeTransfer(ERC20 token, address to, uint256 value) internal {
155         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
156     }
157 
158     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
159         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
160     }
161 
162     function safeApprove(ERC20 token, address spender, uint256 value) internal {
163         // safeApprove should only be called when setting an initial allowance,
164         // or when resetting it to zero. To increase and decrease it, use
165         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
166         // solhint-disable-next-line max-line-length
167         require((value == 0) || (token.allowance(address(this), spender) == 0),
168             "SafeERC20: approve from non-zero to non-zero allowance"
169         );
170         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
171     }
172 
173     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
174         uint256 newAllowance = token.allowance(address(this), spender).add(value);
175         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
176     }
177 
178     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
179         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
180         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
181     }
182 
183     /**
184      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
185      * on the return value: the return value is optional (but if data is returned, it must not be false).
186      * @param token The token targeted by the call.
187      * @param data The call data (encoded using abi.encode or one of its variants).
188      */
189     function callOptionalReturn(ERC20 token, bytes memory data) private {
190         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
191         // we're implementing it ourselves.
192 
193         // A Solidity high level call has three parts:
194         //  1. The target address is checked to verify it contains contract code
195         //  2. The call itself is made, and success asserted
196         //  3. The return value is decoded, which in turn checks the size of the returned data.
197         // solhint-disable-next-line max-line-length
198         require(address(token).isContract(), "SafeERC20: call to non-contract");
199 
200         // solhint-disable-next-line avoid-low-level-calls
201         (bool success, bytes memory returndata) = address(token).call(data);
202         require(success, "SafeERC20: low-level call failed");
203 
204         if (returndata.length > 0) { // Return data is optional
205             // solhint-disable-next-line max-line-length
206             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
207         }
208     }
209 }
210 
211 library UniversalERC20 {
212 
213     using SafeMath for uint256;
214     using SafeERC20 for ERC20;
215 
216     ERC20 private constant ZERO_ADDRESS = ERC20(0x0000000000000000000000000000000000000000);
217     ERC20 private constant ETH_ADDRESS = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
218 
219     function universalTransfer(ERC20 token, address to, uint256 amount) internal {
220         universalTransfer(token, to, amount, false);
221     }
222 
223     function universalTransfer(ERC20 token, address to, uint256 amount, bool mayFail) internal returns(bool) {
224         if (amount == 0) {
225             return true;
226         }
227 
228         if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
229             if (mayFail) {
230                 return address(uint160(to)).send(amount);
231             } else {
232                 address(uint160(to)).transfer(amount);
233                 return true;
234             }
235         } else {
236             token.safeTransfer(to, amount);
237             return true;
238         }
239     }
240 
241     function universalApprove(ERC20 token, address to, uint256 amount) internal {
242         if (token != ZERO_ADDRESS && token != ETH_ADDRESS) {
243             token.safeApprove(to, amount);
244         }
245     }
246 
247     function universalTransferFrom(ERC20 token, address from, address to, uint256 amount) internal {
248         if (amount == 0) {
249             return;
250         }
251 
252         if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
253             require(from == msg.sender && msg.value >= amount, "msg.value is zero");
254             if (to != address(this)) {
255                 address(uint160(to)).transfer(amount);
256             }
257             if (msg.value > amount) {
258                 msg.sender.transfer(uint256(msg.value).sub(amount));
259             }
260         } else {
261             token.safeTransferFrom(from, to, amount);
262         }
263     }
264 
265     function universalBalanceOf(ERC20 token, address who) internal view returns (uint256) {
266         if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
267             return who.balance;
268         } else {
269             return token.balanceOf(who);
270         }
271     }
272 }
273 
274 contract Ownable {
275     address payable public owner = msg.sender;
276     address payable public newOwnerCandidate;
277     
278     modifier onlyOwner()
279     {
280         assert(msg.sender == owner);
281         _;
282     }
283     
284     function changeOwnerCandidate(address payable newOwner) public onlyOwner {
285         newOwnerCandidate = newOwner;
286     }
287     
288     function acceptOwner() public {
289         require(msg.sender == newOwnerCandidate);
290         owner = newOwnerCandidate;
291     }
292 }
293 
294 contract Cube is Ownable
295 {
296     using SafeMath for uint256;
297     using UniversalERC20 for ERC20;
298     
299     uint256 minAmountOfEthToBeEffectiveRefferal = 0.25 ether;
300     
301     function changeMinAmountOfEthToBeEffectiveRefferal(uint256 minAmount) onlyOwner public {
302         minAmountOfEthToBeEffectiveRefferal = minAmount;
303     }
304     
305     // Withdraw and lock funds
306     uint256 public fundsLockedtoWithdraw;
307     uint256 public dateUntilFundsLocked;
308     
309     function lockFunds(uint256 amount) public onlyOwner {
310         // funds lock is active
311         if (dateUntilFundsLocked > now) {
312             require(amount > fundsLockedtoWithdraw);
313         }
314         fundsLockedtoWithdraw = amount;
315         dateUntilFundsLocked = now + 30 days;
316     }
317     
318     function bytesToAddress(bytes memory bys) private pure returns (address payable addr) {
319         assembly {
320           addr := mload(add(bys,20))
321         } 
322     }
323     
324     ERC20 private constant ZERO_ADDRESS = ERC20(0x0000000000000000000000000000000000000000);
325     ERC20 private constant ETH_ADDRESS = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
326     
327     // function for transfer any token from contract
328     function transferTokens(ERC20 token, address target, uint256 amount) onlyOwner public
329     {
330         if (target == address(0x0)) target = owner;
331         
332         if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
333             if (dateUntilFundsLocked > now) require(address(this).balance.sub(amount) > fundsLockedtoWithdraw);
334         }
335         ERC20(token).universalTransfer(target, amount);
336     }
337     
338 
339     mapping(address => address) refList;
340     
341     struct UserData {
342         uint256 invested;    
343         uint256[12] pendingReward;
344         uint256 receivedReward;
345         uint128 refUserCount;
346         uint128 effectiveRefUserCount;
347         uint256 createdAt;
348         bool partnerRewardActivated;
349     }
350     mapping(address => UserData) users;
351     
352     function getRefByUser(address addr) view public returns (address) {
353         return refList[addr];
354     }
355     
356     function getUserInfo(address addr) view public returns (uint256 invested, uint256[12] memory pendingReward, uint256 receivedReward, uint256 refUserCount, uint128 effectiveRefUserCount, uint256 createdAt, bool partnerRewardActivated) {
357         invested = users[addr].invested;
358         pendingReward = users[addr].pendingReward;
359         receivedReward = users[addr].receivedReward;
360         refUserCount = users[addr].refUserCount;
361         effectiveRefUserCount = users[addr].effectiveRefUserCount;
362         createdAt = users[addr].createdAt;
363         partnerRewardActivated = users[addr].partnerRewardActivated;
364     }
365     
366     function getLevelReward(uint8 level) pure internal returns(uint256 rewardLevel, uint128 minUsersRequired) {
367         if (level == 0) 
368             return (50, 0); 
369         else if (level == 1)
370             return (20, 0); 
371         else if (level < 12)
372             return (1, level);
373         else             
374             return (0,0);
375     }
376     
377     event Reward(address indexed userAddress, uint256 amount);
378     
379     function withdrawReward() public {
380         UserData storage user = users[msg.sender];
381         address payable userAddress = msg.sender;
382         
383         require(user.invested >= minAmountOfEthToBeEffectiveRefferal);
384         
385         uint256 reward = 0;
386         
387         bool isUserUnactive = ((user.createdAt > 0 && (block.timestamp - user.createdAt) >= 365 days) && (user.effectiveRefUserCount < 12));
388         
389         for(uint8 i = 0; i < 12;i++) {
390             // user can't get reward after level 2
391             if (i >= 2 && isUserUnactive) break;
392             
393             uint128 minUsersRequired;
394             (, minUsersRequired) = getLevelReward(i);
395             
396             if (user.effectiveRefUserCount >= minUsersRequired) {
397                 if (user.pendingReward[i] > 0) {
398                     reward = reward.add(user.pendingReward[i]);
399                     user.pendingReward[i] = 0;
400                 }
401             } else {
402                 break;
403             }
404         }
405                     
406         emit Reward(msg.sender, reward);
407         user.receivedReward = user.receivedReward.add(reward);
408         userAddress.transfer(reward);
409     }
410     
411     function isUnactiveUser(UserData memory user ) view internal returns (bool) {
412         return  (user.createdAt > 0 && (block.timestamp - user.createdAt) >= 365 days) && (user.effectiveRefUserCount < 12);
413     }
414     
415     address payable addressSupportProject = 0x598f9A85483641F0A4c18d02cC1210f4C81eF1e0;
416     address payable addressAdv = 0xbcA88515dBE20fa9F8FAB6718e8C1A40C876Cfd4;
417     address payable addressRes = 0x2b192b50AfE554023A71762101e3aF044783Bf10;
418     
419     function () payable external
420     {
421         assert(msg.sender == tx.origin); // prevent bots to interact with contract
422         
423         if (msg.sender == owner) return; 
424         
425         if (msg.value == 0) {
426             withdrawReward();
427             return;
428         }
429         
430         require(msg.value >= 0.01 ether); 
431         
432         address payable ref;
433         if (refList[msg.sender] != address(0))
434         {
435             ref = address(uint160(refList[msg.sender]));
436         } else {
437             require(msg.data.length == 20);
438             ref = bytesToAddress(msg.data);
439             assert(ref != msg.sender);
440         
441             refList[msg.sender] = ref;
442         }
443         
444         
445         uint256 ethAmountRest = msg.value;
446         
447         UserData storage user = users[msg.sender];
448         
449         // если новый пользователь - увеличиваем у партнёра кол-во привлечённых людей
450         bool isNewUser = user.createdAt == 0;
451         if (isNewUser)  {
452             users[ref].refUserCount++;
453             user.createdAt = block.timestamp;
454         }
455         
456         user.invested = user.invested.add(msg.value);
457         if (!user.partnerRewardActivated && user.invested > minAmountOfEthToBeEffectiveRefferal) {
458             user.partnerRewardActivated = true;
459             users[ref].effectiveRefUserCount++;
460         }
461         
462         
463         for(uint8 i = 0;i < 12;i++) {
464             uint256 rewardAmount;
465             uint128 minUsersRequired;
466             (rewardAmount, minUsersRequired) = getLevelReward(i);
467             
468             uint256 rewardForRef = msg.value * rewardAmount / 100;
469             ethAmountRest = ethAmountRest.sub(rewardForRef);
470 
471             users[ref].pendingReward[minUsersRequired] += rewardForRef;    
472             
473             ref = address(uint160(refList[address(ref)]));
474             if (ref == address(0)) break;
475         }
476         
477         addressSupportProject.transfer(ethAmountRest * 5 / 100);
478         addressAdv.transfer(ethAmountRest * 5 / 100);
479         addressRes.transfer(ethAmountRest * 10 / 100);
480     }
481 }