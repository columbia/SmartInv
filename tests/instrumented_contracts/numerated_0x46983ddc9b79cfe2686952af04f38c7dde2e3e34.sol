1 pragma solidity 0.4.18;
2 
3 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
31 
32 /**
33  * @title SafeERC20
34  * @dev Wrappers around ERC20 operations that throw on failure.
35  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
36  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
37  */
38 library SafeERC20 {
39   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
40     assert(token.transfer(to, value));
41   }
42 
43   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
44     assert(token.transferFrom(from, to, value));
45   }
46 
47   function safeApprove(ERC20 token, address spender, uint256 value) internal {
48     assert(token.approve(spender, value));
49   }
50 }
51 
52 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
95 
96 /**
97  * @title SafeMath
98  * @dev Math operations with safety checks that throw on error
99  */
100 library SafeMath {
101 
102   /**
103   * @dev Multiplies two numbers, throws on overflow.
104   */
105   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106     if (a == 0) {
107       return 0;
108     }
109     uint256 c = a * b;
110     assert(c / a == b);
111     return c;
112   }
113 
114   /**
115   * @dev Integer division of two numbers, truncating the quotient.
116   */
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return c;
122   }
123 
124   /**
125   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126   */
127   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128     assert(b <= a);
129     return a - b;
130   }
131 
132   /**
133   * @dev Adds two numbers, throws on overflow.
134   */
135   function add(uint256 a, uint256 b) internal pure returns (uint256) {
136     uint256 c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }
141 
142 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
143 
144 /**
145  * @title TokenVesting
146  * @dev A token holder contract that can release its token balance gradually like a
147  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
148  * owner.
149  */
150 contract TokenVesting is Ownable {
151   using SafeMath for uint256;
152   using SafeERC20 for ERC20Basic;
153 
154   event Released(uint256 amount);
155   event Revoked();
156 
157   // beneficiary of tokens after they are released
158   address public beneficiary;
159 
160   uint256 public cliff;
161   uint256 public start;
162   uint256 public duration;
163 
164   bool public revocable;
165 
166   mapping (address => uint256) public released;
167   mapping (address => bool) public revoked;
168 
169   /**
170    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
171    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
172    * of the balance will have vested.
173    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
174    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
175    * @param _duration duration in seconds of the period in which the tokens will vest
176    * @param _revocable whether the vesting is revocable or not
177    */
178   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
179     require(_beneficiary != address(0));
180     require(_cliff <= _duration);
181 
182     beneficiary = _beneficiary;
183     revocable = _revocable;
184     duration = _duration;
185     cliff = _start.add(_cliff);
186     start = _start;
187   }
188 
189   /**
190    * @notice Transfers vested tokens to beneficiary.
191    * @param token ERC20 token which is being vested
192    */
193   function release(ERC20Basic token) public {
194     uint256 unreleased = releasableAmount(token);
195 
196     require(unreleased > 0);
197 
198     released[token] = released[token].add(unreleased);
199 
200     token.safeTransfer(beneficiary, unreleased);
201 
202     Released(unreleased);
203   }
204 
205   /**
206    * @notice Allows the owner to revoke the vesting. Tokens already vested
207    * remain in the contract, the rest are returned to the owner.
208    * @param token ERC20 token which is being vested
209    */
210   function revoke(ERC20Basic token) public onlyOwner {
211     require(revocable);
212     require(!revoked[token]);
213 
214     uint256 balance = token.balanceOf(this);
215 
216     uint256 unreleased = releasableAmount(token);
217     uint256 refund = balance.sub(unreleased);
218 
219     revoked[token] = true;
220 
221     token.safeTransfer(owner, refund);
222 
223     Revoked();
224   }
225 
226   /**
227    * @dev Calculates the amount that has already vested but hasn't been released yet.
228    * @param token ERC20 token which is being vested
229    */
230   function releasableAmount(ERC20Basic token) public view returns (uint256) {
231     return vestedAmount(token).sub(released[token]);
232   }
233 
234   /**
235    * @dev Calculates the amount that has already vested.
236    * @param token ERC20 token which is being vested
237    */
238   function vestedAmount(ERC20Basic token) public view returns (uint256) {
239     uint256 currentBalance = token.balanceOf(this);
240     uint256 totalBalance = currentBalance.add(released[token]);
241 
242     if (now < cliff) {
243       return 0;
244     } else if (now >= start.add(duration) || revoked[token]) {
245       return totalBalance;
246     } else {
247       return totalBalance.mul(now.sub(start)).div(duration);
248     }
249   }
250 }
251 
252 // File: contracts/YUPVesting.sol
253 
254 contract YUPVesting is TokenVesting {
255 
256     /** State variables **/
257     bool revocable = false;
258 
259     /** Constructor **/
260     function YUPVesting(
261         address _beneficiary,
262         uint256 _start,
263         uint256 _cliff,
264         uint256 _duration
265     ) public TokenVesting(_beneficiary, _start, _cliff, _duration, revocable) {}
266 }