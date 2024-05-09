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
43         owner = msg.sender;
44 
45         ticketPrice = 0.101 * 10**18;
46         minimumBounty = 1 * 10**18;
47         maxTickets = 10;
48 
49         _direction = 0;
50         lottoIndex = 1;
51         lastTicketTime = 0;
52 
53         numtickets = 0;
54         totalBounty = msg.value;
55         require(totalBounty >= minimumBounty);
56     }
57 
58 
59    function getBalance() public view returns (uint256 balance)
60     {
61         balance = 0;
62 
63         if(owner == msg.sender) balance = this.balance;
64 
65         return balance;
66     }
67 
68 
69     function withdraw() onlyOwner public
70     {
71         //reset values
72         lottoIndex += 1;
73         numtickets = 0;
74         totalBounty = 0;
75 
76         owner.transfer(this.balance);
77     }
78 
79     function shutdown() onlyOwner public
80     {
81         suicide(msg.sender);
82     }
83 
84     function getLastTicketTime() public view returns (uint256 time)
85     {
86         time = lastTicketTime;
87         return time;
88     }
89 
90     function AddTicket() public payable
91     {
92         require(msg.value == ticketPrice);
93         require(numtickets < maxTickets);
94 
95         //update bif
96         lastTicketTime = now;
97         totalBounty += ticketPrice;
98         bool success = numtickets == maxTickets;
99 
100         NewTicket(msg.sender, success);
101 
102         //check if winner
103         if(success)
104         {
105             PayWinner(msg.sender);
106         }
107     }
108 
109     function PayWinner( address winner ) private
110     {
111         require(numtickets == maxTickets);
112 
113         //calc reward
114         uint ownerTax = 5 * totalBounty / 100;
115         uint winnerPrice = totalBounty - ownerTax;
116 
117         LottoComplete(msg.sender, lottoIndex, winnerPrice);
118 
119         //reset values
120         lottoIndex += 1;
121         numtickets = 0;
122         totalBounty = 0;
123 
124         //change max tickets to give unpredictability
125         if(_direction == 0 && maxTickets < 20) maxTickets += 1;
126         if(_direction == 1 && maxTickets > 10) maxTickets -= 1;
127 
128         if(_direction == 0 && maxTickets == 20) _direction = 1;
129         if(_direction == 1 && maxTickets == 10) _direction = 0;
130 
131         //give real money
132         owner.transfer(ownerTax);
133         winner.transfer(winnerPrice);
134     }
135 }