1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 	function add(uint a, uint b) internal pure returns (uint c) {
5 		c = a + b;
6 		require(c >= a);
7 	}
8 
9 	function sub(uint a, uint b) internal pure returns (uint c) {
10 		require(b <= a);
11 		c = a - b;
12 	}
13 }
14 
15 contract ERC20Interface {
16 	function totalSupply() public constant returns (uint);
17 	function balanceOf(address tokenOwner) public constant returns (uint balance);
18 	function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
19 	function transfer(address to, uint tokens) public returns (bool success);
20 	function approve(address spender, uint tokens) public returns (bool success);
21 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
22 
23 	event Transfer(address indexed from, address indexed to, uint tokens);
24 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
25 }
26 
27 contract DrupeCoin is ERC20Interface {
28 	using SafeMath for uint;
29 
30 	string public constant symbol = "DPC";
31 	string public constant name = "DrupeCoin";
32 	uint8 public constant decimals = 18;
33 
34 	uint _initialSupply;
35 	mapping(address => uint) _balances;
36 	mapping(address => mapping(address => uint)) _allowed;
37 
38 	constructor() public {
39 		_initialSupply = 200 * 1000000 * 10**uint(decimals);
40 		_balances[msg.sender] = _initialSupply;
41 		emit Transfer(address(0), msg.sender, _initialSupply);
42 	}
43 
44 	function _transfer(address from, address to, uint tokens) internal {
45 		_balances[from] = _balances[from].sub(tokens);
46 		_balances[to] = _balances[to].add(tokens);
47 		emit Transfer(from, to, tokens);
48 	}
49 
50 	function totalSupply() public constant returns (uint) {
51 		return _initialSupply - _balances[address(0)];
52 	}
53 
54 	function balanceOf(address tokenOwner) public constant returns (uint balance) {
55 		return _balances[tokenOwner];
56 	}
57 
58 	function transfer(address to, uint tokens) public returns (bool success) {
59 		_transfer(msg.sender, to, tokens);
60 		return true;
61 	}
62 
63 	function approve(address spender, uint tokens) public returns (bool success) {
64 		_allowed[msg.sender][spender] = tokens;
65 		emit Approval(msg.sender, spender, tokens);
66 		return true;
67 	}
68 
69 	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
70 		_allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);
71 		_transfer(from, to, tokens);
72 		return true;
73 	}
74 
75 	function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
76 		return _allowed[tokenOwner][spender];
77 	}
78 }