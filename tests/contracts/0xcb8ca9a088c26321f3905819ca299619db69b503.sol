pragma solidity ^0.4.24;


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
interface ExtendedShrimp {
  function sendFunds(address user,uint hexAmount) external returns (uint256);
  function signalHatch(address user,uint shrimpAmount) external; //to allow the safe use of shrimp as divs, with an effective snapshot of all shrimp counts.
}


contract ShrimpFarmer is IERC20{
    uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
    uint256 PSN=10000;
    uint256 PSNH=5000;
    bool public initialized=false;
    IERC20 public hexToken;
    ExtendedShrimp public extendedContract;
    uint256 public extendedContractSetAt;
    uint256 public extendedContractTimeToGoLive=1 days;
    address public contractCreator;
    address public feeshare2;
    address public feeshare3;
    address public feeshare4;
    address public feeshare5;
    mapping (address => uint256) public hatcheryShrimp;
    mapping (address => uint256) public claimedEggs;
    mapping (address => uint256) public lastHatch;
    mapping (address => address) public referrals;

    uint256 public marketEggs;

    //ERC20 constants
    string public constant name = "HEXSHRIMP";
    string public constant symbol = "HEXSHRIMP";
    uint8 public constant decimals = 0;

    //for view only
    mapping(address => uint) public referralCount;
    mapping(address => uint) public eggsFromReferral;
    mapping(address => bytes32) public refName;
    mapping(bytes32 => address) public addressByRefName;

    event Referral(address from,address to,uint eggsSent);
    event Hatch(address from,uint newShrimp);
    event Buy(address from,uint hexSpent,uint eggsBought);
    event Sell(address from,uint eggsSold,uint hexWithdrawn);
    function ShrimpFarmer(address token,address fs2,address fs3,address fs4,address fs5) public{
        contractCreator=msg.sender;
        feeshare2=fs2;
        feeshare3=fs3;
        feeshare4=fs4;
        feeshare5=fs5;
        hexToken=IERC20(token);
    }
    function hatchEggs(address ref) public{
        require(initialized);
        if(getExtendedContract() != address(0)){
          extendedContract.signalHatch(msg.sender,hatcheryShrimp[msg.sender]);
        }
        if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
            referrals[msg.sender]=ref;
            referralCount[ref]+=1;
        }

        uint256 eggsUsed=getMyEggs();
        uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
        hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
        claimedEggs[msg.sender]=0;
        lastHatch[msg.sender]=now;

        //send referral eggs
        claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,20));
        if(referrals[msg.sender]!=0){
          eggsFromReferral[referrals[msg.sender]]+=SafeMath.div(eggsUsed,20);
          emit Referral(msg.sender,referrals[msg.sender],SafeMath.div(eggsUsed,20));
        }
        //if(ref!=msg.sender){
        //  claimedEggs[ref]=SafeMath.add(claimedEggs[ref],SafeMath.div(eggsUsed,20));//divided by 20 is 5%
        //}

        //boost market to nerf shrimp hoarding
        //re-enabled with lower amount.
        marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,20));

        emit Hatch(msg.sender,newShrimp);
    }
    function payoutFee(uint fee) private{
      hexToken.transfer(contractCreator,SafeMath.div(SafeMath.mul(fee,30),100));
      hexToken.transfer(feeshare2,SafeMath.div(SafeMath.mul(fee,20),100));
      hexToken.transfer(feeshare3,SafeMath.div(SafeMath.mul(fee,20),100));
      hexToken.transfer(feeshare4,SafeMath.div(SafeMath.mul(fee,15),100));
      hexToken.transfer(feeshare5,SafeMath.div(SafeMath.mul(fee,15),100));
    }
    function sellEggs() public{
        require(initialized);
        uint256 hasEggs=getMyEggs();
        uint256 eggValue=calculateEggSell(hasEggs);
        uint256 fee=devFee(eggValue);
        claimedEggs[msg.sender]=0;
        lastHatch[msg.sender]=now;
        marketEggs=SafeMath.add(marketEggs,hasEggs);
        //contractCreator.transfer(fee);
        payoutFee(fee);
        hexToken.transfer(msg.sender,SafeMath.sub(eggValue,fee));

        emit Sell(msg.sender,hasEggs,SafeMath.sub(eggValue,fee));
    }
    function buyEggs(uint hexIn1) public{
        require(initialized);
        uint hexIn;

        //transfer hex from user, must have allowance already set
        hexToken.transferFrom(msg.sender,address(this),hexIn1);

        if(getExtendedContract() != address(0)){
          sendToExtendedShrimp(getExtendedFee(hexIn1));
          hexIn=SafeMath.sub(hexIn1,getExtendedFee(hexIn1));
        }
        else{
          hexIn=hexIn1;
        }

        uint256 eggsBought=calculateEggBuy(hexIn,SafeMath.sub(hexToken.balanceOf(address(this)),hexIn));
        eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));

        payoutFee(devFee(hexIn));
        claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);

        emit Buy(msg.sender,hexIn,eggsBought);
    }
    //magic trade balancing algorithm
    function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
        //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
        return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
    }
    function calculateEggSell(uint256 eggs) public view returns(uint256){
        return calculateTrade(eggs,marketEggs,hexToken.balanceOf(address(this)));
    }
    function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
        return calculateTrade(eth,contractBalance,marketEggs);
    }
    function calculateEggBuySimple(uint256 eth) public view returns(uint256){
        return calculateEggBuy(eth,hexToken.balanceOf(address(this)));
    }
    function devFee(uint256 amount) public pure returns(uint256){
        return SafeMath.div(SafeMath.mul(amount,4),100);
    }
    function seedMarket(uint256 eggs,uint256 hexIn) public{
        require(msg.sender==contractCreator);
        require(marketEggs==0);
        hexToken.transferFrom(msg.sender,address(this),hexIn);
        initialized=true;
        marketEggs=eggs;
    }
    function getExtendedFee(uint hexAmount) public pure returns(uint256){
      return SafeMath.div(SafeMath.mul(hexAmount,10),100);
    }
    function sendToExtendedShrimp(uint hexAmount) private{
      hexToken.transfer(address(extendedContract),hexAmount);
      extendedContract.sendFunds(msg.sender,hexAmount);
    }
    /*
      The contract upgrade function
    */
    function setExtendedShrimp(address extended) public{
      require(msg.sender==contractCreator);
      extendedContract=ExtendedShrimp(extended);
      extendedContractSetAt=now;
    }
    /*
      Ensures that the upgraded contract only goes live after a buffer of time has passed after it was set. Users may examine the code of the contract in the meantime.
    */
    function getExtendedContract() public view returns(ExtendedShrimp){
      if(SafeMath.sub(now,extendedContractSetAt)>extendedContractTimeToGoLive){
        return extendedContract;
      }
      else{
        return ExtendedShrimp(address(0));
      }
    }
    function setRefName(bytes32 s) public{
      require(addressByRefName[s]==0);
      addressByRefName[s]=msg.sender;
      refName[msg.sender]=s;
    }
    /* disabled
    function getFreeShrimp() public{
        require(initialized);
        require(hatcheryShrimp[msg.sender]==0);
        lastHatch[msg.sender]=now;
        hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
    }
    */
    function getBalance() public view returns(uint256){
        return hexToken.balanceOf(address(this));
    }
    function getMyShrimp() public view returns(uint256){
        return hatcheryShrimp[msg.sender];
    }
    function getMyEggs() public view returns(uint256){
        return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
    }
    function getEggsSinceLastHatch(address adr) public view returns(uint256){
        uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
        return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
    }
    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }

/*
  Making this a token to take advantage of metrics collection for shrimp balances. Shrimp cannot be transferred.
*/
    function totalSupply() external view returns (uint256){
      return 0;
    }
    function balanceOf(address account) external view returns (uint256){
      return hatcheryShrimp[account];
    }
    function transfer(address recipient, uint256 amount) external returns (bool){
      revert();
    }
    function allowance(address owner, address spender) external view returns (uint256){
      return 0;
    }
    function approve(address spender, uint256 amount) external returns (bool){
      revert();
    }
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool){
      revert();
    }
}

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
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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