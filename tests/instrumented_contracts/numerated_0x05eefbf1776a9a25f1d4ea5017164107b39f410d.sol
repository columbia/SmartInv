1 pragma solidity 		^0.4.8	;						
2 									
3 contract	Ownable		{						
4 	address	owner	;						
5 									
6 	function	Ownable	() {						
7 		owner	= msg.sender;						
8 	}								
9 									
10 	modifier	onlyOwner	() {						
11 		require(msg.sender ==		owner	);				
12 		_;							
13 	}								
14 									
15 	function 	transfertOwnership		(address	newOwner	)	onlyOwner	{	
16 		owner	=	newOwner	;				
17 	}								
18 }									
19 									
20 									
21 									
22 contract	EuroSibEnergo_TCI_IX_20181220				is	Ownable	{		
23 									
24 	string	public	constant	name =	"	EuroSibEnergo_TCI_IX_20181220		"	;
25 	string	public	constant	symbol =	"	ESETCIIX		"	;
26 	uint32	public	constant	decimals =		18			;
27 	uint	public		totalSupply =		0			;
28 									
29 	mapping (address => uint) balances;								
30 	mapping (address => mapping(address => uint)) allowed;								
31 									
32 	function mint(address _to, uint _value) onlyOwner {								
33 		assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);							
34 		balances[_to] += _value;							
35 		totalSupply += _value;							
36 	}								
37 									
38 	function balanceOf(address _owner) constant returns (uint balance) {								
39 		return balances[_owner];							
40 	}								
41 									
42 	function transfer(address _to, uint _value) returns (bool success) {								
43 		if(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {							
44 			balances[msg.sender] -= _value; 						
45 			balances[_to] += _value;						
46 			return true;						
47 		}							
48 		return false;							
49 	}								
50 									
51 	function transferFrom(address _from, address _to, uint _value) returns (bool success) {								
52 		if( allowed[_from][msg.sender] >= _value &&							
53 			balances[_from] >= _value 						
54 			&& balances[_to] + _value >= balances[_to]) {						
55 			allowed[_from][msg.sender] -= _value;						
56 			balances[_from] -= _value;						
57 			balances[_to] += _value;						
58 			Transfer(_from, _to, _value);						
59 			return true;						
60 		}							
61 		return false;							
62 	}								
63 									
64 	function approve(address _spender, uint _value) returns (bool success) {								
65 		allowed[msg.sender][_spender] = _value;							
66 		Approval(msg.sender, _spender, _value);							
67 		return true;							
68 	}								
69 									
70 	function allowance(address _owner, address _spender) constant returns (uint remaining) {								
71 		return allowed[_owner][_spender];							
72 	}								
73 									
74 	event Transfer(address indexed _from, address indexed _to, uint _value);								
75 	event Approval(address indexed _owner, address indexed _spender, uint _value);								
76 }