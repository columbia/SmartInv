1 pragma solidity ^0.4.18;
2 
3 contract CoinStacks {
4 
5   // Contract owner
6   address private admin;
7 
8   // Game parameters
9   uint256 private constant BOTTOM_LAYER_BET = 0.005 ether;
10   uint16 private constant INITIAL_UNLOCKED_COLUMNS = 10;
11   uint256 private maintenanceFeePercent;
12   uint private  NUM_COINS_TO_HIT_JACKPOT = 30; // every 30th coin placed win a prize
13   uint private MIN_AVG_HEIGHT = 5;
14   uint256 private constant JACKPOT_PRIZE = 2 * BOTTOM_LAYER_BET;
15 
16   // Coin stack data representation
17   //
18   // coordinates are represented by a uint32
19   // where the first 16 bits represents the _x value as a 16-bit unsigned int
20   // where the second 16 bits represents the _y value as a 16-bit unsigned int
21   // For example 0x0010000B corresponse to (_x,_y) = (0x10,0xB) = (16,11)
22   // Decoding from _coord to (_x,_y):
23   // _x = _coord >> 16
24   // _y = _coord & 0xFFFF
25   // Encoding (_x,_y) to _coord:
26   // _coord = (_x << 16) | _y
27 
28   mapping(uint32 => address) public coordinatesToAddresses;
29   uint32[] public coinCoordinates;
30 
31   // Prize
32   uint256 public reserveForJackpot;
33 
34   // withdrawable address balance
35   mapping(address => uint256) public balances;
36 
37   // Event
38   event coinPlacedEvent (
39     uint32 _coord,
40     address indexed _coinOwner
41   );
42 
43   function CoinStacks() public {
44     admin = msg.sender;
45     maintenanceFeePercent = 1; // Default fee is 1%
46     reserveForJackpot = 0;
47 
48     // Set the first coin at the leftmost of the bottom row (0,0)
49     coordinatesToAddresses[uint32(0)] = admin;
50     coinCoordinates.push(uint32(0));
51     coinPlacedEvent(uint32(0),admin);
52   }
53 
54   function isThereACoinAtCoordinates(uint16 _x, uint16 _y) public view returns (bool){
55     return coordinatesToAddresses[(uint32(_x) << 16) | uint16(_y)] != 0;
56   }
57 
58   function getNumCoins() external view returns (uint){
59     return coinCoordinates.length;
60   }
61 
62   function getAllCoins() external view returns (uint32[]){
63     return coinCoordinates;
64   }
65 
66   function placeCoin(uint16 _x, uint16 _y) external payable{
67     // check no coin has been placed at (_x,_y)
68     require(!isThereACoinAtCoordinates(_x,_y));
69     // check the coin below has been placed
70     require(_y==0 || isThereACoinAtCoordinates(_x,_y-1));
71     // cannot place to locked column
72     require(_x<INITIAL_UNLOCKED_COLUMNS || coinCoordinates.length >= MIN_AVG_HEIGHT * _x);
73 
74     uint256 betAmount = BOTTOM_LAYER_BET * (uint256(1) << _y); // * pow(2,_y)
75 
76     // check if the user has enough balance to place the current coin
77     require(balances[msg.sender] + msg.value >= betAmount);
78 
79     // Add the transaction amount to the user's balance
80     // and deduct current coin cost from user's balance
81     balances[msg.sender] += (msg.value - betAmount);
82 
83     uint32 coinCoord = (uint32(_x) << 16) | uint16(_y);
84 
85     coinCoordinates.push(coinCoord);
86     coordinatesToAddresses[coinCoord] = msg.sender;
87 
88     if(_y==0) { // placing a coin in the bottom layer
89       if(reserveForJackpot < JACKPOT_PRIZE) { // goes to jackpot reserve
90         reserveForJackpot += BOTTOM_LAYER_BET;
91       } else { // otherwise goes to admin
92         balances[admin]+= BOTTOM_LAYER_BET;
93       }
94     } else { // reward the owner of the coin below, minus maintenance fee
95       uint256 adminFee = betAmount * maintenanceFeePercent /100;
96       balances[coordinatesToAddresses[(uint32(_x) << 16) | _y-1]] +=
97         (betAmount - adminFee);
98       balances[admin] += adminFee;
99     }
100 
101     // hitting jackpot: send jackpot prize if this is every 30 th coin
102     if(coinCoordinates.length % NUM_COINS_TO_HIT_JACKPOT == 0){
103       balances[msg.sender] += reserveForJackpot;
104       reserveForJackpot = 0;
105     }
106 
107     //trigger the event
108     coinPlacedEvent(coinCoord,msg.sender);
109   }
110 
111   // Withdrawing balance
112   function withdrawBalance(uint256 _amountToWithdraw) external{
113     require(_amountToWithdraw != 0);
114     require(balances[msg.sender] >= _amountToWithdraw);
115     // Subtract the withdrawn amount from the user's balance
116     balances[msg.sender] -= _amountToWithdraw;
117 
118     msg.sender.transfer(_amountToWithdraw);
119   }
120 
121   //transfer ownership of the contract
122   function transferOwnership(address _newOwner) external {
123     require (msg.sender == admin);
124     admin = _newOwner;
125   }
126 
127   //change maintenance fee
128   function setFeePercent(uint256 _newPercent) external {
129     require (msg.sender == admin);
130     if(_newPercent<=2) // Fee will never exceed 2%
131       maintenanceFeePercent = _newPercent;
132   }
133 
134   //fallback function for handling unexpected payment
135   function() external payable{
136     //if any ether is sent to the address, credit the admin balance
137     balances[admin] += msg.value;
138   }
139 }