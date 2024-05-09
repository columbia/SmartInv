1 pragma solidity ^0.4.12;
2 
3 contract Leaderboard {
4     // Contract owner
5     address owner;
6     // Bid must be multiples of minBid
7     uint256 public minBid;
8     // Max num of leaders on the board
9     uint public maxLeaders;
10     
11     // Linked list of leaders on the board
12     uint public numLeaders;
13     address public head;
14     address public tail;
15     mapping (address => Leader) public leaders;
16     
17     struct Leader {
18         // Data
19         uint256 amount;
20         string url;
21         string img_url;
22         
23         // Pointer to next and prev element in linked list
24         address next;
25         address previous;
26     }
27     
28     
29     // Set initial parameters
30     function Leaderboard() {
31         owner = msg.sender;
32         minBid = 0.001 ether;
33         numLeaders = 0;
34         maxLeaders = 10;
35     }
36     
37     
38     /*
39         Default function, make a new bid or add to bid by sending Eth to contract
40     */
41     function () payable {
42         // Bid must be larger than minBid
43         require(msg.value >= minBid);
44         
45         // Bid must be multiple of minBid. Remainder is sent back.
46         uint256 remainder  = msg.value % minBid;
47         uint256 bid_amount = msg.value - remainder;
48         
49         // If leaderboard is full, bid needs to be larger than the lowest placed leader
50         require(!((numLeaders == maxLeaders) && (bid_amount <= leaders[tail].amount)));
51         
52         // Get leader
53         Leader memory leader = popLeader(msg.sender);
54         
55         // Add to leader's bid
56         leader.amount += bid_amount;
57         
58         // Insert leader in appropriate position
59         insertLeader(leader);
60         
61         // If leaderboard is full, drop last leader
62         if (numLeaders > maxLeaders) {
63             dropLast();
64         }
65         
66         // Return remainder to sender
67         if (remainder > 0) msg.sender.transfer(remainder);
68     }
69     
70     
71     /*
72         Set the urls for the link and image
73     */
74     function setUrls(string url, string img_url) {
75         var leader = leaders[msg.sender];
76         
77         require(leader.amount > 0);
78         
79         // Set leader's url if it is not an empty string
80         bytes memory tmp_url = bytes(url);
81         if (tmp_url.length != 0) {
82             // Set url
83             leader.url = url;
84         }
85         
86         // Set leader's img_url if it is not an empty string
87         bytes memory tmp_img_url = bytes(img_url);
88         if (tmp_img_url.length != 0) {
89             // Set image url
90             leader.img_url = img_url;
91         }
92     }
93     
94     
95     /*
96         Allow user to reset urls if he wants nothing to show on the board
97     */
98     function resetUrls(bool url, bool img_url) {
99         var leader = leaders[msg.sender];
100         
101         require(leader.amount > 0);
102         
103         // Reset urls
104         if (url) leader.url = "";
105         if (img_url) leader.img_url = "";
106     }
107     
108     
109     /*
110         Get a leader at position
111     */
112     function getLeader(address key) constant returns (uint amount, string url, string img_url, address next) {
113         amount  = leaders[key].amount;
114         url     = leaders[key].url;
115         img_url = leaders[key].img_url;
116         next    = leaders[key].next;
117     }
118     
119     
120     /*
121         Remove from leaderboard LL
122     */
123     function popLeader(address key) internal returns (Leader leader) {
124         leader = leaders[key];
125         
126         // If no leader - return
127         if (leader.amount == 0) {
128             return leader;
129         }
130         
131         if (numLeaders == 1) {
132             tail = 0x0;
133             head = 0x0;
134         } else if (key == head) {
135             head = leader.next;
136             leaders[head].previous = 0x0;
137         } else if (key == tail) {
138             tail = leader.previous;
139             leaders[tail].next = 0x0;
140         } else {
141             leaders[leader.previous].next = leader.next;
142             leaders[leader.next].previous = leader.previous;
143         }
144         
145         numLeaders--;
146         return leader;
147     }
148     
149     
150     /*
151         Insert in leaderboard LinkedList
152     */
153     function insertLeader(Leader leader) internal {
154         if (numLeaders == 0) {
155             head = msg.sender;
156             tail = msg.sender;
157         } else if (leader.amount <= leaders[tail].amount) {
158             leaders[tail].next = msg.sender;
159             tail = msg.sender;
160         } else if (leader.amount > leaders[head].amount) {
161             leader.next = head;
162             leaders[head].previous = msg.sender;
163             head = msg.sender;
164         } else {
165             var current_addr = head;
166             var current = leaders[current_addr];
167             
168             while (current.amount > 0) {
169                 if (leader.amount > current.amount) {
170                     leader.next = current_addr;
171                     leader.previous = current.previous;
172                     current.previous = msg.sender;
173                     leaders[current.previous].next = msg.sender;
174                     break;
175                 }
176                 
177                 current_addr = current.next;
178                 current = leaders[current_addr];
179             }
180         }
181         
182         leaders[msg.sender] = leader;
183         numLeaders++;
184     }
185     
186     
187     /*
188         Drop last leader from board and return his/her funds
189     */
190     function dropLast() internal {
191         // Get last leader
192         address leader_addr = tail;
193         var leader = popLeader(leader_addr);
194         
195         uint256 refund_amount = leader.amount;
196         
197         // Delete leader from board
198         delete leader;
199         
200         // Return funds to leader
201         leader_addr.transfer(refund_amount);
202     }
203 
204     
205     /*
206         Modifier that only allows the owner to call certain functions
207     */
208     modifier onlyOwner {
209         require(owner == msg.sender);
210         _;
211     }
212 
213 
214     /*
215         Lets owner withdraw Eth from the contract. Owner can withdraw all funds,
216         because leaders who fall of the board can always be refunded with the new
217         bid: (newBid > refund).
218     */
219     function withdraw() onlyOwner {
220         owner.transfer(this.balance);
221     }
222     
223     
224     /*
225         Set new maximum for amount of leaders
226     */
227     function setMaxLeaders(uint newMax) onlyOwner {
228         maxLeaders = newMax;
229     }
230 }