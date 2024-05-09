1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60     
61   address public owner;
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public{
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) private onlyOwner {
84     require(newOwner != address(0));      
85     owner = newOwner;
86   }
87 
88 }
89 
90 contract Crowdsale is Ownable {
91     
92     using SafeMath for uint;
93     
94     address owner;
95     
96     token public tokenReward;
97     
98     uint start = 1523232000;
99     
100     uint period = 22;
101     
102     
103     
104     function Crowdsale (
105         address addressOfTokenUsedAsReward
106         ) public {
107         owner = msg.sender;
108         tokenReward = token(addressOfTokenUsedAsReward);
109     }
110     
111         modifier saleIsOn() {
112         require(now > start && now < start + period * 1 days);
113         _;
114     }
115     
116     function sellTokens() public saleIsOn payable {
117         owner.transfer(msg.value);
118         
119         uint price = 400;
120         
121 if(now < start + (period * 1 days ).div(2)) 
122 {  price = 800;} 
123 else if(now >= start + (period * 1 days).div(2) && now < start + (period * 1 days).div(4).mul(3)) 
124 {  price = 571;} 
125 else if(now >= start + (period * 1 days ).div(4).mul(3) && now < start + (period * 1 days )) 
126 {  price = 500;}
127     
128     uint tokens = msg.value.mul(price);
129     
130     tokenReward.transfer(msg.sender, tokens); 
131     
132     }
133     
134     
135    function() external payable {
136         sellTokens();
137     }
138     
139 }