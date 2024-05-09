1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.0;
5 
6 
7 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
8 // ▓▓▀ ▀▓▌▐▓▓▓▓▓▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
9 // ▓▓▓ ▓▓▌▝▚▞▜▓ ▀▀ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
10 // ▓▓▓▄▀▓▌▐▓▌▐▓▄▀▀▀▓▓▓▓▓▓▓▓▓▓▛▀▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
11 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
12 // ▓▓▓▓▓▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
13 // ▓▓▓▓▓▓▓▓▛▀▀▀▄▄▄▄▄▄▄▛▀▀▀▓▓▓▛▀▀▀▓▓▓▙▄▄▄▛▀▀▀▓▓▓▛▀▀▀▙▄▄▄▓▓▓▛▀▀▀▄▄▄▄▄▄▄▛▀▀▀▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
14 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
15 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▀▀▀▜▓▓▓▓▓▓▓▓▓▓▌   ▀▀▀▀▀▀▀▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
16 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓   ▐▓▓▓▓▓▓▓▓▓▓▌          ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
17 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
18 // ▓▓▓▓▓▓▓▓▌   ▀▀▀▀▀▀▀▓▓▓▓▓▓▓▌   ▓▓▓▛▀▀▀▙▄▄▄▓▓▓▙▄▄▄▛▀▀▀▓▓▓▓▓▓▓▀▀▀▀▀▀▀▀▀▀▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
19 // ▓▓▓▓▓▓▓▓▌          ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓          ▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
20 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
21 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
22 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓    ▓▓▓▓▓▓    ▐▓▓▓▓▓▌    ▐▓▓▓      ▐▓▓▓▌    ▐▓▓▓▓▓▌    ▓▓▓▓▓▓▓▌       ▓▓▓    ▓▓▓▓▓▓▓
23 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▌  ▓▓▓▓  ▐▌  ▓▓▓▓▌  ▓  ▐▓▓▓▓▌  ▓▓▓  ▐▓▓▓  ▐▓▓▓▓▌  ▓▓▓▓▓▓▓▓  ▐▓  ▐▓▓▓  ▐▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓
24 // ▓▓▓▓▓▓▓▓▙▄▄▄▓▓▓▓▌  ▓▓▓▓  ▐▌  ▓▓▓▓▌  ▓  ▐▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▌      ▐▓  ▐▓▓▓  ▐▓▓▓▓▓▓    ▓▓▓▓▓▓
25 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓▓▓▓  ▐▌  ▓▓▓▓▌  ▓  ▐▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓   ▓▓▓▓  ▐▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓
26 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌      ▓▓▓▓▓▓    ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓  ▐▓▓▓▓▓▓▓▓▓▓▌    ▓▓▓▓  ▐▓▓▓▓▓  ▐▓▓▓    ▓▓▓▓▓▓▓
27 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
28 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
29 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
30 //
31 //
32 //
33 //
34 //                     oOOOOOOOo °º¤øøøøøø¤º° ooOOOOOOOOOOOOOOoo °º¤øøøøøø¤º° oOOOOOOOo          
35 //                    OOOOOOOOOOOOOooooooooOOOOOOOOOOOOOOOOOOOOOOOOooooooooOOOOOOOOOOOOO         
36 //                    OOOOººººººººººººººººººººººººººººººººººººººººººººººººººººººººººOOOO         
37 //                    oOOO|                                                        |OOOo         
38 //                     oOO|                                                        |OOo          
39 //                    ¤ oO|                                                        |Oo ¤         
40 //                    O¤ O|                              ░░                        |O ¤O           
41 //                    O¤ O|                            ░░░░░░                      |O ¤O           
42 //                    O¤ O|                          ░░░░░░░░░░░░░░░░░░            |O ¤O           
43 //                    O¤ O|                        ░░░░░░░░░░░░░░░░░░░░░░          |O ¤O          
44 //                    ¤ oO|                          ░░░░░░░░░░░░░░░░░░░░░░        |Oo ¤          
45 //                     oOO|                          ░░░░░░░░░░░░░░░░░░░░░░        |OOo          
46 //                    oOOO|          ##            ░░░░░░░░            ░░░░        |OOOo         
47 //                    OOOO|        ##  ##########  ░░░░░░                ░░░░      |OOOO         
48 //                    OOOO|      ##  ##############░░░░░░  SSSS      SSSS▓▓        |OOOO         
49 //                    OOOO|        ##################░░░░  ▓▓//      ▓▓//▓▓        |OOOO         
50 //                    oOOO|        ######        ####░░▓▓                ▓▓        |OOOo         
51 //                     oOO|        ####            ▓▓░░▓▓                ▓▓        |OOo          
52 //                    ¤ oO|        ####SSSS    SSSS▓▓░░▓▓        ▓▓      ▓▓        |Oo ¤          
53 //                    O¤ O|      ▓▓    ▓▓//    ▓▓//▓▓  ▓▓    ▓▓          ▓▓        |O ¤O           
54 //                    O¤ O|      ▓▓▓▓              ▓▓  ▓▓      ▓▓▓▓▓▓    ▓▓        |O ¤O           
55 //                    O¤ O|        ▓▓        ▓▓    ▓▓  ▓▓              ▓▓          |O ¤O           
56 //                    O¤ O|        ▓▓    ▓▓        ▓▓    ▓▓  ▓▓      ▓▓            |O ¤O           
57 //                    ¤ oO|          ▓▓    ▓▓▓▓    ▓▓    ▓▓    ▓▓▓▓▓▓              |Oo ¤          
58 //                     oOO|          ▓▓          ▓▓    ▓▓▓▓▓▓    ▓▓                |OOo          
59 //                    oOOO|        XXXX  ▓▓▓▓▓▓▓▓      ▓▓VVVV▓▓  ▓▓▓▓              |OOOo         
60 //                    OOOOøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøOOOO   
61 //                    OOOOOOOOOOOOOººººººººOOOOOOOOOOOOOOOOOOOOOOOOººººººººOOOOOOOOOOOOO         
62 //                     ºOOOOOOOº ¸,øøøøøøøøø,¸ ººOOOOOOOOOOOOOOºº ¸,øøøøøøø,¸ ºOOOOOOOOº         
63 //                                               _______________                               
64 //                                              |    Sisters    |                                    
65 //                                               ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
66 //
67 //
68 //
69 // WE LIKE THE ART
70 //
71 // outstretched, emerging from a vital organ
72 // behind plum stacks, as a friend once more departs
73 // to go where windswept howlers lie effacing
74 // in the day on outer shells of garden parts
75 // who once was flayed up by effect's inverse
76 // whose face he hides behind in ancient schools
77 // whose windows were too dark for a distiller
78 //
79 // sat on the roof, foretelling lovers' rules
80 // who stars in only one of twin madonnas
81 // the early figures which we left and buried
82 // in distant view, with the ancient wheel spinning
83 //
84 // the golden lady's home while she was married
85 // his hand towards the orb while Moses watches
86 // ethereal nymphs still swirling all around
87 // who all discovered force in northern forests
88 // before the winning city had been crowned
89 // 
90 // with fiery spear
91 // ensemble au voile
92 // with death as third
93 //
94 //
95 // answers on a postcard, read to verify
96 
97 
98 /**
99  * @dev Interface of the ERC165 standard, as defined in the
100  * https://eips.ethereum.org/EIPS/eip-165[EIP].
101  *
102  * Implementers can declare support of contract interfaces, which can then be
103  * queried by others ({ERC165Checker}).
104  *
105  * For an implementation, see {ERC165}.
106  */
107 interface IERC165 {
108     /**
109      * @dev Returns true if this contract implements the interface defined by
110      * `interfaceId`. See the corresponding
111      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
112      * to learn more about how these ids are created.
113      *
114      * This function call must use less than 30 000 gas.
115      */
116     function supportsInterface(bytes4 interfaceId) external view returns (bool);
117 }
118 
119 /**
120  * @dev Library for managing
121  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
122  * types.
123  *
124  * Sets have the following properties:
125  *
126  * - Elements are added, removed, and checked for existence in constant time
127  * (O(1)).
128  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
129  *
130  * ```
131  * contract Example {
132  *     // Add the library methods
133  *     using EnumerableSet for EnumerableSet.AddressSet;
134  *
135  *     // Declare a set state variable
136  *     EnumerableSet.AddressSet private mySet;
137  * }
138  * ```
139  *
140  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
141  * and `uint256` (`UintSet`) are supported.
142  */
143 library EnumerableSet {
144     // To implement this library for multiple types with as little code
145     // repetition as possible, we write it in terms of a generic Set type with
146     // bytes32 values.
147     // The Set implementation uses private functions, and user-facing
148     // implementations (such as AddressSet) are just wrappers around the
149     // underlying Set.
150     // This means that we can only create new EnumerableSets for types that fit
151     // in bytes32.
152 
153     struct Set {
154         // Storage of set values
155         bytes32[] _values;
156 
157         // Position of the value in the `values` array, plus 1 because index 0
158         // means a value is not in the set.
159         mapping (bytes32 => uint256) _indexes;
160     }
161 
162     /**
163      * @dev Add a value to a set. O(1).
164      *
165      * Returns true if the value was added to the set, that is if it was not
166      * already present.
167      */
168     function _add(Set storage set, bytes32 value) private returns (bool) {
169         if (!_contains(set, value)) {
170             set._values.push(value);
171             // The value is stored at length-1, but we add 1 to all indexes
172             // and use 0 as a sentinel value
173             set._indexes[value] = set._values.length;
174             return true;
175         } else {
176             return false;
177         }
178     }
179 
180     /**
181      * @dev Removes a value from a set. O(1).
182      *
183      * Returns true if the value was removed from the set, that is if it was
184      * present.
185      */
186     function _remove(Set storage set, bytes32 value) private returns (bool) {
187         // We read and store the value's index to prevent multiple reads from the same storage slot
188         uint256 valueIndex = set._indexes[value];
189 
190         if (valueIndex != 0) { // Equivalent to contains(set, value)
191             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
192             // the array, and then remove the last element (sometimes called as 'swap and pop').
193             // This modifies the order of the array, as noted in {at}.
194 
195             uint256 toDeleteIndex = valueIndex - 1;
196             uint256 lastIndex = set._values.length - 1;
197 
198             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
199             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
200 
201             bytes32 lastvalue = set._values[lastIndex];
202 
203             // Move the last value to the index where the value to delete is
204             set._values[toDeleteIndex] = lastvalue;
205             // Update the index for the moved value
206             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
207 
208             // Delete the slot where the moved value was stored
209             set._values.pop();
210 
211             // Delete the index for the deleted slot
212             delete set._indexes[value];
213 
214             return true;
215         } else {
216             return false;
217         }
218     }
219 
220     /**
221      * @dev Returns true if the value is in the set. O(1).
222      */
223     function _contains(Set storage set, bytes32 value) private view returns (bool) {
224         return set._indexes[value] != 0;
225     }
226 
227     /**
228      * @dev Returns the number of values on the set. O(1).
229      */
230     function _length(Set storage set) private view returns (uint256) {
231         return set._values.length;
232     }
233 
234    /**
235     * @dev Returns the value stored at position `index` in the set. O(1).
236     *
237     * Note that there are no guarantees on the ordering of values inside the
238     * array, and it may change when more values are added or removed.
239     *
240     * Requirements:
241     *
242     * - `index` must be strictly less than {length}.
243     */
244     function _at(Set storage set, uint256 index) private view returns (bytes32) {
245         require(set._values.length > index, "EnumerableSet: index out of bounds");
246         return set._values[index];
247     }
248 
249     // Bytes32Set
250 
251     struct Bytes32Set {
252         Set _inner;
253     }
254 
255     /**
256      * @dev Add a value to a set. O(1).
257      *
258      * Returns true if the value was added to the set, that is if it was not
259      * already present.
260      */
261     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
262         return _add(set._inner, value);
263     }
264 
265     /**
266      * @dev Removes a value from a set. O(1).
267      *
268      * Returns true if the value was removed from the set, that is if it was
269      * present.
270      */
271     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
272         return _remove(set._inner, value);
273     }
274 
275     /**
276      * @dev Returns true if the value is in the set. O(1).
277      */
278     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
279         return _contains(set._inner, value);
280     }
281 
282     /**
283      * @dev Returns the number of values in the set. O(1).
284      */
285     function length(Bytes32Set storage set) internal view returns (uint256) {
286         return _length(set._inner);
287     }
288 
289    /**
290     * @dev Returns the value stored at position `index` in the set. O(1).
291     *
292     * Note that there are no guarantees on the ordering of values inside the
293     * array, and it may change when more values are added or removed.
294     *
295     * Requirements:
296     *
297     * - `index` must be strictly less than {length}.
298     */
299     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
300         return _at(set._inner, index);
301     }
302 
303     // AddressSet
304 
305     struct AddressSet {
306         Set _inner;
307     }
308 
309     /**
310      * @dev Add a value to a set. O(1).
311      *
312      * Returns true if the value was added to the set, that is if it was not
313      * already present.
314      */
315     function add(AddressSet storage set, address value) internal returns (bool) {
316         return _add(set._inner, bytes32(uint256(uint160(value))));
317     }
318 
319     /**
320      * @dev Removes a value from a set. O(1).
321      *
322      * Returns true if the value was removed from the set, that is if it was
323      * present.
324      */
325     function remove(AddressSet storage set, address value) internal returns (bool) {
326         return _remove(set._inner, bytes32(uint256(uint160(value))));
327     }
328 
329     /**
330      * @dev Returns true if the value is in the set. O(1).
331      */
332     function contains(AddressSet storage set, address value) internal view returns (bool) {
333         return _contains(set._inner, bytes32(uint256(uint160(value))));
334     }
335 
336     /**
337      * @dev Returns the number of values in the set. O(1).
338      */
339     function length(AddressSet storage set) internal view returns (uint256) {
340         return _length(set._inner);
341     }
342 
343    /**
344     * @dev Returns the value stored at position `index` in the set. O(1).
345     *
346     * Note that there are no guarantees on the ordering of values inside the
347     * array, and it may change when more values are added or removed.
348     *
349     * Requirements:
350     *
351     * - `index` must be strictly less than {length}.
352     */
353     function at(AddressSet storage set, uint256 index) internal view returns (address) {
354         return address(uint160(uint256(_at(set._inner, index))));
355     }
356 
357 
358     // UintSet
359 
360     struct UintSet {
361         Set _inner;
362     }
363 
364     /**
365      * @dev Add a value to a set. O(1).
366      *
367      * Returns true if the value was added to the set, that is if it was not
368      * already present.
369      */
370     function add(UintSet storage set, uint256 value) internal returns (bool) {
371         return _add(set._inner, bytes32(value));
372     }
373 
374     /**
375      * @dev Removes a value from a set. O(1).
376      *
377      * Returns true if the value was removed from the set, that is if it was
378      * present.
379      */
380     function remove(UintSet storage set, uint256 value) internal returns (bool) {
381         return _remove(set._inner, bytes32(value));
382     }
383 
384     /**
385      * @dev Returns true if the value is in the set. O(1).
386      */
387     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
388         return _contains(set._inner, bytes32(value));
389     }
390 
391     /**
392      * @dev Returns the number of values on the set. O(1).
393      */
394     function length(UintSet storage set) internal view returns (uint256) {
395         return _length(set._inner);
396     }
397 
398    /**
399     * @dev Returns the value stored at position `index` in the set. O(1).
400     *
401     * Note that there are no guarantees on the ordering of values inside the
402     * array, and it may change when more values are added or removed.
403     *
404     * Requirements:
405     *
406     * - `index` must be strictly less than {length}.
407     */
408     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
409         return uint256(_at(set._inner, index));
410     }
411 }
412 
413 /**
414  * @dev Contract module that helps prevent reentrant calls to a function.
415  *
416  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
417  * available, which can be applied to functions to make sure there are no nested
418  * (reentrant) calls to them.
419  *
420  * Note that because there is a single `nonReentrant` guard, functions marked as
421  * `nonReentrant` may not call one another. This can be worked around by making
422  * those functions `private`, and then adding `external` `nonReentrant` entry
423  * points to them.
424  *
425  * TIP: If you would like to learn more about reentrancy and alternative ways
426  * to protect against it, check out our blog post
427  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
428  */
429 abstract contract ReentrancyGuard {
430     // Booleans are more expensive than uint256 or any type that takes up a full
431     // word because each write operation emits an extra SLOAD to first read the
432     // slot's contents, replace the bits taken up by the boolean, and then write
433     // back. This is the compiler's defense against contract upgrades and
434     // pointer aliasing, and it cannot be disabled.
435 
436     // The values being non-zero value makes deployment a bit more expensive,
437     // but in exchange the refund on every call to nonReentrant will be lower in
438     // amount. Since refunds are capped to a percentage of the total
439     // transaction's gas, it is best to keep them low in cases like this one, to
440     // increase the likelihood of the full refund coming into effect.
441     uint256 private constant _NOT_ENTERED = 1;
442     uint256 private constant _ENTERED = 2;
443 
444     uint256 private _status;
445 
446     constructor () {
447         _status = _NOT_ENTERED;
448     }
449 
450     /**
451      * @dev Prevents a contract from calling itself, directly or indirectly.
452      * Calling a `nonReentrant` function from another `nonReentrant`
453      * function is not supported. It is possible to prevent this from happening
454      * by making the `nonReentrant` function external, and make it call a
455      * `private` function that does the actual work.
456      */
457     modifier nonReentrant() {
458         // On the first call to nonReentrant, _notEntered will be true
459         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
460 
461         // Any calls to nonReentrant after this point will fail
462         _status = _ENTERED;
463 
464         _;
465 
466         // By storing the original value once again, a refund is triggered (see
467         // https://eips.ethereum.org/EIPS/eip-2200)
468         _status = _NOT_ENTERED;
469     }
470 }
471 
472 
473 /**
474  * @dev Collection of functions related to the address type
475  */
476 library AddressUpgradeable {
477     /**
478      * @dev Returns true if `account` is a contract.
479      *
480      * [IMPORTANT]
481      * ====
482      * It is unsafe to assume that an address for which this function returns
483      * false is an externally-owned account (EOA) and not a contract.
484      *
485      * Among others, `isContract` will return false for the following
486      * types of addresses:
487      *
488      *  - an externally-owned account
489      *  - a contract in construction
490      *  - an address where a contract will be created
491      *  - an address where a contract lived, but was destroyed
492      * ====
493      */
494     function isContract(address account) internal view returns (bool) {
495         // This method relies on extcodesize, which returns 0 for contracts in
496         // construction, since the code is only stored at the end of the
497         // constructor execution.
498 
499         uint256 size;
500         // solhint-disable-next-line no-inline-assembly
501         assembly { size := extcodesize(account) }
502         return size > 0;
503     }
504 
505     /**
506      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
507      * `recipient`, forwarding all available gas and reverting on errors.
508      *
509      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
510      * of certain opcodes, possibly making contracts go over the 2300 gas limit
511      * imposed by `transfer`, making them unable to receive funds via
512      * `transfer`. {sendValue} removes this limitation.
513      *
514      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
515      *
516      * IMPORTANT: because control is transferred to `recipient`, care must be
517      * taken to not create reentrancy vulnerabilities. Consider using
518      * {ReentrancyGuard} or the
519      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
520      */
521     function sendValue(address payable recipient, uint256 amount) internal {
522         require(address(this).balance >= amount, "Address: insufficient balance");
523 
524         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
525         (bool success, ) = recipient.call{ value: amount }("");
526         require(success, "Address: unable to send value, recipient may have reverted");
527     }
528 
529     /**
530      * @dev Performs a Solidity function call using a low level `call`. A
531      * plain`call` is an unsafe replacement for a function call: use this
532      * function instead.
533      *
534      * If `target` reverts with a revert reason, it is bubbled up by this
535      * function (like regular Solidity function calls).
536      *
537      * Returns the raw returned data. To convert to the expected return value,
538      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
539      *
540      * Requirements:
541      *
542      * - `target` must be a contract.
543      * - calling `target` with `data` must not revert.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
548       return functionCall(target, data, "Address: low-level call failed");
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
553      * `errorMessage` as a fallback revert reason when `target` reverts.
554      *
555      * _Available since v3.1._
556      */
557     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
558         return functionCallWithValue(target, data, 0, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but also transferring `value` wei to `target`.
564      *
565      * Requirements:
566      *
567      * - the calling contract must have an ETH balance of at least `value`.
568      * - the called Solidity function must be `payable`.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
573         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
578      * with `errorMessage` as a fallback revert reason when `target` reverts.
579      *
580      * _Available since v3.1._
581      */
582     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
583         require(address(this).balance >= value, "Address: insufficient balance for call");
584         require(isContract(target), "Address: call to non-contract");
585 
586         // solhint-disable-next-line avoid-low-level-calls
587         (bool success, bytes memory returndata) = target.call{ value: value }(data);
588         return _verifyCallResult(success, returndata, errorMessage);
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
598         return functionStaticCall(target, data, "Address: low-level static call failed");
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
603      * but performing a static call.
604      *
605      * _Available since v3.3._
606      */
607     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
608         require(isContract(target), "Address: static call to non-contract");
609 
610         // solhint-disable-next-line avoid-low-level-calls
611         (bool success, bytes memory returndata) = target.staticcall(data);
612         return _verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
616         if (success) {
617             return returndata;
618         } else {
619             // Look for revert reason and bubble it up if present
620             if (returndata.length > 0) {
621                 // The easiest way to bubble the revert reason is using memory via assembly
622 
623                 // solhint-disable-next-line no-inline-assembly
624                 assembly {
625                     let returndata_size := mload(returndata)
626                     revert(add(32, returndata), returndata_size)
627                 }
628             } else {
629                 revert(errorMessage);
630             }
631         }
632     }
633 }
634 /**
635  * @dev Collection of functions related to the address type
636  */
637 library Address {
638     /**
639      * @dev Returns true if `account` is a contract.
640      *
641      * [IMPORTANT]
642      * ====
643      * It is unsafe to assume that an address for which this function returns
644      * false is an externally-owned account (EOA) and not a contract.
645      *
646      * Among others, `isContract` will return false for the following
647      * types of addresses:
648      *
649      *  - an externally-owned account
650      *  - a contract in construction
651      *  - an address where a contract will be created
652      *  - an address where a contract lived, but was destroyed
653      * ====
654      */
655     function isContract(address account) internal view returns (bool) {
656         // This method relies on extcodesize, which returns 0 for contracts in
657         // construction, since the code is only stored at the end of the
658         // constructor execution.
659 
660         uint256 size;
661         // solhint-disable-next-line no-inline-assembly
662         assembly { size := extcodesize(account) }
663         return size > 0;
664     }
665 
666     /**
667      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
668      * `recipient`, forwarding all available gas and reverting on errors.
669      *
670      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
671      * of certain opcodes, possibly making contracts go over the 2300 gas limit
672      * imposed by `transfer`, making them unable to receive funds via
673      * `transfer`. {sendValue} removes this limitation.
674      *
675      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
676      *
677      * IMPORTANT: because control is transferred to `recipient`, care must be
678      * taken to not create reentrancy vulnerabilities. Consider using
679      * {ReentrancyGuard} or the
680      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
681      */
682     function sendValue(address payable recipient, uint256 amount) internal {
683         require(address(this).balance >= amount, "Address: insufficient balance");
684 
685         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
686         (bool success, ) = recipient.call{ value: amount }("");
687         require(success, "Address: unable to send value, recipient may have reverted");
688     }
689 
690     /**
691      * @dev Performs a Solidity function call using a low level `call`. A
692      * plain`call` is an unsafe replacement for a function call: use this
693      * function instead.
694      *
695      * If `target` reverts with a revert reason, it is bubbled up by this
696      * function (like regular Solidity function calls).
697      *
698      * Returns the raw returned data. To convert to the expected return value,
699      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
700      *
701      * Requirements:
702      *
703      * - `target` must be a contract.
704      * - calling `target` with `data` must not revert.
705      *
706      * _Available since v3.1._
707      */
708     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
709       return functionCall(target, data, "Address: low-level call failed");
710     }
711 
712     /**
713      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
714      * `errorMessage` as a fallback revert reason when `target` reverts.
715      *
716      * _Available since v3.1._
717      */
718     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
719         return functionCallWithValue(target, data, 0, errorMessage);
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
724      * but also transferring `value` wei to `target`.
725      *
726      * Requirements:
727      *
728      * - the calling contract must have an ETH balance of at least `value`.
729      * - the called Solidity function must be `payable`.
730      *
731      * _Available since v3.1._
732      */
733     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
734         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
739      * with `errorMessage` as a fallback revert reason when `target` reverts.
740      *
741      * _Available since v3.1._
742      */
743     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
744         require(address(this).balance >= value, "Address: insufficient balance for call");
745         require(isContract(target), "Address: call to non-contract");
746 
747         // solhint-disable-next-line avoid-low-level-calls
748         (bool success, bytes memory returndata) = target.call{ value: value }(data);
749         return _verifyCallResult(success, returndata, errorMessage);
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
754      * but performing a static call.
755      *
756      * _Available since v3.3._
757      */
758     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
759         return functionStaticCall(target, data, "Address: low-level static call failed");
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
764      * but performing a static call.
765      *
766      * _Available since v3.3._
767      */
768     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
769         require(isContract(target), "Address: static call to non-contract");
770 
771         // solhint-disable-next-line avoid-low-level-calls
772         (bool success, bytes memory returndata) = target.staticcall(data);
773         return _verifyCallResult(success, returndata, errorMessage);
774     }
775 
776     /**
777      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
778      * but performing a delegate call.
779      *
780      * _Available since v3.4._
781      */
782     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
783         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
784     }
785 
786     /**
787      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
788      * but performing a delegate call.
789      *
790      * _Available since v3.4._
791      */
792     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
793         require(isContract(target), "Address: delegate call to non-contract");
794 
795         // solhint-disable-next-line avoid-low-level-calls
796         (bool success, bytes memory returndata) = target.delegatecall(data);
797         return _verifyCallResult(success, returndata, errorMessage);
798     }
799 
800     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
801         if (success) {
802             return returndata;
803         } else {
804             // Look for revert reason and bubble it up if present
805             if (returndata.length > 0) {
806                 // The easiest way to bubble the revert reason is using memory via assembly
807 
808                 // solhint-disable-next-line no-inline-assembly
809                 assembly {
810                     let returndata_size := mload(returndata)
811                     revert(add(32, returndata), returndata_size)
812                 }
813             } else {
814                 revert(errorMessage);
815             }
816         }
817     }
818 }
819 
820 /**
821  * @dev Implementation of the {IERC165} interface.
822  *
823  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
824  * for the additional interface id that will be supported. For example:
825  *
826  * ```solidity
827  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
828  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
829  * }
830  * ```
831  *
832  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
833  */
834 abstract contract ERC165 is IERC165 {
835     /**
836      * @dev See {IERC165-supportsInterface}.
837      */
838     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
839         return interfaceId == type(IERC165).interfaceId;
840     }
841 }
842 
843 
844 /**
845  * @dev String operations.
846  */
847 library Strings {
848     bytes16 private constant alphabet = "0123456789abcdef";
849 
850     /**
851      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
852      */
853     function toString(uint256 value) internal pure returns (string memory) {
854         // Inspired by OraclizeAPI's implementation - MIT licence
855         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
856 
857         if (value == 0) {
858             return "0";
859         }
860         uint256 temp = value;
861         uint256 digits;
862         while (temp != 0) {
863             digits++;
864             temp /= 10;
865         }
866         bytes memory buffer = new bytes(digits);
867         while (value != 0) {
868             digits -= 1;
869             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
870             value /= 10;
871         }
872         return string(buffer);
873     }
874 
875     /**
876      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
877      */
878     function toHexString(uint256 value) internal pure returns (string memory) {
879         if (value == 0) {
880             return "0x00";
881         }
882         uint256 temp = value;
883         uint256 length = 0;
884         while (temp != 0) {
885             length++;
886             temp >>= 8;
887         }
888         return toHexString(value, length);
889     }
890 
891     /**
892      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
893      */
894     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
895         bytes memory buffer = new bytes(2 * length + 2);
896         buffer[0] = "0";
897         buffer[1] = "x";
898         for (uint256 i = 2 * length + 1; i > 1; --i) {
899             buffer[i] = alphabet[value & 0xf];
900             value >>= 4;
901         }
902         require(value == 0, "Strings: hex length insufficient");
903         return string(buffer);
904     }
905 
906 }
907 
908 
909 /*
910  * @dev Provides information about the current execution context, including the
911  * sender of the transaction and its data. While these are generally available
912  * via msg.sender and msg.data, they should not be accessed in such a direct
913  * manner, since when dealing with meta-transactions the account sending and
914  * paying for execution may not be the actual sender (as far as an application
915  * is concerned).
916  *
917  * This contract is only required for intermediate, library-like contracts.
918  */
919 abstract contract Context {
920     function _msgSender() internal view virtual returns (address) {
921         return msg.sender;
922     }
923 
924     function _msgData() internal view virtual returns (bytes calldata) {
925         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
926         return msg.data;
927     }
928 }
929 
930 
931 /**
932  * @dev Implement this if you want your extension to have overloadable URI's
933  */
934 interface ICreatorExtensionTokenURI is IERC165 {
935 
936     /**
937      * Get the uri for a given creator/tokenId
938      */
939     function tokenURI(address creator, uint256 tokenId) external view returns (string memory);
940 }
941 
942 /**
943  * @dev Library used to query support of an interface declared via {IERC165}.
944  *
945  * Note that these functions return the actual result of the query: they do not
946  * `revert` if an interface is not supported. It is up to the caller to decide
947  * what to do in these cases.
948  */
949 library ERC165Checker {
950     // As per the EIP-165 spec, no interface should ever match 0xffffffff
951     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
952 
953     /**
954      * @dev Returns true if `account` supports the {IERC165} interface,
955      */
956     function supportsERC165(address account) internal view returns (bool) {
957         // Any contract that implements ERC165 must explicitly indicate support of
958         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
959         return _supportsERC165Interface(account, type(IERC165).interfaceId) &&
960             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
961     }
962 
963     /**
964      * @dev Returns true if `account` supports the interface defined by
965      * `interfaceId`. Support for {IERC165} itself is queried automatically.
966      *
967      * See {IERC165-supportsInterface}.
968      */
969     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
970         // query support of both ERC165 as per the spec and support of _interfaceId
971         return supportsERC165(account) &&
972             _supportsERC165Interface(account, interfaceId);
973     }
974 
975     /**
976      * @dev Returns a boolean array where each value corresponds to the
977      * interfaces passed in and whether they're supported or not. This allows
978      * you to batch check interfaces for a contract where your expectation
979      * is that some interfaces may not be supported.
980      *
981      * See {IERC165-supportsInterface}.
982      *
983      * _Available since v3.4._
984      */
985     function getSupportedInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool[] memory) {
986         // an array of booleans corresponding to interfaceIds and whether they're supported or not
987         bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);
988 
989         // query support of ERC165 itself
990         if (supportsERC165(account)) {
991             // query support of each interface in interfaceIds
992             for (uint256 i = 0; i < interfaceIds.length; i++) {
993                 interfaceIdsSupported[i] = _supportsERC165Interface(account, interfaceIds[i]);
994             }
995         }
996 
997         return interfaceIdsSupported;
998     }
999 
1000     /**
1001      * @dev Returns true if `account` supports all the interfaces defined in
1002      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1003      *
1004      * Batch-querying can lead to gas savings by skipping repeated checks for
1005      * {IERC165} support.
1006      *
1007      * See {IERC165-supportsInterface}.
1008      */
1009     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1010         // query support of ERC165 itself
1011         if (!supportsERC165(account)) {
1012             return false;
1013         }
1014 
1015         // query support of each interface in _interfaceIds
1016         for (uint256 i = 0; i < interfaceIds.length; i++) {
1017             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1018                 return false;
1019             }
1020         }
1021 
1022         // all interfaces supported
1023         return true;
1024     }
1025 
1026     /**
1027      * @notice Query if a contract implements an interface, does not check ERC165 support
1028      * @param account The address of the contract to query for support of an interface
1029      * @param interfaceId The interface identifier, as specified in ERC-165
1030      * @return true if the contract at account indicates support of the interface with
1031      * identifier interfaceId, false otherwise
1032      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1033      * the behavior of this method is undefined. This precondition can be checked
1034      * with {supportsERC165}.
1035      * Interface identification is specified in ERC-165.
1036      */
1037     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1038         bytes memory encodedParams = abi.encodeWithSelector(IERC165(account).supportsInterface.selector, interfaceId);
1039         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1040         if (result.length < 32) return false;
1041         return success && abi.decode(result, (bool));
1042     }
1043 }
1044 
1045 /**
1046  * @dev Core creator interface
1047  */
1048 interface ICreatorCore is IERC165 {
1049 
1050     event ExtensionRegistered(address indexed extension, address indexed sender);
1051     event ExtensionUnregistered(address indexed extension, address indexed sender);
1052     event ExtensionBlacklisted(address indexed extension, address indexed sender);
1053     event MintPermissionsUpdated(address indexed extension, address indexed permissions, address indexed sender);
1054     event RoyaltiesUpdated(uint256 indexed tokenId, address payable[] receivers, uint256[] basisPoints);
1055     event DefaultRoyaltiesUpdated(address payable[] receivers, uint256[] basisPoints);
1056     event ExtensionRoyaltiesUpdated(address indexed extension, address payable[] receivers, uint256[] basisPoints);
1057     event ExtensionApproveTransferUpdated(address indexed extension, bool enabled);
1058 
1059     /**
1060      * @dev gets address of all extensions
1061      */
1062     function getExtensions() external view returns (address[] memory);
1063 
1064     /**
1065      * @dev add an extension.  Can only be called by contract owner or admin.
1066      * extension address must point to a contract implementing ICreatorExtension.
1067      * Returns True if newly added, False if already added.
1068      */
1069     function registerExtension(address extension, string calldata baseURI) external;
1070 
1071     /**
1072      * @dev add an extension.  Can only be called by contract owner or admin.
1073      * extension address must point to a contract implementing ICreatorExtension.
1074      * Returns True if newly added, False if already added.
1075      */
1076     function registerExtension(address extension, string calldata baseURI, bool baseURIIdentical) external;
1077 
1078     /**
1079      * @dev add an extension.  Can only be called by contract owner or admin.
1080      * Returns True if removed, False if already removed.
1081      */
1082     function unregisterExtension(address extension) external;
1083 
1084     /**
1085      * @dev blacklist an extension.  Can only be called by contract owner or admin.
1086      * This function will destroy all ability to reference the metadata of any tokens created
1087      * by the specified extension. It will also unregister the extension if needed.
1088      * Returns True if removed, False if already removed.
1089      */
1090     function blacklistExtension(address extension) external;
1091 
1092     /**
1093      * @dev set the baseTokenURI of an extension.  Can only be called by extension.
1094      */
1095     function setBaseTokenURIExtension(string calldata uri) external;
1096 
1097     /**
1098      * @dev set the baseTokenURI of an extension.  Can only be called by extension.
1099      * For tokens with no uri configured, tokenURI will return "uri+tokenId"
1100      */
1101     function setBaseTokenURIExtension(string calldata uri, bool identical) external;
1102 
1103     /**
1104      * @dev set the common prefix of an extension.  Can only be called by extension.
1105      * If configured, and a token has a uri set, tokenURI will return "prefixURI+tokenURI"
1106      * Useful if you want to use ipfs/arweave
1107      */
1108     function setTokenURIPrefixExtension(string calldata prefix) external;
1109 
1110     /**
1111      * @dev set the tokenURI of a token extension.  Can only be called by extension that minted token.
1112      */
1113     function setTokenURIExtension(uint256 tokenId, string calldata uri) external;
1114 
1115     /**
1116      * @dev set the tokenURI of a token extension for multiple tokens.  Can only be called by extension that minted token.
1117      */
1118     function setTokenURIExtension(uint256[] memory tokenId, string[] calldata uri) external;
1119 
1120     /**
1121      * @dev set the baseTokenURI for tokens with no extension.  Can only be called by owner/admin.
1122      * For tokens with no uri configured, tokenURI will return "uri+tokenId"
1123      */
1124     function setBaseTokenURI(string calldata uri) external;
1125 
1126     /**
1127      * @dev set the common prefix for tokens with no extension.  Can only be called by owner/admin.
1128      * If configured, and a token has a uri set, tokenURI will return "prefixURI+tokenURI"
1129      * Useful if you want to use ipfs/arweave
1130      */
1131     function setTokenURIPrefix(string calldata prefix) external;
1132 
1133     /**
1134      * @dev set the tokenURI of a token with no extension.  Can only be called by owner/admin.
1135      */
1136     function setTokenURI(uint256 tokenId, string calldata uri) external;
1137 
1138     /**
1139      * @dev set the tokenURI of multiple tokens with no extension.  Can only be called by owner/admin.
1140      */
1141     function setTokenURI(uint256[] memory tokenIds, string[] calldata uris) external;
1142 
1143     /**
1144      * @dev set a permissions contract for an extension.  Used to control minting.
1145      */
1146     function setMintPermissions(address extension, address permissions) external;
1147 
1148     /**
1149      * @dev Configure so transfers of tokens created by the caller (must be extension) gets approval
1150      * from the extension before transferring
1151      */
1152     function setApproveTransferExtension(bool enabled) external;
1153 
1154     /**
1155      * @dev get the extension of a given token
1156      */
1157     function tokenExtension(uint256 tokenId) external view returns (address);
1158 
1159     /**
1160      * @dev Set default royalties
1161      */
1162     function setRoyalties(address payable[] calldata receivers, uint256[] calldata basisPoints) external;
1163 
1164     /**
1165      * @dev Set royalties of a token
1166      */
1167     function setRoyalties(uint256 tokenId, address payable[] calldata receivers, uint256[] calldata basisPoints) external;
1168 
1169     /**
1170      * @dev Set royalties of an extension
1171      */
1172     function setRoyaltiesExtension(address extension, address payable[] calldata receivers, uint256[] calldata basisPoints) external;
1173 
1174     /**
1175      * @dev Get royalites of a token.  Returns list of receivers and basisPoints
1176      */
1177     function getRoyalties(uint256 tokenId) external view returns (address payable[] memory, uint256[] memory);
1178     
1179     // Royalty support for various other standards
1180     function getFeeRecipients(uint256 tokenId) external view returns (address payable[] memory);
1181     function getFeeBps(uint256 tokenId) external view returns (uint[] memory);
1182     function getFees(uint256 tokenId) external view returns (address payable[] memory, uint256[] memory);
1183     function royaltyInfo(uint256 tokenId, uint256 value) external view returns (address, uint256);
1184 
1185 }
1186 
1187 
1188 
1189 /**
1190  * @dev Required interface of an ERC721Creator compliant extension contracts.
1191  */
1192 interface IERC721CreatorMintPermissions is IERC165 {
1193 
1194     /**
1195      * @dev get approval to mint
1196      */
1197     function approveMint(address extension, address to, uint256 tokenId) external;
1198 }
1199 
1200 /**
1201  * @dev Your extension is required to implement this interface if it wishes
1202  * to receive the onBurn callback whenever a token the extension created is
1203  * burned
1204  */
1205 interface IERC721CreatorExtensionBurnable is IERC165 {
1206     /**
1207      * @dev callback handler for burn events
1208      */
1209     function onBurn(address owner, uint256 tokenId) external;
1210 }
1211 
1212 /**
1213  * Implement this if you want your extension to approve a transfer
1214  */
1215 interface IERC721CreatorExtensionApproveTransfer is IERC165 {
1216 
1217     /**
1218      * @dev Set whether or not the creator will check the extension for approval of token transfer
1219      */
1220     function setApproveTransfer(address creator, bool enabled) external;
1221 
1222     /**
1223      * @dev Called by creator contract to approve a transfer
1224      */
1225     function approveTransfer(address from, address to, uint256 tokenId) external returns (bool);
1226 }
1227 
1228 /**
1229  * @dev Interface for admin control
1230  */
1231 interface IAdminControl is IERC165 {
1232 
1233     event AdminApproved(address indexed account, address indexed sender);
1234     event AdminRevoked(address indexed account, address indexed sender);
1235 
1236     /**
1237      * @dev gets address of all admins
1238      */
1239     function getAdmins() external view returns (address[] memory);
1240 
1241     /**
1242      * @dev add an admin.  Can only be called by contract owner.
1243      */
1244     function approveAdmin(address admin) external;
1245 
1246     /**
1247      * @dev remove an admin.  Can only be called by contract owner.
1248      */
1249     function revokeAdmin(address admin) external;
1250 
1251     /**
1252      * @dev checks whether or not given address is an admin
1253      * Returns True if they are
1254      */
1255     function isAdmin(address admin) external view returns (bool);
1256 
1257 }
1258 
1259 /**
1260  * @dev Contract module which provides a basic access control mechanism, where
1261  * there is an account (an owner) that can be granted exclusive access to
1262  * specific functions.
1263  *
1264  * By default, the owner account will be the one that deploys the contract. This
1265  * can later be changed with {transferOwnership}.
1266  *
1267  * This module is used through inheritance. It will make available the modifier
1268  * `onlyOwner`, which can be applied to your functions to restrict their use to
1269  * the owner.
1270  */
1271 abstract contract Ownable is Context {
1272     address private _owner;
1273 
1274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1275 
1276     /**
1277      * @dev Initializes the contract setting the deployer as the initial owner.
1278      */
1279     constructor () {
1280         address msgSender = _msgSender();
1281         _owner = msgSender;
1282         emit OwnershipTransferred(address(0), msgSender);
1283     }
1284 
1285     /**
1286      * @dev Returns the address of the current owner.
1287      */
1288     function owner() public view virtual returns (address) {
1289         return _owner;
1290     }
1291 
1292     /**
1293      * @dev Throws if called by any account other than the owner.
1294      */
1295     modifier onlyOwner() {
1296         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1297         _;
1298     }
1299 
1300     /**
1301      * @dev Leaves the contract without owner. It will not be possible to call
1302      * `onlyOwner` functions anymore. Can only be called by the current owner.
1303      *
1304      * NOTE: Renouncing ownership will leave the contract without an owner,
1305      * thereby removing any functionality that is only available to the owner.
1306      */
1307     function renounceOwnership() public virtual onlyOwner {
1308         emit OwnershipTransferred(_owner, address(0));
1309         _owner = address(0);
1310     }
1311 
1312     /**
1313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1314      * Can only be called by the current owner.
1315      */
1316     function transferOwnership(address newOwner) public virtual onlyOwner {
1317         require(newOwner != address(0), "Ownable: new owner is the zero address");
1318         emit OwnershipTransferred(_owner, newOwner);
1319         _owner = newOwner;
1320     }
1321 }
1322 
1323 /**
1324  * @dev Required interface of an ERC721 compliant contract.
1325  */
1326 interface IERC721 is IERC165 {
1327     /**
1328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1329      */
1330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1331 
1332     /**
1333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1334      */
1335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1336 
1337     /**
1338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1339      */
1340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1341 
1342     /**
1343      * @dev Returns the number of tokens in ``owner``'s account.
1344      */
1345     function balanceOf(address owner) external view returns (uint256 balance);
1346 
1347     /**
1348      * @dev Returns the owner of the `tokenId` token.
1349      *
1350      * Requirements:
1351      *
1352      * - `tokenId` must exist.
1353      */
1354     function ownerOf(uint256 tokenId) external view returns (address owner);
1355 
1356     /**
1357      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1358      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1359      *
1360      * Requirements:
1361      *
1362      * - `from` cannot be the zero address.
1363      * - `to` cannot be the zero address.
1364      * - `tokenId` token must exist and be owned by `from`.
1365      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1367      *
1368      * Emits a {Transfer} event.
1369      */
1370     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1371 
1372     /**
1373      * @dev Transfers `tokenId` token from `from` to `to`.
1374      *
1375      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1376      *
1377      * Requirements:
1378      *
1379      * - `from` cannot be the zero address.
1380      * - `to` cannot be the zero address.
1381      * - `tokenId` token must be owned by `from`.
1382      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1383      *
1384      * Emits a {Transfer} event.
1385      */
1386     function transferFrom(address from, address to, uint256 tokenId) external;
1387 
1388     /**
1389      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1390      * The approval is cleared when the token is transferred.
1391      *
1392      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1393      *
1394      * Requirements:
1395      *
1396      * - The caller must own the token or be an approved operator.
1397      * - `tokenId` must exist.
1398      *
1399      * Emits an {Approval} event.
1400      */
1401     function approve(address to, uint256 tokenId) external;
1402 
1403     /**
1404      * @dev Returns the account approved for `tokenId` token.
1405      *
1406      * Requirements:
1407      *
1408      * - `tokenId` must exist.
1409      */
1410     function getApproved(uint256 tokenId) external view returns (address operator);
1411 
1412     /**
1413      * @dev Approve or remove `operator` as an operator for the caller.
1414      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1415      *
1416      * Requirements:
1417      *
1418      * - The `operator` cannot be the caller.
1419      *
1420      * Emits an {ApprovalForAll} event.
1421      */
1422     function setApprovalForAll(address operator, bool _approved) external;
1423 
1424     /**
1425      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1426      *
1427      * See {setApprovalForAll}
1428      */
1429     function isApprovedForAll(address owner, address operator) external view returns (bool);
1430 
1431     /**
1432       * @dev Safely transfers `tokenId` token from `from` to `to`.
1433       *
1434       * Requirements:
1435       *
1436       * - `from` cannot be the zero address.
1437       * - `to` cannot be the zero address.
1438       * - `tokenId` token must exist and be owned by `from`.
1439       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1440       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1441       *
1442       * Emits a {Transfer} event.
1443       */
1444     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1445 }
1446 
1447 abstract contract AdminControl is Ownable, IAdminControl, ERC165 {
1448     using EnumerableSet for EnumerableSet.AddressSet;
1449 
1450     // Track registered admins
1451     EnumerableSet.AddressSet private _admins;
1452 
1453     /**
1454      * @dev See {IERC165-supportsInterface}.
1455      */
1456     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1457         return interfaceId == type(IAdminControl).interfaceId
1458             || super.supportsInterface(interfaceId);
1459     }
1460 
1461     /**
1462      * @dev Only allows approved admins to call the specified function
1463      */
1464     modifier adminRequired() {
1465         require(owner() == msg.sender || _admins.contains(msg.sender), "AdminControl: Must be owner or admin");
1466         _;
1467     }   
1468 
1469     /**
1470      * @dev See {IAdminControl-getAdmins}.
1471      */
1472     function getAdmins() external view override returns (address[] memory admins) {
1473         admins = new address[](_admins.length());
1474         for (uint i = 0; i < _admins.length(); i++) {
1475             admins[i] = _admins.at(i);
1476         }
1477         return admins;
1478     }
1479 
1480     /**
1481      * @dev See {IAdminControl-approveAdmin}.
1482      */
1483     function approveAdmin(address admin) external override onlyOwner {
1484         if (!_admins.contains(admin)) {
1485             emit AdminApproved(admin, msg.sender);
1486             _admins.add(admin);
1487         }
1488     }
1489 
1490     /**
1491      * @dev See {IAdminControl-revokeAdmin}.
1492      */
1493     function revokeAdmin(address admin) external override onlyOwner {
1494         if (_admins.contains(admin)) {
1495             emit AdminRevoked(admin, msg.sender);
1496             _admins.remove(admin);
1497         }
1498     }
1499 
1500     /**
1501      * @dev See {IAdminControl-isAdmin}.
1502      */
1503     function isAdmin(address admin) public override view returns (bool) {
1504         return (owner() == admin || _admins.contains(admin));
1505     }
1506 
1507 }
1508 
1509 /**
1510  * @dev Core creator implementation
1511  */
1512 abstract contract CreatorCore is ReentrancyGuard, ICreatorCore, ERC165 {
1513     using Strings for uint256;
1514     using EnumerableSet for EnumerableSet.AddressSet;
1515     using AddressUpgradeable for address;
1516 
1517     uint256 _tokenCount = 0;
1518 
1519     // Track registered extensions data
1520     EnumerableSet.AddressSet internal _extensions;
1521     EnumerableSet.AddressSet internal _blacklistedExtensions;
1522     mapping (address => address) internal _extensionPermissions;
1523     mapping (address => bool) internal _extensionApproveTransfers;
1524     
1525     // For tracking which extension a token was minted by
1526     mapping (uint256 => address) internal _tokensExtension;
1527 
1528     // The baseURI for a given extension
1529     mapping (address => string) private _extensionBaseURI;
1530     mapping (address => bool) private _extensionBaseURIIdentical;
1531 
1532     // The prefix for any tokens with a uri configured
1533     mapping (address => string) private _extensionURIPrefix;
1534 
1535     // Mapping for individual token URIs
1536     mapping (uint256 => string) internal _tokenURIs;
1537 
1538     
1539     // Royalty configurations
1540     mapping (address => address payable[]) internal _extensionRoyaltyReceivers;
1541     mapping (address => uint256[]) internal _extensionRoyaltyBPS;
1542     mapping (uint256 => address payable[]) internal _tokenRoyaltyReceivers;
1543     mapping (uint256 => uint256[]) internal _tokenRoyaltyBPS;
1544 
1545     /**
1546      * External interface identifiers for royalties
1547      */
1548 
1549     /**
1550      *  @dev CreatorCore
1551      *
1552      *  bytes4(keccak256('getRoyalties(uint256)')) == 0xbb3bafd6
1553      *
1554      *  => 0xbb3bafd6 = 0xbb3bafd6
1555      */
1556     bytes4 private constant _INTERFACE_ID_ROYALTIES_CREATORCORE = 0xbb3bafd6;
1557 
1558     /**
1559      *  @dev Rarible: RoyaltiesV1
1560      *
1561      *  bytes4(keccak256('getFeeRecipients(uint256)')) == 0xb9c4d9fb
1562      *  bytes4(keccak256('getFeeBps(uint256)')) == 0x0ebd4c7f
1563      *
1564      *  => 0xb9c4d9fb ^ 0x0ebd4c7f = 0xb7799584
1565      */
1566     bytes4 private constant _INTERFACE_ID_ROYALTIES_RARIBLE = 0xb7799584;
1567 
1568     /**
1569      *  @dev Foundation
1570      *
1571      *  bytes4(keccak256('getFees(uint256)')) == 0xd5a06d4c
1572      *
1573      *  => 0xd5a06d4c = 0xd5a06d4c
1574      */
1575     bytes4 private constant _INTERFACE_ID_ROYALTIES_FOUNDATION = 0xd5a06d4c;
1576 
1577     /**
1578      *  @dev EIP-2981
1579      *
1580      * bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
1581      *
1582      * => 0x2a55205a = 0x2a55205a
1583      */
1584     bytes4 private constant _INTERFACE_ID_ROYALTIES_EIP2981 = 0x2a55205a;
1585 
1586     /**
1587      * @dev See {IERC165-supportsInterface}.
1588      */
1589     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1590         return interfaceId == type(ICreatorCore).interfaceId || super.supportsInterface(interfaceId)
1591             || interfaceId == _INTERFACE_ID_ROYALTIES_CREATORCORE || interfaceId == _INTERFACE_ID_ROYALTIES_RARIBLE
1592             || interfaceId == _INTERFACE_ID_ROYALTIES_FOUNDATION || interfaceId == _INTERFACE_ID_ROYALTIES_EIP2981;
1593     }
1594 
1595     /**
1596      * @dev Only allows registered extensions to call the specified function
1597      */
1598     modifier extensionRequired() {
1599         require(_extensions.contains(msg.sender), "Must be registered extension");
1600         _;
1601     }
1602 
1603     /**
1604      * @dev Only allows non-blacklisted extensions
1605      */
1606     modifier nonBlacklistRequired(address extension) {
1607         require(!_blacklistedExtensions.contains(extension), "Extension blacklisted");
1608         _;
1609     }   
1610 
1611     /**
1612      * @dev See {ICreatorCore-getExtensions}.
1613      */
1614     function getExtensions() external view override returns (address[] memory extensions) {
1615         extensions = new address[](_extensions.length());
1616         for (uint i = 0; i < _extensions.length(); i++) {
1617             extensions[i] = _extensions.at(i);
1618         }
1619         return extensions;
1620     }
1621 
1622     /**
1623      * @dev Register an extension
1624      */
1625     function _registerExtension(address extension, string calldata baseURI, bool baseURIIdentical) internal {
1626         require(extension != address(this), "Creator: Invalid");
1627         require(extension.isContract(), "Creator: Extension must be a contract");
1628         if (!_extensions.contains(extension)) {
1629             _extensionBaseURI[extension] = baseURI;
1630             _extensionBaseURIIdentical[extension] = baseURIIdentical;
1631             emit ExtensionRegistered(extension, msg.sender);
1632             _extensions.add(extension);
1633         }
1634     }
1635 
1636     /**
1637      * @dev Unregister an extension
1638      */
1639     function _unregisterExtension(address extension) internal {
1640        if (_extensions.contains(extension)) {
1641            emit ExtensionUnregistered(extension, msg.sender);
1642            _extensions.remove(extension);
1643        }
1644     }
1645 
1646     /**
1647      * @dev Blacklist an extension
1648      */
1649     function _blacklistExtension(address extension) internal {
1650        require(extension != address(this), "Cannot blacklist yourself");
1651        if (_extensions.contains(extension)) {
1652            emit ExtensionUnregistered(extension, msg.sender);
1653            _extensions.remove(extension);
1654        }
1655        if (!_blacklistedExtensions.contains(extension)) {
1656            emit ExtensionBlacklisted(extension, msg.sender);
1657            _blacklistedExtensions.add(extension);
1658        }
1659     }
1660 
1661     /**
1662      * @dev Set base token uri for an extension
1663      */
1664     function _setBaseTokenURIExtension(string calldata uri, bool identical) internal {
1665         _extensionBaseURI[msg.sender] = uri;
1666         _extensionBaseURIIdentical[msg.sender] = identical;
1667     }
1668 
1669     /**
1670      * @dev Set token uri prefix for an extension
1671      */
1672     function _setTokenURIPrefixExtension(string calldata prefix) internal {
1673         _extensionURIPrefix[msg.sender] = prefix;
1674     }
1675 
1676     /**
1677      * @dev Set token uri for a token of an extension
1678      */
1679     function _setTokenURIExtension(uint256 tokenId, string calldata uri) internal {
1680         require(_tokensExtension[tokenId] == msg.sender, "Invalid token");
1681         _tokenURIs[tokenId] = uri;
1682     }
1683 
1684     /**
1685      * @dev Set base token uri for tokens with no extension
1686      */
1687     function _setBaseTokenURI(string memory uri) internal {
1688         _extensionBaseURI[address(this)] = uri;
1689     }
1690 
1691     /**
1692      * @dev Set token uri prefix for tokens with no extension
1693      */
1694     function _setTokenURIPrefix(string calldata prefix) internal {
1695         _extensionURIPrefix[address(this)] = prefix;
1696     }
1697 
1698 
1699     /**
1700      * @dev Set token uri for a token with no extension
1701      */
1702     function _setTokenURI(uint256 tokenId, string calldata uri) internal {
1703         require(_tokensExtension[tokenId] == address(this), "Invalid token");
1704         _tokenURIs[tokenId] = uri;
1705     }
1706 
1707     /**
1708      * @dev Retrieve a token's URI
1709      */
1710     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
1711         address extension = _tokensExtension[tokenId];
1712         require(!_blacklistedExtensions.contains(extension), "Extension blacklisted");
1713 
1714         if (bytes(_tokenURIs[tokenId]).length != 0) {
1715             if (bytes(_extensionURIPrefix[extension]).length != 0) {
1716                 return string(abi.encodePacked(_extensionURIPrefix[extension],_tokenURIs[tokenId]));
1717             }
1718             return _tokenURIs[tokenId];
1719         }
1720 
1721         if (ERC165Checker.supportsInterface(extension, type(ICreatorExtensionTokenURI).interfaceId)) {
1722             return ICreatorExtensionTokenURI(extension).tokenURI(address(this), tokenId);
1723         }
1724 
1725         if (!_extensionBaseURIIdentical[extension]) {
1726             return string(abi.encodePacked(_extensionBaseURI[extension], tokenId.toString()));
1727         } else {
1728             return _extensionBaseURI[extension];
1729         }
1730     }
1731 
1732     /**
1733      * Get token extension
1734      */
1735     function _tokenExtension(uint256 tokenId) internal view returns (address extension) {
1736         extension = _tokensExtension[tokenId];
1737 
1738         require(extension != address(this), "No extension for token");
1739         require(!_blacklistedExtensions.contains(extension), "Extension blacklisted");
1740 
1741         return extension;
1742     }
1743 
1744     /**
1745      * Helper to get royalties for a token
1746      */
1747     function _getRoyalties(uint256 tokenId) view internal returns (address payable[] storage, uint256[] storage) {
1748         return (_getRoyaltyReceivers(tokenId), _getRoyaltyBPS(tokenId));
1749     }
1750 
1751     /**
1752      * Helper to get royalty receivers for a token
1753      */
1754     function _getRoyaltyReceivers(uint256 tokenId) view internal returns (address payable[] storage) {
1755         if (_tokenRoyaltyReceivers[tokenId].length > 0) {
1756             return _tokenRoyaltyReceivers[tokenId];
1757         } else if (_extensionRoyaltyReceivers[_tokensExtension[tokenId]].length > 0) {
1758             return _extensionRoyaltyReceivers[_tokensExtension[tokenId]];
1759         }
1760         return _extensionRoyaltyReceivers[address(this)];        
1761     }
1762 
1763     /**
1764      * Helper to get royalty basis points for a token
1765      */
1766     function _getRoyaltyBPS(uint256 tokenId) view internal returns (uint256[] storage) {
1767         if (_tokenRoyaltyBPS[tokenId].length > 0) {
1768             return _tokenRoyaltyBPS[tokenId];
1769         } else if (_extensionRoyaltyBPS[_tokensExtension[tokenId]].length > 0) {
1770             return _extensionRoyaltyBPS[_tokensExtension[tokenId]];
1771         }
1772         return _extensionRoyaltyBPS[address(this)];        
1773     }
1774 
1775     function _getRoyaltyInfo(uint256 tokenId, uint256 value) view internal returns (address receiver, uint256 amount){
1776         address payable[] storage receivers = _getRoyaltyReceivers(tokenId);
1777         require(receivers.length <= 1, "More than 1 royalty receiver");
1778         
1779         if (receivers.length == 0) {
1780             return (address(this), 0);
1781         }
1782         return (receivers[0], _getRoyaltyBPS(tokenId)[0]*value/10000);
1783     }
1784 
1785     /**
1786      * Set royalties for a token
1787      */
1788     function _setRoyalties(uint256 tokenId, address payable[] calldata receivers, uint256[] calldata basisPoints) internal {
1789         require(receivers.length == basisPoints.length, "Invalid input");
1790         uint256 totalBasisPoints;
1791         for (uint i = 0; i < basisPoints.length; i++) {
1792             totalBasisPoints += basisPoints[i];
1793         }
1794         require(totalBasisPoints < 10000, "Invalid total royalties");
1795         _tokenRoyaltyReceivers[tokenId] = receivers;
1796         _tokenRoyaltyBPS[tokenId] = basisPoints;
1797         emit RoyaltiesUpdated(tokenId, receivers, basisPoints);
1798     }
1799 
1800     /**
1801      * Set royalties for all tokens of an extension
1802      */
1803     function _setRoyaltiesExtension(address extension, address payable[] calldata receivers, uint256[] calldata basisPoints) internal {
1804         require(receivers.length == basisPoints.length, "Invalid input");
1805         uint256 totalBasisPoints;
1806         for (uint i = 0; i < basisPoints.length; i++) {
1807             totalBasisPoints += basisPoints[i];
1808         }
1809         require(totalBasisPoints < 10000, "Invalid total royalties");
1810         _extensionRoyaltyReceivers[extension] = receivers;
1811         _extensionRoyaltyBPS[extension] = basisPoints;
1812         if (extension == address(this)) {
1813             emit DefaultRoyaltiesUpdated(receivers, basisPoints);
1814         } else {
1815             emit ExtensionRoyaltiesUpdated(extension, receivers, basisPoints);
1816         }
1817     }
1818 
1819 
1820 }
1821 
1822 /**
1823  * @dev Core ERC721 creator interface
1824  */
1825 interface IERC721CreatorCore is ICreatorCore {
1826 
1827     /**
1828      * @dev mint a token with no extension. Can only be called by an admin.
1829      * Returns tokenId minted
1830      */
1831     function mintBase(address to) external returns (uint256);
1832 
1833     /**
1834      * @dev mint a token with no extension. Can only be called by an admin.
1835      * Returns tokenId minted
1836      */
1837     function mintBase(address to, string calldata uri) external returns (uint256);
1838 
1839     /**
1840      * @dev batch mint a token with no extension. Can only be called by an admin.
1841      * Returns tokenId minted
1842      */
1843     function mintBaseBatch(address to, uint16 count) external returns (uint256[] memory);
1844 
1845     /**
1846      * @dev batch mint a token with no extension. Can only be called by an admin.
1847      * Returns tokenId minted
1848      */
1849     function mintBaseBatch(address to, string[] calldata uris) external returns (uint256[] memory);
1850 
1851     /**
1852      * @dev mint a token. Can only be called by a registered extension.
1853      * Returns tokenId minted
1854      */
1855     function mintExtension(address to) external returns (uint256);
1856 
1857     /**
1858      * @dev mint a token. Can only be called by a registered extension.
1859      * Returns tokenId minted
1860      */
1861     function mintExtension(address to, string calldata uri) external returns (uint256);
1862 
1863     /**
1864      * @dev batch mint a token. Can only be called by a registered extension.
1865      * Returns tokenIds minted
1866      */
1867     function mintExtensionBatch(address to, uint16 count) external returns (uint256[] memory);
1868 
1869     /**
1870      * @dev batch mint a token. Can only be called by a registered extension.
1871      * Returns tokenId minted
1872      */
1873     function mintExtensionBatch(address to, string[] calldata uris) external returns (uint256[] memory);
1874 
1875     /**
1876      * @dev burn a token. Can only be called by token owner or approved address.
1877      * On burn, calls back to the registered extension's onBurn method
1878      */
1879     function burn(uint256 tokenId) external;
1880 
1881 }
1882 
1883 /**
1884  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1885  * @dev See https://eips.ethereum.org/EIPS/eip-721
1886  */
1887 interface IERC721Metadata is IERC721 {
1888 
1889     /**
1890      * @dev Returns the token collection name.
1891      */
1892     function name() external view returns (string memory);
1893 
1894     /**
1895      * @dev Returns the token collection symbol.
1896      */
1897     function symbol() external view returns (string memory);
1898 
1899     /**
1900      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1901      */
1902     function tokenURI(uint256 tokenId) external view returns (string memory);
1903 }
1904 
1905 /**
1906  * @title ERC721 token receiver interface
1907  * @dev Interface for any contract that wants to support safeTransfers
1908  * from ERC721 asset contracts.
1909  */
1910 interface IERC721Receiver {
1911     /**
1912      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1913      * by `operator` from `from`, this function is called.
1914      *
1915      * It must return its Solidity selector to confirm the token transfer.
1916      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1917      *
1918      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1919      */
1920     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1921 }
1922 
1923 /**
1924  * @dev Core ERC721 creator implementation
1925  */
1926 abstract contract ERC721CreatorCore is CreatorCore, IERC721CreatorCore {
1927 
1928     using EnumerableSet for EnumerableSet.AddressSet;
1929 
1930     /**
1931      * @dev See {IERC165-supportsInterface}.
1932      */
1933     function supportsInterface(bytes4 interfaceId) public view virtual override(CreatorCore, IERC165) returns (bool) {
1934         return interfaceId == type(IERC721CreatorCore).interfaceId || super.supportsInterface(interfaceId);
1935     }
1936 
1937     /**
1938      * @dev See {ICreatorCore-setApproveTransferExtension}.
1939      */
1940     function setApproveTransferExtension(bool enabled) external override extensionRequired {
1941         require(!enabled || ERC165Checker.supportsInterface(msg.sender, type(IERC721CreatorExtensionApproveTransfer).interfaceId), "Extension must implement IERC721CreatorExtensionApproveTransfer");
1942         if (_extensionApproveTransfers[msg.sender] != enabled) {
1943             _extensionApproveTransfers[msg.sender] = enabled;
1944             emit ExtensionApproveTransferUpdated(msg.sender, enabled);
1945         }
1946     }
1947 
1948     /**
1949      * @dev Set mint permissions for an extension
1950      */
1951     function _setMintPermissions(address extension, address permissions) internal {
1952         require(_extensions.contains(extension), "CreatorCore: Invalid extension");
1953         require(permissions == address(0x0) || ERC165Checker.supportsInterface(permissions, type(IERC721CreatorMintPermissions).interfaceId), "Invalid address");
1954         if (_extensionPermissions[extension] != permissions) {
1955             _extensionPermissions[extension] = permissions;
1956             emit MintPermissionsUpdated(extension, permissions, msg.sender);
1957         }
1958     }
1959 
1960     /**
1961      * Check if an extension can mint
1962      */
1963     function _checkMintPermissions(address to, uint256 tokenId) internal {
1964         if (_extensionPermissions[msg.sender] != address(0x0)) {
1965             IERC721CreatorMintPermissions(_extensionPermissions[msg.sender]).approveMint(msg.sender, to, tokenId);
1966         }
1967     }
1968 
1969     /**
1970      * Override for post mint actions
1971      */
1972     function _postMintBase(address, uint256) internal virtual {}
1973 
1974     
1975     /**
1976      * Override for post mint actions
1977      */
1978     function _postMintExtension(address, uint256) internal virtual {}
1979 
1980     /**
1981      * Post-burning callback and metadata cleanup
1982      */
1983     function _postBurn(address owner, uint256 tokenId) internal virtual {
1984         // Callback to originating extension if needed
1985         if (_tokensExtension[tokenId] != address(this)) {
1986            if (ERC165Checker.supportsInterface(_tokensExtension[tokenId], type(IERC721CreatorExtensionBurnable).interfaceId)) {
1987                IERC721CreatorExtensionBurnable(_tokensExtension[tokenId]).onBurn(owner, tokenId);
1988            }
1989         }
1990         // Clear metadata (if any)
1991         if (bytes(_tokenURIs[tokenId]).length != 0) {
1992             delete _tokenURIs[tokenId];
1993         }    
1994         // Delete token origin extension tracking
1995         delete _tokensExtension[tokenId];    
1996     }
1997 
1998     /**
1999      * Approve a transfer
2000      */
2001     function _approveTransfer(address from, address to, uint256 tokenId) internal {
2002        if (_extensionApproveTransfers[_tokensExtension[tokenId]]) {
2003            require(IERC721CreatorExtensionApproveTransfer(_tokensExtension[tokenId]).approveTransfer(from, to, tokenId), "ERC721Creator: Extension approval failure");
2004        }
2005     }
2006 
2007 }
2008 
2009 /**
2010  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2011  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2012  * {ERC721Enumerable}.
2013  */
2014 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2015     using Address for address;
2016     using Strings for uint256;
2017 
2018     // Token name
2019     string private _name;
2020 
2021     // Token symbol
2022     string private _symbol;
2023 
2024     // Mapping from token ID to owner address
2025     mapping (uint256 => address) private _owners;
2026 
2027     // Mapping owner address to token count
2028     mapping (address => uint256) private _balances;
2029 
2030     // Mapping from token ID to approved address
2031     mapping (uint256 => address) private _tokenApprovals;
2032 
2033     // Mapping from owner to operator approvals
2034     mapping (address => mapping (address => bool)) private _operatorApprovals;
2035 
2036     /**
2037      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2038      */
2039     constructor (string memory name_, string memory symbol_) {
2040         _name = name_;
2041         _symbol = symbol_;
2042     }
2043 
2044     /**
2045      * @dev See {IERC165-supportsInterface}.
2046      */
2047     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2048         return interfaceId == type(IERC721).interfaceId
2049             || interfaceId == type(IERC721Metadata).interfaceId
2050             || super.supportsInterface(interfaceId);
2051     }
2052 
2053     /**
2054      * @dev See {IERC721-balanceOf}.
2055      */
2056     function balanceOf(address owner) public view virtual override returns (uint256) {
2057         require(owner != address(0), "ERC721: balance query for the zero address");
2058         return _balances[owner];
2059     }
2060 
2061     /**
2062      * @dev See {IERC721-ownerOf}.
2063      */
2064     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2065         address owner = _owners[tokenId];
2066         require(owner != address(0), "ERC721: owner query for nonexistent token");
2067         return owner;
2068     }
2069 
2070     /**
2071      * @dev See {IERC721Metadata-name}.
2072      */
2073     function name() public view virtual override returns (string memory) {
2074         return _name;
2075     }
2076 
2077     /**
2078      * @dev See {IERC721Metadata-symbol}.
2079      */
2080     function symbol() public view virtual override returns (string memory) {
2081         return _symbol;
2082     }
2083 
2084     /**
2085      * @dev See {IERC721Metadata-tokenURI}.
2086      */
2087     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2088         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2089 
2090         string memory baseURI = _baseURI();
2091         return bytes(baseURI).length > 0
2092             ? string(abi.encodePacked(baseURI, tokenId.toString()))
2093             : '';
2094     }
2095 
2096     /**
2097      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
2098      * in child contracts.
2099      */
2100     function _baseURI() internal view virtual returns (string memory) {
2101         return "";
2102     }
2103 
2104     /**
2105      * @dev See {IERC721-approve}.
2106      */
2107     function approve(address to, uint256 tokenId) public virtual override {
2108         address owner = ERC721.ownerOf(tokenId);
2109         require(to != owner, "ERC721: approval to current owner");
2110 
2111         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2112             "ERC721: approve caller is not owner nor approved for all"
2113         );
2114 
2115         _approve(to, tokenId);
2116     }
2117 
2118     /**
2119      * @dev See {IERC721-getApproved}.
2120      */
2121     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2122         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2123 
2124         return _tokenApprovals[tokenId];
2125     }
2126 
2127     /**
2128      * @dev See {IERC721-setApprovalForAll}.
2129      */
2130     function setApprovalForAll(address operator, bool approved) public virtual override {
2131         require(operator != _msgSender(), "ERC721: approve to caller");
2132 
2133         _operatorApprovals[_msgSender()][operator] = approved;
2134         emit ApprovalForAll(_msgSender(), operator, approved);
2135     }
2136 
2137     /**
2138      * @dev See {IERC721-isApprovedForAll}.
2139      */
2140     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2141         return _operatorApprovals[owner][operator];
2142     }
2143 
2144     /**
2145      * @dev See {IERC721-transferFrom}.
2146      */
2147     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
2148         //solhint-disable-next-line max-line-length
2149         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2150 
2151         _transfer(from, to, tokenId);
2152     }
2153 
2154     /**
2155      * @dev See {IERC721-safeTransferFrom}.
2156      */
2157     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
2158         safeTransferFrom(from, to, tokenId, "");
2159     }
2160 
2161     /**
2162      * @dev See {IERC721-safeTransferFrom}.
2163      */
2164     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
2165         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2166         _safeTransfer(from, to, tokenId, _data);
2167     }
2168 
2169     /**
2170      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2171      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2172      *
2173      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2174      *
2175      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2176      * implement alternative mechanisms to perform token transfer, such as signature-based.
2177      *
2178      * Requirements:
2179      *
2180      * - `from` cannot be the zero address.
2181      * - `to` cannot be the zero address.
2182      * - `tokenId` token must exist and be owned by `from`.
2183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2184      *
2185      * Emits a {Transfer} event.
2186      */
2187     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
2188         _transfer(from, to, tokenId);
2189         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2190     }
2191 
2192     /**
2193      * @dev Returns whether `tokenId` exists.
2194      *
2195      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2196      *
2197      * Tokens start existing when they are minted (`_mint`),
2198      * and stop existing when they are burned (`_burn`).
2199      */
2200     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2201         return _owners[tokenId] != address(0);
2202     }
2203 
2204     /**
2205      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2206      *
2207      * Requirements:
2208      *
2209      * - `tokenId` must exist.
2210      */
2211     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2212         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2213         address owner = ERC721.ownerOf(tokenId);
2214         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2215     }
2216 
2217     /**
2218      * @dev Safely mints `tokenId` and transfers it to `to`.
2219      *
2220      * Requirements:
2221      *
2222      * - `tokenId` must not exist.
2223      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2224      *
2225      * Emits a {Transfer} event.
2226      */
2227     function _safeMint(address to, uint256 tokenId) internal virtual {
2228         _safeMint(to, tokenId, "");
2229     }
2230 
2231     /**
2232      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2233      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2234      */
2235     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
2236         _mint(to, tokenId);
2237         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2238     }
2239 
2240     /**
2241      * @dev Mints `tokenId` and transfers it to `to`.
2242      *
2243      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2244      *
2245      * Requirements:
2246      *
2247      * - `tokenId` must not exist.
2248      * - `to` cannot be the zero address.
2249      *
2250      * Emits a {Transfer} event.
2251      */
2252     function _mint(address to, uint256 tokenId) internal virtual {
2253         require(to != address(0), "ERC721: mint to the zero address");
2254         require(!_exists(tokenId), "ERC721: token already minted");
2255 
2256         _beforeTokenTransfer(address(0), to, tokenId);
2257 
2258         _balances[to] += 1;
2259         _owners[tokenId] = to;
2260 
2261         emit Transfer(address(0), to, tokenId);
2262     }
2263 
2264     /**
2265      * @dev Destroys `tokenId`.
2266      * The approval is cleared when the token is burned.
2267      *
2268      * Requirements:
2269      *
2270      * - `tokenId` must exist.
2271      *
2272      * Emits a {Transfer} event.
2273      */
2274     function _burn(uint256 tokenId) internal virtual {
2275         address owner = ERC721.ownerOf(tokenId);
2276 
2277         _beforeTokenTransfer(owner, address(0), tokenId);
2278 
2279         // Clear approvals
2280         _approve(address(0), tokenId);
2281 
2282         _balances[owner] -= 1;
2283         delete _owners[tokenId];
2284 
2285         emit Transfer(owner, address(0), tokenId);
2286     }
2287 
2288     /**
2289      * @dev Transfers `tokenId` from `from` to `to`.
2290      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2291      *
2292      * Requirements:
2293      *
2294      * - `to` cannot be the zero address.
2295      * - `tokenId` token must be owned by `from`.
2296      *
2297      * Emits a {Transfer} event.
2298      */
2299     function _transfer(address from, address to, uint256 tokenId) internal virtual {
2300         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2301         require(to != address(0), "ERC721: transfer to the zero address");
2302 
2303         _beforeTokenTransfer(from, to, tokenId);
2304 
2305         // Clear approvals from the previous owner
2306         _approve(address(0), tokenId);
2307 
2308         _balances[from] -= 1;
2309         _balances[to] += 1;
2310         _owners[tokenId] = to;
2311 
2312         emit Transfer(from, to, tokenId);
2313     }
2314 
2315     /**
2316      * @dev Approve `to` to operate on `tokenId`
2317      *
2318      * Emits a {Approval} event.
2319      */
2320     function _approve(address to, uint256 tokenId) internal virtual {
2321         _tokenApprovals[tokenId] = to;
2322         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2323     }
2324 
2325     /**
2326      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2327      * The call is not executed if the target address is not a contract.
2328      *
2329      * @param from address representing the previous owner of the given token ID
2330      * @param to target address that will receive the tokens
2331      * @param tokenId uint256 ID of the token to be transferred
2332      * @param _data bytes optional data to send along with the call
2333      * @return bool whether the call correctly returned the expected magic value
2334      */
2335     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
2336         private returns (bool)
2337     {
2338         if (to.isContract()) {
2339             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2340                 return retval == IERC721Receiver(to).onERC721Received.selector;
2341             } catch (bytes memory reason) {
2342                 if (reason.length == 0) {
2343                     revert("ERC721: transfer to non ERC721Receiver implementer");
2344                 } else {
2345                     // solhint-disable-next-line no-inline-assembly
2346                     assembly {
2347                         revert(add(32, reason), mload(reason))
2348                     }
2349                 }
2350             }
2351         } else {
2352             return true;
2353         }
2354     }
2355 
2356     /**
2357      * @dev Hook that is called before any token transfer. This includes minting
2358      * and burning.
2359      *
2360      * Calling conditions:
2361      *
2362      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2363      * transferred to `to`.
2364      * - When `from` is zero, `tokenId` will be minted for `to`.
2365      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2366      * - `from` cannot be the zero address.
2367      * - `to` cannot be the zero address.
2368      *
2369      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2370      */
2371     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
2372 }
2373 
2374 /**
2375  * @dev ERC721Creator implementation
2376  */
2377 contract ERC721Creator is AdminControl, ERC721, ERC721CreatorCore {
2378 
2379     constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {
2380     }
2381     
2382     string public arweaveAssetsJSON;
2383     bytes32 public answer = 0x89891b11a799ba288fdbb0082e23fd93e4f50339f69804ccc5272436e759ef89;
2384 
2385     
2386     function verifyAnswer(string memory _answer)
2387     public
2388     view 
2389     returns(bool)
2390     {
2391       return answer == sha256(abi.encodePacked(_answer));
2392     }
2393     
2394     
2395     function setArweaveAssetsJSON(string memory _arweaveAssetsJSON)
2396         public
2397         adminRequired
2398     {
2399         arweaveAssetsJSON = _arweaveAssetsJSON;
2400     }
2401 
2402     /**
2403      * @dev See {IERC165-supportsInterface}.
2404      */
2405     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721CreatorCore, AdminControl) returns (bool) {
2406         return ERC721CreatorCore.supportsInterface(interfaceId) || ERC721.supportsInterface(interfaceId) || AdminControl.supportsInterface(interfaceId);
2407     }
2408 
2409 
2410     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
2411         _approveTransfer(from, to, tokenId);    
2412     }
2413 
2414     /**
2415      * @dev See {ICreatorCore-registerExtension}.
2416      */
2417     function registerExtension(address extension, string calldata baseURI) external override adminRequired nonBlacklistRequired(extension) {
2418         _registerExtension(extension, baseURI, false);
2419     }
2420 
2421     /**
2422      * @dev See {ICreatorCore-registerExtension}.
2423      */
2424     function registerExtension(address extension, string calldata baseURI, bool baseURIIdentical) external override adminRequired nonBlacklistRequired(extension) {
2425         _registerExtension(extension, baseURI, baseURIIdentical);
2426     }
2427 
2428 
2429     /**
2430      * @dev See {ICreatorCore-unregisterExtension}.
2431      */
2432     function unregisterExtension(address extension) external override adminRequired {
2433         _unregisterExtension(extension);
2434     }
2435 
2436     /**
2437      * @dev See {ICreatorCore-blacklistExtension}.
2438      */
2439     function blacklistExtension(address extension) external override adminRequired {
2440         _blacklistExtension(extension);
2441     }
2442 
2443     /**
2444      * @dev See {ICreatorCore-setBaseTokenURIExtension}.
2445      */
2446     function setBaseTokenURIExtension(string calldata uri) external override extensionRequired {
2447         _setBaseTokenURIExtension(uri, false);
2448     }
2449 
2450     /**
2451      * @dev See {ICreatorCore-setBaseTokenURIExtension}.
2452      */
2453     function setBaseTokenURIExtension(string calldata uri, bool identical) external override extensionRequired {
2454         _setBaseTokenURIExtension(uri, identical);
2455     }
2456 
2457     /**
2458      * @dev See {ICreatorCore-setTokenURIPrefixExtension}.
2459      */
2460     function setTokenURIPrefixExtension(string calldata prefix) external override extensionRequired {
2461         _setTokenURIPrefixExtension(prefix);
2462     }
2463 
2464     /**
2465      * @dev See {ICreatorCore-setTokenURIExtension}.
2466      */
2467     function setTokenURIExtension(uint256 tokenId, string calldata uri) external override extensionRequired {
2468         _setTokenURIExtension(tokenId, uri);
2469     }
2470 
2471     /**
2472      * @dev See {ICreatorCore-setTokenURIExtension}.
2473      */
2474     function setTokenURIExtension(uint256[] memory tokenIds, string[] calldata uris) external override extensionRequired {
2475         require(tokenIds.length == uris.length, "Invalid input");
2476         for (uint i = 0; i < tokenIds.length; i++) {
2477             _setTokenURIExtension(tokenIds[i], uris[i]);            
2478         }
2479     }
2480 
2481     /**
2482      * @dev See {ICreatorCore-setBaseTokenURI}.
2483      */
2484     function setBaseTokenURI(string calldata uri) external override adminRequired {
2485         _setBaseTokenURI(uri);
2486     }
2487 
2488     /**
2489      * @dev See {ICreatorCore-setTokenURIPrefix}.
2490      */
2491     function setTokenURIPrefix(string calldata prefix) external override adminRequired {
2492         _setTokenURIPrefix(prefix);
2493     }
2494 
2495     /**
2496      * @dev See {ICreatorCore-setTokenURI}.
2497      */
2498     function setTokenURI(uint256 tokenId, string calldata uri) external override adminRequired {
2499         _setTokenURI(tokenId, uri);
2500     }
2501 
2502     /**
2503      * @dev See {ICreatorCore-setTokenURI}.
2504      */
2505     function setTokenURI(uint256[] memory tokenIds, string[] calldata uris) external override adminRequired {
2506         require(tokenIds.length == uris.length, "Invalid input");
2507         for (uint i = 0; i < tokenIds.length; i++) {
2508             _setTokenURI(tokenIds[i], uris[i]);            
2509         }
2510     }
2511 
2512     /**
2513      * @dev See {ICreatorCore-setMintPermissions}.
2514      */
2515     function setMintPermissions(address extension, address permissions) external override adminRequired {
2516         _setMintPermissions(extension, permissions);
2517     }
2518 
2519     /**
2520      * @dev See {IERC721CreatorCore-mintBase}.
2521      */
2522     function mintBase(address to) public virtual override nonReentrant adminRequired returns(uint256) {
2523         return _mintBase(to, "");
2524     }
2525 
2526     /**
2527      * @dev See {IERC721CreatorCore-mintBase}.
2528      */
2529     function mintBase(address to, string calldata uri) public virtual override nonReentrant adminRequired returns(uint256) {
2530         return _mintBase(to, uri);
2531     }
2532 
2533     /**
2534      * @dev See {IERC721CreatorCore-mintBaseBatch}.
2535      */
2536     function mintBaseBatch(address to, uint16 count) public virtual override nonReentrant adminRequired returns(uint256[] memory tokenIds) {
2537         tokenIds = new uint256[](count);
2538         for (uint16 i = 0; i < count; i++) {
2539             tokenIds[i] = _mintBase(to, "");
2540         }
2541         return tokenIds;
2542     }
2543 
2544     /**
2545      * @dev See {IERC721CreatorCore-mintBaseBatch}.
2546      */
2547     function mintBaseBatch(address to, string[] calldata uris) public virtual override nonReentrant adminRequired returns(uint256[] memory tokenIds) {
2548         tokenIds = new uint256[](uris.length);
2549         for (uint i = 0; i < uris.length; i++) {
2550             tokenIds[i] = _mintBase(to, uris[i]);
2551         }
2552         return tokenIds;
2553     }
2554 
2555     /**
2556      * @dev Mint token with no extension
2557      */
2558     function _mintBase(address to, string memory uri) internal virtual returns(uint256 tokenId) {
2559         _tokenCount++;
2560         tokenId = _tokenCount;
2561 
2562         // Track the extension that minted the token
2563         _tokensExtension[tokenId] = address(this);
2564 
2565         _safeMint(to, tokenId);
2566 
2567         if (bytes(uri).length > 0) {
2568             _tokenURIs[tokenId] = uri;
2569         }
2570 
2571         // Call post mint
2572         _postMintBase(to, tokenId);
2573         return tokenId;
2574     }
2575 
2576 
2577     /**
2578      * @dev See {IERC721CreatorCore-mintExtension}.
2579      */
2580     function mintExtension(address to) public virtual override nonReentrant extensionRequired returns(uint256) {
2581         return _mintExtension(to, "");
2582     }
2583 
2584     /**
2585      * @dev See {IERC721CreatorCore-mintExtension}.
2586      */
2587     function mintExtension(address to, string calldata uri) public virtual override nonReentrant extensionRequired returns(uint256) {
2588         return _mintExtension(to, uri);
2589     }
2590 
2591     /**
2592      * @dev See {IERC721CreatorCore-mintExtensionBatch}.
2593      */
2594     function mintExtensionBatch(address to, uint16 count) public virtual override nonReentrant extensionRequired returns(uint256[] memory tokenIds) {
2595         tokenIds = new uint256[](count);
2596         for (uint16 i = 0; i < count; i++) {
2597             tokenIds[i] = _mintExtension(to, "");
2598         }
2599         return tokenIds;
2600     }
2601 
2602     /**
2603      * @dev See {IERC721CreatorCore-mintExtensionBatch}.
2604      */
2605     function mintExtensionBatch(address to, string[] calldata uris) public virtual override nonReentrant extensionRequired returns(uint256[] memory tokenIds) {
2606         tokenIds = new uint256[](uris.length);
2607         for (uint i = 0; i < uris.length; i++) {
2608             tokenIds[i] = _mintExtension(to, uris[i]);
2609         }
2610     }
2611     
2612     /**
2613      * @dev Mint token via extension
2614      */
2615     function _mintExtension(address to, string memory uri) internal virtual returns(uint256 tokenId) {
2616         _tokenCount++;
2617         tokenId = _tokenCount;
2618 
2619         _checkMintPermissions(to, tokenId);
2620 
2621         // Track the extension that minted the token
2622         _tokensExtension[tokenId] = msg.sender;
2623 
2624         _safeMint(to, tokenId);
2625 
2626         if (bytes(uri).length > 0) {
2627             _tokenURIs[tokenId] = uri;
2628         }
2629         
2630         // Call post mint
2631         _postMintExtension(to, tokenId);
2632         return tokenId;
2633     }
2634 
2635     /**
2636      * @dev See {IERC721CreatorCore-tokenExtension}.
2637      */
2638     function tokenExtension(uint256 tokenId) public view virtual override returns (address) {
2639         require(_exists(tokenId), "Nonexistent token");
2640         return _tokenExtension(tokenId);
2641     }
2642 
2643     /**
2644      * @dev See {IERC721CreatorCore-burn}.
2645      */
2646     function burn(uint256 tokenId) public virtual override nonReentrant {
2647         require(_isApprovedOrOwner(msg.sender, tokenId), "Caller is not owner nor approved");
2648         address owner = ownerOf(tokenId);
2649         _burn(tokenId);
2650         _postBurn(owner, tokenId);
2651     }
2652 
2653     /**
2654      * @dev See {ICreatorCore-setRoyalties}.
2655      */
2656     function setRoyalties(address payable[] calldata receivers, uint256[] calldata basisPoints) external override adminRequired {
2657         _setRoyaltiesExtension(address(this), receivers, basisPoints);
2658     }
2659 
2660     /**
2661      * @dev See {ICreatorCore-setRoyalties}.
2662      */
2663     function setRoyalties(uint256 tokenId, address payable[] calldata receivers, uint256[] calldata basisPoints) external override adminRequired {
2664         require(_exists(tokenId), "Nonexistent token");
2665         _setRoyalties(tokenId, receivers, basisPoints);
2666     }
2667 
2668     /**
2669      * @dev See {ICreatorCore-setRoyaltiesExtension}.
2670      */
2671     function setRoyaltiesExtension(address extension, address payable[] calldata receivers, uint256[] calldata basisPoints) external override adminRequired {
2672         _setRoyaltiesExtension(extension, receivers, basisPoints);
2673     }
2674 
2675     /**
2676      * @dev {See ICreatorCore-getRoyalties}.
2677      */
2678     function getRoyalties(uint256 tokenId) external view virtual override returns (address payable[] memory, uint256[] memory) {
2679         require(_exists(tokenId), "Nonexistent token");
2680         return _getRoyalties(tokenId);
2681     }
2682 
2683     /**
2684      * @dev {See ICreatorCore-getFees}.
2685      */
2686     function getFees(uint256 tokenId) external view virtual override returns (address payable[] memory, uint256[] memory) {
2687         require(_exists(tokenId), "Nonexistent token");
2688         return _getRoyalties(tokenId);
2689     }
2690 
2691     /**
2692      * @dev {See ICreatorCore-getFeeRecipients}.
2693      */
2694     function getFeeRecipients(uint256 tokenId) external view virtual override returns (address payable[] memory) {
2695         require(_exists(tokenId), "Nonexistent token");
2696         return _getRoyaltyReceivers(tokenId);
2697     }
2698 
2699     /**
2700      * @dev {See ICreatorCore-getFeeBps}.
2701      */
2702     function getFeeBps(uint256 tokenId) external view virtual override returns (uint[] memory) {
2703         require(_exists(tokenId), "Nonexistent token");
2704         return _getRoyaltyBPS(tokenId);
2705     }
2706     
2707     /**
2708      * @dev {See ICreatorCore-royaltyInfo}.
2709      */
2710     function royaltyInfo(uint256 tokenId, uint256 value) external view virtual override returns (address, uint256) {
2711         require(_exists(tokenId), "Nonexistent token");
2712         return _getRoyaltyInfo(tokenId, value);
2713     } 
2714 
2715     /**
2716      * @dev See {IERC721Metadata-tokenURI}.
2717      */
2718     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2719         require(_exists(tokenId), "Nonexistent token");
2720         return _tokenURI(tokenId);
2721     }
2722     
2723 }
2724 
2725 contract ThePixelPortraits is ERC721Creator {
2726     constructor() ERC721Creator("The Pixel Portraits", "PXP") {}
2727 }