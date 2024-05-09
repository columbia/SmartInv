1 pragma solidity ^0.5.1;
2 
3 contract ERC20Interface {
4     // 代币名称
5     string public name;
6     // 代币符号或者说简写
7     string public symbol;
8     // 代币小数点位数，代币的最小单位
9     uint8 public decimals;
10     // 代币的发行总量
11     uint public totalSupply;
12 
13     // 实现代币交易，用于给某个地址转移代币
14     function transfer(address to, uint tokens) public returns (bool success);
15     // 实现代币用户之间的交易，从一个地址转移代币到另一个地址
16     function transferFrom(address from, address to, uint tokens) public returns (bool success);
17     // 允许spender多次从你的账户取款，并且最多可取tokens个，主要用于某些场景下授权委托其他用户从你的账户上花费代币
18     function approve(address spender, uint tokens) public returns (bool success);
19     // 查询spender允许从tokenOwner上花费的代币数量
20     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
21 
22     // 代币交易时触发的事件，即调用transfer方法时触发
23     event Transfer(address indexed from, address indexed to, uint tokens);
24     // 允许其他用户从你的账户上花费代币时触发的事件，即调用approve方法时触发
25     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
26 }
27 
28 // 实现ERC-20标准接口
29 contract BTB is ERC20Interface {
30     // 存储每个地址的余额（因为是public的所以会自动生成balanceOf方法）
31     mapping (address => uint256) public balanceOf;
32     // 存储每个地址可操作的地址及其可操作的金额
33     mapping (address => mapping (address => uint256)) internal allowed;
34 
35     // 初始化属性
36     constructor() public {
37         name = "Cupidexs Block Target Business";
38         symbol = "BTB";
39         decimals = 8;
40         totalSupply = 2100000000 * 10**uint(decimals);
41         // 初始化该代币的账户会拥有所有的代币
42         balanceOf[msg.sender] = totalSupply;
43     }
44 
45     function transfer(address to, uint tokens) public returns (bool success) {
46         // 检验接收者地址是否合法
47         require(to != address(0));
48         // 检验发送者账户余额是否足够
49         require(balanceOf[msg.sender] >= tokens);
50         // 检验是否会发生溢出
51         require(balanceOf[to] + tokens >= balanceOf[to]);
52 
53         // 扣除发送者账户余额
54         balanceOf[msg.sender] -= tokens;
55         // 增加接收者账户余额
56         balanceOf[to] += tokens;
57 
58         // 触发相应的事件
59         emit Transfer(msg.sender, to, tokens);
60 
61                 success = true;
62     }
63 
64     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
65         // 检验地址是否合法
66         require(to != address(0) && from != address(0));
67         // 检验发送者账户余额是否足够
68         require(balanceOf[from] >= tokens);
69         // 检验操作的金额是否是被允许的
70         require(allowed[from][msg.sender] <= tokens);
71         // 检验是否会发生溢出
72         require(balanceOf[to] + tokens >= balanceOf[to]);
73 
74         // 扣除发送者账户余额
75         balanceOf[from] -= tokens;
76         // 增加接收者账户余额
77         balanceOf[to] += tokens;
78 
79         // 触发相应的事件
80         emit Transfer(from, to, tokens);
81 
82         success = true;
83     }
84 
85     function approve(address spender, uint tokens) public returns (bool success) {
86         allowed[msg.sender][spender] = tokens;
87         // 触发相应的事件
88         emit Approval(msg.sender, spender, tokens);
89 
90         success = true;
91     }
92 
93     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
94         return allowed[tokenOwner][spender];
95     }
96 }