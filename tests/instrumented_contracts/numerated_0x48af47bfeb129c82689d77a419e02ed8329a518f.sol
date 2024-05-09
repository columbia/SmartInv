1 pragma solidity ^ 0.4.23;
2 // tarot.etherealbazaar.com
3 contract EtherealTarot {
4 
5     struct reading { // Struct
6         uint8[] cards;
7         bool[] upright;
8         uint8 count;
9     }
10 
11   mapping(address => reading) readings;
12 
13   uint8[78] cards;
14   uint8 deckSize = 78;
15   address public creator;
16 
17   constructor() public {
18     creator = msg.sender;
19     for (uint8 card = 0; card < deckSize; card++) {
20       cards[card] = card;
21     }
22   }
23     
24   function draw(uint8 index, uint8 count) private {
25     // put the drawn card at the end of the array
26     // so the next random draw cannot contain
27     // a card thats already been drawn
28     uint8 drawnCard = cards[index];
29     uint8 tableIndex = deckSize - count - 1;
30     cards[index] = cards[tableIndex];
31     cards[tableIndex] = drawnCard;
32   }
33 
34   function draw_random_card(uint8 count) private returns(uint8) {
35     uint8 random_card = random(deckSize - count, count);
36     draw(random_card, count);
37     return random_card;
38   }
39 
40   function random(uint8 range, uint8 count) view private returns(uint8) {
41     uint8 _seed = uint8(
42       keccak256(
43         abi.encodePacked(
44           keccak256(
45             abi.encodePacked(
46               blockhash(block.number),
47               _seed)
48           ), now + count)
49       )
50     );
51     return _seed % (range);
52   }
53   function random_bool(uint8 count) view private returns(bool){
54       return 0==random(2,count);
55   }
56 
57   function spread(uint8 requested) private {
58     // cards in the current spread
59     uint8[] memory table = new uint8[](requested);
60     // reversed cards aren't all bad! understand the shadow...
61     bool[] memory upright = new bool[](requested);
62 
63     //Draw the whole spread
64     for (uint8 position = 0; position < requested; position++) {
65       table[position] = draw_random_card(position);
66       upright[position] = random_bool(position);
67     }
68     readings[msg.sender]=reading(table,upright,requested);
69   }
70 
71 
72   function has_reading() view public returns(bool) {
73     return readings[msg.sender].count!=0;
74   }
75   function reading_card_at(uint8 index) view public returns(uint8) {
76     return readings[msg.sender].cards[index];
77   }
78   function reading_card_upright_at(uint8 index) view public returns(bool) {
79     return readings[msg.sender].upright[index];
80   }
81 
82   // Tarot by donation + gas costs
83   function withdraw() public {
84     require(msg.sender == creator);
85     creator.transfer(address(this).balance);
86   }
87     
88   // 8 Different Spreads available
89   function career_path() payable public {
90     spread(7);
91   }
92 
93   function celtic_cross() payable public {
94     spread(10);
95   }
96 
97   function past_present_future() payable public {
98     spread(3);
99   }
100 
101   function success() payable public {
102     spread(5);
103   }
104 
105   function spiritual_guidance() payable public {
106     spread(8);
107   }
108 
109   function single_card() payable public {
110     spread(1);
111   }
112   function situation_challenge() payable public {
113     spread(2);
114   }
115 
116   function seventeen() payable public {
117     spread(17);
118   }
119   
120 }