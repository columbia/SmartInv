1 pragma solidity 0.4.24;
2 
3 
4 /**
5 
6 COPYRIGHT 2018 Token, Inc.
7 
8 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
9 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
10 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
11 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
12 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
13 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
14 
15 
16 @title Ownable
17 @dev The Ownable contract has an owner address, and provides basic authorization control
18 functions, this simplifies the implementation of "user permissions".
19 
20 
21  */
22 contract Ownable {
23 
24   mapping(address => bool) public owner;
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27   event AllowOwnership(address indexed allowedAddress);
28   event RevokeOwnership(address indexed allowedAddress);
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   constructor() public {
35     owner[msg.sender] = true;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(owner[msg.sender], "Error: Transaction sender is not allowed by the contract.");
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    * @return {"success" : "Returns true when successfully transferred ownership"}
50    */
51   function transferOwnership(address newOwner) public onlyOwner returns (bool success) {
52     require(newOwner != address(0), "Error: newOwner cannot be null!");
53     emit OwnershipTransferred(msg.sender, newOwner);
54     owner[newOwner] = true;
55     owner[msg.sender] = false;
56     return true;
57   }
58 
59   /**
60    * @dev Allows interface contracts and accounts to access contract methods (e.g. Storage contract)
61    * @param allowedAddress The address of new owner
62    * @return {"success" : "Returns true when successfully allowed ownership"}
63    */
64   function allowOwnership(address allowedAddress) public onlyOwner returns (bool success) {
65     owner[allowedAddress] = true;
66     emit AllowOwnership(allowedAddress);
67     return true;
68   }
69 
70   /**
71    * @dev Disallows interface contracts and accounts to access contract methods (e.g. Storage contract)
72    * @param allowedAddress The address to disallow ownership
73    * @return {"success" : "Returns true when successfully allowed ownership"}
74    */
75   function removeOwnership(address allowedAddress) public onlyOwner returns (bool success) {
76     owner[allowedAddress] = false;
77     emit RevokeOwnership(allowedAddress);
78     return true;
79   }
80 
81 }
82 
83 
84 /**
85 
86 COPYRIGHT 2018 Token, Inc.
87 
88 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
89 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
90 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
91 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
92 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
93 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
94 
95 
96 @title TokenIOStorage - Serves as derived contract for TokenIO contract and
97 is used to upgrade interfaces in the event of deprecating the main contract.
98 
99 @author Ryan Tate <ryan.tate@token.io>, Sean Pollock <sean.pollock@token.io>
100 
101 @notice Storage contract
102 
103 @dev In the event that the main contract becomes deprecated, the upgraded contract
104 will be set as the owner of this contract, and use this contract's storage to
105 maintain data consistency between contract.
106 
107 @notice NOTE: This contract is based on the RocketPool Storage Contract,
108 found here: https://github.com/rocket-pool/rocketpool/blob/master/contracts/RocketStorage.sol
109 And this medium article: https://medium.com/rocket-pool/upgradable-solidity-contract-design-54789205276d
110 
111 Changes:
112  - setting primitive mapping view to internal;
113  - setting method views to public;
114 
115  @dev NOTE: When deprecating the main TokenIO contract, the upgraded contract
116  must take ownership of the TokenIO contract, it will require using the public methods
117  to update changes to the underlying data. The updated contract must use a
118  standard call to original TokenIO contract such that the  request is made from
119  the upgraded contract and not the transaction origin (tx.origin) of the signing
120  account.
121 
122 
123  @dev NOTE: The reasoning for using the storage contract is to abstract the interface
124  from the data of the contract on chain, limiting the need to migrate data to
125  new contracts.
126 
127 */
128 contract TokenIOStorage is Ownable {
129 
130 
131     /// @dev mapping for Primitive Data Types;
132 		/// @notice primitive data mappings have `internal` view;
133 		/// @dev only the derived contract can use the internal methods;
134 		/// @dev key == `keccak256(param1, param2...)`
135 		/// @dev Nested mapping can be achieved using multiple params in keccak256 hash;
136     mapping(bytes32 => uint256)    internal uIntStorage;
137     mapping(bytes32 => string)     internal stringStorage;
138     mapping(bytes32 => address)    internal addressStorage;
139     mapping(bytes32 => bytes)      internal bytesStorage;
140     mapping(bytes32 => bool)       internal boolStorage;
141     mapping(bytes32 => int256)     internal intStorage;
142 
143     constructor() public {
144 				/// @notice owner is set to msg.sender by default
145 				/// @dev consider removing in favor of setting ownership in inherited
146 				/// contract
147         owner[msg.sender] = true;
148     }
149 
150     /// @dev Set Key Methods
151 
152     /**
153      * @notice Set value for Address associated with bytes32 id key
154      * @param _key Pointer identifier for value in storage
155      * @param _value The Address value to be set
156      * @return { "success" : "Returns true when successfully called from another contract" }
157      */
158     function setAddress(bytes32 _key, address _value) public onlyOwner returns (bool success) {
159         addressStorage[_key] = _value;
160         return true;
161     }
162 
163     /**
164      * @notice Set value for Uint associated with bytes32 id key
165      * @param _key Pointer identifier for value in storage
166      * @param _value The Uint value to be set
167      * @return { "success" : "Returns true when successfully called from another contract" }
168      */
169     function setUint(bytes32 _key, uint _value) public onlyOwner returns (bool success) {
170         uIntStorage[_key] = _value;
171         return true;
172     }
173 
174     /**
175      * @notice Set value for String associated with bytes32 id key
176      * @param _key Pointer identifier for value in storage
177      * @param _value The String value to be set
178      * @return { "success" : "Returns true when successfully called from another contract" }
179      */
180     function setString(bytes32 _key, string _value) public onlyOwner returns (bool success) {
181         stringStorage[_key] = _value;
182         return true;
183     }
184 
185     /**
186      * @notice Set value for Bytes associated with bytes32 id key
187      * @param _key Pointer identifier for value in storage
188      * @param _value The Bytes value to be set
189      * @return { "success" : "Returns true when successfully called from another contract" }
190      */
191     function setBytes(bytes32 _key, bytes _value) public onlyOwner returns (bool success) {
192         bytesStorage[_key] = _value;
193         return true;
194     }
195 
196     /**
197      * @notice Set value for Bool associated with bytes32 id key
198      * @param _key Pointer identifier for value in storage
199      * @param _value The Bool value to be set
200      * @return { "success" : "Returns true when successfully called from another contract" }
201      */
202     function setBool(bytes32 _key, bool _value) public onlyOwner returns (bool success) {
203         boolStorage[_key] = _value;
204         return true;
205     }
206 
207     /**
208      * @notice Set value for Int associated with bytes32 id key
209      * @param _key Pointer identifier for value in storage
210      * @param _value The Int value to be set
211      * @return { "success" : "Returns true when successfully called from another contract" }
212      */
213     function setInt(bytes32 _key, int _value) public onlyOwner returns (bool success) {
214         intStorage[_key] = _value;
215         return true;
216     }
217 
218     /// @dev Delete Key Methods
219 		/// @dev delete methods may be unnecessary; Use set methods to set values
220 		/// to default?
221 
222     /**
223      * @notice Delete value for Address associated with bytes32 id key
224      * @param _key Pointer identifier for value in storage
225      * @return { "success" : "Returns true when successfully called from another contract" }
226      */
227     function deleteAddress(bytes32 _key) public onlyOwner returns (bool success) {
228         delete addressStorage[_key];
229         return true;
230     }
231 
232     /**
233      * @notice Delete value for Uint associated with bytes32 id key
234      * @param _key Pointer identifier for value in storage
235      * @return { "success" : "Returns true when successfully called from another contract" }
236      */
237     function deleteUint(bytes32 _key) public onlyOwner returns (bool success) {
238         delete uIntStorage[_key];
239         return true;
240     }
241 
242     /**
243      * @notice Delete value for String associated with bytes32 id key
244      * @param _key Pointer identifier for value in storage
245      * @return { "success" : "Returns true when successfully called from another contract" }
246      */
247     function deleteString(bytes32 _key) public onlyOwner returns (bool success) {
248         delete stringStorage[_key];
249         return true;
250     }
251 
252     /**
253      * @notice Delete value for Bytes associated with bytes32 id key
254      * @param _key Pointer identifier for value in storage
255      * @return { "success" : "Returns true when successfully called from another contract" }
256      */
257     function deleteBytes(bytes32 _key) public onlyOwner returns (bool success) {
258         delete bytesStorage[_key];
259         return true;
260     }
261 
262     /**
263      * @notice Delete value for Bool associated with bytes32 id key
264      * @param _key Pointer identifier for value in storage
265      * @return { "success" : "Returns true when successfully called from another contract" }
266      */
267     function deleteBool(bytes32 _key) public onlyOwner returns (bool success) {
268         delete boolStorage[_key];
269         return true;
270     }
271 
272     /**
273      * @notice Delete value for Int associated with bytes32 id key
274      * @param _key Pointer identifier for value in storage
275      * @return { "success" : "Returns true when successfully called from another contract" }
276      */
277     function deleteInt(bytes32 _key) public onlyOwner returns (bool success) {
278         delete intStorage[_key];
279         return true;
280     }
281 
282     /// @dev Get Key Methods
283 
284     /**
285      * @notice Get value for Address associated with bytes32 id key
286      * @param _key Pointer identifier for value in storage
287      * @return { "_value" : "Returns the Address value associated with the id key" }
288      */
289     function getAddress(bytes32 _key) public view returns (address _value) {
290         return addressStorage[_key];
291     }
292 
293     /**
294      * @notice Get value for Uint associated with bytes32 id key
295      * @param _key Pointer identifier for value in storage
296      * @return { "_value" : "Returns the Uint value associated with the id key" }
297      */
298     function getUint(bytes32 _key) public view returns (uint _value) {
299         return uIntStorage[_key];
300     }
301 
302     /**
303      * @notice Get value for String associated with bytes32 id key
304      * @param _key Pointer identifier for value in storage
305      * @return { "_value" : "Returns the String value associated with the id key" }
306      */
307     function getString(bytes32 _key) public view returns (string _value) {
308         return stringStorage[_key];
309     }
310 
311     /**
312      * @notice Get value for Bytes associated with bytes32 id key
313      * @param _key Pointer identifier for value in storage
314      * @return { "_value" : "Returns the Bytes value associated with the id key" }
315      */
316     function getBytes(bytes32 _key) public view returns (bytes _value) {
317         return bytesStorage[_key];
318     }
319 
320     /**
321      * @notice Get value for Bool associated with bytes32 id key
322      * @param _key Pointer identifier for value in storage
323      * @return { "_value" : "Returns the Bool value associated with the id key" }
324      */
325     function getBool(bytes32 _key) public view returns (bool _value) {
326         return boolStorage[_key];
327     }
328 
329     /**
330      * @notice Get value for Int associated with bytes32 id key
331      * @param _key Pointer identifier for value in storage
332      * @return { "_value" : "Returns the Int value associated with the id key" }
333      */
334     function getInt(bytes32 _key) public view returns (int _value) {
335         return intStorage[_key];
336     }
337 
338 }