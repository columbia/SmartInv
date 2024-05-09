1 pragma solidity ^0.4.6;
2 
3 
4 /*
5     Copyright 2016, Jordi Baylina
6 
7     This program is free software: you can redistribute it and/or modify
8     it under the terms of the GNU General Public License as published by
9     the Free Software Foundation, either version 3 of the License, or
10     (at your option) any later version.
11 
12     This program is distributed in the hope that it will be useful,
13     but WITHOUT ANY WARRANTY; without even the implied warranty of
14     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15     GNU General Public License for more details.
16 
17     You should have received a copy of the GNU General Public License
18     along with this program.  If not, see <http://www.gnu.org/licenses/>.
19  */
20 
21 /// @title Vault Contract
22 /// @author Jordi Baylina
23 /// @notice This contract holds funds for Campaigns and automates payments. For
24 ///  this iteration the funds will come straight from the Giveth Multisig as a
25 ///  safety precaution, but once fully tested and optimized this contract will
26 ///  be a safe place to store funds equipped with optional variable time delays
27 ///  to allow for an optional escape hatch
28 
29 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
30 ///  later changed
31 contract Owned {
32     /// @dev `owner` is the only address that can call a function with this
33     /// modifier
34     modifier onlyOwner { if (msg.sender != owner) throw; _; }
35 
36     address public owner;
37 
38     /// @notice The Constructor assigns the message sender to be `owner`
39     function Owned() { owner = msg.sender;}
40 
41     /// @notice `owner` can step down and assign some other address to this role
42     /// @param _newOwner The address of the new owner. 0x0 can be used to create
43     ///  an unowned neutral vault, however that cannot be undone
44     function changeOwner(address _newOwner) onlyOwner {
45         owner = _newOwner;
46         NewOwner(msg.sender, _newOwner);
47     }
48 
49     event NewOwner(address indexed oldOwner, address indexed newOwner);
50 }
51 /// @dev `Escapable` is a base level contract built off of the `Owned`
52 ///  contract that creates an escape hatch function to send its ether to
53 ///  `escapeHatchDestination` when called by the `escapeHatchCaller` in the case that
54 ///  something unexpected happens
55 contract Escapable is Owned {
56     address public escapeHatchCaller;
57     address public escapeHatchDestination;
58 
59     /// @notice The Constructor assigns the `escapeHatchDestination` and the
60     ///  `escapeHatchCaller`
61     /// @param _escapeHatchDestination The address of a safe location (usu a
62     ///  Multisig) to send the ether held in this contract
63     /// @param _escapeHatchCaller The address of a trusted account or contract to
64     ///  call `escapeHatch()` to send the ether in this contract to the
65     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot move
66     ///  funds out of `escapeHatchDestination`
67     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) {
68         escapeHatchCaller = _escapeHatchCaller;
69         escapeHatchDestination = _escapeHatchDestination;
70     }
71 
72     /// @dev The addresses preassigned the `escapeHatchCaller` role
73     ///  is the only addresses that can call a function with this modifier
74     modifier onlyEscapeHatchCallerOrOwner {
75         if ((msg.sender != escapeHatchCaller)&&(msg.sender != owner))
76             throw;
77         _;
78     }
79 
80     /// @notice The `escapeHatch()` should only be called as a last resort if a
81     /// security issue is uncovered or something unexpected happened
82     function escapeHatch() onlyEscapeHatchCallerOrOwner {
83         uint total = this.balance;
84         // Send the total balance of this contract to the `escapeHatchDestination`
85         if (!escapeHatchDestination.send(total)) {
86             throw;
87         }
88         EscapeHatchCalled(total);
89     }
90     /// @notice Changes the address assigned to call `escapeHatch()`
91     /// @param _newEscapeHatchCaller The address of a trusted account or contract to
92     ///  call `escapeHatch()` to send the ether in this contract to the
93     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot
94     ///  move funds out of `escapeHatchDestination`
95     function changeEscapeCaller(address _newEscapeHatchCaller) onlyEscapeHatchCallerOrOwner {
96         escapeHatchCaller = _newEscapeHatchCaller;
97     }
98 
99     event EscapeHatchCalled(uint amount);
100 }
101 
102 /// @dev `Vault` is a higher level contract built off of the `Escapable`
103 ///  contract that holds funds for Campaigns and automates payments.
104 contract Vault is Escapable {
105 
106     /// @dev `Payment` is a public structure that describes the details of
107     ///  each payment making it easy to track the movement of funds
108     ///  transparently
109     struct Payment {
110         string name;     // What is the purpose of this payment
111         bytes32 reference;  // Reference of the payment.
112         address spender;        // Who is sending the funds
113         uint earliestPayTime;   // The earliest a payment can be made (Unix Time)
114         bool canceled;         // If True then the payment has been canceled
115         bool paid;              // If True then the payment has been paid
116         address recipient;      // Who is receiving the funds
117         uint amount;            // The amount of wei sent in the payment
118         uint securityGuardDelay;// The seconds `securityGuard` can delay payment
119     }
120 
121     Payment[] public authorizedPayments;
122 
123     address public securityGuard;
124     uint public absoluteMinTimeLock;
125     uint public timeLock;
126     uint public maxSecurityGuardDelay;
127 
128     /// @dev The white list of approved addresses allowed to set up && receive
129     ///  payments from this vault
130     mapping (address => bool) public allowedSpenders;
131 
132     /// @dev The address assigned the role of `securityGuard` is the only
133     ///  addresses that can call a function with this modifier
134     modifier onlySecurityGuard { if (msg.sender != securityGuard) throw; _; }
135 
136     // @dev Events to make the payment movements easy to find on the blockchain
137     event PaymentAuthorized(uint indexed idPayment, address indexed recipient, uint amount);
138     event PaymentExecuted(uint indexed idPayment, address indexed recipient, uint amount);
139     event PaymentCanceled(uint indexed idPayment);
140     event EtherReceived(address indexed from, uint amount);
141     event SpenderAuthorization(address indexed spender, bool authorized);
142 
143 /////////
144 // Constructor
145 /////////
146 
147     /// @notice The Constructor creates the Vault on the blockchain
148     /// @param _escapeHatchCaller The address of a trusted account or contract to
149     ///  call `escapeHatch()` to send the ether in this contract to the
150     ///  `escapeHatchDestination` it would be ideal if `escapeHatchCaller` cannot move
151     ///  funds out of `escapeHatchDestination`
152     /// @param _escapeHatchDestination The address of a safe location (usu a
153     ///  Multisig) to send the ether held in this contract in an emergency
154     /// @param _absoluteMinTimeLock The minimum number of seconds `timelock` can
155     ///  be set to, if set to 0 the `owner` can remove the `timeLock` completely
156     /// @param _timeLock Initial number of seconds that payments are delayed
157     ///  after they are authorized (a security precaution)
158     /// @param _securityGuard Address that will be able to delay the payments
159     ///  beyond the initial timelock requirements; can be set to 0x0 to remove
160     ///  the `securityGuard` functionality
161     /// @param _maxSecurityGuardDelay The maximum number of seconds in total
162     ///   that `securityGuard` can delay a payment so that the owner can cancel
163     ///   the payment if needed
164     function Vault(
165         address _escapeHatchCaller,
166         address _escapeHatchDestination,
167         uint _absoluteMinTimeLock,
168         uint _timeLock,
169         address _securityGuard,
170         uint _maxSecurityGuardDelay) Escapable(_escapeHatchCaller, _escapeHatchDestination)
171     {
172         absoluteMinTimeLock = _absoluteMinTimeLock;
173         timeLock = _timeLock;
174         securityGuard = _securityGuard;
175         maxSecurityGuardDelay = _maxSecurityGuardDelay;
176     }
177 
178 /////////
179 // Helper functions
180 /////////
181 
182     /// @notice States the total number of authorized payments in this contract
183     /// @return The number of payments ever authorized even if they were canceled
184     function numberOfAuthorizedPayments() constant returns (uint) {
185         return authorizedPayments.length;
186     }
187 
188 //////
189 // Receive Ether
190 //////
191 
192     /// @notice Called anytime ether is sent to the contract && creates an event
193     /// to more easily track the incoming transactions
194     function receiveEther() payable {
195         EtherReceived(msg.sender, msg.value);
196     }
197 
198     /// @notice The fall back function is called whenever ether is sent to this
199     ///  contract
200     function () payable {
201         receiveEther();
202     }
203 
204 ////////
205 // Spender Interface
206 ////////
207 
208     /// @notice only `allowedSpenders[]` Creates a new `Payment`
209     /// @param _name Brief description of the payment that is authorized
210     /// @param _reference External reference of the payment
211     /// @param _recipient Destination of the payment
212     /// @param _amount Amount to be paid in wei
213     /// @param _paymentDelay Number of seconds the payment is to be delayed, if
214     ///  this value is below `timeLock` then the `timeLock` determines the delay
215     /// @return The Payment ID number for the new authorized payment
216     function authorizePayment(
217         string _name,
218         bytes32 _reference,
219         address _recipient,
220         uint _amount,
221         uint _paymentDelay
222     ) returns(uint) {
223 
224         // Fail if you arent on the `allowedSpenders` white list
225         if (!allowedSpenders[msg.sender] ) throw;
226         uint idPayment = authorizedPayments.length;       // Unique Payment ID
227         authorizedPayments.length++;
228 
229         // The following lines fill out the payment struct
230         Payment p = authorizedPayments[idPayment];
231         p.spender = msg.sender;
232 
233         // Overflow protection
234         if (_paymentDelay > 10**18) throw;
235 
236         // Determines the earliest the recipient can receive payment (Unix time)
237         p.earliestPayTime = _paymentDelay >= timeLock ?
238                                 now + _paymentDelay :
239                                 now + timeLock;
240         p.recipient = _recipient;
241         p.amount = _amount;
242         p.name = _name;
243         p.reference = _reference;
244         PaymentAuthorized(idPayment, p.recipient, p.amount);
245         return idPayment;
246     }
247 
248     /// @notice only `allowedSpenders[]` The recipient of a payment calls this
249     ///  function to send themselves the ether after the `earliestPayTime` has
250     ///  expired
251     /// @param _idPayment The payment ID to be executed
252     function collectAuthorizedPayment(uint _idPayment) {
253 
254         // Check that the `_idPayment` has been added to the payments struct
255         if (_idPayment >= authorizedPayments.length) throw;
256 
257         Payment p = authorizedPayments[_idPayment];
258 
259         // Checking for reasons not to execute the payment
260         if (msg.sender != p.recipient) throw;
261         if (!allowedSpenders[p.spender]) throw;
262         if (now < p.earliestPayTime) throw;
263         if (p.canceled) throw;
264         if (p.paid) throw;
265         if (this.balance < p.amount) throw;
266 
267         p.paid = true; // Set the payment to being paid
268         if (!p.recipient.send(p.amount)) {  // Make the payment
269             throw;
270         }
271         PaymentExecuted(_idPayment, p.recipient, p.amount);
272      }
273 
274 /////////
275 // SecurityGuard Interface
276 /////////
277 
278     /// @notice `onlySecurityGuard` Delays a payment for a set number of seconds
279     /// @param _idPayment ID of the payment to be delayed
280     /// @param _delay The number of seconds to delay the payment
281     function delayPayment(uint _idPayment, uint _delay) onlySecurityGuard {
282         if (_idPayment >= authorizedPayments.length) throw;
283 
284         // Overflow test
285         if (_delay > 10**18) throw;
286 
287         Payment p = authorizedPayments[_idPayment];
288 
289         if ((p.securityGuardDelay + _delay > maxSecurityGuardDelay) ||
290             (p.paid) ||
291             (p.canceled))
292             throw;
293 
294         p.securityGuardDelay += _delay;
295         p.earliestPayTime += _delay;
296     }
297 
298 ////////
299 // Owner Interface
300 ///////
301 
302     /// @notice `onlyOwner` Cancel a payment all together
303     /// @param _idPayment ID of the payment to be canceled.
304     function cancelPayment(uint _idPayment) onlyOwner {
305         if (_idPayment >= authorizedPayments.length) throw;
306 
307         Payment p = authorizedPayments[_idPayment];
308 
309 
310         if (p.canceled) throw;
311         if (p.paid) throw;
312 
313         p.canceled = true;
314         PaymentCanceled(_idPayment);
315     }
316 
317     /// @notice `onlyOwner` Adds a spender to the `allowedSpenders[]` white list
318     /// @param _spender The address of the contract being authorized/unauthorized
319     /// @param _authorize `true` if authorizing and `false` if unauthorizing
320     function authorizeSpender(address _spender, bool _authorize) onlyOwner {
321         allowedSpenders[_spender] = _authorize;
322         SpenderAuthorization(_spender, _authorize);
323     }
324 
325     /// @notice `onlyOwner` Sets the address of `securityGuard`
326     /// @param _newSecurityGuard Address of the new security guard
327     function setSecurityGuard(address _newSecurityGuard) onlyOwner {
328         securityGuard = _newSecurityGuard;
329     }
330 
331     /// @notice `onlyOwner` Changes `timeLock`; the new `timeLock` cannot be
332     ///  lower than `absoluteMinTimeLock`
333     /// @param _newTimeLock Sets the new minimum default `timeLock` in seconds;
334     ///  pending payments maintain their `earliestPayTime`
335     function setTimelock(uint _newTimeLock) onlyOwner {
336         if (_newTimeLock < absoluteMinTimeLock) throw;
337         timeLock = _newTimeLock;
338     }
339 
340     /// @notice `onlyOwner` Changes the maximum number of seconds
341     /// `securityGuard` can delay a payment
342     /// @param _maxSecurityGuardDelay The new maximum delay in seconds that
343     ///  `securityGuard` can delay the payment's execution in total
344     function setMaxSecurityGuardDelay(uint _maxSecurityGuardDelay) onlyOwner {
345         maxSecurityGuardDelay = _maxSecurityGuardDelay;
346     }
347 }