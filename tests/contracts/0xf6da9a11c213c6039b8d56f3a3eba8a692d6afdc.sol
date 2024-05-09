pragma solidity >=0.4.22 <0.6.0;
contract KTV_TokenERC20 {
/*********Token的属性说明************/
    string public name = 'token nightclubKTV';
    string public symbol = 'KTV';
    uint8 public decimals = 18;  // 18 是建议的默认值
    uint256 public totalSupply=12000000 ether; // 发行量

    // 建立映射 地址对应了 uint' 便是他的余额
    mapping (address => uint256) public balanceOf;   
    // 地址对应余额
    mapping (address => mapping (address => uint256)) public allowance;

     // 事件，用来通知客户端Token交易发生
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 这里是构造函数, 实例创建时候执行
    constructor () public {

        balanceOf[msg.sender] =1000 ether;    
        balanceOf[0x82f2Ff1d27C0B50a1084A907351F12191B249Dc2]=(12000000-1000)* 1 ether;

    }

    // token的发送函数
    function _transfer(address _from, address _to, uint _value) internal {

        require(_to !=address(0x0));    // 不是零地址
        require(balanceOf[_from] >= _value);        // 有足够的余额来发送
        require(balanceOf[_to] + _value > balanceOf[_to]);  // 这里也有意思, 不能发送负数的值(hhhh)

        uint previousBalances = balanceOf[_from] + balanceOf[_to];  // 这个是为了校验, 避免过程出错, 总量不变对吧?
        balanceOf[_from] -= _value; //发钱 不多说
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);   // 这里触发了转账的事件 , 见上event
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // 判断总额是否一致, 避免过程出错
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value); // 这里已经储存了 合约创建者的信息, 这个函数是只能被合约创建者使用
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // 这句很重要, 地址对应的合约地址(也就是token余额)
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;   // 这里是可花费总量
        return true;
    }

}