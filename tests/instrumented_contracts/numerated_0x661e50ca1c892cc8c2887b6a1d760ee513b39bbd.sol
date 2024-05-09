1 pragma solidity ^0.4.25;
2 
3 
4 
5 library SafeMath {
6 
7  
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9    
10     if (a == 0) {
11       return 0;
12     }
13 
14     uint256 c = a * b;
15     require(c / a == b);
16 
17     return c;
18   }
19 
20   
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     require(b > 0);
23     uint256 c = a / b;
24     
25     return c;
26   }
27 
28  
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b <= a);
31     uint256 c = a - b;
32 
33     return c;
34   }
35 
36   
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     require(c >= a);
40 
41     return c;
42   }
43 
44   
45   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46     require(b != 0);
47     return a % b;
48   }
49 }
50 
51 
52 contract WanCenter {
53     mapping(address => uint256) public balances;
54     mapping(address => mapping (address => uint256)) public allowed;
55     using SafeMath for uint256;
56     address public owner;
57     string public name;
58     string public symbol;
59     uint8 public decimals;
60     uint256 public totalSupply;
61 
62     uint256 private constant MAX_UINT256 = 2**256 -1 ;
63 
64     event Transfer(address indexed from, address indexed to, uint tokens);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66     
67     bool lock = false;
68 
69     constructor(
70         uint256 _initialAmount,
71         string _tokenName,
72         uint8 _decimalUnits,
73         string _tokenSymbol
74     ) public {
75         owner = msg.sender;
76         balances[msg.sender] = _initialAmount;
77         totalSupply = _initialAmount;
78         name = _tokenName;
79         decimals = _decimalUnits;
80         symbol = _tokenSymbol;
81         
82     }
83 	
84 	
85 	modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     modifier isLock {
91         require(!lock);
92         _;
93     }
94     
95     function setLock(bool _lock) onlyOwner public{
96         lock = _lock;
97     }
98 
99     function transferOwnership(address newOwner) onlyOwner public {
100         if (newOwner != address(0)) {
101             owner = newOwner;
102         }
103     }
104 	
105 	
106 
107     function transfer(
108         address _to,
109         uint256 _value
110     ) public returns (bool) {
111         require(balances[msg.sender] >= _value);
112         require(msg.sender == _to || balances[_to] <= MAX_UINT256 - _value);
113         balances[msg.sender] -= _value;
114         balances[_to] += _value;
115         emit Transfer(msg.sender, _to, _value);
116         return true;
117     }
118 
119     function transferFrom(
120         address _from,
121         address _to,
122         uint256 _value
123     ) public returns (bool) {
124         uint256 allowance = allowed[_from][msg.sender];
125         require(balances[_from] >= _value);
126         require(_from == _to || balances[_to] <= MAX_UINT256 -_value);
127         require(allowance >= _value);
128         balances[_from] -= _value;
129         balances[_to] += _value;
130         if (allowance < MAX_UINT256) {
131             allowed[_from][msg.sender] -= _value;
132         }
133         emit Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     function balanceOf(
138         address _owner
139     ) public view returns (uint256) {
140         return balances[_owner];
141     }
142 
143     function approve(
144         address _spender,
145         uint256 _value
146     ) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         emit Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     function allowance(
153         address _owner,
154         address _spender
155     ) public view returns (uint256) {
156         return allowed[_owner][_spender];
157     }
158 }