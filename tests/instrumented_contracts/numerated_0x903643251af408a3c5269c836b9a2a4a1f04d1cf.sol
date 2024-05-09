1 pragma solidity ^0.4.18;
2 
3 
4 contract SysEscrow {
5 
6     address public owner;
7     address arbitrator;
8 
9     uint public MinDeposit = 600000000000000000; // 0.6 Ether
10 
11     uint constant ARBITRATOR_PERCENT = 1; //1%
12 
13     struct Escrow {
14             // Set so we know the trade has already been created
15             bool exists;        
16         
17             address seller;
18             address buyer;
19             uint summ;
20             uint buyerCanCancelAfter;
21             bool buyerApprovedTheTransaction;
22             bool arbitratorStopTransaction;
23     }
24 
25     // Mapping of active trades. Key is a hash of the trade data
26     mapping (bytes32 => Escrow) public escrows;
27 
28 
29     modifier onlyOwner() {
30         require(tx.origin == owner);
31         _;
32     }
33 
34 
35     function SysEscrow() {
36         owner = msg.sender;
37         arbitrator = msg.sender;
38     }
39 
40 
41 function createEscrow(
42       /**
43        * Create a new escrow and add it to `escrows`.
44        * _tradeHash is created by hashing _tradeID, _seller, _buyer, _value and _fee variables. These variables must be supplied on future contract calls.
45        * v, r and s is the signature data supplied from the api. The sig is keccak256(_tradeHash, _paymentWindowInSeconds, _expiry).
46        */
47       bytes16 _tradeID, // The unique ID of the trade
48       address _seller, // The selling party of the trade
49       address _buyer, // The buying party of the trade
50 
51       uint _paymentWindowInSeconds // The time in seconds from Escrow creation that the buyer can return money
52     ) payable external {
53         uint256 _value = msg.value;
54         require(_value>=MinDeposit);
55         bytes32 _tradeHash = keccak256(_tradeID, _seller, _buyer, _value);
56         require(!escrows[_tradeHash].exists); // Require that trade does not already exist
57         uint _buyerCanCancelAfter =  now + _paymentWindowInSeconds;
58         escrows[_tradeHash] = Escrow(true, _seller, _buyer, _value, _buyerCanCancelAfter, false, false);
59 
60     }    
61 
62 
63 
64     function setArbitrator( address _newArbitrator ) onlyOwner {
65         /**
66          * Set the arbitrator to a new address. Only the owner can call this.
67          * @param address _newArbitrator
68          */
69         arbitrator = _newArbitrator;
70     }
71 
72     function setOwner(address _newOwner) onlyOwner external {
73         /**
74          * Change the owner to a new address. Only the owner can call this.
75          * @param address _newOwner
76          */
77         owner = _newOwner;
78     }
79 
80 
81     function cancelEscrow(
82       /**
83        * Cancel escrow. Return money to buyer
84        */
85       bytes16 _tradeID, // The unique ID of the trade
86       address _seller, // The selling party of the trade
87       address _buyer, // The buying party of the trade
88       uint256 _value // 
89     )  external {
90         
91         bytes32 _tradeHash = keccak256(_tradeID, _seller, _buyer, _value);
92         require(escrows[_tradeHash].exists);
93         require(escrows[_tradeHash].buyerCanCancelAfter<now);
94         
95         uint256 arbitratorValue = escrows[_tradeHash].summ*ARBITRATOR_PERCENT/100;
96         uint256 buyerValue =  escrows[_tradeHash].summ - arbitratorValue;
97         
98         bool buyerReceivedMoney = escrows[_tradeHash].buyer.call.value(buyerValue)();
99         bool arbitratorReceivedMoney = arbitrator.call.value(arbitratorValue)();
100         
101         if ( buyerReceivedMoney && arbitratorReceivedMoney )
102         {    
103             delete escrows[_tradeHash];
104         } else {
105             throw;
106         }
107 
108     }
109     
110     function approveEscrow(
111       /**
112        * Approve escrow. 
113        */
114       bytes16 _tradeID, // The unique ID of the trade
115       address _seller, // The selling party of the trade
116       address _buyer, // The buying party of the trade
117       uint256 _value // Trade value
118     )  external {
119         bytes32 _tradeHash = keccak256(_tradeID, _seller, _buyer, _value);
120         require(escrows[_tradeHash].exists);
121         require(escrows[_tradeHash].buyer==msg.sender);
122         escrows[_tradeHash].buyerApprovedTheTransaction = true;
123     }
124     
125     
126     function releaseEscrow(
127       /**
128        * Release escrow. Send money to seller
129        */
130       bytes16 _tradeID, // The unique ID of the trade
131       address _seller, // The selling party of the trade
132       address _buyer, // The buying party of the trade
133       uint256 _value // Trade value
134     )  external {
135         
136         bytes32 _tradeHash = keccak256(_tradeID, _seller, _buyer, _value);
137         require(escrows[_tradeHash].exists);
138         require(escrows[_tradeHash].buyerApprovedTheTransaction);
139         
140         
141         uint256 arbitratorValue = escrows[_tradeHash].summ*ARBITRATOR_PERCENT/100;
142         uint256 buyerValue =  escrows[_tradeHash].summ - arbitratorValue;
143         
144         bool sellerReceivedMoney = escrows[_tradeHash].seller.call.value(buyerValue)();
145         bool arbitratorReceivedMoney = arbitrator.call.value(arbitratorValue)();
146         
147         if ( sellerReceivedMoney && arbitratorReceivedMoney )
148         {    
149             delete escrows[_tradeHash];
150         } else {
151             throw;
152         }
153 
154     }
155         
156     
157     
158     function isExistsEscrow(
159       bytes16 _tradeID, // The unique ID of the trade
160       address _seller, // The selling party of the trade
161       address _buyer, // The buying party of the trade
162       uint256 _value // Trade value
163     )  constant returns (bool es)  { 
164         bytes32 _tradeHash = keccak256(_tradeID, _seller, _buyer, _value);
165         return escrows[_tradeHash].exists; 
166         
167     }
168 }