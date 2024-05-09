1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Ownable {
11 
12     address public owner;
13 
14     modifier onlyOwner {
15         require(isOwner(msg.sender));
16         _;
17     }
18 
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23     function transferOwnership(address _newOwner) public onlyOwner {
24         owner = _newOwner;
25     }
26 
27     function isOwner(address _address) public constant returns (bool) {
28         return owner == _address;
29     }
30 }
31 
32 contract ERC20 is ERC20Basic {
33     function allowance(address owner, address spender) public view returns (uint256);
34     function transferFrom(address from, address to, uint256 value) public returns (bool);
35     function approve(address spender, uint256 value) public returns (bool);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 /**
40  * @title SafeERC20
41  * @dev Wrappers around ERC20 operations that throw on failure.
42  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
43  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
44  */
45 library SafeERC20 {
46   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
47     assert(token.transfer(to, value));
48   }
49 
50   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
51     assert(token.transferFrom(from, to, value));
52   }
53 
54   function safeApprove(ERC20 token, address spender, uint256 value) internal {
55     assert(token.approve(spender, value));
56   }
57 }
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64 
65   /**
66   * @dev Multiplies two numbers, throws on overflow.
67   */
68   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69     if (a == 0) {
70       return 0;
71     }
72     uint256 c = a * b;
73     assert(c / a == b);
74     return c;
75   }
76 
77   /**
78   * @dev Integer division of two numbers, truncating the quotient.
79   */
80   function div(uint256 a, uint256 b) internal pure returns (uint256) {
81     // assert(b > 0); // Solidity automatically throws when dividing by 0
82     uint256 c = a / b;
83     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84     return c;
85   }
86 
87   /**
88   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
89   */
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   /**
96   * @dev Adds two numbers, throws on overflow.
97   */
98   function add(uint256 a, uint256 b) internal pure returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 /**
106  * @title TokenVesting
107  * @dev A token holder contract that can release its token balance gradually like a
108  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
109  * owner.
110  */
111 contract TokenVesting is Ownable {
112   using SafeMath for uint256;
113   using SafeERC20 for ERC20Basic;
114 
115   event Released(uint256 amount);
116   event Revoked();
117 
118   // beneficiary of tokens after they are released
119   address public beneficiary;
120 
121   uint256 public cliff;
122   uint256 public start;
123   uint256 public duration;
124 
125   bool public revocable;
126 
127   mapping (address => uint256) public released;
128   mapping (address => bool) public revoked;
129 
130   /**
131    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
132    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
133    * of the balance will have vested.
134    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
135    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
136    * @param _duration duration in seconds of the period in which the tokens will vest
137    * @param _revocable whether the vesting is revocable or not
138    */
139   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
140     require(_beneficiary != address(0));
141     require(_cliff <= _duration);
142 
143     beneficiary = _beneficiary;
144     revocable = _revocable;
145     duration = _duration;
146     cliff = _start.add(_cliff);
147     start = _start;
148   }
149 
150   /**
151    * @notice Transfers vested tokens to beneficiary.
152    * @param token ERC20 token which is being vested
153    */
154   function release(ERC20Basic token) public {
155     uint256 unreleased = releasableAmount(token);
156 
157     require(unreleased > 0);
158 
159     released[token] = released[token].add(unreleased);
160 
161     token.safeTransfer(beneficiary, unreleased);
162 
163     Released(unreleased);
164   }
165 
166   /**
167    * @notice Allows the owner to revoke the vesting. Tokens already vested
168    * remain in the contract, the rest are returned to the owner.
169    * @param token ERC20 token which is being vested
170    */
171   function revoke(ERC20Basic token) public onlyOwner {
172     require(revocable);
173     require(!revoked[token]);
174 
175     uint256 balance = token.balanceOf(this);
176 
177     uint256 unreleased = releasableAmount(token);
178     uint256 refund = balance.sub(unreleased);
179 
180     revoked[token] = true;
181 
182     token.safeTransfer(owner, refund);
183 
184     Revoked();
185   }
186 
187   /**
188    * @dev Calculates the amount that has already vested but hasn't been released yet.
189    * @param token ERC20 token which is being vested
190    */
191   function releasableAmount(ERC20Basic token) public view returns (uint256) {
192     return vestedAmount(token).sub(released[token]);
193   }
194 
195   /**
196    * @dev Calculates the amount that has already vested.
197    * @param token ERC20 token which is being vested
198    */
199   function vestedAmount(ERC20Basic token) public view returns (uint256) {
200     uint256 currentBalance = token.balanceOf(this);
201     uint256 totalBalance = currentBalance.add(released[token]);
202 
203     if (now < cliff) {
204       return 0;
205     } else if (now >= start.add(duration) || revoked[token]) {
206       return totalBalance;
207     } else {
208       return totalBalance.mul(now.sub(start)).div(duration);
209     }
210   }
211 }