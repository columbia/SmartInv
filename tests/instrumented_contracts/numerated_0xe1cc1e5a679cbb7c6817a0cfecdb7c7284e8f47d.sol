1 pragma solidity ^0.4.21;
2 
3 // ethvegas copy
4 
5 
6 
7 contract Memes{
8     address owner;
9     address helper=0x690F34053ddC11bdFF95D44bdfEb6B0b83CBAb58;
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
28     uint256 BasicPrice = .00666 ether;
29     struct Item{
30         address owner;
31         uint256 CPrice;
32         bool reset;
33     }
34     uint8 constant SIZE = 17;
35     Item[SIZE] public ItemList;
36     
37     address public PotOwner;
38     
39     
40     event ItemBought(address owner, uint256 newPrice, string says, uint8 id);
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
82         ItemList[9] = ITM;
83         ItemList[10] = ITM;
84         ItemList[11] = ITM;
85         ItemList[12] = ITM;
86         ItemList[13] = ITM;
87         ItemList[14] = ITM;
88         ItemList[15] = ITM;
89         ItemList[16] = ITM;
90         owner=msg.sender;
91     }
92     
93     
94     
95     function Buy(uint8 ID, string says) public payable {
96         require(ID < SIZE);
97         var ITM = ItemList[ID];
98         if (TimeFinish == 0){
99             // start game condition.
100             TimeFinish = block.timestamp; 
101         }
102         else if (TimeFinish == 1){
103             TimeFinish =block.timestamp + TimerResetTime;
104         }
105             
106         uint256 price = ITM.CPrice;
107         
108         if (ITM.reset){
109             price = BasicPrice;
110             
111         }
112         
113         if (msg.value >= price){
114             if (!ITM.reset){
115                 require(msg.sender != ITM.owner); // do not buy own item
116             }
117             if ((msg.value - price) > 0){
118                 // pay excess back. 
119                 msg.sender.transfer(msg.value - price);
120             }
121             uint256 LEFT = DoDev(price);
122             uint256 prev_val = 0;
123             // first item all LEFT goes to POT 
124             // not previous owner small fee .
125             uint256 pot_val = LEFT;
126             
127             address sender_target = owner;
128             
129             if (!ITM.reset){
130                 prev_val = (DIVP * LEFT)  / 10000;
131                 pot_val = (POTP * LEFT) / 10000;
132                 sender_target = ITM.owner; // we set sender_target to item owner
133             }
134             else{
135                 // Item is reset, send stuff to dev
136                 // Actually we can just send everything here aka LEFT
137                 prev_val = LEFT;
138                 pot_val = 0; // nothing in pot
139                 // no need to set sender value
140             }
141             
142             Pot = Pot + pot_val;
143             sender_target.transfer(prev_val); // send stuff to sender_target
144             ITM.owner = msg.sender;
145             uint256 incr = PIncr; // weird way of passing other types to new types.
146             ITM.CPrice = (price * (10000 + incr)) / 10000;
147 
148             // check if TimeFinish > block.timestamp; and not 0 otherwise not started
149             uint256 TimeLeft = TimeFinish - block.timestamp;
150             
151             if (TimeLeft< TimerStartTime){
152                 
153                 TimeFinish = block.timestamp + TimerStartTime;
154             }
155             if (ITM.reset){
156                 ITM.reset=false;
157             }
158             PotOwner = msg.sender;
159             // says is for later, for quotes in log. no gas used to save
160             emit ItemBought(msg.sender, ITM.CPrice, says, ID);
161         }  
162         else{
163             revert(); // user knows fail.
164         }
165     }
166     
167     
168     function DoDev(uint256 val) internal returns (uint256){
169         uint256 tval = (val * DEVP / 10000);
170         uint256 hval = (tval * HVAL) / 10000;
171         uint256 dval = tval - hval; 
172         
173         owner.transfer(dval);
174         helper.transfer(hval);
175         return (val-tval);
176     }
177     
178 }