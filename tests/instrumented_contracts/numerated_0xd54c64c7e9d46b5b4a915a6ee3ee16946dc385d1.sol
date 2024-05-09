1 pragma solidity ^0.4.25;
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
14 contract XIOExchange {
15     struct Order {
16         address creator;
17         bool buy;
18         uint price;
19         uint amount;
20     }
21 
22     Order[] public orders;
23     uint public orderCount;
24 
25     address public XIO;
26 
27     event PlaceSell(address indexed user, uint price, uint amount, uint id);
28     event PlaceBuy(address indexed user, uint price, uint amount, uint id);
29     event FillOrder(uint indexed id, address indexed user, uint amount);
30     event CancelOrder(uint indexed id);
31 
32     constructor(address _XIO) public {
33         XIO = _XIO;
34     }
35 
36     function safeAdd(uint a, uint b) private pure returns (uint) {
37         uint c = a + b;
38         assert(c >= a);
39         return c;
40     }
41     
42     function safeSub(uint a, uint b) private pure returns (uint) {
43         assert(b <= a);
44         return a - b;
45     }
46     
47     function safeMul(uint a, uint b) private pure returns (uint) {
48         if (a == 0) {
49           return 0;
50         }
51         
52         uint c = a * b;
53         assert(c / a == b);
54         return c;
55     }
56     
57     function safeIDiv(uint a, uint b) private pure returns (uint) {
58         uint c = a / b;
59         assert(b * c == a);
60         return c;
61     }
62     
63     function calcAmountTrx(uint price, uint amount) internal pure returns (uint) {
64         return safeIDiv(safeMul(price, amount), 1000000000000000000);
65     }
66 
67     function placeBuy(uint price, uint amount) external payable {
68         require(price > 0 && amount > 0 && msg.value == calcAmountTrx(price, amount));
69         orders.push(Order({
70             creator: msg.sender,
71             buy: true,
72             price: price,
73             amount: amount
74         }));
75         emit PlaceBuy(msg.sender, price, amount, orderCount);
76         orderCount++;
77     }
78     
79     function placeSell(uint price, uint amount) external {
80         require(price > 0 && amount > 0);
81         Token(XIO).transferFrom(msg.sender, this, amount);
82         orders.push(Order({
83             creator: msg.sender,
84             buy: false,
85             price: price,
86             amount: amount
87         }));
88         emit PlaceSell(msg.sender, price, amount, orderCount);
89         orderCount++;
90     }
91     
92     function fillOrder(uint id, uint amount) external payable {
93         require(id < orders.length);
94         require(amount > 0);
95         require(orders[id].creator != msg.sender);
96         require(orders[id].amount >= amount);
97         if (orders[id].buy) {
98             require(msg.value == 0);
99             
100             /* send tokens from sender to creator */
101             Token(XIO).transferFrom(msg.sender, orders[id].creator, amount);
102             
103             /* send Ether to sender */
104             msg.sender.transfer(calcAmountTrx(orders[id].price, amount));
105         } else {
106             uint trxAmount = calcAmountTrx(orders[id].price, amount);
107             require(msg.value == trxAmount);
108             
109             /* send tokens to sender */
110             Token(XIO).transfer(msg.sender, amount);
111             
112             /* send Ether from sender to creator */
113             orders[id].creator.transfer(trxAmount);
114         }
115         if (orders[id].amount == amount) {
116             delete orders[id];
117         } else {
118             orders[id].amount -= amount;
119         }
120         emit FillOrder(id, msg.sender, amount);
121     }
122     
123     function cancelOrder(uint id) external {
124         require(id < orders.length);
125         require(orders[id].creator == msg.sender);
126         require(orders[id].amount > 0);
127         if (orders[id].buy) {
128             /* return Ether */
129             msg.sender.transfer(calcAmountTrx(orders[id].price, orders[id].amount));
130         } else {
131             /* return tokens */
132             Token(XIO).transfer(msg.sender, orders[id].amount);
133         }
134         delete orders[id];
135         emit CancelOrder(id);
136     }
137 }