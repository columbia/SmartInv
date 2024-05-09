1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * mul 
10      * @dev Safe math multiply function
11      */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17   /**
18    * add
19    * @dev Safe math addition function
20    */
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 /**
29  * @title Ownable
30  * @dev Ownable has an owner address to simplify "user permissions".
31  */
32 contract Ownable {
33   address public owner;
34 
35   /**
36    * Ownable
37    * @dev Ownable constructor sets the `owner` of the contract to sender
38    */
39   function Ownable() public {
40     owner = msg.sender;
41   }
42 
43   /**
44    * ownerOnly
45    * @dev Throws an error if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   /**
53    * transferOwnership
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     owner = newOwner;
60   }
61 }
62 
63 /**
64  * @title Token
65  * @dev API interface for interacting with the WILD Token contract 
66  */
67 interface Token {
68   function transfer(address _to, uint256 _value) external returns (bool);
69   function balanceOf(address _owner) external constant returns (uint256 balance);
70 }
71 
72 /**
73  * @title LavevelICO
74  * @dev LavevelICO contract is Ownable
75  **/
76 contract GooglierICO is Ownable {
77   using SafeMath for uint256;
78   Token token;
79 
80   uint256 public constant RATE = 3000; // Number of tokens per Ether
81   uint256 public constant CAP = 5350; // Cap in Ether
82   uint256 public constant START = 1519862400; // Mar 26, 2018 @ 12:00 EST
83   uint256 public constant DAYS = 45; // 45 Day
84   
85   uint256 public constant initialTokens = 6000000 * 10**18; // Initial number of tokens available
86   bool public initialized = false;
87   uint256 public raisedAmount = 0;
88   
89   /**
90    * BoughtTokens
91    * @dev Log tokens bought onto the blockchain
92    */
93   event BoughtTokens(address indexed to, uint256 value);
94 
95   /**
96    * whenSaleIsActive
97    * @dev ensures that the contract is still active
98    **/
99   modifier whenSaleIsActive() {
100     // Check if sale is active
101     assert(isActive());
102     _;
103   }
104   
105   /**
106    * LavevelICO
107    * @dev LavevelICO constructor
108    **/
109   function LavevelICO(address _tokenAddr) public {
110       require(_tokenAddr != 0);
111       token = Token(_tokenAddr);
112   }
113   
114   /**
115    * initialize
116    * @dev Initialize the contract
117    **/
118   function initialize() public onlyOwner {
119       require(initialized == false); // Can only be initialized once
120       require(tokensAvailable() == initialTokens); // Must have enough tokens allocated
121       initialized = true;
122   }
123 
124   /**
125    * isActive
126    * @dev Determins if the contract is still active
127    **/
128   function isActive() public view returns (bool) {
129     return (
130         initialized == true &&
131         now >= START && // Must be after the START date
132         now <= START.add(DAYS * 1 days) && // Must be before the end date
133         goalReached() == false // Goal must not already be reached
134     );
135   }
136 
137   /**
138    * goalReached
139    * @dev Function to determin is goal has been reached
140    **/
141   function goalReached() public view returns (bool) {
142     return (raisedAmount >= CAP * 1 ether);
143   }
144 
145   /**
146    * @dev Fallback function if ether is sent to address insted of buyTokens function
147    **/
148   function () public payable {
149     buyTokens();
150   }
151 
152   /**
153    * buyTokens
154    * @dev function that sells available tokens
155    **/
156   function buyTokens() public payable whenSaleIsActive {
157     uint256 weiAmount = msg.value; // Calculate tokens to sell
158     uint256 tokens = weiAmount.mul(RATE);
159     
160     emit BoughtTokens(msg.sender, tokens); // log event onto the blockchain
161     raisedAmount = raisedAmount.add(msg.value); // Increment raised amount
162     token.transfer(msg.sender, tokens); // Send tokens to buyer
163     
164     owner.transfer(msg.value);// Send money to owner
165   }
166 
167   /**
168    * tokensAvailable
169    * @dev returns the number of tokens allocated to this contract
170    **/
171   function tokensAvailable() public constant returns (uint256) {
172     return token.balanceOf(this);
173   }
174 
175   /**
176    * destroy
177    * @notice Terminate contract and refund to owner
178    **/
179   function destroy() onlyOwner public {
180     // Transfer tokens back to owner
181     uint256 balance = token.balanceOf(this);
182     assert(balance > 0);
183     token.transfer(owner, balance);
184     // There should be no ether in the contract but just in case
185     selfdestruct(owner);
186   }
187 }