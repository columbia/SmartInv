1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 contract SafeMath {
8 
9   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
10     assert(b <= a);
11     return a - b;
12   }
13 
14   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
15     uint256 c = a + b;
16     assert(c>=a && c>=b);
17     return c;
18   }
19 }
20 
21 contract Token {
22     
23     function balanceOf(address _owner) constant returns (uint256 balance);
24     function transfer(address _to, uint256 _value) returns (bool success);
25     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
26     function approve(address _spender, uint256 _value) returns (bool success);
27     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 }
31  
32  
33 /*  ERC 20 token */
34 contract erc20 is Token, SafeMath {
35 
36     // metadata
37     string  public  name;
38     string  public  symbol;
39     uint256 public  decimals;
40     uint256 public totalSupply;
41     
42     function erc20(string _name, string _symbol, uint256 _totalSupply, uint256 _decimals){
43         name = _name;
44         symbol = _symbol;
45         decimals = _decimals;
46         totalSupply = formatDecimals(_totalSupply);
47         balances[msg.sender] = totalSupply;
48     }
49     
50     
51     // transfer
52     function formatDecimals(uint256 _value) internal returns (uint256 ) {
53         return _value * 10 ** decimals;
54     }
55 
56     
57     function transfer(address _to, uint256 _value) returns (bool success) {
58         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] +_value > balances[_to] ) {
59             balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);                     
60             balances[_to] = SafeMath.safeAdd(balances[_to], _value); 
61             Transfer(msg.sender, _to, _value);
62             return true;
63         } else {
64             return false;
65         }
66     }
67  
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] +_value > balances[_to]) {
70             balances[_from] = SafeMath.safeSub(balances[_from], _value);                          
71             balances[_to] = SafeMath.safeAdd(balances[_to], _value);                            
72             allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
73 
74             return true;
75         } else {
76             return false;
77         }
78     }
79  
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83  
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89  
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91         return allowed[_owner][_spender];
92     }
93  
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96 }