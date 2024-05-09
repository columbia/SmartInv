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
55         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
56         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
57         require(balances[msg.sender] >= _value);
58         balances[msg.sender] = safeSub(balances[msg.sender], _value);//从消息发送者账户中减去token数量_value
59         balances[_to] = safeAdd(balances[_to], _value);//往接收账户增加token数量_value
60         emit Transfer(msg.sender, _to, _value);//触发转币交易事件
61         return true;
62     }
63 
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns
66         (bool success) {
67         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
68         // _value && balances[_to] + _value > balances[_to]);
69         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
70         balances[_to] = safeAdd(balances[_to], _value);//接收账户增加token数量_value
71         balances[_from] = safeSub(balances[_from], _value); //支出账户_from减去token数量_value
72         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);//消息发送者可以从账户_from中转出的数量减少_value
73         emit Transfer(_from, _to, _value);//触发转币交易事件
74         return true;
75     }
76     function balanceOf(address _owner) public constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80 
81     function approve(address _spender, uint256 _value) public returns(bool success)
82     {
83         allowed[msg.sender][_spender] = _value;
84         emit Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88 
89     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
90         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
91     }
92     mapping(address => uint256) balances;
93     mapping(address => mapping(address => uint256)) allowed;
94 }
95 
96 contract ZeroHooStandardToken is StandardToken { 
97 
98     /* Public variables of the token */
99     string public name;                   //名称: eg Simon Bucks
100     uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
101     string public symbol;               //token简称: eg SBX
102     string public version = 'zero 1.0.0';    //版本
103 
104     function ZeroHooStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
105         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
106         totalSupply = _initialAmount;         // 设置初始总量
107         name = _tokenName;                   // token名称
108         decimals = _decimalUnits;           // 小数位数
109         symbol = _tokenSymbol;             // token简称
110     }
111 
112     /* Approves and then calls the receiving contract */
113 
114     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool success) {
115         allowed[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value);
117         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
118         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
119         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
120         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
121         return true;
122     }
123 
124 }