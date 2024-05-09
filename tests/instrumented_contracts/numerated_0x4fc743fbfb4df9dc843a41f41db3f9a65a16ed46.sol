1 pragma solidity 0.5.8;
2 
3 contract Ownable {
4 
5     address public owner;
6 
7     event NewOwner(address indexed old, address indexed current);
8 
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     function setOwner(address _new)
19         public
20         onlyOwner
21     {
22         require(_new != address(0));
23         owner = _new;
24         emit NewOwner(owner, _new);
25     }
26 }
27 
28 interface IERC20 {
29     
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33     /// @notice send `_value` token to `_to` from `msg.sender`
34     /// @param _to The address of the recipient
35     /// @param _value The amount of token to be transferred
36     /// @return Whether the transfer was successful or not
37     function transfer(address _to, uint256 _value) external returns (bool success);
38 
39     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
40     /// @param _from The address of the sender
41     /// @param _to The address of the recipient
42     /// @param _value The amount of token to be transferred
43     /// @return Whether the transfer was successful or not
44     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
45 
46     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
47     /// @param _spender The address of the account able to transfer the tokens
48     /// @param _value The amount of wei to be approved for transfer
49     /// @return Whether the approval was successful or not
50     function approve(address _spender, uint256 _value) external returns (bool success);
51     
52     /// @param _owner The address from which the balance will be retrieved
53     /// @return The balance
54     function balanceOf(address _owner) external view returns (uint256 balance);
55 
56     /// @param _owner The address of the account owning tokens
57     /// @param _spender The address of the account able to transfer the tokens
58     /// @return Amount of remaining tokens allowed to spent
59     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
60 }
61 
62 contract SafeMath {
63 
64     function safeMul(uint256 a, uint256 b)
65         internal
66         pure
67         returns (uint256)
68     {
69         if (a == 0) {
70             return 0;
71         }
72         uint256 c = a * b;
73         require(
74             c / a == b,
75             "UINT256_OVERFLOW"
76         );
77         return c;
78     }
79 
80     function safeDiv(uint256 a, uint256 b)
81         internal
82         pure
83         returns (uint256)
84     {
85         uint256 c = a / b;
86         return c;
87     }
88 
89     function safeSub(uint256 a, uint256 b)
90         internal
91         pure
92         returns (uint256)
93     {
94         require(
95             b <= a,
96             "UINT256_UNDERFLOW"
97         );
98         return a - b;
99     }
100 
101     function safeAdd(uint256 a, uint256 b)
102         internal
103         pure
104         returns (uint256)
105     {
106         uint256 c = a + b;
107         require(
108             c >= a,
109             "UINT256_OVERFLOW"
110         );
111         return c;
112     }
113 
114     function max64(uint64 a, uint64 b)
115         internal
116         pure
117         returns (uint256)
118     {
119         return a >= b ? a : b;
120     }
121 
122     function min64(uint64 a, uint64 b)
123         internal
124         pure
125         returns (uint256)
126     {
127         return a < b ? a : b;
128     }
129 
130     function max256(uint256 a, uint256 b)
131         internal
132         pure
133         returns (uint256)
134     {
135         return a >= b ? a : b;
136     }
137 
138     function min256(uint256 a, uint256 b)
139         internal
140         pure
141         returns (uint256)
142     {
143         return a < b ? a : b;
144     }
145 }
146 
147 contract ProgressiveUnlockWallet is Ownable, SafeMath {
148 
149     mapping(address => VestingSchedule) public schedules;        // vesting schedules for given addresses
150     mapping(address => address) public addressChangeRequests;    // requested address changes
151 
152     IERC20 vestingToken;
153 
154     event VestingScheduleRegistered(
155         address indexed registeredAddress,
156         address depositor,
157         uint startTimeInSec,
158         uint cliffTimeInSec,
159         uint endTimeInSec,
160         uint totalAmount
161     );
162 
163     event VestingScheduleConfirmed(
164         address indexed registeredAddress,
165         address depositor,
166         uint startTimeInSec,
167         uint cliffTimeInSec,
168         uint endTimeInSec,
169         uint totalAmount
170     );
171 
172     event Withdrawal(
173         address indexed registeredAddress,
174         uint amountWithdrawn
175     );
176 
177     event AddressChangeRequested(
178         address indexed oldRegisteredAddress,
179         address indexed newRegisteredAddress
180     );
181 
182     event AddressChangeConfirmed(
183         address indexed oldRegisteredAddress,
184         address indexed newRegisteredAddress
185     );
186 
187     struct VestingSchedule {
188         uint startTimeInSec;
189         uint cliffTimeInSec;
190         uint endTimeInSec;
191         uint totalAmount;
192         uint totalAmountWithdrawn;
193         address depositor;
194         bool isConfirmed;
195     }
196 
197     modifier addressRegistered(address target) {
198         VestingSchedule storage vestingSchedule = schedules[target];
199         require(vestingSchedule.depositor != address(0));
200         _;
201     }
202 
203     modifier addressNotRegistered(address target) {
204         VestingSchedule storage vestingSchedule = schedules[target];
205         require(vestingSchedule.depositor == address(0));
206         _;
207     }
208 
209     modifier vestingScheduleConfirmed(address target) {
210         VestingSchedule storage vestingSchedule = schedules[target];
211         require(vestingSchedule.isConfirmed);
212         _;
213     }
214 
215     modifier vestingScheduleNotConfirmed(address target) {
216         VestingSchedule storage vestingSchedule = schedules[target];
217         require(!vestingSchedule.isConfirmed);
218         _;
219     }
220 
221     modifier pendingAddressChangeRequest(address target) {
222         require(addressChangeRequests[target] != address(0));
223         _;
224     }
225 
226     modifier pastCliffTime(address target) {
227         VestingSchedule storage vestingSchedule = schedules[target];
228         require(block.timestamp > vestingSchedule.cliffTimeInSec);
229         _;
230     }
231 
232     modifier validVestingScheduleTimes(uint startTimeInSec, uint cliffTimeInSec, uint endTimeInSec) {
233         require(cliffTimeInSec >= startTimeInSec);
234         require(endTimeInSec >= cliffTimeInSec);
235         _;
236     }
237 
238     modifier addressNotNull(address target) {
239         require(target != address(0));
240         _;
241     }
242 
243     /// @dev Assigns a vesting token to the wallet.
244     /// @param _vestingToken Token that will be vested.
245     constructor(address _vestingToken) public {
246         vestingToken = IERC20(_vestingToken);
247     }
248 
249     /// @dev Registers a vesting schedule to an address.
250     /// @param _addressToRegister The address that is allowed to withdraw vested tokens for this schedule.
251     /// @param _depositor Address that will be depositing vesting token.
252     /// @param _startTimeInSec The time in seconds that vesting began.
253     /// @param _cliffTimeInSec The time in seconds that tokens become withdrawable.
254     /// @param _endTimeInSec The time in seconds that vesting ends.
255     /// @param _totalAmount The total amount of tokens that the registered address can withdraw by the end of the vesting period.
256     function registerVestingSchedule(
257         address _addressToRegister,
258         address _depositor,
259         uint _startTimeInSec,
260         uint _cliffTimeInSec,
261         uint _endTimeInSec,
262         uint _totalAmount
263     )
264         public
265         onlyOwner
266         addressNotNull(_depositor)
267         vestingScheduleNotConfirmed(_addressToRegister)
268         validVestingScheduleTimes(_startTimeInSec, _cliffTimeInSec, _endTimeInSec)
269     {
270         schedules[_addressToRegister] = VestingSchedule({
271             startTimeInSec: _startTimeInSec,
272             cliffTimeInSec: _cliffTimeInSec,
273             endTimeInSec: _endTimeInSec,
274             totalAmount: _totalAmount,
275             totalAmountWithdrawn: 0,
276             depositor: _depositor,
277             isConfirmed: false
278         });
279 
280         emit VestingScheduleRegistered(
281             _addressToRegister,
282             _depositor,
283             _startTimeInSec,
284             _cliffTimeInSec,
285             _endTimeInSec,
286             _totalAmount
287         );
288     }
289 
290     /// @dev Confirms a vesting schedule and deposits necessary tokens. Throws if deposit fails or schedules do not match.
291     /// @param _startTimeInSec The time in seconds that vesting began.
292     /// @param _cliffTimeInSec The time in seconds that tokens become withdrawable.
293     /// @param _endTimeInSec The time in seconds that vesting ends.
294     /// @param _totalAmount The total amount of tokens that the registered address can withdraw by the end of the vesting period.
295     function confirmVestingSchedule(
296         uint _startTimeInSec,
297         uint _cliffTimeInSec,
298         uint _endTimeInSec,
299         uint _totalAmount
300     )
301         public
302         addressRegistered(msg.sender)
303         vestingScheduleNotConfirmed(msg.sender)
304     {
305         VestingSchedule storage vestingSchedule = schedules[msg.sender];
306 
307         require(vestingSchedule.startTimeInSec == _startTimeInSec);
308         require(vestingSchedule.cliffTimeInSec == _cliffTimeInSec);
309         require(vestingSchedule.endTimeInSec == _endTimeInSec);
310         require(vestingSchedule.totalAmount == _totalAmount);
311 
312         vestingSchedule.isConfirmed = true;
313         require(vestingToken.transferFrom(vestingSchedule.depositor, address(this), _totalAmount));
314 
315         emit VestingScheduleConfirmed(
316             msg.sender,
317             vestingSchedule.depositor,
318             _startTimeInSec,
319             _cliffTimeInSec,
320             _endTimeInSec,
321             _totalAmount
322         );
323     }
324 
325     /// @dev Allows a registered address to withdraw tokens that have already been vested.
326     function withdraw()
327         public
328         vestingScheduleConfirmed(msg.sender)
329         pastCliffTime(msg.sender)
330     {
331         VestingSchedule storage vestingSchedule = schedules[msg.sender];
332 
333         uint totalAmountVested = getTotalAmountVested(vestingSchedule);
334         uint amountWithdrawable = safeSub(totalAmountVested, vestingSchedule.totalAmountWithdrawn);
335         vestingSchedule.totalAmountWithdrawn = totalAmountVested;
336 
337         if (amountWithdrawable > 0) {
338             require(vestingToken.transfer(msg.sender, amountWithdrawable));
339             emit Withdrawal(msg.sender, amountWithdrawable);
340         }
341     }
342 
343     /// @dev Allows a registered address to request an address change.
344     /// @param _newRegisteredAddress Desired address to update to.
345     function requestAddressChange(address _newRegisteredAddress)
346         public
347         vestingScheduleConfirmed(msg.sender)
348         addressNotRegistered(_newRegisteredAddress)
349         addressNotNull(_newRegisteredAddress)
350     {
351         addressChangeRequests[msg.sender] = _newRegisteredAddress;
352         emit AddressChangeRequested(msg.sender, _newRegisteredAddress);
353     }
354 
355     /// @dev Confirm an address change and migrate vesting schedule to new address.
356     /// @param _oldRegisteredAddress Current registered address.
357     /// @param _newRegisteredAddress Address to migrate vesting schedule to.
358     function confirmAddressChange(address _oldRegisteredAddress, address _newRegisteredAddress)
359         public
360         onlyOwner
361         pendingAddressChangeRequest(_oldRegisteredAddress)
362         addressNotRegistered(_newRegisteredAddress)
363     {
364         address newRegisteredAddress = addressChangeRequests[_oldRegisteredAddress];
365         require(newRegisteredAddress == _newRegisteredAddress);    // prevents race condition
366 
367         VestingSchedule memory vestingSchedule = schedules[_oldRegisteredAddress];
368         schedules[newRegisteredAddress] = vestingSchedule;
369 
370         delete schedules[_oldRegisteredAddress];
371         delete addressChangeRequests[_oldRegisteredAddress];
372 
373         emit AddressChangeConfirmed(_oldRegisteredAddress, _newRegisteredAddress);
374     }
375 
376     /// @dev Calculates the total tokens that have been vested for a vesting schedule, assuming the schedule is past the cliff.
377     /// @param vestingSchedule Vesting schedule used to calculate vested tokens.
378     /// @return Total tokens vested for a vesting schedule.
379     function getTotalAmountVested(VestingSchedule memory vestingSchedule)
380         internal
381         view
382         returns (uint)
383     {
384         if (block.timestamp >= vestingSchedule.endTimeInSec) return vestingSchedule.totalAmount;
385 
386         uint timeSinceStartInSec = safeSub(block.timestamp, vestingSchedule.startTimeInSec);
387         uint totalVestingTimeInSec = safeSub(vestingSchedule.endTimeInSec, vestingSchedule.startTimeInSec);
388         uint totalAmountVested = safeDiv(
389             safeMul(timeSinceStartInSec, vestingSchedule.totalAmount),
390             totalVestingTimeInSec
391         );
392 
393         return totalAmountVested;
394     }
395 }