1 pragma solidity ^0.4.11;
2 
3 
4 interface IERC20 {
5   function totalSupply() constant returns (uint256 totalSupply);
6   function balanceOf(address _owner) constant returns (uint256 balance);
7   function transfer(address _to, uint256 _value) returns (bool success);
8   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
9   function approve(address _spender, uint256 _value) returns (bool success);
10   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
11   event Transfer(address indexed _from, address indexed _to, uint256 _value);
12   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 
14 }
15 
16 
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, throws on overflow.
21   */
22   function mul(uint256 a, uint256 b) internal  returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 a, uint256 b) internal  returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   /**
42   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b) internal  returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 a, uint256 b) internal  returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 
60 
61 
62 
63 
64 contract CMBToken is IERC20 {
65 
66 using SafeMath for uint256;
67 uint public constant _totalSupply = 6500000000000000;
68 
69 string public constant symbol = "CMBT";
70 string public constant name = "CMB Token";
71 uint8 public constant decimals = 8;
72 
73 
74 mapping (address => uint256) balances;
75 mapping(address =>  mapping(address => uint256)) allowed;
76 
77  function CMBToken() {
78 	balances[msg.sender] = _totalSupply;
79 
80 }
81 
82 function totalSupply() constant returns (uint256 totalSupply) {
83 	return _totalSupply;
84 }
85 
86 function balanceOf(address _owner) constant returns (uint256 balance) {
87 	return balances[_owner];
88 }
89 
90 function transfer(address _to, uint256 _value) returns (bool success) {
91 	require(
92 		balances[msg.sender] >= _value
93 		&& _value > 0
94 	);
95 	balances[msg.sender] = balances[msg.sender].sub(_value);
96 	balances [_to] = balances[_to].add(_value);
97 	Transfer(msg.sender, _to, _value);
98 	return true;
99 
100 }
101 
102 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) { 
103 	require(
104 	allowed[_from][msg.sender] >= _value
105 	&& balances[_from] >= _value
106 	&& _value > 0
107 	);
108 	balances[_from] = balances[msg.sender].sub(_value);
109 	balances[_to] = balances[_to].add(_value);
110 	allowed[_from][msg.sender] = balances[msg.sender].sub(_value);
111 	Transfer(_from, _to, _value);
112 	return true;
113 
114 }
115 
116 function approve(address _spender, uint256 _value) returns (bool success) {
117 	allowed[msg.sender][_spender] = _value;
118 	Approval(msg.sender, _spender, _value);
119 	return true;	
120 }
121 
122 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123 	return allowed[_owner][_spender];
124 
125 }
126 
127 event Transfer(address indexed _from, address indexed _to, uint256 _value);
128 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
129 
130 }