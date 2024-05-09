1 pragma solidity ^0.4.18;
2 
3 /**
4  * Mistoken Campaign-1 Crowdsale Contract
5  * Based on the Wild Crypto Crowdsale Contract
6  * and the OpenZeppelin open-source framework
7  */
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33 
34   address public owner;
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) onlyOwner {
57     require(newOwner != address(0));
58     owner = newOwner;
59   }
60 }
61 
62 /**
63  * @title Token
64  * @dev API interface for interacting with the MisToken contract 
65  */
66 interface Token {
67   function transfer(address _to, uint256 _value) returns (bool);
68   function balanceOf(address _owner) constant returns (uint256 balance);
69 }
70 
71 contract Crowdsale is Ownable {
72 
73   using SafeMath for uint256;
74 
75   Token public token;
76 
77   uint256 public constant RATE = 99; // Number of tokens per Ether
78   uint256 public constant CAP = 101; // Cap in Ether
79   uint256 public constant START = 1510398671; // Saturday, November 11, 2017 11:11:11 AM (GMT)
80   uint256 public constant DAYS = 11; // 11 Days
81 
82   uint256 public constant initialTokens = 9999 * 10**18; // Initial number of tokens available
83   bool public initialized = false;
84   uint256 public raisedAmount = 0;
85 
86   event BoughtTokens(address indexed to, uint256 value);
87 
88   modifier whenSaleIsActive() {
89     // Check if sale is active
90     assert(isActive());
91 
92     _;
93   }
94 
95   function Crowdsale(address _tokenAddr) {
96       require(_tokenAddr != 0);
97       token = Token(_tokenAddr);
98   }
99   
100   function initialize() onlyOwner {
101       require(initialized == false); // Can only be initialized once
102       require(tokensAvailable() == initialTokens); // Must have some tokens allocated
103       initialized = true;
104   }
105 
106   function isActive() constant returns (bool) {
107     return (
108         initialized == true &&
109         now >= START && // Must be after the START date
110         now <= START.add(DAYS * 1 days) && // Must be before the end date
111         goalReached() == false // Goal must not already be reached
112     );
113   }
114 
115   function goalReached() constant returns (bool) {
116     return (raisedAmount >= CAP * 1 ether);
117   }
118 
119   function () payable {
120     buyTokens();
121   }
122 
123   /**
124   * @dev function that sells available tokens
125   */
126   function buyTokens() payable whenSaleIsActive {
127 
128     // Calculate tokens to sell
129     uint256 weiAmount = msg.value;
130     uint256 tokens = weiAmount.mul(RATE);
131 
132     BoughtTokens(msg.sender, tokens);
133 
134     // Increment raised amount
135     raisedAmount = raisedAmount.add(msg.value);
136     
137     // Send tokens to buyer
138     token.transfer(msg.sender, tokens);
139     
140     // Send money to owner
141     owner.transfer(msg.value);
142   }
143 
144   /**
145    * @dev returns the number of tokens allocated to this contract
146    */
147   function tokensAvailable() constant returns (uint256) {
148     return token.balanceOf(this);
149   }
150 
151   /**
152    * @notice Terminate contract and refund to owner
153    */
154   function destroy() onlyOwner {
155     // Transfer tokens back to owner
156     uint256 balance = token.balanceOf(this);
157     assert(balance > 0);
158     token.transfer(owner, balance);
159 
160     // There should be no ether in the contract but just in case
161     selfdestruct(owner);
162   }
163 
164 }