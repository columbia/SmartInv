1 pragma solidity >=0.4.10;
2 
3 contract Token {
4 	event Transfer(address indexed from, address indexed to, uint value);
5 	event Approval(address indexed owner, address indexed spender, uint value);
6 
7 	string constant public name = "Hodl Token";
8 	string constant public symbol = "HODL";
9 	uint8 constant public decimals = 8;
10 	mapping (address => uint) public balanceOf;
11 	mapping (address => mapping (address => uint)) public allowance;
12 	uint public totalSupply;
13 	address public owner;
14 
15 	function Token() {
16 		owner = msg.sender;
17 	}
18 
19 	function transfer(address to, uint value) returns(bool) {
20 		uint bal = balanceOf[msg.sender];
21 		require(bal >= value);
22 		balanceOf[msg.sender] = bal - value;
23 		balanceOf[to] = balanceOf[to] + value;
24 		Transfer(msg.sender, to, value);
25 		return true;
26 	}
27 
28 	function approve(address spender, uint value) returns(bool) {
29 		require(value == 0 || (allowance[msg.sender][spender] == 0 && balanceOf[msg.sender] >= value));
30 		allowance[msg.sender][spender] = value;
31 		Approval(msg.sender, spender, value);
32 		return true;
33 	}
34 
35 	function transferFrom(address owner, address to, uint value) returns(bool) {
36 		uint allowed = allowance[owner][msg.sender];
37 		uint balance = balanceOf[owner];
38 		require(allowed >= value && balance >= value);
39 		allowance[owner][msg.sender] = allowed - value;
40 		balanceOf[owner] = balance - value;
41 		balanceOf[to] = balanceOf[to] + value;
42 		Transfer(owner, to, value);
43 		return true;
44 	}
45 
46 	function approval(address owner, address spender) constant returns(uint) {
47 		return allowance[owner][spender];
48 	}
49 
50 	function burn(uint amount) {
51 		uint bal = balanceOf[msg.sender];
52 		require(bal >= amount);
53 		balanceOf[msg.sender] = bal - amount;
54 		totalSupply -= amount;
55 		Transfer(msg.sender, 0, amount);
56 	}
57 
58 	function mint(address to, uint value) {
59 		require(msg.sender == owner);
60 		balanceOf[to] = balanceOf[to] + value;
61 		totalSupply += value;
62 		Transfer(0, to, value);
63 	}
64 
65 	function multiMint(uint256[] bits) {
66 		require(msg.sender == owner);
67 		uint256 lomask = (1 << 96) - 1;
68 		uint created = 0;
69 		for (uint i=0; i<bits.length; i++) {
70 			address a = address(bits[i]>>96);
71 			uint value = bits[i]&lomask;
72 			balanceOf[a] = balanceOf[a] + value;
73 			Transfer(0, a, value);
74 			created += value;
75 		}
76 		totalSupply += created;
77 	}
78 }