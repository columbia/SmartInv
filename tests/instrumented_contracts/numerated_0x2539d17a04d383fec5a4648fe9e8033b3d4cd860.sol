1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender)
12     public view returns (uint256);
13 
14   function transferFrom(address from, address to, uint256 value)
15     public returns (bool);
16 
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 
25 contract Ownable {
26   address public owner;
27 
28 
29   event OwnershipRenounced(address indexed previousOwner);
30   event OwnershipTransferred(
31     address indexed previousOwner,
32     address indexed newOwner
33   );
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   constructor() public {
41     owner = msg.sender;
42   }
43 
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   /**
53    * @dev Allows the current owner to relinquish control of the contract.
54    * @notice Renouncing to ownership will leave the contract without an owner.
55    * It will not be possible to call the functions with the `onlyOwner`
56    * modifier anymore.
57    */
58   function renounceOwnership() public onlyOwner {
59     emit OwnershipRenounced(owner);
60     owner = address(0);
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param _newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address _newOwner) public onlyOwner {
68     _transferOwnership(_newOwner);
69   }
70 
71   /**
72    * @dev Transfers control of the contract to a newOwner.
73    * @param _newOwner The address to transfer ownership to.
74    */
75   function _transferOwnership(address _newOwner) internal {
76     require(_newOwner != address(0));
77     emit OwnershipTransferred(owner, _newOwner);
78     owner = _newOwner;
79   }
80 }
81 
82 library SafeERC20 {
83   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
84     require(token.transfer(to, value));
85   }
86 
87   function safeTransferFrom(
88     ERC20 token,
89     address from,
90     address to,
91     uint256 value
92   )
93     internal
94   {
95     require(token.transferFrom(from, to, value));
96   }
97 
98   function safeApprove(ERC20 token, address spender, uint256 value) internal {
99     require(token.approve(spender, value));
100   }
101 }
102 
103 library SafeMath {
104 
105   /**
106   * @dev Multiplies two numbers, throws on overflow.
107   */
108   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
109     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
110     // benefit is lost if 'b' is also tested.
111     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
112     if (a == 0) {
113       return 0;
114     }
115 
116     c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     // uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return a / b;
129   }
130 
131   /**
132   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
143     c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
148 
149 contract TokenVesting is Ownable {
150   using SafeMath for uint256;
151   using SafeERC20 for ERC20Basic;
152 
153   event Released(uint256 amount);
154   event Revoked();
155 
156   // beneficiary of tokens after they are released
157   address public beneficiary;
158 
159   uint256 public cliff;
160   uint256 public start;
161   uint256 public duration;
162 
163   bool public revocable;
164 
165   mapping (address => uint256) public released;
166   mapping (address => bool) public revoked;
167 
168   /**
169    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
170    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
171    * of the balance will have vested.
172    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
173    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
174    * @param _start the time (as Unix time) at which point vesting starts 
175    * @param _duration duration in seconds of the period in which the tokens will vest
176    * @param _revocable whether the vesting is revocable or not
177    */
178   constructor(
179     address _beneficiary,
180     uint256 _start,
181     uint256 _cliff,
182     uint256 _duration,
183     bool _revocable
184   )
185     public
186   {
187     require(_beneficiary != address(0));
188     require(_cliff <= _duration);
189 
190     beneficiary = _beneficiary;
191     revocable = _revocable;
192     duration = _duration;
193     cliff = _start.add(_cliff);
194     start = _start;
195   }
196 
197   /**
198    * @notice Transfers vested tokens to beneficiary.
199    * @param token ERC20 token which is being vested
200    */
201   function release(ERC20Basic token) public {
202     uint256 unreleased = releasableAmount(token);
203 
204     require(unreleased > 0);
205 
206     released[token] = released[token].add(unreleased);
207 
208     token.safeTransfer(beneficiary, unreleased);
209 
210     emit Released(unreleased);
211   }
212 
213   /**
214    * @notice Allows the owner to revoke the vesting. Tokens already vested
215    * remain in the contract, the rest are returned to the owner.
216    * @param token ERC20 token which is being vested
217    */
218   function revoke(ERC20Basic token) public onlyOwner {
219     require(revocable);
220     require(!revoked[token]);
221 
222     uint256 balance = token.balanceOf(this);
223 
224     uint256 unreleased = releasableAmount(token);
225     uint256 refund = balance.sub(unreleased);
226 
227     revoked[token] = true;
228 
229     token.safeTransfer(owner, refund);
230 
231     emit Revoked();
232   }
233 
234   /**
235    * @dev Calculates the amount that has already vested but hasn't been released yet.
236    * @param token ERC20 token which is being vested
237    */
238   function releasableAmount(ERC20Basic token) public view returns (uint256) {
239     return vestedAmount(token).sub(released[token]);
240   }
241 
242   /**
243    * @dev Calculates the amount that has already vested.
244    * @param token ERC20 token which is being vested
245    */
246   function vestedAmount(ERC20Basic token) public view returns (uint256) {
247     uint256 currentBalance = token.balanceOf(this);
248     uint256 totalBalance = currentBalance.add(released[token]);
249 
250     if (block.timestamp < cliff) {
251       return 0;
252     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
253       return totalBalance;
254     } else {
255       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
256     }
257   }
258 }