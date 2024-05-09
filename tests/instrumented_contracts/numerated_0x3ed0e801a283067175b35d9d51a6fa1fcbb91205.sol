1 pragma solidity ^0.5.1;
2 
3 
4   contract ERC20 {
5       // 获取总的支持量
6       function totalSupply() public view returns (uint256 total);
7 
8       // 获取其他地址的余额
9       function balanceOf(address _owner) public view returns (uint256 balance);
10 
11       // 向其他地址发送token
12       function transfer(address _to, uint256 _value) public returns (bool success);
13 
14       // 从一个地址想另一个地址发送余额
15       function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
16 
17       //允许_spender从你的账户转出_value的余额，调用多次会覆盖可用量。某些DEX功能需要此功能
18       function approve(address _spender, uint256 _value) public returns (bool success);
19 
20       // 返回_spender仍然允许从_owner退出的余额数量
21       function allowance(address _owner, address _spender) public view returns (uint256 remaining);
22 
23       // token转移完成后出发
24       event Transfer(address indexed _from, address indexed _to, uint256 _value);
25 
26       // approve(address _spender, uint256 _value)调用后触发
27       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28   }
29 
30    //继承接口后的实例
31    contract Token is ERC20 {
32       string public constant symbol = "ETS"; //单位
33       string public constant name = "Ethereum small"; //名称
34       uint8 public constant decimals = 8; //小数点后的位数
35       uint256 _totalSupply = 98660000e8; //发行总量
36 
37       // 智能合约的所有者
38       address public owner;
39 
40       // 每个账户的余额
41       mapping(address => uint256) balances;
42 
43       // 帐户的所有者批准将金额转入另一个帐户。从上面的说明我们可以得知allowed[被转移的账户][转移钱的账户]
44       mapping(address => mapping (address => uint256)) allowed;
45 
46       // 构造函数
47       constructor() public {
48           owner = msg.sender;
49           balances[owner] = _totalSupply;
50       }
51 
52       function totalSupply() public view returns (uint256 total) {
53           total = _totalSupply;
54       }
55 
56       // 特定账户的余额
57       function balanceOf(address _owner) public view returns (uint256 balance) {
58           return balances[_owner];
59       }
60 
61       // 转移余额到其他账户
62       function transfer(address _to, uint256 _amount) public returns (bool success) {
63           if (balances[msg.sender] >= _amount 
64               && _amount > 0
65               && balances[_to] + _amount > balances[_to]) {
66               balances[msg.sender] -= _amount;
67               balances[_to] += _amount;
68               emit Transfer(msg.sender, _to, _amount);
69               return true;
70           } else {
71               return false;
72           }
73       }
74 
75       //从一个账户转移到另一个账户，前提是需要有允许转移的余额
76       function transferFrom( address _from, address _to, uint256 _amount ) public returns (bool success) {
77           if (balances[_from] >= _amount 
78               && allowed[_from][msg.sender] >= _amount
79               && _amount > 0
80               && balances[_to] + _amount > balances[_to]) {
81               balances[_from] -= _amount;
82               allowed[_from][msg.sender] -= _amount;
83               balances[_to] += _amount;
84               emit Transfer(_from, _to, _amount);
85               return true;
86           } else {
87               return false;
88           }
89       }
90 
91       //允许账户从当前用户转移余额到那个账户，多次调用会覆盖
92       function approve(address _spender, uint256 _amount) public returns (bool success) {
93           allowed[msg.sender][_spender] = _amount;
94           emit Approval(msg.sender, _spender, _amount);
95           return true;
96       }
97 
98       //返回被允许转移的余额数量
99       function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
100           return allowed[_owner][_spender];
101       }
102   }