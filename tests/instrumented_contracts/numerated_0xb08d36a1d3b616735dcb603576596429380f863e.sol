1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4 	function totalSupply() public constant returns (uint256);
5 	function balanceOf(address tokenOwner) public constant returns (uint256 balance);
6 	function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
7 	function transfer(address to, uint256 tokens) public returns (bool success);
8 	function approve(address spender, uint256 tokens) public returns (bool success);
9 	function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
10 
11 	event Transfer(address indexed from, address indexed to, uint256 tokens);
12 	event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
13 }
14 
15 contract ApproveAndCallFallBack {
16 	function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
17 }
18 
19 contract WATERToken is ERC20Interface {
20 
21 	function () public payable {
22 		revert();
23 	}
24 
25 	string public name;
26 	uint8 public decimals;
27 	string public symbol;
28 	string public version = 'H1.0';
29 	uint256 public _totalSupply;
30 
31 	mapping (address => uint256) balances;
32 	mapping (address => mapping (address => uint256)) allowed;
33 
34 	function WATERToken() public {
35 		decimals = 8;
36 		_totalSupply = 21000000 * 10 ** uint256(decimals);
37 		balances[msg.sender] = _totalSupply;
38 		//Transfer(address(0), msg.sender, _totalSupply);
39 		name = "WATER TOKEN";
40 		symbol = "WAT";
41 	}
42 
43 	function totalSupply() public view returns (uint256) {
44 		return _totalSupply;
45 	}
46 
47 	function transfer(address _to, uint256 _value) public returns (bool success) {
48 		require(balances[msg.sender] >= _value && _value > 0);
49 		//if (balances[msg.sender] >= _value && _value > 0) {
50 			balances[msg.sender] -= _value;
51 			balances[_to] += _value;
52 			Transfer(msg.sender, _to, _value);
53 			return true;
54 		//} else { return false; }
55 	}
56 
57 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
59 		//if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60 			balances[_to] += _value;
61 			balances[_from] -= _value;
62 			allowed[_from][msg.sender] -= _value;
63 			Transfer(_from, _to, _value);
64 			return true;
65 		//} else { return false; }
66 	}
67 
68 	function balanceOf(address _owner) public view returns (uint256 balance) {
69 		return balances[_owner];
70 	}
71 
72 	function approve(address _spender, uint256 _value) public returns (bool success) {
73 		allowed[msg.sender][_spender] = _value;
74 		Approval(msg.sender, _spender, _value);
75 		return true;
76 	}
77 
78 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
79 	  return allowed[_owner][_spender];
80 	}
81 
82 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
83 		allowed[msg.sender][_spender] = _value;
84 		Approval(msg.sender, _spender, _value);
85 
86 		ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, _extraData);
87 		return true;
88 	}
89 }