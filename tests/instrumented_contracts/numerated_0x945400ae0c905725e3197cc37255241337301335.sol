1 pragma solidity ^0.4.16;
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
68 interface Token {
69   function transfer(address _to, uint256 _value) returns (bool);
70   function balanceOf(address _owner) constant returns (uint256 balance);
71 }
72 
73 contract Crowdsale is Ownable {
74 
75   using SafeMath for uint256;
76 
77   Token token;
78 
79   uint256 public constant RATE = 312; // Number of tokens per Ether
80   uint256 public constant START = 1505433600; // Sep 15, 2017 @ 00:00 GMT
81   uint256 public DAYS = 20; // 20 Days
82 
83   uint256 public constant initialTokens = 15600000 * 10**18; // Initial number of tokens available
84   bool public initialized = false;
85 
86   uint256 public raisedAmount = 0;
87 
88   event BoughtTokens(address indexed to, uint256 value);
89 
90   modifier whenSaleIsActive() {
91     // Check if sale is active
92     assert(isActive());
93 
94     _;
95   }
96 
97   function Crowdsale(address _tokenAddr) {
98       require(_tokenAddr != 0);
99       token = Token(_tokenAddr);
100   }
101   
102   function initialize() onlyOwner {
103       require(initialized == false); // Can only be initialized once
104       require(tokensAvailable() == initialTokens); // Must have enough tokens allocated
105       initialized = true;
106   }
107 
108   function isActive() constant returns (bool) {
109     return (
110         initialized == true &&
111         now >= START && // Must be after the START date
112         now <= START.add(DAYS * 1 days) // Must be before the end date
113     );
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
124 
125     // Calculate tokens to sell
126     uint256 weiAmount = msg.value;
127     uint256 tokens = weiAmount.mul(RATE);
128     uint256 bonus = 0;
129 
130     require(tokens >= 1);
131 
132     // Calculate Bonus
133     if (now <= START.add(5 days)) {
134       bonus = tokens.mul(20).div(100);
135     } else if (now <= START.add(8 days)) {
136       bonus = tokens.mul(10).div(100);
137     } else if (now <= START.add(18 days)) {
138       bonus = tokens.mul(5).div(100);
139     }
140     
141     tokens = tokens.add(bonus);
142 
143     BoughtTokens(msg.sender, tokens);
144 
145     // Send tokens to buyer
146     token.transfer(msg.sender, tokens);
147 
148     // Send money to owner
149     owner.transfer(msg.value);
150   }
151 
152   /**
153    * @dev returns the number of tokens allocated to this contract
154    */
155   function tokensAvailable() constant returns (uint256) {
156     return token.balanceOf(this);
157   }
158 
159   /**
160    * @notice Terminate contract and refund to owner
161    */
162   function destroy() onlyOwner {
163     // Transfer tokens back to owner
164     uint256 balance = token.balanceOf(this);
165     token.transfer(owner, balance);
166 
167     // There should be no ether in the contract but just in case
168     selfdestruct(owner);
169   }
170 
171 }