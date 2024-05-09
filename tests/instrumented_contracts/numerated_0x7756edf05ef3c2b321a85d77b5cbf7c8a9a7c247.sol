1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address _who) public view returns (uint256);
6   function transfer(address _to, uint256 _value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 library SafeMath {
10   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
11     if (_a == 0) {
12       return 0;
13     }
14     c = _a * _b;
15     assert(c / _a == _b);
16     return c;
17   }
18   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
19     return _a / _b;
20   }
21   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
22     assert(_b <= _a);
23     return _a - _b;
24   }
25   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
26     c = _a + _b;
27     assert(c >= _a);
28     return c;
29   }
30 }
31 contract BasicToken is ERC20Basic {
32   using SafeMath for uint256;
33 
34   mapping(address => uint256) internal balances;
35 
36   uint256 internal totalSupply_;
37 
38   function totalSupply() public view returns (uint256) {
39     return totalSupply_;
40   }
41   function transfer(address _to, uint256 _value) public returns (bool) {
42     require(_value <= balances[msg.sender]);
43     require(_to != address(0));
44 
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     emit Transfer(msg.sender, _to, _value);
48     return true;
49   }
50   function balanceOf(address _owner) public view returns (uint256) {
51     return balances[_owner];
52   }
53 }
54 contract ERC20 is ERC20Basic {
55   function allowance(address _owner, address _spender)
56     public view returns (uint256);
57 
58   function transferFrom(address _from, address _to, uint256 _value)
59     public returns (bool);
60 
61   function approve(address _spender, uint256 _value) public returns (bool);
62   event Approval(
63     address indexed owner,
64     address indexed spender,
65     uint256 value
66   );
67 }
68 contract StandardToken is ERC20, BasicToken {
69 
70   mapping (address => mapping (address => uint256)) internal allowed;
71 
72   function transferFrom(
73     address _from,
74     address _to,
75     uint256 _value
76   )
77     public
78     returns (bool)
79   {
80     require(_value <= balances[_from]);
81     require(_value <= allowed[_from][msg.sender]);
82     require(_to != address(0));
83 
84     balances[_from] = balances[_from].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87     emit Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   function approve(address _spender, uint256 _value) public returns (bool) {
92     allowed[msg.sender][_spender] = _value;
93     emit Approval(msg.sender, _spender, _value);
94     return true;
95   }
96   function allowance(
97     address _owner,
98     address _spender
99    )
100     public
101     view
102     returns (uint256)
103   {
104     return allowed[_owner][_spender];
105   }
106   function increaseApproval(
107     address _spender,
108     uint256 _addedValue
109   )
110     public
111     returns (bool)
112   {
113     allowed[msg.sender][_spender] = (
114       allowed[msg.sender][_spender].add(_addedValue));
115     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116     return true;
117   }
118   function decreaseApproval(
119     address _spender,
120     uint256 _subtractedValue
121   )
122     public
123     returns (bool)
124   {
125     uint256 oldValue = allowed[msg.sender][_spender];
126     if (_subtractedValue >= oldValue) {
127       allowed[msg.sender][_spender] = 0;
128     } else {
129       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
130     }
131     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135 }
136 contract AQU is StandardToken {
137 	string public name = 'Aquest Token';
138 	string public symbol = 'AQU';
139 	uint8 public decimals = 18;
140 	uint public INITIAL_SUPPLY = 200000000000000000000000000;
141 	//
142 	function AQU() public {
143 	  totalSupply_ = INITIAL_SUPPLY;
144 	  balances[msg.sender] = INITIAL_SUPPLY;
145 	}
146 }