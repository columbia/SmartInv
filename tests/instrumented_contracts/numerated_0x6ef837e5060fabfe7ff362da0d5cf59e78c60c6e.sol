1 pragma solidity ^0.4.16;
2 
3 contract TokenERC20 {
4     string public name; // ERC20标准
5     string public symbol; // ERC20标准
6     uint8 public decimals = 18;  // ERC20标准，decimals 可以有的小数点个数，最小的代币单位。18 是建议的默认值
7     uint256 public totalSupply; // ERC20标准 总供应量
8 
9     // 用mapping保存每个地址对应的余额 ERC20标准
10     mapping (address => uint256) public balanceOf;
11     // 存储对账号的控制 ERC20标准
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     // 事件，用来通知客户端交易发生 ERC20标准
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     // 事件，用来通知客户端代币被授权消费 ERC20标准
18     event Approval(address indexed spender, uint256 value);
19 
20     /**
21      * 初始化构造
22      */
23     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
24         totalSupply = initialSupply * 10 ** uint256(decimals);  // 供应的份额，份额跟最小的代币单位有关，份额 = 币数 * 10 ** decimals。
25         balanceOf[msg.sender] = totalSupply;                // 创建者拥有所有的代币
26         name = tokenName;                                   // 代币名称
27         symbol = tokenSymbol;                               // 代币符号
28     }
29 
30     /**
31      * 代币交易转移的内部实现
32      */
33     function _transfer(address _from, address _to, uint _value) internal {
34         // 确保目标地址不为0x0，因为0x0地址代表销毁
35         require(_to != 0x0);
36         // 检查发送者余额
37         require(balanceOf[_from] >= _value);
38         // 确保转移为正数个
39         require(balanceOf[_to] + _value > balanceOf[_to]);
40 
41         // 以下用来检查交易，
42         uint previousBalances = balanceOf[_from] + balanceOf[_to];
43         // Subtract from the sender
44         balanceOf[_from] -= _value;
45         // Add the same to the recipient
46         balanceOf[_to] += _value;
47         Transfer(_from, _to, _value);
48 
49         // 用assert来检查代码逻辑。
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     /**
54      *  代币交易转移
55      *  从自己（创建交易者）账号发送`_value`个代币到 `_to`账号
56      * ERC20标准
57      * @param _to 接收者地址
58      * @param _value 转移数额
59      */
60     function transfer(address _to, uint256 _value) public returns (bool success) {
61         _transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     /**
66      * 账号之间代币交易转移
67      * ERC20标准
68      * @param _from 发送者地址
69      * @param _to 接收者地址
70      * @param _value 转移数额
71      */
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_value <= allowance[_from][msg.sender]);     // Check allowance
74         allowance[_from][msg.sender] -= _value;
75         _transfer(_from, _to, _value);
76         return true;
77     }
78 
79     /**
80      * 设置某个地址（合约）可以创建交易者名义花费的代币数。
81      *
82      * 允许发送者`_spender` 花费不多于 `_value` 个代币
83      * ERC20标准
84      * @param _spender The address authorized to spend
85      * @param _value the max amount they can spend
86      */
87     function approve(address _spender, uint256 _value) public
88         returns (bool success) {
89             allowance[msg.sender][_spender] = _value;
90             Approval(_spender,_value);
91             return true;
92         }
93 
94 }