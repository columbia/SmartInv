1 pragma solidity ^ 0.4.23;
2 // tarot.etherealbazaar.com
3 contract EtherealTarot {
4 
5     struct reading { // Struct
6         uint8[] cards;
7         bool[] upright;
8         uint8 card_count;
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
73     return readings[msg.sender].card_count!=0;
74   }
75   function reading_card_at(uint8 index) view public returns(uint8) {
76     return readings[msg.sender].cards[index];
77   }
78   // returning variable length arrays proved quite tricky...
79   function reading_card_upright_at(uint8 index) view public returns(bool) {
80     return readings[msg.sender].upright[index];
81   }
82   function reading_card_count() view public returns(uint8){
83     return readings[msg.sender].card_count;
84   }
85   // Tarot by donation
86   function withdraw() public {
87     require(msg.sender == creator);
88     creator.transfer(address(this).balance);
89   }
90     
91   // 8 Different Spreads available
92   function career_path() payable public {
93     spread(7);
94   }
95 
96   function celtic_cross() payable public {
97     spread(10);
98   }
99 
100   function past_present_future() payable public {
101     spread(3);
102   }
103 
104   function success() payable public {
105     spread(5);
106   }
107 
108   function spiritual_guidance() payable public {
109     spread(8);
110   }
111 
112   function single_card() payable public {
113     spread(1);
114   }
115   
116   function situation_challenge() payable public {
117     spread(2);
118   }
119 
120   function seventeen() payable public {
121     spread(17);
122   }
123   
124 }