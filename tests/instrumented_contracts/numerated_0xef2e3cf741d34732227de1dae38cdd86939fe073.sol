1 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Strings.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5     //                                 ██▓▓████████████████████                                        
6     //                           ██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒██████                                  
7     //                         ██░░▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████                              
8     //                       ██░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒████                          
9     //                     ██░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████                      
10     //                   ██░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒██                    
11     //                 ██░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                  
12     //                 ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░██                
13     //             ████▒▒████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░██                
14     //           ██▒▒░░▒▒▒▒▒▒██████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░██              
15     //         ▓▓░░░░░░░░▒▒▒▒▒▒▒▒▒▒████▓▓██▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██              
16     //         ████▒▒▒▒▒▒░░░░▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██              
17     //             ██▒▒░░░░▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒████████░░░░░░░░░░░░░░░░░░░░░░░░██              
18     //           ▓▓▒▒░░░░░░▒▒▒▒░░░░░░▒▒▒▒░░░░░░░░▒▒▒▒░░▒▒▒▒▒▒▒▒██▓▓██▓▓░░░░░░░░░░░░░░░░██▒▒▓▓▓▓        
19     //           ██▒▒░░▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒▒░░░░░░▒▒▒▒▒▒░░▒▒▒▒████░░░░░░░░░░██░░░░░░░░██      
20     //             ████████████████▒▒▒▒██████▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒▒░░░░▒▒▒▒▒▒██████████▒▒▒▒▒▒░░░░██      
21     //               ████▒▒▓▓▓▓▓▓▓▓████▓▓▓▓██▒▒▒▒▒▒▒▒████████▒▒▒▒░░░░██▒▒▒▒▒▒░░░░▒▒▒▒░░░░▒▒▒▒██        
22     //             ██▒▒██▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████▓▓▓▓▓▓▓▓██▒▒░░██▓▓██▒▒▒▒░░░░▒▒▒▒▒▒░░░░██          
23     //           ██▒▒▒▒▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓██▒▒██▒▒▒▒▓▓▓▓████▓▓▓▓██▒▒▒▒░░░░████▒▒░░░░░░██        
24     //           ██▒▒▒▒▒▒▒▒▒▒██▓▓▓▓██▒▒▒▒▒▒▒▒████▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██▒▒░░▓▓▒▒▒▒████▒▒▓▓██        
25     //         ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████▒▒▒▒▒▒▒▒▒▒▒▒██████████▒▒▒▒▒▒▒▒████▒▒▒▒▒▒▒▒▒▒██▒▒▒▒██      
26     //     ██████▒▒▒▒██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████  
27     //   ██▒▒▒▒▒▒████▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
28     // ██▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒██▒▒▒▒████▓▓▓▓▓▓████▒▒▒▒▒▒██████▓▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████▓▓▒▒▒▒▒▒▒▒██
29     // ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████▓▓▓▓▓▓▒▒▓▓▓▓▓▓██████▓▓▓▓▓▓▒▒▒▒▓▓██▒▒▒▒▒▒▒▒▒▒██████▓▓▓▓██  ██████▒▒██
30     //     ████▓▓██▒▒▒▒▒▒▒▒▒▒████▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████▓▓▓▓▓▓████░░██      ██  
31     //           ██▒▒▒▒▒▒████░░░░████████▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▒▒▓▓████░░░░██          
32     //           ████████▓▓██░░░░░░░░░░░░████████████████████████▓▓▓▓██████▓▓▓▓▓▓██░░██░░░░██          
33     //               ██▓▓▓▓▓▓██░░░░░░░░░░░░░░░░░░░░░░░░██▓▓▓▓▓▓▓▓████▓▓▓▓▓▓██████░░░░██░░░░██          
34     //               ██▓▓▒▒▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██░░░░▒▒▒▒██░░██          
35     //                 ████████████░░░░░░░░░░░░████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████░░░░▒▒▒▒▒▒████            
36     //               ██▒▒▒▒▒▒░░░░░░██░░░░░░████░░░░██████████████████░░░░██░░░░▒▒▒▒▒▒▒▒██              
37     //               ██▒▒▒▒▒▒▒▒▒▒░░▒▒▓▓░░██░░░░░░░░░░░░░░████░░░░░░░░░░▓▓░░▒▒▒▒▒▒▒▒▒▒██                
38     //               ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▓▓░░░░██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                
39     //                 ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                  
40     //                 ░░▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██░░                  
41     //                       ████▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████▓▓                        
42     //                               ██████████████████████████████████                  
43 
44 // NhhdNNNNNNNNNNNNNNNMNhhNMMMMMMMMmhhhhdMMMMMMMMMddMMMMMMMMMMMMMMMMMMMMNdhhhhhdMmdddddddddddddddddNNhN
45 // moyo/:::::::::::::::+doy::::::::m....h+-------/dm:-------------------:oy/..ss:-.................-+hN
46 // Mo..................-moo........N....h:.......:dm-.....................-d-/h....................../M
47 // M...................-moo........N....h:.......:dd-......................y++s......................-M
48 // N.........----------:dos........m....h/.......:dd-.......-:::::-........yo+s........:+++++-.......-M
49 // N......../y+++++++++o/os........m....h/.......:dd-......./h++++h........so+s........d/:::h/.......-M
50 // N........oo...........os........m....h/.......:dd-......./h....m........so+y........d-...y/.......-M
51 // M........+h:::::::-...os........m....h/.......-dd-......./h....m........so+y........d-...y+.......-M
52 // M........-///////+os/.os........m....h/.......-dd-......./h....m........so+y........d-...y+.......-M
53 // M..................-y+os........m....h/.......-dd-......./h....m........so+y........d-...y+.......-M
54 // M/..................:dos........m....h/.......-dd:......./h....m........so+y........d-...y+.......-M
55 // Ny/--------..........mos........m....h/.......-dd:......./h....m........so+y........d-...y+.......-M
56 // m-+ooooooooy-........moy........m-...h/.......-dd:......./h....m........so+y........d-...y+.......-M
57 // m..........h+........Noy........d:...h+.......-md:.......:h....N........oo+y........d-...y+........M
58 // m----------h+........N+y........d/---h/.......-Nd:.......:h---:m........oo+y........h:---y+........M
59 // Msoooooooooo-........N/y........:oooo+-.......-Nd:.......-oooo+:........oo+h......../ooooo-........M
60 // M-...................N/y......................-Nd:......................oo+h.......................M
61 // M-..................:d:d......................:dd:.........SUDOSIX2k21..oo+h......................-M
62 // M-................./h/.ss-..................-/h:d:....................:ss..ss-...................:hN
63 // Nsoooooooooooooooos+-...:osooooooooosoooooooo+-.+soooosssssssssssssosso:----/ssooooossssssssssssso:m
64 // Nsssssssssssssss+hsssssh:./hsssssdsssssssssooooos+-ossssssssssssssoysooooooooooooomhooooooooooooossm
65 // N.............-:dh.....y+.oo.....d-.............-ydo-............-sM-.............do............../M
66 // N...............sh.....y+.os.....d-..............+M:......--......+M:.....--------do.....----......M
67 // N...../ysso.....sh.....y+.os.....d-....:dssh.....+M:....-dooh...../M:....-d+++++++ho.....ho+h:.....M
68 // N.....+y:+d.....sh.....y+.os.....d-....:d..m...../M:....-m..d/////oM:....-m/////..so.....m-.y/.....M
69 // N.....:o++/.....hh.....y+.os.....d:....-hooy.....+M:....-m:/+oossssm:....-/////h/.so.....ysss-....-M
70 // N............-/yhh.....y+.os.....d:.....---...--/hm:....-mm///::::oM:..........y+.so............-/yN
71 // N.....-----..-:+dh.....y+.os.....d:...........-:shd:....-mm::...../M:.....:::::y/.ss............:/yN
72 // M...../y+oy.....sh.....s+.os.....d:....-yooo.....+M:....-m/+m-..../M:....-m++++/-.ss.....ssoy:....-M
73 // M...../h/+h.....oh.....ss/ss.....h:....-m..m-..../M/....-d++m-..../M:....-m+++++++hs.....d-.y+.....N
74 // M.....-///:.....od.....-///-.....h:....-m..m-..../M/.....-::-...../M:.....-:------hs.....d-.y+.....N
75 // M...............ym-.............-m:....-m..m-..../Mo..............+M/.............hs.....d/.y+.....N
76 // M/////////////+ydyho//////////+ohNo/++++m::m+++++sdhyo++++++++++oyhdsooooooooooooomdooooom+:yhoooooM
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev String operations.
82  */
83 library Strings {
84     bytes16 private constant alphabet = "0123456789abcdef";
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
88      */
89     function toString(uint256 value) internal pure returns (string memory) {
90         // Inspired by OraclizeAPI's implementation - MIT licence
91         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
92 
93         if (value == 0) {
94             return "0";
95         }
96         uint256 temp = value;
97         uint256 digits;
98         while (temp != 0) {
99             digits++;
100             temp /= 10;
101         }
102         bytes memory buffer = new bytes(digits);
103         while (value != 0) {
104             digits -= 1;
105             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
106             value /= 10;
107         }
108         return string(buffer);
109     }
110 
111     /**
112      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
113      */
114     function toHexString(uint256 value) internal pure returns (string memory) {
115         if (value == 0) {
116             return "0x00";
117         }
118         uint256 temp = value;
119         uint256 length = 0;
120         while (temp != 0) {
121             length++;
122             temp >>= 8;
123         }
124         return toHexString(value, length);
125     }
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
129      */
130     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
131         bytes memory buffer = new bytes(2 * length + 2);
132         buffer[0] = "0";
133         buffer[1] = "x";
134         for (uint256 i = 2 * length + 1; i > 1; --i) {
135             buffer[i] = alphabet[value & 0xf];
136             value >>= 4;
137         }
138         require(value == 0, "Strings: hex length insufficient");
139         return string(buffer);
140     }
141 
142 }
143 
144 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableMap.sol
145 
146 
147 
148 
149 pragma solidity ^0.8.0;
150 
151 /**
152  * @dev Library for managing an enumerable variant of Solidity's
153  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
154  * type.
155  *
156  * Maps have the following properties:
157  *
158  * - Entries are added, removed, and checked for existence in constant time
159  * (O(1)).
160  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
161  *
162  * ```
163  * contract Example {
164  *     // Add the library methods
165  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
166  *
167  *     // Declare a set state variable
168  *     EnumerableMap.UintToAddressMap private myMap;
169  * }
170  * ```
171  *
172  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
173  * supported.
174  */
175 library EnumerableMap {
176     // To implement this library for multiple types with as little code
177     // repetition as possible, we write it in terms of a generic Map type with
178     // bytes32 keys and values.
179     // The Map implementation uses private functions, and user-facing
180     // implementations (such as Uint256ToAddressMap) are just wrappers around
181     // the underlying Map.
182     // This means that we can only create new EnumerableMaps for types that fit
183     // in bytes32.
184 
185     struct MapEntry {
186         bytes32 _key;
187         bytes32 _value;
188     }
189 
190     struct Map {
191         // Storage of map keys and values
192         MapEntry[] _entries;
193 
194         // Position of the entry defined by a key in the `entries` array, plus 1
195         // because index 0 means a key is not in the map.
196         mapping (bytes32 => uint256) _indexes;
197     }
198 
199     /**
200      * @dev Adds a key-value pair to a map, or updates the value for an existing
201      * key. O(1).
202      *
203      * Returns true if the key was added to the map, that is if it was not
204      * already present.
205      */
206     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
207         // We read and store the key's index to prevent multiple reads from the same storage slot
208         uint256 keyIndex = map._indexes[key];
209 
210         if (keyIndex == 0) { // Equivalent to !contains(map, key)
211             map._entries.push(MapEntry({ _key: key, _value: value }));
212             // The entry is stored at length-1, but we add 1 to all indexes
213             // and use 0 as a sentinel value
214             map._indexes[key] = map._entries.length;
215             return true;
216         } else {
217             map._entries[keyIndex - 1]._value = value;
218             return false;
219         }
220     }
221 
222     /**
223      * @dev Removes a key-value pair from a map. O(1).
224      *
225      * Returns true if the key was removed from the map, that is if it was present.
226      */
227     function _remove(Map storage map, bytes32 key) private returns (bool) {
228         // We read and store the key's index to prevent multiple reads from the same storage slot
229         uint256 keyIndex = map._indexes[key];
230 
231         if (keyIndex != 0) { // Equivalent to contains(map, key)
232             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
233             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
234             // This modifies the order of the array, as noted in {at}.
235 
236             uint256 toDeleteIndex = keyIndex - 1;
237             uint256 lastIndex = map._entries.length - 1;
238 
239             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
240             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
241 
242             MapEntry storage lastEntry = map._entries[lastIndex];
243 
244             // Move the last entry to the index where the entry to delete is
245             map._entries[toDeleteIndex] = lastEntry;
246             // Update the index for the moved entry
247             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
248 
249             // Delete the slot where the moved entry was stored
250             map._entries.pop();
251 
252             // Delete the index for the deleted slot
253             delete map._indexes[key];
254 
255             return true;
256         } else {
257             return false;
258         }
259     }
260 
261     /**
262      * @dev Returns true if the key is in the map. O(1).
263      */
264     function _contains(Map storage map, bytes32 key) private view returns (bool) {
265         return map._indexes[key] != 0;
266     }
267 
268     /**
269      * @dev Returns the number of key-value pairs in the map. O(1).
270      */
271     function _length(Map storage map) private view returns (uint256) {
272         return map._entries.length;
273     }
274 
275    /**
276     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
277     *
278     * Note that there are no guarantees on the ordering of entries inside the
279     * array, and it may change when more entries are added or removed.
280     *
281     * Requirements:
282     *
283     * - `index` must be strictly less than {length}.
284     */
285     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
286         require(map._entries.length > index, "EnumerableMap: index out of bounds");
287 
288         MapEntry storage entry = map._entries[index];
289         return (entry._key, entry._value);
290     }
291 
292     /**
293      * @dev Tries to returns the value associated with `key`.  O(1).
294      * Does not revert if `key` is not in the map.
295      */
296     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
297         uint256 keyIndex = map._indexes[key];
298         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
299         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
300     }
301 
302     /**
303      * @dev Returns the value associated with `key`.  O(1).
304      *
305      * Requirements:
306      *
307      * - `key` must be in the map.
308      */
309     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
310         uint256 keyIndex = map._indexes[key];
311         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
312         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
313     }
314 
315     /**
316      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
317      *
318      * CAUTION: This function is deprecated because it requires allocating memory for the error
319      * message unnecessarily. For custom revert reasons use {_tryGet}.
320      */
321     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
322         uint256 keyIndex = map._indexes[key];
323         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
324         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
325     }
326 
327     // UintToAddressMap
328 
329     struct UintToAddressMap {
330         Map _inner;
331     }
332 
333     /**
334      * @dev Adds a key-value pair to a map, or updates the value for an existing
335      * key. O(1).
336      *
337      * Returns true if the key was added to the map, that is if it was not
338      * already present.
339      */
340     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
341         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
342     }
343 
344     /**
345      * @dev Removes a value from a set. O(1).
346      *
347      * Returns true if the key was removed from the map, that is if it was present.
348      */
349     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
350         return _remove(map._inner, bytes32(key));
351     }
352 
353     /**
354      * @dev Returns true if the key is in the map. O(1).
355      */
356     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
357         return _contains(map._inner, bytes32(key));
358     }
359 
360     /**
361      * @dev Returns the number of elements in the map. O(1).
362      */
363     function length(UintToAddressMap storage map) internal view returns (uint256) {
364         return _length(map._inner);
365     }
366 
367    /**
368     * @dev Returns the element stored at position `index` in the set. O(1).
369     * Note that there are no guarantees on the ordering of values inside the
370     * array, and it may change when more values are added or removed.
371     *
372     * Requirements:
373     *
374     * - `index` must be strictly less than {length}.
375     */
376     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
377         (bytes32 key, bytes32 value) = _at(map._inner, index);
378         return (uint256(key), address(uint160(uint256(value))));
379     }
380 
381     /**
382      * @dev Tries to returns the value associated with `key`.  O(1).
383      * Does not revert if `key` is not in the map.
384      *
385      * _Available since v3.4._
386      */
387     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
388         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
389         return (success, address(uint160(uint256(value))));
390     }
391 
392     /**
393      * @dev Returns the value associated with `key`.  O(1).
394      *
395      * Requirements:
396      *
397      * - `key` must be in the map.
398      */
399     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
400         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
401     }
402 
403     /**
404      * @dev Same as {get}, with a custom error message when `key` is not in the map.
405      *
406      * CAUTION: This function is deprecated because it requires allocating memory for the error
407      * message unnecessarily. For custom revert reasons use {tryGet}.
408      */
409     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
410         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
411     }
412 }
413 
414 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol
415 
416 
417 
418 
419 pragma solidity ^0.8.0;
420 
421 /**
422  * @dev Library for managing
423  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
424  * types.
425  *
426  * Sets have the following properties:
427  *
428  * - Elements are added, removed, and checked for existence in constant time
429  * (O(1)).
430  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
431  *
432  * ```
433  * contract Example {
434  *     // Add the library methods
435  *     using EnumerableSet for EnumerableSet.AddressSet;
436  *
437  *     // Declare a set state variable
438  *     EnumerableSet.AddressSet private mySet;
439  * }
440  * ```
441  *
442  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
443  * and `uint256` (`UintSet`) are supported.
444  */
445 library EnumerableSet {
446     // To implement this library for multiple types with as little code
447     // repetition as possible, we write it in terms of a generic Set type with
448     // bytes32 values.
449     // The Set implementation uses private functions, and user-facing
450     // implementations (such as AddressSet) are just wrappers around the
451     // underlying Set.
452     // This means that we can only create new EnumerableSets for types that fit
453     // in bytes32.
454 
455     struct Set {
456         // Storage of set values
457         bytes32[] _values;
458 
459         // Position of the value in the `values` array, plus 1 because index 0
460         // means a value is not in the set.
461         mapping (bytes32 => uint256) _indexes;
462     }
463 
464     /**
465      * @dev Add a value to a set. O(1).
466      *
467      * Returns true if the value was added to the set, that is if it was not
468      * already present.
469      */
470     function _add(Set storage set, bytes32 value) private returns (bool) {
471         if (!_contains(set, value)) {
472             set._values.push(value);
473             // The value is stored at length-1, but we add 1 to all indexes
474             // and use 0 as a sentinel value
475             set._indexes[value] = set._values.length;
476             return true;
477         } else {
478             return false;
479         }
480     }
481 
482     /**
483      * @dev Removes a value from a set. O(1).
484      *
485      * Returns true if the value was removed from the set, that is if it was
486      * present.
487      */
488     function _remove(Set storage set, bytes32 value) private returns (bool) {
489         // We read and store the value's index to prevent multiple reads from the same storage slot
490         uint256 valueIndex = set._indexes[value];
491 
492         if (valueIndex != 0) { // Equivalent to contains(set, value)
493             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
494             // the array, and then remove the last element (sometimes called as 'swap and pop').
495             // This modifies the order of the array, as noted in {at}.
496 
497             uint256 toDeleteIndex = valueIndex - 1;
498             uint256 lastIndex = set._values.length - 1;
499 
500             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
501             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
502 
503             bytes32 lastvalue = set._values[lastIndex];
504 
505             // Move the last value to the index where the value to delete is
506             set._values[toDeleteIndex] = lastvalue;
507             // Update the index for the moved value
508             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
509 
510             // Delete the slot where the moved value was stored
511             set._values.pop();
512 
513             // Delete the index for the deleted slot
514             delete set._indexes[value];
515 
516             return true;
517         } else {
518             return false;
519         }
520     }
521 
522     /**
523      * @dev Returns true if the value is in the set. O(1).
524      */
525     function _contains(Set storage set, bytes32 value) private view returns (bool) {
526         return set._indexes[value] != 0;
527     }
528 
529     /**
530      * @dev Returns the number of values on the set. O(1).
531      */
532     function _length(Set storage set) private view returns (uint256) {
533         return set._values.length;
534     }
535 
536    /**
537     * @dev Returns the value stored at position `index` in the set. O(1).
538     *
539     * Note that there are no guarantees on the ordering of values inside the
540     * array, and it may change when more values are added or removed.
541     *
542     * Requirements:
543     *
544     * - `index` must be strictly less than {length}.
545     */
546     function _at(Set storage set, uint256 index) private view returns (bytes32) {
547         require(set._values.length > index, "EnumerableSet: index out of bounds");
548         return set._values[index];
549     }
550 
551     // Bytes32Set
552 
553     struct Bytes32Set {
554         Set _inner;
555     }
556 
557     /**
558      * @dev Add a value to a set. O(1).
559      *
560      * Returns true if the value was added to the set, that is if it was not
561      * already present.
562      */
563     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
564         return _add(set._inner, value);
565     }
566 
567     /**
568      * @dev Removes a value from a set. O(1).
569      *
570      * Returns true if the value was removed from the set, that is if it was
571      * present.
572      */
573     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
574         return _remove(set._inner, value);
575     }
576 
577     /**
578      * @dev Returns true if the value is in the set. O(1).
579      */
580     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
581         return _contains(set._inner, value);
582     }
583 
584     /**
585      * @dev Returns the number of values in the set. O(1).
586      */
587     function length(Bytes32Set storage set) internal view returns (uint256) {
588         return _length(set._inner);
589     }
590 
591    /**
592     * @dev Returns the value stored at position `index` in the set. O(1).
593     *
594     * Note that there are no guarantees on the ordering of values inside the
595     * array, and it may change when more values are added or removed.
596     *
597     * Requirements:
598     *
599     * - `index` must be strictly less than {length}.
600     */
601     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
602         return _at(set._inner, index);
603     }
604 
605     // AddressSet
606 
607     struct AddressSet {
608         Set _inner;
609     }
610 
611     /**
612      * @dev Add a value to a set. O(1).
613      *
614      * Returns true if the value was added to the set, that is if it was not
615      * already present.
616      */
617     function add(AddressSet storage set, address value) internal returns (bool) {
618         return _add(set._inner, bytes32(uint256(uint160(value))));
619     }
620 
621     /**
622      * @dev Removes a value from a set. O(1).
623      *
624      * Returns true if the value was removed from the set, that is if it was
625      * present.
626      */
627     function remove(AddressSet storage set, address value) internal returns (bool) {
628         return _remove(set._inner, bytes32(uint256(uint160(value))));
629     }
630 
631     /**
632      * @dev Returns true if the value is in the set. O(1).
633      */
634     function contains(AddressSet storage set, address value) internal view returns (bool) {
635         return _contains(set._inner, bytes32(uint256(uint160(value))));
636     }
637 
638     /**
639      * @dev Returns the number of values in the set. O(1).
640      */
641     function length(AddressSet storage set) internal view returns (uint256) {
642         return _length(set._inner);
643     }
644 
645    /**
646     * @dev Returns the value stored at position `index` in the set. O(1).
647     *
648     * Note that there are no guarantees on the ordering of values inside the
649     * array, and it may change when more values are added or removed.
650     *
651     * Requirements:
652     *
653     * - `index` must be strictly less than {length}.
654     */
655     function at(AddressSet storage set, uint256 index) internal view returns (address) {
656         return address(uint160(uint256(_at(set._inner, index))));
657     }
658 
659 
660     // UintSet
661 
662     struct UintSet {
663         Set _inner;
664     }
665 
666     /**
667      * @dev Add a value to a set. O(1).
668      *
669      * Returns true if the value was added to the set, that is if it was not
670      * already present.
671      */
672     function add(UintSet storage set, uint256 value) internal returns (bool) {
673         return _add(set._inner, bytes32(value));
674     }
675 
676     /**
677      * @dev Removes a value from a set. O(1).
678      *
679      * Returns true if the value was removed from the set, that is if it was
680      * present.
681      */
682     function remove(UintSet storage set, uint256 value) internal returns (bool) {
683         return _remove(set._inner, bytes32(value));
684     }
685 
686     /**
687      * @dev Returns true if the value is in the set. O(1).
688      */
689     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
690         return _contains(set._inner, bytes32(value));
691     }
692 
693     /**
694      * @dev Returns the number of values on the set. O(1).
695      */
696     function length(UintSet storage set) internal view returns (uint256) {
697         return _length(set._inner);
698     }
699 
700    /**
701     * @dev Returns the value stored at position `index` in the set. O(1).
702     *
703     * Note that there are no guarantees on the ordering of values inside the
704     * array, and it may change when more values are added or removed.
705     *
706     * Requirements:
707     *
708     * - `index` must be strictly less than {length}.
709     */
710     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
711         return uint256(_at(set._inner, index));
712     }
713 }
714 
715 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
716 
717 
718 
719 
720 pragma solidity ^0.8.0;
721 
722 /**
723  * @dev Collection of functions related to the address type
724  */
725 library Address {
726     /**
727      * @dev Returns true if `account` is a contract.
728      *
729      * [IMPORTANT]
730      * ====
731      * It is unsafe to assume that an address for which this function returns
732      * false is an externally-owned account (EOA) and not a contract.
733      *
734      * Among others, `isContract` will return false for the following
735      * types of addresses:
736      *
737      *  - an externally-owned account
738      *  - a contract in construction
739      *  - an address where a contract will be created
740      *  - an address where a contract lived, but was destroyed
741      * ====
742      */
743     function isContract(address account) internal view returns (bool) {
744         // This method relies on extcodesize, which returns 0 for contracts in
745         // construction, since the code is only stored at the end of the
746         // constructor execution.
747 
748         uint256 size;
749         // solhint-disable-next-line no-inline-assembly
750         assembly { size := extcodesize(account) }
751         return size > 0;
752     }
753 
754     /**
755      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
756      * `recipient`, forwarding all available gas and reverting on errors.
757      *
758      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
759      * of certain opcodes, possibly making contracts go over the 2300 gas limit
760      * imposed by `transfer`, making them unable to receive funds via
761      * `transfer`. {sendValue} removes this limitation.
762      *
763      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
764      *
765      * IMPORTANT: because control is transferred to `recipient`, care must be
766      * taken to not create reentrancy vulnerabilities. Consider using
767      * {ReentrancyGuard} or the
768      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
769      */
770     function sendValue(address payable recipient, uint256 amount) internal {
771         require(address(this).balance >= amount, "Address: insufficient balance");
772 
773         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
774         (bool success, ) = recipient.call{ value: amount }("");
775         require(success, "Address: unable to send value, recipient may have reverted");
776     }
777 
778     /**
779      * @dev Performs a Solidity function call using a low level `call`. A
780      * plain`call` is an unsafe replacement for a function call: use this
781      * function instead.
782      *
783      * If `target` reverts with a revert reason, it is bubbled up by this
784      * function (like regular Solidity function calls).
785      *
786      * Returns the raw returned data. To convert to the expected return value,
787      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
788      *
789      * Requirements:
790      *
791      * - `target` must be a contract.
792      * - calling `target` with `data` must not revert.
793      *
794      * _Available since v3.1._
795      */
796     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
797       return functionCall(target, data, "Address: low-level call failed");
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
802      * `errorMessage` as a fallback revert reason when `target` reverts.
803      *
804      * _Available since v3.1._
805      */
806     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
807         return functionCallWithValue(target, data, 0, errorMessage);
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
812      * but also transferring `value` wei to `target`.
813      *
814      * Requirements:
815      *
816      * - the calling contract must have an ETH balance of at least `value`.
817      * - the called Solidity function must be `payable`.
818      *
819      * _Available since v3.1._
820      */
821     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
822         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
823     }
824 
825     /**
826      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
827      * with `errorMessage` as a fallback revert reason when `target` reverts.
828      *
829      * _Available since v3.1._
830      */
831     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
832         require(address(this).balance >= value, "Address: insufficient balance for call");
833         require(isContract(target), "Address: call to non-contract");
834 
835         // solhint-disable-next-line avoid-low-level-calls
836         (bool success, bytes memory returndata) = target.call{ value: value }(data);
837         return _verifyCallResult(success, returndata, errorMessage);
838     }
839 
840     /**
841      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
842      * but performing a static call.
843      *
844      * _Available since v3.3._
845      */
846     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
847         return functionStaticCall(target, data, "Address: low-level static call failed");
848     }
849 
850     /**
851      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
852      * but performing a static call.
853      *
854      * _Available since v3.3._
855      */
856     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
857         require(isContract(target), "Address: static call to non-contract");
858 
859         // solhint-disable-next-line avoid-low-level-calls
860         (bool success, bytes memory returndata) = target.staticcall(data);
861         return _verifyCallResult(success, returndata, errorMessage);
862     }
863 
864     /**
865      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
866      * but performing a delegate call.
867      *
868      * _Available since v3.4._
869      */
870     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
871         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
872     }
873 
874     /**
875      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
876      * but performing a delegate call.
877      *
878      * _Available since v3.4._
879      */
880     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
881         require(isContract(target), "Address: delegate call to non-contract");
882 
883         // solhint-disable-next-line avoid-low-level-calls
884         (bool success, bytes memory returndata) = target.delegatecall(data);
885         return _verifyCallResult(success, returndata, errorMessage);
886     }
887 
888     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
889         if (success) {
890             return returndata;
891         } else {
892             // Look for revert reason and bubble it up if present
893             if (returndata.length > 0) {
894                 // The easiest way to bubble the revert reason is using memory via assembly
895 
896                 // solhint-disable-next-line no-inline-assembly
897                 assembly {
898                     let returndata_size := mload(returndata)
899                     revert(add(32, returndata), returndata_size)
900                 }
901             } else {
902                 revert(errorMessage);
903             }
904         }
905     }
906 }
907 
908 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/ERC165.sol
909 
910 
911 pragma solidity ^0.8.0;
912 
913 /**
914  * @dev Interface of the ERC165 standard, as defined in the
915  * https://eips.ethereum.org/EIPS/eip-165[EIP].
916  *
917  * Implementers can declare support of contract interfaces, which can then be
918  * queried by others ({ERC165Checker}).
919  *
920  * For an implementation, see {ERC165}.
921  */
922 interface IERC165 {
923     /**
924      * @dev Returns true if this contract implements the interface defined by
925      * `interfaceId`. See the corresponding
926      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
927      * to learn more about how these ids are created.
928      *
929      * This function call must use less than 30 000 gas.
930      */
931     function supportsInterface(bytes4 interfaceId) external view returns (bool);
932 }
933 
934 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
935 
936 
937 pragma solidity ^0.8.0;
938 
939 
940 /**
941  * @dev Implementation of the {IERC165} interface.
942  *
943  * Contracts may inherit from this and call {_registerInterface} to declare
944  * their support of an interface.
945  */
946 abstract contract ERC165 is IERC165 {
947     /**
948      * @dev Mapping of interface ids to whether or not it's supported.
949      */
950     mapping(bytes4 => bool) private _supportedInterfaces;
951 
952     constructor () {
953         // Derived contracts need only register support for their own interfaces,
954         // we register support for ERC165 itself here
955         _registerInterface(type(IERC165).interfaceId);
956     }
957 
958     /**
959      * @dev See {IERC165-supportsInterface}.
960      *
961      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
962      */
963     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
964         return _supportedInterfaces[interfaceId];
965     }
966 
967     /**
968      * @dev Registers the contract as an implementer of the interface defined by
969      * `interfaceId`. Support of the actual ERC165 interface is automatic and
970      * registering its interface id is not required.
971      *
972      * See {IERC165-supportsInterface}.
973      *
974      * Requirements:
975      *
976      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
977      */
978     function _registerInterface(bytes4 interfaceId) internal virtual {
979         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
980         _supportedInterfaces[interfaceId] = true;
981     }
982 }
983 
984 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
985 
986 
987 
988 
989 pragma solidity ^0.8.0;
990 
991 
992 /**
993  * @dev Required interface of an ERC721 compliant contract.
994  */
995 interface IERC721 is IERC165 {
996     /**
997      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
998      */
999     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1000 
1001     /**
1002      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1003      */
1004     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1005 
1006     /**
1007      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1008      */
1009     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1010 
1011     /**
1012      * @dev Returns the number of tokens in ``owner``'s account.
1013      */
1014     function balanceOf(address owner) external view returns (uint256 balance);
1015 
1016     /**
1017      * @dev Returns the owner of the `tokenId` token.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      */
1023     function ownerOf(uint256 tokenId) external view returns (address owner);
1024 
1025     /**
1026      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1027      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1028      *
1029      * Requirements:
1030      *
1031      * - `from` cannot be the zero address.
1032      * - `to` cannot be the zero address.
1033      * - `tokenId` token must exist and be owned by `from`.
1034      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1035      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1040 
1041     /**
1042      * @dev Transfers `tokenId` token from `from` to `to`.
1043      *
1044      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1045      *
1046      * Requirements:
1047      *
1048      * - `from` cannot be the zero address.
1049      * - `to` cannot be the zero address.
1050      * - `tokenId` token must be owned by `from`.
1051      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function transferFrom(address from, address to, uint256 tokenId) external;
1056 
1057     /**
1058      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1059      * The approval is cleared when the token is transferred.
1060      *
1061      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1062      *
1063      * Requirements:
1064      *
1065      * - The caller must own the token or be an approved operator.
1066      * - `tokenId` must exist.
1067      *
1068      * Emits an {Approval} event.
1069      */
1070     function approve(address to, uint256 tokenId) external;
1071 
1072     /**
1073      * @dev Returns the account approved for `tokenId` token.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must exist.
1078      */
1079     function getApproved(uint256 tokenId) external view returns (address operator);
1080 
1081     /**
1082      * @dev Approve or remove `operator` as an operator for the caller.
1083      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1084      *
1085      * Requirements:
1086      *
1087      * - The `operator` cannot be the caller.
1088      *
1089      * Emits an {ApprovalForAll} event.
1090      */
1091     function setApprovalForAll(address operator, bool _approved) external;
1092 
1093     /**
1094      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1095      *
1096      * See {setApprovalForAll}
1097      */
1098     function isApprovedForAll(address owner, address operator) external view returns (bool);
1099 
1100     /**
1101       * @dev Safely transfers `tokenId` token from `from` to `to`.
1102       *
1103       * Requirements:
1104       *
1105       * - `from` cannot be the zero address.
1106       * - `to` cannot be the zero address.
1107       * - `tokenId` token must exist and be owned by `from`.
1108       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1109       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1110       *
1111       * Emits a {Transfer} event.
1112       */
1113     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1114 }
1115 
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 /**
1120  * @title ERC721 token receiver interface
1121  * @dev Interface for any contract that wants to support safeTransfers
1122  * from ERC721 asset contracts.
1123  */
1124 interface IERC721Receiver {
1125     /**
1126      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1127      * by `operator` from `from`, this function is called.
1128      *
1129      * It must return its Solidity selector to confirm the token transfer.
1130      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1131      *
1132      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1133      */
1134     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1135 }
1136 
1137 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Enumerable.sol
1138 
1139 
1140 
1141 
1142 pragma solidity ^0.8.0;
1143 
1144 
1145 /**
1146  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1147  * @dev See https://eips.ethereum.org/EIPS/eip-721
1148  */
1149 interface IERC721Enumerable is IERC721 {
1150 
1151     /**
1152      * @dev Returns the total amount of tokens stored by the contract.
1153      */
1154     function totalSupply() external view returns (uint256);
1155 
1156     /**
1157      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1158      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1159      */
1160     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1161 
1162     /**
1163      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1164      * Use along with {totalSupply} to enumerate all tokens.
1165      */
1166     function tokenByIndex(uint256 index) external view returns (uint256);
1167 }
1168 
1169 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/IERC721Metadata.sol
1170 
1171 
1172 
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 
1177 /**
1178  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1179  * @dev See https://eips.ethereum.org/EIPS/eip-721
1180  */
1181 interface IERC721Metadata is IERC721 {
1182 
1183     /**
1184      * @dev Returns the token collection name.
1185      */
1186     function name() external view returns (string memory);
1187 
1188     /**
1189      * @dev Returns the token collection symbol.
1190      */
1191     function symbol() external view returns (string memory);
1192 
1193     /**
1194      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1195      */
1196     function tokenURI(uint256 tokenId) external view returns (string memory);
1197 }
1198 
1199 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/introspection/IERC165.sol
1200 
1201 
1202 
1203 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
1204 
1205 
1206 
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 /*
1211  * @dev Provides information about the current execution context, including the
1212  * sender of the transaction and its data. While these are generally available
1213  * via msg.sender and msg.data, they should not be accessed in such a direct
1214  * manner, since when dealing with GSN meta-transactions the account sending and
1215  * paying for execution may not be the actual sender (as far as an application
1216  * is concerned).
1217  *
1218  * This contract is only required for intermediate, library-like contracts.
1219  */
1220 abstract contract Context {
1221     function _msgSender() internal view virtual returns (address) {
1222         return msg.sender;
1223     }
1224 
1225     function _msgData() internal view virtual returns (bytes calldata) {
1226         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1227         return msg.data;
1228     }
1229 }
1230 
1231 
1232 
1233 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
1234 
1235 
1236 
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 /**
1251  * @title ERC721 Non-Fungible Token Standard basic implementation
1252  * @dev see https://eips.ethereum.org/EIPS/eip-721
1253  */
1254 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1255     using Address for address;
1256     using EnumerableSet for EnumerableSet.UintSet;
1257     using EnumerableMap for EnumerableMap.UintToAddressMap;
1258     using Strings for uint256;
1259 
1260     // Mapping from holder address to their (enumerable) set of owned tokens
1261     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1262 
1263     // Enumerable mapping from token ids to their owners
1264     EnumerableMap.UintToAddressMap private _tokenOwners;
1265 
1266     // Mapping from token ID to approved address
1267     mapping (uint256 => address) private _tokenApprovals;
1268 
1269     // Mapping from owner to operator approvals
1270     mapping (address => mapping (address => bool)) private _operatorApprovals;
1271 
1272     // Token name
1273     string private _name;
1274 
1275     // Token symbol
1276     string private _symbol;
1277 
1278     // Optional mapping for token URIs
1279     mapping (uint256 => string) private _tokenURIs;
1280 
1281     // Base URI
1282     string private _baseURI;
1283 
1284     /**
1285      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1286      */
1287     constructor (string memory name_, string memory symbol_) {
1288         _name = name_;
1289         _symbol = symbol_;
1290 
1291         // register the supported interfaces to conform to ERC721 via ERC165
1292         _registerInterface(type(IERC721).interfaceId);
1293         _registerInterface(type(IERC721Metadata).interfaceId);
1294         _registerInterface(type(IERC721Enumerable).interfaceId);
1295     }
1296 
1297     /**
1298      * @dev See {IERC721-balanceOf}.
1299      */
1300     function balanceOf(address owner) public view virtual override returns (uint256) {
1301         require(owner != address(0), "ERC721: balance query for the zero address");
1302         return _holderTokens[owner].length();
1303     }
1304     
1305 
1306     
1307     /**
1308      * @dev See {IERC721-ownerOf}.
1309      */
1310     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1311         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1312     }
1313 
1314     /**
1315      * @dev See {IERC721Metadata-name}.
1316      */
1317     function name() public view virtual override returns (string memory) {
1318         return _name;
1319     }
1320 
1321     /**
1322      * @dev See {IERC721Metadata-symbol}.
1323      */
1324     function symbol() public view virtual override returns (string memory) {
1325         return _symbol;
1326     }
1327 
1328     /**
1329      * @dev See {IERC721Metadata-tokenURI}.
1330      */
1331     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1332         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1333 
1334         string memory _tokenURI = _tokenURIs[tokenId];
1335         string memory base = baseURI();
1336 
1337         // If there is no base URI, return the token URI.
1338         if (bytes(base).length == 0) {
1339             return _tokenURI;
1340         }
1341         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1342         if (bytes(_tokenURI).length > 0) {
1343             return string(abi.encodePacked(base, _tokenURI));
1344         }
1345         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1346         return string(abi.encodePacked(base, tokenId.toString()));
1347     }
1348 
1349     /**
1350     * @dev Returns the base URI set via {_setBaseURI}. This will be
1351     * automatically added as a prefix in {tokenURI} to each token's URI, or
1352     * to the token ID if no specific URI is set for that token ID.
1353     */
1354     function baseURI() public view virtual returns (string memory) {
1355         return _baseURI;
1356     }
1357 
1358     /**
1359      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1360      */
1361     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1362         return _holderTokens[owner].at(index);
1363     }
1364 
1365     /**
1366      * @dev See {IERC721Enumerable-totalSupply}.
1367      */
1368     function totalSupply() public view virtual override returns (uint256) {
1369         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1370         return _tokenOwners.length();
1371     }
1372 
1373     /**
1374      * @dev See {IERC721Enumerable-tokenByIndex}.
1375      */
1376     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1377         (uint256 tokenId, ) = _tokenOwners.at(index);
1378         return tokenId;
1379     }
1380 
1381     /**
1382      * @dev See {IERC721-approve}.
1383      */
1384     function approve(address to, uint256 tokenId) public virtual override {
1385         address owner = ERC721.ownerOf(tokenId);
1386         require(to != owner, "ERC721: approval to current owner");
1387 
1388         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1389             "ERC721: approve caller is not owner nor approved for all"
1390         );
1391 
1392         _approve(to, tokenId);
1393     }
1394 
1395     /**
1396      * @dev See {IERC721-getApproved}.
1397      */
1398     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1399         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1400 
1401         return _tokenApprovals[tokenId];
1402     }
1403 
1404     /**
1405      * @dev See {IERC721-setApprovalForAll}.
1406      */
1407     function setApprovalForAll(address operator, bool approved) public virtual override {
1408         require(operator != _msgSender(), "ERC721: approve to caller");
1409 
1410         _operatorApprovals[_msgSender()][operator] = approved;
1411         emit ApprovalForAll(_msgSender(), operator, approved);
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-isApprovedForAll}.
1416      */
1417     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1418         return _operatorApprovals[owner][operator];
1419     }
1420 
1421     /**
1422      * @dev See {IERC721-transferFrom}.
1423      */
1424     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1425         //solhint-disable-next-line max-line-length
1426         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1427 
1428         _transfer(from, to, tokenId);
1429     }
1430 
1431     /**
1432      * @dev See {IERC721-safeTransferFrom}.
1433      */
1434     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1435         safeTransferFrom(from, to, tokenId, "");
1436     }
1437 
1438     /**
1439      * @dev See {IERC721-safeTransferFrom}.
1440      */
1441     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1442         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1443         _safeTransfer(from, to, tokenId, _data);
1444     }
1445 
1446     /**
1447      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1448      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1449      *
1450      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1451      *
1452      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1453      * implement alternative mechanisms to perform token transfer, such as signature-based.
1454      *
1455      * Requirements:
1456      *
1457      * - `from` cannot be the zero address.
1458      * - `to` cannot be the zero address.
1459      * - `tokenId` token must exist and be owned by `from`.
1460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1461      *
1462      * Emits a {Transfer} event.
1463      */
1464     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1465         _transfer(from, to, tokenId);
1466         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1467     }
1468 
1469     /**
1470      * @dev Returns whether `tokenId` exists.
1471      *
1472      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1473      *
1474      * Tokens start existing when they are minted (`_mint`),
1475      * and stop existing when they are burned (`_burn`).
1476      */
1477     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1478         return _tokenOwners.contains(tokenId);
1479     }
1480 
1481     /**
1482      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1483      *
1484      * Requirements:
1485      *
1486      * - `tokenId` must exist.
1487      */
1488     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1489         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1490         address owner = ERC721.ownerOf(tokenId);
1491         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1492     }
1493 
1494     /**
1495      * @dev Safely mints `tokenId` and transfers it to `to`.
1496      *
1497      * Requirements:
1498      d*
1499      * - `tokenId` must not exist.
1500      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1501      *
1502      * Emits a {Transfer} event.
1503      */
1504     function _safeMint(address to, uint256 tokenId) internal virtual {
1505         _safeMint(to, tokenId, "");
1506     }
1507 
1508     /**
1509      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1510      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1511      */
1512     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1513         _mint(to, tokenId);
1514         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1515     }
1516 
1517     /**
1518      * @dev Mints `tokenId` and transfers it to `to`.
1519      *
1520      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1521      *
1522      * Requirements:
1523      *
1524      * - `tokenId` must not exist.
1525      * - `to` cannot be the zero address.
1526      *
1527      * Emits a {Transfer} event.
1528      */
1529     function _mint(address to, uint256 tokenId) internal virtual {
1530         require(to != address(0), "ERC721: mint to the zero address");
1531         require(!_exists(tokenId), "ERC721: token already minted");
1532 
1533         _beforeTokenTransfer(address(0), to, tokenId);
1534 
1535         _holderTokens[to].add(tokenId);
1536 
1537         _tokenOwners.set(tokenId, to);
1538 
1539         emit Transfer(address(0), to, tokenId);
1540     }
1541 
1542     /**
1543      * @dev Destroys `tokenId`.
1544      * The approval is cleared when the token is burned.
1545      *
1546      * Requirements:
1547      *
1548      * - `tokenId` must exist.
1549      *
1550      * Emits a {Transfer} event.
1551      */
1552     function _burn(uint256 tokenId) internal virtual {
1553         address owner = ERC721.ownerOf(tokenId); // internal owner
1554 
1555         _beforeTokenTransfer(owner, address(0), tokenId);
1556 
1557         // Clear approvals
1558         _approve(address(0), tokenId);
1559 
1560         // Clear metadata (if any)
1561         if (bytes(_tokenURIs[tokenId]).length != 0) {
1562             delete _tokenURIs[tokenId];
1563         }
1564 
1565         _holderTokens[owner].remove(tokenId);
1566 
1567         _tokenOwners.remove(tokenId);
1568 
1569         emit Transfer(owner, address(0), tokenId);
1570     }
1571 
1572     /**
1573      * @dev Transfers `tokenId` from `from` to `to`.
1574      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1575      *
1576      * Requirements:
1577      *
1578      * - `to` cannot be the zero address.
1579      * - `tokenId` token must be owned by `from`.
1580      *
1581      * Emits a {Transfer} event.
1582      */
1583     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1584         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1585         require(to != address(0), "ERC721: transfer to the zero address");
1586 
1587         _beforeTokenTransfer(from, to, tokenId);
1588 
1589         // Clear approvals from the previous owner
1590         _approve(address(0), tokenId);
1591 
1592         _holderTokens[from].remove(tokenId);
1593         _holderTokens[to].add(tokenId);
1594 
1595         _tokenOwners.set(tokenId, to);
1596 
1597         emit Transfer(from, to, tokenId);
1598     }
1599 
1600     /**
1601      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1602      *
1603      * Requirements:
1604      *
1605      * - `tokenId` must exist.
1606      */
1607     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1608         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1609         _tokenURIs[tokenId] = _tokenURI;
1610     }
1611 
1612     /**
1613      * @dev Internal function to set the base URI for all token IDs. It is
1614      * automatically added as a prefix to the value returned in {tokenURI},
1615      * or to the token ID if {tokenURI} is empty.
1616      */
1617     function _setBaseURI(string memory baseURI_) internal virtual {
1618         _baseURI = baseURI_;
1619     }
1620 
1621     /**
1622      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1623      * The call is not executed if the target address is not a contract.
1624      *
1625      * @param from address representing the previous owner of the given token ID
1626      * @param to target address that will receive the tokens
1627      * @param tokenId uint256 ID of the token to be transferred
1628      * @param _data bytes optional data to send along with the call
1629      * @return bool whether the call correctly returned the expected magic value
1630      */
1631     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1632         private returns (bool)
1633     {
1634         if (to.isContract()) {
1635             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1636                 return retval == IERC721Receiver(to).onERC721Received.selector;
1637             } catch (bytes memory reason) {
1638                 if (reason.length == 0) {
1639                     revert("ERC721: transfer to non ERC721Receiver implementer");
1640                 } else {
1641                     // solhint-disable-next-line no-inline-assembly
1642                     assembly {
1643                         revert(add(32, reason), mload(reason))
1644                     }
1645                 }
1646             }
1647         } else {
1648             return true;
1649         }
1650     }
1651 
1652     function _approve(address to, uint256 tokenId) private {
1653         _tokenApprovals[tokenId] = to;
1654         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1655     }
1656 
1657     /**
1658      * @dev Hook that is called before any token transfer. This includes minting
1659      * and burning.
1660      *
1661      * Calling conditions:
1662      *
1663      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1664      * transferred to `to`.
1665      * - When `from` is zero, `tokenId` will be minted for `to`.
1666      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1667      * - `from` cannot be the zero address.
1668      * - `to` cannot be the zero address.
1669      *
1670      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1671      */
1672     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1673 }
1674 
1675 
1676 
1677 // File: http://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol
1678 
1679 
1680 
1681 
1682 pragma solidity ^0.8.0;
1683 
1684 /**
1685  * @dev Contract module which provides a basic access control mechanism, where
1686  * there is an account (an owner) that can be granted exclusive access to
1687  * specific functions.
1688  *
1689  * By default, the owner account will be the one that deploys the contract. This
1690  * can later be changed with {transferOwnership}.
1691  *
1692  * This module is used through inheritance. It will make available the modifier
1693  * `onlyOwner`, which can be applied to your functions to restrict their use to
1694  * the owner.
1695  */
1696 abstract contract Ownable is Context {
1697     address private _owner;
1698 
1699     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1700 
1701     /**
1702      * @dev Initializes the contract setting the deployer as the initial owner.
1703      */
1704     constructor () {
1705         address msgSender = _msgSender();
1706         _owner = msgSender;
1707         emit OwnershipTransferred(address(0), msgSender);
1708     }
1709 
1710     /**
1711      * @dev Returns the address of the current owner.
1712      */
1713     function owner() public view virtual returns (address) {
1714         return _owner;
1715     }
1716 
1717     /**
1718      * @dev Throws if called by any account other than the owner.
1719      */
1720     modifier onlyOwner() {
1721         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1722         _;
1723     }
1724 
1725     /**
1726      * @dev Leaves the contract without owner. It will not be possible to call
1727      * `onlyOwner` functions anymore. Can only be called by the current owner.
1728      *
1729      * NOTE: Renouncing ownership will leave the contract without an owner,
1730      * thereby removing any functionality that is only available to the owner.
1731      */
1732     function renounceOwnership() public virtual onlyOwner {
1733         emit OwnershipTransferred(_owner, address(0));
1734         _owner = address(0);
1735     }
1736 
1737     /**
1738      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1739      * Can only be called by the current owner.
1740      */
1741     function transferOwnership(address newOwner) public virtual onlyOwner {
1742         require(newOwner != address(0), "Ownable: new owner is the zero address");
1743         emit OwnershipTransferred(_owner, newOwner);
1744         _owner = newOwner;
1745     }
1746 }
1747 
1748 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
1749 
1750 
1751 
1752 
1753 pragma solidity ^0.8.0;
1754 
1755 // CAUTION
1756 // This version of SafeMath should only be used with Solidity 0.8 or later,
1757 // because it relies on the compiler's built in overflow checks.
1758 
1759 /**
1760  * @dev Wrappers over Solidity's arithmetic operations.
1761  *
1762  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1763  * now has built in overflow checking.
1764  */
1765 library SafeMath {
1766     /**
1767      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1768      *
1769      * _Available since v3.4._
1770      */
1771     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1772         unchecked {
1773             uint256 c = a + b;
1774             if (c < a) return (false, 0);
1775             return (true, c);
1776         }
1777     }
1778 
1779     /**
1780      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1781      *
1782      * _Available since v3.4._
1783      */
1784     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1785         unchecked {
1786             if (b > a) return (false, 0);
1787             return (true, a - b);
1788         }
1789     }
1790 
1791     /**
1792      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1793      *
1794      * _Available since v3.4._
1795      */
1796     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1797         unchecked {
1798             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1799             // benefit is lost if 'b' is also tested.
1800             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1801             if (a == 0) return (true, 0);
1802             uint256 c = a * b;
1803             if (c / a != b) return (false, 0);
1804             return (true, c);
1805         }
1806     }
1807 
1808     /**
1809      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1810      *
1811      * _Available since v3.4._
1812      */
1813     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1814         unchecked {
1815             if (b == 0) return (false, 0);
1816             return (true, a / b);
1817         }
1818     }
1819 
1820     /**
1821      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1822      *
1823      * _Available since v3.4._
1824      */
1825     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1826         unchecked {
1827             if (b == 0) return (false, 0);
1828             return (true, a % b);
1829         }
1830     }
1831 
1832     /**
1833      * @dev Returns the addition of two unsigned integers, reverting on
1834      * overflow.
1835      *
1836      * Counterpart to Solidity's `+` operator.
1837      *
1838      * Requirements:
1839      *
1840      * - Addition cannot overflow.
1841      */
1842     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1843         return a + b;
1844     }
1845 
1846     /**
1847      * @dev Returns the subtraction of two unsigned integers, reverting on
1848      * overflow (when the result is negative).
1849      *
1850      * Counterpart to Solidity's `-` operator.
1851      *
1852      * Requirements:
1853      *
1854      * - Subtraction cannot overflow.
1855      */
1856     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1857         return a - b;
1858     }
1859 
1860     /**
1861      * @dev Returns the multiplication of two unsigned integers, reverting on
1862      * overflow.
1863      *
1864      * Counterpart to Solidity's `*` operator.
1865      *
1866      * Requirements:
1867      *
1868      * - Multiplication cannot overflow.
1869      */
1870     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1871         return a * b;
1872     }
1873 
1874     /**
1875      * @dev Returns the integer division of two unsigned integers, reverting on
1876      * division by zero. The result is rounded towards zero.
1877      *
1878      * Counterpart to Solidity's `/` operator.
1879      *
1880      * Requirements:
1881      *
1882      * - The divisor cannot be zero.
1883      */
1884     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1885         return a / b;
1886     }
1887 
1888     /**
1889      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1890      * reverting when dividing by zero.
1891      *
1892      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1893      * opcode (which leaves remaining gas untouched) while Solidity uses an
1894      * invalid opcode to revert (consuming all remaining gas).
1895      *
1896      * Requirements:
1897      *
1898      * - The divisor cannot be zero.
1899      */
1900     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1901         return a % b;
1902     }
1903 
1904     /**
1905      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1906      * overflow (when the result is negative).
1907      *
1908      * CAUTION: This function is deprecated because it requires allocating memory for the error
1909      * message unnecessarily. For custom revert reasons use {trySub}.
1910      *
1911      * Counterpart to Solidity's `-` operator.
1912      *
1913      * Requirements:
1914      *
1915      * - Subtraction cannot overflow.
1916      */
1917     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1918         unchecked {
1919             require(b <= a, errorMessage);
1920             return a - b;
1921         }
1922     }
1923 
1924     /**
1925      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1926      * division by zero. The result is rounded towards zero.
1927      *
1928      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1929      * opcode (which leaves remaining gas untouched) while Solidity uses an
1930      * invalid opcode to revert (consuming all remaining gas).
1931      *
1932      * Counterpart to Solidity's `/` operator. Note: this function uses a
1933      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1934      * uses an invalid opcode to revert (consuming all remaining gas).
1935      *
1936      * Requirements:
1937      *
1938      * - The divisor cannot be zero.
1939      */
1940     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1941         unchecked {
1942             require(b > 0, errorMessage);
1943             return a / b;
1944         }
1945     }
1946 
1947     /**
1948      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1949      * reverting with custom message when dividing by zero.
1950      *
1951      * CAUTION: This function is deprecated because it requires allocating memory for the error
1952      * message unnecessarily. For custom revert reasons use {tryMod}.
1953      *
1954      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1955      * opcode (which leaves remaining gas untouched) while Solidity uses an
1956      * invalid opcode to revert (consuming all remaining gas).
1957      *
1958      * Requirements:
1959      *
1960      * - The divisor cannot be zero.
1961      */
1962     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1963         unchecked {
1964             require(b > 0, errorMessage);
1965             return a % b;
1966         }
1967     }
1968 }
1969 
1970 
1971 pragma solidity ^0.8.0;
1972 
1973 
1974 
1975 
1976 
1977 contract FRYCOOKS is ERC721, Ownable {
1978     using SafeMath for uint256;
1979     uint public constant MAX_COOKS = 11112;
1980     bool public hasSaleStarted = false;
1981     
1982     // THE IPFS HASH OF ALL TOKEN DATAS WILL BE ADDED HERE WHEN ALL JABBA FORMS ARE FINALIZED.
1983     string public METADATA_PROVENANCE_HASH = "";
1984     
1985     
1986     constructor() ERC721("FRYCOOKS","FRYCOOK")  {
1987         setBaseURI("https://j48baforms.io/frycook/");
1988     }
1989     
1990 	
1991     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1992         uint256 tokenCount = balanceOf(_owner);
1993         if (tokenCount == 0) {
1994             // Return an empty array
1995             return new uint256[](0);
1996         } else {
1997             uint256[] memory result = new uint256[](tokenCount);
1998             uint256 index;
1999             for (index = 0; index < tokenCount; index++) {
2000                 result[index] = tokenOfOwnerByIndex(_owner, index);
2001             }
2002             return result;
2003         }
2004     }
2005     
2006     function calculatePrice() public view returns (uint256) {
2007         require(hasSaleStarted == true, "SUDOBURGER is not open yet");
2008 
2009         require(totalSupply() < MAX_COOKS, "All FRYCOOKS have been minted!");
2010 
2011         uint currentSupply = totalSupply();
2012         require(currentSupply < MAX_COOKS, "All FRYCOOKS have been minted!");
2013 
2014         return 100000000000000000; //0.1 ETH
2015     }
2016 
2017      function calculatePriceTest(uint _id) public view returns (uint256) {
2018 
2019 
2020         require(_id < MAX_COOKS, "All FRYCOOKS have been minted!");
2021 
2022         return 100000000000000000; //0.1 ETH
2023         
2024     }
2025     
2026    function fryCOOK(uint256 numCooks) public payable {
2027         require(totalSupply() < MAX_COOKS, "All FRYCOOKS have been minted!");
2028         require(numCooks > 0 && numCooks <= 20, "Only 20 FRYCOOKS can be minted at a time");
2029         require(totalSupply().add(numCooks) <= MAX_COOKS, "All FRYCOOKS have been minted!");
2030         require(msg.value >= calculatePrice().mul(numCooks), "Not enough ETH sent in transaction");
2031 
2032         for (uint i = 0; i < numCooks; i++) {
2033             uint mintIndex = totalSupply();
2034             _safeMint(msg.sender, mintIndex);
2035         }
2036 
2037     }
2038 	// AIRDROP FOR ALL J48BAFORMS HOLDERS. FUNCTION IS DESIGNED TO STOP WORKING AFTER AIRDROP. -sd6
2039     function jabbaAIRDROP(address[] memory userAddresses) public onlyOwner {
2040         require(totalSupply() < 985, "Airdrop is done.");
2041         for (uint256 i = 0; i < userAddresses.length; i++) {
2042             uint mintIndex = totalSupply();
2043             _safeMint(userAddresses[i], mintIndex);
2044         }
2045     }
2046     
2047     // ONLYOWNER FUNCTIONS
2048     
2049     function setProvenanceHash(string memory _hash) public onlyOwner {
2050         METADATA_PROVENANCE_HASH = _hash;
2051     }
2052     
2053     function setBaseURI(string memory baseURI) public onlyOwner {
2054         _setBaseURI(baseURI);
2055     }
2056     
2057     function startDrop() public onlyOwner {
2058         hasSaleStarted = true;
2059     }
2060     function pauseDrop() public onlyOwner {
2061         hasSaleStarted = false;
2062     }
2063     
2064     
2065     function withdrawAll() public payable onlyOwner {
2066         require(payable(msg.sender).send(address(this).balance));
2067     }
2068     
2069 
2070 
2071 }