1 pragma solidity ^0.4.24;
2 
3 pragma solidity ^0.4.24;
4 
5 /// @notice Standard interface for `RegulatorService`s
6 contract RegulatorServiceI {
7 
8   /*
9    * @notice This method *MUST* be called by `RegulatedToken`s during `transfer()` and `transferFrom()`.
10    *         The implementation *SHOULD* check whether or not a transfer can be approved.
11    *
12    * @dev    This method *MAY* call back to the token contract specified by `_token` for
13    *         more information needed to enforce trade approval.
14    *
15    * @param  _token The address of the token to be transfered
16    * @param  _spender The address of the spender of the token
17    * @param  _from The address of the sender account
18    * @param  _to The address of the receiver account
19    * @param  _amount The quantity of the token to trade
20    *
21    * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation
22    *               to assign meaning.
23    */
24   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);
25 }
26 
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipRenounced(address indexed previousOwner);
38   event OwnershipTransferred(
39     address indexed previousOwner,
40     address indexed newOwner
41   );
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   constructor() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to relinquish control of the contract.
62    * @notice Renouncing to ownership will leave the contract without an owner.
63    * It will not be possible to call the functions with the `onlyOwner`
64    * modifier anymore.
65    */
66   function renounceOwnership() public onlyOwner {
67     emit OwnershipRenounced(owner);
68     owner = address(0);
69   }
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param _newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address _newOwner) public onlyOwner {
76     _transferOwnership(_newOwner);
77   }
78 
79   /**
80    * @dev Transfers control of the contract to a newOwner.
81    * @param _newOwner The address to transfer ownership to.
82    */
83   function _transferOwnership(address _newOwner) internal {
84     require(_newOwner != address(0));
85     emit OwnershipTransferred(owner, _newOwner);
86     owner = _newOwner;
87   }
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * See https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address _who) public view returns (uint256);
99   function transfer(address _to, uint256 _value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address _owner, address _spender)
110     public view returns (uint256);
111 
112   function transferFrom(address _from, address _to, uint256 _value)
113     public returns (bool);
114 
115   function approve(address _spender, uint256 _value) public returns (bool);
116   event Approval(
117     address indexed owner,
118     address indexed spender,
119     uint256 value
120   );
121 }
122 
123 
124 /**
125  * @title DetailedERC20 token
126  * @dev The decimals are only for visualization purposes.
127  * All the operations are done using the smallest and indivisible token unit,
128  * just as on Ethereum all the operations are done in wei.
129  */
130 contract DetailedERC20 is ERC20 {
131   string public name;
132   string public symbol;
133   uint8 public decimals;
134 
135   constructor(string _name, string _symbol, uint8 _decimals) public {
136     name = _name;
137     symbol = _symbol;
138     decimals = _decimals;
139   }
140 }
141 
142 
143 /**
144  * @title  On-chain RegulatorService implementation for approving trades
145  * @author Originally Bob Remeika, modified by TokenSoft Inc
146  * @dev Orignal source: https://github.com/harborhq/r-token/blob/master/contracts/TokenRegulatorService.sol
147  */
148 contract RegulatorService is RegulatorServiceI, Ownable {
149   /**
150    * @dev Throws if called by any account other than the admin
151    */
152   modifier onlyAdmins() {
153     require(msg.sender == admin || msg.sender == owner);
154     _;
155   }
156 
157   /// @dev Settings that affect token trading at a global level
158   struct Settings {
159 
160     /**
161      * @dev Toggle for locking/unlocking trades at a token level.
162      *      The default behavior of the zero memory state for locking will be unlocked.
163      */
164     bool locked;
165 
166     /**
167      * @dev Toggle for allowing/disallowing fractional token trades at a token level.
168      *      The default state when this contract is created `false` (or no partial
169      *      transfers allowed).
170      */
171     bool partialTransfers;
172   }
173 
174   // @dev Check success code & message
175   uint8 constant private CHECK_SUCCESS = 0;
176   string constant private SUCCESS_MESSAGE = 'Success';
177 
178   // @dev Check error reason: Token is locked
179   uint8 constant private CHECK_ELOCKED = 1;
180   string constant private ELOCKED_MESSAGE = 'Token is locked';
181 
182   // @dev Check error reason: Token can not trade partial amounts
183   uint8 constant private CHECK_EDIVIS = 2;
184   string constant private EDIVIS_MESSAGE = 'Token can not trade partial amounts';
185 
186   // @dev Check error reason: Sender is not allowed to send the token
187   uint8 constant private CHECK_ESEND = 3;
188   string constant private ESEND_MESSAGE = 'Sender is not allowed to send the token';
189 
190   // @dev Check error reason: Receiver is not allowed to receive the token
191   uint8 constant private CHECK_ERECV = 4;
192   string constant private ERECV_MESSAGE = 'Receiver is not allowed to receive the token';
193 
194   /// @dev Permission bits for allowing a participant to send tokens
195   uint8 constant private PERM_SEND = 0x1;
196 
197   /// @dev Permission bits for allowing a participant to receive tokens
198   uint8 constant private PERM_RECEIVE = 0x2;
199 
200   // @dev Address of the administrator
201   address public admin;
202 
203   /// @notice Permissions that allow/disallow token trades on a per token level
204   mapping(address => Settings) private settings;
205 
206   /// @dev Permissions that allow/disallow token trades on a per participant basis.
207   ///      The format for key based access is `participants[tokenAddress][participantAddress]`
208   ///      which returns the permission bits of a participant for a particular token.
209   mapping(address => mapping(address => uint8)) private participants;
210 
211   /// @dev Event raised when a token's locked setting is set
212   event LogLockSet(address indexed token, bool locked);
213 
214   /// @dev Event raised when a token's partial transfer setting is set
215   event LogPartialTransferSet(address indexed token, bool enabled);
216 
217   /// @dev Event raised when a participant permissions are set for a token
218   event LogPermissionSet(address indexed token, address indexed participant, uint8 permission);
219 
220   /// @dev Event raised when the admin address changes
221   event LogTransferAdmin(address indexed oldAdmin, address indexed newAdmin);
222 
223   constructor() public {
224     admin = msg.sender;
225   }
226 
227   /**
228    * @notice Locks the ability to trade a token
229    *
230    * @dev    This method can only be called by this contract's owner
231    *
232    * @param  _token The address of the token to lock
233    */
234   function setLocked(address _token, bool _locked) onlyOwner public {
235     settings[_token].locked = _locked;
236 
237     emit LogLockSet(_token, _locked);
238   }
239 
240   /**
241    * @notice Allows the ability to trade a fraction of a token
242    *
243    * @dev    This method can only be called by this contract's owner
244    *
245    * @param  _token The address of the token to allow partial transfers
246    */
247   function setPartialTransfers(address _token, bool _enabled) onlyOwner public {
248    settings[_token].partialTransfers = _enabled;
249 
250    emit LogPartialTransferSet(_token, _enabled);
251   }
252 
253   /**
254    * @notice Sets the trade permissions for a participant on a token
255    *
256    * @dev    The `_permission` bits overwrite the previous trade permissions and can
257    *         only be called by the contract's owner.  `_permissions` can be bitwise
258    *         `|`'d together to allow for more than one permission bit to be set.
259    *
260    * @param  _token The address of the token
261    * @param  _participant The address of the trade participant
262    * @param  _permission Permission bits to be set
263    */
264   function setPermission(address _token, address _participant, uint8 _permission) onlyAdmins public {
265     participants[_token][_participant] = _permission;
266 
267     emit LogPermissionSet(_token, _participant, _permission);
268   }
269 
270   /**
271    * @dev Allows the owner to transfer admin controls to newAdmin.
272    *
273    * @param newAdmin The address to transfer admin rights to.
274    */
275   function transferAdmin(address newAdmin) onlyOwner public {
276     require(newAdmin != address(0));
277 
278     address oldAdmin = admin;
279     admin = newAdmin;
280 
281     emit LogTransferAdmin(oldAdmin, newAdmin);
282   }
283 
284   /**
285    * @notice Checks whether or not a trade should be approved
286    *
287    * @dev    This method calls back to the token contract specified by `_token` for
288    *         information needed to enforce trade approval if needed
289    *
290    * @param  _token The address of the token to be transfered
291    * @param  _spender The address of the spender of the token (unused in this implementation)
292    * @param  _from The address of the sender account
293    * @param  _to The address of the receiver account
294    * @param  _amount The quantity of the token to trade
295    *
296    * @return `true` if the trade should be approved and `false` if the trade should not be approved
297    */
298   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8) {
299     if (settings[_token].locked) {
300       return CHECK_ELOCKED;
301     }
302 
303     if (participants[_token][_from] & PERM_SEND == 0) {
304       return CHECK_ESEND;
305     }
306 
307     if (participants[_token][_to] & PERM_RECEIVE == 0) {
308       return CHECK_ERECV;
309     }
310 
311     if (!settings[_token].partialTransfers && _amount % _wholeToken(_token) != 0) {
312       return CHECK_EDIVIS;
313     }
314 
315     return CHECK_SUCCESS;
316   }
317 
318   /**
319    * @notice Returns the error message for a passed failed check reason
320    *
321    * @param  _reason The reason code: 0 means success.  Non-zero values are left to the implementation
322    *                 to assign meaning.
323    *
324    * @return The human-readable mesage string
325    */
326   function messageForReason (uint8 _reason) public pure returns (string) {
327     if (_reason == CHECK_ELOCKED) {
328       return ELOCKED_MESSAGE;
329     }
330     
331     if (_reason == CHECK_ESEND) {
332       return ESEND_MESSAGE;
333     }
334 
335     if (_reason == CHECK_ERECV) {
336       return ERECV_MESSAGE;
337     }
338 
339     if (_reason == CHECK_EDIVIS) {
340       return EDIVIS_MESSAGE;
341     }
342 
343     return SUCCESS_MESSAGE;
344   }
345 
346   /**
347    * @notice Retrieves the whole token value from a token that this `RegulatorService` manages
348    *
349    * @param  _token The token address of the managed token
350    *
351    * @return The uint256 value that represents a single whole token
352    */
353   function _wholeToken(address _token) view private returns (uint256) {
354     return uint256(10)**DetailedERC20(_token).decimals();
355   }
356 }