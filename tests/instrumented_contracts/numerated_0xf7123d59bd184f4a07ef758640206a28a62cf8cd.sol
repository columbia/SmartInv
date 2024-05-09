1 pragma solidity ^0.4.12;
2  
3 contract SafeMath {
4  
5  
6     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
7         uint256 z = x + y;
8         assert((z >= x) && (z >= y));
9         return z;
10     }
11  
12     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
13         assert(x >= y);
14         uint256 z = x - y;
15         return z;
16     }
17  
18     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
19         uint256 z = x * y;
20         assert((x == 0)||(z/x == y));
21         return z;
22     }
23  
24 }
25  
26 contract Token {
27     uint256 public totalSupply;
28     function balanceOf(address _owner) constant returns (uint256 balance);
29     function transfer(address _to, uint256 _value) returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31     function approve(address _spender, uint256 _value) returns (bool success);
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36  
37  
38 /*  ERC 20 token */
39 contract StandardToken is Token {
40  
41     function transfer(address _to, uint256 _value) returns (bool success) {
42         if (balances[msg.sender] >= _value && _value > 0) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             Transfer(msg.sender, _to, _value);
46             return true;
47         } else {
48             return false;
49         }
50     }
51  
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         } else {
60             return false;
61         }
62     }
63  
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67  
68     function approve(address _spender, uint256 _value) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73  
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75         return allowed[_owner][_spender];
76     }
77  
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80 }
81  
82 contract UBTToken is StandardToken, SafeMath {
83  
84     // metadata
85     string  public constant name = "UBTToken";
86     string  public constant symbol = "UBT";
87     uint256 public constant decimals = 18;
88             
89     // events
90     
91     function formatDecimals(uint256 _value) internal returns (uint256 ) {
92         return _value * 10 ** decimals;
93     }
94  
95    
96     function UBTToken()
97     {
98      
99         totalSupply = formatDecimals(200000000);
100         balances[msg.sender] = totalSupply;
101     }
102  
103  
104 }