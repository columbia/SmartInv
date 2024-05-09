1 pragma solidity ^ 0.4.19;
2 
3 library SafeMath {
4 	function sub(uint256 a, uint256 b) internal pure returns(uint256) {
5 		assert(b <= a);
6 		return a - b;
7 	}
8 
9 	function add(uint256 a, uint256 b) internal pure returns(uint256) {
10 		uint256 c = a + b;
11 		assert(c >= a);
12 		return c;
13 	}
14 }
15 
16 contract ERC20 {
17 	function balanceOf(address _owner) constant public returns(uint256 balance);
18 	function transfer(address _to, uint256 _value) public returns(bool success);
19 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
20 	function approve(address _spender, uint256 _value) public returns(bool success);
21 	function allowance(address _owner, address _spender) constant public returns(uint256 remaining);
22 
23 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
24 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 	event Burn(address indexed from, uint256 value);
26 }
27 
28 contract StandardToken is ERC20 {
29 	using SafeMath for uint256;
30 
31 	function transfer(address _to, uint256 _value) public returns(bool success) {
32 		require(_to != address(0));
33 		require(_value <= balances[msg.sender]);
34 		balances[msg.sender] = balances[msg.sender].sub(_value);
35 		balances[_to] = balances[_to].add(_value);
36 		Transfer(msg.sender, _to, _value);
37 		return true;
38 	}
39 
40 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
41 		require(_to != address(0));
42 		require(_value <= balances[_from]);
43 		require(_value <= allowed[_from][msg.sender]);
44 
45 		balances[_from] = balances[_from].sub(_value);
46 		balances[_to] = balances[_to].add(_value);
47 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
48 		Transfer(_from, _to, _value);
49 		return true;
50 	}
51 
52 	function balanceOf(address _owner) constant public returns(uint256 balance) {
53 		return balances[_owner];
54 	}
55 
56 	function approve(address _spender, uint256 _value) public returns(bool success) {
57 		allowed[msg.sender][_spender] = _value;
58 		Approval(msg.sender, _spender, _value);
59 		return true;
60 	}
61 
62 	function allowance(address _owner, address _spender) constant public returns(uint256 remaining) {
63 		return allowed[_owner][_spender];
64 	}
65 
66 	function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
67 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
68 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
69 		return true;
70 	}
71 
72 	function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
73 		uint oldValue = allowed[msg.sender][_spender];
74 		if (_subtractedValue > oldValue) {
75 			allowed[msg.sender][_spender] = 0;
76 		} else {
77 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
78 		}
79 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
80 		return true;
81 	}
82 	
83 	function burn(uint256 _value) public returns (bool success) {
84         require(balances[msg.sender] >= _value);
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         Burn(msg.sender, _value);
87         return true;
88     }
89 
90     function burnFrom(address _from, uint256 _value) public returns (bool success) {
91         require(balances[_from] >= _value);
92         require(_value <= allowed[_from][msg.sender]);
93         balances[_from] = balances[_from].sub(_value);
94         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95         Burn(_from, _value);
96         return true;
97     }
98 
99 	mapping(address => uint256) balances;
100 	mapping(address => mapping(address => uint256)) allowed;
101 }
102 
103 contract BCT is StandardToken {
104 
105 	string public name = 'BIShiCaiJing Token';
106 	string public symbol = 'BCT';
107 	uint8 public decimals = 18;
108 	uint256 public totalSupply = 1000000000 * 10 ** uint256(decimals);
109 
110 	function BCT() public {
111 		balances[msg.sender] = totalSupply;
112 	}
113 
114 	function() public {
115 		throw;
116 	}
117 
118 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool success) {
119 		allowed[msg.sender][_spender] = _value;
120 		Approval(msg.sender, _spender, _value);
121 		if (!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
122 			throw;
123 		}
124 		return true;
125 	}
126 }