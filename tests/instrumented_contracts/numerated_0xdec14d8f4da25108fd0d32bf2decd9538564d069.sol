1 pragma solidity ^0.4.18;
2 
3 contract CryptoVideoGames {
4 
5     address contractCreator = 0xC15d9f97aC926a6A29A681f5c19e2b56fd208f00;
6     address devFeeAddress = 0xC15d9f97aC926a6A29A681f5c19e2b56fd208f00;
7 
8     struct VideoGame {
9         string videoGameName;
10         address ownerAddress;
11         uint256 currentPrice;
12     }
13     VideoGame[] videoGames;
14 
15     modifier onlyContractCreator() {
16         require (msg.sender == contractCreator);
17         _;
18     }
19 
20     bool isPaused;
21     
22     
23     /*
24     We use the following functions to pause and unpause the game.
25     */
26     function pauseGame() public onlyContractCreator {
27         isPaused = true;
28     }
29     function unPauseGame() public onlyContractCreator {
30         isPaused = false;
31     }
32     function GetGamestatus() public view returns(bool) {
33        return(isPaused);
34     }
35 
36     /*
37     This function allows users to purchase Video Game. 
38     The price is automatically multiplied by 2 after each purchase.
39     Users can purchase multiple video games.
40     */
41     function purchaseVideoGame(uint _videoGameId) public payable {
42         require(msg.value == videoGames[_videoGameId].currentPrice);
43         require(isPaused == false);
44 
45         // Calculate the 10% value
46         uint256 devFee = (msg.value / 10);
47 
48         // Calculate the video game owner commission on this sale & transfer the commission to the owner.     
49         uint256 commissionOwner = msg.value - devFee; // => 90%
50         videoGames[_videoGameId].ownerAddress.transfer(commissionOwner);
51 
52         // Transfer the 10% commission to the developer
53         devFeeAddress.transfer(devFee); // => 10%                       
54 
55         // Update the video game owner and set the new price
56         videoGames[_videoGameId].ownerAddress = msg.sender;
57         videoGames[_videoGameId].currentPrice = mul(videoGames[_videoGameId].currentPrice, 2);
58     }
59     
60     /*
61     This function can be used by the owner of a video game to modify the price of its video game.
62     He can make the price lesser than the current price only.
63     */
64     function modifyCurrentVideoGamePrice(uint _videoGameId, uint256 _newPrice) public {
65         require(_newPrice > 0);
66         require(videoGames[_videoGameId].ownerAddress == msg.sender);
67         require(_newPrice < videoGames[_videoGameId].currentPrice);
68         videoGames[_videoGameId].currentPrice = _newPrice;
69     }
70     
71     // This function will return all of the details of the Video Games
72     function getVideoGameDetails(uint _videoGameId) public view returns (
73         string videoGameName,
74         address ownerAddress,
75         uint256 currentPrice
76     ) {
77         VideoGame memory _videoGame = videoGames[_videoGameId];
78 
79         videoGameName = _videoGame.videoGameName;
80         ownerAddress = _videoGame.ownerAddress;
81         currentPrice = _videoGame.currentPrice;
82     }
83     
84     // This function will return only the price of a specific Video Game
85     function getVideoGameCurrentPrice(uint _videoGameId) public view returns(uint256) {
86         return(videoGames[_videoGameId].currentPrice);
87     }
88     
89     // This function will return only the owner address of a specific Video Game
90     function getVideoGameOwner(uint _videoGameId) public view returns(address) {
91         return(videoGames[_videoGameId].ownerAddress);
92     }
93     
94     
95     /**
96     @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
97     */
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100           return 0;
101         }
102         uint256 c = a * b;
103         assert(c / a == b);
104         return c;
105     }
106 
107     /**
108     @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
109     */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         // assert(b > 0); // Solidity automatically throws when dividing by 0
112         uint256 c = a / b;
113         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114         return c;
115     }
116     
117     // This function will be used to add a new video game by the contract creator
118     function addVideoGame(string videoGameName, address ownerAddress, uint256 currentPrice) public onlyContractCreator {
119         videoGames.push(VideoGame(videoGameName,ownerAddress,currentPrice));
120     }
121     
122 }