1 pragma solidity ^0.4.18;
2 
3 contract Token {
4     //获取账户_owner拥有token的数量 
5     function balanceOf(address _owner) constant returns (uint256 balance);
6 
7     //从消息发送者账户中往_to账户转数量为_value的token
8     function transfer(address _to, uint256 _value) returns (bool success);
9 
10     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12 
13     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
14     function approve(address _spender, uint256 _value) returns (bool success);
15 
16     //获取账户_spender可以从账户_owner中转出token的数量
17     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
18 
19     //发生转账时必须要触发的事件 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21 
22     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24     
25     //token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
26     uint256 public totalSupply;
27 }
28 
29 contract StandardToken is Token {
30     function balanceOf(address _owner) constant returns (uint256 balance) {
31         return balances[_owner];
32     }
33     
34     function transfer(address _to, uint256 _value) returns (bool success) {
35         //默认totalSupply 不会超过最大值 (2^256 - 1).
36         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
37         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
38         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
39         balances[_to] += _value;//往接收账户增加token数量_value
40         Transfer(msg.sender, _to, _value);//触发转币交易事件
41         return true;
42     }
43 
44     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
45         require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
46             _value && balances[_to] + _value > balances[_to]);
47         balances[_to] += _value;//接收账户增加token数量_value
48         balances[_from] -= _value; //支出账户_from减去token数量_value
49         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
50         Transfer(_from, _to, _value);//触发转币交易事件
51         return true;
52     }
53 
54     function approve(address _spender, uint256 _value) returns (bool success)   
55     {
56         allowed[msg.sender][_spender] = _value;
57         Approval(msg.sender, _spender, _value);
58         return true;
59     }
60     
61     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
62         require(_addedValue > 0);
63         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
64         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
65         return true;
66     }
67     
68     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
69         require(_subtractedValue > 0);
70         uint oldValue = allowed[msg.sender][_spender];
71         if (_subtractedValue >= oldValue) {
72             allowed[msg.sender][_spender] = 0;
73         } else {
74             allowed[msg.sender][_spender] = oldValue - _subtractedValue;
75         }
76         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
81         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
82     }
83     
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86 }
87 
88 contract MyToken is StandardToken {
89     /* Public variables of the token */
90     string public name;             // token name
91     uint8  public decimals;
92     string public symbol;           // token symbol
93     
94     function(){
95         revert();
96     }
97 
98     function MyToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
99         name = _tokenName;
100         decimals = _decimalUnits;
101         symbol = _tokenSymbol;
102         totalSupply = _initialAmount * (10 ** uint256(_decimalUnits));
103         balances[msg.sender] = totalSupply;
104     }
105 
106     /* Approves and then calls the receiving contract */
107     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         //发送者通知代币合约：1STORE币授权给了服务合约（通过调用代币合约的 approveAndCall()函数）
111         //代币合约通知服务合约：1STORE币已经授权给了服务合约（通过调用服务合约的 receiveApproval()函数）
112         //服务合约指示代币合约将代币从发送者的账户转移到服务合约的账户（通过调用服务合约的 transferFrom()函数 并且存储信息)
113         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
114         return true;
115     }
116 }