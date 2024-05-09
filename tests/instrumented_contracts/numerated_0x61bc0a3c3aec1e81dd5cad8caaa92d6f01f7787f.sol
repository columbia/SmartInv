1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }  // token的 接受者 这里声明接口, 将会在我们的ABI里
4 
5 contract TokenERC20 {
6 /*********Token的属性说明************/
7     string public name ;
8     string public symbol ;
9     uint8 public decimals = 18;  // 18 是建议的默认值
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
35         require(_to != 0x0);    // 不是零地址
36         require(balanceOf[_from] >= _value);        // 有足够的余额来发送
37         require(balanceOf[_to] + _value > balanceOf[_to]);  // 这里也有意思, 不能发送负数的值(hhhh)
38 
39         uint previousBalances = balanceOf[_from] + balanceOf[_to];  // 这个是为了校验, 避免过程出错, 总量不变对吧?
40         balanceOf[_from] -= _value; //发钱 不多说
41         balanceOf[_to] += _value;
42         emit Transfer(_from, _to, _value);   // 这里触发了转账的事件 , 见上event
43         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // 判断总额是否一致, 避免过程出错
44     }
45 
46     function transfer(address _to, uint256 _value) public {
47         _transfer(msg.sender, _to, _value); 
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         require(_value <= allowance[_from][msg.sender]);     // 这句很重要, 地址对应的合约地址(也就是token余额)
52         allowance[_from][msg.sender] -= _value;
53         _transfer(_from, _to, _value);
54         return true;
55     }
56 
57     function approve(address _spender, uint256 _value) public
58         returns (bool success) {
59         allowance[msg.sender][_spender] = _value;   // 这里是可花费总量
60         return true;
61     }
62 
63     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
64         tokenRecipient spender = tokenRecipient(_spender);
65         if (approve(_spender, _value)) {
66             spender.receiveApproval(msg.sender, _value, this, _extraData);
67             return true;
68         }
69     }
70     // 正如其名, 这个是烧币的.. ,用于把创建者的 token 烧掉
71     function burn(uint256 _value) public returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);   // 必须要有这么多
73         balanceOf[msg.sender] -= _value;
74         totalSupply -= _value;
75         emit Burn(msg.sender, _value);
76         return true;
77     }
78     // 这个是用户销毁token.....
79     function burnFrom(address _from, uint256 _value) public returns (bool success) {
80         require(balanceOf[_from] >= _value);        // 一样要有这么多
81         require(_value <= allowance[_from][msg.sender]);    // 
82         balanceOf[_from] -= _value;
83         allowance[_from][msg.sender] -= _value;
84         totalSupply -= _value;
85         emit Burn(_from, _value);
86         return true;
87     }
88 }