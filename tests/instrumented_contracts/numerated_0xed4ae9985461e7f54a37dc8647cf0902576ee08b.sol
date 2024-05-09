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
65 contract Crowdsale is Ownable {
66 
67   using SafeMath for uint256;
68 
69   Token public token;
70 
71   uint256 public constant RATE = 2000; // Number of tokens per Ether
72   uint256 public constant CAP = 500; // Cap in Ether
73   uint256 public constant START = now; // Sep 5, 2017 @ 08:00 GMT+1
74   uint256 public constant DAYS = 7; // 7 Days
75 
76   uint256 public constant initialTokens = 1000000 * 10**18; // Initial number of tokens available
77   bool public initialized = false;
78   uint256 public raisedAmount = 0;
79 
80   event BoughtTokens(address indexed to, uint256 value);
81 
82   modifier whenSaleIsActive() {
83     // Check if sale is active
84     assert(isActive());
85 
86     _;
87   }
88 
89   function Crowdsale(address _tokenAddr) {
90       require(_tokenAddr != 0);
91       token = Token(_tokenAddr);
92   }
93   
94   function initialize() onlyOwner {
95       require(initialized == false); // Can only be initialized once
96       require(tokensAvailable() == initialTokens); // Must have some tokens allocated
97       initialized = true;
98   }
99 
100   function isActive() constant returns (bool) {
101     return (
102         initialized == true &&
103         now >= START && // Must be after the START date
104         now <= START.add(DAYS * 1 days) && // Must be before the end date
105         goalReached() == false // Goal must not already be reached
106     );
107   }
108 
109   function goalReached() constant returns (bool) {
110     return (raisedAmount >= CAP * 1 ether);
111   }
112 
113   function () payable {
114     buyTokens();
115   }
116 
117   /**
118   * @dev function that sells available tokens
119   */
120   function buyTokens() payable whenSaleIsActive {
121 
122     // Calculate tokens to sell
123     uint256 weiAmount = msg.value;
124     uint256 tokens = weiAmount.mul(RATE);
125 
126     BoughtTokens(msg.sender, tokens);
127 
128     // Increment raised amount
129     raisedAmount = raisedAmount.add(msg.value);
130     
131     // Send tokens to buyer
132     token.transfer(msg.sender, tokens);
133     
134     // Send money to owner
135     owner.transfer(msg.value);
136   }
137 
138   /**
139    * @dev returns the number of tokens allocated to this contract
140    */
141   function tokensAvailable() constant returns (uint256) {
142     return token.balanceOf(this);
143   }
144 
145   /**
146    * @notice Terminate contract and refund to owner
147    */
148   function destroy() onlyOwner {
149     // Transfer tokens back to owner
150     uint256 balance = token.balanceOf(this);
151     assert(balance > 0);
152     token.transfer(owner, balance);
153 
154     // There should be no ether in the contract but just in case
155     selfdestruct(owner);
156   }
157 
158 }