1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
5 }
6 contract AssToken{
7     //公共变量
8     string public name;//代币名称
9     string public symbol;//代币符号
10     uint8 public decimals = 18;//小数点位数
11     uint256 public totalSupply;  //代币发行总量
12 
13     //创建一个包含所有余额的数组
14     mapping (address => uint256) public balanceOf;  //保存所有账户的代币余额的数组
15     mapping (address => mapping (address => uint256)) public allowance;   //嵌套的数组来保存授权账户、被授权账户和授权额度
16 
17     //在区块链上生成一个公共事件，该事件将通知客户端
18     event Transfer(address indexed from, address indexed to, uint256 value);    //每次转账成功后都必须触发该事件
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);   //将在区块链上生成一个公共事件，每次进行授权，都必须触发该事件。参数为：授权人、被授权人和授权额度
20     event Burn(address indexed from, uint256 value);    //关于上涨的客户通知
21     /**
22      * 构造函数初始化契约，
23      * 将初始供应令牌提供给契约的创建者
24     */
25     constructor(
26         uint256 initialSupply,//发行总量
27         string memory tokenName,//代币名称
28         string memory tokenSymbol//代币符号
29     ) public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  // 用十进制数字更新总供应量
31         balanceOf[msg.sender] = totalSupply;                // 给创建者所有初始令牌
32         name = tokenName;                                   // 代币名称
33         symbol = tokenSymbol;                               // 代币符号
34     }
35     /**
36      * 内部转账，只能按本合同调用
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39         // 防止传输到无效地址。改用burn（）
40         require(_to != address(0x0));
41         // 检查账号余额是否大于转账金额
42         require(balanceOf[_from] >= _value);
43         // 检查转账金额是否正常
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45         // 保存余额状态
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         // Subtract from the sender
48         balanceOf[_from] -= _value;
49         // Add the same to the recipient
50         balanceOf[_to] += _value;
51         emit Transfer(_from, _to, _value);
52         // Asserts are used to use static analysis to find bugs in your code. They should never fail
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55     /**
56      * 转账操作，将指定数量的代币从总账户发送到另一个账户
57      *
58      * Send `_value` tokens to `_to` from your account
59      *
60      * @param _to The address of the recipient
61      * @param _value the amount to send
62      */
63     function transfer(address _to, uint256 _value) public returns (bool success) {
64         _transfer(msg.sender, _to, _value);
65         return true;
66     }
67     /**
68      * 转账操作，用户转给用户
69      *
70      * Send `_value` tokens to `_to` on behalf of `_from`
71      *
72      * @param _from The address of the sender
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_value <= allowance[_from][msg.sender]);     // 检查转账金额不能小于手续费
78         allowance[_from][msg.sender] -= _value; //先扣除转账方的手续费
79         _transfer(_from, _to, _value);
80         return true;
81     }
82     /**
83      * 给转账用户设置手续费
84      *
85      * Allows `_spender` to spend no more than `_value` tokens on your behalf
86      *
87      * @param _spender The address authorized to spend
88      * @param _value the max amount they can spend
89      */
90     function approve(address _spender, uint256 _value) public
91         returns (bool success) {
92         allowance[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value);
94         return true;
95     }
96     /**
97      * 获取到账户地址和 手续费的通知
98      *
99      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
100      *
101      * @param _spender The address authorized to spend
102      * @param _value the max amount they can spend
103      * @param _extraData some extra information to send to the approved contract
104      */
105     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
106         public
107         returns (bool success) {
108         tokenRecipient spender = tokenRecipient(_spender);
109         if (approve(_spender, _value)) {
110             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
111             return true;
112         }
113     }
114     /**
115      * 减少代币总余额
116      *
117      * Remove `_value` tokens from the system irreversibly
118      *
119      * @param _value the amount of money to burn
120      */
121     function burn(uint256 _value) public returns (bool success) {
122         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
123         balanceOf[msg.sender] -= _value;            // Subtract from the sender
124         totalSupply -= _value;                      // Updates totalSupply
125         emit Burn(msg.sender, _value);
126         return true;
127     }
128     /**
129      * 减少用户余额
130      *
131      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
132      *
133      * @param _from the address of the sender
134      * @param _value the amount of money to burn
135      */
136     function burnFrom(address _from, uint256 _value) public returns (bool success) {
137         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
138         require(_value <= allowance[_from][msg.sender]);    // Check allowance
139         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
140         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
141         totalSupply -= _value;                              // Update totalSupply
142         emit Burn(_from, _value);
143         return true;
144     }
145     //查询指定账户地址的代币余额
146     function balanceTo(address _owner) public view returns (uint256 balance){
147         return balanceOf[_owner];
148     }
149      //查询指定账户的手续费
150     function allowed(address _owner,address _spender) public view returns (uint256 remaining){
151         return allowance[_owner][_spender];
152     }
153 }