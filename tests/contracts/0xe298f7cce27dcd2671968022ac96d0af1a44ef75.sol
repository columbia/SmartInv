pragma solidity ^0.5.8;

//=========================================================================================
// Allocation Supply 
// - Private Sale    :   500.000.000 // 10%
// - IEO             : 1.000.000.000 // 20%
// - Founder         :   250.000.000 //  5% == lock 12 month
// - Team & Partners :   500.000.000 // 10% == lock 10 month // unlock 10% for every month
// - Airdrop         :   250.000.000 //  5% 
// - Reserved        : 2.500.000.000 // 50% == lock 6 month == Just used for reward apps
// 
// For more Information visit https://www.delgoplus.com
//=========================================================================================


contract SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Token {
  
  function totalSupply() public view returns (uint256 supply);
  function balanceOf(address _owner) public view returns (uint256 balance);
  function transfer(address _to, uint256 _value) public returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
  function approve(address _spender, uint256 _value) public returns (bool success);
  function allowance(address _owner, address _spender) public view returns (uint256 remaining);
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract ERC20Token is Token, SafeMath {

  constructor () public {
    // Do nothing
  }

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return accounts [_owner];
  }

  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(_to != address(0));
    if (accounts [msg.sender] < _value) return false;
    if (_value > 0 && msg.sender != _to) {
      accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
      accounts [_to] = safeAdd (accounts [_to], _value);
    }
    emit Transfer (msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public
  returns (bool success) {
    require(_to != address(0));
    if (allowances [_from][msg.sender] < _value) return false;
    if (accounts [_from] < _value) return false; 

    if (_value > 0 && _from != _to) {
      allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);
      accounts [_from] = safeSub (accounts [_from], _value);
      accounts [_to] = safeAdd (accounts [_to], _value);
    }
    emit Transfer(_from, _to, _value);
    return true;
  }

   function approve (address _spender, uint256 _value) public returns (bool success) {
    allowances [msg.sender][_spender] = _value;
    emit Approval (msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public view
  returns (uint256 remaining) {
    return allowances [_owner][_spender];
  }

  mapping (address => uint256) accounts;
  mapping (address => mapping (address => uint256)) private allowances;
  
}

contract DELGOPlus is ERC20Token {

  uint256 constant TotalSupply = 5000000000e8;

  address private owner;

  mapping (address => bool) private frozenAccount;

  uint256 tokenCount = 0;

  bool frozen = false;

  constructor () public {
    owner = msg.sender;
  }

  function totalSupply() public view returns (uint256 supply) {
    return tokenCount;
  }

  string constant public name = "DELGOPlus";
  string constant public symbol = "DELGO";
  uint8 constant public decimals = 8;
  

  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(!frozenAccount[msg.sender]);
    if (frozen) return true;
    else return ERC20Token.transfer (_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public
    returns (bool success) {
    require(!frozenAccount[_from]);
    if (frozen) return true;
    else return ERC20Token.transferFrom (_from, _to, _value);
  }

  function approve (address _spender, uint256 _value) public
    returns (bool success) {
    require(allowance (msg.sender, _spender) == 0 || _value == 0);
    return ERC20Token.approve (_spender, _value);
  }

  function createTokens(uint256 _value) public
    returns (bool success) {
    require (msg.sender == owner);

    if (_value > 0) {
      if (_value > safeSub (TotalSupply, tokenCount)) return false;
      
      accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
      tokenCount = safeAdd (tokenCount, _value);

      emit Transfer(address(0), msg.sender, _value);
      return true;
    }
    
      return false;
    
  }

  function burn(uint256 _value) public returns (bool success) {
  
        require(accounts[msg.sender] >= _value); 
        require (msg.sender == owner);
        
        accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
        tokenCount = safeSub (tokenCount, _value);  
        emit Burn(msg.sender, _value);
        return true;
    }   

  function setOwner(address _newOwner) public {
    require (msg.sender == owner);
    owner = _newOwner;
    }
  
  function freezeAccount(address _target, bool freeze) public {
      require (msg.sender == owner);
      require (msg.sender != _target);
      frozenAccount[_target] = true;
      emit FrozenFunds(_target, freeze);

 }
  event Freeze ();
  event Unfreeze ();
  event FrozenFunds(address target, bool frozen);
  event Burn(address target,uint256 _value);

}