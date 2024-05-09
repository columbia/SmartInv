1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6  
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12       return 0;
13     }
14 
15     uint256 c = a * b;
16     require(c / a == b);
17 
18     return c;
19   }
20 
21   
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     require(b > 0); // Solidity only automatically asserts when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26 
27     return c;
28   }
29 
30  
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b <= a);
33     uint256 c = a - b;
34 
35     return c;
36   }
37 
38   
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     require(c >= a);
42 
43     return c;
44   }
45 
46   
47   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
48     require(b != 0);
49     return a % b;
50   }
51 }
52 
53 
54 contract Htcoin {
55     mapping(address => uint256) public balances;
56     mapping(address => mapping (address => uint256)) public allowed;
57     using SafeMath for uint256;
58     address public owner;
59     string public name;
60     string public symbol;
61     uint8 public decimals;
62     uint256 public totalSupply;
63 
64     uint256 private constant MAX_UINT256 = 2**256 -1 ;
65 
66     event Transfer(address indexed from, address indexed to, uint tokens);
67     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
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
139     function balanceOf(
140         address _owner
141     ) public view returns (uint256) {
142         return balances[_owner];
143     }
144 
145     function approve(
146         address _spender,
147         uint256 _value
148     ) public returns (bool) {
149         allowed[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     function allowance(
155         address _owner,
156         address _spender
157     ) public view returns (uint256) {
158         return allowed[_owner][_spender];
159     }
160 }