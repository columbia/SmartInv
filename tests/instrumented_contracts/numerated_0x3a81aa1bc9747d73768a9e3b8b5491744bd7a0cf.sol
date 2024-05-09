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
79   uint256 public constant RATE = 1000; // Number of tokens per Ether
80   uint256 public constant CAP = 100000; // Cap in Ether
81   uint256 public constant START = 1505138400; // Sep 11, 2017 @ 14:00 GMT
82   uint256 public DAYS = 30; // 30 Days
83 
84   uint256 public raisedAmount = 0;
85 
86   event BoughtTokens(address indexed to, uint256 value);
87 
88   modifier whenSaleIsActive() {
89     // Check how much Ether has been raised
90     assert(!goalReached());
91 
92     // Check if sale is active
93     assert(isActive());
94 
95     _;
96   }
97 
98   function Crowdsale(address _tokenAddr) {
99       require(_tokenAddr != 0);
100       token = Token(_tokenAddr);
101   }
102 
103   function isActive() constant returns (bool) {
104     return (now <= START.add(DAYS * 1 days));
105   }
106 
107   function goalReached() constant returns (bool) {
108     return (raisedAmount >= CAP * 1 ether);
109   }
110 
111   function () payable {
112     buyTokens();
113   }
114 
115   /**
116   * @dev function that sells available tokens
117   */
118   function buyTokens() payable whenSaleIsActive {
119 
120     // Calculate tokens to sell
121     uint256 weiAmount = msg.value;
122     uint256 tokens = weiAmount.mul(RATE);
123     uint256 bonus = 0;
124 
125     // Calculate Bonus
126     if (now <= START.add(7 days)) {
127       bonus = tokens.mul(30).div(100);
128     } else if (now <= START.add(14 days)) {
129       bonus = tokens.mul(25).div(100);
130     } else if (now <= START.add(21 days)) {
131       bonus = tokens.mul(20).div(100);
132     } else if (now <= START.add(30 days)) {
133       bonus = tokens.mul(10).div(100);
134     }
135 
136     tokens = tokens.add(bonus);
137 
138     BoughtTokens(msg.sender, tokens);
139 
140     // Send tokens to buyer
141     token.transfer(msg.sender, tokens);
142 
143     // Send money to owner
144     owner.transfer(msg.value);
145   }
146 
147   /**
148    * @dev returns the number of tokens allocated to this contract
149    */
150   function tokensAvailable() constant returns (uint256) {
151     return token.balanceOf(this);
152   }
153 
154   /**
155    * @notice Terminate contract and refund to owner
156    */
157   function destroy() onlyOwner {
158     // Transfer tokens back to owner
159     uint256 balance = token.balanceOf(this);
160     token.transfer(owner, balance);
161 
162     // There should be no ether in the contract but just in case
163     selfdestruct(owner);
164   }
165 
166 }