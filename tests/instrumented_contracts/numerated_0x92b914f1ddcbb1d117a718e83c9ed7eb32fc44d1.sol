1 pragma solidity ^0.4.17;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 library SafeMath {
12 
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     
26     uint256 c = a / b;
27     
28     return c;
29   }
30 
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37 
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   uint256 totalSupply_;
52 
53   function totalSupply() public view returns (uint256) {
54     return totalSupply_;
55   }
56 
57 
58   function transfer(address _to, uint256 _value) public returns (bool) {
59     require(_to != address(0));
60     require(_value <= balances[msg.sender]);
61 
62     
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   function balanceOf(address _owner) public view returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73 }
74 
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender) public view returns (uint256);
77   function transferFrom(address from, address to, uint256 value) public returns (bool);
78   function approve(address spender, uint256 value) public returns (bool);
79   event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 
83 
84 contract StandardToken is ERC20, BasicToken {
85 
86   mapping (address => mapping (address => uint256)) internal allowed;
87 
88 
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93 
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97     Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   function approve(address _spender, uint256 _value) public returns (bool) {
102     allowed[msg.sender][_spender] = _value;
103     Approval(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   function allowance(address _owner, address _spender) public view returns (uint256) {
108     return allowed[_owner][_spender];
109   }
110 
111   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
112     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
113     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 
117   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
118     uint oldValue = allowed[msg.sender][_spender];
119     if (_subtractedValue > oldValue) {
120       allowed[msg.sender][_spender] = 0;
121     } else {
122       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
123     }
124     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 
128 }
129 
130 
131 contract EnkronosToken is StandardToken {
132 
133 	string public name = 'EnkronosToken';
134 	string public symbol = 'ENK';
135 	uint8 public decimals = 18;
136 	uint public INITIAL_SUPPLY = 500000000000000000000000000;
137 
138 	
139 	function EnkronosToken() public {
140 	  totalSupply_ = INITIAL_SUPPLY;
141 	  balances[msg.sender] = INITIAL_SUPPLY;
142 	}
143 
144 }