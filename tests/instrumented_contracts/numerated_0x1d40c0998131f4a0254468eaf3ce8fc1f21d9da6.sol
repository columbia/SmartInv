1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipRenounced(address indexed previousOwner);
14     event OwnershipTransferred(
15         address indexed previousOwner,
16         address indexed newOwner
17     );
18 
19 
20     /**
21     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22     * account.
23     */
24     constructor() public {
25         owner = msg.sender;
26     }
27 
28     /**
29     * @dev Throws if called by any account other than the owner.
30     */
31     modifier onlyOwner() {
32         require(msg.sender == owner, "Only owner is allowed for this operation.");
33         _;
34     }
35 
36     /**
37     * @dev Allows the current owner to relinquish control of the contract.
38     * @notice Renouncing to ownership will leave the contract without an owner.
39     * It will not be possible to call the functions with the `onlyOwner`
40     * modifier anymore.
41     */
42     function renounceOwnership() public onlyOwner {
43         emit OwnershipRenounced(owner);
44         owner = address(0);
45     }
46 
47     /**
48     * @dev Allows the current owner to transfer control of the contract to a newOwner.
49     * @param _newOwner The address to transfer ownership to.
50     */
51     function transferOwnership(address _newOwner) public onlyOwner {
52         _transferOwnership(_newOwner);
53     }
54 
55     /**
56     * @dev Transfers control of the contract to a newOwner.
57     * @param _newOwner The address to transfer ownership to.
58     */
59     function _transferOwnership(address _newOwner) internal {
60         require(_newOwner != address(0), "Cannot transfer ownership to an empty user.");
61         emit OwnershipTransferred(owner, _newOwner);
62         owner = _newOwner;
63     }
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72     /**
73     * @dev Multiplies two numbers, throws on overflow.
74     */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         c = a * b;
84         assert(c / a == b);
85         return c;
86     }
87 
88     /**
89     * @dev Integer division of two numbers, truncating the quotient.
90     */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         // assert(b > 0); // Solidity automatically throws when dividing by 0
93         // uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95         return a / b;
96     }
97 
98     /**
99     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100     */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         assert(b <= a);
103         return a - b;
104     }
105 
106     /**
107     * @dev Adds two numbers, throws on overflow.
108     */
109     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110         c = a + b;
111         assert(c >= a);
112         return c;
113     }
114 }
115 
116 /**
117  * @title ERC20Basic
118  * @dev Simpler version of ERC20 interface
119  * See https://github.com/ethereum/EIPs/issues/179
120  */
121 contract ERC20Basic {
122     function totalSupply() public view returns (uint256);
123     function balanceOf(address who) public view returns (uint256);
124     function transfer(address to, uint256 value) public returns (bool);
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 contract ANKRTokenVault is Ownable {
129     using SafeMath for uint256;
130 
131     // token contract Address
132 
133     //Wallet Addresses for allocation immediately
134     address public opentokenAddress           = 0x7B1f5F0FCa6434D7b01161552D335A774706b650;
135     address public tokenmanAddress            = 0xBB46219183f1F17364914e353A44F982de77eeC8;
136 
137     // Wallet Address for unlocked token
138     address public marketingAddress           = 0xc2e96F45232134dD32B6DF4D51AC82248CA942cc;
139 
140     // Wallet Address for locked token
141     address public teamReserveWallet          = 0x0AA7Aa665276A96acD25329354FeEa8F955CAf2b;
142     address public communityReserveWallet     = 0xeFA1f626670445271359940e1aC346Ac374019E7;
143 
144     //Token Allocations
145     uint256 public opentokenAllocation            = 0.5 * (10 ** 9) * (10 ** 18);
146     uint256 public tokenmanAllocation             = 0.2 * (10 ** 9) * (10 ** 18);
147     uint256 public marketingAllocation            = 0.5 * (10 ** 9) * (10 ** 18);
148     uint256 public teamReserveAllocation          = 2.0 * (10 ** 9) * (10 ** 18);
149     uint256 public communityReserveAllocation     = 4.0 * (10 ** 9) * (10 ** 18);
150 
151     //Total Token Allocations
152     uint256 public totalAllocation = 10 * (10 ** 9) * (10 ** 18);
153 
154     uint256 public investorTimeLock = 183 days; // six months
155     uint256 public othersTimeLock = 3 * 365 days;
156     // uint256 public investorVestingStages = 1;
157     uint256 public othersVestingStages = 3 * 12;
158 
159     // uint256 public investorTimeLock = 5 seconds; // six months
160     // uint256 public othersTimeLock = 3 * 12 * 5 seconds;
161 
162     /** Reserve allocations */
163     mapping(address => uint256) public allocations;
164 
165     /** When timeLocks are over (UNIX Timestamp)  */
166     mapping(address => uint256) public timeLocks;
167 
168     /** How many tokens each reserve wallet has claimed */
169     mapping(address => uint256) public claimed;
170 
171     /** How many tokens each reserve wallet has claimed */
172     mapping(address => uint256) public lockedInvestors;
173     address[] public lockedInvestorsIndices;
174 
175     /** How many tokens each reserve wallet has claimed */
176     mapping(address => uint256) public unLockedInvestors;
177     address[] public unLockedInvestorsIndices;
178 
179     /** When this vault was locked (UNIX Timestamp)*/
180     uint256 public lockedAt = 0;
181 
182     ERC20Basic public token;
183 
184     /** Allocated reserve tokens */
185     event Allocated(address wallet, uint256 value);
186 
187     /** Distributed reserved tokens */
188     event Distributed(address wallet, uint256 value);
189 
190     /** Tokens have been locked */
191     event Locked(uint256 lockTime);
192 
193     //Any of the reserve wallets
194     modifier onlyReserveWallets {
195         require(allocations[msg.sender] > 0, "There should be non-zero allocation.");
196         _;
197     }
198 
199     // //Only Ankr team reserve wallet
200     // modifier onlyNonInvestorReserve {
201     //     require(
202     //         msg.sender == teamReserveWallet || msg.sender == communityReserveWallet, 
203     //         "Only team and community is allowed for this operation.");
204     //     require(allocations[msg.sender] > 0, "There should be non-zero allocation for team.");
205     //     _;
206     // }
207 
208     //Has not been locked yet
209     modifier notLocked {
210         require(lockedAt == 0, "lockedAt should be zero.");
211         _;
212     }
213 
214     modifier locked {
215         require(lockedAt > 0, "lockedAt should be larger than zero.");
216         _;
217     }
218 
219     //Token allocations have not been set
220     modifier notAllocated {
221         require(allocations[opentokenAddress] == 0, "Allocation should be zero.");
222         require(allocations[tokenmanAddress] == 0, "Allocation should be zero.");
223         require(allocations[marketingAddress] == 0, "Allocation should be zero.");
224         require(allocations[teamReserveWallet] == 0, "Allocation should be zero.");
225         require(allocations[communityReserveWallet] == 0, "Allocation should be zero.");
226         _;
227     }
228 
229     constructor(ERC20Basic _token) public {
230         token = ERC20Basic(_token);
231     }
232 
233     function addUnlockedInvestor(address investor, uint256 amt) public onlyOwner notLocked notAllocated returns (bool) {
234         require(investor != address(0), "Unlocked investor must not be zero.");
235         require(amt > 0, "Unlocked investor's amount should be larger than zero.");
236         unLockedInvestorsIndices.push(investor);
237         unLockedInvestors[investor] = amt * (10 ** 18);
238         return true;
239     }
240 
241     function addLockedInvestor(address investor, uint256 amt) public onlyOwner notLocked notAllocated returns (bool) {
242         require(investor != address(0), "Locked investor must not be zero.");
243         require(amt > 0, "Locked investor's amount should be larger than zero.");
244         lockedInvestorsIndices.push(investor);
245         lockedInvestors[investor] = amt * (10 ** 18);
246         return true;
247     }
248 
249     function allocate() public notLocked notAllocated onlyOwner {
250 
251         //Makes sure Token Contract has the exact number of tokens
252         require(token.balanceOf(address(this)) == totalAllocation, "Token should not be allocated yet.");
253 
254         allocations[opentokenAddress] = opentokenAllocation;
255         allocations[tokenmanAddress] = tokenmanAllocation;
256         allocations[marketingAddress] = marketingAllocation;
257         allocations[teamReserveWallet] = teamReserveAllocation;
258         allocations[communityReserveWallet] = communityReserveAllocation;
259 
260         emit Allocated(opentokenAddress, opentokenAllocation);
261         emit Allocated(tokenmanAddress, tokenmanAllocation);
262         emit Allocated(marketingAddress, marketingAllocation);
263         emit Allocated(teamReserveWallet, teamReserveAllocation);
264         emit Allocated(communityReserveWallet, communityReserveAllocation);
265 
266         address cur;
267         uint arrayLength;
268         uint i;
269         arrayLength = unLockedInvestorsIndices.length;
270         for (i = 0; i < arrayLength; i++) {
271             cur = unLockedInvestorsIndices[i];
272             allocations[cur] = unLockedInvestors[cur];
273             emit Allocated(cur, unLockedInvestors[cur]);
274         }
275         arrayLength = lockedInvestorsIndices.length;
276         for (i = 0; i < arrayLength; i++) {
277             cur = lockedInvestorsIndices[i];
278             allocations[cur] = lockedInvestors[cur];
279             emit Allocated(cur, lockedInvestors[cur]);
280         }
281 
282         // lock();
283         preDistribute();
284     }
285 
286     function distribute() public notLocked onlyOwner {
287         claimTokenReserve(marketingAddress);
288         
289         uint arrayLength;
290         uint i;
291         arrayLength = unLockedInvestorsIndices.length;
292         for (i = 0; i < arrayLength; i++) {
293             claimTokenReserve(unLockedInvestorsIndices[i]);
294         }
295         lock();
296     }
297 
298     //Lock the vault for the three wallets
299     function lock() internal {
300 
301         lockedAt = block.timestamp;
302 
303         timeLocks[teamReserveWallet] = lockedAt.add(othersTimeLock);
304         timeLocks[communityReserveWallet] = lockedAt.add(othersTimeLock);
305 
306         emit Locked(lockedAt);
307     }
308 
309     //In the case locking failed, then allow the owner to reclaim the tokens on the contract.
310     //Recover Tokens in case incorrect amount was sent to contract.
311     function recoverFailedLock() external notLocked notAllocated onlyOwner {
312 
313         // Transfer all tokens on this contract back to the owner
314         require(token.transfer(owner, token.balanceOf(address(this))), "recoverFailedLock: token transfer failed!");
315     }
316 
317     // Total number of tokens currently in the vault
318     function getTotalBalance() public view returns (uint256 tokensCurrentlyInVault) {
319 
320         return token.balanceOf(address(this));
321 
322     }
323 
324     // Number of tokens that are still locked
325     function getLockedBalance() public view onlyReserveWallets returns (uint256 tokensLocked) {
326 
327         return allocations[msg.sender].sub(claimed[msg.sender]);
328 
329     }
330 
331     //Distribute tokens for non-vesting reserve wallets
332     function preDistribute() internal {
333         claimTokenReserve(opentokenAddress);
334         claimTokenReserve(tokenmanAddress);
335     }
336 
337     //Claim tokens for non-vesting reserve wallets
338     function claimTokenReserve(address reserveWallet) internal {
339         // Must Only claim once
340         require(allocations[reserveWallet] > 0, "There should be non-zero allocation.");
341         require(claimed[reserveWallet] == 0, "This address should be never claimed before.");
342 
343         uint256 amount = allocations[reserveWallet];
344 
345         claimed[reserveWallet] = amount;
346 
347         require(token.transfer(reserveWallet, amount), "Token transfer failed");
348 
349         emit Distributed(reserveWallet, amount);
350     }
351 
352     //Claim tokens for Investor's reserve wallet
353     function distributeInvestorsReserve() onlyOwner locked public {
354         require(block.timestamp.sub(lockedAt) > investorTimeLock, "Still in locking period.");
355 
356         uint arrayLength;
357         uint i;
358         
359         arrayLength = lockedInvestorsIndices.length;
360         for (i = 0; i < arrayLength; i++) {
361             claimTokenReserve(lockedInvestorsIndices[i]);
362         }
363     }
364 
365     //Claim tokens for Team and Community reserve wallet
366     // function claimNonInvestorReserve() public onlyNonInvestorReserve locked {
367     function claimNonInvestorReserve() public onlyOwner locked {
368         uint256 vestingStage = nonInvestorVestingStage();
369 
370         //Amount of tokens the team should have at this vesting stage
371         uint256 totalUnlockedTeam = vestingStage.mul(allocations[teamReserveWallet]).div(othersVestingStages);
372         uint256 totalUnlockedComm = vestingStage.mul(allocations[communityReserveWallet]).div(othersVestingStages);
373 
374         //Previously claimed tokens must be less than what is unlocked
375         require(claimed[teamReserveWallet] < totalUnlockedTeam, "Team's claimed tokens must be less than what is unlocked");
376         require(claimed[communityReserveWallet] < totalUnlockedComm, "Community's claimed tokens must be less than what is unlocked");
377 
378         uint256 paymentTeam = totalUnlockedTeam.sub(claimed[teamReserveWallet]);
379         uint256 paymentComm = totalUnlockedComm.sub(claimed[communityReserveWallet]);
380 
381         claimed[teamReserveWallet] = totalUnlockedTeam;
382         claimed[communityReserveWallet] = totalUnlockedComm;
383 
384         require(token.transfer(teamReserveWallet, paymentTeam), "Team token transfer failed.");
385         require(token.transfer(communityReserveWallet, paymentComm), "Community token transfer failed.");
386 
387         emit Distributed(teamReserveWallet, paymentTeam);
388         emit Distributed(communityReserveWallet, paymentComm);
389     }
390 
391     //Current Vesting stage for Ankr's Team and Community
392     function nonInvestorVestingStage() public view returns(uint256){
393 
394         // Every month
395         uint256 vestingMonths = othersTimeLock.div(othersVestingStages);
396 
397         uint256 stage = (block.timestamp.sub(lockedAt).sub(investorTimeLock)).div(vestingMonths);
398 
399         //Ensures Team and Community vesting stage doesn't go past othersVestingStages
400         if(stage > othersVestingStages){
401             stage = othersVestingStages;
402         }
403 
404         return stage;
405 
406     }
407 }