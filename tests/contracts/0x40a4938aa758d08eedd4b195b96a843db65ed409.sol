pragma solidity ^0.4.18;

/*
         _     _                                               _         
   ___  | |_  | |__     ___   _ __   _ __     ___  __  __     (_)   ___  
  / _ \ | __| | '_ \   / _ \ | '__| | '_ \   / _ \ \ \/ /     | |  / _ \ 
 |  __/ | |_  | | | | |  __/ | |    | | | | |  __/  >  <   _  | | | (_) |
  \___|  \__| |_| |_|  \___| |_|    |_| |_|  \___| /_/\_\ (_) |_|  \___/ 

https://ethernex.io/
*/

contract ethernex {
    using SafeMath for uint256;
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    struct MemberInfo { uint userID; uint activeEntry; address referrer; uint[] entriesId; address[] referrals; }
    struct RegInfo { bool isActive; uint amount; uint totalIncome; uint startDate; uint maturityDays; uint withdrawnAmount; }
    mapping (address => MemberInfo)  memberInfos;
    mapping(uint => mapping(uint => RegInfo))  RegistrationInfo;
    mapping(address => uint) public balance;
    uint256 public totalEntries;
    address owner;
    uint public lastMemberID = 2;
    uint public lastEntryID = 2;
    
    constructor() public {
        owner = msg.sender;
        MemberInfo storage _memberInfo = memberInfos[owner];
        _memberInfo.userID = 1;
    }

    function register(address uplineAddress) external payable {
        require(msg.value >= 0.1 ether, "registration starts at 0.1");
        uint _totalDays = getMaturityDays(msg.value);
        require(_totalDays > 0, "invalid entry amount.");
        uint uplineUserId = getUserId(uplineAddress);
        require(uplineUserId > 0, "upline address not found");
         uint memberId = getUserId(msg.sender);
         require(memberId == 0,"address already registered.");
        memberId = lastMemberID++;   
        MemberInfo storage _memberInfo = memberInfos[msg.sender]; 
        _memberInfo.referrer = uplineAddress;
        _memberInfo.userID = memberId;
        uint newEntryId = lastEntryID++;
        _memberInfo.activeEntry += 1;
        _memberInfo.entriesId.push(newEntryId);
        RegInfo storage _regInfo = RegistrationInfo[memberId][newEntryId];
        _regInfo.isActive = true;
        _regInfo.amount = msg.value;
        _regInfo.totalIncome = msg.value.mul(10).mul(_totalDays).div(100);
        _regInfo.startDate = now;
        _regInfo.maturityDays = _totalDays;
        MemberInfo storage _uplineInfo = memberInfos[uplineAddress];
        _uplineInfo.referrals.push(msg.sender);
        uint _directIncome = msg.value.mul(10).div(100);
        if(uplineAddress != address(0)){
            uplineAddress.transfer(_directIncome);
            balance[uplineAddress] += _directIncome;
        }
        owner.transfer(msg.value.mul(8).div(100));
        totalEntries += msg.value;
    }
    
    function addentry() external payable {
        require(msg.value >= 0.1 ether, "registration starts at 0.1");
        uint _totalDays = getMaturityDays(msg.value);
        require(_totalDays > 0, "invalid entry amount.");
        uint memberId = getUserId(msg.sender);
        require(memberId > 0, "address is not yet registered.");
        address uplineAddress = getUpline(msg.sender);
        MemberInfo storage _memberInfo = memberInfos[msg.sender]; 
        uint newEntryId = lastEntryID++;
        _memberInfo.activeEntry += 1;
        _memberInfo.entriesId.push(newEntryId);
        RegInfo storage _regInfo = RegistrationInfo[memberId][newEntryId];
        _regInfo.isActive = true;
        _regInfo.amount = msg.value;
        _regInfo.totalIncome = msg.value.mul(10).mul(_totalDays).div(100);
        _regInfo.startDate = now;
        _regInfo.maturityDays = _totalDays;
        uint _directIncome = msg.value.mul(10).div(100);
        if(uplineAddress != address(0)){
            uplineAddress.transfer(_directIncome);
            balance[uplineAddress] += _directIncome;
        }
        owner.transfer(msg.value.mul(8).div(100));
        totalEntries += msg.value;
    }
    
    function withdrawincome(uint amount, uint entryId) public{
        uint _userId = getUserId(msg.sender);
        require(_userId > 0, "invalid account address");
        uint _balance = getAvailableIncome(_userId, entryId);
        require(_balance >= amount, "you don't have enough balance");
        require(address(this).balance >= amount, "source has insufficient fund, try again later.");
        RegInfo storage _regInfo =  RegistrationInfo[_userId][entryId];
        _regInfo.withdrawnAmount += amount;
        balance[msg.sender] += amount;
        if(_regInfo.withdrawnAmount >= _regInfo.totalIncome){
            _regInfo.isActive = false;
        }
        msg.sender.transfer(amount);
    }
    
    
    function getMaturityDays(uint amount) pure internal  returns (uint) {
        uint _days = 20;
        if(amount == 1 ether){
            _days = 22;
        }else if(amount == 10 ether){
            _days = 25;
        }
        return _days;
    }
    
    function getAvailableIncome(uint _userId, uint _entryId) view public returns (uint AvailableBalance) { 
        RegInfo storage _regInfo =  RegistrationInfo[_userId][_entryId];
        if(_regInfo.isActive){
            
            uint _totalDays = (now - _regInfo.startDate).div(60).div(60).div(24);
            if(_totalDays > _regInfo.maturityDays){
                _totalDays = _regInfo.maturityDays;
            }
            uint _dailyIncome = _regInfo.amount.mul(10).div(100);
            uint _totalIncome = _dailyIncome.mul(_totalDays);
            uint _balance = _totalIncome.sub(_regInfo.withdrawnAmount);
            return _balance;
        }
        
        return 0;
    }
    
    function getGrowthDays(uint _userId, uint _entryId) view public returns (uint TotalDays) { 
        RegInfo storage _regInfo =  RegistrationInfo[_userId][_entryId];
        if(_regInfo.isActive){
            
            uint _totalDays = (now - _regInfo.startDate).div(60).div(60).div(24);
            if(_totalDays > _regInfo.maturityDays){
                _totalDays = _regInfo.maturityDays;
            }
            
            return _totalDays;
        }
        
        return 0;
    }
    
    function getUserId(address _address) view public returns (uint UserId) { 
        return (memberInfos[_address].userID);
    }
    function getEntriesId(address _address) view public returns (uint[] Entries) { 
        return (memberInfos[_address].entriesId);
    }
    
    function getUpline(address _address) view public returns (address UplineAddress) { 
        return (memberInfos[_address].referrer);
    }
    
    function getEntryDetails(uint userId, uint entryId) view public returns (bool isActive, uint amountEntry, uint expectedIncome, uint dateStarted, uint maturityDays,  uint withdrawnAmount) {
        RegInfo storage _regInfo = RegistrationInfo[userId][entryId];
        return (_regInfo.isActive, _regInfo.amount, _regInfo.totalIncome, _regInfo.startDate,  _regInfo.maturityDays, _regInfo.withdrawnAmount);
    }
    
    function getAllReferrals(address _address) view public returns (address[] Referrals) {
        return (memberInfos[_address].referrals);
    }

}

library SafeMath {
  function mul(uint256 a, uint256 b) pure internal  returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
 
  function div(uint256 a, uint256 b) pure internal  returns (uint256) {
    uint256 c = a / b;
    return c;
  }
 
  function sub(uint256 a, uint256 b) pure internal  returns (uint256) {
    assert(b <= a);
    return a - b;
  }
 
  function add(uint256 a, uint256 b) pure internal  returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}