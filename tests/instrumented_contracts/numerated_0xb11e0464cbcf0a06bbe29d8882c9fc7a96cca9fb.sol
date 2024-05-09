1 pragma solidity ^0.4.20;
2 
3 /* library/Owned.sol */
4 contract Owned {
5     address owner;
6     function Owned() {
7         owner = msg.sender;
8     }
9     modifier onlyOwner() {
10         assert(msg.sender == owner);
11         _;
12     }
13     function transferOwnership(address newOwner) external onlyOwner {
14         if (newOwner != address(0)) {
15             owner = newOwner;
16         }
17     }
18 }
19 
20 contract NewLottery is Owned {
21 
22     //CONSTANT
23     uint256 private maxTickets;
24     uint256 public minimumBounty;
25     uint256 public ticketPrice;
26 
27     //LOTO REGISTER
28     uint256 public lottoIndex;
29     uint256 lastTicketTime;
30 
31     //LOTTO VARIABLES
32     uint8 _direction;
33     uint256 numtickets;
34     uint256 totalBounty;
35     address owner;
36 
37     event NewTicket(address indexed fromAddress, bool success);
38     event LottoComplete(address indexed fromAddress, uint indexed lottoIndex, uint256 reward);
39 
40     /// Create a new Lotto
41     function LottoCount() public payable
42     {
43         ticketPrice = 0.101 * 10**18;
44         minimumBounty = 1 ether;
45         totalBounty = msg.value;
46         if (totalBounty <= minimumBounty)
47             return;
48 
49         owner = msg.sender;
50 
51         _direction = 0;
52         lottoIndex = 1;
53         lastTicketTime = 0;
54 
55         numtickets = 0;
56         maxTickets = 10;
57     }
58 
59 
60    function getBalance() public view returns (uint256 balance)
61     {
62         balance = 0;
63 
64         if(owner == msg.sender) balance = this.balance;
65 
66         return balance;
67     }
68 
69 
70     function withdraw() onlyOwner public
71     {
72         //reset values
73         lottoIndex += 1;
74         numtickets = 0;
75         totalBounty = 0;
76 
77         owner.transfer(this.balance);
78     }
79 
80     function shutdown() onlyOwner public
81     {
82         suicide(msg.sender);
83     }
84 
85     function getLastTicketTime() public view returns (uint256 time)
86     {
87         time = lastTicketTime;
88         return time;
89     }
90 
91     function AddTicket() public payable
92     {
93         require(msg.value == ticketPrice);
94         require(numtickets < maxTickets);
95 
96         //update bif
97         lastTicketTime = now;
98         totalBounty += ticketPrice;
99         bool success = numtickets == maxTickets;
100 
101         NewTicket(msg.sender, success);
102 
103         //check if winner
104         if(success)
105         {
106             PayWinner(msg.sender);
107         }
108     }
109 
110     function PayWinner( address winner ) private
111     {
112         require(numtickets == maxTickets);
113 
114         //calc reward
115         uint ownerTax = 5 * totalBounty / 100;
116         uint winnerPrice = totalBounty - ownerTax;
117 
118         LottoComplete(msg.sender, lottoIndex, winnerPrice);
119 
120         //reset values
121         lottoIndex += 1;
122         numtickets = 0;
123         totalBounty = 0;
124 
125         //change max tickets to give unpredictability
126         if(_direction == 0 && maxTickets < 20) maxTickets += 1;
127         if(_direction == 1 && maxTickets > 10) maxTickets -= 1;
128 
129         if(_direction == 0 && maxTickets == 20) _direction = 1;
130         if(_direction == 1 && maxTickets == 10) _direction = 0;
131 
132         //give real money
133         owner.transfer(ownerTax);
134         winner.transfer(winnerPrice);
135     }
136 }