pragma solidity ^0.5.12;

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
  constructor () public {
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
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a); 
    return a - b; 
  } 
  
  function add(uint256 a, uint256 b) internal pure returns (uint256) { 
    uint256 c = a + b; assert(c >= a);
    return c;
  }
}

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender], "Error"); 
    // SafeMath.sub will throw if there is not enough balance. 
    balances[msg.sender] = balances[msg.sender].sub(_value); 
    balances[_to] = balances[_to].add(_value); 
    emit Transfer(msg.sender, _to, _value); 
    return true; 
  } 

  /** 
   * @dev Gets the balance of the specified address. 
   * @param _owner The address to query the the balance of. 
   * @return An uint256 representing the amount owned by the passed address. 
   */ 
  function balanceOf(address _owner) public view returns (uint256 balance) { 
    return balances[_owner]; 
  } 
} 

/** 
 * @title Standard ERC20 token 
 * 
 * @dev Implementation of the basic standard token. 
 * @dev https://github.com/ethereum/EIPs/issues/20 
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
 */ 
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]); 
    balances[_from] = balances[_from].sub(_value); 
    balances[_to] = balances[_to].add(_value); 
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
    emit Transfer(_from, _to, _value); 
    return true; 
  } 

 /** 
  * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
  * 
  * Beware that changing an allowance with this method brings the risk that someone may use both the old 
  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
  * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
  * @param _spender The address which will spend the funds. 
  * @param _value The amount of tokens to be spent. 
  */ 
  function approve(address _spender, uint256 _value) public returns (bool) { 
    allowed[msg.sender][_spender] = _value; 
    emit Approval(msg.sender, _spender, _value); 
    return true; 
  }

 /** 
  * @dev Function to check the amount of tokens that an owner allowed to a spender. 
  * @param _owner address The address which owns the funds. 
  * @param _spender address The address which will spend the funds. 
  * @return A uint256 specifying the amount of tokens still available for the spender. 
  */ 
  function allowance(address _owner, address _spender) public view returns (uint256 remaining) { 
    return allowed[_owner][_spender]; 
  } 

 /** 
  * approve should be called when allowed[_spender] == 0. To increment 
  * allowed value is better to use this function to avoid 2 calls (and wait until 
  * the first transaction is mined) * From MonolithDAO Token.sol 
  */ 
  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
    return true; 
  }

  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
    uint oldValue = allowed[msg.sender][_spender]; 
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function () external payable {
    revert();
  }

}

contract MiningExpertToken is StandardToken, Ownable {
    
    string public constant name = "Mining Expert Token";
    
    string public constant symbol = "MEXP";
    
    uint32 public constant decimals = 18;
    
    uint256 public constant INITIAL_SUPPLY = 200000000*10**18; //200 billion token MEXP
    
    constructor () public {
        totalSupply = INITIAL_SUPPLY;
    }
    
}

//The contract has an address 0x0000009d48b12597675a02fca9c317eadef152cb, it is generated before the contract is uploaded to the network, all other addresses have nothing to do with us
contract MiningExpert is MiningExpertToken{
   using SafeMath for uint;
   
   MiningExpertToken public token = new MiningExpertToken();
    // public information about the contribution of a specific investor
    mapping (address => uint) public contributor_balance;
    // public information last payment time
    mapping (address => uint) public contributor_payout_time;
    // public information how much the user received money
    mapping(address => uint) public contributor_payout;
    // public information how much the user received tokens
    mapping(address => uint) public contributor_token_payout;
    // public information how much the user received bonus MEXP
    mapping(address => bool) public contributor_bonus;
    // public information how much the user received bonus MEXP
    mapping(address => uint) public contributor_ETH_bonus;
    
    // all deposits below the minimum will be sent directly to the developer's wallet and will
    // be used for the development of the project
    uint constant  MINIMAL_DEPOSIT = 0.01 ether;
    //Token bonus 200%
    uint constant  BONUS_COEFFICIENT = 2;
    //bonus 2.2% for a deposit above 10 ETH
    uint constant  BONUS_ETH = 22;
    //bonus cost 0.01 ether
    uint TOKEN_COST = 100;
    // Time after which you can request the next payment
    uint constant  PAYOUT_TIME = 1 hours;
    // 0.0925 % per hour
    uint constant  HOURLY_PERCENT = 925;
    //commission 10%
    uint constant PROJECT_COMMISSION = 10;
    // developer wallet for advertising and server payments
    address payable constant DEVELOPER_WALLET  = 0x100000b152A8dA7a8FCb938D7113952BfbB99705;
    // payment wallet
    address payable constant PAYMENT_WALLET = 0x2000001068A0F8A100A2A3a6D256A069A074B4E2;
    
    event NewContributor(address indexed contributor, uint value, uint time);
    event PayDividends(address indexed contributor, uint value, uint time);
    event PayTokenDividends(address indexed contributor, uint value, uint time);
    event NewContribution(address indexed contributor, uint value,uint time);
    event PayBonus(address indexed contributor, uint value, uint time);
    event Refund(address indexed contributor, uint value, uint time);
    event Reinvest(address indexed contributor, uint value, uint time);
    event TokenRefund(address indexed contributor, uint value, uint time);

    uint public total_deposits;
    uint public number_contributors;
    uint public last_payout;
    uint public total_payout;
    uint public total_token_payout;
    
    constructor()public payable {
        balances[address(this)] = INITIAL_SUPPLY/2;
        balances[DEVELOPER_WALLET] = INITIAL_SUPPLY/2;
        emit Transfer(address(this), DEVELOPER_WALLET, INITIAL_SUPPLY/2);
    }
    
    /**
     * The modifier checking the positive balance of the beneficiary
    */
    modifier checkContributor(){
        require(contributor_balance[msg.sender] > 0,  "Deposit not found");
        _;
    }
    
    /**
     * modifier checking the next payout time
     */
    modifier checkTime(){
         require(now >= contributor_payout_time[msg.sender].add(PAYOUT_TIME), "You can request payments at least 1 time per hour");
         _;
    }
    
    function get_contributor_credit()public view  returns(uint){
        uint hourly_rate = (contributor_balance[msg.sender].add(contributor_ETH_bonus[msg.sender])).mul(HOURLY_PERCENT).div(1000000);
        uint debt = now.sub(contributor_payout_time[msg.sender]).div(PAYOUT_TIME);
        return(debt.mul(hourly_rate));
    }
    
    // Take the remainder of the deposit and exit the project
    function refund() checkContributor public payable {
        uint balance = contributor_balance[msg.sender];
        uint token_balance_payout = contributor_token_payout[msg.sender].div(TOKEN_COST);
        uint payout_left = balance.sub(contributor_payout[msg.sender]).sub(token_balance_payout);
        uint out_summ;
        
        if(contributor_bonus[msg.sender] || contributor_payout[msg.sender] > 0){
            out_summ = payout_left.sub(balance.mul(PROJECT_COMMISSION).div(100));
            msg.sender.transfer(out_summ);
        }else{
            out_summ = payout_left;
            msg.sender.transfer(out_summ);
        }
        contributor_balance[msg.sender] = 0;
        contributor_payout_time[msg.sender] = 0;
        contributor_payout[msg.sender] = 0;
        contributor_token_payout[msg.sender] = 0;
        contributor_bonus[msg.sender] = false;
        contributor_ETH_bonus[msg.sender] = 0;
        
        emit Refund(msg.sender, out_summ, now);
    }
    
    // Conclusion establihsment and exit tokens MEXP
    function tokenRefund() checkContributor public payable {
        uint balance = contributor_balance[msg.sender];
        uint token_balance_payout = contributor_token_payout[msg.sender].div(TOKEN_COST);
        uint payout_left = balance.sub(contributor_payout[msg.sender]).sub(token_balance_payout);
        uint out_summ;
        
        if(contributor_bonus[msg.sender] || contributor_payout[msg.sender] > 0){
            out_summ = payout_left.sub(balance.mul(PROJECT_COMMISSION).div(100));
            this.transfer(msg.sender, out_summ.mul(TOKEN_COST));
        }else{
            out_summ = payout_left;
            this.transfer(msg.sender, out_summ.mul(TOKEN_COST));
        }
        contributor_balance[msg.sender] = 0;
        contributor_payout_time[msg.sender] = 0;
        contributor_payout[msg.sender] = 0;
        contributor_token_payout[msg.sender] = 0;
        contributor_bonus[msg.sender] = false;
        contributor_ETH_bonus[msg.sender] = 0;
        total_token_payout += out_summ;
        
        emit Refund(msg.sender, out_summ, now);
    }
    
    // Reinvest the dividends into the project
    function reinvest()public checkContributor payable{
        require(contributor_bonus[msg.sender], 'Get bonus to reinvest');
        uint credit = get_contributor_credit();
        
        if (credit > 0){
            uint bonus = credit.mul(BONUS_ETH).div(1000);
            credit += bonus;
            contributor_payout_time[msg.sender] = now;
            contributor_balance[msg.sender] += credit;
            emit Reinvest(msg.sender, credit, now);
        }else{
            revert();
        }
    }
    
    // Get payment of dividends
    function receivePayment()checkTime public payable{
        uint credit = get_contributor_credit();
        contributor_payout_time[msg.sender] = now;
        contributor_payout[msg.sender] += credit;
        // 1 percent held on hedging
        msg.sender.transfer(credit.sub(credit.div(100)));
        total_payout += credit;
        last_payout = now;
        emit PayDividends(msg.sender, credit, now);
    }
    
    // Get payment of dividends in tokens
    function receiveTokenPayment()checkTime public payable{
        uint credit = get_contributor_credit().mul(TOKEN_COST);
        contributor_payout_time[msg.sender] = now;
        contributor_token_payout[msg.sender] += credit;
        this.transfer(msg.sender,credit);
        total_token_payout += credit;
        last_payout = now;
        emit PayTokenDividends(msg.sender, credit, now);
    }
    
    /**
     * The method of accepting payments, if a zero payment has come, then we start the procedure for refunding
     * the interest on the deposit, if the payment is not empty, we record the number of broadcasts on the contract
     * and the payment time
     */
    function makeContribution() private{
            
        if (contributor_balance[msg.sender] == 0){
            emit NewContributor(msg.sender, msg.value, now);
            number_contributors+=1;
        }
        
        // transfer developer commission
        DEVELOPER_WALLET.transfer(msg.value.mul(10).div(100));
        
        if(now >= contributor_payout_time[msg.sender].add(PAYOUT_TIME) && contributor_balance[msg.sender] != 0){
            receivePayment();
        }
        
        contributor_balance[msg.sender] += msg.value;
        contributor_payout_time[msg.sender] = now;
        
        if (msg.value >= 10 ether){
            contributor_ETH_bonus[msg.sender] = msg.value.mul(BONUS_ETH).div(1000);
        }
        
        total_deposits += msg.value;
        emit NewContribution(msg.sender, msg.value, now);
    }
    
    // Get bonus for contribution
    function getBonus()checkContributor external payable{
        uint balance = contributor_balance[msg.sender];
        if (!contributor_bonus[msg.sender]){
            contributor_bonus[msg.sender] = true;
            uint bonus = balance.mul(TOKEN_COST);
            this.transfer(msg.sender, bonus);
            total_token_payout += bonus;
            emit PayBonus(msg.sender, bonus, now);
        }
    }
    
    // Get information on the contributor
    function getContribtor() public view returns(uint balance, uint payout, uint payout_time, uint token_payout, bool bonus, uint ETH_bonus, uint payout_balance, uint token_balance) {
        balance = contributor_balance[msg.sender];
        payout = contributor_payout[msg.sender];
        payout_time = contributor_payout_time[msg.sender];
        token_payout = contributor_token_payout[msg.sender];
        bonus = contributor_bonus[msg.sender];
        ETH_bonus = contributor_ETH_bonus[msg.sender];
        payout_balance = get_contributor_credit();
        token_balance = balanceOf(msg.sender);
        
    }

    /**
     * function that is launched when transferring money to a contract
     */
    function() external payable{
        if (msg.value >= MINIMAL_DEPOSIT){
            //if the sender is not a payment wallet, then we make out a deposit otherwise we do nothing,
            // but simply put money on the balance of the contract
            if(msg.sender != PAYMENT_WALLET){
                makeContribution();
            }
            
        }else{
           DEVELOPER_WALLET.transfer(msg.value); 
        }
    }
}