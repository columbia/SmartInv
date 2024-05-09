1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      */
25     function isContract(address account) internal view returns (bool) {
26         // This method relies on extcodesize, which returns 0 for contracts in
27         // construction, since the code is only stored at the end of the
28         // constructor execution.
29 
30         uint256 size;
31         // solhint-disable-next-line no-inline-assembly
32         assembly { size := extcodesize(account) }
33         return size > 0;
34     }
35 
36     /**
37      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
38      * `recipient`, forwarding all available gas and reverting on errors.
39      *
40      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
41      * of certain opcodes, possibly making contracts go over the 2300 gas limit
42      * imposed by `transfer`, making them unable to receive funds via
43      * `transfer`. {sendValue} removes this limitation.
44      *
45      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
46      *
47      * IMPORTANT: because control is transferred to `recipient`, care must be
48      * taken to not create reentrancy vulnerabilities. Consider using
49      * {ReentrancyGuard} or the
50      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
51      */
52     function sendValue(address payable recipient, uint256 amount) internal {
53         require(address(this).balance >= amount, "Address: insufficient balance");
54 
55         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
56         (bool success, ) = recipient.call{ value: amount }("");
57         require(success, "Address: unable to send value, recipient may have reverted");
58     }
59 
60     /**
61      * @dev Performs a Solidity function call using a low level `call`. A
62      * plain`call` is an unsafe replacement for a function call: use this
63      * function instead.
64      *
65      * If `target` reverts with a revert reason, it is bubbled up by this
66      * function (like regular Solidity function calls).
67      *
68      * Returns the raw returned data. To convert to the expected return value,
69      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
70      *
71      * Requirements:
72      *
73      * - `target` must be a contract.
74      * - calling `target` with `data` must not revert.
75      *
76      * _Available since v3.1._
77      */
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
79       return functionCall(target, data, "Address: low-level call failed");
80     }
81 
82     /**
83      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
84      * `errorMessage` as a fallback revert reason when `target` reverts.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89         return functionCallWithValue(target, data, 0, errorMessage);
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
94      * but also transferring `value` wei to `target`.
95      *
96      * Requirements:
97      *
98      * - the calling contract must have an ETH balance of at least `value`.
99      * - the called Solidity function must be `payable`.
100      *
101      * _Available since v3.1._
102      */
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
109      * with `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114         require(address(this).balance >= value, "Address: insufficient balance for call");
115         require(isContract(target), "Address: call to non-contract");
116 
117         // solhint-disable-next-line avoid-low-level-calls
118         (bool success, bytes memory returndata) = target.call{ value: value }(data);
119         return _verifyCallResult(success, returndata, errorMessage);
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
124      * but performing a static call.
125      *
126      * _Available since v3.3._
127      */
128     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
129         return functionStaticCall(target, data, "Address: low-level static call failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
134      * but performing a static call.
135      *
136      * _Available since v3.3._
137      */
138     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
139         require(isContract(target), "Address: static call to non-contract");
140 
141         // solhint-disable-next-line avoid-low-level-calls
142         (bool success, bytes memory returndata) = target.staticcall(data);
143         return _verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a delegate call.
149      *
150      * _Available since v3.4._
151      */
152     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a delegate call.
159      *
160      * _Available since v3.4._
161      */
162     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
163         require(isContract(target), "Address: delegate call to non-contract");
164 
165         // solhint-disable-next-line avoid-low-level-calls
166         (bool success, bytes memory returndata) = target.delegatecall(data);
167         return _verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
171         if (success) {
172             return returndata;
173         } else {
174             // Look for revert reason and bubble it up if present
175             if (returndata.length > 0) {
176                 // The easiest way to bubble the revert reason is using memory via assembly
177 
178                 // solhint-disable-next-line no-inline-assembly
179                 assembly {
180                     let returndata_size := mload(returndata)
181                     revert(add(32, returndata), returndata_size)
182                 }
183             } else {
184                 revert(errorMessage);
185             }
186         }
187     }
188 }
189 
190 /**
191  * @dev Interface of the ERC20 standard as defined in the EIP.
192  */
193 
194 interface IERC20 {
195     /**
196      * @dev Returns the amount of tokens in existence.
197      */
198     function totalSupply() external view returns (uint256);
199 
200     /**
201      * @dev Returns the amount of tokens owned by `account`.
202      */
203     function balanceOf(address account) external view returns (uint256);
204 
205     /**
206      * @dev Moves `amount` tokens from the caller's account to `recipient`.
207      *
208      * Returns a boolean value indicating whether the operation succeeded.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transfer(address recipient, uint256 amount) external returns (bool);
213 
214     /**
215      * @dev Returns the remaining number of tokens that `spender` will be
216      * allowed to spend on behalf of `owner` through {transferFrom}. This is
217      * zero by default.
218      *
219      * This value changes when {approve} or {transferFrom} are called.
220      */
221     function allowance(address owner, address spender) external view returns (uint256);
222 
223     /**
224      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
225      *
226      * Returns a boolean value indicating whether the operation succeeded.
227      *
228      * IMPORTANT: Beware that changing an allowance with this method brings the risk
229      * that someone may use both the old and the new allowance by unfortunate
230      * transaction ordering. One possible solution to mitigate this race
231      * condition is to first reduce the spender's allowance to 0 and set the
232      * desired value afterwards:
233      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234      *
235      * Emits an {Approval} event.
236      */
237     function approve(address spender, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Moves `amount` tokens from `sender` to `recipient` using the
241      * allowance mechanism. `amount` is then deducted from the caller's
242      * allowance.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Emitted when `value` tokens are moved from one account (`from`) to
252      * another (`to`).
253      *
254      * Note that `value` may be zero.
255      */
256     event Transfer(address indexed from, address indexed to, uint256 value);
257 
258     /**
259      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
260      * a call to {approve}. `value` is the new allowance.
261      */
262     event Approval(address indexed owner, address indexed spender, uint256 value);
263 }
264 
265 /**
266  * @title SafeERC20
267  * @dev Wrappers around ERC20 operations that throw on failure (when the token
268  * contract returns false). Tokens that return no value (and instead revert or
269  * throw on failure) are also supported, non-reverting calls are assumed to be
270  * successful.
271  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
272  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
273  */
274 library SafeERC20 {
275     using Address for address;
276 
277     function safeTransfer(IERC20 token, address to, uint256 value) internal {
278         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
279     }
280 
281     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
282         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
283     }
284 
285     /**
286      * @dev Deprecated. This function has issues similar to the ones found in
287      * {IERC20-approve}, and its usage is discouraged.
288      *
289      * Whenever possible, use {safeIncreaseAllowance} and
290      * {safeDecreaseAllowance} instead.
291      */
292     function safeApprove(IERC20 token, address spender, uint256 value) internal {
293         // safeApprove should only be called when setting an initial allowance,
294         // or when resetting it to zero. To increase and decrease it, use
295         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
296         // solhint-disable-next-line max-line-length
297         require((value == 0) || (token.allowance(address(this), spender) == 0),
298             "SafeERC20: approve from non-zero to non-zero allowance"
299         );
300         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
301     }
302 
303     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
304         uint256 newAllowance = token.allowance(address(this), spender) + value;
305         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
306     }
307 
308     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
309         unchecked {
310             uint256 oldAllowance = token.allowance(address(this), spender);
311             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
312             uint256 newAllowance = oldAllowance - value;
313             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
314         }
315     }
316 
317     /**
318      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
319      * on the return value: the return value is optional (but if data is returned, it must not be false).
320      * @param token The token targeted by the call.
321      * @param data The call data (encoded using abi.encode or one of its variants).
322      */
323     function _callOptionalReturn(IERC20 token, bytes memory data) private {
324         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
325         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
326         // the target address contains contract code and also asserts for success in the low-level call.
327 
328         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
329         if (returndata.length > 0) { // Return data is optional
330             // solhint-disable-next-line max-line-length
331             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
332         }
333     }
334 }
335 
336 contract SwapToken{
337     
338     using SafeERC20 for IERC20;
339     
340     IERC20 public oldToken;
341     IERC20 public newToken;
342     
343     address public owner;
344     
345     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
346     
347     constructor(IERC20 _oldToken, IERC20 _newToken){
348         owner = msg.sender;
349         oldToken = _oldToken;
350         newToken = _newToken;
351     }
352     
353     modifier onlyOwner{
354         require(owner == msg.sender, "Only owner can call this function");
355         _;
356     }
357     
358     function claimToken(uint _amount) public{
359         uint bal = oldTokenBalance(msg.sender);
360         require(_amount <= bal, "Incorrect amount");
361         require(oldToken.allowance(msg.sender, address(this)) >= _amount, "not approved");
362         oldToken.safeTransferFrom(msg.sender, deadAddress, _amount);
363         newToken.safeTransfer(msg.sender, _amount);
364     }
365     
366     function oldTokenBalance(address userAddress) public view returns(uint){
367         return oldToken.balanceOf(userAddress);
368     }
369     
370     function newTokenBalance(address userAddress) public view returns(uint){
371         return newToken.balanceOf(userAddress);
372     }
373     
374     function oldTokenContractBalance() public view returns(uint){
375         return oldToken.balanceOf(address(this));
376     }
377     
378     function newTokenCntractBalance() public view returns(uint){
379         return newToken.balanceOf(address(this));
380     }
381 
382     
383     
384     // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)
385     // Admin cannot transfer out Staking Token from this smart contract
386     function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
387         IERC20(_tokenAddr).transfer(_to, _amount);
388     }
389     
390 }