1 pragma solidity ^0.4.11;
2 
3 contract ERC20Standard {
4 	uint public totalSupply;
5 	
6 	string public name;
7 	uint8 public decimals;
8 	string public symbol;
9 	string public version;
10 	
11 	mapping (address => uint256) balances;
12 	mapping (address => mapping (address => uint)) allowed;
13 
14 	modifier onlyPayloadSize(uint size) {
15 		assert(msg.data.length == size + 4);
16 		_;
17 	} 
18 
19 	function balanceOf(address _owner) constant returns (uint balance) {
20 		return balances[_owner];
21 	}
22 
23 	function transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {
24 		require(balances[msg.sender] >= _value && _value > 0);
25 	    balances[msg.sender] -= _value;
26 	    balances[_recipient] += _value;
27 	    Transfer(msg.sender, _recipient, _value);        
28     }
29 
30 	function transferFrom(address _from, address _to, uint _value) {
31 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
32         balances[_to] += _value;
33         balances[_from] -= _value;
34         allowed[_from][msg.sender] -= _value;
35         Transfer(_from, _to, _value);
36     }
37 
38 	function approve(address _spender, uint _value) {
39 		allowed[msg.sender][_spender] = _value;
40 		Approval(msg.sender, _spender, _value);
41 	}
42 
43 	function allowance(address _spender, address _owner) constant returns (uint balance) {
44 		return allowed[_owner][_spender];
45 	}
46 
47 	event Transfer(
48 		address indexed _from,
49 		address indexed _to,
50 		uint _value
51 		);
52 		
53 	event Approval(
54 		address indexed _owner,
55 		address indexed _spender,
56 		uint _value
57 		);
58 
59 }
60 
61 
62 contract NewToken is ERC20Standard {
63 	function NewToken() {
64 		totalSupply = 100000000000000;
65 		name = "Infinity Network Solutions";
66 		decimals = 4;
67 		symbol = "INS";
68 		version = "1.0";
69 		balances[msg.sender] = totalSupply;
70 	}
71 }