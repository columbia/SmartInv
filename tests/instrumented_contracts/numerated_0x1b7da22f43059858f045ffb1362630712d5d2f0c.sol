1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
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
19   
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     require(b > 0);
22     uint256 c = a / b;
23     
24     return c;
25   }
26 
27  
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     require(b <= a);
30     uint256 c = a - b;
31 
32     return c;
33   }
34 
35   
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     require(c >= a);
39 
40     return c;
41   }
42 
43   
44   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45     require(b != 0);
46     return a % b;
47   }
48 }
49 
50 
51 contract VOTOToken {
52     mapping(address => uint256) public balances;
53     mapping(address => mapping (address => uint256)) public allowed;
54     using SafeMath for uint256;
55     address public owner;
56     string public name;
57     string public symbol;
58     uint8 public decimals;
59     uint256 public totalSupply;
60 
61     uint256 private constant MAX_UINT256 = 2**256 -1 ;
62 
63     event Transfer(address indexed from, address indexed to, uint tokens);
64     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
65     
66     mapping (address => bool) public frozenAccount;
67     event FrozenFunds(address target, bool frozen);
68    
69     bool lock = false;
70 
71     constructor(
72         uint256 _initialAmount,
73         string _tokenName,
74         uint8 _decimalUnits,
75         string _tokenSymbol
76     ) public {
77         owner = msg.sender;
78         balances[msg.sender] = _initialAmount;
79         totalSupply = _initialAmount;
80         name = _tokenName;
81         decimals = _decimalUnits;
82         symbol = _tokenSymbol;
83         
84     }
85 	
86 	
87 	modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     modifier isLock {
93         require(!lock);
94         _;
95     }
96     
97     function setLock(bool _lock) onlyOwner public{
98         lock = _lock;
99     }
100 
101     function transferOwnership(address newOwner) onlyOwner public {
102         if (newOwner != address(0)) {
103             owner = newOwner;
104         }
105     }
106 	
107 	
108 
109     function transfer(
110         address _to,
111         uint256 _value
112     ) public returns (bool) {
113         require(balances[msg.sender] >= _value);
114         require(msg.sender == _to || balances[_to] <= MAX_UINT256 - _value);
115         balances[msg.sender] -= _value;
116         balances[_to] += _value;
117         emit Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     function transferFrom(
122         address _from,
123         address _to,
124         uint256 _value
125     ) public returns (bool) {
126         uint256 allowance = allowed[_from][msg.sender];
127         require(balances[_from] >= _value);
128         require(_from == _to || balances[_to] <= MAX_UINT256 -_value);
129         require(allowance >= _value);
130         balances[_from] -= _value;
131         balances[_to] += _value;
132         if (allowance < MAX_UINT256) {
133             allowed[_from][msg.sender] -= _value;
134         }
135         emit Transfer(_from, _to, _value);
136         return true;
137     }
138 	
139     function freezeAccount(address target, bool freeze) onlyOwner public {
140         frozenAccount[target] = freeze;
141         emit FrozenFunds(target, freeze);
142     }	
143 	
144     function balanceOf(
145         address _owner
146     ) public view returns (uint256) {
147         return balances[_owner];
148     }
149 
150     function approve(
151         address _spender,
152         uint256 _value
153     ) public returns (bool) {
154         allowed[msg.sender][_spender] = _value;
155         emit Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     function allowance(
160         address _owner,
161         address _spender
162     ) public view returns (uint256) {
163         return allowed[_owner][_spender];
164     }
165 }