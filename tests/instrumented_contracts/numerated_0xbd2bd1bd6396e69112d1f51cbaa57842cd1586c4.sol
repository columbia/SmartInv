1 pragma solidity ^0.4.0;
2 
3 contract GameEthContractV1{
4 
5 address owner;
6 mapping (address => uint256) deposits;
7 mapping (address => uint256) totalPaid;
8 mapping (address => uint256) paydates;
9 mapping (address => uint256) notToPay;
10 
11 uint minWei = 40000000000000000; // default 0.04 ether
12 uint secInDay = 86400; // min payment step 1 day (in seconds)
13 uint gasForPayout = 50000; // gas used for payout
14 uint lastBlockTime;
15 uint inCommission = 3; // deposit commission 3%
16 
17 event DepositIn(
18         address indexed _from,
19         uint256 _value,
20         uint256 _date
21     );
22     
23 event PayOut(
24         address indexed _from,
25         uint256 _value,
26         uint256 _date
27     );
28     
29 
30 constructor(address _owner) public {
31 	owner = _owner; 
32 	lastBlockTime = now;
33 }
34 
35 // Payable method, payouts for message sender
36 function () public payable{
37  	require(now >= lastBlockTime && msg.value >= minWei); // last block time < block.timestamp, check min deposit
38  	lastBlockTime = now; // set last block time to block.timestamp
39  	uint256 com = msg.value/100*inCommission; // 3% commission
40  	uint256 amount = msg.value - com; // deposit amount is amount - commission
41  	if (deposits[msg.sender] > 0){
42  		// repeating payment
43  		uint256 daysGone = (now - paydates[msg.sender]) / secInDay;	// days gone before this payment, and not included in next payout
44  		notToPay[msg.sender] += amount/100*daysGone; // keep amount that does not have to be paid 
45  	}else{
46  		// new payment 
47  		paydates[msg.sender] = now; // set paydate to block.timestamp
48  	}
49     deposits[msg.sender] += amount; // update deposit amount
50     emit DepositIn(msg.sender, msg.value, now); // emit deposit in event
51     owner.transfer(com); // transfer commission to contract owner
52 }
53 
54 // Payable method, payout will be paid to specific address
55 function  depositForRecipent(address payoutAddress) public  payable{
56  	require(now >= lastBlockTime && msg.value >= minWei); // last block time < block.timestamp, check min deposit
57  	lastBlockTime = now; // set last block time to block.timestamp
58  	uint256 com = msg.value/100*inCommission; // 3% commission
59  	uint256 amount = msg.value - com; // deposit amount is amount - commission
60  	if (deposits[payoutAddress] > 0){
61  		// repeating payment
62  		uint256 daysGone = (now - paydates[payoutAddress]) / secInDay;	// days gone before this payment, and not included in next payout
63  		notToPay[payoutAddress] += amount/100*daysGone; // keep amount that does not have to be paid 
64  	}else{
65  		// new payment
66  		paydates[payoutAddress] = now; // set paydate to block.timestamp
67  	}
68     deposits[payoutAddress] += amount; // update deposit amount
69     emit DepositIn(payoutAddress, msg.value, now); // emit deposit in event
70     owner.transfer(com); // transfer commission to contract owner
71 }
72 
73 // transfer ownership
74 function transferOwnership(address newOwnerAddress) public {
75 	require (msg.sender == owner); // check function called by contract owner
76 	owner = newOwnerAddress;
77 }
78 
79 
80 // function used by client direct calls, for direct contract interaction, gas paid by function caller in this case
81 function payOut() public {
82 		require(deposits[msg.sender] > 0); // check is message sender deposited an funds
83 		require(paydates[msg.sender] < now); // check is lastPayDate < block.timestamp 
84 		uint256 payForDays = (now - paydates[msg.sender]) / secInDay; // days from last payment
85         require(payForDays >= 30);
86 		pay(msg.sender,false,payForDays); // don't withdraw tx gass fee, because fee paid by function caller
87 }
88 
89 // function used by contrcat owner for automatic payouts from representative site
90 // gas price paid by contract owner and because of that gasPrice will be withdrawn from payout amount
91 function payOutFor(address _recipient) public {
92 		require(msg.sender == owner && deposits[_recipient] > 0); // check is message sender is contract owner and recipients was deposited funds
93 		require(paydates[_recipient] < now); // check is lastPayDate < block.timestamp
94 		uint256 payForDays = (now - paydates[_recipient]) / secInDay; // days from last payment
95         require(payForDays >= 30); 
96 		pay(_recipient, true,payForDays); // pay with withdraw tx gas fee because fee paid by contract owner
97 }
98 
99 
100 function pay(address _recipient, bool calcGasPrice,uint256 payForDays) private {
101         uint256 payAmount = 0;
102         payAmount = deposits[_recipient]/100*payForDays - notToPay[_recipient]; // calculate payout one percent per day - amount that does not have to be paid
103         if (payAmount >= address(this).balance){
104         	payAmount = address(this).balance;
105         }
106         assert(payAmount > 0); // check is pay amount > 0 and payAmount <= contract balance 
107         if (calcGasPrice){
108         	// if calcGasPrice calculate tx gas price to cover transaction fee
109         	uint256 com = gasForPayout * tx.gasprice; // fixed gas per tx * tx.gasprice
110         	assert(com < payAmount);   // commission must be < pay amount
111         	payAmount = payAmount - com; // remaining pay amount = pay amount - commission
112         	owner.transfer(com); // withdraw tx gas fee to contract owner
113         }
114         paydates[_recipient] = now; // update last pay date to block.timestamp
115         _recipient.transfer(payAmount); // transfer funds to recipient
116         totalPaid[_recipient] += payAmount; // update total paid amount
117         notToPay[_recipient] = 0; // clear not to pay amount
118         emit PayOut(_recipient, payAmount, now);  // emit event
119 }
120 
121 
122 
123 function totalDepositOf(address _sender) public constant returns (uint256 deposit) {
124         return deposits[_sender];
125 }
126 
127 function lastPayDateOf(address _sender) public constant returns (uint256 secFromEpoch) {
128         return paydates[_sender];
129 }
130 
131 function totalPaidOf(address _sender) public constant returns (uint256 paid) {
132         return totalPaid[_sender];
133 }
134 
135 }