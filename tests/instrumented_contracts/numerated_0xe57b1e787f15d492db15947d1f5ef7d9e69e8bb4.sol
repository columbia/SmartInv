1 pragma solidity 0.6.12;
2 
3 // SPDX-License-Identifier: No License
4 
5     /**
6     * @title SafeMath
7     * @dev Math operations with safety checks that throw on error
8     */
9     
10     library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34     }
35 
36     /**
37     * @dev Library for managing
38     * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
39     * types.
40     *
41     * Sets have the following properties:
42     *
43     * - Elements are added, removed, and checked for existence in constant time
44     * (O(1)).
45     * - Elements are enumerated in O(n). No guarantees are made on the ordering.
46     *
47     * ```
48     * contract Example {
49     *     // Add the library methods
50     *     using EnumerableSet for EnumerableSet.AddressSet;
51     *
52     *     // Declare a set state variable
53     *     EnumerableSet.AddressSet private mySet;
54     * }
55     * ```
56     *
57     * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
58     * (`UintSet`) are supported.
59     */
60     
61     library EnumerableSet {
62         
63 
64         struct Set {
65         
66             bytes32[] _values;
67     
68             mapping (bytes32 => uint256) _indexes;
69         }
70     
71         function _add(Set storage set, bytes32 value) private returns (bool) {
72             if (!_contains(set, value)) {
73                 set._values.push(value);
74                 
75                 set._indexes[value] = set._values.length;
76                 return true;
77             } else {
78                 return false;
79             }
80         }
81 
82         /**
83         * @dev Removes a value from a set. O(1).
84         *
85         * Returns true if the value was removed from the set, that is if it was
86         * present.
87         */
88         function _remove(Set storage set, bytes32 value) private returns (bool) {
89             // We read and store the value's index to prevent multiple reads from the same storage slot
90             uint256 valueIndex = set._indexes[value];
91 
92             if (valueIndex != 0) { // Equivalent to contains(set, value)
93                 
94 
95                 uint256 toDeleteIndex = valueIndex - 1;
96                 uint256 lastIndex = set._values.length - 1;
97 
98             
99                 bytes32 lastvalue = set._values[lastIndex];
100 
101                 set._values[toDeleteIndex] = lastvalue;
102                 set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
103 
104                 set._values.pop();
105 
106                 delete set._indexes[value];
107 
108                 return true;
109             } else {
110                 return false;
111             }
112         }
113 
114         
115         function _contains(Set storage set, bytes32 value) private view returns (bool) {
116             return set._indexes[value] != 0;
117         }
118 
119         
120         function _length(Set storage set) private view returns (uint256) {
121             return set._values.length;
122         }
123 
124     
125         function _at(Set storage set, uint256 index) private view returns (bytes32) {
126             require(set._values.length > index, "EnumerableSet: index out of bounds");
127             return set._values[index];
128         }
129 
130         
131 
132         struct AddressSet {
133             Set _inner;
134         }
135     
136         function add(AddressSet storage set, address value) internal returns (bool) {
137             return _add(set._inner, bytes32(uint256(value)));
138         }
139 
140     
141         function remove(AddressSet storage set, address value) internal returns (bool) {
142             return _remove(set._inner, bytes32(uint256(value)));
143         }
144 
145         
146         function contains(AddressSet storage set, address value) internal view returns (bool) {
147             return _contains(set._inner, bytes32(uint256(value)));
148         }
149 
150     
151         function length(AddressSet storage set) internal view returns (uint256) {
152             return _length(set._inner);
153         }
154     
155         function at(AddressSet storage set, uint256 index) internal view returns (address) {
156             return address(uint256(_at(set._inner, index)));
157         }
158 
159 
160     
161         struct UintSet {
162             Set _inner;
163         }
164 
165         
166         function add(UintSet storage set, uint256 value) internal returns (bool) {
167             return _add(set._inner, bytes32(value));
168         }
169 
170     
171         function remove(UintSet storage set, uint256 value) internal returns (bool) {
172             return _remove(set._inner, bytes32(value));
173         }
174 
175         
176         function contains(UintSet storage set, uint256 value) internal view returns (bool) {
177             return _contains(set._inner, bytes32(value));
178         }
179 
180         
181         function length(UintSet storage set) internal view returns (uint256) {
182             return _length(set._inner);
183         }
184 
185     
186         function at(UintSet storage set, uint256 index) internal view returns (uint256) {
187             return uint256(_at(set._inner, index));
188         }
189     }
190     
191     contract Ownable {
192     address public owner;
193 
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     
198     constructor() public {
199         owner = msg.sender;
200     }
201     
202     modifier onlyOwner() {
203         require(msg.sender == owner);
204         _;
205     }
206 
207     
208     function transferOwnership(address newOwner) onlyOwner public {
209         require(newOwner != address(0));
210         emit OwnershipTransferred(owner, newOwner);
211         owner = newOwner;
212     }
213     }
214 
215 
216     interface Token {
217         function transferFrom(address, address, uint) external returns (bool);
218         function transfer(address, uint) external returns (bool);
219         function balanceOf(address) external view returns (uint256);
220     }
221 
222     contract FTEXCashBackV2 is Ownable {
223         using SafeMath for uint;
224         using EnumerableSet for EnumerableSet.AddressSet;
225         
226 
227         // FTEX token contract address
228         address public constant tokenAddress = 0x9743cb5f346Daa80A3a50B0859Efb85A49E4B8CC;
229         address public constant rewardAddress = 0xaA99007aa41ff10d76E91d96Ff4b0Bc773336C27 ;
230 
231 
232         mapping(address => uint) public unclaimed;
233         
234         mapping(address => uint) public claimed;
235         
236         event CashbackAdded(address indexed user,uint amount ,uint time);
237             
238         event CashbackClaimed(address indexed user, uint amount ,uint time );
239     
240 
241         
242         function addCashback(address _user , uint _amount ) public  onlyOwner returns (bool)   {
243 
244                     unclaimed[_user] =  unclaimed[_user].add(_amount) ;
245                    
246                     emit CashbackAdded(_user,_amount,now);
247                                
248                     return true ;
249 
250         }
251         
252         
253         function addCashbackBulk(address[] memory _users, uint[] memory _amount) public onlyOwner {
254       
255             for(uint i = 0; i < _users.length; i++) {
256                 address _user = _users[i];
257                 uint _reward = _amount[i];
258                 unclaimed[_user] =  unclaimed[_user].add(_reward) ;
259                 emit CashbackAdded(_user,_reward,now);
260             }
261          
262         }
263         
264         
265         function claim() public returns (uint)  {
266             
267             require(unclaimed[msg.sender] > 0, "Cannot claim 0 or less");
268 
269             uint amount = unclaimed[msg.sender] ;
270             
271             uint fee = amount.mul(500).div(1e4) ;
272             
273             amount = amount.sub(fee);
274 
275             Token(tokenAddress).transfer(msg.sender, amount);
276             
277             Token(tokenAddress).transfer(rewardAddress, fee);
278           
279             emit CashbackClaimed(msg.sender,unclaimed[msg.sender],now);
280             
281             claimed[msg.sender] = claimed[msg.sender].add(unclaimed[msg.sender]) ;
282             
283             unclaimed[msg.sender] =  0 ;
284 
285         }
286           
287 
288         function getUnclaimeCashback(address _user) view public returns ( uint  ) {
289                         return unclaimed[_user];
290         }
291         
292         function getClaimeCashback(address _user) view public returns ( uint  ) {
293                         return claimed[_user];
294         }
295           
296  
297         function addContractBalance(uint amount) public onlyOwner{
298             require(Token(tokenAddress).transferFrom(msg.sender, address(this), amount), "Cannot add balance!");
299             
300         }
301         
302         function withdrawBalance() public onlyOwner {
303            msg.sender.transfer(address(this).balance);
304             
305         } 
306         
307         function withdrawToken() public onlyOwner {
308             require(Token(tokenAddress).transfer(msg.sender, Token(tokenAddress).balanceOf(address(this))), "Cannot withdraw balance!");
309             
310         } 
311  
312     
313 
314     }