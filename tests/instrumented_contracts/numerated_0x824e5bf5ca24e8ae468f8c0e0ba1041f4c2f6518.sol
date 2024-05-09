1 pragma solidity ^0.4.8;
2 
3   // ----------------------------------------------------------------------------------------------
4   // Sample Erc20 supply token contract
5   // Contract name:Erc20SupplyToken
6   // Create params:uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol
7   //          e.g.:100000000,"My company's Token",8,"TOK"
8   // ----------------------------------------------------------------------------------------------
9 
10    // ERC Token Standard #20 Interface
11   // https://github.com/ethereum/EIPs/issues/20
12   contract ERC20Interface {
13       // 获取总的支持量
14       function totalSupply() constant returns (uint256 totalSupply);
15 
16       // 获取其他地址的余额
17       function balanceOf(address _owner) constant returns (uint256 balance);
18 
19       // 向其他地址发送token
20       function transfer(address _to, uint256 _value) returns (bool success);
21 
22       // 从一个地址想另一个地址发送余额
23       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
24 
25       //允许_spender从你的账户转出_value的余额，调用多次会覆盖可用量。某些DEX功能需要此功能
26       function approve(address _spender, uint256 _value) returns (bool success);
27 
28       // 返回_spender仍然允许从_owner退出的余额数量
29       function allowance(address _owner, address _spender) constant returns (uint256 remaining);
30 
31       // token转移完成后出发
32       event Transfer(address indexed _from, address indexed _to, uint256 _value);
33 
34       // approve(address _spender, uint256 _value)调用后触发
35       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36   }
37 
38    //继承接口后的实例
39    contract Erc20SupplyToken is ERC20Interface {
40       string public symbol; //单位
41       string public name; //名称
42       uint8 public decimals; //小数点后的位数
43       uint256 public _totalSupply; //发行总量
44       string public constant version = '1.0';    //版本
45 
46       // 智能合约的所有者
47       address public owner;
48 
49       // 每个账户的余额
50       mapping(address => uint256) balances;
51 
52       // 帐户的所有者批准将金额转入另一个帐户。从上面的说明我们可以得知allowed[被转移的账户][转移钱的账户]
53       mapping(address => mapping (address => uint256)) allowed;
54 
55       // 只能通过智能合约的所有者才能调用的方法
56       modifier onlyOwner() {
57           if (msg.sender != owner) {
58               throw;
59           }
60           _;
61       }
62 
63       // 构造函数,发行一个币create时传入参数为:100000000,"My company's Token",8,"NOTRMB"
64       function Erc20SupplyToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
65           owner 						= msg.sender;
66           balances[owner] 	= _initialAmount;
67           
68           _totalSupply 			= _initialAmount;         // 设置初始总量
69           name 							= _tokenName;             // token名称
70           decimals 					= _decimalUnits;          // 小数位数
71           symbol 						= _tokenSymbol;           // token简称          
72 
73       }
74 
75       function totalSupply() constant returns (uint256 totalSupply) {
76           totalSupply = _totalSupply;
77       }
78 
79       // 特定账户的余额
80       function balanceOf(address _owner) constant returns (uint256 balance) {
81           return balances[_owner];
82       }
83 
84       // 转移余额到其他账户
85       function transfer(address _to, uint256 _amount) returns (bool success) {
86           if (balances[msg.sender] >= _amount 
87               && _amount > 0
88               && balances[_to] + _amount > balances[_to]) {
89               balances[msg.sender] -= _amount;
90               balances[_to] += _amount;
91               Transfer(msg.sender, _to, _amount);
92               return true;
93           } else {
94               return false;
95           }
96       }
97 
98       //从一个账户转移到另一个账户，前提是需要有允许转移的余额
99       function transferFrom(
100           address _from,
101           address _to,
102           uint256 _amount
103       ) returns (bool success) {
104           if (balances[_from] >= _amount
105               && allowed[_from][msg.sender] >= _amount
106               && _amount > 0
107               && balances[_to] + _amount > balances[_to]) {
108               balances[_from] -= _amount;
109               allowed[_from][msg.sender] -= _amount;
110               balances[_to] += _amount;
111               Transfer(_from, _to, _amount);
112               return true;
113           } else {
114               return false;
115           }
116       }
117 
118       //允许账户从当前用户转移余额到那个账户，多次调用会覆盖
119       function approve(address _spender, uint256 _amount) returns (bool success) {
120           allowed[msg.sender][_spender] = _amount;
121           Approval(msg.sender, _spender, _amount);
122           return true;
123       }
124 
125       //返回被允许转移的余额数量
126       function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127           return allowed[_owner][_spender];
128       }
129   }