1 pragma solidity ^0.4.21;
2 /*
3 The full name of YFIP is YFIPOOL, which is a token produced by YFIM liquid mining. The total amount of YFIP is 6,000,000 and 60,000 pieces are produced every day,
4 and it is mined in 100 days.YFIP is the YFIM liquid mining token. Add liquidity to the ETH/YFIM trading pair in Uniswap, you can participate in mining and get YFIP token rewards, 
5 which are distributed according to the proportion of injection into the liquidity pool.
6 */
7 
8 contract  IYFIP {
9    
10     uint256 public totalSupply;
11 
12  
13     function balanceOf(address _owner) public view returns (uint256 balance);
14 
15 
16     function transfer(address _to, uint256 _value) public returns (bool success);
17 
18 
19     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
20 
21 
22     function approve(address _spender, uint256 _value) public returns (bool success);
23 
24 
25     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
26 
27 
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 }
31 
32 library SafeMath {
33 
34   
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36 
37     if (a == 0) {
38       return 0;
39     }
40 
41     uint256 c = a * b;
42     require(c / a == b);
43 
44     return c;
45   }
46 
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b > 0); 
50     uint256 c = a / b;
51 
52 
53     return c;
54   }
55 
56 
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b <= a);
60     uint256 c = a - b;
61 
62     return c;
63   }
64 
65 
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     require(c >= a);
69 
70     return c;
71   }
72 
73 
74   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b != 0);
76     return a % b;
77   }
78 }
79 
80 
81 contract YFIP is IYFIP {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) public balances;
85     mapping (address => mapping (address => uint256)) public allowed;
86 
87     string public name;                   
88     uint8 public decimals;                
89     string public symbol;                 
90 
91     function YFIP(
92         uint256 _initialAmount,
93         string _tokenName,
94         uint8 _decimalUnits,
95         string _tokenSymbol
96     ) public {
97         balances[msg.sender] = _initialAmount;               
98         totalSupply = _initialAmount;                       
99         name = _tokenName;                                  
100         decimals = _decimalUnits;                            
101         symbol = _tokenSymbol;                             
102     }
103 
104     function transfer(address _to, uint256 _value) public returns (bool success) {
105         require(_to != address(0));
106         require(balances[msg.sender] >= _value);
107       
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109   
110         balances[_to] = balances[_to].add(_value);
111         emit Transfer(msg.sender, _to, _value); 
112         return true;
113     }
114 
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
116         uint256 allowance = allowed[_from][msg.sender];
117         require(balances[_from] >= _value && allowance >= _value);
118         require(_to != address(0));
119       
120         balances[_to] = balances[_to].add(_value);
121  
122         balances[_from] = balances[_from].sub(_value);
123 
124         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125  
126         emit Transfer(_from, _to, _value); 
127         return true;
128     }
129 
130     function balanceOf(address _owner) public view returns (uint256 balance) {
131         return balances[_owner];
132     }
133 
134     function approve(address _spender, uint256 _value) public returns (bool success) {
135         require(_spender != address(0));
136         allowed[msg.sender][_spender] = _value;
137         emit Approval(msg.sender, _spender, _value); 
138         return true;
139     }
140 
141     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
142         require(_spender != address(0));
143         return allowed[_owner][_spender];
144     }
145 }