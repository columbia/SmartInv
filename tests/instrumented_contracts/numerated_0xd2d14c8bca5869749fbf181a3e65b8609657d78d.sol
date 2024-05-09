1 pragma solidity 0.4.23;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/zacharykilgore/src/flexa/smart-contracts/contracts/TokenVault.sol
6 // flattened :  Saturday, 05-Jan-19 14:47:14 UTC
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     emit OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract ERC20Basic {
85   function totalSupply() public view returns (uint256);
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 contract Claimable is Ownable {
92   address public pendingOwner;
93 
94   /**
95    * @dev Modifier throws if called by any account other than the pendingOwner.
96    */
97   modifier onlyPendingOwner() {
98     require(msg.sender == pendingOwner);
99     _;
100   }
101 
102   /**
103    * @dev Allows the current owner to set the pendingOwner address.
104    * @param newOwner The address to transfer ownership to.
105    */
106   function transferOwnership(address newOwner) onlyOwner public {
107     pendingOwner = newOwner;
108   }
109 
110   /**
111    * @dev Allows the pendingOwner address to finalize the transfer.
112    */
113   function claimOwnership() onlyPendingOwner public {
114     emit OwnershipTransferred(owner, pendingOwner);
115     owner = pendingOwner;
116     pendingOwner = address(0);
117   }
118 }
119 
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) public view returns (uint256);
122   function transferFrom(address from, address to, uint256 value) public returns (bool);
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 library SafeERC20 {
128   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
129     assert(token.transfer(to, value));
130   }
131 
132   function safeTransferFrom(
133     ERC20 token,
134     address from,
135     address to,
136     uint256 value
137   )
138     internal
139   {
140     assert(token.transferFrom(from, to, value));
141   }
142 
143   function safeApprove(ERC20 token, address spender, uint256 value) internal {
144     assert(token.approve(spender, value));
145   }
146 }
147 
148 contract CanReclaimToken is Ownable {
149   using SafeERC20 for ERC20Basic;
150 
151   /**
152    * @dev Reclaim all ERC20Basic compatible tokens
153    * @param token ERC20Basic The address of the token contract
154    */
155   function reclaimToken(ERC20Basic token) external onlyOwner {
156     uint256 balance = token.balanceOf(this);
157     token.safeTransfer(owner, balance);
158   }
159 
160 }
161 
162 contract Recoverable is CanReclaimToken, Claimable {
163   using SafeERC20 for ERC20Basic;
164 
165   /**
166    * @dev Transfer all ether held by the contract to the contract owner.
167    */
168   function reclaimEther() external onlyOwner {
169     owner.transfer(address(this).balance);
170   }
171 
172 }
173 
174 contract TokenVault is Recoverable {
175   using SafeMath for uint256;
176   using SafeERC20 for ERC20Basic;
177 
178   /** The ERC20 token distribution the vault manages. */
179   ERC20Basic public token;
180 
181   /** The amount of tokens that should be allocated prior to locking the vault. */
182   uint256 public tokensToBeAllocated;
183 
184   /** The total amount of tokens allocated through setAllocation. */
185   uint256 public tokensAllocated;
186 
187   /** Total amount of tokens claimed. */
188   uint256 public totalClaimed;
189 
190   /** UNIX timestamp when the contract was locked. */
191   uint256 public lockedAt;
192 
193   /** UNIX timestamp when the contract was unlocked. */
194   uint256 public unlockedAt;
195 
196   /**
197    * Amount of time, in seconds, after locking that must pass before the vault
198    * can be unlocked.
199    */
200   uint256 public vestingPeriod = 0;
201 
202   /** Mapping of accounts to token allocations. */
203   mapping (address => uint256) public allocations;
204 
205   /** Mapping of tokens claimed by a beneficiary. */
206   mapping (address => uint256) public claimed;
207 
208 
209   /** Event to track that allocations have been set and the vault has been locked. */
210   event Locked();
211 
212   /** Event to track when the vault has been unlocked. */
213   event Unlocked();
214 
215   /**
216    * Event to track successful allocation of amount and bonus amount.
217    * @param beneficiary Account that allocation is for
218    * @param amount Amount of tokens allocated
219    */
220   event Allocated(address indexed beneficiary, uint256 amount);
221 
222   /**
223    * Event to track a beneficiary receiving an allotment of tokens.
224    * @param beneficiary Account that received tokens
225    * @param amount Amount of tokens received
226    */
227   event Distributed(address indexed beneficiary, uint256 amount);
228 
229 
230   /** Ensure the vault is able to be loaded. */
231   modifier vaultLoading() {
232     require(lockedAt == 0, "Expected vault to be loadable");
233     _;
234   }
235 
236   /** Ensure the vault has been locked. */
237   modifier vaultLocked() {
238     require(lockedAt > 0, "Expected vault to be locked");
239     _;
240   }
241 
242   /** Ensure the vault has been unlocked. */
243   modifier vaultUnlocked() {
244     require(unlockedAt > 0, "Expected the vault to be unlocked");
245     _;
246   }
247 
248 
249   /**
250    * @notice Creates a TokenVault contract that stores a token distribution.
251    * @param _token The address of the ERC20 token the vault is for
252    * @param _tokensToBeAllocated The amount of tokens that will be allocated
253    * prior to locking
254    * @param _vestingPeriod The amount of time, in seconds, that must pass
255    * after locking in the allocations and then unlocking the allocations for
256    * claiming
257    */
258   constructor(
259     ERC20Basic _token,
260     uint256 _tokensToBeAllocated,
261     uint256 _vestingPeriod
262   )
263     public
264   {
265     require(address(_token) != address(0), "Token address should not be blank");
266     require(_tokensToBeAllocated > 0, "Token allocation should be greater than zero");
267 
268     token = _token;
269     tokensToBeAllocated = _tokensToBeAllocated;
270     vestingPeriod = _vestingPeriod;
271   }
272 
273   /**
274    * @notice Function to set allocations for accounts.
275    * @dev To be called by owner, likely in a scripted fashion.
276    * @param _beneficiary The address to allocate tokens for
277    * @param _amount The amount of tokens to be allocated and made available
278    * once unlocked
279    * @return true if allocation has been set for beneficiary, false if not
280    */
281   function setAllocation(
282     address _beneficiary,
283     uint256 _amount
284   )
285     external
286     onlyOwner
287     vaultLoading
288     returns(bool)
289   {
290     require(_beneficiary != address(0), "Beneficiary of allocation must not be blank");
291     require(_amount != 0, "Amount of allocation must not be zero");
292     require(allocations[_beneficiary] == 0, "Allocation amount for this beneficiary is not already set");
293 
294     // Update the storage
295     allocations[_beneficiary] = allocations[_beneficiary].add(_amount);
296     tokensAllocated = tokensAllocated.add(_amount);
297 
298     emit Allocated(_beneficiary, _amount);
299 
300     return true;
301   }
302 
303   /**
304    * @notice Finalize setting of allocations and begin the lock up (vesting) period.
305    * @dev Should be called after every allocation has been set.
306    * @return true if the vault has been successfully locked
307    */
308   function lock() external onlyOwner vaultLoading {
309     require(tokensAllocated == tokensToBeAllocated, "Expected to allocate all tokens");
310     require(token.balanceOf(address(this)) == tokensAllocated, "Vault must own enough tokens to distribute");
311 
312     // solium-disable-next-line security/no-block-members
313     lockedAt = block.timestamp;
314 
315     emit Locked();
316   }
317 
318   /**
319    * @notice Unlock the vault, allowing the tokens to be distributed to their
320    * beneficiaries.
321    * @dev Must be locked prior to unlocking. Also, the vestingPeriod must be up.
322    */
323   function unlock() external onlyOwner vaultLocked {
324     require(unlockedAt == 0, "Must not be unlocked yet");
325     // solium-disable-next-line security/no-block-members
326     require(block.timestamp >= lockedAt.add(vestingPeriod), "Lock up must be over");
327 
328     // solium-disable-next-line security/no-block-members
329     unlockedAt = block.timestamp;
330 
331     emit Unlocked();
332   }
333 
334   /**
335    * @notice Claim whatever tokens account are allocated to the sender.
336    * @dev Can only be called once contract has been unlocked.
337    * @return true if balance successfully distributed to sender, false otherwise
338    */
339   function claim() public vaultUnlocked returns(bool) {
340     return _transferTokens(msg.sender);
341   }
342 
343   /**
344    * @notice Utility function to actually transfer allocated tokens to their
345    * owners.
346    * @dev Can only be called by the owner. To be used in case an investor would
347    * like their tokens transferred directly for them. Most likely by a script.
348    * @param _beneficiary Address to transfer tokens to
349    * @return true if balance transferred to beneficiary, false otherwise
350    */
351   function transferFor(
352     address _beneficiary
353   )
354     public
355     onlyOwner
356     vaultUnlocked
357     returns(bool)
358   {
359     return _transferTokens(_beneficiary);
360   }
361 
362   /****************
363    *** Internal ***
364    ****************/
365 
366   /**
367    * @dev Calculate the number of tokens a beneficiary can claim.
368    * @param _beneficiary Address to check for
369    * @return The amount of tokens available to be claimed
370    */
371   function _claimableTokens(address _beneficiary) internal view returns(uint256) {
372     return allocations[_beneficiary].sub(claimed[_beneficiary]);
373   }
374 
375   /**
376    * @dev Internal function to transfer an amount of tokens to a beneficiary.
377    * @param _beneficiary Account to transfer tokens to. The amount is derived
378    * from the claimable amount in the vault
379    * @return true if tokens transferred successfully, false if not
380    */
381   function _transferTokens(address _beneficiary) internal returns(bool) {
382     uint256 _amount = _claimableTokens(_beneficiary);
383     require(_amount > 0, "Tokens to claim must be greater than zero");
384 
385     claimed[_beneficiary] = claimed[_beneficiary].add(_amount);
386     totalClaimed = totalClaimed.add(_amount);
387 
388     token.safeTransfer(_beneficiary, _amount);
389 
390     emit Distributed(_beneficiary, _amount);
391 
392     return true;
393   }
394 
395 }