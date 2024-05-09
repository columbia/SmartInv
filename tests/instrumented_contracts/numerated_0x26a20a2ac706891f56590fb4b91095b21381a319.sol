1 pragma solidity >=0.8.0;
2 
3 // SPDX-License-Identifier: BSD-3-Clause
4 
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 library EnumerableSet {
32 
33     struct Set {
34         // Storage of set values
35         bytes32[] _values;
36 
37         // Position of the value in the `values` array, plus 1 because index 0
38         // means a value is not in the set.
39         mapping (bytes32 => uint256) _indexes;
40     }
41 
42     function _add(Set storage set, bytes32 value) private returns (bool) {
43         if (!_contains(set, value)) {
44             set._values.push(value);
45             // The value is stored at length-1, but we add 1 to all indexes
46             // and use 0 as a sentinel value
47             set._indexes[value] = set._values.length;
48             return true;
49         } else {
50             return false;
51         }
52     }
53 
54     function _remove(Set storage set, bytes32 value) private returns (bool) {
55         // We read and store the value's index to prevent multiple reads from the same storage slot
56         uint256 valueIndex = set._indexes[value];
57 
58         if (valueIndex != 0) { // Equivalent to contains(set, value)
59             
60             uint256 toDeleteIndex = valueIndex - 1;
61             uint256 lastIndex = set._values.length - 1;
62 
63             bytes32 lastvalue = set._values[lastIndex];
64 
65             set._values[toDeleteIndex] = lastvalue;
66             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
67 
68             set._values.pop();
69 
70             delete set._indexes[value];
71 
72             return true;
73         } else {
74             return false;
75         }
76     }
77 
78     function _contains(Set storage set, bytes32 value) private view returns (bool) {
79         return set._indexes[value] != 0;
80     }
81 
82     function _length(Set storage set) private view returns (uint256) {
83         return set._values.length;
84     }
85 
86     function _at(Set storage set, uint256 index) private view returns (bytes32) {
87         require(set._values.length > index, "EnumerableSet: index out of bounds");
88         return set._values[index];
89     }
90 
91     // AddressSet
92 
93     struct AddressSet {
94         Set _inner;
95     }
96 
97     function add(AddressSet storage set, address value) internal returns (bool) {
98         return _add(set._inner,  bytes32(uint(uint160(value))));
99     }
100 
101     function remove(AddressSet storage set, address value) internal returns (bool) {
102         return _remove(set._inner,  bytes32(uint(uint160(value))));
103     }
104 
105     /**
106      * @dev Returns true if the value is in the set. O(1).
107      */
108     function contains(AddressSet storage set, address value) internal view returns (bool) {
109         return _contains(set._inner,  bytes32(uint(uint160(value))));
110     }
111 
112     /**
113      * @dev Returns the number of values in the set. O(1).
114      */
115     function length(AddressSet storage set) internal view returns (uint256) {
116         return _length(set._inner);
117     }
118 
119     function at(AddressSet storage set, uint256 index) internal view returns (address) {
120         return address(uint160(uint(_at(set._inner, index))));
121     }
122 
123 
124     // UintSet
125 
126     struct UintSet {
127         Set _inner;
128     }
129 
130     function add(UintSet storage set, uint256 value) internal returns (bool) {
131         return _add(set._inner, bytes32(value));
132     }
133 
134     function remove(UintSet storage set, uint256 value) internal returns (bool) {
135         return _remove(set._inner, bytes32(value));
136     }
137 
138     /**
139      * @dev Returns true if the value is in the set. O(1).
140      */
141     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
142         return _contains(set._inner, bytes32(value));
143     }
144 
145     /**
146      * @dev Returns the number of values on the set. O(1).
147      */
148     function length(UintSet storage set) internal view returns (uint256) {
149         return _length(set._inner);
150     }
151 
152    
153     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
154         return uint256(_at(set._inner, index));
155     }
156 }
157 
158 contract Ownable {
159   address public owner;
160 
161 
162   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164   constructor()  {
165     owner = msg.sender;
166   }
167 
168 
169   modifier onlyOwner() {
170     require(msg.sender == owner);
171     _;
172   }
173 
174   function transferOwnership(address newOwner) onlyOwner public returns(bool){
175     require(newOwner != address(0));
176     emit OwnershipTransferred(owner, newOwner);
177     owner = newOwner;
178     return true;
179   }
180   
181 }
182 
183 interface Library {
184     function transferFrom(address, address, uint) external returns (bool);
185     function transfer(address, uint) external returns (bool);
186     function balanceOf(address) external returns (uint256);
187     function giftNFT(address) external returns(bool);
188 }
189 
190 contract YFDAI2_TOKENSWAP is Ownable {
191     using SafeMath for uint;
192     using EnumerableSet for EnumerableSet.AddressSet;
193     
194     event Bridged(address holder, uint amount, uint newAmount);
195     
196     /* @dev
197     Contract addresses
198     */
199     address public constant deposit = 0xf4CD3d3Fda8d7Fd6C5a500203e38640A70Bf9577;
200     address public constant withdraw = 0x0C72C6fa50422aeA10B49e12Fe460103d0fa9c3e;
201     address public constant collectionNFT = 0x158D39C053058adb4c19D16Ffb06AE182f5F6fF6;
202     /* @dev
203     Exchange Rate
204     */
205     uint public rate = 1;
206     
207     /* @dev
208     Enable / Disable the bridge
209     */
210     bool public enabled = true;
211     bool public givingNFTs = true;
212     mapping(address => bool) public gotNFT;
213     
214      /* @dev
215         FUNCTIONS:
216     */
217     function changeState(bool _new) public onlyOwner returns(bool){
218         enabled = _new;
219         return true;
220     }
221 
222     function setGivingNFTs(bool _new) public onlyOwner returns(bool){
223         givingNFTs = _new;
224         return true;
225     }
226     
227     function swap(uint amount) public returns (bool){
228         require(enabled , "Bridge is disabled");
229         require(amount >= 1000000000000000000, "Min amount is 1");
230         uint _toSend = amount.mul(rate);
231         require(Library(deposit).transferFrom(msg.sender, address(this), amount), "Could not get deposit token");
232         require(Library(withdraw).transfer(msg.sender, _toSend), "Could not transfer withdraw token");
233         if(!gotNFT[msg.sender] && givingNFTs){
234             gotNFT[msg.sender] = true;
235             require(Library(collectionNFT).giftNFT(msg.sender), "Could not mint NFT");
236         }
237         
238         emit Bridged(msg.sender, amount, _toSend);
239         return true;
240     }
241     
242     function getDeposited() public onlyOwner returns(bool){
243         uint amount = Library(deposit).balanceOf(address(this));
244         require(Library(deposit).transfer(msg.sender, amount), "Could not get deposit token");
245         return true;
246     }
247 
248     function getUnused() public onlyOwner returns(bool){
249         uint amount = Library(withdraw).balanceOf(address(this));
250         require(Library(withdraw).transfer(msg.sender, amount), "Could not get bridge token");
251         return true;
252     }
253 }