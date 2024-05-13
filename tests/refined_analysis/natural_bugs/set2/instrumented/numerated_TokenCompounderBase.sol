1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
5 // ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
6 // █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
7 // ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
8 // ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
9 // ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
10 // ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
11 // ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
12 // █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
13 // ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
14 // ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
15 // ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝
16                                                                                     
17 //  _____    _           _____                             _         _____             
18 // |_   ____| |_ ___ ___|     |___ _____ ___ ___ _ _ ___ _| |___ ___| __  |___ ___ ___ 
19 //   | || . | '_| -_|   |   --| . |     | . | . | | |   | . | -_|  _| __ -| .'|_ -| -_|
20 //   |_||___|_,_|___|_|_|_____|___|_|_|_|  _|___|___|_|_|___|___|_| |_____|__,|___|___|
21 //                                      |_|                                            
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
26 import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
27 import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
28 
29 import {ERC4626, ERC20, FixedPointMathLib} from "src/shared/interfaces/ERC4626.sol";
30 
31 abstract contract TokenCompounderBase is ReentrancyGuard, ERC4626 {
32 
33     using FixedPointMathLib for uint256;
34     using SafeERC20 for IERC20;
35     
36     struct Fees {
37         /// @notice The performance fee percentage to take for platform on harvest
38         uint256 platformFeePercentage;
39         /// @notice The percentage of fee to pay for caller on harvest
40         uint256 harvestBountyPercentage;
41         /// @notice The fee percentage to take on withdrawal. Fee stays in the vault, and is therefore distributed to vault participants. Used as a mechanism to protect against mercenary capital
42         uint256 withdrawFeePercentage;
43     }
44 
45     /// @notice The fees settings
46     Fees public fees;
47 
48     /// @notice The last block number that the harvest function was executed
49     uint256 public lastHarvestBlock;
50     /// @notice The internal accounting of AUM
51     uint256 internal totalAUM;
52     /// @notice The internal accounting of the deposit limit. Denominated in shares
53     uint256 public depositCap;
54 
55     /// @notice The description of the vault
56     string public description;
57 
58     /// @notice The address of owner
59     address public owner;
60     /// @notice The address of recipient of platform fee
61     address public platform;
62     /// @notice The address of FortressSwap contract
63     address public swap;
64 
65     /// @notice Whether deposits are paused
66     bool public pauseDeposit = false;
67     /// @notice Whether withdrawals are paused
68     bool public pauseWithdraw = false;
69 
70     /// @notice The fee denominator
71     uint256 internal constant FEE_DENOMINATOR = 1e9;
72     /// @notice The maximum withdrawal fee
73     uint256 internal constant MAX_WITHDRAW_FEE = 1e8; // 10%
74     /// @notice The maximum platform fee
75     uint256 internal constant MAX_PLATFORM_FEE = 2e8; // 20%
76     /// @notice The maximum harvest fee
77     uint256 internal constant MAX_HARVEST_BOUNTY = 1e8; // 10%
78 
79     /// @notice The underlying assets
80     address[] public underlyingAssets;
81 
82     /// @notice The mapping of whitelisted feeless redeemers
83     mapping(address => bool) public feelessRedeemerWhitelist;
84 
85     /********************************** Constructor **********************************/
86 
87     constructor(
88             ERC20 _asset,
89             string memory _name,
90             string memory _symbol,
91             string memory _description,
92             address _owner,
93             address _platform,
94             address _swap,
95             address[] memory _underlyingAssets
96         )
97         ERC4626(_asset, _name, _symbol) {
98 
99         {
100             Fees storage _fees = fees;
101             _fees.platformFeePercentage = 50000000; // 5%
102             _fees.harvestBountyPercentage = 25000000; // 2.5%
103             _fees.withdrawFeePercentage = 2000000; // 0.2%
104         }
105         
106         description = _description;
107         owner = _owner;
108         platform = _platform;
109         swap = _swap;
110         depositCap = 0;
111         underlyingAssets = _underlyingAssets;
112     }
113 
114     /********************************** View Functions **********************************/
115 
116     /// @dev Get the list of addresses of the vault's underlying assets (the assets that comprise the LP token, which is the vault primary asset)
117     /// @return - The underlying assets
118     function getUnderlyingAssets() external view returns (address[] memory) {
119         return underlyingAssets;
120     }
121 
122     /// @dev Get the name of the vault
123     /// @return - The name of the vault
124     function getName() external view returns (string memory) {
125         return name;
126     }
127 
128     /// @dev Get the symbol of the vault
129     /// @return - The symbol of the vault
130     function getSymbol() external view returns (string memory) {
131         return symbol;
132     }
133 
134     /// @dev Get the description of the vault
135     /// @return - The description of the vault
136     function getDescription() external view returns (string memory) {
137         return description;
138     }
139 
140     /// @dev Indicates whether there are pending rewards to harvest
141     /// @return - True if there's pending rewards, false if otherwise
142     function isPendingRewards() public view virtual returns (bool) {}
143 
144     /// @dev Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions
145     /// @param _shares - The amount of _shares to redeem
146     /// @return - The amount of _assets in return, after subtracting a withdrawal fee
147     function previewRedeem(uint256 _shares) public view override returns (uint256) {
148         // Calculate assets based on a user's % ownership of vault shares
149         uint256 assets = convertToAssets(_shares);
150 
151         uint256 _totalSupply = totalSupply;
152 
153         // Calculate a fee - zero if user is the last to withdraw
154         uint256 _fee = (_totalSupply == 0 || _totalSupply - _shares == 0) ? 0 : assets.mulDivDown(fees.withdrawFeePercentage, FEE_DENOMINATOR);
155 
156         // Redeemable amount is the post-withdrawal-fee amount
157         return assets - _fee;
158     }
159 
160     /// @dev Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions
161     /// @param _assets - The amount of _assets to withdraw
162     /// @return - The amount of shares to burn, after subtracting a fee
163     function previewWithdraw(uint256 _assets) public view override returns (uint256) {
164         // Calculate shares based on the specified assets' proportion of the pool
165         uint256 _shares = convertToShares(_assets);
166 
167         uint256 _totalSupply = totalSupply;
168 
169         // Factor in additional shares to fulfill withdrawal if user is not the last to withdraw
170         return (_totalSupply == 0 || _totalSupply - _shares == 0) ? _shares : (_shares * FEE_DENOMINATOR) / (FEE_DENOMINATOR - fees.withdrawFeePercentage);
171     }
172 
173     /// @dev Returns the total amount of assets that are managed by the vault
174     /// @return - The total amount of managed assets
175     function totalAssets() public view virtual override returns (uint256) {
176         return totalAUM;
177     }
178 
179     /// @dev Returns the maximum amount of the underlying asset that can be deposited into the Vault for the receiver, through a deposit call
180     function maxDeposit(address) public view override returns (uint256) {
181         uint256 _assetCap = convertToAssets(depositCap);
182         return _assetCap == 0 ? type(uint256).max : _assetCap - totalAUM;
183     }
184 
185     /// @dev Returns the maximum amount of the Vault shares that can be minted for the receiver, through a mint call
186     function maxMint(address) public view override returns (uint256) {
187         return depositCap == 0 ? type(uint256).max : depositCap - totalSupply;
188     }
189 
190     /// @dev Checks if a specific asset is an underlying asset
191     /// @param _asset - The address of the asset to check
192     /// @return - Whether the assets is an underlying asset
193     function _isUnderlyingAsset(address _asset) internal view returns (bool) {
194         address[] memory _underlyingAssets = underlyingAssets;
195 
196         for (uint256 i = 0; i < _underlyingAssets.length; i++) {
197             if (_underlyingAssets[i] == _asset) {
198                 return true;
199             }
200         }
201         return false;
202     }
203 
204     /********************************** Mutated Functions **********************************/
205 
206     /// @dev Mints Vault shares to _receiver by depositing exact amount of underlying assets
207     /// @param _assets - The amount of assets to deposit
208     /// @param _receiver - The receiver of minted shares
209     /// @return _shares - The amount of shares minted
210     function deposit(uint256 _assets, address _receiver) external override nonReentrant returns (uint256 _shares) {
211         if (_assets >= maxDeposit(msg.sender)) revert InsufficientDepositCap();
212 
213         _shares = previewDeposit(_assets);
214         
215         _deposit(msg.sender, _receiver, _assets, _shares);
216 
217         _depositStrategy(_assets, true);
218         
219         return _shares;
220     }
221 
222     /// @dev Mints exact Vault shares to _receiver by depositing amount of underlying assets
223     /// @param _shares - The shares to receive
224     /// @param _receiver - The address of the receiver of shares
225     /// @return _assets - The amount of underlying assets received
226     function mint(uint256 _shares, address _receiver) external override nonReentrant returns (uint256 _assets) {
227         if (_shares >= maxMint(msg.sender)) revert InsufficientDepositCap();
228 
229         _assets = previewMint(_shares);
230 
231         _deposit(msg.sender, _receiver, _assets, _shares);
232 
233         _depositStrategy(_assets, true);
234         
235         return _assets;
236     }
237 
238     /// @dev Burns shares from owner and sends exact assets of underlying assets to _receiver. If the _owner is whitelisted, no withdrawal fee is applied
239     /// @param _assets - The amount of underlying assets to receive
240     /// @param _receiver - The address of the receiver of underlying assets
241     /// @param _owner - The owner of shares
242     /// @return _shares - The amount of shares burned
243     function withdraw(uint256 _assets, address _receiver, address _owner) external override nonReentrant returns (uint256 _shares) { 
244         if (_assets > maxWithdraw(_owner)) revert InsufficientBalance();
245 
246         // If the _owner is whitelisted, we can skip the preview and just convert the assets to shares
247         _shares = feelessRedeemerWhitelist[_owner] ? convertToShares(_assets) : previewWithdraw(_assets);
248 
249         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
250         
251         _withdrawStrategy(_assets, _receiver, true);
252         
253         return _shares;
254     }
255 
256     /// @dev Burns exact shares from owner and sends assets of underlying tokens to _receiver. If the _owner is whitelisted, no withdrawal fee is applied
257     /// @param _shares - The shares to burn
258     /// @param _receiver - The address of the receiver of underlying assets
259     /// @param _owner - The owner of shares to burn
260     /// @return _assets - The amount of assets returned to the user
261     function redeem(uint256 _shares, address _receiver, address _owner) external override nonReentrant returns (uint256 _assets) {
262         if (_shares > maxRedeem(_owner)) revert InsufficientBalance();
263 
264         // If the _owner is whitelisted, we can skip the preview and just convert the shares to assets
265         _assets = feelessRedeemerWhitelist[_owner] ? convertToAssets(_shares) : previewRedeem(_shares);
266 
267         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
268         
269         _withdrawStrategy(_assets, _receiver, true);
270         
271         return _assets;
272     }
273 
274     /// @dev Mints Vault shares to receiver by depositing exact amount of unwrapped underlying assets
275     /// @param _underlyingAsset - The address of the underlying asset to deposit
276     /// @param _receiver - The receiver of minted shares
277     /// @param _underlyingAmount - The amount of unwrapped underlying assets to deposit
278     /// @param _minAmount - The minimum amount of asset to get for unwrapped asset
279     /// @return _shares - The amount of shares minted
280     function depositUnderlying(address _underlyingAsset, address _receiver, uint256 _underlyingAmount, uint256 _minAmount) external virtual payable nonReentrant returns (uint256 _shares) {}
281 
282     /// @notice that this function is vulnerable to a frontrunning attack if called without asserting the returned value
283     /// @notice If the _owner is whitelisted, no withdrawal fee is applied
284     /// @dev Burns exact shares from owner and sends assets of unwrapped underlying tokens to _receiver
285     /// @param _underlyingAsset - The address of the underlying asset to withdraw
286     /// @param _receiver - The address of the receiver of underlying assets
287     /// @param _owner - The owner of shares to burn
288     /// @param _shares - The shares to burn
289     /// @param _minAmount - The minimum amount of underlying assets to get for assets
290     /// @return _underlyingAssets - The amount of assets returned to the user
291     function redeemUnderlying(address _underlyingAsset, address _receiver, address _owner, uint256 _shares, uint256 _minAmount) external virtual nonReentrant returns (uint256 _underlyingAssets) {}
292     
293     /// @dev Harvest the pending rewards and convert to underlying token, then stake
294     /// @param _receiver - The address of account to receive harvest bounty
295     /// @param _minBounty - The minimum amount of harvest bounty _receiver should get
296     function harvest(address _receiver, uint256 _minBounty) external nonReentrant returns (uint256 _rewards) {
297         if (block.number == lastHarvestBlock) revert HarvestAlreadyCalled();
298         lastHarvestBlock = block.number;
299 
300         _rewards = _harvest(_receiver, _minBounty);
301         totalAUM += _rewards;
302 
303         return _rewards;
304     }
305 
306     /// @dev Adds emitting of YbTokenTransfer event to the original function
307     function transfer(address to, uint256 amount) public override returns (bool) {
308         balanceOf[msg.sender] -= amount;
309 
310         // Cannot overflow because the sum of all user
311         // balances can't exceed the max uint256 value.
312         unchecked {
313             balanceOf[to] += amount;
314         }
315 
316         emit Transfer(msg.sender, to, amount);
317         emit YbTokenTransfer(msg.sender, to, amount, convertToAssets(amount));
318         
319         return true;
320     }
321 
322     /// @dev Adds emitting of YbTokenTransfer event to the original function
323     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
324         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
325 
326         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
327 
328         balanceOf[from] -= amount;
329 
330         // Cannot overflow because the sum of all user
331         // balances can't exceed the max uint256 value.
332         unchecked {
333             balanceOf[to] += amount;
334         }
335 
336         emit Transfer(from, to, amount);
337         emit YbTokenTransfer(from, to, amount, convertToAssets(amount));
338 
339         return true;
340     }
341 
342     /********************************** Restricted Functions **********************************/
343 
344     /// @dev Updates the feelessRedeemerWhitelist
345     /// @param _address - The address to update
346     /// @param _whitelist - The new whitelist status
347     function updateFeelessRedeemerWhitelist(address _address, bool _whitelist) external {
348         if (msg.sender != owner) revert Unauthorized();
349 
350         feelessRedeemerWhitelist[_address] = _whitelist;
351     }
352 
353     /// @dev Updates the vault fees
354     /// @param _withdrawFeePercentage - The new withdrawal fee percentage
355     /// @param _platformFeePercentage - The new platform fee percentage
356     /// @param _harvestBountyPercentage - The new harvest fee percentage
357     function updateFees(uint256 _withdrawFeePercentage, uint256 _platformFeePercentage, uint256 _harvestBountyPercentage) external {
358         if (msg.sender != owner) revert Unauthorized();
359         if (_withdrawFeePercentage > MAX_WITHDRAW_FEE) revert InvalidAmount();
360         if (_platformFeePercentage > MAX_PLATFORM_FEE) revert InvalidAmount();
361         if (_harvestBountyPercentage > MAX_HARVEST_BOUNTY) revert InvalidAmount();
362 
363         Fees storage _fees = fees;
364         _fees.withdrawFeePercentage = _withdrawFeePercentage;
365         _fees.platformFeePercentage = _platformFeePercentage;
366         _fees.harvestBountyPercentage = _harvestBountyPercentage;
367 
368         emit UpdateFees(_withdrawFeePercentage, _platformFeePercentage, _harvestBountyPercentage);
369     }
370 
371     /// @dev updates the vault settings
372     /// @param _platform - The Fortress platform address
373     /// @param _swap - The Fortress swap address
374     /// @param _owner - The vault owner address
375     /// @param _depositCap - The deposit cap
376     /// @param _underlyingAssets - The underlying assets
377     function updateSettings(address _platform, address _swap, address _owner, uint256 _depositCap, address[] memory _underlyingAssets) external {
378         if (msg.sender != owner) revert Unauthorized();
379 
380         platform = _platform;
381         swap = _swap;
382         owner = _owner;
383         depositCap = _depositCap;
384         underlyingAssets = _underlyingAssets;
385 
386         emit UpdateInternalUtils();
387     }
388 
389     /// @dev Pauses deposits/withdrawals for the vault
390     /// @param _pauseDeposit - The new deposit status
391     /// @param _pauseWithdraw - The new withdraw status
392     function pauseInteractions(bool _pauseDeposit, bool _pauseWithdraw) external {
393         if (msg.sender != owner) revert Unauthorized();
394 
395         pauseDeposit = _pauseDeposit;
396         pauseWithdraw = _pauseWithdraw;
397         
398         emit PauseInteractions(_pauseDeposit, _pauseWithdraw);
399     }
400 
401     /********************************** Internal Functions **********************************/
402 
403     function _deposit(address _caller, address _receiver, uint256 _assets, uint256 _shares) internal override {
404         if (pauseDeposit) revert DepositPaused();
405         if (_receiver == address(0)) revert ZeroAddress();
406         if (!(_assets > 0)) revert ZeroAmount();
407         if (!(_shares > 0)) revert ZeroAmount();
408 
409         _mint(_receiver, _shares);
410         totalAUM += _assets;
411 
412         emit Deposit(_caller, _receiver, _assets, _shares);
413     }
414 
415     function _withdraw(address _caller, address _receiver, address _owner, uint256 _assets, uint256 _shares) internal override {
416         if (pauseWithdraw) revert WithdrawPaused();
417         if (_receiver == address(0)) revert ZeroAddress();
418         if (_owner == address(0)) revert ZeroAddress();
419         if (!(_shares > 0)) revert ZeroAmount();
420         if (!(_assets > 0)) revert ZeroAmount();
421         
422         if (_caller != _owner) {
423             uint256 _allowed = allowance[_owner][_caller];
424             if (_allowed < _shares) revert InsufficientAllowance();
425             if (_allowed != type(uint256).max) allowance[_owner][_caller] = _allowed - _shares;
426         }
427         
428         _burn(_owner, _shares);
429         totalAUM -= _assets;
430         
431         emit Withdraw(_caller, _receiver, _owner, _assets, _shares);
432     }
433 
434     function _harvest(address _receiver, uint256 _minimumOut) internal virtual returns (uint256) {}
435 
436     function _depositStrategy(uint256 _assets, bool _transfer) internal virtual {
437         if (_transfer) IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
438     }
439 
440     function _withdrawStrategy(uint256 _assets, address _receiver, bool _transfer) internal virtual {
441         if (_transfer) IERC20(address(asset)).safeTransfer(_receiver, _assets);
442     }
443 
444     /********************************** Events **********************************/
445 
446     event Deposit(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);
447     event Withdraw(address indexed _caller, address indexed _receiver, address indexed _owner, uint256 _assets, uint256 _shares);
448     event YbTokenTransfer(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);
449     event Harvest(address indexed _harvester, uint256 _amount);
450     event UpdateFees(uint256 _withdrawFeePercentage, uint256 _platformFeePercentage, uint256 _harvestBountyPercentage);
451     event PauseInteractions(bool _pauseDeposit, bool _pauseWithdraw);
452     event UpdateInternalUtils();
453     
454     /********************************** Errors **********************************/
455 
456     error Unauthorized();
457     error InsufficientBalance();
458     error InsufficientAllowance();
459     error InvalidAmount();
460     error InsufficientDepositCap();
461     error HarvestAlreadyCalled();
462     error ZeroAddress();
463     error ZeroAmount();
464     error InsufficientAmountOut();
465     error DepositPaused();
466     error WithdrawPaused();
467     error NoPendingRewards();
468     error NotUnderlyingAsset();
469 }