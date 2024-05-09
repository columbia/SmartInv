1 pragma solidity ^0.4.18;
2 
3 contract LockableERC20Token {
4 	uint256 public totalSupply;
5 	string public name;
6 	uint8 public decimals;
7 	string public symbol;
8 	address public owner;
9 	bool public isLocked;
10 	
11 	mapping (address => uint256) balances;
12 	mapping (address => mapping (address => uint256)) allowed;
13 	
14 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
15 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 	event Burn(address indexed _from, uint256 _value);
17 	event SetOwner(address indexed _prevOwner, address indexed _owner);
18 	event Lock(address indexed _owner, bool _isLocked);
19 	
20 	constructor(uint256 _totalSupply, uint8 _decimals, string _symbol, string _name, bool _isLocked) public {
21 		decimals = _decimals;
22 		symbol = _symbol;
23 		name = _name;
24 		isLocked = _isLocked;
25 		owner = msg.sender;
26 		totalSupply = _totalSupply * (10 ** uint256(decimals));
27 		balances[msg.sender] = totalSupply;
28 	}
29 	
30 	function balanceOf(address _owner) constant public returns (uint256) {
31 		return balances[_owner];
32 	}
33 	
34 	function transfer(address _to, uint256 _value) public {
35 		require(_to != 0x0 && balances[msg.sender] >= _value && _value > 0 && isLocked == false);
36 		balances[msg.sender] -= _value;
37 		balances[_to] += _value;
38 		Transfer(msg.sender, _to, _value);
39 	}
40 	
41 	function transferFrom(address _from, address _to, uint256 _value) public {
42 		require(_to != 0x0 && balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && isLocked == false);
43 		balances[_to] += _value;
44 		balances[_from] -= _value;
45 		allowed[_from][msg.sender] -= _value;
46 		Transfer(_from, _to, _value);
47 	}
48 	
49 	function approve(address _spender, uint256 _value) public {
50 		require(_spender != 0x0 && isLocked == false);
51 		allowed[msg.sender][_spender] = _value;
52 		Approval(msg.sender, _spender, _value);
53 	}
54 	
55 	function allowance(address _owner, address _spender) constant public returns (uint256) {
56 		return allowed[_owner][_spender];
57 	}
58 	
59 	function burn(uint256 _value) public returns (bool _success) {
60 	    require(msg.sender == owner && balances[msg.sender] >= _value && isLocked == false);
61 	    balances[msg.sender] -= _value;
62 	    totalSupply -= _value;
63 	    Burn(msg.sender, _value);
64 	    _success = true;
65 	}
66 	
67 	function setOwner(address _owner) public returns(bool _success) {
68 	    require(_owner != 0x0 && msg.sender == owner);
69 	    address prevOwner = owner;
70 	    owner = _owner;
71 	    SetOwner(prevOwner, owner);
72 	    _success = true;
73 	}
74 	
75 	function lock() public returns(bool _success) {
76 		require(msg.sender == owner && isLocked == false);
77 		isLocked = true;
78 		Lock(owner, isLocked);
79 		_success = true;
80 	}
81 	
82 	function unLock() public returns(bool _success) {
83 		require(msg.sender == owner && isLocked == true);
84 		isLocked = false;
85 		Lock(owner, isLocked);
86 		_success = true;
87 	}
88 }