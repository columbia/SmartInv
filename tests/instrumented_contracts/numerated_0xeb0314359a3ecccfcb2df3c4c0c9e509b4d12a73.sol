1 pragma solidity ^0.4.8;
2 
3 contract Token{
4     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
5     uint256 public totalSupply;
6 
7     /// 获取账户_owner拥有token的数量 
8     function balanceOf(address _owner) constant returns (uint256 balance);
9 
10     //从消息发送者账户中往_to账户转数量为_value的token
11     function transfer(address _to, uint256 _value) returns (bool success);
12 
13     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
14     function transferFrom(address _from, address _to, uint256 _value) returns   
15     (bool success);
16 
17     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
18     function approve(address _spender, uint256 _value) returns (bool success);
19 
20     //获取账户_spender可以从账户_owner中转出token的数量
21     function allowance(address _owner, address _spender) constant returns 
22     (uint256 remaining);
23 
24     //发生转账时必须要触发的事件 
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 
27     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
28     event Approval(address indexed _owner, address indexed _spender, uint256 
29     _value);
30 }
31 
32 contract StandardToken is Token {
33     function transfer(address _to, uint256 _value) returns (bool success) {
34         //默认totalSupply 不会超过最大值 (2^256 - 1).
35         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
36         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
37         require(balances[msg.sender] >= _value);
38         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
39         balances[_to] += _value;//往接收账户增加token数量_value
40         Transfer(msg.sender, _to, _value);//触发转币交易事件
41         return true;
42     }
43 
44 
45     function transferFrom(address _from, address _to, uint256 _value) returns 
46     (bool success) {
47         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
48         // _value && balances[_to] + _value > balances[_to]);
49         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
50         balances[_to] += _value;//接收账户增加token数量_value
51         balances[_from] -= _value; //支出账户_from减去token数量_value
52         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
53         Transfer(_from, _to, _value);//触发转币交易事件
54         return true;
55     }
56     function balanceOf(address _owner) constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60 
61     function approve(address _spender, uint256 _value) returns (bool success)   
62     {
63         allowed[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68 
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
70         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
71     }
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74 }
75 
76 contract SLChainToken is StandardToken { 
77 
78     /* Public variables of the token */
79     string public  name;                
80     uint8  public  decimals;               
81     string public  symbol;                  
82     string public  version = 'v0.1';    
83     string public  website = 'https://salad.co';
84 
85     function SLChainToken(
86         uint256 _initialAmount,
87         string _tokenName,
88         uint8 _decimalUnits,
89         string _tokenSymbol
90         ) {
91         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
92         balances[msg.sender] = totalSupply;                         // Give the creator all initial tokens
93         name = _tokenName;                                          // Set the name for display purposes
94         decimals = _decimalUnits;                                   // Amount of decimals for display purposes
95         symbol = _tokenSymbol;                                      // Set the symbol for display purposes
96     }
97 
98     /* Approves and then calls the receiving contract */
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
100         allowed[msg.sender][_spender] = _value;
101         Approval(msg.sender, _spender, _value);
102         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
103         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
104         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
105         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
106         return true;
107     }
108 
109 }