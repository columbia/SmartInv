1 pragma solidity ^0.4.24;
2 contract LTCOINToken{
3   
4     uint256 public totalSupply;
5 
6    
7     function balanceOf(address _owner)public  returns (uint256 balance);
8 
9   
10     function transfer(address _to, uint256 _value)public returns (bool success);
11 
12    
13     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);
14 
15   
16     function approve(address _spender, uint256 _value)public returns (bool success);
17 
18   
19     function allowance(address _owner, address _spender)public  returns (uint256 remaining);
20 
21    
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23 
24    
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 }
27 
28 contract LTCOINStandardToken is LTCOINToken {
29     function transfer(address _to, uint256 _value)public returns (bool success) {
30         require(_to!=address(0));
31         require(balances[msg.sender] >= _value);
32         require(balances[_to]+_value>=balances[_to]);
33         balances[msg.sender] -= _value;
34         balances[_to] += _value;
35         emit Transfer(msg.sender, _to, _value);
36         return true;
37     }
38 
39 
40     function transferFrom(address _from, address _to, uint256 _value)public returns 
41     (bool success) {
42         require(_to!=address(0));
43         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
44         require(balances[_to] +_value>=balances[_to]);
45         balances[_to]+=_value;
46         balances[_from] -= _value; 
47         allowed[_from][msg.sender] -= _value;
48         emit Transfer(_from, _to, _value);
49         return true;
50     }
51     function balanceOf(address _owner)public  returns (uint256 balance) {
52         return balances[_owner];
53     }
54 
55 
56     function approve(address _spender, uint256 _value)public returns (bool success)   
57     {
58         allowed[msg.sender][_spender] = _value;
59         emit Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63 
64     function allowance(address _owner, address _spender)public  returns (uint256 remaining) {
65         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
66     }
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69 }
70 
71 contract LTCOINStandardCreateToken is LTCOINStandardToken { 
72 
73  
74     string public name;                   
75     uint8 public decimals;              
76     string public symbol;              
77     string public version;    
78 
79     constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol)public {
80         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
81         totalSupply = _initialAmount;         // 设置初始总量
82         name = _tokenName;                   // token名称
83         decimals = _decimalUnits;           // 小数位数
84         symbol = _tokenSymbol;             // token简称
85     }
86 
87     /* Approves and then calls the receiving contract */
88     
89     function approveAndCall(address _spender, uint256 _value)public returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         emit Approval(msg.sender, _spender, _value);
92         return true;
93     }
94     
95     
96 
97 }