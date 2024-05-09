1 pragma solidity ^0.4.11;
2 
3 contract ERC20Standard {
4 	
5 	mapping (address => uint256) balances;
6 	mapping (address => mapping (address => uint)) allowed;
7 
8 	//Fix for short address attack against ERC20
9 	modifier onlyPayloadSize(uint size) {
10 		assert(msg.data.length == size + 4);
11 		_;
12 	} 
13 
14 	function balanceOf(address _owner) public constant returns (uint balance) {
15 	    return balances[_owner];
16 	}
17 
18 	function transfer(address _recipient, uint _value) onlyPayloadSize(2*32) public {
19 		require(balances[msg.sender] >= _value && _value > 0);
20 	    balances[msg.sender] -= _value;
21 	    balances[_recipient] += _value;
22 	    Transfer(msg.sender, _recipient, _value);        
23     }
24 
25 	function transferFrom(address _from, address _to, uint _value) public {
26 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
27         balances[_to] += _value;
28         balances[_from] -= _value;
29         allowed[_from][msg.sender] -= _value;
30         Transfer(_from, _to, _value);
31     }
32 
33 	function approve(address _spender, uint _value) public {
34 		allowed[msg.sender][_spender] = _value;
35 		Approval(msg.sender, _spender, _value);
36 	}
37 
38 	function allowance(address _spender, address _owner) public constant returns (uint balance) {
39 		return allowed[_owner][_spender];
40 	}
41 
42 	//Event which is triggered to log all transfers to this contract's event log
43 	event Transfer(
44 		address indexed _from,
45 		address indexed _to,
46 		uint _value
47 		);
48 		
49 	//Event is triggered whenever an owner approves a new allowance for a spender.
50 	event Approval(
51 		address indexed _owner,
52 		address indexed _spender,
53 		uint _value
54 		);
55 
56 }
57 
58 contract WEBcoin is ERC20Standard {
59 	string public name = "WEBCoin";
60 	uint8 public decimals = 18;
61 	string public symbol = "WEB";
62 	uint public totalSupply = 21000000;
63 	    
64 	function WEBcoin() {
65 	    balances[msg.sender] = totalSupply;
66 	}
67 }