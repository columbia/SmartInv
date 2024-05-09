1 pragma solidity ^0.4.18;
2 
3 contract WineMarket{
4 
5     bool public initialized=false;
6     address public ceoAddress;
7     address public ceoWallet;
8 
9     uint256 public marketWine;
10 
11     mapping (address => uint256) public totalWineTransferredFromVineyard;
12     mapping (address => uint256) public currentWineAmount;
13 
14     address constant public VINEYARD_ADDRESS = 0x66593d57B26Ed56Fd7881a016fcd0AF66636A9F0;
15     VineyardInterface vineyardContract;
16 
17     function WineMarket(address _wallet) public{
18         require(_wallet != address(0));
19         ceoAddress = msg.sender;
20         ceoWallet = _wallet;
21         vineyardContract = VineyardInterface(VINEYARD_ADDRESS);
22     }
23 
24     function transferWalletOwnership(address newWalletAddress) public {
25       require(msg.sender == ceoAddress);
26       require(newWalletAddress != address(0));
27       ceoWallet = newWalletAddress;
28     }
29 
30     modifier initializedMarket {
31         require(initialized);
32         _;
33     }
34 
35     function transferWineFromVineyardCellar() initializedMarket public {
36         require(vineyardContract.wineInCellar(msg.sender) > totalWineTransferredFromVineyard[msg.sender]);
37         // More wine bottles have been produced from Vineyard. Transfer the difference here.
38         uint256 wineToTransfer = SafeMath.sub(vineyardContract.wineInCellar(msg.sender),totalWineTransferredFromVineyard[msg.sender]);
39         currentWineAmount[msg.sender] = SafeMath.add(currentWineAmount[msg.sender],wineToTransfer);
40         totalWineTransferredFromVineyard[msg.sender] = SafeMath.add(totalWineTransferredFromVineyard[msg.sender],wineToTransfer);
41     }
42 
43     function consumeWine(uint256 numBottlesToConsume) initializedMarket public returns(uint256) {
44         require(currentWineAmount[msg.sender] > 0);
45         require(numBottlesToConsume <= currentWineAmount[msg.sender]);
46 
47         // Once wine is consumed, it is gone forever
48         currentWineAmount[msg.sender] = SafeMath.sub(currentWineAmount[msg.sender],numBottlesToConsume);
49 
50         // return amount consumed
51         return numBottlesToConsume;
52     }
53 
54     function sellWine(uint256 numBottlesToSell) initializedMarket public {
55         require(numBottlesToSell > 0);
56 
57         uint256 myAvailableWine = currentWineAmount[msg.sender];
58         uint256 adjustedNumBottlesToSell = numBottlesToSell;
59         if (numBottlesToSell > myAvailableWine) {
60           // don't allow sell larger than the owner actually has
61           adjustedNumBottlesToSell = myAvailableWine;
62         }
63         if (adjustedNumBottlesToSell > marketWine) {
64           // don't allow sell larger than the current market holdings
65           adjustedNumBottlesToSell = marketWine;
66         }
67 
68         uint256 wineValue = calculateWineSellSimple(adjustedNumBottlesToSell);
69         uint256 fee = devFee(wineValue);
70         currentWineAmount[msg.sender] = SafeMath.sub(myAvailableWine, adjustedNumBottlesToSell);
71         marketWine = SafeMath.add(marketWine,adjustedNumBottlesToSell);
72         ceoWallet.transfer(fee);
73         msg.sender.transfer(SafeMath.sub(wineValue, fee));
74     }
75 
76     function buyWine() initializedMarket public payable{
77         require(msg.value <= SafeMath.sub(this.balance,msg.value));
78 
79         uint256 fee = devFee(msg.value);
80         uint256 buyValue = SafeMath.sub(msg.value, fee);
81         uint256 wineBought = calculateWineBuy(buyValue, SafeMath.sub(this.balance, buyValue));
82         marketWine = SafeMath.sub(marketWine, wineBought);
83         ceoWallet.transfer(fee);
84         currentWineAmount[msg.sender] = SafeMath.add(currentWineAmount[msg.sender],wineBought);
85     }
86 
87     function calculateTrade(uint256 valueIn, uint256 marketInv, uint256 Balance) public pure returns(uint256) {
88         return SafeMath.div(SafeMath.mul(Balance, 10000), SafeMath.add(SafeMath.div(SafeMath.add(SafeMath.mul(marketInv,10000), SafeMath.mul(valueIn, 5000)), valueIn), 5000));
89     }
90 
91     function calculateWineSell(uint256 wine, uint256 marketWineValue) public view returns(uint256) {
92         return calculateTrade(wine, marketWineValue, this.balance);
93     }
94 
95     function calculateWineSellSimple(uint256 wine) public view returns(uint256) {
96         return calculateTrade(wine, marketWine, this.balance);
97     }
98 
99     function calculateWineBuy(uint256 eth,uint256 contractBalance) public view returns(uint256) {
100         return calculateTrade(eth,contractBalance,marketWine);
101     }
102 
103     function calculateWineBuySimple(uint256 eth) public view returns(uint256) {
104         return calculateWineBuy(eth,this.balance);
105     }
106 
107     function devFee(uint256 amount) public pure returns(uint256){
108         return SafeMath.div(SafeMath.mul(amount,3), 100);
109     }
110 
111     function seedMarket(uint256 wineBottles) public payable{
112         require(marketWine == 0);
113         require(ceoAddress == msg.sender);
114         initialized = true;
115         marketWine = wineBottles;
116     }
117 
118     function getBalance() public view returns(uint256) {
119         return this.balance;
120     }
121 
122     function getMyWine() public view returns(uint256) {
123         return SafeMath.add(SafeMath.sub(vineyardContract.wineInCellar(msg.sender),totalWineTransferredFromVineyard[msg.sender]),currentWineAmount[msg.sender]);
124     }
125 
126     function getMyTransferredWine() public view returns(uint256) {
127         return totalWineTransferredFromVineyard[msg.sender];
128     }
129 
130     function getMyAvailableWine() public view returns(uint256) {
131         return currentWineAmount[msg.sender];
132     }
133 }
134 
135 contract VineyardInterface {
136     function wineInCellar(address) public returns (uint256);
137 }
138 
139 library SafeMath {
140 
141   /**
142   * @dev Multiplies two numbers, throws on overflow.
143   */
144   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145     if (a == 0) {
146       return 0;
147     }
148     uint256 c = a * b;
149     assert(c / a == b);
150     return c;
151   }
152 
153   /**
154   * @dev Integer division of two numbers, truncating the quotient.
155   */
156   function div(uint256 a, uint256 b) internal pure returns (uint256) {
157     // assert(b > 0); // Solidity automatically throws when dividing by 0
158     uint256 c = a / b;
159     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160     return c;
161   }
162 
163   /**
164   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
165   */
166   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167     assert(b <= a);
168     return a - b;
169   }
170 
171   /**
172   * @dev Adds two numbers, throws on overflow.
173   */
174   function add(uint256 a, uint256 b) internal pure returns (uint256) {
175     uint256 c = a + b;
176     assert(c >= a);
177     return c;
178   }
179 }