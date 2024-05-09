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
52   uint256 public jackpot = 0;
53   
54   function initNewGame() public onlyCoOwner payable {
55      //set start win pot
56 	 require (msg.value>0);
57 	 require (jackpot == 0); 
58 	 jackpot = msg.value;
59 	 
60 	 uint8 row;
61 	 uint8 col;
62 	 uint8 num;
63 	 
64 	 for (uint8 puzzleId=1; puzzleId<=6; puzzleId++) {
65 		num=15;
66 		puzzleIdOwner[puzzleId] = address(this);
67 		puzzleIdPrice[puzzleId] = 0.001 ether;
68 		for (row=1; row<=4; row++) {
69 			for (col=1; col<=4; col++) {
70 				fifteenPuzzles[puzzleId][row][col]=num;
71 				num--;
72 			}
73 		}
74 	 }
75 	 
76   } 
77 
78   function getPuzzle(uint8 _puzzleId) public constant returns(uint8[16] puzzleValues) {    
79 	 uint8 row;
80 	 uint8 col;
81 	 uint8 num = 0;
82 	 for (row=1; row<=4; row++) {
83 		for (col=1; col<=4; col++) {
84 			puzzleValues[num] = fifteenPuzzles[_puzzleId][row][col];
85 			num++;
86 		}
87 	 }	
88   }
89   
90   function changePuzzle(uint8 _puzzleId, uint8 _row, uint8 _col, uint8 _torow, uint8 _tocol) public gameNotStopped {  
91 	 require (msg.sender == puzzleIdOwner[_puzzleId]);
92 	 require (fifteenPuzzles[_puzzleId][_torow][_tocol] == 0); //free place is number 0
93 	 require (_row >= 1 && _row <= 4 && _col >= 1 && _col <= 4 && _torow >= 1 && _torow <= 4 && _tocol >= 1 && _tocol <= 4);
94 	 require ((_row == _torow && (_col-_tocol == 1 || _tocol-_col == 1)) || (_col == _tocol && (_row-_torow == 1 || _torow-_row== 1)));
95 	 
96 	 fifteenPuzzles[_puzzleId][_torow][_tocol] = fifteenPuzzles[_puzzleId][_row][_col];
97 	 fifteenPuzzles[_puzzleId][_row][_col] = 0;
98 	 
99 	 if (fifteenPuzzles[_puzzleId][1][1] == 1 && 
100 	     fifteenPuzzles[_puzzleId][1][2] == 2 && 
101 		 fifteenPuzzles[_puzzleId][1][3] == 3 && 
102 		 fifteenPuzzles[_puzzleId][1][4] == 4) 
103 	 { // we have the winner - stop game
104 		msg.sender.transfer(jackpot);
105 		jackpot = 0; //stop game
106 	 }
107   }
108   
109   function buyPuzzle(uint8 _puzzleId) public gameNotStopped payable {
110   
111     address puzzleOwner = puzzleIdOwner[_puzzleId];
112     require(puzzleOwner != msg.sender && msg.sender != address(0));
113 
114     uint256 puzzlePrice = puzzleIdPrice[_puzzleId];
115     require(msg.value >= puzzlePrice);
116 	
117 	//new owner
118 	puzzleIdOwner[_puzzleId] = msg.sender;
119 	
120 	uint256 oldPrice = uint256(puzzlePrice/2);
121 	
122 	//new price
123 	puzzleIdPrice[_puzzleId] = uint256(puzzlePrice*2);	
124 
125 	
126 	//profit fee 20% from oldPrice ( or 10% from puzzlePrice )
127 	uint256 profitFee = uint256(oldPrice/5); 
128 	
129 	uint256 oldOwnerPayment = uint256(oldPrice + profitFee);
130 	
131 	//60% from oldPrice ( or 30% from puzzlePrice ) to jackpot
132     jackpot += uint256(profitFee*3);
133 	
134     if (puzzleOwner != address(this)) {
135       puzzleOwner.transfer(oldOwnerPayment); 
136 	  coOwner.transfer(profitFee); 
137     } else {
138       coOwner.transfer(oldOwnerPayment+profitFee); 
139 	}
140 
141 	//excess pay
142     if (msg.value > puzzlePrice) { 
143 		msg.sender.transfer(msg.value - puzzlePrice);
144 	}
145   }  
146   
147   modifier gameNotStopped() {
148     require(jackpot > 0);
149     _;
150   }    
151 	
152 	
153 }