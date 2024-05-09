1 pragma solidity ^0.4.23;
2 
3 //X Harvest System   
4 //简称  XHS
5 //中文  西红柿
6 //发行量   10亿枚
7 
8 contract Token{
9 
10     uint256 public totalSupply;
11 
12 
13     function balanceOf(address _owner) constant returns (uint256 balance);
14     function transfer(address _to, uint256 _value) returns (bool success);
15     function transferFrom(address _from, address _to, uint256 _value) returns   
16     (bool success);
17     function approve(address _spender, uint256 _value) returns (bool success);
18     function allowance(address _owner, address _spender) constant returns 
19     (uint256 remaining);
20 
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22 
23     event Approval(address indexed _owner, address indexed _spender, uint256 
24     _value);
25 }
26 
27 contract StandardToken is Token {
28     function transfer(address _to, uint256 _value) returns (bool success) {
29         require(balances[msg.sender] >= _value);
30         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
31         balances[_to] += _value;//往接收账户增加token数量_value
32         Transfer(msg.sender, _to, _value);//触发转币交易事件
33         return true;
34     }
35 
36 
37     function transferFrom(address _from, address _to, uint256 _value) returns 
38     (bool success) {
39       
40         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
41         balances[_to] += _value;//接收账户增加token数量_value
42         balances[_from] -= _value; //支出账户_from减去token数量_value
43         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
44         Transfer(_from, _to, _value);//触发转币交易事件
45         return true;
46     }
47     function balanceOf(address _owner) constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50 
51 
52     function approve(address _spender, uint256 _value) returns (bool success)   
53     {
54         allowed[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59 
60     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
61         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
62     }
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65 }
66 
67 contract xhstoken is StandardToken { 
68 
69     /* Public variables of the token */
70     string public name;                   
71     uint8 public decimals;               
72     string public symbol;               //token
73     string public version = 'v2.0';    
74 
75     function xhstoken() {
76         balances[msg.sender] = 1000000000000000000000000000; // 初始token数量给予消息发送者
77         totalSupply = 1000000000000000000000000000;         // 设置初始总量
78         name = "X Harvest System";                   // token名称
79         decimals = 18;           // 小数位数
80         symbol = "XHS";             // token简称
81     }
82 
83     /* Approves and then calls the receiving contract */
84     
85     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
89         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
90         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
91         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
92         return true;
93     }
94 
95 }