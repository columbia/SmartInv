1 pragma solidity ^0.4.25;
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
24       // 事件，用来通知客户端代币有增发
25     event AddSupply(address indexed from, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     // 这里是构造函数, 实例创建时候执行
29     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  // 总发行量
31 
32         balanceOf[msg.sender] = totalSupply;    // 全部token给合约的Creator
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
43         require(balanceOf[_to] + _value > balanceOf[_to]);  //  不能发送负数的值
44 
45         uint previousBalances = balanceOf[_from] + balanceOf[_to];  // 校验避免过程出错, 总量不变
46         balanceOf[_from] -= _value; 
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
57         require(_value <= allowance[_from][msg.sender]);     // 地址对应的合约地址
58         allowance[_from][msg.sender] -= _value;
59         _transfer(_from, _to, _value);
60         return true;
61     }
62 
63     function approve(address _spender, uint256 _value) public
64         returns (bool success) {
65         emit Approval(msg.sender, _spender, _value);
66         allowance[msg.sender][_spender] = _value;   // 可花费总量
67         return true;
68     }
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
98         require(balanceOf[msg.sender] >= _value);   // 必须要有这么多余额
99         balanceOf[msg.sender] -= _value;
100         totalSupply -= _value;
101         emit Burn(msg.sender, _value);
102         return true;
103     }
104     // 用户销毁token
105     function burnFrom(address _from, uint256 _value) public returns (bool success) {
106         require(balanceOf[_from] >= _value);        // 
107         require(_value <= allowance[_from][msg.sender]);    //
108         balanceOf[_from] -= _value;
109         allowance[_from][msg.sender] -= _value;
110         totalSupply -= _value;
111         emit Burn(_from, _value);
112         return true;
113     }
114 
115      // 增发gas
116     function addSupply(uint256 _value) public returns (bool success) {
117         require(balanceOf[msg.sender]+_value>balanceOf[msg.sender]); 
118         require(totalSupply+_value>totalSupply);        // 
119         require(owner == msg.sender);
120         balanceOf[msg.sender] += _value;
121         totalSupply += _value;
122         emit AddSupply(msg.sender, _value);
123         return true;
124     }
125 }