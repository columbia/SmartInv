1 //SPDX-License-Identifier: Delayed Release MIT
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
35     function _mint(address to_, uint256 amount_) internal {
36         totalSupply += amount_;
37         balanceOf[to_] += amount_;
38         emit Transfer(address(0x0), to_, amount_);
39     }
40     function _burn(address from_, uint256 amount_) internal {
41         balanceOf[from_] -= amount_;
42         totalSupply -= amount_;
43         emit Transfer(from_, address(0x0), amount_);
44     }
45 
46     // Public Functions
47     function approve(address spender_, uint256 amount_) public virtual returns (bool) {
48         allowance[msg.sender][spender_] = amount_;
49         emit Approval(msg.sender, spender_, amount_);
50         return true;
51     }
52     function transfer(address to_, uint256 amount_) public virtual returns (bool) {
53         balanceOf[msg.sender] -= amount_;
54         balanceOf[to_] += amount_;
55         emit Transfer(msg.sender, to_, amount_);
56         return true;
57     }
58     function transferFrom(address from_, address to_, uint256 amount_) public virtual returns (bool) {
59         if (allowance[from_][msg.sender] != type(uint256).max) {
60             allowance[from_][msg.sender] -= amount_; }
61         balanceOf[from_] -= amount_;
62         balanceOf[to_] += amount_;
63         emit Transfer(from_, to_, amount_);
64         return true;
65     }
66 
67     // 0xInuarashi Custom Functions
68     function multiTransfer(address[] memory to_, uint256[] memory amounts_) public virtual {
69         require(to_.length == amounts_.length, "ERC20I: To and Amounts length Mismatch!");
70         for (uint256 i = 0; i < to_.length; i++) {
71             transfer(to_[i], amounts_[i]);
72         }
73     }
74     function multiTransferFrom(address[] memory from_, address[] memory to_, uint256[] memory amounts_) public virtual {
75         require(from_.length == to_.length && from_.length == amounts_.length, "ERC20I: From, To, and Amounts length Mismatch!");
76         for (uint256 i = 0; i < from_.length; i++) {
77             transferFrom(from_[i], to_[i], amounts_[i]);
78         }
79     }
80 }
81 
82 abstract contract ERC20IBurnable is ERC20I {
83     function burn(uint256 amount_) external virtual {
84         _burn(msg.sender, amount_);
85     }
86     function burnFrom(address from_, uint256 amount_) public virtual {
87         uint256 _currentAllowance = allowance[from_][msg.sender];
88         require(_currentAllowance >= amount_, "ERC20IBurnable: Burn amount requested exceeds allowance!");
89 
90         if (allowance[from_][msg.sender] != type(uint256).max) {
91             allowance[from_][msg.sender] -= amount_; }
92 
93         _burn(from_, amount_);
94     }
95 }
96 
97 abstract contract Ownable {
98     address public owner;
99     constructor() { 
100         owner = msg.sender; 
101     }
102     modifier onlyOwner { 
103         require(owner == msg.sender, "Ownable: caller is not the owner"); 
104         _; 
105     }
106     function transferOwnership(address newOwner_) public virtual onlyOwner {
107         owner = newOwner_; 
108     }
109 }
110 
111 interface iMES {
112     struct Yield { uint40 yieldRate_; uint40 lastUpdatedTime_; uint176 pendingRewards_; }
113     function raw_getTotalClaimableTokens(address address_) external view returns (uint256);
114     function addressToYield(address address_) external view returns (Yield memory);
115 }
116 
117 contract MartianEssence is ERC20IBurnable, Ownable {
118 
119     // Constructor and Treasury Mints
120     constructor() ERC20I("Martian Essence", "MES") {
121 
122         // Treasury Mint. We will never use this, except to benefit the community.
123         // This is 10M and is around 5% of the theoretical total supply.
124         _mint(msg.sender, 10000000 ether);
125     }
126 
127     // Interface with Old MES
128     iMES public oMES = iMES(0x984b6968132DA160122ddfddcc4461C995741513);
129     function setoMEs(address address_) external onlyOwner {
130         oMES = iMES(address_);
131     }
132 
133     // Times
134     uint40 public yieldStartTime = 1638619200; // 2021-12-04_07-00-00 EST
135     uint40 public yieldEndTime = 1956502800; // 2031-12-31_12-00-00 EST
136     function setYieldEndTime(uint40 yieldEndTime_) external onlyOwner { 
137         yieldEndTime = yieldEndTime_; }
138 
139     // Controllers
140     mapping(address => bool) public mesControllers; 
141     function setController(address address_, bool bool_) external onlyOwner {
142         mesControllers[address_] = bool_; }
143     modifier onlyControllers { 
144         require(mesControllers[msg.sender], "You are not a controller!"); _; }
145 
146     // Yield Info
147     uint256 public globalModulus = (10 ** 14);
148     uint40 public halvingRate = 1; // This is not used
149 
150     struct Yield {
151         uint40 yieldRate_;
152         uint40 lastUpdatedTime_;
153         uint176 pendingRewards_;
154     }
155 
156     mapping(address => Yield) public addressToYield;
157 
158     function setHalvingRate(uint40 rate_) external onlyOwner {
159         halvingRate = rate_; }
160 
161     // Events
162     event Claim(address to_, uint256 amount_);
163 
164     // Administration
165     function setYieldRate(address address_, uint256 yieldRate_) external onlyControllers {
166         uint40 _yieldRate = uint40(yieldRate_ / globalModulus);
167         addressToYield[address_].yieldRate_ = _yieldRate;
168     }
169     function addYieldRate(address address_, uint256 yieldRateAdd_) external onlyControllers {
170         uint40 _yieldRateAdd = uint40(yieldRateAdd_ / globalModulus);
171         addressToYield[address_].yieldRate_ += _yieldRateAdd;
172     }
173     function subYieldRate(address address_, uint256 yieldRateSub_) external onlyControllers {
174         uint40 _yieldRateSub = uint40(yieldRateSub_ / globalModulus);
175         addressToYield[address_].yieldRate_ -= _yieldRateSub;
176     }
177 
178     // Credits System
179     function deductCredits(address address_, uint256 amount_) external onlyControllers {
180         uint40 _amount = uint40(amount_ / globalModulus);
181         require(addressToYield[address_].pendingRewards_ >= _amount, "Not enough credits!");
182         addressToYield[address_].pendingRewards_ -= _amount;
183     }
184     function addCredits(address address_, uint256 amount_) external onlyControllers {
185         uint40 _amount = uint40(amount_ / globalModulus);
186         addressToYield[address_].pendingRewards_ += _amount;
187     }
188 
189     // ERC20 Burn (Stacked Functions!)
190     function burn(address from_, uint256 amount_) external onlyControllers {
191         _burn(from_, amount_);
192     }
193 
194     // ERC20 Airdrop for Migration
195     function airdropMigration(address[] calldata addresses_, uint256[] calldata amounts_) external onlyOwner {
196         require(addresses_.length == amounts_.length,
197             "Array length mismatch!");
198         
199         for (uint256 i = 0; i < addresses_.length; i++) {
200             _mint(addresses_[i], amounts_[i]);
201         }
202     }
203 
204     // Migrator: Unstuck Addresses
205     function migrateSetNewYieldInfos(address[] calldata addresses_, uint40[] calldata lastUpdatedTimes_,
206     uint40[] calldata yieldRates_, uint176[] calldata pendingRewards_) external onlyOwner {
207         require(addresses_.length == lastUpdatedTimes_.length
208             && addresses_.length == yieldRates_.length
209             && addresses_.length == pendingRewards_.length,
210             "Array lengths mismatch!");
211         
212         for (uint256 i = 0; i < addresses_.length; i++) {
213             addressToYield[addresses_[i]].lastUpdatedTime_ = lastUpdatedTimes_[i];
214             addressToYield[addresses_[i]].yieldRate_ = yieldRates_[i];
215             addressToYield[addresses_[i]].pendingRewards_ = pendingRewards_[i];
216         }
217     }
218 
219     // Internal View Functions
220     function __getSmallerValueUint40(uint40 a, uint40 b) internal pure returns (uint40) {
221         return a < b ? a : b;
222     }
223     function __getTimestamp() internal view returns (uint40) {
224         return __getSmallerValueUint40(uint40(block.timestamp), yieldEndTime);
225     }
226     function __calculateYieldReward(address address_) internal view returns (uint176) {
227         // ~0xInuarashi: The fixed calculation code...
228         uint256 _totalYieldRate = uint256(addressToYield[address_].yieldRate_); 
229         
230         if (_totalYieldRate == 0) { return 0; }
231         
232         uint256 _time = uint256(__getSmallerValueUint40(uint40(block.timestamp), yieldEndTime));
233         uint256 _lastUpdate = uint256(addressToYield[address_].lastUpdatedTime_);
234 
235         if (_lastUpdate > yieldStartTime) {
236             return uint176( (_totalYieldRate * (_time - _lastUpdate) / 1 days) / halvingRate);
237         } else {
238             return 0;
239         }
240     }
241 
242     // Migration Logic
243     bool public migrationEnabled = true;
244     function setMigrationEnabled(bool bool_) external onlyOwner { migrationEnabled = bool_; }
245 
246     function __migrateRewards(address address_) internal {
247         require(migrationEnabled,
248             "Migration is not enabled!");
249         
250         uint40 _time = __getTimestamp();
251         uint40 _lastUpdate = addressToYield[address_].lastUpdatedTime_;
252 
253         require(_lastUpdate == 0,
254             "You have already migrated!");
255         
256         // Set the time. This starts the yield again.
257         addressToYield[address_].lastUpdatedTime_ = _time;
258         
259         // Claim their rewards for them from the old contract
260         uint176 _pendingRewards = uint176(oMES.raw_getTotalClaimableTokens(address_));
261 
262         if (_pendingRewards > 0) {
263             addressToYield[address_].pendingRewards_ = _pendingRewards;
264         }
265 
266         // Set their yield rate to the previous contract's yield rate
267         uint40 _yieldRate = oMES.addressToYield(address_).yieldRate_;
268 
269         if (_yieldRate > 0) {
270             addressToYield[address_].yieldRate_ = _yieldRate;
271         }
272     }
273 
274     function migrateRewards(address[] calldata addresses_) public {
275         require(migrationEnabled,
276             "Migration is not enabled!");
277     
278         for (uint256 i = 0; i < addresses_.length; i++) {
279             __migrateRewards(addresses_[i]);
280         }
281     }
282 
283     // Internal Write Functions
284     function __updateYieldReward(address address_) internal {
285         uint40 _time = __getSmallerValueUint40(uint40(block.timestamp), yieldEndTime);
286         uint40 _lastUpdate = addressToYield[address_].lastUpdatedTime_;
287 
288         if (_lastUpdate > 0) { 
289             addressToYield[address_].pendingRewards_ += __calculateYieldReward(address_); 
290         } else {
291             // Migrate Rewards Logic if _lastUpdate is 0
292             if (migrationEnabled) {
293                 __migrateRewards(address_);
294             }
295         }
296 
297         if (_lastUpdate != yieldEndTime) { 
298             addressToYield[address_].lastUpdatedTime_ = _time; 
299         }
300     }
301 
302     function __claimYieldReward(address address_) internal {
303         uint176 _pendingRewards = addressToYield[address_].pendingRewards_;
304 
305         if (_pendingRewards > 0) { 
306             addressToYield[address_].pendingRewards_ = 0;
307 
308             uint256 _expandedReward = uint256(_pendingRewards * globalModulus);
309 
310             _mint(address_, _expandedReward);
311             emit Claim(address_, _expandedReward);
312         } 
313     }
314 
315     // Public Write Functions
316     function updateReward(address address_) public {
317         __updateYieldReward(address_); 
318     }
319     function claimTokens(address address_) public {
320         __updateYieldReward(address_);
321         __claimYieldReward(address_);
322     }
323 
324     // Public Write Multi-Functions
325     function multiUpdateReward(address[] memory addresses_) public {
326         for (uint256 i = 0; i < addresses_.length; i++) {
327             updateReward(addresses_[i]);
328         }
329     }
330     function multiClaimTokens(address[] memory addresses_) public {
331         for (uint256 i = 0; i < addresses_.length; i++) {
332             claimTokens(addresses_[i]);
333         }
334     }
335 
336     // Public View Functions
337     function getStorageClaimableTokens(address address_) public view returns (uint256) {
338         return uint256( uint256(addressToYield[address_].pendingRewards_) * globalModulus);
339     }
340     function getPendingClaimableTokens(address address_) public view returns (uint256) {
341         return uint256( uint256(__calculateYieldReward(address_)) * globalModulus);
342     }
343     function getTotalClaimableTokens(address address_) public view returns (uint256) {
344         return getStorageClaimableTokens(address_) + getPendingClaimableTokens(address_);
345     }
346     function getYieldRateOfAddress(address address_) public view returns (uint256) {
347         return uint256( uint256(addressToYield[address_].yieldRate_) * globalModulus); 
348     }
349     function raw_getStorageClaimableTokens(address address_) public view returns (uint256) {
350         return uint256(addressToYield[address_].pendingRewards_);
351     }
352     function raw_getPendingClaimableTokens(address address_) public view returns (uint256) {
353         return uint256(__calculateYieldReward(address_));
354     }
355     function raw_getTotalClaimableTokens(address address_) public view returns (uint256) {
356         return raw_getStorageClaimableTokens(address_) + raw_getPendingClaimableTokens(address_);
357     }
358 
359 }