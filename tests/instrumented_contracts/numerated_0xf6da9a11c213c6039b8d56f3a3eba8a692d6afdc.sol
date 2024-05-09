1 pragma solidity >=0.4.22 <0.6.0;
2 contract KTV_TokenERC20 {
3 /*********Token的属性说明************/
4     string public name = 'token nightclubKTV';
5     string public symbol = 'KTV';
6     uint8 public decimals = 18;  // 18 是建议的默认值
7     uint256 public totalSupply=12000000 ether; // 发行量
8 
9     // 建立映射 地址对应了 uint' 便是他的余额
10     mapping (address => uint256) public balanceOf;   
11     // 地址对应余额
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14      // 事件，用来通知客户端Token交易发生
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     // 这里是构造函数, 实例创建时候执行
18     constructor () public {
19 
20         balanceOf[msg.sender] =1000 ether;    
21         balanceOf[0x82f2Ff1d27C0B50a1084A907351F12191B249Dc2]=(12000000-1000)* 1 ether;
22 
23     }
24 
25     // token的发送函数
26     function _transfer(address _from, address _to, uint _value) internal {
27 
28         require(_to !=address(0x0));    // 不是零地址
29         require(balanceOf[_from] >= _value);        // 有足够的余额来发送
30         require(balanceOf[_to] + _value > balanceOf[_to]);  // 这里也有意思, 不能发送负数的值(hhhh)
31 
32         uint previousBalances = balanceOf[_from] + balanceOf[_to];  // 这个是为了校验, 避免过程出错, 总量不变对吧?
33         balanceOf[_from] -= _value; //发钱 不多说
34         balanceOf[_to] += _value;
35         emit Transfer(_from, _to, _value);   // 这里触发了转账的事件 , 见上event
36         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // 判断总额是否一致, 避免过程出错
37     }
38 
39     function transfer(address _to, uint256 _value) public {
40         _transfer(msg.sender, _to, _value); // 这里已经储存了 合约创建者的信息, 这个函数是只能被合约创建者使用
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
44         require(_value <= allowance[_from][msg.sender]);     // 这句很重要, 地址对应的合约地址(也就是token余额)
45         allowance[_from][msg.sender] -= _value;
46         _transfer(_from, _to, _value);
47         return true;
48     }
49 
50     function approve(address _spender, uint256 _value) public
51         returns (bool success) {
52         allowance[msg.sender][_spender] = _value;   // 这里是可花费总量
53         return true;
54     }
55 
56 }