pragma solidity =0.8.0;

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function getOwner() external view returns (address);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
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

    function getOwner() external view returns (address) {
        return owner;
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

interface INimbusStakingPool {
    function balanceOf(address account) external view returns (uint256);
    function stakingToken() external view returns (IBEP20);
}

interface INimbusReferralProgram {
    function userSponsorByAddress(address user) external view returns (uint);
    function userIdByAddress(address user) external view returns (uint);
}

interface INimbusRouter {
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
}

contract NBUInfluencerBonusPart is Ownable {
    IBEP20 public immutable NBU;
    
    uint public nbuBonusAmount;
    INimbusReferralProgram public immutable referralProgram;
    INimbusStakingPool[] public stakingPools;
    
    INimbusRouter public swapRouter;                
    address public swapToken;                       
    uint public swapTokenAmountForBonusThreshold;  
    
    mapping (address => bool) public influencers;
    mapping (address => mapping (address => bool)) public processedUsers;

    event ProcessInfluencerBonus(address indexed influencer, address indexed user, uint userAmount, uint influencerBonus);
    event Rescue(address indexed to, uint amount);
    event RescueToken(address indexed token, address indexed to, uint amount); 

    constructor(address nbu, address router, address referral) {
        NBU = IBEP20(nbu);
        swapRouter = INimbusRouter(router);
        referralProgram = INimbusReferralProgram(referral);
        nbuBonusAmount = 5 * 1e18;
    }

    function claimBonus(address[] memory users) external {
        for (uint i; i < users.length; i++) {
            claimBonus(users[i]);
        }
    }

    function claimBonus(address user) public {
        require(influencers[msg.sender], "NBUInfluencerBonusPart: Not influencer");
        require(!processedUsers[msg.sender][user], "NBUInfluencerBonusPart: Bonus for user already received");
        uint userSponsor = referralProgram.userSponsorByAddress(user);
        require(userSponsor == referralProgram.userIdByAddress(msg.sender) && userSponsor != 0, "NBUInfluencerBonusPart: Not user sponsor");
        uint amount;
        for (uint i; i < stakingPools.length; i++) {
            amount += stakingPools[i].balanceOf(user);
        }

        address[] memory path = new address[](2);
        path[0] = swapToken;
        path[1] = address(NBU);
        uint minNbuAmountForBonus = swapRouter.getAmountsOut(swapTokenAmountForBonusThreshold, path)[1];
        require (amount >= minNbuAmountForBonus, "NBUInfluencerBonusPart: Bonus threshold not met");
        require(NBU.transfer(msg.sender, nbuBonusAmount), "NBUInfluencerBonusPart: Error while transfer");
        processedUsers[msg.sender][user] = true;
        emit ProcessInfluencerBonus(msg.sender, user, amount, nbuBonusAmount);
    }

    function isBonusForUserAllowed(address influencer, address user) external view returns (bool) {
        if (!influencers[influencer]) return false;
        if (processedUsers[influencer][user]) return false;
        if (referralProgram.userSponsorByAddress(user) != referralProgram.userIdByAddress(influencer)) return false;
        uint amount;
        for (uint i; i < stakingPools.length; i++) {
            amount += stakingPools[i].balanceOf(user);
        }

        address[] memory path = new address[](2);
        path[0] = swapToken;
        path[1] = address(NBU);
        uint minNbuAmountForBonus = swapRouter.getAmountsOut(swapTokenAmountForBonusThreshold, path)[1];
        return amount >= minNbuAmountForBonus;
    }



    function rescue(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0), "NBUInfluencerBonusPart: Address is zero");
        require(amount > 0, "NBUInfluencerBonusPart: Should be greater than 0");
        TransferHelper.safeTransferBNB(to, amount);
        emit Rescue(to, amount);
    }

    function rescue(address to, address token, uint256 amount) external onlyOwner {
        require(to != address(0), "NBUInfluencerBonusPart: Address is zero");
        require(amount > 0, "NBUInfluencerBonusPart: Should be greater than 0");
        TransferHelper.safeTransfer(token, to, amount);
        emit RescueToken(token, to, amount);
    }

    function updateSwapRouter(address newSwapRouter) external onlyOwner {
        require(newSwapRouter != address(0), "NBUInfluencerBonusPart: Address is zero");
        swapRouter = INimbusRouter(newSwapRouter);
    }
    
    function updateStakingPoolAdd(address newStakingPool) external onlyOwner {
        INimbusStakingPool pool = INimbusStakingPool(newStakingPool);
        require (pool.stakingToken() == NBU, "NBUInfluencerBonusPart: Wrong pool staking tokens");

        for (uint i; i < stakingPools.length; i++) {
            require (address(stakingPools[i]) != newStakingPool, "NBUInfluencerBonusPart: Pool exists");
        }
        stakingPools.push(pool);
    }

    function updateStakingPoolRemove(uint poolIndex) external onlyOwner {
        stakingPools[poolIndex] = stakingPools[stakingPools.length - 1];
        stakingPools.pop();
    }

    function updateInfluencer(address influencer, bool isActive) external onlyOwner {
        influencers[influencer] = isActive;
    }

    function updateNbuBonusAmount(uint newAmount) external onlyOwner {
        nbuBonusAmount = newAmount;
    }

    function updateSwapToken(address newSwapToken) external onlyOwner {
        require(newSwapToken != address(0), "NBUInfluencerBonusPart: Address is zero");
        swapToken = newSwapToken;
    }

    function updateSwapTokenAmountForBonusThreshold(uint threshold) external onlyOwner {
        swapTokenAmountForBonusThreshold = threshold;
    }
}

library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferBNB(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
    }
}