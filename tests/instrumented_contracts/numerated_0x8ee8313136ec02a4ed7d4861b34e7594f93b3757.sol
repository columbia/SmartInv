1 pragma solidity >=0.4.14 <0.6.0;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev give an account access to this role
14      */
15     function add(Role storage role, address account) internal {
16         require(account != address(0));
17         require(!has(role, account));
18 
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev remove an account's access to this role
24      */
25     function remove(Role storage role, address account) internal {
26         require(account != address(0));
27         require(has(role, account));
28 
29         role.bearer[account] = false;
30     }
31 
32     /**
33      * @dev check if an account has this role
34      * @return bool
35      */
36     function has(Role storage role, address account) internal view returns (bool) {
37         require(account != address(0));
38         return role.bearer[account];
39     }
40 }
41 
42 /**
43  * @title WhitelistAdminRole
44  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
45  */
46 contract WhitelistAdminRole {
47     using Roles for Roles.Role;
48 
49     event WhitelistAdminAdded(address indexed account);
50     event WhitelistAdminRemoved(address indexed account);
51 
52     Roles.Role private _whitelistAdmins;
53 
54     constructor () internal {
55         _addWhitelistAdmin(msg.sender);
56     }
57 
58     modifier onlyWhitelistAdmin() {
59         require(isWhitelistAdmin(msg.sender));
60         _;
61     }
62 
63     function isWhitelistAdmin(address account) public view returns (bool) {
64         return _whitelistAdmins.has(account);
65     }
66 
67     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
68         _addWhitelistAdmin(account);
69     }
70 
71     function renounceWhitelistAdmin() public {
72         _removeWhitelistAdmin(msg.sender);
73     }
74 
75     function _addWhitelistAdmin(address account) internal {
76         _whitelistAdmins.add(account);
77         emit WhitelistAdminAdded(account);
78     }
79 
80     function _removeWhitelistAdmin(address account) internal {
81         _whitelistAdmins.remove(account);
82         emit WhitelistAdminRemoved(account);
83     }
84 }
85 
86 /**
87  * @title SafeMath
88  * @dev Unsigned math operations with safety checks that revert on error
89  */
90 library SafeMath {
91     /**
92     * @dev Multiplies two unsigned integers, reverts on overflow.
93     */
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
96         // benefit is lost if 'b' is also tested.
97         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
98         if (a == 0) {
99             return 0;
100         }
101 
102         uint256 c = a * b;
103         require(c / a == b);
104 
105         return c;
106     }
107 
108     /**
109     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
110     */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Solidity only automatically asserts when dividing by 0
113         require(b > 0);
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
122     */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a);
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131     * @dev Adds two unsigned integers, reverts on overflow.
132     */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a);
136 
137         return c;
138     }
139 
140     /**
141     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
142     * reverts when dividing by zero.
143     */
144     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145         require(b != 0);
146         return a % b;
147     }
148 }
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 interface IERC20 {
155     function transfer(address to, uint256 value) external returns (bool);
156 
157     function approve(address spender, uint256 value) external returns (bool);
158 
159     function transferFrom(address from, address to, uint256 value) external returns (bool);
160 
161     function totalSupply() external view returns (uint256);
162 
163     function balanceOf(address who) external view returns (uint256);
164 
165     function allowance(address owner, address spender) external view returns (uint256);
166 
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 /**
173  * @title SafeERC20
174  * @dev Wrappers around ERC20 operations that throw on failure.
175  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
176  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
177  */
178 library SafeERC20 {
179     using SafeMath for uint256;
180 
181     function safeTransfer(IERC20 token, address to, uint256 value) internal {
182         require(token.transfer(to, value));
183     }
184 
185     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
186         require(token.transferFrom(from, to, value));
187     }
188 
189     function safeApprove(IERC20 token, address spender, uint256 value) internal {
190         // safeApprove should only be called when setting an initial allowance,
191         // or when resetting it to zero. To increase and decrease it, use
192         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
193         require((value == 0) || (token.allowance(address(this), spender) == 0));
194         require(token.approve(spender, value));
195     }
196 
197     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
198         uint256 newAllowance = token.allowance(address(this), spender).add(value);
199         require(token.approve(spender, newAllowance));
200     }
201 
202     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
203         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
204         require(token.approve(spender, newAllowance));
205     }
206 }
207 
208 
209 /// @author QuarkChain Eng Team
210 /// @title A simplified term deposit contract for ERC20 tokens
211 contract TermDepositSimplified is WhitelistAdminRole {
212 
213     using SafeMath for uint256;
214     using SafeERC20 for IERC20;
215 
216     event DoDeposit(address indexed depositor, uint256 amount);
217     event Withdraw(address indexed depositor, uint256 amount);
218     event Drain(address indexed admin);
219     event Pause(address indexed admin, bool isPaused);
220     event Goodbye(address indexed admin, uint256 amount);
221 
222     uint256 public constant MIN_DEPOSIT = 100 * 1e18;  // => 100 QKC.
223     // Pre-defined terms.
224     bytes4 public constant TERM_2MO = "2mo";
225     bytes4 public constant TERM_4MO = "4mo";
226     bytes4 public constant TERM_6MO = "6mo";
227 
228     struct TermDepositInfo {
229         uint256 duration;
230         uint256 totalReceived;
231         mapping (address => Deposit[]) deposits;
232     }
233 
234     struct Deposit {
235         uint256 amount;
236         uint256 depositAt;
237         uint256 withdrawAt;
238     }
239 
240     mapping (bytes4 => TermDepositInfo) private _termDeposits;
241     IERC20 private _token;
242     bool   private _isPaused = false;
243 
244     bytes4[] public allTerms = [TERM_2MO, TERM_4MO, TERM_6MO];
245 
246     /// Constructor for the term deposit contract.
247     /// @param token ERC20 token addresses for term deposit
248     constructor(IERC20 token) public {
249         uint256 monthInSec = 2635200;
250         _token = token;
251 
252         _termDeposits[TERM_2MO] = TermDepositInfo({
253             duration: 2 * monthInSec,
254             totalReceived: 0
255         });
256 
257         _termDeposits[TERM_4MO] = TermDepositInfo({
258             duration: 4 * monthInSec,
259             totalReceived: 0
260         });
261 
262         _termDeposits[TERM_6MO] = TermDepositInfo({
263             duration: 6 * monthInSec,
264             totalReceived: 0
265         });
266     }
267 
268     /// Getter for token address.
269     /// @return the token address
270     function token() public view returns (IERC20) {
271         return _token;
272     }
273 
274     /// Return a term deposit's key properties.
275     /// @param term the byte representation of terms
276     /// @return a list of deposit overview info
277     function getTermDepositInfo(bytes4 term) public view returns (uint256[2] memory) {
278         TermDepositInfo memory info = _termDeposits[term];
279         require(info.duration > 0, "should be a valid term");
280         return [
281             info.duration,
282             info.totalReceived
283         ];
284     }
285 
286     /// Deposit users tokens into this contract.
287     /// @param term the byte representation of terms
288     /// @param amount token amount in wei
289     function deposit(bytes4 term, uint256 amount) public {
290         require(!_isPaused, "deposit not allowed when contract is paused");
291         require(amount >= MIN_DEPOSIT, "should have amount >= minimum");
292         TermDepositInfo storage info = _termDeposits[term];
293         require(info.duration > 0, "should be a valid term");
294 
295         Deposit[] storage deposits = info.deposits[msg.sender];
296         deposits.push(Deposit({
297             amount: amount,
298             depositAt: now,
299             withdrawAt: 0
300         }));
301         info.totalReceived = info.totalReceived.add(amount);
302         emit DoDeposit(msg.sender, amount);
303 
304         _token.safeTransferFrom(msg.sender, address(this), amount);
305     }
306 
307     /// Calculate amount of tokens a user has deposited.
308     /// @param depositor the address of the depositor
309     /// @param terms the list of byte representation of terms
310     /// @param withdrawable boolean flag for whether to require withdrawable
311     /// @return amount of tokens available for withdrawal
312     function getDepositAmount(
313         address depositor,
314         bytes4[] memory terms,
315         bool withdrawable
316     ) public view returns (uint256[] memory)
317     {
318         uint256[] memory ret = new uint256[](terms.length);
319         for (uint256 i = 0; i < terms.length; i++) {
320             TermDepositInfo storage info = _termDeposits[terms[i]];
321             require(info.duration > 0, "should be a valid term");
322             Deposit[] memory deposits = info.deposits[depositor];
323 
324             uint256 total = 0;
325             for (uint256 j = 0; j < deposits.length; j++) {
326                 uint256 lockUntil = deposits[j].depositAt.add(info.duration);
327                 if (deposits[j].withdrawAt == 0) {
328                     if (!withdrawable || now >= lockUntil) {
329                         total = total.add(deposits[j].amount);
330                     }
331                 }
332             }
333             ret[i] = total;
334         }
335         return ret;
336     }
337 
338     /// Get detailed deposit information of a user.
339     /// @param depositor the address of the depositor
340     /// @param terms the list of byte representation of terms
341     /// @return 1 array for terms, 3 arrays of deposit amounts, deposit / withdrawal timestamps
342     function getDepositDetails(
343         address depositor,
344         bytes4[] memory terms
345     ) public view returns (bytes4[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
346     {
347         Deposit[][] memory depositListByTerms = new Deposit[][](terms.length);
348 
349         // Collect count first because dynamic array in memory is not allowed.
350         uint256 totalDepositCount = 0;
351         for (uint256 i = 0; i < terms.length; i++) {
352             bytes4 term = terms[i];
353             TermDepositInfo storage info = _termDeposits[term];
354             require(info.duration > 0, "should be a valid term");
355             Deposit[] memory deposits = info.deposits[depositor];
356             depositListByTerms[i] = deposits;
357             totalDepositCount = totalDepositCount.add(deposits.length);
358         }
359 
360         bytes4[] memory depositTerms = new bytes4[](totalDepositCount);
361         uint256[] memory amounts = new uint256[](totalDepositCount);
362         uint256[] memory depositTs = new uint256[](totalDepositCount);
363         uint256[] memory withdrawTs = new uint256[](totalDepositCount);
364         uint256 retIndex = 0;
365         for (uint256 i = 0; i < depositListByTerms.length; i++) {
366             Deposit[] memory deposits = depositListByTerms[i];
367             for (uint256 j = 0; j < deposits.length; j++) {
368                 depositTerms[retIndex] = terms[i];
369                 Deposit memory d = deposits[j];
370                 amounts[retIndex] = d.amount;
371                 depositTs[retIndex] = d.depositAt;
372                 withdrawTs[retIndex] = d.withdrawAt;
373                 retIndex += 1;
374             }
375         }
376         assert(retIndex == totalDepositCount);
377         return (depositTerms, amounts, depositTs, withdrawTs);
378     }
379 
380     /// Withdraw a user's tokens plus interest to his/her own address.
381     /// @param terms the list of byte representation of terms
382     /// @return whether have withdrawn some tokens successfully
383     function withdraw(bytes4[] memory terms) public returns (bool) {
384         require(!_isPaused, "withdraw not allowed when contract is paused");
385 
386         uint256 total = 0;
387         for (uint256 i = 0; i < terms.length; i++) {
388             bytes4 term = terms[i];
389             TermDepositInfo storage info = _termDeposits[term];
390             require(info.duration > 0, "should be a valid term");
391             Deposit[] storage deposits = info.deposits[msg.sender];
392 
393             uint256 termTotal = 0;
394             for (uint256 j = 0; j < deposits.length; j++) {
395                 uint256 lockUntil = deposits[j].depositAt.add(info.duration);
396                 if (deposits[j].withdrawAt == 0 && now >= lockUntil) {
397                     termTotal = termTotal.add(deposits[j].amount);
398                     deposits[j].withdrawAt = now;
399                 }
400             }
401 
402             info.totalReceived = info.totalReceived.sub(termTotal);
403             total = total.add(termTotal);
404         }
405 
406         if (total == 0) {
407             return false;
408         }
409         emit Withdraw(msg.sender, total);
410         _token.safeTransfer(msg.sender, total);
411         return true;
412     }
413 
414     /// Return necessary amount of tokens to cover interests and referral bonuses.
415     /// @param terms the list of byte representation of terms
416     /// @return total deposit
417     function calculateTotalPayout(bytes4[] memory terms) public view returns (uint256) {
418         // [deposit, interest, bonus].
419         uint256 ret;
420         for (uint256 i = 0; i < terms.length; i++) {
421             TermDepositInfo memory info = _termDeposits[terms[i]];
422             require(info.duration > 0, "should be a valid term");
423             ret = ret.add(info.totalReceived);
424         }
425         return ret;
426     }
427 
428     /// Leave enough tokens for payout, and drain the surplus.
429     /// @dev only admins can call this function
430     function drainSurplusTokens() external onlyWhitelistAdmin {
431         emit Drain(msg.sender);
432 
433         uint256 neededAmount = calculateTotalPayout(allTerms);
434         uint256 currentAmount = _token.balanceOf(address(this));
435         if (currentAmount > neededAmount) {
436             uint256 surplus = currentAmount.sub(neededAmount);
437             _token.safeTransfer(msg.sender, surplus);
438         }
439     }
440 
441     /// Pause deposit and withdraw
442     /// @dev only admins can call this function
443     function pause(bool isPaused) external onlyWhitelistAdmin {
444         _isPaused = isPaused;
445 
446         emit Pause(msg.sender, _isPaused);
447     }
448 
449     /// Drain remaining tokens and destroys the contract to save some space for the network.
450     /// @dev only admins can call this function
451     function goodbye() external onlyWhitelistAdmin {
452         // Make sure is after deposit deadline, and no received tokens.
453         for (uint256 i = 0; i < allTerms.length; i++) {
454             bytes4 term = allTerms[i];
455             TermDepositInfo memory info = _termDeposits[term];
456             require(info.totalReceived < 1000 * 1e18, "should have small enough deposits");
457         }
458         // Transfer remaining tokens.
459         uint256 tokenAmount = _token.balanceOf(address(this));
460         emit Goodbye(msg.sender, tokenAmount);
461         if (tokenAmount > 0) {
462             _token.safeTransfer(msg.sender, tokenAmount);
463         }
464         // Say goodbye.
465         selfdestruct(msg.sender);
466     }
467 }