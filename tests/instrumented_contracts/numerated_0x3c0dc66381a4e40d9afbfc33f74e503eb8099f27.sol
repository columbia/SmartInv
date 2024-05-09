1 pragma solidity ^0.5.0;
2 
3 /**
4  * The Syndicate contract
5  *
6  * A way for distributed groups of people to work together and come to consensus
7  * on use of funds.
8  *
9  * syndicate - noun
10  * a group of individuals or syndicates combined to promote some common interest
11  **/
12 
13 contract Syndicate {
14 
15   mapping (address => uint256) public balances;
16 
17   struct Payment {
18     address sender;
19     address payable receiver;
20     uint256 timestamp;
21     uint256 time;
22     uint256 weiValue;
23     uint256 weiPaid;
24   }
25 
26   Payment[] public payments;
27 
28   event PaymentUpdated(uint256 index);
29   event PaymentCreated(uint256 index);
30 
31   /**
32    * Deposit to a given address over a certain amount of time.
33    **/
34   function deposit(address payable _receiver, uint256 _time) external payable {
35     balances[msg.sender] += msg.value;
36     pay(_receiver, msg.value, _time);
37   }
38 
39   /**
40    * Pay from sender to receiver a certain amount over a certain amount of time.
41    **/
42   function pay(address payable _receiver, uint256 _weiValue, uint256 _time) public {
43     // Verify that the balance is there and value is non-zero
44     require(_weiValue <= balances[msg.sender] && _weiValue > 0);
45     // Verify the time is non-zero
46     require(_time > 0);
47     payments.push(Payment({
48       sender: msg.sender,
49       receiver: _receiver,
50       timestamp: block.timestamp,
51       time: _time,
52       weiValue: _weiValue,
53       weiPaid: 0
54     }));
55     // Update the balance value of the sender to effectively lock the funds in place
56     balances[msg.sender] -= _weiValue;
57     emit PaymentCreated(payments.length - 1);
58   }
59 
60   /**
61    * Settle an individual payment at the current point in time.
62    *
63    * Can be called idempotently.
64    **/
65   function paymentSettle(uint256 index) public {
66     uint256 owedWei = paymentWeiOwed(index);
67     balances[payments[index].receiver] += owedWei;
68     payments[index].weiPaid += owedWei;
69     emit PaymentUpdated(index);
70   }
71 
72   /**
73    * Return the wei owed on a payment at the current block timestamp.
74    **/
75   function paymentWeiOwed(uint256 index) public view returns (uint256) {
76     assertPaymentIndexInRange(index);
77     Payment memory payment = payments[index];
78     // Calculate owed wei based on current time and total wei owed/paid
79     return payment.weiValue * min(block.timestamp - payment.timestamp, payment.time) / payment.time - payment.weiPaid;
80   }
81 
82   /**
83    * Accessor for determining if a given payment is fully settled.
84    **/
85   function isPaymentSettled(uint256 index) public view returns (bool) {
86     assertPaymentIndexInRange(index);
87     Payment memory payment = payments[index];
88     return payment.weiValue == payment.weiPaid;
89   }
90 
91   /**
92    * Reverts if the supplied payment index is out of range
93    **/
94   function assertPaymentIndexInRange(uint256 index) public view {
95     require(index < payments.length);
96   }
97 
98   /**
99    * Withdraw target address balance from Syndicate to ether.
100    **/
101   function withdraw(address payable target, uint256 weiValue) public {
102     require(balances[target] >= weiValue);
103     balances[target] -= weiValue;
104     target.transfer(weiValue);
105   }
106 
107   /**
108    * One argument, target address.
109    **/
110   function withdraw(address payable target) public {
111     withdraw(target, balances[target]);
112   }
113 
114   /**
115    * No arguments, withdraws full balance to sender from sender balance.
116    **/
117   function withdraw() public {
118     withdraw(msg.sender, balances[msg.sender]);
119   }
120 
121   /**
122    * Accessor for array length
123    **/
124   function paymentCount() public view returns (uint) {
125     return payments.length;
126   }
127 
128   /**
129    * Return the smaller of two values.
130    **/
131   function min(uint a, uint b) private pure returns (uint) {
132     return a < b ? a : b;
133   }
134 }