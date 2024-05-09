1 pragma solidity ^0.4.24;
2 
3 contract PixelFactory {
4     address public contractOwner;
5     uint    public startPrice = 0.1 ether;
6     bool    public isInGame = false;
7     uint    public finishTime;
8     
9     uint    public lastWinnerId;
10     address public lastWinnerAddress;
11 
12     constructor() public {
13         contractOwner = msg.sender;
14     }
15 
16     modifier onlyOwner() {
17         require(msg.sender == contractOwner);
18         _;
19     }
20 
21     struct Pixel {
22         uint price;
23     }
24 
25     Pixel[] public pixels;
26 
27     mapping(uint => address) pixelToOwner;
28     mapping(address => string) ownerToUsername;
29 
30     /** ACCOUNT FUNCTIONS **/
31     event Username(string username);
32     
33     function setUsername(string username) public {
34         ownerToUsername[msg.sender] = username;
35         emit Username(username);
36     }
37     
38     function getUsername() public view returns(string) {
39         return ownerToUsername[msg.sender];
40     }
41 
42     /** GAME FUNCTIONS **/
43     // this function is triggered manually by owner after all pixels sold
44     function startGame() public onlyOwner {
45         require(isInGame == false);
46         isInGame = true;
47         finishTime = 86400 + now;
48     }
49     
50     function sendOwnerCommission() public payable onlyOwner {
51         contractOwner.transfer(msg.value);
52     } 
53      
54     function _sendWinnerJackpot(address winner) private {
55         uint jackpot = 10 ether;
56         winner.transfer(jackpot);
57     } 
58     
59     // this function is called to calculate countdown on the front side
60     function getFinishTime() public view returns(uint) {
61         return finishTime;
62     }
63     
64     function getLastWinner() public view returns(uint id, address addr) {
65         id = lastWinnerId;
66         addr = lastWinnerAddress;
67     }
68     
69     function _rand(uint min, uint max) private view returns(uint) {
70         return uint(keccak256(abi.encodePacked(now)))%(min+max)-min;
71     }
72     
73     // this function is triggered manually by owner to finish game after countdown stops
74     function finisGame() public onlyOwner {
75         require(isInGame == true);
76         isInGame = false;
77         finishTime = 0;
78 
79         // get winner id
80         uint winnerId = _rand(0, 399);
81         lastWinnerId = winnerId;
82         
83         // get winner address
84         address winnerAddress = pixelToOwner[winnerId];
85         lastWinnerAddress = winnerAddress;
86         
87         // transfer jackpot amount to winner
88         _sendWinnerJackpot(winnerAddress);
89         
90         // reset pixels
91         delete pixels;
92     }
93     
94     /** PIXEL FUNCTIONS **/
95     function createPixels(uint amount) public onlyOwner {
96         // it can be max 400 pixels
97         require(pixels.length + amount <= 400);
98         
99         // P.S. creating 400 pixels in one time is costing too much gas that's why we are using amount
100         
101         // system is creating pixels
102         for(uint i=0; i<amount; i++) {
103             uint id = pixels.push(Pixel(startPrice)) - 1;
104             pixelToOwner[id] = msg.sender;
105         }
106     }
107 
108     function getAllPixels() public view returns(uint[], uint[], address[]) {
109         uint[]    memory id           = new uint[](pixels.length);
110         uint[]    memory price        = new uint[](pixels.length);
111         address[] memory owner        = new address[](pixels.length);
112 
113         for (uint i = 0; i < pixels.length; i++) {
114             Pixel storage pixel = pixels[i];
115             
116             id[i]           = i;
117             price[i]        = pixel.price;
118             owner[i]        = pixelToOwner[i];
119         }
120 
121         return (id, price, owner);
122     }
123 
124     function _checkPixelIdExists(uint id) private constant returns(bool) {
125         if(id < pixels.length) return true;
126         return false;
127     }
128 
129     function _transfer(address to, uint id) private {
130         pixelToOwner[id] = to;
131     }
132 
133     function buy(uint id) external payable {
134         // checking pixel id exists before buying
135         require(_checkPixelIdExists(id) == true);
136 
137         // preparing pixel data
138         Pixel storage pixel = pixels[id];
139         uint currentPrice = pixel.price;
140         address currentOwner = pixelToOwner[id];
141         address newOwner = msg.sender;
142         
143         // cheking buyer is sending correct price for pixel
144         require(currentPrice == msg.value);
145         
146         // cheking buyer is not at the same time owner of pixel 
147         require(currentOwner != msg.sender);
148 
149         // calculating new price of pixel
150         uint newPrice = currentPrice * 2;
151         pixel.price = newPrice;
152 
153         // transfering money to current owner if current is not contractOwner, otherweise pot is collected in contract address
154         if(currentOwner != contractOwner) {
155             currentOwner.transfer(msg.value);
156         }
157         
158         // transfering pixel to new owner
159         _transfer(newOwner, id);
160     }
161 }