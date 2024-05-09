1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract WEIPAY {
6     /* 公共变量 */
7     string public name;
8     string public symbol;
9     uint8 public decimals = 4;
10     uint256 public totalSupply;
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Burn(address indexed from, uint256 value);
15 
16     /* 初始化合约，并且把初始的所有代币都给这合约的创建者
17      * @param initialSupply 代币的总数
18      * @param tokenName 代币名称
19      * @param tokenSymbol 代币符号
20      */
21     constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
22         totalSupply = initialSupply * 10 ** uint256(decimals);
23         balanceOf[msg.sender] = totalSupply;
24         name = tokenName;
25         symbol = tokenSymbol;
26     }
27 
28 
29     /**
30      * 私有方法从一个帐户发送给另一个帐户代币
31      * @param  _from address 发送代币的地址
32      * @param  _to address 接受代币的地址
33      * @param  _value uint256 接受代币的数量
34      */
35     function _transfer(address _from, address _to, uint256 _value) internal {
36       require(_to != 0x0);
37       require(balanceOf[_from] >= _value);
38       require(balanceOf[_to] + _value > balanceOf[_to]);
39       uint previousBalances = balanceOf[_from] + balanceOf[_to];
40       balanceOf[_from] -= _value;
41       balanceOf[_to] += _value;
42       emit Transfer(_from, _to, _value);
43       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
44     }
45 
46     /**
47      * 从主帐户合约调用者发送给别人代币
48      * @param  _to address 接受代币的地址
49      * @param  _value uint256 接受代币的数量
50      */
51     function transfer(address _to, uint256 _value) public {
52         _transfer(msg.sender, _to, _value);
53     }
54 
55     /**
56      * 从某个指定的帐户中，向另一个帐户发送代币
57      *
58      * 调用过程，会检查设置的允许最大交易额
59      *
60      * @param  _from address 发送者地址
61      * @param  _to address 接受者地址
62      * @param  _value uint256 要转移的代币数量
63      * @return success        是否交易成功
64      */
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         require(_value <= allowance[_from][msg.sender]);
67         allowance[_from][msg.sender] -= _value;
68         _transfer(_from, _to, _value);
69         return true;
70     }
71 
72     /**
73      * 设置帐户允许支付的最大金额
74      *
75      * 一般在智能合约的时候，避免支付过多，造成风险
76      *
77      * @param _spender 帐户地址
78      * @param _value 金额
79      */
80     function approve(address _spender, uint256 _value) public returns (bool success) {
81         allowance[msg.sender][_spender] = _value;
82         return true;
83     }
84 
85     /**
86      * 设置帐户允许支付的最大金额
87      *
88      * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
89      *
90      * @param _spender 帐户地址
91      * @param _value 金额
92      * @param _extraData 操作的时间
93      */
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
95         tokenRecipient spender = tokenRecipient(_spender);
96         if (approve(_spender, _value)) {
97             spender.receiveApproval(msg.sender, _value, this, _extraData);
98             return true;
99         }
100     }
101 
102     /**
103      * 减少代币调用者的余额
104      *
105      * 操作以后是不可逆的
106      *
107      * @param _value 要删除的数量
108      */
109     function burn(uint256 _value) public returns (bool success) {
110         require(balanceOf[msg.sender] >= _value);
111         balanceOf[msg.sender] -= _value;
112         totalSupply -= _value;
113         emit Burn(msg.sender, _value);
114         return true;
115     }
116     /**
117      * 删除帐户的余额（含其他帐户）
118      *
119      * 删除以后是不可逆的
120      *
121      * @param _from 要操作的帐户地址
122      * @param _value 要减去的数量
123      */
124     function burnFrom(address _from, uint256 _value) public returns (bool success) {
125         require(balanceOf[_from] >= _value);
126         require(_value <= allowance[_from][msg.sender]);
127         balanceOf[_from] -= _value;
128         allowance[_from][msg.sender] -= _value;
129         totalSupply -= _value;
130         emit Burn(_from, _value);
131         return true;
132     }
133 
134 }