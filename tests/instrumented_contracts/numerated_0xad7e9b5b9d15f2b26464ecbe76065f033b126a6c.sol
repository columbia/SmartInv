1 pragma solidity ^0.4.18;
2 
3 contract Random {
4 
5     uint public ticketsNum = 0;
6     
7     mapping(uint => uint) internal tickets;  // tickets for the current draw
8     mapping(uint => bool) internal payed_back; // ticket payment refunding identifier
9     
10     address[] public addr; // addresses of all the draw participants
11     
12     uint32 public random_num = 0; // draw serial number
13  
14     uint public liveBlocksNumber = 5760; // amount of blocks untill the lottery ending
15     uint public startBlockNumber = 0; // initial block of the current lottery
16     uint public endBlockNumber = 0; // final block of the current lottery
17 
18     uint public constant onePotWei = 10000000000000000; // 1 ticket cost is 0.01 ETH
19 
20     address public inv_contract = 0x5192c55B1064D920C15dB125eF2E69a17558E65a; // investing contract
21     address public rtm_contract = 0x7E08c0468CBe9F48d8A4D246095dEb8bC1EB2e7e; // team contract
22     address public mrk_contract = 0xc01c08B2b451328947bFb7Ba5ffA3af96Cfc3430; // marketing contract
23     
24     address manager; // lottery manager address
25     
26     uint public winners_count = 0; // amount of winners in the current draw
27     uint last_winner = 0; // amount of winners already received rewards
28     uint public others_prize = 0; // prize fund less jack pots
29     
30     uint public fee_balance = 0; // current balance available for commiting payment to investing, team and marketing contracts
31 
32     
33     // Events
34     // This generates a publics event on the blockchain that will notify clients
35     
36     event Buy(address indexed sender, uint eth); // tickets purchase
37     event Withdraw(address indexed sender, address to, uint eth); // reward accruing
38     event Transfer(address indexed from, address indexed to, uint value); // event: sending ticket to another address
39     event TransferError(address indexed to, uint value); // event (error): sending ETH from the contract was failed
40     
41 
42     // methods with following modifier can only be called by the manager
43     modifier onlyManager() {
44         require(msg.sender == manager);
45         _;
46     }
47     
48 
49     // constructor
50     function Random() public {
51         manager = msg.sender;
52         startBlockNumber = block.number - 1;
53         endBlockNumber = startBlockNumber + liveBlocksNumber;
54     }
55 
56 
57     /// function for straight tickets purchase (sending ETH to the contract address)
58     function() public payable {
59         require(block.number < endBlockNumber || msg.value < 1000000000000000000);
60         if (msg.value > 0 && last_winner == 0) {
61             uint val =  msg.value / onePotWei;
62             uint i = 0;
63             uint ix = checkAddress(msg.sender);
64             for(i; i < val; i++) { tickets[ticketsNum+i] = ix; }
65             ticketsNum += i;
66             Buy(msg.sender, msg.value);
67         }
68         if (block.number >= endBlockNumber) { 
69             EndLottery(); 
70         }
71     }
72 
73 
74     /// function for ticket sending from owner's address to designated address
75     function transfer(address _to, uint _ticketNum) public {
76         if (msg.sender == getAddress(tickets[_ticketNum]) && _to != address(0)) {
77             uint ix = checkAddress(_to);
78             tickets[_ticketNum] = ix;
79             Transfer(msg.sender, _to, _ticketNum);
80         }
81     }
82 
83 
84     /// manager's opportunity to write off ETH from the contract, in a case of unforseen contract blocking (possible in only case of more than 24 hours from the moment of lottery ending had passed and a new one has not started)
85     function manager_withdraw() onlyManager public {
86         require(block.number >= endBlockNumber + liveBlocksNumber);
87         msg.sender.transfer(this.balance);
88     }
89     
90     /// lottery ending
91     function EndLottery() public payable returns (bool success) {
92         require(block.number >= endBlockNumber); 
93         uint tn = ticketsNum;
94         if(tn < 3) { 
95             tn = 0;
96             if(msg.value > 0) { msg.sender.transfer(msg.value); }
97             startNewDraw(msg.value);
98             return false;
99         }
100         uint pf = prizeFund();
101         uint jp1 = percent(pf, 10);
102         uint jp2 = percent(pf, 4);
103         uint jp3 = percent(pf, 1);
104         uint lastbet_prize = onePotWei*10;
105         
106         if(last_winner == 0) {
107             
108             winners_count = percent(tn, 4) + 3; 
109             
110             uint prizes = jp1 + jp2 + jp3 + lastbet_prize*2;
111             uint full_prizes = jp1 + jp2 + jp3 + (lastbet_prize * ( (winners_count+1)/10 ) );
112 
113             if(winners_count < 10) {
114                 if(prizes > pf) {
115                     others_prize = 0;
116                 } else {
117                     others_prize = pf - prizes;    
118                 }
119             } else {
120                 if(full_prizes > pf) {
121                     others_prize = 0;
122                 } else {
123                     others_prize = pf - full_prizes;    
124                 }
125             }
126 
127             sendEth(getAddress(tickets[getWinningNumber(1)]), jp1);
128             sendEth(getAddress(tickets[getWinningNumber(2)]), jp2);
129             sendEth(getAddress(tickets[getWinningNumber(3)]), jp3);
130             last_winner += 1;
131             
132             sendEth(msg.sender, lastbet_prize + msg.value); 
133             return true;
134         } 
135         
136         if(last_winner < winners_count + 1 && others_prize > 0) {
137             
138             uint val = others_prize / winners_count;
139             uint i;
140             uint8 cnt = 0;
141             for(i = last_winner; i < winners_count + 1; i++) {
142                 sendEth(getAddress(tickets[getWinningNumber(i+3)]), val);
143                 cnt++;
144                 if(cnt > 9) {
145                     last_winner = i;
146                     return true;
147                 }
148             }
149             last_winner = i;
150             sendEth(msg.sender, lastbet_prize + msg.value);
151             return true;
152             
153         } else {
154 
155             startNewDraw(lastbet_prize + msg.value);   
156         }
157         
158         sendEth(msg.sender, lastbet_prize + msg.value);
159         return true;
160     }
161     
162     /// new draw start
163     function startNewDraw(uint _msg_value) internal {
164         ticketsNum = 0;
165         startBlockNumber = block.number - 1;
166         endBlockNumber = startBlockNumber + liveBlocksNumber;
167         random_num += 1;
168         winners_count = 0;
169         last_winner = 0;
170         fee_balance += (this.balance - _msg_value);
171     }
172     
173     /// sending rewards to the investing, team and marketing contracts 
174     function payfee() public {
175         require(fee_balance > 0);
176         uint val = fee_balance;
177         inv_contract.transfer( percent(val, 20) );
178         rtm_contract.transfer( percent(val, 49) );
179         mrk_contract.transfer( percent(val, 30) );
180         fee_balance = 0;
181     }
182     
183     /// function for sending ETH with balance check (does not interrupt the program if balance is not sufficient)
184     function sendEth(address _to, uint _val) internal returns(bool) {
185         if(this.balance < _val) {
186             TransferError(_to, _val);
187             return false;
188         }
189         _to.transfer(_val);
190         Withdraw(address(this), _to, _val);
191         return true;
192     }
193     
194     
195     /// get winning ticket number basing on block hasg (block number is being calculated basing on specified displacement)
196     function getWinningNumber(uint _blockshift) internal constant returns (uint) {
197         return uint(block.blockhash(block.number - _blockshift)) % ticketsNum + 1;
198     }
199     
200 
201     /// current amount of jack pot 1
202     function jackPotA() public view returns (uint) {
203         return percent(prizeFund(), 10);
204     }
205     
206     /// current amount of jack pot 2
207     function jackPotB() public view returns (uint) {
208         return percent(prizeFund(), 4);
209     }
210     
211     /// current amount of jack pot 3
212     function jackPotC() public view returns (uint) {
213         return percent(prizeFund(), 1);
214     }
215 
216     /// current amount of prize fund
217     function prizeFund() public view returns (uint) {
218         return ( (ticketsNum * onePotWei) / 100 ) * 90;
219     }
220 
221     /// function for calculating definite percent of a number
222     function percent(uint _val, uint8 _percent) public pure returns (uint) {
223         return ( _val / 100 ) * _percent;
224     }
225 
226 
227     /// returns owner address using ticket number
228     function getTicketOwner(uint _num) public view returns (address) {
229         if(ticketsNum == 0) {
230             return 0;
231         }
232         return getAddress(tickets[_num]);
233     }
234 
235     /// returns amount of tickets for the current draw in the possession of specified address
236     function getTicketsCount(address _addr) public view returns (uint) {
237         if(ticketsNum == 0) {
238             return 0;
239         }
240         uint num = 0;
241         for(uint i = 0; i < ticketsNum; i++) {
242             if(tickets[i] == readAddress(_addr)) {
243                 num++;
244             }
245         }
246         return num;
247     }
248     
249     /// returns tickets numbers for the current draw in the possession of specified address
250     function getTicketsAtAdress(address _address) public view returns(uint[]) {
251         uint[] memory result = new uint[](getTicketsCount(_address));
252         uint num = 0;
253         for(uint i = 0; i < ticketsNum; i++) {
254             if(getAddress(tickets[i]) == _address) {
255                 result[num] = i;
256                 num++;
257             }
258         }
259         return result;
260     }
261 
262 
263     /// returns amount of paid rewards for the current draw
264     function getLastWinner() public view returns(uint) {
265         return last_winner+1;
266     }
267 
268 
269     /// investing contract address change
270     function setInvContract(address _addr) onlyManager public {
271         inv_contract = _addr;
272     }
273 
274     /// team contract address change
275     function setRtmContract(address _addr) onlyManager public {
276         rtm_contract = _addr;
277     }
278 
279     /// marketing contract address change
280     function setMrkContract(address _addr) onlyManager public {
281         mrk_contract = _addr;
282     }
283 
284 
285     /// returns number of participant (in the list of participants) by belonging address and adding to the list, if not found
286     function checkAddress(address _addr) public returns (uint addr_num)
287     {
288         for(uint i=0; i<addr.length; i++) {
289             if(addr[i] == _addr) {
290                 return i;
291             }
292         }
293         return addr.push(_addr) - 1;
294     }
295     
296     /// returns participants number (in the list of participants) be belonging address (read only)
297     function readAddress(address _addr) public view returns (uint addr_num)
298     {
299         for(uint i=0; i<addr.length; i++) {
300             if(addr[i] == _addr) {
301                 return i;
302             }
303         }
304         return 0;
305     }
306 
307     /// returns address by the number in the list of participants
308     function getAddress(uint _index) public view returns (address) {
309         return addr[_index];
310     }
311 
312 
313     /// method for direct contract replenishment with ETH
314     function deposit() public payable {
315         require(msg.value > 0);
316     }
317     
318 
319 }