1 pragma solidity ^0.4.11;
2 
3 contract OL {
4 	uint256 public totalSupply;
5 	string public name;
6 	uint256 public decimals;
7 	string public symbol;
8 	address public owner;
9 
10 	mapping (address => uint256) balances;
11 	mapping (address => mapping (address => uint256)) allowed;
12 
13     function OL(uint256 _totalSupply, string _symbol, string _name, uint8 _decimalUnits) public {
14         decimals = _decimalUnits;
15         symbol = _symbol;
16         name = _name;
17         owner = msg.sender;
18         totalSupply = _totalSupply * (10 ** decimals);
19         balances[msg.sender] = totalSupply;
20     }
21 
22 	//Fix for short address attack against ERC20
23 	modifier onlyPayloadSize(uint size) {
24 		assert(msg.data.length == size + 4);
25 		_;
26 	} 
27 
28 	function balanceOf(address _owner) constant public returns (uint256) {
29 		return balances[_owner];
30 	}
31 
32 	function transfer(address _recipient, uint256 _value) onlyPayloadSize(2*32) public {
33 		require(balances[msg.sender] >= _value && _value > 0);
34 	    balances[msg.sender] -= _value;
35 	    balances[_recipient] += _value;
36 	    Transfer(msg.sender, _recipient, _value);        
37     }
38 
39 	function transferFrom(address _from, address _to, uint256 _value) public {
40 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
41         balances[_to] += _value;
42         balances[_from] -= _value;
43         allowed[_from][msg.sender] -= _value;
44         Transfer(_from, _to, _value);
45     }
46 
47 	function approve(address _spender, uint256 _value) public {
48 		allowed[msg.sender][_spender] = _value;
49 		Approval(msg.sender, _spender, _value);
50 	}
51 
52 	function allowance(address _owner, address _spender) constant public returns (uint256) {
53 		return allowed[_owner][_spender];
54 	}
55 
56 	function mint(uint256 amount) public {
57 		assert(amount >= 0);
58 		require(msg.sender == owner);
59 		balances[msg.sender] += amount;
60 		totalSupply += amount;
61 	}
62 
63 	//Event which is triggered to log all transfers to this contract's event log
64 	event Transfer(
65 		address indexed _from,
66 		address indexed _to,
67 		uint256 _value
68 		);
69 		
70 	//Event which is triggered whenever an owner approves a new allowance for a spender.
71 	event Approval(
72 		address indexed _owner,
73 		address indexed _spender,
74 		uint256 _value
75 		);
76 
77 }