1 pragma solidity 0.4.11;
2 
3 /*
4  * Ownable
5  *
6  * Base contract with an owner.
7  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
8  */
9 
10 contract Ownable {
11     address public owner;
12 
13     function Ownable() {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address newOwner) onlyOwner {
23         if (newOwner != address(0)) {
24             owner = newOwner;
25         }
26     }
27 }
28 
29 contract Token {
30 
31     /// @return total amount of tokens
32     function totalSupply() constant returns (uint supply) {}
33 
34     /// @param _owner The address from which the balance will be retrieved
35     /// @return The balance
36     function balanceOf(address _owner) constant returns (uint balance) {}
37 
38     /// @notice send `_value` token to `_to` from `msg.sender`
39     /// @param _to The address of the recipient
40     /// @param _value The amount of token to be transferred
41     /// @return Whether the transfer was successful or not
42     function transfer(address _to, uint _value) returns (bool success) {}
43 
44     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
45     /// @param _from The address of the sender
46     /// @param _to The address of the recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
50 
51     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
52     /// @param _spender The address of the account able to transfer the tokens
53     /// @param _value The amount of wei to be approved for transfer
54     /// @return Whether the approval was successful or not
55     function approve(address _spender, uint _value) returns (bool success) {}
56 
57     /// @param _owner The address of the account owning tokens
58     /// @param _spender The address of the account able to transfer the tokens
59     /// @return Amount of remaining tokens allowed to spent
60     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
61 
62     event Transfer(address indexed _from, address indexed _to, uint _value);
63     event Approval(address indexed _owner, address indexed _spender, uint _value);
64 }
65 
66 contract SafeMath {
67     function safeMul(uint a, uint b) internal constant returns (uint) {
68         uint c = a * b;
69         assert(a == 0 || c / a == b);
70         return c;
71     }
72 
73     function safeDiv(uint a, uint b) internal constant returns (uint) {
74         uint c = a / b;
75         return c;
76     }
77 
78     function safeSub(uint a, uint b) internal constant returns (uint) {
79         assert(b <= a);
80         return a - b;
81     }
82 
83     function safeAdd(uint a, uint b) internal constant returns (uint) {
84         uint c = a + b;
85         assert(c >= a);
86         return c;
87     }
88 
89     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
90         return a >= b ? a : b;
91     }
92 
93     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
94         return a < b ? a : b;
95     }
96 
97     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
98         return a >= b ? a : b;
99     }
100 
101     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
102         return a < b ? a : b;
103     }
104 }
105 
106 contract VestingWallet is Ownable, SafeMath {
107 
108     mapping(address => VestingSchedule) public schedules;        // vesting schedules for given addresses
109     mapping(address => address) public addressChangeRequests;    // requested address changes
110 
111     Token vestingToken;
112 
113     event VestingScheduleRegistered(
114         address indexed registeredAddress,
115         address depositor,
116         uint startTimeInSec,
117         uint cliffTimeInSec,
118         uint endTimeInSec,
119         uint totalAmount
120     );
121     event VestingScheduleConfirmed(
122         address indexed registeredAddress,
123         address depositor,
124         uint startTimeInSec,
125         uint cliffTimeInSec,
126         uint endTimeInSec,
127         uint totalAmount
128     );
129     event Withdrawal(address indexed registeredAddress, uint amountWithdrawn);
130     event VestingEndedByOwner(address indexed registeredAddress, uint amountWithdrawn, uint amountRefunded);
131     event AddressChangeRequested(address indexed oldRegisteredAddress, address indexed newRegisteredAddress);
132     event AddressChangeConfirmed(address indexed oldRegisteredAddress, address indexed newRegisteredAddress);
133 
134     struct VestingSchedule {
135         uint startTimeInSec;
136         uint cliffTimeInSec;
137         uint endTimeInSec;
138         uint totalAmount;
139         uint totalAmountWithdrawn;
140         address depositor;
141         bool isConfirmed;
142     }
143 
144     modifier addressRegistered(address target) {
145         VestingSchedule storage vestingSchedule = schedules[target];
146         require(vestingSchedule.depositor != address(0));
147         _;
148     }
149 
150     modifier addressNotRegistered(address target) {
151         VestingSchedule storage vestingSchedule = schedules[target];
152         require(vestingSchedule.depositor == address(0));
153         _;
154     }
155 
156     modifier vestingScheduleConfirmed(address target) {
157         VestingSchedule storage vestingSchedule = schedules[target];
158         require(vestingSchedule.isConfirmed);
159         _;
160     }
161 
162     modifier vestingScheduleNotConfirmed(address target) {
163         VestingSchedule storage vestingSchedule = schedules[target];
164         require(!vestingSchedule.isConfirmed);
165         _;
166     }
167 
168     modifier pendingAddressChangeRequest(address target) {
169         require(addressChangeRequests[target] != address(0));
170         _;
171     }
172 
173     modifier pastCliffTime(address target) {
174         VestingSchedule storage vestingSchedule = schedules[target];
175         require(block.timestamp > vestingSchedule.cliffTimeInSec);
176         _;
177     }
178 
179     modifier validVestingScheduleTimes(uint startTimeInSec, uint cliffTimeInSec, uint endTimeInSec) {
180         require(cliffTimeInSec >= startTimeInSec);
181         require(endTimeInSec >= cliffTimeInSec);
182         _;
183     }
184 
185     modifier addressNotNull(address target) {
186         require(target != address(0));
187         _;
188     }
189 
190     /// @dev Assigns a vesting token to the wallet.
191     /// @param _vestingToken Token that will be vested.
192     function VestingWallet(address _vestingToken) {
193         vestingToken = Token(_vestingToken);
194     }
195 
196     /// @dev Registers a vesting schedule to an address.
197     /// @param _addressToRegister The address that is allowed to withdraw vested tokens for this schedule.
198     /// @param _depositor Address that will be depositing vesting token.
199     /// @param _startTimeInSec The time in seconds that vesting began.
200     /// @param _cliffTimeInSec The time in seconds that tokens become withdrawable.
201     /// @param _endTimeInSec The time in seconds that vesting ends.
202     /// @param _totalAmount The total amount of tokens that the registered address can withdraw by the end of the vesting period.
203     function registerVestingSchedule(
204         address _addressToRegister,
205         address _depositor,
206         uint _startTimeInSec,
207         uint _cliffTimeInSec,
208         uint _endTimeInSec,
209         uint _totalAmount
210     )
211         public
212         onlyOwner
213         addressNotNull(_depositor)
214         vestingScheduleNotConfirmed(_addressToRegister)
215         validVestingScheduleTimes(_startTimeInSec, _cliffTimeInSec, _endTimeInSec)
216     {
217         schedules[_addressToRegister] = VestingSchedule({
218             startTimeInSec: _startTimeInSec,
219             cliffTimeInSec: _cliffTimeInSec,
220             endTimeInSec: _endTimeInSec,
221             totalAmount: _totalAmount,
222             totalAmountWithdrawn: 0,
223             depositor: _depositor,
224             isConfirmed: false
225         });
226 
227         VestingScheduleRegistered(
228             _addressToRegister,
229             _depositor,
230             _startTimeInSec,
231             _cliffTimeInSec,
232             _endTimeInSec,
233             _totalAmount
234         );
235     }
236 
237     /// @dev Confirms a vesting schedule and deposits necessary tokens. Throws if deposit fails or schedules do not match.
238     /// @param _startTimeInSec The time in seconds that vesting began.
239     /// @param _cliffTimeInSec The time in seconds that tokens become withdrawable.
240     /// @param _endTimeInSec The time in seconds that vesting ends.
241     /// @param _totalAmount The total amount of tokens that the registered address can withdraw by the end of the vesting period.
242     function confirmVestingSchedule(
243         uint _startTimeInSec,
244         uint _cliffTimeInSec,
245         uint _endTimeInSec,
246         uint _totalAmount
247     )
248         public
249         addressRegistered(msg.sender)
250         vestingScheduleNotConfirmed(msg.sender)
251     {
252         VestingSchedule storage vestingSchedule = schedules[msg.sender];
253 
254         require(vestingSchedule.startTimeInSec == _startTimeInSec);
255         require(vestingSchedule.cliffTimeInSec == _cliffTimeInSec);
256         require(vestingSchedule.endTimeInSec == _endTimeInSec);
257         require(vestingSchedule.totalAmount == _totalAmount);
258 
259         vestingSchedule.isConfirmed = true;
260         require(vestingToken.transferFrom(vestingSchedule.depositor, address(this), _totalAmount));
261 
262         VestingScheduleConfirmed(
263             msg.sender,
264             vestingSchedule.depositor,
265             _startTimeInSec,
266             _cliffTimeInSec,
267             _endTimeInSec,
268             _totalAmount
269         );
270     }
271 
272     /// @dev Allows a registered address to withdraw tokens that have already been vested.
273     function withdraw()
274         public
275         vestingScheduleConfirmed(msg.sender)
276         pastCliffTime(msg.sender)
277     {
278         VestingSchedule storage vestingSchedule = schedules[msg.sender];
279 
280         uint totalAmountVested = getTotalAmountVested(vestingSchedule);
281         uint amountWithdrawable = safeSub(totalAmountVested, vestingSchedule.totalAmountWithdrawn);
282         vestingSchedule.totalAmountWithdrawn = totalAmountVested;
283 
284         if (amountWithdrawable > 0) {
285             require(vestingToken.transfer(msg.sender, amountWithdrawable));
286             Withdrawal(msg.sender, amountWithdrawable);
287         }
288     }
289 
290     /// @dev Allows contract owner to terminate a vesting schedule, transfering remaining vested tokens to the registered address and refunding owner with remaining tokens.
291     /// @param _addressToEnd Address that is currently registered to the vesting schedule that will be closed.
292     /// @param _addressToRefund Address that will receive unvested tokens.
293     function endVesting(address _addressToEnd, address _addressToRefund)
294         public
295         onlyOwner
296         vestingScheduleConfirmed(_addressToEnd)
297         addressNotNull(_addressToRefund)
298     {
299         VestingSchedule storage vestingSchedule = schedules[_addressToEnd];
300 
301         uint amountWithdrawable = 0;
302         uint amountRefundable = 0;
303 
304         if (block.timestamp < vestingSchedule.cliffTimeInSec) {
305             amountRefundable = vestingSchedule.totalAmount;
306         } else {
307             uint totalAmountVested = getTotalAmountVested(vestingSchedule);
308             amountWithdrawable = safeSub(totalAmountVested, vestingSchedule.totalAmountWithdrawn);
309             amountRefundable = safeSub(vestingSchedule.totalAmount, totalAmountVested);
310         }
311 
312         delete schedules[_addressToEnd];
313         require(amountWithdrawable == 0 || vestingToken.transfer(_addressToEnd, amountWithdrawable));
314         require(amountRefundable == 0 || vestingToken.transfer(_addressToRefund, amountRefundable));
315 
316         VestingEndedByOwner(_addressToEnd, amountWithdrawable, amountRefundable);
317     }
318 
319     /// @dev Allows a registered address to request an address change.
320     /// @param _newRegisteredAddress Desired address to update to.
321     function requestAddressChange(address _newRegisteredAddress)
322         public
323         vestingScheduleConfirmed(msg.sender)
324         addressNotRegistered(_newRegisteredAddress)
325         addressNotNull(_newRegisteredAddress)
326     {
327         addressChangeRequests[msg.sender] = _newRegisteredAddress;
328         AddressChangeRequested(msg.sender, _newRegisteredAddress);
329     }
330 
331     /// @dev Confirm an address change and migrate vesting schedule to new address.
332     /// @param _oldRegisteredAddress Current registered address.
333     /// @param _newRegisteredAddress Address to migrate vesting schedule to.
334     function confirmAddressChange(address _oldRegisteredAddress, address _newRegisteredAddress)
335         public
336         onlyOwner
337         pendingAddressChangeRequest(_oldRegisteredAddress)
338         addressNotRegistered(_newRegisteredAddress)
339     {
340         address newRegisteredAddress = addressChangeRequests[_oldRegisteredAddress];
341         require(newRegisteredAddress == _newRegisteredAddress);    // prevents race condition
342 
343         VestingSchedule memory vestingSchedule = schedules[_oldRegisteredAddress];
344         schedules[newRegisteredAddress] = vestingSchedule;
345 
346         delete schedules[_oldRegisteredAddress];
347         delete addressChangeRequests[_oldRegisteredAddress];
348 
349         AddressChangeConfirmed(_oldRegisteredAddress, _newRegisteredAddress);
350     }
351 
352     /// @dev Calculates the total tokens that have been vested for a vesting schedule, assuming the schedule is past the cliff.
353     /// @param vestingSchedule Vesting schedule used to calculate vested tokens.
354     /// @return Total tokens vested for a vesting schedule.
355     function getTotalAmountVested(VestingSchedule vestingSchedule)
356         internal
357         returns (uint)
358     {
359         if (block.timestamp >= vestingSchedule.endTimeInSec) return vestingSchedule.totalAmount;
360 
361         uint timeSinceStartInSec = safeSub(block.timestamp, vestingSchedule.startTimeInSec);
362         uint totalVestingTimeInSec = safeSub(vestingSchedule.endTimeInSec, vestingSchedule.startTimeInSec);
363         uint totalAmountVested = safeDiv(
364             safeMul(timeSinceStartInSec, vestingSchedule.totalAmount),
365             totalVestingTimeInSec
366         );
367 
368         return totalAmountVested;
369     }
370 }