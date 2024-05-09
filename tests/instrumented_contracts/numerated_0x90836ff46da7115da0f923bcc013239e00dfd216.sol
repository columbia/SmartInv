1 pragma solidity ^0.4.24;
2 contract LCToken{
3   
4     uint256 public totalSupply;
5 
6    
7     function balanceOf(address _owner)public constant returns (uint256 balance);
8 
9   
10     function transfer(address _to, uint256 _value)public returns (bool success);
11 
12    
13     function transferFrom(address _from, address _to, uint256 _value)public returns   
14     (bool success);
15 
16   
17     function approve(address _spender, uint256 _value)public returns (bool success);
18 
19   
20     function allowance(address _owner, address _spender)public constant returns 
21     (uint256 remaining);
22 
23    
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25 
26    
27     event Approval(address indexed _owner, address indexed _spender, uint256 
28     _value);
29 }
30 
31 contract LCStandardToken is LCToken {
32     function transfer(address _to, uint256 _value)public returns (bool success) {
33 	    require(_to!= address(0));
34         require(balances[msg.sender] >= _value);
35 		require(balances[_to] +_value>=balances[_to]);
36         balances[msg.sender] -= _value;
37         balances[_to] += _value;
38         emit Transfer(msg.sender, _to, _value);
39         return true;
40     }
41 
42 
43     function transferFrom(address _from, address _to, uint256 _value)public returns 
44     (bool success) {
45         require(_to!= address(0));
46         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
47         require(balances[_to] +_value>=balances[_to]);
48 		balances[_to] += _value;
49         balances[_from] -= _value; 
50         allowed[_from][msg.sender] -= _value;
51         emit Transfer(_from, _to, _value);
52         return true;
53     }
54     function balanceOf(address _owner)public constant returns (uint256 balance) {
55         return balances[_owner];
56     }
57 
58 
59     function approve(address _spender, uint256 _value)public returns (bool success)   
60     {
61         allowed[msg.sender][_spender] = _value;
62        emit Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66 
67     function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
68         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
69     }
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 }
73 
74 contract LCStandardCreateToken is LCStandardToken { 
75 
76  
77     string public name;                   
78     uint8 public decimals;              
79     string public symbol;              
80     string public version = 'H0.1';    
81 
82     constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol)public {
83         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
84         totalSupply = _initialAmount;         // 设置初始总量
85         name = _tokenName;                   // token名称
86         decimals = _decimalUnits;           // 小数位数
87         symbol = _tokenSymbol;             // token简称
88     }
89 
90     /* Approves and then calls the receiving contract */
91     
92     function approveAndCall(address _spender, uint256 _value)public returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         emit Approval(msg.sender, _spender, _value);
95         return true;
96     }
97     
98     
99 
100 }