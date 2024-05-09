1 pragma solidity ^0.4.11;
2 
3 contract ERC20Interface {
4 	function totalSupply() constant returns (uint totalSupply);
5 	function balanceOf(address _owner) constant returns (uint balance);
6 	function transfer(address _to, uint _value) returns (bool success);
7 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
8 	function approve(address _spender, uint _value) returns (bool success);
9 	function allowance(address _owner, address _spender) constant returns (uint remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 
15 contract DeDeTokenContract is ERC20Interface {
16 // ERC20 basic variables
17 	string public constant symbol = "DEDE";
18 	string public constant name = "DeDeToken";
19 	uint8 public constant decimals = 18; // smallest unit is 10**-18, same as ether wei
20 	uint256 public _totalSupply = (25 ether) * (10 ** 7); // total dede is 2.5 * 10**8
21 
22 	mapping (address => uint) public balances;
23 	mapping (address => mapping (address => uint256)) public allowed;
24 
25 // variables for donation
26 	address public dedeNetwork;
27 	bool public installed = false;
28 
29 // constructor
30 	function DeDeTokenContract(address _dedeNetwork){
31 		require(_dedeNetwork != 0);
32 
33 		balances[_dedeNetwork] = (_totalSupply * 275) / 1000; // 27.5% of all tokens. 20% is for dedeNetwork, 7.5% is for early donators
34 		balances[this] = _totalSupply - balances[_dedeNetwork];
35 
36 		Transfer(0, _dedeNetwork, balances[_dedeNetwork]);
37 		Transfer(0, this, balances[this]);
38 
39 		dedeNetwork = _dedeNetwork;
40 	}
41 
42 	function installDonationContract(address donationContract){
43 		require(msg.sender == dedeNetwork);
44 		require(!installed);
45 
46 		installed = true;
47 
48 		allowed[this][donationContract] = balances[this];
49 		Approval(this, donationContract, balances[this]);
50 	}
51 
52 	function changeDeDeNetwork(address newDeDeNetwork){
53 		require(msg.sender == dedeNetwork);
54 		dedeNetwork = newDeDeNetwork;
55 	}
56 
57 // ERC20 FUNCTIONS
58 	//get total tokens
59 	function totalSupply() constant returns (uint totalSupply){
60 		return _totalSupply;
61 	}
62 	//get balance of user
63 	function balanceOf(address _owner) constant returns (uint balance){
64 		return balances[_owner];
65 	}
66 	//transfer tokens
67 	function transfer(address _to, uint _value) returns (bool success){
68 		if(balances[msg.sender] >= _value
69 			&& _value > 0
70 			&& balances[_to] + _value > balances[_to]){
71 			balances[msg.sender] -= _value;
72 			balances[_to] += _value;
73 			Transfer(msg.sender, _to, _value);
74 			return true;
75 		}
76 		else{
77 			return false;
78 		}
79 	}
80 	//transfer tokens if you have a delegated wallet
81 	function transferFrom(address _from, address _to, uint _value) returns (bool success){
82 		if(balances[_from] >= _value
83 			&& allowed[_from][msg.sender] >= _value
84 			&& _value > 0
85 			&& balances[_to] + _value > balances[_to]){
86 			balances[_from] -= _value;
87 			allowed[_from][msg.sender] -= _value;
88 			balances[_to] += _value;
89 			Transfer(_from, _to, _value);
90 			return true;
91 		}
92 		else{
93 			return false;
94 		}
95 	}
96 	//delegate your wallet to someone
97 	function approve(address _spender, uint _value) returns (bool success){
98 		allowed[msg.sender][_spender] = _value;
99 		Approval(msg.sender, _spender, _value);
100 		return true;
101 	}
102 	//get allowance that you can spend, from delegated wallet
103 	function allowance(address _owner, address _spender) constant returns (uint remaining){
104 		return allowed[_owner][_spender];
105 	}
106 }