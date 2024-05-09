pragma solidity >=0.4.0 <0.6.0;
 
 interface tokenToTransfer {
        function transfer(address to, uint256 value) external;
        function transferFrom(address from, address to, uint256 value) external;
        function balanceOf(address owner) external returns (uint256);
    }
    
    contract Ownable {
        address private _owner;
        
        constructor() public {
            _owner = msg.sender;
        }
        
        modifier onlyOwner() {
            require(isOwner());
            _;
         }
          
        function isOwner() public view returns(bool) {
            return msg.sender == _owner;
         }
          
        function transferOwnership(address newOwner) public onlyOwner {
            _transferOwnership(newOwner);
        }
        
        function _transferOwnership(address newOwner) internal {
            require(newOwner != address(0));
            _owner = newOwner;
        }
    }
    
    contract StakeImperial is Ownable {
    //Setup of public variables for maintaing between contract transactions
    address private ImperialAddress = address(0x25cef4fb106e76080e88135a0e4059276fa9be87);
    tokenToTransfer private sendtTransaction;
    
    //Setup of staking variables for contract maintenance 
    mapping (address => uint256) private stake;
    mapping (address => uint256) private timeinStake;
    mapping (address => bool) private hasUserStaked;
    uint256 private time = now;
    uint256 private reward;
    uint256 private timeVariable = 86400;
    uint256 private allStakes;
    bool private higherReward = true;
    
    function View_Balance() public view returns (uint256) {
        sendtTransaction = tokenToTransfer(ImperialAddress);
        return sendtTransaction.balanceOf(msg.sender);
    }
    
    function View_ContractBalance() public view returns (uint256) {
        sendtTransaction = tokenToTransfer(ImperialAddress);
        return sendtTransaction.balanceOf(address(this));
    }
    
    function initateStake() public {
        //uint256 stakedAmount = stake * 1000000;
        sendtTransaction = tokenToTransfer(ImperialAddress);
        uint256 stakedAmount = View_Balance();
        
                if (stakedAmount == 0) {
                    revert();
                }
                
                if (hasUserStaked[msg.sender] == true) {
                    revert();
                }
        
        sendtTransaction.transferFrom(msg.sender, address(this), stakedAmount);
        stake[msg.sender] = stakedAmount;
        allStakes += stakedAmount;
        timeinStake[msg.sender] = now;
        hasUserStaked[msg.sender] = true;
    }
    
    function displayStake() public view returns (uint256) {
        return stake[msg.sender];
    }
    
    function displayBalance() public view returns (uint256) {
        uint256 balanceTime = (now - timeinStake[msg.sender]) / timeVariable;
        if (higherReward == true) {
        return balanceTime * reward * stake[msg.sender];
        } else {
        balanceTime = balanceTime * (stake[msg.sender] / reward) + stake[msg.sender];
        return balanceTime;
        }
    }

    function displayTime() public view returns (uint256) {
        return time;
    }
    
    function displayAllStakes() public view returns (uint256) {
        return allStakes;
    }
    
    function displayTimeVariable() public view returns (uint256) {
        return timeVariable;
    }
    
    function displayTimeWhenUserStaked() public view returns (uint256) {
        return timeinStake[msg.sender];
    }
    
    function displayRewardBool() public view returns (bool) {
        return higherReward;
    }
    
    function displayRewardVariable() public view returns (uint256) {
        return reward;
    }
    
    /* ADMIN FUNCTIONS */
    //Admin change address to updated address function
    function displayUserStake(address user) public view onlyOwner returns (uint256) {
        return stake[user];
    }
    
    function adminWithdraw(uint256 amount, address ownerAddress) public onlyOwner {
        sendtTransaction = tokenToTransfer(ImperialAddress);
        sendtTransaction.transfer(ownerAddress, amount);
    }
    
    function changeImperialAddresstoNew(address change) public onlyOwner {
        ImperialAddress = change;
    }
    
    //Admin change reward function
    function changeReward(uint256 change) public onlyOwner {
        reward = change;
    }
    
    //Admin change reward function
    function changeTimeVariable(uint256 change) public onlyOwner {
        timeVariable = change;
    }
    
    //Admin reward function for lower than 100%
    function changeRewardtoLower(bool value) public onlyOwner {
        higherReward = value;
    }
    
    //Admin reset time balance to reset stake to new level
    function resetTime() public onlyOwner {
        time = now;
    }

    function withdrawBalance() public {
        uint256 balanceTime = now - timeinStake[msg.sender];
        if (balanceTime < timeVariable) {
                revert();
        }
        
        if (timeinStake[msg.sender] == 0) {
            revert();
        }
        sendtTransaction = tokenToTransfer(ImperialAddress);
        uint256 getUserBalance = displayBalance();
        uint256 contractBalance = View_ContractBalance();
        //Ensure users can get their balance
            if (getUserBalance > contractBalance) {
                revert();
            }
        sendtTransaction.transfer(msg.sender, getUserBalance);
        stake[msg.sender] = 0;
        allStakes -= getUserBalance;
        timeinStake[msg.sender] = 0;
        hasUserStaked[msg.sender] = false;
    }
    
 }