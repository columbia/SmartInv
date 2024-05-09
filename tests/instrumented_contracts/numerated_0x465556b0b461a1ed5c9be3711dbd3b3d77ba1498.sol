1 pragma solidity ^0.4.19;
2 
3 contract Token {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10     
11     uint8 public decimals;
12 }
13 
14 contract Exchange {
15     struct Order {
16         address creator;
17         address token;
18         bool buy;
19         uint price;
20         uint amount;
21     }
22     
23     address public owner;
24     uint public feeDeposit = 500;
25     
26     mapping (uint => Order) orders;
27     uint currentOrderId = 0;
28     
29     /* Token address (0x0 - Ether) => User address => balance */
30     mapping (address => mapping (address => uint)) public balanceOf;
31     
32     event FundTransfer(address backer, uint amount, bool isContribution);
33     
34     event PlaceSell(address indexed token, address indexed user, uint price, uint amount, uint id);
35     event PlaceBuy(address indexed token, address indexed user, uint price, uint amount, uint id);
36     event FillOrder(uint indexed id, address indexed user, uint amount);
37     event CancelOrder(uint indexed id);
38     event Deposit(address indexed token, address indexed user, uint amount);
39     event Withdraw(address indexed token, address indexed user, uint amount);
40     event BalanceChanged(address indexed token, address indexed user, uint value);
41 
42     modifier onlyOwner {
43         if (msg.sender != owner) revert();
44         _;
45     }
46     
47     function transferOwnership(address newOwner) external onlyOwner {
48         owner = newOwner;
49     }
50     
51     function Exchange() public {
52         owner = msg.sender;
53     }
54     
55     function safeAdd(uint a, uint b) private pure returns (uint) {
56         uint c = a + b;
57         assert(c >= a);
58         return c;
59     }
60     
61     function safeSub(uint a, uint b) private pure returns (uint) {
62         assert(b <= a);
63         return a - b;
64     }
65     
66     function safeMul(uint a, uint b) private pure returns (uint) {
67         if (a == 0) {
68           return 0;
69         }
70         
71         uint c = a * b;
72         assert(c / a == b);
73         return c;
74     }
75     
76     function decFeeDeposit(uint delta) external onlyOwner {
77         feeDeposit = safeSub(feeDeposit, delta);
78     }
79     
80     function calcAmountEther(address tokenAddr, uint price, uint amount) private view returns (uint) {
81         uint k = 10;
82         k = k ** Token(tokenAddr).decimals();
83         return safeMul(amount, price) / k;
84     }
85     
86     function balanceAdd(address tokenAddr, address user, uint amount) private {
87         balanceOf[tokenAddr][user] =
88             safeAdd(balanceOf[tokenAddr][user], amount);
89     }
90     
91     function balanceSub(address tokenAddr, address user, uint amount) private {
92         require(balanceOf[tokenAddr][user] >= amount);
93         balanceOf[tokenAddr][user] =
94             safeSub(balanceOf[tokenAddr][user], amount);
95     }
96     
97     function placeBuy(address tokenAddr, uint price, uint amount) external {
98         require(price > 0 && amount > 0);
99         uint amountEther = calcAmountEther(tokenAddr, price, amount);
100         require(amountEther > 0);
101         balanceSub(0x0, msg.sender, amountEther);
102         BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
103         orders[currentOrderId] = Order({
104             creator: msg.sender,
105             token: tokenAddr,
106             buy: true,
107             price: price,
108             amount: amount
109         });
110         PlaceBuy(tokenAddr, msg.sender, price, amount, currentOrderId);
111         currentOrderId++;
112     }
113     
114     function placeSell(address tokenAddr, uint price, uint amount) external {
115         require(price > 0 && amount > 0);
116         uint amountEther = calcAmountEther(tokenAddr, price, amount);
117         require(amountEther > 0);
118         balanceSub(tokenAddr, msg.sender, amount);
119         BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);
120         orders[currentOrderId] = Order({
121             creator: msg.sender,
122             token: tokenAddr,
123             buy: false,
124             price: price,
125             amount: amount
126         });
127         PlaceSell(tokenAddr, msg.sender, price, amount, currentOrderId);
128         currentOrderId++;
129     }
130     
131     function fillOrder(uint id, uint amount) external {
132         require(id < currentOrderId);
133         require(amount > 0);
134         require(orders[id].creator != msg.sender);
135         require(orders[id].amount >= amount);
136         uint amountEther = calcAmountEther(orders[id].token, orders[id].price, amount);
137         if (orders[id].buy) {
138             /* send tokens from sender to creator */
139             // sub from sender
140             balanceSub(orders[id].token, msg.sender, amount);
141             BalanceChanged(
142                 orders[id].token,
143                 msg.sender,
144                 balanceOf[orders[id].token][msg.sender]
145             );
146             
147             // add to creator
148             balanceAdd(orders[id].token, orders[id].creator, amount);
149             BalanceChanged(
150                 orders[id].token,
151                 orders[id].creator,
152                 balanceOf[orders[id].token][orders[id].creator]
153             );
154             
155             /* send Ether to sender */
156             balanceAdd(0x0, msg.sender, amountEther);
157             BalanceChanged(
158                 0x0,
159                 msg.sender,
160                 balanceOf[0x0][msg.sender]
161             );
162         } else {
163             /* send Ether from sender to creator */
164             // sub from sender
165             balanceSub(0x0, msg.sender, amountEther);
166             BalanceChanged(
167                 0x0,
168                 msg.sender,
169                 balanceOf[0x0][msg.sender]
170             );
171             
172             // add to creator
173             balanceAdd(0x0, orders[id].creator, amountEther);
174             BalanceChanged(
175                 0x0,
176                 orders[id].creator,
177                 balanceOf[0x0][orders[id].creator]
178             );
179             
180             /* send tokens to sender */
181             balanceAdd(orders[id].token, msg.sender, amount);
182             BalanceChanged(
183                 orders[id].token,
184                 msg.sender,
185                 balanceOf[orders[id].token][msg.sender]
186             );
187         }
188         orders[id].amount -= amount;
189         FillOrder(id, msg.sender, orders[id].amount);
190     }
191     
192     function cancelOrder(uint id) external {
193         require(id < currentOrderId);
194         require(orders[id].creator == msg.sender);
195         require(orders[id].amount > 0);
196         if (orders[id].buy) {
197             uint amountEther = calcAmountEther(orders[id].token, orders[id].price, orders[id].amount);
198             balanceAdd(0x0, msg.sender, amountEther);
199             BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
200         } else {
201             balanceAdd(orders[id].token, msg.sender, orders[id].amount);
202             BalanceChanged(orders[id].token, msg.sender, balanceOf[orders[id].token][msg.sender]);
203         }
204         orders[id].amount = 0;
205         CancelOrder(id);
206     }
207     
208     function () external payable {
209         require(msg.value > 0);
210         uint fee = msg.value * feeDeposit / 10000;
211         require(msg.value > fee);
212         balanceAdd(0x0, owner, fee);
213         
214         uint toAdd = msg.value - fee;
215         balanceAdd(0x0, msg.sender, toAdd);
216         
217         Deposit(0x0, msg.sender, toAdd);
218         BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
219         
220         FundTransfer(msg.sender, toAdd, true);
221     }
222     
223     function depositToken(address tokenAddr, uint amount) external {
224         require(tokenAddr != 0x0);
225         require(amount > 0);
226         Token(tokenAddr).transferFrom(msg.sender, this, amount);
227         balanceAdd(tokenAddr, msg.sender, amount);
228         
229         Deposit(tokenAddr, msg.sender, amount);
230         BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);
231     }
232     
233     function withdrawEther(uint amount) external {
234         require(amount > 0);
235         balanceSub(0x0, msg.sender, amount);
236         msg.sender.transfer(amount);
237         
238         Withdraw(0x0, msg.sender, amount);
239         BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
240         
241         FundTransfer(msg.sender, amount, false);
242     }
243     
244     function withdrawToken(address tokenAddr, uint amount) external {
245         require(tokenAddr != 0x0);
246         require(amount > 0);
247         balanceSub(tokenAddr, msg.sender, amount);
248         Token(tokenAddr).transfer(msg.sender, amount);
249         
250         Withdraw(tokenAddr, msg.sender, amount);
251         BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);
252     }
253 }