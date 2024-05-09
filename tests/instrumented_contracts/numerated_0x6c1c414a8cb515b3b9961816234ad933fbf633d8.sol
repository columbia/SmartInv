1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-11
3 */
4 
5 pragma solidity 0.6.12;
6 
7 // SPDX-License-Identifier: No License
8 
9     /**
10     * @title SafeMath
11     * @dev Math operations with safety checks that throw on error
12     */
13     
14     library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38     }
39 
40     /**
41     * @dev Library for managing
42     * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
43     * types.
44     *
45     * Sets have the following properties:
46     *
47     * - Elements are added, removed, and checked for existence in constant time
48     * (O(1)).
49     * - Elements are enumerated in O(n). No guarantees are made on the ordering.
50     *
51     * ```
52     * contract Example {
53     *     // Add the library methods
54     *     using EnumerableSet for EnumerableSet.AddressSet;
55     *
56     *     // Declare a set state variable
57     *     EnumerableSet.AddressSet private mySet;
58     * }
59     * ```
60     *
61     * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
62     * (`UintSet`) are supported.
63     */
64     
65     library EnumerableSet {
66         
67 
68         struct Set {
69         
70             bytes32[] _values;
71     
72             mapping (bytes32 => uint256) _indexes;
73         }
74     
75         function _add(Set storage set, bytes32 value) private returns (bool) {
76             if (!_contains(set, value)) {
77                 set._values.push(value);
78                 
79                 set._indexes[value] = set._values.length;
80                 return true;
81             } else {
82                 return false;
83             }
84         }
85 
86         /**
87         * @dev Removes a value from a set. O(1).
88         *
89         * Returns true if the value was removed from the set, that is if it was
90         * present.
91         */
92         function _remove(Set storage set, bytes32 value) private returns (bool) {
93             // We read and store the value's index to prevent multiple reads from the same storage slot
94             uint256 valueIndex = set._indexes[value];
95 
96             if (valueIndex != 0) { // Equivalent to contains(set, value)
97                 
98 
99                 uint256 toDeleteIndex = valueIndex - 1;
100                 uint256 lastIndex = set._values.length - 1;
101 
102             
103                 bytes32 lastvalue = set._values[lastIndex];
104 
105                 set._values[toDeleteIndex] = lastvalue;
106                 set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
107 
108                 set._values.pop();
109 
110                 delete set._indexes[value];
111 
112                 return true;
113             } else {
114                 return false;
115             }
116         }
117 
118         
119         function _contains(Set storage set, bytes32 value) private view returns (bool) {
120             return set._indexes[value] != 0;
121         }
122 
123         
124         function _length(Set storage set) private view returns (uint256) {
125             return set._values.length;
126         }
127 
128     
129         function _at(Set storage set, uint256 index) private view returns (bytes32) {
130             require(set._values.length > index, "EnumerableSet: index out of bounds");
131             return set._values[index];
132         }
133 
134         
135 
136         struct AddressSet {
137             Set _inner;
138         }
139     
140         function add(AddressSet storage set, address value) internal returns (bool) {
141             return _add(set._inner, bytes32(uint256(value)));
142         }
143 
144     
145         function remove(AddressSet storage set, address value) internal returns (bool) {
146             return _remove(set._inner, bytes32(uint256(value)));
147         }
148 
149         
150         function contains(AddressSet storage set, address value) internal view returns (bool) {
151             return _contains(set._inner, bytes32(uint256(value)));
152         }
153 
154     
155         function length(AddressSet storage set) internal view returns (uint256) {
156             return _length(set._inner);
157         }
158     
159         function at(AddressSet storage set, uint256 index) internal view returns (address) {
160             return address(uint256(_at(set._inner, index)));
161         }
162 
163 
164     
165         struct UintSet {
166             Set _inner;
167         }
168 
169         
170         function add(UintSet storage set, uint256 value) internal returns (bool) {
171             return _add(set._inner, bytes32(value));
172         }
173 
174     
175         function remove(UintSet storage set, uint256 value) internal returns (bool) {
176             return _remove(set._inner, bytes32(value));
177         }
178 
179         
180         function contains(UintSet storage set, uint256 value) internal view returns (bool) {
181             return _contains(set._inner, bytes32(value));
182         }
183 
184         
185         function length(UintSet storage set) internal view returns (uint256) {
186             return _length(set._inner);
187         }
188 
189     
190         function at(UintSet storage set, uint256 index) internal view returns (uint256) {
191             return uint256(_at(set._inner, index));
192         }
193     }
194     
195     contract Ownable {
196     address public owner;
197 
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     
202     constructor() public {
203         owner = msg.sender;
204     }
205     
206     modifier onlyOwner() {
207         require(msg.sender == owner);
208         _;
209     }
210 
211     
212     function transferOwnership(address newOwner) onlyOwner public {
213         require(newOwner != address(0));
214         emit OwnershipTransferred(owner, newOwner);
215         owner = newOwner;
216     }
217     }
218 
219 
220     interface Token {
221         function transferFrom(address, address, uint) external returns (bool);
222         function transfer(address, uint) external returns (bool);
223         function balanceOf(address) external view returns (uint256);
224     }
225 
226     contract FTEXCashBack is Ownable {
227         using SafeMath for uint;
228         using EnumerableSet for EnumerableSet.AddressSet;
229         
230 
231         // FTEX token contract address
232         address public constant tokenAddress = 0x9743cb5f346Daa80A3a50B0859Efb85A49E4B8CC;
233         address public constant rewardAddress = 0xaA99007aa41ff10d76E91d96Ff4b0Bc773336C27 ;
234 
235 
236         mapping(address => uint) public unclaimed;
237         
238         mapping(address => uint) public claimed;
239         
240         event CashbackAdded(address indexed user,uint amount ,uint time);
241             
242         event CashbackClaimed(address indexed user, uint amount ,uint time );
243     
244 
245         
246         function addCashback(address _user , uint _amount ) public  onlyOwner returns (bool)   {
247 
248                     unclaimed[_user] =  unclaimed[_user].add(_amount) ;
249                    
250                     emit CashbackAdded(_user,_amount,now);
251                                
252                     return true ;
253 
254         }
255         
256         function claim() public returns (uint)  {
257             
258             require(unclaimed[msg.sender] > 0, "Cannot claim 0 or less");
259 
260             uint amount = unclaimed[msg.sender] ;
261             
262             uint fee = amount.mul(500).div(1e4) ;
263             
264             amount = amount.sub(fee);
265 
266             Token(tokenAddress).transfer(msg.sender, amount);
267             
268             Token(tokenAddress).transfer(rewardAddress, fee);
269           
270             emit CashbackClaimed(msg.sender,unclaimed[msg.sender],now);
271             
272             claimed[msg.sender] = claimed[msg.sender].add(unclaimed[msg.sender]) ;
273             
274             unclaimed[msg.sender] =  0 ;
275 
276         }
277           
278 
279         function getUnclaimeCashback(address _user) view public returns ( uint  ) {
280                         return unclaimed[_user];
281         }
282         
283         function getClaimeCashback(address _user) view public returns ( uint  ) {
284                         return claimed[_user];
285         }
286           
287  
288         function addContractBalance(uint amount) public onlyOwner{
289             require(Token(tokenAddress).transferFrom(msg.sender, address(this), amount), "Cannot add balance!");
290             
291         }
292         
293         function withdrawBalance() public onlyOwner {
294            msg.sender.transfer(address(this).balance);
295             
296         } 
297         
298         function withdrawToken() public onlyOwner {
299             require(Token(tokenAddress).transfer(msg.sender, Token(tokenAddress).balanceOf(address(this))), "Cannot withdraw balance!");
300             
301         } 
302  
303     
304 
305     }