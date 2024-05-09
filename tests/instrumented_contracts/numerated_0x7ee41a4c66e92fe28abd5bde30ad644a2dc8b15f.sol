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
46     }
47 }
48 /// @dev `Escapable` is a base level contract built off of the `Owned`
49 ///  contract that creates an escape hatch function to send its ether to
50 ///  `escapeDestination` when called by the `escapeCaller` in the case that
51 ///  something unexpected happens
52 contract Escapable is Owned {
53     address public escapeCaller;
54     address public escapeDestination;
55 
56     /// @notice The Constructor assigns the `escapeDestination` and the
57     ///  `escapeCaller`
58     /// @param _escapeDestination The address of a safe location (usu a
59     ///  Multisig) to send the ether held in this contract
60     /// @param _escapeCaller The address of a trusted account or contract to
61     ///  call `escapeHatch()` to send the ether in this contract to the
62     ///  `escapeDestination` it would be ideal that `escapeCaller` cannot move
63     ///  funds out of `escapeDestination`
64     function Escapable(address _escapeCaller, address _escapeDestination) {
65         escapeCaller = _escapeCaller;
66         escapeDestination = _escapeDestination;
67     }
68 
69     /// @dev The addresses preassigned the `escapeCaller` role
70     ///  is the only addresses that can call a function with this modifier
71     modifier onlyEscapeCallerOrOwner {
72         if ((msg.sender != escapeCaller)&&(msg.sender != owner))
73             throw;
74         _;
75     }
76 
77     /// @notice The `escapeHatch()` should only be called as a last resort if a
78     /// security issue is uncovered or something unexpected happened
79     function escapeHatch() onlyEscapeCallerOrOwner {
80         uint total = this.balance;
81         // Send the total balance of this contract to the `escapeDestination`
82         if (!escapeDestination.send(total)) {
83             throw;
84         }
85         EscapeCalled(total);
86     }
87     /// @notice Changes the address assigned to call `escapeHatch()`
88     /// @param _newEscapeCaller The address of a trusted account or contract to
89     ///  call `escapeHatch()` to send the ether in this contract to the
90     ///  `escapeDestination` it would be ideal that `escapeCaller` cannot
91     ///  move funds out of `escapeDestination`
92     function changeEscapeCaller(address _newEscapeCaller) onlyEscapeCallerOrOwner {
93         escapeCaller = _newEscapeCaller;
94     }
95 
96     event EscapeCalled(uint amount);
97 }
98 
99 /// @dev `Vault` is a higher level contract built off of the `Escapable`
100 ///  contract that holds funds for Campaigns and automates payments.
101 contract Vault is Escapable {
102 
103     /// @dev `Payment` is a public structure that describes the details of
104     ///  each payment making it easy to track the movement of funds
105     ///  transparently
106     struct Payment {
107         string description;     // What is the purpose of this payment
108         address spender;        // Who is sending the funds
109         uint earliestPayTime;   // The earliest a payment can be made (Unix Time)
110         bool canceled;         // If True then the payment has been canceled
111         bool paid;              // If True then the payment has been paid
112         address recipient;      // Who is receiving the funds
113         uint amount;            // The amount of wei sent in the payment
114         uint securityGuardDelay;// The seconds `securityGuard` can delay payment
115     }
116 
117     Payment[] public authorizedPayments;
118 
119     address public securityGuard;
120     uint public absoluteMinTimeLock;
121     uint public timeLock;
122     uint public maxSecurityGuardDelay;
123 
124     /// @dev The white list of approved addresses allowed to set up && receive
125     ///  payments from this vault
126     mapping (address => bool) public allowedSpenders;
127 
128     /// @dev The address assigned the role of `securityGuard` is the only
129     ///  addresses that can call a function with this modifier
130     modifier onlySecurityGuard { if (msg.sender != securityGuard) throw; _; }
131 
132     // @dev Events to make the payment movements easy to find on the blockchain
133     event PaymentAuthorized(uint indexed idPayment, address indexed recipient, uint amount);
134     event PaymentExecuted(uint indexed idPayment, address indexed recipient, uint amount);
135     event PaymentCanceled(uint indexed idPayment);
136     event EtherReceived(address indexed from, uint amount);
137     event SpenderAuthorization(address indexed spender, bool authorized);
138 
139 /////////
140 // Constructor
141 /////////
142 
143     /// @notice The Constructor creates the Vault on the blockchain
144     /// @param _escapeCaller The address of a trusted account or contract to
145     ///  call `escapeHatch()` to send the ether in this contract to the
146     ///  `escapeDestination` it would be ideal if `escapeCaller` cannot move
147     ///  funds out of `escapeDestination`
148     /// @param _escapeDestination The address of a safe location (usu a
149     ///  Multisig) to send the ether held in this contract in an emergency
150     /// @param _absoluteMinTimeLock The minimum number of seconds `timelock` can
151     ///  be set to, if set to 0 the `owner` can remove the `timeLock` completely
152     /// @param _timeLock Initial number of seconds that payments are delayed
153     ///  after they are authorized (a security precaution)
154     /// @param _securityGuard Address that will be able to delay the payments
155     ///  beyond the initial timelock requirements; can be set to 0x0 to remove
156     ///  the `securityGuard` functionality
157     /// @param _maxSecurityGuardDelay The maximum number of seconds in total
158     ///   that `securityGuard` can delay a payment so that the owner can cancel
159     ///   the payment if needed
160     function Vault(
161         address _escapeCaller,
162         address _escapeDestination,
163         uint _absoluteMinTimeLock,
164         uint _timeLock,
165         address _securityGuard,
166         uint _maxSecurityGuardDelay) Escapable(_escapeCaller, _escapeDestination)
167     {
168         absoluteMinTimeLock = _absoluteMinTimeLock;
169         timeLock = _timeLock;
170         securityGuard = _securityGuard;
171         maxSecurityGuardDelay = _maxSecurityGuardDelay;
172     }
173 
174 /////////
175 // Helper functions
176 /////////
177 
178     /// @notice States the total number of authorized payments in this contract
179     /// @return The number of payments ever authorized even if they were canceled
180     function numberOfAuthorizedPayments() constant returns (uint) {
181         return authorizedPayments.length;
182     }
183 
184 //////
185 // Receive Ether
186 //////
187 
188     /// @notice Called anytime ether is sent to the contract && creates an event
189     /// to more easily track the incoming transactions
190     function receiveEther() payable {
191         EtherReceived(msg.sender, msg.value);
192     }
193 
194     /// @notice The fall back function is called whenever ether is sent to this
195     ///  contract
196     function () payable {
197         receiveEther();
198     }
199 
200 ////////
201 // Spender Interface
202 ////////
203 
204     /// @notice only `allowedSpenders[]` Creates a new `Payment`
205     /// @param _description Brief description of the payment that is authorized
206     /// @param _recipient Destination of the payment
207     /// @param _amount Amount to be paid in wei
208     /// @param _paymentDelay Number of seconds the payment is to be delayed, if
209     ///  this value is below `timeLock` then the `timeLock` determines the delay
210     /// @return The Payment ID number for the new authorized payment
211     function authorizePayment(
212         string _description,
213         address _recipient,
214         uint _amount,
215         uint _paymentDelay
216     ) returns(uint) {
217 
218         // Fail if you arent on the `allowedSpenders` white list
219         if (!allowedSpenders[msg.sender] ) throw;
220         uint idPayment = authorizedPayments.length;       // Unique Payment ID
221         authorizedPayments.length++;
222 
223         // The following lines fill out the payment struct
224         Payment p = authorizedPayments[idPayment];
225         p.spender = msg.sender;
226 
227         // Determines the earliest the recipient can receive payment (Unix time)
228         p.earliestPayTime = _paymentDelay >= timeLock ?
229                                 now + _paymentDelay :
230                                 now + timeLock;
231         p.recipient = _recipient;
232         p.amount = _amount;
233         p.description = _description;
234         PaymentAuthorized(idPayment, p.recipient, p.amount);
235         return idPayment;
236     }
237 
238     /// @notice only `allowedSpenders[]` The recipient of a payment calls this
239     ///  function to send themselves the ether after the `earliestPayTime` has
240     ///  expired
241     /// @param _idPayment The payment ID to be executed
242     function collectAuthorizedPayment(uint _idPayment) {
243 
244         // Check that the `_idPayment` has been added to the payments struct
245         if (_idPayment >= authorizedPayments.length) throw;
246 
247         Payment p = authorizedPayments[_idPayment];
248 
249         // Checking for reasons not to execute the payment
250         if (msg.sender != p.recipient) throw;
251         if (!allowedSpenders[p.spender]) throw;
252         if (now < p.earliestPayTime) throw;
253         if (p.canceled) throw;
254         if (p.paid) throw;
255         if (this.balance < p.amount) throw;
256 
257         p.paid = true; // Set the payment to being paid
258         if (!p.recipient.send(p.amount)) {  // Make the payment
259             throw;
260         }
261         PaymentExecuted(_idPayment, p.recipient, p.amount);
262      }
263 
264 /////////
265 // SecurityGuard Interface
266 /////////
267 
268     /// @notice `onlySecurityGuard` Delays a payment for a set number of seconds
269     /// @param _idPayment ID of the payment to be delayed
270     /// @param _delay The number of seconds to delay the payment
271     function delayPayment(uint _idPayment, uint _delay) onlySecurityGuard {
272         if (_idPayment >= authorizedPayments.length) throw;
273 
274         Payment p = authorizedPayments[_idPayment];
275 
276         if ((p.securityGuardDelay + _delay > maxSecurityGuardDelay) ||
277             (p.paid) ||
278             (p.canceled))
279             throw;
280 
281         p.securityGuardDelay += _delay;
282         p.earliestPayTime += _delay;
283     }
284 
285 ////////
286 // Owner Interface
287 ///////
288 
289     /// @notice `onlyOwner` Cancel a payment all together
290     /// @param _idPayment ID of the payment to be canceled.
291     function cancelPayment(uint _idPayment) onlyOwner {
292         if (_idPayment >= authorizedPayments.length) throw;
293 
294         Payment p = authorizedPayments[_idPayment];
295 
296 
297         if (p.canceled) throw;
298         if (p.paid) throw;
299 
300         p.canceled = true;
301         PaymentCanceled(_idPayment);
302     }
303 
304     /// @notice `onlyOwner` Adds a spender to the `allowedSpenders[]` white list
305     /// @param _spender The address of the contract being authorized/unauthorized
306     /// @param _authorize `true` if authorizing and `false` if unauthorizing
307     function authorizeSpender(address _spender, bool _authorize) onlyOwner {
308         allowedSpenders[_spender] = _authorize;
309         SpenderAuthorization(_spender, _authorize);
310     }
311 
312     /// @notice `onlyOwner` Sets the address of `securityGuard`
313     /// @param _newSecurityGuard Address of the new security guard
314     function setSecurityGuard(address _newSecurityGuard) onlyOwner {
315         securityGuard = _newSecurityGuard;
316     }
317 
318 
319     /// @notice `onlyOwner` Changes `timeLock`; the new `timeLock` cannot be
320     ///  lower than `absoluteMinTimeLock`
321     /// @param _newTimeLock Sets the new minimum default `timeLock` in seconds;
322     ///  pending payments maintain their `earliestPayTime`
323     function setTimelock(uint _newTimeLock) onlyOwner {
324         if (_newTimeLock < absoluteMinTimeLock) throw;
325         timeLock = _newTimeLock;
326     }
327 
328     /// @notice `onlyOwner` Changes the maximum number of seconds
329     /// `securityGuard` can delay a payment
330     /// @param _maxSecurityGuardDelay The new maximum delay in seconds that
331     ///  `securityGuard` can delay the payment's execution in total
332     function setMaxSecurityGuardDelay(uint _maxSecurityGuardDelay) onlyOwner {
333         maxSecurityGuardDelay = _maxSecurityGuardDelay;
334     }
335 }