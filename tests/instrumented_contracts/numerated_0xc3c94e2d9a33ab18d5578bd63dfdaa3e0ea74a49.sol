1 pragma solidity ^0.4.17;
2 
3 contract PyramidGame
4 {
5     /////////////////////////////////////////////
6     // Game parameters
7     uint256 private constant BOTTOM_LAYER_BET_AMOUNT = 0.005 ether;
8     uint256 private adminFeeDivisor; // e.g. 100 means a 1% fee, 200 means a 0.5% fee
9     
10     /////////////////////////////////////////////
11     // Game owner
12     address private administrator;
13     
14     /////////////////////////////////////////////
15     // Pyramid grid data
16     //
17     // The uint32 is the coordinates.
18     // It consists of two uint16's:
19     // The x is the most significant 2 bytes (16 bits)
20     // The y is the least significant 2 bytes (16 bits)
21     // x = coordinates >> 16
22     // y = coordinates & 0xFFFF
23     // coordinates = (x << 16) | y
24     // x is a 16-bit unsigned integer
25     // y is a 16-bit unsigned integer
26     mapping(uint32 => address) public coordinatesToAddresses;
27     uint32[] public allBlockCoordinates;
28     
29     // In the user interface, the rows of blocks will be
30     // progressively shifted more to the right, as y increases
31     // 
32     // For example, these blocks in the contract's coordinate system:
33     //         ______
34     //      2 |__A__|______
35     // /|\  1 |__B__|__D__|______
36     //  |   0 |__C__|__E__|__F__|
37     //  y        0     1     2
38     // 
39     //        x -->
40     // 
41     // 
42     // Become these blocks in the user interface:
43     //    __        ______
44     //    /|     __|__A__|___
45     //   /    __|__B__|__D__|___
46     //  y    |__C__|__E__|__F__|
47     // 
48     //   x -->
49     // 
50     // 
51     
52     /////////////////////////////////////////////
53     // Address properties
54     mapping(address => uint256) public addressesToTotalWeiPlaced;
55     mapping(address => uint256) public addressBalances;
56     
57     ////////////////////////////////////////////
58     // Game Constructor
59     function PyramidGame() public
60     {
61         administrator = msg.sender;
62         adminFeeDivisor = 200; // Default fee is 0.5%
63         
64         // The administrator gets a few free chat messages :-)
65         addressesToChatMessagesLeft[administrator] += 5;
66         
67         // Set the first block in the middle of the bottom row
68         coordinatesToAddresses[uint32(1 << 15) << 16] = msg.sender;
69         allBlockCoordinates.push(uint32(1 << 15) << 16);
70     }
71     
72     ////////////////////////////////////////////
73     // Pyramid grid reading functions
74     function getBetAmountAtLayer(uint16 y) public pure returns (uint256)
75     {
76         // The minimum bet doubles every time you go up 1 layer
77         return BOTTOM_LAYER_BET_AMOUNT * (uint256(1) << y);
78     }
79     
80     function isThereABlockAtCoordinates(uint16 x, uint16 y) public view returns (bool)
81     {
82         return coordinatesToAddresses[(uint32(x) << 16) | uint16(y)] != 0;
83     }
84     
85     function getTotalAmountOfBlocks() public view returns (uint256)
86     {
87         return allBlockCoordinates.length;
88     }
89     
90     ////////////////////////////////////////////
91     // Pyramid grid writing functions
92     function placeBlock(uint16 x, uint16 y) external payable
93     {
94         // You may only place a block on an empty spot
95         require(!isThereABlockAtCoordinates(x, y));
96         
97         // Add the transaction amount to the person's balance
98         addressBalances[msg.sender] += msg.value;
99         
100         // Calculate the required bet amount at the specified layer
101         uint256 betAmount = getBetAmountAtLayer(y);
102 
103         // If the block is at the lowest layer...
104         if (y == 0)
105         {
106             // There must be a block to the left or to the right of it
107             require(isThereABlockAtCoordinates(x-1, y) ||
108                     isThereABlockAtCoordinates(x+1, y));
109         }
110         
111         // If the block is NOT at the lowest layer...
112         else
113         {
114             // There must be two existing blocks below it:
115             require(isThereABlockAtCoordinates(x  , y-1) &&
116                     isThereABlockAtCoordinates(x+1, y-1));
117         }
118         
119         // Subtract the bet amount from the person's balance
120         addressBalances[msg.sender] -= betAmount;
121         
122         // Place the block
123         coordinatesToAddresses[(uint32(x) << 16) | y] = msg.sender;
124         allBlockCoordinates.push((uint32(x) << 16) | y);
125         
126         // If the block is at the lowest layer...
127         if (y == 0)
128         {
129             // The bet goes to the administrator
130             addressBalances[administrator] += betAmount;
131         }
132         
133         // If the block is NOT at the lowest layer...
134         else
135         {
136             // Calculate the administrator fee
137             uint256 adminFee = betAmount / adminFeeDivisor;
138             
139             // Calculate the bet amount minus the admin fee
140             uint256 betAmountMinusAdminFee = betAmount - adminFee;
141             
142             // Add the money to the balances of the people below
143             addressBalances[coordinatesToAddresses[(uint32(x  ) << 16) | (y-1)]] += betAmountMinusAdminFee / 2;
144             addressBalances[coordinatesToAddresses[(uint32(x+1) << 16) | (y-1)]] += betAmountMinusAdminFee / 2;
145             
146             // Give the admin fee to the admin
147             addressBalances[administrator] += adminFee;
148         }
149         
150         // The new sender's balance must not have underflowed
151         // (this verifies that the sender has enough balance to place the block)
152         require(addressBalances[msg.sender] < (1 << 255));
153         
154         // Give the sender their chat message rights
155         addressesToChatMessagesLeft[msg.sender] += uint32(1) << y;
156         
157         // Register the sender's total bets placed
158         addressesToTotalWeiPlaced[msg.sender] += betAmount;
159     }
160     
161     ////////////////////////////////////////////
162     // Withdrawing balance
163     function withdrawBalance(uint256 amountToWithdraw) external
164     {
165         require(amountToWithdraw != 0);
166         
167         // The user must have enough balance to withdraw
168         require(addressBalances[msg.sender] >= amountToWithdraw);
169         
170         // Subtract the withdrawn amount from the user's balance
171         addressBalances[msg.sender] -= amountToWithdraw;
172         
173         // Transfer the amount to the user's address
174         // If the transfer() call fails an exception will be thrown,
175         // and therefore the user's balance will be automatically restored
176         msg.sender.transfer(amountToWithdraw);
177     }
178     
179     /////////////////////////////////////////////
180     // Chatbox data
181     struct ChatMessage
182     {
183         address person;
184         string message;
185     }
186     mapping(bytes32 => address) public usernamesToAddresses;
187     mapping(address => bytes32) public addressesToUsernames;
188     mapping(address => uint32) public addressesToChatMessagesLeft;
189     ChatMessage[] public chatMessages;
190     mapping(uint256 => bool) public censoredChatMessages;
191     
192     /////////////////////////////////////////////
193     // Chatbox functions
194     function registerUsername(bytes32 username) external
195     {
196         // The username must not already be token
197         require(usernamesToAddresses[username] == 0);
198         
199         // The address must not already have a username
200         require(addressesToUsernames[msg.sender] == 0);
201         
202         // Register the new username & address combination
203         usernamesToAddresses[username] = msg.sender;
204         addressesToUsernames[msg.sender] = username;
205     }
206     
207     function sendChatMessage(string message) external
208     {
209         // The sender must have at least 1 chat message allowance
210         require(addressesToChatMessagesLeft[msg.sender] >= 1);
211         
212         // Deduct 1 chat message allowence from the sender
213         addressesToChatMessagesLeft[msg.sender]--;
214         
215         // Add the chat message
216         chatMessages.push(ChatMessage(msg.sender, message));
217     }
218     
219     function getTotalAmountOfChatMessages() public view returns (uint256)
220     {
221         return chatMessages.length;
222     }
223     
224     function getChatMessageAtIndex(uint256 index) public view returns (address, bytes32, string)
225     {
226         address person = chatMessages[index].person;
227         bytes32 username = addressesToUsernames[person];
228         return (person, username, chatMessages[index].message);
229     }
230     
231     // In case of chat messages with extremely rude or inappropriate
232     // content, the administrator can censor a chat message.
233     function censorChatMessage(uint256 chatMessageIndex) public
234     {
235         require(msg.sender == administrator);
236         censoredChatMessages[chatMessageIndex] = true;
237     }
238     
239     /////////////////////////////////////////////
240     // Game ownership functions
241     function transferOwnership(address newAdministrator) external
242     {
243         require(msg.sender == administrator);
244         administrator = newAdministrator;
245     }
246     
247     function setFeeDivisor(uint256 newFeeDivisor) external
248     {
249         require(msg.sender == administrator);
250         require(newFeeDivisor >= 20); // The fee may never exceed 5%
251         adminFeeDivisor = newFeeDivisor;
252     }
253 }