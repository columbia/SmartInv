1 pragma solidity ^0.4.23;
2 
3 // great wall token 
4 // power by great wall exchange
5 
6 contract Token{
7 
8     uint256 public totalSupply;
9 
10 
11     function balanceOf(address _owner) constant returns (uint256 balance);
12     function transfer(address _to, uint256 _value) returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) returns   
14     (bool success);
15     function approve(address _spender, uint256 _value) returns (bool success);
16     function allowance(address _owner, address _spender) constant returns 
17     (uint256 remaining);
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20 
21     event Approval(address indexed _owner, address indexed _spender, uint256 
22     _value);
23 }
24 
25 contract StandardToken is Token {
26     function transfer(address _to, uint256 _value) returns (bool success) {
27         require(balances[msg.sender] >= _value);
28         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
29         balances[_to] += _value;//往接收账户增加token数量_value
30         Transfer(msg.sender, _to, _value);//触发转币交易事件
31         return true;
32     }
33 
34 
35     function transferFrom(address _from, address _to, uint256 _value) returns 
36     (bool success) {
37       
38         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
39         balances[_to] += _value;//接收账户增加token数量_value
40         balances[_from] -= _value; //支出账户_from减去token数量_value
41         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
42         Transfer(_from, _to, _value);//触发转币交易事件
43         return true;
44     }
45     function balanceOf(address _owner) constant returns (uint256 balance) {
46         return balances[_owner];
47     }
48 
49 
50     function approve(address _spender, uint256 _value) returns (bool success)   
51     {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57 
58     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
59         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
60     }
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63 }
64 
65 contract gwtoken is StandardToken { 
66 
67     /* Public variables of the token */
68     string public name;                   
69     uint8 public decimals;               
70     string public symbol;               //token
71     string public version = 'v1.0';    
72 
73     function gwtoken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
74         balances[msg.sender] = 2000000000000000000000000000; // 初始token数量给予消息发送者
75         totalSupply = 2000000000000000000000000000;         // 设置初始总量
76         name = _tokenName;                   // token名称
77         decimals = _decimalUnits;           // 小数位数
78         symbol = _tokenSymbol;             // token简称
79     }
80 
81     /* Approves and then calls the receiving contract */
82     
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
87         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
88         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
89         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
90         return true;
91     }
92 
93 }