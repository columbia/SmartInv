1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6 		if (a == 0) {
7       		return 0;
8     	}
9 
10     	c = a * b;
11     	assert(c / a == b);
12     	return c;
13   	}
14 
15 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     	return a / b;
17 	}
18 
19 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     	assert(b <= a);
21     	return a - b;
22 	}
23 
24 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     	c = a + b;
26     	assert(c >= a);
27     	return c;
28 	}
29 }
30 
31 contract ERC20Basic {
32 	function totalSupply() public view returns (uint256);
33 	function balanceOf(address who) public view returns (uint256);
34 	function transfer(address to, uint256 value) public returns (bool);
35 	event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39 	function allowance(address owner, address spender) public view returns (uint256);
40 	function transferFrom(address from, address to, uint256 value) public returns (bool);
41 	function approve(address spender, uint256 value) public returns (bool);
42 	event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract BasicToken is ERC20Basic {
46 	using SafeMath for uint256;
47 
48 	mapping(address => uint256) balances;
49 
50 	uint256 totalSupply_;
51 
52 	function totalSupply() public view returns (uint256) {
53     	return totalSupply_;
54   	}
55 
56   	function transfer(address _to, uint256 _value) public returns (bool) {
57     	require(_to != address(0));
58     	require(_value <= balances[msg.sender]);
59 
60     	balances[msg.sender] = balances[msg.sender].sub(_value);
61     	balances[_to] = balances[_to].add(_value);
62     	emit Transfer(msg.sender, _to, _value);
63     	return true;
64 	}
65 
66     function balanceOf(address _owner) public view returns (uint256) {
67 		return balances[_owner];
68 	}
69 	
70 }
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74 	mapping (address => mapping (address => uint256)) internal allowed;
75 
76 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
77 		require(_to != address(0));
78 		require(_value <= balances[_from]);
79 		require(_value <= allowed[_from][msg.sender]);
80 
81 		balances[_from] = balances[_from].sub(_value);
82 		balances[_to] = balances[_to].add(_value);
83 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
84 		emit Transfer(_from, _to, _value);
85 		return true;
86 	}
87 
88   	function approve(address _spender, uint256 _value) public returns (bool) {
89     	allowed[msg.sender][_spender] = _value;
90     	emit Approval(msg.sender, _spender, _value);
91     	return true;
92   	}
93 
94   	function allowance(address _owner, address _spender) public view returns (uint256) {
95     	return allowed[_owner][_spender];
96 	}
97 
98 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
99     	allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
100 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
101 		return true;
102 	}
103 
104   	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105     	uint oldValue = allowed[msg.sender][_spender];
106     	if (_subtractedValue > oldValue) {
107       		allowed[msg.sender][_spender] = 0;
108     	} else {
109       		allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110     	}
111     	emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112     	return true;
113   	}
114 }
115 
116 contract ZioncoinToken is StandardToken {
117 	
118 	string public name;
119 	string public symbol; 
120 	uint8 public decimals; 
121 
122   	constructor (string _name, string _symbol, uint8 _decimals, uint256 _total) public {
123 		name = _name;
124 		symbol = _symbol;
125 		decimals = _decimals;
126 		totalSupply_ = _total.mul(10 ** uint256(_decimals));
127 	
128     	balances[msg.sender] = totalSupply_;
129 	
130     	emit Transfer(address(0), msg.sender, totalSupply_);
131   	}
132 	
133 }