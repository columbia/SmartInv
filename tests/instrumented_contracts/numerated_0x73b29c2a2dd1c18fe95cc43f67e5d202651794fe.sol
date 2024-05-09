1 pragma solidity ^0.4.19;
2 
3 // File: contracts/erc20/Token.sol
4 
5 contract Token {
6 
7     /// @return total amount of tokens
8     function totalSupply() constant returns (uint supply) {}
9 
10     /// @param _owner The address from which the balance will be retrieved
11     /// @return The balance
12     function balanceOf(address _owner) constant returns (uint balance) {}
13 
14     /// @notice send `_value` token to `_to` from `msg.sender`
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transfer(address _to, uint _value) returns (bool success) {}
19 
20     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
21     /// @param _from The address of the sender
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
26 
27     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @param _value The amount of wei to be approved for transfer
30     /// @return Whether the approval was successful or not
31     function approve(address _spender, uint _value) returns (bool success) {}
32 
33     /// @param _owner The address of the account owning tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @return Amount of remaining tokens allowed to spent
36     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
37 
38     event Transfer(address indexed _from, address indexed _to, uint _value);
39     event Approval(address indexed _owner, address indexed _spender, uint _value);
40 }
41 
42 // File: contracts/math/SafeMath.sol
43 
44 contract SafeMath {
45     function safeMul(uint a, uint b) internal constant returns (uint) {
46         uint c = a * b;
47         assert(a == 0 || c / a == b);
48         return c;
49     }
50 
51     function safeDiv(uint a, uint b) internal constant returns (uint) {
52         uint c = a / b;
53         return c;
54     }
55 
56     function safeSub(uint a, uint b) internal constant returns (uint) {
57         assert(b <= a);
58         return a - b;
59     }
60 
61     function safeAdd(uint a, uint b) internal constant returns (uint) {
62         uint c = a + b;
63         assert(c >= a);
64         return c;
65     }
66 
67     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
68         return a >= b ? a : b;
69     }
70 
71     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
72         return a < b ? a : b;
73     }
74 
75     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
76         return a >= b ? a : b;
77     }
78 
79     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
80         return a < b ? a : b;
81     }
82 }
83 
84 // File: contracts/ownership/Ownable.sol
85 
86 /*
87  * Ownable
88  *
89  * Base contract with an owner.
90  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
91  */
92 
93 contract Ownable {
94     address public owner;
95 
96     function Ownable() {
97         owner = msg.sender;
98     }
99 
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104 
105     function transferOwnership(address newOwner) onlyOwner {
106         if (newOwner != address(0)) {
107             owner = newOwner;
108         }
109     }
110 }
111 
112 // File: contracts/vesting/VestingWallet.sol
113 
114 contract VestingWallet is Ownable, SafeMath {
115 
116     mapping(address => VestingSchedule) public schedules;        // vesting schedules for given addresses
117     mapping(address => address) public addressChangeRequests;    // requested address changes
118 
119     Token public vestingToken;
120 
121     address public approvedWallet;
122 
123     event VestingScheduleRegistered(
124         address indexed registeredAddress,
125         address depositor,
126         uint startTimeInSec,
127         uint cliffTimeInSec,
128         uint endTimeInSec,
129         uint totalAmount
130     );
131 
132 
133     event Withdrawal(address indexed registeredAddress, uint amountWithdrawn);
134 
135     event VestingEndedByOwner(address indexed registeredAddress, uint amountWithdrawn, uint amountRefunded);
136 
137     event AddressChangeRequested(address indexed oldRegisteredAddress, address indexed newRegisteredAddress);
138 
139     event AddressChangeConfirmed(address indexed oldRegisteredAddress, address indexed newRegisteredAddress);
140 
141     struct VestingSchedule {
142         uint startTimeInSec;
143         uint cliffTimeInSec;
144         uint endTimeInSec;
145         uint totalAmount;
146         uint totalAmountWithdrawn;
147         address depositor;
148     }
149 
150     modifier addressRegistered(address target) {
151         VestingSchedule storage vestingSchedule = schedules[target];
152         require(vestingSchedule.depositor != address(0));
153         _;
154     }
155 
156     modifier addressNotRegistered(address target) {
157         VestingSchedule storage vestingSchedule = schedules[target];
158         require(vestingSchedule.depositor == address(0));
159         _;
160     }
161 
162     modifier pendingAddressChangeRequest(address target) {
163         require(addressChangeRequests[target] != address(0));
164         _;
165     }
166 
167     modifier pastCliffTime(address target) {
168         VestingSchedule storage vestingSchedule = schedules[target];
169         require(getTime() > vestingSchedule.cliffTimeInSec);
170         _;
171     }
172 
173     modifier validVestingScheduleTimes(uint startTimeInSec, uint cliffTimeInSec, uint endTimeInSec) {
174         require(cliffTimeInSec >= startTimeInSec);
175         require(endTimeInSec >= cliffTimeInSec);
176         _;
177     }
178 
179     modifier addressNotNull(address target) {
180         require(target != address(0));
181         _;
182     }
183 
184     /// @dev Assigns a vesting token to the wallet.
185     /// @param _vestingToken Token that will be vested.
186     function VestingWallet(address _vestingToken) {
187         vestingToken = Token(_vestingToken);
188         approvedWallet = msg.sender;
189     }
190 
191     function registerVestingScheduleWithPercentage(
192         address _addressToRegister,
193         address _depositor,
194         uint _startTimeInSec,
195         uint _cliffTimeInSec,
196         uint _endTimeInSec,
197         uint _totalAmount,
198         uint _percentage
199     )
200     public
201     onlyOwner
202     addressNotNull(_depositor)
203     validVestingScheduleTimes(_startTimeInSec, _cliffTimeInSec, _endTimeInSec)
204     {
205         require(_percentage <= 100);
206         uint vestedAmount = safeDiv(safeMul(
207                 _totalAmount, _percentage
208             ), 100);
209         registerVestingSchedule(_addressToRegister, _depositor, _startTimeInSec, _cliffTimeInSec, _endTimeInSec, vestedAmount);
210     }
211 
212     /// @dev Registers a vesting schedule to an address.
213     /// @param _addressToRegister The address that is allowed to withdraw vested tokens for this schedule.
214     /// @param _depositor Address that will be depositing vesting token.
215     /// @param _startTimeInSec The time in seconds that vesting began.
216     /// @param _cliffTimeInSec The time in seconds that tokens become withdrawable.
217     /// @param _endTimeInSec The time in seconds that vesting ends.
218     /// @param _totalAmount The total amount of tokens that the registered address can withdraw by the end of the vesting period.
219     function registerVestingSchedule(
220         address _addressToRegister,
221         address _depositor,
222         uint _startTimeInSec,
223         uint _cliffTimeInSec,
224         uint _endTimeInSec,
225         uint _totalAmount
226     )
227     public
228     onlyOwner
229     addressNotNull(_depositor)
230     validVestingScheduleTimes(_startTimeInSec, _cliffTimeInSec, _endTimeInSec)
231     {
232 
233         require(vestingToken.transferFrom(approvedWallet, address(this), _totalAmount));
234         require(vestingToken.balanceOf(address(this)) >= _totalAmount);
235 
236         schedules[_addressToRegister] = VestingSchedule({
237             startTimeInSec : _startTimeInSec,
238             cliffTimeInSec : _cliffTimeInSec,
239             endTimeInSec : _endTimeInSec,
240             totalAmount : _totalAmount,
241             totalAmountWithdrawn : 0,
242             depositor : _depositor
243             });
244 
245         VestingScheduleRegistered(
246             _addressToRegister,
247             _depositor,
248             _startTimeInSec,
249             _cliffTimeInSec,
250             _endTimeInSec,
251             _totalAmount
252         );
253     }
254 
255     /// @dev Allows a registered address to withdraw tokens that have already been vested.
256     function withdraw()
257     public
258     pastCliffTime(msg.sender)
259     {
260         VestingSchedule storage vestingSchedule = schedules[msg.sender];
261         uint totalAmountVested = getTotalAmountVested(vestingSchedule);
262         uint amountWithdrawable = safeSub(totalAmountVested, vestingSchedule.totalAmountWithdrawn);
263         vestingSchedule.totalAmountWithdrawn = totalAmountVested;
264 
265         if (amountWithdrawable > 0) {
266             require(vestingToken.transfer(msg.sender, amountWithdrawable));
267             Withdrawal(msg.sender, amountWithdrawable);
268         }
269     }
270 
271     /// @dev Allows contract owner to terminate a vesting schedule, transfering remaining vested tokens to the registered address and refunding owner with remaining tokens.
272     /// @param _addressToEnd Address that is currently registered to the vesting schedule that will be closed.
273     /// @param _addressToRefund Address that will receive unvested tokens.
274     function endVesting(address _addressToEnd, address _addressToRefund)
275     public
276     onlyOwner
277     addressNotNull(_addressToRefund)
278     {
279         VestingSchedule storage vestingSchedule = schedules[_addressToEnd];
280 
281         uint amountWithdrawable = 0;
282         uint amountRefundable = 0;
283 
284         if (getTime() < vestingSchedule.cliffTimeInSec) {
285             amountRefundable = vestingSchedule.totalAmount;
286         }
287         else {
288             uint totalAmountVested = getTotalAmountVested(vestingSchedule);
289             amountWithdrawable = safeSub(totalAmountVested, vestingSchedule.totalAmountWithdrawn);
290             amountRefundable = safeSub(vestingSchedule.totalAmount, totalAmountVested);
291         }
292 
293         delete schedules[_addressToEnd];
294         require(amountWithdrawable == 0 || vestingToken.transfer(_addressToEnd, amountWithdrawable));
295         require(amountRefundable == 0 || vestingToken.transfer(_addressToRefund, amountRefundable));
296 
297         VestingEndedByOwner(_addressToEnd, amountWithdrawable, amountRefundable);
298     }
299 
300     /// @dev Allows a registered address to request an address change.
301     /// @param _newRegisteredAddress Desired address to update to.
302     function requestAddressChange(address _newRegisteredAddress)
303     public
304     addressNotRegistered(_newRegisteredAddress)
305     addressNotNull(_newRegisteredAddress)
306     {
307         addressChangeRequests[msg.sender] = _newRegisteredAddress;
308         AddressChangeRequested(msg.sender, _newRegisteredAddress);
309     }
310 
311     /// @dev Confirm an address change and migrate vesting schedule to new address.
312     /// @param _oldRegisteredAddress Current registered address.
313     /// @param _newRegisteredAddress Address to migrate vesting schedule to.
314     function confirmAddressChange(address _oldRegisteredAddress, address _newRegisteredAddress)
315     public
316     onlyOwner
317     pendingAddressChangeRequest(_oldRegisteredAddress)
318     addressNotRegistered(_newRegisteredAddress)
319     {
320         address newRegisteredAddress = addressChangeRequests[_oldRegisteredAddress];
321         require(newRegisteredAddress == _newRegisteredAddress);
322         // prevents race condition
323 
324         VestingSchedule memory vestingSchedule = schedules[_oldRegisteredAddress];
325         schedules[newRegisteredAddress] = vestingSchedule;
326 
327         delete schedules[_oldRegisteredAddress];
328         delete addressChangeRequests[_oldRegisteredAddress];
329 
330         AddressChangeConfirmed(_oldRegisteredAddress, _newRegisteredAddress);
331     }
332 
333     function setApprovedWallet(address _approvedWallet)
334     public
335     addressNotNull(_approvedWallet)
336     onlyOwner {
337         approvedWallet = _approvedWallet;
338     }
339 
340     function getTime() internal view returns (uint) {
341         return now;
342     }
343 
344     function allowance(address _target) public view returns (uint) {
345         VestingSchedule storage vestingSchedule = schedules[_target];
346         uint totalAmountVested = getTotalAmountVested(vestingSchedule);
347         uint amountWithdrawable = safeSub(totalAmountVested, vestingSchedule.totalAmountWithdrawn);
348         return amountWithdrawable;
349     }
350 
351     /// @dev Calculates the total tokens that have been vested for a vesting schedule, assuming the schedule is past the cliff.
352     /// @param vestingSchedule Vesting schedule used to calculate vested tokens.
353     /// @return Total tokens vested for a vesting schedule.
354     function getTotalAmountVested(VestingSchedule vestingSchedule)
355     internal
356     view
357     returns (uint)
358     {
359         if (getTime() >= vestingSchedule.endTimeInSec) {
360             return vestingSchedule.totalAmount;
361         }
362 
363         uint timeSinceStartInSec = safeSub(getTime(), vestingSchedule.startTimeInSec);
364         uint totalVestingTimeInSec = safeSub(vestingSchedule.endTimeInSec, vestingSchedule.startTimeInSec);
365         uint totalAmountVested = safeDiv(
366             safeMul(timeSinceStartInSec, vestingSchedule.totalAmount), totalVestingTimeInSec
367         );
368 
369         return totalAmountVested;
370     }
371 }