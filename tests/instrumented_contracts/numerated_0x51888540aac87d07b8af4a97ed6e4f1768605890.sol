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
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) public view returns (uint256);
89   function transferFrom(address from, address to, uint256 value) public returns (bool);
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 library SafeERC20 {
95   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
96     assert(token.transfer(to, value));
97   }
98 
99   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
100     assert(token.transferFrom(from, to, value));
101   }
102 
103   function safeApprove(ERC20 token, address spender, uint256 value) internal {
104     assert(token.approve(spender, value));
105   }
106 }
107 
108 contract TokenVesting is Ownable {
109   using SafeMath for uint256;
110   using SafeERC20 for ERC20Basic;
111 
112   event Released(uint256 amount);
113   event Revoked();
114 
115   // beneficiary of tokens after they are released
116   address public beneficiary;
117 
118   uint256 public cliff;
119   uint256 public start;
120   uint256 public duration;
121 
122   bool public revocable;
123 
124   mapping (address => uint256) public released;
125   mapping (address => bool) public revoked;
126 
127   /**
128    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
129    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
130    * of the balance will have vested.
131    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
132    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
133    * @param _duration duration in seconds of the period in which the tokens will vest
134    * @param _revocable whether the vesting is revocable or not
135    */
136   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
137     require(_beneficiary != address(0));
138     require(_cliff <= _duration);
139 
140     beneficiary = _beneficiary;
141     revocable = _revocable;
142     duration = _duration;
143     cliff = _start.add(_cliff);
144     start = _start;
145   }
146 
147   /**
148    * @notice Transfers vested tokens to beneficiary.
149    * @param token ERC20 token which is being vested
150    */
151   function release(ERC20Basic token) public {
152     uint256 unreleased = releasableAmount(token);
153 
154     require(unreleased > 0);
155 
156     released[token] = released[token].add(unreleased);
157 
158     token.safeTransfer(beneficiary, unreleased);
159 
160     Released(unreleased);
161   }
162 
163   /**
164    * @notice Allows the owner to revoke the vesting. Tokens already vested
165    * remain in the contract, the rest are returned to the owner.
166    * @param token ERC20 token which is being vested
167    */
168   function revoke(ERC20Basic token) public onlyOwner {
169     require(revocable);
170     require(!revoked[token]);
171 
172     uint256 balance = token.balanceOf(this);
173 
174     uint256 unreleased = releasableAmount(token);
175     uint256 refund = balance.sub(unreleased);
176 
177     revoked[token] = true;
178 
179     token.safeTransfer(owner, refund);
180 
181     Revoked();
182   }
183 
184   /**
185    * @dev Calculates the amount that has already vested but hasn't been released yet.
186    * @param token ERC20 token which is being vested
187    */
188   function releasableAmount(ERC20Basic token) public view returns (uint256) {
189     return vestedAmount(token).sub(released[token]);
190   }
191 
192   /**
193    * @dev Calculates the amount that has already vested.
194    * @param token ERC20 token which is being vested
195    */
196   function vestedAmount(ERC20Basic token) public view returns (uint256) {
197     uint256 currentBalance = token.balanceOf(this);
198     uint256 totalBalance = currentBalance.add(released[token]);
199 
200     if (now < cliff) {
201       return 0;
202     } else if (now >= start.add(duration) || revoked[token]) {
203       return totalBalance;
204     } else {
205       return totalBalance.mul(now.sub(start)).div(duration);
206     }
207   }
208 }