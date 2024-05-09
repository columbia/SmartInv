1 pragma solidity 0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 /**
102  * @title SafeERC20
103  * @dev Wrappers around ERC20 operations that throw on failure.
104  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
105  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
106  */
107 library SafeERC20 {
108   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
109     assert(token.transfer(to, value));
110   }
111 
112   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
113     assert(token.transferFrom(from, to, value));
114   }
115 
116   function safeApprove(ERC20 token, address spender, uint256 value) internal {
117     assert(token.approve(spender, value));
118   }
119 }
120 
121 /**
122  * @title TokenVesting
123  * @dev A token holder contract that can release its token balance gradually like a
124  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
125  * owner.
126  */
127 contract TokenVesting is Ownable {
128   using SafeMath for uint256;
129   using SafeERC20 for ERC20Basic;
130 
131   event Released(uint256 amount);
132   event Revoked();
133 
134   // beneficiary of tokens after they are released
135   address public beneficiary;
136 
137   uint256 public cliff;
138   uint256 public start;
139   uint256 public duration;
140 
141   bool public revocable;
142 
143   mapping (address => uint256) public released;
144   mapping (address => bool) public revoked;
145 
146   /**
147    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
148    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
149    * of the balance will have vested.
150    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
151    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
152    * @param _duration duration in seconds of the period in which the tokens will vest
153    * @param _revocable whether the vesting is revocable or not
154    */
155   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
156     require(_beneficiary != address(0));
157     require(_cliff <= _duration);
158 
159     beneficiary = _beneficiary;
160     revocable = _revocable;
161     duration = _duration;
162     cliff = _start.add(_cliff);
163     start = _start;
164   }
165 
166   /**
167    * @notice Transfers vested tokens to beneficiary.
168    * @param token ERC20 token which is being vested
169    */
170   function release(ERC20Basic token) public {
171     uint256 unreleased = releasableAmount(token);
172 
173     require(unreleased > 0);
174 
175     released[token] = released[token].add(unreleased);
176 
177     token.safeTransfer(beneficiary, unreleased);
178 
179     Released(unreleased);
180   }
181 
182   /**
183    * @notice Allows the owner to revoke the vesting. Tokens already vested
184    * remain in the contract, the rest are returned to the owner.
185    * @param token ERC20 token which is being vested
186    */
187   function revoke(ERC20Basic token) public onlyOwner {
188     require(revocable);
189     require(!revoked[token]);
190 
191     uint256 balance = token.balanceOf(this);
192 
193     uint256 unreleased = releasableAmount(token);
194     uint256 refund = balance.sub(unreleased);
195 
196     revoked[token] = true;
197 
198     token.safeTransfer(owner, refund);
199 
200     Revoked();
201   }
202 
203   /**
204    * @dev Calculates the amount that has already vested but hasn't been released yet.
205    * @param token ERC20 token which is being vested
206    */
207   function releasableAmount(ERC20Basic token) public view returns (uint256) {
208     return vestedAmount(token).sub(released[token]);
209   }
210 
211   /**
212    * @dev Calculates the amount that has already vested.
213    * @param token ERC20 token which is being vested
214    */
215   function vestedAmount(ERC20Basic token) public view returns (uint256) {
216     uint256 currentBalance = token.balanceOf(this);
217     uint256 totalBalance = currentBalance.add(released[token]);
218 
219     if (now < cliff) {
220       return 0;
221     } else if (now >= start.add(duration) || revoked[token]) {
222       return totalBalance;
223     } else {
224       return totalBalance.mul(now.sub(start)).div(duration);
225     }
226   }
227 }