1 /**
2  * Source Code first verified at https://etherscan.io on Monday, June 17, 2019
3  (UTC) */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Wednesday, September 27, 2017
7  (UTC) */
8 
9 pragma solidity ^0.4.8;
10 contract Token{
11     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
12     uint256 public totalSupply;
13 
14     /// 获取账户_owner拥有token的数量 
15     function balanceOf(address _owner) constant returns (uint256 balance);
16 
17     //从消息发送者账户中往_to账户转数量为_value的token
18     function transfer(address _to, uint256 _value) returns (bool success);
19 
20     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
21     function transferFrom(address _from, address _to, uint256 _value) returns   
22     (bool success);
23 
24     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
25     function approve(address _spender, uint256 _value) returns (bool success);
26 
27     //获取账户_spender可以从账户_owner中转出token的数量
28     function allowance(address _owner, address _spender) constant returns 
29     (uint256 remaining);
30 
31     //发生转账时必须要触发的事件 
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33 
34     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
35     event Approval(address indexed _owner, address indexed _spender, uint256 
36     _value);
37 }
38 
39 contract StandardToken is Token {
40     function transfer(address _to, uint256 _value) returns (bool success) {
41         //默认totalSupply 不会超过最大值 (2^256 - 1).
42         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
43         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
44         require(balances[msg.sender] >= _value);
45         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
46         balances[_to] += _value;//往接收账户增加token数量_value
47         Transfer(msg.sender, _to, _value);//触发转币交易事件
48         return true;
49     }
50 
51 
52     function transferFrom(address _from, address _to, uint256 _value) returns 
53     (bool success) {
54         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
55         // _value && balances[_to] + _value > balances[_to]);
56         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
57         balances[_to] += _value;//接收账户增加token数量_value
58         balances[_from] -= _value; //支出账户_from减去token数量_value
59         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
60         Transfer(_from, _to, _value);//触发转币交易事件
61         return true;
62     }
63     function balanceOf(address _owner) constant returns (uint256 balance) {
64         return balances[_owner];
65     }
66 
67 
68     function approve(address _spender, uint256 _value) returns (bool success)   
69     {
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75 
76     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
78     }
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81 }
82 
83 contract kgjf is StandardToken { 
84 
85     /* Public variables of the token */
86     string public name;                   //名称: eg Simon Bucks
87     uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
88     string public symbol;               //token简称: eg SBX
89     string public version = 'H0.1';    //版本
90 
91     function kgjf (uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
92         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
93         totalSupply = _initialAmount;         // 设置初始总量
94         name = _tokenName;                   // token名称
95         decimals = _decimalUnits;           // 小数位数
96         symbol = _tokenSymbol;             // token简称
97     }
98 
99     /* Approves and then calls the receiving contract */
100     
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
105         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
106         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
107         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
108         return true;
109     }
110 
111 }