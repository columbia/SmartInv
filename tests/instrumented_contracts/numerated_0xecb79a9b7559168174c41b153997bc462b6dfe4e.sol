1 /**
2  *Submitted for verification at Etherscan.io on 2019-12
3 */
4 
5 pragma solidity ^0.4.8;
6 contract Token{
7     uint256 public totalSupply;
8 
9     function balanceOf(address _owner) constant returns (uint256 balance);
10 
11     function transfer(address _to, uint256 _value) returns (bool success);
12 
13     function transferFrom(address _from, address _to, uint256 _value) returns   
14     (bool success);
15 
16     function approve(address _spender, uint256 _value) returns (bool success);
17 
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
30         balances[msg.sender] -= _value;
31         balances[_to] += _value;
32         Transfer(msg.sender, _to, _value);
33         return true;
34     }
35 
36 
37     function transferFrom(address _from, address _to, uint256 _value) returns 
38     (bool success) {
39         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
40         balances[_to] += _value;
41         balances[_from] -= _value; 
42         allowed[_from][msg.sender] -= _value;
43         Transfer(_from, _to, _value);
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
60         return allowed[_owner][_spender];
61     }
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64 }
65 
66 contract TokenNAT is StandardToken { 
67 
68     /* Public variables of the token */
69     string public name;                   
70     uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
71     string public symbol;               //token简称: eg SBX
72     string public version = 'H0.1';    //版本
73 
74     function TokenNAT(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
75         balances[msg.sender] = _initialAmount; 
76         totalSupply = _initialAmount;         // 设置初始总量
77         name = _tokenName;                   // token名称
78         decimals = _decimalUnits;           // 小数位数
79         symbol = _tokenSymbol;             // token简称
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