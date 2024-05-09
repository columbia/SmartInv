/**
 * This is the smart contract that manages the Revenue Sharing for the Prodigy Bot.
 *
 * https://prodigybot.io/
 * https://t.me/ProdigySniper/
 * https://t.me/ProdigySniperBot/
 * https://twitter.com/Prodigy__Sniper
 */

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

abstract contract Auth {
	address private owner;
	mapping (address => bool) private authorizations;

	constructor(address _owner) {
		owner = _owner;
		authorizations[_owner] = true;
	}

	/**
	* @dev Function modifier to require caller to be contract owner
	*/
	modifier onlyOwner() {
		require(isOwner(msg.sender), "!OWNER"); _;
	}

	/**
	* @dev Function modifier to require caller to be authorized
	*/
	modifier authorized() {
		require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
	}

	/**
	* @dev Authorize address. Owner only
	*/
	function authorize(address adr) public onlyOwner {
		authorizations[adr] = true;
	}

	/**
	* @dev Remove address' authorization. Owner only
	*/
	function unauthorize(address adr) public onlyOwner {
		authorizations[adr] = false;
	}

	/**
	* @dev Check if address is owner
	*/
	function isOwner(address account) public view returns (bool) {
		return account == owner;
	}

	/**
	* @dev Return address' authorization status
	*/
	function isAuthorized(address adr) public view returns (bool) {
		return authorizations[adr];
	}

	/**
	* @dev Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
	*/
	function transferOwnership(address payable adr) public onlyOwner {
		owner = adr;
		authorizations[adr] = true;
		emit OwnershipTransferred(adr);
	}

	event OwnershipTransferred(address owner);
}

interface IERC20 {
	function transfer(address recipient, uint256 amount) external returns (bool);
	function balanceOf(address account) external view returns (uint256);
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

interface IRouter {
	function WETH() external pure returns (address);
	function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
}

contract ProdigyRevenueShare is Auth {

	/**
	 * @notice The entire Prodigy token supply fits in an uint80.
	 * The entire supply of Ethereum fits in uint88.
	 * We are using this to keep track of claimed ether and unclaimable ether for a specific account.
	 * If we were to reach such a number, we'd need a new contract, but that'd be a very nice problem to have.
	 * If you fork this: Keep in mind token supplies may need different uints.
	 */
	struct Stake {
		uint80 amount;
		uint88 totalClaimed;
		uint88 totalExcluded;
	}

	address public immutable prodigyToken;
	uint256 private _rewardsPerToken;
	uint256 private constant _accuracyFactor = 1e36;
	uint256 private _minStake = 20 ether;
	uint256 private _minPayout = 0.1 ether;

	bool public open;
	uint80 private _totalStaked;
	uint88 private _revenueShareEther;
	uint16 private _sharedRevenue = 4;
	uint16 private _revenueDenominator = 10;

	address public devFeeReceiver;
	uint96 private _devOwedEther;

	address private _router;
	uint96 private _revenueSharePaid;

	bool public migrating;
	uint32 public migrationStarts;
	uint32 public constant migrationLockTime = 7 days;
	address public migratingTo;

	mapping (address => Stake) private _stakes;

	event Realised(address account, uint256 amount);
	event Staked(address account, uint256 amount);
	event Unstaked(address account, uint256 amount);
	event Compounded(address account, uint256 amount, uint256 tokenAmount);

	error ZeroAmount();
	error InsufficientStake();
	error StakingTokenRescue();
	error CouldNotSendEther();
	error ClaimTooSmall();
	error AlreadyStaked();
	error NotAvailable();
	error CannotMigrate();
	error FinaliseTooEarly();

	modifier isOpen {
		if (!open) {
			revert NotAvailable();
		}
		_;
	}

	constructor(address token, address router) Auth(msg.sender) {
		prodigyToken = token;
		_router = router;
	}

	/**
	 * @dev Bot trading fees and token fees are sent here.
	 * A part is sent to developer wallet to cover for the costs of running the trading suite:
	 * Cloud servers, RPCs, Nodes, full-time development and support.
	 * The rest is shared amongst token holders who stake their position in the contract.
	 * You may link your staking account to your bot account, enjoying the benefits of holding and revenue share.
	 */
	receive() external payable {
		if (msg.value == 0) {
			revert ZeroAmount();
		}

		// If no positions present, everything is sent to dev.
		uint256 stakedTokens = _totalStaked;
		if (stakedTokens == 0) {
			_manageDevShare(msg.value);
			return;
		}

		// Calculate part for revenue share and part for development.
		uint256 toShare = msg.value * _sharedRevenue / _revenueDenominator;
		uint256 toDev = msg.value - toShare;
		_manageDevShare(toDev);
		unchecked {
			// If this overflow we are all rich.
			_revenueShareEther += uint88(toShare);
			// Update total rewards per token staked.
			uint256 newRewards = _accuracyFactor * toShare / stakedTokens;
			_rewardsPerToken += newRewards;
		}
	}

	function _manageDevShare(uint256 share) private {
		if (_sendEther(devFeeReceiver, share + _devOwedEther)) {
			_devOwedEther = 0;
		} else {
			unchecked {
				_devOwedEther += uint96(share);
			}
		}
	}

	function _sendEther(address receiver, uint256 amount) private returns (bool success) {
		(success,) = receiver.call{value: amount}("");
	}

	function viewPosition(address account) external view returns (Stake memory) {
		return _stakes[account];
	}

	function accountStakedTokens(address account) external view returns (uint256) {
		return _stakes[account].amount;
	}

	function accountsSumStakedTokens(address[] calldata accounts) external view returns (uint256 tokens) {
		for (uint256 i = 0; i < accounts.length; ++i) {
			tokens += _stakes[accounts[i]].amount;
		}
	}

	function getPendingClaim(address account) external view returns (uint256) {
		return _earnt(_stakes[account], false);
	}

	/**
	 * @notice The operation must be done in uint256 before converting to uint88 for decimal precision.
	 */
	function _getCumulativeRewards(uint256 amount, bool roundUp) private view returns (uint88) {
		uint256 accurate = _rewardsPerToken * amount;
		if (roundUp) {
			unchecked {
				accurate += _accuracyFactor / 10;
			}
		}
		return uint88(accurate / _accuracyFactor);
	}

	/**
	 * @dev Add a position for revenue share for the first time.
	 * @notice For adding to a position, call the `restake` method.
	 */
	function stake(uint256 amount) external isOpen {
		if (amount == 0) {
			revert ZeroAmount();
		}
		_firstStake(msg.sender, uint80(amount));
		IERC20(prodigyToken).transferFrom(msg.sender, address(this), amount);
	}

	/**
	 * @dev Add to an existing stake plus compounding pending revenue.
	 * @notice Must calculate slippage from UI for expectedTokens!
	 */
	function restake(uint256 amount, uint256 expectedTokens) external isOpen {
		if (amount == 0) {
			revert ZeroAmount();
		}
		_stake(msg.sender, uint80(amount), expectedTokens);
		IERC20(prodigyToken).transferFrom(msg.sender, address(this), amount);
	}

	/**
	 * @dev Add a stake for someone else.
	 * @notice Only available for a first time stake, since re-stake triggers compounding.
	 */
	function stakeFor(address account, uint256 amount) external isOpen {
		if (amount == 0) {
			revert ZeroAmount();
		}

		_firstStake(account, uint80(amount));
		IERC20(prodigyToken).transferFrom(msg.sender, address(this), amount);
	}

	/**
	 * @dev To be used for the first time a stake is done.
	 */
	function _firstStake(address account, uint80 amount) private {
		if (amount < _minStake) {
			revert InsufficientStake();
		}
		Stake storage position = _stakes[account];
		if (position.amount > 0) {
			revert AlreadyStaked();
		}
		position.amount = amount;
		position.totalExcluded = _getCumulativeRewards(position.amount, true);
		unchecked {
			_totalStaked += amount;
		}

		emit Staked(account, amount);
	}

	/**
	 * @dev Add to an existing position.
	 */
	function _stake(address account, uint80 amount, uint256 expectedTokens) private {
		Stake storage position = _stakes[account];
		_compound(account, position, expectedTokens);

		unchecked {
			position.amount += amount;
			position.totalExcluded = _getCumulativeRewards(position.amount, true);
			_totalStaked += amount;
		}

		emit Staked(account, amount);
	}

	function unstake(uint256 amount) external {
		if (amount == 0) {
			revert ZeroAmount();
		}

		_unstake(msg.sender, uint80(amount));
	}

	function _unstake(address account, uint80 amount) private {
		Stake storage position = _stakes[account];
		// Revert if amount over actual position or it would lead a position to be under the minimum.
		if (position.amount < amount || (amount < position.amount && position.amount - amount < _minStake)) {
			revert InsufficientStake();
		}

		// Forfeit remainder of revenue.
		_forfeit(position);

		// Remove the stake amount.
		unchecked {
			position.amount -= amount;
			_totalStaked -= amount;
		}
		position.totalExcluded = _getCumulativeRewards(position.amount, true);
		IERC20(prodigyToken).transfer(account, amount);

		emit Unstaked(account, amount);
	}

	/**
	 * @dev Claim your pending share of the revenue.
	 * @notice There's a set minimum revenue one can claim.
	 */
	function claim() external isOpen {
		uint256 realised = _realise(msg.sender, _stakes[msg.sender]);
		if (realised < _minPayout) {
			revert ClaimTooSmall();
		}
	}

	/**
	 * @dev Use your pending revenue to buy the token tax free and increase your ownership on the revenue share.
	 * @notice Slippage should be checked fron the UI and send the expected tokens to acquire by selling the rewards.
	 */
	function compound(uint256 expectedTokens) external isOpen {
		address account = msg.sender;
		Stake storage position = _stakes[account];
		if (position.amount == 0) {
			revert ZeroAmount();
		}

		_compound(account, position, expectedTokens);
	}

	function _compound(address account, Stake storage position, uint256 expectedTokens) private {
		uint88 amount = uint88(_earnt(position, false));
		if (amount == 0) {
			return;
		}

		// Mark ether used for compound as claimed.
		unchecked {
			position.totalClaimed += amount;
			_revenueSharePaid += amount;
		}

		// Buy the tokens to add to stake.
		uint256 tokensBefore = IERC20(prodigyToken).balanceOf(address(this));
		IRouter router = IRouter(_router);
		address[] memory buyPath = new address[](2);
		buyPath[0] = router.WETH();
		buyPath[1] = prodigyToken;
		router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(expectedTokens, buyPath, address(this), block.timestamp);
		uint80 tokensAfter = uint80(IERC20(prodigyToken).balanceOf(address(this)) - tokensBefore);

		// Update stake and its exclusion value.
		unchecked {
			position.amount += tokensAfter;
			_totalStaked += tokensAfter;
		}
		position.totalExcluded = _getCumulativeRewards(position.amount, true);

		emit Compounded(account, amount, tokensAfter);
	}

	function _forfeit(Stake storage position) private {
		uint256 amount = _earnt(position, false);
		if (amount > 0) {
			_manageDevShare(amount);
		}
	}

	function _realise(address account, Stake storage position) private returns (uint256) {
		// Calculate accrued unclaimed reward.
		uint88 amount = uint88(_earnt(position, false));
		if (amount == 0) {
			return 0;
		}
		uint88 exclude = uint88(_earnt(position, true));
		unchecked {
			position.totalClaimed += amount;
			position.totalExcluded += exclude;
			_revenueSharePaid += amount;
		}

		if (!_sendEther(account, amount)) {
			revert CouldNotSendEther();
		}

		emit Realised(account, amount);

		return amount;
	}

	function _earnt(Stake storage position, bool round) private view returns (uint256) {
		uint256 accountTotalRewards = _getCumulativeRewards(position.amount, round);
		uint256 accountTotalExcluded = position.totalExcluded;
		if (accountTotalRewards <= accountTotalExcluded) {
			return 0;
		}

		return accountTotalRewards - accountTotalExcluded;
	}

	/**
	 * @dev Rescue wrongly sent ERC20 tokens.
	 * @notice The staking token may never be taken out unless it's through unstaking.
	 */
	function rescueToken(address token) external authorized {
		if (token == prodigyToken) {
			revert StakingTokenRescue();
		}
		IERC20 t = IERC20(token);
		t.transfer(msg.sender, t.balanceOf(address(this)));
	}

	/**
	 * @dev Recover any non staked PRO tokens sent directly to contract.
	 */
	function rescueNonStakingProdigy() external authorized {
		IERC20 pro = IERC20(prodigyToken);
		uint256 available = pro.balanceOf(address(this)) - _totalStaked;
		if (available == 0) {
			revert ZeroAmount();
		}
		pro.transfer(msg.sender, available);
	}

	/**
	 * @dev Get currently configured distribution of revenue.
	 */
	function getRevenueShareSettings() external view returns (uint16 devRevenue, uint16 sharedRevenue, uint16 denominator) {
		sharedRevenue = _sharedRevenue;
		devRevenue = _revenueDenominator - sharedRevenue;
		denominator = _revenueDenominator;
	}

	/**
	 * @dev Total ether already claimed by participants of revenue share.
	 */
	function totalRevenueClaimed() external view returns (uint256) {
		return _revenueSharePaid;
	}

	/**
	 * @dev Total amount of revenue share ether both claimed and to be claimed.
	 */
	function getTotalRevenue() external view returns (uint256) {
		return _revenueShareEther;
	}

	/**
	 * @dev Ether destined for development costs that hasn't been sent yet.
	 */
	function pendingDevEther() external view returns (uint256) {
		return _devOwedEther;
	}

	/**
	 * @dev Total amount of tokens participating in revenue share.
	 */
	function totalPosition() external view returns (uint256) {
		return _totalStaked;
	}

	function setRevenueShareConfig(uint16 shared, uint16 denominator) external authorized {
		// Denominator can never be zero or it would cause reverts.
		if (denominator == 0) {
			revert ZeroAmount();
		}
		_sharedRevenue = shared;
		_revenueDenominator = denominator;
	}

	function setDevReceiver(address dev) external authorized {
		devFeeReceiver = dev;
	}

	function setMinStake(uint256 min) external authorized {
		_minStake = min;
	}

	function setMinPayout(uint32 min) external authorized {
		_minPayout = min;
	}

	function setRouter(address r) external authorized {
		_router = r;
	}

	function setIsOpen(bool isIt) external authorized {
		open = isIt;
	}

	/**
	 * @dev Two-step migration that gives a week lock before assets can be transferred to a new contract.
	 */
	function startTwoStepMigration(address migrateTo) external authorized {
		if (migrating || migrateTo == address(0)) {
			revert CannotMigrate();
		}
		open = false;
		migrating = true;
		migrationStarts = uint32(block.timestamp + migrationLockTime);
		migratingTo = migrateTo;
	}

	function finaliseTwoStepMigration() external authorized {
		address receiver = migratingTo;
		if (!migrating || receiver == address(0)) {
			revert CannotMigrate();
		}
		if (block.timestamp < migrationStarts) {
			revert FinaliseTooEarly();
		}
		
		migratingTo = address(0);
		migrating = false;
		migrationStarts = 0;

		IERC20 token = IERC20(prodigyToken);
		token.transfer(receiver, token.balanceOf(address(this)));

		if (!_sendEther(receiver, address(this).balance)) {
			revert CouldNotSendEther();
		}
	}

	function cancelMigration() external authorized {
		migrating = false;
		migrationStarts = 0;
		migratingTo = address(0);
	}

	function getMinStake() external view returns (uint256) {
		return _minStake;
	}

	function getMinPayout() external view returns (uint256) {
		return _minPayout;
	}
}