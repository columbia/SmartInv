1 pragma solidity 		^0.4.8	;						
2 									
3 contract	Ownable		{						
4 									
5 	address	owner	;						
6 									
7 	function	Ownable	() {						
8 		owner	= msg.sender;						
9 	}								
10 									
11 	modifier	onlyOwner	() {						
12 		require(msg.sender ==		owner	);				
13 		_;							
14 	}								
15 									
16 	function 	transfertOwnership		(address	newOwner	)	onlyOwner	{	
17 		owner	=	newOwner	;				
18 	}								
19 }									
20 									
21 									
22 									
23 contract	Algo_Exchange_Index_I				is	Ownable	{		
24 									
25 	string	public	constant	name =	"	ALGOEXINDEX		"	;
26 	string	public	constant	symbol =	"	AEII		"	;
27 	uint32	public	constant	decimals =		8			;
28 	uint	public		totalSupply =		0			;
29 									
30 	mapping (address => uint) balances;								
31 	mapping (address => mapping(address => uint)) allowed;								
32 									
33 	function mint(address _to, uint _value) onlyOwner {								
34 		assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);							
35 		balances[_to] += _value;							
36 		totalSupply += _value;							
37 	}								
38 									
39 	function balanceOf(address _owner) constant returns (uint balance) {								
40 		return balances[_owner];							
41 	}								
42 									
43 	function transfer(address _to, uint _value) returns (bool success) {								
44 		if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {							
45 			balances[msg.sender] -= _value; 						
46 			balances[_to] += _value;						
47 			return true;						
48 		}							
49 		return false;							
50 	}								
51 									
52 	function transferFrom(address _from, address _to, uint _value) returns (bool success) {								
53 		if( allowed[_from][msg.sender] >= _value &&							
54 			balances[_from] >= _value 						
55 			&& balances[_to] + _value >= balances[_to]) {						
56 			allowed[_from][msg.sender] -= _value;						
57 			balances[_from] -= _value;						
58 			balances[_to] += _value;						
59 			Transfer(_from, _to, _value);						
60 			return true;						
61 		}							
62 		return false;							
63 	}								
64 									
65 	function approve(address _spender, uint _value) returns (bool success) {								
66 		allowed[msg.sender][_spender] = _value;							
67 		Approval(msg.sender, _spender, _value);							
68 		return true;							
69 	}								
70 									
71 	function allowance(address _owner, address _spender) constant returns (uint remaining) {								
72 		return allowed[_owner][_spender];							
73 	}								
74 									
75 	event Transfer(address indexed _from, address indexed _to, uint _value);								
76 	event Approval(address indexed _owner, address indexed _spender, uint _value);								
77 }