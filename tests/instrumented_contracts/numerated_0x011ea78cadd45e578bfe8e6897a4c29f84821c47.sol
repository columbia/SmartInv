1 pragma solidity ^0.4.8;
2 
3   // ----------------------------------------------------------------------------------------------
4   // Sample fixed supply token contract
5   // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6   // ----------------------------------------------------------------------------------------------
7 
8    // ERC Token Standard #20 Interface
9   // https://github.com/ethereum/EIPs/issues/20
10 contract ERC20Interface {
11   // 获取总的支持量
12   function totalSupply() constant returns (uint256 totalSupply);
13 
14   // 获取其他地址的余额
15   function balanceOf(address _owner) constant returns (uint256 balance);
16 
17   // 向其他地址发送token
18   function transfer(address _to, uint256 _value) returns (bool success);
19 
20   // 从一个地址想另一个地址发送余额
21   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
22 
23   //允许_spender从你的账户转出_value的余额，调用多次会覆盖可用量。某些DEX功能需要此功能
24   function approve(address _spender, uint256 _value) returns (bool success);
25 
26   // 返回_spender仍然允许从_owner退出的余额数量
27   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
28 
29   // token转移完成后出发
30   event Transfer(address indexed _from, address indexed _to, uint256 _value);
31 
32   // approve(address _spender, uint256 _value)调用后触发
33   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 //继承接口后的实例
37 contract mkethToken is ERC20Interface {
38   string public constant symbol = "Wan Ke Bi"; //单位
39   string public constant name = "WKC"; //名称
40   uint8 public constant decimals = 18; //小数点后的位数
41   uint256 _totalSupply = 1500000000 * 10 ** uint256(decimals); //发行总量
42 
43   // 智能合约的所有者
44   address public owner;
45 
46   // 每个账户的余额
47   mapping(address => uint256) balances;
48 
49   // 帐户的所有者批准将金额转入另一个帐户。从上面的说明我们可以得知allowed[被转移的账户][转移钱的账户]
50   mapping(address => mapping (address => uint256)) allowed;
51 
52   // 只能通过智能合约的所有者才能调用的方法
53   modifier onlyOwner() {
54       if (msg.sender != owner) {
55           throw;
56       }
57       _;
58   }
59 
60   // 构造函数
61   function mkethToken() {
62       owner = msg.sender;
63       balances[owner] = _totalSupply;
64   }
65 
66   function totalSupply() constant returns (uint256 totalSupply) {
67       totalSupply = _totalSupply;
68   }
69 
70   // 特定账户的余额
71   function balanceOf(address _owner) constant returns (uint256 balance) {
72       return balances[_owner];
73   }
74 
75   // 转移余额到其他账户
76   function transfer(address _to, uint256 _amount) returns (bool success) {
77       if (balances[msg.sender] >= _amount 
78           && _amount > 0
79           && balances[_to] + _amount > balances[_to]) {
80           balances[msg.sender] -= _amount;
81           balances[_to] += _amount;
82           Transfer(msg.sender, _to, _amount);
83           return true;
84       } else {
85           return false;
86       }
87   }
88 
89   //从一个账户转移到另一个账户，前提是需要有允许转移的余额
90   function transferFrom(
91       address _from,
92       address _to,
93       uint256 _amount
94   ) returns (bool success) {
95       if (balances[_from] >= _amount
96           && allowed[_from][msg.sender] >= _amount
97           && _amount > 0
98           && balances[_to] + _amount > balances[_to]) {
99           balances[_from] -= _amount;
100           allowed[_from][msg.sender] -= _amount;
101           balances[_to] += _amount;
102           Transfer(_from, _to, _amount);
103           return true;
104       } else {
105           return false;
106       }
107   }
108 
109   //允许账户从当前用户转移余额到那个账户，多次调用会覆盖
110   function approve(address _spender, uint256 _amount) returns (bool success) {
111       allowed[msg.sender][_spender] = _amount;
112       Approval(msg.sender, _spender, _amount);
113       return true;
114   }
115 
116   //返回被允许转移的余额数量
117   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
118       return allowed[_owner][_spender];
119   }
120 }