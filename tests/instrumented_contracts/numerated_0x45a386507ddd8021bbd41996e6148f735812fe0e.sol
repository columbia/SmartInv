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
12     function totalSupply() public view returns (uint);
13     function balanceOf(address tokenOwner) public view returns (uint balance);
14     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
15     function transfer(address to, uint tokens) public returns (bool success);
16     function approve(address spender, uint tokens) public returns (bool success);
17     function transferFrom(address from, address to, uint tokens) public returns (bool success);
18 
19     event Transfer(address indexed from, address indexed to, uint tokens);
20     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
21 }
22 
23 contract TournamentTicket is ERC20Interface {}
24 
25 contract TournamentTicketSale {
26 
27     //////// V A R I A B L E S
28     //
29     // Current address of the ticket contract (tickets).
30     //
31     address public ticketContract;
32     //
33     // Address that owns the tickets.
34     //
35     address payable public ticketOwner;
36     //
37     // In case the sale is paused.
38     //
39     bool public paused;
40     //
41     // Price per ticket.
42     //
43     uint public pricePerTicket;
44     //
45     // Standard contract ownership.
46     //
47     address payable public owner;
48     address payable private nextOwner;
49 
50     //////// M O D I F I E R S
51     //
52     // Invokable only by contract owner.
53     //
54     modifier onlyContractOwner {
55         require(msg.sender == owner, "Function called by non-owner.");
56         _;
57     }
58     //
59     // Invokable only by owner of the tickets.
60     //
61     modifier onlyTicketOwner {
62         require(msg.sender == ticketOwner, "Function called by non-ticket-owner.");
63         _;
64     }
65     //
66     // Invokable only if exchange is not paused.
67     //
68     modifier onlyUnpaused {
69         require(paused == false, "Exchange is paused.");
70         _;
71     }
72 
73     //////// C O N S T R U C T O R
74     //
75     constructor() public {
76         owner = msg.sender;
77     }
78 
79     //////// F U N C T I O N S
80     //
81     // Buy a single ticket.
82     //
83     function buyOne() onlyUnpaused payable external {
84         TournamentTicket ticket = getTicketContract();
85 
86         require(ticket.balanceOf(msg.sender) == 0, "You already have a ticket, and you only need one to participate!");
87         require(pricePerTicket > 0, "The price per ticket needs to be more than 0!");
88         require(msg.value == pricePerTicket, "The amout sent is not corresponding with the ticket price!");
89         
90         require(
91             ticket.transferFrom(getTicketOwnerAddress(), msg.sender, 1000000000000000000),
92             "Ticket transfer failed!"
93         );
94         
95         getTicketOwnerAddress().transfer(msg.value);
96     }
97     //
98     // Sets current ticket price.
99     //
100     function setTicketPrice(uint price) external onlyTicketOwner {
101         pricePerTicket = price;
102     }
103     //
104     // Sets current ticket token contract address.
105     //
106     function setTicketContract(address value) external onlyContractOwner {
107         ticketContract = value;
108     }
109     //
110     // Get current ticket token contract instance.
111     //
112     function getTicketContract() internal view returns(TournamentTicket) {
113         return(TournamentTicket(ticketContract));
114     }
115     //
116     // Sets current ticket token contract address.
117     //
118     function setTicketOwnerAddress(address payable value) external onlyContractOwner {
119         ticketOwner = value;
120     }
121     //
122     // Get current ticket token contract instance.
123     //
124     function getTicketOwnerAddress() internal view returns(address payable) {
125         return(ticketOwner);
126     }
127     //
128     // Set paused
129     //
130     function setPaused(bool value) external onlyContractOwner {
131         paused = value;
132     }
133     //
134     // Standard contract ownership transfer.
135     //
136     function approveNextOwner(address payable _nextOwner) external onlyContractOwner {
137         require(_nextOwner != owner, "Cannot approve current owner.");
138         nextOwner = _nextOwner;
139     }
140     //
141     // Accept the next getGodsTokenContract owner.
142     //
143     function acceptNextOwner() external {
144         require(msg.sender == nextOwner, "The new owner has to accept the previously set new owner.");
145         owner = nextOwner;
146     }
147     //
148     // Fallback function deliberately left empty. It's primary use case
149     // is to top up the exchange.
150     //
151     function () external payable {}
152     
153 }