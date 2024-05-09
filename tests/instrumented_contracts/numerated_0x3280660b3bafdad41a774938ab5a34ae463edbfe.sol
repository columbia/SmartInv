1 pragma solidity ^0.4.23;
2 
3 // Deploying version: https://github.com/astralship/auction-ethereum/commit/1359e14e0319c6019eb9c7e57348b95c722e3dd6
4 // Timestamp Converter: 1529279999
5 // Is equivalent to: 06/17/2018 @ 11:59pm (UTC)
6 // Sunday midnight, in a week ?
7 
8 contract Auction {
9   
10   string public description;
11   string public instructions; // will be used for delivery address or email
12   uint public price;
13   bool public initialPrice = true; // at first asking price is OK, then +25% required
14   uint public timestampEnd;
15   address public beneficiary;
16   bool public finalized = false;
17 
18   address public owner;
19   address public winner;
20   mapping(address => uint) public bids;
21   address[] public accountsList; // so we can iterate: https://ethereum.stackexchange.com/questions/13167/are-there-well-solved-and-simple-storage-patterns-for-solidity
22 
23   // THINK: should be (an optional) constructor parameter?
24   // For now if you want to change - simply modify the code
25   uint public increaseTimeIfBidBeforeEnd = 24 * 60 * 60; // Naming things: https://www.instagram.com/p/BSa_O5zjh8X/
26   uint public increaseTimeBy = 24 * 60 * 60;
27   
28 
29   event Bid(address indexed winner, uint indexed price, uint indexed timestamp);
30   event Refund(address indexed sender, uint indexed amount, uint indexed timestamp);
31   
32   modifier onlyOwner { require(owner == msg.sender, "only owner"); _; }
33   modifier onlyWinner { require(winner == msg.sender, "only winner"); _; }
34   modifier ended { require(now > timestampEnd, "not ended yet"); _; }
35 
36   function setDescription(string _description) public onlyOwner() {
37     description = _description;
38   }
39 
40   function setInstructions(string _instructions) public ended() onlyWinner()  {
41     instructions = _instructions;
42   }
43 
44   constructor(uint _price, string _description, uint _timestampEnd, address _beneficiary) public {
45     require(_timestampEnd > now, "end of the auction must be in the future");
46     owner = msg.sender;
47     price = _price;
48     description = _description;
49     timestampEnd = _timestampEnd;
50     beneficiary = _beneficiary;
51   }
52 
53   function() public payable {
54 
55     if (msg.value == 0) { // when sending `0` it acts as if it was `withdraw`
56       refund();
57       return;
58     }
59 
60     require(now < timestampEnd, "auction has ended"); // sending ether only allowed before the end
61 
62     if (bids[msg.sender] > 0) { // First we add the bid to an existing bid
63       bids[msg.sender] += msg.value;
64     } else {
65       bids[msg.sender] = msg.value;
66       accountsList.push(msg.sender); // this is out first bid, therefore adding 
67     }
68 
69     if (initialPrice) {
70       require(bids[msg.sender] >= price, "bid too low, minimum is the initial price");
71     } else {
72       require(bids[msg.sender] >= (price * 5 / 4), "bid too low, minimum 25% increment");
73     }
74     
75     if (now > timestampEnd - increaseTimeIfBidBeforeEnd) {
76       timestampEnd = now + increaseTimeBy;
77     }
78 
79     initialPrice = false;
80     price = bids[msg.sender];
81     winner = msg.sender;
82     emit Bid(winner, price, now);
83   }
84 
85   function finalize() public ended() onlyOwner() {
86     require(finalized == false, "can withdraw only once");
87     require(initialPrice == false, "can withdraw only if there were bids");
88 
89     finalized = true; // THINK: DAO hack reentrancy - does it matter which order? (just in case setting it first)
90     beneficiary.send(price);
91 
92     bids[winner] = 0; // setting it to zero that in the refund loop it is skipped
93     for (uint i = 0; i < accountsList.length;  i++) {
94       if (bids[accountsList[i]] > 0) {
95         accountsList[i].send( bids[accountsList[i]] ); // send? transfer? tell me baby: https://ethereum.stackexchange.com/a/38642/2524
96         bids[accountsList[i]] = 0; // in case someone calls `refund` again
97       }
98     }     
99   }
100 
101   function refund() public {
102     require(msg.sender != winner, "winner cannot refund");
103 
104     msg.sender.send( bids[msg.sender] );
105     emit Refund(msg.sender, bids[msg.sender], now);
106     bids[msg.sender] = 0;
107   }
108 
109 }