1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 
61 
62 
63 
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender)
71     public view returns (uint256);
72 
73   function transferFrom(address from, address to, uint256 value)
74     public returns (bool);
75 
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 
85 
86 /**
87  * @title SafeERC20
88  * @dev Wrappers around ERC20 operations that throw on failure.
89  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
90  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
91  */
92 library SafeERC20 {
93   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
94     require(token.transfer(to, value));
95   }
96 
97   function safeTransferFrom(
98     ERC20 token,
99     address from,
100     address to,
101     uint256 value
102   )
103     internal
104   {
105     require(token.transferFrom(from, to, value));
106   }
107 
108   function safeApprove(ERC20 token, address spender, uint256 value) internal {
109     require(token.approve(spender, value));
110   }
111 }
112 /* solium-disable security/no-block-members */
113 
114 
115 
116 
117 
118 
119 
120 
121 
122 /**
123  * @title SafeMath
124  * @dev Math operations with safety checks that throw on error
125  */
126 library SafeMath {
127 
128   /**
129   * @dev Multiplies two numbers, throws on overflow.
130   */
131   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132     if (a == 0) {
133       return 0;
134     }
135     uint256 c = a * b;
136     assert(c / a == b);
137     return c;
138   }
139 
140   /**
141   * @dev Integer division of two numbers, truncating the quotient.
142   */
143   function div(uint256 a, uint256 b) internal pure returns (uint256) {
144     // assert(b > 0); // Solidity automatically throws when dividing by 0
145     uint256 c = a / b;
146     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147     return c;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     assert(b <= a);
155     return a - b;
156   }
157 
158   /**
159   * @dev Adds two numbers, throws on overflow.
160   */
161   function add(uint256 a, uint256 b) internal pure returns (uint256) {
162     uint256 c = a + b;
163     assert(c >= a);
164     return c;
165   }
166 }
167 
168 
169 
170 /**
171  * @title TokenVesting
172  * @dev A token holder contract that can release its token balance gradually like a
173  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
174  * owner.
175  */
176 contract TokenVesting is Ownable {
177   using SafeMath for uint256;
178   using SafeERC20 for ERC20Basic;
179 
180   event Released(uint256 amount);
181   event Revoked();
182 
183   // beneficiary of tokens after they are released
184   address public beneficiary;
185 
186   uint256 public cliff;
187   uint256 public start;
188   uint256 public duration;
189 
190   bool public revocable;
191 
192   mapping (address => uint256) public released;
193   mapping (address => bool) public revoked;
194 
195   /**
196    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
197    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
198    * of the balance will have vested.
199    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
200    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
201    * @param _start the time (as Unix time) at which point vesting starts 
202    * @param _duration duration in seconds of the period in which the tokens will vest
203    * @param _revocable whether the vesting is revocable or not
204    */
205   constructor(
206     address _beneficiary,
207     uint256 _start,
208     uint256 _cliff,
209     uint256 _duration,
210     bool _revocable
211   )
212     public
213   {
214     require(_beneficiary != address(0));
215     require(_cliff <= _duration);
216 
217     beneficiary = _beneficiary;
218     revocable = _revocable;
219     duration = _duration;
220     cliff = _start.add(_cliff);
221     start = _start;
222   }
223 
224   /**
225    * @notice Transfers vested tokens to beneficiary.
226    * @param token ERC20 token which is being vested
227    */
228   function release(ERC20Basic token) public {
229     uint256 unreleased = releasableAmount(token);
230 
231     require(unreleased > 0);
232 
233     released[token] = released[token].add(unreleased);
234 
235     token.safeTransfer(beneficiary, unreleased);
236 
237     emit Released(unreleased);
238   }
239 
240   /**
241    * @notice Allows the owner to revoke the vesting. Tokens already vested
242    * remain in the contract, the rest are returned to the owner.
243    * @param token ERC20 token which is being vested
244    */
245   function revoke(ERC20Basic token) public onlyOwner {
246     require(revocable);
247     require(!revoked[token]);
248 
249     uint256 balance = token.balanceOf(this);
250 
251     uint256 unreleased = releasableAmount(token);
252     uint256 refund = balance.sub(unreleased);
253 
254     revoked[token] = true;
255 
256     token.safeTransfer(owner, refund);
257 
258     emit Revoked();
259   }
260 
261   /**
262    * @dev Calculates the amount that has already vested but hasn't been released yet.
263    * @param token ERC20 token which is being vested
264    */
265   function releasableAmount(ERC20Basic token) public view returns (uint256) {
266     return vestedAmount(token).sub(released[token]);
267   }
268 
269   /**
270    * @dev Calculates the amount that has already vested.
271    * @param token ERC20 token which is being vested
272    */
273   function vestedAmount(ERC20Basic token) public view returns (uint256) {
274     uint256 currentBalance = token.balanceOf(this);
275     uint256 totalBalance = currentBalance.add(released[token]);
276 
277     if (block.timestamp < cliff) {
278       return 0;
279     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
280       return totalBalance;
281     } else {
282       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
283     }
284   }
285 }