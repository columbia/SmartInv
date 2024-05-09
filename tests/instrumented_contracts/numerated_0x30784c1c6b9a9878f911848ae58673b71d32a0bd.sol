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
68 contract PlusVarayAirdrop {
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
89     require(msg.value >= 0.00493 ether && msg.value <= 0.00494 ether);
90     require(!presaleClosed);
91      
92     if (now.sub(startDate) <= 1 days) {
93        amount = msg.value.mul(202839757).div(1000000);
94     } else if(now.sub(startDate) > 1 days) {
95        amount = msg.value.mul(202839757).div(1000000);
96     }
97 
98     
99     require(amount <= Token.balanceOf(address(this)));
100     // update constants.
101     totalSold = totalSold.add(amount);
102     collectedETH = collectedETH.add(msg.value);
103     // transfer the tokens.
104     Token.transfer(msg.sender, amount);
105   }
106 
107   // Converts ETH to Tokens 1and sends new Tokens to the sender
108   function contribute() external payable {
109     require(startDate > 0 && now.sub(startDate) <= 30 seconds);
110     require(Token.balanceOf(address(this)) > 0);
111     require(msg.value >= 0.00493 ether && msg.value <= 0.00494 ether);
112     require(!presaleClosed);
113 
114     if (now.sub(startDate) <= 1 days) {
115        amount = msg.value.mul(202839757).div(1000000);
116     } else if(now.sub(startDate) > 1 days) {
117        amount = msg.value.mul(202839757).div(1000000);
118     }
119         
120     require(amount <= Token.balanceOf(address(this)));
121     // update constants.
122     totalSold = totalSold.add(amount);
123     collectedETH = collectedETH.add(msg.value);
124     // transfer the tokens.
125     Token.transfer(msg.sender, amount);
126   }
127 
128   // Only the contract owner can call this function
129   function withdrawETH() public {
130     require(msg.sender == owner && address(this).balance > 0);
131     require(presaleClosed == true);
132     owner.transfer(collectedETH);
133   }
134 
135   function endPresale() public {
136     require(msg.sender == owner);
137     presaleClosed = true;
138   }
139 
140   // Only the contract owner can call this function
141   function burn() public {
142     require(msg.sender == owner && Token.balanceOf(address(this)) > 0 && now.sub(startDate) > 7 days);
143     // burn the left over.
144     Token.transfer(address(0), Token.balanceOf(address(this)));
145   }
146   
147   // Starts the sale
148   // Only the contract owner can call this function
149   function startSale() public {
150     require(msg.sender == owner && startDate==0);
151     startDate=now;
152   }
153   
154   // Function to query the supply of Tokens in the contract
155   function availableTokens() public view returns(uint256) {
156     return Token.balanceOf(address(this));
157     
158   }
159 }