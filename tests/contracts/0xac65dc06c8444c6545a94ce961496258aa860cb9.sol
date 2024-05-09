pragma solidity ^0.4.25;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 **/
contract Ownable {
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
     **/
   constructor() public {
      owner = msg.sender;
    }
    
    /**
     * @dev Throws if called by any account other than the owner.
     **/
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }
    
    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     **/
    function transferOwnership(address newOwner) public onlyOwner {
      require(newOwner != address(0));
      emit OwnershipTransferred(owner, newOwner);
      owner = newOwner;
    }
}

/**
 * @title ERC20Basic interface
 * @dev Basic ERC20 interface
 **/
contract ERC20Basic {
    //
    function totalSupply() public view returns (uint256);
    function balanceOf(address _who) view public returns (uint);
    function transfer(address _to, uint _value) public returns (bool);
    //
    event Transfer(address indexed _from, address indexed _to, uint _value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 **/
contract ERC20 is ERC20Basic {
    //
    function allowance(address _owner, address _spender) public view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
    function approve(address _spender, uint256 _value) public returns (bool);
    //
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 **/
contract BasicToken is ERC20Basic {
    
    using SafeMath for uint256;
    
    mapping(address => uint256) balances;
    
    uint256 _totalSupply=0;
    
    /**
     * @dev total number of tokens in existence
     **/
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    /**
     * @dev transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     **/
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        //
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        //
        emit Transfer(msg.sender, _to, _value);
        //
        return true;
    }
    
    /**
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     **/
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }
}

contract StandardToken is ERC20, BasicToken {
    
    enum StackingStatus{
        locked,
        unlocked
    }
    
    StackingStatus public stackingStatus=StackingStatus.unlocked;
    
    mapping (address => mapping (address => uint256)) internal allowed;
    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     **/
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(stackingStatus==StackingStatus.unlocked);
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        //
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        //
        emit Transfer(_from, _to, _value);
        //
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
     **/
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
     **/
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
    
    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to increase the allowance by.
     **/
    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
    
    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to decrease the allowance by.
     **/
    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
    event Burn(address indexed burner, uint256 value);
}

/**
 * @title Configurable
 * @dev Configurable varriables of the contract
 **/
contract Configurable {
    uint256 constant percentDivider = 100000;
    uint256 constant cap = 700000000*10**18; //7
    
    uint256 internal tokensSold = 0;
    uint256 internal remainingTokens = 0;
}

/**
 * @title CrowdsaleToken 
 * @dev Contract to preform crowd sale with token
 **/
contract CrowdsaleToken is StandardToken, Configurable, Ownable {
    
    enum DepositStatus{
        locked,
        unlocked
    }
    
    /**
     * @dev Variables
     **/
     
    DepositStatus public depositStatus=DepositStatus.locked;
    
    /**
     * @dev Events
     **/
    event Logger(string _label, uint256 _note1, uint256 _note2, uint256 _note3, uint256 _note4);
    
    /**
     * @dev Mapping
     **/
    
    /**
     * @dev constructor of CrowdsaleToken
     **/
    constructor() public {
        //
        depositStatus = DepositStatus.locked;
        //
        remainingTokens = cap;
    }
    

/* payments */
    
    /**
     * @dev fallback function to send ether to for Crowd sale
     **/
    function () external payable {
        require(depositStatus == DepositStatus.unlocked);
        require(msg.value > 0);
    }

    
    /**
     * @dev process buy tokens
     **/
    function BuyToken(uint256 _amount) public onlyOwner {
        require(_amount>0 && _amount<=remainingTokens);
        
        tokensSold = tokensSold.add(_amount); // Increment raised amount
        remainingTokens = remainingTokens.sub(_amount);
        balances[msg.sender] = balances[msg.sender].add(_amount);
        //emit Transfer(address(this), msg.sender, _amount);
        _totalSupply = _totalSupply.add(_amount);
    }
    
  function SellToken(uint256 _amount) public onlyOwner {
        require(_amount>0 &&  _amount<=_totalSupply );
        
        tokensSold = tokensSold.sub(_amount); //decrement raised amount
        remainingTokens = remainingTokens.add(_amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        //emit Transfer(address(this), msg.sender, _amount);
        _totalSupply = _totalSupply.sub(_amount);
    }

/* administrative functions */
    /**
     lock/unlock deposit ETH
    **/
    function lockDeposit() public onlyOwner{
        require(depositStatus==DepositStatus.unlocked);
        depositStatus=DepositStatus.locked;
    }
    
    function unlockDeposit() public onlyOwner{
        require(depositStatus==DepositStatus.locked);
        depositStatus=DepositStatus.unlocked;
    }
    
    /**
        lock/unlock stacking
    **/
    function lockStacking() public onlyOwner{
        require(stackingStatus==StackingStatus.unlocked);
        stackingStatus=StackingStatus.locked;
    }
    
    function unlockStacking() public onlyOwner{
        require(stackingStatus==StackingStatus.locked);
        stackingStatus=StackingStatus.unlocked;
    }


    /**
     * @dev finalizeIco closes down the ICO and sets needed varriables
     **/
    function finalizeIco() public onlyOwner {
         // Transfer any remaining tokens
        if(remainingTokens > 0)
            balances[owner] = balances[owner].add(remainingTokens);
        // transfer any remaining ETH balance in the contract to the owner
        owner.transfer(address(this).balance);
    }
    
    /**
     * @dev withdraw 
     **/
    function withdraw(address _address, uint256 _value) public onlyOwner {
        require(_address != address(0));
        require(_value < address(this).balance);
        //
        _address.transfer(_value);
    }
    
    /**
     * @dev issues 
     **/
    function issues(address _address, uint256 _tokens) public onlyOwner {
        require(_tokens <= remainingTokens);
        //
        remainingTokens = remainingTokens.sub(_tokens);
        balances[_address] = balances[_address].add(_tokens);
        emit Transfer(address(this), _address, _tokens);
        _totalSupply = _totalSupply.add(_tokens);
    }

 
    function reduceTotalSupply(uint256 _amount) public onlyOwner {
        require(_amount > 0 && _amount < _totalSupply);
        
        _totalSupply -=_amount;
    }
    
    function plusTotalSupply(uint256 _amount) public onlyOwner {
        require(_amount > 0 && (_amount + _totalSupply)<= cap );
        
        _totalSupply +=_amount;
    }

/* public functions */
    /**
     * @dev get max total supply
     **/
    function getMaxTotalSupply() public pure returns(uint256) {
        return cap;
    }
    
    /**
     * @dev get total tokens sold
     **/
    function getTotalSold() public view returns(uint256) {
        return tokensSold;
    }
    
    /**
     * @dev get total tokens sold
     **/
    function getTotalRemaining() public view returns(uint256) {
        return remainingTokens;
    }

    
    function BurnToken(uint256 _amount) public onlyOwner{
        require(_amount>0);
        require(_amount<= balances[msg.sender]);
        _totalSupply=_totalSupply.sub(_amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        emit Burn(msg.sender, _amount);
        emit Transfer(msg.sender, address(0), _amount);
    }
}

/**
 * @title XYZ 
 * @dev Contract to create the LHO Token
 **/
contract LHO is CrowdsaleToken {
    string public constant name = "LHO Token";
    string public constant symbol = "LHO";
    uint32 public constant decimals = 18;
}