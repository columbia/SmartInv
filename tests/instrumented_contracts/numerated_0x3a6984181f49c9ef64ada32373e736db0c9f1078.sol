1 pragma solidity ^0.4.22;
2 
3 /// @title Auctionify, A platform to auction stuff, using ethereum
4 /// @author Auctionify.xyz
5 /// @notice This is the stand alone version of the auction
6 /// // @dev All function calls are currently implement without side effects
7 contract Auctionify {
8     // Parameters of the auction.
9     // Time is absolute unix timestamps
10 
11     address public beneficiary;
12     uint public auctionEnd;
13     string public auctionTitle;
14     string public auctionDescription;
15     uint public minimumBid;
16 
17     // Escrow
18     address public escrowModerator;
19     //bool public escrowEnabled;
20 
21     // Current state of the auction.
22     address public highestBidder;
23 
24     // List of all the bids
25     mapping(address => uint) public bids;
26 
27     // State of the Auction
28     enum AuctionStates { Started, Ongoing, Ended }
29     AuctionStates public auctionState;
30 
31 
32     //modifiers
33     modifier auctionNotEnded()
34     {
35         // Revert the call if the bidding
36         // period is over.
37         require(
38             now < auctionEnd, // do not front-run me miners
39             "Auction already ended."
40         );
41         require(
42           auctionState != AuctionStates.Ended,
43            "Auction already ended."
44           );
45         _;
46     }
47 
48     //modifiers
49     modifier isMinimumBid()
50     {
51       // If the bid is higher than minimumBid
52       require(
53           msg.value >= minimumBid,
54           "The value is smaller than minimum bid."
55       );
56       _;
57     }
58 
59     modifier isHighestBid()
60     {
61       // If the bid is not higher than higestBid,
62       // send the money back.
63       require(
64           msg.value > bids[highestBidder],
65           "There already is a higher bid."
66       );
67       _;
68     }
69 
70     modifier onlyHighestBidderOrEscrow()
71     {
72       // only highestBidder or the moderator can call.
73       // Also callable if no one has bidded
74       if ((msg.sender == highestBidder) || (msg.sender == escrowModerator) || (highestBidder == address(0))) {
75         _;
76       }
77       else{
78         revert();
79       }
80     }
81 
82 
83     // Events that will be fired on changes.
84     event HighestBidIncreased(address bidder, uint amount);
85     event AuctionEnded(address winner, uint amount);
86     event CheaterBidder(address cheater, uint amount);
87 
88     constructor(
89         string _auctionTitle,
90         uint _auctionEnd,
91         address _beneficiary,
92         string _auctionDesc,
93         uint _minimumBid,
94         bool _escrowEnabled,
95         bool _listed
96     ) public {
97         auctionTitle = _auctionTitle;
98         beneficiary = _beneficiary;
99         auctionEnd = _auctionEnd;
100         auctionDescription = _auctionDesc;
101         auctionState = AuctionStates.Started;
102         minimumBid = _minimumBid;
103         if (_escrowEnabled) {
104           // TODO: get moderatorID, (delegate moderator list to a ens resolver)
105           escrowModerator = address(0x32cEfb2dC869BBfe636f7547CDa43f561Bf88d5A); //TODO: ENS resolver for auctionify.eth
106         }
107         if (_listed) {
108           // TODO: List in the registrar
109         }
110     }
111 
112     /// @author Auctionify.xyz
113    /// @notice Bid on the auction with the amount of `msg.value`
114    /// The lesser value will be refunded.
115    /// updates highestBidder
116    /// @dev should satisfy auctionNotEnded(), isMinimumBid(), isHighestBid()
117     function bid() public payable auctionNotEnded isMinimumBid isHighestBid {
118         // No arguments are necessary, all
119         // information is already part of
120         // the transaction.
121         if (highestBidder != address(0)) {
122             //refund the last highest bid
123             uint lastBid = bids[highestBidder];
124             bids[highestBidder] = 0;
125             if(!highestBidder.send(lastBid)) {
126                 // if failed to send, the bid is kept in the contract
127                 emit CheaterBidder(highestBidder, lastBid);
128             }
129         }
130 
131         //set the new highestBidder
132         highestBidder = msg.sender;
133         bids[msg.sender] = msg.value;
134 
135         //change state and trigger event
136         auctionState = AuctionStates.Ongoing;
137         emit HighestBidIncreased(msg.sender, msg.value);
138     }
139 
140     /// @author auctionify.xyz
141    /// @notice Getter function for highestBid `bids[highestBidder]`
142    /// @dev View only function, free
143    /// @return the highest bid value
144     function highestBid() public view returns(uint){
145       return (bids[highestBidder]);
146     }
147 
148     /// End the auction and send the highest bid
149     /// to the beneficiary.
150     /// @author auctionify.xyz
151    /// @notice Ends the auction and sends the `bids[highestBidder]` to `beneficiary`
152    /// @dev onlyHighestBidderOrEscrow, after `auctionEnd`, only if `auctionState != AuctionStates.Ended`
153     function endAuction() public onlyHighestBidderOrEscrow {
154 
155         // 1. Conditions
156         require(now >= auctionEnd, "Auction not yet ended.");
157         require(auctionState != AuctionStates.Ended, "Auction has already ended.");
158 
159         // 2. Effects
160         auctionState = AuctionStates.Ended;
161         emit AuctionEnded(highestBidder, bids[highestBidder]);
162 
163         // 3. Interaction. send the money to the beneficiary
164         if(!beneficiary.send(bids[highestBidder])) {
165             // if failed to send, the final bid is kept in the contract
166             // the funds can be released using cleanUpAfterYourself()
167         }
168     }
169 
170     /// @author auctionify.xyz
171    /// @notice selfdestructs and sends the balance to `escrowModerator` or `beneficiary`
172    /// @dev only if `auctionState == AuctionStates.Ended`
173   function cleanUpAfterYourself() public {
174     require(auctionState == AuctionStates.Ended, "Auction is not ended.");
175       if (escrowModerator != address(0)) {
176         selfdestruct(escrowModerator);
177       } else {
178         selfdestruct(beneficiary); //save blockchain space, save lives
179       }
180   }
181 }