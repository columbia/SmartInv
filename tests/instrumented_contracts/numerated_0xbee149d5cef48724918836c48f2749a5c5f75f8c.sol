1 pragma solidity ^0.4.11;
2 
3 contract SimpleAuction {
4     // 
5     // This is an auction where UNICEF is the beneficiary 
6     //
7     // The highest bidder of this auction is entiteled to Poster Number one of the worlds first Ehtereum funded movie The-Pitt-Circus Movie. 
8     // The Poster is a limited editions serigraphy (numbered and signed by the artist).
9     // To claim the poster the highest bidder can get in touch with the-pitts-circus.com or send the address an data-field transation to the contract of the beneficiary = 0xb23397f97715118532c8c1207F5678Ed4FbaEA6c after the auction has ended
10     // 
11     // 
12     //
13     //Parameters of the auction. Times are either
14     // absolute unix timestamps (seconds since 1970-01-01)
15     // or time periods in seconds.
16     // 
17   	
18     uint public auctionStart;
19     uint public biddingTime;
20 
21     // Current state of the auction.
22     address public highestBidder;
23     uint public highestBid;
24 
25     // Allowed withdrawals of previous bids
26     mapping(address => uint) pendingReturns;
27 
28     // Set to true at the end, disallows any change
29     bool ended;
30 
31     // Events that will be fired on changes.
32     event HighestBidIncreased(address bidder, uint amount);
33     event AuctionEnded(address winner, uint amount);
34 
35     // The following is a so-called natspec comment,
36     // recognizable by the three slashes.
37     // It will be shown when the user is asked to
38     // confirm a transaction.
39 
40     /// Create a simple auction with `_biddingTime`
41     /// seconds bidding time on behalf of the
42     /// beneficiary address `_beneficiary`.
43     
44     address _beneficiary = 0xb23397f97715118532c8c1207F5678Ed4FbaEA6c;
45 	// UNICEF Multisig Wallet according to:
46 	// unicefstories.org/2017/08/04/unicef-ventures-exploring-smart-contracts/
47 	address beneficiary;
48     
49     function SimpleAuction() {
50         beneficiary = _beneficiary;
51         auctionStart = now;
52         biddingTime = 2587587;
53     }
54 
55     /// Bid on the auction with the value sent
56     /// together with this transaction.
57     /// The value will only be refunded if the
58     /// auction is not won.
59     function bid() payable {
60         // No arguments are necessary, all
61         // information is already part of
62         // the transaction. The keyword payable
63         // is required for the function to
64         // be able to receive Ether.
65 
66         // Revert the call if the bidding
67         // period is over.
68         require(now <= (auctionStart + biddingTime));
69 
70         // If the bid is not higher, send the
71         // money back.
72         require(msg.value > highestBid);
73 
74         if (highestBidder != 0) {
75             // Sending back the money by simply using
76             // highestBidder.send(highestBid) is a security risk
77             // because it can be prevented by the caller by e.g.
78             // raising the call stack to 1023. It is always safer
79             // to let the recipients withdraw their money themselves.
80             pendingReturns[highestBidder] += highestBid;
81         }
82         highestBidder = msg.sender;
83         highestBid = msg.value;
84         HighestBidIncreased(msg.sender, msg.value);
85     }
86 
87     /// Withdraw a bid that was overbid.
88     function withdraw() returns (bool) {
89         uint amount = pendingReturns[msg.sender];
90         if (amount > 0) {
91             // It is important to set this to zero because the recipient
92             // can call this function again as part of the receiving call
93             // before `send` returns.
94             pendingReturns[msg.sender] = 0;
95 
96             if (!msg.sender.send(amount)) {
97                 // No need to call throw here, just reset the amount owing
98                 pendingReturns[msg.sender] = amount;
99                 return false;
100             }
101         }
102         return true;
103     }
104     // Users want to know when the auction ends, seconds from 1970-01-01
105     function auctionEndTime() constant returns (uint256) {
106         return auctionStart + biddingTime;
107     }
108     
109     /// End the auction and send the highest bid
110     /// to the beneficiary.
111     function auctionEnd() {
112         // It is a good guideline to structure functions that interact
113         // with other contracts (i.e. they call functions or send Ether)
114         // into three phases:
115         // 1. checking conditions
116         // 2. performing actions (potentially changing conditions)
117         // 3. interacting with other contracts
118         // If these phases are mixed up, the other contract could call
119         // back into the current contract and modify the state or cause
120         // effects (ether payout) to be performed multiple times.
121         // If functions called internally include interaction with external
122         // contracts, they also have to be considered interaction with
123         // external contracts.
124 
125         // 1. Conditions
126         require(now >= (auctionStart + biddingTime)); // auction did not yet end
127         require(!ended); // this function has already been called
128 
129         // 2. Effects
130         ended = true;
131         AuctionEnded(highestBidder, highestBid);
132 
133         // 3. Interaction
134         beneficiary.transfer(highestBid);
135     }
136 }