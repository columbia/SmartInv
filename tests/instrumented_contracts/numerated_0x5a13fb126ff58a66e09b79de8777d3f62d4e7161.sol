1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function add(uint256 a, uint256 b) internal constant returns (uint256) {
15     uint256 c = a + b;
16     assert(c >= a);
17     return c;
18   }
19 }
20 
21 /**
22  * @title Ownable
23  * @dev The Ownable contract has an owner address, and provides basic authorization control
24  * functions, this simplifies the implementation of "user permissions".
25  */
26 contract Ownable {
27 
28   address public owner;
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) onlyOwner {
51     require(newOwner != address(0));
52     owner = newOwner;
53   }
54 }
55 
56 /**
57  * @title Token
58  * @dev API interface for interacting with the WILD Token contract 
59  */
60 interface Token {
61   function transfer(address _to, uint256 _value) returns (bool);
62   function balanceOf(address _owner) constant returns (uint256 balance);
63 }
64 
65 contract PreICO is Ownable {
66 
67   using SafeMath for uint256;
68 
69   Token token;
70 
71   uint256 public constant RATE = 2332; // Number of tokens per Ether with 40% bonus
72   uint256 public constant CAP = 228703; // Cap in Ether
73   uint256 public constant START = 1523692800; // start date in epoch timestamp
74   uint256 public constant DAYS = 21; // 21 days/ 3 weeks
75   uint256 public constant Bonus = 40; //40% bonus during preICO
76   uint256 public constant initialTokens =  53333333333 * 10**17; // Initial number of tokens available
77   bool public initialized = false;
78   uint256 public raisedAmount = 0;
79   
80   mapping (address => uint256) buyers;
81 
82   event BoughtTokens(address indexed to, uint256 value);
83 
84   modifier whenSaleIsActive() {
85     // Check if sale is active
86     assert(isActive());
87 
88     _;
89   }
90 
91   function PreICO() {
92       
93       
94       token = Token(0xb55cbc064fa6662029753b68d89037f284af658c);//GREENBIT TOKEN ADDRESS
95   }
96   
97   function initialize() onlyOwner {
98       require(initialized == false); // Can only be initialized once
99       require(tokensAvailable() == initialTokens); // Must have enough tokens allocated
100       initialized = true;
101   }
102 
103   function isActive() constant returns (bool) {
104     return (
105         initialized == true &&
106         now >= START && // Must be after the START date
107         now <= START.add(DAYS * 1 days) && // Must be before the end date
108         goalReached() == false // Goal must not already be reached
109     );
110   }
111 
112   function goalReached() constant returns (bool) {
113     return (raisedAmount >= CAP * 1 ether);
114   }
115 
116   function () payable {
117     buyTokens();
118   }
119 
120   /**
121   * @dev function that sells available tokens
122   */
123   function buyTokens() payable whenSaleIsActive {
124     // Calculate tokens to sell
125     uint256 weiAmount = msg.value;
126     uint256 tokens = weiAmount.mul(RATE);
127 
128     BoughtTokens(msg.sender, tokens);
129 
130     // Increment raised amount
131     raisedAmount = raisedAmount.add(msg.value);
132     
133     // Send tokens to buyer
134     token.transfer(msg.sender, tokens);
135     
136     // Send money to owner
137     owner.transfer(msg.value);
138   }
139 
140   /**
141    * @dev returns the number of tokens allocated to this contract
142    */
143   function tokensAvailable() constant returns (uint256) {
144     return token.balanceOf(this);
145   }
146 
147   /**
148    * @notice Terminate contract and refund to owner
149    */
150   function destroy() onlyOwner {
151     // Transfer tokens back to owner
152     uint256 balance = token.balanceOf(this);
153     assert(balance > 0);
154     token.transfer(owner, balance);
155 
156     // There should be no ether in the contract but just in case
157     selfdestruct(owner);
158   }
159 
160 }