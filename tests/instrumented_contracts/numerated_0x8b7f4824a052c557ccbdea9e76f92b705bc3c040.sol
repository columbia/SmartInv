1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function add(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a + b;
6     assert(c >= a);
7     return c;
8   }
9 
10   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     return a / b;
27   }
28 }
29 
30 contract RakuRakuEth {
31   using SafeMath for uint256;
32 
33   enum Status {
34     Pending,
35     Requested,
36     Canceled,
37     Paid,
38     Rejected
39   }
40   
41   struct Payment {
42     uint256 amountJpy;
43     uint256 amountWei;
44     uint256 rateEthJpy;
45     uint256 paymentDue;
46     uint256 requestedTime;
47     Status status; //0: pending, 1: requested, 2: canceled, 3: paid, 4: rejected
48   }
49   
50   address public owner;
51   address public creditor;
52   address public debtor;
53   uint256 ethWei = 10**18;
54 
55   Payment[] payments;
56   mapping (address => uint256) balances;
57   
58   modifier onlyCreditor() {
59     require(msg.sender == creditor);
60     _;
61   }
62   
63   modifier onlyDebtor() {
64     require(msg.sender == debtor);
65     _;
66   }
67   
68   modifier onlyStakeholders() {
69     require(msg.sender == debtor || msg.sender == creditor);
70     _;
71   }
72 
73   constructor (address _creditor, address _debtor) public {
74     owner = msg.sender;
75     creditor = _creditor;
76     debtor = _debtor;
77   }
78   
79   // Public Function (anyone can call)
80   function getCurrentTimestamp () external view returns (uint256 timestamp) {
81     return block.timestamp;
82   }
83 
84   function collectPayment(uint256 _index) external returns (bool) {
85     require(payments[_index].status == Status.Requested);
86     require(payments[_index].requestedTime + 24*60*60 < block.timestamp);
87     require(balances[debtor] >= payments[_index].amountWei);
88     balances[debtor] = balances[debtor].sub(payments[_index].amountWei);
89     balances[creditor] = balances[creditor].add(payments[_index].amountWei);
90     payments[_index].status = Status.Paid;
91     return true;
92   }
93   
94   // Function for stakeholders (debtor or creditor)
95   function getBalance(address _address) external view returns (uint256 balance) {
96     return balances[_address];
97   }
98   
99   function getPayment(uint256 _index) external view returns (uint256 amountJpy, uint256 amountWei, uint256 rateEthJpy, uint256 paymentDue, uint256 requestedTime, Status status) {
100     Payment memory pm = payments[_index];
101     return (pm.amountJpy, pm.amountWei, pm.rateEthJpy, pm.paymentDue, pm.requestedTime, pm.status);
102   }
103   
104   function getNumPayments() external view returns (uint256 num) {
105     return payments.length;
106   }
107   
108   function withdraw(uint256 _amount) external returns (bool) {
109     require(balances[msg.sender] >= _amount);
110     msg.sender.transfer(_amount);
111     balances[msg.sender] = balances[msg.sender].sub(_amount);
112     return true;
113   }
114   
115   // Functions for creditor
116   function addPayment(uint256 _amountJpy, uint256 _paymentDue) external onlyCreditor returns (uint256 index) {
117     payments.push(Payment(_amountJpy, 0, 0, _paymentDue, 0, Status.Pending));
118     return payments.length-1;
119   }
120   
121   function requestPayment(uint256 _index, uint256 _rateEthJpy) external onlyCreditor returns (bool) {
122     require(payments[_index].status == Status.Pending || payments[_index].status == Status.Rejected);
123     require(payments[_index].paymentDue <= block.timestamp);
124     payments[_index].rateEthJpy = _rateEthJpy;
125     payments[_index].amountWei = payments[_index].amountJpy.mul(ethWei).div(_rateEthJpy);
126     payments[_index].requestedTime = block.timestamp;
127     payments[_index].status = Status.Requested;
128     return true;
129   }
130   
131   function cancelPayment(uint256 _index) external onlyCreditor returns (bool) {
132     require(payments[_index].status != Status.Paid);
133     payments[_index].status = Status.Canceled;
134     return true;
135   }
136 
137   // Function for debtor
138   function () external payable onlyDebtor {
139     balances[msg.sender] = balances[msg.sender].add(msg.value);
140   }
141   
142   function rejectPayment(uint256 _index) external onlyDebtor returns (bool) {
143     require(payments[_index].status == Status.Requested);
144     require(payments[_index].requestedTime + 24*60*60 > block.timestamp);
145     payments[_index].status = Status.Rejected;
146     return true;
147   }
148   
149   function approvePayment(uint256 _index) external onlyDebtor returns (bool) {
150     require(payments[_index].status == Status.Requested);
151     require(balances[debtor] >= payments[_index].amountWei);
152     balances[debtor] = balances[debtor].sub(payments[_index].amountWei);
153     balances[creditor] = balances[creditor].add(payments[_index].amountWei);
154     payments[_index].status = Status.Paid;
155     return true;
156   }
157 
158 }