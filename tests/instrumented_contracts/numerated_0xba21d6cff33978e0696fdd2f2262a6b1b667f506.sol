1 pragma solidity ^0.4.24;
2 
3 // 😀😀😀😀😀😀😀😀😀😀😀😀😀😀
4 // 😀                            😀
5 // 😀 https://emojisan.github.io 😀
6 // 😀                            😀
7 // 😀😀😀😀😀😀😀😀😀😀😀😀😀😀
8 
9 // part of NFT token interface used in this contract
10 // https://etherscan.io/address/0xE3f2F807ba194ea0221B9109fb14Da600C9e1eb6
11 interface Emojisan {
12 
13     function ownerOf(uint tokenId) external view returns (address);
14     function balanceOf(address owner) external view returns (uint);
15     function transferFrom(address from, address to, uint tokenId) external;
16     function mint(uint tokenId) external;
17     function setMinter(address newMinter) external;
18 }
19 
20 contract EmojisanAuctionHouse {
21 
22     event Bid(uint indexed tokenId);
23 
24     struct Auction {
25         address owner;
26         uint128 currentPrice;
27     }
28 
29     struct User {
30         uint128 balance;
31         uint32 bidBlock;
32     }
33 
34     // NFT token address
35     // https://etherscan.io/address/0xE3f2F807ba194ea0221B9109fb14Da600C9e1eb6
36     Emojisan public constant emojisan = Emojisan(0xE3f2F807ba194ea0221B9109fb14Da600C9e1eb6);
37 
38     uint[] public tokenByIndex;
39     mapping (uint => Auction) public auction;
40     mapping (address => User) public user;
41     uint32 private constant auctionTime = 20000;
42 
43     address public whaleAddress;
44     uint32 public whaleStartTime;
45     uint128 public whaleBalance;
46     uint32 private constant whaleWithdrawDelay = 80000;
47 
48     uint128 public ownerBalance;
49     uint private constant ownerTokenId = 128512;
50 
51     function tokens() external view returns (uint[]) {
52         return tokenByIndex;
53     }
54 
55     function tokensCount() external view returns (uint) {
56         return tokenByIndex.length;
57     }
58 
59     function wantItForFree(uint tokenId) external {
60         // user 👤 can bid only on one 1️⃣ token at a time ⏱️
61         require(block.number >= user[msg.sender].bidBlock + auctionTime);
62         // check auction has not started 🚫🎬
63         require(auction[tokenId].owner == address(this));
64         auction[tokenId].owner = msg.sender;
65         user[msg.sender].bidBlock = uint32(block.number);
66         emojisan.mint(tokenId);
67         emit Bid(tokenId);
68     }
69 
70     function wantItMoreThanYou(uint tokenId) external payable {
71         // user 👤 can bid only on one 1️⃣ token at a time ⏱️
72         require(block.number >= user[msg.sender].bidBlock + auctionTime);
73         // check auction has not finished 🚫🏁
74         address previousOwner = auction[tokenId].owner;
75         require(block.number < user[previousOwner].bidBlock + auctionTime);
76         // fancy 🧐 price 💰 calculation 📈
77         // 0 ➡️ 0.002 ➡️ 0.004 ➡️ 0.008 ➡️ 0.016 ➡️ 0.032 ➡️ 0.064 ➡️ 0.128
78         // ➡️ 0.256 ➡️ 0.512 ➡️ 1 ➡️ 1.5 ➡️ 2 ➡️ 2.5 ➡️ 3 ➡️ 3.5 ➡️ 4 ➡️ ...
79         uint128 previousPrice = auction[tokenId].currentPrice;
80         uint128 price;
81         if (previousPrice == 0) {
82             price = 2 finney;
83         } else if (previousPrice < 500 finney) {
84             price = 2 * previousPrice;
85         } else {
86             price = (previousPrice + 500 finney) / 500 finney * 500 finney;
87         }
88         require(msg.value >= price);
89         uint128 priceDiff = price - previousPrice;
90         // previous 👤 gets what she 🙆 paid ➕ 2️⃣5️⃣%
91         user[previousOwner] = User({
92             balance: previousPrice + priceDiff / 4,
93             bidBlock: 0
94         });
95         // whale 🐋 gets 5️⃣0️⃣%
96         whaleBalance += priceDiff / 2;
97         // owner 👩 of token 128512 😀 gets 2️⃣5️⃣%
98         ownerBalance += priceDiff / 4;
99         auction[tokenId] = Auction({
100             owner: msg.sender,
101             currentPrice: price
102         });
103         user[msg.sender].bidBlock = uint32(block.number);
104         if (msg.value > price) {
105             // send back eth if someone sent too much 💸💸💸
106             msg.sender.transfer(msg.value - price);
107         }
108         emit Bid(tokenId);
109     }
110 
111     function wantMyToken(uint tokenId) external {
112         Auction memory a = auction[tokenId];
113         // check auction has finished 🏁
114         require(block.number >= user[a.owner].bidBlock + auctionTime);
115         emojisan.transferFrom(this, a.owner, tokenId);
116     }
117 
118     function wantMyEther() external {
119         uint amount = user[msg.sender].balance;
120         user[msg.sender].balance = 0;
121         msg.sender.transfer(amount);
122     }
123 
124     function wantToBeWhale() external {
125         // need to have more tokens 💰 than current 🐋
126         require(emojisan.balanceOf(msg.sender) > emojisan.balanceOf(whaleAddress));
127         whaleAddress = msg.sender;
128         // whale 🐳 needs to wait some time ⏱️ before snatching that sweet 🍬 eth 🤑
129         whaleStartTime = uint32(block.number);
130     }
131 
132     function whaleWantMyEther() external {
133         require(msg.sender == whaleAddress);
134         // check enough time ⏱️ passed for whale 🐳 to grab 💵💷💶💴
135         require(block.number >= whaleStartTime + whaleWithdrawDelay);
136         // whale 🐳 needs to wait some time ⏱️ before snatching that sweet 🍭 eth 🤑 again
137         whaleStartTime = uint32(block.number);
138         uint amount = whaleBalance;
139         whaleBalance = 0;
140         whaleAddress.transfer(amount);
141     }
142 
143     function ownerWantMyEther() external {
144         uint amount = ownerBalance;
145         ownerBalance = 0;
146         emojisan.ownerOf(ownerTokenId).transfer(amount);
147     }
148 
149     function wantNewTokens(uint[] tokenIds) external {
150         // only owner 👩 of token 128512 😀
151         require(msg.sender == emojisan.ownerOf(ownerTokenId));
152         for (uint i = 0; i < tokenIds.length; i++) {
153             auction[tokenIds[i]].owner = this;
154             tokenByIndex.push(tokenIds[i]);
155         }
156     }
157 
158     function wantNewMinter(address minter) external {
159         // only owner 👩 of token 128512 😀
160         require(msg.sender == emojisan.ownerOf(ownerTokenId));
161         emojisan.setMinter(minter);
162     }
163 }