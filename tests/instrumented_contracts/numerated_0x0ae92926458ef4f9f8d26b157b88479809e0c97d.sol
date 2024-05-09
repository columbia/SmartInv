1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
8     // benefit is lost if 'b' is also tested.
9     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
10     if (a == 0) {
11       return 0;
12     }
13 
14     uint256 c = a * b;
15     require(c / a == b);
16 
17     return c;
18   }  
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     require(b > 0); // Solidity only automatically asserts when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23 
24     return c;
25   } 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     require(b <= a);
28     uint256 c = a - b;
29 
30     return c;
31   }  
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     require(c >= a);
35 
36     return c;
37   }  
38   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39     require(b != 0);
40     return a % b;
41   }
42 }
43 
44 contract Gocc {
45     mapping(address => uint256) public balances;
46     mapping(address => mapping (address => uint256)) public allowed;
47     using SafeMath for uint256;
48     address public owner;
49     string public name;
50     string public symbol;
51     uint8 public decimals;
52     uint256 public totalSupply;
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
95 
96     function transfer(
97         address _to,
98         uint256 _value
99     ) public returns (bool) {
100         require(balances[msg.sender] >= _value);
101         require(msg.sender == _to || balances[_to] <= MAX_UINT256 - _value);
102         balances[msg.sender] -= _value;
103         balances[_to] += _value;
104         emit Transfer(msg.sender, _to, _value);
105         return true;
106     }
107 
108     function transferFrom(
109         address _from,
110         address _to,
111         uint256 _value
112     ) public returns (bool) {
113         uint256 allowance = allowed[_from][msg.sender];
114         require(balances[_from] >= _value);
115         require(_from == _to || balances[_to] <= MAX_UINT256 -_value);
116         require(allowance >= _value);
117         balances[_from] -= _value;
118         balances[_to] += _value;
119         if (allowance < MAX_UINT256) {
120             allowed[_from][msg.sender] -= _value;
121         }
122         emit Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     function balanceOf(
127         address _owner
128     ) public view returns (uint256) {
129         return balances[_owner];
130     }
131 
132     function approve(
133         address _spender,
134         uint256 _value
135     ) public returns (bool) {
136         allowed[msg.sender][_spender] = _value;
137         emit Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     function allowance(
142         address _owner,
143         address _spender
144     ) public view returns (uint256) {
145         return allowed[_owner][_spender];
146     }
147 }