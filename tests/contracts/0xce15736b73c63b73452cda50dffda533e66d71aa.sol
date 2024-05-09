pragma solidity ^0.4.25;

// File: SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {    

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
   
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // assert(_b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
    return _a / _b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b <= _a);
    return _a - _b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
 
}

// File: BACCToken.sol

contract BACCToken {

    using SafeMath for uint256;   

    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    //--------------------------------  Basic Info  -------------------------------------//

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    //--------------------------------  Basic Info  -------------------------------------//


  
    
    //--------------------------------  Admin Info  -------------------------------------//

    address internal admin;  //Admin address
     
    event ChangeAdmin(address indexed admin, address indexed newAdmin);
  
    modifier onlyAdmin() {
        require(msg.sender == admin); 
        _;
    }
  
  
    /**
     * @dev Change admin address
     * @param newAdmin New admin address
     */
    function changeAdmin(address newAdmin) public onlyAdmin returns (bool)  {
        require(newAdmin != address(0));
        uint256 balAdmin = balances[admin];
        balances[newAdmin] = balances[newAdmin].add(balAdmin);
        balances[admin] = 0;
        emit Transfer(admin, newAdmin, balAdmin);
        emit ChangeAdmin(admin, newAdmin);
        admin = newAdmin;          
        return true;
    }

    //--------------------------------  Admin Info  -------------------------------------//
    
    //-----------------------------  Transfer switch  ----------------------------------//

    bool public allowedTransfer;     //Whether transfering token is allowed
    bool public allowedMultiTransfer;     //Whether multi transfering token is allowed
    
    /**
     * @dev Change allowedTransfer flag
     * @param newAllowedTransfer whether transfering token is allowed
     */
    function changeAllowedTransfer(bool newAllowedTransfer) public onlyAdmin returns (bool)  {
       // require(msg.sender == admin);        
        allowedTransfer = newAllowedTransfer;
        return true;
    }
    
    /**
     * @dev Change allowedMultiTransfer flag
     * @param newAllowedMultiTransfer whether multi transfering token is allowed
     */
    function changeAllowedMultiTransfer(bool newAllowedMultiTransfer) public onlyAdmin returns (bool)  {
      //  require(msg.sender == admin);        
        allowedMultiTransfer = newAllowedMultiTransfer;
        return true;
    }
    
    //-----------------------------  Transfer switch  ----------------------------------//

    //--------------------------  Events & Constructor  ------------------------------//
    
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    // constructor
    constructor(string tokenName, string tokenSymbol, uint8 tokenDecimals, uint256 totalTokenSupply) public {
        name = tokenName;
        symbol = tokenSymbol;
        decimals = tokenDecimals;
        totalSupply = totalTokenSupply;
        admin = msg.sender;
        balances[msg.sender] = totalTokenSupply;
        allowedTransfer = true;
        allowedMultiTransfer = true;
        emit Transfer(address(0x0), msg.sender, totalTokenSupply); 

    }

    //--------------------------  Events & Constructor  ------------------------------//
    
    //------------------------------ Account lock  -----------------------------------//

    // The same account is frozen if it satisfies any freezing conditions
    mapping (address => bool)  public frozenAccount; //Accounts frozen indefinitely
    mapping (address => uint256) public frozenTimestamp; // Accounts frozen for a limited period

   

    /**
     * Lock accounts
     */
    function freeze(address _target, bool _freeze) public onlyAdmin returns (bool) {
      //  require(msg.sender == admin);          
        require(_target != admin);
        frozenAccount[_target] = _freeze;
        return true;
    }

    /**
     * Locking accounts through timestamps
     */
    function freezeWithTimestamp(address _target, uint256 _timestamp) public onlyAdmin returns (bool) {
     //   require(msg.sender == admin);          
        require(_target != admin); 
        frozenTimestamp[_target] = _timestamp;
        return true;
    }

    /**
     * Batch Lock-in Account
     */
    function multiFreeze(address[] _targets, bool[] _freezes) public onlyAdmin returns (bool) {
      //  require(msg.sender == admin);         
        require(_targets.length == _freezes.length);
        uint256 len = _targets.length;
        require(len > 0);
        for (uint256 i = 0; i < len; i = i.add(1)) {
            address _target = _targets[i];
            require(_target != admin);
            bool _freeze = _freezes[i];
            frozenAccount[_target] = _freeze;
        }
        return true;
    }

    /**
     * Lock accounts in batches through timestamps
     */
    function multiFreezeWithTimestamp(address[] _targets, uint256[] _timestamps) public onlyAdmin returns (bool) {
       // require(msg.sender == admin);        
       // require(_targets.length == _timestamps.length);    
        require(_targets.length > 0 && _targets.length == _timestamps.length);
        uint256 len = _targets.length;           
        for (uint256 i = 0; i < len; i = i.add(1)) {
            address _target = _targets[i];
            require(_target != admin);
            uint256 _timestamp = _timestamps[i];
            frozenTimestamp[_target] = _timestamp;
        }
        return true;
    }

    //------------------------------  Account lock  -----------------------------------//


    //-------------------------  Standard ERC20 Interfaces  --------------------------//

    function multiTransfer(address[] _tos, uint256[] _values) public returns (bool) {
        require(allowedMultiTransfer);
        require(!frozenAccount[msg.sender]);
        require(now > frozenTimestamp[msg.sender]);
       // require(_tos.length == _values.length);     
        require(_tos.length > 0 && _tos.length == _values.length);
        uint256 len = _tos.length;
        uint256 amount = 0;
        for (uint256 i = 0; i < len; i = i.add(1)) {
            amount = amount.add(_values[i]);
        }
        require(balances[msg.sender] >= amount);
        for (uint256 j = 0; j < len; j = j.add(1)) {
            address _to = _tos[j];        
            require(_to != address(0));
            balances[_to] = balances[_to].add(_values[j]);
            balances[msg.sender] = balances[msg.sender].sub(_values[j]);
            emit Transfer(msg.sender, _to, _values[j]);
        }
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(allowedTransfer);
        require(!frozenAccount[msg.sender]);
        require(now > frozenTimestamp[msg.sender]);
        require(balances[msg.sender].sub(_value) >= 0);    
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) { 
        require(_to != address(0));
        require(allowedTransfer);
        require(!frozenAccount[_from]);
        require(now > frozenTimestamp[_from]);
        require(balances[_from].sub(_value) >= 0);    
        require(allowed[_from][msg.sender] >= _value);   

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) { 
        require(_value == 0 || allowed[msg.sender][_spender] == 0);
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    //-------------------------  Standard ERC20 Interfaces  --------------------------//
}