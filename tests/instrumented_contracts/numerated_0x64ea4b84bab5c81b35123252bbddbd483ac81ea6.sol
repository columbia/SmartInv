1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 contract Orders {
5 
6   event LogNewSellOrder(bytes3 indexed currency, address sellorder);
7   event LogNewBuyOrder(bytes3 indexed currency, address buyorder);
8   event LogRemoveSellOrder(address indexed sellorder);
9   event LogRemoveBuyOrder(address indexed buyorder);   
10   function newSellOrder(bytes3 curr, uint price) public payable {
11     require(msg.value/price >= 10000);
12     Sell_eth newselleth = (new Sell_eth).value(msg.value)(price, msg.sender, address(this));
13     emit LogNewSellOrder(curr, address(newselleth));    
14   }
15 
16   function newBuyOrder(bytes3 curr, uint price) public payable {
17     require(msg.value/price >= 5000);
18     Buy_eth newbuyeth =(new Buy_eth).value(msg.value)(price, msg.sender, address(this));
19     emit LogNewBuyOrder(curr, address(newbuyeth));
20   }
21 
22   function removeSellOrder() public {  
23     emit LogRemoveSellOrder(msg.sender);
24   }
25 
26   function removeBuyOrder() public {
27     emit LogRemoveBuyOrder(msg.sender);
28   }
29 
30   function() external {revert();}
31 }
32 
33 contract Sell_eth {
34     Orders orders;
35     uint weiForSale;
36     uint price; //wei per smallest currency unit (eg. cent)
37     address payable seller;
38     mapping(address => uint) sales;
39     uint8 pending;
40     modifier onlySeller() {require(msg.sender == seller);  _;}
41 
42     event LogNewWeiForSale(uint wei_for_sale);
43     event LogNewPrice(uint nprice);
44     event LogSalePending(address indexed _seller, address indexed _buyer, uint value, uint _price);
45     event LogCashReceived(address indexed _buyer, address indexed _seller);
46 
47     constructor(uint _price, address payable _seller, address _orders) public payable {
48         orders = Orders(_orders);
49         seller = _seller;
50         price = _price;
51         pending = 0;
52         weiForSale = msg.value / 2;
53     }
54     
55     function buy() payable public {
56         require(sales[msg.sender] == 0);
57         require(msg.value > 0 && msg.value <= weiForSale && (msg.value/price)%5000 == 0);
58         sales[msg.sender] = msg.value;
59         weiForSale -= msg.value;
60         pending += 1;
61         emit LogNewWeiForSale(weiForSale);
62         emit LogSalePending(seller, msg.sender, msg.value, price);
63     }
64 
65     function confirmReceived(address payable _buyer) public  onlySeller {
66         require(sales[_buyer] > 0 && pending > 0);
67         uint amt = sales[_buyer];
68         sales[_buyer] = 0;
69         _buyer.transfer(2*amt);
70         pending -= 1;
71         emit LogCashReceived(_buyer, seller);
72 	weiForSale += amt/2;
73 	emit LogNewWeiForSale(weiForSale); 
74     }
75 
76     function addEther() public onlySeller payable {
77         weiForSale += msg.value/2;
78         emit LogNewWeiForSale(weiForSale);
79     }
80 
81     function changePrice(uint new_price) public onlySeller {
82         price = new_price;
83         emit LogNewPrice(price);
84     }
85     
86     function retr_funds() public onlySeller payable {
87         require(pending == 0);
88         orders.removeSellOrder();
89         selfdestruct(address(seller));
90     }
91     
92     function get_vars() view public returns(uint, uint) {
93         return (weiForSale, price);
94     }
95 
96     function is_party() view public returns(string memory) {
97         if (sales[msg.sender] > 0) return "buyer";
98         else if (seller == msg.sender) return "seller";
99     }
100 
101     function has_pending() view public returns(bool) {
102 	if (pending > 0) return true;
103     }
104 }
105 
106 contract Buy_eth {
107     Orders orders;
108     uint weiToBuy;
109     uint price; //wei per smallest currency unit (eg. cent)   
110     address payable buyer;
111     mapping(address => uint) sales;
112     uint8 pending;
113     modifier onlyBuyer() {require(msg.sender == buyer);  _;}
114     
115     event LogNewWeiToBuy(uint wei_to_buy);
116     event LogNewPrice(uint nprice);
117     event LogSalePending(address indexed _buyer, address indexed _seller, uint value, uint _price);
118     event LogCashReceived(address indexed _seller, address indexed _buyer);
119 
120     constructor(uint _price, address payable _buyer, address _orders) public payable {
121         orders = Orders(_orders);
122         buyer = _buyer;
123         price = _price;
124         pending = 0;
125         weiToBuy = msg.value;
126     }
127     function sell() public payable {
128         require(sales[msg.sender] == 0);
129         require(msg.value > 0 && msg.value/2 <= weiToBuy && (msg.value/price)%10000 == 0); 
130         uint amt = msg.value/2;
131         sales[msg.sender] = amt;
132         weiToBuy -= amt;
133         pending += 1;
134         emit LogSalePending(buyer, msg.sender, amt, price);
135         emit LogNewWeiToBuy(weiToBuy);
136     }
137 
138     function confirmReceived() public payable {
139         require(sales[msg.sender] > 0 && pending > 0);
140         uint amt = sales[msg.sender];
141         sales[msg.sender] = 0;
142         msg.sender.transfer(amt);
143         emit LogCashReceived(msg.sender, buyer);
144         weiToBuy += 2*amt;
145         pending -= 1;
146         emit LogNewWeiToBuy(weiToBuy);
147     }
148     
149     function retreive_eth(uint vol) public onlyBuyer payable {  
150         require(vol <= weiToBuy-price*5000);
151         weiToBuy -= vol;
152         buyer.transfer(vol);
153         emit LogNewWeiToBuy(weiToBuy);
154     }
155 
156     function changePrice(uint new_price) public onlyBuyer {
157         price = new_price;
158         emit LogNewPrice(price);
159     }
160 
161     function terminate_contract() public onlyBuyer payable {
162         require(pending == 0);
163         orders.removeBuyOrder();
164         selfdestruct(buyer);
165     }
166 
167     function get_vars() view public returns(uint,uint) {
168         return (weiToBuy, price);
169     }
170 
171     function is_party() view public returns(string memory) {
172         if (buyer == msg.sender) return "buyer";
173         else if (sales[msg.sender] > 0) return "seller";
174     }
175 
176     function has_pending() view public returns(bool) {
177 	if (pending > 0) return true;
178     }
179 }