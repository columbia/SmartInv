1 // SPDX-License-Identifier: MIT License
2 
3 /*
4 ░███████╗░█████╗░██╗██╗░░░░░  ██████╗░██████╗░░█████╗░░██╗░░░░░░░██╗
5 ██╔██╔══╝██╔══██╗██║██║░░░░░  ██╔══██╗██╔══██╗██╔══██╗░██║░░██╗░░██║
6 ╚██████╗░██║░░██║██║██║░░░░░  ██║░░██║██████╔╝███████║░╚██╗████╗██╔╝
7 ░╚═██╔██╗██║░░██║██║██║░░░░░  ██║░░██║██╔══██╗██╔══██║░░████╔═████║░
8 ███████╔╝╚█████╔╝██║███████╗  ██████╔╝██║░░██║██║░░██║░░╚██╔╝░╚██╔╝░
9 ╚══════╝░░╚════╝░╚═╝╚══════╝  ╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░
10 By: BR33D                                                         */
11 
12 pragma solidity ^0.8.11;
13 
14 interface iOIL {
15     function balanceOf(address address_) external view returns (uint); 
16     function transferFrom(address from_, address to_, uint amount) external returns (bool);
17     function burn(address from_, uint amount) external;
18 }
19 
20 contract OilDraw {
21 
22     address public owner;
23     address[] public players;
24     
25     uint256 public ticketPrice = 20000000000000000000000; // 20,000ETH
26     uint256 public drawId;
27 	uint256 public maxTicketsPerTx = 10;
28     
29     bool public drawLive = false;
30 
31     mapping (uint => address) public pastDraw;
32     mapping (address => uint256) public userEntries;
33 
34 
35     constructor() {
36         owner = msg.sender;
37         drawId = 1;
38     }
39 
40     address public oilAddress;
41     iOIL public Oil;
42     function setOil(address _address) external onlyOwner {
43         oilAddress = _address;
44         Oil = iOIL(_address);
45     }
46 
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52 
53     /*  ======================
54         |---Entry Function---|
55         ======================
56     */
57 
58     function enterDraw(uint256 _numOfTickets) public payable {
59         uint256 totalTicketCost = ticketPrice * _numOfTickets;
60         require(Oil.balanceOf(msg.sender) >= ticketPrice * _numOfTickets, "insufficent $Oil");
61         require(drawLive == true, "cannot enter at this time");
62         require(_numOfTickets <= maxTicketsPerTx, "too many per TX");
63 
64         uint256 ownerTicketsPurchased = userEntries[msg.sender];
65         require(ownerTicketsPurchased + _numOfTickets <= maxTicketsPerTx, "only allowed 10 tickets");
66         Oil.burn(msg.sender, totalTicketCost);
67 
68         // player ticket purchasing loop
69         for (uint256 i = 1; i <= _numOfTickets; i++) {
70             players.push(msg.sender);
71             userEntries[msg.sender]++;
72         }
73         
74     }
75 
76     /*  ======================
77         |---View Functions---|
78         ======================
79     */
80 
81     function getRandom() public view returns (uint) {
82         uint rand = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, block.coinbase)));
83         uint index = rand % players.length;
84         return index;
85     }
86 
87     function getPlayers() public view returns (address[] memory) {
88         return players;
89     }
90 
91     function drawEntrys() public view returns (uint) {
92         return players.length;
93     }
94 
95     function getWinnerByDraw(uint _drawId) public view returns (address) {
96         return pastDraw[_drawId];
97     }
98 
99     // Retrieves total entries of players address
100     function playerEntries(address _player) public view returns (uint256) {
101         address addressOfPlayer = _player;
102         uint arrayLength = players.length;
103         uint totalEntries = 0;
104         for (uint256 i; i < arrayLength; i++) {
105             if(players[i] == addressOfPlayer) {
106                 totalEntries++;
107             }
108             
109         }
110         return totalEntries;
111     }
112 
113 
114     /*  ============================
115         |---Owner Only Functions---|
116         ============================
117     */
118 
119     // Salt should be a random number from 1 - 1,000,000,000,000,000
120     function pickWinner(uint _firstSalt, uint _secondSalt) public onlyOwner {
121         uint rand = getRandom();
122         uint firstWinner = (rand + _firstSalt) % players.length;
123         uint secondWinner = (firstWinner + _secondSalt) % players.length;
124 
125         pastDraw[drawId] = players[firstWinner];
126         drawId++;
127         pastDraw[drawId] = players[secondWinner];
128         drawId++;
129     }
130 
131     function setTicketPrice(uint256 _newTicketPrice) public onlyOwner {
132         ticketPrice = _newTicketPrice;
133     }
134 
135     function setMaxTicket(uint256 _maxTickets) public onlyOwner {
136         maxTicketsPerTx = _maxTickets;
137     }
138 
139     function startEntries() public onlyOwner {
140         drawLive = true;
141     }
142 
143     function stopEntries() public onlyOwner {
144         drawLive = false;
145     }
146 
147     function transferOwnership(address _address) public onlyOwner {
148         owner = _address;
149     }
150 
151 }