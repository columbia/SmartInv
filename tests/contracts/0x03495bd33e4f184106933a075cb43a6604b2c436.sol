pragma solidity ^0.4.21;

contract EIP20Interface {
	// 获取总的支持量
    uint256 public totalSupply;
    // 获取其他地址的余额
    function balanceOf(address _owner) public view returns (uint256 balance);
    // 调用者向_to地址发送_value数量的token
    function transfer(address _to, uint256 _value) public returns (bool success);
    //从_from地址向_to地址发送_value数量的token
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    //允许_spender从自己的账户转出_value数量的token，调用多次会覆盖可用量。
	function approve(address _spender, uint256 _value) public returns (bool success);
    // 返回_spender仍然允许从_owner获取的余额数量
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    // token转移完成后触发
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    // approve调用后触发
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract MyToken is EIP20Interface {
    //注意以下四个状态变量必须公开，并且变量名不能变化，如decimals，命名为decimal。否则与其它钱包应用不能兼容。
    uint256 public totalSupply;
    uint8 public decimals;
    string public name;
    string public symbol;
    
    mapping(address=>uint256) public balances;
    mapping(address=>mapping(address=>uint256)) public allowed;
    
    function MyToken(
        uint256 _totalSupply,
        uint8 _decimal,
        string _name,
        string _symbol) public {
            
        totalSupply = _totalSupply;
        decimals = _decimal;
        name = _name;
        symbol = _symbol;
        
        balances[msg.sender] = totalSupply;
    }

    
    // 获取其他地址的余额
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    // 调用者向_to地址发送_value数量的token
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value && _value > 0);
        require(balances[_to] + _value > balances[_to]);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    
    //从_from地址向_to地址发送_value数量的token
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
	    uint256 allow = allowed[_from][_to];
	    require(_to == msg.sender && allow >= _value && balances[_from] >= _value);
	    require(balances[_to] + _value > balances[_to]);
	    allowed[_from][_to] -= _value;
	    balances[_from] -= _value;
	    balances[_to] += _value;
	    emit Transfer(_from, _to, _value);
	    return true;
	}
	
    //允许_spender从自己的账户转出_value数量的token，调用多次会覆盖可用量。
	function approve(address _spender, uint256 _value) public returns (bool success) {
	    require(balances[msg.sender] >= _value && _value > 0 );
	    allowed[msg.sender][_spender] = _value;
	    emit Approval(msg.sender, _spender, _value);
	    return true;
	}
	
    // 返回_spender仍然允许从_owner获取的余额数量
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}