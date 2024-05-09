1 pragma solidity ^0.4.17;
2 
3 contract PreSale {
4     
5     event Pause();
6     event Unpause();
7 
8     address public adminAddress;
9 
10     bool public paused = false;
11     
12     modifier onlyAdmin() {
13         require(msg.sender == adminAddress);
14         _;
15     }
16     
17     modifier whenNotPaused() {
18         require(!paused);
19         _;
20     }
21 
22     modifier whenPaused() {
23         require(paused);
24         _;
25     }
26     
27     function pause() public onlyAdmin whenNotPaused returns(bool) {
28         paused = true;
29         Pause();
30         return true;
31     }
32 
33     function unpause() public onlyAdmin whenPaused returns(bool) {
34         paused = false;
35         Unpause();
36         return true;
37     }
38     
39     function PreSale() public {
40         paused = true;
41         adminAddress = msg.sender;
42     }
43     
44     function withdrawBalance() external onlyAdmin {
45         adminAddress.transfer(this.balance);
46     }
47     
48     function _random(uint _lower, uint _range, uint _jump) internal view returns (uint) {
49         uint number = uint(block.blockhash(block.number - _jump)) % _range;
50         if (number < _lower) {
51             number = _lower;
52         }
53         return number;
54     }
55     
56     event preSaleCreated(uint saleId, uint heroId, uint price);
57     event preSaleSuccess(address buyer, uint saleId, uint heroId, uint price);
58     event autoPreSaleSuccess(address buyer, uint heroId);
59     event priceChanged(uint saleId, uint newPrice);
60     event auctionCreated(uint auctionId, uint heroId, uint startPrice);
61     event bidSuccess(uint auctionId, address bidder, uint bidAmount);
62     event drawItemLottery(address player, uint numOfItem);
63     event drawHeroLottery(address player, bool win);
64 
65     
66     struct Sale {
67         uint heroId;
68         uint price;
69         bool ifSold;
70     }
71     
72     struct Auction {
73         uint heroId;
74         uint currentPrice;
75         address bidder;
76     }
77     
78     Sale[] sales;
79     Auction[] auctions;
80     
81     uint public oneEth = 1 ether;
82     
83     mapping (uint => address) public heroIdToBuyer;
84     mapping (address => uint) public BuyerLotteryTimes;
85     mapping (address => uint) public playerWinItems;
86     mapping (address => uint) public playerWinHeroes;
87     
88     function createPreSale(
89         uint _heroId,
90         uint _price
91     ) 
92         public 
93         onlyAdmin 
94         returns (uint)
95     {
96         Sale memory _sale = Sale({
97             heroId: _heroId,
98             price: _price,
99             ifSold: false
100         });
101         
102         uint newSaleId = sales.push(_sale) - 1;
103         
104         preSaleCreated(newSaleId, _heroId, _price);
105         
106         return newSaleId;
107     }
108     
109     function multiCreate(uint _startId, uint _amount, uint _price) public onlyAdmin {
110         for (uint i; i < _amount; i++) {
111             createPreSale(_startId + i, _price);
112         }
113     }
114     
115     function changePrice(uint _saleId, uint _price) public onlyAdmin {
116         Sale storage sale = sales[_saleId];
117         require(sale.ifSold == false);
118         sale.price = _price;
119         priceChanged(_saleId, _price);
120     }
121     
122     function totalSales() public view returns (uint) {
123         return sales.length;
124     }
125     
126     function buyPreSale(uint _saleId) 
127         public
128         payable
129         whenNotPaused
130     {
131         Sale storage _sale = sales[_saleId];
132         
133         require(_sale.ifSold == false);
134         uint _heroId = _sale.heroId;
135         uint _price = _sale.price;
136         require(msg.value >= _price);
137         require(heroIdToBuyer[_heroId] == address(0));
138         
139         heroIdToBuyer[_heroId] = msg.sender;
140         _sale.ifSold = true;
141         uint lotteryTime = _price/oneEth + 1;
142         BuyerLotteryTimes[msg.sender] += lotteryTime;
143         
144         preSaleSuccess(msg.sender, _saleId, _heroId, _price);
145         
146     }
147     uint public standFeeBefore500 = 800 finney;
148     uint public standFeeAfter500 = 500 finney;
149     function setAutoBuyFee(uint _fee, uint _pick) public onlyAdmin returns (uint) {
150         require(_pick == 0 || _pick == 1);
151         if (_pick == 0) {
152             standFeeBefore500 = _fee;
153             return standFeeBefore500;
154         } else if (_pick == 1) {
155             standFeeAfter500 = _fee;
156             return standFeeAfter500;
157         }
158     }
159     
160     
161     function autoBuy(uint _heroId) public payable whenNotPaused{
162         require(heroIdToBuyer[_heroId] == address(0));
163         require(_heroId >= 101 && _heroId <= 998);
164         require(_heroId != 200 && _heroId != 300 && _heroId != 400 && _heroId != 500 && _heroId != 600 && _heroId != 700 && _heroId != 800 && _heroId != 900);
165         require(_heroId != 111 && _heroId != 222 && _heroId != 333 && _heroId != 444 && _heroId != 555 && _heroId != 666 && _heroId != 777 && _heroId != 888 && _heroId != 999);
166         
167         if (_heroId < 500) {
168             require(msg.value >= standFeeBefore500);
169             heroIdToBuyer[_heroId] = msg.sender;
170         } else {
171             require(msg.value >= standFeeAfter500);
172             heroIdToBuyer[_heroId] = msg.sender;
173         }
174         
175         BuyerLotteryTimes[msg.sender] ++;
176         autoPreSaleSuccess(msg.sender, _heroId);
177     }
178     
179     function getPreSale(uint _saleId) public view returns(
180         uint heroId,
181         uint price,
182         address buyer
183     ) {
184         Sale memory sale = sales[_saleId];
185         
186         heroId = sale.heroId;
187         price = sale.price;
188         buyer = heroIdToBuyer[heroId];
189     }
190     
191     function createAuction(uint _heroId, uint _startPrice) public onlyAdmin returns (uint) {
192         Auction memory auction = Auction({
193             heroId: _heroId,
194             currentPrice: _startPrice,
195             bidder: address(0)
196         });
197         uint newAuctionId = auctions.push(auction) - 1;
198         
199         auctionCreated(newAuctionId, _heroId, _startPrice);
200         
201         return newAuctionId;
202     }
203     
204     uint public transferFee = 10 finney;
205     
206     function setTransferFee(uint _fee) public onlyAdmin {
207         transferFee = _fee;
208     }
209     
210     function bidAuction(uint _auctionId) public payable whenNotPaused{
211         Auction storage auction = auctions[_auctionId];
212         require(auction.bidder != msg.sender);
213         require(msg.value > auction.currentPrice);
214         if (auction.bidder != address(0)) {
215             address lastBidder = auction.bidder;
216             lastBidder.transfer(auction.currentPrice - transferFee);
217         }
218         auction.currentPrice = msg.value;
219         auction.bidder = msg.sender;
220         BuyerLotteryTimes[msg.sender] ++;
221         
222         bidSuccess(_auctionId, msg.sender, msg.value);
223     }
224     
225     function getAuction(uint _auctionId) public view returns (
226         uint heroId,
227         uint currentPrice,
228         address bidder
229     ) {
230         Auction memory auction = auctions[_auctionId];
231         
232         heroId = auction.heroId;
233         currentPrice = auction.currentPrice;
234         bidder = auction.bidder;
235     }
236     
237     function totalAuctions() public view returns (uint) {
238         return auctions.length;
239     }
240     
241     function _ItemRandom(uint _jump) internal view returns (uint) {
242         uint num = _random(0,1000,_jump);
243         if (num >= 0 && num <= 199) {
244             return 2;
245         } else if (num >= 200 && num <= 449) {
246             return 1;
247         } else if (num >= 450 && num <= 649) {
248             return 0;
249         } else if (num >= 650 && num <= 799) {
250             return 3;
251         } else if (num >= 800 && num <= 899) {
252             return 4;
253         } else if (num >= 900 && num <= 969) {
254             return 5;
255         } else if (num >= 970 && num <= 999) {
256             return 6;
257         }
258     }
259     
260     uint rad = _random(1,13,1);
261     
262     function itemLottery() public whenNotPaused returns (uint) {
263         require(BuyerLotteryTimes[msg.sender] >= 1);
264         uint _jump = _random(1, 89, rad);
265         if (rad < 13) {
266             rad ++;
267         } else {
268             rad = 1;
269         }
270         BuyerLotteryTimes[msg.sender] --;
271         uint result = _ItemRandom(_jump);
272         playerWinItems[msg.sender] += result;
273         drawItemLottery(msg.sender, result);
274         return result;
275     }
276     
277     function heroLottery() public whenNotPaused returns (bool) {
278         require(BuyerLotteryTimes[msg.sender] >= 1);
279         uint _jump = _random(1, 89, rad);
280         if (rad < 13) {
281             rad ++;
282         } else {
283             rad = 1;
284         }
285         BuyerLotteryTimes[msg.sender] --;
286         bool result = false;
287         uint lottery = _random(10, 100, _jump);
288         if (lottery == 10) {
289             result = true;
290             playerWinHeroes[msg.sender] ++;
291         }
292         drawHeroLottery(msg.sender, result);
293         return result;
294     }
295     
296 }