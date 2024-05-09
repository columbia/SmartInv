1 /*
2 Copyright 2018 DeDev Pte Ltd
3 
4 Author : Chongsoo Chung (Jones Chung), CEO of DeDev in Seoul, South Korea
5  */
6 
7 pragma solidity ^0.4.20;
8 
9 contract ERC20Interface {
10 	function totalSupply() constant returns (uint supply);
11 	function balanceOf(address _owner) constant returns (uint balance);
12 	function transfer(address _to, uint _value) returns (bool success);
13 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
14 	function approve(address _spender, uint _value) returns (bool success);
15 	function allowance(address _owner, address _spender) constant returns (uint remaining);
16 	event Transfer(address indexed _from, address indexed _to, uint _value);
17 	event Approval(address indexed _owner, address indexed _spender, uint _value);
18 }
19 
20 contract Love is ERC20Interface {
21 	// ERC20 basic variables
22 	string public constant symbol = "LOVE";
23 	string public constant name = "LoveToken";
24 	uint8 public constant decimals = 0;
25 	uint256 public constant _totalSupply = (10 ** 10);
26 	mapping (address => uint) public balances;
27 	mapping (address => mapping (address => uint256)) public allowed;
28 
29 	mapping (address => uint256) public tokenSaleAmount;
30 	uint256 public saleStartEpoch;
31 	uint256 public tokenSaleLeft = 7 * (10 ** 9);
32 	uint256 public tokenAirdropLeft = 3 * (10 ** 9);
33 
34 	uint256 public constant tokenSaleLowerLimit = 10 finney;
35 	uint256 public constant tokenSaleUpperLimit = 1 ether;
36 	uint256 public constant tokenExchangeRate = (10 ** 8); // 100m LOVE for each ether
37 	uint256 public constant devReward = 18; // in percent
38 
39 	address private constant saleDepositAddress = 0x6969696969696969696969696969696969696969;
40 	address private constant airdropDepositAddress = 0x7474747474747474747474747474747474747474;
41 
42 	address public devAddress;
43 	address public ownerAddress;
44 
45 // constructor
46 	function Love(address _ownerAddress, address _devAddress, uint256 _saleStartEpoch) public {
47 		require(_ownerAddress != 0);
48 		require(_devAddress != 0);
49 		require(_saleStartEpoch > now);
50 
51 		balances[saleDepositAddress] = tokenSaleLeft;
52 		balances[airdropDepositAddress] = tokenAirdropLeft;
53 
54 		ownerAddress = _ownerAddress;
55 		devAddress = _devAddress;
56 		saleStartEpoch = _saleStartEpoch;
57 	}
58 
59 	function sendAirdrop(address[] to, uint256[] value) public {
60 		require(msg.sender == ownerAddress);
61 		require(to.length == value.length);
62 		for(uint256 i = 0; i < to.length; i++){
63 			if(tokenAirdropLeft > value[i]){
64 				Transfer(airdropDepositAddress, to[i], value[i]);
65 
66 				balances[to[i]] += value[i];
67 				balances[airdropDepositAddress] -= value[i];
68 				tokenAirdropLeft -= value[i];
69 			}
70 			else{
71 				Transfer(airdropDepositAddress, to[i], tokenAirdropLeft);
72 
73 				balances[to[i]] += tokenAirdropLeft;
74 				balances[airdropDepositAddress] -= tokenAirdropLeft;
75 				tokenAirdropLeft = 0;
76 				break;
77 			}
78 		}
79 	}
80 
81 	function buy() payable public {
82 		require(tokenSaleLeft > 0);
83 		require(msg.value + tokenSaleAmount[msg.sender] <= tokenSaleUpperLimit);
84 		require(msg.value >= tokenSaleLowerLimit);
85 		require(now >= saleStartEpoch);
86 		require(msg.value >= 1 ether / tokenExchangeRate);
87 
88 		if(msg.value * tokenExchangeRate / 1 ether > tokenSaleLeft){
89 			Transfer(saleDepositAddress, msg.sender, tokenSaleLeft);
90 
91 			uint256 changeAmount = msg.value - tokenSaleLeft * 1 ether / tokenExchangeRate;
92 			balances[msg.sender] += tokenSaleLeft;
93 			balances[saleDepositAddress] -= tokenSaleLeft;
94 			tokenSaleAmount[msg.sender] += msg.value - changeAmount;
95 			tokenSaleLeft = 0;
96 			msg.sender.transfer(changeAmount);
97 
98 			ownerAddress.transfer((msg.value - changeAmount) * (100 - devReward) / 100);
99 			devAddress.transfer((msg.value - changeAmount) * devReward / 100);
100 		}
101 		else{
102 			Transfer(saleDepositAddress, msg.sender, msg.value * tokenExchangeRate / 1 ether);
103 
104 			balances[msg.sender] += msg.value * tokenExchangeRate / 1 ether;
105 			balances[saleDepositAddress] -= msg.value * tokenExchangeRate / 1 ether;
106 			tokenSaleAmount[msg.sender] += msg.value;
107 			tokenSaleLeft -= msg.value * tokenExchangeRate / 1 ether;
108 
109 			ownerAddress.transfer(msg.value * (100 - devReward) / 100);
110 			devAddress.transfer(msg.value * devReward / 100);
111 		}
112 	}
113 
114 // fallback function : send request to donate
115 	function () payable public {
116 		buy();
117 	}
118 
119 
120 // ERC20 FUNCTIONS
121 	//get total tokens
122 	function totalSupply() constant returns (uint supply){
123 		return _totalSupply;
124 	}
125 	//get balance of user
126 	function balanceOf(address _owner) constant returns (uint balance){
127 		return balances[_owner];
128 	}
129 	//transfer tokens
130 	function transfer(address _to, uint _value) returns (bool success){
131 		if(balances[msg.sender] < _value)
132 			return false;
133 		balances[msg.sender] -= _value;
134 		balances[_to] += _value;
135 		Transfer(msg.sender, _to, _value);
136 		return true;
137 	}
138 	//transfer tokens if you have been delegated a wallet
139 	function transferFrom(address _from, address _to, uint _value) returns (bool success){
140 		if(balances[_from] >= _value
141 			&& allowed[_from][msg.sender] >= _value
142 			&& _value >= 0
143 			&& balances[_to] + _value > balances[_to]){
144 			balances[_from] -= _value;
145 			allowed[_from][msg.sender] -= _value;
146 			balances[_to] += _value;
147 			Transfer(_from, _to, _value);
148 			return true;
149 		}
150 		else{
151 			return false;
152 		}
153 	}
154 	//delegate your wallet to someone, usually to a smart contract
155 	function approve(address _spender, uint _value) returns (bool success){
156 		allowed[msg.sender][_spender] = _value;
157 		Approval(msg.sender, _spender, _value);
158 		return true;
159 	}
160 	//get allowance that you can spend, from delegated wallet
161 	function allowance(address _owner, address _spender) constant returns (uint remaining){
162 		return allowed[_owner][_spender];
163 	}
164 	
165 	function change_owner(address new_owner){
166 	    require(msg.sender == ownerAddress);
167 	    ownerAddress = new_owner;
168 	}
169 	function change_dev(address new_dev){
170 	    require(msg.sender == devAddress);
171 	    devAddress = new_dev;
172 	}
173 }