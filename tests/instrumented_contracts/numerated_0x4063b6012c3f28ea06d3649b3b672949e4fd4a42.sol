1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-12
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-02-12
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-02-11
11 */
12 
13 pragma solidity 0.6.12;
14 
15 // SPDX-License-Identifier: No License
16 
17     /**
18     * @title SafeMath
19     * @dev Math operations with safety checks that throw on error
20     */
21     
22     library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46     }
47 
48     /**
49     * @dev Library for managing
50     * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
51     * types.
52     *
53     * Sets have the following properties:
54     *
55     * - Elements are added, removed, and checked for existence in constant time
56     * (O(1)).
57     * - Elements are enumerated in O(n). No guarantees are made on the ordering.
58     *
59     * ```
60     * contract Example {
61     *     // Add the library methods
62     *     using EnumerableSet for EnumerableSet.AddressSet;
63     *
64     *     // Declare a set state variable
65     *     EnumerableSet.AddressSet private mySet;
66     * }
67     * ```
68     *
69     * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
70     * (`UintSet`) are supported.
71     */
72     
73     library EnumerableSet {
74         
75 
76         struct Set {
77         
78             bytes32[] _values;
79     
80             mapping (bytes32 => uint256) _indexes;
81         }
82     
83         function _add(Set storage set, bytes32 value) private returns (bool) {
84             if (!_contains(set, value)) {
85                 set._values.push(value);
86                 
87                 set._indexes[value] = set._values.length;
88                 return true;
89             } else {
90                 return false;
91             }
92         }
93 
94         /**
95         * @dev Removes a value from a set. O(1).
96         *
97         * Returns true if the value was removed from the set, that is if it was
98         * present.
99         */
100         function _remove(Set storage set, bytes32 value) private returns (bool) {
101             // We read and store the value's index to prevent multiple reads from the same storage slot
102             uint256 valueIndex = set._indexes[value];
103 
104             if (valueIndex != 0) { // Equivalent to contains(set, value)
105                 
106 
107                 uint256 toDeleteIndex = valueIndex - 1;
108                 uint256 lastIndex = set._values.length - 1;
109 
110             
111                 bytes32 lastvalue = set._values[lastIndex];
112 
113                 set._values[toDeleteIndex] = lastvalue;
114                 set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
115 
116                 set._values.pop();
117 
118                 delete set._indexes[value];
119 
120                 return true;
121             } else {
122                 return false;
123             }
124         }
125 
126         
127         function _contains(Set storage set, bytes32 value) private view returns (bool) {
128             return set._indexes[value] != 0;
129         }
130 
131         
132         function _length(Set storage set) private view returns (uint256) {
133             return set._values.length;
134         }
135 
136     
137         function _at(Set storage set, uint256 index) private view returns (bytes32) {
138             require(set._values.length > index, "EnumerableSet: index out of bounds");
139             return set._values[index];
140         }
141 
142         
143 
144         struct AddressSet {
145             Set _inner;
146         }
147     
148         function add(AddressSet storage set, address value) internal returns (bool) {
149             return _add(set._inner, bytes32(uint256(value)));
150         }
151 
152     
153         function remove(AddressSet storage set, address value) internal returns (bool) {
154             return _remove(set._inner, bytes32(uint256(value)));
155         }
156 
157         
158         function contains(AddressSet storage set, address value) internal view returns (bool) {
159             return _contains(set._inner, bytes32(uint256(value)));
160         }
161 
162     
163         function length(AddressSet storage set) internal view returns (uint256) {
164             return _length(set._inner);
165         }
166     
167         function at(AddressSet storage set, uint256 index) internal view returns (address) {
168             return address(uint256(_at(set._inner, index)));
169         }
170 
171 
172     
173         struct UintSet {
174             Set _inner;
175         }
176 
177         
178         function add(UintSet storage set, uint256 value) internal returns (bool) {
179             return _add(set._inner, bytes32(value));
180         }
181 
182     
183         function remove(UintSet storage set, uint256 value) internal returns (bool) {
184             return _remove(set._inner, bytes32(value));
185         }
186 
187         
188         function contains(UintSet storage set, uint256 value) internal view returns (bool) {
189             return _contains(set._inner, bytes32(value));
190         }
191 
192         
193         function length(UintSet storage set) internal view returns (uint256) {
194             return _length(set._inner);
195         }
196 
197     
198         function at(UintSet storage set, uint256 index) internal view returns (uint256) {
199             return uint256(_at(set._inner, index));
200         }
201     }
202     
203     contract Ownable {
204     address public owner;
205 
206 
207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209     
210     constructor() public {
211         owner = msg.sender;
212     }
213     
214     modifier onlyOwner() {
215         require(msg.sender == owner);
216         _;
217     }
218 
219     
220     function transferOwnership(address newOwner) onlyOwner public {
221         require(newOwner != address(0));
222         emit OwnershipTransferred(owner, newOwner);
223         owner = newOwner;
224     }
225     }
226 
227 
228     interface Token {
229         function transferFrom(address, address, uint) external returns (bool);
230         function transfer(address, uint) external returns (bool);
231         function balanceOf(address) external view returns (uint256);
232     }
233 
234     contract GCBNCashClaim is Ownable {
235         using SafeMath for uint;
236         using EnumerableSet for EnumerableSet.AddressSet;
237         
238 
239         // GCBN token contract address
240         address public constant tokenAddress = 0x15c303B84045f67156AcF6963954e4247B526717;
241         
242 
243         mapping(address => uint) public unclaimed;
244         
245         mapping(address => uint) public claimed;
246         
247         event CashbackAdded(address indexed user,uint amount ,uint time);
248             
249         event CashbackClaimed(address indexed user, uint amount ,uint time );
250     
251 
252         
253         function addCashback(address _user , uint _amount ) public  onlyOwner returns (bool)   {
254 
255                     unclaimed[_user] =  unclaimed[_user].add(_amount) ;
256                    
257                     emit CashbackAdded(_user,_amount,now);
258                                
259                     return true ;
260 
261         }
262 
263 
264         function addCashbackBulk(address[] memory _users, uint[] memory _amount) public onlyOwner {
265       
266             for(uint i = 0; i < _users.length; i++) {
267                 address _user = _users[i];
268                 uint _reward = _amount[i];
269                 unclaimed[_user] =  unclaimed[_user].add(_reward) ;
270                 emit CashbackAdded(_user,_reward,now);
271             }
272          
273         }
274         
275         
276         function claim() public returns (uint)  {
277             
278             require(unclaimed[msg.sender] > 0, "Cannot claim 0 or less");
279 
280             uint amount = unclaimed[msg.sender] ;
281            
282             Token(tokenAddress).transfer(msg.sender, amount);
283            
284           
285             emit CashbackClaimed(msg.sender,unclaimed[msg.sender],now);
286             
287             claimed[msg.sender] = claimed[msg.sender].add(unclaimed[msg.sender]) ;
288             
289             unclaimed[msg.sender] =  0 ;
290 
291         }
292           
293 
294         function getUnclaimeCashback(address _user) view public returns ( uint  ) {
295                         return unclaimed[_user];
296         }
297         
298         function getClaimeCashback(address _user) view public returns ( uint  ) {
299                         return claimed[_user];
300         }
301           
302  
303         function addContractBalance(uint amount) public onlyOwner{
304             require(Token(tokenAddress).transferFrom(msg.sender, address(this), amount), "Cannot add balance!");
305             
306         }
307         
308         function withdrawBalance() public onlyOwner {
309            msg.sender.transfer(address(this).balance);
310             
311         } 
312         
313         function withdrawToken() public onlyOwner {
314             require(Token(tokenAddress).transfer(msg.sender, Token(tokenAddress).balanceOf(address(this))), "Cannot withdraw balance!");
315             
316         } 
317  
318     
319 
320     }