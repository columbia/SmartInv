1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 pragma solidity ^0.4.24;
68 
69 
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * See https://github.com/ethereum/EIPs/issues/179
74  */
75 contract ERC20Basic {
76   function totalSupply() public view returns (uint256);
77   function balanceOf(address _who) public view returns (uint256);
78   function transfer(address _to, uint256 _value) public returns (bool);
79   event Transfer(address indexed from, address indexed to, uint256 value);
80 }
81 
82 
83 pragma solidity ^0.4.24;
84 
85 
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address _owner, address _spender)
93     public view returns (uint256);
94 
95   function transferFrom(address _from, address _to, uint256 _value)
96     public returns (bool);
97 
98   function approve(address _spender, uint256 _value) public returns (bool);
99   event Approval(
100     address indexed owner,
101     address indexed spender,
102     uint256 value
103   );
104 }
105 
106 
107 pragma solidity ^0.4.24;
108 
109 
110 
111 /**
112  * @title DetailedERC20 token
113  * @dev The decimals are only for visualization purposes.
114  * All the operations are done using the smallest and indivisible token unit,
115  * just as on Ethereum all the operations are done in wei.
116  */
117 contract DetailedERC20 is ERC20 {
118   string public name;
119   string public symbol;
120   uint8 public decimals;
121 
122   constructor(string _name, string _symbol, uint8 _decimals) public {
123     name = _name;
124     symbol = _symbol;
125     decimals = _decimals;
126   }
127 }
128 
129 
130 /**
131    Copyright (c) 2017 Harbor Platform, Inc.
132 
133    Licensed under the Apache License, Version 2.0 (the “License”);
134    you may not use this file except in compliance with the License.
135    You may obtain a copy of the License at
136 
137    http://www.apache.org/licenses/LICENSE-2.0
138 
139    Unless required by applicable law or agreed to in writing, software
140    distributed under the License is distributed on an “AS IS” BASIS,
141    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
142    See the License for the specific language governing permissions and
143    limitations under the License.
144 */
145 
146 pragma solidity ^0.4.24;
147 
148 /// @notice Standard interface for `RegulatorService`s
149 contract RegulatorServiceI {
150 
151   /*
152    * @notice This method *MUST* be called by `RegulatedToken`s during `transfer()` and `transferFrom()`.
153    *         The implementation *SHOULD* check whether or not a transfer can be approved.
154    *
155    * @dev    This method *MAY* call back to the token contract specified by `_token` for
156    *         more information needed to enforce trade approval.
157    *
158    * @param  _token The address of the token to be transfered
159    * @param  _spender The address of the spender of the token
160    * @param  _from The address of the sender account
161    * @param  _to The address of the receiver account
162    * @param  _amount The quantity of the token to trade
163    *
164    * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation
165    *               to assign meaning.
166    */
167   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);
168 }
169 
170 
171 pragma solidity ^0.4.18;
172 
173 
174 
175 
176 /**
177  * @title  On-chain RegulatorService implementation for approving trades
178  * @author Originally Bob Remeika, modified by TokenSoft Inc
179  * @dev Orignal source: https://github.com/harborhq/r-token/blob/master/contracts/TokenRegulatorService.sol
180  */
181 contract RegulatorService is RegulatorServiceI, Ownable {
182   /**
183    * @dev Throws if called by any account other than the admin
184    */
185   modifier onlyAdmins() {
186     require(msg.sender == admin || msg.sender == owner);
187     _;
188   }
189 
190   /// @dev Settings that affect token trading at a global level
191   struct Settings {
192 
193     /**
194      * @dev Toggle for locking/unlocking trades at a token level.
195      *      The default behavior of the zero memory state for locking will be unlocked.
196      */
197     bool locked;
198 
199     /**
200      * @dev Toggle for allowing/disallowing fractional token trades at a token level.
201      *      The default state when this contract is created `false` (or no partial
202      *      transfers allowed).
203      */
204     bool partialTransfers;
205 
206     /**
207      * @dev Mappning for 12 months hold up period for investors.
208      * @param  address investors wallet
209      * @param  uint256 holdingPeriod start date in unix
210      */
211     mapping(address => uint256) holdingPeriod;
212   }
213 
214   // @dev number of seconds in a year = 365 * 24 * 60 * 60
215   uint256 constant private YEAR = 1 years;
216 
217   // @dev Check success code & message
218   uint8 constant private CHECK_SUCCESS = 0;
219   string constant private SUCCESS_MESSAGE = 'Success';
220 
221   // @dev Check error reason: Token is locked
222   uint8 constant private CHECK_ELOCKED = 1;
223   string constant private ELOCKED_MESSAGE = 'Token is locked';
224 
225   // @dev Check error reason: Token can not trade partial amounts
226   uint8 constant private CHECK_EDIVIS = 2;
227   string constant private EDIVIS_MESSAGE = 'Token can not trade partial amounts';
228 
229   // @dev Check error reason: Sender is not allowed to send the token
230   uint8 constant private CHECK_ESEND = 3;
231   string constant private ESEND_MESSAGE = 'Sender is not allowed to send the token';
232 
233   // @dev Check error reason: Receiver is not allowed to receive the token
234   uint8 constant private CHECK_ERECV = 4;
235   string constant private ERECV_MESSAGE = 'Receiver is not allowed to receive the token';
236 
237   uint8 constant private CHECK_EHOLDING_PERIOD = 5;
238   string constant private EHOLDING_PERIOD_MESSAGE = 'Sender is still in 12 months holding period';
239 
240   uint8 constant private CHECK_EDECIMALS = 6;
241   string constant private EDECIMALS_MESSAGE = 'Transfer value must be bigger than 0.000001 or 1 szabo';
242 
243   uint256 constant public MINIMAL_TRANSFER = 1 szabo;
244 
245   /// @dev Permission bits for allowing a participant to send tokens
246   uint8 constant private PERM_SEND = 0x1;
247 
248   /// @dev Permission bits for allowing a participant to receive tokens
249   uint8 constant private PERM_RECEIVE = 0x2;
250 
251   // @dev Address of the administrator
252   address public admin;
253 
254   /// @notice Permissions that allow/disallow token trades on a per token level
255   mapping(address => Settings) private settings;
256 
257   /// @dev Permissions that allow/disallow token trades on a per participant basis.
258   ///      The format for key based access is `participants[tokenAddress][participantAddress]`
259   ///      which returns the permission bits of a participant for a particular token.
260   mapping(address => mapping(address => uint8)) private participants;
261 
262   /// @dev Event raised when a token's locked setting is set
263   event LogLockSet(address indexed token, bool locked);
264 
265   /// @dev Event raised when a token's partial transfer setting is set
266   event LogPartialTransferSet(address indexed token, bool enabled);
267 
268   /// @dev Event raised when a participant permissions are set for a token
269   event LogPermissionSet(address indexed token, address indexed participant, uint8 permission);
270 
271   /// @dev Event raised when the admin address changes
272   event LogTransferAdmin(address indexed oldAdmin, address indexed newAdmin);
273 
274   /// @dev Event raised when holding period start date is set for participant
275   event LogHoldingPeriod(
276     address indexed _token, address indexed _participant, uint256 _startDate);
277 
278   constructor() public {
279     admin = msg.sender;
280   }
281 
282   /**
283    * @notice Locks the ability to trade a token
284    *
285    * @dev    This method can only be called by this contract's owner
286    *
287    * @param  _token The address of the token to lock
288    */
289   function setLocked(address _token, bool _locked) onlyOwner public {
290     settings[_token].locked = _locked;
291 
292     emit LogLockSet(_token, _locked);
293   }
294 
295   /**
296    * @notice Allows the ability to trade a fraction of a token
297    *
298    * @dev    This method can only be called by this contract's owner
299    *
300    * @param  _token The address of the token to allow partial transfers
301    */
302   function setPartialTransfers(address _token, bool _enabled) onlyOwner public {
303    settings[_token].partialTransfers = _enabled;
304 
305    emit LogPartialTransferSet(_token, _enabled);
306   }
307 
308   /**
309    * @notice Sets the trade permissions for a participant on a token
310    *
311    * @dev    The `_permission` bits overwrite the previous trade permissions and can
312    *         only be called by the contract's owner.  `_permissions` can be bitwise
313    *         `|`'d together to allow for more than one permission bit to be set.
314    *
315    * @param  _token The address of the token
316    * @param  _participant The address of the trade participant
317    * @param  _permission Permission bits to be set
318    */
319   function setPermission(address _token, address _participant, uint8 _permission) onlyAdmins public {
320     participants[_token][_participant] = _permission;
321 
322     emit LogPermissionSet(_token, _participant, _permission);
323   }
324 
325   /**
326    * @notice Set initial holding period for investor
327    * @param _token       token address
328    * @param _participant participant address
329    * @param _startDate   start date of holding period in UNIX format
330    */
331   function setHoldingPeriod(address _token, address _participant, uint256 _startDate) onlyAdmins public {
332     settings[_token].holdingPeriod[_participant] = _startDate;
333 
334     emit LogHoldingPeriod(_token, _participant, _startDate);
335   }
336 
337   /**
338    * @dev Allows the owner to transfer admin controls to newAdmin.
339    *
340    * @param newAdmin The address to transfer admin rights to.
341    */
342   function transferAdmin(address newAdmin) onlyOwner public {
343     require(newAdmin != address(0));
344 
345     address oldAdmin = admin;
346     admin = newAdmin;
347 
348     emit LogTransferAdmin(oldAdmin, newAdmin);
349   }
350 
351   /**
352    * @notice Checks whether or not a trade should be approved
353    *
354    * @dev    This method calls back to the token contract specified by `_token` for
355    *         information needed to enforce trade approval if needed
356    *
357    * @param  _token The address of the token to be transfered
358    * @param  _spender The address of the spender of the token (unused in this implementation)
359    * @param  _from The address of the sender account
360    * @param  _to The address of the receiver account
361    * @param  _amount The quantity of the token to trade
362    *
363    * @return `true` if the trade should be approved and `false` if the trade should not be approved
364    */
365   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8) {
366     if (settings[_token].locked) {
367       return CHECK_ELOCKED;
368     }
369 
370     if (participants[_token][_from] & PERM_SEND == 0) {
371       return CHECK_ESEND;
372     }
373 
374     if (participants[_token][_to] & PERM_RECEIVE == 0) {
375       return CHECK_ERECV;
376     }
377 
378     if (!settings[_token].partialTransfers && _amount % _wholeToken(_token) != 0) {
379       return CHECK_EDIVIS;
380     }
381 
382     if (settings[_token].holdingPeriod[_from] + YEAR >= now) {
383       return CHECK_EHOLDING_PERIOD;
384     }
385 
386     if (_amount < MINIMAL_TRANSFER) {
387       return CHECK_EDECIMALS;
388     }
389 
390     return CHECK_SUCCESS;
391   }
392 
393   /**
394    * @notice Returns the error message for a passed failed check reason
395    *
396    * @param  _reason The reason code: 0 means success.  Non-zero values are left to the implementation
397    *                 to assign meaning.
398    *
399    * @return The human-readable mesage string
400    */
401   function messageForReason (uint8 _reason) public pure returns (string) {
402     if (_reason == CHECK_ELOCKED) {
403       return ELOCKED_MESSAGE;
404     }
405     
406     if (_reason == CHECK_ESEND) {
407       return ESEND_MESSAGE;
408     }
409 
410     if (_reason == CHECK_ERECV) {
411       return ERECV_MESSAGE;
412     }
413 
414     if (_reason == CHECK_EDIVIS) {
415       return EDIVIS_MESSAGE;
416     }
417 
418     if (_reason == CHECK_EHOLDING_PERIOD) {
419       return EHOLDING_PERIOD_MESSAGE;
420     }
421 
422     if (_reason == CHECK_EDECIMALS) {
423       return EDECIMALS_MESSAGE;
424     }
425 
426     return SUCCESS_MESSAGE;
427   }
428 
429   /**
430    * @notice Retrieves the whole token value from a token that this `RegulatorService` manages
431    *
432    * @param  _token The token address of the managed token
433    *
434    * @return The uint256 value that represents a single whole token
435    */
436   function _wholeToken(address _token) view private returns (uint256) {
437     return uint256(10)**DetailedERC20(_token).decimals();
438   }
439 }