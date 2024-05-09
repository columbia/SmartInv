1 pragma solidity ^0.4.18;
2 
3 contract EtherAuction {
4 
5   // The address that deploys this auction and volunteers 1 eth as price.
6   address public auctioneer;
7   uint public auctionedEth = 0;
8 
9   uint public highestBid = 0;
10   uint public secondHighestBid = 0;
11 
12   address public highestBidder;
13   address public secondHighestBidder;
14 
15   uint public latestBidTime = 0;
16   uint public auctionEndTime;
17 
18   mapping (address => uint) public balances;
19 
20   bool public auctionStarted = false;
21   bool public auctionFinalized = false;
22 
23   event E_AuctionStarted(address _auctioneer, uint _auctionStart, uint _auctionEnd);
24   event E_Bid(address _highestBidder, uint _highestBid);
25   event E_AuctionFinished(address _highestBidder,uint _highestBid,address _secondHighestBidder,uint _secondHighestBid,uint _auctionEndTime);
26 
27   function EtherAuction(){
28     auctioneer = msg.sender;
29   }
30 
31   // The auctioneer has to call this function while supplying the 1th to start the auction
32   function startAuction() public payable{
33     require(!auctionStarted);
34     require(msg.sender == auctioneer);
35     require(msg.value == (1 * 10 ** 18));
36     
37     auctionedEth = msg.value;
38     auctionStarted = true;
39     auctionEndTime = now + (3600 * 24 * 7); // Ends 7 days after the deployment of the contract
40 
41     E_AuctionStarted(msg.sender,now, auctionEndTime);
42   }
43 
44   //Anyone can bid by calling this function and supplying the corresponding eth
45   function bid() public payable {
46     require(auctionStarted);
47     require(now < auctionEndTime);
48     require(msg.sender != auctioneer);
49     require(highestBidder != msg.sender); //If sender is already the highest bidder, reject it.
50 
51     address _newBidder = msg.sender;
52 
53     uint previousBid = balances[_newBidder];
54     uint _newBid = msg.value + previousBid;
55 
56     require (_newBid  == highestBid + (5 * 10 ** 16)); //Each bid has to be 0.05 eth higher
57 
58     // The highest bidder is now the second highest bidder
59     secondHighestBid = highestBid;
60     secondHighestBidder = highestBidder;
61 
62     highestBid = _newBid;
63     highestBidder = _newBidder;
64 
65     latestBidTime = now;
66     //Update the bidder's balance so they can later withdraw any pending balance
67     balances[_newBidder] = _newBid;
68 
69     //If there's less than an hour remaining and someone bids, extend end time.
70     if(auctionEndTime - now < 3600)
71       auctionEndTime += 3600; // Each bid extends the auctionEndTime by 1 hour
72 
73     E_Bid(highestBidder, highestBid);
74 
75   }
76   // Once the auction end has been reached, we distribute the ether.
77   function finalizeAuction() public {
78     require (now > auctionEndTime);
79     require (!auctionFinalized);
80     auctionFinalized = true;
81 
82     if(highestBidder == address(0)){
83       //If no one bid at the auction, auctioneer can withdraw the funds.
84       balances[auctioneer] = auctionedEth;
85     }else{
86       // Second highest bidder gets nothing, his latest bid is lost and sent to the auctioneer
87       balances[secondHighestBidder] -= secondHighestBid;
88       balances[auctioneer] += secondHighestBid;
89 
90       //Auctioneer gets the highest bid from the highest bidder.
91       balances[highestBidder] -= highestBid;
92       balances[auctioneer] += highestBid;
93 
94       //winner gets the 1eth being auctioned.
95       balances[highestBidder] += auctionedEth;
96       auctionedEth = 0;
97     }
98 
99     E_AuctionFinished(highestBidder,highestBid,secondHighestBidder,secondHighestBid,auctionEndTime);
100 
101   }
102 
103   //Once the auction has finished, the bidders can withdraw the eth they put
104   //Winner will withdraw the auctionedEth
105   //Auctioneer will withdraw the highest bid from the winner
106   //Second highest bidder will already have his balance at 0
107   //The rest of the bidders get their money back
108   function withdrawBalance() public{
109     require (auctionFinalized);
110 
111     uint ethToWithdraw = balances[msg.sender];
112     if(ethToWithdraw > 0){
113       balances[msg.sender] = 0;
114       msg.sender.transfer(ethToWithdraw);
115     }
116 
117   }
118 
119   //Call thisfunction to know how many seconds remain for the auction to end
120   function timeRemaining() public view returns (uint){
121       require (auctionEndTime > now);
122       return auctionEndTime - now;
123   }
124 
125   function myLatestBid() public view returns (uint){
126     return balances[msg.sender];
127   }
128 
129 }