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
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 /**
114  * @title SafeERC20
115  * @dev Wrappers around ERC20 operations that throw on failure.
116  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
117  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
118  */
119 library SafeERC20 {
120   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
121     assert(token.transfer(to, value));
122   }
123 
124   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
125     assert(token.transferFrom(from, to, value));
126   }
127 
128   function safeApprove(ERC20 token, address spender, uint256 value) internal {
129     assert(token.approve(spender, value));
130   }
131 }
132 
133 /**
134  * @title TokenVesting
135  * @dev A token holder contract that can release its token balance gradually like a
136  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
137  * owner.
138  */
139 contract TokenVesting is Ownable {
140   using SafeMath for uint256;
141   using SafeERC20 for ERC20Basic;
142 
143   event Released(uint256 amount);
144   event Revoked();
145 
146   // beneficiary of tokens after they are released
147   address public beneficiary;
148 
149   uint256 public cliff;
150   uint256 public start;
151   uint256 public duration;
152 
153   bool public revocable;
154 
155   mapping (address => uint256) public released;
156   mapping (address => bool) public revoked;
157 
158   /**
159    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
160    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
161    * of the balance will have vested.
162    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
163    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
164    * @param _duration duration in seconds of the period in which the tokens will vest
165    * @param _revocable whether the vesting is revocable or not
166    */
167   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
168     require(_beneficiary != address(0));
169     require(_cliff <= _duration);
170 
171     beneficiary = _beneficiary;
172     revocable = _revocable;
173     duration = _duration;
174     cliff = _start.add(_cliff);
175     start = _start;
176   }
177 
178   /**
179    * @notice Transfers vested tokens to beneficiary.
180    * @param token ERC20 token which is being vested
181    */
182   function release(ERC20Basic token) public {
183     uint256 unreleased = releasableAmount(token);
184 
185     require(unreleased > 0);
186 
187     released[token] = released[token].add(unreleased);
188 
189     token.safeTransfer(beneficiary, unreleased);
190 
191     Released(unreleased);
192   }
193 
194   /**
195    * @notice Allows the owner to revoke the vesting. Tokens already vested
196    * remain in the contract, the rest are returned to the owner.
197    * @param token ERC20 token which is being vested
198    */
199   function revoke(ERC20Basic token) public onlyOwner {
200     require(revocable);
201     require(!revoked[token]);
202 
203     uint256 balance = token.balanceOf(this);
204 
205     uint256 unreleased = releasableAmount(token);
206     uint256 refund = balance.sub(unreleased);
207 
208     revoked[token] = true;
209 
210     token.safeTransfer(owner, refund);
211 
212     Revoked();
213   }
214 
215   /**
216    * @dev Calculates the amount that has already vested but hasn't been released yet.
217    * @param token ERC20 token which is being vested
218    */
219   function releasableAmount(ERC20Basic token) public view returns (uint256) {
220     return vestedAmount(token).sub(released[token]);
221   }
222 
223   /**
224    * @dev Calculates the amount that has already vested.
225    * @param token ERC20 token which is being vested
226    */
227   function vestedAmount(ERC20Basic token) public view returns (uint256) {
228     uint256 currentBalance = token.balanceOf(this);
229     uint256 totalBalance = currentBalance.add(released[token]);
230 
231     if (now < cliff) {
232       return 0;
233     } else if (now >= start.add(duration) || revoked[token]) {
234       return totalBalance;
235     } else {
236       return totalBalance.mul(now.sub(start)).div(duration);
237     }
238   }
239 }
240 
241 /**
242  * @title MetadiumVesting
243  * @dev A token holder contract that can release its token balance gradually like a
244  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
245  * owner.
246  */
247 contract MetadiumVesting is TokenVesting {
248     function MetadiumVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public 
249     TokenVesting(_beneficiary, _start, _cliff, _duration, _revocable)
250     {
251         
252     }
253 }