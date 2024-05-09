1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 contract TokenVesting is Ownable {
55   using SafeMath for uint256;
56   using SafeERC20 for ERC20Basic;
57 
58   event Released(uint256 amount);
59   event Revoked();
60 
61   // beneficiary of tokens after they are released
62   address public beneficiary;
63 
64   uint256 public cliff;
65   uint256 public start;
66   uint256 public duration;
67 
68   bool public revocable;
69 
70   mapping (address => uint256) public released;
71   mapping (address => bool) public revoked;
72 
73   /**
74    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
75    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
76    * of the balance will have vested.
77    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
78    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
79    * @param _duration duration in seconds of the period in which the tokens will vest
80    * @param _revocable whether the vesting is revocable or not
81    */
82   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
83     require(_beneficiary != address(0));
84     require(_cliff <= _duration);
85 
86     beneficiary = _beneficiary;
87     revocable = _revocable;
88     duration = _duration;
89     cliff = _start.add(_cliff);
90     start = _start;
91   }
92 
93   /**
94    * @notice Transfers vested tokens to beneficiary.
95    * @param token ERC20 token which is being vested
96    */
97   function release(ERC20Basic token) public {
98     uint256 unreleased = releasableAmount(token);
99 
100     require(unreleased > 0);
101 
102     released[token] = released[token].add(unreleased);
103 
104     token.safeTransfer(beneficiary, unreleased);
105 
106     Released(unreleased);
107   }
108 
109   /**
110    * @notice Allows the owner to revoke the vesting. Tokens already vested
111    * remain in the contract, the rest are returned to the owner.
112    * @param token ERC20 token which is being vested
113    */
114   function revoke(ERC20Basic token) public onlyOwner {
115     require(revocable);
116     require(!revoked[token]);
117 
118     uint256 balance = token.balanceOf(this);
119 
120     uint256 unreleased = releasableAmount(token);
121     uint256 refund = balance.sub(unreleased);
122 
123     revoked[token] = true;
124 
125     token.safeTransfer(owner, refund);
126 
127     Revoked();
128   }
129 
130   /**
131    * @dev Calculates the amount that has already vested but hasn't been released yet.
132    * @param token ERC20 token which is being vested
133    */
134   function releasableAmount(ERC20Basic token) public view returns (uint256) {
135     return vestedAmount(token).sub(released[token]);
136   }
137 
138   /**
139    * @dev Calculates the amount that has already vested.
140    * @param token ERC20 token which is being vested
141    */
142   function vestedAmount(ERC20Basic token) public view returns (uint256) {
143     uint256 currentBalance = token.balanceOf(this);
144     uint256 totalBalance = currentBalance.add(released[token]);
145 
146     if (now < cliff) {
147       return 0;
148     } else if (now >= start.add(duration) || revoked[token]) {
149       return totalBalance;
150     } else {
151       return totalBalance.mul(now.sub(start)).div(duration);
152     }
153   }
154 }
155 
156 library SafeERC20 {
157   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
158     assert(token.transfer(to, value));
159   }
160 
161   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
162     assert(token.transferFrom(from, to, value));
163   }
164 
165   function safeApprove(ERC20 token, address spender, uint256 value) internal {
166     assert(token.approve(spender, value));
167   }
168 }
169 
170 library SafeMath {
171   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172     if (a == 0) {
173       return 0;
174     }
175     uint256 c = a * b;
176     assert(c / a == b);
177     return c;
178   }
179 
180   function div(uint256 a, uint256 b) internal pure returns (uint256) {
181     // assert(b > 0); // Solidity automatically throws when dividing by 0
182     uint256 c = a / b;
183     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184     return c;
185   }
186 
187   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188     assert(b <= a);
189     return a - b;
190   }
191 
192   function add(uint256 a, uint256 b) internal pure returns (uint256) {
193     uint256 c = a + b;
194     assert(c >= a);
195     return c;
196   }
197 }