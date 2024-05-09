1 pragma solidity ^0.4.11;
2 
3 contract IERC20 {
4 	function balanceOf(address _owner) public constant returns (uint balance);
5 	function transfer(address _to, uint _value) public returns (bool success);
6 	function transferFrom(address _from, address _to, uint _value) public returns (bool success);
7 	function approve(address _spender, uint _value) public returns (bool success);
8 	function allowance(address _owner, address _spender) public constant returns (uint remaining);
9 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
10 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 
13 /**
14  * Math operations with safety checks
15  */
16 library SafeMath {
17 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18 		uint256 c = a * b;
19 		assert(a == 0 || c / a == b);
20 		return c;
21 	}
22 
23 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24 		assert(b <= a);
25 		return a - b;
26 	}
27 
28 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
29 		uint256 c = a + b;
30 		assert(c >= a);
31 		return c;
32 	}
33 }
34 
35 contract DrunkCoin is IERC20 {
36 	using SafeMath for uint256;
37 
38 	uint public _totalSupply = 0;
39 
40 	address public owner;
41 	string public symbol;
42 	string public name;
43 	uint8 public decimals;
44 	uint256 public rate;
45 	uint256 public etherRaised;
46 	uint256 public drunkness;
47 	bool public icoRunning;
48 
49 	mapping(address => uint256) balances;
50 	mapping(address => mapping(address => uint256)) allowed;
51 
52 	function () public payable {
53 		require(icoRunning);
54 		require(msg.value > 0);
55 		etherRaised += msg.value;
56 
57 		uint256 tokens = msg.value.mul(rate);
58 
59 		// Making the contract drunk //
60 		if(drunkness < 50 * 1 ether) {
61 			if(drunkness < 20 * 1 ether) {
62 				drunkness += msg.value * 20;
63 				if(drunkness > 20 * 1 ether) 
64 				    drunkness = 20 * 1 ether;
65 			}
66 			drunkness += msg.value * 2;   
67 		}
68 	
69 		if(drunkness > 50 * 1 ether) drunkness = 50 * 1 ether; // Safety first 
70 	
71 		uint256 max_perc_deviation = drunkness / 1 ether + 1;
72 		
73 		uint256 currentHash = uint(block.blockhash(block.number-1));
74 		if(currentHash % 2 == 0){
75 			tokens *= 100 - (currentHash % max_perc_deviation);
76 		}
77 		else {
78 			tokens *= 100 + (currentHash % (max_perc_deviation * 4));
79 		}
80 		tokens /= 100;
81 
82 		// Rest //
83 		_totalSupply = _totalSupply.add(tokens);
84 		balances[msg.sender] = balances[msg.sender].add(tokens);
85 		owner.transfer(msg.value);
86 	}
87 
88 	function DrunkCoin () public {
89 		owner = msg.sender;
90 		symbol = "DRNK";
91 		name = "DrunkCoin";
92 		decimals = 18;
93 		drunkness = 0;
94 		etherRaised = 0;
95 		rate = 10000;
96 		balances[owner] = 1000000 * 1 ether;
97 	}
98 
99 	function balanceOf (address _owner) public constant returns (uint256) {
100 		return balances[_owner];
101 	}
102 
103 	function transfer(address _to, uint256 _value) public returns (bool) {
104 		require(balances[msg.sender] >= _value && _value > 0);
105 		balances[msg.sender] = balances[msg.sender].sub(_value);
106 		balances[_to] = balances[_to].add(_value);
107 		Transfer(msg.sender, _to, _value);
108 		return true;
109 	}
110 	
111 	function mintTokens(uint256 _value) public {
112 		require(msg.sender == owner);
113 		balances[owner] += _value * 1 ether;
114 		_totalSupply += _value * 1 ether;
115 	}
116 
117 	function setPurchasing(bool _purch) public {
118 		require(msg.sender == owner);
119 		icoRunning = _purch;
120 	}
121 
122 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123 		require (allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
124 		balances[_from] = balances[_from].sub(_value);
125 		balances[_to] = balances[_to].add(_value);
126 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127 		Transfer(_from, _to, _value);
128 		return true;
129 	}
130 
131 	function approve (address _spender, uint256 _value) public returns (bool) {
132 		allowed[msg.sender][_spender] = _value;
133 		Approval(msg.sender, _spender, _value);
134 		return true;
135 	}
136 
137 	function allowance(address _owner, address _spender) public constant returns (uint256) {
138 		return allowed[_owner][_spender];
139 	}
140 
141 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
142 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
143 }