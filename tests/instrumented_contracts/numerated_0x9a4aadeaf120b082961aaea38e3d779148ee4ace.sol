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
11     address public owner;
12 
13     // 建立映射 地址对应了 uint' 便是他的余额
14     mapping (address => uint256) public balanceOf;
15     // 地址对应余额
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18      // 事件，用来通知客户端Token交易发生
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21      // 事件，用来通知客户端代币被消耗(这里就不是转移, 是token用了就没了)
22     event Burn(address indexed from, uint256 value);
23 
24       // 事件，用来通知客户端代币有增发
25     event AddSupply(address indexed from, uint256 value);
26 
27 
28     // 这里是构造函数, 实例创建时候执行
29     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  // 这里确定了总发行量
31 
32         balanceOf[msg.sender] = totalSupply;    // 这里就比较重要, 这里相当于实现了, 把token 全部给合约的Creator
33 
34         name = tokenName;
35         symbol = tokenSymbol;
36         owner = msg.sender;
37     }
38 
39     // token的发送函数
40     function _transfer(address _from, address _to, uint _value) internal {
41         require(_to != 0x0);    // 不是零地址
42         require(balanceOf[_from] >= _value);        // 有足够的余额来发送
43         require(balanceOf[_to] + _value > balanceOf[_to]);  // 这里也有意思, 不能发送负数的值(hhhh)
44 
45         uint previousBalances = balanceOf[_from] + balanceOf[_to];  // 这个是为了校验, 避免过程出错, 总量不变对吧?
46         balanceOf[_from] -= _value; //发钱 不多说
47         balanceOf[_to] += _value;
48         emit Transfer(_from, _to, _value);   // 这里触发了转账的事件 , 见上event
49         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // 判断总额是否一致, 避免过程出错
50     }
51 
52     function transfer(address _to, uint256 _value) public {
53         _transfer(msg.sender, _to, _value); 
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
57         require(_value <= allowance[_from][msg.sender]);     // 这句很重要, 地址对应的合约地址(也就是token余额)
58         allowance[_from][msg.sender] -= _value;
59         _transfer(_from, _to, _value);
60         return true;
61     }
62 
63     function approve(address _spender, uint256 _value) public
64         returns (bool success) {
65         allowance[msg.sender][_spender] = _value;   // 这里是可花费总量
66         return true;
67     }
68 
69     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
70         tokenRecipient spender = tokenRecipient(_spender);
71         if (approve(_spender, _value)) {
72             spender.receiveApproval(msg.sender, _value, this, _extraData);
73             return true;
74         }
75     }
76     // 正如其名, 这个是烧币(SB)的.. ,用于把创建者的 token 烧掉
77     function burn(uint256 _value) public returns (bool success) {
78         require(balanceOf[msg.sender] >= _value);   // 必须要有这么多
79         balanceOf[msg.sender] -= _value;
80         totalSupply -= _value;
81         emit Burn(msg.sender, _value);
82         return true;
83     }
84     // 这个是用户销毁token.....
85     function burnFrom(address _from, uint256 _value) public returns (bool success) {
86         require(balanceOf[_from] >= _value);        // 一样要有这么多
87         require(_value <= allowance[_from][msg.sender]);    //
88         balanceOf[_from] -= _value;
89         allowance[_from][msg.sender] -= _value;
90         totalSupply -= _value;
91         emit Burn(_from, _value);
92         return true;
93     }
94 
95      // 正如其名, 这个是增发gas用的..
96     function addSupply(uint256 _value) public returns (bool success) {
97         require(owner == msg.sender);
98         balanceOf[msg.sender] += _value;
99         totalSupply += _value;
100         emit AddSupply(msg.sender, _value);
101         return true;
102     }
103 }