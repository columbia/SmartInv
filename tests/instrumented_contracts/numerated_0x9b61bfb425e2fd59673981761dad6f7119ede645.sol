1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 contract MithrilToken {
69     mapping(address => uint256) public balances;
70     mapping(address => mapping (address => uint256)) public allowed;
71     using SafeMath for uint256;
72     address public owner;
73     string public name;
74     string public symbol;
75     uint8 public decimals;
76     uint256 public totalSupply;
77 
78     uint256 private constant MAX_UINT256 = 2**256 -1 ;
79 
80     event Transfer(address indexed from, address indexed to, uint tokens);
81     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
82     
83     bool lock = false;
84 
85     constructor(
86         uint256 _initialAmount,
87         string _tokenName,
88         uint8 _decimalUnits,
89         string _tokenSymbol
90     ) public {
91         owner = msg.sender;
92         balances[msg.sender] = _initialAmount;
93         totalSupply = _initialAmount;
94         name = _tokenName;
95         decimals = _decimalUnits;
96         symbol = _tokenSymbol;
97         
98     }
99 	
100 	
101 	modifier onlyOwner {
102         require(msg.sender == owner);
103         _;
104     }
105 
106     modifier isLock {
107         require(!lock);
108         _;
109     }
110     
111     function setLock(bool _lock) onlyOwner public{
112         lock = _lock;
113     }
114 
115     function transferOwnership(address newOwner) onlyOwner public {
116         if (newOwner != address(0)) {
117             owner = newOwner;
118         }
119     }
120 	
121 	
122 
123     function transfer(
124         address _to,
125         uint256 _value
126     ) public returns (bool) {
127         require(balances[msg.sender] >= _value);
128         require(msg.sender == _to || balances[_to] <= MAX_UINT256 - _value);
129         balances[msg.sender] -= _value;
130         balances[_to] += _value;
131         emit Transfer(msg.sender, _to, _value);
132         return true;
133     }
134 
135     function transferFrom(
136         address _from,
137         address _to,
138         uint256 _value
139     ) public returns (bool) {
140         uint256 allowance = allowed[_from][msg.sender];
141         require(balances[_from] >= _value);
142         require(_from == _to || balances[_to] <= MAX_UINT256 -_value);
143         require(allowance >= _value);
144         balances[_from] -= _value;
145         balances[_to] += _value;
146         if (allowance < MAX_UINT256) {
147             allowed[_from][msg.sender] -= _value;
148         }
149         emit Transfer(_from, _to, _value);
150         return true;
151     }
152 
153     function balanceOf(
154         address _owner
155     ) public view returns (uint256) {
156         return balances[_owner];
157     }
158 
159     function approve(
160         address _spender,
161         uint256 _value
162     ) public returns (bool) {
163         allowed[msg.sender][_spender] = _value;
164         emit Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168     function allowance(
169         address _owner,
170         address _spender
171     ) public view returns (uint256) {
172         return allowed[_owner][_spender];
173     }
174 }