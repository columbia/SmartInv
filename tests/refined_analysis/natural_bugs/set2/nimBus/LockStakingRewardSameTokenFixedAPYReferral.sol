pragma solidity =0.8.0;

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ILockStakingRewards {
    function earned(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function stake(uint256 amount) external;
    function stakeFor(uint256 amount, address user) external;
    function getReward() external;
    function withdraw(uint256 nonce) external;
    function withdrawAndGetReward(uint256 nonce) external;
}

interface IBEP20Permit {
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
}

interface INimbusReferralProgramUsers {
    function userIdByAddress(address user) external view returns (uint);
}

contract Ownable {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed from, address indexed to);

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Ownable: Caller is not the owner");
        _;
    }

    function transferOwnership(address transferOwner) external onlyOwner {
        require(transferOwner != newOwner);
        newOwner = transferOwner;
    }

    function acceptOwnership() virtual external {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in construction, 
        // since the code is only stored at the end of the constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

library SafeBEP20 {
    using Address for address;

    function safeTransfer(IBEP20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IBEP20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeBEP20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender) - value;
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function callOptionalReturn(IBEP20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeBEP20: call to non-contract");

        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeBEP20: low-level call failed");

        if (returndata.length > 0) { 
            require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
        }
    }
}

contract LockStakingRewardSameTokenFixedAPYReferral is ILockStakingRewards, ReentrancyGuard, Ownable {
    using SafeBEP20 for IBEP20;

    struct StakeInfo {
        uint rewardRate;
        bool isReferral;
        uint stakeAmount;
        uint stakeAmountRewardEquivalent;
        uint stakeLock;
    }

    struct StakingUserInfo {
        uint weightedStakeDate;
        uint balance;
        uint balanceRewardEquivalent;
    }

    IBEP20 public immutable token;
    IBEP20 public immutable stakingToken; //read only variable for compatibility with other contracts
    uint256 public rewardRate;
    uint256 public referralRewardRate;
    uint256 public withdrawalCashbackRate;
    uint256 public stakingCashbackRate;

    INimbusReferralProgramUsers public referralProgramUsers;

    uint256 public immutable lockDuration; 
    uint256 public constant rewardDuration = 365 days;

    bool public allowAccuralMarketingReward;
    bool public onlyAllowedAddresses;
    mapping(address => bool) allowedAddresses; 

    mapping(address => uint256) public stakeNonces;

    uint256 private _totalSupply;

    mapping(address => mapping(uint => StakeInfo)) public stakeInfo;
    mapping(address => StakingUserInfo) public userStakingInfo;

    event RewardUpdated(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event Rescue(address indexed to, uint amount);
    event RescueToken(address indexed to, address indexed token, uint amount);
    event WithdrawalCashbackSent(address indexed to, uint withdrawnAmount, uint cashbackAmout);
    event StakingCashbackSent(address indexed to, uint stakedAmount, uint cashbackAmout);
    event AccuralMarketingRewardAllowanceUpdated(bool allowance);
    event RewardRateUpdated(uint rate);
    event ReferralRewardRateUpdated(uint rate);
    event StakingCashbackRateUpdated(uint rate);
    event WithdrawalCashbackRateUpdated(uint rate);
    event OnlyAllowedAddressesUpdated(bool allowance);

    constructor(
        address _token,
        address _referralProgramUsers,
        uint _rewardRate,
        uint _referralRewardRate,
        uint _stakingCashbackRate,
        uint _withdrawalCashbackRate,
        uint _lockDuration
    ) {
        require(Address.isContract(_token), "_token is not a contract");
        require(Address.isContract(_referralProgramUsers), "_referralProgramUsers is not a contract");
        require(_rewardRate > 0, "_rewardRate is equal to zero");
        require(_referralRewardRate > 0, "_referralRewardRate is equal to zero");
        require(_lockDuration > 0, "_lockDuration is equal to zero");
        token = IBEP20(_token);
        stakingToken = IBEP20(_token);
        referralProgramUsers = INimbusReferralProgramUsers(_referralProgramUsers);
        rewardRate = _rewardRate;
        referralRewardRate = _referralRewardRate;
        stakingCashbackRate = _stakingCashbackRate;
        withdrawalCashbackRate = _withdrawalCashbackRate;
        lockDuration = _lockDuration;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return userStakingInfo[account].balance;
    }

    function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
        require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake 0");

        if(onlyAllowedAddresses) {
            require(allowedAddresses[msg.sender], "LockStakingRewardMinAmountFixedAPYReferral: Only allowed addresses.");
        }

        // permit
        IBEP20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
        _stake(amount, msg.sender);
    }

    function stake(uint256 amount) external override nonReentrant {
        require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake 0");

        if(onlyAllowedAddresses) {
            require(allowedAddresses[msg.sender], "LockStakingRewardMinAmountFixedAPYReferral: Only allowed addresses.");
        }
        
        _stake(amount, msg.sender);
    }

    function stakeFor(uint256 amount, address user) external override nonReentrant {
        require(amount > 0, "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake 0");
        require(user != address(0), "LockStakingRewardMinAmountFixedAPYReferral: Cannot stake for zero address");

        if(onlyAllowedAddresses) {
            require(allowedAddresses[user], "LockStakingRewardMinAmountFixedAPYReferral: Only allowed addresses.");
        }

        _stake(amount, user);
    }

    function withdrawAndGetReward(uint256 nonce) external override {
        getReward();
        withdraw(nonce);
    }
    
    function earned(address account) public view override returns (uint256) {
        return (userStakingInfo[account].balanceRewardEquivalent * (block.timestamp - userStakingInfo[account].weightedStakeDate) * getRate(account)) / (100 * rewardDuration);
    }

    function getRate(address user) public view returns(uint totalRate) {
        uint totalStakingAmount = balanceOf(user);

        for(uint i = 0; i < stakeNonces[user]; i++) {
            StakeInfo memory userStakeInfo = stakeInfo[user][i];

            if(userStakeInfo.stakeAmount != 0) {
                totalRate += userStakeInfo.rewardRate * (userStakeInfo.stakeAmount / totalStakingAmount);
            }
        }
    }

    //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
    function withdraw(uint256 nonce) public override nonReentrant {
        uint amount = stakeInfo[msg.sender][nonce].stakeAmount;
        require(stakeInfo[msg.sender][nonce].stakeAmount > 0, "LockStakingRewardSameTokenFixedAPYReferral: This stake nonce was withdrawn");
        require(stakeInfo[msg.sender][nonce].stakeLock < block.timestamp, "LockStakingRewardSameTokenFixedAPYReferral: Locked");
        _totalSupply -= amount;
        userStakingInfo[msg.sender].balance -= amount;
        token.safeTransfer(msg.sender, amount);
        _sendWithdrawalCashback(msg.sender, amount);
        stakeInfo[msg.sender][nonce].stakeAmount = 0;
        emit Withdrawn(msg.sender, amount);
    }

    function getReward() public override nonReentrant {
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            userStakingInfo[msg.sender].weightedStakeDate = block.timestamp;
            token.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }
        
    function getUserReferralId(address account) external view returns (uint256) {
        require(address(referralProgramUsers) != address(0), "LockStakingRewardSameTokenFixedAPYReferral: Referral Program was not added.");
        return referralProgramUsers.userIdByAddress(account);
    }

        function updateRewardAmount(uint256 reward) external onlyOwner {
        rewardRate = reward;
        emit RewardUpdated(reward);
    }

    function rescue(address to, address tokenAddress, uint256 amount) external onlyOwner {
        require(to != address(0), "LockStakingRewardSameTokenFixedAPYReferral: Cannot rescue to the zero address");
        require(amount > 0, "LockStakingRewardSameTokenFixedAPYReferral: Cannot rescue 0");
        require(tokenAddress != address(token), "LockStakingRewardSameTokenFixedAPYReferral: Cannot rescue staking/reward token");

        IBEP20(tokenAddress).safeTransfer(to, amount);
        emit RescueToken(to, address(tokenAddress), amount);
    }

    function rescue(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0), "LockStakingRewardSameTokenFixedAPYReferral: Cannot rescue to the zero address");
        require(amount > 0, "LockStakingRewardSameTokenFixedAPYReferral: Cannot rescue 0");

        to.transfer(amount);
        emit Rescue(to, amount);
    }

    function updateOnlyAllowedAddresses(bool allowance) external onlyOwner {
        onlyAllowedAddresses = allowance;
        emit OnlyAllowedAddressesUpdated(onlyAllowedAddresses);
    }

    function updateAccuralMarketingRewardAllowance(bool isAllowed) external onlyOwner {
        allowAccuralMarketingReward = isAllowed;
        emit AccuralMarketingRewardAllowanceUpdated(allowAccuralMarketingReward);
    }

    function updateAllowedAddress(address _address, bool allowance) public onlyOwner {
        require(_address != address(0), "LockStakingRewardSameTokenFixedAPYReferral: allowed address can't be equal to address(0)");
        allowedAddresses[_address] = allowance;
    }

    function updateAllowedAddresses(address[] memory addresses, bool[] memory allowances) external onlyOwner {
        require(addresses.length == allowances.length, "LockStakingRewardSameTokenFixedAPYReferral: Addresses and allowances arrays have different size.");

        for(uint i = 0; i < addresses.length; i++) {
            updateAllowedAddress(addresses[i], allowances[i]);
        }
    }

    function updateRewardRate(uint256 _rewardRate) external onlyOwner {
        require(_rewardRate > 0, "LockStakingRewardSameTokenFixedAPYReferral: Reward rate must be grater than 0");
        rewardRate = _rewardRate;
        emit RewardRateUpdated(rewardRate);
    }
    
    function updateReferralRewardRate(uint256 _referralRewardRate) external onlyOwner {
        require(_referralRewardRate >= rewardRate, "LockStakingRewardSameTokenFixedAPYReferral: Referral reward rate can't be lower than reward rate");
        referralRewardRate = _referralRewardRate;
        emit ReferralRewardRateUpdated(referralRewardRate);
    }
    
    function updateStakingCashbackRate(uint256 _stakingCashbackRate) external onlyOwner {
        //Staking cahsback can be equal to 0
        stakingCashbackRate = _stakingCashbackRate;
        emit StakingCashbackRateUpdated(stakingCashbackRate);
    }
    
    function updateWithdrawalCashbackRate(uint256 _withdrawalCashbackRate) external onlyOwner {
        //Withdrawal cahsback can be equal to 0
        withdrawalCashbackRate = _withdrawalCashbackRate;
        emit WithdrawalCashbackRateUpdated(withdrawalCashbackRate);
    }
    
    function updateReferralProgramUsers(address _referralProgramUsers) external onlyOwner {
        require(_referralProgramUsers != address(0), "LockStakingRewardSameTokenFixedAPYReferral: Referral program users address can't be equal to address(0)");
        referralProgramUsers = INimbusReferralProgramUsers(_referralProgramUsers);
    }

    function _stake(uint256 amount, address user) private {
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        uint id = referralProgramUsers.userIdByAddress(user);
        bool isReferral = id != 0 ? true : false;
        uint stakeLock = block.timestamp + lockDuration;
        uint rate = isReferral ? referralRewardRate : rewardRate;
        _sendStakingCashback(user, amount);

        _totalSupply += amount;
        uint previousAmount = userStakingInfo[user].balance;
        uint newAmount = previousAmount + amount;
        userStakingInfo[user].weightedStakeDate = (userStakingInfo[user].weightedStakeDate * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
        userStakingInfo[user].balance = newAmount;

        uint stakeNonce = stakeNonces[user]++;
        stakeInfo[user][stakeNonce].rewardRate = rate;
        stakeInfo[user][stakeNonce].isReferral = isReferral;
        stakeInfo[user][stakeNonce].stakeAmount = amount;
        stakeInfo[user][stakeNonce].stakeLock = stakeLock;
        
        stakeInfo[user][stakeNonce].stakeAmountRewardEquivalent = amount;
        userStakingInfo[user].balanceRewardEquivalent += amount;
        
        emit Staked(user, amount);
    }

    function _sendWithdrawalCashback(address account, uint _withdrawalAmount) internal {
        if(address(referralProgramUsers) != address(0) && referralProgramUsers.userIdByAddress(account) != 0) {
            uint256 cashbackAmount = (_withdrawalAmount * withdrawalCashbackRate) / 100;
            token.safeTransfer(account, cashbackAmount);
            emit WithdrawalCashbackSent(account, _withdrawalAmount, cashbackAmount);
        }
    }
    
    function _sendStakingCashback(address account, uint _stakingAmount) internal {
        if(address(referralProgramUsers) != address(0) && referralProgramUsers.userIdByAddress(account) != 0) {
            uint256 cashbackAmount = (_stakingAmount * stakingCashbackRate) / 100;
            token.safeTransfer(account, cashbackAmount);
            emit StakingCashbackSent(account, _stakingAmount, cashbackAmount);
        }
    }
}