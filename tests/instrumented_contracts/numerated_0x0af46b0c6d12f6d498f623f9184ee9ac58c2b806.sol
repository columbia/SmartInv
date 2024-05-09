1 pragma solidity ^0.4.15;
2 
3 contract TimeBroker 
4 {
5     address owner;
6     
7     function TimeBroker()
8     {
9         owner = msg.sender;    
10     }
11     
12     modifier isOwner()
13     {
14         assert(msg.sender == owner);
15         _;
16     }
17 
18     struct Seller
19     {
20         string FirstName;
21         string SecondName;
22         string MiddleName;
23         string City;
24         //uint256 rating;
25     }
26     
27     mapping(address => Seller) public sellers;
28 
29     Auction[] auctions;
30     
31     struct Auction
32     {
33         address seller;
34         uint256 bidsAcceptedBefore;
35         uint256 datetime;
36         uint64 duration;
37         uint256 currentPrice;
38         address winner;
39         bool canceled;
40     }
41     mapping (uint256 => bool) auctionWithdrawDone;
42     
43     
44 
45     event RegisterSeller(address source, string FirstName, string SecondName, string MiddleName, string City);
46     event NewAuction(address seller, uint256 index, uint256 bidsAcceptedBefore, uint256 datetime, uint64 duration, uint256 minPrice);
47     event CancelAuction(address seller, uint256 index, uint256 bidsAcceptedBefore, uint256 datetime, uint64 duration, uint256 currentPrice, address winner);
48     event AuctionFinished(address seller, uint256 index, uint256 bidsAcceptedBefore, uint256 datetime, uint64 duration, uint256 currentPrice, address winner);
49     event Bid(address seller, uint256 index, address buyer, uint256 newPrice);
50     event Withdraw(address seller, uint256 index, uint256 payToSeller);
51     
52     function registerAsSeller(address source, string FirstName, string SecondName, string MiddleName, string City) isOwner
53     {
54         sellers[source] = Seller(FirstName, SecondName, MiddleName, City);
55         RegisterSeller(source, FirstName, SecondName, MiddleName, City);
56     }
57 
58     function createAuction(uint256 bidsAcceptedBefore, uint256 datetime, uint64 duration, uint256 minPrice)
59     {
60         assert(bytes(sellers[msg.sender].FirstName).length > 0);
61         assert(datetime > bidsAcceptedBefore);
62         assert(datetime > now);
63         assert(duration > 0);
64         auctions.push(Auction(msg.sender, bidsAcceptedBefore, datetime, duration, minPrice, 0x0, false));
65         NewAuction(msg.sender, auctions.length - 1, bidsAcceptedBefore, datetime, duration, minPrice);
66     }
67 
68     function withdraw(uint256 index)
69     {
70         Auction storage auc = auctions[index];
71         assert(auc.seller == msg.sender); // seller call function
72         assert(now > auc.datetime + auc.duration); // meeting ended
73         assert(auctionWithdrawDone[index] == false);
74         auctionWithdrawDone[index] = true;
75         uint256 payToSeller = auc.currentPrice * 95 / 100;
76         assert(auc.currentPrice > payToSeller);
77         auc.seller.transfer(payToSeller);               // 95% to seller
78         owner.transfer(auc.currentPrice - payToSeller); // 5% to owner
79         Withdraw(auc.seller, index, payToSeller);
80     }
81 
82 
83     function placeBid(uint256 index) payable
84     {
85         Auction storage auc = auctions[index];
86         assert(auc.seller != msg.sender);
87         assert(now < auc.bidsAcceptedBefore);
88         assert(auc.canceled == false);
89         assert(msg.value > auc.currentPrice);
90         if (auc.winner != 0)
91         {
92             auc.winner.transfer(auc.currentPrice);
93         }
94         auc.currentPrice = msg.value;
95         auc.winner = msg.sender;
96         Bid(auc.seller, index, msg.sender, msg.value);
97     }
98 
99     function kill() isOwner {
100         selfdestruct(msg.sender);
101     }
102 
103 
104 }