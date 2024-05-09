1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
5       uint256 z = x + y;
6       assert((z >= x) && (z >= y));
7       return z;
8     }
9 
10     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
11       assert(x >= y);
12       uint256 z = x - y;
13       return z;
14     }
15 
16     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
17       uint256 z = x * y;
18       assert((x == 0)||(z/x == y));
19       return z;
20     }
21 
22 }
23 
24 contract Token {
25     uint256 public totalSupply;
26     function balanceOf(address _owner) constant returns (uint256 balance);
27     function transfer(address _to, uint256 _value) returns (bool success);
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
29     function approve(address _spender, uint256 _value) returns (bool success);
30     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 
35 
36 /*  ERC 20 token */
37 contract StandardToken is Token {
38 
39     function transfer(address _to, uint256 _value) returns (bool success) {
40       if (balances[msg.sender] >= _value && _value > 0) {
41         balances[msg.sender] -= _value;
42         balances[_to] += _value;
43         Transfer(msg.sender, _to, _value);
44         return true;
45       } else {
46         return false;
47       }
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
51       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52         balances[_to] += _value;
53         balances[_from] -= _value;
54         allowed[_from][msg.sender] -= _value;
55         Transfer(_from, _to, _value);
56         return true;
57       } else {
58         return false;
59       }
60     }
61 
62     function balanceOf(address _owner) constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint256 _value) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
73       return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78 }
79 
80 contract GDC is StandardToken, SafeMath {
81 
82     string public constant name = "GDC001";
83     string public constant symbol = "GDC001";
84     uint256 public constant decimals = 18;
85     string public version = "1.0";
86 
87     address public GDCAcc01;
88     address public GDCAcc02;
89     address public GDCAcc03;
90     address public GDCAcc04;
91     address public GDCAcc05;
92 
93     uint256 public constant factorial = 6;
94     uint256 public constant GDCNumber1 = 200 * (10**factorial) * 10**decimals; //GDCAcc1代币数量
95     uint256 public constant GDCNumber2 = 200 * (10**factorial) * 10**decimals; //GDCAcc2代币数量
96     uint256 public constant GDCNumber3 = 200 * (10**factorial) * 10**decimals; //GDCAcc3代币数量
97     uint256 public constant GDCNumber4 = 200 * (10**factorial) * 10**decimals; //GDCAcc4代币数量
98     uint256 public constant GDCNumber5 = 200 * (10**factorial) * 10**decimals; //GDCAcc5代币数量
99 
100   
101 
102     // constructor
103  
104     function GDC(
105       address _GDCAcc01,
106       address _GDCAcc02,
107       address _GDCAcc03,
108       address _GDCAcc04,
109       address _GDCAcc05
110     )
111     {
112       GDCAcc01 = _GDCAcc01;
113       GDCAcc02 = _GDCAcc02;
114       GDCAcc03 = _GDCAcc03;
115       GDCAcc04 = _GDCAcc04;
116       GDCAcc05 = _GDCAcc05;
117 
118       balances[GDCAcc01] = GDCNumber1;
119       balances[GDCAcc02] = GDCNumber2;
120       balances[GDCAcc03] = GDCNumber3;
121       balances[GDCAcc04] = GDCNumber4;
122       balances[GDCAcc05] = GDCNumber5;
123 
124     }
125 }