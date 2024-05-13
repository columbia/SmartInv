1 pragma solidity ^0.5.0;
2 
3 
4 library Utils {
5 
6     /* @notice      Convert the bytes array to bytes32 type, the bytes array length must be 32
7     *  @param _bs   Source bytes array
8     *  @return      bytes32
9     */
10     function bytesToBytes32(bytes memory _bs) internal pure returns (bytes32 value) {
11         require(_bs.length == 32, "bytes length is not 32.");
12         assembly {
13             // load 32 bytes from memory starting from position _bs + 0x20 since the first 0x20 bytes stores _bs length
14             value := mload(add(_bs, 0x20))
15         }
16     }
17 
18     /* @notice      Convert bytes to uint256
19     *  @param _b    Source bytes should have length of 32
20     *  @return      uint256
21     */
22     function bytesToUint256(bytes memory _bs) internal pure returns (uint256 value) {
23         require(_bs.length == 32, "bytes length is not 32.");
24         assembly {
25             // load 32 bytes from memory starting from position _bs + 32
26             value := mload(add(_bs, 0x20))
27         }
28         require(value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
29     }
30 
31     /* @notice      Convert uint256 to bytes
32     *  @param _b    uint256 that needs to be converted
33     *  @return      bytes
34     */
35     function uint256ToBytes(uint256 _value) internal pure returns (bytes memory bs) {
36         require(_value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
37         assembly {
38             // Get a location of some free memory and store it in result as
39             // Solidity does for memory variables.
40             bs := mload(0x40)
41             // Put 0x20 at the first word, the length of bytes for uint256 value
42             mstore(bs, 0x20)
43             //In the next word, put value in bytes format to the next 32 bytes
44             mstore(add(bs, 0x20), _value)
45             // Update the free-memory pointer by padding our last write location to 32 bytes
46             mstore(0x40, add(bs, 0x40))
47         }
48     }
49 
50     /* @notice      Convert bytes to address
51     *  @param _bs   Source bytes: bytes length must be 20
52     *  @return      Converted address from source bytes
53     */
54     function bytesToAddress(bytes memory _bs) internal pure returns (address addr)
55     {
56         require(_bs.length == 20, "bytes length does not match address");
57         assembly {
58             // for _bs, first word store _bs.length, second word store _bs.value
59             // load 32 bytes from mem[_bs+20], convert it into Uint160, meaning we take last 20 bytes as addr (address).
60             addr := mload(add(_bs, 0x14))
61         }
62 
63     }
64     
65     /* @notice      Convert address to bytes
66     *  @param _addr Address need to be converted
67     *  @return      Converted bytes from address
68     */
69     function addressToBytes(address _addr) internal pure returns (bytes memory bs){
70         assembly {
71             // Get a location of some free memory and store it in result as
72             // Solidity does for memory variables.
73             bs := mload(0x40)
74             // Put 20 (address byte length) at the first word, the length of bytes for uint256 value
75             mstore(bs, 0x14)
76             // logical shift left _a by 12 bytes, change _a from right-aligned to left-aligned
77             mstore(add(bs, 0x20), shl(96, _addr))
78             // Update the free-memory pointer by padding our last write location to 32 bytes
79             mstore(0x40, add(bs, 0x40))
80        }
81     }
82 
83     /* @notice          Do hash leaf as the multi-chain does
84     *  @param _data     Data in bytes format
85     *  @return          Hashed value in bytes32 format
86     */
87     function hashLeaf(bytes memory _data) internal pure returns (bytes32 result)  {
88         result = sha256(abi.encodePacked(byte(0x0), _data));
89     }
90 
91     /* @notice          Do hash children as the multi-chain does
92     *  @param _l        Left node
93     *  @param _r        Right node
94     *  @return          Hashed value in bytes32 format
95     */
96     function hashChildren(bytes32 _l, bytes32  _r) internal pure returns (bytes32 result)  {
97         result = sha256(abi.encodePacked(bytes1(0x01), _l, _r));
98     }
99 
100     /* @notice              Compare if two bytes are equal, which are in storage and memory, seperately
101                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L368
102     *  @param _preBytes     The bytes stored in storage
103     *  @param _postBytes    The bytes stored in memory
104     *  @return              Bool type indicating if they are equal
105     */
106     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
107         bool success = true;
108 
109         assembly {
110             // we know _preBytes_offset is 0
111             let fslot := sload(_preBytes_slot)
112             // Arrays of 31 bytes or less have an even value in their slot,
113             // while longer arrays have an odd value. The actual length is
114             // the slot divided by two for odd values, and the lowest order
115             // byte divided by two for even values.
116             // If the slot is even, bitwise and the slot with 255 and divide by
117             // two to get the length. If the slot is odd, bitwise and the slot
118             // with -1 and divide by two.
119             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
120             let mlength := mload(_postBytes)
121 
122             // if lengths don't match the arrays are not equal
123             switch eq(slength, mlength)
124             case 1 {
125                 // fslot can contain both the length and contents of the array
126                 // if slength < 32 bytes so let's prepare for that
127                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
128                 // slength != 0
129                 if iszero(iszero(slength)) {
130                     switch lt(slength, 32)
131                     case 1 {
132                         // blank the last byte which is the length
133                         fslot := mul(div(fslot, 0x100), 0x100)
134 
135                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
136                             // unsuccess:
137                             success := 0
138                         }
139                     }
140                     default {
141                         // cb is a circuit breaker in the for loop since there's
142                         //  no said feature for inline assembly loops
143                         // cb = 1 - don't breaker
144                         // cb = 0 - break
145                         let cb := 1
146 
147                         // get the keccak hash to get the contents of the array
148                         mstore(0x0, _preBytes_slot)
149                         let sc := keccak256(0x0, 0x20)
150 
151                         let mc := add(_postBytes, 0x20)
152                         let end := add(mc, mlength)
153 
154                         // the next line is the loop condition:
155                         // while(uint(mc < end) + cb == 2)
156                         for {} eq(add(lt(mc, end), cb), 2) {
157                             sc := add(sc, 1)
158                             mc := add(mc, 0x20)
159                         } {
160                             if iszero(eq(sload(sc), mload(mc))) {
161                                 // unsuccess:
162                                 success := 0
163                                 cb := 0
164                             }
165                         }
166                     }
167                 }
168             }
169             default {
170                 // unsuccess:
171                 success := 0
172             }
173         }
174 
175         return success;
176     }
177 
178     /* @notice              Slice the _bytes from _start index till the result has length of _length
179                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L246
180     *  @param _bytes        The original bytes needs to be sliced
181     *  @param _start        The index of _bytes for the start of sliced bytes
182     *  @param _length       The index of _bytes for the end of sliced bytes
183     *  @return              The sliced bytes
184     */
185     function slice(
186         bytes memory _bytes,
187         uint _start,
188         uint _length
189     )
190         internal
191         pure
192         returns (bytes memory)
193     {
194         require(_bytes.length >= (_start + _length));
195 
196         bytes memory tempBytes;
197 
198         assembly {
199             switch iszero(_length)
200             case 0 {
201                 // Get a location of some free memory and store it in tempBytes as
202                 // Solidity does for memory variables.
203                 tempBytes := mload(0x40)
204 
205                 // The first word of the slice result is potentially a partial
206                 // word read from the original array. To read it, we calculate
207                 // the length of that partial word and start copying that many
208                 // bytes into the array. The first word we copy will start with
209                 // data we don't care about, but the last `lengthmod` bytes will
210                 // land at the beginning of the contents of the new array. When
211                 // we're done copying, we overwrite the full first word with
212                 // the actual length of the slice.
213                 // lengthmod <= _length % 32
214                 let lengthmod := and(_length, 31)
215 
216                 // The multiplication in the next line is necessary
217                 // because when slicing multiples of 32 bytes (lengthmod == 0)
218                 // the following copy loop was copying the origin's length
219                 // and then ending prematurely not copying everything it should.
220                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
221                 let end := add(mc, _length)
222 
223                 for {
224                     // The multiplication in the next line has the same exact purpose
225                     // as the one above.
226                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
227                 } lt(mc, end) {
228                     mc := add(mc, 0x20)
229                     cc := add(cc, 0x20)
230                 } {
231                     mstore(mc, mload(cc))
232                 }
233 
234                 mstore(tempBytes, _length)
235 
236                 //update free-memory pointer
237                 //allocating the array padded to 32 bytes like the compiler does now
238                 mstore(0x40, and(add(mc, 31), not(31)))
239             }
240             //if we want a zero-length slice let's just return a zero-length array
241             default {
242                 tempBytes := mload(0x40)
243 
244                 mstore(0x40, add(tempBytes, 0x20))
245             }
246         }
247 
248         return tempBytes;
249     }
250     /* @notice              Check if the elements number of _signers within _keepers array is no less than _m
251     *  @param _keepers      The array consists of serveral address
252     *  @param _signers      Some specific addresses to be looked into
253     *  @param _m            The number requirement paramter
254     *  @return              True means containment, false meansdo do not contain.
255     */
256     function containMAddresses(address[] memory _keepers, address[] memory _signers, uint _m) internal pure returns (bool){
257         uint m = 0;
258         for(uint i = 0; i < _signers.length; i++){
259             for (uint j = 0; j < _keepers.length; j++) {
260                 if (_signers[i] == _keepers[j]) {
261                     m++;
262                     // delete _keepers[j];
263                     _keepers[j] = 0x7777777777777777777777777777777777777777;
264                 }
265             }
266         }
267         return m >= _m;
268     }
269 
270     /* @notice              TODO
271     *  @param key
272     *  @return
273     */
274     function compressMCPubKey(bytes memory key) internal pure returns (bytes memory newkey) {
275          require(key.length >= 67, "key lenggh is too short");
276          newkey = slice(key, 0, 35);
277          if (uint8(key[66]) % 2 == 0){
278              newkey[2] = byte(0x02);
279          } else {
280              newkey[2] = byte(0x03);
281          }
282          return newkey;
283     }
284     
285     /**
286      * @dev Returns true if `account` is a contract.
287      *      Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol#L18
288      *
289      * This test is non-exhaustive, and there may be false-negatives: during the
290      * execution of a contract's constructor, its address will be reported as
291      * not containing a contract.
292      *
293      * IMPORTANT: It is unsafe to assume that an address for which this
294      * function returns false is an externally-owned account (EOA) and not a
295      * contract.
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies in extcodesize, which returns 0 for contracts in
299         // construction, since the code is only stored at the end of the
300         // constructor execution.
301 
302         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
303         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
304         // for accounts without code, i.e. `keccak256('')`
305         bytes32 codehash;
306         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { codehash := extcodehash(account) }
309         return (codehash != 0x0 && codehash != accountHash);
310     }
311 }