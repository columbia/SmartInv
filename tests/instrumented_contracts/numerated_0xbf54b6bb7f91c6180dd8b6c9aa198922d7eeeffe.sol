1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-12
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-02-11
7 */
8 
9 pragma solidity 0.6.12;
10 
11 // SPDX-License-Identifier: No License
12 
13     /**
14     * @title SafeMath
15     * @dev Math operations with safety checks that throw on error
16     */
17     
18     library SafeMath {
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a * b;
21         assert(a == 0 || c / a == b);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42     }
43 
44     /**
45     * @dev Library for managing
46     * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
47     * types.
48     *
49     * Sets have the following properties:
50     *
51     * - Elements are added, removed, and checked for existence in constant time
52     * (O(1)).
53     * - Elements are enumerated in O(n). No guarantees are made on the ordering.
54     *
55     * ```
56     * contract Example {
57     *     // Add the library methods
58     *     using EnumerableSet for EnumerableSet.AddressSet;
59     *
60     *     // Declare a set state variable
61     *     EnumerableSet.AddressSet private mySet;
62     * }
63     * ```
64     *
65     * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
66     * (`UintSet`) are supported.
67     */
68     
69     library EnumerableSet {
70         
71 
72         struct Set {
73         
74             bytes32[] _values;
75     
76             mapping (bytes32 => uint256) _indexes;
77         }
78     
79         function _add(Set storage set, bytes32 value) private returns (bool) {
80             if (!_contains(set, value)) {
81                 set._values.push(value);
82                 
83                 set._indexes[value] = set._values.length;
84                 return true;
85             } else {
86                 return false;
87             }
88         }
89 
90         /**
91         * @dev Removes a value from a set. O(1).
92         *
93         * Returns true if the value was removed from the set, that is if it was
94         * present.
95         */
96         function _remove(Set storage set, bytes32 value) private returns (bool) {
97             // We read and store the value's index to prevent multiple reads from the same storage slot
98             uint256 valueIndex = set._indexes[value];
99 
100             if (valueIndex != 0) { // Equivalent to contains(set, value)
101                 
102 
103                 uint256 toDeleteIndex = valueIndex - 1;
104                 uint256 lastIndex = set._values.length - 1;
105 
106             
107                 bytes32 lastvalue = set._values[lastIndex];
108 
109                 set._values[toDeleteIndex] = lastvalue;
110                 set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
111 
112                 set._values.pop();
113 
114                 delete set._indexes[value];
115 
116                 return true;
117             } else {
118                 return false;
119             }
120         }
121 
122         
123         function _contains(Set storage set, bytes32 value) private view returns (bool) {
124             return set._indexes[value] != 0;
125         }
126 
127         
128         function _length(Set storage set) private view returns (uint256) {
129             return set._values.length;
130         }
131 
132     
133         function _at(Set storage set, uint256 index) private view returns (bytes32) {
134             require(set._values.length > index, "EnumerableSet: index out of bounds");
135             return set._values[index];
136         }
137 
138         
139 
140         struct AddressSet {
141             Set _inner;
142         }
143     
144         function add(AddressSet storage set, address value) internal returns (bool) {
145             return _add(set._inner, bytes32(uint256(value)));
146         }
147 
148     
149         function remove(AddressSet storage set, address value) internal returns (bool) {
150             return _remove(set._inner, bytes32(uint256(value)));
151         }
152 
153         
154         function contains(AddressSet storage set, address value) internal view returns (bool) {
155             return _contains(set._inner, bytes32(uint256(value)));
156         }
157 
158     
159         function length(AddressSet storage set) internal view returns (uint256) {
160             return _length(set._inner);
161         }
162     
163         function at(AddressSet storage set, uint256 index) internal view returns (address) {
164             return address(uint256(_at(set._inner, index)));
165         }
166 
167 
168     
169         struct UintSet {
170             Set _inner;
171         }
172 
173         
174         function add(UintSet storage set, uint256 value) internal returns (bool) {
175             return _add(set._inner, bytes32(value));
176         }
177 
178     
179         function remove(UintSet storage set, uint256 value) internal returns (bool) {
180             return _remove(set._inner, bytes32(value));
181         }
182 
183         
184         function contains(UintSet storage set, uint256 value) internal view returns (bool) {
185             return _contains(set._inner, bytes32(value));
186         }
187 
188         
189         function length(UintSet storage set) internal view returns (uint256) {
190             return _length(set._inner);
191         }
192 
193     
194         function at(UintSet storage set, uint256 index) internal view returns (uint256) {
195             return uint256(_at(set._inner, index));
196         }
197     }
198     
199     contract Ownable {
200     address public owner;
201 
202 
203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205     
206     constructor() public {
207         owner = msg.sender;
208     }
209     
210     modifier onlyOwner() {
211         require(msg.sender == owner);
212         _;
213     }
214 
215     
216     function transferOwnership(address newOwner) onlyOwner public {
217         require(newOwner != address(0));
218         emit OwnershipTransferred(owner, newOwner);
219         owner = newOwner;
220     }
221     }
222 
223 
224     interface Token {
225         function transferFrom(address, address, uint) external returns (bool);
226         function transfer(address, uint) external returns (bool);
227         function balanceOf(address) external view returns (uint256);
228     }
229 
230     contract GCBNCashClaim is Ownable {
231         using SafeMath for uint;
232         using EnumerableSet for EnumerableSet.AddressSet;
233         
234 
235         // GCBN token contract address
236         address public constant tokenAddress = 0x15c303B84045f67156AcF6963954e4247B526717;
237         
238 
239         mapping(address => uint) public unclaimed;
240         
241         mapping(address => uint) public claimed;
242         
243         event CashbackAdded(address indexed user,uint amount ,uint time);
244             
245         event CashbackClaimed(address indexed user, uint amount ,uint time );
246     
247 
248         
249         function addCashback(address _user , uint _amount ) public  onlyOwner returns (bool)   {
250 
251                     unclaimed[_user] =  unclaimed[_user].add(_amount) ;
252                    
253                     emit CashbackAdded(_user,_amount,now);
254                                
255                     return true ;
256 
257         }
258         
259         
260         function claim() public returns (uint)  {
261             
262             require(unclaimed[msg.sender] > 0, "Cannot claim 0 or less");
263 
264             uint amount = unclaimed[msg.sender] ;
265            
266             Token(tokenAddress).transfer(msg.sender, amount);
267            
268           
269             emit CashbackClaimed(msg.sender,unclaimed[msg.sender],now);
270             
271             claimed[msg.sender] = claimed[msg.sender].add(unclaimed[msg.sender]) ;
272             
273             unclaimed[msg.sender] =  0 ;
274 
275         }
276           
277 
278         function getUnclaimeCashback(address _user) view public returns ( uint  ) {
279                         return unclaimed[_user];
280         }
281         
282         function getClaimeCashback(address _user) view public returns ( uint  ) {
283                         return claimed[_user];
284         }
285           
286  
287         function addContractBalance(uint amount) public onlyOwner{
288             require(Token(tokenAddress).transferFrom(msg.sender, address(this), amount), "Cannot add balance!");
289             
290         }
291         
292         function withdrawBalance() public onlyOwner {
293            msg.sender.transfer(address(this).balance);
294             
295         } 
296         
297         function withdrawToken() public onlyOwner {
298             require(Token(tokenAddress).transfer(msg.sender, Token(tokenAddress).balanceOf(address(this))), "Cannot withdraw balance!");
299             
300         } 
301  
302     
303 
304     }