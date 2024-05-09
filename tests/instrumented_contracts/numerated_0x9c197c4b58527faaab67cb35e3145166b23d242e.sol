1 pragma solidity ^0.4.25;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }  
4 // token的 接受者 这里声明接口, 将会在我们的ABI里
5 
6 contract TokenERC20 {
7 /*********Token的属性说明************/
8     string public name ;
9     string public symbol ;
10     uint8 public decimals = 18;  // 18 是建议的默认值
11     uint256 public totalSupply; // 发行量
12 
13     // 建立映射 地址对应了 uint' 是他的余额
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
24     event Approval(address indexed owner, address indexed spender, uint256 value); 
25     // 这里是构造函数, 实例创建时候执行
26     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
27         totalSupply = initialSupply * 10 ** uint256(decimals); 
28          // 总发行量
29 
30         balanceOf[msg.sender] = totalSupply;   
31          //  把token 全部给合约的Creator
32 
33         name = tokenName;
34         symbol = tokenSymbol;
35     }
36 
37     // token的发送函数
38     function _transfer(address _from, address _to, uint _value) internal {
39         require(_to != 0x0);    // 不是零地址
40         require(balanceOf[_from] >= _value);        // 有足够的余额来发送
41         require(balanceOf[_to] + _value > balanceOf[_to]);  // 不能发送负数的值
42 
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];  // 校验避免过程出错, 总量不变对吧
44         balanceOf[_from] -= _value; //发钱 
45         balanceOf[_to] += _value;
46         emit Transfer(_from, _to, _value);   // 这里触发了转账的事件 , 见上event
47         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // 判断总额是否一致, 避免过程出错
48     }
49 
50     function transfer(address _to, uint256 _value) public {
51         _transfer(msg.sender, _to, _value); 
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         require(_value <= allowance[_from][msg.sender]);     // 地址对应的合约地址(也就是token余额)
56         allowance[_from][msg.sender] -= _value;
57         _transfer(_from, _to, _value);
58         return true;
59     }
60 
61 
62     function approve(address _spender, uint256 _value) public
63         returns (bool success) {
64         emit Approval(msg.sender, _spender, _value);
65         allowance[msg.sender][_spender] = _value;   // 可花费总量
66         return true;
67     }
68 
69 
70     function increaseApproval (address _spender, uint _value)public 
71         returns (bool success) {
72         require(allowance[msg.sender][_spender] + _value >=allowance[msg.sender][_spender]);
73         allowance[msg.sender][_spender] += _value;
74         emit Approval(msg.sender, _spender,allowance[msg.sender][_spender]);
75         return true;
76     }
77     function decreaseApproval (address _spender, uint _value)public 
78         returns (bool success) {
79         if (_value > allowance[msg.sender][_spender]) {
80             allowance[msg.sender][_spender] = 0;
81         } else {
82             allowance[msg.sender][_spender] -= _value;
83         }
84         emit Approval(msg.sender, _spender,allowance[msg.sender][_spender]);
85         return true;
86     }
87 
88 
89     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
90         tokenRecipient spender = tokenRecipient(_spender);
91         if (approve(_spender, _value)) {
92             spender.receiveApproval(msg.sender, _value, this, _extraData);
93             return true;
94         }
95     }
96     // 用于把创建者的 token 烧掉
97     function burn(uint256 _value) public returns (bool success) {
98         require(balanceOf[msg.sender] >= _value);   // 必须要有这么多
99         balanceOf[msg.sender] -= _value;
100         totalSupply -= _value;
101         emit Burn(msg.sender, _value);
102         return true;
103     }
104     // 这个是用户销毁token.....
105     function burnFrom(address _from, uint256 _value) public returns (bool success) {
106         require(balanceOf[_from] >= _value);        // 一样要有这么多
107         require(_value <= allowance[_from][msg.sender]);    // 
108         balanceOf[_from] -= _value;
109         allowance[_from][msg.sender] -= _value;
110         totalSupply -= _value;
111         emit Burn(_from, _value);
112         return true;
113     }
114 }