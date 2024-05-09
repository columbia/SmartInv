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
21 	mapping(address => bool) public airAddrs;
22 
23 	function BaseContract(
24 		uint256 _totalSupply,
25 		string _name,
26 		uint8 _decimal,
27 		string _symbol
28 	) {
29 		totalSupply = _totalSupply;
30 		name = _name;
31 		symbol = _symbol;
32 		decimals = _decimal;
33 		balanceOf[msg.sender] = _totalSupply;
34 		aff[msg.sender] = msg.sender;
35 		airAddrs[msg.sender] = true;
36 	}
37 
38 	function transfer(address _to, uint256 _value) public returns(bool success) {
39 		require(_to != 0x0, "invalid addr");
40 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
41 		balanceOf[_to] = balanceOf[_to].add(_value);
42 		emit Transfer(msg.sender, _to, _value);
43 		if(_value > 0 && aff[_to] == address(0) && msg.sender != _to) {
44 			aff[_to] = msg.sender;
45 			affs[msg.sender].push(_to);
46 			airAddrs[_to] = true;
47 		}
48 		return true;
49 	}
50 
51 	function approve(address _spender, uint256 _value) public returns(bool success) {
52 		require(_spender != 0x0, "invalid addr");
53 		require(_value > 0, "invalid value");
54 		allowance[msg.sender][_spender] = _value;
55 		return true;
56 	}
57 
58 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
59 		require(_from != 0x0, "invalid addr");
60 		require(_to != 0x0, "invalid addr");
61 		balanceOf[_from] = balanceOf[_from].sub(_value);
62 		balanceOf[_to] = balanceOf[_to].add(_value);
63 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
64 		emit Transfer(_from, _to, _value);
65 		return true;
66 	}
67 
68 	function getAff(address _addr)
69 	public
70 	view
71 	returns(address) {
72 		return aff[_addr];
73 	}
74 	
75 	function getAffLength(address _addr)
76 	public
77 	view
78 	returns(uint256) {
79 		return affs[_addr].length;
80 	}
81 
82 	function isAirAddr(address _addr)
83 	public
84 	view
85 	returns(bool) {
86 		return airAddrs[_addr];
87 	}
88 
89 }
90 
91 library SafeMath {
92 
93 	function sub(uint256 a, uint256 b)
94 	internal
95 	pure
96 	returns(uint256 c) {
97 		require(b <= a, "sub failed");
98 		c = a - b;
99 		require(c <= a, "sub failed");
100 		return c;
101 	}
102 
103 	function add(uint256 a, uint256 b)
104 	internal
105 	pure
106 	returns(uint256 c) {
107 		c = a + b;
108 		require(c >= a, "add failed");
109 		return c;
110 	}
111 
112 }