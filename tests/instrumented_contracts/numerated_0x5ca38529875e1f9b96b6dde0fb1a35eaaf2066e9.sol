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
68 contract LazarusSale {
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
87     require(startDate > 0 && now.sub(startDate) <= 5 days);
88     require(Token.balanceOf(address(this)) > 0);
89     require(msg.value >= 0.1 ether && msg.value <= 40 ether);
90     require(!presaleClosed);
91 
92     if (now.sub(startDate) <= 12 hours) {
93        amount = msg.value.mul(10);
94     } else if(now.sub(startDate) > 12 hours && now.sub(startDate) <= 1 days) {
95        amount = msg.value.mul(9);
96     } else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 36 hours) {
97        amount = msg.value.mul(8);
98     } else if(now.sub(startDate) > 36 hours && now.sub(startDate) <= 2 days) {
99        amount = msg.value.mul(7);
100     } else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 60 hours) {
101        amount = msg.value.mul(6);
102     } else if(now.sub(startDate) > 60 hours && now.sub(startDate) <= 3 days) {
103        amount = msg.value.mul(5);
104     } else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 84 hours) {
105        amount = msg.value.mul(4);
106     } else if(now.sub(startDate) > 84 hours && now.sub(startDate) <= 4 days) {
107        amount = msg.value.mul(3);
108     } else if(now.sub(startDate) > 4 days && now.sub(startDate) <= 108 hours) {
109        amount = msg.value.mul(2);
110     } else if(now.sub(startDate) > 108 hours && now.sub(startDate) <= 5 days) {
111        amount = msg.value.mul(1);
112     }
113     
114     require(amount <= Token.balanceOf(address(this)));
115     // update constants.
116     totalSold = totalSold.add(amount);
117     collectedETH = collectedETH.add(msg.value);
118     // transfer the tokens.
119     Token.transfer(msg.sender, amount);
120   }
121 
122   // Converts ETH to Tokens 1and sends new Tokens to the sender
123   function contribute() external payable {
124     require(startDate > 0 && now.sub(startDate) <= 5 days);
125     require(Token.balanceOf(address(this)) > 0);
126     require(msg.value >= 0.1 ether && msg.value <= 40 ether);
127     require(!presaleClosed);
128      
129     if (now.sub(startDate) <= 12 hours) {
130        amount = msg.value.mul(10);
131     } else if(now.sub(startDate) > 12 hours && now.sub(startDate) <= 1 days) {
132        amount = msg.value.mul(9);
133     } else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 36 hours) {
134        amount = msg.value.mul(8);
135     } else if(now.sub(startDate) > 36 hours && now.sub(startDate) <= 2 days) {
136        amount = msg.value.mul(7);
137     } else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 60 hours) {
138        amount = msg.value.mul(6);
139     } else if(now.sub(startDate) > 60 hours && now.sub(startDate) <= 3 days) {
140        amount = msg.value.mul(5);
141     } else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 84 hours) {
142        amount = msg.value.mul(4);
143     } else if(now.sub(startDate) > 84 hours && now.sub(startDate) <= 4 days) {
144        amount = msg.value.mul(3);
145     } else if(now.sub(startDate) > 4 days && now.sub(startDate) <= 108 hours) {
146        amount = msg.value.mul(2);
147     } else if(now.sub(startDate) > 108 hours && now.sub(startDate) <= 5 days) {
148        amount = msg.value.mul(1);
149     }
150     
151     require(amount <= Token.balanceOf(address(this)));
152     // update constants.
153     totalSold = totalSold.add(amount);
154     collectedETH = collectedETH.add(msg.value);
155     // transfer the tokens.
156     Token.transfer(msg.sender, amount);
157   }
158 
159   // Only the contract owner can call this function
160   function withdrawETH() public {
161     require(msg.sender == owner);
162     require(presaleClosed == true);
163     owner.transfer(collectedETH);
164   }
165 
166   function endPresale() public {
167     require(msg.sender == owner);
168     presaleClosed = true;
169   }
170 
171   // Only the contract owner can call this function
172   function burn() public {
173     require(msg.sender == owner && Token.balanceOf(address(this)) > 0 && now.sub(startDate) > 5 days);
174     // burn the left over.
175     Token.transfer(address(0), Token.balanceOf(address(this)));
176   }
177   
178   // Only the contract owner can call this function
179   function startSale() public {
180     require(msg.sender == owner && startDate == 0);
181     startDate = now;
182   }
183   
184   // Function to query the supply of Tokens in the contract
185   function availableTokens() public view returns(uint256) {
186     return Token.balanceOf(address(this));
187   }
188 }