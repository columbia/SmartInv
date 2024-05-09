1 pragma solidity 0.5.3;
2 
3 
4 
5 
6 
7 
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor () internal {
24         _owner = msg.sender;
25         emit OwnershipTransferred(address(0), _owner);
26     }
27 
28     /**
29      * @return the address of the owner.
30      */
31     function owner() public view returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(isOwner());
40         _;
41     }
42 
43     /**
44      * @return true if `msg.sender` is the owner of the contract.
45      */
46     function isOwner() public view returns (bool) {
47         return msg.sender == _owner;
48     }
49 
50     /**
51      * @dev Allows the current owner to relinquish control of the contract.
52      * It will not be possible to call the functions with the `onlyOwner`
53      * modifier anymore.
54      * @notice Renouncing ownership will leave the contract without an owner,
55      * thereby removing any functionality that is only available to the owner.
56      */
57     function renounceOwnership() public onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) public onlyOwner {
67         _transferOwnership(newOwner);
68     }
69 
70     /**
71      * @dev Transfers control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function _transferOwnership(address newOwner) internal {
75         require(newOwner != address(0));
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 
82 /**
83  * @title Secondary
84  * @dev A Secondary contract can only be used by its primary account (the one that created it)
85  */
86 contract OwnableSecondary is Ownable {
87   address private _primary;
88 
89   event PrimaryTransferred(
90     address recipient
91   );
92 
93   /**
94    * @dev Sets the primary account to the one that is creating the Secondary contract.
95    */
96   constructor() internal {
97     _primary = msg.sender;
98     emit PrimaryTransferred(_primary);
99   }
100 
101   /**
102    * @dev Reverts if called from any account other than the primary or the owner.
103    */
104    modifier onlyPrimaryOrOwner() {
105      require(msg.sender == _primary || msg.sender == owner(), "not the primary user nor the owner");
106      _;
107    }
108 
109    /**
110     * @dev Reverts if called from any account other than the primary.
111     */
112   modifier onlyPrimary() {
113     require(msg.sender == _primary, "not the primary user");
114     _;
115   }
116 
117   /**
118    * @return the address of the primary.
119    */
120   function primary() public view returns (address) {
121     return _primary;
122   }
123 
124   /**
125    * @dev Transfers contract to a new primary.
126    * @param recipient The address of new primary.
127    */
128   function transferPrimary(address recipient) public onlyOwner {
129     require(recipient != address(0), "new primary address is null");
130     _primary = recipient;
131     emit PrimaryTransferred(_primary);
132   }
133 }
134 
135 
136 contract ImmutableEternalStorageInterface is OwnableSecondary {
137   /********************/
138   /** PUBLIC - WRITE **/
139   /********************/
140   function createUint(bytes32 key, uint value) external;
141 
142   function createString(bytes32 key, string calldata value) external;
143 
144   function createAddress(bytes32 key, address value) external;
145 
146   function createBytes(bytes32 key, bytes calldata value) external;
147 
148   function createBytes32(bytes32 key, bytes32 value) external;
149 
150   function createBool(bytes32 key, bool value) external;
151 
152   function createInt(bytes32 key, int value) external;
153 
154   /*******************/
155   /** PUBLIC - READ **/
156   /*******************/
157   function getUint(bytes32 key) external view returns(uint);
158 
159   function uintExists(bytes32 key) external view returns(bool);
160 
161   function getString(bytes32 key) external view returns(string memory);
162 
163   function stringExists(bytes32 key) external view returns(bool);
164 
165   function getAddress(bytes32 key) external view returns(address);
166 
167   function addressExists(bytes32 key) external view returns(bool);
168 
169   function getBytes(bytes32 key) external view returns(bytes memory);
170 
171   function bytesExists(bytes32 key) external view returns(bool);
172 
173   function getBytes32(bytes32 key) external view returns(bytes32);
174 
175   function bytes32Exists(bytes32 key) external view returns(bool);
176 
177   function getBool(bytes32 key) external view returns(bool);
178 
179   function boolExists(bytes32 key) external view returns(bool);
180 
181   function getInt(bytes32 key) external view returns(int);
182 
183   function intExists(bytes32 key) external view returns(bool);
184 }
185 
186 
187 contract ImmutableEternalStorage is ImmutableEternalStorageInterface {
188     struct UintEntity {
189       uint value;
190       bool isEntity;
191     }
192     struct StringEntity {
193       string value;
194       bool isEntity;
195     }
196     struct AddressEntity {
197       address value;
198       bool isEntity;
199     }
200     struct BytesEntity {
201       bytes value;
202       bool isEntity;
203     }
204     struct Bytes32Entity {
205       bytes32 value;
206       bool isEntity;
207     }
208     struct BoolEntity {
209       bool value;
210       bool isEntity;
211     }
212     struct IntEntity {
213       int value;
214       bool isEntity;
215     }
216     mapping(bytes32 => UintEntity) private uIntStorage;
217     mapping(bytes32 => StringEntity) private stringStorage;
218     mapping(bytes32 => AddressEntity) private addressStorage;
219     mapping(bytes32 => BytesEntity) private bytesStorage;
220     mapping(bytes32 => Bytes32Entity) private bytes32Storage;
221     mapping(bytes32 => BoolEntity) private boolStorage;
222     mapping(bytes32 => IntEntity) private intStorage;
223 
224     /********************/
225     /** PUBLIC - WRITE **/
226     /********************/
227     function createUint(bytes32 key, uint value) onlyPrimaryOrOwner external {
228         require(!uIntStorage[key].isEntity);
229 
230         uIntStorage[key].value = value;
231         uIntStorage[key].isEntity = true;
232     }
233 
234     function createString(bytes32 key, string calldata value) onlyPrimaryOrOwner external {
235         require(!stringStorage[key].isEntity);
236 
237         stringStorage[key].value = value;
238         stringStorage[key].isEntity = true;
239     }
240 
241     function createAddress(bytes32 key, address value) onlyPrimaryOrOwner external {
242         require(!addressStorage[key].isEntity);
243 
244         addressStorage[key].value = value;
245         addressStorage[key].isEntity = true;
246     }
247 
248     function createBytes(bytes32 key, bytes calldata value) onlyPrimaryOrOwner external {
249         require(!bytesStorage[key].isEntity);
250 
251         bytesStorage[key].value = value;
252         bytesStorage[key].isEntity = true;
253     }
254 
255     function createBytes32(bytes32 key, bytes32 value) onlyPrimaryOrOwner external {
256         require(!bytes32Storage[key].isEntity);
257 
258         bytes32Storage[key].value = value;
259         bytes32Storage[key].isEntity = true;
260     }
261 
262     function createBool(bytes32 key, bool value) onlyPrimaryOrOwner external {
263         require(!boolStorage[key].isEntity);
264 
265         boolStorage[key].value = value;
266         boolStorage[key].isEntity = true;
267     }
268 
269     function createInt(bytes32 key, int value) onlyPrimaryOrOwner external {
270         require(!intStorage[key].isEntity);
271 
272         intStorage[key].value = value;
273         intStorage[key].isEntity = true;
274     }
275 
276     /*******************/
277     /** PUBLIC - READ **/
278     /*******************/
279     function getUint(bytes32 key) external view returns(uint) {
280         return uIntStorage[key].value;
281     }
282 
283     function uintExists(bytes32 key) external view returns(bool) {
284       return uIntStorage[key].isEntity;
285     }
286 
287     function getString(bytes32 key) external view returns(string memory) {
288         return stringStorage[key].value;
289     }
290 
291     function stringExists(bytes32 key) external view returns(bool) {
292       return stringStorage[key].isEntity;
293     }
294 
295     function getAddress(bytes32 key) external view returns(address) {
296         return addressStorage[key].value;
297     }
298 
299     function addressExists(bytes32 key) external view returns(bool) {
300       return addressStorage[key].isEntity;
301     }
302 
303     function getBytes(bytes32 key) external view returns(bytes memory) {
304         return bytesStorage[key].value;
305     }
306 
307     function bytesExists(bytes32 key) external view returns(bool) {
308       return bytesStorage[key].isEntity;
309     }
310 
311     function getBytes32(bytes32 key) external view returns(bytes32) {
312         return bytes32Storage[key].value;
313     }
314 
315     function bytes32Exists(bytes32 key) external view returns(bool) {
316       return bytes32Storage[key].isEntity;
317     }
318 
319     function getBool(bytes32 key) external view returns(bool) {
320         return boolStorage[key].value;
321     }
322 
323     function boolExists(bytes32 key) external view returns(bool) {
324       return boolStorage[key].isEntity;
325     }
326 
327     function getInt(bytes32 key) external view returns(int) {
328         return intStorage[key].value;
329     }
330 
331     function intExists(bytes32 key) external view returns(bool) {
332       return intStorage[key].isEntity;
333     }
334 }