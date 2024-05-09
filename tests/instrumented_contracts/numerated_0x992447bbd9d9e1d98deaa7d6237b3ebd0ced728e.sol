1 pragma solidity ^0.5.0;
2 
3 /**
4  * Syndicate
5  *
6  * A way to distribute ownership of ether in time
7  **/
8 
9 contract Syndicate {
10 
11   mapping (address => uint256) public balances;
12 
13   struct Payment {
14     address sender;
15     address payable receiver;
16     uint256 timestamp;
17     uint256 time;
18     uint256 weiValue;
19     uint256 weiPaid;
20     bool isFork;
21     uint256 parentIndex;
22   }
23 
24   Payment[] public payments;
25 
26   // A mapping of Payment index to forked payments that have been created
27   mapping (uint256 => uint256[2]) public forkIndexes;
28 
29   event PaymentUpdated(uint256 index);
30   event PaymentCreated(uint256 index);
31   event BalanceUpdated(address payable target);
32 
33   /**
34    * Deposit to a given address over a certain amount of time.
35    **/
36   function deposit(address payable _receiver, uint256 _time) external payable {
37     balances[msg.sender] += msg.value;
38     emit BalanceUpdated(msg.sender);
39     pay(_receiver, msg.value, _time);
40   }
41 
42   /**
43    * Pay from sender to receiver a certain amount over a certain amount of time.
44    **/
45   function pay(address payable _receiver, uint256 _weiValue, uint256 _time) public {
46     // Verify that the balance is there and value is non-zero
47     require(_weiValue <= balances[msg.sender] && _weiValue > 0);
48     // Verify the time is non-zero
49     require(_time > 0);
50     payments.push(Payment({
51       sender: msg.sender,
52       receiver: _receiver,
53       timestamp: block.timestamp,
54       time: _time,
55       weiValue: _weiValue,
56       weiPaid: 0,
57       isFork: false,
58       parentIndex: 0
59     }));
60     // Update the balance value of the sender to effectively lock the funds in place
61     balances[msg.sender] -= _weiValue;
62     emit BalanceUpdated(msg.sender);
63     emit PaymentCreated(payments.length - 1);
64   }
65 
66   /**
67    * Settle an individual payment at the current point in time.
68    *
69    * Can be called idempotently.
70    **/
71   function paymentSettle(uint256 index) public {
72     uint256 owedWei = paymentWeiOwed(index);
73     balances[payments[index].receiver] += owedWei;
74     emit BalanceUpdated(payments[index].receiver);
75     payments[index].weiPaid += owedWei;
76     emit PaymentUpdated(index);
77   }
78 
79   /**
80    * Return the wei owed on a payment at the current block timestamp.
81    **/
82   function paymentWeiOwed(uint256 index) public view returns (uint256) {
83     assertPaymentIndexInRange(index);
84     Payment memory payment = payments[index];
85     // Calculate owed wei based on current time and total wei owed/paid
86     return max(payment.weiPaid, payment.weiValue * min(block.timestamp - payment.timestamp, payment.time) / payment.time) - payment.weiPaid;
87   }
88 
89   /**
90    * Forks a payment to another address for the duration of a payment. Allows
91    * responsibility of funds to be delegated to other addresses by payment
92    * recipient.
93    *
94    * Payment completion time is unaffected by forking, the only thing that
95    * changes is recipient.
96    *
97    * Payments can be forked until weiValue is 0, at which point the Payment is
98    * settled. Child payments can also be forked.
99    **/
100   function paymentFork(uint256 index, address payable _receiver, uint256 _weiValue) public {
101     Payment memory payment = payments[index];
102     // Make sure the payment owner is operating
103     require(msg.sender == payment.receiver);
104 
105     uint256 remainingWei = payment.weiValue - payment.weiPaid;
106     uint256 remainingTime = max(0, payment.time - (block.timestamp - payment.timestamp));
107 
108     // Ensure there is enough unsettled wei in the payment
109     require(remainingWei >= _weiValue);
110     require(_weiValue > 0);
111 
112     // Create a new Payment of _weiValue to _receiver over the remaining time of
113     // Payment at index
114     payments[index].weiValue = payments[index].weiPaid;
115     emit PaymentUpdated(index);
116 
117     payments.push(Payment({
118       sender: msg.sender,
119       receiver: _receiver,
120       timestamp: block.timestamp,
121       time: remainingTime,
122       weiValue: _weiValue,
123       weiPaid: 0,
124       isFork: true,
125       parentIndex: index
126     }));
127     forkIndexes[index][0] = payments.length - 1;
128     emit PaymentCreated(payments.length - 1);
129 
130     payments.push(Payment({
131       sender: payment.receiver,
132       receiver: payment.receiver,
133       timestamp: block.timestamp,
134       time: remainingTime,
135       weiValue: remainingWei - _weiValue,
136       weiPaid: 0,
137       isFork: true,
138       parentIndex: index
139     }));
140     forkIndexes[index][1] = payments.length - 1;
141     emit PaymentCreated(payments.length - 1);
142   }
143 
144   function paymentForkIndexes(uint256 index) public view returns (uint256[2] memory) {
145     assertPaymentIndexInRange(index);
146     return forkIndexes[index];
147   }
148 
149   function isPaymentForked(uint256 index) public view returns (bool) {
150     assertPaymentIndexInRange(index);
151     return forkIndexes[index][0] != 0 && forkIndexes[index][1] != 0;
152   }
153 
154   /**
155    * Accessor for determining if a given payment is fully settled.
156    **/
157   function isPaymentSettled(uint256 index) public view returns (bool) {
158     assertPaymentIndexInRange(index);
159     Payment memory payment = payments[index];
160     return payment.weiValue == payment.weiPaid;
161   }
162 
163   /**
164    * Reverts if the supplied payment index is out of range
165    **/
166   function assertPaymentIndexInRange(uint256 index) public view {
167     require(index < payments.length);
168   }
169 
170   /**
171    * Withdraw target address balance from Syndicate to ether.
172    **/
173   function withdraw(address payable target, uint256 weiValue) public {
174     require(balances[target] >= weiValue);
175     balances[target] -= weiValue;
176     emit BalanceUpdated(target);
177     target.transfer(weiValue);
178   }
179 
180   /**
181    * One argument, target address.
182    **/
183   function withdraw(address payable target) public {
184     withdraw(target, balances[target]);
185   }
186 
187   /**
188    * No arguments, withdraws full balance to sender from sender balance.
189    **/
190   function withdraw() public {
191     withdraw(msg.sender, balances[msg.sender]);
192   }
193 
194   /**
195    * Accessor for array length
196    **/
197   function paymentCount() public view returns (uint) {
198     return payments.length;
199   }
200 
201   /**
202    * Return the smaller of two values.
203    **/
204   function min(uint a, uint b) private pure returns (uint) {
205     return a < b ? a : b;
206   }
207 
208   /**
209    * Return the larger of two values.
210    **/
211   function max(uint a, uint b) private pure returns (uint) {
212     return a > b ? a : b;
213   }
214 }