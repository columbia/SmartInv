1 pragma solidity ^0.4.24;
2 
3 library Attribute {
4   enum AttributeType {
5     ROLE_MANAGER,                   // 0
6     ROLE_OPERATOR,                  // 1
7     IS_BLACKLISTED,                 // 2
8     HAS_PASSED_KYC_AML,             // 3
9     NO_FEES,                        // 4
10     /* Additional user-defined later */
11     USER_DEFINED
12   }
13 
14   function toUint256(AttributeType _type) internal pure returns (uint256) {
15     return uint256(_type);
16   }
17 }
18 
19 
20 library BitManipulation {
21   uint256 constant internal ONE = uint256(1);
22 
23   function setBit(uint256 _num, uint256 _pos) internal pure returns (uint256) {
24     return _num | (ONE << _pos);
25   }
26 
27   function clearBit(uint256 _num, uint256 _pos) internal pure returns (uint256) {
28     return _num & ~(ONE << _pos);
29   }
30 
31   function toggleBit(uint256 _num, uint256 _pos) internal pure returns (uint256) {
32     return _num ^ (ONE << _pos);
33   }
34 
35   function checkBit(uint256 _num, uint256 _pos) internal pure returns (bool) {
36     return (_num >> _pos & ONE == ONE);
37   }
38 }
39 
40 
41 
42 /**
43  * @title Ownable
44  * @dev The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipRenounced(address indexed previousOwner);
52   event OwnershipTransferred(
53     address indexed previousOwner,
54     address indexed newOwner
55   );
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   constructor() public {
63     owner = msg.sender;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   /**
75    * @dev Allows the current owner to relinquish control of the contract.
76    * @notice Renouncing to ownership will leave the contract without an owner.
77    * It will not be possible to call the functions with the `onlyOwner`
78    * modifier anymore.
79    */
80   function renounceOwnership() public onlyOwner {
81     emit OwnershipRenounced(owner);
82     owner = address(0);
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param _newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address _newOwner) public onlyOwner {
90     _transferOwnership(_newOwner);
91   }
92 
93   /**
94    * @dev Transfers control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function _transferOwnership(address _newOwner) internal {
98     require(_newOwner != address(0));
99     emit OwnershipTransferred(owner, _newOwner);
100     owner = _newOwner;
101   }
102 }
103 
104 
105 
106 
107 
108 
109 // Interface for logic governing write access to a Registry.
110 contract RegistryAccessManager {
111   // Called when _admin attempts to write _value for _who's _attribute.
112   // Returns true if the write is allowed to proceed.
113   function confirmWrite(
114     address _who,
115     Attribute.AttributeType _attribute,
116     address _admin
117   )
118     public returns (bool);
119 }
120 
121 
122 
123 
124 
125 
126 
127 
128 
129 
130 /**
131  * @title Claimable
132  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
133  * This allows the new owner to accept the transfer.
134  */
135 contract Claimable is Ownable {
136   address public pendingOwner;
137 
138   /**
139    * @dev Modifier throws if called by any account other than the pendingOwner.
140    */
141   modifier onlyPendingOwner() {
142     require(msg.sender == pendingOwner);
143     _;
144   }
145 
146   /**
147    * @dev Allows the current owner to set the pendingOwner address.
148    * @param newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address newOwner) public onlyOwner {
151     pendingOwner = newOwner;
152   }
153 
154   /**
155    * @dev Allows the pendingOwner address to finalize the transfer.
156    */
157   function claimOwnership() public onlyPendingOwner {
158     emit OwnershipTransferred(owner, pendingOwner);
159     owner = pendingOwner;
160     pendingOwner = address(0);
161   }
162 }
163 
164 
165 
166 /**
167  * @title Claimable Ex
168  * @dev Extension for the Claimable contract, where the ownership transfer can be canceled.
169  */
170 contract ClaimableEx is Claimable {
171   /*
172    * @dev Cancels the ownership transfer.
173    */
174   function cancelOwnershipTransfer() onlyOwner public {
175     pendingOwner = owner;
176   }
177 }
178 
179 
180 
181 
182 
183 
184 
185 
186 /**
187  * @title SafeMath
188  * @dev Math operations with safety checks that throw on error
189  */
190 library SafeMath {
191 
192   /**
193   * @dev Multiplies two numbers, throws on overflow.
194   */
195   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
196     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
197     // benefit is lost if 'b' is also tested.
198     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
199     if (_a == 0) {
200       return 0;
201     }
202 
203     c = _a * _b;
204     assert(c / _a == _b);
205     return c;
206   }
207 
208   /**
209   * @dev Integer division of two numbers, truncating the quotient.
210   */
211   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
212     // assert(_b > 0); // Solidity automatically throws when dividing by 0
213     // uint256 c = _a / _b;
214     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
215     return _a / _b;
216   }
217 
218   /**
219   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
220   */
221   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
222     assert(_b <= _a);
223     return _a - _b;
224   }
225 
226   /**
227   * @dev Adds two numbers, throws on overflow.
228   */
229   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
230     c = _a + _b;
231     assert(c >= _a);
232     return c;
233   }
234 }
235 
236 
237 
238 
239 
240 
241 
242 
243 
244 
245 
246 contract Registry is ClaimableEx {
247   using BitManipulation for uint256;
248 
249   struct AttributeData {
250     uint256 value;
251   }
252 
253   // Stores arbitrary attributes for users. An example use case is an ERC20
254   // token that requires its users to go through a KYC/AML check - in this case
255   // a validator can set an account's "hasPassedKYC/AML" attribute to 1 to indicate
256   // that account can use the token. This mapping stores that value (1, in the
257   // example) as well as which validator last set the value and at what time,
258   // so that e.g. the check can be renewed at appropriate intervals.
259   mapping(address => AttributeData) private attributes;
260 
261   // The logic governing who is allowed to set what attributes is abstracted as
262   // this accessManager, so that it may be replaced by the owner as needed.
263   RegistryAccessManager public accessManager;
264 
265   event SetAttribute(
266     address indexed who,
267     Attribute.AttributeType attribute,
268     bool enable,
269     string notes,
270     address indexed adminAddr
271   );
272 
273   event SetManager(
274     address indexed oldManager,
275     address indexed newManager
276   );
277 
278   constructor() public {
279     accessManager = new DefaultRegistryAccessManager();
280   }
281 
282   // Writes are allowed only if the accessManager approves
283   function setAttribute(
284     address _who,
285     Attribute.AttributeType _attribute,
286     string _notes
287   )
288     public
289   {
290     bool _canWrite = accessManager.confirmWrite(
291       _who,
292       _attribute,
293       msg.sender
294     );
295     require(_canWrite);
296 
297     // Get value of previous attribute before setting new attribute
298     uint256 _tempVal = attributes[_who].value;
299 
300     attributes[_who] = AttributeData(
301       _tempVal.setBit(Attribute.toUint256(_attribute))
302     );
303 
304     emit SetAttribute(_who, _attribute, true, _notes, msg.sender);
305   }
306 
307   function clearAttribute(
308     address _who,
309     Attribute.AttributeType _attribute,
310     string _notes
311   )
312     public
313   {
314     bool _canWrite = accessManager.confirmWrite(
315       _who,
316       _attribute,
317       msg.sender
318     );
319     require(_canWrite);
320 
321     // Get value of previous attribute before setting new attribute
322     uint256 _tempVal = attributes[_who].value;
323 
324     attributes[_who] = AttributeData(
325       _tempVal.clearBit(Attribute.toUint256(_attribute))
326     );
327 
328     emit SetAttribute(_who, _attribute, false, _notes, msg.sender);
329   }
330 
331   // Returns true if the uint256 value stored for this attribute is non-zero
332   function hasAttribute(
333     address _who,
334     Attribute.AttributeType _attribute
335   )
336     public
337     view
338     returns (bool)
339   {
340     return attributes[_who].value.checkBit(Attribute.toUint256(_attribute));
341   }
342 
343   // Returns the exact value of the attribute, as well as its metadata
344   function getAttributes(
345     address _who
346   )
347     public
348     view
349     returns (uint256)
350   {
351     AttributeData memory _data = attributes[_who];
352     return _data.value;
353   }
354 
355   function setManager(RegistryAccessManager _accessManager) public onlyOwner {
356     emit SetManager(accessManager, _accessManager);
357     accessManager = _accessManager;
358   }
359 }
360 
361 
362 
363 
364 contract DefaultRegistryAccessManager is RegistryAccessManager {
365   function confirmWrite(
366     address /*_who*/,
367     Attribute.AttributeType _attribute,
368     address _operator
369   )
370     public
371     returns (bool)
372   {
373     Registry _client = Registry(msg.sender);
374     if (_operator == _client.owner()) {
375       return true;
376     } else if (_client.hasAttribute(_operator, Attribute.AttributeType.ROLE_MANAGER)) {
377       return (_attribute == Attribute.AttributeType.ROLE_OPERATOR);
378     } else if (_client.hasAttribute(_operator, Attribute.AttributeType.ROLE_OPERATOR)) {
379       return (_attribute != Attribute.AttributeType.ROLE_OPERATOR &&
380               _attribute != Attribute.AttributeType.ROLE_MANAGER);
381     }
382   }
383 }