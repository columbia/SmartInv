1 pragma solidity ^0.4.24;
2 
3 interface ERC20
4 {
5 	function totalSupply() view external returns (uint _totalSupply);
6 	function balanceOf(address _owner) view external returns (uint balance);
7 	function transfer(address _to, uint _value) external returns (bool success);
8 	function transferFrom(address _from, address _to, uint _value) external returns (bool success);
9 	function approve(address _spender, uint _value) external returns (bool success);
10 	function allowance(address _owner, address _spender) view external returns (uint remaining);
11 
12 	event Transfer(address indexed _from, address indexed _to, uint _value);
13 	event Approval(address indexed _owner, address indexed _spender, uint _value);
14 }
15 
16 contract NoxusCoin is ERC20
17 {
18 	string public name;
19 	string public symbol;
20 	uint public totalSupply;
21 	uint8 public decimals = 18;	
22 
23 	mapping (address => uint) public balanceOf;
24 	mapping (address => mapping (address => uint)) public allowance;
25 
26 	event Transfer(address indexed from, address indexed to, uint value);
27 	event Burn(address indexed from, uint value);
28 
29 	constructor(uint initialSupply,string tokenName, string tokenSymbol, address _owner) public
30 	{
31 		totalSupply = initialSupply * 10 ** uint(decimals);
32 		balanceOf[_owner] = totalSupply;
33 		name = tokenName;
34 		symbol = tokenSymbol;
35 	}
36 
37 	function totalSupply() view external returns (uint _totalSupply)
38 	{
39 		return totalSupply;
40 	}
41 	function balanceOf(address _owner) view external returns (uint balance)
42 	{
43 		return balanceOf[_owner];
44 	}
45 
46 	function allowance(address _owner, address _spender) view external returns (uint remaining)
47 	{
48 		return allowance[_owner][_spender];
49 	}
50 	function _transfer(address _from, address _to, uint _value) internal
51 	{
52 		require(_to != 0x0);
53 		require(balanceOf[_from] >= _value);
54 		require(balanceOf[_to] + _value > balanceOf[_to]);
55 		
56 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
57 		balanceOf[_from] -= _value;
58 		balanceOf[_to] += _value;
59 		
60 		emit Transfer(_from, _to, _value);
61 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
62 	}
63 
64 	function transfer(address _to, uint _value) public returns (bool success)
65 	{
66 		_transfer(msg.sender, _to, _value);
67 		return true;
68 	}
69 
70 	function transferFrom(address _from, address _to, uint _value) public returns (bool success)
71 	{
72 		require(_value <= allowance[_from][msg.sender]);
73 		allowance[_from][msg.sender] -= _value;
74 		_transfer(_from, _to, _value);
75 		return true;
76 	}
77 
78 	function approve(address _spender, uint _value) public returns (bool success)
79 	{
80 		allowance[msg.sender][_spender] = _value;
81 		emit Approval(msg.sender, _spender, _value);
82 		return true;
83 	}
84 
85 	function burn(uint _value) public returns (bool success)
86 	{
87 		require(balanceOf[msg.sender] >= _value);
88 		balanceOf[msg.sender] -= _value;
89 		totalSupply -= _value;
90 		emit Burn(msg.sender, _value);
91 		return true;
92 	}
93 
94 	function burnFrom(address _from, uint _value) public returns (bool success)
95 	{
96 		require(balanceOf[_from] >= _value);
97 		require(_value <= allowance[_from][msg.sender]);
98 		balanceOf[_from] -= _value;
99 		allowance[_from][msg.sender] -= _value;
100 		totalSupply -= _value;
101 		emit Burn(_from, _value);
102 		return true;
103 	}
104 	
105 	function () public
106 	{
107 		revert();
108 	}
109 }