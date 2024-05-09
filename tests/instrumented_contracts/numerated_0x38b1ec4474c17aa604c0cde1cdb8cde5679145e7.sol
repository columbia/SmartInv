1 pragma solidity 0.6.8;
2 
3 library SafeMath {
4   /**
5   * @dev Multiplies two unsigned integers, reverts on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12         return 0;
13     }
14 
15     uint256 c = a * b;
16     require(c / a == b);
17 
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // Solidity only automatically asserts when dividing by 0
26     require(b > 0);
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two unsigned integers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 interface ERC20 {
64   function balanceOf(address who) external view returns (uint256);
65   function transfer(address to, uint value) external  returns (bool success);
66 }
67 
68 contract MoonbeamSale {
69   using SafeMath for uint256;
70 
71   uint256 public totalSold;
72   ERC20 public Token;
73   address payable public owner;
74   uint256 public collectedETH;
75   uint256 public startDate;
76   bool private presaleClosed = false;
77 
78   constructor(address _wallet) public {
79     owner = msg.sender;
80     Token = ERC20(_wallet);
81   }
82 
83   uint256 amount;
84  
85   // Converts ETH to Tokens and sends new Tokens to the sender
86   receive () external payable {
87     require(startDate > 0 && now.sub(startDate) <= 7 days);
88     require(Token.balanceOf(address(this)) > 0);
89     require(msg.value >= 0.1 ether && msg.value <= 60 ether);
90     require(!presaleClosed);
91      
92     if (now.sub(startDate) <= 1 days) {
93        amount = msg.value.mul(45);
94     } else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days) {
95        amount = msg.value.mul(85).div(2);
96     } else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days) {
97        amount = msg.value.mul(40);
98     } else if(now.sub(startDate) > 3 days) {
99        amount = msg.value.mul(75).div(2);
100     }
101     
102     require(amount <= Token.balanceOf(address(this)));
103     // update constants.
104     totalSold = totalSold.add(amount);
105     collectedETH = collectedETH.add(msg.value);
106     // transfer the tokens.
107     Token.transfer(msg.sender, amount);
108   }
109 
110   // Converts ETH to Tokens 1and sends new Tokens to the sender
111   function contribute() external payable {
112     require(startDate > 0 && now.sub(startDate) <= 7 days);
113     require(Token.balanceOf(address(this)) > 0);
114     require(msg.value >= 0.1 ether && msg.value <= 60 ether);
115     require(!presaleClosed);
116      
117     if (now.sub(startDate) <= 1 days) {
118        amount = msg.value.mul(45);
119     } else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days) {
120        amount = msg.value.mul(85).div(2);
121     } else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days) {
122        amount = msg.value.mul(40);
123     } else if(now.sub(startDate) > 3 days) {
124        amount = msg.value.mul(75).div(2);
125     }
126     
127     require(amount <= Token.balanceOf(address(this)));
128     // update constants.
129     totalSold = totalSold.add(amount);
130     collectedETH = collectedETH.add(msg.value);
131     // transfer the tokens.
132     Token.transfer(msg.sender, amount);
133   }
134 
135   // Only the contract owner can call this function
136   function withdrawETH() public {
137     require(msg.sender == owner);
138     require(presaleClosed == true);
139     owner.transfer(collectedETH);
140   }
141 
142   function endPresale() public {
143     require(msg.sender == owner);
144     presaleClosed = true;
145   }
146 
147   // Only the contract owner can call this function
148   function burn() public {
149     require(msg.sender == owner && Token.balanceOf(address(this)) > 0 && now.sub(startDate) > 7 days);
150     // burn the left over.
151     Token.transfer(address(0), Token.balanceOf(address(this)));
152   }
153   
154   // Starts the sale
155   // Only the contract owner can call this function
156   function startSale() public {
157     require(msg.sender == owner && startDate==0);
158     startDate=now;
159   }
160   
161   // Function to query the supply of Tokens in the contract
162   function availableTokens() public view returns(uint256) {
163     return Token.balanceOf(address(this));
164   }
165 }