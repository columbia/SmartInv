1 pragma solidity ^0.4.18;
2 
3 ///>[ Pre Sale ]>>>>
4 
5 contract BrandContest {
6     address public ceoAddress;
7 
8     function BrandContest() public {
9         ceoAddress = msg.sender;
10     }
11 
12     struct Contest {
13         bool open;
14         uint256 ticket_price;
15         uint8 tickets_sold;
16         address winner;
17         mapping (uint256 => address) tickets;
18     }
19     mapping (string => Contest) contests;
20 
21     
22     struct Slot {
23         uint256 price;
24         address owner;
25     }
26     mapping (uint256 => Slot) slots;
27 
28     modifier onlyCEO() { require(msg.sender == ceoAddress); _; }
29     function setCEO(address _newCEO) public onlyCEO {
30         require(_newCEO != address(0));
31         ceoAddress = _newCEO;
32     }
33     
34     function buyTicket(string _key) public payable {
35         require(msg.sender != address(0));
36         Contest storage contest = contests[_key];
37         require(contest.open == true);
38         require(msg.value >= contest.ticket_price);
39         
40         contest.tickets[contest.tickets_sold] = msg.sender;
41         contest.tickets_sold++;
42         
43         if(msg.value > contest.ticket_price){
44             msg.sender.transfer(SafeMath.sub(msg.value, contest.ticket_price));
45         }
46     }
47     
48     function buySlot(uint256 _slot) public payable {
49         require(msg.sender != address(0));
50         Slot storage slot = slots[_slot];
51         require(slot.owner == address(0));
52         require(msg.value >= slot.price);
53     
54         slot.owner = msg.sender;
55 
56         if(msg.value > slot.price){
57             msg.sender.transfer(SafeMath.sub(msg.value, slot.price));
58         }
59     }
60     
61     function getContest(string _key) public view returns (
62         string name,
63         bool open,
64         uint256 ticket_price,
65         uint8 tickets_sold,
66         address winner,
67         address[5] last_tickets
68     ) {
69         name = _key;
70         open = contests[_key].open;
71         ticket_price = contests[_key].ticket_price;
72         tickets_sold = contests[_key].tickets_sold;
73         winner = contests[_key].winner;
74     
75         for(uint8 i = 0; i < 5; i++){
76             last_tickets[i] = contests[_key].tickets[ contests[_key].tickets_sold-1-i ];
77         }
78     }
79     
80     function getSlot(uint256 _slot) public view returns (
81         uint256 slot,
82         bool open,
83         uint256 price,
84         address owner
85     ) {
86         slot = _slot;
87         open = (slots[_slot].owner == address(0));
88         price = slots[_slot].price;
89         owner = slots[_slot].owner;
90     }
91     
92     function getTickets(string _key) public view returns (
93         string name,
94         address[] tickets
95     ) {
96         name = _key;
97         for(uint8 i = 0; i < contests[_key].tickets_sold; i++){
98             tickets[i] = contests[_key].tickets[ i ];
99         }
100     }
101     
102     function getMyTickets(string _key, address _address) public view returns (
103         string name,
104         uint ticket_count
105     ) {
106         name = _key;
107         for(uint8 i = 0; i < contests[_key].tickets_sold; i++){
108             if(contests[_key].tickets[i] == _address){
109                 ticket_count++;
110             }
111         }
112     }
113 
114     function createContest(string _key, uint256 _ticket_price) public onlyCEO {
115         require(msg.sender != address(0));
116         contests[_key] = Contest(true, _ticket_price, 0, address(0));
117     }
118     
119     function createSlot(uint256 _slot, uint256 _price) public onlyCEO {
120         require(msg.sender != address(0));
121         slots[_slot] = Slot(_price, address(0));
122     }
123     
124     function closeContest(string _key) public onlyCEO {
125         require(msg.sender != address(0));
126         uint seed = (block.number + contests[_key].tickets_sold + contests[_key].ticket_price);
127         uint winner_num = uint(sha3(block.blockhash(block.number-1), seed ))%contests[_key].tickets_sold;
128         contests[_key].winner = contests[_key].tickets[winner_num];
129         contests[_key].open = false;
130     }
131     
132     function payout() public onlyCEO {
133         ceoAddress.transfer(this.balance);
134     }
135 }
136 
137 library SafeMath {
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         if (a == 0) {
140             return 0;
141         }
142         uint256 c = a * b;
143         assert(c / a == b);
144         return c;
145     }
146     function div(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a / b;
148         return c;
149     }
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         assert(b <= a);
152         return a - b;
153     }
154     function add(uint256 a, uint256 b) internal pure returns (uint256) {
155         uint256 c = a + b;
156         assert(c >= a);
157         return c;
158     }
159 }