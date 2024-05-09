1 pragma solidity ^0.4.0;
2 
3 contract TwentyDollars {
4     /*
5      * Storage
6      */
7 
8     struct Bid {
9         address owner;
10         uint256 amount;
11     }
12 
13     address owner;
14     uint256 public gameValue;
15     uint256 public gameEndBlock;
16     
17     Bid public highestBid;
18     Bid public secondHighestBid;
19     mapping (address => uint256) public balances;
20 
21     
22     /*
23      * Modifiers
24      */
25 
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     modifier onlyBiddingOpen() {
32         require(block.number < gameEndBlock);
33         _;
34     }
35 
36     modifier onlyBiddingClosed() {
37         require(biddingClosed());
38         _;
39     }
40 
41     modifier onlyHighestBidder() {
42         require(msg.sender == highestBid.owner);
43         _;
44     }
45     
46     
47     /*
48      * Constructor
49      */
50     
51     constructor() public payable {
52         owner = msg.sender;
53         gameValue = msg.value;
54         gameEndBlock = block.number + 40000;
55     }
56 
57 
58     /*
59      * Public functions
60      */
61 
62     function bid() public payable onlyBiddingOpen {
63         // Must bid higher than current highest bid.
64         require(msg.value > highestBid.amount);
65 
66         // Push out second highest bid and set new highest bid.
67         balances[secondHighestBid.owner] += secondHighestBid.amount;
68         secondHighestBid = highestBid;
69         highestBid.owner = msg.sender;
70         highestBid.amount = msg.value;
71         
72         // Extend the game by ten blocks.
73         gameEndBlock += 10;
74     }
75     
76     function withdraw() public {
77         uint256 balance = balances[msg.sender];
78         require(balance > 0);
79         balances[msg.sender] = 0;
80         msg.sender.transfer(balance);
81     }
82 
83     function winnerWithdraw() public onlyBiddingClosed onlyHighestBidder {
84         address highestBidder = highestBid.owner;
85         require(highestBidder != address(0));
86         delete highestBid.owner;
87         highestBidder.transfer(gameValue);
88     }
89 
90     function ownerWithdraw() public onlyOwner onlyBiddingClosed {
91         // Withdraw the value of the contract minus allocation for the winner. 
92         uint256 winnerAllocation = (highestBid.owner == address(0)) ? 0 : gameValue;
93         owner.transfer(getContractBalance() - winnerAllocation);
94     }
95 
96     function getMyBalance() public view returns (uint256) {
97         return balances[msg.sender];
98     }
99     
100     function getContractBalance() public view returns (uint256) {
101         return address(this).balance;
102     }
103     
104     function biddingClosed() public view returns (bool) {
105         return block.number >= gameEndBlock;
106     }
107     
108     
109     /*
110      * Fallback
111      */
112 
113     function () public payable {
114         bid();
115     }
116 }