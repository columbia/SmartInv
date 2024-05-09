1 /* solium-disable security/no-block-members */
2 
3 pragma solidity ^0.4.23;
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
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender)
19     public view returns (uint256);
20 
21   function transferFrom(address from, address to, uint256 value)
22     public returns (bool);
23 
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 /**
33  * @title SafeERC20
34  * @dev Wrappers around ERC20 operations that throw on failure.
35  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
36  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
37  */
38 library SafeERC20 {
39   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
40     require(token.transfer(to, value));
41   }
42 
43   function safeTransferFrom(
44     ERC20 token,
45     address from,
46     address to,
47     uint256 value
48   )
49     internal
50   {
51     require(token.transferFrom(from, to, value));
52   }
53 
54   function safeApprove(ERC20 token, address spender, uint256 value) internal {
55     require(token.approve(spender, value));
56   }
57 }
58 
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66   address public owner;
67 
68 
69   event OwnershipRenounced(address indexed previousOwner);
70   event OwnershipTransferred(
71     address indexed previousOwner,
72     address indexed newOwner
73   );
74 
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   constructor() public {
81     owner = msg.sender;
82   }
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address newOwner) public onlyOwner {
97     require(newOwner != address(0));
98     emit OwnershipTransferred(owner, newOwner);
99     owner = newOwner;
100   }
101 
102   /**
103    * @dev Allows the current owner to relinquish control of the contract.
104    */
105   function renounceOwnership() public onlyOwner {
106     emit OwnershipRenounced(owner);
107     owner = address(0);
108   }
109 }
110 
111 /**
112  * @title SafeMath
113  * @dev Math operations with safety checks that throw on error
114  */
115 library SafeMath {
116 
117   /**
118   * @dev Multiplies two numbers, throws on overflow.
119   */
120   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
121     if (a == 0) {
122       return 0;
123     }
124     c = a * b;
125     assert(c / a == b);
126     return c;
127   }
128 
129   /**
130   * @dev Integer division of two numbers, truncating the quotient.
131   */
132   function div(uint256 a, uint256 b) internal pure returns (uint256) {
133     // assert(b > 0); // Solidity automatically throws when dividing by 0
134     // uint256 c = a / b;
135     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136     return a / b;
137   }
138 
139   /**
140   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
141   */
142   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143     assert(b <= a);
144     return a - b;
145   }
146 
147   /**
148   * @dev Adds two numbers, throws on overflow.
149   */
150   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
151     c = a + b;
152     assert(c >= a);
153     return c;
154   }
155 }
156 
157 
158 /**
159  * @title TokenVesting
160  * @dev A token holder contract that can release its token balance gradually like a
161  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
162  * owner.
163  */
164 contract TokenVesting is Ownable {
165   using SafeMath for uint256;
166   using SafeERC20 for ERC20Basic;
167 
168   event Released(uint256 amount);
169   event Revoked();
170 
171   // beneficiary of tokens after they are released
172   address public beneficiary;
173 
174   uint256 public cliff;
175   uint256 public start;
176   uint256 public duration;
177 
178   bool public revocable;
179 
180   mapping (address => uint256) public released;
181   mapping (address => bool) public revoked;
182 
183   /**
184    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
185    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
186    * of the balance will have vested.
187    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
188    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
189    * @param _duration duration in seconds of the period in which the tokens will vest
190    * @param _revocable whether the vesting is revocable or not
191    */
192   constructor(
193     address _beneficiary,
194     uint256 _start,
195     uint256 _cliff,
196     uint256 _duration,
197     bool _revocable
198   )
199     public
200   {
201     require(_beneficiary != address(0));
202     require(_cliff <= _duration);
203 
204     beneficiary = _beneficiary;
205     revocable = _revocable;
206     duration = _duration;
207     cliff = _start.add(_cliff);
208     start = _start;
209   }
210 
211   /**
212    * @notice Transfers vested tokens to beneficiary.
213    * @param token ERC20 token which is being vested
214    */
215   function release(ERC20Basic token) public {
216     uint256 unreleased = releasableAmount(token);
217 
218     require(unreleased > 0);
219 
220     released[token] = released[token].add(unreleased);
221 
222     token.safeTransfer(beneficiary, unreleased);
223 
224     emit Released(unreleased);
225   }
226 
227   /**
228    * @notice Allows the owner to revoke the vesting. Tokens already vested
229    * remain in the contract, the rest are returned to the owner.
230    * @param token ERC20 token which is being vested
231    */
232   function revoke(ERC20Basic token) public onlyOwner {
233     require(revocable);
234     require(!revoked[token]);
235 
236     uint256 balance = token.balanceOf(this);
237 
238     uint256 unreleased = releasableAmount(token);
239     uint256 refund = balance.sub(unreleased);
240 
241     revoked[token] = true;
242 
243     token.safeTransfer(owner, refund);
244 
245     emit Revoked();
246   }
247 
248   /**
249    * @dev Calculates the amount that has already vested but hasn't been released yet.
250    * @param token ERC20 token which is being vested
251    */
252   function releasableAmount(ERC20Basic token) public view returns (uint256) {
253     return vestedAmount(token).sub(released[token]);
254   }
255 
256   /**
257    * @dev Calculates the amount that has already vested.
258    * @param token ERC20 token which is being vested
259    */
260   function vestedAmount(ERC20Basic token) public view returns (uint256) {
261     uint256 currentBalance = token.balanceOf(this);
262     uint256 totalBalance = currentBalance.add(released[token]);
263 
264     if (block.timestamp < cliff) {
265       return 0;
266     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
267       return totalBalance;
268     } else {
269       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
270     }
271   }
272 }