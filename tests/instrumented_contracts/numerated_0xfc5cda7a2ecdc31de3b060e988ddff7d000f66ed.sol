1 // Puzzle "Fifteen". 
2 // Numbers can be moved by puzzle owner to the empty place.
3 // The winner must put the numbers (1-4) in the first row in the correct order.
4 //
5 // Start position:
6 //---------------------
7 //| 15 | 14 | 13 | 12 |
8 //---------------------
9 //| 11 | 10 | 9  | 8  |
10 //---------------------
11 //| 7  | 6  | 5  | 4  |
12 //---------------------
13 //| 3  | 2  | 1  |    |
14 //---------------------
15 //
16 //site - https://puzzlefifteen.xyz/
17 
18 pragma solidity ^0.4.21;
19 
20 contract Payments {
21 
22   address public coOwner;
23   mapping(address => uint256) public payments; 
24 
25   function Payments() public {
26     //contract owner
27     coOwner = msg.sender;
28   }
29 
30   modifier onlyCoOwner() {
31     require(msg.sender == coOwner);
32     _;
33   }
34 
35   function transferCoOwnership(address _newCoOwner) public onlyCoOwner {
36     require(_newCoOwner != address(0));
37     coOwner = _newCoOwner;
38   }  
39   
40   function PayWins(address _winner) public {
41 	 require (payments[_winner] > 0 && _winner!=address(0) && this.balance >= payments[_winner]);
42 	 _winner.transfer(payments[_winner]);
43   }
44 
45 }
46 
47 contract Fifteen is Payments {
48   //puzzleId => row => column => value
49   mapping (uint8 => mapping (uint8 => mapping (uint8 => uint8))) public fifteenPuzzles;
50   mapping (uint8 => address) public puzzleIdOwner;
51   mapping (uint8 => uint256) public puzzleIdPrice;
52   uint256 private prevBlock;
53   uint256 public jackpot = 0;
54   
55   function initNewGame(uint8[16] _Numbers) public onlyCoOwner payable {
56      //set start win pot
57 	 //for example [15,14,13,12,1,2,3,4,7,6,5,11,10,9,8,0]
58 	 require (msg.value>0);
59 	 require (_Numbers.length == 16);
60 	 require (jackpot == 0); 
61 	 jackpot = msg.value;
62 	 
63 	 uint8 row=1;
64 	 uint8 col=1;
65 	 uint8 key;
66 	 
67 	 for (uint8 puzzleId=1; puzzleId<=6; puzzleId++) {
68 		puzzleIdOwner[puzzleId] = address(this);
69 		puzzleIdPrice[puzzleId] = 0.002 ether;
70 	 }	
71 	 for (key=0; key < 16; key++) {
72 		fifteenPuzzles[1][row][col]=_Numbers[key];
73 		fifteenPuzzles[2][row][col]=_Numbers[key];
74 		fifteenPuzzles[3][row][col]=_Numbers[key];
75 		fifteenPuzzles[4][row][col]=_Numbers[key];
76 		fifteenPuzzles[5][row][col]=_Numbers[key];
77 		fifteenPuzzles[6][row][col]=_Numbers[key];
78 		if (col==4 || col==8 || col==12) {
79 			col=0;
80 			row++;
81 		}
82 		col++;
83 	 }		
84 	 
85   } 
86 
87   function getPuzzle(uint8 _puzzleId) public constant returns(uint8[16] puzzleValues) {    
88 	 uint8 row;
89 	 uint8 col;
90 	 uint8 num = 0;
91 	 for (row=1; row<=4; row++) {
92 		for (col=1; col<=4; col++) {
93 			puzzleValues[num] = fifteenPuzzles[_puzzleId][row][col];
94 			num++;
95 		}
96 	 }	
97   }
98   
99   function changePuzzle(uint8 _puzzleId, uint8 _row, uint8 _col, uint8 _torow, uint8 _tocol) public gameNotStopped {  
100      
101 	 require(block.number != prevBlock);
102 	 require (msg.sender == puzzleIdOwner[_puzzleId]);
103 	 require (fifteenPuzzles[_puzzleId][_torow][_tocol] == 0); //free place is number 0
104 	 require (_row >= 1 && _row <= 4 && _col >= 1 && _col <= 4 && _torow >= 1 && _torow <= 4 && _tocol >= 1 && _tocol <= 4);
105 	 require ((_row == _torow && (_col-_tocol == 1 || _tocol-_col == 1)) || (_col == _tocol && (_row-_torow == 1 || _torow-_row== 1)));
106 	 
107 	 fifteenPuzzles[_puzzleId][_torow][_tocol] = fifteenPuzzles[_puzzleId][_row][_col];
108 	 fifteenPuzzles[_puzzleId][_row][_col] = 0;
109 	
110 	 prevBlock = block.number;	 
111 	 
112 	 if (fifteenPuzzles[_puzzleId][1][1] == 1 && 
113 	     fifteenPuzzles[_puzzleId][1][2] == 2 && 
114 		 fifteenPuzzles[_puzzleId][1][3] == 3 && 
115 		 fifteenPuzzles[_puzzleId][1][4] == 4) 
116 	 { // we have the winner - stop game
117 		msg.sender.transfer(jackpot);
118 		jackpot = 0; //stop game
119 	 }
120   }
121   
122   function buyPuzzle(uint8 _puzzleId) public gameNotStopped payable {
123   
124     address puzzleOwner = puzzleIdOwner[_puzzleId];
125     require(puzzleOwner != msg.sender && msg.sender != address(0));
126 
127     uint256 puzzlePrice = puzzleIdPrice[_puzzleId];
128     require(msg.value >= puzzlePrice);
129 	
130 	//new owner
131 	puzzleIdOwner[_puzzleId] = msg.sender;
132 	
133 	uint256 oldPrice = uint256(puzzlePrice/2);
134 	
135 	//new price
136 	puzzleIdPrice[_puzzleId] = uint256(puzzlePrice*2);	
137 
138 	
139 	//profit fee 20% from oldPrice ( or 10% from puzzlePrice )
140 	uint256 profitFee = uint256(oldPrice/5); 
141 	
142 	uint256 oldOwnerPayment = uint256(oldPrice + profitFee);
143 	
144 	//60% from oldPrice ( or 30% from puzzlePrice ) to jackpot
145     jackpot += uint256(profitFee*3);
146 	
147     if (puzzleOwner != address(this)) {
148       puzzleOwner.transfer(oldOwnerPayment); 
149 	  coOwner.transfer(profitFee); 
150     } else {
151       coOwner.transfer(oldOwnerPayment+profitFee); 
152 	}
153 
154 	//excess pay
155     if (msg.value > puzzlePrice) { 
156 		msg.sender.transfer(msg.value - puzzlePrice);
157 	}
158   }  
159   
160   modifier gameNotStopped() {
161     require(jackpot > 0);
162     _;
163   }    
164 
165 	
166 }