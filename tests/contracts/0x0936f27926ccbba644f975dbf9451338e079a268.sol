pragma solidity ^0.4.25;

contract Utils {
    function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
        uint256 _z = _x + _y;
        assert(_z >= _x);
        return _z;
    }

    function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
        assert(_x >= _y);
        return _x - _y;
    }

    function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
        uint256 _z = _x * _y;
        assert(_x == 0 || _z / _x == _y);
        return _z;
    }
    
    function safeDiv(uint256 _x, uint256 _y) internal pure returns (uint256) {
        assert(_y != 0); 
        uint256 _z = _x / _y;
        assert(_x == _y * _z + _x % _y); 
        return _z;
    }

}

contract Ownable {
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address newOwner) onlyOwner public {
        require(newOwner != address(0));
        owner = newOwner;
    }
}

contract ERC20Token {
    function balanceOf(address who) public constant returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    function approve(address _spender, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
}

contract StandardToken is ERC20Token, Utils, Ownable {

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowed;
    mapping (address => mapping (address => uint256)) public allowance;
    
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value > balanceOf[_to]); 
        
        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balanceOf[_owner];
    }
    
    
    function approve(address _spender, uint256 _value) returns (bool success) {
		require (_value > 0); 
        allowance[msg.sender][_spender] = _value;
        return true;
    }
      

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        require (_value > 0 && balanceOf[_from] >= _value && _value <= allowance[_from][msg.sender] && balanceOf[_to] + _value > balanceOf[_to]);     
        
        balanceOf[_from] = safeSub(balanceOf[_from], _value);                          
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);                           
        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
        Transfer(_from, _to, _value);
        return true;
    }

}

contract YouFoxToken is StandardToken {

    string public constant name = "YouFoxToken";
    string public constant symbol = "YFT"; 
    uint8 public constant decimals = 18;
    uint256 public totalSupply = 2 * 10**26;
    address public constant OwnerWallet = 0xCB1Df93fE09772D8d5f52263e6b2DE7ca3adFF7e;
    
    function YouFoxToken(){
        balanceOf[OwnerWallet] = totalSupply;
        
        Transfer(0x0, OwnerWallet, balanceOf[OwnerWallet]);
    }
}