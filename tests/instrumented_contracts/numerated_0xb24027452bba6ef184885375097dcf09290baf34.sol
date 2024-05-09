1 pragma solidity 0.8.4;
2 library Address {
3     function isContract(address account) internal view returns (bool) {
4         uint256 size;
5         assembly {
6             size := extcodesize(account)
7         }
8         return size > 0;
9     }
10     function sendValue(address payable recipient, uint256 amount) internal {
11         require(
12             address(this).balance >= amount,
13             "Address: insufficient balance"
14         );
15         (bool success, ) = recipient.call{value: amount}("");
16         require(
17             success,
18             "Address: unable to send value, recipient may have reverted"
19         );
20     }
21     function functionCall(address target, bytes memory data)
22         internal
23         returns (bytes memory)
24     {
25         return functionCall(target, data, "Address: low-level call failed");
26     }
27     function functionCall(
28         address target,
29         bytes memory data,
30         string memory errorMessage
31     ) internal returns (bytes memory) {
32         return functionCallWithValue(target, data, 0, errorMessage);
33     }
34     function functionCallWithValue(
35         address target,
36         bytes memory data,
37         uint256 value
38     ) internal returns (bytes memory) {
39         return
40             functionCallWithValue(
41                 target,
42                 data,
43                 value,
44                 "Address: low-level call with value failed"
45             );
46     }
47     function functionCallWithValue(
48         address target,
49         bytes memory data,
50         uint256 value,
51         string memory errorMessage
52     ) internal returns (bytes memory) {
53         require(
54             address(this).balance >= value,
55             "Address: insufficient balance for call"
56         );
57         require(isContract(target), "Address: call to non-contract");
58         (bool success, bytes memory returndata) = target.call{value: value}(
59             data
60         );
61         return _verifyCallResult(success, returndata, errorMessage);
62     }
63     function functionStaticCall(address target, bytes memory data)
64         internal
65         view
66         returns (bytes memory)
67     {
68         return
69             functionStaticCall(
70                 target,
71                 data,
72                 "Address: low-level static call failed"
73             );
74     }
75     function functionStaticCall(
76         address target,
77         bytes memory data,
78         string memory errorMessage
79     ) internal view returns (bytes memory) {
80         require(isContract(target), "Address: static call to non-contract");
81         (bool success, bytes memory returndata) = target.staticcall(data);
82         return _verifyCallResult(success, returndata, errorMessage);
83     }
84     function functionDelegateCall(address target, bytes memory data)
85         internal
86         returns (bytes memory)
87     {
88         return
89             functionDelegateCall(
90                 target,
91                 data,
92                 "Address: low-level delegate call failed"
93             );
94     }
95     function functionDelegateCall(
96         address target,
97         bytes memory data,
98         string memory errorMessage
99     ) internal returns (bytes memory) {
100         require(isContract(target), "Address: delegate call to non-contract");
101         (bool success, bytes memory returndata) = target.delegatecall(data);
102         return _verifyCallResult(success, returndata, errorMessage);
103     }
104     function _verifyCallResult(
105         bool success,
106         bytes memory returndata,
107         string memory errorMessage
108     ) private pure returns (bytes memory) {
109         if (success) {
110             return returndata;
111         } else {
112             if (returndata.length > 0) {
113                 assembly {
114                     let returndata_size := mload(returndata)
115                     revert(add(32, returndata), returndata_size)
116                 }
117             } else {
118                 revert(errorMessage);
119             }
120         }
121     }
122 }
123 interface IERC20 {
124     function totalSupply() external view returns (uint256);
125     function balanceOf(address account) external view returns (uint256);
126     function transfer(address recipient, uint256 amount)
127         external
128         returns (bool);
129     function allowance(address owner, address spender)
130         external
131         view
132         returns (uint256);
133     function approve(address spender, uint256 amount) external returns (bool);
134     function transferFrom(
135         address sender,
136         address recipient,
137         uint256 amount
138     ) external returns (bool);
139     event Transfer(address indexed from, address indexed to, uint256 value);
140     event Approval(
141         address indexed owner,
142         address indexed spender,
143         uint256 value
144     );
145 }
146 library SafeERC20 {
147     using Address for address;
148     function safeTransfer(
149         IERC20 token,
150         address to,
151         uint256 value
152     ) internal {
153         _callOptionalReturn(
154             token,
155             abi.encodeWithSelector(token.transfer.selector, to, value)
156         );
157     }
158     function safeTransferFrom(
159         IERC20 token,
160         address from,
161         address to,
162         uint256 value
163     ) internal {
164         _callOptionalReturn(
165             token,
166             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
167         );
168     }
169     function safeApprove(
170         IERC20 token,
171         address spender,
172         uint256 value
173     ) internal {
174         require(
175             (value == 0) || (token.allowance(address(this), spender) == 0),
176             "SafeERC20: approve from non-zero to non-zero allowance"
177         );
178         _callOptionalReturn(
179             token,
180             abi.encodeWithSelector(token.approve.selector, spender, value)
181         );
182     }
183     function safeIncreaseAllowance(
184         IERC20 token,
185         address spender,
186         uint256 value
187     ) internal {
188         uint256 newAllowance = token.allowance(address(this), spender) + value;
189         _callOptionalReturn(
190             token,
191             abi.encodeWithSelector(
192                 token.approve.selector,
193                 spender,
194                 newAllowance
195             )
196         );
197     }
198     function safeDecreaseAllowance(
199         IERC20 token,
200         address spender,
201         uint256 value
202     ) internal {
203         unchecked {
204             uint256 oldAllowance = token.allowance(address(this), spender);
205             require(
206                 oldAllowance >= value,
207                 "SafeERC20: decreased allowance below zero"
208             );
209             uint256 newAllowance = oldAllowance - value;
210             _callOptionalReturn(
211                 token,
212                 abi.encodeWithSelector(
213                     token.approve.selector,
214                     spender,
215                     newAllowance
216                 )
217             );
218         }
219     }
220     function _callOptionalReturn(IERC20 token, bytes memory data) private {
221         bytes memory returndata = address(token).functionCall(
222             data,
223             "SafeERC20: low-level call failed"
224         );
225         if (returndata.length > 0) {
226             require(
227                 abi.decode(returndata, (bool)),
228                 "SafeERC20: ERC20 operation did not succeed"
229             );
230         }
231     }
232 }
233 abstract contract LockerTypes {
234     enum LockType {
235         ERC20,
236         LP
237     }
238     struct LockStorageRecord {
239         LockType ltype;
240         address token;
241         uint256 amount;
242         VestingRecord[] vestings;
243     }
244     struct VestingRecord {
245         uint256 unlockTime;
246         uint256 amountUnlock;
247         bool isNFT;
248     }
249     struct RegistryShare {
250         uint256 lockIndex;
251         uint256 sharePercent;
252         uint256 claimedAmount;
253     }
254 }
255 contract PicipoLocker is LockerTypes {
256     using SafeERC20 for IERC20;
257     string constant name = "Lock & Registry v0.0.2";
258     uint256 constant MAX_VESTING_RECORDS_PER_LOCK = 250;
259     uint256 constant TOTAL_IN_PERCENT = 10000;
260     LockStorageRecord[] lockerStorage;
261     mapping(address => RegistryShare[]) public registry;
262     mapping(uint256 => address[]) beneficiariesInLock;
263     event NewLock(
264         address indexed erc20,
265         address indexed who,
266         uint256 lockedAmount,
267         uint256 lockId
268     );
269     function lockTokens(
270         address _ERC20,
271         uint256 _amount,
272         uint256[] memory _unlockedFrom,
273         uint256[] memory _unlockAmount,
274         address[] memory _beneficiaries,
275         uint256[] memory _beneficiariesShares
276     ) external {
277         require(_amount > 0, "Cant lock 0 amount");
278         require(
279             IERC20(_ERC20).allowance(msg.sender, address(this)) >= _amount,
280             "Please approve first"
281         );
282         require(
283             _getArraySum(_unlockAmount) == _amount,
284             "Sum vesting records must be equal lock amount"
285         );
286         require(
287             _unlockedFrom.length == _unlockAmount.length,
288             "Length of periods and amounts arrays must be equal"
289         );
290         require(
291             _beneficiaries.length == _beneficiariesShares.length,
292             "Length of beneficiaries and shares arrays must be equal"
293         );
294         require(
295             _getArraySum(_beneficiariesShares) == TOTAL_IN_PERCENT,
296             "Sum of shares array must be equal to 100%"
297         );
298         VestingRecord[] memory v = new VestingRecord[](_unlockedFrom.length);
299         for (uint256 i = 0; i < _unlockedFrom.length; i++) {
300             v[i].unlockTime = _unlockedFrom[i];
301             v[i].amountUnlock = _unlockAmount[i];
302         }
303         LockStorageRecord storage lock = lockerStorage.push();
304         lock.ltype = LockType.ERC20;
305         lock.token = _ERC20;
306         lock.amount = _amount;
307         for (uint256 i = 0; i < _unlockedFrom.length; i++) {
308             lock.vestings.push(v[i]);
309         }
310         for (uint256 i = 0; i < _beneficiaries.length; i++) {
311             RegistryShare[] storage shares = registry[_beneficiaries[i]];
312             shares.push(
313                 RegistryShare({
314                     lockIndex: lockerStorage.length - 1,
315                     sharePercent: _beneficiariesShares[i],
316                     claimedAmount: 0
317                 })
318             );
319             beneficiariesInLock[lockerStorage.length - 1].push(
320                 _beneficiaries[i]
321             );
322         }
323         IERC20 token = IERC20(_ERC20);
324         token.safeTransferFrom(msg.sender, address(this), _amount);
325         emit NewLock(_ERC20, msg.sender, _amount, lockerStorage.length - 1);
326     }
327     function claimTokens(uint256 _lockIndex, uint256 _desiredAmount) external {
328         require(_lockIndex < lockerStorage.length, "Lock record not saved yet");
329         require(_desiredAmount > 0, "Cant claim zero");
330         LockStorageRecord memory lock = lockerStorage[_lockIndex];
331         (
332             uint256 percentShares,
333             uint256 wasClaimed
334         ) = _getUserSharePercentAndClaimedAmount(msg.sender, _lockIndex);
335         uint256 availableAmount = (_getAvailableAmountByLockIndex(_lockIndex) *
336             percentShares) /
337             TOTAL_IN_PERCENT -
338             wasClaimed;
339         require(_desiredAmount <= availableAmount, "Insufficient for now");
340         availableAmount = _desiredAmount;
341         _decreaseAvailableAmount(msg.sender, _lockIndex, availableAmount);
342         IERC20 token = IERC20(lock.token);
343         token.safeTransfer(msg.sender, availableAmount);
344     }
345     function getUserShares(address _user)
346         external
347         view
348         returns (RegistryShare[] memory)
349     {
350         return _getUsersShares(_user);
351     }
352     function getUserBalances(address _user, uint256 _lockIndex)
353         external
354         view
355         returns (uint256, uint256)
356     {
357         return _getUserBalances(_user, _lockIndex);
358     }
359     function getLockRecordByIndex(uint256 _index)
360         external
361         view
362         returns (LockStorageRecord memory)
363     {
364         return _getLockRecordByIndex(_index);
365     }
366     function getLockCount() external view returns (uint256) {
367         return lockerStorage.length;
368     }
369     function getArraySum(uint256[] memory _array)
370         external
371         pure
372         returns (uint256)
373     {
374         return _getArraySum(_array);
375     }
376     function _decreaseAvailableAmount(
377         address user,
378         uint256 _lockIndex,
379         uint256 _amount
380     ) internal {
381         RegistryShare[] storage shares = registry[user];
382         for (uint256 i = 0; i < shares.length; i++) {
383             if (shares[i].lockIndex == _lockIndex) {
384                 shares[i].claimedAmount += _amount;
385                 break;
386             }
387         }
388     }
389     function _getArraySum(uint256[] memory _array)
390         internal
391         pure
392         returns (uint256)
393     {
394         uint256 res = 0;
395         for (uint256 i = 0; i < _array.length; i++) {
396             res += _array[i];
397         }
398         return res;
399     }
400     function _getAvailableAmountByLockIndex(uint256 _lockIndex)
401         internal
402         view
403         returns (uint256)
404     {
405         VestingRecord[] memory v = lockerStorage[_lockIndex].vestings;
406         uint256 res = 0;
407         for (uint256 i = 0; i < v.length; i++) {
408             if (v[i].unlockTime <= block.timestamp && !v[i].isNFT) {
409                 res += v[i].amountUnlock;
410             }
411         }
412         return res;
413     }
414     function _getUserSharePercentAndClaimedAmount(
415         address _user,
416         uint256 _lockIndex
417     ) internal view returns (uint256 percent, uint256 claimed) {
418         RegistryShare[] memory shares = registry[_user];
419         for (uint256 i = 0; i < shares.length; i++) {
420             if (shares[i].lockIndex == _lockIndex) {
421                 percent += shares[i].sharePercent;
422                 claimed += shares[i].claimedAmount;
423             }
424         }
425         return (percent, claimed);
426     }
427     function _getUsersShares(address _user)
428         internal
429         view
430         returns (RegistryShare[] memory)
431     {
432         return registry[_user];
433     }
434     function _getUserBalances(address _user, uint256 _lockIndex)
435         internal
436         view
437         returns (uint256, uint256)
438     {
439         (
440             uint256 percentShares,
441             uint256 wasClaimed
442         ) = _getUserSharePercentAndClaimedAmount(_user, _lockIndex);
443         uint256 totalBalance = (lockerStorage[_lockIndex].amount *
444             percentShares) /
445             TOTAL_IN_PERCENT -
446             wasClaimed;
447         uint256 available = (_getAvailableAmountByLockIndex(_lockIndex) *
448             percentShares) /
449             TOTAL_IN_PERCENT -
450             wasClaimed;
451         return (totalBalance, available);
452     }
453     function _getVestingsByLockIndex(uint256 _index)
454         internal
455         view
456         returns (VestingRecord[] memory)
457     {
458         VestingRecord[] memory v = _getLockRecordByIndex(_index).vestings;
459         return v;
460     }
461     function _getLockRecordByIndex(uint256 _index)
462         internal
463         view
464         returns (LockStorageRecord memory)
465     {
466         return lockerStorage[_index];
467     }
468 }