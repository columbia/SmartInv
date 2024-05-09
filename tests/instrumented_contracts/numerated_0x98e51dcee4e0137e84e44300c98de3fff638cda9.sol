1 pragma solidity ^0.4.8;
2 contract Token{
3     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
4     uint256 public totalSupply;
5     /// 获取账户_owner拥有token的数量 
6     function balanceOf(address _owner) constant returns (uint256 balance);
7     //从消息发送者账户中往_to账户转数量为_value的token
8     function transfer(address _to, uint256 _value) returns (bool success);
9 
10     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
11     function transferFrom(address _from, address _to, uint256 _value) returns   
12     (bool success);
13 
14     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
15     function approve(address _spender, uint256 _value) returns (bool success);
16     //获取账户_spender可以从账户_owner中转出token的数量
17     function allowance(address _owner, address _spender) constant returns 
18     (uint256 remaining);
19 
20     //发生转账时必须要触发的事件 
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22 
23     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
24     event Approval(address indexed _owner, address indexed _spender, uint256 
25     _value);
26 }
27 
28 contract StandardToken is Token {
29     function transfer(address _to, uint256 _value) returns (bool success) {
30         //默认totalSupply 不会超过最大值 (2^256 - 1).
31         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
32         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
33         require(balances[msg.sender] >= _value);
34         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
35         balances[_to] += _value;//往接收账户增加token数量_value
36         Transfer(msg.sender, _to, _value);//触发转币交易事件
37         return true;
38     }
39 
40 
41     function transferFrom(address _from, address _to, uint256 _value) returns 
42     (bool success) {
43         require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
44          _value && balances[_to] + _value > balances[_to]);
45         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
46         balances[_to] += _value;//接收账户增加token数量_value
47         balances[_from] -= _value; //支出账户_from减去token数量_value
48         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
49         Transfer(_from, _to, _value);//触发转币交易事件
50         return true;
51     }
52     function balanceOf(address _owner) constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     function approve(address _spender, uint256 _value) returns (bool success)   
57     {
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63 
64     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
65         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
66     }
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69 }
70 
71 contract HumanStandardToken is StandardToken { 
72 
73     /* Public variables of the token */
74     string public name;                   //名称: eg Simon Bucks
75     uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
76     string public symbol;               //token简称: eg SBX
77     string public version = 'H0.1';    //版本
78 
79     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
80         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
81         totalSupply = _initialAmount;         // 设置初始总量
82         name = _tokenName;                   // token名称
83         decimals = _decimalUnits;           // 小数位数
84         symbol = _tokenSymbol;             // token简称
85     }
86 
87     /* Approves and then calls the receiving contract */
88     
89     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
93         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
94         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
95         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
96         return true;
97     }
98 
99 }