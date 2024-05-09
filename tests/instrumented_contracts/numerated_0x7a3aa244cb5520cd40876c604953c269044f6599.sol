1 pragma solidity ^0.4.21;
2 
3 contract NewToken {
4 	uint public totalSupply = 2300000000000000;
5 	
6 	string public name = "TTInvest";
7 	uint8 public decimals = 8;
8 	string public symbol = "TTInvest";
9 	string public version = "1.0";
10 
11 function NewToken(){
12   balances[msg.sender] = 2300000000000000;
13 }
14 
15 	mapping (address => uint256) balances;
16 	mapping (address => mapping (address => uint)) allowed;
17 
18 	//Fix for short address attack against ERC20
19 	modifier onlyPayloadSize(uint size) {
20 		assert(msg.data.length == size + 4);
21 		_;
22 	} 
23 
24 	function balanceOf(address _owner) constant returns (uint balance) {
25 		return balances[_owner];
26 	}
27 
28 	function transfer(address _recipient, uint _value) onlyPayloadSize(2*32) {
29 		require(balances[msg.sender] >= _value && _value > 0);
30 	    balances[msg.sender] -= _value;
31 	    balances[_recipient] += _value;
32 	    Transfer(msg.sender, _recipient, _value);        
33     }
34 
35 	function transferFrom(address _from, address _to, uint _value) {
36 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
37         balances[_to] += _value;
38         balances[_from] -= _value;
39         allowed[_from][msg.sender] -= _value;
40         Transfer(_from, _to, _value);
41     }
42 
43 	function approve(address _spender, uint _value) {
44 		allowed[msg.sender][_spender] = _value;
45 		Approval(msg.sender, _spender, _value);
46 	}
47 
48 	function allowance(address _spender, address _owner) constant returns (uint balance) {
49 		return allowed[_owner][_spender];
50 	}
51 
52 	//Event which is triggered to log all transfers to this contract's event log
53 	event Transfer(
54 		address indexed _from,
55 		address indexed _to,
56 		uint _value
57 		);
58 		
59 	//Event which is triggered whenever an owner approves a new allowance for a spender.
60 	event Approval(
61 		address indexed _owner,
62 		address indexed _spender,
63 		uint _value
64 		);
65 
66 }