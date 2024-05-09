1 // ----------------------------------------------------------------------------------------------
2   // Sample fixed supply token contract
3   // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
4   // ----------------------------------------------------------------------------------------------
5 
6    // ERC Token Standard #20 Interface
7   // https://github.com/ethereum/EIPs/issues/20
8   pragma solidity ^0.4.11;
9   contract ERC20Interface {
10       // 获取总的支持量
11       function totalSupply() constant returns (uint256 totalSupply);
12 
13       // 获取其他地址的余额
14       function balanceOf(address _owner) constant returns (uint256 balance);
15 
16       // 向其他地址发送token
17       function transfer(address _to, uint256 _value) returns (bool success);
18 
19       // 从一个地址想另一个地址发送余额
20       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
21 
22       //允许_spender从你的账户转出_value的余额，调用多次会覆盖可用量。某些DEX功能需要此功能
23       function approve(address _spender, uint256 _value) returns (bool success);
24 
25       // 返回_spender仍然允许从_owner退出的余额数量
26       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
27 
28       // token转移完成后出发
29       event Transfer(address indexed _from, address indexed _to, uint256 _value);
30 
31       // approve(address _spender, uint256 _value)调用后触发
32       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33   }
34 
35    //继承接口后的实例
36    contract BanliangCoin is ERC20Interface {
37       string public constant symbol = "BLC"; //单位
38       string public constant name = "BanliangCoin Token"; //名称
39       uint8 public constant decimals = 18; //小数点后的位数
40       uint256 _totalSupply = 10000000000 * 10 ** uint256(decimals); //发行总量
41 
42       // 智能合约的所有者
43       address public owner;
44 
45       // 每个账户的余额
46       mapping(address => uint256) balances;
47 
48       // 帐户的所有者批准将金额转入另一个帐户。从上面的说明我们可以得知allowed[被转移的账户][转移钱的账户]
49       mapping(address => mapping (address => uint256)) allowed;
50 
51       // 只能通过智能合约的所有者才能调用的方法
52       modifier onlyOwner() {
53           if (msg.sender != owner) {
54               throw;
55           }
56           _;
57       }
58 
59       // 构造函数
60       function BanliangCoin() {
61           owner = msg.sender;
62           balances[owner] = _totalSupply;
63       }
64 
65       function totalSupply() constant returns (uint256 totalSupply) {
66           totalSupply = _totalSupply;
67       }
68 
69       // 特定账户的余额
70       function balanceOf(address _owner) constant returns (uint256 balance) {
71           return balances[_owner];
72       }
73 
74       // 转移余额到其他账户
75       function transfer(address _to, uint256 _amount) returns (bool success) {
76           if (balances[msg.sender] >= _amount 
77               && _amount > 0
78               && balances[_to] + _amount > balances[_to]) {
79               balances[msg.sender] -= _amount;
80               balances[_to] += _amount;
81               Transfer(msg.sender, _to, _amount);
82               return true;
83           } else {
84               return false;
85           }
86       }
87 
88       //从一个账户转移到另一个账户，前提是需要有允许转移的余额
89       function transferFrom(
90           address _from,
91           address _to,
92           uint256 _amount
93       ) returns (bool success) {
94           if (balances[_from] >= _amount
95               && allowed[_from][msg.sender] >= _amount
96               && _amount > 0
97               && balances[_to] + _amount > balances[_to]) {
98               balances[_from] -= _amount;
99               allowed[_from][msg.sender] -= _amount;
100               balances[_to] += _amount;
101               Transfer(_from, _to, _amount);
102               return true;
103           } else {
104               return false;
105           }
106       }
107 
108       //允许账户从当前用户转移余额到那个账户，多次调用会覆盖
109       function approve(address _spender, uint256 _amount) returns (bool success) {
110           allowed[msg.sender][_spender] = _amount;
111           Approval(msg.sender, _spender, _amount);
112           return true;
113       }
114 
115       //返回被允许转移的余额数量
116       function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
117           return allowed[_owner][_spender];
118       }
119   }