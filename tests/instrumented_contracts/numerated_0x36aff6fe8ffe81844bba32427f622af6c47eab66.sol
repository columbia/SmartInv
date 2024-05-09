1 pragma solidity ^0.4.13;
2 
3 contract SafeMath {
4     //SafeAdd 是安全加法，这是ERC20标准function
5     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6       uint256 z = x + y;
7       assert((z >= x) && (z >= y));
8       return z;
9     }
10 
11     //SafeSubtract 是安全减法，这是ERC20标准function
12     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
13       assert(x >= y);
14       uint256 z = x - y;
15       return z;
16     }
17 
18     //SafeMult 是安全乘法，这是ERC20标准function
19     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
20       uint256 z = x * y;
21       assert((x == 0)||(z/x == y));
22       return z;
23     }
24 
25 }
26 
27 // Token合约，这里定义了合约需要用到的方法
28 contract Token {
29     //totalSupply: 总供应量
30     uint256 public totalSupply;
31     //balanceOf: 获取每个地址的GDC余额
32     function balanceOf(address _owner) constant returns (uint256 balance);
33     //transfer: GDC合约的转账功能
34     function transfer(address _to, uint256 _value) returns (bool success);
35     //transferFrom: 将GDC从一个地址转向另一个地址
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37     //approve: 允许从A地址向B地址转账，需要先approve, 然后才能transferFrom
38     function approve(address _spender, uint256 _value) returns (bool success);
39     //allowance，保留Approve方法的结果
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41     //Transfer事件，在调用转账方法之后，会记录下转账事件
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     //Approval事件，在调用approve方法之后，会记录下Approval事件
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 
48 /*  ERC 20 token */
49 contract StandardToken is Token {
50     //转账功能，实现向某个账户转账的功能
51     function transfer(address _to, uint256 _value) returns (bool success) {
52       if (balances[msg.sender] >= _value && _value > 0) {
53         balances[msg.sender] -= _value;
54         balances[_to] += _value;
55         Transfer(msg.sender, _to, _value);
56         return true;
57       } else {
58         return false;
59       }
60     }
61 
62     // 实现从A账户向B账户转账功能，但必须要A账户先允许向B账户的转账金额才可
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
65         balances[_to] += _value;
66         balances[_from] -= _value;
67         allowed[_from][msg.sender] -= _value;
68         Transfer(_from, _to, _value);
69         return true;
70       } else {
71         return false;
72       }
73     }
74     //获取当前账户的代币数量
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78     //允许向某个账户转账多少金额
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84     // 记录下向某个账户转账的代币数量
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88     // 代币余额表，记录下某个地址有多少代币数量
89     mapping (address => uint256) balances;
90     // 允许转账金额，记录下A地址允许向B地址，转账多少代币
91     mapping (address => mapping (address => uint256)) allowed;
92 }
93 
94 // GDC合约，继承自ERC20的标准合约
95 contract GDC is StandardToken, SafeMath {
96     string public constant name = "GDC"; //合约名字为GDC
97     string public constant symbol = "GDC"; //合约标示为GDC
98     uint256 public constant decimals = 18; //合约小数点后18位
99     string public version = "1.0"; //合约版本 1.0
100 
101     address  public GDCAcc01;  //GDC合约的账号1
102     address  public GDCAcc02;  //GDC合约的账号2
103     address  public GDCAcc03;  //GDC合约的账号3
104     address  public GDCAcc04;  //GDC合约的账号4
105     address  public GDCAcc05;  //GDC合约的账号5
106 
107     uint256 public constant factorial = 6; //用于定义每个账户多少GDC数量所用。
108     uint256 public constant GDCNumber1 = 200 * (10**factorial) * 10**decimals; //GDCAcc1代币数量为200M，即2亿代币
109     uint256 public constant GDCNumber2 = 200 * (10**factorial) * 10**decimals; //GDCAcc2代币数量为200M，即2亿代币
110     uint256 public constant GDCNumber3 = 200 * (10**factorial) * 10**decimals; //GDCAcc3代币数量为200M，即2亿代币
111     uint256 public constant GDCNumber4 = 200 * (10**factorial) * 10**decimals; //GDCAcc4代币数量为200M，即2亿代币
112     uint256 public constant GDCNumber5 = 200 * (10**factorial) * 10**decimals; //GDCAcc5代币数量为200M，即2亿代币
113 
114 
115     // 构造函数，需要输入五个地址，然后分别给五个地址分配2亿GDC代币
116     function GDC(
117       address _GDCAcc01,
118       address _GDCAcc02,
119       address _GDCAcc03,
120       address _GDCAcc04,
121       address _GDCAcc05
122     )
123     {
124       totalSupply = 1000 * (10**factorial) * 10**decimals; // 设置总供应量为10亿
125       GDCAcc01 = _GDCAcc01;
126       GDCAcc02 = _GDCAcc02;
127       GDCAcc03 = _GDCAcc03;
128       GDCAcc04 = _GDCAcc04;
129       GDCAcc05 = _GDCAcc05;
130 
131       balances[GDCAcc01] = GDCNumber1;
132       balances[GDCAcc02] = GDCNumber2;
133       balances[GDCAcc03] = GDCNumber3;
134       balances[GDCAcc04] = GDCNumber4;
135       balances[GDCAcc05] = GDCNumber5;
136 
137     }
138 
139     // transferLock 代表必须要输入的flag为true的时候，转账才可能生效，否则都会失效
140     function transferLock(address _to, uint256 _value, bool flag) returns (bool success) {
141       if (balances[msg.sender] >= _value && _value > 0 && flag) {
142         balances[msg.sender] -= _value;
143         balances[_to] += _value;
144         Transfer(msg.sender, _to, _value);
145         return true;
146       } else {
147         return false;
148       }
149     }
150 }