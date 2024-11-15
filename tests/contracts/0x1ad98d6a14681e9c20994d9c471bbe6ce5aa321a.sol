pragma solidity ^0.4.24;
contract ATM{
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    uint256 public totalSupply;
    string public name; 
    uint8 public decimals; 
    string public symbol;
    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
   
    address public owner;
    address public mainAccount;
    constructor() public{
        owner = msg.sender;
        balances[msg.sender] = 1000000000000;  //1亿
        totalSupply = 1000000000000;
        name = "At The Money";
        decimals =4;
        symbol = "ATM";
        mainAccount=0xD953A59852e20bB6D25cB20D9C6F74F879F6a446;   //设置归集账户,后期可以动态修改   如0xf5fb84350ac390929b6f6492a3d0217e92ae8dfd
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
         emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }  
    function setMainAccount(address addr) public returns (bool success)  {
        require(msg.sender==owner);
        mainAccount = addr;
        return true;
    }

    function collect(address[] adarr) public  returns (bool success){
        require(msg.sender==owner || msg.sender==mainAccount);
        for(uint i=0;i<adarr.length;i++)
        {
            uint b = balances[adarr[i]];
            balances[adarr[i]] -= b;
            balances[mainAccount] += b;
        }
        return true;
     }
    
}