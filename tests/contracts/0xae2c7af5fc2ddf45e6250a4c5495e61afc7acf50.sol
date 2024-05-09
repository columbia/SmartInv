pragma solidity 0.5.7;

interface AddrMInterface {
     function getAddr(string calldata name_) external view returns(address);
}

interface ERC20 {
  function balanceOf(address) external view returns (uint256);
  function transferFrom(address, address, uint256) external returns (bool);
  function transfer(address _to, uint256 _value) external returns (bool success);
  function ticketGet() external ;
  function allowance(address _owner, address _spender) external view returns (uint256 remaining);
}

interface mPoolInterface{
    function setAmbFlag(address ply_) external;
}



contract Ticket{
    
    //address manager 
    AddrMInterface public addrM;
    bool public fristTime;
    address public owner;
    
    ERC20 tokenADC;
    
    // change rule
    
    mapping(uint8 => uint256) private changeRatio;
    mapping(uint8 => uint256) public RemainAmount; // changeAmount - this lava cost
    uint256 public totalCheckOut; // already check out ADC acount
    uint8 public curentLevel;
   
    // constant set 
    uint256 constant public totalBalance = 153000000*10**18;
    uint256 constant public minInPay  = 5*10**16;// 1 * 5% eth
    uint256 constant public OutPay  =   1*10**17;// 1 * 10% eth
    address payable constant public  teamAddr = address(0x1d13502CfB73FCa360d1af7703cD3F47abA809b5);//
    
    
    
    
    constructor(address AddrManager_) public{
        owner = msg.sender;
        addrM = AddrMInterface(AddrManager_);
        tokenADC = ERC20(addrM.getAddr("ADC"));
        
        fristTime = false;
        
        curentLevel = 1;
        totalCheckOut = 0;
        
        RemainAmount[1] =  1000000000000000000000000;
        RemainAmount[2] =  2000000000000000000000000;
        RemainAmount[3] =  3000000000000000000000000;
        RemainAmount[4] =  4000000000000000000000000;
        RemainAmount[5] =  5000000000000000000000000;
        RemainAmount[6] =  6000000000000000000000000;
        RemainAmount[7] =  7000000000000000000000000;
        RemainAmount[8] =  8000000000000000000000000;
        RemainAmount[9] =  9000000000000000000000000;
        RemainAmount[10] = 10000000000000000000000000;
        RemainAmount[11] = 11000000000000000000000000;
        RemainAmount[12] = 12000000000000000000000000;
        RemainAmount[13] = 13000000000000000000000000;
        RemainAmount[14] = 14000000000000000000000000;
        RemainAmount[15] = 15000000000000000000000000;
        RemainAmount[16] = 16000000000000000000000000;
        RemainAmount[17] = 17000000000000000000000000;
        
        changeRatio[1] = 7000000000000000000000;
        changeRatio[2] = 6000000000000000000000;
        changeRatio[3] = 5000000000000000000000;
        changeRatio[4] = 4000000000000000000000;
        changeRatio[5] = 3000000000000000000000;
        changeRatio[6] = 2000000000000000000000;
        changeRatio[7] = 1000000000000000000000;
        changeRatio[8] = 500000000000000000000;
        changeRatio[9] = 250000000000000000000;
        changeRatio[10] = 125000000000000000000;
        changeRatio[11] = 60000000000000000000;
        changeRatio[12] = 30000000000000000000;
        changeRatio[13] = 15000000000000000000;
        changeRatio[14] = 8000000000000000000;
        changeRatio[15] = 4000000000000000000;
        changeRatio[16] = 2000000000000000000;
        changeRatio[17] = 1000000000000000000;
 
    }
    

    function buyADC() public payable{
        uint256 msgValue = msg.value;
        uint256 adcAmount;
        uint256 saleADC;
        
        if(!fristTime){
            tokenADC.ticketGet();
            fristTime = true;
        }
        require(msgValue >= minInPay," value to smail buyADC");
        require((totalBalance-totalCheckOut) == tokenADC.balanceOf(address(this)),"balance not right");
        
        saleADC = (msgValue* changeRatio[curentLevel])/10**18; //msgValue.div(10**18).mul(changeRatio[curentLevel]);
        
        teamAddr.transfer(msgValue);
        adcAmount = CrossLevel(saleADC,msgValue);
        
        tokenADC.transfer(msg.sender,adcAmount);
        
        if(msgValue >= 100*10**18){
            mPoolInterface(addrM.getAddr("MAINPOOL")).setAmbFlag(msg.sender);
        }
        
        totalCheckOut += adcAmount;
        
    }
    
    function calDeductionADC(uint256 _value,bool isIn_) public view returns(uint256 disADC_){
        
        uint256 ticketValue ;
        uint256 tempAdc;
        disADC_ = 0;
        if(isIn_){
           ticketValue = _value * 5 /100; 
        }else{
           ticketValue = _value * 5 /100; 
        }
    
        //require(_value >= 1*10**17,"_value to smail calDeductionADC");
        
        tempAdc = (ticketValue*changeRatio[curentLevel])/10**18;
        disADC_ = calcDistroy(tempAdc,ticketValue);
    }
    
    function getTickeInfo() public view returns(uint256 curLevel_,uint256 distroyADCAmount_){
        curLevel_ = curentLevel;
        distroyADCAmount_ = totalCheckOut;
    }
    
    function CrossLevel(uint256 saleADC_,uint256 buyValue_) internal  returns(uint256 disAdc){
        if(RemainAmount[curentLevel] > saleADC_){
            RemainAmount[curentLevel] -=saleADC_;
            disAdc = saleADC_;
            return disAdc;
        }else{
            disAdc = RemainAmount[curentLevel];
            uint256 newLevelRemian;
            uint256 value = buyValue_;
            uint256 subValue;
            for(uint8 i=curentLevel+1; i<17; i++){
                curentLevel = i;
                subValue = (RemainAmount[i-1]*10**18)/changeRatio[i-1];
                newLevelRemian = ((value- subValue)*changeRatio[i])/10**18;
                if(newLevelRemian < RemainAmount[i]){
                    disAdc += newLevelRemian;
                    RemainAmount[i] -= newLevelRemian;
                    return disAdc;
                }
                disAdc += RemainAmount[i];
                value -= subValue;
            }
        }
    }
    
    function calcDistroy(uint256 saleADC_,uint256 buyValue_) internal view returns(uint256 disAdc){
        if(RemainAmount[curentLevel] > saleADC_){
            
            disAdc = saleADC_;
           return disAdc;
        }else{
            disAdc = RemainAmount[curentLevel];
            uint256 newLevelRemian;
            uint256 value = buyValue_;
            uint256 subValue;
            for(uint8 i=curentLevel+1; i<17; i++){
                subValue = (RemainAmount[i-1]*10**18)/changeRatio[i-1];
                newLevelRemian = ((value- subValue)*changeRatio[i])/10**18;
                if(newLevelRemian < RemainAmount[i]){
                    disAdc += newLevelRemian;
                    return disAdc;
                }
                disAdc += RemainAmount[i];
                value -= subValue;
            }
        }
    }

}