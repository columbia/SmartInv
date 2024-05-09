1 pragma solidity ^0.4.23;
2 
3 // ALE
4 // Asset Link Entertainment
5 
6 
7 contract Token{
8 
9     uint256 public totalSupply;
10 
11 
12     function balanceOf(address _owner) constant returns (uint256 balance);
13     function transfer(address _to, uint256 _value) returns (bool success);
14     function transferFrom(address _from, address _to, uint256 _value) returns   
15     (bool success);
16     function approve(address _spender, uint256 _value) returns (bool success);
17     function allowance(address _owner, address _spender) constant returns 
18     (uint256 remaining);
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21 
22     event Approval(address indexed _owner, address indexed _spender, uint256 
23     _value);
24 }
25 
26 contract StandardToken is Token {
27     function transfer(address _to, uint256 _value) returns (bool success) {
28         require(balances[msg.sender] >= _value);
29         balances[msg.sender] -= _value;
30         balances[_to] += _value;
31         Transfer(msg.sender, _to, _value);
32         return true;
33     }
34 
35 
36     function transferFrom(address _from, address _to, uint256 _value) returns 
37     (bool success) {
38       
39         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
40         balances[_to] += _value;//接收账户增加token数量_value
41         balances[_from] -= _value; //支出账户_from减去token数量_value
42         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
43         Transfer(_from, _to, _value);//触发转币交易事件
44         return true;
45     }
46     function balanceOf(address _owner) constant returns (uint256 balance) {
47         return balances[_owner];
48     }
49 
50 
51     function approve(address _spender, uint256 _value) returns (bool success)   
52     {
53         allowed[msg.sender][_spender] = _value;
54         Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58 
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
60         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
61     }
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64 }
65 
66 contract aletoken is StandardToken { 
67 
68     /* Public variables of the token */
69     string public name;                   
70     uint8 public decimals;               
71     string public symbol;               //token
72     string public version = 'v1.0';    
73 
74     function aletoken(string _tokenSymbol) {
75         balances[msg.sender] = 4000000000000000000000000000; // 初始token数量给予消息发送者
76         totalSupply = 4000000000000000000000000000;         // 设置初始总量
77         name = "Asset Link Entertainment";        
78         decimals = 18;
79         symbol = _tokenSymbol;  
80     }
81 
82     /* Approves and then calls the receiving contract */
83     
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
88         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
89         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
90         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
91         return true;
92     }
93 
94 }