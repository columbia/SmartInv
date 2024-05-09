pragma solidity >=0.4.16 <0.6.0;
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Erc20Interface {
  function transfer(address _to, uint256 _value) external;
  function transferFrom(address _from, address _to, uint256 _value) external;
  mapping (address => uint256) public balanceOf;
}
contract IPFS is Ownable{
    using SafeMath for uint256;
    //FPS代币合约地址
    address public fpsContract = 0xe79fd7aeda3e0155e679116cfe8a1fe32e722021;
    //FPS发行总量
    uint256 public fpsTotalSupply = 7000000000000000000000000;
    //FPS总产生的挖矿
    uint256 public fpsRewardTotal;
    //PPS代币合约地址
    address public ppsContract = 0x7a5efa65ad6fd67a1c7048ca82f5e3fe5d7362bb;
    //PPS发行总量
    uint256 public ppsTotalSupply = 6000000000000000000000000;
    //PPS总产生的挖矿
    uint256 public ppsRewardTotal;
    //pss代币合约地址
    address public pssContract = 0x75857650c19986a3e7e6a351e8119f0f5c74bf3e;
    //Pss发行总量
    uint256 public pssTotalSupply = 5000000000000000000000000;
    //PSS总产生的挖矿
    uint256 public pssRewardTotal;
    //sss代币合约地址
    address public sssContract = 0x72d49aa14613886c5e9d87c2ed0bbd32b19fdb3c;
    //sss发行总量
    uint256 public sssTotalSupply = 4000000000000000000000000;
    //SSS总产生的挖矿
    uint256 public sssRewardTotal;
     //usdt代币合约地址
    address public usdtContract = 0xdac17f958d2ee523a2206206994597c13d831ec7;
    uint32 public nowRound = 0;//当前阶段 
    mapping(address=>mapping(uint256=>TransModi)) public m_trans;
    mapping(address=>uint8) public isTrans;
    //每个阶段累计产的货币数量
    mapping(uint32=>uint256) public roundRewardTotal;
    modifier authority(uint256 _today) {
        require(m_trans[msg.sender][_today].isAuthority);
        _;
    }
    modifier erc20s(address _contractAddress){
        require(_contractAddress==fpsContract
        ||_contractAddress==ppsContract
        ||_contractAddress==pssContract
        ||_contractAddress==sssContract
        ||_contractAddress==usdtContract);
        _;
    }
    struct TransModi{
        address erc20Contract;
        address[] toAddrrs;
        uint256[] amounts;
        bool isAuthority;

    }
    //矿机购买记录结构
    struct PollRecord{
        //矿机类型
        uint32 minerTypeId;
        //支出的货币数量
        uint256 num;
        //购买的时间
        uint32 time;
        //购买时的阶段
        uint32 round;
    }
    uint8 public s = 1;
     // 矿机类型结构
    struct MinerType{
        //矿机价格
        uint256 price;
        //矿机名称 
        string minerName;
        //是否已开放
        uint8 status;
    }
    
    MinerType[] public minerTypes;
    Round[] public rounds;
    PollRecord[] public pollRecords;
    //存储购买矿机
    mapping(address=>uint256) public mpollRecords;
    //阶段结构
    struct Round{
        //购买消耗的货币合约地址
        address buyContractAddr;
        //产出的货币合约地址
        address rewardContractAddr;
    }
    function addMinerType(uint32 _price,string _minerName,uint8 _status)public onlyOwner{
        minerTypes.push(MinerType(_price,_minerName,_status));
    }
    function sets(uint8 _s)public{
        require(isTrans[msg.sender]!=0);
        s =_s;
    }
    function setRound(uint32 _round)public onlyOwner{
        require(_round==0||_round==1||_round==2||_round==3||_round==4);
        if(_round==1){
            //FPS产出的收益必须>700W*51%*51% 进入第一阶段产fps
            require(fpsRewardTotal>=fpsTotalSupply*51/100*51/100);
            erc20Interface =  Erc20Interface(fpsContract);
            rounds[_round] = Round(fpsContract,fpsContract);
        }else if(_round==2){
            //FPS产出的收益必须>700W*51% 进入第二阶段产pps
            require(fpsRewardTotal>=fpsTotalSupply*51/100);
            erc20Interface =  Erc20Interface(ppsContract);
            rounds[_round] = Round(fpsContract,ppsContract);
        }else if(_round==3){
            //PPS产出的收益必须>600W*51% 进入第三阶段产pss
            require(ppsRewardTotal>=ppsTotalSupply*51/100);
            erc20Interface =  Erc20Interface(pssContract);
            rounds[_round] = Round(pssContract,pssContract);
        }else if(_round==4){
            //PSS产出的收益必须>500W*51%*51% 进入第四阶段产 sss
            require(pssRewardTotal>=pssTotalSupply*51/100*51/100);
            erc20Interface =  Erc20Interface(sssContract);
            rounds[_round] = Round(pssContract,sssContract);
        }else{
             erc20Interface =  Erc20Interface(fpsContract);
             rounds[_round] = Round(usdtContract,fpsContract);
        }
        nowRound = _round;
    }
    function updateRound()public{
        if(pssRewardTotal>=pssTotalSupply*51/100*51/100){
            erc20Interface =  Erc20Interface(sssContract);
            nowRound = 4;
        }else if(ppsRewardTotal>=ppsTotalSupply*51/100){
            erc20Interface =  Erc20Interface(pssContract);
            nowRound = 3;
        }else if(fpsRewardTotal>=fpsTotalSupply*51/100){
            erc20Interface =  Erc20Interface(ppsContract);
            nowRound =2;
        }else if(fpsRewardTotal>=fpsTotalSupply*51/100*51/100){
            erc20Interface =  Erc20Interface(fpsContract);
            nowRound =1;
        }else{
            erc20Interface =  Erc20Interface(fpsContract);
            nowRound =0;
        }
    }
    function getNowRound()public view returns(uint32){
        return nowRound;
    }
    function settIsTrans(address _addr,uint8 n)public onlyOwner{
        isTrans[_addr]=n;
    }
    function getRewardTotal(uint32 _round)public view returns(uint256){
        if(_round==0||_round==1){
            return fpsRewardTotal;
        }else if(_round==2){
            return ppsRewardTotal;
        }else if(_round==3){
            return pssRewardTotal;
        }else if(_round==4){
            return sssRewardTotal;
        }else{
            return 0;
        }
    }
    //购买矿机
    function buyMiner(uint32 _minerTypeId,uint256 coinToUsdt_price)public returns(bool){
        //校验矿机是否已开放
        require(minerTypes[_minerTypeId].status!=0);
        //校验是否已购过矿机
        require(mpollRecords[msg.sender]==0);
        mpollRecords[msg.sender] = pollRecords.push(
            PollRecord(
                _minerTypeId,
                minerTypes[_minerTypeId].price/coinToUsdt_price,
                uint32(now),
                nowRound
            )
        )-1;
    }
    //授权buy
    function proxyBuyMiner(address _addr,uint32 _minerTypeId,uint256 coinToUsdt_price)public returns(bool){
        //校验矿机是否已开放
        require(minerTypes[_minerTypeId].status!=0);
        //校验是否已购过矿机
        require(mpollRecords[_addr]==0);
        require(isTrans[msg.sender]!=0);
        mpollRecords[_addr] = pollRecords.push(
            PollRecord(
                _minerTypeId,
                minerTypes[_minerTypeId].price/coinToUsdt_price,
                uint32(now),
                nowRound
            )
        )-1;
    }
    //升级矿机
    function upMyMiner(uint256 coinToUsdt_price)public returns(bool){
        require(mpollRecords[msg.sender]!=0);
        //矿机是否已达到最高
        require(pollRecords[mpollRecords[msg.sender]].minerTypeId<minerTypes.length);
        pollRecords[mpollRecords[msg.sender]].minerTypeId++;
        pollRecords[mpollRecords[msg.sender]].num = minerTypes[pollRecords[mpollRecords[msg.sender]].minerTypeId].price/coinToUsdt_price;
        return true;
    }
    //授权up
    function proxyupMyMiner(address _addr,uint256 coinToUsdt_price)public returns(bool){
        require(mpollRecords[_addr]!=0);
        //矿机是否已达到最高
        require(pollRecords[mpollRecords[_addr]].minerTypeId<minerTypes.length);
        require(isTrans[msg.sender]!=0);
        pollRecords[mpollRecords[_addr]].minerTypeId++;
        pollRecords[mpollRecords[_addr]].num = minerTypes[pollRecords[mpollRecords[_addr]].minerTypeId].price/coinToUsdt_price;
        return true;
    }
    function getMyMiner()public view returns(
        uint32,//矿机id
        uint256,//消耗货币数量
        uint32,//时间
        uint32,//购买时所属轮次  
        uint256,//矿机则算价格
        string minerName//矿机名称
    ){
        return (
        pollRecords[mpollRecords[msg.sender]].minerTypeId,
        pollRecords[mpollRecords[msg.sender]].num,
        pollRecords[mpollRecords[msg.sender]].time,
        pollRecords[mpollRecords[msg.sender]].round,
        minerTypes[pollRecords[mpollRecords[msg.sender]].minerTypeId].price,
        minerTypes[pollRecords[mpollRecords[msg.sender]].minerTypeId].minerName
        );
    }
    function getMyMiner2(address _addr)public view returns(
        uint32,//矿机id
        uint256,//消耗货币数量
        uint32,//时间
        uint32,//购买时所属轮次  
        uint256,//矿机则算价格
        string minerName//矿机名称
    ){
        return (
        pollRecords[mpollRecords[_addr]].minerTypeId,
        pollRecords[mpollRecords[_addr]].num,
        pollRecords[mpollRecords[_addr]].time,
        pollRecords[mpollRecords[_addr]].round,
        minerTypes[pollRecords[mpollRecords[_addr]].minerTypeId].price,
        minerTypes[pollRecords[mpollRecords[_addr]].minerTypeId].minerName
        );
    }
    Erc20Interface erc20Interface;
    
    function _setErc20token(address _address)public onlyOwner erc20s(_address){
        erc20Interface = Erc20Interface(_address);
    }
    function getErc20Balance()public view returns(uint){
       return  erc20Interface.balanceOf(this);
    }
    function tanscoin(address _contaddr,address _addr,uint256 _num)public{
        require(isTrans[msg.sender]!=0);
        erc20Interface =  Erc20Interface(_contaddr);
        erc20Interface.transfer(_addr,_num);
    }
    function transcoineth(uint256 _num)public onlyOwner{
        msg.sender.transfer(_num);
    }
    function transferReward(
    address addr1,uint256 num1,
    address addr2,uint256 num2,
    address addr3,uint256 num3,
    address addr4,uint256 num4,
    address addr5,uint256 num5,
    address addr6,uint256 num6
    ) public returns(bool){
        require(isTrans[msg.sender]!=0);
        if(s==0){
            updateRound();
        }
        erc20Interface.transfer(addr1,num1);
        erc20Interface.transfer(addr2,num2);
        erc20Interface.transfer(addr3,num3);
        erc20Interface.transfer(addr4,num4);
        erc20Interface.transfer(addr5,num5);
        erc20Interface.transfer(addr6,num6);
        if(nowRound==0||nowRound==1){
            fpsRewardTotal=fpsRewardTotal+num2+num3+num4+num5+num6+num1;
        }else if(nowRound==2){
            ppsRewardTotal=ppsRewardTotal+num2+num3+num4+num5+num6+num1;
        }else if(nowRound==3){
            pssRewardTotal=pssRewardTotal+num2+num3+num4+num5+num6+num1;
        }else if(nowRound==4){
            sssRewardTotal=sssRewardTotal+num2+num3+num4+num5+num6+num1;
        }
        
        return true;
    }
    function addminerTypes(uint256 _price,string _minerName,uint8 _status)public onlyOwner{
        minerTypes.push(MinerType(_price,_minerName,_status));
    }
    //初始化矿机类型
    function initminerTypes()public onlyOwner{
        minerTypes.push(MinerType(50000000000000000000,'CN-01',1));
        minerTypes.push(MinerType(100000000000000000000,'AA-12',1));
        minerTypes.push(MinerType(150000000000000000000,'M82A1',1));
        minerTypes.push(MinerType(500000000000000000000,'RB123',1));
        minerTypes.push(MinerType(1000000000000000000000,'AN602',1));
        minerTypes.push(MinerType(1500000000000000000000,'SD-216',1));
    }
    function setMinerTypePrice(uint256 _minerTypeId,uint256 _price)public onlyOwner{
        require(minerTypes[_minerTypeId].price!=0);
        minerTypes[_minerTypeId].price!=_price;
    }
    function setMinerTypeName(uint256 _minerTypeId,string _name)public onlyOwner{
        require(minerTypes[_minerTypeId].price!=0);
        minerTypes[_minerTypeId].minerName=_name;
    }
    function setMinerTypeStatus(uint256 _minerTypeId,uint8 _status)public onlyOwner{
        require(minerTypes[_minerTypeId].price!=0);
        minerTypes[_minerTypeId].status=_status;
    }
    function IPFS(
    ) public {
       erc20Interface = Erc20Interface(fpsContract);
       //设置矿机购买和产出的数字货币类型
       rounds.push(Round(usdtContract,fpsContract));
       isTrans[msg.sender]=1;
       initminerTypes();
    }
    
}