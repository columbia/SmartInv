1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 /**
55  * Utility library of inline functions on addresses
56  */
57 library Address {
58 
59     /**
60      * Returns whether the target address is a contract
61      * @dev This function will return false if invoked during the constructor of a contract,
62      * as the code is not actually created until after the constructor finishes.
63      * @param account address of the account to check
64      * @return whether the target address is a contract
65      */
66     function isContract(address account) internal view returns (bool) {
67         uint256 size;
68         // XXX Currently there is no better way to check if there is a contract in an address
69         // than to check the size of the code at that address.
70         // See https://ethereum.stackexchange.com/a/14016/36603
71         // for more details about how this works.
72         // TODO Check this again before the Serenity release, because all addresses will be
73         // contracts then.
74         // solium-disable-next-line security/no-inline-assembly
75         assembly { size := extcodesize(account) }
76         return size > 0;
77     }
78 
79 }
80 
81 /// @dev Note: the ERC-165 identifier for this interface is 0xf23a6e61.
82 interface IERC1155TokenReceiver {
83     /// @notice Handle the receipt of an ERC1155 type
84     /// @dev The smart contract calls this function on the recipient
85     ///  after a `safeTransfer`. This function MAY throw to revert and reject the
86     ///  transfer. Return of other than the magic value MUST result in the
87     ///  transaction being reverted.
88     ///  Note: the contract address is always the message sender.
89     /// @param _operator The address which called `safeTransferFrom` function
90     /// @param _from The address which previously owned the token
91     /// @param _id The identifier of the item being transferred
92     /// @param _value The amount of the item being transferred
93     /// @param _data Additional data with no specified format
94     /// @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
95     ///  unless throwing
96     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes _data) external returns(bytes4);
97 }
98 
99 interface IERC1155 {
100     event Approval(address indexed _owner, address indexed _spender, uint256 indexed _id, uint256 _oldValue, uint256 _value);
101     event Transfer(address _spender, address indexed _from, address indexed _to, uint256 indexed _id, uint256 _value);
102 
103     function transferFrom(address _from, address _to, uint256 _id, uint256 _value) external;
104     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes _data) external;
105     function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) external;
106     function balanceOf(uint256 _id, address _owner) external view returns (uint256);
107     function allowance(uint256 _id, address _owner, address _spender) external view returns (uint256);
108 }
109 
110 interface IERC1155Extended {
111     function transfer(address _to, uint256 _id, uint256 _value) external;
112     function safeTransfer(address _to, uint256 _id, uint256 _value, bytes _data) external;
113 }
114 
115 interface IERC1155BatchTransfer {
116     function batchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values) external;
117     function safeBatchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values, bytes _data) external;
118     function batchApprove(address _spender, uint256[] _ids,  uint256[] _currentValues, uint256[] _values) external;
119 }
120 
121 interface IERC1155BatchTransferExtended {
122     function batchTransfer(address _to, uint256[] _ids, uint256[] _values) external;
123     function safeBatchTransfer(address _to, uint256[] _ids, uint256[] _values, bytes _data) external;
124 }
125 
126 interface IERC1155Operators {
127     event OperatorApproval(address indexed _owner, address indexed _operator, uint256 indexed _id, bool _approved);
128     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
129 
130     function setApproval(address _operator, uint256[] _ids, bool _approved) external;
131     function isApproved(address _owner, address _operator, uint256 _id)  external view returns (bool);
132     function setApprovalForAll(address _operator, bool _approved) external;
133     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
134 }
135 
136 interface IERC1155Views {
137     function totalSupply(uint256 _id) external view returns (uint256);
138     function name(uint256 _id) external view returns (string);
139     function symbol(uint256 _id) external view returns (string);
140     function decimals(uint256 _id) external view returns (uint8);
141     function uri(uint256 _id) external view returns (string);
142 }
143 
144 contract ERC1155 is IERC1155, IERC1155Extended, IERC1155BatchTransfer, IERC1155BatchTransferExtended {
145     using SafeMath for uint256;
146     using Address for address;
147 
148     // Variables
149     struct Items {
150         string name;
151         uint256 totalSupply;
152         mapping (address => uint256) balances;
153     }
154     mapping (uint256 => uint8) public decimals;
155     mapping (uint256 => string) public symbols;
156     mapping (uint256 => mapping(address => mapping(address => uint256))) public allowances;
157     mapping (uint256 => Items) public items;
158     mapping (uint256 => string) public metadataURIs;
159 
160     bytes4 constant private ERC1155_RECEIVED = 0xf23a6e61;
161 
162 /////////////////////////////////////////// IERC1155 //////////////////////////////////////////////
163 
164     // Events
165     event Approval(address indexed _owner, address indexed _spender, uint256 indexed _id, uint256 _oldValue, uint256 _value);
166     event Transfer(address _spender, address indexed _from, address indexed _to, uint256 indexed _id, uint256 _value);
167 
168     function transferFrom(address _from, address _to, uint256 _id, uint256 _value) external {
169         if(_from != msg.sender) {
170             //require(allowances[_id][_from][msg.sender] >= _value);
171             allowances[_id][_from][msg.sender] = allowances[_id][_from][msg.sender].sub(_value);
172         }
173 
174         items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
175         items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
176 
177         emit Transfer(msg.sender, _from, _to, _id, _value);
178     }
179 
180     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes _data) external {
181         this.transferFrom(_from, _to, _id, _value);
182 
183         // solium-disable-next-line arg-overflow
184         require(_checkAndCallSafeTransfer(_from, _to, _id, _value, _data));
185     }
186 
187     function approve(address _spender, uint256 _id, uint256 _currentValue, uint256 _value) external {
188         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
189         require(_value == 0 || allowances[_id][msg.sender][_spender] == _currentValue);
190         allowances[_id][msg.sender][_spender] = _value;
191         emit Approval(msg.sender, _spender, _id, _currentValue, _value);
192     }
193 
194     function balanceOf(uint256 _id, address _owner) external view returns (uint256) {
195         return items[_id].balances[_owner];
196     }
197 
198     function allowance(uint256 _id, address _owner, address _spender) external view returns (uint256) {
199         return allowances[_id][_owner][_spender];
200     }
201 
202 /////////////////////////////////////// IERC1155Extended //////////////////////////////////////////
203 
204     function transfer(address _to, uint256 _id, uint256 _value) external {
205         // Not needed. SafeMath will do the same check on .sub(_value)
206         //require(_value <= items[_id].balances[msg.sender]);
207         items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
208         items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
209         emit Transfer(msg.sender, msg.sender, _to, _id, _value);
210     }
211 
212     function safeTransfer(address _to, uint256 _id, uint256 _value, bytes _data) external {
213         this.transfer(_to, _id, _value);
214 
215         // solium-disable-next-line arg-overflow
216         require(_checkAndCallSafeTransfer(msg.sender, _to, _id, _value, _data));
217     }
218 
219 //////////////////////////////////// IERC1155BatchTransfer ////////////////////////////////////////
220 
221     function batchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values) external {
222         uint256 _id;
223         uint256 _value;
224 
225         if(_from == msg.sender) {
226             for (uint256 i = 0; i < _ids.length; ++i) {
227                 _id = _ids[i];
228                 _value = _values[i];
229 
230                 items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
231                 items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
232 
233                 emit Transfer(msg.sender, _from, _to, _id, _value);
234             }
235         }
236         else {
237             for (i = 0; i < _ids.length; ++i) {
238                 _id = _ids[i];
239                 _value = _values[i];
240 
241                 allowances[_id][_from][msg.sender] = allowances[_id][_from][msg.sender].sub(_value);
242 
243                 items[_id].balances[_from] = items[_id].balances[_from].sub(_value);
244                 items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
245 
246                 emit Transfer(msg.sender, _from, _to, _id, _value);
247             }
248         }
249     }
250 
251     function safeBatchTransferFrom(address _from, address _to, uint256[] _ids, uint256[] _values, bytes _data) external {
252         this.batchTransferFrom(_from, _to, _ids, _values);
253 
254         for (uint256 i = 0; i < _ids.length; ++i) {
255             // solium-disable-next-line arg-overflow
256             require(_checkAndCallSafeTransfer(_from, _to, _ids[i], _values[i], _data));
257         }
258     }
259 
260     function batchApprove(address _spender, uint256[] _ids,  uint256[] _currentValues, uint256[] _values) external {
261         uint256 _id;
262         uint256 _value;
263 
264         for (uint256 i = 0; i < _ids.length; ++i) {
265             _id = _ids[i];
266             _value = _values[i];
267 
268             require(_value == 0 || allowances[_id][msg.sender][_spender] == _currentValues[i]);
269             allowances[_id][msg.sender][_spender] = _value;
270             emit Approval(msg.sender, _spender, _id, _currentValues[i], _value);
271         }
272     }
273 
274 //////////////////////////////// IERC1155BatchTransferExtended ////////////////////////////////////
275 
276     function batchTransfer(address _to, uint256[] _ids, uint256[] _values) external {
277         uint256 _id;
278         uint256 _value;
279 
280         for (uint256 i = 0; i < _ids.length; ++i) {
281             _id = _ids[i];
282             _value = _values[i];
283 
284             items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
285             items[_id].balances[_to] = _value.add(items[_id].balances[_to]);
286 
287             emit Transfer(msg.sender, msg.sender, _to, _id, _value);
288         }
289     }
290 
291     function safeBatchTransfer(address _to, uint256[] _ids, uint256[] _values, bytes _data) external {
292         this.batchTransfer(_to, _ids, _values);
293 
294         for (uint256 i = 0; i < _ids.length; ++i) {
295             // solium-disable-next-line arg-overflow
296             require(_checkAndCallSafeTransfer(msg.sender, _to, _ids[i], _values[i], _data));
297         }
298     }
299 
300 //////////////////////////////// IERC1155BatchTransferExtended ////////////////////////////////////
301 
302     // Optional meta data view Functions
303     // consider multi-lingual support for name?
304     function name(uint256 _id) external view returns (string) {
305         return items[_id].name;
306     }
307 
308     function symbol(uint256 _id) external view returns (string) {
309         return symbols[_id];
310     }
311 
312     function decimals(uint256 _id) external view returns (uint8) {
313         return decimals[_id];
314     }
315 
316     function totalSupply(uint256 _id) external view returns (uint256) {
317         return items[_id].totalSupply;
318     }
319 
320     function uri(uint256 _id) external view returns (string) {
321         return metadataURIs[_id];
322     }
323 
324 ////////////////////////////////////////// OPTIONALS //////////////////////////////////////////////
325 
326 
327     function multicastTransfer(address[] _to, uint256[] _ids, uint256[] _values) external {
328         for (uint256 i = 0; i < _to.length; ++i) {
329             uint256 _id = _ids[i];
330             uint256 _value = _values[i];
331             address _dst = _to[i];
332 
333             items[_id].balances[msg.sender] = items[_id].balances[msg.sender].sub(_value);
334             items[_id].balances[_dst] = _value.add(items[_id].balances[_dst]);
335 
336             emit Transfer(msg.sender, msg.sender, _dst, _id, _value);
337         }
338     }
339 
340     function safeMulticastTransfer(address[] _to, uint256[] _ids, uint256[] _values, bytes _data) external {
341         this.multicastTransfer(_to, _ids, _values);
342 
343         for (uint256 i = 0; i < _ids.length; ++i) {
344             // solium-disable-next-line arg-overflow
345             require(_checkAndCallSafeTransfer(msg.sender, _to[i], _ids[i], _values[i], _data));
346         }
347     }
348 
349 ////////////////////////////////////////// INTERNAL //////////////////////////////////////////////
350 
351     function _checkAndCallSafeTransfer(
352         address _from,
353         address _to,
354         uint256 _id,
355         uint256 _value,
356         bytes _data
357     )
358     internal
359     returns (bool)
360     {
361         if (!_to.isContract()) {
362             return true;
363         }
364         bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(
365             msg.sender, _from, _id, _value, _data);
366         return (retval == ERC1155_RECEIVED);
367     }
368 }
369 
370 /**
371     @dev Mintable form of ERC1155
372     Shows how easy it is to mint new items
373 */
374 contract ERC1155V3 is ERC1155 {
375     mapping (uint256 => address) public minters;
376     uint256 public nonce;
377 
378     modifier minterOnly(uint256 _id) {
379         require(minters[_id] == msg.sender);
380         _;
381     }
382 
383     function mint(string _name, uint256 _totalSupply, string _uri, uint8 _decimals, string _symbol)
384     external returns(uint256 _id) {
385         _id = ++nonce;
386         minters[_id] = msg.sender; //
387 
388         items[_id].name = _name;
389         items[_id].totalSupply = _totalSupply;
390         metadataURIs[_id] = _uri;
391         decimals[_id] = _decimals;
392         symbols[_id] = _symbol;
393 
394         // Grant the items to the minter
395         items[_id].balances[msg.sender] = _totalSupply;
396     }
397 
398     function setURI(uint256 _id, string _uri) external minterOnly(_id) {
399         metadataURIs[_id] = _uri;
400     }
401 }