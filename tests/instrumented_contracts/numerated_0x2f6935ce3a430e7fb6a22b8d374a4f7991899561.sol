1 pragma solidity ^ 0.4.25;
2 contract owned {
3     address public owner;
4     constructor() public{
5     owner = msg.sender;
6     }
7     /* modifier是修改标志 */
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     /* 修改管理员账户， onlyOwner代表只能是用户管理员来修改 */
14     function transferOwnership(address newOwner) onlyOwner public {
15         owner = newOwner;
16     }   
17 }
18 
19 contract BTCC is owned{
20     // 代币（token）的公共变量
21     string public name;             //代币名字
22     string public symbol;           //代币符号
23     uint8 public decimals = 18;     //代币小数点位数， 18是默认， 尽量不要更改
24 
25     uint256 public totalSupply;     //代币总量
26     uint256 public sellPrice = 1 ether;
27     uint256 public buyPrice = 1 ether;
28 
29     /* 冻结账户 */
30     mapping (address => bool) public frozenAccount;
31     // 记录各个账户的代币数目
32     mapping (address => uint256) public balanceOf;
33 
34     // A账户存在B账户资金
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     // 转账通知事件
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // 销毁金额通知事件
41     event Burn(address indexed from, uint256 value);
42     /* This generates a public event on the blockchain that will notify clients */
43     event FrozenFunds(address target, bool frozen);
44     /* 构造函数 */
45     constructor() public {
46         totalSupply = 1000000000 ether;  // 根据decimals计算代币的数量
47         balanceOf[msg.sender] = totalSupply;                    // 给生成者所有的代币数量
48         name = 'BTCC';                                       // 设置代币的名字
49         symbol = 'btcc';                                   // 设置代币的符号
50         emit Transfer(this, msg.sender, totalSupply);
51     }
52 
53     /* 私有的交易函数 */
54     function _transfer(address _from, address _to, uint _value) internal {
55         // 防止转移到0x0， 用burn代替这个功能
56         require(_to != 0x0);
57         require(!frozenAccount[_from]);                     // Check if sender is frozen
58         require(!frozenAccount[_to]);                       // Check if recipient is frozen
59         // 检测发送者是否有足够的资金
60         require(balanceOf[_from] >= _value);
61         // 检查是否溢出（数据类型的溢出）
62         require(balanceOf[_to] + _value > balanceOf[_to]);
63         // 将此保存为将来的断言， 函数最后会有一个检验
64         uint previousBalances = balanceOf[_from] + balanceOf[_to];
65         // 减少发送者资产
66         balanceOf[_from] -= _value;
67         // 增加接收者的资产
68         balanceOf[_to] += _value;
69         emit Transfer(_from, _to, _value);
70         // 断言检测， 不应该为错
71         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
72     }
73 
74     /* 传递tokens */
75     function transfer(address _to, uint256 _value) public {
76         _transfer(msg.sender, _to, _value);
77     }
78 
79     /* 从其他账户转移资产 */
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81         require(!frozenAccount[_from]);                     // Check if sender is frozen
82         require(!frozenAccount[_to]);                       // Check if recipient is frozen
83         require(_value <= allowance[_from][msg.sender]);     // Check allowance
84         allowance[_from][msg.sender] -= _value;
85         _transfer(_from, _to, _value);
86         return true;
87     }
88 
89     /*  授权第三方从发送者账户转移代币，然后通过transferFrom()函数来执行第三方的转移操作 */
90     function approve(address _spender, uint256 _value) public
91         returns (bool success) {
92         allowance[msg.sender][_spender] = _value;
93         return true;
94     }
95 
96     /**
97     * 销毁代币
98     */
99     function burn(uint256 _value) public returns (bool success) {
100         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
101         balanceOf[msg.sender] -= _value;            // Subtract from the sender
102         totalSupply -= _value;                      // Updates totalSupply
103         emit Burn(msg.sender, _value);
104         return true;
105     }
106 
107     /**
108     * 从其他账户销毁代币
109     */
110     function burnFrom(address _from, uint256 _value) public returns (bool success) {
111         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
112         require(_value <= allowance[_from][msg.sender]);    // Check allowance
113         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
114         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
115         totalSupply -= _value;                              // Update totalSupply
116         emit Burn(_from, _value);
117         return true;
118     }
119     // 冻结 or 解冻账户
120     function freezeAccount(address target, bool freeze) onlyOwner public {
121         frozenAccount[target] = freeze;
122         emit FrozenFunds(target, freeze);
123     }
124 
125     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
126         sellPrice = newSellPrice;
127         buyPrice = newBuyPrice;
128     }
129 
130     /// @notice Buy tokens from contract by sending ether
131     function buy() payable public {
132         uint amount = msg.value / buyPrice;               // calculates the amount
133         require(totalSupply >= amount);
134         totalSupply -= amount;
135         _transfer(this, msg.sender, amount);              // makes the transfers
136     }
137 
138     function sell(uint256 amount) public {
139         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
140         _transfer(msg.sender, this, amount);              // makes the transfers
141         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
142     }
143     // 向指定账户增发资金
144     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
145         require(totalSupply >= mintedAmount);
146         balanceOf[target] += mintedAmount;
147         totalSupply -= mintedAmount;
148         emit Transfer(this, target, mintedAmount);
149     }
150 }