1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4 	function totalSupply() public constant returns (uint256 supply);
5 	function balanceOf(address _owner) public constant returns (uint256 balance);
6 	function transfer(address _to, uint256 _value) public returns (bool success);
7 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8 	function approve(address _spender, uint256 _value) public returns (bool success);
9 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 
16 contract StandardToken is ERC20Interface {
17 
18 	function transfer(address _to, uint256 _value) public returns (bool) {
19 		require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
20 		balances[msg.sender] -= _value;
21 		balances[_to] += _value;
22 		Transfer(msg.sender, _to, _value);
23 		return true;
24 	}
25 
26 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
27 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
28 		balances[_to] += _value;
29 		balances[_from] -= _value;
30 		allowed[_from][msg.sender] -= _value;
31 		Transfer(_from, _to, _value);
32 		return true;
33 	}
34 
35 	function balanceOf(address _owner) public constant returns (uint256) {
36 		return balances[_owner];
37 	}
38 
39 	function approve(address _spender, uint256 _value) public returns (bool) {
40 		allowed[msg.sender][_spender] = _value;
41 		Approval(msg.sender, _spender, _value);
42 		return true;
43 	}
44 
45 	function allowance(address _owner, address _spender) public constant returns (uint256) {
46 	  return allowed[_owner][_spender];
47 	}
48 	
49 	function totalSupply() public constant returns (uint256 supply) {
50 		return totalTokens;
51 	}
52 
53 	mapping (address => uint256) balances;
54 	mapping (address => mapping (address => uint256)) allowed;
55 	uint256 public totalTokens;
56 	
57 	// Optional vanity variables
58 	uint8 public decimals;
59 	string public name;
60 	string public symbol;
61 	string public version = '0.1';
62 }
63 
64 
65 
66 
67 
68 
69 
70 contract TimCoin is StandardToken {
71 
72 	address private owner;
73 	uint256 etherBalance;
74 	
75 	function() public payable {
76 		uint256 amount = msg.value;
77 		require(amount > 0 && etherBalance + amount > etherBalance);
78 		etherBalance += amount;
79 	}
80 	
81 	function collect(uint256 amount) public {
82 		require(msg.sender == owner && amount <= etherBalance);
83 		owner.transfer(amount);
84 		etherBalance -= amount;
85 	}
86 
87 
88 
89 	function TimCoin() public {
90 		owner = msg.sender;
91 		decimals = 18;
92 		totalTokens = uint(10)**(decimals + 9);
93 		balances[owner] = totalTokens;
94 		name = "Tim Coin";
95 		symbol = "TIM";
96 	}
97 	
98 	function increaseSupply(uint value, address to) public returns (bool) {
99 		require(value > 0 && totalTokens + value > totalTokens && msg.sender == owner);
100 		totalTokens += value;
101 		balances[to] += value;
102 		Transfer(0, to, value);
103 		return true;
104 	}
105 	
106 	function decreaseSupply(uint value, address from) public returns (bool) {
107 		require(value > 0 && balances[from] >= value && msg.sender == owner);
108 		balances[from] -= value;
109 		totalTokens -= value;
110 		Transfer(from, 0, value);
111 		return true;
112 	}
113 }