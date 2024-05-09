1 pragma solidity ^0.4.21;
2 /*YFIG is the abbreviation of YFIGroup. 
3 YFIG's success is due to the core technology from YFI. 
4 The development core team comes from the United States, China, and South Korea.
5 The YFI technology is independently forked and upgraded to a cluster interactive intelligent aggregator, 
6 which aggregates multiple platforms Agreement to realize the interaction of assets on different decentralized liquidity platforms.*/
7 contract  IYFIG {
8    
9     uint256 public totalSupply;
10 
11  
12     function balanceOf(address _owner) public view returns (uint256 balance);
13 
14 
15     function transfer(address _to, uint256 _value) public returns (bool success);
16 
17 
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19 
20 
21     function approve(address _spender, uint256 _value) public returns (bool success);
22 
23 
24     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
25 
26 
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 }
30 
31 library SafeMath {
32 
33   
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35 
36     if (a == 0) {
37       return 0;
38     }
39 
40     uint256 c = a * b;
41     require(c / a == b);
42 
43     return c;
44   }
45 
46 
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     require(b > 0); 
49     uint256 c = a / b;
50 
51 
52     return c;
53   }
54 
55 
56 
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b <= a);
59     uint256 c = a - b;
60 
61     return c;
62   }
63 
64 
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66     uint256 c = a + b;
67     require(c >= a);
68 
69     return c;
70   }
71 
72 
73   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b != 0);
75     return a % b;
76   }
77 }
78 
79 
80 contract YFIG is IYFIG {
81     using SafeMath for uint256;
82 
83     mapping (address => uint256) public balances;
84     mapping (address => mapping (address => uint256)) public allowed;
85 
86     string public name;                   
87     uint8 public decimals;                
88     string public symbol;                 
89 
90     function YFIG(
91         uint256 _initialAmount,
92         string _tokenName,
93         uint8 _decimalUnits,
94         string _tokenSymbol
95     ) public {
96         balances[msg.sender] = _initialAmount;               
97         totalSupply = _initialAmount;                       
98         name = _tokenName;                                  
99         decimals = _decimalUnits;                            
100         symbol = _tokenSymbol;                             
101     }
102 
103     function transfer(address _to, uint256 _value) public returns (bool success) {
104         require(_to != address(0));
105         require(balances[msg.sender] >= _value);
106       
107         balances[msg.sender] = balances[msg.sender].sub(_value);
108   
109         balances[_to] = balances[_to].add(_value);
110         emit Transfer(msg.sender, _to, _value); 
111         return true;
112     }
113 
114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
115         uint256 allowance = allowed[_from][msg.sender];
116         require(balances[_from] >= _value && allowance >= _value);
117         require(_to != address(0));
118       
119         balances[_to] = balances[_to].add(_value);
120  
121         balances[_from] = balances[_from].sub(_value);
122 
123         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124  
125         emit Transfer(_from, _to, _value); 
126         return true;
127     }
128 
129     function balanceOf(address _owner) public view returns (uint256 balance) {
130         return balances[_owner];
131     }
132 
133     function approve(address _spender, uint256 _value) public returns (bool success) {
134         require(_spender != address(0));
135         allowed[msg.sender][_spender] = _value;
136         emit Approval(msg.sender, _spender, _value); 
137         return true;
138     }
139 
140     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
141         require(_spender != address(0));
142         return allowed[_owner][_spender];
143     }
144 }