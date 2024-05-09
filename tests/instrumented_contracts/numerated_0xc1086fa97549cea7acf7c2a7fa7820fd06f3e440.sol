1 pragma solidity ^0.4.21;
2 
3 // Dev fee payout contract + dividend options 
4 // EtherGuy DApp fee will be stored here 
5 // Buying any token gives right to claim 
6 // UI: etherguy.surge.sh/dividend.html
7 // Made by EtherGuy, etherguy@mail.com 
8 
9 // IF THERE IS ANY BUG the data will be rerolled from here. See the discord https://discord.gg/R84hD6f if anything happens or mail me 
10 
11 
12 contract Dividends{
13     // 10 million token supply 
14     uint256 constant TokenSupply = 10000000;
15     
16     uint256 public TotalPaid = 0;
17     
18     uint16 public Tax = 1250; 
19     
20     address dev;
21     
22     mapping (address => uint256) public MyTokens;
23     mapping (address => uint256) public DividendCollectSince;
24     
25     // TKNS / PRICE 
26     mapping(address => uint256[2]) public SellOrder;
27     
28     // web 
29     // returns tokens + price (in wei)
30     function GetSellOrderDetails(address who) public view returns (uint256, uint256){
31         return (SellOrder[who][0], SellOrder[who][1]);
32     }
33     
34     function ViewMyTokens(address who) public view returns (uint256){
35         return MyTokens[who];
36     }
37     
38     function ViewMyDivs(address who) public view returns (uint256){
39         uint256 tkns = MyTokens[who];
40         if (tkns==0){
41             return 0;
42         }
43         return (GetDividends(who, tkns));
44     }
45     
46     function Bal() public view returns (uint256){
47         return (address(this).balance);
48     }
49     
50     // >MINT IT
51     function Dividends() public {
52         dev = msg.sender;
53         // EG
54         MyTokens[msg.sender] = TokenSupply - 400000;
55         // HE
56         MyTokens[address(0x83c0Efc6d8B16D87BFe1335AB6BcAb3Ed3960285)] = 200000;
57         // PG
58         MyTokens[address(0x26581d1983ced8955C170eB4d3222DCd3845a092)] = 200000;
59         //MyTokens[address(0x0)] = 400000;
60         PlaceSellOrder(1600000, (0.5 szabo)); // 1 token per 0.5 szabo / 500 gwei or 1000 tokens per 0.5 finney / 0.0005 ether or 1M tokens per 0.5 ETH 
61     }
62     
63     function GetDividends(address who, uint256 TokenAmount) internal view  returns(uint256){
64         if (TokenAmount == 0){
65             return 0;
66         }
67         uint256 TotalContractIn = address(this).balance + TotalPaid;
68         // division rounds DOWN so we never pay too much
69         // no revert errors due to this. 
70         
71         uint256 MyBalance = sub(TotalContractIn, DividendCollectSince[who]);
72         
73         return  ((MyBalance * TokenAmount) / (TokenSupply));
74     }
75     
76 
77     event Sold(address Buyer, address Seller, uint256 price, uint256 tokens);
78     function Buy(address who) public payable {
79        // require(msg.value >= (1 szabo)); // normal amounts pls 
80         // lookup order by addr 
81         uint256[2] memory order = SellOrder[who];
82         uint256 amt_available = order[0];
83         uint256 price = order[1];
84         
85         uint256 excess = 0;
86         
87         // nothing to sell 
88         if (amt_available == 0){
89             revert();
90         }
91         
92         uint256 max = amt_available * price; 
93         uint256 currval = msg.value;
94         // more than max buy value 
95         if (currval > max){
96             excess = (currval-max);
97             currval = max;
98         }
99         
100 
101 
102 
103         uint256 take = currval / price;
104         
105         if (take == 0){
106             revert(); // very high price apparently 
107         }
108         excess = excess + sub(currval, take * price); 
109 
110         
111         if (excess > 0){
112             msg.sender.transfer(excess);
113         }
114         
115         currval = sub(currval,excess);
116         
117         // pay fees 
118 
119         uint256 fee = (Tax * currval)/10000;
120         dev.transfer(fee);
121         who.transfer(currval-fee);
122         
123         // the person with these tokens will also receive dividend over this buy order (this.balance)
124         // however the excess is removed, see the excess transfer above 
125      //   if (msg.value > (excess+currval+fee)){
126       //      msg.sender.transfer(msg.value-excess-currval-fee);
127      //   }
128         _withdraw(who, MyTokens[who]);
129         if (MyTokens[msg.sender] > 0){
130             
131             _withdraw(msg.sender, MyTokens[msg.sender]);
132         }
133         MyTokens[who] = MyTokens[who] - take; 
134         SellOrder[who][0] = SellOrder[who][0]-take; 
135         MyTokens[msg.sender] = MyTokens[msg.sender] + take;
136     //    MyPayouts[msg.sender] = MyPayouts[msg.sender] + GetDividends(msg.sender, take);
137         DividendCollectSince[msg.sender] = (address(this).balance) + TotalPaid;
138         
139         emit Sold(msg.sender, who, price, take);
140        // push((excess + currval)/(1 finney), (msg.value)/(1 finney));
141     }
142     
143     function Withdraw() public {
144         _withdraw(msg.sender, MyTokens[msg.sender]);
145     }
146     
147     function _withdraw(address who, uint256 amt) internal{
148         // withdraws from amt. 
149         // (amt not used in current code, always same value)
150         if (MyTokens[who] < amt){
151             revert(); // ??? security check 
152         }
153         
154         uint256 divs = GetDividends(who, amt);
155         
156         who.transfer(divs);
157         TotalPaid = TotalPaid + divs;
158         
159         DividendCollectSince[who] = TotalPaid + address(this).balance;
160     }
161     
162     event SellOrderPlaced(address who, uint256 amt, uint256 price);
163     function PlaceSellOrder(uint256 amt, uint256 price) public {
164         // replaces old order 
165         if (amt > MyTokens[msg.sender]){
166             revert(); // ?? more sell than you got 
167         }
168         SellOrder[msg.sender] = [amt,price];
169         emit SellOrderPlaced(msg.sender, amt, price);
170     }
171     
172     function ChangeTax(uint16 amt) public {
173         require (amt <= 2500);
174         require(msg.sender == dev);
175         Tax=amt;
176     }
177     
178     
179     // dump divs in contract 
180     function() public payable {
181         
182     }
183     
184     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185         assert(b <= a);
186         return a - b;
187     } 
188     
189 }