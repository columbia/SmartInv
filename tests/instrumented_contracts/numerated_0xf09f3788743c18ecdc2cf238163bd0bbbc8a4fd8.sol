1 pragma solidity ^0.4.13;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) onlyOwner public {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract ERC20Basic {
85   uint256 public totalSupply;
86   function balanceOf(address who) public constant returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public constant returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 library SafeERC20 {
99   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
100     assert(token.transfer(to, value));
101   }
102 
103   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
104     assert(token.transferFrom(from, to, value));
105   }
106 
107   function safeApprove(ERC20 token, address spender, uint256 value) internal {
108     assert(token.approve(spender, value));
109   }
110 }
111 
112 contract ReturnVestingRegistry is Ownable {
113 
114   mapping (address => address) public returnAddress;
115 
116   function record(address from, address to) onlyOwner public {
117     require(from != 0);
118 
119     returnAddress[from] = to;
120   }
121 }
122 
123 contract TerraformReserve is Ownable {
124 
125   /* Storing a balance for each user */
126   mapping (address => uint256) public lockedBalance;
127 
128   /* Store the total sum locked */
129   uint public totalLocked;
130 
131   /* Reference to the token */
132   ERC20 public manaToken;
133 
134   /* Contract that will assign the LAND and burn/return tokens */
135   address public landClaim;
136 
137   /* Prevent the token from accepting deposits */
138   bool public acceptingDeposits;
139 
140   event LockedBalance(address user, uint mana);
141   event LandClaimContractSet(address target);
142   event LandClaimExecuted(address user, uint value, bytes data);
143   event AcceptingDepositsChanged(bool _acceptingDeposits);
144 
145   function TerraformReserve(address _token) {
146     require(_token != 0);
147     manaToken = ERC20(_token);
148     acceptingDeposits = true;
149   }
150 
151   /**
152    * Lock MANA into the contract.
153    * This contract does not have another way to take the tokens out other than
154    * through the target contract.
155    */
156   function lockMana(address _from, uint256 mana) public {
157     require(acceptingDeposits);
158     require(mana >= 1000 * 1e18);
159     require(manaToken.transferFrom(_from, this, mana));
160 
161     lockedBalance[_from] += mana;
162     totalLocked += mana;
163     LockedBalance(_from, mana);
164   }
165 
166   /**
167    * Allows the owner of the contract to pause acceptingDeposits
168    */
169   function changeContractState(bool _acceptingDeposits) public onlyOwner {
170     acceptingDeposits = _acceptingDeposits;
171     AcceptingDepositsChanged(acceptingDeposits);
172   }
173 
174   /**
175    * Set the contract that can move the staked MANA.
176    * Calls the `approve` function of the ERC20 token with the total amount.
177    */
178   function setTargetContract(address target) public onlyOwner {
179     landClaim = target;
180     manaToken.approve(landClaim, totalLocked);
181     LandClaimContractSet(target);
182   }
183 
184   /**
185    * Prevent payments to the contract
186    */
187   function () public payable {
188     revert();
189   }
190 }
191 
192 contract TokenVesting is Ownable {
193   using SafeMath for uint256;
194   using SafeERC20 for ERC20;
195 
196   event Released(uint256 amount);
197   event Revoked();
198 
199   // beneficiary of tokens after they are released
200   address public beneficiary;
201 
202   uint256 public cliff;
203   uint256 public start;
204   uint256 public duration;
205 
206   bool public revocable;
207   bool public revoked;
208 
209   uint256 public released;
210 
211   ERC20 public token;
212 
213   /**
214    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
215    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
216    * of the balance will have vested.
217    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
218    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
219    * @param _duration duration in seconds of the period in which the tokens will vest
220    * @param _revocable whether the vesting is revocable or not
221    * @param _token address of the ERC20 token contract
222    */
223   function TokenVesting(
224     address _beneficiary,
225     uint256 _start,
226     uint256 _cliff,
227     uint256 _duration,
228     bool    _revocable,
229     address _token
230   ) {
231     require(_beneficiary != 0x0);
232     require(_cliff <= _duration);
233 
234     beneficiary = _beneficiary;
235     start       = _start;
236     cliff       = _start.add(_cliff);
237     duration    = _duration;
238     revocable   = _revocable;
239     token       = ERC20(_token);
240   }
241 
242   /**
243    * @notice Only allow calls from the beneficiary of the vesting contract
244    */
245   modifier onlyBeneficiary() {
246     require(msg.sender == beneficiary);
247     _;
248   }
249 
250   /**
251    * @notice Allow the beneficiary to change its address
252    * @param target the address to transfer the right to
253    */
254   function changeBeneficiary(address target) onlyBeneficiary public {
255     require(target != 0);
256     beneficiary = target;
257   }
258 
259   /**
260    * @notice Transfers vested tokens to beneficiary.
261    */
262   function release() public {
263     require(now >= cliff);
264     _releaseTo(beneficiary);
265   }
266 
267   /**
268    * @notice Transfers vested tokens to a target address.
269    * @param target the address to send the tokens to
270    */
271   function releaseTo(address target) onlyBeneficiary public {
272     require(now >= cliff);
273     _releaseTo(target);
274   }
275 
276   /**
277    * @notice Transfers vested tokens to beneficiary.
278    */
279   function _releaseTo(address target) internal {
280     uint256 unreleased = releasableAmount();
281 
282     released = released.add(unreleased);
283 
284     token.safeTransfer(target, unreleased);
285 
286     Released(released);
287   }
288 
289   /**
290    * @notice Allows the owner to revoke the vesting. Tokens already vested are sent to the beneficiary.
291    */
292   function revoke() onlyOwner public {
293     require(revocable);
294     require(!revoked);
295 
296     // Release all vested tokens
297     _releaseTo(beneficiary);
298 
299     // Send the remainder to the owner
300     token.safeTransfer(owner, token.balanceOf(this));
301 
302     revoked = true;
303 
304     Revoked();
305   }
306 
307 
308   /**
309    * @dev Calculates the amount that has already vested but hasn't been released yet.
310    */
311   function releasableAmount() public constant returns (uint256) {
312     return vestedAmount().sub(released);
313   }
314 
315   /**
316    * @dev Calculates the amount that has already vested.
317    */
318   function vestedAmount() public constant returns (uint256) {
319     uint256 currentBalance = token.balanceOf(this);
320     uint256 totalBalance = currentBalance.add(released);
321 
322     if (now < cliff) {
323       return 0;
324     } else if (now >= start.add(duration) || revoked) {
325       return totalBalance;
326     } else {
327       return totalBalance.mul(now.sub(start)).div(duration);
328     }
329   }
330 
331   /**
332    * @notice Allow withdrawing any token other than the relevant one
333    */
334   function releaseForeignToken(ERC20 _token, uint256 amount) onlyOwner {
335     require(_token != token);
336     _token.transfer(owner, amount);
337   }
338 }