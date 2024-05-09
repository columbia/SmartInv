pragma solidity ^0.6.12;

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
    function balanceOf(address tokenOwner) external view returns (uint256 balance);
}

contract YFKAController is Ownable {
    using SafeMath for uint256;

    uint8 constant ETH_POOL = 3;

    IERC20[4] public pools;
    
    mapping(uint8 => mapping(address => uint256)) public lastBlockWithdrawn;
    mapping(uint8 => mapping(address => uint256)) public personalEmissions;


    IYFKA public yfka = IYFKA(0x4086692D53262b2Be0b13909D804F0491FF6Ec3e);
    
    uint256 public multiplier = 2;

    mapping(uint8 => mapping(address => uint256)) public stakes;

    // Current Emission Rate / 
    uint256 public emissionRate = 2 * (10 ** 18); // YFKA reward per YFKA staked per year
    
    uint256 public minimum_stake = 2 * (10 ** 17); //0.2 YFKA required to stake
    uint256 public blocks_per_year = 2372500;
    
    uint256 public decayPercent =  999998;
    uint256 public decayDivisor = 1000000;
    
    uint256 public lastBlockUpdated = block.number;
    
    mapping(address => bool) whitelist;
    
    // MGMT
    bool isOpen = false;
    
    function setOpen() public onlyOwner {
        isOpen = true;
    }
    
    function addWhitelist() public {
        whitelist[msg.sender] = true;
    }
    
    modifier onlyIfOpen {
        if (isOpen == false) {
          require((msg.sender == _owner) || (whitelist[msg.sender] == true));  
        }
        _;
    }
    //
    
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

    function setYFKA(address _addr) public onlyOwner {
        yfka = IYFKA(_addr);
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
    uint precision = 1000000;
    function yfkaPerLP(uint8 idx, uint256 amount) public view returns (uint256) {
        uint percentOfLPStaked = amount.mul(precision).div(pools[idx].totalSupply());
        uint256 _yfkaStake = yfka.balanceOf(address(pools[idx])).mul(percentOfLPStaked).div(precision);

        return _yfkaStake;
    }
    
    function totalYFKAStaked(uint8 idx) public view returns(uint points) {
        uint256 amount = pools[idx].balanceOf(address(this));
        return yfkaPerLP(idx, amount);
    }
    
    function personalYFKAStaked(uint8 idx) public view returns(uint points) {
        uint256 amount = stakes[idx][msg.sender];
        return yfkaPerLP(idx, amount);
    }
    

    // Returns the pool with the highest stake amount
    function getActivePool() public view returns (uint8 idx) {
        if ((totalYFKAStaked(0) < totalYFKAStaked(1)) && (totalYFKAStaked(0) < totalYFKAStaked(2))) {
            return 0;
        }
        else if ((totalYFKAStaked(1) < totalYFKAStaked(0)) && (totalYFKAStaked(1) < totalYFKAStaked(2))) {
            return 1;
        }
        return 2;
    }

    // LOGIC CALLED WHEN STAKING / UNSTAKING / WITHDRAWING FROM A POOL

    // Emission rate variables
    function _getNextRateReduction() public view returns(uint256) {
        uint256 absoluteRate = emissionRate.mul(decayPercent).div(decayDivisor);
        return emissionRate.sub(absoluteRate);
    }

    function _getBlocksSinceLastReduction() public view returns(uint256) {
        uint256 last = block.number.sub(lastBlockUpdated);
        if (last > 5000) {
            return 5000;
        }
        return last;
    }
    
    function _getTotalNextRateReduction() public view returns(uint256) {
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
    
    event BonusPoolChange(uint256 indexed previousPool, uint256 indexed newPool);

    function stake(uint8 idx, uint256 amount) public {
        require(yfkaPerLP(idx, amount) > minimum_stake);

        mint(idx, false);

        if (getPersonalEmissionRate(idx, msg.sender) == 0) {
            setPersonalEmissionRate(idx, msg.sender);
        }
        
        uint256 previousPool = getActivePool();

        pools[idx].transferFrom(msg.sender, address(this), amount);
        stakes[idx][msg.sender] = stakes[idx][msg.sender].add(amount);
        // If the emission rate has not been set, set it to the current rate
        
        uint256 newPool = getActivePool();
        
        if (previousPool != newPool) {
            emit BonusPoolChange(previousPool, newPool);
        }
    }
    
    function unstake(uint8 idx, uint256 amount) public {
        // Mint and update global and personal rate
        mint(idx, true);

        // Subtract stake first before sending any tokens back. Will throw if invalid amount provided.
        stakes[idx][msg.sender] = stakes[idx][msg.sender].sub(amount);
        pools[idx].transfer(msg.sender, amount);
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

    function getLastBlockWithdrawn(uint8 idx) public view returns (uint256 reward) {
        uint256 lbw = lastBlockWithdrawn[idx][msg.sender];
        if (lbw == 0) {
            lbw = block.number;
        }

        return lbw;
    }

    function getCurrentRewardPerYear(uint8 idx) public view returns (uint256) {
        uint256 emission = personalEmissions[idx][msg.sender];
        uint256 staked = personalYFKAStaked(idx);

        if ((emission == 0) || (staked == 0)) {
            return 0;
        }

        uint256 perYear = staked.mul(emission).div(10 ** 18);

        return perYear;
    }
    
    function getCurrentReward(uint8 idx) public view returns (uint256) {
        uint256 perYear = getCurrentRewardPerYear(idx);

        uint256 lbw = getLastBlockWithdrawn(idx);
        uint256 blockDifference = block.number.sub(lbw);

        uint reward = perYear.div(blocks_per_year).mul(blockDifference);
        
        if (idx == getActivePool()) {
            reward = reward.mul(multiplier);
        }
        else if (idx == ETH_POOL) {
            reward = reward.div(multiplier);
        }
        
        return reward;
    }
    
    event EmissionRateCut(uint256 indexed previousRate, uint256 indexed newRate);
    
    function mint(uint8 idx, bool update) internal onlyIfOpen {
        uint256 mintAmount = getCurrentReward(idx);
        
        // Apply mint
        yfka.mint(msg.sender, mintAmount);
        
        if(emissionRate != 0){
            uint256 previousRate = emissionRate;
            updateEmissionRate();
            uint256 newRate = emissionRate;
            
            emit EmissionRateCut(previousRate, newRate);
        }
        
        lastBlockWithdrawn[idx][msg.sender] = block.number;

        if(update == true) {
           setPersonalEmissionRate(idx, msg.sender);
        }
    }

}