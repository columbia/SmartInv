pragma solidity ^0.4.23;
/*
 *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐
 *             ║ ║├┤ ├┤ ││  │├─┤│   │ KOL Community Foundation│ │ ║║║├┤ ├┴┐╚═╗│ │ ├┤
 *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬─────────────────────┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘
 *   ┌────────────────────────────────┘                     └──────────────────────────────┐
 *   │    ┌─────────────────────────────────────────────────────────────────────────────┐  │
 *   └────┤ Dev:Jack Koe ├─────────────┤ Special for: KOL  ├───────────────┤ 20200513   ├──┘
 *        └─────────────────────────────────────────────────────────────────────────────┘
 */

 library SafeMath {
   function mul(uint a, uint b) internal pure  returns (uint) {
     uint c = a * b;
     require(a == 0 || c / a == b);
     return c;
   }
   function div(uint a, uint b) internal pure returns (uint) {
     require(b > 0);
     uint c = a / b;
     require(a == b * c + a % b);
     return c;
   }
   function sub(uint a, uint b) internal pure returns (uint) {
     require(b <= a);
     return a - b;
   }
   function add(uint a, uint b) internal pure returns (uint) {
     uint c = a + b;
     require(c >= a);
     return c;
   }
   function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
     return a >= b ? a : b;
   }
   function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
     return a < b ? a : b;
   }
   function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
     return a >= b ? a : b;
   }
   function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
     return a < b ? a : b;
   }
 }

 /**
  * title KOL Promotion contract
  * dev visit: https://github.com/jackoelv/KOL/
 */

 contract ERC20Basic {
   uint public totalSupply;
   function balanceOf(address who) public constant returns (uint);
   function transfer(address to, uint value) public;
   event Transfer(address indexed from, address indexed to, uint value);
 }

 contract ERC20 is ERC20Basic {
   function allowance(address owner, address spender) public constant returns (uint);
   function transferFrom(address from, address to, uint value) public;
   function approve(address spender, uint value) public;
   event Approval(address indexed owner, address indexed spender, uint value);
 }

 /**
  * title KOL Promotion contract
  * dev visit: https://github.com/jackoelv/KOL/
 */

 contract BasicToken is ERC20Basic {

   using SafeMath for uint;

   mapping(address => uint) balances;

   function transfer(address _to, uint _value) public{
     balances[msg.sender] = balances[msg.sender].sub(_value);
     balances[_to] = balances[_to].add(_value);
     emit Transfer(msg.sender, _to, _value);
   }

   function balanceOf(address _owner) public constant returns (uint balance) {
     return balances[_owner];
   }
 }

 /**
  * title KOL Promotion contract
  * dev visit: https://github.com/jackoelv/KOL/
 */

 contract StandardToken is BasicToken, ERC20 {
   mapping (address => mapping (address => uint)) allowed;
   uint256 public userSupplyed;

   function transferFrom(address _from, address _to, uint _value) public {
     balances[_to] = balances[_to].add(_value);
     balances[_from] = balances[_from].sub(_value);
     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
     emit Transfer(_from, _to, _value);
   }

   function approve(address _spender, uint _value) public{
     require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
     allowed[msg.sender][_spender] = _value;
     emit Approval(msg.sender, _spender, _value);
   }

   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
     return allowed[_owner][_spender];
   }
 }
 contract KOL is StandardToken {
 }

 /**
  * title KOL Promotion contract
  * dev visit: https://github.com/jackoelv/KOL/
 */

 contract Ownable {
     address public owner;

     constructor() public{
         owner = msg.sender;
     }

     modifier onlyOwner {
         require(msg.sender == owner);
         _;
     }
     function transferOwnership(address newOwner) onlyOwner public{
         if (newOwner != address(0)) {
             owner = newOwner;
         }
     }
 }
 /**
  * title KOL Promotion contract
  * dev visit: https://github.com/jackoelv/KOL/
 */
contract KOLPro is Ownable{
  using SafeMath for uint256;
  string public name = "KOL Promotion";
  KOL public kol;
  address public draw;
  address private receiver;

  uint256 public begin;
  uint256 public end;

  uint256 public iCode;
  uint256 public every = 1 days;
  uint256 public totalRegister;
  uint256 public totalBalance;

  uint8 public  userLevel1 = 20;
  uint8 public  userLevel2 = 10;
  uint8 public maxlevel = 9;

  uint16 public  comLevel1Users = 100;
  uint16 public  comLevel2Users = 200;
  uint16 public  comLevel3Users = 300;

  uint256 public  comLevel1Amount = 30000 * (10 ** 18);
  uint256 public  comLevel2Amount = 50000 * (10 ** 18);
  uint256 public  comLevel3Amount = 100000 * (10 ** 18);

  uint8 public constant comLevel1 = 3;
  uint8 public constant comLevel2 = 5;
  uint8 public constant comLevel3 = 10;
  uint8 public constant inviteLevel1 = 2;
  uint8 public constant inviteLevel2 = 3;
  uint8 public constant inviteLevel3 = 5;


  uint8 public constant fee = 5;
  bool public going = true;


  struct lock{
    uint256 begin;
    uint256 amount;
    uint256 end;
    bool withDrawed;
  }

  struct teamRate{
    uint8 rate;
    uint256 changeTime;

  }

  struct dayTeamBonus{
    uint256 theDayLastSecond;
    uint256 theDayTeamBonus;
    uint256 totalTeamBonus;
    uint8 theDayRate;
  }
  struct dayInviteBonus{
    uint256 theDayLastSecond;
    uint256 theDayInviteBonus;
    uint256 totalInviteBonus;
  }



  mapping (address => dayTeamBonus[]) public LockTeamBonus;
  mapping (address => dayInviteBonus[]) public LockInviteBonus;


  mapping (address => address[]) public InviteList;
  mapping (address => address[]) public ChildAddrs;
  mapping (address => teamRate[]) public TeamRateList;
  mapping (address => lock[]) public LockHistory;
  mapping (address => uint256) public LockBalance;

  mapping (uint256 => uint256) public ClosePrice;
  mapping (address => uint256) public TotalUsers;
  mapping (address => uint256) public TotalLockingAmount;
  mapping (uint256 => address) public InviteCode;
  mapping (address => uint256) public RInviteCode;

  mapping (address => uint8) public isLevelN;
  mapping (uint8 => uint8) public levelRate;
  mapping (address => bool) public USDTOrCoin;

  //GAS优化

  event Registed(address _user,uint256 inviteCode);
  event Joined(address _user,uint256 _theTime,uint256 _amount,bool _usdtOrCoin);
  event GradeChanged(address _user,uint8 _oldLevel,uint8 _newLevel);

  modifier onlyContract {
      require(msg.sender == draw);
      _;
  }
  constructor(address _tokenAddress,address _receiver,uint256 _begin,uint256 _end) public {
    kol = KOL(_tokenAddress);
    receiver = _receiver;
    begin = _begin;
    end = _end;
    InviteCode[0] = owner;
    levelRate[0] = 0;
    levelRate[1] = comLevel1;
    levelRate[2] = comLevel2;
    levelRate[3] = comLevel3;
  }

  function register(uint256 _fInviteCode) public {
    require(going);
    require(now <= end);
    require(RInviteCode[msg.sender] == 0);
    uint256 random = uint256(keccak256(now, msg.sender)) % 100;
    uint256 _myInviteCode = iCode.add(random);
    iCode = iCode.add(random);

    require(InviteCode[_myInviteCode] == address(0));
    require(InviteCode[_fInviteCode] != address(0));
    InviteCode[_myInviteCode] = msg.sender;
    RInviteCode[msg.sender] = _myInviteCode;
    emit Registed(msg.sender,iCode);
    totalRegister ++;
    address father = InviteCode[_fInviteCode];
    ChildAddrs[father].push(msg.sender);
    if (InviteList[msg.sender].length < 9){
      InviteList[msg.sender].push(father);
    }
    for (uint i = 0 ; i < InviteList[father].length; i++){
      if (InviteList[msg.sender].length < 9){
        InviteList[msg.sender].push(InviteList[father][i]);
      }else{
        break;
      }

    }

  }
  /**
   * title 转入KOL进行持仓生息
   * _usdtOrCoin, true:金本位; false:币本位
   * dev visit: https://github.com/jackoelv/KOL/
  */
  function join(uint256 _amount,bool _usdtOrCoin) payable  public {
    require(going);
    require(now <= end);
    if (LockBalance[msg.sender] == 0) USDTOrCoin[msg.sender] = _usdtOrCoin;
    kol.transferFrom(msg.sender,draw,_amount);
    LockHistory[msg.sender].push(lock(now,_amount,0,false));
    uint256 oldBalance = LockBalance[msg.sender];
    LockBalance[msg.sender] = LockBalance[msg.sender].add(_amount);
    totalBalance = totalBalance.add(_amount);
    emit Joined(msg.sender,now,_amount,_usdtOrCoin);

    uint256 amount3;//amount*3/1000以后

    for (uint i = 0; i<InviteList[msg.sender].length; i++){
      if (i == maxlevel) break;
      if (LockHistory[msg.sender].length == 1){
        //给上面的人数+1
        TotalUsers[InviteList[msg.sender][i]] += 1;
      }else{
        if (oldBalance == 0) TotalUsers[InviteList[msg.sender][i]] += 1;
      }
      //给上面的加入团队总金额

      TotalLockingAmount[InviteList[msg.sender][i]] = TotalLockingAmount[InviteList[msg.sender][i]].add(_amount);
      queryAndSetLevelN(InviteList[msg.sender][i]);

      amount3 = calcuDiffAmount(msg.sender,InviteList[msg.sender][i],_amount);


      if (i<2){
        setTopInviteBonus(InviteList[msg.sender][i],amount3,i);
      }

      if (i < maxlevel){
        setTopTeamBonus(InviteList[msg.sender][i],amount3);
      }
    }
  }
  function calcuDiffAmount(address _selfAddr,address _topAddr,uint256 _amount) public view returns(uint256){
    //计算网体收益加速额。
    uint256 topDayLockBalance = queryLockBalance(_topAddr,now);
    uint256 selfDayLockBalance = queryLockBalance(_selfAddr,now);
    uint256 minAmount;

    if (topDayLockBalance >= selfDayLockBalance){
      minAmount = _amount;
    }else{
        if(LockHistory[_selfAddr].length > 1){
            uint256 previous = LockHistory[_selfAddr].length - 2;
            uint256 theTime = LockHistory[_selfAddr][previous].begin;
            uint256 previousLockBalance = queryLockBalance(_selfAddr,theTime);
            if (topDayLockBalance > previousLockBalance){
              //_amount + previousLockBalance 一定是大于topDayLockBalance的；
              minAmount = topDayLockBalance - previousLockBalance;
            }
        }else{
          minAmount = topDayLockBalance;
        }
    }
    return minAmount.mul(3).div(1000);
  }
  function setTopTeamBonus(address _topAddr,uint256 _minAmount) private {
    uint8 newRate = levelRate[isLevelN[_topAddr]];
    dayTeamBonus memory theDayTB =dayTeamBonus(0,0,0,0);
    uint256 tomorrowLastSecond =getYestodayLastSecond(now) +  every;

    if (LockTeamBonus[_topAddr].length == 0){
      theDayTB.theDayLastSecond = tomorrowLastSecond;
      theDayTB.theDayTeamBonus = _minAmount;
      theDayTB.totalTeamBonus = _minAmount * newRate / 100;
      theDayTB.theDayRate = newRate;
      LockTeamBonus[_topAddr].push(theDayTB);
    }else{
      uint256 last = LockTeamBonus[_topAddr].length -1;
      theDayTB = LockTeamBonus[_topAddr][last];

      uint256 lastingDays = (tomorrowLastSecond - theDayTB.theDayLastSecond) / every;

      theDayTB.totalTeamBonus = lastingDays * theDayTB.theDayTeamBonus * theDayTB.theDayRate/100;//这里不好解决啊
      theDayTB.totalTeamBonus += _minAmount * newRate / 100;
      theDayTB.theDayTeamBonus += _minAmount;
      theDayTB.theDayRate = newRate;
        //必然就都是明天。
      if(theDayTB.theDayLastSecond < tomorrowLastSecond){
        theDayTB.theDayLastSecond = tomorrowLastSecond;
        LockTeamBonus[_topAddr].push(theDayTB);
      }else{
        LockTeamBonus[_topAddr][last]=theDayTB;
      }
    }
  }
  function setTopInviteBonus(address _topAddr,uint256 _minAmount,uint256 _index) private {
    uint8 inviteRate;
    if (_index == 0){
      inviteRate = userLevel1;
    }else if(_index ==1){
      inviteRate = userLevel2;
    }else{
      return;
    }
    uint256 tomorrowLastSecond = getYestodayLastSecond(now) + every;
    if (LockInviteBonus[_topAddr].length == 0){
      LockInviteBonus[_topAddr].push(dayInviteBonus(tomorrowLastSecond,
                                            _minAmount * inviteRate/100,
                                            _minAmount * inviteRate/100));
    }else{
      uint256 last = LockInviteBonus[_topAddr].length -1;

      uint256 lastDayLastSecond = LockInviteBonus[_topAddr][last].theDayLastSecond;
      uint256 lastDayInviteBonus = LockInviteBonus[_topAddr][last].theDayInviteBonus;
      uint256 lastDayInviteTotalBonus = LockInviteBonus[_topAddr][last].totalInviteBonus;

      uint256 lastingDays = (tomorrowLastSecond - lastDayLastSecond) / every;
      uint256 newDayInviteBonus = _minAmount* inviteRate / 100 + lastDayInviteBonus;
      uint256 newDayInviteTotalBonus = (lastingDays * lastDayInviteBonus) + _minAmount * inviteRate /100 + lastDayInviteTotalBonus;
        //必然就都是明天。
      if(lastDayLastSecond < tomorrowLastSecond){
        LockInviteBonus[_topAddr].push(dayInviteBonus(tomorrowLastSecond,
                                              newDayInviteBonus,
                                              newDayInviteTotalBonus));
      }else{
        LockInviteBonus[_topAddr][last].theDayInviteBonus = newDayInviteBonus;
        LockInviteBonus[_topAddr][last].totalInviteBonus = newDayInviteTotalBonus;
      }

    }
  }
  /**
   * title 查询并设置用户的身份级别
   * dev visit: https://github.com/jackoelv/KOL/
  */
  function queryAndSetLevelN(address _addr) private{
    if ((TotalUsers[_addr] >= comLevel3Users) &&
              (TotalLockingAmount[_addr] >= comLevel3Amount) &&
              ChildAddrs[_addr].length>=inviteLevel3){
      if (isLevelN[_addr]!=3){
        emit GradeChanged(_addr,isLevelN[_addr],3);
        isLevelN[_addr] = 3;
        TeamRateList[_addr].push(teamRate(3,now));
      }
    }else if((TotalUsers[_addr] >= comLevel2Users) &&
              (TotalLockingAmount[_addr] >= comLevel2Amount) &&
              ChildAddrs[_addr].length>=inviteLevel2){
      if (isLevelN[_addr]!=2){
        emit GradeChanged(_addr,isLevelN[_addr],2);
        isLevelN[_addr] = 2;
        TeamRateList[_addr].push(teamRate(2,now));
      }
    }else if((TotalUsers[_addr] >= comLevel1Users) &&
              (TotalLockingAmount[_addr] >= comLevel1Amount) &&
              ChildAddrs[_addr].length>=inviteLevel1){
      if (isLevelN[_addr]!=1){
        emit GradeChanged(_addr,isLevelN[_addr],1);
        isLevelN[_addr] = 1;
        TeamRateList[_addr].push(teamRate(1,now));
      }
    }else{
      if (isLevelN[_addr]!=0){
        emit GradeChanged(_addr,isLevelN[_addr],0);
        isLevelN[_addr] = 0;
        TeamRateList[_addr].push(teamRate(0,now));
      }
    }
  }

  /**
   * title 查询指定时间用户的有效锁仓余额
   * dev visit: https://github.com/jackoelv/KOL/
  */
  function queryLockBalance(address _addr,uint256 _queryTime) public view returns(uint256) {
    require(_queryTime <= end);
    uint256 dayLockBalance;
    for (uint j = 0; j<LockHistory[_addr].length; j++){
      if (LockHistory[_addr][j].withDrawed){
        //如果是已经提现的资金，那就要求计算日期是在起止时间内的。
        if ((_queryTime >= LockHistory[_addr][j].begin) && (_queryTime <= LockHistory[_addr][j].end)){
            dayLockBalance += LockHistory[_addr][j].amount;
        }
      }else{
        if (_queryTime >= LockHistory[_addr][j].begin ){
          //这个就要计入到当天的收益
          dayLockBalance += LockHistory[_addr][j].amount;
        }
      }
    }
    return dayLockBalance;
  }

  /**
   * title 根据给定时间计算出昨天的最后一秒
   * dev visit: https://github.com/jackoelv/KOL/
  */
  function getYestodayLastSecond(uint256 _queryTime) public view returns(uint256){
    require(_queryTime <= (end + every));
    return (_queryTime.sub(_queryTime.sub(begin) % every) - 1);
  }


  function clearLock(address _addr) onlyContract public{
    for (uint i =0;i<LockHistory[_addr].length;i++){
      LockHistory[_addr][i].end = now;
      LockHistory[_addr][i].withDrawed = true;
    }
    LockBalance[_addr] = 0;
  }
  function pushInvite(address _addr,
                      uint256 _theDayLastSecond,
                      uint256 _theDayInviteBonus,
                      uint256 _totalInviteBonus) onlyContract public{
    LockInviteBonus[_addr].push(dayInviteBonus(_theDayLastSecond,
                                              _theDayInviteBonus,
                                              _totalInviteBonus));
  }
  function setLastInvite(address _addr,
                      uint256 _theDayInviteBonus,
                      uint256 _totalInviteBonus) onlyContract public{
    require(LockInviteBonus[_addr].length > 0);
    uint256 last = LockInviteBonus[_addr].length -1;
    LockInviteBonus[_addr][last].theDayInviteBonus = _theDayInviteBonus;
    LockInviteBonus[_addr][last].totalInviteBonus = _totalInviteBonus;
  }
  function pushTeam(address _addr,
                      uint256 _theDayLastSecond,
                      uint256 _theDayTeamBonus,
                      uint256 _totalTeamBonus,
                      uint8 _theDayRate) onlyContract public{
    LockTeamBonus[_addr].push(dayTeamBonus(_theDayLastSecond,
                                              _theDayTeamBonus,
                                              _totalTeamBonus,
                                              _theDayRate));
  }
  function setLastTeam(address _addr,
                      uint256 _theDayTeamBonus,
                      uint256 _totalTeamBonus,
                      uint8 _theDayRate) onlyContract public{
    require(LockTeamBonus[_addr].length > 0);
    uint256 last = LockTeamBonus[_addr].length - 1;
    LockTeamBonus[_addr][last].theDayTeamBonus = _theDayTeamBonus;
    LockTeamBonus[_addr][last].totalTeamBonus = _totalTeamBonus;
    LockTeamBonus[_addr][last].theDayRate = _theDayRate;

  }
  function subTotalUsers(address _addr) onlyContract public{
    TotalUsers[_addr] = TotalUsers[_addr].sub(1);
  }
  function subTotalLockingAmount(address _addr,uint256 _amount) onlyContract public{
    TotalLockingAmount[_addr] = TotalLockingAmount[_addr].sub(_amount);
  }
  function subTotalBalance(uint256 _amount) onlyContract public{
    totalBalance=totalBalance.sub(_amount);
  }
  function qsLevel(address _addr) onlyContract public{
    queryAndSetLevelN(_addr);
  }
  function setInviteTeam(address _addr) onlyContract public{
    uint256 yestodayLastSecond = getYestodayLastSecond(now);
    uint256 last;
    if (LockInviteBonus[_addr].length > 0){
      last = LockInviteBonus[_addr].length - 1;
      LockInviteBonus[_addr][last].theDayInviteBonus = 0;
      LockInviteBonus[_addr][last].totalInviteBonus = 0;
    }
    if (LockInviteBonus[_addr].length > 0){
      last = LockTeamBonus[_addr].length - 1;
      LockTeamBonus[_addr][last].theDayTeamBonus = 0;
      LockTeamBonus[_addr][last].totalTeamBonus = 0;
      LockTeamBonus[_addr][last].theDayRate = 0;
    }
  }
  /**
   * title 录入KOL的收盘价
   * dev visit: https://github.com/jackoelv/KOL/
  */
  function putClosePrice(uint256 price,uint256 _queryTime) onlyOwner public{
    //录入的价格为4位小数
    require(_queryTime <= (end + 2*every));
    uint256 yestodayLastSecond = getYestodayLastSecond(_queryTime);
    ClosePrice[yestodayLastSecond] = price;
  }

  function setReceiver(address _receiver) onlyOwner public{
    receiver = _receiver;
  }
  function draw() onlyOwner public{
    receiver.send(address(this).balance);
  }
  function setContract(address _addr) onlyOwner public{
    draw = _addr;
  }
  function setGoing(bool _going) onlyOwner public{
    going = _going;
  }
  function setEnd(uint256 _end) onlyOwner public{
    end = _end;
  }

  function getLockLen(address _addr) public view returns(uint256) {
    return(LockHistory[_addr].length);
  }
  function getFathersLength(address _addr) public view returns(uint256){
    return InviteList[_addr].length;
  }
  function getLockTeamBonusLen(address _addr) public view returns(uint256){
    return(LockTeamBonus[_addr].length);
  }
  function getLockInviteBonusLen(address _addr) public view returns(uint256){
    return(LockInviteBonus[_addr].length);
  }
  function getChildsLen(address _addr) public view returns(uint256){
  return(ChildAddrs[_addr].length);
  }

}