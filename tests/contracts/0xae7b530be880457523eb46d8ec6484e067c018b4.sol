pragma solidity ^0.5.13;


/**
 * 
 * UniPower's Timelock Staking
 * Holders can stake their power here for fixed duration to receive trading fees thoroughout
 * For more info visit: https://unipower.network
 * 
 */
contract PowerLock {
    
    ERC20 constant powerToken = ERC20(0xF2f9A7e93f845b3ce154EfbeB64fB9346FCCE509);
    
    address blobby = msg.sender;
    uint256 constant internal magnitude = 2 ** 64;
    
    mapping(address => int256) public payoutsTo;
    uint256 public profitPerShare;
    
    uint256 public totalStakePower;
    uint256 public totalPowerStaked;
    
    mapping(address => uint256) public playersStakePower;
    mapping(address => Frozen[]) public playersFreezes;
    
    mapping(uint256 => StakingOption) public stakingBonus;
    
    struct Frozen {
        uint128 amount;
        uint64 unlockEpoch;
        uint32 stakeBonus;
    }
    
    struct StakingOption {
        uint128 unlockEpoch;
        uint128 stakeBonus;
    }
    
    constructor() public {
        stakingBonus[0] = StakingOption(30 days, 0);
        stakingBonus[1] = StakingOption(90 days, 10);
        stakingBonus[2] = StakingOption(180 days, 25);
    }
    
    
    function addStakingOption(uint256 id, uint128 unlockEpoch, uint128 stakeBonus) external {
        require(msg.sender == blobby);
        require(unlockEpoch >= 7 days);
        require(stakeBonus > 0 && stakeBonus <= 200);
        stakingBonus[id] = StakingOption(unlockEpoch, stakeBonus);
    }


    function receiveApproval(address player, uint256 amount, address, bytes calldata data) external {
        require(msg.sender == address(powerToken));
        require(amount >= 1 * (10 ** 18));
        
        StakingOption memory stakingOptions = stakingBonus[bytesToUint(data)];
        require(stakingOptions.unlockEpoch > 0);
        uint256 stakeBonus = stakingOptions.stakeBonus;
        uint256 unlockEpoch = now + stakingOptions.unlockEpoch;
    
        uint256 stakePower = (amount * (100 + stakeBonus)) / 100;
        totalPowerStaked += amount;
        totalStakePower += stakePower;
        playersStakePower[player] += stakePower;
        payoutsTo[player] += (int256) (profitPerShare * stakePower);
        
        powerToken.transferFrom(player, address(this), amount);
        playersFreezes[player].push(Frozen(uint128(amount), uint64(unlockEpoch), uint32(stakeBonus)));
    }
    
    
    function unfreeze(uint256 index) external {
        uint256 playersFreezeCount = playersFreezes[msg.sender].length;
        require(index < playersFreezeCount);
        Frozen memory freeze = playersFreezes[msg.sender][index];
        require(freeze.amount > 0);
        require(freeze.unlockEpoch <= now);
        
        withdrawEarnings();
        uint256 stakePower = (freeze.amount * (100 + freeze.stakeBonus)) / 100;
        totalPowerStaked -= freeze.amount;
        totalStakePower -= stakePower;
        playersStakePower[msg.sender] -= stakePower;
        payoutsTo[msg.sender] -= (int256) (profitPerShare * stakePower);
        
        if (playersFreezeCount > 1) {
            playersFreezes[msg.sender][index] = playersFreezes[msg.sender][playersFreezeCount - 1];
        }
        delete playersFreezes[msg.sender][playersFreezeCount - 1];
        playersFreezes[msg.sender].length--;
        
        powerToken.transfer(msg.sender, freeze.amount);
    }
    
    
    function withdrawEarnings() public {
        uint256 dividends = dividendsOf(msg.sender);
        payoutsTo[msg.sender] += (int256) (dividends * magnitude);
        powerToken.transfer(msg.sender, dividends);
    }
    
    
    function distributeDivs(uint256 amount) external {
        powerToken.transferFrom(msg.sender, address(this), amount);
        profitPerShare += amount * magnitude / totalStakePower;
    }
    
    
    function dividendsOf(address customerAddress) view public returns (uint256) {
        return (uint256) ((int256)(profitPerShare * playersStakePower[customerAddress]) - payoutsTo[customerAddress]) / magnitude;
    }
    
    
    function getPlayersFreezings(address player, uint256 startIndex, uint256 endIndex) public view returns (uint256[3][] memory) {
        uint256 numListings = (endIndex - startIndex) + 1;
        if (startIndex == 0 && endIndex == 0) {
            numListings = playersFreezes[player].length;
        }

        uint256[3][] memory freezeData = new uint256[3][](numListings);
        for (uint256 i = 0; i < numListings; i++) {
            Frozen memory freeze = playersFreezes[player][i];
            freezeData[i][0] = freeze.amount;
            freezeData[i][1] = freeze.unlockEpoch;
            freezeData[i][2] = freeze.stakeBonus;
        }

        return (freezeData);
    }
    
    function bytesToUint(bytes memory b) public pure returns (uint256) {
        uint256 number;
        for (uint i=0;i<b.length;i++) {
            number = number + uint(uint8(b[i]))*(2**(8*(b.length-(i+1))));
        }
        return number;
    }
    
}





interface ERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
  function transferFrom(address from, address to, uint256 value) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}