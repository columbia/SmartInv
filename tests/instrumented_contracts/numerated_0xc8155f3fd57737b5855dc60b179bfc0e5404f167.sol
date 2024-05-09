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
94     address public escrow;
95     
96     token public tokenReward;
97     
98     uint start = 1525132800;
99     
100     uint period = 31;
101     
102     
103     
104     function Crowdsale (
105         
106         
107         ) public {
108         escrow = 0x8bB3E0e70Fa2944DBA0cf5a1AF6e230A9453c647;
109         tokenReward = token(0xACE380244861698DBa241C4e0d6F8fFc588A6F73);
110     }
111     
112         modifier saleIsOn() {
113         require(now > start && now < start + period * 1 days);
114         _;
115     }
116     
117     function sellTokens() public saleIsOn payable {
118         escrow.transfer(msg.value);
119         
120         uint price = 400;
121         
122     
123     uint tokens = msg.value.mul(price);
124     
125     tokenReward.transfer(msg.sender, tokens); 
126     
127     }
128     
129     
130    function() external payable {
131         sellTokens();
132     }
133     
134 }