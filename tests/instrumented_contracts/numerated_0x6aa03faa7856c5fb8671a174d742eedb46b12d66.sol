1 pragma solidity ^0.4.21;
2 
3 // ethvegas copy
4 
5 
6 
7 contract Memes{
8     address owner;
9     address helper=0x26581d1983ced8955C170eB4d3222DCd3845a092;
10 
11     uint256 public TimeFinish = 0;
12     uint256 TimerResetTime = 7200; // 2 hours cooldown @ new game 
13     uint256 TimerStartTime = 360000; 
14     uint256 public Pot = 0;
15     // Price increase in percent divided (10k = 100% = 2x increase.)
16     uint16 PIncr = 10000; // % 100%
17     // part of left amount going to previous
18     uint16 DIVP = 10000; // 
19     // part of left amount going to pot 
20     uint16 POTP = 0; // DIVP and POTP are both 100; scaled to dev factor.
21     // part of pot going to winner 
22     uint16 WPOTPART = 9000; // % in pot part going to owner.
23     
24     // Dev fee 
25     uint16 public DEVP = 500;
26     // Helper factor fee 
27     uint16 public HVAL = 5000;
28     uint256 BasicPrice = 1 finney;
29     struct Item{
30         address owner;
31         uint256 CPrice;
32         bool reset;
33     }
34     uint8 constant SIZE = 9;
35     Item[SIZE] public ItemList;
36     
37     address public PotOwner;
38     
39     
40     event ItemBought(address owner, uint256 newPrice, uint256 newPot, uint256 Timer, string says, uint8 id);
41     // owner wins paid , new pot is npot
42     event GameWon(address owner, uint256 paid, uint256 npot);
43     
44     modifier OnlyOwner(){
45         if (msg.sender == owner){
46             _;
47         }
48         else{
49             revert();
50         }
51     }
52     
53     function SetDevFee(uint16 tfee) public OnlyOwner{
54         require(tfee <= 500);
55         DEVP = tfee;
56     }
57     
58     // allows to change helper fee. minimum is 10%, max 100%. 
59     function SetHFee(uint16 hfee) public OnlyOwner {
60         require(hfee <= 10000);
61         require(hfee >= 1000);
62         HVAL = hfee;
63     
64     }
65     
66     
67     // constructor 
68     function Memes() public {
69         // create items ;
70         
71         // clone ??? 
72         var ITM = Item(msg.sender, BasicPrice, true );
73         ItemList[0] = ITM; // blackjack 
74         ItemList[1] = ITM; // roulette 
75         ItemList[2] = ITM; // poker 
76         ItemList[3] = ITM; // slots 
77         ItemList[4] = ITM; // 
78         ItemList[5] = ITM; // other weird items 
79         ItemList[6] = ITM;
80         ItemList[7] = ITM;
81         ItemList[8] = ITM;
82         owner=msg.sender;
83     }
84     
85     function Payout() public {
86         require(TimeFinish < block.timestamp);
87         require(TimeFinish > 1);
88         uint256 pay = (Pot * WPOTPART)/10000;
89         Pot = Pot - pay;
90         PotOwner.transfer(pay);
91         TimeFinish = 1; // extra setting time never 1 due miners. reset count
92         // too much gas
93         for (uint8 i = 0; i <SIZE; i++ ){
94            ItemList[i].reset= true;
95         }
96         emit GameWon(PotOwner, pay, Pot);
97     }
98     
99     function Buy(uint8 ID, string says) public payable {
100         require(ID < SIZE);
101         var ITM = ItemList[ID];
102         if (TimeFinish == 0){
103             // start game condition.
104             TimeFinish = block.timestamp; 
105         }
106         else if (TimeFinish == 1){
107             TimeFinish =block.timestamp + TimerResetTime;
108         }
109             
110         uint256 price = ITM.CPrice;
111         
112         if (ITM.reset){
113             price = BasicPrice;
114             
115         }
116         
117         if (TimeFinish < block.timestamp){
118             // game done 
119            Payout();
120            msg.sender.transfer(msg.value);
121         }
122         else if (msg.value >= price){
123             if (!ITM.reset){
124                 require(msg.sender != ITM.owner); // do not buy own item
125             }
126             if ((msg.value - price) > 0){
127                 // pay excess back. 
128                 msg.sender.transfer(msg.value - price);
129             }
130             uint256 LEFT = DoDev(price);
131             uint256 prev_val = 0;
132             // first item all LEFT goes to POT 
133             // not previous owner small fee .
134             uint256 pot_val = LEFT;
135             if (!ITM.reset){
136                 prev_val = (DIVP * LEFT)  / 10000;
137                 pot_val = (POTP * LEFT) / 10000;
138             }
139             
140             Pot = Pot + pot_val;
141             ITM.owner.transfer(prev_val);
142             ITM.owner = msg.sender;
143             uint256 incr = PIncr; // weird way of passing other types to new types.
144             ITM.CPrice = (price * (10000 + incr)) / 10000;
145 
146             // check if TimeFinish > block.timestamp; and not 0 otherwise not started
147             uint256 TimeLeft = TimeFinish - block.timestamp;
148             
149             if (TimeLeft< TimerStartTime){
150                 
151                 TimeFinish = block.timestamp + TimerStartTime;
152             }
153             if (ITM.reset){
154                 ITM.reset=false;
155             }
156             PotOwner = msg.sender;
157             // says is for later, for quotes in log. no gas used to save
158             emit ItemBought(msg.sender, ITM.CPrice, Pot, TimeFinish, says, ID);
159         }  
160         else{
161             revert(); // user knows fail.
162         }
163     }
164     
165     
166     function DoDev(uint256 val) internal returns (uint256){
167         uint256 tval = (val * DEVP / 10000);
168         uint256 hval = (tval * HVAL) / 10000;
169         uint256 dval = tval - hval; 
170         
171         owner.transfer(dval);
172         helper.transfer(hval);
173         return (val-tval);
174     }
175     
176 }