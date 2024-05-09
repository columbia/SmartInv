1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
3 
4 /*
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣄⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠋⠙⠋⠉⠙⢷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣶⣶⣄⠀⠀⠀⢠⣾⣿⣁⡀⠀⠀⠀⠀⠀⠀⢑⣿⡆⠀⠀⠀⢠⣾⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣾⣦⡀⢠⣾⡿⣛⣛⡻⢷⣄⠀⠀⣴⣾⣿⠛⠻⠦⣄⣴⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠻⢿⣿⣿⣿⣿⣿⢿⣿⣿⣧⢼⣿⣿⣿⠿⣿⣇⢸⡟⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠿⢿⣾⣿⣤⠿⠋⠀⠈⠻⢿⣿⣧⣿⠟⣬⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠃⠀⠀⢀⣴⣖⣶⠀⠀⠀⠀⠀⢀⡈⠀⠀⢘⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣶⣶⣶⠿⠿⠿⠿⠷⠶⠶⠶⠛⠋⠻⣦⣤⣀⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡇⠀⣿⠻⢷⣤⣀⠀⠀⠀⠈⠀⠀⠀⣀⣈⡻⢿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⡿⠛⡏⠁⠂⠘⠭⢿⣒⣒⡒⠒⠒⠊⠉⠁⠀⠀⣿⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠟⠁⡄⠣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡌⠙⠲⣤⣀⠠⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣏⠀⠀⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠋⠀⠀⠀⠀⠈⠙⠚⠓⠶⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣶⣀⡴⠛⢷⣄⣠⣄⡀⠀⠀⠀⠀⠀⠀⠀⠐⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠳⢦⡀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⠴⠾⣿⣿⣿⣿⣿⠟⠛⠿⣿⣦⣄⠙⢻⣿⣷⣦⡤⠤⠶⠒⠛⠁⣠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣆⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⢠⣴⡾⠏⠁⠀⠀⠀⠀⠰⠿⠟⠋⠀⠀⠀⠀⠈⠉⠛⠙⠋⠉⠉⠀⠀⠀⠀⠀⣀⡴⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⡀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⢀⣴⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠒⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⢀⣾⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢉⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡇⠀⠀⠀
22 ⠀⠀⠀⠀⢄⣾⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⢸⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣧⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀
23 ⠀⠀⠀⠀⣼⣋⣧⣶⠀⠀⠀⢀⡀⣀⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⣼⣿⣿⣟⣤⡀⠀⠀⠀⠀⠀⠀⠘⣦⠀⠀
24 ⠀⠀⠀⠀⣿⡟⡇⣿⣤⣤⣴⣼⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢼⣷⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠏⣴⣿⣿⠋⠉⠉⠛⠋⡄⠂⠀⠀⠀⠀⠈⣇⠀
25 ⠀⠀⠀⢀⣿⣷⣜⢿⣿⣿⣿⣿⣿⣿⣟⢿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⠾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠐⠖⣠⣶⣿⣟⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡀
26 ⠀⠀⢀⣾⠋⠻⣿⡶⠍⠙⠛⢿⣿⣿⣿⣮⡙⠿⣿⣶⣤⣄⣀⣤⣤⣤⣤⡀⢀⣈⣁⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇
27 ⠀⠀⣾⠇⠀⠀⠘⢷⡇⠀⠀⠀⢿⣿⣿⣿⣿⣶⣼⣿⣿⣟⣻⣿⣿⣿⣿⡿⠟⠛⠁⠀⠉⠻⢿⣿⣶⣤⣴⣶⣶⣤⣶⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠇
28 ⠀⢸⣿⠀⠀⠀⢠⡞⠀⠀⠀⠀⢾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣋⣠⣀⠀⠀⠀⠀⠀⠀⠀⢉⣛⢻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀
29 ⠀⢸⡏⠀⠀⠀⣼⠁⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⠿⡿⠛⠉⠉⠉⠁⠀⢀⠀⠀⠀⠀⠀⠉⠰⠿⠿⠛⠻⠟⠉⠁⢩⢹⣿⣿⣄⠀⠸⣆⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀
30 ⠀⣿⢿⠀⠀⣰⠇⠀⠀⠀⠀⠀⣿⡟⢻⣿⣿⣿⣿⣿⡟⠻⢶⣤⠀⠀⠀⠀⠀⠀⠀⢸⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⢿⣿⣿⣦⠀⢹⣆⠀⠀⠀⠀⠀⠀⠀⡇⠀
31 ⢀⡟⠺⠀⢐⡿⠀⠀⠀⠀⢀⣼⣿⠁⠀⢻⣿⣿⣿⣿⣿⣷⣤⣿⣤⣤⣤⣤⣶⡄⠀⠀⣿⣇⣤⣤⣀⣀⡀⠀⠀⠀⠀⠀⠈⢿⣷⣿⡾⠁⢿⣿⣷⣿⣿⡷⠀⠀⠀⠀⠀⠀⡇⠀
32 ⢸⡇⠀⠘⣿⡁⠀⠀⢀⣰⣿⣿⠃⠀⠀⠀⢻⣿⣽⠋⠛⢯⢿⣿⠛⠛⠋⠉⠙⠛⠲⣄⠉⠉⠁⠈⠉⠙⠛⠷⣦⣤⣤⣌⠀⠀⢸⡟⠁⠀⠀⠻⣿⣿⣿⣍⠀⠀⠀⠀⠀⠀⢧⠀
33 ⢸⠁⠀⠀⢹⣷⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⢸⣿⢢⠀⠂⠀⣭⣿⡀⠀⠀⠀⠀⠀⠀⢸⡉⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⡿⠀⠀⠀⠀⠀⢹⣿⡿⠉⠀⠀⠀⠀⠀⠀⡾⠀
34 ⠀⠀⠀⠀⠀⠋⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⣼⣏⠈⠁⢰⠀⢨⣿⣧⣀⡀⣠⠀⠀⠀⣸⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⠀⠀⠀⠀⠀⣸⡍⠁⠀⠀⠀⠀⠀⠀⣠⣷⠀
35 ⠀⠀⠀⠀⠀⠀⠙⢿⣿⡇⠀⠀⠀⠀⠀⢠⣿⠟⠇⠀⠈⠑⢦⣿⠿⠿⠿⠿⠶⢀⢀⣸⠿⣶⣦⣠⡖⠀⠀⠀⠀⠀⠀⠀⢀⣿⠀⠀⠀⠀⠀⠀⡿⠀⠀⠀⠀⠀⠀⠀⠀⠘⢻⡆
36 ⠀⠀⠀⠀⠀⠀⠀⠀⣼⡇⠀⠀⠀⠀⠀⣸⡗⠀⠀⠀⠀⠀⠀⠙⠷⡄⣀⠀⠀⠻⠟⠃⠀⠀⠀⠀⠤⠀⠀⠀⠀⠀⠀⠀⣾⡟⠀⠀⠀⠀⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇
37 ⠀⠀⠀⠀⠀⠀⠀⠀⠹⠇⠀⠀⠀⠀⠀⣸⣿⠠⢰⣶⠄⠀⠀⠀⢀⣀⠀⢠⠀⠀⢠⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣙⣿⠁⠀⠀⠀⠀⠀⣸⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠇
38 */
39 
40 
41 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
42 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Library for managing
48  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
49  * types.
50  *
51  * Sets have the following properties:
52  *
53  * - Elements are added, removed, and checked for existence in constant time
54  * (O(1)).
55  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
56  *
57  * ```
58  * contract Example {
59  *     // Add the library methods
60  *     using EnumerableSet for EnumerableSet.AddressSet;
61  *
62  *     // Declare a set state variable
63  *     EnumerableSet.AddressSet private mySet;
64  * }
65  * ```
66  *
67  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
68  * and `uint256` (`UintSet`) are supported.
69  *
70  * [WARNING]
71  * ====
72  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
73  * unusable.
74  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
75  *
76  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
77  * array of EnumerableSet.
78  * ====
79  */
80 library EnumerableSet {
81     // To implement this library for multiple types with as little code
82     // repetition as possible, we write it in terms of a generic Set type with
83     // bytes32 values.
84     // The Set implementation uses private functions, and user-facing
85     // implementations (such as AddressSet) are just wrappers around the
86     // underlying Set.
87     // This means that we can only create new EnumerableSets for types that fit
88     // in bytes32.
89 
90     struct Set {
91         // Storage of set values
92         bytes32[] _values;
93         // Position of the value in the `values` array, plus 1 because index 0
94         // means a value is not in the set.
95         mapping(bytes32 => uint256) _indexes;
96     }
97 
98     /**
99      * @dev Add a value to a set. O(1).
100      *
101      * Returns true if the value was added to the set, that is if it was not
102      * already present.
103      */
104     function _add(Set storage set, bytes32 value) private returns (bool) {
105         if (!_contains(set, value)) {
106             set._values.push(value);
107             // The value is stored at length-1, but we add 1 to all indexes
108             // and use 0 as a sentinel value
109             set._indexes[value] = set._values.length;
110             return true;
111         } else {
112             return false;
113         }
114     }
115 
116     /**
117      * @dev Removes a value from a set. O(1).
118      *
119      * Returns true if the value was removed from the set, that is if it was
120      * present.
121      */
122     function _remove(Set storage set, bytes32 value) private returns (bool) {
123         // We read and store the value's index to prevent multiple reads from the same storage slot
124         uint256 valueIndex = set._indexes[value];
125 
126         if (valueIndex != 0) {
127             // Equivalent to contains(set, value)
128             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
129             // the array, and then remove the last element (sometimes called as 'swap and pop').
130             // This modifies the order of the array, as noted in {at}.
131 
132             uint256 toDeleteIndex = valueIndex - 1;
133             uint256 lastIndex = set._values.length - 1;
134 
135             if (lastIndex != toDeleteIndex) {
136                 bytes32 lastValue = set._values[lastIndex];
137 
138                 // Move the last value to the index where the value to delete is
139                 set._values[toDeleteIndex] = lastValue;
140                 // Update the index for the moved value
141                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
142             }
143 
144             // Delete the slot where the moved value was stored
145             set._values.pop();
146 
147             // Delete the index for the deleted slot
148             delete set._indexes[value];
149 
150             return true;
151         } else {
152             return false;
153         }
154     }
155 
156     /**
157      * @dev Returns true if the value is in the set. O(1).
158      */
159     function _contains(Set storage set, bytes32 value) private view returns (bool) {
160         return set._indexes[value] != 0;
161     }
162 
163     /**
164      * @dev Returns the number of values on the set. O(1).
165      */
166     function _length(Set storage set) private view returns (uint256) {
167         return set._values.length;
168     }
169 
170     /**
171      * @dev Returns the value stored at position `index` in the set. O(1).
172      *
173      * Note that there are no guarantees on the ordering of values inside the
174      * array, and it may change when more values are added or removed.
175      *
176      * Requirements:
177      *
178      * - `index` must be strictly less than {length}.
179      */
180     function _at(Set storage set, uint256 index) private view returns (bytes32) {
181         return set._values[index];
182     }
183 
184     /**
185      * @dev Return the entire set in an array
186      *
187      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
188      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
189      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
190      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
191      */
192     function _values(Set storage set) private view returns (bytes32[] memory) {
193         return set._values;
194     }
195 
196     // Bytes32Set
197 
198     struct Bytes32Set {
199         Set _inner;
200     }
201 
202     /**
203      * @dev Add a value to a set. O(1).
204      *
205      * Returns true if the value was added to the set, that is if it was not
206      * already present.
207      */
208     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
209         return _add(set._inner, value);
210     }
211 
212     /**
213      * @dev Removes a value from a set. O(1).
214      *
215      * Returns true if the value was removed from the set, that is if it was
216      * present.
217      */
218     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
219         return _remove(set._inner, value);
220     }
221 
222     /**
223      * @dev Returns true if the value is in the set. O(1).
224      */
225     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
226         return _contains(set._inner, value);
227     }
228 
229     /**
230      * @dev Returns the number of values in the set. O(1).
231      */
232     function length(Bytes32Set storage set) internal view returns (uint256) {
233         return _length(set._inner);
234     }
235 
236     /**
237      * @dev Returns the value stored at position `index` in the set. O(1).
238      *
239      * Note that there are no guarantees on the ordering of values inside the
240      * array, and it may change when more values are added or removed.
241      *
242      * Requirements:
243      *
244      * - `index` must be strictly less than {length}.
245      */
246     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
247         return _at(set._inner, index);
248     }
249 
250     /**
251      * @dev Return the entire set in an array
252      *
253      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
254      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
255      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
256      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
257      */
258     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
259         bytes32[] memory store = _values(set._inner);
260         bytes32[] memory result;
261 
262         /// @solidity memory-safe-assembly
263         assembly {
264             result := store
265         }
266 
267         return result;
268     }
269 
270     // AddressSet
271 
272     struct AddressSet {
273         Set _inner;
274     }
275 
276     /**
277      * @dev Add a value to a set. O(1).
278      *
279      * Returns true if the value was added to the set, that is if it was not
280      * already present.
281      */
282     function add(AddressSet storage set, address value) internal returns (bool) {
283         return _add(set._inner, bytes32(uint256(uint160(value))));
284     }
285 
286     /**
287      * @dev Removes a value from a set. O(1).
288      *
289      * Returns true if the value was removed from the set, that is if it was
290      * present.
291      */
292     function remove(AddressSet storage set, address value) internal returns (bool) {
293         return _remove(set._inner, bytes32(uint256(uint160(value))));
294     }
295 
296     /**
297      * @dev Returns true if the value is in the set. O(1).
298      */
299     function contains(AddressSet storage set, address value) internal view returns (bool) {
300         return _contains(set._inner, bytes32(uint256(uint160(value))));
301     }
302 
303     /**
304      * @dev Returns the number of values in the set. O(1).
305      */
306     function length(AddressSet storage set) internal view returns (uint256) {
307         return _length(set._inner);
308     }
309 
310     /**
311      * @dev Returns the value stored at position `index` in the set. O(1).
312      *
313      * Note that there are no guarantees on the ordering of values inside the
314      * array, and it may change when more values are added or removed.
315      *
316      * Requirements:
317      *
318      * - `index` must be strictly less than {length}.
319      */
320     function at(AddressSet storage set, uint256 index) internal view returns (address) {
321         return address(uint160(uint256(_at(set._inner, index))));
322     }
323 
324     /**
325      * @dev Return the entire set in an array
326      *
327      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
328      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
329      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
330      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
331      */
332     function values(AddressSet storage set) internal view returns (address[] memory) {
333         bytes32[] memory store = _values(set._inner);
334         address[] memory result;
335 
336         /// @solidity memory-safe-assembly
337         assembly {
338             result := store
339         }
340 
341         return result;
342     }
343 
344     // UintSet
345 
346     struct UintSet {
347         Set _inner;
348     }
349 
350     /**
351      * @dev Add a value to a set. O(1).
352      *
353      * Returns true if the value was added to the set, that is if it was not
354      * already present.
355      */
356     function add(UintSet storage set, uint256 value) internal returns (bool) {
357         return _add(set._inner, bytes32(value));
358     }
359 
360     /**
361      * @dev Removes a value from a set. O(1).
362      *
363      * Returns true if the value was removed from the set, that is if it was
364      * present.
365      */
366     function remove(UintSet storage set, uint256 value) internal returns (bool) {
367         return _remove(set._inner, bytes32(value));
368     }
369 
370     /**
371      * @dev Returns true if the value is in the set. O(1).
372      */
373     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
374         return _contains(set._inner, bytes32(value));
375     }
376 
377     /**
378      * @dev Returns the number of values in the set. O(1).
379      */
380     function length(UintSet storage set) internal view returns (uint256) {
381         return _length(set._inner);
382     }
383 
384     /**
385      * @dev Returns the value stored at position `index` in the set. O(1).
386      *
387      * Note that there are no guarantees on the ordering of values inside the
388      * array, and it may change when more values are added or removed.
389      *
390      * Requirements:
391      *
392      * - `index` must be strictly less than {length}.
393      */
394     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
395         return uint256(_at(set._inner, index));
396     }
397 
398     /**
399      * @dev Return the entire set in an array
400      *
401      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
402      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
403      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
404      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
405      */
406     function values(UintSet storage set) internal view returns (uint256[] memory) {
407         bytes32[] memory store = _values(set._inner);
408         uint256[] memory result;
409 
410         /// @solidity memory-safe-assembly
411         assembly {
412             result := store
413         }
414 
415         return result;
416     }
417 }
418 
419 // File: contracts/IOperatorFilterRegistry.sol
420 
421 
422 pragma solidity ^0.8.13;
423 
424 
425 interface IOperatorFilterRegistry {
426     function isOperatorAllowed(address registrant, address operator) external returns (bool);
427     function register(address registrant) external;
428     function registerAndSubscribe(address registrant, address subscription) external;
429     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
430     function updateOperator(address registrant, address operator, bool filtered) external;
431     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
432     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
433     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
434     function subscribe(address registrant, address registrantToSubscribe) external;
435     function unsubscribe(address registrant, bool copyExistingEntries) external;
436     function subscriptionOf(address addr) external returns (address registrant);
437     function subscribers(address registrant) external returns (address[] memory);
438     function subscriberAt(address registrant, uint256 index) external returns (address);
439     function copyEntriesOf(address registrant, address registrantToCopy) external;
440     function isOperatorFiltered(address registrant, address operator) external returns (bool);
441     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
442     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
443     function filteredOperators(address addr) external returns (address[] memory);
444     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
445     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
446     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
447     function isRegistered(address addr) external returns (bool);
448     function codeHashOf(address addr) external returns (bytes32);
449 }
450 // File: contracts/OperatorFilterer.sol
451 
452 
453 pragma solidity ^0.8.13;
454 
455 
456 contract OperatorFilterer {
457     error OperatorNotAllowed(address operator);
458 
459     IOperatorFilterRegistry constant operatorFilterRegistry =
460         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
461 
462     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
463         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
464         // will not revert, but the contract will need to be registered with the registry once it is deployed in
465         // order for the modifier to filter addresses.
466         if (address(operatorFilterRegistry).code.length > 0) {
467             if (subscribe) {
468                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
469             } else {
470                 if (subscriptionOrRegistrantToCopy != address(0)) {
471                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
472                 } else {
473                     operatorFilterRegistry.register(address(this));
474                 }
475             }
476         }
477     }
478 
479     modifier onlyAllowedOperator() virtual {
480         // Check registry code length to facilitate testing in environments without a deployed registry.
481         if (address(operatorFilterRegistry).code.length > 0) {
482             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
483                 revert OperatorNotAllowed(msg.sender);
484             }
485         }
486         _;
487     }
488 }
489 // File: contracts/DefaultOperatorFilterer.sol
490 
491 
492 pragma solidity ^0.8.13;
493 
494 
495 contract DefaultOperatorFilterer is OperatorFilterer {
496     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
497 
498     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
499 }
500 // File: @openzeppelin/contracts/utils/math/Math.sol
501 
502 
503 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @dev Standard math utilities missing in the Solidity language.
509  */
510 library Math {
511     enum Rounding {
512         Down, // Toward negative infinity
513         Up, // Toward infinity
514         Zero // Toward zero
515     }
516 
517     /**
518      * @dev Returns the largest of two numbers.
519      */
520     function max(uint256 a, uint256 b) internal pure returns (uint256) {
521         return a > b ? a : b;
522     }
523 
524     /**
525      * @dev Returns the smallest of two numbers.
526      */
527     function min(uint256 a, uint256 b) internal pure returns (uint256) {
528         return a < b ? a : b;
529     }
530 
531     /**
532      * @dev Returns the average of two numbers. The result is rounded towards
533      * zero.
534      */
535     function average(uint256 a, uint256 b) internal pure returns (uint256) {
536         // (a + b) / 2 can overflow.
537         return (a & b) + (a ^ b) / 2;
538     }
539 
540     /**
541      * @dev Returns the ceiling of the division of two numbers.
542      *
543      * This differs from standard division with `/` in that it rounds up instead
544      * of rounding down.
545      */
546     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
547         // (a + b - 1) / b can overflow on addition, so we distribute.
548         return a == 0 ? 0 : (a - 1) / b + 1;
549     }
550 
551     /**
552      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
553      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
554      * with further edits by Uniswap Labs also under MIT license.
555      */
556     function mulDiv(
557         uint256 x,
558         uint256 y,
559         uint256 denominator
560     ) internal pure returns (uint256 result) {
561         unchecked {
562             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
563             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
564             // variables such that product = prod1 * 2^256 + prod0.
565             uint256 prod0; // Least significant 256 bits of the product
566             uint256 prod1; // Most significant 256 bits of the product
567             assembly {
568                 let mm := mulmod(x, y, not(0))
569                 prod0 := mul(x, y)
570                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
571             }
572 
573             // Handle non-overflow cases, 256 by 256 division.
574             if (prod1 == 0) {
575                 return prod0 / denominator;
576             }
577 
578             // Make sure the result is less than 2^256. Also prevents denominator == 0.
579             require(denominator > prod1);
580 
581             ///////////////////////////////////////////////
582             // 512 by 256 division.
583             ///////////////////////////////////////////////
584 
585             // Make division exact by subtracting the remainder from [prod1 prod0].
586             uint256 remainder;
587             assembly {
588                 // Compute remainder using mulmod.
589                 remainder := mulmod(x, y, denominator)
590 
591                 // Subtract 256 bit number from 512 bit number.
592                 prod1 := sub(prod1, gt(remainder, prod0))
593                 prod0 := sub(prod0, remainder)
594             }
595 
596             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
597             // See https://cs.stackexchange.com/q/138556/92363.
598 
599             // Does not overflow because the denominator cannot be zero at this stage in the function.
600             uint256 twos = denominator & (~denominator + 1);
601             assembly {
602                 // Divide denominator by twos.
603                 denominator := div(denominator, twos)
604 
605                 // Divide [prod1 prod0] by twos.
606                 prod0 := div(prod0, twos)
607 
608                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
609                 twos := add(div(sub(0, twos), twos), 1)
610             }
611 
612             // Shift in bits from prod1 into prod0.
613             prod0 |= prod1 * twos;
614 
615             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
616             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
617             // four bits. That is, denominator * inv = 1 mod 2^4.
618             uint256 inverse = (3 * denominator) ^ 2;
619 
620             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
621             // in modular arithmetic, doubling the correct bits in each step.
622             inverse *= 2 - denominator * inverse; // inverse mod 2^8
623             inverse *= 2 - denominator * inverse; // inverse mod 2^16
624             inverse *= 2 - denominator * inverse; // inverse mod 2^32
625             inverse *= 2 - denominator * inverse; // inverse mod 2^64
626             inverse *= 2 - denominator * inverse; // inverse mod 2^128
627             inverse *= 2 - denominator * inverse; // inverse mod 2^256
628 
629             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
630             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
631             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
632             // is no longer required.
633             result = prod0 * inverse;
634             return result;
635         }
636     }
637 
638     /**
639      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
640      */
641     function mulDiv(
642         uint256 x,
643         uint256 y,
644         uint256 denominator,
645         Rounding rounding
646     ) internal pure returns (uint256) {
647         uint256 result = mulDiv(x, y, denominator);
648         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
649             result += 1;
650         }
651         return result;
652     }
653 
654     /**
655      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
656      *
657      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
658      */
659     function sqrt(uint256 a) internal pure returns (uint256) {
660         if (a == 0) {
661             return 0;
662         }
663 
664         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
665         //
666         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
667         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
668         //
669         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
670         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
671         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
672         //
673         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
674         uint256 result = 1 << (log2(a) >> 1);
675 
676         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
677         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
678         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
679         // into the expected uint128 result.
680         unchecked {
681             result = (result + a / result) >> 1;
682             result = (result + a / result) >> 1;
683             result = (result + a / result) >> 1;
684             result = (result + a / result) >> 1;
685             result = (result + a / result) >> 1;
686             result = (result + a / result) >> 1;
687             result = (result + a / result) >> 1;
688             return min(result, a / result);
689         }
690     }
691 
692     /**
693      * @notice Calculates sqrt(a), following the selected rounding direction.
694      */
695     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
696         unchecked {
697             uint256 result = sqrt(a);
698             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
699         }
700     }
701 
702     /**
703      * @dev Return the log in base 2, rounded down, of a positive value.
704      * Returns 0 if given 0.
705      */
706     function log2(uint256 value) internal pure returns (uint256) {
707         uint256 result = 0;
708         unchecked {
709             if (value >> 128 > 0) {
710                 value >>= 128;
711                 result += 128;
712             }
713             if (value >> 64 > 0) {
714                 value >>= 64;
715                 result += 64;
716             }
717             if (value >> 32 > 0) {
718                 value >>= 32;
719                 result += 32;
720             }
721             if (value >> 16 > 0) {
722                 value >>= 16;
723                 result += 16;
724             }
725             if (value >> 8 > 0) {
726                 value >>= 8;
727                 result += 8;
728             }
729             if (value >> 4 > 0) {
730                 value >>= 4;
731                 result += 4;
732             }
733             if (value >> 2 > 0) {
734                 value >>= 2;
735                 result += 2;
736             }
737             if (value >> 1 > 0) {
738                 result += 1;
739             }
740         }
741         return result;
742     }
743 
744     /**
745      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
746      * Returns 0 if given 0.
747      */
748     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
749         unchecked {
750             uint256 result = log2(value);
751             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
752         }
753     }
754 
755     /**
756      * @dev Return the log in base 10, rounded down, of a positive value.
757      * Returns 0 if given 0.
758      */
759     function log10(uint256 value) internal pure returns (uint256) {
760         uint256 result = 0;
761         unchecked {
762             if (value >= 10**64) {
763                 value /= 10**64;
764                 result += 64;
765             }
766             if (value >= 10**32) {
767                 value /= 10**32;
768                 result += 32;
769             }
770             if (value >= 10**16) {
771                 value /= 10**16;
772                 result += 16;
773             }
774             if (value >= 10**8) {
775                 value /= 10**8;
776                 result += 8;
777             }
778             if (value >= 10**4) {
779                 value /= 10**4;
780                 result += 4;
781             }
782             if (value >= 10**2) {
783                 value /= 10**2;
784                 result += 2;
785             }
786             if (value >= 10**1) {
787                 result += 1;
788             }
789         }
790         return result;
791     }
792 
793     /**
794      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
795      * Returns 0 if given 0.
796      */
797     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
798         unchecked {
799             uint256 result = log10(value);
800             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
801         }
802     }
803 
804     /**
805      * @dev Return the log in base 256, rounded down, of a positive value.
806      * Returns 0 if given 0.
807      *
808      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
809      */
810     function log256(uint256 value) internal pure returns (uint256) {
811         uint256 result = 0;
812         unchecked {
813             if (value >> 128 > 0) {
814                 value >>= 128;
815                 result += 16;
816             }
817             if (value >> 64 > 0) {
818                 value >>= 64;
819                 result += 8;
820             }
821             if (value >> 32 > 0) {
822                 value >>= 32;
823                 result += 4;
824             }
825             if (value >> 16 > 0) {
826                 value >>= 16;
827                 result += 2;
828             }
829             if (value >> 8 > 0) {
830                 result += 1;
831             }
832         }
833         return result;
834     }
835 
836     /**
837      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
838      * Returns 0 if given 0.
839      */
840     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
841         unchecked {
842             uint256 result = log256(value);
843             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
844         }
845     }
846 }
847 
848 // File: @openzeppelin/contracts/utils/Strings.sol
849 
850 
851 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
852 
853 pragma solidity ^0.8.0;
854 
855 
856 /**
857  * @dev String operations.
858  */
859 library Strings {
860     bytes16 private constant _SYMBOLS = "0123456789abcdef";
861     uint8 private constant _ADDRESS_LENGTH = 20;
862 
863     /**
864      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
865      */
866     function toString(uint256 value) internal pure returns (string memory) {
867         unchecked {
868             uint256 length = Math.log10(value) + 1;
869             string memory buffer = new string(length);
870             uint256 ptr;
871             /// @solidity memory-safe-assembly
872             assembly {
873                 ptr := add(buffer, add(32, length))
874             }
875             while (true) {
876                 ptr--;
877                 /// @solidity memory-safe-assembly
878                 assembly {
879                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
880                 }
881                 value /= 10;
882                 if (value == 0) break;
883             }
884             return buffer;
885         }
886     }
887 
888     /**
889      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
890      */
891     function toHexString(uint256 value) internal pure returns (string memory) {
892         unchecked {
893             return toHexString(value, Math.log256(value) + 1);
894         }
895     }
896 
897     /**
898      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
899      */
900     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
901         bytes memory buffer = new bytes(2 * length + 2);
902         buffer[0] = "0";
903         buffer[1] = "x";
904         for (uint256 i = 2 * length + 1; i > 1; --i) {
905             buffer[i] = _SYMBOLS[value & 0xf];
906             value >>= 4;
907         }
908         require(value == 0, "Strings: hex length insufficient");
909         return string(buffer);
910     }
911 
912     /**
913      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
914      */
915     function toHexString(address addr) internal pure returns (string memory) {
916         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
917     }
918 }
919 
920 // File: @openzeppelin/contracts/utils/Address.sol
921 
922 
923 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
924 
925 pragma solidity ^0.8.1;
926 
927 /**
928  * @dev Collection of functions related to the address type
929  */
930 library Address {
931     /**
932      * @dev Returns true if `account` is a contract.
933      *
934      * [IMPORTANT]
935      * ====
936      * It is unsafe to assume that an address for which this function returns
937      * false is an externally-owned account (EOA) and not a contract.
938      *
939      * Among others, `isContract` will return false for the following
940      * types of addresses:
941      *
942      *  - an externally-owned account
943      *  - a contract in construction
944      *  - an address where a contract will be created
945      *  - an address where a contract lived, but was destroyed
946      * ====
947      *
948      * [IMPORTANT]
949      * ====
950      * You shouldn't rely on `isContract` to protect against flash loan attacks!
951      *
952      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
953      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
954      * constructor.
955      * ====
956      */
957     function isContract(address account) internal view returns (bool) {
958         // This method relies on extcodesize/address.code.length, which returns 0
959         // for contracts in construction, since the code is only stored at the end
960         // of the constructor execution.
961 
962         return account.code.length > 0;
963     }
964 
965     /**
966      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
967      * `recipient`, forwarding all available gas and reverting on errors.
968      *
969      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
970      * of certain opcodes, possibly making contracts go over the 2300 gas limit
971      * imposed by `transfer`, making them unable to receive funds via
972      * `transfer`. {sendValue} removes this limitation.
973      *
974      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
975      *
976      * IMPORTANT: because control is transferred to `recipient`, care must be
977      * taken to not create reentrancy vulnerabilities. Consider using
978      * {ReentrancyGuard} or the
979      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
980      */
981     function sendValue(address payable recipient, uint256 amount) internal {
982         require(address(this).balance >= amount, "Address: insufficient balance");
983 
984         (bool success, ) = recipient.call{value: amount}("");
985         require(success, "Address: unable to send value, recipient may have reverted");
986     }
987 
988     /**
989      * @dev Performs a Solidity function call using a low level `call`. A
990      * plain `call` is an unsafe replacement for a function call: use this
991      * function instead.
992      *
993      * If `target` reverts with a revert reason, it is bubbled up by this
994      * function (like regular Solidity function calls).
995      *
996      * Returns the raw returned data. To convert to the expected return value,
997      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
998      *
999      * Requirements:
1000      *
1001      * - `target` must be a contract.
1002      * - calling `target` with `data` must not revert.
1003      *
1004      * _Available since v3.1._
1005      */
1006     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1007         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1012      * `errorMessage` as a fallback revert reason when `target` reverts.
1013      *
1014      * _Available since v3.1._
1015      */
1016     function functionCall(
1017         address target,
1018         bytes memory data,
1019         string memory errorMessage
1020     ) internal returns (bytes memory) {
1021         return functionCallWithValue(target, data, 0, errorMessage);
1022     }
1023 
1024     /**
1025      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1026      * but also transferring `value` wei to `target`.
1027      *
1028      * Requirements:
1029      *
1030      * - the calling contract must have an ETH balance of at least `value`.
1031      * - the called Solidity function must be `payable`.
1032      *
1033      * _Available since v3.1._
1034      */
1035     function functionCallWithValue(
1036         address target,
1037         bytes memory data,
1038         uint256 value
1039     ) internal returns (bytes memory) {
1040         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1041     }
1042 
1043     /**
1044      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1045      * with `errorMessage` as a fallback revert reason when `target` reverts.
1046      *
1047      * _Available since v3.1._
1048      */
1049     function functionCallWithValue(
1050         address target,
1051         bytes memory data,
1052         uint256 value,
1053         string memory errorMessage
1054     ) internal returns (bytes memory) {
1055         require(address(this).balance >= value, "Address: insufficient balance for call");
1056         (bool success, bytes memory returndata) = target.call{value: value}(data);
1057         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1058     }
1059 
1060     /**
1061      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1062      * but performing a static call.
1063      *
1064      * _Available since v3.3._
1065      */
1066     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1067         return functionStaticCall(target, data, "Address: low-level static call failed");
1068     }
1069 
1070     /**
1071      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1072      * but performing a static call.
1073      *
1074      * _Available since v3.3._
1075      */
1076     function functionStaticCall(
1077         address target,
1078         bytes memory data,
1079         string memory errorMessage
1080     ) internal view returns (bytes memory) {
1081         (bool success, bytes memory returndata) = target.staticcall(data);
1082         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1083     }
1084 
1085     /**
1086      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1087      * but performing a delegate call.
1088      *
1089      * _Available since v3.4._
1090      */
1091     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1092         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1093     }
1094 
1095     /**
1096      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1097      * but performing a delegate call.
1098      *
1099      * _Available since v3.4._
1100      */
1101     function functionDelegateCall(
1102         address target,
1103         bytes memory data,
1104         string memory errorMessage
1105     ) internal returns (bytes memory) {
1106         (bool success, bytes memory returndata) = target.delegatecall(data);
1107         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1108     }
1109 
1110     /**
1111      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1112      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1113      *
1114      * _Available since v4.8._
1115      */
1116     function verifyCallResultFromTarget(
1117         address target,
1118         bool success,
1119         bytes memory returndata,
1120         string memory errorMessage
1121     ) internal view returns (bytes memory) {
1122         if (success) {
1123             if (returndata.length == 0) {
1124                 // only check isContract if the call was successful and the return data is empty
1125                 // otherwise we already know that it was a contract
1126                 require(isContract(target), "Address: call to non-contract");
1127             }
1128             return returndata;
1129         } else {
1130             _revert(returndata, errorMessage);
1131         }
1132     }
1133 
1134     /**
1135      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1136      * revert reason or using the provided one.
1137      *
1138      * _Available since v4.3._
1139      */
1140     function verifyCallResult(
1141         bool success,
1142         bytes memory returndata,
1143         string memory errorMessage
1144     ) internal pure returns (bytes memory) {
1145         if (success) {
1146             return returndata;
1147         } else {
1148             _revert(returndata, errorMessage);
1149         }
1150     }
1151 
1152     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1153         // Look for revert reason and bubble it up if present
1154         if (returndata.length > 0) {
1155             // The easiest way to bubble the revert reason is using memory via assembly
1156             /// @solidity memory-safe-assembly
1157             assembly {
1158                 let returndata_size := mload(returndata)
1159                 revert(add(32, returndata), returndata_size)
1160             }
1161         } else {
1162             revert(errorMessage);
1163         }
1164     }
1165 }
1166 
1167 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1168 
1169 
1170 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 /**
1175  * @title ERC721 token receiver interface
1176  * @dev Interface for any contract that wants to support safeTransfers
1177  * from ERC721 asset contracts.
1178  */
1179 interface IERC721Receiver {
1180     /**
1181      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1182      * by `operator` from `from`, this function is called.
1183      *
1184      * It must return its Solidity selector to confirm the token transfer.
1185      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1186      *
1187      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1188      */
1189     function onERC721Received(
1190         address operator,
1191         address from,
1192         uint256 tokenId,
1193         bytes calldata data
1194     ) external returns (bytes4);
1195 }
1196 
1197 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1198 
1199 
1200 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1201 
1202 pragma solidity ^0.8.0;
1203 
1204 /**
1205  * @dev Interface of the ERC165 standard, as defined in the
1206  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1207  *
1208  * Implementers can declare support of contract interfaces, which can then be
1209  * queried by others ({ERC165Checker}).
1210  *
1211  * For an implementation, see {ERC165}.
1212  */
1213 interface IERC165 {
1214     /**
1215      * @dev Returns true if this contract implements the interface defined by
1216      * `interfaceId`. See the corresponding
1217      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1218      * to learn more about how these ids are created.
1219      *
1220      * This function call must use less than 30 000 gas.
1221      */
1222     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1223 }
1224 
1225 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1226 
1227 
1228 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1229 
1230 pragma solidity ^0.8.0;
1231 
1232 
1233 /**
1234  * @dev Implementation of the {IERC165} interface.
1235  *
1236  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1237  * for the additional interface id that will be supported. For example:
1238  *
1239  * ```solidity
1240  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1241  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1242  * }
1243  * ```
1244  *
1245  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1246  */
1247 abstract contract ERC165 is IERC165 {
1248     /**
1249      * @dev See {IERC165-supportsInterface}.
1250      */
1251     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1252         return interfaceId == type(IERC165).interfaceId;
1253     }
1254 }
1255 
1256 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1257 
1258 
1259 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1260 
1261 pragma solidity ^0.8.0;
1262 
1263 
1264 /**
1265  * @dev Required interface of an ERC721 compliant contract.
1266  */
1267 interface IERC721 is IERC165 {
1268     /**
1269      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1270      */
1271     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1272 
1273     /**
1274      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1275      */
1276     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1277 
1278     /**
1279      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1280      */
1281     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1282 
1283     /**
1284      * @dev Returns the number of tokens in ``owner``'s account.
1285      */
1286     function balanceOf(address owner) external view returns (uint256 balance);
1287 
1288     /**
1289      * @dev Returns the owner of the `tokenId` token.
1290      *
1291      * Requirements:
1292      *
1293      * - `tokenId` must exist.
1294      */
1295     function ownerOf(uint256 tokenId) external view returns (address owner);
1296 
1297     /**
1298      * @dev Safely transfers `tokenId` token from `from` to `to`.
1299      *
1300      * Requirements:
1301      *
1302      * - `from` cannot be the zero address.
1303      * - `to` cannot be the zero address.
1304      * - `tokenId` token must exist and be owned by `from`.
1305      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1306      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function safeTransferFrom(
1311         address from,
1312         address to,
1313         uint256 tokenId,
1314         bytes calldata data
1315     ) external;
1316 
1317     /**
1318      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1319      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1320      *
1321      * Requirements:
1322      *
1323      * - `from` cannot be the zero address.
1324      * - `to` cannot be the zero address.
1325      * - `tokenId` token must exist and be owned by `from`.
1326      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1327      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1328      *
1329      * Emits a {Transfer} event.
1330      */
1331     function safeTransferFrom(
1332         address from,
1333         address to,
1334         uint256 tokenId
1335     ) external;
1336 
1337     /**
1338      * @dev Transfers `tokenId` token from `from` to `to`.
1339      *
1340      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1341      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1342      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1343      *
1344      * Requirements:
1345      *
1346      * - `from` cannot be the zero address.
1347      * - `to` cannot be the zero address.
1348      * - `tokenId` token must be owned by `from`.
1349      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1350      *
1351      * Emits a {Transfer} event.
1352      */
1353     function transferFrom(
1354         address from,
1355         address to,
1356         uint256 tokenId
1357     ) external;
1358 
1359     /**
1360      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1361      * The approval is cleared when the token is transferred.
1362      *
1363      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1364      *
1365      * Requirements:
1366      *
1367      * - The caller must own the token or be an approved operator.
1368      * - `tokenId` must exist.
1369      *
1370      * Emits an {Approval} event.
1371      */
1372     function approve(address to, uint256 tokenId) external;
1373 
1374     /**
1375      * @dev Approve or remove `operator` as an operator for the caller.
1376      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1377      *
1378      * Requirements:
1379      *
1380      * - The `operator` cannot be the caller.
1381      *
1382      * Emits an {ApprovalForAll} event.
1383      */
1384     function setApprovalForAll(address operator, bool _approved) external;
1385 
1386     /**
1387      * @dev Returns the account approved for `tokenId` token.
1388      *
1389      * Requirements:
1390      *
1391      * - `tokenId` must exist.
1392      */
1393     function getApproved(uint256 tokenId) external view returns (address operator);
1394 
1395     /**
1396      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1397      *
1398      * See {setApprovalForAll}
1399      */
1400     function isApprovedForAll(address owner, address operator) external view returns (bool);
1401 }
1402 
1403 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1404 
1405 
1406 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1407 
1408 pragma solidity ^0.8.0;
1409 
1410 
1411 /**
1412  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1413  * @dev See https://eips.ethereum.org/EIPS/eip-721
1414  */
1415 interface IERC721Metadata is IERC721 {
1416     /**
1417      * @dev Returns the token collection name.
1418      */
1419     function name() external view returns (string memory);
1420 
1421     /**
1422      * @dev Returns the token collection symbol.
1423      */
1424     function symbol() external view returns (string memory);
1425 
1426     /**
1427      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1428      */
1429     function tokenURI(uint256 tokenId) external view returns (string memory);
1430 }
1431 
1432 // File: @openzeppelin/contracts/utils/Context.sol
1433 
1434 pragma solidity ^0.8.0;
1435 
1436 
1437 
1438 interface IERC721Enumerable is IERC721 {
1439   
1440     function totalSupply() external view returns (uint256);
1441 
1442 
1443     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1444 
1445 
1446     function tokenByIndex(uint256 index) external view returns (uint256);
1447 }
1448 
1449 pragma solidity ^0.8.0;
1450 
1451 abstract contract ReentrancyGuard {
1452 
1453     uint256 private constant _NOT_ENTERED = 1;
1454     uint256 private constant _ENTERED = 2;
1455 
1456     uint256 private _status;
1457 
1458     constructor() {
1459         _status = _NOT_ENTERED;
1460     }
1461 
1462 
1463     modifier nonReentrant() {
1464         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1465 
1466         _status = _ENTERED;
1467 
1468         _;
1469 
1470         _status = _NOT_ENTERED;
1471     }
1472 }
1473 
1474 
1475 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1476 
1477 pragma solidity ^0.8.0;
1478 
1479 /**
1480  * @dev Provides information about the current execution context, including the
1481  * sender of the transaction and its data. While these are generally available
1482  * via msg.sender and msg.data, they should not be accessed in such a direct
1483  * manner, since when dealing with meta-transactions the account sending and
1484  * paying for execution may not be the actual sender (as far as an application
1485  * is concerned).
1486  *
1487  * This contract is only required for intermediate, library-like contracts.
1488  */
1489 abstract contract Context {
1490     function _msgSender() internal view virtual returns (address) {
1491         return msg.sender;
1492     }
1493 
1494     function _msgData() internal view virtual returns (bytes calldata) {
1495         return msg.data;
1496     }
1497 }
1498 
1499 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1500 
1501 
1502 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1503 
1504 pragma solidity ^0.8.0;
1505 
1506 
1507 
1508 
1509 // File: @openzeppelin/contracts/access/Ownable.sol
1510 
1511 
1512 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1513 
1514 pragma solidity ^0.8.0;
1515 
1516 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, DefaultOperatorFilterer {
1517     using Address for address;
1518     using Strings for uint256;
1519 
1520     struct TokenOwnership {
1521         address addr;
1522         uint64 startTimestamp;
1523     }
1524 
1525     struct AddressData {
1526         uint128 balance;
1527         uint128 numberMinted;
1528     }
1529 
1530     uint256 internal currentIndex;
1531 
1532     string private _name;
1533 
1534     string private _symbol;
1535 
1536     mapping(uint256 => TokenOwnership) internal _ownerships;
1537 
1538     mapping(address => AddressData) private _addressData;
1539 
1540     mapping(uint256 => address) private _tokenApprovals;
1541 
1542     mapping(address => mapping(address => bool)) private _operatorApprovals;
1543 
1544     constructor(string memory name_, string memory symbol_) {
1545         _name = name_;
1546         _symbol = symbol_;
1547     }
1548 
1549     function totalSupply() public view override returns (uint256) {
1550         return currentIndex;
1551     }
1552 
1553     function tokenByIndex(uint256 index) public view override returns (uint256) {
1554         require(index < totalSupply(), "ERC721A: global index out of bounds");
1555         return index;
1556     }
1557 
1558     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1559         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1560         uint256 numMintedSoFar = totalSupply();
1561         uint256 tokenIdsIdx;
1562         address currOwnershipAddr;
1563 
1564         unchecked {
1565             for (uint256 i; i < numMintedSoFar; i++) {
1566                 TokenOwnership memory ownership = _ownerships[i];
1567                 if (ownership.addr != address(0)) {
1568                     currOwnershipAddr = ownership.addr;
1569                 }
1570                 if (currOwnershipAddr == owner) {
1571                     if (tokenIdsIdx == index) {
1572                         return i;
1573                     }
1574                     tokenIdsIdx++;
1575                 }
1576             }
1577         }
1578 
1579         revert("ERC721A: unable to get token of owner by index");
1580     }
1581 
1582 
1583     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1584         return
1585             interfaceId == type(IERC721).interfaceId ||
1586             interfaceId == type(IERC721Metadata).interfaceId ||
1587             interfaceId == type(IERC721Enumerable).interfaceId ||
1588             super.supportsInterface(interfaceId);
1589     }
1590 
1591     function balanceOf(address owner) public view override returns (uint256) {
1592         require(owner != address(0), "ERC721A: balance query for the zero address");
1593         return uint256(_addressData[owner].balance);
1594     }
1595 
1596     function _numberMinted(address owner) internal view returns (uint256) {
1597         require(owner != address(0), "ERC721A: number minted query for the zero address");
1598         return uint256(_addressData[owner].numberMinted);
1599     }
1600 
1601     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1602         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1603 
1604         unchecked {
1605             for (uint256 curr = tokenId; curr >= 0; curr--) {
1606                 TokenOwnership memory ownership = _ownerships[curr];
1607                 if (ownership.addr != address(0)) {
1608                     return ownership;
1609                 }
1610             }
1611         }
1612 
1613         revert("ERC721A: unable to determine the owner of token");
1614     }
1615 
1616     function ownerOf(uint256 tokenId) public view override returns (address) {
1617         return ownershipOf(tokenId).addr;
1618     }
1619 
1620     function name() public view virtual override returns (string memory) {
1621         return _name;
1622     }
1623 
1624     function symbol() public view virtual override returns (string memory) {
1625         return _symbol;
1626     }
1627 
1628     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1629         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1630 
1631         string memory baseURI = _baseURI();
1632         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1633     }
1634 
1635     function _baseURI() internal view virtual returns (string memory) {
1636         return "";
1637     }
1638 
1639     function approve(address to, uint256 tokenId) public override {
1640         address owner = ERC721A.ownerOf(tokenId);
1641         require(to != owner, "ERC721A: approval to current owner");
1642 
1643         require(
1644             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1645             "ERC721A: approve caller is not owner nor approved for all"
1646         );
1647 
1648         _approve(to, tokenId, owner);
1649     }
1650 
1651     function getApproved(uint256 tokenId) public view override returns (address) {
1652         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1653 
1654         return _tokenApprovals[tokenId];
1655     }
1656 
1657     function setApprovalForAll(address operator, bool approved) public override {
1658         require(operator != _msgSender(), "ERC721A: approve to caller");
1659 
1660         _operatorApprovals[_msgSender()][operator] = approved;
1661         emit ApprovalForAll(_msgSender(), operator, approved);
1662     }
1663 
1664     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1665         return _operatorApprovals[owner][operator];
1666     }
1667 
1668    function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
1669         transferFrom(from, to, tokenId);
1670     }
1671 
1672     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
1673         safeTransferFrom(from, to, tokenId);
1674     }
1675 
1676     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1677         public
1678         override
1679         onlyAllowedOperator
1680     {
1681         safeTransferFrom(from, to, tokenId, data);
1682     }
1683 
1684     function _exists(uint256 tokenId) internal view returns (bool) {
1685         return tokenId < currentIndex;
1686     }
1687 
1688     function _safeMint(address to, uint256 quantity) internal {
1689         _safeMint(to, quantity, "");
1690     }
1691 
1692     function _safeMint(
1693         address to,
1694         uint256 quantity,
1695         bytes memory _data
1696     ) internal {
1697         _mint(to, quantity, _data, true);
1698     }
1699 
1700     function _mint(
1701         address to,
1702         uint256 quantity,
1703         bytes memory _data,
1704         bool safe
1705     ) internal {
1706         uint256 startTokenId = currentIndex;
1707         require(to != address(0), "ERC721A: mint to the zero address");
1708         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1709 
1710         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1711 
1712         unchecked {
1713             _addressData[to].balance += uint128(quantity);
1714             _addressData[to].numberMinted += uint128(quantity);
1715 
1716             _ownerships[startTokenId].addr = to;
1717             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1718 
1719             uint256 updatedIndex = startTokenId;
1720 
1721             for (uint256 i; i < quantity; i++) {
1722                 emit Transfer(address(0), to, updatedIndex);
1723                 if (safe) {
1724                     require(
1725                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1726                         "ERC721A: transfer to non ERC721Receiver implementer"
1727                     );
1728                 }
1729 
1730                 updatedIndex++;
1731             }
1732 
1733             currentIndex = updatedIndex;
1734         }
1735 
1736         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1737     }
1738  
1739     function _transfer(
1740         address from,
1741         address to,
1742         uint256 tokenId
1743     ) private {
1744         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1745 
1746         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1747             getApproved(tokenId) == _msgSender() ||
1748             isApprovedForAll(prevOwnership.addr, _msgSender()));
1749 
1750         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1751 
1752         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1753         require(to != address(0), "ERC721A: transfer to the zero address");
1754 
1755         _beforeTokenTransfers(from, to, tokenId, 1);
1756 
1757         _approve(address(0), tokenId, prevOwnership.addr);
1758 
1759         
1760         unchecked {
1761             _addressData[from].balance -= 1;
1762             _addressData[to].balance += 1;
1763 
1764             _ownerships[tokenId].addr = to;
1765             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1766 
1767             uint256 nextTokenId = tokenId + 1;
1768             if (_ownerships[nextTokenId].addr == address(0)) {
1769                 if (_exists(nextTokenId)) {
1770                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1771                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1772                 }
1773             }
1774         }
1775 
1776         emit Transfer(from, to, tokenId);
1777         _afterTokenTransfers(from, to, tokenId, 1);
1778     }
1779 
1780     function _approve(
1781         address to,
1782         uint256 tokenId,
1783         address owner
1784     ) private {
1785         _tokenApprovals[tokenId] = to;
1786         emit Approval(owner, to, tokenId);
1787     }
1788 
1789     function _checkOnERC721Received(
1790         address from,
1791         address to,
1792         uint256 tokenId,
1793         bytes memory _data
1794     ) private returns (bool) {
1795         if (to.isContract()) {
1796             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1797                 return retval == IERC721Receiver(to).onERC721Received.selector;
1798             } catch (bytes memory reason) {
1799                 if (reason.length == 0) {
1800                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1801                 } else {
1802                     assembly {
1803                         revert(add(32, reason), mload(reason))
1804                     }
1805                 }
1806             }
1807         } else {
1808             return true;
1809         }
1810     }
1811 
1812     function _beforeTokenTransfers(
1813         address from,
1814         address to,
1815         uint256 startTokenId,
1816         uint256 quantity
1817     ) internal virtual {}
1818 
1819     function _afterTokenTransfers(
1820         address from,
1821         address to,
1822         uint256 startTokenId,
1823         uint256 quantity
1824     ) internal virtual {}
1825 }
1826 
1827 
1828 /**
1829  * @dev Contract module which provides a basic access control mechanism, where
1830  * there is an account (an owner) that can be granted exclusive access to
1831  * specific functions.
1832  *
1833  * By default, the owner account will be the one that deploys the contract. This
1834  * can later be changed with {transferOwnership}.
1835  *
1836  * This module is used through inheritance. It will make available the modifier
1837  * `onlyOwner`, which can be applied to your functions to restrict their use to
1838  * the owner.
1839  */
1840 abstract contract Ownable is Context {
1841     address private _owner;
1842 
1843     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1844 
1845     /**
1846      * @dev Initializes the contract setting the deployer as the initial owner.
1847      */
1848     constructor() {
1849         _transferOwnership(_msgSender());
1850     }
1851 
1852     /**
1853      * @dev Throws if called by any account other than the owner.
1854      */
1855     modifier onlyOwner() {
1856         _checkOwner();
1857         _;
1858     }
1859 
1860     /**
1861      * @dev Returns the address of the current owner.
1862      */
1863     function owner() public view virtual returns (address) {
1864         return _owner;
1865     }
1866 
1867     /**
1868      * @dev Throws if the sender is not the owner.
1869      */
1870     function _checkOwner() internal view virtual {
1871         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1872     }
1873 
1874     /**
1875      * @dev Leaves the contract without owner. It will not be possible to call
1876      * `onlyOwner` functions anymore. Can only be called by the current owner.
1877      *
1878      * NOTE: Renouncing ownership will leave the contract without an owner,
1879      * thereby removing any functionality that is only available to the owner.
1880      */
1881     function renounceOwnership() public virtual onlyOwner {
1882         _transferOwnership(address(0));
1883     }
1884 
1885     /**
1886      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1887      * Can only be called by the current owner.
1888      */
1889     function transferOwnership(address newOwner) public virtual onlyOwner {
1890         require(newOwner != address(0), "Ownable: new owner is the zero address");
1891         _transferOwnership(newOwner);
1892     }
1893 
1894     /**
1895      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1896      * Internal function without access restriction.
1897      */
1898     function _transferOwnership(address newOwner) internal virtual {
1899         address oldOwner = _owner;
1900         _owner = newOwner;
1901         emit OwnershipTransferred(oldOwner, newOwner);
1902     }
1903 }
1904 
1905 // File: contracts/TheShrapes.sol
1906 
1907 
1908 pragma solidity ^0.8.9;
1909 
1910 
1911 contract TheShrapes is ERC721A, Ownable, ReentrancyGuard {
1912     using Strings for uint256;
1913     
1914     address private _AdventureContract;
1915     uint   private _totalStake;
1916     bool   public QuestPhase = false;
1917     uint128 internal _burnCounter; 
1918     uint   public price             = 0.005 ether;
1919     uint   public maxTx          = 30;
1920     uint   public maxFreePerWallet  = 1;
1921     uint   public maxShrapes          = 10000;
1922     uint256 public reservedSupply = 50;
1923     string private baseURI;
1924     bool   public mintEnabled;  
1925     
1926     mapping(address => uint256) public _FreeMinted;
1927 
1928     constructor() ERC721A("The Shrapes", "SHRAPE") {}
1929 
1930     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1931         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1932         string memory currentBaseURI = _baseURI();
1933         return bytes(currentBaseURI).length > 0
1934             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId),".json"))
1935             : "";
1936     }
1937 
1938     function _baseURI() internal view virtual override returns (string memory) {
1939         return baseURI;
1940     }
1941 
1942     // Public Functions
1943     function mint(uint256 Amount) external payable {
1944 
1945         if (((totalSupply() + Amount < maxShrapes + 1) && (_FreeMinted[msg.sender] < maxFreePerWallet))) 
1946         {
1947         require(totalSupply() + Amount <= maxShrapes, "No more shrapes to be minted");
1948         require(mintEnabled, "Not live yet, shrapes are coming");
1949         require(msg.value >= (Amount * price) - price, "Eth Amount Invalid");
1950         require(Amount <= maxTx, "Too much asked per TX");
1951         _FreeMinted[msg.sender] += Amount;
1952         }
1953         else{
1954         require(totalSupply() + Amount <= maxShrapes, "No more shrapes to be minted");
1955         require(mintEnabled, "Not live yet, shrapes are coming");
1956         require(msg.value >= Amount * price, "Eth Amount Invalid");
1957         require(Amount <= maxTx, "Too much asked per TX");
1958         }
1959 
1960         _safeMint(msg.sender, Amount);
1961         //totalSupply += Amount;
1962         
1963     }
1964 
1965     function reservedMint(uint256 Amount) external onlyOwner
1966     {
1967         uint256 Remaining = reservedSupply;
1968 
1969         require(totalSupply() + Amount <= maxShrapes, "No more shrapes to be minted");
1970         require(Remaining >= Amount, "Reserved Supply Minted");
1971     
1972         reservedSupply = Remaining - Amount;
1973         _safeMint(msg.sender, Amount);
1974        // totalSupply() += Amount;
1975     }
1976 
1977     // Owner-only functions
1978     function toggleMinting() external onlyOwner {
1979       mintEnabled = !mintEnabled;
1980     }
1981 
1982    function setBaseUri(string memory baseuri_) public onlyOwner {
1983         baseURI = baseuri_;
1984     }
1985 
1986     function setCost(uint256 price_) external onlyOwner {
1987         price = price_;
1988     }
1989 
1990     function costInspect() public view returns (uint256) {
1991         return price;
1992     }
1993 
1994     function setAdventureContract(address _contract) public onlyOwner {
1995         _AdventureContract = _contract;
1996     }
1997 
1998     function toggleQuestPhase() public onlyOwner {
1999         QuestPhase = !QuestPhase;
2000     }
2001 
2002     function withdraw() external onlyOwner nonReentrant {
2003         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2004         require(success, "Transfer failed.");
2005     }
2006 }