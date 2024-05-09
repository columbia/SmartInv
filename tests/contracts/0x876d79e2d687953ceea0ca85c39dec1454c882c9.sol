pragma solidity ^0.4.24;

//SafeMath库，用于防止数据溢出等安全漏洞
library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

//下面是一个标准的ERC20合约
contract ERC20  {
  //使用SafeMath防止数据溢出
  using SafeMath for uint256;
  //总发行量
  uint256 totalSupply_;
  //用户token余额
  mapping(address => uint256) balances;
  //授权token转移
  mapping (address => mapping (address => uint256)) internal allowed;
  
  //token转移事件
  event Transfer(address indexed from, address indexed to, uint256 value);
  
  //token授权事件
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
  
  //查询token总发行量
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }
  
  //token转移
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    //检查余额
    require(_value <= balances[msg.sender]);
    //转移token到目标地址
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }
  
  //查询余额
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }
  
  //代为转移token，前提是已获得他人授权
  function transferFrom(address _from, address _to,
    uint256 _value ) public returns (bool) {
    require(_to != address(0));
    //检查余额是否足够
    require(_value <= balances[_from]);
    //检查是否已获得转移token的授权
    require(_value <= allowed[_from][msg.sender]);
    //转移指定账户的token到目标账户
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  //授权指定数量的token转移权限给某个地址
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  //查询授权token转移的数量
  function allowance( address _owner, address _spender) 
  public view returns (uint256)  {
    return allowed[_owner][_spender];
  }

  //增加授权转移token的数量
  function increaseApproval(address _spender,
    uint256 _addedValue)
    public returns (bool) {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }
  
  //减少授权转移Token的数量
  function decreaseApproval(address _spender,
    uint256 _subtractedValue)
    public returns (bool) {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }
}


// 以下合约拓展ERC20标准，增加了一些特定的功能，如增发、锁定等。
contract NewToken is ERC20 {
    address public admin; // 管理员
    string public name = "AARK"; // 代币名称
    string public symbol = "AARK"; // 代币符号
    uint8 public decimals = 18; // 代币精度
    uint256 public INITIAL_SUPPLY = 0; // 发行总量


    //只能由积分发行方调用
    modifier onlyAdmin(){
        if (msg.sender == admin) _;
    }

    // 构造函数
    constructor(uint256 _INITIAL_SUPPLY,
                string _name,
                string _symbol,
                address _admin) public {
        require(_INITIAL_SUPPLY>0);
        name = _name;
        symbol = _symbol;
        INITIAL_SUPPLY = _INITIAL_SUPPLY;
        totalSupply_ = INITIAL_SUPPLY;
        admin = _admin;
        balances[admin] = INITIAL_SUPPLY;
    }



    //修改管理员
    function changeAdmin( address _newAdmin )
    onlyAdmin public returns (bool)  {
        balances[_newAdmin] = balances[_newAdmin].add(balances[admin]);
        balances[admin] = 0;
        admin = _newAdmin;
        return true;
    }
    // 增发
    function generateToken( address _target, uint256 _amount)
    onlyAdmin public returns (bool)  {
        balances[_target] = balances[_target].add(_amount);
        totalSupply_ = totalSupply_.add(_amount);
        INITIAL_SUPPLY = totalSupply_;
        return true;
    }


    //批量转账
    function multiTransfer( address[] _tos, uint256[] _values)
    public returns (bool) {

        require(_tos.length == _values.length);
        uint256 len = _tos.length;
        require(len > 0);
        uint256 amount = 0;
        for (uint256 i = 0; i < len; i = i.add(1)) {
            amount = amount.add(_values[i]);
        }
        require(amount <= balances[msg.sender]);
        for (uint256 j = 0; j < len; j = j.add(1)) {
            address _to = _tos[j];
            require(_to != address(0));
            balances[_to] = balances[_to].add(_values[j]);
            balances[msg.sender] = balances[msg.sender].sub(_values[j]);
            emit Transfer(msg.sender, _to, _values[j]);
        }
        return true;
    }

    //从调用者转账至_to
    function transfer(address _to, uint256 _value )
    public returns (bool) {

        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    //从调用者作为from代理将from账户中的token转账至to
    //调用者在from的许可额度中必须>=value
    function transferFrom(address _from,address _to,
    uint256 _value)
    public returns (bool)
    {

        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        emit Transfer(_from, _to, _value);
        return true;
    }


    

    
    // 修改name
    function setName ( string _value )
    onlyAdmin  public returns (bool) {
        name = _value;
        return true;
    }
    
    // 修改symbol
    function setSymbol ( string _value )
    onlyAdmin public returns (bool) {
        symbol = _value;
        return true;
    }


    



}