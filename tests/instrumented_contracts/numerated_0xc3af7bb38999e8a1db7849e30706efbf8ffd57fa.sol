1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5     ERC20I (ERC20 0xInuarashi Edition)
6     Minified and Gas Optimized
7     From the efforts of the 0x Collective
8     https://0xcollective.net
9 */
10 
11 contract ERC20I {
12     // Token Params
13     string public name;
14     string public symbol;
15     constructor(string memory name_, string memory symbol_) {
16         name = name_;
17         symbol = symbol_;
18     }
19 
20     // Decimals
21     uint8 public constant decimals = 18;
22 
23     // Supply
24     uint256 public totalSupply;
25     
26     // Mappings of Balances
27     mapping(address => uint256) public balanceOf;
28     mapping(address => mapping(address => uint256)) public allowance;
29 
30     // Events
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 
34     // Internal Functions
35     function _mint(address to_, uint256 amount_) internal virtual {
36         totalSupply += amount_;
37         balanceOf[to_] += amount_;
38         emit Transfer(address(0x0), to_, amount_);
39     }
40     function _burn(address from_, uint256 amount_) internal virtual {
41         balanceOf[from_] -= amount_;
42         totalSupply -= amount_;
43         emit Transfer(from_, address(0x0), amount_);
44     }
45     function _approve(address owner_, address spender_, uint256 amount_) internal virtual {
46         allowance[owner_][spender_] = amount_;
47         emit Approval(owner_, spender_, amount_);
48     }
49 
50     // Public Functions
51     function approve(address spender_, uint256 amount_) public virtual returns (bool) {
52         _approve(msg.sender, spender_, amount_);
53         return true;
54     }
55     function transfer(address to_, uint256 amount_) public virtual returns (bool) {
56         balanceOf[msg.sender] -= amount_;
57         balanceOf[to_] += amount_;
58         emit Transfer(msg.sender, to_, amount_);
59         return true;
60     }
61     function transferFrom(address from_, address to_, uint256 amount_) public virtual returns (bool) {
62         if (allowance[from_][msg.sender] != type(uint256).max) {
63             allowance[from_][msg.sender] -= amount_; }
64         balanceOf[from_] -= amount_;
65         balanceOf[to_] += amount_;
66         emit Transfer(from_, to_, amount_);
67         return true;
68     }
69 
70     // 0xInuarashi Custom Functions
71     function multiTransfer(address[] memory to_, uint256[] memory amounts_) public virtual {
72         require(to_.length == amounts_.length, "ERC20I: To and Amounts length Mismatch!");
73         for (uint256 i = 0; i < to_.length; i++) {
74             transfer(to_[i], amounts_[i]);
75         }
76     }
77     function multiTransferFrom(address[] memory from_, address[] memory to_, uint256[] memory amounts_) public virtual {
78         require(from_.length == to_.length && from_.length == amounts_.length, "ERC20I: From, To, and Amounts length Mismatch!");
79         for (uint256 i = 0; i < from_.length; i++) {
80             transferFrom(from_[i], to_[i], amounts_[i]);
81         }
82     }
83 }
84 
85 abstract contract ERC20IBurnable is ERC20I {
86     function burn(uint256 amount_) external virtual {
87         _burn(msg.sender, amount_);
88     }
89     function burnFrom(address from_, uint256 amount_) public virtual {
90         uint256 _currentAllowance = allowance[from_][msg.sender];
91         require(_currentAllowance >= amount_, "ERC20IBurnable: Burn amount requested exceeds allowance!");
92 
93         if (allowance[from_][msg.sender] != type(uint256).max) {
94             allowance[from_][msg.sender] -= amount_; }
95 
96         _burn(from_, amount_);
97     }
98 }
99 
100 // Open0x Ownable (by 0xInuarashi)
101 abstract contract Ownable {
102     address public owner;
103     event OwnershipTransferred(address indexed oldOwner_, address indexed newOwner_);
104     constructor() { owner = msg.sender; }
105     modifier onlyOwner {
106         require(owner == msg.sender, "Ownable: caller is not the owner");
107         _;
108     }
109     function _transferOwnership(address newOwner_) internal virtual {
110         address _oldOwner = owner;
111         owner = newOwner_;
112         emit OwnershipTransferred(_oldOwner, newOwner_);    
113     }
114     function transferOwnership(address newOwner_) public virtual onlyOwner {
115         require(newOwner_ != address(0x0), "Ownable: new owner is the zero address!");
116         _transferOwnership(newOwner_);
117     }
118     function renounceOwnership() public virtual onlyOwner {
119         _transferOwnership(address(0x0));
120     }
121 }
122 
123 interface iSpaceYetis {
124     function balanceOf(address address_) external view returns (uint256);
125 }
126 
127 interface iPlasmaOld {
128     
129     struct Yield {
130         uint40 lastUpdatedTime_;
131         uint176 pendingRewards_;
132     }
133 
134     function addressToYield(address address_) external view returns (Yield memory);
135     function getTotalClaimableTokens(address address_) external view returns (uint256);
136     function raw_getTotalClaimableTokens(address address_) external view returns (uint256);
137     function balanceOf(address address_) external view returns (uint256);
138 }
139 
140 contract Plasma is ERC20IBurnable, Ownable {
141     constructor() ERC20I("Plasma", "PLASMA") {}
142 
143     // Interface with Space Yetis
144     iSpaceYetis public SpaceYetis = iSpaceYetis(0x33a39af0F83E9D46a055e6eEbde3296D26d916F4);
145     function setSpaceYetis(address address_) external onlyOwner {
146         SpaceYetis = iSpaceYetis(address_); }
147     
148     // Interface with Plasma (Old)
149     iPlasmaOld public PO = iPlasmaOld(0x194cc053324C919f9c0Aa0caAbC3ac7c15fF6375);
150     function setPlasmaOld(address address_) external onlyOwner {
151         PO = iPlasmaOld(address_); }
152 
153     // Times
154     uint40 public yieldStartTime = 1640221200; // 2021-12-22_20-00 EST
155     uint40 public yieldEndTime = 1955754000; // 2031-12-22_20-00 EST
156     function setYieldEndTime(uint40 yieldEndTime_) external onlyOwner {
157         yieldEndTime = yieldEndTime_; }
158 
159     // Yield Info
160     uint256 public globalModulus = (10 ** 14); // 14 Digits Expansion and Compression
161     uint40 public yieldRatePerYeti = uint40(5 ether / globalModulus); // Yield Rate Compressed
162 
163     struct Yield {
164         uint40 lastUpdatedTime_;
165         uint176 pendingRewards_;
166     }
167 
168     mapping(address => Yield) public addressToYield;
169 
170     // Events
171     event Claim(address to_, uint256 amount_);
172     event CreditsDeducted(address from_, uint256 amount_);
173     event CreditsAdded(address to_, uint256 amount_);
174 
175     // Controllers
176     mapping(address => bool) public plasmaControllers;
177     modifier onlyControllers { 
178         require(plasmaControllers[msg.sender], "You are not a controller!"); _; }
179     function setControllers(address address_, bool bool_) external onlyOwner {
180         plasmaControllers[address_] = bool_; }
181 
182     // Credit System
183     function deductCredits(address from_, uint256 amount_) external onlyControllers {
184         require(amount_ % globalModulus == 0, 
185             "Amount does not conform to Global Modulus standard!");
186 
187         uint176 _compressedAmount = uint176(amount_ / globalModulus);
188 
189         require(addressToYield[from_].pendingRewards_ >= _compressedAmount, 
190             "Not enough credit balance to deduct!");
191 
192         // Deduct the credits 
193         addressToYield[from_].pendingRewards_ -= _compressedAmount;
194         emit CreditsDeducted(from_, amount_);
195     }
196     function addCredits(address to_, uint256 amount_) external onlyControllers {
197         require(amount_ % globalModulus == 0,
198             "Amount does not conform to Global Modulus standard!");
199         
200         uint176 _compressedAmount = uint176(amount_ / globalModulus); 
201 
202         // Add the credits
203         addressToYield[to_].pendingRewards_ += _compressedAmount;
204         emit CreditsAdded(to_, amount_);
205     }
206 
207     // ERC20 Burn by Controllers
208     function burnByController(address from_, uint256 amount_) external onlyControllers {
209         _burn(from_, amount_);
210     }
211 
212     // ERC20 Airdrop for Migration
213     function airdropMigration(address[] calldata addresses_) external onlyOwner {
214         for (uint256 i = 0; i < addresses_.length; i++) {
215             // Migration Logic for Claimed Tokens
216             require( balanceOf[addresses_[i]] == 0,
217                 "This address already has balance!");
218 
219             // Check the old contract balance of the tokens
220             uint256 _balanceOfPO = PO.balanceOf(addresses_[i]);
221 
222             _mint(addresses_[i], _balanceOfPO);
223         }
224     }
225     function airdropMigration2(address[] calldata addresses_, uint256[] calldata amounts_) external onlyOwner {
226         require(addresses_.length == amounts_.length,
227             "Array length mismatch!");
228 
229         for (uint256 i = 0; i < addresses_.length; i++) {
230             _mint(addresses_[i], amounts_[i]);
231         }
232     }
233 
234     // Migrator : This is to unstuck these addresses
235     function migrateSetNewTimestampOnAddresses(address[] calldata addresses_) external onlyOwner {
236         for (uint256 i = 0; i < addresses_.length; i++) {
237             addressToYield[addresses_[i]].lastUpdatedTime_ = uint40(block.timestamp);
238         }
239     }
240 
241     // Internal View Functions
242     function __getSmallerValueUint40(uint40 a, uint40 b) internal pure returns (uint40) {
243         return a < b ? a : b; 
244     }
245     function __getTimestamp() internal view returns (uint40) {
246         return __getSmallerValueUint40( uint40(block.timestamp), yieldEndTime );
247     }
248     function __getYieldRate(address address_) internal view returns (uint40) {
249         return uint40( uint40(SpaceYetis.balanceOf(address_)) * yieldRatePerYeti );
250     }
251     function __calculateYieldReward(address address_) internal view returns (uint176) {
252         // Expand the Values
253         uint256 _totalYieldRate = uint256(__getYieldRate(address_));
254         if (_totalYieldRate == 0) { return 0; }
255         uint256 _time = uint256(__getTimestamp());
256         uint256 _lastUpdate = uint256(addressToYield[address_].lastUpdatedTime_);
257 
258         if (_lastUpdate > yieldStartTime) {
259             return uint176( (_totalYieldRate * (_time - _lastUpdate) / 1 days) );
260         } else { return 0; }
261     }
262 
263     // Migration Logic
264     bool public migrationEnabled = true;
265     function setMigrationEnabled(bool bool_) external onlyOwner {
266         migrationEnabled = bool_; }
267     
268     function migrateRewards() public {
269         __migrateRewards(msg.sender);
270     }
271 
272     function migrateRewardsFor(address address_) public {
273         __migrateRewards(address_);
274     }
275 
276     // Internal Write Functions
277     function __migrateRewards(address address_) internal {
278         require(migrationEnabled,
279             "Migration is not enabled!");
280 
281         uint40 _time = __getTimestamp();
282         uint40 _lastUpdate = addressToYield[address_].lastUpdatedTime_;
283 
284         // If _lastUpdate is not 0, the migration logic already ran!
285         require(_lastUpdate == 0,
286             "You have already migrated!");
287         
288         // First, set the time (0) to _time. This starts yield generation.
289         addressToYield[address_].lastUpdatedTime_ = _time;
290 
291         // Second, we check for any pending rewards from PO.
292         uint176 _pendingRewards = uint176(PO.raw_getTotalClaimableTokens(address_));
293 
294         // Then, we update the contract's pending rewards to PO rewards if it is > 0
295         if (_pendingRewards > 0) {
296             addressToYield[address_].pendingRewards_ = _pendingRewards;
297         }
298 
299         // Hooray! Credits Migration has been done.
300 
301     }
302     function __updateYieldReward(address address_) internal {
303         // We don't need to expand these as we're not doing arithmetics on them
304         uint40 _time = __getTimestamp(); 
305         uint40 _lastUpdate = addressToYield[address_].lastUpdatedTime_;
306 
307         // This is not triggered in the case that the user has never minted / held a token before.
308         if (_lastUpdate > 0) {
309             addressToYield[address_].pendingRewards_ += __calculateYieldReward(address_);
310         } else {
311             /*
312                 /!\ Migration Logic Here! /!\
313                 People are calling this function through Character Transfer passively.
314                 Due to this, we need to be able to hook it on the first transfer to migrate
315                 the required datas of the old Plasma contract.
316                 
317                 In this condition, the default _lastUpdate of the address will be 0. 
318                 We call the necessary migration logic.
319 
320                 We also run an IF statement on State Storage to reduce gas cost in the future
321                 for cross-contract checking.
322             */
323 
324             if (migrationEnabled) {
325                 __migrateRewards(address_);
326             }
327         }
328 
329         // This sets the new timestamp for pending rewards calculation. If already ended yield, skip.
330         if (_lastUpdate != yieldEndTime) {
331             addressToYield[address_].lastUpdatedTime_ = _time;
332         }
333     }
334     function __claimYieldReward(address address_) internal { 
335         uint176 _pendingRewards = addressToYield[address_].pendingRewards_;
336 
337         if (_pendingRewards > 0) {
338             addressToYield[address_].pendingRewards_ = 0;
339 
340             uint256 _expandedReward = uint256( uint256(_pendingRewards) * globalModulus);
341 
342             _mint(address_, _expandedReward);
343             emit Claim(address_, _expandedReward);
344         }
345     }
346 
347     // Public Write Functions
348     function updateReward(address address_) public {
349         __updateYieldReward(address_);
350     }
351     function claimTokens() public {
352         __updateYieldReward(msg.sender);
353         __claimYieldReward(msg.sender);
354     }
355     function claimTokensFor(address address_) public onlyControllers {
356         __updateYieldReward(address_);
357         __claimYieldReward(address_);
358     }
359 
360     // Public View Functions
361     function getStorageClaimableTokens(address address_) public view returns (uint256) {
362         return uint256( uint256(addressToYield[address_].pendingRewards_) * globalModulus);
363     }
364     function getPendingClaimableTokens(address address_) public view returns (uint256) {
365         return uint256( uint256(__calculateYieldReward(address_)) * globalModulus);
366     }
367     function getTotalClaimableTokens(address address_) public view returns (uint256) {
368         return uint256( ( uint256(addressToYield[address_].pendingRewards_) + uint256(__calculateYieldReward(address_)) ) * globalModulus );
369     }
370     function getYieldRateOfAddress(address address_) public view returns (uint256) {
371         return uint256( uint256(__getYieldRate(address_)) * globalModulus); 
372     }
373     function raw_getStorageClaimableTokens(address address_) public view returns (uint256) {
374         return uint256(addressToYield[address_].pendingRewards_);
375     }
376     function raw_getPendingClaimableTokens(address address_) public view returns (uint256) {
377         return uint256(__calculateYieldReward(address_));
378     }
379     function raw_getTotalClaimableTokens(address address_) public view returns (uint256) {
380         return uint256( uint256(addressToYield[address_].pendingRewards_) + uint256(__calculateYieldReward(address_)) );
381     }
382 }