1 pragma solidity 0.4.21;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256);
5     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
7     function transfer(address to, uint256 tokens) public returns (bool success);
8     function approve(address spender, uint256 tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract Harimid {
16 
17         uint private multiplier;
18         uint private payoutOrder = 0;
19 
20         address private owner;
21 
22         function Harimid(uint multiplierPercent) public {
23             owner = msg.sender;
24             multiplier = multiplierPercent;
25         }
26 
27         modifier onlyOwner {
28             require(msg.sender == owner);
29             _;
30         }
31 
32         modifier onlyPositiveSend {
33             require(msg.value > 0);
34             _;
35         }
36         struct Participant {
37             address etherAddress;
38             uint payout;
39         }
40 
41         Participant[] private participants;
42 
43 
44         function() public payable onlyPositiveSend {
45             participants.push(Participant(msg.sender, (msg.value * multiplier) / 100));
46             uint balance = msg.value;
47             while (balance > 0) {
48                 uint payoutToSend = balance < participants[payoutOrder].payout ? balance : participants[payoutOrder].payout;
49                 participants[payoutOrder].payout -= payoutToSend;
50                 balance -= payoutToSend;
51                 participants[payoutOrder].etherAddress.transfer(payoutToSend);
52                 if(balance > 0){
53                     payoutOrder += 1;
54                 }
55             }
56         }
57 
58 
59         function currentMultiplier() view public returns(uint) {
60             return multiplier;
61         }
62 
63         function totalParticipants() view public returns(uint count) {
64                 count = participants.length;
65         }
66 
67         function numberOfParticipantsWaitingForPayout() view public returns(uint ) {
68                 return participants.length - payoutOrder;
69         }
70 
71         function participantDetails(uint orderInPyramid) view public returns(address Address, uint Payout) {
72                 if (orderInPyramid <= participants.length) {
73                         Address = participants[orderInPyramid].etherAddress;
74                         Payout = participants[orderInPyramid].payout;
75                 }
76         }
77         
78         function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
79             return ERC20Interface(tokenAddress).transfer(owner, tokens);
80         }
81 }