1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     emit OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93   function totalSupply() public view returns (uint256);
94   function balanceOf(address who) public view returns (uint256);
95   function transfer(address to, uint256 value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public view returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 library SafeERC20 {
109   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
110     assert(token.transfer(to, value));
111   }
112 
113   function safeTransferFrom(
114     ERC20 token,
115     address from,
116     address to,
117     uint256 value
118   )
119     internal
120   {
121     assert(token.transferFrom(from, to, value));
122   }
123 
124   function safeApprove(ERC20 token, address spender, uint256 value) internal {
125     assert(token.approve(spender, value));
126   }
127 }
128 /**
129  * @title TokenVesting
130  * @dev A token holder contract that can release its token balance gradually like a
131  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
132  * owner.
133  */
134 contract TokenVesting is Ownable {
135   using SafeMath for uint256;
136   using SafeERC20 for ERC20Basic;
137 
138   event Released(uint256 amount);
139   event Revoked();
140 
141   // beneficiary of tokens after they are released
142   address public beneficiary;
143   
144   ERC20Basic public token;
145   address public addressToken; 
146   uint256 public cliff;
147   uint256 public start;
148   uint256 public duration;
149 
150   mapping (address => uint256) public released;
151   mapping (address => bool) public revoked;
152 
153   /**
154    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
155    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
156    * of the balance will have vested.
157    */
158   function TokenVesting() public
159   { 
160     //address of the beneficiary to whom vested tokens are transferred
161     beneficiary = 0xEdc62572208C819ee413a2e19a037BbC3eA1F9c8; //address of team
162     //duration in seconds of the period in which the tokens will vest
163     duration = 24 * 31 * 24 * 60 * 60; 
164     //date of start
165     start = 1523275200; //09 Apr 2018 12:00:00 
166     cliff = start;
167   }
168 
169   function setToken(address _addressToken) public onlyOwner{
170     require(_addressToken != address(0));  
171     addressToken = _addressToken;  
172     token = ERC20Basic(_addressToken);  
173   }
174  
175   function release() public {
176     uint256 unreleased = releasableAmount();
177     require(addressToken != address(0));
178     require(unreleased > 0);
179 
180     released[token] = released[token].add(unreleased);
181 
182     token.safeTransfer(beneficiary, unreleased);
183 
184     emit Released(unreleased);
185   }
186 
187 
188   /**
189    * Calculates the amount that has already vested but hasn't been released yet.
190    */
191   function releasableAmount() public view returns (uint256) {
192     return vestedAmount().sub(released[token]);
193   }
194 
195   /**
196    * Calculates the amount that has already vested.
197    */
198   function vestedAmount() public view returns (uint256) {
199     uint256 currentBalance = token.balanceOf(this);
200     uint256 totalBalance = currentBalance.add(released[token]);
201 
202     if (block.timestamp < cliff) {
203       return 0;
204     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
205       return totalBalance;
206     } else {
207       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
208     }
209   }
210 }