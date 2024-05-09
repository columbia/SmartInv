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
11   struct Payment {
12     address sender;
13     address payable receiver;
14     uint256 timestamp;
15     uint256 time;
16     uint256 weiValue;
17     uint256 weiPaid;
18     bool isFork;
19     uint256 parentIndex;
20     bool isForked;
21     uint256 fork1Index;
22     uint256 fork2Index;
23   }
24 
25   Payment[] public payments;
26 
27   event PaymentUpdated(uint256 index);
28   event PaymentCreated(uint256 index);
29 
30   mapping(address => mapping (address => bool)) public delegates;
31 
32   /**
33    * Change whether _delegate can settle and fork payments on behalf of
34    * msg.sender.
35    **/
36   function delegate(address _delegate, bool delegated) public {
37     delegates[msg.sender][_delegate] = delegated;
38   }
39 
40   /**
41    * Pay from sender to receiver a certain amount over a certain amount of time.
42    **/
43   function paymentCreate(address payable _receiver, uint256 _time) public payable {
44     // Verify that value has been sent
45     require(msg.value > 0);
46     // Verify the time is non-zero
47     require(_time > 0);
48     payments.push(Payment({
49       sender: msg.sender,
50       receiver: _receiver,
51       timestamp: block.timestamp,
52       time: _time,
53       weiValue: msg.value,
54       weiPaid: 0,
55       isFork: false,
56       parentIndex: 0,
57       isForked: false,
58       fork1Index: 0,
59       fork2Index: 0
60     }));
61     emit PaymentCreated(payments.length - 1);
62   }
63 
64   /**
65    * Settle an individual payment at the current point in time.
66    *
67    * Transfers the owedWei at the current point in time to the receiving
68    * address.
69    **/
70   function paymentSettle(uint256 index) public {
71     requirePaymentIndexInRange(index);
72     Payment storage payment = payments[index];
73     requireExecutionAllowed(payment.receiver);
74     uint256 owedWei = paymentWeiOwed(index);
75     payment.weiPaid += owedWei;
76     payment.receiver.transfer(owedWei);
77     emit PaymentUpdated(index);
78   }
79 
80   /**
81    * Return the wei owed on a payment at the current block timestamp.
82    **/
83   function paymentWeiOwed(uint256 index) public view returns (uint256) {
84     requirePaymentIndexInRange(index);
85     Payment memory payment = payments[index];
86     // Calculate owed wei based on current time and total wei owed/paid
87     return max(payment.weiPaid, payment.weiValue * min(block.timestamp - payment.timestamp, payment.time) / payment.time) - payment.weiPaid;
88   }
89 
90   /**
91    * Forks a payment to another address for the remaining duration of a payment.
92    * Allows responsibility of funds to be delegated to other addresses by
93    * payment recipient or a delegate.
94    *
95    * Payment completion time is unaffected by forking, the only thing that
96    * changes is recipient(s).
97    *
98    * Payments can be forked until weiValue is 0, at which point the Payment is
99    * settled. Child payments can also be forked.
100    *
101    * The genealogy of a payment can be represented as a binary tree.
102    **/
103   function paymentFork(uint256 index, address payable _receiver, uint256 _weiValue) public {
104     requirePaymentIndexInRange(index);
105     Payment storage payment = payments[index];
106     // Make sure the payment receiver or a delegate is operating
107     requireExecutionAllowed(payment.receiver);
108 
109     uint256 remainingWei = payment.weiValue - payment.weiPaid;
110     uint256 remainingTime = max(0, payment.time - (block.timestamp - payment.timestamp));
111 
112     // Ensure there is more remainingWei than requested fork wei
113     require(remainingWei > _weiValue);
114     require(_weiValue > 0);
115 
116     // Create a new Payment of _weiValue to _receiver over the remaining time of
117     // payment at index
118     payment.weiValue = payment.weiPaid;
119     emit PaymentUpdated(index);
120 
121     payments.push(Payment({
122       sender: payment.receiver,
123       receiver: _receiver,
124       timestamp: block.timestamp,
125       time: remainingTime,
126       weiValue: _weiValue,
127       weiPaid: 0,
128       isFork: true,
129       parentIndex: index,
130       isForked: false,
131       fork1Index: 0,
132       fork2Index: 0
133     }));
134     payment.fork1Index = payments.length - 1;
135     emit PaymentCreated(payments.length - 1);
136 
137     payments.push(Payment({
138       sender: payment.receiver,
139       receiver: payment.receiver,
140       timestamp: block.timestamp,
141       time: remainingTime,
142       weiValue: remainingWei - _weiValue,
143       weiPaid: 0,
144       isFork: true,
145       parentIndex: index,
146       isForked: false,
147       fork1Index: 0,
148       fork2Index: 0
149     }));
150     payment.fork2Index = payments.length - 1;
151     emit PaymentCreated(payments.length - 1);
152 
153     payment.isForked = true;
154   }
155 
156   /**
157    * Accessor for determining if a given payment is fully settled.
158    **/
159   function isPaymentSettled(uint256 index) public view returns (bool) {
160     requirePaymentIndexInRange(index);
161     return payments[index].weiValue == payments[index].weiPaid;
162   }
163 
164   /**
165    * Reverts if the supplied payment index is out of range.
166    **/
167   function requirePaymentIndexInRange(uint256 index) public view {
168     require(index < payments.length);
169   }
170 
171   /**
172    * Checks if msg.sender is allowed to modify payments on behalf of receiver.
173    **/
174   function requireExecutionAllowed(address payable receiver) public view {
175     require(msg.sender == receiver || delegates[receiver][msg.sender] == true);
176   }
177 
178   /**
179    * Accessor for array length.
180    **/
181   function paymentCount() public view returns (uint) {
182     return payments.length;
183   }
184 
185   /**
186    * Return the smaller of two values.
187    **/
188   function min(uint a, uint b) private pure returns (uint) {
189     return a < b ? a : b;
190   }
191 
192   /**
193    * Return the larger of two values.
194    **/
195   function max(uint a, uint b) private pure returns (uint) {
196     return a > b ? a : b;
197   }
198 }