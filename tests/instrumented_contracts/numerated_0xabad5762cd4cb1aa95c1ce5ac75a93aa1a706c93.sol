1 pragma solidity ^0.4.20;
2 
3 library SafeMath
4 {
5 	function mul(uint a, uint b) internal pure returns (uint)
6 	{
7 		if (a == 0)
8 		{
9 			return 0;
10 		}
11 		uint c = a * b;
12 		assert(c / a == b);
13 		return c;
14 	}
15 
16 	function div(uint a, uint b) internal pure returns (uint)
17 	{
18 		uint c = a / b;
19 		return c;
20 	}
21 
22 	function sub(uint a, uint b) internal pure returns (uint)
23 	{
24 		assert(b <= a);
25 		return a - b;
26 	}
27 
28 	function add(uint a, uint b) internal pure returns (uint)
29 	{
30 		uint c = a + b;
31 		assert(c >= a);
32 		return c;
33 	}
34 }
35 
36 interface ERC20
37 {
38 	function balanceOf(address who) public view returns (uint);
39 	function transfer(address to, uint value) public returns (bool);
40 	function allowance(address owner, address spender) public view returns (uint);
41 	function transferFrom(address from, address to, uint value) public returns (bool);
42 	function approve(address spender, uint value) public returns (bool);
43 	event Transfer(address indexed from, address indexed to, uint value);
44 	event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 interface ERC223
48 {
49 	function transfer(address to, uint value, bytes data) public;
50 	event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
51 }
52 
53 contract ERC223ReceivingContract
54 {
55 	function tokenFallback(address _from, uint _value, bytes _data) public;
56 }
57 
58 contract POUND is ERC20, ERC223
59 {
60 	using SafeMath for uint;
61 
62 	string public name;
63 	string public symbol;
64 	uint8 public decimals;
65 	uint public totalSupply;
66 
67 	mapping (address => uint) balances;
68 	mapping (address => mapping (address => uint)) allowed;
69 
70 	function POUND(string _name, string _symbol, uint8 _decimals, uint _totalSupply, address _admin) public
71 	{
72 		name = _name;
73 		symbol = _symbol;
74 		decimals = _decimals;
75 		totalSupply = _totalSupply * 10 ** uint(_decimals);
76 		balances[_admin] = totalSupply;
77 	}
78 
79 	function tokenFallback(address _from, uint _value, bytes _data)
80 	{
81 	    revert();
82 	}
83 	
84 	function () //revert any ether sent to this contract
85 	{
86 		revert();
87 	}
88 	
89 	function balanceOf(address _owner) public view returns (uint balance)
90 	{
91 		return balances[_owner];
92 	}
93 
94 	function transfer(address _to, uint _value) public returns (bool)
95 	{
96 		require(_to != address(0));
97 		require(_value <= balances[msg.sender]);
98 		balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
99 		balances[_to] = SafeMath.add(balances[_to], _value);
100 		Transfer(msg.sender, _to, _value);
101 		return true;
102 	}
103 
104 	function transferFrom(address _from, address _to, uint _value) public returns (bool)
105 	{
106 		require(_to != address(0));
107 		require(_value <= balances[_from]);
108 		require(_value <= allowed[_from][msg.sender]);
109 
110 		balances[_from] = SafeMath.sub(balances[_from], _value);
111 		balances[_to] = SafeMath.add(balances[_to], _value);
112 		allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
113 		Transfer(_from, _to, _value);
114 		return true;
115 	}
116 
117 	function approve(address _spender, uint _value) public returns (bool)
118 	{
119 		allowed[msg.sender][_spender] = _value;
120 		Approval(msg.sender, _spender, _value);
121 		return true;
122 	}
123 
124 	function allowance(address _owner, address _spender) public view returns (uint)
125 	{
126 		return allowed[_owner][_spender];
127 	}
128 
129 	function increaseApproval(address _spender, uint _addedValue) public returns (bool)
130 	{
131 		allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
132 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133 		return true;
134 	}
135 
136 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool)
137 	{
138 		uint oldValue = allowed[msg.sender][_spender];
139 		if (_subtractedValue > oldValue)
140 		{
141 			allowed[msg.sender][_spender] = 0;
142 		}
143 		else
144 		{
145 			allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
146 		}
147 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148 		return true;
149 	}
150 	
151 	function transfer(address _to, uint _value, bytes _data) public
152 	{
153 		require(_value > 0 );
154 		if(isContract(_to))
155 		{
156 			ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
157 			receiver.tokenFallback(msg.sender, _value, _data);
158 		}
159 		balances[msg.sender] = balances[msg.sender].sub(_value);
160 		balances[_to] = balances[_to].add(_value);
161 		Transfer(msg.sender, _to, _value, _data);
162 	}
163 		
164 	function isContract(address _addr) private returns (bool is_contract)
165 	{
166 		uint length;
167 		assembly
168 		{
169 			length := extcodesize(_addr)
170 		}
171 		return (length>0);
172 	}
173 }