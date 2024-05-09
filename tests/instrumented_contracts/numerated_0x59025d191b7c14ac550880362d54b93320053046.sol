1 pragma solidity ^0.4.11;
2 
3 // 以太坊企业服务，请访问 https://www.94eth.com/tool
4 
5 contract ERC20Standard {
6 	uint256 public totalSupply;
7 	string public name;
8 	uint256 public decimals;
9 	string public symbol;
10 	address public owner;
11 
12 	mapping (address => uint256) balances;
13 	mapping (address => mapping (address => uint256)) allowed;
14 
15    constructor(uint256 _totalSupply, string _symbol, string _name, uint256 _decimals) public {
16 		symbol = _symbol;
17 		name = _name;
18         decimals = _decimals;
19 		owner = msg.sender;
20         totalSupply = _totalSupply * (10 ** decimals);
21         balances[owner] = totalSupply;
22   }
23 	//Fix for short address attack against ERC20
24 	modifier onlyPayloadSize(uint size) {
25 		assert(msg.data.length == size + 4);
26 		_;
27 	} 
28 
29 	function balanceOf(address _owner) constant public returns (uint256) {
30 		return balances[_owner];
31 	}
32 
33 	function transfer(address _recipient, uint256 _value) onlyPayloadSize(2*32) public {
34 		require(balances[msg.sender] >= _value && _value >= 0);
35 	    require(balances[_recipient] + _value >= balances[_recipient]);
36 	    balances[msg.sender] -= _value;
37 	    balances[_recipient] += _value;
38 	    emit Transfer(msg.sender, _recipient, _value);        
39     }
40 
41 	function transferFrom(address _from, address _to, uint256 _value) public {
42 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
43 		require(balances[_to] + _value >= balances[_to]);
44         balances[_to] += _value;
45         balances[_from] -= _value;
46         allowed[_from][msg.sender] -= _value;
47         emit Transfer(_from, _to, _value);
48     }
49 
50 	function approve(address _spender, uint256 _value) public {
51 		allowed[msg.sender][_spender] = _value;
52 		emit Approval(msg.sender, _spender, _value);
53 	}
54 
55 	function allowance(address _owner, address _spender) constant public returns (uint256) {
56 		return allowed[_owner][_spender];
57 	}
58 
59 	//Event which is triggered to log all transfers to this contract's event log
60 	event Transfer(
61 		address indexed _from,
62 		address indexed _to,
63 		uint256 _value
64 		);
65 		
66 	//Event which is triggered whenever an owner approves a new allowance for a spender.
67 	event Approval(
68 		address indexed _owner,
69 		address indexed _spender,
70 		uint256 _value
71 		);
72 
73 }