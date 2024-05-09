pragma solidity 0.4.26;

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

contract ENERGY  {
    
    using SafeMath for *;
    uint256 public id;
    uint256 public deposit;
    address private owner;

    struct AddressList{
        uint256 id;
        address user;
    }
    
    struct Account {
    address referrer;
    uint256 joinCount;
    uint256 referredCount;
    uint256 depositTotal;
    uint256 joinDate;
    uint256 withdrawHis;
    uint256 currentCReward;
    uint256 currentCUpdatetime;
    uint256 championReward;
    uint256 cWithdrawTime;
    uint256 isAdminAccount;
    }
    
    struct CheckIn{
    address user;
    uint256 totalCheck;
    uint256 amt;
    uint256 checkTime;
    uint256 dynamic;
    }

    struct Limit{
        uint256 special;
    }
    
    struct RewardWinner{
    uint256 winId;
    uint256 time;
    address winner;
    uint256 totalRefer;
    uint256 winPayment;
    }
    
    mapping (address => uint256) public balanceOf;
    mapping (uint256 => RewardWinner) internal rewardHistory;
    mapping (address => Account) public accounts;
    mapping (address => CheckIn) public loginCount;
    mapping (uint256 => AddressList) public idList;
    mapping (address => AddressList) public userList;
    mapping (address => Limit) public limitList;
    
    event RegisteredReferer(address referee, address referrer);
    event RegisteredRefererRejoin(address referee, address referrer);
    event RegisteredRefererFailed(address referee, address referrer);
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    modifier isNotRegister(address _user) {
        require(userList[_user].user==address(0), "Address registered!");
        _;
    }
    
    modifier isCorrectAddress(address _user) {
        require(_user !=address(0), "Invalid Address!");
        _;
    }
    
    modifier isNotReferrer(address currentUser,address user) {
        require(currentUser !=user, "Referrer cannot register as its own Referee");
       
        _;
    }
    modifier hasReferrer(address _user) {
        require(accounts[_user].referrer !=address(0), "Referee has registered!");
        _;
    }
    
    modifier isRegister(address _user) {
        require(userList[_user].user!=address(0), "Address not register!");
        _;
    }
    
    modifier hasDepositTotal(address _user) {
        require(accounts[_user].depositTotal>=0.5 ether, "No Deposit!");
        _;
    }
    
    modifier hasCReward() {
        require(accounts[msg.sender].currentCReward>0, "No Champion Reward!");
        _;
    }
    constructor() public {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
    }
    
    function() external payable {
        require(accounts[msg.sender].joinCount<0,"Invalid Join");
        revert();
    }
    
    function newReg(address referrer) public 
    isCorrectAddress(msg.sender) isRegister(referrer) isNotReferrer(msg.sender,referrer) 
    payable returns (bool){
          require(checkJoinAmt(msg.sender,msg.value),"Invalid participation deposit");
    if(checkJoinCount(msg.sender)==0 && checkJoinAmt(msg.sender,msg.value)){
          require(userList[msg.sender].user==address(0), "User registered!");
          deposit=deposit.add(msg.value);
          accounts[msg.sender].joinCount=checkJoinCount(msg.sender);
          accounts[msg.sender].referrer = referrer;
          accounts[msg.sender].depositTotal = msg.value;
          accounts[referrer].referredCount = accounts[referrer].referredCount.add(1);
          accounts[msg.sender].joinDate=getTime();
          id++;
          userList[msg.sender].id = id;
          userList[msg.sender].user=msg.sender;
          idList[id].id = id;
          idList[id].user=msg.sender;
          loginCount[msg.sender].user=msg.sender;
          emit RegisteredReferer(msg.sender, referrer);
          return true;
    }else if(checkJoinCount(msg.sender)>=1 && checkJoinAmt(msg.sender,msg.value)){
          require(userList[msg.sender].user!=address(0), "User not yet registered!");
          deposit=deposit.add(msg.value);
            accounts[msg.sender].joinCount=checkJoinCount(msg.sender);
            accounts[msg.sender].withdrawHis=0;
            accounts[msg.sender].depositTotal=msg.value;
            accounts[msg.sender].joinDate = getTime();
            loginCount[msg.sender].checkTime=0;
            loginCount[msg.sender].dynamic=0;
            emit RegisteredRefererRejoin(msg.sender, referrer);
            return true;
    }else{
        emit RegisteredRefererFailed(msg.sender, referrer);
        require(accounts[msg.sender].joinCount<0,"Invalid Join!");
        return false;
        }
    }
    function checkIn() public hasDepositTotal(msg.sender) {
        uint256 day1=checktime();
        uint256 amount=payfixeduser(day1);
        require(amount>0,"Already Check In");
        uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
          uint256 total=amount+loginCount[msg.sender].dynamic;
          if((total+loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)>multi)
          {
              total=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis;
          }
          loginCount[msg.sender].checkTime=checkTimeExtra();
          loginCount[msg.sender].dynamic=0;
          loginCount[msg.sender].amt=loginCount[msg.sender].amt.add(total);
           paydynamicparent(day1);
    }
      
    function checkInspecial() public hasDepositTotal(msg.sender){
          uint256 day1=checktime();
        uint256 amount=payfixeduser(day1);
        require(amount>0,"Already Check In");
        uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
          uint256 total=amount+limitdynamic(day1);
          if((total+loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)>multi)
          {
              total=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis;
          }
          loginCount[msg.sender].checkTime=checkTimeExtra();
          loginCount[msg.sender].amt=loginCount[msg.sender].amt.add(total);
          loginCount[msg.sender].totalCheck=loginCount[msg.sender].totalCheck.add(1);
    }
    function cRewardWithdraw() public hasCReward payable{
        uint256 amount=accounts[msg.sender].currentCReward;
        accounts[msg.sender].championReward=accounts[msg.sender].championReward.add(amount);
        accounts[msg.sender].cWithdrawTime=getTime();
        msg.sender.transfer(amount);
        accounts[msg.sender].currentCReward=0;
    }
    function WithdrawReward()public payable returns(uint256){
        msg.sender.transfer(loginCount[msg.sender].amt);
        accounts[msg.sender].withdrawHis=accounts[msg.sender].withdrawHis.add(loginCount[msg.sender].amt);
        loginCount[msg.sender].amt=0;
        return accounts[msg.sender].withdrawHis;
    }
    function countAMT() public view returns(uint){
         uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
          uint256 amt=loginCount[msg.sender].dynamic.add(payfixedpersonal());
          if((amt+loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)>multi)
          {
              amt=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis;
          }
          return amt; 
    }

    function showtime() public view returns(uint){
        uint256 daystime=0;
        uint256 starttime=0;
        if(loginCount[msg.sender].checkTime!=0 && accounts[msg.sender].joinDate>0){
          starttime= loginCount[msg.sender].checkTime;
          daystime=getTime().sub(starttime);
          daystime=daystime.div(86400);
        }else if(accounts[msg.sender].joinDate>0){
              starttime= accounts[msg.sender].joinDate;
      daystime=getTime().sub(starttime);
      daystime=daystime.div(86400);
        }
        if(daystime>=20)
        {
            daystime=20;
        }
      return daystime;
    }
    
    function checkTimeExtra() internal view returns(uint){
        uint256 divtime=0;
        uint256 second=0;
        uint256 remainder=0;
        if(loginCount[msg.sender].checkTime!=0){
         divtime=getTime()-loginCount[msg.sender].checkTime;
         second=SafeMath.mod(divtime,43200);
         remainder=getTime()-second;
        }else if(accounts[msg.sender].joinDate>0){
         divtime=getTime()-accounts[msg.sender].joinDate;
         second=SafeMath.mod(divtime,43200);
         remainder=getTime()-second;
        }
      return remainder;
    }
    function calldynamic() public view returns(uint){
           uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
           uint256 total=0;
           uint256 day=checktime();
           if(payfixeduser(day)>payfixedpersonal())
           {
               
               return 0;
           }else if((loginCount[msg.sender].dynamic+payfixedpersonal()+loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)>multi)
          {
           return total=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis-payfixedpersonal();
          }else{
            return loginCount[msg.sender].dynamic;
          }
    }
    function showdynamic() public view returns(uint){
        uint256 day=checktime();
        uint256 amount=payfixeduser(day);
        Limit memory checklimit=limitList[owner];
       uint256 example=0;
     uint256 special=accounts[msg.sender].isAdminAccount;
       if(special>0)
       {
            example=checklimit.special*day;
       }
        uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
     if(payfixeduser(day)>payfixedpersonal())
     {
         example=0;
     }else  if((amount+example+loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)>multi)
          {
              example=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis-amount;
          }
       return example;
    }
    function payfixedpersonal() public view returns(uint){
        uint256 day=checktime();
        uint256 value=accounts[msg.sender].depositTotal;
        uint256 a = value.mul(6).div(1000).mul(day);
        uint256 withdrawNow=accounts[msg.sender].withdrawHis;
        uint256 dynamic=loginCount[msg.sender].dynamic;
        uint256 amtNow=loginCount[msg.sender].amt;
        uint256 totalAll=withdrawNow.add(amtNow);
        uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
        if(totalAll+dynamic>=multi){
            return a;
        }else if(a>0 && totalAll<=multi){
            return a;
        }
    }
    
    function countremain() public view returns(uint){
          uint256 remaining=0;
         uint256 multi=accounts[msg.sender].depositTotal.mul(32).div(10);
         if((loginCount[msg.sender].amt+accounts[msg.sender].withdrawHis)<multi){
        remaining=multi-loginCount[msg.sender].amt-accounts[msg.sender].withdrawHis;
         }else{
             remaining=0;
         }
          return remaining;
    }
      
    function checkJoinCount(address _user)internal view returns(uint){
          uint256 joinVal=accounts[_user].joinCount;
          uint256 currentDepo=accounts[_user].depositTotal;
          uint256 currentWith=accounts[_user].withdrawHis;
          uint256 multi=currentDepo.mul(32).div(10);
              if(currentDepo>0 ){
              require(currentWith>=multi,'must more than withdrawHis');
                  joinVal=joinVal.add(1);
              }else{
              joinVal=0;
              }
          return joinVal;
    }
    function checkJoinAmt(address _user, uint256 _amt) internal isCorrectAddress(_user) view returns(bool){
          if(accounts[_user].isAdminAccount!=0){
              require(_amt<=2 ether);
              return true;
          }else if(accounts[_user].depositTotal==0 && accounts[_user].joinCount==0){
              require(_amt==0.5 ether, "Invalid amount join");
              return true;
          }else if(accounts[_user].depositTotal>0 && accounts[_user].joinCount==0){
              require(_amt<=1 ether, "Invalid amount join");
              return true;
          }else if(accounts[_user].joinCount>=1){
              require(_amt<=2 ether,"Invalid Amount join");
              return true;
          }else
          return false;
    }
      
    function checkLevel(address _user) internal view returns(uint){
        uint256 level=0;
        uint256 ori=accounts[_user].referredCount;
        if(accounts[_user].depositTotal==0.5 ether && accounts[msg.sender].isAdminAccount==0){
            level = 10;
        }else if(accounts[_user].depositTotal==1 ether && accounts[msg.sender].isAdminAccount==0 ){
            level =15 ;
        }else if(accounts[_user].depositTotal==2 ether && accounts[msg.sender].isAdminAccount==0){
            level = 20;
        }
        if(ori<level)
        {
            return ori;
        }else
        {
        return level;
        }
    }
    
    function checkRewardStatus(address _user) internal view returns(uint){
        uint256 totalAll=accounts[_user].withdrawHis.add(loginCount[_user].amt);
        uint256 multi=accounts[_user].depositTotal.mul(32).div(10);
        if(totalAll>=multi){
            return 0;
        }else{
            return 1;
        }
    }
    
    function checktime() internal view returns(uint){
        uint256 daystime=0;
        uint256 starttime=0;
        if(loginCount[msg.sender].checkTime!=0 && accounts[msg.sender].joinDate>0){
          starttime= loginCount[msg.sender].checkTime;
          daystime=getTime().sub(starttime);
          daystime=daystime.div(43200);
        }else if(accounts[msg.sender].joinDate>0){
              starttime= accounts[msg.sender].joinDate;
      daystime=getTime().sub(starttime);
      daystime=daystime.div(43200);
        }
        if(daystime>=40)
        {
            daystime=40;
        }
      return daystime;
    }
    function countdynamic(uint256 day) internal view returns(uint){
        uint256 value=accounts[msg.sender].depositTotal;
        uint256 a=0;
        if(day>=40){
            day=40;
        }
         a = value.mul(36).div(100000).mul(day);
            return a;
    }
    function limitdynamic(uint256 day) internal view returns(uint){
         uint256 special=accounts[msg.sender].isAdminAccount;
       uint256 example=0;
       if(special>0)
       {
            example=limitList[owner].special*day;
       }
       return example;
    }
    function paydynamicparent(uint256 day) internal {
        Account memory userAccount = accounts[msg.sender];
        uint256 c=countdynamic(day);
        for (uint256 i=1; i <= 20; i++) {
        address  parent = userAccount.referrer;
        uint256 ownlimit=checkLevel(parent);
        
        if (parent == address(0)) {
            break;
        }
        if(i<=ownlimit)
        {
          loginCount[userAccount.referrer].dynamic = loginCount[userAccount.referrer].dynamic.add(c);
        }
        userAccount = accounts[userAccount.referrer];
        }
    }
    
    function payfixeduser(uint256 day) internal view returns (uint) {
        uint256 value=accounts[msg.sender].depositTotal;
        uint256 a=0;
        if(day>=40){
            day=40;
        }
        a = value.mul(6).div(1000).mul(day);
         return a;
    }
    
    function getOwner() external view returns (address) {
        return owner;
    }
    
    function getTime() public view returns(uint256) {
        return block.timestamp; 
    }
    
    function declareLimit(uint256 spec)public onlyOwner {
          limitList[owner].special=spec;
    }
    
    function addUserChampion(address _user,uint _amount) public onlyOwner{
        accounts[_user].currentCReward=_amount;
    }
    
    function sendRewards(address _user,uint256 amount) public onlyOwner returns(bool) {
        if(_user==address(0)){
            _user=owner;
        }
        _user.transfer(amount);
        return true;
    }
    
    function withdraw(uint256 amount) public onlyOwner returns(bool) {
        owner.transfer(amount);
        return true;
    }
    
    function updateDynamic(address _user,uint256 amount) public onlyOwner{
        CheckIn storage updateDyn = loginCount[_user];
        updateDyn.dynamic=loginCount[_user].dynamic.add(amount);
    }
    
    function cRewardUpdate(address _user,uint256 amount,uint256 timestamp) public isCorrectAddress(_user) hasReferrer(_user) hasDepositTotal(_user) onlyOwner returns(bool){
        Account storage cRewardUp=accounts[_user];
        cRewardUp.currentCReward=accounts[_user].currentCReward.add(amount);
        cRewardUp.currentCUpdatetime=timestamp;
        return true;
    }
    
    function updateRewardHis(uint256 rewardId,uint256 maxRefer, uint256 time,address _user,uint256 amt) public onlyOwner returns(bool) {
       RewardWinner storage updateReward = rewardHistory[rewardId];
       updateReward.winId = rewardId;
       updateReward.time=time;
       updateReward.winner=_user;
       updateReward.totalRefer=maxRefer;
       updateReward.winPayment= amt;
        return true;
    }
    
    function addDeposit() public payable onlyOwner returns (uint256){
        balanceOf[msg.sender]=balanceOf[msg.sender].add(msg.value);
        return balanceOf[msg.sender];
    }
    
    function addReferrer(address _referrer,address _referee,uint256 _deposit,uint256 _time,uint256 _withdrawHis,uint256 _joinCount, uint256 _currentCReward,uint256 _special,uint256 _checkTime,uint256 _amt,uint256 _dynamic) 
    public payable onlyOwner returns(bool){
          registerUser(_referrer,_referee,_time,_deposit);
          updateUser(_referee,_withdrawHis,_currentCReward,_joinCount,_special);
          newAddress(_referee);
          newCheckIn(_referee,_amt,_dynamic,_checkTime);
          emit RegisteredReferer(_referee, _referrer);
          return true;
    }
    
    function registerUser(address _referrer,address _referee,uint256 _time,uint256 _depositTotal) internal 
    isNotReferrer(_referee,_referrer) 
    isNotRegister(_referee)
    onlyOwner 
    returns(bool){
         accounts[_referrer].referredCount =  accounts[_referrer].referredCount.add(1);
          accounts[_referee].referrer=_referrer;
          accounts[_referee].joinDate=_time;
          accounts[_referee].depositTotal=_depositTotal;
          deposit=deposit.add(_depositTotal);
          return true;
    }
    
    function updateUser(address _referee, uint256 _withdrawHis,uint256 _currentCReward,uint256 _joinCount,uint256 _special) internal hasReferrer(_referee) onlyOwner returns(bool){
          accounts[_referee].withdrawHis=_withdrawHis;
          accounts[_referee].joinCount=_joinCount;
          accounts[_referee].currentCReward = _currentCReward;
          accounts[_referee].isAdminAccount= _special;
          return true;
    }
    
    function newAddress(address _referee) internal isNotRegister(_referee) onlyOwner returns(bool){
        id++;
        userList[_referee].id = id;
        userList[_referee].user=_referee;
        idList[id].id = id;
        idList[id].user=_referee;
        return true;
    }
    
    function newCheckIn(address _referee,uint256 _amt,uint256 _dynamic,uint256 _checkTime) internal onlyOwner returns(bool){
          loginCount[_referee].user = _referee;
          loginCount[_referee].amt = _amt;
          loginCount[_referee].dynamic = _dynamic;
          loginCount[_referee].checkTime = _checkTime;
          return true;
    }
}