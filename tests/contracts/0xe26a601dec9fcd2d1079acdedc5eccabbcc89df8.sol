// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: contracts/elmo_staking_v2.sol

//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;




interface IBurn {
    function publicBurn(uint256 amount) external;
}
interface IBalanceOf721 {
    function balanceOf(address owner) external view returns (uint256 balance);
}

contract Staking is Ownable, ReentrancyGuard {
//constant
    uint256 public constant BURN_OPTION_ONE = 25;
    uint256 public constant BURN_OPTION_TWO = 50;
    uint256 public constant BURN_OPTION_THREE = 75;
    uint256 public constant DELAY_WITHDRAW = 14 days;
    uint256 public constant EMERGENCY_FEE = 10;
    uint256 public immutable MAX_DEPOSIT_LIMIT; 
    uint256 public immutable PRECISION_FACTOR;
    uint256 public immutable TOKEN_DECIMALS;
    
// bool
    bool public hasUserLimit;
    bool public isInitialized;
    bool public poolIsOnline;
    bool public depositEnabled = true;
    bool public compoundEnabled = true;
//address
    address public nftContractAddress;
// uint
    uint256 public totalUsersInStaking;
    uint256 public poolTotalReward;
    uint256 public accTokenPerShare;
    uint256 public startBlock;
    uint256 public lastRewardBlock;
    uint256 public rewardPerBlock;
    uint256 public totalBurned;
    uint256 public totalUsersStake;
    uint256 public totalUsersRewards;
    uint256 public nftBoostPercentage;
    
// staking tokens
    IERC20Metadata public rewardToken;

// mapping
    mapping(address => UserInfo) public userInfo;
    mapping(uint => uint) public optionToBurn; //0=None 1=25% 2=50% 3=75%
// struct
    struct UserInfo {
        uint256 amount; // How many staked tokens the user has provided
        uint256 rewardDebt; // Reward debt
        uint256 withdrawInitTime; // // init the cooldown timer to withdraw, save block.timestamp
        uint256 burnChosen; // burn option  
        uint256 amountToWithdraw; // amount to withdraw
    }

// event
    event Deposit(address indexed user, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event PoolFunded(uint256 amount);
    event Compound(address indexed user, uint256 amount);
    event ClaimReward(address indexed user, uint256 amount);
    event UserCompoundUpdated(address indexed user, bool onDeposit, bool onWithdraw);
    event WithdrawInitiated(address indexed user, uint256 amount, uint256 burnedAmount);
    event PoolStateUpdated(bool poolIsOnline, bool depositEnabled, bool compoundEnabled);
    event NftBoostUpdated(uint256 percentage);
    event TokenRecovered(address indexed tokenAddress, uint256 tokenAmount);
    event BlockRewardUpdated(uint256 rewardPerBlock);
    event PoolStarted(uint256 startBlock, uint256 rewardPerBlock);

//constructor
    /// @notice Contract constructor that initializes the Smart Contract.
    /// @param _rewardToken The address of the ERC20 token used as a reward.
    /// @param _nftContractAddress The address of the NFT contract used as reward boost.
    constructor(IERC20Metadata _rewardToken, address _nftContractAddress) {
        rewardToken = _rewardToken;
        TOKEN_DECIMALS = uint256(rewardToken.decimals());
        require(TOKEN_DECIMALS < 30, "Must be inferior to 30");
        MAX_DEPOSIT_LIMIT= 2000000*10**TOKEN_DECIMALS;
        PRECISION_FACTOR = uint256(10**(uint256(30) - TOKEN_DECIMALS));
        optionToBurn[1] = BURN_OPTION_ONE;
        optionToBurn[2] = BURN_OPTION_TWO;
        optionToBurn[3] = BURN_OPTION_THREE;
        nftContractAddress = _nftContractAddress;
    }

//owner function
    /// @notice Allows the contract owner to set the state of the pool.
    /// @param _poolIsOnline Enable or disable the pool.
    /// @param _depositEnabled Enable or disable user deposits.
    /// @param _compoundEnabled Enable or disable user compound functionality.
    function setPoolState(bool _poolIsOnline, bool _depositEnabled, bool _compoundEnabled) external onlyOwner {
        poolIsOnline = _poolIsOnline;
        depositEnabled = _depositEnabled;
        compoundEnabled = _compoundEnabled; 
        emit PoolStateUpdated(_poolIsOnline, _depositEnabled, _compoundEnabled);
    }

    /// @notice Allows the contract owner to set the NFT boost percentage.
    /// @param _percentage The new NFT boost percentage to be set.
    function setNftBoostPercentage(uint256 _percentage) external onlyOwner {
        nftBoostPercentage = _percentage;
        emit NftBoostUpdated(_percentage);
    }

    /// @notice Allows the contract owner to recover wrongly sent tokens to the contract.
    /// @param _tokenAddress The address of the token to be recovered.
    /// @param _tokenAmount The amount of tokens to be recovered.
    function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner { //@msg NOT Withdraw any tokens from the contract
        require(_tokenAddress != address(rewardToken), "Cannot be staked or reward tokens");
        IERC20Metadata(_tokenAddress).transfer(address(msg.sender), _tokenAmount);
        emit TokenRecovered(_tokenAddress, _tokenAmount);
    }

    /// @notice Allows the contract owner to update the reward rate per block.
    /// @param _rewardPerBlock The new token amount per block to be set.
    function updateRewardPerBlock(uint256 _rewardPerBlock) external onlyOwner { //@msg Update APY
        require(_rewardPerBlock > 0, "Reward per block should be greater than 0");
        rewardPerBlock = _rewardPerBlock;
        emit BlockRewardUpdated(_rewardPerBlock);
    }

    /// @notice Initializes the staking pool with the provided reward rate per block.
    /// @param _rewardPerBlock The reward rate per block to be set for the staking pool.
    function istart(uint256 _rewardPerBlock) external onlyOwner {
        require(!isInitialized, "Already initialized");
        isInitialized = true;
        rewardPerBlock = _rewardPerBlock;
        startBlock = block.number;
        poolIsOnline = true;
        lastRewardBlock = startBlock;
        emit PoolStarted(startBlock, _rewardPerBlock);
    }

//modifier
    /// @notice Modifier to check if the staking pool is online and available for certain actions.
    /// @param actionType The type of action: 0 for deposit, 1 for compound.
    modifier isPoolOnline(uint8 actionType) {
        require(poolIsOnline || msg.sender == owner(),"staking platform not available now.");
        if (actionType == 0) {
            require(depositEnabled || msg.sender == owner(),"deposits not available now.");
        }
        else if (actionType == 1) {
            require(compoundEnabled || msg.sender == owner(),"compounds not available now.");
        } 
        _;
    }


// user functions
    /// @notice Allows users to top up the staking pool with additional reward tokens.
    /// @param amount The amount of reward tokens to be added to the pool.
    function fundPool(uint256 amount) external {
        poolTotalReward += amount;
        rewardToken.transferFrom(address(msg.sender), address(this), amount);
        emit PoolFunded(amount);
    }

    /// @notice Allows users to deposit tokens into the staking pool.
    /// @param _amount The amount of reward tokens to be deposited into the staking pool.
    /// @param _burnOption The chosen burn option (1-25%, 2-50%, 3-75%) for the user's rewards.
    function deposit(uint256 _amount, uint256 _burnOption) external isPoolOnline(0) nonReentrant {
        require(_burnOption == 1 || _burnOption == 2 || _burnOption == 3, "invalid burn option");
        require(userInfo[msg.sender].withdrawInitTime < block.timestamp, "cooldown not passed");
        UserInfo storage user = userInfo[msg.sender];
        uint userAmountBefore = user.amount;
        require(_amount + userAmountBefore <= MAX_DEPOSIT_LIMIT, "User amount above limit");
        if (_amount != 0) {
            user.amount = userAmountBefore + _amount;
            totalUsersStake += _amount;
            rewardToken.transferFrom(address(msg.sender), address(this), _amount);
        }else{
            revert("can't deposit 0 tokens");
        }
        if (userAmountBefore == 0) {
            totalUsersInStaking += 1;
            user.burnChosen = _burnOption;
        }

        _updatePool();

        user.rewardDebt = user.amount * accTokenPerShare / PRECISION_FACTOR;

        emit Deposit(msg.sender, _amount);
    }

    /// @notice Initiates the withdrawal process for the staked reward tokens.
    function initWithdraw() external nonReentrant {// unstack init
        UserInfo storage user = userInfo[msg.sender];
        uint userAmnt = user.amount;
        require(userAmnt != 0, "No amount stacked");
        require(user.amountToWithdraw == 0, "Withdraw already initiated");
        _updatePool();
        uint burnAmnout;
        uint256 pending =_internalPendingCalc(userAmnt, accTokenPerShare, user.rewardDebt); 
        if (pending != 0) {
            totalUsersRewards += pending;
            poolTotalReward -= pending;
            burnAmnout = pending * optionToBurn[user.burnChosen] / 100;
            totalBurned += burnAmnout;
            user.amountToWithdraw = userAmnt + (pending - burnAmnout);
            IBurn(address(rewardToken)).publicBurn(burnAmnout);
            emit ClaimReward(msg.sender,pending - burnAmnout);
        }else{
            user.amountToWithdraw = userAmnt;
        }
        totalUsersInStaking -= 1;
        totalUsersStake -= userAmnt;
        user.withdrawInitTime = block.timestamp;
        user.rewardDebt = userAmnt * accTokenPerShare / PRECISION_FACTOR;
        emit WithdrawInitiated(msg.sender, userAmnt + (pending - burnAmnout), burnAmnout);
    }

    /// @notice Allows users to withdraw their pending rewards from the staking pool.
    function withdrawReward() external nonReentrant{ 
        UserInfo storage user = userInfo[msg.sender];
        require(user.amountToWithdraw == 0, "Cant have rewards if withdraw initiated");
        uint userAmnt = user.amount;
        require(userAmnt != 0, "0 stacked");
        _updatePool();

        uint256 pending = _internalPendingCalc(userAmnt, accTokenPerShare, user.rewardDebt); 
        if (pending > 0) {
            totalUsersRewards += pending;
            poolTotalReward -= pending;
            uint burnAmnout = pending * optionToBurn[user.burnChosen] / 100;
            totalBurned += burnAmnout;
            IBurn(address(rewardToken)).publicBurn(burnAmnout);
            rewardToken.transfer(address(msg.sender), pending-burnAmnout);
            emit ClaimReward(msg.sender,pending - burnAmnout);
        }
        user.rewardDebt = userAmnt * accTokenPerShare / PRECISION_FACTOR;
    }

    /// @notice Allows users to withdraw their staked reward tokens after the lock time has passed.
    function withdraw() external nonReentrant {// unstack
        UserInfo storage user = userInfo[msg.sender];
        uint256 amountToWithdraw = user.amountToWithdraw;
        require(amountToWithdraw != 0, "No amount to withdraw");
        require(user.withdrawInitTime + DELAY_WITHDRAW <= block.timestamp, "Minimum lock time not reached");
        
        delete userInfo[msg.sender];
        rewardToken.transfer(address(msg.sender), amountToWithdraw);
        
        emit Withdraw(msg.sender, amountToWithdraw);
    }


    /// @notice Allows users to compound their pending rewards by adding them to their staked amount.
    function compound() external isPoolOnline(1) nonReentrant {
        UserInfo storage user = userInfo[msg.sender];
        uint userAmnt = user.amount;
        require(userAmnt != 0, "No amount stacked");
        require(user.amountToWithdraw == 0, "Cant compound if withdraw initiated");
        if(userAmnt != 0) {
            _updatePool();
            uint pending = _internalPendingCalc(userAmnt, accTokenPerShare, user.rewardDebt);
            if(pending != 0) {
                totalUsersRewards += pending;
                poolTotalReward -= pending;
                uint burnAmnout = pending * optionToBurn[user.burnChosen] / 100;
                uint effectivePending = pending - burnAmnout;
                totalBurned += burnAmnout;
                totalUsersStake += effectivePending;
                user.amount = user.amount + effectivePending;
                user.rewardDebt = user.amount * accTokenPerShare / PRECISION_FACTOR;
                IBurn(address(rewardToken)).publicBurn(burnAmnout);
                emit Compound(msg.sender, effectivePending);
            }
        } else {
            revert("nothing to compound");
        }
    }

    // @notice Allows users to perform an emergency withdrawal from the staking pool.
    function emergencyWithdraw() external nonReentrant {
        UserInfo storage user = userInfo[msg.sender];
        uint256 amountToWithdraw = user.amount;
        require(amountToWithdraw != 0, "No amount to withdraw");
        totalUsersStake -= amountToWithdraw;
        uint256 feePart = (amountToWithdraw * EMERGENCY_FEE / 100);
        amountToWithdraw = amountToWithdraw - feePart; //fee back to pool
        poolTotalReward += feePart;
        totalUsersInStaking -= 1;
        delete userInfo[msg.sender];
        rewardToken.transfer(address(msg.sender), amountToWithdraw);
        emit EmergencyWithdraw(msg.sender, amountToWithdraw);
    }



    /// @notice Calculates the pending rewards for a user's staked amount, considering the NFT boost.
    /// @param amnt The user's staked amount for which the pending rewards are calculated.
    /// @param accTokenShare The accumulated token share in the staking pool at the time of calculation.
    /// @param debt The user's reward debt at the time of calculation.
    /// @return pending The calculated pending rewards for the user's staked amount, considering the NFT boost.
    function _internalPendingCalc(uint amnt, uint accTokenShare, uint debt) internal view returns(uint256 pending) { 
        pending = amnt * accTokenShare / PRECISION_FACTOR - debt;
        uint hasNft = IBalanceOf721(nftContractAddress).balanceOf(msg.sender); 
        if(hasNft != 0) {
            pending = pending+(pending * nftBoostPercentage / 100);
        }
        return pending;
    }


    /// @notice Calculates the pending and effective pending rewards for a specific user, considering the NFT boost(if applicable).
    /// @param _user The address of the user for whom the rewards are to be calculated.
    /// @return pending The total pending rewards for the user's staked amount, including the NFT boost if applicable.
    /// @return effectivePending The effective pending rewards after considering the burn option (if any) and NFT boost (if applicable).
    function pendingReward(address _user) external view returns (uint256 pending, uint256 effectivePending) {
        UserInfo storage user = userInfo[_user];
        if(user.amountToWithdraw != 0){
            pending = 0;
            effectivePending = user.amountToWithdraw;
        } else {
            if (block.number > lastRewardBlock && totalUsersStake != 0) {
                uint256 multiplier = block.number - lastRewardBlock;
                uint256 cakeReward = multiplier * rewardPerBlock;
                uint256 adjustedTokenPerShare = accTokenPerShare + (cakeReward * PRECISION_FACTOR / totalUsersStake);
                pending = user.amount * adjustedTokenPerShare / PRECISION_FACTOR - user.rewardDebt;

            } else {
                pending = user.amount * accTokenPerShare / PRECISION_FACTOR - user.rewardDebt;
            }
            uint hasNft = IBalanceOf721(nftContractAddress).balanceOf(_user); 
            if(hasNft != 0) {
                pending = pending + (pending * nftBoostPercentage / 100);
            }
            uint burnAmnout = pending * optionToBurn[user.burnChosen] / 100;
            effectivePending = pending - burnAmnout;
        }
    }

    /// @notice Updates the staking pool by calculating and accumulating the reward tokens (cakeReward) per share of staked tokens.
    function _updatePool() internal {
        if (block.number <= lastRewardBlock) {
            return;
        }
        uint256 stakedTokenSupply = totalUsersStake;
        if (stakedTokenSupply == 0) {
            lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = block.number - lastRewardBlock;
        uint256 cakeReward = multiplier * rewardPerBlock;
        accTokenPerShare = accTokenPerShare + (cakeReward * PRECISION_FACTOR / stakedTokenSupply);
        lastRewardBlock = block.number;
    }

    /// @notice Get the available balance of the staking pool.
    /// @return calc The available balance of the staking pool (total reward tokens available for distribution).
    function getPoolEffectiveBalance() external view returns(uint256 calc){
        calc = rewardToken.balanceOf(address(this)) - totalUsersStake;
        return calc;
    }

    /// @notice Calculate the Annual Percentage Yield (APY) for the staking pool.
    /// @return calculatedApr The calculated Annual Percentage Yield (APY) for the staking pool.
    function calculateAPR() external view returns (uint256 calculatedApr, uint256 aprWithNft) {
        uint blockPerYear = (86400/12)*365; 
        if (totalUsersStake == 0 || poolTotalReward == 0) {
            calculatedApr = 0;
            aprWithNft = 0;
        }else{
            calculatedApr = (rewardPerBlock * blockPerYear) / totalUsersStake;
            uint blockBoosted = rewardPerBlock + (rewardPerBlock * nftBoostPercentage / 100);
            aprWithNft = (blockBoosted * blockPerYear) / totalUsersStake;
        }
        
    }

}