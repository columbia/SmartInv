1 contract Owned {
2 
3 	address public owner;
4 
5 	function Owned() {
6 		owner = msg.sender;
7 	}
8 
9 	modifier onlyOwner {
10 		require (msg.sender == owner);
11 		_;
12 	}
13 
14 	function transferOwnership(address newOwner) onlyOwner {
15 		owner = newOwner;
16 	}
17 }
18 
19 contract tokenRecipient { 
20 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
21 } 
22 
23 contract IERC20Token {     
24 
25 	function totalSupply() constant returns (uint256 totalSupply);
26 	function balanceOf(address _owner) constant returns (uint256 balance) {}  
27 	function transfer(address _to, uint256 _value) returns (bool success) {}
28 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
29 	function approve(address _spender, uint256 _value) returns (bool success) {}     
30     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}       
31 
32 	event Transfer(address indexed _from, address indexed _to, uint256 _value);     
33 	event Approval(address indexed _owner, address indexed _spender, uint256 _value); 
34 } 
35 
36 contract EstatiumToken is IERC20Token, Owned {
37   
38 	string public standard = "Estatium token v1.0";
39 	string public name = "Estatium";
40 	string public symbol = "EST";
41 	uint8 public decimals = 18;
42 	bool public tokenFrozen;
43    
44 	uint256 supply = 0;
45 	mapping (address => uint256) balances;
46 	mapping (address => mapping (address => uint256)) allowances;
47     address public distributor;
48       
49 	event Mint(address indexed _to, uint256 _value);
50     event Burn(address indexed _from, uint256 _value);
51 	event TokenFrozen();
52   
53 	function EstatiumToken() {
54         supply += 84000000 * 10**18;
55 		balances[msg.sender] += 84000000 * 10**18;
56 		Mint(msg.sender, 84000000 * 10**18);
57 		Transfer(0x0, msg.sender, 84000000 * 10**18);
58 	}
59   
60 	function totalSupply() constant returns (uint256 totalsupply) {
61 		return supply;
62 	}
63 
64 	function balanceOf(address _owner) constant returns (uint256 balance) {
65 		return balances[_owner];
66 	}
67 
68 	function transfer(address _to, uint256 _value) returns (bool success) {
69 		require(canSendtokens(msg.sender));
70 		require(balances[msg.sender] >= _value);
71 		require (balances[_to] + _value > balances[_to]);
72 		
73         balances[msg.sender] -= _value;
74 		balances[_to] += _value;
75 		Transfer(msg.sender, _to, _value);
76 
77 		return true;
78 	}     
79 
80 	function approve(address _spender, uint256 _value) returns (bool success) {
81 		require(canSendtokens(msg.sender));
82 		allowances[msg.sender][_spender] = _value;
83 		Approval(msg.sender, _spender, _value);
84 		return true;
85 	}
86 
87 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
88 		tokenRecipient spender = tokenRecipient(_spender);
89 		approve(_spender, _value);
90 		spender.receiveApproval(msg.sender, _value, this, _extraData);
91 		return true;
92 	}
93    
94 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
95 		require(canSendtokens(msg.sender));  
96 		require (balances[_from] >= _value);
97 		require (balances[_to] + _value > balances[_to]);
98 		require (_value <= allowances[_from][msg.sender]);
99 
100 		balances[_from] -= _value;
101 		balances[_to] += _value;
102 		allowances[_from][msg.sender] -= _value;
103 		Transfer(_from, _to, _value);
104 
105 		return true;
106 	}
107   
108 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
109 		return allowances[_owner][_spender];
110 	}
111 
112 	function freezeTransfers() onlyOwner {
113 		tokenFrozen = !tokenFrozen;
114 		TokenFrozen();
115 	}
116 
117 	function setDistributorAddress(address _newDistributorAddress) onlyOwner {
118 		distributor = _newDistributorAddress;
119 	}
120 
121     function burn(uint _value) {
122         require (balances[msg.sender] >= _value);
123         require(canSendtokens(msg.sender));
124 
125         balances[msg.sender] -= _value;
126         supply -= _value;
127         Transfer(msg.sender, 0x0, _value);
128         Burn(msg.sender, _value);
129     }
130 
131     function canSendtokens(address _sender) internal constant returns (bool) {
132         if (_sender == distributor || _sender == owner) {
133             return true;
134         }else {
135             if (!tokenFrozen) {
136                 return true;
137             }
138         }
139         return false;
140     }
141 }