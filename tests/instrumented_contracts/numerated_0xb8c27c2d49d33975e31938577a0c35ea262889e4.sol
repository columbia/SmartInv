1 pragma solidity ^0.4.24;
2 
3 
4 contract DaiInterface {
5     function transferFrom(address src, address dst, uint wad) public returns (bool);
6 }
7 
8 
9 contract DaiTransferrer {
10 
11     address daiAddress = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
12     DaiInterface daiContract = DaiInterface(daiAddress);
13 
14     function transferDai(address _src, address _dst, uint _dai) internal {
15         require(daiContract.transferFrom(_src, _dst, _dai));
16     }
17 }
18 
19 
20 /**
21  * @title SafeMath
22  * @dev + and - operations with safety checks that revert on error
23  */
24 library SafeMath {
25     /**
26     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
27     */
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         require(b <= a);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 
35     /**
36     * @dev Adds two numbers, reverts on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a);
41 
42         return c;
43     }
44 }
45 
46 
47 /**
48  * @title SafeMath64
49  * @dev + and - operations with safety checks that revert on error for uint64
50  */
51 library SafeMath64 {
52     /**
53     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
54     */
55     function sub(uint64 a, uint64 b) internal pure returns (uint64) {
56         require(b <= a);
57         uint64 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63     * @dev Adds two numbers, reverts on overflow.
64     */
65     function add(uint64 a, uint64 b) internal pure returns (uint64) {
66         uint64 c = a + b;
67         require(c >= a);
68 
69         return c;
70     }
71 }
72 
73 
74 contract ScorchablePayments is DaiTransferrer {
75 
76     using SafeMath for uint256;
77     using SafeMath64 for uint64;
78 
79     struct Payment {
80         address payer;
81         address payee;
82         uint amount;
83         uint payeeBondAmount;
84         uint payerInactionTimeout;
85         uint listIndex;
86         bool payeeBondPaid;
87         bool isEthPayment;
88     }
89 
90     uint64[] public paymentIds;
91     uint64 public currentId = 1;
92     mapping(uint64 => Payment) public payments;
93     address public scorchAddress = 0x0;
94 
95     modifier onlyPayer(uint64 paymentId) {
96         require(msg.sender == payments[paymentId].payer);
97         _;
98     }
99 
100     modifier onlyPayee(uint64 paymentId) {
101         require(msg.sender == payments[paymentId].payee);
102         _;
103     }
104 
105     function createPayment(
106         address payee,
107         uint amountToPay,
108         uint payeeBondAmount,
109         uint payerInactionTimeout,
110         bool isEthPayment
111     )
112     external
113     payable
114     {
115         transferTokens(msg.sender, address(this), amountToPay, isEthPayment);
116         require(payerInactionTimeout < now.add(27 weeks));
117         payments[currentId] = Payment(
118             msg.sender,
119             payee,
120             amountToPay,
121             payeeBondAmount,
122             payerInactionTimeout,
123             paymentIds.push(currentId).sub(1),
124             payeeBondAmount == 0,
125             isEthPayment
126         );
127         currentId = currentId.add(1);
128     }
129 
130     function cancelPayment(uint64 paymentId) external onlyPayer(paymentId) {
131         require(payments[paymentId].payeeBondPaid == false);
132         transferTokens(
133             address(this),
134             msg.sender,
135             payments[paymentId].amount,
136             payments[paymentId].isEthPayment
137         );
138         _deletePayment(paymentId);
139     }
140 
141     function payBond(
142         uint64 paymentId
143     )
144     external
145     payable
146     {
147         require(payments[paymentId].payeeBondPaid == false);
148         transferTokens(
149             msg.sender,
150             address(this),
151             payments[paymentId].payeeBondAmount,
152             payments[paymentId].isEthPayment
153         );
154         payments[paymentId].amount = payments[paymentId].amount.add(payments[paymentId].payeeBondAmount);
155         payments[paymentId].payeeBondPaid = true;
156     }
157 
158     function returnTokensToSender(uint64 paymentId, uint amount) external onlyPayee(paymentId) {
159         require(amount <= payments[paymentId].amount);
160         transferTokens(address(this), payments[paymentId].payer, amount, payments[paymentId].isEthPayment);
161         if (amount == payments[paymentId].amount) {
162             _deletePayment(paymentId);
163         }
164         else {
165             payments[paymentId].amount = payments[paymentId].amount.sub(amount);
166         }
167     }
168 
169     function topUp(uint64 paymentId, uint amount) external payable {
170         transferTokens(msg.sender, address(this), amount, payments[paymentId].isEthPayment);
171         payments[paymentId].amount = payments[paymentId].amount.add(amount);
172     }
173 
174     function releasePayment(uint64 paymentId, uint amount) external onlyPayer(paymentId) {
175         require(amount <= payments[paymentId].amount);
176         payments[paymentId].amount = payments[paymentId].amount.sub(amount);
177         transferTokens(address(this), payments[paymentId].payee, amount, payments[paymentId].isEthPayment);
178         if (payments[paymentId].amount == 0) {
179             _deletePayment(paymentId);
180         }
181     }
182 
183     function scorchPayment(uint64 paymentId, uint256 amountToScorch) external onlyPayer(paymentId) {
184         payments[paymentId].amount = payments[paymentId].amount.sub(amountToScorch);
185         transferTokens(address(this), scorchAddress, amountToScorch, payments[paymentId].isEthPayment);
186         if (payments[paymentId].amount == 0) {
187             _deletePayment(paymentId);
188         }
189     }
190 
191     function claimTimedOutPayment(uint64 paymentId) external onlyPayee(paymentId) {
192         require(now > payments[paymentId].payerInactionTimeout);
193         transferTokens(
194             address(this),
195             payments[paymentId].payee,
196             payments[paymentId].amount,
197             payments[paymentId].isEthPayment
198         );
199         _deletePayment(paymentId);
200     }
201 
202     function getNumPayments() external view returns (uint length) {
203         return paymentIds.length;
204     }
205 
206     function getPaymentsForAccount(address account) external view returns (uint64[], uint64[]) {
207         uint64[] memory outgoingIds = new uint64[](paymentIds.length);
208         uint64[] memory incomingIds = new uint64[](paymentIds.length);
209         uint outgoingReturnLength = 0;
210         uint incomingReturnLength = 0;
211 
212         for (uint i=0; i < paymentIds.length; i = i.add(1)) {
213             if (payments[paymentIds[i]].payer == account) {
214                 outgoingIds[outgoingReturnLength] = paymentIds[i];
215                 outgoingReturnLength = outgoingReturnLength.add(1);
216             }
217             if (payments[paymentIds[i]].payee == account) {
218                 incomingIds[incomingReturnLength] = paymentIds[i];
219                 incomingReturnLength = incomingReturnLength.add(1);
220             }
221         }
222 
223         uint64[] memory returnOutgoingIds = new uint64[](outgoingReturnLength);
224         uint64[] memory returnIncomingIds = new uint64[](incomingReturnLength);
225 
226         for (uint j=0; j < outgoingReturnLength; j = j.add(1)) {
227             returnOutgoingIds[j] = outgoingIds[j];
228         }
229         for (uint k=0; k < incomingReturnLength; k = k.add(1)) {
230             returnIncomingIds[k] = incomingIds[k];
231         }
232         return (returnOutgoingIds, returnIncomingIds);
233     }
234 
235     function extendInactionTimeout(uint64 paymentId) public onlyPayer(paymentId) {
236         payments[paymentId].payerInactionTimeout = now.add(5 weeks);
237     }
238 
239     function transferTokens(address source, address dest, uint amount, bool isEthPayment) internal {
240         if (isEthPayment) {
241             if (dest == address(this)) {
242                 require(msg.value == amount);
243             }
244             else {
245                 dest.transfer(amount);
246             }
247         }
248         else {
249             transferDai(source, dest, amount);
250         }
251     }
252 
253     function _deletePayment(uint64 paymentId) internal {
254         uint listIndex = payments[paymentId].listIndex;
255         paymentIds[listIndex] = paymentIds[paymentIds.length.sub(1)];
256         payments[paymentIds[listIndex]].listIndex = listIndex;
257         delete payments[paymentId];
258         paymentIds.length = paymentIds.length.sub(1);
259     }
260 }