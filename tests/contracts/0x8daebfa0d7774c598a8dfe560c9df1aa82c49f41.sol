pragma solidity 0.6.12;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () public {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint256 balance);
    function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
    function transfer(address to, uint256 tokens) external returns (bool success);
    function approve(address spender, uint256 tokens) external returns (bool success);
    function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
}


interface IYFKA {
    function mint(address to, uint256 amount) external;
    function transferOwnership(address newOwner) external;
}

contract YFKAController is Ownable {
    using SafeMath for uint256;

    IERC20[3] pools;
    
    mapping(uint8 => mapping(address => uint256)) public lastBlockWithdrawn;
    mapping(uint8 => mapping(address => uint256)) public personalEmissions;


    IYFKA public yfka = IYFKA(0x4086692D53262b2Be0b13909D804F0491FF6Ec3e);
    
    uint256 public multiplier = 2; 
    
    mapping(uint8 => mapping(address => uint256)) public stakes;
    mapping(uint8 => uint256) public totalStakes;
    
    // Current Emission Rate / 
    uint256 public emissionRate = 10**18;
    uint256 public decayPercent =  999998;
    uint256 public decayDivisor = 1000000;
    
    uint256 public lastBlockUpdated = block.number;
    
    /*
    SET TOKEN
    Given an index and an address, this stores the ERC20 contract object of the token you want to support in your pool
    Parameters:
        idx: Index of the pool to set.
        _addr: Address of the token you want to pool.
    Returns:
        None
    
    */
    function setPool(uint8 idx, address _addr) public onlyOwner {
        pools[idx] = IERC20(_addr);
    }

    function transferOwnershipOfYFKA(address _addr) public onlyOwner {
        yfka.transferOwnership(_addr);
    }

    /*
    GET POINTS FOR STAKE
    Calculates the 'points' an owner has for a particular pool. Used to calculate how much of a reward to mint.
    Parameters:
        idx: Index of the pool to set.
        stake: The amount of stake.
    Returns:
        points: Number of points
    */
    function getPointsForStake(uint8 idx, uint256 stake) public view returns(uint points) {
        return stake.mul(10 ** 9).div(pools[idx].totalSupply());
    }


    // Returns the pool with the highest stake amount
    function getActivePool() public view returns (uint8 idx) {
        uint256[3] memory maxStakes;
        maxStakes[0] = getPointsForStake(0, pools[0].balanceOf(address(this)));
        maxStakes[1] = getPointsForStake(1, pools[1].balanceOf(address(this)));
        maxStakes[2] = getPointsForStake(2, pools[2].balanceOf(address(this)));
        
        if ((maxStakes[0] >= maxStakes[1]) && (maxStakes[0] >= maxStakes[2])) {
            return 0;
        }
        else if ((maxStakes[1] >= maxStakes[0]) && (maxStakes[1] >= maxStakes[2])) {
            return 1;
        }
        return 2;
    }

    // LOGIC CALLED WHEN STAKING / UNSTAKING / WITHDRAWING FROM A POOL

    // Emission rate variables
    function _getNextRateReduction() internal view returns(uint256) {
        uint256 absoluteRate = emissionRate.mul(decayPercent).div(decayDivisor);
        return emissionRate.sub(absoluteRate);
    }

    function _getBlocksSinceLastReduction() internal view returns(uint256) {
        uint256 last = block.number.sub(lastBlockUpdated);
        if (last > 5000) {
            return 5000;
        }
        return last;    
        
    }
    
    function _getTotalNextRateReduction() internal view returns(uint256) {
        return _getNextRateReduction().mul(_getBlocksSinceLastReduction());
    }
    
    // stake/ withdraw until 156 blocks have passed
    function updateEmissionRate() internal {
        
        if (_getTotalNextRateReduction() < emissionRate) {
            emissionRate = emissionRate.sub(_getTotalNextRateReduction());
            lastBlockUpdated = block.number;
        }
        
    }
    
    function getPersonalEmissionRate(uint8 idx, address _addr) public view returns (uint256) {
        return personalEmissions[idx][_addr];
    }

    function setPersonalEmissionRate(uint8 idx, address _addr) internal {
        personalEmissions[idx][_addr] = emissionRate;
    }

    function increaseStake(uint8 idx, uint256 amount) internal {
        pools[idx].transferFrom(msg.sender, address(this), amount);
        stakes[idx][msg.sender] = stakes[idx][msg.sender].add(amount);
        totalStakes[idx] = totalStakes[idx].add(amount);
    }

    function decreaseStake(uint8 idx, uint256 amount) internal {
        totalStakes[idx] = totalStakes[idx].sub(amount);
        stakes[idx][msg.sender] = stakes[idx][msg.sender].sub(amount);
        pools[idx].transfer(msg.sender, amount);
    }

    function stake(uint8 idx, uint256 amount) public {
        // If the emission rate has not been set, set it to the current rate
        // 10**3 == MINIMUM_LIQUIDITY of the uniswap token 
        require(emissionRate > 0, "Staking period must be active.");
        amount = amount.sub(10**3);
        
        if (getPersonalEmissionRate(idx, msg.sender) == 0) {
            setPersonalEmissionRate(idx, msg.sender);
        }

        // Mint before adding stake
        mint(idx, false);
        
        // Add to stake
        increaseStake(idx, amount);
    }
    
    function unstake(uint8 idx, uint256 amount) public {
        // Mint and update global and personal rate
        amount = amount.sub(10**3);
        
        mint(idx, true);

        // Subtract stake first before sending any tokens back. Will throw if invalid amount provided.
        decreaseStake(idx, amount);
    }
    
    // redeem idxs w/o unstaking
    function redeem(uint8 idx) public {
        // Mint and update global and personal rate
        mint(idx, true);
    }

    /*
    LAST BLOCK WITHDRAWN
    Mapping of pool index and wallet public key to block number
    This is used to determine the time between the last withdraw event and the current withdraw event.
    The duration of time in blocks is then multiplied by the 
    */

    function getLastBlockWithdrawn(uint8 idx) public view returns (uint256) {
        uint256 lbw = lastBlockWithdrawn[idx][msg.sender];
        if (lbw == 0) {
            lbw = block.number;
        }

        return lbw;
    }
    
    function setLastBlockWithdrawn(uint8 idx) internal {
        lastBlockWithdrawn[idx][msg.sender] = block.number;
    }
    
    function getCurrentReward(uint8 idx) public view returns (uint256 reward) {
        uint256 blockDifference = block.number.sub(getLastBlockWithdrawn(idx));
        uint256 amount = getPersonalEmissionRate(idx, msg.sender).mul(blockDifference).mul(getPointsForStake(idx,stakes[idx][msg.sender])).div(10**9);
        
        if (idx == getActivePool()) {
            amount = amount.mul(multiplier);
        }
        
        return amount;

    }
    
    function mint(uint8 idx, bool update) internal {
        uint256 mintAmount = getCurrentReward(idx); 
        
        // Apply mint
        yfka.mint(msg.sender, mintAmount);
        
        if(emissionRate != 0){
            updateEmissionRate();
        }
        
        setLastBlockWithdrawn(idx);
        if(update) {    
           setPersonalEmissionRate(idx, msg.sender);
        }
        
    }

}