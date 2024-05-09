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
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39 
40   address public owner;
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner {
63     require(newOwner != address(0));
64     owner = newOwner;
65   }
66 }
67 
68 /**
69  * @title Token
70  * @dev API interface for interacting with the Ethereum Pink Token contract
71  */
72 interface Token {
73   function transfer(address _to, uint256 _value) returns (bool);
74   function balanceOf(address _owner) constant returns (uint256 balance);
75 }
76 
77 contract PreSale is Ownable {
78 
79   using SafeMath for uint256;
80 
81   Token token;
82 
83   uint256 public constant RATE = 3900; // Number of tokens per Ether
84   uint256 public constant CAP = 2000; // Cap in Ether
85   uint256 public constant START = 1528934400; // Thursday, June 14 2018 12:00:00 AM GMT
86   uint256 public constant DAYS = 32; // 32 Day
87 
88   uint256 public constant initialTokens = 7800000 * 10**18; // Initial number of tokens available
89   bool public initialized = false;
90   uint256 public raisedAmount = 0;
91 
92   event BoughtTokens(address indexed to, uint256 value);
93 
94   modifier whenSaleIsActive() {
95     // Check if sale is active
96     assert(isActive());
97 
98     _;
99   }
100 
101   function PreSale(address _tokenAddr) {
102       require(_tokenAddr != 0);
103       token = Token(_tokenAddr);
104   }
105 
106   function initialize() onlyOwner {
107       require(initialized == false); // Can only be initialized once
108       require(tokensAvailable() == initialTokens); // Must have enough tokens allocated
109       initialized = true;
110   }
111 
112   function isActive() constant returns (bool) {
113     return (
114         initialized == true &&
115         now >= START && // Must be after the START date
116         now <= START.add(DAYS * 1 days) && // Must be before the end date
117         goalReached() == false // Goal must not already be reached
118     );
119   }
120 
121   function goalReached() constant returns (bool) {
122     return (raisedAmount >= CAP * 1 ether);
123   }
124 
125   function () payable {
126     buyTokens();
127   }
128 
129   /**
130   * @dev function that sells available tokens
131   */
132   function buyTokens() payable whenSaleIsActive {
133     // Calculate tokens to sell
134     uint256 weiAmount = msg.value;
135     uint256 tokens = weiAmount.mul(RATE);
136 
137     BoughtTokens(msg.sender, tokens);
138 
139     // Increment raised amount
140     raisedAmount = raisedAmount.add(msg.value);
141 
142     // Send tokens to buyer
143     token.transfer(msg.sender, tokens);
144 
145     // Send money to owner
146     owner.transfer(msg.value);
147   }
148 
149   /**
150    * @dev returns the number of tokens allocated to this contract
151    */
152   function tokensAvailable() constant returns (uint256) {
153     return token.balanceOf(this);
154   }
155 
156   /**
157    * @notice Terminate contract and refund to owner
158    */
159   function destroy() onlyOwner {
160     // Transfer tokens back to owner
161     uint256 balance = token.balanceOf(this);
162     assert(balance > 0);
163     token.transfer(owner, balance);
164 
165     // There should be no ether in the contract but just in case
166     selfdestruct(owner);
167   }
168 
169 }