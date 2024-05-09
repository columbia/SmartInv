1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ERC20-token.sol
4 
5 /**
6  * @title ERC20 interface 
7  * 
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 // File: contracts/OwnableWithAdmin.sol
21 
22 /**
23  * @title OwnableWithAdmin 
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract OwnableWithAdmin {
28   address public owner;
29   address public adminOwner;
30 
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   constructor() public {
37     owner = msg.sender;
38     adminOwner = msg.sender;
39   }
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48   /**
49    * @dev Throws if called by any account other than the admin.
50    */
51   modifier onlyAdmin() {
52     require(msg.sender == adminOwner);
53     _;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner or admin.
58    */
59   modifier onlyOwnerOrAdmin() {
60     require(msg.sender == adminOwner || msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74   /**
75    * @dev Allows the current adminOwner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferAdminOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(adminOwner, newOwner);
81     adminOwner = newOwner;
82   }
83 
84 }
85 
86 // File: contracts/SafeMath.sol
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that revert on error
91  */
92 library SafeMath {
93   /**
94   * @dev Multiplies two numbers, reverts on overflow.
95   */
96   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98       // benefit is lost if 'b' is also tested.
99       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
100       if (a == 0) {
101           return 0;
102       }
103 
104       uint256 c = a * b;
105       require(c / a == b);
106 
107       return c;
108   }
109 
110   /**
111   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
112   */
113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
114       // Solidity only automatically asserts when dividing by 0
115       require(b > 0);
116       uint256 c = a / b;
117       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119       return c;
120   }
121 
122   /**
123   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
124   */
125   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126       require(b <= a);
127       uint256 c = a - b;
128 
129       return c;
130   }
131 
132   /**
133   * @dev Adds two numbers, reverts on overflow.
134   */
135   function add(uint256 a, uint256 b) internal pure returns (uint256) {
136       uint256 c = a + b;
137       require(c >= a);
138 
139       return c;
140   }
141 
142   /**
143   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
144   * reverts when dividing by zero.
145   */
146   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147       require(b != 0);
148       return a % b;
149   }
150  
151 
152   function uint2str(uint i) internal pure returns (string){
153       if (i == 0) return "0";
154       uint j = i;
155       uint length;
156       while (j != 0){
157           length++;
158           j /= 10;
159       }
160       bytes memory bstr = new bytes(length);
161       uint k = length - 1;
162       while (i != 0){
163           bstr[k--] = byte(48 + i % 10);
164           i /= 10;
165       }
166       return string(bstr);
167   }
168  
169   
170 }
171 
172 // File: contracts/AirDropLight.sol
173 
174 /**
175  * @title AirDrop Light Direct Airdrop
176  * @notice Contract is not payable.
177  * Owner or admin can allocate tokens.
178  * Tokens will be released direct. 
179  *
180  *
181  */
182 contract AirDropLight is OwnableWithAdmin {
183   using SafeMath for uint256;
184   
185   // Amount of tokens claimed
186   uint256 public grandTotalClaimed = 0;
187 
188   // The token being sold
189   ERC20 public token;
190 
191   // Max amount in one airdrop
192   uint256  maxDirect = 51 * (10**uint256(18));
193 
194   // Recipients
195   mapping(address => bool) public recipients;
196 
197   // List of all addresses
198   address[] public addresses;
199    
200   constructor(ERC20 _token) public {
201      
202     require(_token != address(0));
203 
204     token = _token;
205 
206   }
207 
208   
209   /**
210    * @dev fallback function ***DO NOT OVERRIDE***
211    */
212   function () public {
213     //Not payable
214   }
215 
216 
217   /**
218     * @dev Transfer tokens direct
219     * @param _recipients Array of wallets
220     * @param _tokenAmount Amount Allocated tokens + 18 decimals
221     */
222   function transferManyDirect (address[] _recipients, uint256 _tokenAmount) onlyOwnerOrAdmin  public{
223     for (uint256 i = 0; i < _recipients.length; i++) {
224       transferDirect(_recipients[i],_tokenAmount);
225     }    
226   }
227 
228         
229   /**
230     * @dev Transfer tokens direct to recipient without allocation. 
231     * _recipient can only get one transaction and _tokens can't be above maxDirect value
232     *  
233     */
234   function transferDirect(address _recipient,uint256 _tokens) public{
235 
236     //Check if contract has tokens
237     require(token.balanceOf(this)>=_tokens);
238     
239     //Check max value
240     require(_tokens < maxDirect );
241 
242     //Check if _recipient already have got tokens
243     require(!recipients[_recipient]); 
244     recipients[_recipient] = true;
245   
246     //Transfer tokens
247     require(token.transfer(_recipient, _tokens));
248 
249     //Add claimed tokens to grandTotalClaimed
250     grandTotalClaimed = grandTotalClaimed.add(_tokens); 
251      
252   }
253   
254 
255   // Allow transfer of tokens back to owner or reserve wallet
256   function returnTokens() public onlyOwner {
257     uint256 balance = token.balanceOf(this);
258     require(token.transfer(owner, balance));
259   }
260 
261   // Owner can transfer tokens that are sent here by mistake
262   function refundTokens(address _recipient, ERC20 _token) public onlyOwner {
263     uint256 balance = _token.balanceOf(this);
264     require(_token.transfer(_recipient, balance));
265   }
266 
267 }
268 
269 // File: contracts/ZBX/ZBXAirDropLight.sol
270 
271 /**
272  * @title BYTMAirDropLight
273  *  
274  *
275 */
276 contract ZBXAirDropLight is AirDropLight {
277   constructor(   
278     ERC20 _token
279   ) public AirDropLight(_token) {
280 
281      
282 
283   }
284 }