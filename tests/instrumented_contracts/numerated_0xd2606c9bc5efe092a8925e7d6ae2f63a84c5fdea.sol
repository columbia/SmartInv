1 pragma solidity ^0.4.18;
2 
3 contract CryptoVideoGameItem {
4 
5     address contractCreator = 0xC15d9f97aC926a6A29A681f5c19e2b56fd208f00; 
6     address devFeeAddress = 0xC15d9f97aC926a6A29A681f5c19e2b56fd208f00;
7 
8     address cryptoVideoGames = 0xdEc14D8f4DA25108Fd0d32Bf2DeCD9538564D069; 
9 
10     struct VideoGameItem {
11         string videoGameItemName;
12         address ownerAddress;
13         uint256 currentPrice;
14         uint parentVideoGame;
15     }
16     VideoGameItem[] videoGameItems;
17 
18     modifier onlyContractCreator() {
19         require (msg.sender == contractCreator);
20         _;
21     }
22 
23     bool isPaused;
24     
25     
26     /*
27     We use the following functions to pause and unpause the game.
28     */
29     function pauseGame() public onlyContractCreator {
30         isPaused = true;
31     }
32     function unPauseGame() public onlyContractCreator {
33         isPaused = false;
34     }
35     function GetGamestatus() public view returns(bool) {
36        return(isPaused);
37     }
38 
39     /*
40     This function allows users to purchase Video Game Item. 
41     The price is automatically multiplied by 2 after each purchase.
42     Users can purchase multiple video game Items.
43     */
44     function purchaseVideoGameItem(uint _videoGameItemId) public payable {
45         require(msg.value >= videoGameItems[_videoGameItemId].currentPrice);
46         require(isPaused == false);
47 
48         CryptoVideoGames parentContract = CryptoVideoGames(cryptoVideoGames);
49         uint256 currentPrice = videoGameItems[_videoGameItemId].currentPrice;
50         uint256 excess = msg.value - currentPrice;
51         // Calculate the 10% value
52         uint256 devFee = (currentPrice / 10);
53         uint256 parentOwnerFee = (currentPrice / 10);
54 
55         address parentOwner = parentContract.getVideoGameOwner(videoGameItems[_videoGameItemId].parentVideoGame);
56         address newOwner = msg.sender;
57         // Calculate the video game owner commission on this sale & transfer the commission to the owner.     
58         uint256 commissionOwner = currentPrice - devFee - parentOwnerFee; // => 80%
59         videoGameItems[_videoGameItemId].ownerAddress.transfer(commissionOwner);
60 
61         // Transfer the 10% commission to the developer
62         devFeeAddress.transfer(devFee); // => 10% 
63         parentOwner.transfer(parentOwnerFee); // => 10%   
64         newOwner.transfer(excess);              
65 
66         // Update the video game owner and set the new price
67         videoGameItems[_videoGameItemId].ownerAddress = newOwner;
68         videoGameItems[_videoGameItemId].currentPrice = mul(videoGameItems[_videoGameItemId].currentPrice, 2);
69     }
70     
71     /*
72     This function can be used by the owner of a video game item to modify the price of its video game item.
73     He can make the price lesser than the current price only.
74     */
75     function modifyCurrentVideoGameItemPrice(uint _videoGameItemId, uint256 _newPrice) public {
76         require(_newPrice > 0);
77         require(videoGameItems[_videoGameItemId].ownerAddress == msg.sender);
78         require(_newPrice < videoGameItems[_videoGameItemId].currentPrice);
79         videoGameItems[_videoGameItemId].currentPrice = _newPrice;
80     }
81     
82     // This function will return all of the details of the Video Game Item
83     function getVideoGameItemDetails(uint _videoGameItemId) public view returns (
84         string videoGameItemName,
85         address ownerAddress,
86         uint256 currentPrice,
87         uint parentVideoGame
88     ) {
89         VideoGameItem memory _videoGameItem = videoGameItems[_videoGameItemId];
90 
91         videoGameItemName = _videoGameItem.videoGameItemName;
92         ownerAddress = _videoGameItem.ownerAddress;
93         currentPrice = _videoGameItem.currentPrice;
94         parentVideoGame = _videoGameItem.parentVideoGame;
95     }
96     
97     // This function will return only the price of a specific Video Game Item
98     function getVideoGameItemCurrentPrice(uint _videoGameItemId) public view returns(uint256) {
99         return(videoGameItems[_videoGameItemId].currentPrice);
100     }
101     
102     // This function will return only the owner address of a specific Video Game
103     function getVideoGameItemOwner(uint _videoGameItemId) public view returns(address) {
104         return(videoGameItems[_videoGameItemId].ownerAddress);
105     }
106     
107     
108     /**
109     @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
110     */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         if (a == 0) {
113           return 0;
114         }
115         uint256 c = a * b;
116         assert(c / a == b);
117         return c;
118     }
119 
120     /**
121     @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
122     */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         // assert(b > 0); // Solidity automatically throws when dividing by 0
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127         return c;
128     }
129     
130     // This function will be used to add a new video game by the contract creator
131     function addVideoGameItem(string videoGameItemName, address ownerAddress, uint256 currentPrice, uint parentVideoGame) public onlyContractCreator {
132         videoGameItems.push(VideoGameItem(videoGameItemName,ownerAddress,currentPrice, parentVideoGame));
133     }
134     
135 }
136 
137 
138 
139 contract CryptoVideoGames {
140     
141     
142     
143     // This function will return only the owner address of a specific Video Game
144     function getVideoGameOwner(uint _videoGameId) public view returns(address) {
145     }
146     
147 }