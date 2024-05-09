1 pragma solidity ^0.4.11;
2 
3 contract ERC20Interface {
4 	function totalSupply() constant returns (uint supply);
5 	function balanceOf(address _owner) constant returns (uint balance);
6 	function transfer(address _to, uint _value) returns (bool success);
7 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
8 	function approve(address _spender, uint _value) returns (bool success);
9 	function allowance(address _owner, address _spender) constant returns (uint remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 contract DDAContract is ERC20Interface {
14 	string public constant symbol = "DDA";
15 	string public constant name = "DeDeAnchor";
16 	uint8 public constant decimals = 18;
17 	uint256 public _totalSupply = 10**26;//smallest unit is 10**-18, and total dda is 10**8
18 
19 	mapping (address => uint) public balances;
20 	mapping (address => mapping (address => uint256)) public allowed;
21 
22 	address dedeAddress;
23 
24 // ERC20 FUNCTIONS
25 	function totalSupply() constant returns (uint totalSupply){
26 		return _totalSupply;
27 	}
28 	function balanceOf(address _owner) constant returns (uint balance){
29 		return balances[_owner];
30 	}
31 	function transfer(address _to, uint _value) returns (bool success){
32 		if(balances[msg.sender] >= _value
33 			&& _value > 0
34 			&& balances[_to] + _value > balances[_to]){
35 			balances[msg.sender] -= _value;
36 			balances[_to] += _value;
37 			Transfer(msg.sender, _to, _value);
38 			return true;
39 		}
40 		else{
41 			return false;
42 		}
43 	}
44 	function transferFrom(address _from, address _to, uint _value) returns (bool success){
45 		if(balances[_from] >= _value
46 			&& allowed[_from][msg.sender] >= _value
47 			&& _value >= 0
48 			&& balances[_to] + _value > balances[_to]){
49 			balances[_from] -= _value;
50 			allowed[_from][msg.sender] -= _value;
51 			balances[_to] += _value;
52 			Transfer(_from, _to, _value);
53 			return true;
54 		}
55 		else{
56 			return false;
57 		}
58 	}
59 	function approve(address _spender, uint _value) returns (bool success){
60 		allowed[msg.sender][_spender] = _value;
61 		Approval(msg.sender, _spender, _value);
62 		return true;
63 	}
64 	function allowance(address _owner, address _spender) constant returns (uint remaining){
65 		return allowed[_owner][_spender];
66 	}
67 
68 
69 	function DDAContract(address _dedeAddress){
70 		dedeAddress = _dedeAddress;
71 		balances[_dedeAddress] = _totalSupply;
72 		Transfer(0, _dedeAddress, _totalSupply);
73 	}
74 	function changeDedeAddress(address newDedeAddress){
75 		require(msg.sender == dedeAddress);
76 		dedeAddress = newDedeAddress;
77 	}
78 	function mint(uint256 value){
79 		require(msg.sender == dedeAddress);
80 		_totalSupply += value;
81 		balances[msg.sender] += value;
82 		Transfer(0, msg.sender, value);
83 	}
84 }