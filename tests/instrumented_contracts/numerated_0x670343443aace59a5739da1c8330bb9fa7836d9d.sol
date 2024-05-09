1 pragma solidity ^ 0.4 .23;
2 //Ethereal Tarot Reader http://tarot.etherealbazaar.com/
3 contract EtherealTarot {
4 
5   mapping(address => uint8[]) readings;
6   mapping(address => uint8[]) orientations;
7   uint8[78] cards;
8   uint8 deckSize = 78;
9   address public creator;
10 
11   constructor() public {
12     creator = msg.sender;
13     for (uint8 card = 0; card < deckSize; card++) {
14       cards[card] = card;
15     }
16   }
17     
18   function draw(uint8 index, uint8 count) public {
19     // put the drawn card at the end of the array
20     // so the next random draw cannot contain
21     // a card thats already been drawn
22     uint8 drawnCard = cards[index];
23     uint8 tableIndex = deckSize - count - 1;
24     cards[index] = cards[tableIndex];
25     cards[tableIndex] = drawnCard;
26   }
27 
28   function draw_random_card(uint8 count) private returns(uint8) {
29     uint8 random_card = random(deckSize - count, count);
30     draw(random_card, count);
31     return random_card;
32   }
33 
34   function random(uint8 range, uint8 count) view private returns(uint8) {
35     uint8 _seed = uint8(
36       keccak256(
37         abi.encodePacked(
38           keccak256(
39             abi.encodePacked(
40               blockhash(block.number),
41               _seed)
42           ), now + count)
43       )
44     );
45     return _seed % (range);
46   }
47 
48   function spread(uint8 requested) private {
49     // cards in the current spread
50     uint8[] memory table = new uint8[](requested);
51     //card orientation 0 is front 1 is reversed
52     uint8[] memory oriented = new uint8[](requested);
53 
54     //Draw the whole spread
55     for (uint8 position = 0; position < requested; position++) {
56       table[position] = draw_random_card(position);
57       oriented[position] = random(2, position);
58     }
59     orientations[msg.sender] = oriented;
60     readings[msg.sender] = table;
61   }
62 
63 
64   function orientation() view public returns(uint8[]) {
65     return orientations[msg.sender];
66   }
67 
68   function reading() view public returns(uint8[]) {
69     return readings[msg.sender];
70   }
71 
72   // Tarot by donation + gas costs
73   function withdraw() public {
74     require(msg.sender == creator);
75     creator.transfer(address(this).balance);
76   }
77     
78   function shiva() public{
79     require(msg.sender == creator);
80     selfdestruct(creator);
81   }
82 
83   // 6 Different Spreads available
84   function career_path() payable public {
85     spread(7);
86   }
87 
88   function celtic_cross() payable public {
89     spread(10);
90   }
91 
92   function past_present_future() payable public {
93     spread(3);
94   }
95 
96   function success() payable public {
97     spread(5);
98   }
99 
100   function spiritual_guidance() payable public {
101     spread(8);
102   }
103 
104   function one_card() payable public {
105     spread(1);
106   }
107   function two_card() payable public {
108     spread(2);
109   }
110 
111   function seventeen() payable public {
112     spread(17);
113   }
114   
115 }