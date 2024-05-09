pragma solidity 0.4.20;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract ForeignToken {
    function balanceOf(address _owner) constant public returns (uint256);
    function transfer(address _to, uint256 _value) public returns (bool);
}

contract ERC20Basic {
    uint256 public totalSupply;
    function balanceOf(address who) public constant returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public constant returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Token { 
    function distr(address _to, uint256 _value) external returns (bool);
    function totalSupply() constant external returns (uint256 supply);
    function balanceOf(address _owner) constant external returns (uint256 balance);
}

contract iCORE is ERC20 {
    
    using SafeMath for uint256;
    address owner = msg.sender;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    mapping (address => bool) public blacklist;

    string public constant name = "iCORE";
    string public constant symbol = "iCORE";
    uint public constant decimals = 8;
    
    uint256 public totalSupply = 20000e8;
    uint256 public totalDistributed = 0;
    uint256 public totalRemaining = totalSupply.sub(totalDistributed);
    uint256 value;
    uint256 public freeTokens = 1000e8;
    
    // bot blacklist
    
    address bot1 = 0xEBB4d6cfC2B538e2a7969Aa4187b1c00B2762108;
    address bot2 = 0x93438E08C4edc17F867e8A9887284da11F26A09d;
    address bot3 = 0x8Be4DB5926232BC5B02b841dbeDe8161924495C4;
    address bot4 = 0x42D0ba0223700DEa8BCA7983cc4bf0e000DEE772;
    address bot5 = 0x00000000002bde777710C370E08Fc83D61b2B8E1;
    address bot6 = 0x1d6c43b4D829334d88ce609D7728Dc5f4736b3c7;
    address bot7 = 0x44BdB19dB1Cd29D546597AF7dc0549e7f6F9E480;
    address bot8 = 0xAfE0e7De1FF45Bc31618B39dfE42dd9439eEBB32;
    address bot9 = 0x5f3E759d09e1059e4c46D6984f07cbB36A73bdf1;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    event Distr(address indexed to, uint256 amount);
    event DistrFinished();
    
    event Burn(address indexed burner, uint256 value);

    bool public distributionFinished = false;
    
    modifier canDistr() {
        require(!distributionFinished);
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
   
    
    function iCORE () public {
        owner = msg.sender;
        value = 1e8;
        distr(owner, totalDistributed);
    }
    
    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
	
	function setFreeTokens(uint256 _amount) onlyOwner public {
		freeTokens = _amount;
    }
    

    function finishDistribution() onlyOwner canDistr public returns (bool) {
        distributionFinished = true;
        DistrFinished();
        return true;
    }
    
    function distr(address _to, uint256 _amount) canDistr private returns (bool) {
        totalDistributed = totalDistributed.add(_amount);
        totalRemaining = totalRemaining.sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        Distr(_to, _amount);
        Transfer(address(0), _to, _amount);
        return true;
        
        if (totalDistributed >= totalSupply) {
            distributionFinished = true;
        }
    }
    
   
    function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner canDistr public {
        
        require(addresses.length <= 255);
        require(addresses.length == amounts.length);
        
        for (uint8 i = 0; i < addresses.length; i++) {
            amounts[i]=amounts[i].mul(1e8);
            require(amounts[i] <= totalRemaining);

            distr(addresses[i], amounts[i]);
            
            if (totalDistributed >= totalSupply) {
                distributionFinished = true;
            }
        }
    }
    
    function () external payable {
		
            getFreeTokens();
			owner.transfer(msg.value);
     }
    
    function getFreeTokens() payable canDistr public {
        
		require(value <= freeTokens);
		
        
        address investor = msg.sender;
        uint256 toGive = value;
        
        require(blacklist[investor] != true);
		
		freeTokens = freeTokens.sub(value);
        distr(investor, toGive);
        
        if (toGive > 0) {
            blacklist[investor] = true;
        }
    }

    function balanceOf(address _owner) constant public returns (uint256) {
	    return balances[_owner];
    }
	

    // mitigates the ERC20 short address attack
    modifier onlyPayloadSize(uint size) {
        assert(msg.data.length >= size + 4);
        _;
    }
    
    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {

        require(_to != address(0));
        require(_amount <= balances[msg.sender]);
        require(msg.sender != bot1 && msg.sender != bot2 && msg.sender != bot3 && msg.sender != bot4 && msg.sender != bot5 && msg.sender != bot6 && msg.sender != bot7 && msg.sender != bot8 && msg.sender != bot9);
        
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        Transfer(msg.sender, _to, _amount);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {

        require(_to != address(0));
        require(_amount <= balances[_from]);
        require(_amount <= allowed[_from][msg.sender]);
        require(_from != bot1 && _from != bot2 && _from != bot3 && _from != bot4 && _from != bot5 && _from != bot6 && _from != bot7 && _from != bot8 && _from != bot9);
        
        balances[_from] = balances[_from].sub(_amount);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        Transfer(_from, _to, _amount);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // mitigates the ERC20 spend/approval race condition
        if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) constant public returns (uint256) {
        return allowed[_owner][_spender];
    }
    
    function burn(uint256 _value) onlyOwner public {
        
        _value=_value.mul(1e8);
        require(_value <= balances[msg.sender]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which should be an assertion failure
        
        address burner = msg.sender;

        balances[burner] = balances[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        totalDistributed = totalDistributed.sub(_value);
        Burn(burner, _value);
		Transfer(burner, address(0), _value);
    }
    
    function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
        ForeignToken token = ForeignToken(_tokenContract);
        uint256 amount = token.balanceOf(address(this));
        return token.transfer(owner, amount);
    }


}