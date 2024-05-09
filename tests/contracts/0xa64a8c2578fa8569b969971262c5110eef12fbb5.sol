pragma solidity ^0.5.4;

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender)
    external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value)
    external returns (bool);

    function transferFrom(address from, address to, uint256 value)
    external returns (bool);

}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}


contract AtisStaking {
	using SafeMath for uint256;
 	address payable internal owner;
    IERC20 internal atis = IERC20(address(0x821144518dfE9e7b44fCF4d0824e15e8390d4637));
    uint256 constant internal MAGNITUDE = 2 ** 64;
    uint32 constant private DROP_RATE = 3;
    uint32 constant private PENALITY_FEE = 3;
    uint32 constant private DROP_FREQUENCY = 48 hours;
    uint32 constant private TIME_LOCK_FREQUENCY = 48 hours;
    

    mapping(address => uint256) public stakedOf;
    mapping(address => int256) private payoutsTo;
    mapping(address => uint256) public claimedOf;
    mapping(address => uint256) public unstakedOf;
    mapping(address => uint256) public timeLock;
    
    uint256 private profitPerShare;
    uint256 private pool;
    uint256 private totalSupply;

    uint256 public lastDripTime  = now;
    
    modifier onlyOwner() {
      require(msg.sender == owner,"NO_AUTH");
    _;
    }
 
	constructor() public {
		owner = msg.sender;
    }


     modifier hasDripped(){
        if(pool > 0 && totalSupply > 0){ 
          uint256 cyclePassed = SafeMath.sub(now,lastDripTime)/DROP_FREQUENCY;
         
          uint256 dividends =  cyclePassed*((pool * DROP_RATE) / 100);

          if (dividends > pool) {
              dividends = pool;
          }

          profitPerShare = SafeMath.add(profitPerShare, (dividends * MAGNITUDE) / totalSupply);
          pool = pool.sub(dividends);
          lastDripTime = lastDripTime + (cyclePassed * DROP_FREQUENCY);
        }

        _;
    }

    function feed() public payable{
        require(msg.value > 0);
        if(pool == 0 && totalSupply > 0){//START DRIPPING
            lastDripTime = now;
        }
        pool += msg.value;
       
    }


    function stake(uint256 amount) hasDripped  public 
    {
        require(amount > 0);
        uint256 currentBalance = atis.balanceOf(address(this));
        atis.transferFrom(msg.sender, address(this), amount);
        uint256 diff = atis.balanceOf(address(this)) - currentBalance;
        
        require(diff > 0);
        
        if(pool > 0 && totalSupply == 0){//START DRIPPING
            lastDripTime = now;
        }
        totalSupply = SafeMath.add(totalSupply,diff);
        stakedOf[msg.sender] = SafeMath.add(stakedOf[msg.sender], diff);
        payoutsTo[msg.sender] += (int256) (profitPerShare * diff);
    }

    function unstake(uint256 _amount) hasDripped public 
    {
        require(_amount <= stakedOf[msg.sender]);
        totalSupply -= _amount;
        stakedOf[msg.sender]= SafeMath.sub(stakedOf[msg.sender], _amount);
        unstakedOf[msg.sender] += _amount;
        payoutsTo[msg.sender] -= (int256) (profitPerShare * _amount);
        timeLock[msg.sender] = now + TIME_LOCK_FREQUENCY;
        
    }

    function withdraw() hasDripped public 
    {
        require(unstakedOf[msg.sender] > 0);
        require(timeLock[msg.sender] < now , "LOCKED");
        uint256 amount = unstakedOf[msg.sender];
        uint256 penality = (amount * PENALITY_FEE) / 100;
        unstakedOf[msg.sender] = 0;
        
        atis.transfer(address(0xe82954Fc979A8CE3b9BBC1B19c6D6A2Aa6d240B2),penality);
        atis.transfer(msg.sender,SafeMath.sub(amount,penality));
    }

    function claimEarning() hasDripped public {
        uint256 divs = dividendsOf(msg.sender);

        require(divs > 0 , "NO_DIV");
        payoutsTo[msg.sender] += (int256) (divs * MAGNITUDE);
        claimedOf[msg.sender] += divs;
        msg.sender.transfer(divs);
    }


    function getGlobalInfo() public view returns (uint256 ,uint256){
        return (pool,totalSupply);
    }
    

    function estimateDividendsOf(address _customerAddress) public view returns (uint256) {
        if(pool > 0 && totalSupply > 0){
            uint256 _profitPerShare = profitPerShare;
            uint256 cyclePassed = SafeMath.sub(now,lastDripTime) / DROP_FREQUENCY;
            uint256 dividends =  cyclePassed*((pool * DROP_RATE) / 100);
    
            if (dividends > pool) {
                dividends = pool;
            }
    
            _profitPerShare = SafeMath.add(profitPerShare, (dividends * MAGNITUDE) / totalSupply);
    
            return  (uint256) ((int256) (_profitPerShare * stakedOf[_customerAddress]) - payoutsTo[_customerAddress]) / MAGNITUDE;
            
        }else{
            return 0;
        }
    }

    function dividendsOf(address _customerAddress) public view returns (uint256) {
        return (uint256) ((int256) (profitPerShare * stakedOf[_customerAddress]) -payoutsTo[_customerAddress]) / MAGNITUDE ;
    }
}