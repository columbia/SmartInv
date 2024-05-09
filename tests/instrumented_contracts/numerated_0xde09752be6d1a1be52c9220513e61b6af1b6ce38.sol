1 pragma solidity ^ 0.4.21;
2 
3 contract Token{
4     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
5     uint256 public totalSupply;
6 
7     /// 获取账户_owner拥有token的数量 
8     function balanceOf(address _owner) public constant returns (uint256 balance);
9 
10     //从消息发送者账户中往_to账户转数量为_value的token
11     function transfer(address _to, uint256 _value) public returns(bool success);
12 
13     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
14     function transferFrom(address _from, address _to, uint256 _value) public returns
15         (bool success);
16 
17     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
18     function approve(address _spender, uint256 _value) public returns(bool success);
19 
20     //获取账户_spender可以从账户_owner中转出token的数量
21     function allowance(address _owner, address _spender) public constant returns 
22         (uint256 remaining);
23 
24     //发生转账时必须要触发的事件 
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 
27     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
28     event Approval(address indexed _owner, address indexed _spender, uint256 
29     _value);
30 }
31 
32 contract SafeMath {
33     uint256 constant public MAX_UINT256 =
34         0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
35 
36     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
37         if (x > MAX_UINT256 - y) revert();
38         return x + y;
39     }
40 
41     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
42         if (x < y) revert();
43         return x - y;
44     }
45 
46     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
47         if (y == 0) return 0;
48         if (x > MAX_UINT256 / y) revert();
49         return x * y;
50     }
51 }
52 
53 contract StandardToken is Token, SafeMath {
54     function transfer(address _to, uint256 _value) public returns(bool success) {
55         //默认totalSupply 不会超过最大值 (2^256 - 1).
56         require(balances[msg.sender] >= _value);
57         balances[msg.sender] = safeSub(balances[msg.sender], _value);//从消息发送者账户中减去token数量_value
58         balances[_to] = safeAdd(balances[_to], _value);//往接收账户增加token数量_value
59         emit Transfer(msg.sender, _to, _value);//触发转币交易事件
60         return true;
61     }
62 
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns
65         (bool success) {
66        
67         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
68         balances[_to] = safeAdd(balances[_to], _value);//接收账户增加token数量_value
69         balances[_from] = safeSub(balances[_from], _value); //支出账户_from减去token数量_value
70         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);//消息发送者可以从账户_from中转出的数量减少_value
71         emit Transfer(_from, _to, _value);//触发转币交易事件
72         return true;
73     }
74     function balanceOf(address _owner) public constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78 
79     function approve(address _spender, uint256 _value) public returns(bool success)
80     {
81         allowed[msg.sender][_spender] = _value;
82         emit Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86 
87     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
89     }
90     mapping(address => uint256) balances;
91     mapping(address => mapping(address => uint256)) allowed;
92 }
93 
94 contract OKG is StandardToken { 
95 
96     /* Public variables of the token */
97     string public name;                   //名称
98     uint8 public decimals;               //最多的小数位数
99     string public symbol;               //token
100     string public version = '1.0.0';    //版本
101 
102     function OKG(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
103         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
104         totalSupply = _initialAmount;         // 设置初始总量
105         name = _tokenName;                   // token名称
106         decimals = _decimalUnits;           // 小数位数
107         symbol = _tokenSymbol;             // token简称
108     }
109 
110     /* Approves and then calls the receiving contract */
111 
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool success) {
113         allowed[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
116         return true;
117     }
118 
119 }