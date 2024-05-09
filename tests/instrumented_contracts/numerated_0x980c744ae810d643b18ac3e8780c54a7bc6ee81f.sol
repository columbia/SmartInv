1 pragma solidity >=0.4.22 <0.6.0;
2 
3 // * Gods Unchained Ticket Sale
4 //
5 // * Version 1.0
6 //
7 // * A dedicated contract selling tickets for the Gods Unchained tournament.
8 //
9 // * https://gu.cards
10 
11 contract ERC20Interface {
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 }
14 
15 contract TournamentTicket is ERC20Interface {}
16 
17 contract TournamentTicketSale {
18 
19     //////// V A R I A B L E S
20     //
21     // The ticket owner
22     //
23     address payable constant public ticketOwner = 0x317D875cA3B9f8d14f960486C0d1D1913be74e90;
24     //
25     // The ticket contract
26     //
27     TournamentTicket constant public ticketContract = TournamentTicket(0x22365168c8705E95B2D08876C23a8c13E3ad72E2);
28     //
29     // In case the sale is paused.
30     //
31     bool public paused;
32     //
33     // Price per ticket.
34     //
35     uint public pricePerTicket;
36     //
37     // Standard contract ownership.
38     //
39     address payable public owner;
40 
41     //////// M O D I F I E R S
42     //
43     // Invokable only by contract owner.
44     //
45     modifier onlyContractOwner {
46         require(msg.sender == owner, "Function called by non-owner.");
47         _;
48     }
49     //
50     // Invokable only if exchange is not paused.
51     //
52     modifier onlyUnpaused {
53         require(paused == false, "Exchange is paused.");
54         _;
55     }
56 
57     //////// C O N S T R U C T O R
58     //
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     //////// F U N C T I O N S
64     //
65     // Buy a single ticket.
66     //
67     function buyOne() onlyUnpaused payable external {
68         require(msg.value == pricePerTicket, "The amout sent is not corresponding with the ticket price!");
69         
70         require(
71             ticketContract.transferFrom(ticketOwner, msg.sender, 1),
72             "Ticket transfer failed!"
73         );
74     }
75     //
76     // Sets current ticket price.
77     //
78     function setTicketPrice(uint price) external onlyContractOwner {
79         pricePerTicket = price;
80     }
81     //
82     // Set paused
83     //
84     function setPaused(bool value) external onlyContractOwner {
85         paused = value;
86     }
87     //
88     // Funds withdrawal to cover operational costs
89     //
90     function withdrawFunds(uint withdrawAmount) external onlyContractOwner {
91         ticketOwner.transfer(withdrawAmount);
92     }
93     //
94     // Contract may be destroyed only when there are no ongoing bets,
95     // either settled or refunded. All funds are transferred to contract owner.
96     //
97     function kill() external onlyContractOwner {
98         selfdestruct(owner);
99     }
100 }