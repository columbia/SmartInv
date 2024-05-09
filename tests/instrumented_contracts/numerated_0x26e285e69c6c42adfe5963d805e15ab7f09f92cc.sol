1 pragma solidity ^0.4.23;
2 
3 
4 contract Token{
5     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
6     uint256 public totalSupply;
7 
8     /// 获取账户_owner拥有token的数量 
9     function balanceOf(address _owner) constant returns (uint256 balance);
10 
11     //从消息发送者账户中往_to账户转数量为_value的token
12     function transfer(address _to, uint256 _value) returns (bool success);
13 
14     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
15     function transferFrom(address _from, address _to, uint256 _value) returns   
16     (bool success);
17 
18     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
19     function approve(address _spender, uint256 _value) returns (bool success);
20 
21     //获取账户_spender可以从账户_owner中转出token的数量
22     function allowance(address _owner, address _spender) constant returns 
23     (uint256 remaining);
24 
25     //发生转账时必须要触发的事件 
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27 
28     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
29     event Approval(address indexed _owner, address indexed _spender, uint256 
30     _value);
31 }
32 
33 contract StandardToken is Token {
34     function transfer(address _to, uint256 _value) returns (bool success) {
35         //默认totalSupply 不会超过最大值 (2^256 - 1).
36         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的
37         
38         require(balances[msg.sender] >= _value);
39         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
40         balances[_to] += _value;//往接收账户增加token数量_value
41         Transfer(msg.sender, _to, _value);//触发转币交易事件
42         return true;
43     }
44 
45 
46     function transferFrom(address _from, address _to, uint256 _value) returns 
47     (bool success) {
48         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
49         // _value && balances[_to] + _value > balances[_to]);
50         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
51         balances[_to] += _value;//接收账户增加token数量_value
52         balances[_from] -= _value; //支出账户_from减去token数量_value
53         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
54         Transfer(_from, _to, _value);//触发转币交易事件
55         return true;
56     }
57     function balanceOf(address _owner) constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60 
61 
62     function approve(address _spender, uint256 _value) returns (bool success)   
63     {
64         allowed[msg.sender][_spender] = _value;
65         Approval(msg.sender, _spender, _value);
66         return true;
67     }
68 
69 
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
72     }
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75 }
76 
77 contract HumanStandardToken is StandardToken { 
78 
79     /* Public variables of the token */
80     string public name;                   //名称: eg Simon Bucks
81     uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
82     string public symbol;               //token简称: eg SBX
83     string public version = 'H0.1';    //版本
84 
85     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
86         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
87         totalSupply = _initialAmount;         // 设置初始总量
88         name = _tokenName;                   // token名称
89         decimals = _decimalUnits;           // 小数位数
90         symbol = _tokenSymbol;             // token简称
91     }
92 
93     /* Approves and then calls the receiving contract */
94     
95     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
99         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
100         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
101         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
102         return true;
103     }
104 
105 }