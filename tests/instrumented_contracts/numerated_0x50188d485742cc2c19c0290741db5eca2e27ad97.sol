1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 contract Claimable is Ownable {
46   address public pendingOwner;
47 
48   /**
49    * @dev Modifier throws if called by any account other than the pendingOwner.
50    */
51   modifier onlyPendingOwner() {
52     require(msg.sender == pendingOwner);
53     _;
54   }
55 
56   /**
57    * @dev Allows the current owner to set the pendingOwner address.
58    * @param newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address newOwner) onlyOwner public {
61     pendingOwner = newOwner;
62   }
63 
64   /**
65    * @dev Allows the pendingOwner address to finalize the transfer.
66    */
67   function claimOwnership() onlyPendingOwner public {
68     emit OwnershipTransferred(owner, pendingOwner);
69     owner = pendingOwner;
70     pendingOwner = address(0);
71   }
72 }
73 
74 contract TokenVestingFactory is Claimable {
75 
76     event Created(VariableRateTokenVesting vesting);
77 
78     function create(
79         address _beneficiary,
80         uint256 _start,
81         uint256[] _cumulativeRates,
82         uint256 _interval
83     ) onlyOwner public returns (VariableRateTokenVesting)
84     {
85         VariableRateTokenVesting vesting = new VariableRateTokenVesting(
86             _beneficiary, _start, _cumulativeRates, _interval);
87         emit Created(vesting);
88         return vesting;
89     }
90 }
91 
92 contract TokenVesting is Ownable {
93   using SafeMath for uint256;
94   using SafeERC20 for ERC20Basic;
95 
96   event Released(uint256 amount);
97   event Revoked();
98 
99   // beneficiary of tokens after they are released
100   address public beneficiary;
101 
102   uint256 public cliff;
103   uint256 public start;
104   uint256 public duration;
105 
106   bool public revocable;
107 
108   mapping (address => uint256) public released;
109   mapping (address => bool) public revoked;
110 
111   /**
112    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
113    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
114    * of the balance will have vested.
115    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
116    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
117    * @param _duration duration in seconds of the period in which the tokens will vest
118    * @param _revocable whether the vesting is revocable or not
119    */
120   function TokenVesting(
121     address _beneficiary,
122     uint256 _start,
123     uint256 _cliff,
124     uint256 _duration,
125     bool _revocable
126   )
127     public
128   {
129     require(_beneficiary != address(0));
130     require(_cliff <= _duration);
131 
132     beneficiary = _beneficiary;
133     revocable = _revocable;
134     duration = _duration;
135     cliff = _start.add(_cliff);
136     start = _start;
137   }
138 
139   /**
140    * @notice Transfers vested tokens to beneficiary.
141    * @param token ERC20 token which is being vested
142    */
143   function release(ERC20Basic token) public {
144     uint256 unreleased = releasableAmount(token);
145 
146     require(unreleased > 0);
147 
148     released[token] = released[token].add(unreleased);
149 
150     token.safeTransfer(beneficiary, unreleased);
151 
152     emit Released(unreleased);
153   }
154 
155   /**
156    * @notice Allows the owner to revoke the vesting. Tokens already vested
157    * remain in the contract, the rest are returned to the owner.
158    * @param token ERC20 token which is being vested
159    */
160   function revoke(ERC20Basic token) public onlyOwner {
161     require(revocable);
162     require(!revoked[token]);
163 
164     uint256 balance = token.balanceOf(this);
165 
166     uint256 unreleased = releasableAmount(token);
167     uint256 refund = balance.sub(unreleased);
168 
169     revoked[token] = true;
170 
171     token.safeTransfer(owner, refund);
172 
173     emit Revoked();
174   }
175 
176   /**
177    * @dev Calculates the amount that has already vested but hasn't been released yet.
178    * @param token ERC20 token which is being vested
179    */
180   function releasableAmount(ERC20Basic token) public view returns (uint256) {
181     return vestedAmount(token).sub(released[token]);
182   }
183 
184   /**
185    * @dev Calculates the amount that has already vested.
186    * @param token ERC20 token which is being vested
187    */
188   function vestedAmount(ERC20Basic token) public view returns (uint256) {
189     uint256 currentBalance = token.balanceOf(this);
190     uint256 totalBalance = currentBalance.add(released[token]);
191 
192     if (block.timestamp < cliff) {
193       return 0;
194     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
195       return totalBalance;
196     } else {
197       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
198     }
199   }
200 }
201 
202 library SafeERC20 {
203   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
204     assert(token.transfer(to, value));
205   }
206 
207   function safeTransferFrom(
208     ERC20 token,
209     address from,
210     address to,
211     uint256 value
212   )
213     internal
214   {
215     assert(token.transferFrom(from, to, value));
216   }
217 
218   function safeApprove(ERC20 token, address spender, uint256 value) internal {
219     assert(token.approve(spender, value));
220   }
221 }
222 
223 library SafeMath {
224 
225   /**
226   * @dev Multiplies two numbers, throws on overflow.
227   */
228   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
229     if (a == 0) {
230       return 0;
231     }
232     c = a * b;
233     assert(c / a == b);
234     return c;
235   }
236 
237   /**
238   * @dev Integer division of two numbers, truncating the quotient.
239   */
240   function div(uint256 a, uint256 b) internal pure returns (uint256) {
241     // assert(b > 0); // Solidity automatically throws when dividing by 0
242     // uint256 c = a / b;
243     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244     return a / b;
245   }
246 
247   /**
248   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
249   */
250   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
251     assert(b <= a);
252     return a - b;
253   }
254 
255   /**
256   * @dev Adds two numbers, throws on overflow.
257   */
258   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
259     c = a + b;
260     assert(c >= a);
261     return c;
262   }
263 }
264 
265 contract VariableRateTokenVesting is TokenVesting {
266 
267     using SafeMath for uint256;
268     using SafeERC20 for ERC20Basic;
269 
270     // Every element between 0 and 100, and should increase monotonically.
271     // [10, 20, 30, ..., 100] means releasing 10% for each period.
272     uint256[] public cumulativeRates;
273 
274     // Seconds between each period.
275     uint256 public interval;
276 
277     constructor(
278         address _beneficiary,
279         uint256 _start,
280         uint256[] _cumulativeRates,
281         uint256 _interval
282     ) public
283         // We don't need `duration`, also always allow revoking.
284         TokenVesting(_beneficiary, _start, /*cliff*/0, /*duration: uint max*/~uint256(0), true)
285     {
286         // Validate rates.
287         for (uint256 i = 0; i < _cumulativeRates.length; ++i) {
288             require(_cumulativeRates[i] <= 100);
289             if (i > 0) {
290                 require(_cumulativeRates[i] >= _cumulativeRates[i - 1]);
291             }
292         }
293 
294         cumulativeRates = _cumulativeRates;
295         interval = _interval;
296         // Hardcode owner.
297         owner = 0x0298CF0d5B60a0aD885518adCB4c3fc49b36D347;
298     }
299 
300     /// @dev Override to use cumulative rates to calculated amount for vesting.
301     function vestedAmount(ERC20Basic token) public view returns (uint256) {
302         if (now < start) {
303             return 0;
304         }
305 
306         uint256 currentBalance = token.balanceOf(this);
307         uint256 totalBalance = currentBalance.add(released[token]);
308 
309         uint256 timeSinceStart = now.sub(start);
310         uint256 currentPeriod = timeSinceStart.div(interval);
311         if (currentPeriod >= cumulativeRates.length) {
312             return totalBalance;
313         }
314         return totalBalance.mul(cumulativeRates[currentPeriod]).div(100);
315     }
316 }
317 
318 contract ERC20 is ERC20Basic {
319   function allowance(address owner, address spender) public view returns (uint256);
320   function transferFrom(address from, address to, uint256 value) public returns (bool);
321   function approve(address spender, uint256 value) public returns (bool);
322   event Approval(address indexed owner, address indexed spender, uint256 value);
323 }