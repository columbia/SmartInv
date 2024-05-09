1 pragma solidity ^0.4.6;
2 
3 /// @title Vault Contract
4 /// @author Jordi Baylina
5 /// @notice This contract holds funds for Campaigns and automates payments, it
6 ///  intends to be a safe place to store funds equipped with optional variable
7 ///  time delays to allow for an optional escape hatch
8 
9 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
10 ///  later changed
11 contract Owned {
12     /// @dev `owner` is the only address that can call a function with this
13     /// modifier
14     modifier onlyOwner { if (msg.sender != owner) throw; _; }
15 
16     address public owner;
17 
18     /// @notice The Constructor assigns the message sender to be `owner`
19     function Owned() { owner = msg.sender;}
20 
21     /// @notice `owner` can step down and assign some other address to this role
22     /// @param _newOwner The address of the new owner. 0x0 can be used to create
23     ///  an unowned neutral vault, however that cannot be undone
24     function changeOwner(address _newOwner) onlyOwner {
25         owner = _newOwner;
26         NewOwner(msg.sender, _newOwner);
27     }
28 
29     event NewOwner(address indexed oldOwner, address indexed newOwner);
30 }
31 
32 /// @dev `Escapable` is a base level contract built off of the `Owned`
33 ///  contract that creates an escape hatch function to send its ether to
34 ///  `escapeHatchDestination` when called by the `escapeHatchCaller` in the case that
35 ///  something unexpected happens
36 contract Escapable is Owned {
37     address public escapeHatchCaller;
38     address public escapeHatchDestination;
39 
40     /// @notice The Constructor assigns the `escapeHatchDestination` and the
41     ///  `escapeHatchCaller`
42     /// @param _escapeHatchDestination The address of a safe location (usu a
43     ///  Multisig) to send the ether held in this contract
44     /// @param _escapeHatchCaller The address of a trusted account or contract to
45     ///  call `escapeHatch()` to send the ether in this contract to the
46     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot move
47     ///  funds out of `escapeHatchDestination`
48     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) {
49         escapeHatchCaller = _escapeHatchCaller;
50         escapeHatchDestination = _escapeHatchDestination;
51     }
52 
53     /// @dev The addresses preassigned the `escapeHatchCaller` role
54     ///  is the only addresses that can call a function with this modifier
55     modifier onlyEscapeHatchCallerOrOwner {
56         if ((msg.sender != escapeHatchCaller)&&(msg.sender != owner))
57             throw;
58         _;
59     }
60 
61     /// @notice The `escapeHatch()` should only be called as a last resort if a
62     /// security issue is uncovered or something unexpected happened
63     function escapeHatch() onlyEscapeHatchCallerOrOwner {
64         uint total = this.balance;
65         // Send the total balance of this contract to the `escapeHatchDestination`
66         if (!escapeHatchDestination.send(total)) {
67             throw;
68         }
69         EscapeHatchCalled(total);
70     }
71     /// @notice Changes the address assigned to call `escapeHatch()`
72     /// @param _newEscapeHatchCaller The address of a trusted account or contract to
73     ///  call `escapeHatch()` to send the ether in this contract to the
74     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot
75     ///  move funds out of `escapeHatchDestination`
76     function changeEscapeCaller(address _newEscapeHatchCaller) onlyEscapeHatchCallerOrOwner {
77         escapeHatchCaller = _newEscapeHatchCaller;
78     }
79 
80     event EscapeHatchCalled(uint amount);
81 }
82 
83 /// @dev `Vault` is a higher level contract built off of the `Escapable`
84 ///  contract that holds funds for Campaigns and automates payments.
85 contract Vault is Escapable {
86 
87     /// @dev `Payment` is a public structure that describes the details of
88     ///  each payment making it easy to track the movement of funds
89     ///  transparently
90     struct Payment {
91         string name;     // What is the purpose of this payment
92         bytes32 reference;  // Reference of the payment.
93         address spender;        // Who is sending the funds
94         uint earliestPayTime;   // The earliest a payment can be made (Unix Time)
95         bool canceled;         // If True then the payment has been canceled
96         bool paid;              // If True then the payment has been paid
97         address recipient;      // Who is receiving the funds
98         uint amount;            // The amount of wei sent in the payment
99         uint securityGuardDelay;// The seconds `securityGuard` can delay payment
100     }
101 
102     Payment[] public authorizedPayments;
103 
104     address public securityGuard;
105     uint public absoluteMinTimeLock;
106     uint public timeLock;
107     uint public maxSecurityGuardDelay;
108 
109     /// @dev The white list of approved addresses allowed to set up && receive
110     ///  payments from this vault
111     mapping (address => bool) public allowedSpenders;
112 
113     /// @dev The address assigned the role of `securityGuard` is the only
114     ///  addresses that can call a function with this modifier
115     modifier onlySecurityGuard { if (msg.sender != securityGuard) throw; _; }
116 
117     // @dev Events to make the payment movements easy to find on the blockchain
118     event PaymentAuthorized(uint indexed idPayment, address indexed recipient, uint amount);
119     event PaymentExecuted(uint indexed idPayment, address indexed recipient, uint amount);
120     event PaymentCanceled(uint indexed idPayment);
121     event EtherReceived(address indexed from, uint amount);
122     event SpenderAuthorization(address indexed spender, bool authorized);
123 
124 /////////
125 // Constructor
126 /////////
127 
128     /// @notice The Constructor creates the Vault on the blockchain
129     /// @param _escapeHatchCaller The address of a trusted account or contract to
130     ///  call `escapeHatch()` to send the ether in this contract to the
131     ///  `escapeHatchDestination` it would be ideal if `escapeHatchCaller` cannot move
132     ///  funds out of `escapeHatchDestination`
133     /// @param _escapeHatchDestination The address of a safe location (usu a
134     ///  Multisig) to send the ether held in this contract in an emergency
135     /// @param _absoluteMinTimeLock The minimum number of seconds `timelock` can
136     ///  be set to, if set to 0 the `owner` can remove the `timeLock` completely
137     /// @param _timeLock Initial number of seconds that payments are delayed
138     ///  after they are authorized (a security precaution)
139     /// @param _securityGuard Address that will be able to delay the payments
140     ///  beyond the initial timelock requirements; can be set to 0x0 to remove
141     ///  the `securityGuard` functionality
142     /// @param _maxSecurityGuardDelay The maximum number of seconds in total
143     ///   that `securityGuard` can delay a payment so that the owner can cancel
144     ///   the payment if needed
145     function Vault(
146         address _escapeHatchCaller,
147         address _escapeHatchDestination,
148         uint _absoluteMinTimeLock,
149         uint _timeLock,
150         address _securityGuard,
151         uint _maxSecurityGuardDelay) Escapable(_escapeHatchCaller, _escapeHatchDestination)
152     {
153         absoluteMinTimeLock = _absoluteMinTimeLock;
154         timeLock = _timeLock;
155         securityGuard = _securityGuard;
156         maxSecurityGuardDelay = _maxSecurityGuardDelay;
157     }
158 
159 /////////
160 // Helper functions
161 /////////
162 
163     /// @notice States the total number of authorized payments in this contract
164     /// @return The number of payments ever authorized even if they were canceled
165     function numberOfAuthorizedPayments() constant returns (uint) {
166         return authorizedPayments.length;
167     }
168 
169 //////
170 // Receive Ether
171 //////
172 
173     /// @notice Called anytime ether is sent to the contract && creates an event
174     /// to more easily track the incoming transactions
175     function receiveEther() payable {
176         EtherReceived(msg.sender, msg.value);
177     }
178 
179     /// @notice The fall back function is called whenever ether is sent to this
180     ///  contract
181     function () payable {
182         receiveEther();
183     }
184 
185 ////////
186 // Spender Interface
187 ////////
188 
189     /// @notice only `allowedSpenders[]` Creates a new `Payment`
190     /// @param _name Brief description of the payment that is authorized
191     /// @param _reference External reference of the payment
192     /// @param _recipient Destination of the payment
193     /// @param _amount Amount to be paid in wei
194     /// @param _paymentDelay Number of seconds the payment is to be delayed, if
195     ///  this value is below `timeLock` then the `timeLock` determines the delay
196     /// @return The Payment ID number for the new authorized payment
197     function authorizePayment(
198         string _name,
199         bytes32 _reference,
200         address _recipient,
201         uint _amount,
202         uint _paymentDelay
203     ) returns(uint) {
204 
205         // Fail if you arent on the `allowedSpenders` white list
206         if (!allowedSpenders[msg.sender] ) throw;
207         uint idPayment = authorizedPayments.length;       // Unique Payment ID
208         authorizedPayments.length++;
209 
210         // The following lines fill out the payment struct
211         Payment p = authorizedPayments[idPayment];
212         p.spender = msg.sender;
213 
214         // Overflow protection
215         if (_paymentDelay > 10**18) throw;
216 
217         // Determines the earliest the recipient can receive payment (Unix time)
218         p.earliestPayTime = _paymentDelay >= timeLock ?
219                                 now + _paymentDelay :
220                                 now + timeLock;
221         p.recipient = _recipient;
222         p.amount = _amount;
223         p.name = _name;
224         p.reference = _reference;
225         PaymentAuthorized(idPayment, p.recipient, p.amount);
226         return idPayment;
227     }
228 
229     /// @notice only `allowedSpenders[]` The recipient of a payment calls this
230     ///  function to send themselves the ether after the `earliestPayTime` has
231     ///  expired
232     /// @param _idPayment The payment ID to be executed
233     function collectAuthorizedPayment(uint _idPayment) {
234 
235         // Check that the `_idPayment` has been added to the payments struct
236         if (_idPayment >= authorizedPayments.length) throw;
237 
238         Payment p = authorizedPayments[_idPayment];
239 
240         // Checking for reasons not to execute the payment
241         if (msg.sender != p.recipient) throw;
242         if (!allowedSpenders[p.spender]) throw;
243         if (now < p.earliestPayTime) throw;
244         if (p.canceled) throw;
245         if (p.paid) throw;
246         if (this.balance < p.amount) throw;
247 
248         p.paid = true; // Set the payment to being paid
249         if (!p.recipient.send(p.amount)) {  // Make the payment
250             throw;
251         }
252         PaymentExecuted(_idPayment, p.recipient, p.amount);
253      }
254 
255 /////////
256 // SecurityGuard Interface
257 /////////
258 
259     /// @notice `onlySecurityGuard` Delays a payment for a set number of seconds
260     /// @param _idPayment ID of the payment to be delayed
261     /// @param _delay The number of seconds to delay the payment
262     function delayPayment(uint _idPayment, uint _delay) onlySecurityGuard {
263         if (_idPayment >= authorizedPayments.length) throw;
264 
265         // Overflow test
266         if (_delay > 10**18) throw;
267 
268         Payment p = authorizedPayments[_idPayment];
269 
270         if ((p.securityGuardDelay + _delay > maxSecurityGuardDelay) ||
271             (p.paid) ||
272             (p.canceled))
273             throw;
274 
275         p.securityGuardDelay += _delay;
276         p.earliestPayTime += _delay;
277     }
278 
279 ////////
280 // Owner Interface
281 ///////
282 
283     /// @notice `onlyOwner` Cancel a payment all together
284     /// @param _idPayment ID of the payment to be canceled.
285     function cancelPayment(uint _idPayment) onlyOwner {
286         if (_idPayment >= authorizedPayments.length) throw;
287 
288         Payment p = authorizedPayments[_idPayment];
289 
290 
291         if (p.canceled) throw;
292         if (p.paid) throw;
293 
294         p.canceled = true;
295         PaymentCanceled(_idPayment);
296     }
297 
298     /// @notice `onlyOwner` Adds a spender to the `allowedSpenders[]` white list
299     /// @param _spender The address of the contract being authorized/unauthorized
300     /// @param _authorize `true` if authorizing and `false` if unauthorizing
301     function authorizeSpender(address _spender, bool _authorize) onlyOwner {
302         allowedSpenders[_spender] = _authorize;
303         SpenderAuthorization(_spender, _authorize);
304     }
305 
306     /// @notice `onlyOwner` Sets the address of `securityGuard`
307     /// @param _newSecurityGuard Address of the new security guard
308     function setSecurityGuard(address _newSecurityGuard) onlyOwner {
309         securityGuard = _newSecurityGuard;
310     }
311 
312     /// @notice `onlyOwner` Changes `timeLock`; the new `timeLock` cannot be
313     ///  lower than `absoluteMinTimeLock`
314     /// @param _newTimeLock Sets the new minimum default `timeLock` in seconds;
315     ///  pending payments maintain their `earliestPayTime`
316     function setTimelock(uint _newTimeLock) onlyOwner {
317         if (_newTimeLock < absoluteMinTimeLock) throw;
318         timeLock = _newTimeLock;
319     }
320 
321     /// @notice `onlyOwner` Changes the maximum number of seconds
322     /// `securityGuard` can delay a payment
323     /// @param _maxSecurityGuardDelay The new maximum delay in seconds that
324     ///  `securityGuard` can delay the payment's execution in total
325     function setMaxSecurityGuardDelay(uint _maxSecurityGuardDelay) onlyOwner {
326         maxSecurityGuardDelay = _maxSecurityGuardDelay;
327     }
328 }