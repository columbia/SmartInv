1 pragma solidity ^0.4.21;
2 
3 
4 contract ERC20Basic {
5   function totalSupply() public view returns (uint256);
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender)
13   public view returns (uint256);
14 
15   function transferFrom(address from, address to, uint256 value)
16   public returns (bool);
17 
18   function approve(address spender, uint256 value) public returns (bool);
19   event Approval(
20     address indexed owner,
21     address indexed spender,
22     uint256 value
23   );
24 }
25 
26 library SafeERC20 {
27   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
28     require(token.transfer(to, value));
29   }
30 
31   function safeTransferFrom(
32     ERC20 token,
33     address from,
34     address to,
35     uint256 value
36   )
37     internal
38   {
39     require(token.transferFrom(from, to, value));
40   }
41 
42   function safeApprove(ERC20 token, address spender, uint256 value) internal {
43     require(token.approve(spender, value));
44   }
45 }
46 /**
47  * @title SafeMath
48  * @dev Math   with safety checks that throw on error
49  */
50 library SafeMath {
51     /**
52      * mul
53      * @dev Safe math multiply function
54      */
55   function mul(uint256 a, uint256 b) internal pure returns (uint256){
56     uint256 c = a * b;
57     assert(a == 0 || c / a == b);
58     return c;
59   }
60   /**
61    * add
62    * @dev Safe math addition function
63    */
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 
70     /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     // uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return a / b;
78   }
79 
80 }
81 
82 /**
83  * @title Ownable
84  * @dev Ownable has an owner address to simplify "user permissions".
85  */
86 contract Ownable {
87   address public owner;
88 
89   /**
90    * Ownable
91    * @dev Ownable constructor sets the `owner` of the contract to sender
92    */
93   constructor() public {
94     owner = msg.sender;
95   }
96 
97   /**
98    * ownerOnly
99    * @dev Throws an error if called by any account other than the owner.
100    */
101   modifier onlyOwner() {
102     require(msg.sender == owner);
103     _;
104   }
105 
106   /**
107    * transferOwnership
108    * @dev Allows the current owner to transfer control of the contract to a newOwner.
109    * @param newOwner The address to transfer ownership to.
110    */
111   function transferOwnership(address newOwner) public onlyOwner {
112     require(newOwner != address(0));
113     owner = newOwner;
114   }
115 }
116 
117 /**
118  * @title LavevelICO
119  * @dev LavevelICO contract is Ownable
120  **/
121 contract AFDTICO is Ownable {
122   using SafeERC20 for ERC20Basic;
123   // ERC20 basic token contract being held
124   ERC20Basic public token;
125   using SafeMath for uint256;
126  
127   uint256 public RATE = 2188; // 以太兑换AFDT比例
128   uint256 public minimum = 10000000000000000;   //0.01ETH
129 //   uint256 public constant initialTokens = 1000000 * 10**8; // Initial number of tokens available
130   address public constant FAVOREE = 0x57f3495D0eb2257F1B0Dbbc77a8A49E4AcAC82f5; //受益人账号
131   uint256 public raisedAmount = 0; //合约以太数量
132   
133   /**
134    * BoughtTokens
135    * @dev Log tokens bought onto the blockchain
136    */
137   event BoughtTokens(address indexed to, uint256 value, uint256 tokens);
138 
139   constructor(ERC20Basic _token) public {
140       token = _token;
141   }
142 
143   /**
144    * @dev Fallback function if ether is sent to address insted of buyTokens function
145    **/
146   function () public payable {
147 
148     buyTokens();
149   }
150 
151   /**
152    * buyTokens
153    * @dev function that sells available tokens
154    **/
155   function buyTokens() public payable {
156     require(msg.value >= minimum);
157     uint256 tokens = msg.value.mul(RATE).div(10**10);  //应得AFDT数量
158     uint256 balance = token.balanceOf(this);     //合约拥有AFDT数量
159     if (tokens > balance){                       //如果应得数量大于合约拥有数量返还ETH
160         msg.sender.transfer(msg.value);
161     }
162     
163     else{
164         token.transfer(msg.sender, tokens); // Send tokens to buyer
165         emit BoughtTokens(msg.sender, msg.value, tokens);
166         raisedAmount = raisedAmount.add(msg.value);
167     }
168  }
169 
170   /**
171    * tokensAvailable
172    * @dev returns the number of tokens allocated to this contract
173    **/
174   function tokensAvailable() public constant returns (uint256) {
175     return token.balanceOf(this);
176   }
177 
178   function ratio(uint256 _RATE) onlyOwner public {
179       RATE = _RATE;
180   }
181   
182   function withdrawals() onlyOwner public {
183       FAVOREE.transfer(raisedAmount);
184       raisedAmount = 0;
185   }
186   
187   function adjust_eth(uint256 _minimum) onlyOwner  public {
188       minimum = _minimum;
189   }
190   /**
191    * destroy
192    * @notice Terminate contract and refund to owner
193    **/
194   function destroy() onlyOwner public {
195     // Transfer tokens back to owner
196     uint256 balance = token.balanceOf(this);
197     assert(balance > 0);
198     token.transfer(FAVOREE, balance);
199     // There should be no ether in the contract but just in case
200     selfdestruct(FAVOREE); 
201   }
202 }