1 pragma solidity ^0.4.21;
2 
3 // Simple formulas;
4 // Need MORE than this prevPayment to make previous owners get profit;
5 
6 // Note: Increase of 100% in contract is the number 2 here (doubles price)
7 
8 // PreviousFee = 1 / (Increase(1-devFee));
9 // Profit calculation if someone buys item;
10 // Profit = Increase(1-devFee)*previousOwner - 1; (in %)
11 
12 // RULES 
13 // First item all money goes into pot. 
14 // First item: No previous fee.  
15 // After buy item: Timer reset, price increase, winner changes to new buyer,
16 // part of amount goes to previous owner 
17 // After timer is gone: 
18 // Payout pot to winner, there will stay a small amount in pot 
19 // Timer will reset, but now increase with TimerResetTime, 
20 // This means next round will start with timer a bit longer than normal
21 // This is a cooldown period.
22 // After buy, timer will increase to start time. 
23 // Timer cannot decrease 
24 
25 // HOW TO MAKE PROFIT 
26 // Biggest way to make profit is usually to win game 
27 // Losers: bag holders of items @ win 
28 // Winners: everyone who sells bag or wins game 
29 // There are some exception to win game, if you buy 
30 // an expensive item while cheaper ones are around then
31 // you might still lose 
32 // Buy cheapest items (sounds logical)
33 
34 // HOW TO CHECK IF YOU MAKE PROFIT 
35 // If the current pot win is HIGHER than item you want to buy 
36 // You will make profit if you win pot 
37 // You will ALWAYS make profit if someone buys your item 
38 // If the game is won and no one has bought your item, you have LOST
39 
40 
41 
42 contract LasVegas{
43     address owner;
44     address helper=0x30B3E09d9A81D6B265A573edC7Cc4C4fBc0B0586;
45 
46     uint256 public TimeFinish = 0;
47     uint256 TimerResetTime = 7200; // 2 hours cooldown @ new game 
48     uint256 TimerStartTime = 3600; 
49     uint256 public Pot = 0;
50     // Price increase in percent divided (10k = 100% = 2x increase.)
51     uint16 PIncr = 10000; // % 100%
52     // part of left amount going to previous
53     uint16 DIVP = 6500; // 
54     // part of left amount going to pot 
55     uint16 POTP = 3500; // DIVP and POTP are both 100; scaled to dev factor.
56     // part of pot going to winner 
57     uint16 WPOTPART = 9000; // % in pot part going to owner.
58     
59     // Dev fee 
60     uint16 public DEVP = 350;
61     // Helper factor fee 
62     uint16 public HVAL = 2000;
63     uint256 BasicPrice = 1 finney;
64     struct Item{
65         address owner;
66         uint256 CPrice;
67         bool reset;
68     }
69     uint8 constant SIZE = 9;
70     Item[SIZE] public ItemList;
71     
72     address public PotOwner;
73     
74     
75     event ItemBought(address owner, uint256 newPrice, uint256 newPot, uint256 Timer, string says, uint8 id);
76     // owner wins paid , new pot is npot
77     event GameWon(address owner, uint256 paid, uint256 npot);
78     
79     modifier OnlyOwner(){
80         if (msg.sender == owner){
81             _;
82         }
83         else{
84             revert();
85         }
86     }
87     
88     function SetDevFee(uint16 tfee) public OnlyOwner{
89         require(tfee <= 500);
90         DEVP = tfee;
91     }
92     
93     // allows to change helper fee. minimum is 10%, max 100%. 
94     function SetHFee(uint16 hfee) public OnlyOwner {
95         require(hfee <= 10000);
96         require(hfee >= 1000);
97         HVAL = hfee;
98     
99     }
100     
101     
102     // constructor 
103     function LasVegas() public {
104         // create items ;
105         
106         // clone ??? 
107         var ITM = Item(msg.sender, BasicPrice, true );
108         ItemList[0] = ITM; // blackjack 
109         ItemList[1] = ITM; // roulette 
110         ItemList[2] = ITM; // poker 
111         ItemList[3] = ITM; // slots 
112         ItemList[4] = ITM; // 
113         ItemList[5] = ITM; // other weird items 
114         ItemList[6] = ITM;
115         ItemList[7] = ITM;
116         ItemList[8] = ITM;
117         owner=msg.sender;
118     }
119     
120     function Payout() public {
121         require(TimeFinish < block.timestamp);
122         require(TimeFinish > 1);
123         uint256 pay = (Pot * WPOTPART)/10000;
124         Pot = Pot - pay;
125         PotOwner.transfer(pay);
126         TimeFinish = 1; // extra setting time never 1 due miners. reset count
127         // too much gas
128         for (uint8 i = 0; i <SIZE; i++ ){
129            ItemList[i].reset= true;
130         }
131         emit GameWon(PotOwner, pay, Pot);
132     }
133     
134     function Buy(uint8 ID, string says) public payable {
135         require(ID < SIZE);
136         var ITM = ItemList[ID];
137         if (TimeFinish == 0){
138             // start game condition.
139             TimeFinish = block.timestamp; 
140         }
141         else if (TimeFinish == 1){
142             TimeFinish =block.timestamp + TimerResetTime;
143         }
144             
145         uint256 price = ITM.CPrice;
146         
147         if (ITM.reset){
148             price = BasicPrice;
149             
150         }
151         
152         if (TimeFinish < block.timestamp){
153             // game done 
154            Payout();
155            msg.sender.transfer(msg.value);
156         }
157         else if (msg.value >= price){
158             if (!ITM.reset){
159                 require(msg.sender != ITM.owner); // do not buy own item
160             }
161             if ((msg.value - price) > 0){
162                 // pay excess back. 
163                 msg.sender.transfer(msg.value - price);
164             }
165             uint256 LEFT = DoDev(price);
166             uint256 prev_val = 0;
167             // first item all LEFT goes to POT 
168             // not previous owner small fee .
169             uint256 pot_val = LEFT;
170             if (!ITM.reset){
171                 prev_val = (DIVP * LEFT)  / 10000;
172                 pot_val = (POTP * LEFT) / 10000;
173             }
174             
175             Pot = Pot + pot_val;
176             ITM.owner.transfer(prev_val);
177             ITM.owner = msg.sender;
178             uint256 incr = PIncr; // weird way of passing other types to new types.
179             ITM.CPrice = (price * (10000 + incr)) / 10000;
180 
181             // check if TimeFinish > block.timestamp; and not 0 otherwise not started
182             uint256 TimeLeft = TimeFinish - block.timestamp;
183             
184             if (TimeLeft< TimerStartTime){
185                 
186                 TimeFinish = block.timestamp + TimerStartTime;
187             }
188             if (ITM.reset){
189                 ITM.reset=false;
190             }
191             PotOwner = msg.sender;
192             // says is for later, for quotes in log. no gas used to save
193             emit ItemBought(msg.sender, ITM.CPrice, Pot, TimeFinish, says, ID);
194         }  
195         else{
196             revert(); // user knows fail.
197         }
198     }
199     
200     
201     function DoDev(uint256 val) internal returns (uint256){
202         uint256 tval = (val * DEVP / 10000);
203         uint256 hval = (tval * HVAL) / 10000;
204         uint256 dval = tval - hval; 
205         
206         owner.transfer(dval);
207         helper.transfer(hval);
208         return (val-tval);
209     }
210     
211 }