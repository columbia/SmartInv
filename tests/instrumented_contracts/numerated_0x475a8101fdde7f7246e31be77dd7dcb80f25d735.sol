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
36     event FillOrder(uint id, uint amount);
37     event CancelOrder(uint id);
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
133         require(orders[id].creator != msg.sender);
134         require(orders[id].amount >= amount);
135         uint amountEther = calcAmountEther(orders[id].token, orders[id].price, amount);
136         if (orders[id].buy) {
137             /* send tokens from sender to creator */
138             // sub from sender
139             balanceSub(orders[id].token, msg.sender, amount);
140             BalanceChanged(
141                 orders[id].token,
142                 msg.sender,
143                 balanceOf[orders[id].token][msg.sender]
144             );
145             
146             // add to creator
147             balanceAdd(orders[id].token, orders[id].creator, amount);
148             BalanceChanged(
149                 orders[id].token,
150                 orders[id].creator,
151                 balanceOf[orders[id].token][orders[id].creator]
152             );
153             
154             /* send Ether to sender */
155             balanceAdd(0x0, msg.sender, amountEther);
156             BalanceChanged(
157                 0x0,
158                 msg.sender,
159                 balanceOf[0x0][msg.sender]
160             );
161         } else {
162             /* send Ether from sender to creator */
163             // sub from sender
164             balanceSub(0x0, msg.sender, amountEther);
165             BalanceChanged(
166                 0x0,
167                 msg.sender,
168                 balanceOf[0x0][msg.sender]
169             );
170             
171             // add to creator
172             balanceAdd(0x0, orders[id].creator, amountEther);
173             BalanceChanged(
174                 0x0,
175                 orders[id].creator,
176                 balanceOf[0x0][orders[id].creator]
177             );
178             
179             /* send tokens to sender */
180             balanceAdd(orders[id].token, msg.sender, amount);
181             BalanceChanged(
182                 orders[id].token,
183                 msg.sender,
184                 balanceOf[orders[id].token][msg.sender]
185             );
186         }
187         orders[id].amount -= amount;
188         FillOrder(id, orders[id].amount);
189     }
190     
191     function cancelOrder(uint id) external {
192         require(id < currentOrderId);
193         require(orders[id].creator == msg.sender);
194         require(orders[id].amount > 0);
195         if (orders[id].buy) {
196             uint amountEther = calcAmountEther(orders[id].token, orders[id].price, orders[id].amount);
197             balanceAdd(0x0, msg.sender, amountEther);
198             BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
199         } else {
200             balanceAdd(orders[id].token, msg.sender, orders[id].amount);
201             BalanceChanged(orders[id].token, msg.sender, balanceOf[orders[id].token][msg.sender]);
202         }
203         orders[id].amount = 0;
204         CancelOrder(id);
205     }
206     
207     function () external payable {
208         require(msg.value > 0);
209         uint fee = msg.value * feeDeposit / 10000;
210         require(msg.value > fee);
211         balanceAdd(0x0, owner, fee);
212         
213         uint toAdd = msg.value - fee;
214         balanceAdd(0x0, msg.sender, toAdd);
215         
216         Deposit(0x0, msg.sender, toAdd);
217         BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
218         
219         FundTransfer(msg.sender, toAdd, true);
220     }
221     
222     function depositToken(address tokenAddr, uint amount) external {
223         require(tokenAddr != 0x0);
224         require(amount > 0);
225         Token(tokenAddr).transferFrom(msg.sender, this, amount);
226         balanceAdd(tokenAddr, msg.sender, amount);
227         
228         Deposit(tokenAddr, msg.sender, amount);
229         BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);
230     }
231     
232     function withdrawEther(uint amount) external {
233         require(amount > 0);
234         balanceSub(0x0, msg.sender, amount);
235         msg.sender.transfer(amount);
236         
237         Withdraw(0x0, msg.sender, amount);
238         BalanceChanged(0x0, msg.sender, balanceOf[0x0][msg.sender]);
239         
240         FundTransfer(msg.sender, amount, false);
241     }
242     
243     function withdrawToken(address tokenAddr, uint amount) external {
244         require(tokenAddr != 0x0);
245         require(amount > 0);
246         balanceSub(tokenAddr, msg.sender, amount);
247         Token(tokenAddr).transfer(msg.sender, amount);
248         
249         Withdraw(tokenAddr, msg.sender, amount);
250         BalanceChanged(tokenAddr, msg.sender, balanceOf[tokenAddr][msg.sender]);
251     }
252 }