1 pragma solidity ^ 0.4.24;
2 
3 contract VTM {
4 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
5 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
6 }
7 
8 contract BaseContract is VTM {
9 	using SafeMath
10 	for * ;
11 
12 	string public name;
13 	string public symbol;
14 	uint8 public decimals;
15 	uint256 public totalSupply;
16 	mapping(address => uint256) public balanceOf;
17 	mapping(address => mapping(address => uint256)) public allowance;
18 
19 	mapping(address => address[]) public affs;
20 	mapping(address => address) public aff;
21 
22 	function BaseContract(
23 		uint256 _totalSupply,
24 		string _name,
25 		uint8 _decimal,
26 		string _symbol
27 	) {
28 		totalSupply = _totalSupply;
29 		name = _name;
30 		symbol = _symbol;
31 		decimals = _decimal;
32 		balanceOf[msg.sender] = _totalSupply;
33 		aff[msg.sender] = msg.sender;
34 	}
35 
36 	function transfer(address _to, uint256 _value) public returns(bool success) {
37 		require(_to != 0x0, "invalid addr");
38 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
39 		balanceOf[_to] = balanceOf[_to].add(_value);
40 		emit Transfer(msg.sender, _to, _value);
41 		if(_value > 0 && aff[_to] == address(0) && msg.sender != _to) {
42 			aff[_to] = msg.sender;
43 			affs[msg.sender].push(_to);
44 		}
45 		return true;
46 	}
47 
48 	function approve(address _spender, uint256 _value) public returns(bool success) {
49 		require(_spender != 0x0, "invalid addr");
50 		require(_value > 0, "invalid value");
51 		allowance[msg.sender][_spender] = _value;
52 		return true;
53 	}
54 
55 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
56 		require(_from != 0x0, "invalid addr");
57 		require(_to != 0x0, "invalid addr");
58 		balanceOf[_from] = balanceOf[_from].sub(_value);
59 		balanceOf[_to] = balanceOf[_to].add(_value);
60 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
61 		emit Transfer(_from, _to, _value);
62 		return true;
63 	}
64 
65 	function getAff(address _addr)
66 	public
67 	view
68 	returns(address) {
69 		return aff[_addr];
70 	}
71 	
72 	function getAffLength(address _addr)
73 	public
74 	view
75 	returns(uint256) {
76 		return affs[_addr].length;
77 	}
78 
79 }
80 
81 library SafeMath {
82 
83 	function sub(uint256 a, uint256 b)
84 	internal
85 	pure
86 	returns(uint256 c) {
87 		require(b <= a, "sub failed");
88 		c = a - b;
89 		require(c <= a, "sub failed");
90 		return c;
91 	}
92 
93 	function add(uint256 a, uint256 b)
94 	internal
95 	pure
96 	returns(uint256 c) {
97 		c = a + b;
98 		require(c >= a, "add failed");
99 		return c;
100 	}
101 
102 }