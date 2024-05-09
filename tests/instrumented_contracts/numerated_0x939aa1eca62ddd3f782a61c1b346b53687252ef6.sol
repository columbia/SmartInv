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
22     bool isForked;
23     uint256 fork1Index;
24     uint256 fork2Index;
25   }
26 
27   Payment[] public payments;
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
58       parentIndex: 0,
59       isForked: false,
60       fork1Index: 0,
61       fork2Index: 0
62     }));
63     // Update the balance value of the sender to effectively lock the funds in place
64     balances[msg.sender] -= _weiValue;
65     emit BalanceUpdated(msg.sender);
66     emit PaymentCreated(payments.length - 1);
67   }
68 
69   /**
70    * Settle an individual payment at the current point in time.
71    *
72    * Can be called idempotently.
73    **/
74   function paymentSettle(uint256 index) public {
75     uint256 owedWei = paymentWeiOwed(index);
76     balances[payments[index].receiver] += owedWei;
77     emit BalanceUpdated(payments[index].receiver);
78     payments[index].weiPaid += owedWei;
79     emit PaymentUpdated(index);
80   }
81 
82   /**
83    * Return the wei owed on a payment at the current block timestamp.
84    **/
85   function paymentWeiOwed(uint256 index) public view returns (uint256) {
86     requirePaymentIndexInRange(index);
87     Payment memory payment = payments[index];
88     // Calculate owed wei based on current time and total wei owed/paid
89     return max(payment.weiPaid, payment.weiValue * min(block.timestamp - payment.timestamp, payment.time) / payment.time) - payment.weiPaid;
90   }
91 
92   /**
93    * Forks a payment to another address for the duration of a payment. Allows
94    * responsibility of funds to be delegated to other addresses by payment
95    * recipient.
96    *
97    * Payment completion time is unaffected by forking, the only thing that
98    * changes is recipient(s).
99    *
100    * Payments can be forked until weiValue is 0, at which point the Payment is
101    * settled. Child payments can also be forked.
102    *
103    * The genealogy of a payment can be represented as a binary tree.
104    **/
105   function paymentFork(uint256 index, address payable _receiver, uint256 _weiValue) public {
106     Payment memory payment = payments[index];
107     // Make sure the payment owner is operating
108     require(msg.sender == payment.receiver);
109 
110     uint256 remainingWei = payment.weiValue - payment.weiPaid;
111     uint256 remainingTime = max(0, payment.time - (block.timestamp - payment.timestamp));
112 
113     // Ensure there is more remainingWei than requested fork wei
114     require(remainingWei > _weiValue);
115     require(_weiValue > 0);
116 
117     // Create a new Payment of _weiValue to _receiver over the remaining time of
118     // Payment at index
119     payments[index].weiValue = payments[index].weiPaid;
120     emit PaymentUpdated(index);
121 
122     payments.push(Payment({
123       sender: msg.sender,
124       receiver: _receiver,
125       timestamp: block.timestamp,
126       time: remainingTime,
127       weiValue: _weiValue,
128       weiPaid: 0,
129       isFork: true,
130       parentIndex: index,
131       isForked: false,
132       fork1Index: 0,
133       fork2Index: 0
134     }));
135     payments[index].fork1Index = payments.length - 1;
136     emit PaymentCreated(payments.length - 1);
137 
138     payments.push(Payment({
139       sender: payment.receiver,
140       receiver: payment.receiver,
141       timestamp: block.timestamp,
142       time: remainingTime,
143       weiValue: remainingWei - _weiValue,
144       weiPaid: 0,
145       isFork: true,
146       parentIndex: index,
147       isForked: false,
148       fork1Index: 0,
149       fork2Index: 0
150     }));
151     payments[index].fork2Index = payments.length - 1;
152     emit PaymentCreated(payments.length - 1);
153 
154     payments[index].isForked = true;
155   }
156 
157   /**
158    * Accessor for determining if a given payment is fully settled.
159    **/
160   function isPaymentSettled(uint256 index) public view returns (bool) {
161     requirePaymentIndexInRange(index);
162     return payments[index].weiValue == payments[index].weiPaid;
163   }
164 
165   /**
166    * Reverts if the supplied payment index is out of range.
167    **/
168   function requirePaymentIndexInRange(uint256 index) public view {
169     require(index < payments.length);
170   }
171 
172   /**
173    * Withdraw target address balance from Syndicate to ether.
174    **/
175   function withdraw(address payable target, uint256 weiValue) public {
176     require(balances[target] >= weiValue);
177     balances[target] -= weiValue;
178     emit BalanceUpdated(target);
179     target.transfer(weiValue);
180   }
181 
182   /**
183    * One argument, target address.
184    **/
185   function withdraw(address payable target) public {
186     withdraw(target, balances[target]);
187   }
188 
189   /**
190    * No arguments, withdraws full balance to sender from sender balance.
191    **/
192   function withdraw() public {
193     withdraw(msg.sender, balances[msg.sender]);
194   }
195 
196   /**
197    * Accessor for array length.
198    **/
199   function paymentCount() public view returns (uint) {
200     return payments.length;
201   }
202 
203   /**
204    * Return the smaller of two values.
205    **/
206   function min(uint a, uint b) private pure returns (uint) {
207     return a < b ? a : b;
208   }
209 
210   /**
211    * Return the larger of two values.
212    **/
213   function max(uint a, uint b) private pure returns (uint) {
214     return a > b ? a : b;
215   }
216 }