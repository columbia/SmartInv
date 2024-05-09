1 /*
2     WhaleChain contract 2018 
3     
4  */
5  
6 pragma solidity ^0.4.8;
7 contract Token{
8     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
9     uint256 public totalSupply;
10 
11     /// 获取账户_owner拥有token的数量 
12     function balanceOf(address _owner) constant returns (uint256 balance);
13 
14     //从消息发送者账户中往_to账户转数量为_value的token
15     function transfer(address _to, uint256 _value) returns (bool success);
16 
17     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
18     function transferFrom(address _from, address _to, uint256 _value) returns   
19     (bool success);
20 
21     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
22     function approve(address _spender, uint256 _value) returns (bool success);
23 
24     //获取账户_spender可以从账户_owner中转出token的数量
25     function allowance(address _owner, address _spender) constant returns 
26     (uint256 remaining);
27 
28     //发生转账时必须要触发的事件 
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30 
31     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
32     event Approval(address indexed _owner, address indexed _spender, uint256 
33     _value);
34 }
35 
36 contract StandardToken is Token {
37     function transfer(address _to, uint256 _value) returns (bool success) {
38         //默认totalSupply 不会超过最大值 (2^256 - 1).
39         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
40         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
41         require(balances[msg.sender] >= _value);
42         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
43         balances[_to] += _value;//往接收账户增加token数量_value
44         Transfer(msg.sender, _to, _value);//触发转币交易事件
45         return true;
46     }
47 
48 
49     function transferFrom(address _from, address _to, uint256 _value) returns 
50     (bool success) {
51         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
52         // _value && balances[_to] + _value > balances[_to]);
53         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
54         balances[_to] += _value;//接收账户增加token数量_value
55         balances[_from] -= _value; //支出账户_from减去token数量_value
56         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
57         Transfer(_from, _to, _value);//触发转币交易事件
58         return true;
59     }
60     function balanceOf(address _owner) constant returns (uint256 balance) {
61         return balances[_owner];
62     }
63 
64 
65     function approve(address _spender, uint256 _value) returns (bool success)   
66     {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72 
73     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
74         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
75     }
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78 }
79 
80 contract WhaleChain is StandardToken { 
81 
82     /* Public variables of the token */
83     string public name;                   //名称: eg Simon Bucks
84     uint8 public decimals;                //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
85     string public symbol;                 //token简称: eg SBX
86     string public version = 'v1.0';       //版本
87 
88     function WhaleChain(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
89         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
90         totalSupply = _initialAmount;          // 设置初始总量
91         name = _tokenName;                     // token名称
92         decimals = _decimalUnits;              // 小数位数
93         symbol = _tokenSymbol;                 // token简称
94     }
95 
96     /* Approves and then calls the receiving contract */
97 
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
102         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
103         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
104         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
105         return true;
106     }
107 
108 }