1 pragma solidity ^0.4.25;
2 
3 contract P3Daily {
4     
5     using SafeMath for uint256;
6     
7     struct Round {
8         uint256 pot;
9         uint256 ticketsSold;
10         uint256 blockNumber;
11         uint256 startTime;
12         mapping(uint256 => address) tickets;
13         mapping(address => uint256) ticketsPerAddress;
14     }
15     
16     HourglassInterface constant p3dContract = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
17     address constant sacMasternode = address(0x4fac33dAbFd83d160717dFee4175d9cAaA249CA5);
18     address constant dev = address(0xF0EA6CE7d210Ee58e83a463Af13989B5c2DbE108);
19     
20     uint256 constant public PRICE_PER_TICKET = 0.01 ether;
21     uint256 constant public ROUND_LENGTH = 24 hours;
22     
23     mapping(uint256 => Round) public rounds;
24     mapping(address => uint256) private vault;
25     
26     uint256 public currentRoundNumber;
27     
28     event TicketsPurchased(address indexed player, uint256 indexed amount);
29     event LotteryWinner(address indexed winner, uint256 indexed winnings, uint256 indexed ticket);
30     event WithdrawVault(address indexed player, uint256 indexed amaount);
31     event Validator(address indexed validator, uint256 indexed reward);
32     
33     modifier isValidPurchase(uint256 _howMany)
34     {
35         require(_howMany > 0);
36         require(msg.value == _howMany.mul(PRICE_PER_TICKET));
37         _;
38     }
39     
40     modifier canPayFromVault(uint256 _howMany)
41     {
42         require(_howMany > 0);
43         require(vault[msg.sender] >= _howMany.mul(PRICE_PER_TICKET));
44         _;
45     }
46     
47     modifier positiveVaultBalance()
48     {
49         require(vault[msg.sender] > 0);
50         _;
51     }
52     
53     constructor()
54         public
55     {
56         currentRoundNumber = 0;
57         rounds[currentRoundNumber] = Round(0, 0, 0, now);
58     }
59     
60     function() external payable {}
61        
62     function isRoundOver()
63         public
64         view
65         returns(bool)
66     {
67         return now >= rounds[currentRoundNumber].startTime.add(ROUND_LENGTH);
68     }
69     
70     function potentialWinner()
71         external
72         view
73         returns(address)
74     {
75         if(isRoundOver() &&
76         rounds[currentRoundNumber].blockNumber != 0 &&
77         block.number - 256 <= rounds[currentRoundNumber].blockNumber &&
78         rounds[currentRoundNumber].blockNumber != block.number) {
79             uint256 potentialwinningTicket = uint256(blockhash(rounds[currentRoundNumber].blockNumber)) % rounds[currentRoundNumber].ticketsSold;
80             return rounds[currentRoundNumber].tickets[potentialwinningTicket];
81         }
82         
83         return address(0);
84     }
85     
86     function blocksUntilNewPotentialWinner()
87         external
88         view
89         returns (uint256)
90     {
91         if(isRoundOver() &&
92         rounds[currentRoundNumber].blockNumber != 0 &&
93         block.number - 256 <= rounds[currentRoundNumber].blockNumber &&
94         rounds[currentRoundNumber].blockNumber != block.number) {
95            return 256 - (block.number - rounds[currentRoundNumber].blockNumber);
96         }
97         
98         return 0;
99     }
100     
101     function getTicketOwner(uint256 _number)
102         external
103         view
104         returns(address)
105     {
106         return rounds[currentRoundNumber].tickets[_number];
107     }
108     
109      function ticketsPurchased()
110         external
111         view
112         returns(uint256)
113     {
114         return rounds[currentRoundNumber].ticketsSold;
115     }
116     
117     function timeLeft()
118         external
119         view
120         returns(uint256)
121     {
122         if(isRoundOver()) {
123             return 0;
124         }
125         
126         return ROUND_LENGTH.sub(now.sub(rounds[currentRoundNumber].startTime));
127     }
128     
129     function jackpotSize()
130         external
131         view
132         returns(uint256)
133     {
134         return rounds[currentRoundNumber].pot.add(p3dContract.myDividends(true)).mul(97) / 100;
135     }
136     
137     function validatorReward()
138         external
139         view
140         returns(uint256)
141     {
142         return rounds[currentRoundNumber].pot.add(p3dContract.myDividends(true)) / 100;
143     }
144     
145     function myVault()
146         external
147         view
148         returns(uint256)
149     {
150         return vault[msg.sender];
151     }
152     
153     function myTickets()
154         external
155         view
156         returns(uint256)
157     {
158         return rounds[currentRoundNumber].ticketsPerAddress[msg.sender];
159     }
160     
161     function purchaseTicket(uint256 _howMany)
162         external
163         payable
164         isValidPurchase(_howMany)
165     {
166         if(!isRoundOver() || onRoundEnd()) {
167             acceptPurchase(_howMany, msg.value);
168         } else {
169             vault[msg.sender] = vault[msg.sender].add(msg.value);
170         }
171     }
172     
173     function purchaseFromVault(uint256 _howMany)
174         external
175         canPayFromVault(_howMany)
176     {
177         if(!isRoundOver() || onRoundEnd()) {
178             uint256 value = _howMany.mul(PRICE_PER_TICKET);
179             vault[msg.sender] -= value;
180             acceptPurchase(_howMany, value);
181         }
182     }
183     
184     function validate()
185         external
186     {
187         require(isRoundOver());
188         
189         onRoundEnd();
190     }
191     
192     function withdrawFromVault()
193         external
194         positiveVaultBalance
195     {
196         uint256 amount = vault[msg.sender];
197         vault[msg.sender] = 0;
198         
199         emit WithdrawVault(msg.sender, amount);
200         
201         msg.sender.transfer(amount);
202     }
203     
204     function onRoundEnd()
205         private
206         returns(bool newRound)
207     {
208         //no tickets sold => create new round
209         if(rounds[currentRoundNumber].ticketsSold == 0) {
210             currentRoundNumber++;
211             rounds[currentRoundNumber] = Round(0, 0, 0, now);
212             return true;
213         }
214         
215         //blocknumber has not been chosen or is too old => set new one
216         if(rounds[currentRoundNumber].blockNumber == 0 || block.number - 256 > rounds[currentRoundNumber].blockNumber) {
217             rounds[currentRoundNumber].blockNumber = block.number;
218             return false;
219         }
220         
221         //can't determine hash of current block
222         if(block.number == rounds[currentRoundNumber].blockNumber) {return false;}
223         
224         //determine winner
225         uint256 winningTicket = uint256(blockhash(rounds[currentRoundNumber].blockNumber)) % rounds[currentRoundNumber].ticketsSold;
226         address winner = rounds[currentRoundNumber].tickets[winningTicket];
227         
228         uint256 totalWinnings = rounds[currentRoundNumber].pot;
229         
230         uint256 dividends = p3dContract.myDividends(true);
231         if(dividends > 0) {
232             p3dContract.withdraw();
233             totalWinnings = totalWinnings.add(dividends);
234         }
235         
236         //winner reward
237         uint256 winnings = totalWinnings.mul(97) / 100;
238         vault[winner] = vault[winner].add(winnings);
239         emit LotteryWinner(winner, winnings, winningTicket);
240         
241         //validator reward
242         vault[msg.sender] = vault[msg.sender].add(totalWinnings / 100);
243         emit Validator(msg.sender, totalWinnings / 100);
244         
245         //dev fee
246         vault[dev] = vault[dev].add(totalWinnings.mul(2) / 100);
247         
248         currentRoundNumber++;
249         rounds[currentRoundNumber] = Round(0, 0, 0, now);
250         return true;
251     }
252     
253     function acceptPurchase(uint256 _howMany, uint256 value)
254         private
255     {
256         uint256 ticketsSold = rounds[currentRoundNumber].ticketsSold;
257         uint256 boundary = _howMany.add(ticketsSold);
258         
259         for(uint256 i = ticketsSold; i < boundary; i++) {
260             rounds[currentRoundNumber].tickets[i] = msg.sender;
261         }
262         
263         rounds[currentRoundNumber].ticketsSold = boundary;
264         rounds[currentRoundNumber].pot = rounds[currentRoundNumber].pot.add(value.mul(60) / 100);
265         rounds[currentRoundNumber].ticketsPerAddress[msg.sender] = rounds[currentRoundNumber].ticketsPerAddress[msg.sender].add(_howMany);
266         
267         emit TicketsPurchased(msg.sender, _howMany);
268         
269         p3dContract.buy.value(value.mul(40) / 100)(sacMasternode);
270     }
271 }
272 
273 interface HourglassInterface {
274     function buy(address _playerAddress) payable external returns(uint256);
275     function withdraw() external;
276     function myDividends(bool _includeReferralBonus) external view returns(uint256);
277 }
278 
279 library SafeMath {
280 
281   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
282     if (a == 0) {
283       return 0;
284     }
285 
286     uint256 c = a * b;
287     require(c / a == b);
288 
289     return c;
290   }
291 
292   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
293     require(b <= a);
294     uint256 c = a - b;
295 
296     return c;
297   }
298 
299   function add(uint256 a, uint256 b) internal pure returns (uint256) {
300     uint256 c = a + b;
301     require(c >= a);
302 
303     return c;
304   }
305 }