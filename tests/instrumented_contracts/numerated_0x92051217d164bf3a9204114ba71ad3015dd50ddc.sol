1 pragma solidity ^0.4.25;
2 
3 
4 library SafeMath {
5  
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     require(c / a == b);
12 
13     return c;
14   }
15   
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     require(b > 0);
18     uint256 c = a / b;
19     
20     return c;
21   }
22  
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     require(b <= a);
25     uint256 c = a - b;
26 
27     return c;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     require(c >= a);
33 
34     return c;
35   }
36   
37   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b != 0);
39     return a % b;
40   }
41 }
42 
43 contract SYCTOKEN {
44     mapping(address => uint256) public balances;
45     mapping(address => mapping (address => uint256)) public allowed;
46     using SafeMath for uint256;
47     address public owner;
48     string public name;
49     string public symbol;
50     uint8 public decimals;
51     uint256 public totalSupply;
52 
53     uint256 private constant MAX_UINT256 = 2**256 -1 ;
54 
55     event Transfer(address indexed from, address indexed to, uint tokens);
56     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
57     
58     bool lock = false;
59 
60     constructor(
61         uint256 _initialAmount,
62         string _tokenName,
63         uint8 _decimalUnits,
64         string _tokenSymbol
65     ) public {
66         owner = msg.sender;
67         balances[msg.sender] = _initialAmount;
68         totalSupply = _initialAmount;
69         name = _tokenName;
70         decimals = _decimalUnits;
71         symbol = _tokenSymbol;
72         
73     }
74 	
75 	modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     modifier isLock {
81         require(!lock);
82         _;
83     }
84     
85     function setLock(bool _lock) onlyOwner public{
86         lock = _lock;
87     }
88 
89     function transferOwnership(address newOwner) onlyOwner public {
90         if (newOwner != address(0)) {
91             owner = newOwner;
92         }
93     }
94 
95     function transfer(
96         address _to,
97         uint256 _value
98     ) public returns (bool) {
99         require(balances[msg.sender] >= _value);
100         require(msg.sender == _to || balances[_to] <= MAX_UINT256 - _value);
101         balances[msg.sender] -= _value;
102         balances[_to] += _value;
103         emit Transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     function transferFrom(
108         address _from,
109         address _to,
110         uint256 _value
111     ) public returns (bool) {
112         uint256 allowance = allowed[_from][msg.sender];
113         require(balances[_from] >= _value);
114         require(_from == _to || balances[_to] <= MAX_UINT256 -_value);
115         require(allowance >= _value);
116         balances[_from] -= _value;
117         balances[_to] += _value;
118         if (allowance < MAX_UINT256) {
119             allowed[_from][msg.sender] -= _value;
120         }
121         emit Transfer(_from, _to, _value);
122         return true;
123     }
124 
125     function balanceOf(
126         address _owner
127     ) public view returns (uint256) {
128         return balances[_owner];
129     }
130 
131     function approve(
132         address _spender,
133         uint256 _value
134     ) public returns (bool) {
135         allowed[msg.sender][_spender] = _value;
136         emit Approval(msg.sender, _spender, _value);
137         return true;
138     }
139 
140     function allowance(
141         address _owner,
142         address _spender
143     ) public view returns (uint256) {
144         return allowed[_owner][_spender];
145     }
146 }