1 // LooneyLottery that pays out the full pool once a day
2 //
3 // git: https://github.com/thelooneyfarm/contracts/tree/master/src/lottery
4 // url: http://the.looney.farm/game/lottery
5 contract LooneyLottery {
6   // modifier for the owner protected functions
7   modifier owneronly {
8     // yeap, you need to own this contract to action it
9     if (msg.sender != owner) {
10       throw;
11     }
12 
13     // function execution inserted here
14     _
15   }
16 
17   // constants for the Lehmer RNG
18   uint constant private LEHMER_MOD = 4294967291;
19   uint constant private LEHMER_MUL = 279470273;
20   uint constant private LEHMER_SDA = 1299709;
21   uint constant private LEHMER_SDB = 7919;
22 
23   // various game-related constants, also available in the interface
24   uint constant public CONFIG_DURATION = 24 hours;
25   uint constant public CONFIG_MIN_PLAYERS  = 5;
26   uint constant public CONFIG_MAX_PLAYERS  = 222;
27   uint constant public CONFIG_MAX_TICKETS = 100;
28   uint constant public CONFIG_PRICE = 10 finney;
29   uint constant public CONFIG_FEES = 50 szabo;
30   uint constant public CONFIG_RETURN = CONFIG_PRICE - CONFIG_FEES;
31   uint constant public CONFIG_MIN_VALUE = CONFIG_PRICE;
32   uint constant public CONFIG_MAX_VALUE = CONFIG_PRICE * CONFIG_MAX_TICKETS;
33 
34   // our owner, stored for owner-related functions
35   address private owner = msg.sender;
36 
37   // basic initialisation for the RNG
38   uint private random = uint(sha3(block.coinbase, block.blockhash(block.number - 1), now));
39   uint private seeda = LEHMER_SDA;
40   uint private seedb = LEHMER_SDB;
41 
42   // we allow 222 * 100 max tickets, allocate a bit more and store the mapping of entry => address
43   uint8[22500] private tickets;
44   mapping (uint => address) private players;
45 
46   // public game-related values
47   uint public round = 1;
48   uint public numplayers = 0;
49   uint public numtickets = 0;
50   uint public start = now;
51   uint public end = start + CONFIG_DURATION;
52 
53   // lifetime stats
54   uint public txs = 0;
55   uint public tktotal = 0;
56   uint public turnover = 0;
57 
58   // nothing much to do in the constructor, we have the owner set & init done
59   function LooneyLottery() {
60   }
61 
62   // owner withdrawal of fees
63   function ownerWithdraw() owneronly public {
64     // calculate the fees collected previously (excluding current round)
65     uint fees = this.balance - (numtickets * CONFIG_PRICE);
66 
67     // return it if we have someting
68     if (fees > 0) {
69       owner.call.value(fees)();
70     }
71   }
72 
73   // calculate the next random number with a two-phase Lehmer
74   function randomize() private {
75     // calculate the next seed for the first phase
76     seeda = (seeda * LEHMER_MUL) % LEHMER_MOD;
77 
78     // adjust the random accordingly, getting extra info from the blockchain together with the seeds
79     random ^= uint(sha3(block.coinbase, block.blockhash(block.number - 1), seeda, seedb));
80 
81     // adjust the second phase seed for the next iteration
82     seedb = (seedb * LEHMER_MUL) % LEHMER_MOD;
83   }
84 
85   // pick a random winner when the time is right
86   function pickWinner() private {
87     // do we have >222 players or >= 5 tickets and an expired timer
88     if ((numplayers >= CONFIG_MAX_PLAYERS ) || ((numplayers >= CONFIG_MIN_PLAYERS ) && (now > end))) {
89       // get the winner based on the number of tickets (each player has multiple tickets)
90       uint winidx = tickets[random % numtickets];
91       uint output = numtickets * CONFIG_RETURN;
92 
93       // send the winnings to the winner and let the world know
94       players[winidx].call.value(output)();
95       notifyWinner(players[winidx], output);
96 
97       // reset the round, and start a new one
98       numplayers = 0;
99       numtickets = 0;
100       start = now;
101       end = start + CONFIG_DURATION;
102       round++;
103     }
104   }
105 
106   // allocate tickets to the entry based on the value of the transaction
107   function allocateTickets(uint number) private {
108     // the last index of the ticket we will be adding to the pool
109     uint ticketmax = numtickets + number;
110 
111     // loop through and allocate a ticket based on the number bought
112     for (uint idx = numtickets; idx < ticketmax; idx++) {
113       tickets[idx] = uint8(numplayers);
114     }
115 
116     // our new value of total tickets (for this round) is the same as max, store it
117     numtickets = ticketmax;
118 
119     // store the actual player info so we can reference it from the tickets
120     players[numplayers] = msg.sender;
121     numplayers++;
122 
123     // let the world know that we have yet another player
124     notifyPlayer(number);
125   }
126 
127   // we only have a default function, send an amount and it gets allocated, no ABI needed
128   function() public {
129     // oops, we need at least 10 finney to play :(
130     if (msg.value < CONFIG_MIN_VALUE) {
131       throw;
132     }
133 
134     // adjust the random value based on the pseudo rndom inputs
135     randomize();
136 
137     // pick a winner at the end of a round
138     pickWinner();
139 
140     // here we store the number of tickets in this transaction
141     uint number = 0;
142 
143     // get either a max number based on the over-the-top entry or calculate based on inputs
144     if (msg.value >= CONFIG_MAX_VALUE) {
145       number = CONFIG_MAX_TICKETS;
146     } else {
147       number = msg.value / CONFIG_PRICE;
148     }
149 
150     // overflow is the value to be returned, >max or not a multiple of min
151     uint input = number * CONFIG_PRICE;
152     uint overflow = msg.value - input;
153 
154     // store the actual turnover, transaction increment and total tickets
155     turnover += input;
156     tktotal += number;
157     txs += 1;
158 
159     // allocate the actual tickets now
160     allocateTickets(number);
161 
162     // send back the overflow where applicable
163     if (overflow > 0) {
164       msg.sender.call.value(overflow)();
165     }
166   }
167 
168   // log events
169   event Player(address addr, uint32 at, uint32 round, uint32 tickets, uint32 numtickets, uint tktotal, uint turnover);
170   event Winner(address addr, uint32 at, uint32 round, uint32 numtickets, uint output);
171 
172   // notify that a new player has entered the fray
173   function notifyPlayer(uint number) private {
174     Player(msg.sender, uint32(now), uint32(round), uint32(number), uint32(numtickets), tktotal, turnover);
175   }
176 
177   // create the Winner event and send it
178   function notifyWinner(address addr, uint output) private {
179     Winner(addr, uint32(now), uint32(round), uint32(numtickets), output);
180   }
181 }