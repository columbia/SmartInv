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
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     if (a == 0) {
99       return 0;
100     }
101     uint256 c = a * b;
102     assert(c / a == b);
103     return c;
104   }
105 
106   /**
107   * @dev Integer division of two numbers, truncating the quotient.
108   */
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   /**
117   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   /**
125   * @dev Adds two numbers, throws on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     assert(c >= a);
130     return c;
131   }
132 
133   function uint2str(uint i) internal pure returns (string){
134       if (i == 0) return "0";
135       uint j = i;
136       uint length;
137       while (j != 0){
138           length++;
139           j /= 10;
140       }
141       bytes memory bstr = new bytes(length);
142       uint k = length - 1;
143       while (i != 0){
144           bstr[k--] = byte(48 + i % 10);
145           i /= 10;
146       }
147       return string(bstr);
148   }
149  
150   
151 }
152 
153 // File: contracts/AirDropLight.sol
154 
155 /**
156  * @title AirDrop Light Direct Airdrop
157  * @notice Contract is not payable.
158  * Owner or admin can allocate tokens.
159  * Tokens will be released direct. 
160  *
161  *
162  */
163 contract AirDropLight is OwnableWithAdmin {
164   using SafeMath for uint256;
165   
166   // Amount of tokens claimed
167   uint256 public grandTotalClaimed = 0;
168 
169   // The token being sold
170   ERC20 public token;
171 
172   // Max amount in one airdrop
173   uint256  maxDirect = 10000 * (10**uint256(18));
174 
175   // Recipients
176   mapping(address => bool) public recipients;
177 
178   // List of all addresses
179   address[] public addresses;
180    
181   constructor(ERC20 _token) public {
182      
183     require(_token != address(0));
184 
185     token = _token;
186 
187   }
188 
189   
190   /**
191    * @dev fallback function ***DO NOT OVERRIDE***
192    */
193   function () public {
194     //Not payable
195   }
196 
197 
198   /**
199     * @dev Transfer tokens direct
200     * @param _recipients Array of wallets
201     * @param _tokenAmount Amount Allocated tokens + 18 decimals
202     */
203   function transferManyDirect (address[] _recipients, uint256 _tokenAmount) onlyOwnerOrAdmin  public{
204     for (uint256 i = 0; i < _recipients.length; i++) {
205       transferDirect(_recipients[i],_tokenAmount);
206     }    
207   }
208 
209         
210   /**
211     * @dev Transfer tokens direct to recipient without allocation. 
212     * _recipient can only get one transaction and _tokens can't be above maxDirect value
213     *  
214     */
215   function transferDirect(address _recipient,uint256 _tokens) public{
216 
217     //Check if contract has tokens
218     require(token.balanceOf(this)>=_tokens);
219     
220     //Check max value
221     require(_tokens < maxDirect );
222 
223     //Check if _recipient already have got tokens
224     require(!recipients[_recipient]); 
225     recipients[_recipient] = true;
226   
227     //Transfer tokens
228     require(token.transfer(_recipient, _tokens));
229 
230     //Add claimed tokens to grandTotalClaimed
231     grandTotalClaimed = grandTotalClaimed.add(_tokens); 
232      
233   }
234   
235 
236   // Allow transfer of tokens back to owner or reserve wallet
237   function returnTokens() public onlyOwner {
238     uint256 balance = token.balanceOf(this);
239     require(token.transfer(owner, balance));
240   }
241 
242   // Owner can transfer tokens that are sent here by mistake
243   function refundTokens(address _recipient, ERC20 _token) public onlyOwner {
244     uint256 balance = _token.balanceOf(this);
245     require(_token.transfer(_recipient, balance));
246   }
247 
248 }
249 
250 // File: contracts/BYTM/BYTMAirDropLight.sol
251 
252 /**
253  * @title BYTMAirDropLight
254  *  
255  *
256 */
257 contract BYTMAirDropLight is AirDropLight {
258   constructor(   
259     ERC20 _token
260   ) public AirDropLight(_token) {
261 
262      
263 
264   }
265 }