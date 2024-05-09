1 pragma solidity ^0.4.18;
2 
3 contract BurnableERC20Token {
4 	uint256 public totalSupply;
5 	string public name;
6 	uint8 public decimals;
7 	string public symbol;
8 	address public owner;
9 	
10 	mapping (address => uint256) balances;
11 	mapping (address => mapping (address => uint256)) allowed;
12 	
13 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
14 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 	event Burn(address indexed _from, uint256 _value);
16 	event SetOwner(address indexed _prevOwner, address indexed _owner);
17 	
18 	constructor(uint256 _totalSupply, uint8 _decimals, string _symbol, string _name) public {
19 		decimals = _decimals;
20 		symbol = _symbol;
21 		name = _name;
22 		owner = msg.sender;
23 		totalSupply = _totalSupply * (10 ** uint256(decimals));
24 		balances[msg.sender] = totalSupply;
25 	}
26 	
27 	function balanceOf(address _owner) constant public returns (uint256) {
28 		return balances[_owner];
29 	}
30 	
31 	function transfer(address _to, uint256 _value) public {
32 		require(_to != 0x0 && balances[msg.sender] >= _value && _value > 0);
33 		balances[msg.sender] -= _value;
34 		balances[_to] += _value;
35 		Transfer(msg.sender, _to, _value);
36 	}
37 	
38 	function transferFrom(address _from, address _to, uint256 _value) public {
39 		require(_to != 0x0 && balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
40 		balances[_to] += _value;
41 		balances[_from] -= _value;
42 		allowed[_from][msg.sender] -= _value;
43 		Transfer(_from, _to, _value);
44 	}
45 	
46 	function approve(address _spender, uint256 _value) public {
47 		allowed[msg.sender][_spender] = _value;
48 		Approval(msg.sender, _spender, _value);
49 	}
50 	
51 	function allowance(address _owner, address _spender) constant public returns (uint256) {
52 		return allowed[_owner][_spender];
53 	}
54 	
55 	function burn(uint256 _value) public returns (bool _success) {
56 	    require(msg.sender == owner && balances[msg.sender] >= _value);
57 	    balances[msg.sender] -= _value;
58 	    totalSupply -= _value;
59 	    Burn(msg.sender, _value);
60 	    _success = true;
61 	}
62 	
63 	function setOwner(address _owner) public returns(bool _success) {
64 	    require(_owner != 0x0 && msg.sender == owner);
65 	    address prevOwner = owner;
66 	    owner = _owner;
67 	    SetOwner(prevOwner, owner);
68 	    _success = true;
69 	}
70 }