1 // BitFrank.com : The unstoppable on-chain exchange of ERC20 tokens
2 // Copyright (c) 2018. All rights reserved.
3 
4 pragma solidity ^0.4.20;
5 
6 contract SafeMath {
7     function add(uint x, uint y) internal pure returns (uint z) {
8         require((z = x + y) >= x);
9     }
10     function sub(uint x, uint y) internal pure returns (uint z) {
11         require((z = x - y) <= x);
12     }
13     function mul(uint x, uint y) internal pure returns (uint z) {
14         require(y == 0 || (z = x * y) / y == x);
15     }
16 }
17 
18 contract ERC20 {
19     function transfer(address dst, uint wad) public returns (bool);
20     function transferFrom(address src, address dst, uint wad) public returns (bool);
21 }
22 
23 contract BitFrank is SafeMath {
24     
25     address public admin;
26     
27     string public constant name = "BitFrank v1";
28     bool public suspendDeposit = false; // if we are upgrading to a new contract, deposit will be suspended, but you can still withdraw / trade
29  
30     // market details for each TOKEN
31     struct TOKEN_DETAIL {
32         uint8 level; // 1 = listed, 2 = registered, 3 = verified (by admin), MAX = 9
33         uint fee; // fee for taker. 100 = 0.01%, 1000 = 0.1%, 10000 = 1%, 1000000 = 100%
34     }
35     uint public marketRegisterCost = 99 * (10 ** 16); // 0.99 ETH
36     uint public marketDefaultFeeLow = 2000; // 0.2%
37     uint public marketDefaultFeeHigh = 8000; // 0.8%
38     
39     mapping (address => TOKEN_DETAIL) public tokenMarket; // registered token details
40     address[] public tokenList; // list of registered tokens
41     
42     mapping (address => mapping (address => uint)) public balance; // balance[tokenAddr][userAddr]
43     mapping (address => mapping (address => uint)) public balanceLocked; // token locked in orders
44     
45     uint public globalOrderSerial = 100000; // always increasing
46     uint public PRICE_FACTOR = 10 ** 18; // all prices are multiplied by PRICE_FACTOR
47     
48     struct ORDER {
49         address token;
50         bool isBuy; // buy or sell
51         address user; // userMaker
52         uint wad;
53         uint wadFilled;
54         uint price; // all prices are multiplied by PRICE_FACTOR
55         uint listPosition; // position in orderList, useful when updating orderList
56     }
57     
58     mapping (uint => ORDER) public order; // [orderID] => ORDER
59     uint[] public orderList; // list of orderIDs
60 
61     //============== EVENTS ==============
62     
63     event MARKET_CHANGE(address indexed token);
64     event DEPOSIT(address indexed user, address indexed token, uint wad, uint result);
65     event WITHDRAW(address indexed user, address indexed token, uint wad, uint result);
66     event ORDER_PLACE(address indexed user, address indexed token, bool isBuy, uint wad, uint price, uint indexed id);
67     event ORDER_CANCEL(address indexed user, address indexed token, uint indexed id);
68     event ORDER_MODIFY(address indexed user, address indexed token, uint indexed id, uint new_wad, uint new_price);
69     event ORDER_FILL(address indexed userTaker, address userMaker, address indexed token, bool isOriginalOrderBuy, uint fillAmt, uint price, uint indexed id);
70     event ORDER_DONE(address indexed userTaker, address userMaker, address indexed token, bool isOriginalOrderBuy, uint fillAmt, uint price, uint indexed id);
71     
72     //============== ORDER PLACEMENT & TRADE ==============
73     
74     // get order list count
75     
76     function getOrderCount() public constant returns (uint) {
77         return orderList.length;
78     }
79     
80     // limit order @ price (all prices are multiplied by PRICE_FACTOR)
81     
82     function orderPlace(address token, bool isBuy, uint wad, uint price) public {
83         
84         uint newLocked;
85         if (isBuy) { // buy token, lock ETH
86             newLocked = add(balanceLocked[0][msg.sender], mul(wad, price) / PRICE_FACTOR);
87             require(balance[0][msg.sender] >= newLocked);
88             balanceLocked[0][msg.sender] = newLocked;
89         } else { // sell token, lock token
90             newLocked = add(balanceLocked[token][msg.sender], wad);
91             require(balance[token][msg.sender] >= newLocked);
92             balanceLocked[token][msg.sender] = newLocked;
93         }
94         
95         // place order
96         ORDER memory o;
97         o.token = token;
98         o.isBuy = isBuy;
99         o.wad = wad;
100         o.price = price;
101         o.user = msg.sender;
102         o.listPosition = orderList.length; // position in orderList
103         order[globalOrderSerial] = o;
104         
105         // update order list with orderID = globalOrderSerial
106         orderList.push(globalOrderSerial);
107         
108         // event
109         ORDER_PLACE(msg.sender, token, isBuy, wad, price, globalOrderSerial);
110 
111         globalOrderSerial++; // can never overflow
112     }
113     
114     // market order to take order @ price (all prices are multiplied by PRICE_FACTOR)
115     
116     function orderTrade(uint orderID, uint wad, uint price) public {
117         
118         ORDER storage o = order[orderID];
119         require(price == o.price); // price must match, because maker can modify price
120         
121         // fill amt
122         uint fillAmt = sub(o.wad, o.wadFilled);
123         if (fillAmt > wad) fillAmt = wad;
124         
125         // fill ETH and fee
126         uint fillETH = mul(fillAmt, price) / PRICE_FACTOR;
127         uint fee = mul(fillETH, tokenMarket[o.token].fee) / 1000000;
128     
129         uint newTakerBalance;
130         
131         if (o.isBuy) { // taker is selling token to maker
132             
133             // remove token from taker (check balance first)
134             newTakerBalance = sub(balance[o.token][msg.sender], fillAmt);
135             require(newTakerBalance >= balanceLocked[o.token][msg.sender]);
136             balance[o.token][msg.sender] = newTakerBalance;
137             
138             // remove ETH from maker
139             balance[0][o.user] = sub(balance[0][o.user], fillETH);
140             balanceLocked[0][o.user] = sub(balanceLocked[0][o.user], fillETH);
141             
142             // give token to maker
143             balance[o.token][o.user] = add(balance[o.token][o.user], fillAmt);
144             
145             // give ETH (after fee) to taker 
146             balance[0][msg.sender] = add(balance[0][msg.sender], sub(fillETH, fee));
147             
148         } else { // taker is buying token from maker
149         
150             // remove ETH (with fee) from taker (check balance first)
151             newTakerBalance = sub(balance[0][msg.sender], add(fillETH, fee));
152             require(newTakerBalance >= balanceLocked[0][msg.sender]);
153             balance[0][msg.sender] = newTakerBalance;
154 
155             // remove token from maker
156             balance[o.token][o.user] = sub(balance[o.token][o.user], fillAmt);
157             balanceLocked[o.token][o.user] = sub(balanceLocked[o.token][o.user], fillAmt);
158             
159             // give ETH to maker
160             balance[0][o.user] = add(balance[0][o.user], fillETH);
161 
162             // give token to taker
163             balance[o.token][msg.sender] = add(balance[o.token][msg.sender], fillAmt);
164         }
165         
166         balance[0][admin] = add(balance[0][admin], fee);
167 
168         // fill order
169         o.wadFilled = add(o.wadFilled, fillAmt);
170         
171         // remove filled order
172         if (o.wadFilled >= o.wad) {
173 
174             // update order list
175             orderList[o.listPosition] = orderList[orderList.length - 1];
176             order[orderList[o.listPosition]].listPosition = o.listPosition; // update position in orderList
177             orderList.length--;
178             
179             // delete order
180             ORDER_DONE(msg.sender, o.user, o.token, o.isBuy, fillAmt, price, orderID);
181 
182             delete order[orderID];
183             
184         } else {
185             ORDER_FILL(msg.sender, o.user, o.token, o.isBuy, fillAmt, price, orderID);
186         }
187     }
188     
189     function orderCancel(uint orderID) public {
190         // make sure the order is correct
191         ORDER memory o = order[orderID]; // o is not modified
192         require(o.user == msg.sender);
193 
194         uint wadLeft = sub(o.wad, o.wadFilled);
195 
196         // release remained amt
197         if (o.isBuy) { // release ETH
198             balanceLocked[0][msg.sender] = sub(balanceLocked[0][msg.sender], mul(o.price, wadLeft) / PRICE_FACTOR);
199         } else { // release token
200             balanceLocked[o.token][msg.sender] = sub(balanceLocked[o.token][msg.sender], wadLeft);
201         }
202 
203         ORDER_CANCEL(msg.sender, o.token, orderID);
204         
205         // update order list
206         orderList[o.listPosition] = orderList[orderList.length - 1];
207         order[orderList[o.listPosition]].listPosition = o.listPosition; // update position in orderList
208         orderList.length--;
209         
210         // delete order
211         delete order[orderID];
212     }
213     
214     function orderModify(uint orderID, uint new_wad, uint new_price) public {
215         // make sure the order is correct
216         ORDER storage o = order[orderID]; // o is modified
217         require(o.user == msg.sender);
218         require(o.wadFilled == 0); // for simplicity, you can't change filled orders
219         
220         // change amount of locked assets
221         
222         uint newLocked;
223         if (o.isBuy) { // lock ETH
224             newLocked = sub(add(balanceLocked[0][msg.sender], mul(new_wad, new_price) / PRICE_FACTOR), mul(o.wad, o.price) / PRICE_FACTOR);
225             require(balance[0][msg.sender] >= newLocked);
226             balanceLocked[0][msg.sender] = newLocked;
227         } else { // lock token
228             newLocked = sub(add(balanceLocked[o.token][msg.sender], new_wad), o.wad);
229             require(balance[o.token][msg.sender] >= newLocked);
230             balanceLocked[o.token][msg.sender] = newLocked;
231         }
232     
233         // modify order
234         o.wad = new_wad;
235         o.price = new_price;
236         
237         ORDER_MODIFY(msg.sender, o.token, orderID, new_wad, new_price);
238     }
239   
240     //============== ADMINISTRATION ==============
241   
242     function BitFrank() public {
243         admin = msg.sender;
244         
245         adminSetMarket(0, 9, 0); // ETH, level 9, fee = 0
246     }
247     
248     // set admin
249     function adminSetAdmin(address newAdmin) public {
250         require(msg.sender == admin);
251         require(balance[0][newAdmin] > 0); // newAdmin must have deposits
252         admin = newAdmin;
253     }
254     
255     // suspend deposit (prepare for upgrading to a new contract)
256     function adminSuspendDeposit(bool status) public {
257         require(msg.sender == admin);
258         suspendDeposit = status;
259     }
260     
261     // set market details
262     function adminSetMarket(address token, uint8 level_, uint fee_) public {
263         require(msg.sender == admin);
264         require(level_ != 0);
265         require(level_ <= 9);
266         if (tokenMarket[token].level == 0) {
267             tokenList.push(token);
268         }
269         tokenMarket[token].level = level_;
270         tokenMarket[token].fee = fee_;
271         MARKET_CHANGE(token);
272     }
273     
274     // set register cost
275     function adminSetRegisterCost(uint cost_) public {
276         require(msg.sender == admin);
277         marketRegisterCost = cost_;
278     }
279     
280     // set default fee
281     function adminSetDefaultFee(uint marketDefaultFeeLow_, uint marketDefaultFeeHigh_) public {
282         require(msg.sender == admin);
283         marketDefaultFeeLow = marketDefaultFeeLow_;
284         marketDefaultFeeHigh = marketDefaultFeeHigh_;
285     }
286     
287     //============== MARKET REGISTRATION & HELPER ==============
288 
289     // register token
290     function marketRegisterToken(address token) public payable {
291         require(tokenMarket[token].level == 1);
292         require(msg.value >= marketRegisterCost); // register cost
293         balance[0][admin] = add(balance[0][admin], msg.value);
294         
295         tokenMarket[token].level = 2;
296         tokenMarket[token].fee = marketDefaultFeeLow;
297         MARKET_CHANGE(token);
298     }
299     
300     // get token list count
301     function getTokenCount() public constant returns (uint) {
302         return tokenList.length;
303     }
304   
305     //============== DEPOSIT & WITHDRAW ==============
306   
307     function depositETH() public payable {
308         require(!suspendDeposit);
309         balance[0][msg.sender] = add(balance[0][msg.sender], msg.value);
310         DEPOSIT(msg.sender, 0, msg.value, balance[0][msg.sender]);
311     }
312 
313     function depositToken(address token, uint wad) public {
314         require(!suspendDeposit);
315         // remember to call TOKEN(address).approve(this, wad) first
316         require(ERC20(token).transferFrom(msg.sender, this, wad)); // transfer token
317         
318         // add new token to list
319         if (tokenMarket[token].level == 0) {
320             tokenList.push(token);
321             tokenMarket[token].level = 1;
322             tokenMarket[token].fee = marketDefaultFeeHigh;
323             MARKET_CHANGE(token);
324         }
325         
326         balance[token][msg.sender] = add(balance[token][msg.sender], wad); // set balance
327         DEPOSIT(msg.sender, token, wad, balance[token][msg.sender]);
328     }
329 
330     function withdrawETH(uint wad) public {
331         balance[0][msg.sender] = sub(balance[0][msg.sender], wad); // set amt first
332         require(balance[0][msg.sender] >= balanceLocked[0][msg.sender]); // can't withdraw locked ETH
333         msg.sender.transfer(wad); // send ETH
334         WITHDRAW(msg.sender, 0, wad, balance[0][msg.sender]);
335     }
336     
337     function withdrawToken(address token, uint wad) public {
338         require(token != 0); // not for withdrawing ETH
339         balance[token][msg.sender] = sub(balance[token][msg.sender], wad);
340         require(balance[token][msg.sender] >= balanceLocked[token][msg.sender]); // can't withdraw locked token
341         require(ERC20(token).transfer(msg.sender, wad)); // send token
342         WITHDRAW(msg.sender, token, wad, balance[token][msg.sender]);
343     }
344 }