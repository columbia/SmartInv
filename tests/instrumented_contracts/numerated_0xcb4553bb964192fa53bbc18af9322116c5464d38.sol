1 /**
2  *Submitted for verification at Etherscan.io on 2018-04-19
3 */
4 
5 pragma solidity ^0.4.11;
6 
7 // 以太坊企业服务，请访问 https://www.94eth.com/tool
8 
9 contract ERC20Standard {
10 	uint256 public totalSupply;
11 	string public name;
12 	uint256 public decimals;
13 	string public symbol;
14 	address public owner;
15 
16 	mapping (address => uint256) balances;
17 	mapping (address => mapping (address => uint256)) allowed;
18 
19    constructor(uint256 _totalSupply, string _symbol, string _name, uint256 _decimals, address _owner) public {
20 		symbol = _symbol;
21 		name = _name;
22         decimals = _decimals;
23 		owner = _owner;
24         totalSupply = _totalSupply * (10 ** decimals);
25         balances[owner] = totalSupply;
26   }
27 	//Fix for short address attack against ERC20
28 	modifier onlyPayloadSize(uint size) {
29 		assert(msg.data.length == size + 4);
30 		_;
31 	} 
32 
33 	function balanceOf(address _owner) constant public returns (uint256) {
34 		return balances[_owner];
35 	}
36 
37 	function transfer(address _recipient, uint256 _value) onlyPayloadSize(2*32) public {
38 		require(balances[msg.sender] >= _value && _value >= 0);
39 	    require(balances[_recipient] + _value >= balances[_recipient]);
40 	    balances[msg.sender] -= _value;
41 	    balances[_recipient] += _value;
42 	    emit Transfer(msg.sender, _recipient, _value);        
43     }
44 
45 	function transferFrom(address _from, address _to, uint256 _value) public {
46 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
47 		require(balances[_to] + _value >= balances[_to]);
48         balances[_to] += _value;
49         balances[_from] -= _value;
50         allowed[_from][msg.sender] -= _value;
51         emit Transfer(_from, _to, _value);
52     }
53 
54 	function approve(address _spender, uint256 _value) public {
55 		allowed[msg.sender][_spender] = _value;
56 		emit Approval(msg.sender, _spender, _value);
57 	}
58 
59 	function allowance(address _owner, address _spender) constant public returns (uint256) {
60 		return allowed[_owner][_spender];
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