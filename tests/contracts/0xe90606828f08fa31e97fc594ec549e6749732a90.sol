pragma solidity 0.5.16;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
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
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        return c;
    }
    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}


contract EEEMoney{
    // SafeMath
    using SafeMath for uint;
    
    // User struct
    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        uint totalEarnedETH;
        uint previousShare;
        uint sharesHoldings;
        uint directShare;
        uint referralShare;
        uint poolHoldings;
        uint created;
        address[] referral;
    }
    
    // Public variables
    address public ownerWallet;
    address public splitOverWallet;
    uint public poolMoney;
    uint public qualifiedPoolHolding = 0.5 ether;
    uint public invest = 0.25 ether;
    uint public feePercentage = 0.0125 ether; 
    uint public currUserID = 0;
    uint public qualify = 86400;
    bool public lockStatus;
    
    // Mapping
    mapping(address => UserStruct) public users;
    mapping(address => uint) public userMoney;
    mapping (uint => address) public userList;
    
    // Events
    event regEvent(address indexed _user, address indexed _referrer, uint _time);
    event poolMoneyEvent(address indexed _user, uint _money, uint _time);
    event splitOverEvent(address indexed _user, uint _shareAmount, uint _userShares, uint _money, uint _time);
    event userInversement(address indexed _user, uint _noOfShares, uint _amount, uint _time, uint investType);
    event userWalletTransferEvent(address indexed _user, uint _amount, uint _percentage, uint _gasFee, uint _time);
    event ownerWalletTransferEvent(address indexed _user, uint _percentage, uint _gasFee, uint _time);
    
    // On Deploy
    constructor(address _splitOverWallet)public{
        ownerWallet = msg.sender;
        splitOverWallet = _splitOverWallet;
        
        UserStruct memory userStruct;
        currUserID++;
        
        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: 0,
            totalEarnedETH: 0,
            previousShare: 0,
            sharesHoldings: 1000,
            directShare: 0,
            referralShare: 0,
            poolHoldings: 0,
            created:now.add(qualify),
            referral: new address[](0)
        });
        users[ownerWallet] = userStruct;
        userList[currUserID] = ownerWallet;
    }
    
    /**
     * @dev Fallback
     */ 
    function () external payable {
        revert("Invalid Transaction");
    }
    
    /**
     * @dev To register the User
     * @param _referrerID id of user/referrer 
     */
    function regUser(uint _referrerID) public payable returns(bool){
        require(
            lockStatus == false,
            "Contract is locked"
        );
        require(
            !users[msg.sender].isExist,
            "User exist"
        );
        require(
            _referrerID > 0 && _referrerID <= currUserID,
            "Incorrect referrer Id"
        );
        require(
            msg.value == invest,
            "Incorrect Value"
        );
        
        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: _referrerID,
            totalEarnedETH: 0,
            previousShare: 0,
            sharesHoldings: 1,
            directShare: 0,
            referralShare: 0,
            poolHoldings: 0,
            created:now.add(qualify),
            referral: new address[](0)
        });

        users[msg.sender] = userStruct;
        userList[currUserID] = msg.sender;
        
        users[userList[_referrerID]].sharesHoldings = users[userList[_referrerID]].sharesHoldings.add(1);
        users[userList[_referrerID]].referralShare = users[userList[_referrerID]].referralShare.add(1);
        users[userList[_referrerID]].referral.push(msg.sender);
    
        uint _value = invest.div(2);
        
        require(
            address(uint160(userList[_referrerID])).send(_value),
            "Transaction failed"
        );
        users[userList[_referrerID]].totalEarnedETH = users[userList[_referrerID]].totalEarnedETH.add(_value);
        
        poolMoney = poolMoney.add(_value);
        
        emit poolMoneyEvent( msg.sender, _value, now);
        emit regEvent(msg.sender, userList[_referrerID], now);
        
        return true;
    }

    /**
     * @dev To invest on shares
     * @param _noOfShares No of shares 
     */
    function investOnShare(uint _noOfShares) public payable returns(bool){
        require(
            lockStatus == false,
            "Contract is locked"
        );
        require(
            users[msg.sender].isExist,
            "User not exist"
        );
        require(
            msg.value == invest.mul(_noOfShares),
            "Incorrect Value"
        );
        
        uint _value = (msg.value).div(2);
        address _referer = userList[users[msg.sender].referrerID];
        require(
            address(uint160(_referer)).send(_value),
            "Transaction failed"
        ); 
        
        users[_referer].totalEarnedETH = users[_referer].totalEarnedETH.add(_value);
        
        users[msg.sender].directShare = users[msg.sender].directShare.add(_noOfShares);
        users[msg.sender].sharesHoldings = users[msg.sender].sharesHoldings.add(_noOfShares);
        
        poolMoney = poolMoney.add(_value);
        
        emit poolMoneyEvent( msg.sender, _value, now);
        emit userInversement( msg.sender, _noOfShares, msg.value, now, 1);
        
        return true;
    }
    
    /**
     * @dev To splitOver pool money
     * @param _gasFee Gas fee 
     */
    function splitOver(uint _gasFee) public returns(bool){
        require(
           splitOverWallet == msg.sender,
            "Invalid splitOverWallet"
        );
        require(
            poolMoney > 0,
            "pool money is zero"
        );
        uint _totalShare = getQualfiedUsers(1, 0);
        uint shareAmount = poolMoney.div(_totalShare);
        
        sendSplitShares( 1, shareAmount, _gasFee);
        
        return true;
    }
    
    /**
     * @dev Contract balance withdraw
     * @param _toUser  receiver addrress
     * @param _amount  withdraw amount
     */ 
    function failSafe(address payable _toUser, uint _amount) public returns (bool) {
        require(msg.sender == ownerWallet, "Only Owner Wallet");
        require(_toUser != address(0), "Invalid Address");
        require(address(this).balance >= _amount, "Insufficient balance");

        (_toUser).transfer(_amount);
        return true;
    }

    /**
     * @dev To lock/unlock the contract
     * @param _lockStatus  status in bool
     */
    function contractLock(bool _lockStatus) public returns (bool) {
        require(msg.sender == ownerWallet, "Invalid ownerWallet");

        lockStatus = _lockStatus;
        return true;
    }
    
    /**
     * @dev To get qualified user
     * @param _userIndex  User ID 
     * @param _totalShare  Users total share
     */ 
    function getQualfiedUsers(uint _userIndex, uint _totalShare) public view returns(uint){
        address _userAddress = userList[_userIndex];
        if((users[_userAddress].sharesHoldings > users[_userAddress].previousShare) && (users[_userAddress].created < now)){
           _totalShare = _totalShare.add((users[_userAddress].sharesHoldings.sub(users[_userAddress].previousShare)));
           
        }
        _userIndex++;
        if(_userIndex <= currUserID){
           return this.getQualfiedUsers(_userIndex, _totalShare);
        }
        else{
            return _totalShare;
        }
    }
    
    /**
     * @dev To view the referrals
     * @param _user  User address
     */ 
    function viewUserReferral(address _user) public view returns(address[] memory) {
        return users[_user].referral;
    }
    
    function getTotalEarnedEther() public view returns(uint) {
        uint totalEth;
        
        for( uint _userIndex=1;_userIndex<= currUserID;_userIndex++) {
            totalEth = totalEth.add(users[userList[_userIndex]].totalEarnedETH);
        }
        
        return totalEth;
    }
    
    function sendSplitShares(uint _userIndex, uint _shareAmount, uint _gasFee) internal {
        
        address _userAddress = userList[_userIndex];
        if((users[_userAddress].sharesHoldings > users[_userAddress].previousShare) && (users[_userAddress].created < now)){
            uint _shares = users[_userAddress].sharesHoldings.sub(users[_userAddress].previousShare);
            uint _userShareAmount = _shareAmount.mul(_shares);
            
            poolMoney = poolMoney.sub(_userShareAmount);
            users[_userAddress].poolHoldings = users[_userAddress].poolHoldings.add(_userShareAmount);
            users[_userAddress].previousShare = users[_userAddress].sharesHoldings;
            
            if(users[_userAddress].poolHoldings >= qualifiedPoolHolding){
                // re-Inversement
                reInvest(_userAddress, _gasFee);
            }
            
            
            emit splitOverEvent( _userAddress, _shareAmount, _shares, _userShareAmount, now);
            
            
        }
        _userIndex++;
        if(_userIndex <= currUserID){
            sendSplitShares(_userIndex, _shareAmount, _gasFee);
        }
        
    }
    
    function reInvest(address _userAddress, uint _gasFee) internal returns(bool) {
        
        uint _totalInvestingShare = users[_userAddress].poolHoldings.div(qualifiedPoolHolding);
        uint _referervalue = invest.div(2);
        uint _value = (_referervalue.mul(_totalInvestingShare));
        
        address _referer = userList[users[_userAddress].referrerID];

        uint adminFee = feePercentage.mul(2);
        uint gasFee = _gasFee.mul(2);
        
        if(_referer == address(0))
            _referer = userList[1];
        
        require(
            address(uint160(_referer)).send(_value),
            "re-inverset referer 50 percentage failed"
        );
        
        users[_referer].totalEarnedETH = users[_referer].totalEarnedETH.add(_value);
        
        users[_userAddress].directShare = users[_userAddress].directShare.add(_totalInvestingShare);
        users[_userAddress].sharesHoldings = users[_userAddress].sharesHoldings.add(_totalInvestingShare);
        
        poolMoney = poolMoney.add(_value);
        
        // wallet
        uint _walletAmount = invest.mul(_totalInvestingShare);
        _walletAmount = _walletAmount.sub(adminFee.add(gasFee));
        
        require(
            address(uint160(_userAddress)).send(_walletAmount) &&
            address(uint160(ownerWallet)).send(adminFee.add(gasFee)),
            "user wallet transfer failed"
        );  
        
        users[_userAddress].poolHoldings = users[_userAddress].poolHoldings.sub(qualifiedPoolHolding.mul(_totalInvestingShare));
        
        emit userInversement( _userAddress, _totalInvestingShare, invest.mul(_totalInvestingShare), now, 2);
        emit poolMoneyEvent( _userAddress, _value, now);
        emit userWalletTransferEvent(_userAddress, _walletAmount, adminFee, gasFee, now);
        emit ownerWalletTransferEvent(_userAddress, adminFee, gasFee, now);
        
        return true;
    }
    
}