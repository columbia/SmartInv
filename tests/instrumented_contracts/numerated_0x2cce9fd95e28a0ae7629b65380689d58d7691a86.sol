1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * @notice https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7  */
8 library SafeMath {
9   /**
10    * SafeMath mul function
11    * @dev function for safe multiply
12    **/
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18   
19   /**
20    * SafeMath div funciotn
21    * @dev function for safe devide
22    **/
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a / b;
25     return c;
26   }
27   
28   /**
29    * SafeMath sub function
30    * @dev function for safe subtraction
31    **/
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36   
37   /**
38    * SafeMath add fuction 
39    * @dev function for safe addition
40    **/
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simple version of ERC20 interface
51  * @notice https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54   uint256 public totalSupply;
55   function balanceOf(address who) public constant returns (uint256);
56   function transfer(address to, uint256 value) public  returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 /**
61  * @title BasicToken
62  * @dev Basic version of Token, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66   mapping(address => uint256) balances;
67 
68   /**
69    * BasicToken transfer function
70    * @dev transfer token for a specified address
71    * @param _to address to transfer to.
72    * @param _value amount to be transferred.
73    */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     //Safemath fnctions will throw if value is invalid
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     emit Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83    * BasicToken balanceOf function 
84    * @dev Gets the balance of the specified address.
85    * @param _owner address to get balance of.
86    * @return uint256 amount owned by the address.
87    */
88   function balanceOf(address _owner) public constant returns (uint256 bal) {
89     return balances[_owner];
90   }
91 }
92 
93 /**
94  *  @title ERC20 interface
95  *  @notice https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public constant returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @title Token
106  * @dev Token to meet the ERC20 standard
107  * @notice https://github.com/ethereum/EIPs/issues/20
108  */
109 contract Token is ERC20, BasicToken {
110   mapping (address => mapping (address => uint256)) allowed;
111   
112   /**
113    * Token transferFrom function
114    * @dev Transfer tokens from one address to another
115    * @param _from address to send tokens from
116    * @param _to address to transfer to
117    * @param _value amout of tokens to be transfered
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     uint256 _allowance = allowed[_from][msg.sender];
121     // Safe math functions will throw if value invalid
122     balances[_to] = balances[_to].add(_value);
123     balances[_from] = balances[_from].sub(_value);
124     allowed[_from][msg.sender] = _allowance.sub(_value);
125     emit Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * Token approve function
131    * @dev Aprove address to spend amount of tokens
132    * @param _spender address to spend the funds.
133    * @param _value amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     // To change the approve amount you first have to reduce the addresses`
137     // allowance to zero by calling `approve(_spender, 0)` if it is not
138     // already 0 to mitigate the race condition described here:
139     // @notice https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140     assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
141 
142     allowed[msg.sender][_spender] = _value;
143     emit Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * Token allowance method
149    * @dev Ckeck that owners tokens is allowed to send to spender
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifing the amount of tokens still available for the spender.
153    */
154   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
155     return allowed[_owner][_spender];
156   }
157 }
158 
159 /**
160  * @title Lavevel Token
161  * @dev Simple ERC20 Token with standard token functions.
162  */
163 contract LavevelToken is Token {
164   string public constant NAME = "Googlier Token";
165   string public constant SYMBOL = "GOOGLIER";
166   uint256 public constant DECIMALS = 18;
167 
168   uint256 public constant INITIAL_SUPPLY = 500000000 * 10**18;
169 
170   /**
171    * Kimera Token Constructor
172    * @dev Create and issue tokens to msg.sender.
173    */
174   function LavevelToken() public {
175     totalSupply = INITIAL_SUPPLY;
176     balances[msg.sender] = INITIAL_SUPPLY;
177   }
178 }
179 
180 /**
181  * @title Ownable
182  * @dev Ownable has an owner address to simplify "user permissions".
183  */
184 contract Ownable {
185   address public owner;
186 
187   /**
188    * Ownable
189    * @dev Ownable constructor sets the `owner` of the contract to sender
190    */
191   function Ownable() public {
192     owner = msg.sender;
193   }
194 
195   /**
196    * ownerOnly
197    * @dev Throws an error if called by any account other than the owner.
198    */
199   modifier onlyOwner() {
200     require(msg.sender == owner);
201     _;
202   }
203 
204   /**
205    * transferOwnership
206    * @dev Allows the current owner to transfer control of the contract to a newOwner.
207    * @param newOwner The address to transfer ownership to.
208    */
209   function transferOwnership(address newOwner) public onlyOwner {
210     require(newOwner != address(0));
211     owner = newOwner;
212   }
213 }
214 
215 /**
216  * @title Token
217  * @dev API interface for interacting with the WILD Token contract 
218  */
219 
220 /**
221  * @title LavevelICO
222  * @dev LavevelICO contract is Ownable
223  **/
224 contract LavevelICO is Ownable {
225   using SafeMath for uint256;
226   Token token;
227 
228   uint256 public constant RATE = 3000; // Number of tokens per Ether
229   uint256 public constant CAP = 5350; // Cap in Ether
230   uint256 public constant START = 1519862400; // Mar 26, 2018 @ 12:00 EST
231   uint256 public constant DAYS = 45; // 45 Day
232   
233   uint256 public constant initialTokens = 6000000 * 10**18; // Initial number of tokens available
234   bool public initialized = false;
235   uint256 public raisedAmount = 0;
236   
237   /**
238    * BoughtTokens
239    * @dev Log tokens bought onto the blockchain
240    */
241   event BoughtTokens(address indexed to, uint256 value);
242 
243   /**
244    * whenSaleIsActive
245    * @dev ensures that the contract is still active
246    **/
247   modifier whenSaleIsActive() {
248     // Check if sale is active
249     assert(isActive());
250     _;
251   }
252   
253   /**
254    * LavevelICO
255    * @dev LavevelICO constructor
256    **/
257   function LavevelICO(address _tokenAddr) public {
258       require(_tokenAddr != 0);
259       token = Token(_tokenAddr);
260   }
261   
262   /**
263    * initialize
264    * @dev Initialize the contract
265    **/
266   function initialize() public onlyOwner {
267       require(initialized == true); // Can only be initialized once
268       require(tokensAvailable() == initialTokens); // Must have enough tokens allocated
269       initialized = true;
270   }
271 
272   /**
273    * isActive
274    * @dev Determins if the contract is still active
275    **/
276   function isActive() public view returns (bool) {
277     return (
278         initialized == true &&
279         now >= START && // Must be after the START date
280         now <= START.add(DAYS * 1 days) && // Must be before the end date
281         goalReached() == false // Goal must not already be reached
282     );
283   }
284 
285   /**
286    * goalReached
287    * @dev Function to determin is goal has been reached
288    **/
289   function goalReached() public view returns (bool) {
290     return (raisedAmount >= CAP * 1 ether);
291   }
292 
293   /**
294    * @dev Fallback function if ether is sent to address insted of buyTokens function
295    **/
296   function () public payable {
297     buyTokens();
298   }
299 
300   /**
301    * buyTokens
302    * @dev function that sells available tokens
303    **/
304   function buyTokens() public payable whenSaleIsActive {
305     uint256 weiAmount = msg.value; // Calculate tokens to sell
306     uint256 tokens = weiAmount.mul(RATE);
307     
308     emit BoughtTokens(msg.sender, tokens); // log event onto the blockchain
309     raisedAmount = raisedAmount.add(msg.value); // Increment raised amount
310     token.transfer(msg.sender, tokens); // Send tokens to buyer
311     
312     owner.transfer(msg.value);// Send money to owner
313   }
314 
315   /**
316    * tokensAvailable
317    * @dev returns the number of tokens allocated to this contract
318    **/
319   function tokensAvailable() public constant returns (uint256) {
320     return token.balanceOf(this);
321   }
322 
323   /**
324    * destroy
325    * @notice Terminate contract and refund to owner
326    **/
327   function destroy() onlyOwner public {
328     // Transfer tokens back to owner
329     uint256 balance = token.balanceOf(this);
330     assert(balance > 0);
331     token.transfer(owner, balance);
332     // There should be no ether in the contract but just in case
333     selfdestruct(owner);
334   }
335 }