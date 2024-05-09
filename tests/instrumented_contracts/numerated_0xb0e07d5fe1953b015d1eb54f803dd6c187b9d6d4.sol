1 pragma solidity ^0.4.8;
2 contract Token{
3     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
4     uint256 public totalSupply;
5 
6     /// 获取账户_owner拥有token的数量 
7     function balanceOf(address _owner) constant returns (uint256 balance);
8 
9     //从消息发送者账户中往_to账户转数量为_value的token
10     function transfer(address _to, uint256 _value) returns (bool success);
11 
12     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
13     function transferFrom(address _from, address _to, uint256 _value) returns   
14     (bool success);
15 
16     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
17     function approve(address _spender, uint256 _value) returns (bool success);
18 
19     //获取账户_spender可以从账户_owner中转出token的数量
20     function allowance(address _owner, address _spender) constant returns 
21     (uint256 remaining);
22 
23     //发生转账时必须要触发的事件 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25 
26     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
27     event Approval(address indexed _owner, address indexed _spender, uint256 
28     _value);
29 }
30 
31 contract StandardToken is Token {
32     function transfer(address _to, uint256 _value) returns (bool success) {
33         //默认totalSupply 不会超过最大值 (2^256 - 1).
34         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
35         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
36         require(balances[msg.sender] >= _value);
37         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
38         balances[_to] += _value;//往接收账户增加token数量_value
39         Transfer(msg.sender, _to, _value);//触发转币交易事件
40         return true;
41     }
42 
43 
44     function transferFrom(address _from, address _to, uint256 _value) returns 
45     (bool success) {
46         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
47         // _value && balances[_to] + _value > balances[_to]);
48         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
49         balances[_to] += _value;//接收账户增加token数量_value
50         balances[_from] -= _value; //支出账户_from减去token数量_value
51         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
52         Transfer(_from, _to, _value);//触发转币交易事件
53         return true;
54     }
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59 
60     function approve(address _spender, uint256 _value) returns (bool success)   
61     {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67 
68     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
69         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
70     }
71     mapping (address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;
73 }
74 
75 contract RootAntCoin is StandardToken { 
76 
77     /* Public variables of the token */
78     string public name;                   //名称: eg Simon Bucks
79     uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
80     string public symbol;               //token简称: eg SBX
81     string public version = 'H0.1';    //版本
82 
83     function RootAntCoin(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
84         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
85         totalSupply = _initialAmount;         // 设置初始总量
86         name = _tokenName;                   // token名称
87         decimals = _decimalUnits;           // 小数位数
88         symbol = _tokenSymbol;             // token简称
89     }
90 
91     /* Approves and then calls the receiving contract */
92     
93     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
94         allowed[msg.sender][_spender] = _value;
95         Approval(msg.sender, _spender, _value);
96         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
97         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
98         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
99         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
100         return true;
101     }
102 
103 }