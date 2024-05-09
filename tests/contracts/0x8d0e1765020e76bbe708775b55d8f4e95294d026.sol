// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0 <0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

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
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

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

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract StakingToken is Ownable {
    
    //initializing safe computations
    using SafeMath for uint;

    IERC20 public contractAddress;
    uint public stakingPool;
    uint public stakeholdersIndex;
    uint public totalStakes;
    uint private setTime;
    uint public minimumStakeValue;
    address admin;
    
    uint rewardToShare;
    
    struct Stakeholder {
         bool staker;
         uint id;
    }

    modifier validatStake(uint _stake) {
        require(_stake >= minimumStakeValue, "Amount is below minimum stake value.");
        require(contractAddress.balanceOf(msg.sender) >= _stake, "Must have enough balance to stake");
        require(
            contractAddress.allowance(msg.sender, address(this)) >= _stake, 
            "Must approve tokens before staking"
        );
        _;
    }
    
    mapping (address => Stakeholder) public stakeholders;
    mapping (uint => address) public stakeholdersReverseMapping;
    mapping(address => uint256) private stakes;
    mapping(address => uint256) private rewards;
    mapping(address => uint256) private time;
    mapping(address => bool) public registered;

    constructor(IERC20 _contractAddress) {
        contractAddress = _contractAddress;
        stakingPool = 0;
        stakeholdersIndex = 0;
        totalStakes = 0;
        totalStakes = 0;
        setTime = 0;
        rewardToShare = 0;
        minimumStakeValue = 0.1 ether;
    }
    
    function bal(address addr) public view returns(uint) {
        return contractAddress.balanceOf(addr);
    }
    
    function approvedTokenBalance(address _sender) public view returns(uint) {
        return contractAddress.allowance(_sender, address(this));
    }
    
    function changeAdmin(address _newAdmin) public returns(bool) {
        require(msg.sender == admin, 'Access denied!');
        require(_newAdmin != address(0), "New admin is zero address");
        admin = _newAdmin;
        return true;
    }
    
    function newStake(uint _stake) external validatStake(_stake) {
        require(
            stakes[msg.sender] == 0 && 
            registered[msg.sender] == false, 
            "Already a stakeholder"
        );
         require(approvedTokenBalance(msg.sender) >= _stake, "No token approve yet");
        // Aprrove tokens before staking
        contractAddress.transferFrom(msg.sender, address(this), _stake);
        
        addStakeholder(msg.sender); 
        uint registerCost = calculateCost(_stake);
        uint stakeToPool = _stake.sub(registerCost);
        stakingPool = stakingPool.add(stakeToPool);
        stakes[msg.sender] = registerCost;
        totalStakes = totalStakes.add(registerCost);
        registered[msg.sender] = true;
    }
    
    function stake(uint _stake) external { 
        require(
            registered[msg.sender] == true, 
            "Not a stakeholder, use the newStake method to stake"
        );
        require(_stake >= minimumStakeValue, "Amount is below minimum stake value.");
        require(contractAddress.balanceOf(msg.sender) >= _stake, "Must have enough balance to stake");
        require(
            approvedTokenBalance(msg.sender) >= _stake, 
            "Must approve tokens before staking"
        );
        
        contractAddress.transferFrom(msg.sender, address(this), _stake);
        
        // check previous stake balance
        uint previousStakeBalance = stakes[msg.sender];
        
        uint availableTostake = calculateCost(_stake);
        uint stakeToPool2 = _stake.sub(availableTostake);
        stakingPool = stakingPool.add(stakeToPool2);
        totalStakes = totalStakes.add(availableTostake);
        stakes[msg.sender] = previousStakeBalance.add(availableTostake);
    }
    
    function stakeOf(address _stakeholder) external view returns(uint256) {
        return stakes[_stakeholder];
    }
    
    function removeStake(uint _stake) external {
        require(registered[msg.sender] == true, "Not a stakeholder");
        require(stakes[msg.sender] > 0, 'stakes must be above 0');
        require(stakes[msg.sender] >= _stake, "Amount is greater than current stake");
        
        time[msg.sender] = block.timestamp;
        uint _balance = stakes[msg.sender];
        stakes[msg.sender] = stakes[msg.sender].sub(_stake);
         
        uint _reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        totalStakes = totalStakes.sub(_stake);
        // 20% withrawal charges
        uint withdrawalCharges = _stake.mul(20).div(100);
        stakingPool = stakingPool.add(withdrawalCharges);
        uint _totalAmount = _balance.sub(withdrawalCharges);
        _totalAmount = _totalAmount.add(_reward);
        contractAddress.transfer(msg.sender, _totalAmount);
        
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
    }
    
    function addStakeholder(address _stakeholder) private {
        require(stakeholders[_stakeholder].staker == false, "Already a stakeholder");
        stakeholders[_stakeholder].staker = true;    
        stakeholders[_stakeholder].id = stakeholdersIndex;
        stakeholdersReverseMapping[stakeholdersIndex] = _stakeholder;
        stakeholdersIndex = stakeholdersIndex.add(1);
    }
   
    function removeStakeholder(address _stakeholder) private  {
        require(stakeholders[_stakeholder].staker == true, "Not a stakeholder");
        
        // get id of the stakeholders to be deleted
        uint swappableId = stakeholders[_stakeholder].id;
        
        // swap the stakeholders info and update admins mapping
        // get the last stakeholdersReverseMapping address for swapping
        address swappableAddress = stakeholdersReverseMapping[stakeholdersIndex -1];
        
        // swap the stakeholdersReverseMapping and then reduce stakeholder index
        stakeholdersReverseMapping[swappableId] = stakeholdersReverseMapping[stakeholdersIndex - 1];
        
        // also remap the stakeholder id
        stakeholders[swappableAddress].id = swappableId;
        
        // delete and reduce admin index 
        delete(stakeholders[_stakeholder]);
        delete(stakeholdersReverseMapping[stakeholdersIndex - 1]);
        stakeholdersIndex = stakeholdersIndex.sub(1);
        registered[msg.sender] = false;
    }
    
    function getRewardToShareWeekly() external onlyOwner() {
        require(block.timestamp > setTime, 'wait a week from last call');
        setTime = block.timestamp + 7 days;
        rewardToShare = stakingPool.div(2);
        stakingPool = stakingPool.sub(rewardToShare);
    }
    
    function getRewards() external {
        require(registered[msg.sender] == true, 'address does not belong to a stakeholders');
        require(rewardToShare > 0, 'no reward to share at this time');
        require(block.timestamp > time[msg.sender], 'can only call this function once a week');
        
        time[msg.sender] = block.timestamp + 7 days;
        uint _initialStake = stakes[msg.sender];
        uint reward = _initialStake.mul(rewardToShare).div(totalStakes);
        rewards[msg.sender] = rewards[msg.sender].add(reward);
    }
    
    /* return will converted to ether in frontend*/
    function rewardOf(address _stakeholder) external view returns(uint256){
        return rewards[_stakeholder];
    }
    
    function calculateCost(uint256 _stake) private pure returns(uint availableForstake) {
        uint stakingCost =  (_stake).mul(20).div(100);
        availableForstake = _stake.sub(stakingCost);
        return availableForstake;
    }
    
}