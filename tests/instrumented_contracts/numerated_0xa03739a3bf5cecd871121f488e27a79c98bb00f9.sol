1 pragma solidity ^0.4.11;
2 
3 contract SimpleAuction {
4     // Parameters of the auction. Times are either
5     // absolute unix timestamps (seconds since 1970-01-01)
6     // or time periods in seconds.
7     address public beneficiary;
8     uint public auctionStart;
9     uint public biddingTime;
10 
11     // Current state of the auction.
12     address public highestBidder;
13     uint public highestBid;
14 
15     // Allowed withdrawals of previous bids
16     mapping(address => uint) pendingReturns;
17 
18     // Set to true at the end, disallows any change
19     bool ended;
20 
21     // Events that will be fired on changes.
22     event HighestBidIncreased(address bidder, uint amount);
23     event AuctionEnded(address winner, uint amount);
24 
25     // The following is a so-called natspec comment,
26     // recognizable by the three slashes.
27     // It will be shown when the user is asked to
28     // confirm a transaction.
29 
30     /// Create a simple auction with `_biddingTime`
31     /// seconds bidding time on behalf of the
32     /// beneficiary address `_beneficiary`.
33     function SimpleAuction() {
34         beneficiary = 0xc2752751E6B91736d5a2e8E31336DC7C7220e8FC;
35         auctionStart = now;
36         biddingTime = 600;
37     }
38 
39     /// Bid on the auction with the value sent
40     /// together with this transaction.
41     /// The value will only be refunded if the
42     /// auction is not won.
43     function bid() payable {
44         // No arguments are necessary, all
45         // information is already part of
46         // the transaction. The keyword payable
47         // is required for the function to
48         // be able to receive Ether.
49 
50         // Revert the call if the bidding
51         // period is over.
52         require(now <= (auctionStart + biddingTime));
53 
54         // If the bid is not higher, send the
55         // money back.
56         require(msg.value > highestBid);
57 
58         if (highestBidder != 0) {
59             // Sending back the money by simply using
60             // highestBidder.send(highestBid) is a security risk
61             // because it can be prevented by the caller by e.g.
62             // raising the call stack to 1023. It is always safer
63             // to let the recipients withdraw their money themselves.
64             pendingReturns[highestBidder] += highestBid;
65         }
66         highestBidder = msg.sender;
67         highestBid = msg.value;
68         HighestBidIncreased(msg.sender, msg.value);
69     }
70 
71     /// Withdraw a bid that was overbid.
72     function withdraw() returns (bool) {
73         uint amount = pendingReturns[msg.sender];
74         if (amount > 0) {
75             // It is important to set this to zero because the recipient
76             // can call this function again as part of the receiving call
77             // before `send` returns.
78             pendingReturns[msg.sender] = 0;
79 
80             if (!msg.sender.send(amount)) {
81                 // No need to call throw here, just reset the amount owing
82                 pendingReturns[msg.sender] = amount;
83                 return false;
84             }
85         }
86         return true;
87     }
88     // Users want to know when the auction ends, seconds from 1970-01-01
89     function auctionEndTime() constant returns (uint256) {
90         return auctionStart + biddingTime;
91     }
92     
93     /// End the auction and send the highest bid
94     /// to the beneficiary.
95     function auctionEnd() {
96         // It is a good guideline to structure functions that interact
97         // with other contracts (i.e. they call functions or send Ether)
98         // into three phases:
99         // 1. checking conditions
100         // 2. performing actions (potentially changing conditions)
101         // 3. interacting with other contracts
102         // If these phases are mixed up, the other contract could call
103         // back into the current contract and modify the state or cause
104         // effects (ether payout) to be performed multiple times.
105         // If functions called internally include interaction with external
106         // contracts, they also have to be considered interaction with
107         // external contracts.
108 
109         // 1. Conditions
110         require(now >= (auctionStart + biddingTime)); // auction did not yet end
111         require(!ended); // this function has already been called
112 
113         // 2. Effects
114         ended = true;
115         AuctionEnded(highestBidder, highestBid);
116 
117         // 3. Interaction
118         beneficiary.transfer(highestBid);
119     }
120 }