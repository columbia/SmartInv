1 contract Tickets {
2 
3     string public name = "Kraftwerk";
4     string public symbol = "KKT";
5     uint8 public decimals = 0;
6 
7     address[1000] public holders;
8     mapping(uint256 => bool) public usedTickets;
9     mapping(uint256 => string) public additionalInfo;
10     mapping(address => uint[16]) public seatsList;
11     mapping(address => uint256) public balanceOf;
12     address[30000] public booking;
13     mapping(address => uint[16]) public bookingList;
14     mapping(address => uint256) public amountOfBooked;
15 
16     address Manager;
17     address ManagerForRate;
18     address Company;
19     address nullAddress = 0x0;
20 
21     uint public limitPerHolder = 16;
22     uint public seatsCount = 1000;
23     uint scaleMultiplier = 1000000000000000000; 
24 
25     uint public Rate_Eth = 298;
26     uint public Ticket_Price = 15*scaleMultiplier/Rate_Eth;
27 
28     modifier managerOnly { require(msg.sender == Manager); _; }
29     modifier rateManagerOnly { require(msg.sender == ManagerForRate); _; }
30 
31     event LogAllocateTicket(uint256 _seatID, address _buyer, string _infoString);
32     event LogTransfer(address _holder, address _receiver, uint256 _seatID, string _infoStringt);
33     event LogRedeemTicket(uint _seatID, address _holder, string _infoString);
34     event LogBookTicket(uint _seatID, address _buyer,string _infoString);
35     event LogCancelReservation(address _buyer, uint _seatID);
36 
37 
38 
39     function Tickets(address _ManagerForRate,  address _Manager, address _Company) {
40         ManagerForRate = _ManagerForRate;
41         Manager = _Manager;
42         Company = _Company;
43     }
44 
45     function setRate(uint _RateEth) external rateManagerOnly {
46        Rate_Eth = _RateEth;
47        Ticket_Price = 15*scaleMultiplier/Rate_Eth;
48     }
49 
50 
51     function allocateTicket(uint256 seatID, address buyer, string infoString) external managerOnly {
52         require(seatID > 0 && seatID < seatsCount);
53         require(holders[seatID] == nullAddress);
54         require(balanceOf[buyer] < limitPerHolder);
55         require(booking[seatID] == nullAddress);
56         createTicket(seatID, buyer);
57         additionalInfo[seatID] = infoString;
58         LogAllocateTicket(seatID, buyer, infoString);
59     }
60 
61     function createTicket(uint256 seatID, address buyer) internal {
62         uint i = 0;
63         for(i = 0; i < limitPerHolder; i++)
64         {
65             if(seatsList[buyer][i] == 0)
66             {
67                 break;
68             }
69         }
70         holders[seatID] = buyer;
71         balanceOf[buyer] += 1;
72         seatsList[buyer][i] = seatID;
73     }
74 
75     function redeemTicket(uint seatID, address holder) external managerOnly{
76         require(seatID > 0 && seatID < seatsCount);
77         require(usedTickets[seatID] == false);
78         require(holders[seatID] == holder);
79         usedTickets[seatID] = true;
80         string infoString = additionalInfo[seatID];
81         LogRedeemTicket(seatID, holder, infoString);
82     }
83 
84     function transfer(address holder, address receiver, uint256 seatID) external managerOnly{
85         require(seatID > 0 && seatID < seatsCount);
86         require(holders[seatID] == holder);
87         require(balanceOf[receiver] < limitPerHolder);
88         require(holder != receiver);
89         uint i = 0;
90         holders[seatID] = receiver;
91         balanceOf[holder] -= 1;
92         if(receiver != nullAddress)
93         {
94             for(i = 0; i < limitPerHolder; i++)
95               {
96                   if(seatsList[receiver][i] == 0)
97                   {
98                      break;
99                   }
100             }
101             balanceOf[receiver] += 1;
102             seatsList[receiver][i] = seatID;
103         }
104         for(i = 0; i < limitPerHolder; i++)
105         {
106             if(seatsList[holder][i] == seatID)
107             {
108                 seatsList[holder][i] = 0;
109             }
110         }
111         string infoString = additionalInfo[seatID];
112         LogTransfer(holder, receiver, seatID, infoString);
113     }
114 
115     function bookTicket(uint256 seatID, address buyer, string infoString) external managerOnly{
116         require(seatID > 0 && seatID < seatsCount);
117         require(holders[seatID] == nullAddress);
118         require(booking[seatID] == nullAddress);
119         require(balanceOf[buyer] + amountOfBooked[buyer] < limitPerHolder);
120         uint i = 0;
121         booking[seatID] = buyer;
122         amountOfBooked[buyer] += 1;
123         while(bookingList[buyer][i] != 0) {
124             i++;
125         }
126         bookingList[buyer][i] = seatID;
127         additionalInfo[seatID] = infoString;
128         LogBookTicket(seatID, buyer, infoString);
129     }
130 
131     function cancelReservation(address buyer, uint256 seatID) external managerOnly{
132         require(booking[seatID] == buyer);
133         uint i = 0;
134         while(i < limitPerHolder) {
135             if (seatID == bookingList[buyer][i]){
136               booking[seatID] = nullAddress;
137               bookingList[buyer][i] = 0;
138               break;
139             }
140             i++;
141         }
142         amountOfBooked[buyer] -= 1;
143         LogCancelReservation(buyer, seatID);
144     }
145 
146 
147     function() payable {
148         require(amountOfBooked[msg.sender] != 0);
149         require(balanceOf[msg.sender] + amountOfBooked[msg.sender] <= limitPerHolder);
150         require(msg.value >= Ticket_Price * amountOfBooked[msg.sender]);
151         makePayment(msg.sender);
152     }
153 
154     function makePayment(address buyer) internal {
155         uint i = 0;
156         uint seatID;
157         string infoString;
158         while(i < limitPerHolder) {
159             if(bookingList[buyer][i] != 0) {
160               seatID = bookingList[buyer][i];
161               bookingList[buyer][i] = 0;
162               booking[seatID] = nullAddress;
163               createTicket(seatID, buyer);
164               infoString = additionalInfo[seatID];
165               LogAllocateTicket(seatID, msg.sender, infoString);
166             }
167             i++;
168         }
169         amountOfBooked[buyer] = 0;
170     }
171 
172     function withdrawEther(uint256 _value) external managerOnly{
173        Company.transfer(_value);
174     }
175 
176 
177 }