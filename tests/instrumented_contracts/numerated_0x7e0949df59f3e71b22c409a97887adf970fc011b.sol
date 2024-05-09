1 pragma solidity ^0.4.13;
2 
3 contract SafeMath {
4   function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
5    uint256 z = x + y;
6    assert((z >= x) && (z >= y));
7    return z;
8   }
9 
10 
11 
12 
13   function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
14    assert(x >= y);
15    uint256 z = x - y;
16    return z;
17   }
18 
19 
20 
21 
22   function safeMult(uint256 x, uint256 y) internal returns(uint256) {
23    uint256 z = x * y;
24    assert((x == 0)||(z/x == y));
25    return z;
26   }
27 }
28 
29 contract Token {
30   uint256 public totalSupply;
31   function balanceOf(address _owner) constant returns (uint256 balance);
32   function transfer(address _to, uint256 _value) returns (bool success);
33   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34   function approve(address _spender, uint256 _value) returns (bool success);
35   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
36   event Transfer(address indexed _from, address indexed _to, uint256 _value);
37   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 /* ERC 20 token */
41 contract StandardToken is Token {
42 
43   function transfer(address _to, uint256 _value) returns (bool success) {
44    if (balances[msg.sender] >= _value && _value > 0) {
45     balances[msg.sender] -= _value;
46     balances[_to] += _value;
47     Transfer(msg.sender, _to, _value);
48     return true;
49    } else {
50     return false;
51    }
52   }
53 
54   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
55    if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
56     balances[_to] += _value;
57     balances[_from] -= _value;
58     allowed[_from][msg.sender] -= _value;
59     Transfer(_from, _to, _value);
60     return true;
61    } else {
62     return false;
63    }
64   }
65 
66   function balanceOf(address _owner) constant returns (uint256 balance) {
67     return balances[_owner];
68   }
69 
70   function approve(address _spender, uint256 _value) returns (bool success) {
71     allowed[msg.sender][_spender] = _value;
72     Approval(msg.sender, _spender, _value);
73     return true;
74   }
75 
76   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
77    return allowed[_owner][_spender];
78   }
79 
80   mapping (address => uint256) balances;
81   mapping (address => mapping (address => uint256)) allowed;
82 }
83 
84 
85 contract NBAT001 is StandardToken, SafeMath {
86 
87   string public constant name = "NBA002";
88   string public constant symbol = "NBA002";
89   uint256 public constant decimals = 18;
90   string public version = "1.0";
91 
92   address public GDCAcc01;
93   address public GDCAcc02;
94   address public GDCAcc03;
95   address public GDCAcc04;
96   address public GDCAcc05;
97 
98   uint256 public constant factorial = 6;
99   uint256 public constant GDCNumber1 = 200 * (10**factorial) * 10**decimals; //GDCAcc1代币数量
100   uint256 public constant GDCNumber2 = 200 * (10**factorial) * 10**decimals; //GDCAcc2代币数量
101   uint256 public constant GDCNumber3 = 200 * (10**factorial) * 10**decimals; //GDCAcc3代币数量
102   uint256 public constant GDCNumber4 = 200 * (10**factorial) * 10**decimals; //GDCAcc4代币数量
103   uint256 public constant GDCNumber5 = 200 * (10**factorial) * 10**decimals; //GDCAcc5代币数量
104 
105   // constructor
106 
107   function NBAT001(
108    address _GDCAcc01,
109    address _GDCAcc02,
110    address _GDCAcc03,
111    address _GDCAcc04,
112    address _GDCAcc05
113   )
114   {
115    GDCAcc01 = _GDCAcc01;
116    GDCAcc02 = _GDCAcc02;
117    GDCAcc03 = _GDCAcc03;
118    GDCAcc04 = _GDCAcc04;
119    GDCAcc05 = _GDCAcc05;
120 
121 
122 
123 
124    balances[GDCAcc01] = GDCNumber1;
125    balances[GDCAcc02] = GDCNumber2;
126    balances[GDCAcc03] = GDCNumber3;
127    balances[GDCAcc04] = GDCNumber4;
128    balances[GDCAcc05] = GDCNumber5;
129 
130   }
131 }