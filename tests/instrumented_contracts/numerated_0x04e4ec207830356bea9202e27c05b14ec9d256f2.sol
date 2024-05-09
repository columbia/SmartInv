1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract VestingFund is Ownable {
81   using SafeMath for uint256;
82   using SafeERC20 for ERC20Basic;
83 
84   event Released(uint256 amount);
85 
86   // beneficiary of tokens after they are released
87   address public beneficiary;
88   ERC20Basic public token;
89 
90   uint256 public quarters;
91   uint256 public start;
92 
93 
94   uint256 public released;
95 
96   /**
97    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
98    * _beneficiary, tokens are release in an incremental fashion after a quater has passed until _start + _quarters * 3 * months. 
99    * By then all of the balance will have vested.
100    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
101    * @param _quarters number of quarters the vesting will last
102    * @param _token ERC20 token which is being vested
103    */
104   function VestingFund(address _beneficiary, uint256 _start, uint256 _quarters, address _token) public {
105     
106     require(_beneficiary != address(0) && _token != address(0));
107     require(_quarters > 0);
108 
109     beneficiary = _beneficiary;
110     quarters = _quarters;
111     start = _start;
112     token = ERC20Basic(_token);
113   }
114 
115   /**
116    * @notice Transfers vested tokens to beneficiary.
117    */
118   function release() public {
119     uint256 unreleased = releasableAmount();
120     require(unreleased > 0);
121 
122     released = released.add(unreleased);
123     token.safeTransfer(beneficiary, unreleased);
124 
125     Released(unreleased);
126   }
127 
128   /**
129    * @dev Calculates the amount that has already vested but hasn't been released yet.
130    */
131   function releasableAmount() public view returns(uint256) {
132     return vestedAmount().sub(released);
133   }
134 
135   /**
136    * @dev Calculates the amount that has already vested.
137    */
138   function vestedAmount() public view returns(uint256) {
139     uint256 currentBalance = token.balanceOf(this);
140     uint256 totalBalance = currentBalance.add(released);
141 
142     if (now < start) {
143       return 0;
144     }
145 
146     uint256 dT = now.sub(start); // time passed since start
147     uint256 dQuarters = dT.div(90 days); // quarters passed
148 
149     if (dQuarters >= quarters) {
150       return totalBalance; // return everything if vesting period ended
151     } else {
152       return totalBalance.mul(dQuarters).div(quarters); // ammount = total * (quarters passed / total quarters)
153     }
154   }
155 }
156 
157 contract ERC20Basic {
158   function totalSupply() public view returns (uint256);
159   function balanceOf(address who) public view returns (uint256);
160   function transfer(address to, uint256 value) public returns (bool);
161   event Transfer(address indexed from, address indexed to, uint256 value);
162 }
163 
164 contract ERC20 is ERC20Basic {
165   function allowance(address owner, address spender) public view returns (uint256);
166   function transferFrom(address from, address to, uint256 value) public returns (bool);
167   function approve(address spender, uint256 value) public returns (bool);
168   event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 library SafeERC20 {
172   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
173     assert(token.transfer(to, value));
174   }
175 
176   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
177     assert(token.transferFrom(from, to, value));
178   }
179 
180   function safeApprove(ERC20 token, address spender, uint256 value) internal {
181     assert(token.approve(spender, value));
182   }
183 }