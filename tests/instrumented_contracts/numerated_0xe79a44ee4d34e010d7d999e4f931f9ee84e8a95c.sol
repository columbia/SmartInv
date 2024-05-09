1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20Standard {
5 	uint public totalSupply;
6 	
7 	string public name;
8 	uint8 public decimals;
9 	string public symbol;
10 	string public version;
11 	
12 	mapping (address => uint256) balances;
13 	mapping (address => mapping (address => uint)) allowed;
14 
15 	//Fix for short address attack against ERC20
16 	modifier onlyPayloadSize(uint size) {
17 		assert(msg.data.length == size + 4);
18 		_;
19 	} 
20 
21 	function balanceOf(address _owner) constant returns (uint balance) {
22 		return balances[_owner];
23 	}
24 
25 	function transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {
26 		require(balances[msg.sender] >= _value && _value > 0);
27 	    balances[msg.sender] -= _value;
28 	    balances[_recipient] += _value;
29 	    Transfer(msg.sender, _recipient, _value);        
30     }
31 
32 	function transferFrom(address _from, address _to, uint _value) {
33 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
34         balances[_to] += _value;
35         balances[_from] -= _value;
36         allowed[_from][msg.sender] -= _value;
37         Transfer(_from, _to, _value);
38     }
39 
40 	function approve(address _spender, uint _value) {
41 		allowed[msg.sender][_spender] = _value;
42 		Approval(msg.sender, _spender, _value);
43 	}
44 
45 	function allowance(address _spender, address _owner) constant returns (uint balance) {
46 		return allowed[_owner][_spender];
47 	}
48 
49 	//Event which is triggered to log all transfers to this contract's event log
50 	event Transfer(
51 		address indexed _from,
52 		address indexed _to,
53 		uint _value
54 		);
55 		
56 	//Event which is triggered whenever an owner approves a new allowance for a spender.
57 	event Approval(
58 		address indexed _owner,
59 		address indexed _spender,
60 		uint _value
61 		);
62 
63 }
64 
65 contract Whales_group is ERC20Standard {
66 	function Whales_group() {
67 		totalSupply = 1000000000*10**8;
68 		name = "Whales group";
69 		decimals = 8;
70 		symbol = "WHL";
71 		version = "1.0";
72 		balances[msg.sender] = totalSupply;
73 	}
74 }