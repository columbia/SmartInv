1 pragma solidity 0.4.25;
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
147 contract VestingWallet is Ownable, SafeMath {
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
177     event VestingEndedByOwner(
178         address indexed registeredAddress,
179         uint amountWithdrawn, uint amountRefunded
180     );
181 
182     event AddressChangeRequested(
183         address indexed oldRegisteredAddress,
184         address indexed newRegisteredAddress
185     );
186 
187     event AddressChangeConfirmed(
188         address indexed oldRegisteredAddress,
189         address indexed newRegisteredAddress
190     );
191 
192     struct VestingSchedule {
193         uint startTimeInSec;
194         uint cliffTimeInSec;
195         uint endTimeInSec;
196         uint totalAmount;
197         uint totalAmountWithdrawn;
198         address depositor;
199         bool isConfirmed;
200     }
201 
202     modifier addressRegistered(address target) {
203         VestingSchedule storage vestingSchedule = schedules[target];
204         require(vestingSchedule.depositor != address(0));
205         _;
206     }
207 
208     modifier addressNotRegistered(address target) {
209         VestingSchedule storage vestingSchedule = schedules[target];
210         require(vestingSchedule.depositor == address(0));
211         _;
212     }
213 
214     modifier vestingScheduleConfirmed(address target) {
215         VestingSchedule storage vestingSchedule = schedules[target];
216         require(vestingSchedule.isConfirmed);
217         _;
218     }
219 
220     modifier vestingScheduleNotConfirmed(address target) {
221         VestingSchedule storage vestingSchedule = schedules[target];
222         require(!vestingSchedule.isConfirmed);
223         _;
224     }
225 
226     modifier pendingAddressChangeRequest(address target) {
227         require(addressChangeRequests[target] != address(0));
228         _;
229     }
230 
231     modifier pastCliffTime(address target) {
232         VestingSchedule storage vestingSchedule = schedules[target];
233         require(block.timestamp > vestingSchedule.cliffTimeInSec);
234         _;
235     }
236 
237     modifier validVestingScheduleTimes(uint startTimeInSec, uint cliffTimeInSec, uint endTimeInSec) {
238         require(cliffTimeInSec >= startTimeInSec);
239         require(endTimeInSec >= cliffTimeInSec);
240         _;
241     }
242 
243     modifier addressNotNull(address target) {
244         require(target != address(0));
245         _;
246     }
247 
248     /// @dev Assigns a vesting token to the wallet.
249     /// @param _vestingToken Token that will be vested.
250     constructor(address _vestingToken) public {
251         vestingToken = IERC20(_vestingToken);
252     }
253 
254     /// @dev Registers a vesting schedule to an address.
255     /// @param _addressToRegister The address that is allowed to withdraw vested tokens for this schedule.
256     /// @param _depositor Address that will be depositing vesting token.
257     /// @param _startTimeInSec The time in seconds that vesting began.
258     /// @param _cliffTimeInSec The time in seconds that tokens become withdrawable.
259     /// @param _endTimeInSec The time in seconds that vesting ends.
260     /// @param _totalAmount The total amount of tokens that the registered address can withdraw by the end of the vesting period.
261     function registerVestingSchedule(
262         address _addressToRegister,
263         address _depositor,
264         uint _startTimeInSec,
265         uint _cliffTimeInSec,
266         uint _endTimeInSec,
267         uint _totalAmount
268     )
269         public
270         onlyOwner
271         addressNotNull(_depositor)
272         vestingScheduleNotConfirmed(_addressToRegister)
273         validVestingScheduleTimes(_startTimeInSec, _cliffTimeInSec, _endTimeInSec)
274     {
275         schedules[_addressToRegister] = VestingSchedule({
276             startTimeInSec: _startTimeInSec,
277             cliffTimeInSec: _cliffTimeInSec,
278             endTimeInSec: _endTimeInSec,
279             totalAmount: _totalAmount,
280             totalAmountWithdrawn: 0,
281             depositor: _depositor,
282             isConfirmed: false
283         });
284 
285         emit VestingScheduleRegistered(
286             _addressToRegister,
287             _depositor,
288             _startTimeInSec,
289             _cliffTimeInSec,
290             _endTimeInSec,
291             _totalAmount
292         );
293     }
294 
295     /// @dev Confirms a vesting schedule and deposits necessary tokens. Throws if deposit fails or schedules do not match.
296     /// @param _startTimeInSec The time in seconds that vesting began.
297     /// @param _cliffTimeInSec The time in seconds that tokens become withdrawable.
298     /// @param _endTimeInSec The time in seconds that vesting ends.
299     /// @param _totalAmount The total amount of tokens that the registered address can withdraw by the end of the vesting period.
300     function confirmVestingSchedule(
301         uint _startTimeInSec,
302         uint _cliffTimeInSec,
303         uint _endTimeInSec,
304         uint _totalAmount
305     )
306         public
307         addressRegistered(msg.sender)
308         vestingScheduleNotConfirmed(msg.sender)
309     {
310         VestingSchedule storage vestingSchedule = schedules[msg.sender];
311 
312         require(vestingSchedule.startTimeInSec == _startTimeInSec);
313         require(vestingSchedule.cliffTimeInSec == _cliffTimeInSec);
314         require(vestingSchedule.endTimeInSec == _endTimeInSec);
315         require(vestingSchedule.totalAmount == _totalAmount);
316 
317         vestingSchedule.isConfirmed = true;
318         require(vestingToken.transferFrom(vestingSchedule.depositor, address(this), _totalAmount));
319 
320         emit VestingScheduleConfirmed(
321             msg.sender,
322             vestingSchedule.depositor,
323             _startTimeInSec,
324             _cliffTimeInSec,
325             _endTimeInSec,
326             _totalAmount
327         );
328     }
329 
330     /// @dev Allows a registered address to withdraw tokens that have already been vested.
331     function withdraw()
332         public
333         vestingScheduleConfirmed(msg.sender)
334         pastCliffTime(msg.sender)
335     {
336         VestingSchedule storage vestingSchedule = schedules[msg.sender];
337 
338         uint totalAmountVested = getTotalAmountVested(vestingSchedule);
339         uint amountWithdrawable = safeSub(totalAmountVested, vestingSchedule.totalAmountWithdrawn);
340         vestingSchedule.totalAmountWithdrawn = totalAmountVested;
341 
342         if (amountWithdrawable > 0) {
343             require(vestingToken.transfer(msg.sender, amountWithdrawable));
344             emit Withdrawal(msg.sender, amountWithdrawable);
345         }
346     }
347 
348     /// @dev Allows contract owner to terminate a vesting schedule, transfering remaining vested tokens to the registered address and refunding owner with remaining tokens.
349     /// @param _addressToEnd Address that is currently registered to the vesting schedule that will be closed.
350     /// @param _addressToRefund Address that will receive unvested tokens.
351     function endVesting(address _addressToEnd, address _addressToRefund)
352         public
353         onlyOwner
354         vestingScheduleConfirmed(_addressToEnd)
355         addressNotNull(_addressToRefund)
356     {
357         VestingSchedule storage vestingSchedule = schedules[_addressToEnd];
358 
359         uint amountWithdrawable = 0;
360         uint amountRefundable = 0;
361 
362         if (block.timestamp < vestingSchedule.cliffTimeInSec) {
363             amountRefundable = vestingSchedule.totalAmount;
364         } else {
365             uint totalAmountVested = getTotalAmountVested(vestingSchedule);
366             amountWithdrawable = safeSub(totalAmountVested, vestingSchedule.totalAmountWithdrawn);
367             amountRefundable = safeSub(vestingSchedule.totalAmount, totalAmountVested);
368         }
369 
370         delete schedules[_addressToEnd];
371         require(amountWithdrawable == 0 || vestingToken.transfer(_addressToEnd, amountWithdrawable));
372         require(amountRefundable == 0 || vestingToken.transfer(_addressToRefund, amountRefundable));
373 
374         emit VestingEndedByOwner(_addressToEnd, amountWithdrawable, amountRefundable);
375     }
376 
377     /// @dev Allows a registered address to request an address change.
378     /// @param _newRegisteredAddress Desired address to update to.
379     function requestAddressChange(address _newRegisteredAddress)
380         public
381         vestingScheduleConfirmed(msg.sender)
382         addressNotRegistered(_newRegisteredAddress)
383         addressNotNull(_newRegisteredAddress)
384     {
385         addressChangeRequests[msg.sender] = _newRegisteredAddress;
386         emit AddressChangeRequested(msg.sender, _newRegisteredAddress);
387     }
388 
389     /// @dev Confirm an address change and migrate vesting schedule to new address.
390     /// @param _oldRegisteredAddress Current registered address.
391     /// @param _newRegisteredAddress Address to migrate vesting schedule to.
392     function confirmAddressChange(address _oldRegisteredAddress, address _newRegisteredAddress)
393         public
394         onlyOwner
395         pendingAddressChangeRequest(_oldRegisteredAddress)
396         addressNotRegistered(_newRegisteredAddress)
397     {
398         address newRegisteredAddress = addressChangeRequests[_oldRegisteredAddress];
399         require(newRegisteredAddress == _newRegisteredAddress);    // prevents race condition
400 
401         VestingSchedule memory vestingSchedule = schedules[_oldRegisteredAddress];
402         schedules[newRegisteredAddress] = vestingSchedule;
403 
404         delete schedules[_oldRegisteredAddress];
405         delete addressChangeRequests[_oldRegisteredAddress];
406 
407         emit AddressChangeConfirmed(_oldRegisteredAddress, _newRegisteredAddress);
408     }
409 
410     /// @dev Calculates the total tokens that have been vested for a vesting schedule, assuming the schedule is past the cliff.
411     /// @param vestingSchedule Vesting schedule used to calculate vested tokens.
412     /// @return Total tokens vested for a vesting schedule.
413     function getTotalAmountVested(VestingSchedule vestingSchedule)
414         internal
415         view
416         returns (uint)
417     {
418         if (block.timestamp >= vestingSchedule.endTimeInSec) return vestingSchedule.totalAmount;
419 
420         uint timeSinceStartInSec = safeSub(block.timestamp, vestingSchedule.startTimeInSec);
421         uint totalVestingTimeInSec = safeSub(vestingSchedule.endTimeInSec, vestingSchedule.startTimeInSec);
422         uint totalAmountVested = safeDiv(
423             safeMul(timeSinceStartInSec, vestingSchedule.totalAmount),
424             totalVestingTimeInSec
425         );
426 
427         return totalAmountVested;
428     }
429 }