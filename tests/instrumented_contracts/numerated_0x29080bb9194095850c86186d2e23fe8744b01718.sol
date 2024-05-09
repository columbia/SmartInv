1 pragma solidity 0.4.24;
2 
3 // File: erc-1155/contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         // uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return a / b;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49         c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 // File: erc-1155/contracts/Address.sol
56 
57 /**
58  * Utility library of inline functions on addresses
59  */
60 library Address {
61 
62     /**
63      * Returns whether the target address is a contract
64      * @dev This function will return false if invoked during the constructor of a contract,
65      * as the code is not actually created until after the constructor finishes.
66      * @param account address of the account to check
67      * @return whether the target address is a contract
68      */
69     function isContract(address account) internal view returns (bool) {
70         uint256 size;
71         // XXX Currently there is no better way to check if there is a contract in an address
72         // than to check the size of the code at that address.
73         // See https://ethereum.stackexchange.com/a/14016/36603
74         // for more details about how this works.
75         // TODO Check this again before the Serenity release, because all addresses will be
76         // contracts then.
77         // solium-disable-next-line security/no-inline-assembly
78         assembly { size := extcodesize(account) }
79         return size > 0;
80     }
81 
82 }
83 
84 // File: erc-1155/contracts/IERC1155.sol
85 
86 /// @dev Note: the ERC-165 identifier for this interface is 0xf23a6e61.
87 interface IERC1155TokenReceiver {
88     /// @notice Handle the receipt of an ERC1155 type
89     /// @dev The smart contract calls this function on the recipient
90     ///  after a `safeTransfer`. This function MAY throw to revert and reject the
91     ///  transfer. Return of other than the magic value MUST result in the
92     ///  transaction being reverted.
93     ///  Note: the contract address is always the message sender.
94     /// @param _operator The address which called `safeTransferFrom` function
95     /// @param _from The address which previously owned the token
96     /// @param _id The identifier of the item being transferred
97     /// @param _value The amount of the item being transferred
98     /// @param _data Additional data with no specified format
99     /// @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
100     ///  unless throwing
101     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes _data) external returns(bytes4);
102 }
103 
104 interface IERC1155 {
105     event Approval(address indexed _owner, address indexed _spender, uint256 indexed _id, uint256 _oldValue, uint256 _value);
106     event Transfer(address _spender, address indexed _from, address indexed _to, uint256 indexed _id, uint256 _value);
107 
108     function transferFrom(address _from, address _to, uint256 _id, uint256 _value) external;
109     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes _data) external;
110     function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) external;
111     function balanceOf(uint256 _id, address _owner) external view returns (uint256);
112     function allowance(uint256 _id, address _owner, address _spender) external view returns (uint256);
113 }
114 
115 interface IERC1155Extended {
116     function transfer(address _to, uint256 _id, uint256 _value) external;
117     function safeTransfer(address _to, uint256 _id, uint256 _value, bytes _data) external;
118 }
119 
120 interface IERC1155BatchTransfer {
121     function batchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values) external;
122     function safeBatchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values, bytes _data) external;
123     function batchApprove(address _spender, uint256[] _ids,  uint256[] _currentValues, uint256[] _values) external;
124 }
125 
126 interface IERC1155BatchTransferExtended {
127     function batchTransfer(address _to, uint256[] _ids, uint256[] _values) external;
128     function safeBatchTransfer(address _to, uint256[] _ids, uint256[] _values, bytes _data) external;
129 }
130 
131 interface IERC1155Operators {
132     event OperatorApproval(address indexed _owner, address indexed _operator, uint256 indexed _id, bool _approved);
133     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
134 
135     function setApproval(address _operator, uint256[] _ids, bool _approved) external;
136     function isApproved(address _owner, address _operator, uint256 _id)  external view returns (bool);
137     function setApprovalForAll(address _operator, bool _approved) external;
138     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
139 }
140 
141 interface IERC1155Views {
142     function totalSupply(uint256 _id) external view returns (uint256);
143     function name(uint256 _id) external view returns (string);
144     function symbol(uint256 _id) external view returns (string);
145     function decimals(uint256 _id) external view returns (uint8);
146     function uri(uint256 _id) external view returns (string);
147 }
148 
149 // File: erc-1155/contracts/ERC1155.sol
150 
151 contract ERC1155 is IERC1155, IERC1155Extended, IERC1155BatchTransfer, IERC1155BatchTransferExtended {
152     using SafeMath for uint256;
153     using Address for address;
154 
155     // Variables
156     struct Items {
157         string name;
158         uint256 totalSupply;
159         mapping (address => uint256) balances;
160     }
161     mapping (uint256 => uint8) public decimals;
162     mapping (uint256 => string) public symbols;
163     mapping (uint256 => mapping(address => mapping(address => uint256))) public allowances;
164     mapping (uint256 => Items) public items;
165     mapping (uint256 => string) public metadataURIs;
166 
167     bytes4 constant private ERC1155_RECEIVED = 0xf23a6e61;
168 
169 /////////////////////////////////////////// IERC1155 //////////////////////////////////////////////
170 
171     // Events
172     event Approval(address indexed _owner, address indexed _spender, uint256 indexed _id, uint256 _oldValue, uint256 _value);
173     event Transfer(address _spender, address indexed _from, address indexed _to, uint256 indexed _id, uint256 _value);
174 
175     function transferFrom(address _from, address _to, uint256 _id, uint256 _value) external {
176         if(_from != msg.sender) {
177             //require(allowances[_id][_from][msg.sender] >= _value);
178             allowances[_id][_from][msg.sender] = allowances[_id][_from][msg.sender].sub(_value);
179         }
180 
181         items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
182         items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
183 
184         emit Transfer(msg.sender, _from, _to, _id, _value);
185     }
186 
187     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes _data) external {
188         this.transferFrom(_from, _to, _id, _value);
189 
190         // solium-disable-next-line arg-overflow
191         require(_checkAndCallSafeTransfer(_from, _to, _id, _value, _data));
192     }
193 
194     function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) external {
195         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
196         require(_value == 0 || allowances[_id][msg.sender][_spender] == _currentValue);
197         allowances[_id][msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _id, _currentValue, _value);
199     }
200 
201     function balanceOf(uint256 _id, address _owner) external view returns (uint256) {
202         return items[_id].balances[_owner];
203     }
204 
205     function allowance(uint256 _id, address _owner, address _spender) external view returns (uint256) {
206         return allowances[_id][_owner][_spender];
207     }
208 
209 /////////////////////////////////////// IERC1155Extended //////////////////////////////////////////
210 
211     function transfer(address _to, uint256 _id, uint256 _value) external {
212         // Not needed. SafeMath will do the same check on .sub(_value)
213         //require(_value <= items[_id].balances[msg.sender]);
214         items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
215         items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
216         emit Transfer(msg.sender, msg.sender, _to, _id, _value);
217     }
218 
219     function safeTransfer(address _to, uint256 _id, uint256 _value, bytes _data) external {
220         this.transfer(_to, _id, _value);
221 
222         // solium-disable-next-line arg-overflow
223         require(_checkAndCallSafeTransfer(msg.sender, _to, _id, _value, _data));
224     }
225 
226 //////////////////////////////////// IERC1155BatchTransfer ////////////////////////////////////////
227 
228     function batchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values) external {
229         uint256 _id;
230         uint256 _value;
231 
232         if(_from == msg.sender) {
233             for (uint256 i = 0; i < _ids.length; ++i) {
234                 _id = _ids[i];
235                 _value = _values[i];
236 
237                 items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
238                 items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
239 
240                 emit Transfer(msg.sender, _from, _to, _id, _value);
241             }
242         }
243         else {
244             for (i = 0; i < _ids.length; ++i) {
245                 _id = _ids[i];
246                 _value = _values[i];
247 
248                 allowances[_id][_from][msg.sender] = allowances[_id][_from][msg.sender].sub(_value);
249 
250                 items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
251                 items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
252 
253                 emit Transfer(msg.sender, _from, _to, _id, _value);
254             }
255         }
256     }
257 
258     function safeBatchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values, bytes _data) external {
259         this.batchTransferFrom(_from, _to, _ids, _values);
260 
261         for (uint256 i = 0; i < _ids.length; ++i) {
262             // solium-disable-next-line arg-overflow
263             require(_checkAndCallSafeTransfer(_from, _to, _ids[i], _values[i], _data));
264         }
265     }
266 
267     function batchApprove(address _spender, uint256[] _ids,  uint256[] _currentValues, uint256[] _values) external {
268         uint256 _id;
269         uint256 _value;
270 
271         for (uint256 i = 0; i < _ids.length; ++i) {
272             _id = _ids[i];
273             _value = _values[i];
274 
275             require(_value == 0 || allowances[_id][msg.sender][_spender] == _currentValues[i]);
276             allowances[_id][msg.sender][_spender] = _value;
277             emit Approval(msg.sender, _spender, _id, _currentValues[i], _value);
278         }
279     }
280 
281 //////////////////////////////// IERC1155BatchTransferExtended ////////////////////////////////////
282 
283     function batchTransfer(address _to, uint256[] _ids, uint256[] _values) external {
284         uint256 _id;
285         uint256 _value;
286 
287         for (uint256 i = 0; i < _ids.length; ++i) {
288             _id = _ids[i];
289             _value = _values[i];
290 
291             items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
292             items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
293 
294             emit Transfer(msg.sender, msg.sender, _to, _id, _value);
295         }
296     }
297 
298     function safeBatchTransfer(address _to, uint256[] _ids, uint256[] _values, bytes _data) external {
299         this.batchTransfer(_to, _ids, _values);
300 
301         for (uint256 i = 0; i < _ids.length; ++i) {
302             // solium-disable-next-line arg-overflow
303             require(_checkAndCallSafeTransfer(msg.sender, _to, _ids[i], _values[i], _data));
304         }
305     }
306 
307 //////////////////////////////// IERC1155BatchTransferExtended ////////////////////////////////////
308 
309     // Optional meta data view Functions
310     // consider multi-lingual support for name?
311     function name(uint256 _id) external view returns (string) {
312         return items[_id].name;
313     }
314 
315     function symbol(uint256 _id) external view returns (string) {
316         return symbols[_id];
317     }
318 
319     function decimals(uint256 _id) external view returns (uint8) {
320         return decimals[_id];
321     }
322 
323     function totalSupply(uint256 _id) external view returns (uint256) {
324         return items[_id].totalSupply;
325     }
326 
327     function uri(uint256 _id) external view returns (string) {
328         return metadataURIs[_id];
329     }
330 
331 ////////////////////////////////////////// OPTIONALS //////////////////////////////////////////////
332 
333 
334     function multicastTransfer(address[] _to, uint256[] _ids, uint256[] _values) external {
335         for (uint256 i = 0; i < _to.length; ++i) {
336             uint256 _id = _ids[i];
337             uint256 _value = _values[i];
338             address _dst = _to[i];
339 
340             items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
341             items[_id].balances[_dst] = _value.add(items[_id].balances[_dst]);
342 
343             emit Transfer(msg.sender, msg.sender, _dst, _id, _value);
344         }
345     }
346 
347     function safeMulticastTransfer(address[] _to, uint256[] _ids, uint256[] _values, bytes _data) external {
348         this.multicastTransfer(_to, _ids, _values);
349 
350         for (uint256 i = 0; i < _ids.length; ++i) {
351             // solium-disable-next-line arg-overflow
352             require(_checkAndCallSafeTransfer(msg.sender, _to[i], _ids[i], _values[i], _data));
353         }
354     }
355 
356 ////////////////////////////////////////// INTERNAL //////////////////////////////////////////////
357 
358     function _checkAndCallSafeTransfer(
359         address _from,
360         address _to,
361         uint256 _id,
362         uint256 _value,
363         bytes _data
364     )
365     internal
366     returns (bool)
367     {
368         if (!_to.isContract()) {
369             return true;
370         }
371         bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(
372             msg.sender, _from, _id, _value, _data);
373         return (retval == ERC1155_RECEIVED);
374     }
375 }
376 
377 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
378 
379 /**
380  * @title Ownable
381  * @dev The Ownable contract has an owner address, and provides basic authorization control
382  * functions, this simplifies the implementation of "user permissions".
383  */
384 contract Ownable {
385   address private _owner;
386 
387 
388   event OwnershipRenounced(address indexed previousOwner);
389   event OwnershipTransferred(
390     address indexed previousOwner,
391     address indexed newOwner
392   );
393 
394 
395   /**
396    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
397    * account.
398    */
399   constructor() public {
400     _owner = msg.sender;
401   }
402 
403   /**
404    * @return the address of the owner.
405    */
406   function owner() public view returns(address) {
407     return _owner;
408   }
409 
410   /**
411    * @dev Throws if called by any account other than the owner.
412    */
413   modifier onlyOwner() {
414     require(isOwner());
415     _;
416   }
417 
418   /**
419    * @return true if `msg.sender` is the owner of the contract.
420    */
421   function isOwner() public view returns(bool) {
422     return msg.sender == _owner;
423   }
424 
425   /**
426    * @dev Allows the current owner to relinquish control of the contract.
427    * @notice Renouncing to ownership will leave the contract without an owner.
428    * It will not be possible to call the functions with the `onlyOwner`
429    * modifier anymore.
430    */
431   function renounceOwnership() public onlyOwner {
432     emit OwnershipRenounced(_owner);
433     _owner = address(0);
434   }
435 
436   /**
437    * @dev Allows the current owner to transfer control of the contract to a newOwner.
438    * @param newOwner The address to transfer ownership to.
439    */
440   function transferOwnership(address newOwner) public onlyOwner {
441     _transferOwnership(newOwner);
442   }
443 
444   /**
445    * @dev Transfers control of the contract to a newOwner.
446    * @param newOwner The address to transfer ownership to.
447    */
448   function _transferOwnership(address newOwner) internal {
449     require(newOwner != address(0));
450     emit OwnershipTransferred(_owner, newOwner);
451     _owner = newOwner;
452   }
453 }
454 
455 // File: contracts/Costume.sol
456 
457 contract Costume is ERC1155, Ownable {
458     uint private nonce;
459 
460     function mint(string name, uint totalSupply) external onlyOwner returns (uint id) {
461         id = ++nonce;
462 
463         items[id].name = name;
464         items[id].totalSupply = totalSupply;
465         metadataURIs[id] = "";
466         decimals[id] = 0;
467         symbols[id] = "COS";
468 
469         items[id].balances[msg.sender] = totalSupply;
470     }
471 }