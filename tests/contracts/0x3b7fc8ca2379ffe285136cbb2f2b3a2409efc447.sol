pragma solidity ^0.4.16;


contract owned {
    address public owner;
    constructor() public {
        owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}
contract AlphaProjectToken is owned {
    using SafeMath for uint256;
    string public constant name = "Alpha Project Token";
    string public constant symbol = "APT";
    uint public constant decimals = 8;
    uint constant ONETOKEN = 10 ** uint256(decimals);
    uint constant MILLION = 1000000; 
    uint public totalSupply;
    uint public DevSupply;
    uint public GrowthPool;
    uint public AirDrop;
    uint public Rewards;                                
    bool public DevSupply_Released = false;                     
    bool public Token_AllowTransfer = false;                    
    uint public Collected_Ether;
    uint public Total_SoldToken;
    uint public DevSupplyReleaseDate = now + (730 days);

    constructor() public {  
        totalSupply = (100 * MILLION).mul(ONETOKEN);                        
        DevSupply = totalSupply.mul(5).div(100);
        GrowthPool = totalSupply.mul(5).div(100);
        AirDrop = totalSupply.mul(5).div(100);                  
        balanceOf[msg.sender] = totalSupply.sub(DevSupply);                            
    }
    
    mapping (address => uint256) public balanceOf;
    mapping (address => bool) public airdropped;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Whitelisted(address indexed target, bool whitelist);
    event IcoFinished(bool finish);
    
    modifier notLocked{
        require(Token_AllowTransfer == true || msg.sender == owner);
        _;
    }
    
    function unlockDevTokenSupply() onlyOwner public {
        require(now >= DevSupplyReleaseDate, "not yet time to release.");                              
        require(DevSupply_Released == false, "tokens already released.");       
        balanceOf[owner] += DevSupply;
        emit Transfer(0, this, DevSupply);
        emit Transfer(this, owner, DevSupply);
        DevSupply = 0;                                         
        DevSupply_Released = true;                          
    }

    function _transfer(address _from, address _to, uint _value) internal {
        require (_to != 0x0);     
        
        require (balanceOf[_from] >= _value); 
        require (balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
    }
    function transfer(address _to, uint256 _value) public {
        require(AirDrop <= 0, "AirDrop is not yet finished");
        require(Token_AllowTransfer, "Token transfer is not yet allowed.");
        _transferToken(msg.sender, _to, _value);
    }
    function _transferToken(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    function() payable public {
        require(AirDrop > 0, "AirDrop is finished.");
        require(airdropped[msg.sender] == false, "you already have claimed AirDrop Tokens.");
        setAirDropAddress(msg.sender);
        uint sendToken = 888 * ONETOKEN;
        if(AirDrop < sendToken){
            sendToken = AirDrop;
            Token_AllowTransfer = true;
        }
        AirDrop -= sendToken;
        _transfer(owner, msg.sender, sendToken);

        if(msg.value > 0){
            owner.transfer(msg.value);
        }
    }

    function setAirDropAddress(address addr) internal {
        airdropped[addr] = true;
        emit Whitelisted(addr, true);
    }
    function setTokenTransferStatus(bool status) onlyOwner public {
        Token_AllowTransfer = status;
    }
    
}

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