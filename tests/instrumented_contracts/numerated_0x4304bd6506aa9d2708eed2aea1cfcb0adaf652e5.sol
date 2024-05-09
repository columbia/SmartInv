1 pragma solidity ^0.4.21;
2 
3 contract TokenRecipient {
4 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 contract ERC20 {
8 	uint256 public totalSupply;
9 	function balanceOf(address _owner) public constant returns (uint256 balance);
10 	function transfer(address _to, uint256 _value) public returns (bool ok);
11 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool ok);
12 	function approve(address _spender, uint256 _value) public returns (bool ok);
13 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
14 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
15 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 contract WankCoin is ERC20 {
19 	mapping (address => uint256) balances;
20 	mapping (address => mapping (address => uint256)) allowed;
21 	uint8 public decimals;
22 	string public name;
23 	string public symbol;
24 	
25 	bool public running;
26 	address public owner;
27 	address public ownerTemp;
28 	
29 	
30 
31 	modifier isOwner {
32 		require(owner == msg.sender);
33 		_;
34 	}
35 	
36 	modifier isRunning {
37 		require(running);
38 		_;
39 	}
40 	
41 	
42 	function WankCoin() public {
43 		running = true;
44 		owner = msg.sender;
45 		decimals = 18;
46 		totalSupply = 2 * uint(10)**(decimals + 9);
47 		balances[owner] = totalSupply;
48 		name = "WANKCOIN";
49 		symbol = "WKC";
50 		emit Transfer(0x0, owner, totalSupply);
51 	}
52 	
53 	function transfer(address _to, uint256 _value) public isRunning returns (bool) {
54 		require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
55 		balances[msg.sender] -= _value;
56 		balances[_to] += _value;
57 		emit Transfer(msg.sender, _to, _value);
58 		return true;
59 	}
60 
61 	function transferFrom(address _from, address _to, uint256 _value) public isRunning returns (bool) {
62 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
63 		balances[_to] += _value;
64 		balances[_from] -= _value;
65 		allowed[_from][msg.sender] -= _value;
66 		emit Transfer(_from, _to, _value);
67 		return true;
68 	}
69 
70 	function balanceOf(address _owner) public constant returns (uint256) {
71 		return balances[_owner];
72 	}
73 
74 	function approve(address _spender, uint256 _value) public isRunning returns (bool) {
75 		allowed[msg.sender][_spender] = _value;
76 		emit Approval(msg.sender, _spender, _value);
77 		return true;
78 	}
79 
80 	function allowance(address _owner, address _spender) public constant returns (uint256) {
81 	  return allowed[_owner][_spender];
82 	}
83 	
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public isRunning returns (bool ok) {
85 		TokenRecipient spender = TokenRecipient(_spender);
86         if (approve(_spender, _value)) {
87             spender.receiveApproval(msg.sender, _value, this, _extraData);
88 			return true;
89 		}
90     }
91 	
92 	
93 	
94 	function setName(string _name) public isOwner {
95 		name = _name;
96 	}
97 	
98 	function setSymbol(string _symbol) public isOwner {
99 		symbol = _symbol;
100 	}
101 	
102 	function setRunning(bool _run) public isOwner {
103 		running = _run;
104 	}
105 	
106 	function transferOwnership(address _owner) public isOwner {
107 		ownerTemp = _owner;
108 	}
109 	
110 	function acceptOwnership() public {
111 		require(msg.sender == ownerTemp);
112 		owner = ownerTemp;
113 		ownerTemp = 0x0;
114 	}
115 	
116 	function collectERC20(address _token, uint _amount) public isRunning isOwner returns (bool success) {
117 		return ERC20(_token).transfer(owner, _amount);
118 	}
119 }