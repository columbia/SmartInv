/**
 *Submitted for verification at Etherscan.io on 2019-09-09
 * BEB dapp for www.betbeb.com
*/
pragma solidity^0.4.24;  
interface tokenTransfer {
    function transfer(address receiver, uint amount);
    function transferFrom(address _from, address _to, uint256 _value);
    function balanceOf(address receiver) returns(uint256);
}
interface tokenTransferUSDT {
    function transfer(address receiver, uint amount);
    function transferFrom(address _from, address _to, uint256 _value);
    function balances(address receiver) returns(uint256);
}
interface tokenTransferBET {
    function transfer(address receiver, uint amount);
    function transferFrom(address _from, address _to, uint256 _value);
    function balanceOf(address receiver) returns(uint256);
}
contract SafeMath {
      address public owner;
       
  function SafeMath () public {
        owner = msg.sender;
    }
  function safeMul(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
    assert(b > 0);
    uint256 c = a / b;
    assert(a == b * c + a % b);
    return c;
  }

  function safeSub(uint256 a, uint256 b) internal returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a + b;
    assert(c>=a && c>=b);
    return c;
  }

  function assert(bool assertion) internal {
    if (!assertion) {
      throw;
    }
  }
    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }
    function transferOwnership(address newOwner) onlyOwner public {
        if (newOwner != address(0)) {
        owner = newOwner;
      }
    }
}
contract bebBUYtwo is SafeMath{
tokenTransfer public bebTokenTransfer; //代币 
tokenTransferUSDT public bebTokenTransferUSDT;
tokenTransferBET public bebTokenTransferBET;
    uint8 decimals;
    uint256 bebethex;//eth-beb
    uint256 BEBday;
    uint256 bebjiage;
    uint256 bebtime;
    uint256 usdtex;
    address ownerstoex;
    uint256 ProfitSUMBEB;
    uint256 SUMdeposit;
    uint256 SUMWithdraw;
    uint256 USDTdeposit;
    uint256 USDTWithdraw;
    uint256 BEBzanchen;//赞成总量
    uint256 BEBfandui;//反对总量
    address shenqingzhichu;//申请人地址
    uint256 shenqingAmount;//申请金额
    uint256 huobileixing;//货币类型1=ETH，2=BEB，3=USDT
    string purpose;//用途
    bool KAIGUAN;//表决开关
    string boody;//是否通过
    uint256 buyOrSell;
    struct BEBuser{
        uint256 amount;
        uint256 dayamount;//每天
        uint256 bebdays;//天数
        uint256 usertime;//时间
        uint256 zhiyaBEB;
        uint256 sumProfit;
        uint256 amounts;
        bool vote;
    }
    struct USDTuser{
        uint256 amount;
        uint256 dayamount;//每天
        uint256 bebdays;//天数
        uint256 usertime;//时间
        uint256 zhiyaBEB;
        uint256 sumProfit;
    }
    mapping(address=>uint256)public buybebs;
    mapping(address=>USDTuser)public USDTusers;
    mapping(address=>BEBuser)public BEBusers;
    function bebBUYtwo(address _tokenAddress,address _usdtadderss,address _BETadderss,address _addr){
         bebTokenTransfer = tokenTransfer(_tokenAddress);
         bebTokenTransferUSDT =tokenTransferUSDT(_usdtadderss);
         bebTokenTransferBET =tokenTransferBET(_BETadderss);
         ownerstoex=_addr;
         bebethex=5623;
         decimals=18;
         BEBday=20;
         bebjiage=178480000000000;
         bebtime=now;
         usdtex=170;
     }
     //USDT
      function setUSDT(uint256 _value) public{
         require(_value>=10000000);
         uint256 _valueToBEB=SafeMath.safeDiv(_value,1000000);
         uint256 _valueToBEBs=_valueToBEB*10**18;
         uint256 _usdts=SafeMath.safeMul(_value,120);//100;
         uint256 _usdt=SafeMath.safeDiv(_usdts,100);//100;
         uint256 _bebex=SafeMath.safeMul(bebjiage,usdtex);
         uint256 _usdtexs=SafeMath.safeDiv(1000000000000000000,_bebex);
         uint256 _usdtex=SafeMath.safeMul(_usdtexs,_valueToBEBs);
         USDTuser storage _user=USDTusers[msg.sender];
         require(_user.amount==0,"Already invested ");
         bebTokenTransferUSDT.transferFrom(msg.sender,address(this),_value);
         bebTokenTransfer.transferFrom(msg.sender,address(this),_usdtex);
         _user.zhiyaBEB=_usdtex;
         _user.amount=_value;
         _user.dayamount=SafeMath.safeDiv(_usdt,BEBday);
         _user.usertime=now;
         _user.sumProfit+=_value*20/100;
         ProfitSUMBEB+=_usdtex*10/100;
         USDTdeposit+=_value;
         
     }
     function setETH()payable public{
         require(msg.value>=500000000000000000);
         uint256 _eths=SafeMath.safeMul(msg.value,120);
         uint256 _eth=SafeMath.safeDiv(_eths,100);
         uint256 _beb=SafeMath.safeMul(msg.value,bebethex);
         BEBuser storage _user=BEBusers[msg.sender];
         require(_user.amount==0,"Already invested ");
         bebTokenTransfer.transferFrom(msg.sender,address(this),_beb);
         _user.zhiyaBEB=_beb;
         _user.amount=msg.value;
         _user.dayamount=SafeMath.safeDiv(_eth,BEBday);
         _user.usertime=now;
         _user.sumProfit+=msg.value*20/100;
         ProfitSUMBEB+=_beb*10/100;
         SUMdeposit+=msg.value;
         
     }
     function DayQuKuan()public{
         if(now-bebtime>86400){
            bebtime+=86400;
            bebjiage+=660000000000;//每日固定上涨0.00000066ETH
            bebethex=1 ether/bebjiage;
        }
        BEBuser storage _users=BEBusers[msg.sender];
        uint256 _eths=_users.dayamount;
        require(_eths>0,"You didn't invest");
        require(_users.bebdays<BEBday,"Expired");
        uint256 _time=(now-_users.usertime)/86400;
        require(_time>=1,"Less than a day");
        uint256 _ddaayy=_users.bebdays+1;
        if(BEBday==20){
        msg.sender.transfer(_users.dayamount);
        SUMWithdraw+=_users.dayamount;
        _users.bebdays=_ddaayy;
        _users.usertime+=86400;
        if(_ddaayy==BEBday){
        uint256 _bebs=_users.zhiyaBEB*90/100;
         bebTokenTransfer.transfer(msg.sender,_bebs);
         _users.amount=0;
         _users.dayamount=0;
          _users.bebdays=0;
          _users.zhiyaBEB=0;
        }
        }else{
         uint256 _values=SafeMath.safeDiv(_users.zhiyaBEB,BEBday);
         bebTokenTransfer.transfer(msg.sender,_values);
        _users.bebdays=_ddaayy;
        _users.usertime+=86400;
        if(_ddaayy==BEBday){
         uint256 _bebss=_users.zhiyaBEB*90/100;
         bebTokenTransfer.transfer(msg.sender,_bebss);
         _users.amount=0;
         _users.dayamount=0;
          _users.bebdays=0;
          _users.zhiyaBEB=0;
        }   
        }
        
     }
     function DayQuKuanUsdt()public{
         if(now-bebtime>86400){
            bebtime+=86400;
            bebjiage+=660000000000;//每日固定上涨0.00000066ETH
            bebethex=1 ether/bebjiage;
        }
        USDTuser storage _users=USDTusers[msg.sender];
        uint256 _eths=_users.dayamount;
        require(_eths>0,"You didn't invest");
        require(_users.bebdays<BEBday,"Expired");
        uint256 _time=(now-_users.usertime)/86400;
        require(_time>=1,"Less than a day");
        uint256 _ddaayy=_users.bebdays+1;
        if(BEBday==20){
        bebTokenTransferUSDT.transfer(msg.sender,_eths);
        USDTWithdraw+=_eths;
        _users.bebdays=_ddaayy;
        _users.usertime+=86400;
        if(_ddaayy==BEBday){
        uint256 _bebs=_users.zhiyaBEB*90/100;
         bebTokenTransfer.transfer(msg.sender,_bebs);
         _users.amount=0;
         _users.dayamount=0;
          _users.bebdays=0;
          _users.zhiyaBEB=0;
        }
        }else{
         uint256 _values=SafeMath.safeDiv(_users.zhiyaBEB,BEBday);
         bebTokenTransfer.transfer(msg.sender,_values);
        _users.bebdays=_ddaayy;
        _users.usertime+=86400;
        if(_ddaayy==BEBday){
         uint256 _bebss=_users.zhiyaBEB*90/100;
         bebTokenTransfer.transfer(msg.sender,_bebss);
         _users.amount=0;
         _users.dayamount=0;
          _users.bebdays=0;
          _users.zhiyaBEB=0;
        }   
        }
        
     }
     //申请支出
     function ChaiwuzhiChu(address _addr,uint256 _values,uint256 _leixing,string _purpose)public{
         require(!KAIGUAN,"The last round of voting is not over");
         require(getTokenBalanceBET(address(this))<1,"And bet didn't get it back");
         uint256 _value=getTokenBalanceBET(msg.sender);//BET持有数量
        require(_value>=1 ether,"You have no right to apply");
         KAIGUAN=true;//开始投票
         shenqingzhichu=_addr;//申请人地址
         if(_leixing==3){
            uint256 _usdts= SafeMath.safeDiv(_values,1000000000000000000);
            uint256 _usdttozhichu=_usdts*1000000;
            shenqingAmount=_usdttozhichu;
         }else{
           shenqingAmount=_values;//申请支出金额
         }
         huobileixing=_leixing;//1=eth,2=BEB,3=USDT
         purpose=_purpose;
         boody="投票中...";
     }
     //投票赞成
    function setVoteZancheng()public{
        BEBuser storage _user=BEBusers[msg.sender];
        require(KAIGUAN);
        uint256 _value=getTokenBalanceBET(msg.sender);//BET持有数量
        require(_value>=1 ether,"You have no right to vote");
        require(!_user.vote,"You have voted");
        bebTokenTransferBET.transferFrom(msg.sender,address(this),_value);//转入BET
        BEBzanchen+=_value;//赞成增加
        _user.amounts=_value;//赋值
        _user.vote=true;//赋值已经投票
        if(BEBzanchen>=51 ether){
            //投票通过执行财务支出
            if(huobileixing!=0){
                if(huobileixing==1){
                 shenqingzhichu.transfer(shenqingAmount);//支出ETH
                 KAIGUAN=false;
                 BEBfandui=0;//票数归零
                 BEBzanchen=0;//票数归零
                 huobileixing=0;//撤销本次申请
                 boody="通过";
                 //shenqingzhichu=0;//撤销地址
                 //shenqingAmount=0;//撤销申请金额
                }else{
                    if(huobileixing==2){
                      bebTokenTransfer.transfer(shenqingzhichu,shenqingAmount);//支出BEB
                      KAIGUAN=false;
                      BEBfandui=0;//票数归零
                      BEBzanchen=0;//票数归零
                      huobileixing=0;//撤销本次申请
                      boody="通过";
                    }else{
                        bebTokenTransferUSDT.transfer(shenqingzhichu,shenqingAmount);//支出USDT
                        KAIGUAN=false;
                        BEBfandui=0;//票数归零
                        BEBzanchen=0;//票数归零
                        huobileixing=0;//撤销本次申请
                        boody="通过";
                    }          
                 }
            }
        }
    }
    //投票反对
    function setVoteFandui()public{
        require(KAIGUAN);
        BEBuser storage _user=BEBusers[msg.sender];
        uint256 _value=getTokenBalanceBET(msg.sender);
        require(_value>=1 ether,"You have no right to vote");
        require(!_user.vote,"You have voted");
        bebTokenTransferBET.transferFrom(msg.sender,address(this),_value);//转入BET
        BEBfandui+=_value;//赞成增加
        _user.amounts=_value;//赋值
        _user.vote=true;//赋值已经投票
        if(BEBfandui>=51 ether){
            //反对大于51%表决不通过
            BEBfandui=0;//票数归零
            BEBzanchen=0;//票数归零
            huobileixing=0;//撤销本次申请
            shenqingzhichu=0;//撤销地址
            shenqingAmount=0;//撤销申请金额
            KAIGUAN=false;
            boody="拒绝";
        }
    }
    //取回BET
     function quhuiBET()public{
        require(!KAIGUAN,"Bet cannot be retrieved while voting is in progress");
        BEBuser storage _user=BEBusers[msg.sender];
        require(_user.vote,"You did not vote");
        bebTokenTransferBET.transfer(msg.sender,_user.amounts);//退回BET
        _user.vote=false;
        _user.amounts=0;
     }
     function buybeb()payable public{
        uint256 _amount=msg.value;
        uint256 _buybeb=SafeMath.safeMul(_amount,bebethex);
        require(_buybeb<=ProfitSUMBEB);
        bebTokenTransfer.transfer(msg.sender,_buybeb);//支出BEB
        buybebs[msg.sender]+=_buybeb;
        buyOrSell+=_buybeb;
        ProfitSUMBEB-=_buybeb;
     }
     function sellbeb(uint256 _value) public{
         require(_value>bebethex);
         require(buybebs[msg.sender]>=_value,"Sorry, your credit is running low");
        uint256 _sellbeb=SafeMath.safeDiv(_value,bebethex);
        uint256 _selleth=_sellbeb*95/100;
        bebTokenTransfer.transferFrom(msg.sender,address(this),_value);
        msg.sender.transfer(_selleth);
        buybebs[msg.sender]-=_value;
        buyOrSell-=_selleth;
        ProfitSUMBEB+=_value;
     }
     function setBEB(uint256 _value)public{
         require(_value>0);
         bebTokenTransfer.transferFrom(msg.sender,address(this),_value);
         ProfitSUMBEB+=_value;
     }
     function setusdtex(uint256 _value)public{
         require(ownerstoex==msg.sender);
         usdtex=_value;
     }
     function setETHS()payable onlyOwner{
         SUMdeposit+=msg.value;
     }
     function setUSDTS(uint256 _value)onlyOwner{
         bebTokenTransferUSDT.transferFrom(msg.sender,address(this),_value);
         USDTdeposit+=_value;
     }
     function querBalance()public view returns(uint256){
         return this.balance;
     }
    function getTokenBalance() public view returns(uint256){
         return bebTokenTransfer.balanceOf(address(this));
    }
    function getTokenBalanceUSDT() public view returns(uint256){
         return bebTokenTransferUSDT.balances(address(this));
    }
    function BETwithdrawal(uint256 amount)onlyOwner {
      bebTokenTransferBET.transfer(msg.sender,amount);
    }
    function setBEBday(uint256 _BEBday)onlyOwner{
        BEBday=_BEBday;
    }
    function setusersUSDT(address _addr)onlyOwner{
       USDTuser storage _user=USDTusers[_addr];
       _user.amount=0;
       _user.dayamount=0;
       _user.bebdays=0;
       _user.usertime=0;
       _user.zhiyaBEB=0;
       _user.sumProfit=0;
        
    }
    function setusersETH(address _addr)onlyOwner{
       BEBuser storage _user=BEBusers[_addr];
       _user.amount=0;
       _user.dayamount=0;
       _user.bebdays=0;
       _user.usertime=0;
       _user.zhiyaBEB=0;
       _user.sumProfit=0;
        
    }
    function getuserBuybebs() public view returns(uint256){
         return buybebs[msg.sender];
    }
    function getTokenBalanceBET(address _addr) public view returns(uint256){
         return bebTokenTransferBET.balanceOf(_addr);
    }
    function getQuanju()public view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256){
            
         return (bebjiage,bebethex,ProfitSUMBEB,SUMdeposit,SUMWithdraw,USDTdeposit,USDTWithdraw,buyOrSell,usdtex);
    }
    function getUSDTuser(address _addr)public view returns(uint256,uint256,uint256,uint256,uint256,uint256){
            USDTuser storage _users=USDTusers[_addr];
            //uint256 amount;//USDT总投资
        //uint256 dayamount;//每天回本息
        //uint256 bebdays;//回款天数
        //uint256 usertime;//上一次取款时间
        //uint256 zhiyaBEB;质押BEB数量
        //uint256 sumProfit;总收益
         return (_users.amount,_users.dayamount,_users.bebdays,_users.usertime,_users.zhiyaBEB,_users.sumProfit);
    }
    function getBEBuser(address _addr)public view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,bool){
            BEBuser storage _users=BEBusers[_addr];
            //uint256 amount;//投资金额
            //uint256 dayamount;//每天回本息
            //uint256 bebdays;//回款天数
            //uint256 usertime;//上一次取款时间
            //uint256 zhiyaBEB;//质押BEB数量
            //uint256 sumProfit;//总收益
            // uint256 amounts;//投票BET数量
           //bool vote;//是否投票
         return (_users.amount,_users.dayamount,_users.bebdays,_users.usertime,_users.zhiyaBEB,_users.sumProfit,_users.amounts,_users.vote);
    }
    function getBETvote()public view returns(uint256,uint256,address,uint256,uint256,string,bool,string){
            //uint256 BEBzanchen;//赞成总量
    //uint256 BEBfandui;//反对总量
    //address shenqingzhichu;//申请人地址
    //uint256 shenqingAmount;//申请金额
    //uint256 huobileixing;//货币类型1=ETH，2=BEB，3=USDT
    //string purpose;//用途
    //bool KAIGUAN;//表决开关
    //string boody;//是否通过，状态
         return (BEBzanchen,BEBfandui,shenqingzhichu,shenqingAmount,huobileixing,purpose,KAIGUAN,boody);
    }
    function getUsdt()public view returns(uint256){
        return usdtex;
    }
    function ()payable{
        
    }
}