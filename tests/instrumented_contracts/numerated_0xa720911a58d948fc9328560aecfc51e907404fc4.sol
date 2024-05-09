1 pragma solidity ^ 0.4.21;
2 
3 contract SafeMath {
4     uint256 constant public MAX_UINT256 =
5         0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
6 
7     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
8         if (x > MAX_UINT256 - y) revert();
9         return x + y;
10     }
11 
12     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
13         if (x < y) revert();
14         return x - y;
15     }
16 
17     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
18         if (y == 0) return 0;
19         if (x > MAX_UINT256 / y) revert();
20         return x * y;
21     }
22 }
23 contract Token{
24     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
25     uint256 public totalSupply;
26 
27     /// 获取账户_owner拥有token的数量 
28     function balanceOf(address _owner) public constant returns (uint256 balance);
29 
30     //从消息发送者账户中往_to账户转数量为_value的token
31     function transfer(address _to, uint256 _value) public returns(bool success);
32 
33     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
34     function transferFrom(address _from, address _to, uint256 _value) public returns
35         (bool success);
36 
37     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
38     function approve(address _spender, uint256 _value) public returns(bool success);
39 
40     //获取账户_spender可以从账户_owner中转出token的数量
41     function allowance(address _owner, address _spender) public constant returns 
42         (uint256 remaining);
43 
44     //发生转账时必须要触发的事件 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46 
47     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
48     event Approval(address indexed _owner, address indexed _spender, uint256 
49     _value);
50 }
51 
52 contract StandardToken is Token, SafeMath {
53     function transfer(address _to, uint256 _value) public returns(bool success) {
54         //默认totalSupply 不会超过最大值 (2^256 - 1).
55         require(balances[msg.sender] >= _value);
56         balances[msg.sender] = safeSub(balances[msg.sender], _value);//从消息发送者账户中减去token数量_value
57         balances[_to] = safeAdd(balances[_to], _value);//往接收账户增加token数量_value
58         emit Transfer(msg.sender, _to, _value);//触发转币交易事件
59         return true;
60     }
61 
62 
63     function transferFrom(address _from, address _to, uint256 _value) public returns
64         (bool success) {
65        
66         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
67         balances[_to] = safeAdd(balances[_to], _value);//接收账户增加token数量_value
68         balances[_from] = safeSub(balances[_from], _value); //支出账户_from减去token数量_value
69         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);//消息发送者可以从账户_from中转出的数量减少_value
70         emit Transfer(_from, _to, _value);//触发转币交易事件
71         return true;
72     }
73     function balanceOf(address _owner) public constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77 
78     function approve(address _spender, uint256 _value) public returns(bool success)
79     {
80         allowed[msg.sender][_spender] = _value;
81         emit Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85 
86     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
87         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
88     }
89     mapping(address => uint256) balances;
90     mapping(address => mapping(address => uint256)) allowed;
91 }
92 
93 contract ZeroHooStandardToken is StandardToken { 
94 
95     /* Public variables of the token */
96     string public name;                   //名称
97     uint8 public decimals;               //最多的小数位数
98     string public symbol;               //token简称:FAC
99     string public version = 'zero 1.0.0';    //版本
100 
101     function ZeroHooStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
102         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
103         totalSupply = _initialAmount;         // 设置初始总量
104         name = _tokenName;                   // token名称
105         decimals = _decimalUnits;           // 小数位数
106         symbol = _tokenSymbol;             // token简称
107     }
108 
109     /* Approves and then calls the receiving contract */
110 
111     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool success) {
112         allowed[msg.sender][_spender] = _value;
113         emit Approval(msg.sender, _spender, _value);
114         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
115         return true;
116     }
117 
118 }