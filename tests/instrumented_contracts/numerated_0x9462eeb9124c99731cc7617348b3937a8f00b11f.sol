1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC223 {
30   uint public totalSupply;
31   function balanceOf(address who) constant returns (uint);
32 
33   function name() constant returns (string _name);
34   function symbol() constant returns (string _symbol);
35   function decimals() constant returns (uint8 _decimals);
36   function totalSupply() constant returns (uint256 _supply);
37 
38   function transfer(address to, uint value) returns (bool ok);
39   function transfer(address to, uint value, bytes data) returns (bool ok);
40   event Transfer(address indexed _from, address indexed _to, uint256 _value);
41   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
42 }
43 
44 contract ContractReceiver {
45   function tokenFallback(address _from, uint _value, bytes _data);
46 }
47 
48 contract ERC20Basic {
49   uint256 public totalSupply;
50   uint8   public decimals;
51   function balanceOf(address who) public constant returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) public constant returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract Radex is ContractReceiver {
64   using SafeMath for uint256;
65 
66   struct Order {
67     address owner;
68     address sellToken;
69     address buyToken;
70     uint256 amount;
71     uint256 priceMul;
72     uint256 priceDiv;
73   }
74 
75   // fee to be paid towards market makers
76   // fee amount = trade amount divided by feeMultiplier
77   uint256 public  feeMultiplier;
78   address private admin;
79   address private etherAddress = 0x0;
80 
81   // person => token => balance
82   mapping(address => mapping(address => uint256)) public balances;
83   mapping(address => mapping(address => uint256)) public commitments;
84 
85   mapping(uint256 => Order) orderBook;
86   uint256 public latestOrderId = 0;
87 
88   event Deposit(address indexed _token, address indexed _owner, uint256 _amount, uint256 _time);
89   event Withdrawal(address indexed _token, address indexed _owner, uint256 _amount, uint256 _time);
90 
91   event NewOrder(uint256 _id, address indexed _owner, address indexed _sellToken, address indexed _buyToken, uint256 _amount, uint256 _priceMul, uint256 _priceDiv, uint256 _time);
92   event OrderCancelled(uint256 indexed _id, uint256 _time);
93   event OrderFulfilled(uint256 indexed _id, uint256 _time);
94 
95   event MarketMaker(address indexed _owner, address indexed _token, uint256 _amount, uint256 _time);
96   event Trade(address indexed _from, address indexed _to, uint256 indexed _orderId, uint256 _soldTokens, uint256 _boughtTokens, uint256 _time);
97 
98   function Radex() {
99     feeMultiplier = 1000;
100     admin = msg.sender;
101   }
102 
103   function createOrder(address sellToken, address buyToken, uint256 amount, uint256 priceMul, uint256 priceDiv) returns(uint256 orderId) {
104     if (amount == 0) { revert(); }
105     if (priceMul == 0) { revert(); }
106     if (priceDiv == 0) { revert(); }
107     if (sellToken == buyToken) { revert(); }
108     if (balances[msg.sender][sellToken] < amount) { revert(); }
109     if (amount.mul(priceMul).div(priceDiv) == 0) { revert(); }
110 
111     orderId = latestOrderId++;
112     orderBook[orderId] = Order(msg.sender, sellToken, buyToken, amount, priceMul, priceDiv);
113 
114     balances[msg.sender][sellToken] = balances[msg.sender][sellToken].sub(amount);
115     commitments[msg.sender][sellToken] = commitments[msg.sender][sellToken].add(amount);
116 
117     NewOrder(orderId, msg.sender, sellToken, buyToken, amount, priceMul, priceDiv, now);
118   }
119 
120   function cancelOrder(uint256 orderId) {
121     Order storage order = orderBook[orderId];
122     if (order.amount == 0) { revert(); }
123     if (msg.sender != order.owner) { revert(); }
124 
125     commitments[msg.sender][order.sellToken] = commitments[msg.sender][order.sellToken].sub(order.amount);
126     balances[msg.sender][order.sellToken] = balances[msg.sender][order.sellToken].add(order.amount);
127 
128     OrderCancelled(orderId, now);
129   }
130 
131   function executeOrder(uint256 orderId, uint256 amount) {
132     if (orderId > latestOrderId) { revert(); }
133     Order storage order    = orderBook[orderId];
134     uint256 buyTokenAmount = amount.mul(order.priceMul).div(order.priceDiv);
135     if (amount == 0) { revert(); }
136     if (order.amount < amount) { revert(); }
137     if (msg.sender == order.owner) { revert(); }
138     if (balances[msg.sender][order.buyToken] < buyTokenAmount) { revert(); }
139 
140     uint256 fee = amount.div(feeMultiplier);
141 
142     balances[order.owner][order.buyToken]     = balances[order.owner][order.buyToken].add(buyTokenAmount);
143     balances[msg.sender][order.buyToken]      = balances[msg.sender][order.buyToken].sub(buyTokenAmount);
144     balances[msg.sender][order.sellToken]     = balances[msg.sender][order.sellToken].add(amount).sub(fee);
145     balances[order.owner][order.sellToken]    = balances[order.owner][order.sellToken].add(fee);
146 
147     commitments[order.owner][order.sellToken] = commitments[order.owner][order.sellToken].sub(amount);
148     order.amount = order.amount.sub(amount);
149     if (order.amount == 0) { OrderFulfilled(orderId, now); }
150 
151     Trade(msg.sender, order.owner, orderId, amount, buyTokenAmount, now);
152     MarketMaker(order.owner, order.sellToken, fee, now);
153   }
154 
155 
156   function redeem(address token, uint256 value) {
157     if (value == 0) { revert(); }
158     address caller = msg.sender;
159     if (value > balances[caller][token]) { revert(); }
160 
161     balances[caller][token] = balances[caller][token].sub(value);
162     // ETH transfers and token transfers need to be handled differently
163     if (token == etherAddress) {
164       caller.transfer(value);
165     } else {
166       ERC223(token).transfer(caller, value);
167     }
168     Withdrawal(token, msg.sender, value, now);
169   }
170 
171   function balanceOf(address token, address user) constant returns (uint256) {
172     return balances[user][token];
173   }
174 
175   function commitmentsOf(address token, address user) constant returns (uint256) {
176     return commitments[user][token];
177   }
178 
179   // deposits
180   // we're not using the third argument so we comment it out
181   // to silence solidity linter warnings
182   function tokenFallback(address _from, uint _value, bytes /* _data */) {
183     // ERC223 token deposit handler
184     balances[_from][msg.sender] = balances[_from][msg.sender].add(_value);
185     Deposit(msg.sender, _from, _value, now);
186   }
187 
188   function fund() payable {
189     // ETH deposit handler
190     balances[msg.sender][etherAddress] = balances[msg.sender][etherAddress].add(msg.value);
191     Deposit(etherAddress, msg.sender, msg.value, now);
192   }
193 
194   // register the ERC20<>ERC223 pair with the smart contract
195   function register(address erc20token, address erc223token) {
196     if (msg.sender != admin) { revert(); } // only owner
197     ERC20 erc20 = ERC20(erc20token);
198     uint256 supply = erc20.totalSupply();
199     erc20.approve(erc223token, supply);
200   }
201 }