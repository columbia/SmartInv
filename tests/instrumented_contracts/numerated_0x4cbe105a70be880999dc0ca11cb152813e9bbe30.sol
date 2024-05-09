1 pragma solidity ^0.5.0;
2 
3 contract ZoeCoin {
4     
5 	uint public totalSupply;
6 	
7 	string public name;
8 	uint256 public decimals;
9 	string public symbol;
10 	
11 	mapping (address => uint256) balances;
12 	mapping (address => mapping (address => uint256)) allowed;
13 	
14 	constructor() public {
15 		totalSupply = 10000000000000000;
16 		name = "ZOE Coin";
17 		decimals = 8;
18 		symbol = "ZOE";
19 		balances[msg.sender] = totalSupply;
20 	}
21 	
22 	//Fix for short address attack against ERC20
23 	modifier onlyPayloadSize(uint size) {
24 		assert(msg.data.length == size + 4);
25 		_;
26 	} 
27 
28 	function balanceOf(address _owner) public view returns (uint balance) {
29 		return balances[_owner];
30 	}
31 
32 	function transfer(address _recipient, uint _value) public onlyPayloadSize(2*32) {
33 		require(balances[msg.sender] >= _value && _value > 0);
34 	    balances[msg.sender] -= _value;
35 	    balances[_recipient] += _value;
36 	    emit Transfer(msg.sender, _recipient, _value);        
37     }
38 
39 	function transferFrom(address _from, address _to, uint _value) public {
40 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
41         balances[_to] += _value;
42         balances[_from] -= _value;
43         allowed[_from][msg.sender] -= _value;
44         emit Transfer(_from, _to, _value);
45     }
46     
47     function burn(uint _value) public returns (bool success) {
48         require(balances[msg.sender] >= _value &&  _value > 0);
49         balances[msg.sender] -= _value;
50         totalSupply -= _value;
51         emit Burn(msg.sender, _value);
52         return true;
53     }
54 
55 	function approve(address _spender, uint _value) public {
56 	    require(_value > 0); 
57 		allowed[msg.sender][_spender] = _value;
58 		emit Approval(msg.sender, _spender, _value);
59 	}
60 
61 	function allowance(address _spender, address _owner) public view returns (uint balance) {
62 		return allowed[_owner][_spender];
63 	}
64 	
65 	//Event which is triggered to log all transfers to this contract's event log
66 	event Transfer(address indexed _from, address indexed _to, uint _value);
67 		
68 	//Event which is triggered whenever an owner approves a new allowance for a spender.
69 	event Approval(address indexed _owner,	address indexed _spender, uint _value);
70 	
71 	//Event which is triggered to notifies clients about the amount burnt.
72 	event Burn(address indexed _from, uint value);
73 }