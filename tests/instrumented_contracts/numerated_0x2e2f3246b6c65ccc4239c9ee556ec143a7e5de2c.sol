1 pragma solidity ^0.4.21;
2 
3 contract  IYFIM {
4    
5     uint256 public totalSupply;
6 
7  
8     function balanceOf(address _owner) public view returns (uint256 balance);
9 
10 
11     function transfer(address _to, uint256 _value) public returns (bool success);
12 
13 
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
15 
16 
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 
19 
20     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
21 
22 
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 }
26 
27 library SafeMath {
28 
29   
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31 
32     if (a == 0) {
33       return 0;
34     }
35 
36     uint256 c = a * b;
37     require(c / a == b);
38 
39     return c;
40   }
41 
42 
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     require(b > 0); 
45     uint256 c = a / b;
46 
47 
48     return c;
49   }
50 
51 
52 
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     require(b <= a);
55     uint256 c = a - b;
56 
57     return c;
58   }
59 
60 
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     require(c >= a);
64 
65     return c;
66   }
67 
68 
69   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b != 0);
71     return a % b;
72   }
73 }
74 
75 
76 contract YFIM is IYFIM {
77     using SafeMath for uint256;
78 
79     mapping (address => uint256) public balances;
80     mapping (address => mapping (address => uint256)) public allowed;
81 
82     string public name;                   
83     uint8 public decimals;                
84     string public symbol;                 
85 
86     function YFIM(
87         uint256 _initialAmount,
88         string _tokenName,
89         uint8 _decimalUnits,
90         string _tokenSymbol
91     ) public {
92         balances[msg.sender] = _initialAmount;               
93         totalSupply = _initialAmount;                       
94         name = _tokenName;                                  
95         decimals = _decimalUnits;                            
96         symbol = _tokenSymbol;                             
97     }
98 
99     function transfer(address _to, uint256 _value) public returns (bool success) {
100         require(_to != address(0));
101         require(balances[msg.sender] >= _value);
102       
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104   
105         balances[_to] = balances[_to].add(_value);
106         emit Transfer(msg.sender, _to, _value); 
107         return true;
108     }
109 
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         uint256 allowance = allowed[_from][msg.sender];
112         require(balances[_from] >= _value && allowance >= _value);
113         require(_to != address(0));
114       
115         balances[_to] = balances[_to].add(_value);
116  
117         balances[_from] = balances[_from].sub(_value);
118 
119         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120  
121         emit Transfer(_from, _to, _value); 
122         return true;
123     }
124 
125     function balanceOf(address _owner) public view returns (uint256 balance) {
126         return balances[_owner];
127     }
128 
129     function approve(address _spender, uint256 _value) public returns (bool success) {
130         require(_spender != address(0));
131         allowed[msg.sender][_spender] = _value;
132         emit Approval(msg.sender, _spender, _value); 
133         return true;
134     }
135 
136     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
137         require(_spender != address(0));
138         return allowed[_owner][_spender];
139     }
140 }