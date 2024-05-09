1 pragma solidity ^0.4.24;
2 
3 library SafeMath
4 {
5 	function mul(uint256 a, uint256 b) internal pure
6 	returns (uint256)
7 	{
8 		uint256 c = a * b;
9 
10 		assert(a == 0 || c / a == b);
11 
12 		return c;
13 	}
14 
15 	function div(uint256 a, uint256 b) internal pure
16 	returns (uint256)
17 	{
18 		// assert(b > 0); // Solidity automatically throws when dividing by 0
19 		uint256 c = a / b;
20 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
21 		return c;
22 	}
23 
24 	function sub(uint256 a, uint256 b) internal pure
25 	returns (uint256)
26 	{
27 		assert(b <= a);
28 
29 		return a - b;
30 	}
31 
32 	function add(uint256 a, uint256 b) internal pure
33 	returns (uint256)
34 	{
35 		uint256 c = a + b;
36 
37 		assert(c >= a);
38 
39 		return c;
40 	}
41 }
42 
43 interface ERC20
44 {
45 	function totalSupply() view external returns (uint _totalSupply);
46 	function balanceOf(address _owner) view external returns (uint balance);
47 	function transfer(address _to, uint _value) external returns (bool success);
48 	function transferFrom(address _from, address _to, uint _value) external returns (bool success);
49 	function approve(address _spender, uint _value) external returns (bool success);
50 	function allowance(address _owner, address _spender) view external returns (uint remaining);
51 
52 	event Transfer(address indexed _from, address indexed _to, uint _value);
53 	event Approval(address indexed _owner, address indexed _spender, uint _value);
54 }
55 
56 contract LynchpinToken is ERC20
57 {
58 	using SafeMath for uint256;
59 
60 	string 	public name        = "Lynchpin";
61 	string 	public symbol      = "LYN";
62 	uint8 	public decimals    = 18;
63 	uint 	public totalSupply = 5000000 * (10 ** uint(decimals));
64 	address public owner       = 0xAc983022185b95eF2B2C7219143483BD0C65Ecda;
65 
66 	mapping (address => uint) public balanceOf;
67 	mapping (address => mapping (address => uint)) public allowance;
68 
69 	constructor() public
70 	{
71 		balanceOf[owner] = totalSupply;
72 	}
73 
74 	function totalSupply() view external returns (uint _totalSupply)
75 	{
76 		return totalSupply;
77 	}
78 
79 	function balanceOf(address _owner) view external returns (uint balance)
80 	{
81 		return balanceOf[_owner];
82 	}
83 
84 	function allowance(address _owner, address _spender) view external returns (uint remaining)
85 	{
86 		return allowance[_owner][_spender];
87 	}
88 	function _transfer(address _from, address _to, uint _value) internal
89 	{
90 		require(_to != 0x0);
91 
92 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
93 		balanceOf[_from] = balanceOf[_from].sub(_value);
94 		balanceOf[_to] = balanceOf[_to].add(_value);
95 
96 		emit Transfer(_from, _to, _value);
97 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
98 	}
99 
100 	function transfer(address _to, uint _value) public returns (bool success)
101 	{
102 		_transfer(msg.sender, _to, _value);
103 		return true;
104 	}
105 
106 	function transferFrom(address _from, address _to, uint _value) public returns (bool success)
107 	{
108 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
109 		_transfer(_from, _to, _value);
110 		return true;
111 	}
112 
113 	function approve(address _spender, uint _value) public returns (bool success)
114 	{
115 		allowance[msg.sender][_spender] = _value;
116 		emit Approval(msg.sender, _spender, _value);
117 		return true;
118 	}
119 
120 	// disallow incoming ether to this contract
121 	function () public
122 	{
123 		revert();
124 	}
125 }