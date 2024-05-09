1 pragma solidity ^0.5.0;
2 
3 /**
4  * Syndicate
5  **/
6 
7 /// @title A way to distribute ownership of Ether in time
8 /// @author Chance Hudson
9 /// @notice This contract can be used to manipulate ownership of Ether across
10 /// time. Funds are linearly distributed over the time period to recipients.
11 contract Syndicate {
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
25   mapping(uint256 => uint256[]) public paymentForks;
26 
27   event PaymentUpdated(uint256 index);
28   event PaymentCreated(uint256 index);
29 
30   /// @notice Create a payment from `msg.sender` of amount `msg.value` to
31   /// `_receiver` over `_time` seconds. The funds are linearly distributed in
32   /// this time. The `_receiver` may fork the funds to another address but
33   /// cannot manipulate the `_time` value.
34   /// @param _receiver The address receiving the payment
35   /// @param _time The payment time length, in seconds
36   function paymentCreate(address payable _receiver, uint256 _time) public payable {
37     // Verify that value has been sent
38     require(msg.value > 0);
39     // Verify the time is non-zero
40     require(_time > 0);
41     payments.push(Payment({
42       sender: msg.sender,
43       receiver: _receiver,
44       timestamp: block.timestamp,
45       time: _time,
46       weiValue: msg.value,
47       weiPaid: 0,
48       isFork: false,
49       parentIndex: 0
50     }));
51     paymentForks[payments.length - 1] = new uint256[](0);
52     emit PaymentCreated(payments.length - 1);
53   }
54 
55   /// @notice Withdraws the available funds at the current point in time from a
56   /// payment to the receiver address.
57   /// @dev May be invoked by anyone idempotently.
58   /// @param index The payment index to settle
59   function paymentSettle(uint256 index) public {
60     requirePaymentIndexInRange(index);
61     Payment storage payment = payments[index];
62     uint256 owedWei = paymentWeiOwed(index);
63     payment.weiPaid += owedWei;
64     payment.receiver.transfer(owedWei);
65     emit PaymentUpdated(index);
66   }
67 
68   /// @notice Calculates the amount of wei owed on a payment at the current
69   /// `block.timestamp`.
70   /// @param index The payment index for which to determine wei owed
71   /// @return The wei owed at the current point in time
72   function paymentWeiOwed(uint256 index) public view returns (uint256) {
73     requirePaymentIndexInRange(index);
74     Payment memory payment = payments[index];
75     // Calculate owed wei based on current time and total wei owed/paid
76     return max(payment.weiPaid, payment.weiValue * min(block.timestamp - payment.timestamp, payment.time) / payment.time) - payment.weiPaid;
77   }
78 
79   /// @notice Forks part of a payment to another address for the remaining time
80   /// on a payment. Allows responsibility of funds to be delegated to other
81   /// addresses by the payment recipient. A payment and all forks share the same
82   /// completion time.
83   /// @dev Payments may only be forked by the receiver address. The `_weiValue`
84   /// being forked must be less than the wei currently available in the payment.
85   /// @param index The payment index to be forked
86   /// @param _receiver The fork payment recipient
87   /// @param _weiValue The amount of wei to fork
88   function paymentFork(uint256 index, address payable _receiver, uint256 _weiValue) public {
89     requirePaymentIndexInRange(index);
90     Payment storage payment = payments[index];
91     // Make sure the payment receiver is operating
92     require(msg.sender == payment.receiver);
93 
94     uint256 remainingWei = payment.weiValue - payment.weiPaid;
95     uint256 remainingTime = max(0, payment.time - (block.timestamp - payment.timestamp));
96 
97     // Ensure there is more remainingWei than requested fork wei
98     require(remainingWei > _weiValue);
99     require(_weiValue > 0);
100 
101     // Create a new Payment of _weiValue to _receiver over the remaining time of
102     // payment at index
103 
104     payment.weiValue -= _weiValue;
105 
106     // Now create the forked payment
107     payments.push(Payment({
108       sender: payment.receiver,
109       receiver: _receiver,
110       timestamp: block.timestamp,
111       time: remainingTime,
112       weiValue: _weiValue,
113       weiPaid: 0,
114       isFork: true,
115       parentIndex: index
116     }));
117     uint256 forkIndex = payments.length - 1;
118     paymentForks[forkIndex] = new uint256[](0);
119     paymentForks[index].push(forkIndex);
120     emit PaymentUpdated(index);
121     emit PaymentCreated(forkIndex);
122   }
123 
124   /// @notice Accessor for determining if a given payment has any forks.
125   /// @param index The payment to check
126   /// @return Whether payment `index` has been forked
127   function isPaymentForked(uint256 index) public view returns (bool) {
128     requirePaymentIndexInRange(index);
129     return paymentForks[index].length > 0;
130   }
131 
132   /// @notice Accessor for payment fork count.
133   /// @param index The payment for which to get the fork count
134   /// @return The number of time payment `index` has been forked
135   function paymentForkCount(uint256 index) public view returns (uint256) {
136     requirePaymentIndexInRange(index);
137     return paymentForks[index].length;
138   }
139 
140   /// @notice Accessor for determining if a payment is settled.
141   /// @param index The payment to check
142   /// @return Whether a payment has been fully paid
143   function isPaymentSettled(uint256 index) public view returns (bool) {
144     requirePaymentIndexInRange(index);
145     return payments[index].weiValue == payments[index].weiPaid;
146   }
147 
148   /// @dev Throws if `index` is out of range.
149   /// @param index The payment index to check
150   function requirePaymentIndexInRange(uint256 index) public view {
151     require(index < payments.length);
152   }
153 
154   /// @notice Accessor for payments array length.
155   /// @return The number of payments that exist in the Syndicate
156   function paymentCount() public view returns (uint) {
157     return payments.length;
158   }
159 
160   /// @dev Return the smaller of two values.
161   function min(uint a, uint b) private pure returns (uint) {
162     return a < b ? a : b;
163   }
164 
165   /// @dev Return the larger of two values.
166   function max(uint a, uint b) private pure returns (uint) {
167     return a > b ? a : b;
168   }
169 }