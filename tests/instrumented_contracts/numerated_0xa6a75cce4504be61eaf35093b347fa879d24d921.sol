1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }  // token的 接受者 这里声明接口, 将会在我们的ABI里
4 
5 contract TokenERC20 {
6 /*********Token的属性说明************/
7     string public name = 'Super DataBase Coin';
8     string public symbol = 'SDBC';
9     uint8 public decimals = 8;  // 18 是建议的默认值
10     uint256 public totalSupply; // 发行量
11 
12     // 建立映射 地址对应了 uint' 便是他的余额
13     mapping (address => uint256) public balanceOf;   
14     // 地址对应余额
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17      // 事件，用来通知客户端Token交易发生
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20      // 事件，用来通知客户端代币被消耗(这里就不是转移, 是token用了就没了)
21     event Burn(address indexed from, uint256 value);
22 
23     // 这里是构造函数, 实例创建时候执行
24     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
25         totalSupply = initialSupply * 10 ** uint256(decimals);  // 这里确定了总发行量
26 
27         balanceOf[msg.sender] = totalSupply;    // 这里就比较重要, 这里相当于实现了, 把token 全部给合约的Creator
28 
29         name = tokenName;
30         symbol = tokenSymbol;
31     }
32 
33     // token的发送函数
34     function _transfer(address _from, address _to, uint _value) internal {
35 
36         require(_to != 0x0);    // 不是零地址
37         require(balanceOf[_from] >= _value);        // 有足够的余额来发送
38         require(balanceOf[_to] + _value > balanceOf[_to]);  // 这里也有意思, 不能发送负数的值(hhhh)
39 
40         uint previousBalances = balanceOf[_from] + balanceOf[_to];  // 这个是为了校验, 避免过程出错, 总量不变对吧?
41         balanceOf[_from] -= _value; //发钱 不多说
42         balanceOf[_to] += _value;
43         Transfer(_from, _to, _value);   // 这里触发了转账的事件 , 见上event
44         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // 判断总额是否一致, 避免过程出错
45     }
46 
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value); // 这里已经储存了 合约创建者的信息, 这个函数是只能被合约创建者使用
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         require(_value <= allowance[_from][msg.sender]);     // 这句很重要, 地址对应的合约地址(也就是token余额)
53         allowance[_from][msg.sender] -= _value;
54         _transfer(_from, _to, _value);
55         return true;
56     }
57 
58     function approve(address _spender, uint256 _value) public
59         returns (bool success) {
60         allowance[msg.sender][_spender] = _value;   // 这里是可花费总量
61         return true;
62     }
63 
64     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
65         tokenRecipient spender = tokenRecipient(_spender);
66         if (approve(_spender, _value)) {
67             spender.receiveApproval(msg.sender, _value, this, _extraData);
68             return true;
69         }
70     }
71 }