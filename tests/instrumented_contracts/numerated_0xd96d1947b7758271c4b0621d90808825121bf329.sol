1 pragma solidity ^0.4.18;
2 
3 contract DomainAuction {
4     address public owner;
5 
6     struct Bid {
7         uint timestamp;
8         address bidder;
9         uint amount;
10         string url;
11     }
12 
13     struct WinningBid {
14         uint winTimestamp;
15         uint bidTimestamp;
16         address bidder;
17         uint bidAmount;
18         string url;
19     }
20 
21     Bid public highestBid;
22 
23     WinningBid public winningBid;
24 
25     event BidLog(uint timestamp, address bidder, uint amount, string url);
26     event WinningBidLog(uint winTimestamp, uint bidTimestamp, address bidder, uint amount, string url);
27     event Refund(uint timestamp, address bidder, uint amount);
28 
29     ///////////////////////////////////
30 
31     function placeBid(string url) public payable {
32         require(msg.value >= ((highestBid.amount * 11) / 10));
33         Bid memory newBid = Bid(now, msg.sender, msg.value, url);
34 
35         // Refund the current highest bid.
36         // Do not refund anything on the first `placeBid` call.
37         if (highestBid.bidder != 0) {
38             refundBid(highestBid);
39         }
40 
41         // Update the highest bid and log the event
42         highestBid = newBid;
43         emit BidLog(newBid.timestamp, newBid.bidder, newBid.amount, newBid.url);
44     }
45 
46     // This might fail if the bidder is trying some contract bullshit, but they do this
47     // at their own risk. It won't fail if the bidder is a non-contract address.
48     // It is very important to use `send` instead of `transfer`. Otherwise this could fail
49     // and this contract could get hijacked.
50     // See https://ethereum.stackexchange.com/questions/19341/address-send-vs-address-transfer-best-practice-usage
51     function refundBid(Bid bid) private {
52         bid.bidder.send(bid.amount);
53         emit Refund(now, bid.bidder, bid.amount);
54     }
55 
56     // This will need to be triggered externally every x days
57     function pickWinner() public payable {
58         require(msg.sender == owner);
59 
60         if (winningBid.bidTimestamp != highestBid.timestamp) {
61           // Have to store the new winning bid in memory in order to emit it as part
62           // of an event. Can't emit an event straight from a stored variable.
63           WinningBid memory newWinningBid = WinningBid(now, highestBid.timestamp, highestBid.bidder, highestBid.amount, highestBid.url);
64           winningBid = newWinningBid;
65           emit WinningBidLog(
66               newWinningBid.winTimestamp,
67               newWinningBid.bidTimestamp,
68               newWinningBid.bidder,
69               newWinningBid.bidAmount,
70               newWinningBid.url
71           );
72         }
73     }
74 
75     ///////////////////////////////////
76 
77     constructor() public payable {
78         owner = msg.sender;
79     }
80 
81     function withdraw() public {
82         if (msg.sender == owner) owner.send(address(this).balance);
83     }
84 
85     function kill() public {
86         if (msg.sender == owner) selfdestruct(owner);
87     }
88 }