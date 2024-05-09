1 pragma solidity ^0.4.23;
2 
3 //英文全称： Exchange Traded Funds  Token
4 //简称：ETFT
5 //中文：基金链
6 //发行量：19亿枚
7 //发行价:0.13$
8 
9 
10 
11 
12 contract Token{
13 
14     uint256 public totalSupply;
15 
16 
17 function balanceOf(address _owner) constant returns (uint256 balance);
18     function transfer(address _to, uint256 _value) returns (bool success);
19     function transferFrom(address _from, address _to, uint256 _value) returns   
20     (bool success);
21     function approve(address _spender, uint256 _value) returns (bool success);
22     function allowance(address _owner, address _spender) constant returns
23     (uint256 remaining);
24 
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26 
27     event Approval(address indexed _owner, address indexed _spender, uint256
28     _value);
29 }
30 
31 contract StandardToken is Token {
32     function transfer(address _to, uint256 _value) returns (bool success) {
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
43      
44         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
45         balances[_to] += _value;//接收账户增加token数量_value
46         balances[_from] -= _value; //支出账户_from减去token数量_value
47         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
48         Transfer(_from, _to, _value);//触发转币交易事件
49         return true;
50     }
51     function balanceOf(address _owner) constant returns (uint256 balance) {
52         return balances[_owner];
53     }
54 
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
71 contract ETFTtoken is StandardToken {
72 
73     /* Public variables of the token */
74     string public name;                   
75     uint8 public decimals;               
76     string public symbol;               //token
77     string public version = 'v1.1';   
78 
79     function ETFTtoken() {
80         balances[msg.sender] = 1900000000000000000000000000; // 初始token数量给予消息发送者
81         totalSupply = 1900000000000000000000000000;         // 设置初始总量
82         name = "Exchange Traded Funds Token";                   // token名称
83         decimals = 18;           // 小数位数
84         symbol = "ETFT";             // token简称
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