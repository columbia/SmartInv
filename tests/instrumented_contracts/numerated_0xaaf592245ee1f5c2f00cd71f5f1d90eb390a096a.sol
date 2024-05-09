1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @dev Contract module which provides a basic access control mechanism, where
117  * there is an account (an owner) that can be granted exclusive access to
118  * specific functions.
119  *
120  * This module is used through inheritance. It will make available the modifier
121  * `onlyOwner`, which can be aplied to your functions to restrict their use to
122  * the owner.
123  */
124 contract Ownable {
125     address private _owner;
126 
127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129     /**
130      * @dev Initializes the contract setting the deployer as the initial owner.
131      */
132     constructor () internal {
133         _owner = msg.sender;
134         emit OwnershipTransferred(address(0), _owner);
135     }
136 
137     /**
138      * @dev Returns the address of the current owner.
139      */
140     function owner() public view returns (address) {
141         return _owner;
142     }
143 
144     /**
145      * @dev Throws if called by any account other than the owner.
146      */
147     modifier onlyOwner() {
148         require(isOwner(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     /**
153      * @dev Returns true if the caller is the current owner.
154      */
155     function isOwner() public view returns (bool) {
156         return msg.sender == _owner;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * > Note: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public onlyOwner {
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      */
182     function _transferOwnership(address newOwner) internal {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         emit OwnershipTransferred(_owner, newOwner);
185         _owner = newOwner;
186     }
187 }
188 
189 // File: contracts/eth_superplayer_select_character.sol
190 
191 pragma solidity ^0.5.0;
192 
193 
194 
195 
196 
197 
198 
199 contract SuperplayerCharacter is Ownable {
200   using SafeMath for uint256;
201 
202 
203   event CharacterSelect(address from ,uint32 chaId) ;
204   mapping(address => uint32) public addrMapCharacterIds;
205   uint256 changeFee = 0;
206 
207 
208   struct Character {
209     uint32 id ;
210     uint weight ;
211   }
212 
213 
214   Character[] private characters;
215   uint256 totalNum = 0;
216   uint256 totalWeight = 0;
217 
218   constructor() public {
219       _addCharacter(1,1000000);
220       _addCharacter(2,1000000);
221       _addCharacter(3,1000000);
222       _addCharacter(4,1000);
223       _addCharacter(5,1000);
224       _addCharacter(6,1000);
225   }
226 
227 
228   function AddCharacter(uint32 id ,uint weight ) public onlyOwner{
229     _addCharacter(id,weight);
230   }
231 
232 
233   function SetFee( uint256 fee ) public onlyOwner {
234     changeFee = fee;
235   }
236 
237 
238 
239 
240   function withdraw( address payable to )  public onlyOwner{
241     require(to == msg.sender); //to == msg.sender == _owner
242     to.transfer((address(this).balance ));
243   }
244 
245   function getConfig() public view returns(uint32[] memory ids,uint256[] memory weights){
246      ids = new uint32[](characters.length);
247      weights = new uint[](characters.length);
248      for (uint i = 0;i < characters.length ; i++){
249           Character memory ch  = characters[i];
250           ids[i] = ch.id;
251           weights[i] = ch.weight;
252      }
253   }
254 
255   function () payable external{
256     require(msg.value >= changeFee);
257     uint sum = 0 ;
258     uint index = characters.length - 1;
259 
260     uint weight = uint256(keccak256(abi.encodePacked(block.timestamp,msg.value,block.difficulty))) %totalWeight + 1;
261 
262     for (uint i = 0;i < characters.length ; i++){
263       Character memory ch  = characters[i];
264       sum += ch.weight;
265       if( weight  <=  sum ){
266         index = i;
267         break;
268       }
269     }
270     _selectCharacter(msg.sender,characters[index].id);
271 
272     msg.sender.transfer(msg.value.sub(changeFee));
273   }
274 
275   function _selectCharacter(address from,uint32 id) internal{
276     addrMapCharacterIds[from] = id;
277     emit CharacterSelect(from,id);
278   }
279 
280 
281 
282   function  _addCharacter(uint32 id ,uint weight) internal  {
283     Character memory char = Character({
284       id : id,
285       weight :weight
286     });
287     characters.push(char);
288     totalNum = totalNum.add(1);
289     totalWeight  = totalWeight.add(weight);
290   }
291 
292 }