1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, reverts on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (a == 0) {
42       return 0;
43     }
44 
45     uint256 c = a * b;
46     require(c / a == b);
47 
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     require(b > 0); // Solidity only automatically asserts when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     require(b <= a);
67     uint256 c = a - b;
68 
69     return c;
70   }
71 
72   /**
73   * @dev Adds two numbers, reverts on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     require(c >= a);
78 
79     return c;
80   }
81 
82   /**
83   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
84   * reverts when dividing by zero.
85   */
86   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87     require(b != 0);
88     return a % b;
89   }
90 }
91 
92 contract Sophia_Token is IERC20 {
93     
94     using SafeMath for uint256;
95     
96     address owner;
97     
98     uint public constant _totalSupply = 250000000000000000000000000;
99     
100     string public constant name = "OpenCryptoTrust Token";
101     string public constant symbol = "OCTb";
102     uint8 public constant decimals = 18;
103     
104     mapping (address => uint256) balances;
105     mapping (address => mapping (address => uint256)) allowed;
106     
107     constructor () {
108         
109         owner = msg.sender;
110         balances[msg.sender] = _totalSupply;
111     }
112     
113     function totalSupply () constant returns (uint256 totalSupply) {
114         return _totalSupply;
115     }
116  
117     function balanceOf (address _owner) constant returns (uint256 balance) {
118         return balances[_owner];
119     }   
120 
121     function transfer (address _to, uint256 _value) returns (bool success) {
122         require(
123             balances[msg.sender] >= _value
124             && _value > 0
125         );
126         
127         balances[msg.sender] = balances[msg.sender].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         emit Transfer(msg.sender, _to, _value);
130         return true;
131     }
132     
133     function transferFrom (address _from, address _to, uint256 _value) returns (bool success) {
134         require(
135             allowed[_from][msg.sender] >= _value
136             && balances[_from] >= _value
137             && _value > 0
138         );
139     
140         balances[_from] = balances[_from].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143         emit Transfer(_from, _to, _value);
144         return true;
145     }
146     
147     function approve (address _spender, uint256 _value) returns (bool success) {
148         allowed[msg.sender][_spender] = _value;
149         emit Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     function allowance (address _owner, address _spender) constant returns (uint256 remaining) {
154         return allowed[_owner][_spender];
155     }
156     
157     event Transfer (address  indexed _from, address indexed _to, uint256 _value);
158     event Approval (address indexed _owner, address indexed _spender, uint256 _value);
159 }