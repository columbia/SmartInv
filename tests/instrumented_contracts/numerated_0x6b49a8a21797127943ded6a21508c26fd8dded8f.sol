1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) internal returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 
21   function assert(bool assertion) internal {
22     if (!assertion) throw;
23   }
24 }
25 contract Token {
26     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
27     function name() public constant returns (string name) { name; }
28     function symbol() public constant returns (string symbol) { symbol; }
29     function decimals() public constant returns (uint8 decimals) { decimals; }
30     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
31     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
32     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
33 
34     function transfer(address _to, uint256 _value) public returns (bool success);
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
36     function approve(address _spender, uint256 _value) public returns (bool success);
37 }
38 
39 contract Ethex is SafeMath {
40   address public admin; //the admin address
41   address public feeAccount; //the account that will receive fees
42   uint public sellFee; //percentage times (1 ether)
43   uint public buyFee; //percentage times (1 ether)
44   mapping (bytes32 => uint) public sellOrders; //a hash of available orders holds a number of tokens
45   mapping (bytes32 => uint) public buyOrders; //a hash of available orders. holds a number of eth
46 
47   event BuyOrder(bytes32 order, address token, uint amount, uint price, address buyer);
48   event SellOrder(bytes32 order,address token, uint amount, uint price, address seller);
49   event CancelBuyOrder(bytes32 order, address token, uint price, address buyer);
50   event CancelSellOrder(bytes32 order, address token, uint price, address seller);
51   event Buy(bytes32 order, address token, uint amount, uint price, address buyer, address seller);
52   event Sell(bytes32 order, address token, uint amount, uint price, address buyer, address seller);
53 
54   function Ethex(address admin_, address feeAccount_, uint buyFee_, uint sellFee_) {
55     admin = admin_;
56     feeAccount = feeAccount_;
57     buyFee = buyFee_;
58     sellFee = sellFee_;
59   }
60 
61   function() {
62     throw;
63   }
64 
65   function changeAdmin(address admin_) {
66     if (msg.sender != admin) throw;
67     admin = admin_;
68   }
69 
70   function changeFeeAccount(address feeAccount_) {
71     if (msg.sender != admin) throw;
72     feeAccount = feeAccount_;
73   }
74 
75   function changeBuyFee(uint buyFee_) {
76     if (msg.sender != admin) throw;
77     if (buyFee_ > buyFee) throw;
78     buyFee = buyFee_;
79   }
80 
81   function changeSellFee(uint sellFee_) {
82     if (msg.sender != admin) throw;
83     if (sellFee_ > sellFee)
84     sellFee = sellFee_;
85   }
86 
87   function sellOrder(address token, uint tokenAmount, uint price) {
88     bytes32 h = sha256(token, price, msg.sender);
89     sellOrders[h] = safeAdd(sellOrders[h],tokenAmount);
90     SellOrder(h, token, tokenAmount, price, msg.sender);
91   }
92 
93   function buyOrder(address token, uint tokenAmount, uint price) payable {
94     bytes32 h = sha256(token, price,  msg.sender);
95     uint totalCost = tokenAmount*price;
96     if (totalCost < msg.value) throw;
97     buyOrders[h] = safeAdd(buyOrders[h],msg.value);
98     BuyOrder(h, token, tokenAmount, price, msg.sender);
99   }
100 
101   function cancelSellOrder(address token, uint price) {
102     bytes32 h = sha256(token, price, msg.sender);
103     delete sellOrders[h];
104     CancelSellOrder(h,token,price,msg.sender);
105   }
106 
107   function cancelBuyOrder(address token, uint price) {
108     bytes32 h = sha256(token, price, msg.sender);
109     uint remain = buyOrders[h];
110     delete buyOrders[h];
111     if (!msg.sender.call.value(remain)()) throw;
112     CancelBuyOrder(h,token,price,msg.sender);
113   }
114 
115   function totalBuyPrice(uint amount, uint price)  public constant returns (uint) {
116     uint totalPriceNoFee = safeMul(amount, price);
117     uint totalFee = safeMul(totalPriceNoFee, buyFee) / (1 ether);
118     uint totalPrice = safeAdd(totalPriceNoFee,totalFee);
119     return totalPrice;
120   }
121 
122   function takeBuy(address token, uint amount, uint price, address buyer) payable {
123     bytes32 h = sha256(token, price, buyer);
124     uint totalPriceNoFee = safeMul(amount, price);
125     uint totalFee = safeMul(totalPriceNoFee, buyFee) / (1 ether);
126     uint totalPrice = safeAdd(totalPriceNoFee,totalFee);
127     if (buyOrders[h] < amount) throw;
128     if (totalPrice > msg.value) throw;
129     if (Token(token).allowance(msg.sender,this) < amount) throw;
130     if (Token(token).transferFrom(msg.sender,buyer,amount)) throw;
131     buyOrders[h] = safeSub(buyOrders[h], amount);
132     if (!feeAccount.send(totalFee)) throw;
133     uint leftOver = msg.value - totalPrice;
134     if (leftOver>0)
135       if (!msg.sender.send(leftOver)) throw;
136     Buy(h, token, amount, totalPrice, buyer, msg.sender);
137   }
138 
139   function totalSellPrice(uint amount, uint price)  public constant returns (uint) {
140     uint totalPriceNoFee = safeMul(amount, price);
141     uint totalFee = safeMul(totalPriceNoFee, buyFee) / (1 ether);
142     uint totalPrice = safeSub(totalPriceNoFee,totalFee);
143     return totalPrice;
144   }
145 
146   function takeSell(address token, uint amount,uint price, address seller) payable {
147     bytes32 h = sha256(token, price, seller);
148     uint totalPriceNoFee = safeMul(amount, price);
149     uint totalFee = safeMul(totalPriceNoFee, buyFee) / (1 ether);
150     uint totalPrice = safeSub(totalPriceNoFee,totalFee);
151     if (sellOrders[h] < amount) throw;
152     if (Token(token).allowance(seller,this) < amount) throw;
153     if (!Token(token).transferFrom(seller,msg.sender,amount)) throw;
154     sellOrders[h] = safeSub(sellOrders[h],amount);
155     if (!seller.send(totalPrice)) throw;
156     if (!feeAccount.send(totalFee)) throw;
157     Sell(h, token, amount, totalPrice, msg.sender, seller);
158   }
159 }