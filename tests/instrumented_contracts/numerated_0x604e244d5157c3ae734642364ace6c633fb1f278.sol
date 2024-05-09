1 pragma solidity ^0.4.18;
2 
3 
4 // EthernityFinancialOracle v0.2
5 // @ethernity.live
6 
7 
8 contract Caller {
9     function EFOcallBack(string _response);
10 }
11 
12 
13 contract EthernityFinancialOracle{
14     
15     address public owner;
16     address public oracleAddress;
17     uint public collectedFee; 
18     uint public feePrice = 0.0005 ether;
19     uint public gasLimit = 50000;
20     uint public gasPrice = 40000000000 wei;
21     
22     struct User {
23     	string response;
24     	bool callBack;
25     	bool asked;
26     	uint balance;
27     	bool banned;
28     }
29 
30     mapping(address => User) public users;
31 
32     
33     modifier onlyOwner{
34         require(msg.sender == owner);
35         _;
36     }
37 
38     modifier onlyOracle{
39         require(msg.sender == oracleAddress);
40         _;
41     }
42 
43     modifier onlyOwnerOrOracle {
44     	require(msg.sender == owner || msg.sender == oracleAddress);
45     	_;
46     }
47 
48     modifier notBanned {
49         require( users[msg.sender].banned == false );
50         _;
51     }
52 
53     modifier receivePayment {
54         users[msg.sender].balance = users[msg.sender].balance + msg.value;
55         _;
56     }
57 
58     event Request (string _coin , string _againstCoin , address _address , uint _gasPrice , uint _gasLimit );
59     event Response (address _address , string _response);
60     event Error (string _error);
61     
62 
63     // Main constructor
64     function EthernityFinancialOracle() {
65         owner = msg.sender;
66         oracleAddress = msg.sender; // 0xfb509f6900d0326520c8f88e8f12c83459a199ec;
67     }   
68 
69     // Payable to receive payments and stores into the mapping through modifier
70     function () payable receivePayment {
71     }
72 
73     // REQUESTS
74     
75     function requestEtherToUSD(bool _callBack , uint _gasPrice , uint _gasLimit) payable receivePayment notBanned {
76         (_gasPrice , _gasLimit) = payToOracle (_gasPrice , _gasLimit);
77         users[msg.sender].callBack = _callBack;
78         users[msg.sender].asked = true;
79         Request ('ETH', 'USD', msg.sender , _gasPrice , _gasLimit );
80     }
81     
82     function requestCoinToUSD(string _coin , bool _callBack , uint _gasPrice , uint _gasLimit) payable receivePayment notBanned {
83     	(_gasPrice , _gasLimit) = payToOracle (_gasPrice , _gasLimit);
84         users[msg.sender].callBack = _callBack;
85         users[msg.sender].asked = true;
86         Request (_coin, 'USD', msg.sender , _gasPrice , _gasLimit );
87     }
88     
89     function requestRate(string _coin, string _againstCoin , bool _callBack , uint _gasPrice , uint _gasLimit) payable receivePayment notBanned {
90     	(_gasPrice , _gasLimit) = payToOracle (_gasPrice , _gasLimit);
91         users[msg.sender].callBack = _callBack;
92         users[msg.sender].asked = true;
93         Request (_coin, _againstCoin, msg.sender , _gasPrice , _gasLimit );
94     }
95 
96 
97     function getRefund() {
98         if (msg.sender == owner) {
99             uint a = collectedFee;
100             collectedFee = 0; 
101             require(owner.send(a));
102         } else {
103 	        uint b = users[msg.sender].balance;
104 	        users[msg.sender].balance = 0;
105 	        require(msg.sender.send(b));
106 	    	}
107     }
108 
109 
110     // GETTERS
111 
112     function getResponse() public constant returns(string _response){
113         return users[msg.sender].response;
114     }
115 
116     function getPrice(uint _gasPrice , uint _gasLimit) public constant returns(uint _price) {
117         if (_gasPrice == 0) _gasPrice = gasPrice;
118         if (_gasLimit == 0) _gasLimit = gasLimit;
119     	assert(_gasLimit * _gasPrice / _gasLimit == _gasPrice); // To avoid overflow exploitation
120     	return feePrice + _gasLimit * _gasPrice;
121     }
122 
123     function getBalance() public constant returns(uint _balance) {
124     	return users[msg.sender].balance;
125     }
126 
127     function getBalance(address _address) public constant returns(uint _balance) {
128 		return users[_address].balance;
129     }
130 
131 
132 
133     // SET RESPONSE FROM ORACLE
134     function setResponse (address _user, string _result) onlyOracle {
135 
136 		require( users[_user].asked );
137 		users[_user].asked = false;
138 
139     	if ( users[_user].callBack ) {
140     		// Callback function: passive, expensive, somewhat private
141         	Caller _caller = Caller(_user);
142         	_caller.EFOcallBack(_result);
143     		} else {
144     	// Mapping: active, cheap, public
145         users[_user].response = _result;
146         Response( _user , _result );
147     	}
148 
149     }
150 
151 
152     // INTERNAL FUNCTIONS
153 
154     function payToOracle (uint _gasPrice , uint _gasLimit) internal returns(uint _price , uint _limit) {
155         if (_gasPrice == 0) _gasPrice = gasPrice;
156         if (_gasLimit == 0) _gasLimit = gasLimit;
157 
158         uint gp = getPrice(_gasPrice,_gasLimit);
159 
160         require (users[msg.sender].balance >= gp );
161 
162         collectedFee += feePrice;
163         users[msg.sender].balance -= gp;
164 
165         require(oracleAddress.send(gp - feePrice));
166         return(_gasPrice,_gasLimit);
167     }
168 
169 
170     // ADMIN FUNCTIONS
171     
172     function changeOwner(address _newOwner) onlyOwner {
173         owner = _newOwner;
174     }
175 
176     function changeOracleAdd(address _newOracleAdd) onlyOwner {
177         oracleAddress = _newOracleAdd;
178     }
179 
180     function setFeePrice(uint _feePrice) onlyOwner {
181         feePrice = _feePrice;
182     }
183 
184     function setGasPrice(uint _gasPrice) onlyOwnerOrOracle {
185     	gasPrice = _gasPrice;
186     }
187 
188     function setGasLimit(uint _gasLimit) onlyOwnerOrOracle {
189     	gasLimit = _gasLimit;
190     }
191 
192     function emergencyFlush() onlyOwner {
193         require(owner.send(this.balance));
194     }
195 
196     function ban(address _user) onlyOwner{
197         users[_user].banned = true;
198     }
199     
200     function desBan(address _user) onlyOwner{
201         users[_user].banned = false;
202     }
203 }