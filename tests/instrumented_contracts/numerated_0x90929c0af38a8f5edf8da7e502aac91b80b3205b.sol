1 pragma solidity ^0.4.25;
2 
3 
4 
5 library SafeMath {
6  
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8    
9     if (a == 0) {
10       return 0;
11     }
12 
13     uint256 c = a * b;
14     require(c / a == b);
15 
16     return c;
17   }
18   
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     require(b > 0);
21     uint256 c = a / b;
22     
23     return c;
24   }
25  
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     require(b <= a);
28     uint256 c = a - b;
29 
30     return c;
31   }
32 
33   
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     require(c >= a);
37 
38     return c;
39   }
40   
41   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b != 0);
43     return a % b;
44   }
45 }
46 
47 contract APCT {
48     mapping(address => uint256) public balances;
49     mapping(address => mapping (address => uint256)) public allowed;
50     using SafeMath for uint256;
51     address public owner;
52     string public name;
53     string public symbol;
54     uint8 public decimals;
55     uint256 public totalSupply;
56 
57     uint256 private constant MAX_UINT256 = 2**256 -1 ;
58 
59     event Transfer(address indexed from, address indexed to, uint tokens);
60     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
61     
62     bool lock = false;
63 
64     constructor(
65         uint256 _initialAmount,
66         string _tokenName,
67         uint8 _decimalUnits,
68         string _tokenSymbol
69     ) public {
70         owner = msg.sender;
71         balances[msg.sender] = _initialAmount;
72         totalSupply = _initialAmount;
73         name = _tokenName;
74         decimals = _decimalUnits;
75         symbol = _tokenSymbol;
76         
77     }
78 	
79 	modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     modifier isLock {
85         require(!lock);
86         _;
87     }
88     
89     function setLock(bool _lock) onlyOwner public{
90         lock = _lock;
91     }
92 
93     function transferOwnership(address newOwner) onlyOwner public {
94         if (newOwner != address(0)) {
95             owner = newOwner;
96         }
97     }
98 
99     function transfer(
100         address _to,
101         uint256 _value
102     ) public returns (bool) {
103         require(balances[msg.sender] >= _value);
104         require(msg.sender == _to || balances[_to] <= MAX_UINT256 - _value);
105         balances[msg.sender] -= _value;
106         balances[_to] += _value;
107         emit Transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     function transferFrom(
112         address _from,
113         address _to,
114         uint256 _value
115     ) public returns (bool) {
116         uint256 allowance = allowed[_from][msg.sender];
117         require(balances[_from] >= _value);
118         require(_from == _to || balances[_to] <= MAX_UINT256 -_value);
119         require(allowance >= _value);
120         balances[_from] -= _value;
121         balances[_to] += _value;
122         if (allowance < MAX_UINT256) {
123             allowed[_from][msg.sender] -= _value;
124         }
125         emit Transfer(_from, _to, _value);
126         return true;
127     }
128 
129     function balanceOf(
130         address _owner
131     ) public view returns (uint256) {
132         return balances[_owner];
133     }
134 
135     function approve(
136         address _spender,
137         uint256 _value
138     ) public returns (bool) {
139         allowed[msg.sender][_spender] = _value;
140         emit Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     function allowance(
145         address _owner,
146         address _spender
147     ) public view returns (uint256) {
148         return allowed[_owner][_spender];
149     }
150 }