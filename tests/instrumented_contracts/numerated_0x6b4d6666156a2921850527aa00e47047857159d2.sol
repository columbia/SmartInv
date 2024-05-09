1 pragma solidity ^0.4.11;
2 
3 contract ERC20Interface {
4 	function totalSupply() constant returns (uint supply);
5 	function balanceOf(address _owner) constant returns (uint balance);
6 	function transfer(address _to, uint _value) returns (bool success);
7 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
8 	function approve(address _spender, uint _value) returns (bool success);
9 	function allowance(address _owner, address _spender) constant returns (uint remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 contract DeDeMasterContract {
15 
16 	mapping (address => bool) public isDeDeContract;
17 
18 	mapping (address => uint256) public validationTime;
19 	mapping (address => address) public dip;
20 	mapping (address => address) public scs;
21 	mapping (address => address) public issuer;
22 	mapping (address => address) public targetAddress;//if address value is zero, this contract itself posesses ethereum as target.
23 	mapping (address => address) public bulletAddress;//if address value is zero, this contract itself gets ethereum as bullet.
24 	mapping (address => uint256) public targetAmount;
25 	mapping (address => uint256) public bulletAmount;
26 
27 	event Issue(address indexed dip, address indexed scs, address issuer, address indexed dedeAddress);
28 	event Transfer(address indexed from, address indexed to, address issuer, address indexed dedeAddress); // unused in current version
29 	event Activate(address indexed dip, address indexed scs, address issuer, address indexed dedeAddress);
30 	event Nullify(address indexed dip, address indexed scs, address issuer, address indexed dedeAddress);
31 
32 	address public dedeNetworkAddress;
33 
34 	function DeDeMasterContract(address _dedeNetworkAddress){
35 		dedeNetworkAddress = _dedeNetworkAddress;
36 	}
37 
38 	function changeDedeAddress(address newDedeAddress){
39 		require(msg.sender == dedeNetworkAddress);
40 		dedeNetworkAddress = newDedeAddress;
41 	}
42 
43 	function issue(uint256 _targetAmount, uint256 _bulletAmount, address _targetAddress, address _bulletAddress, uint256 _validationTime, address _issuer) payable {
44 		require(msg.sender == dedeNetworkAddress);
45 		require(now + 1 days < _validationTime);
46 		require(_targetAddress != _bulletAddress);
47 
48 		if(_targetAddress == 0){ // ether target
49 			require(msg.value >= _targetAmount);
50 			if(msg.value > _targetAmount){
51 				msg.sender.transfer(msg.value - _targetAmount);
52 			}
53 		}
54 
55 		address dede = (new DeDeContract).value(_targetAddress == 0 ? _targetAmount : 0)(_targetAddress, _targetAmount);
56 		isDeDeContract[dede] = true;
57 
58 		validationTime[dede] = _validationTime;
59 		dip[dede] = msg.sender;
60 		scs[dede] = msg.sender;
61 		issuer[dede] = _issuer;
62 		targetAddress[dede] = _targetAddress;
63 		bulletAddress[dede] = _bulletAddress;
64 		targetAmount[dede] = _targetAmount;
65 		bulletAmount[dede] = _bulletAmount;
66 
67 		if(_targetAddress != 0){ // send target token to dede
68 			assert(ERC20Interface(_targetAddress).transferFrom(msg.sender, dede, _targetAmount));
69 		}
70 
71 		Issue(msg.sender, msg.sender, _issuer, dede);
72 	}
73 	function activate(address dede) payable {
74 		var _dede = DeDeContract(dede);
75 
76 		require(isDeDeContract[dede]);
77 
78 		require(msg.sender == scs[dede]);
79 		require(now >= validationTime[dede] && now < validationTime[dede] + 1 days);
80 
81 		isDeDeContract[dede] = false;
82 
83 		Activate(dip[dede], scs[dede], issuer[dede], dede);
84 
85 		if(bulletAddress[dede] == 0){
86 			require(msg.value >= bulletAmount[dede]);
87 			if(msg.value > bulletAmount[dede]){
88 				msg.sender.transfer(msg.value - bulletAmount[dede]);
89 			}
90 		}
91 		else{
92 			assert(ERC20Interface(bulletAddress[dede]).transferFrom(scs[dede], dip[dede], bulletAmount[dede])); // send bullet token to dip
93 		}
94 
95 		if(targetAddress[dede] != 0){
96 			assert(ERC20Interface(targetAddress[dede]).transferFrom(dede, scs[dede], targetAmount[dede])); // send target token to scs
97 		}
98 		_dede.activate.value(bulletAddress[dede] == 0 ? bulletAmount[dede] : 0)(bulletAddress[dede] == 0 ? dip[dede] : scs[dede]); // send target ether to scs (or bullet ether to dip) and suicide dede
99 	}
100 	function nullify(address dede){
101 		var _dede = DeDeContract(dede);
102 
103 		require(isDeDeContract[dede]);
104 
105 		require(now >= (validationTime[dede] + 1 days) && (msg.sender == dip[dede] || msg.sender == scs[dede]));
106 
107 		isDeDeContract[dede] = false;
108 
109 		Nullify(dip[dede], scs[dede], issuer[dede], dede);
110 	
111 		if(targetAddress[dede] != 0){
112 			assert(ERC20Interface(targetAddress[dede]).transferFrom(dede, dip[dede], targetAmount[dede])); // send target token to dip
113 		}
114 		_dede.nullify(dip[dede]); // send target ether to dip and suicide dede
115 	}
116 
117 	function transfer(address receiver, address dede){ // unused in current version
118 		require(isDeDeContract[dede]);
119 
120 		require(msg.sender == scs[dede]);
121 
122 		Transfer(scs[dede], receiver, issuer[dede], dede);
123 
124 		scs[dede] = receiver;
125 	}
126 }
127 
128 
129 contract DeDeContract {
130 
131 	address public masterContract;//master smart contract address
132 
133 	function DeDeContract(address targetAddress, uint256 targetAmount) payable {
134 		masterContract = msg.sender;
135 		if(targetAddress != 0){
136 			assert(ERC20Interface(targetAddress).approve(msg.sender, targetAmount));
137 		}
138 	}
139 
140 	function activate(address destination) payable {
141 		require(msg.sender == masterContract);
142 
143 		suicide(destination);
144 	}
145 	function nullify(address destination) {
146 		require(msg.sender == masterContract);
147 
148 		suicide(destination);
149 	}
150 }