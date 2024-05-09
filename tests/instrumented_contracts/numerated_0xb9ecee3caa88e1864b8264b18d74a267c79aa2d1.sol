1 contract EthereumRouletteInterface {
2 
3   // The owner is responsible for committing and revealing spin results.
4   address public owner;
5   // Funds that are kept in reserve in order to pay off the winners in all revealed spins.
6   // This number increases when new bets are made and decreases when winners collect their
7   // winnings. When all winnings have been collected, this should be 0.
8   uint public locked_funds_for_revealed_spins;
9   // How much time (in seconds) the owner has to reveal the result to a spin after the
10   // first bet has been made.
11   uint public owner_time_limit;
12   // Used to calculate the maximum bet a player can make.
13   uint public fraction;
14   // Maximum bet that a player can make on one of the numbers this spin.
15   uint public max_bet_this_spin;
16   // Contains all spins that happened so far. All spins, except that last two, are
17   // settled. A spin is settled if and only if the spin_result and nonce are revealed by
18   // the owner or owner_took_too_long flag is true. If a spin is settled, then players can
19   // collect their winnings from that spin. It's possible that the last two spins are also
20   // settled if the owner took too long.
21   Spin[] public spins;
22 
23   struct Spin {
24     // If owner takes too long (does not respond in time and someone calls the
25     // player_declare_taking_too_long function), owner_took_too_long will be set to true
26     // and all players will be paid out. This represents the total sum that will be paid
27     // out in that case.
28     uint total_payout;
29     // The owner privately computes the sha3 of spin_result + nonce.
30     bytes32 commit_hash;
31     // Should be in [0, 37] range. 0 and 37 represent 0 and 00 on the roulette wheel.
32     uint8 spin_result;
33     // Some random value that the owner generates to make it impossible for someone to
34     // guess the spin_result based on the commit_hash.
35     bytes32 nonce;
36     // Total amount that was bet on a particular number. Used to verify that the amount
37     // bet on a number does not exceed max_bet_this_spin.
38     mapping(uint8 => uint) total_bet_on_number;
39     // Maps player address to a bet on a particular spin_result.
40     mapping(address => mapping(uint8 => Bet)) bets;
41     // This can be set to true if player_declare_taking_too_long is called if the owner is
42     // taking too long. In that case all bets in this round will be winners.
43     bool owner_took_too_long;
44     // Time (in seconds) by which the spin result should be revealed by the owner.
45     uint time_of_latest_reveal;
46   }
47 
48   struct Bet {
49     uint amount;
50     // True if this bet was already paid.
51     bool already_paid;
52   }
53 
54   // Allows only the owner to call certain functions.
55   modifier onlyOwner {}
56   // Verifies no Ether is sent when calling a function.
57   modifier noEther {}
58   // Verifies that more than 0 Ether is sent when calling a function.
59   modifier etherRequired {}
60 
61   // Player makes a bet on a particular spin_result.
62   function player_make_bet(uint8 spin_result) etherRequired;
63 
64   // Player calls this function to collect all winnings from a particular spin.
65   function player_collect_winnings(uint spin_num) noEther;
66 
67   // If the owner is taking too long to reveal the spin result, player can call this
68   // function. If enough time passed, all bets in the last two spins (which are
69   // unrevealed) will become winners. Player can then call player_collect_winnings.
70   function player_declare_taking_too_long() noEther;
71 
72   // Owner reveals the spin_result and nonce for the first unrevealed spin (which is
73   // second last in the spins array). Owner also also adds a new unrevealed spin to the
74   // spins array. All new player bets will be on this new spin after this function is
75   // called.
76   //
77   // The reason why we always have two unrevealed spins (instead of 1) is because of this
78   // function. If there was only 1 unrevealed spin, when the owner tried revealing it,
79   // an attacker would be able to see the spin result in the transaction that the owner
80   // submits and quickly try to place a bet on the spin_result to try to get his
81   // trasaction to be processed before the owner.
82   function owner_reveal_and_commit(uint8 spin_result, bytes32 nonce, bytes32 commit_hash) onlyOwner noEther;
83 
84   // Set a new time limit for the owner between commit and reveal.
85   function owner_set_time_limit(uint new_time_limit) onlyOwner noEther;
86 
87   // Allows the owner to deposit additional funds into the contract.
88   function owner_deposit() onlyOwner etherRequired;
89 
90   // Allows the owner to withdraw the winnings. Makes sure that the owner does not
91   // withdraw any funds that should be paid out to the players.
92   function owner_withdraw(uint amount) onlyOwner noEther;
93 
94   // Updates the fraction (has an effect on how large the player bets can be).
95   function owner_set_fraction(uint _fraction) onlyOwner noEther;
96 
97   function owner_transfer_ownership(address new_owner) onlyOwner noEther;
98 
99   event MadeBet(uint amount, uint8 spin_result, address player_addr);
100   event Revealed(uint spin_number, uint8 spin_result);
101 }
102 
103 
104 contract EthereumRoulette is EthereumRouletteInterface {
105 
106   modifier onlyOwner {if (msg.sender != owner) throw; _}
107 
108   modifier noEther {if (msg.value > 0) throw; _}
109 
110   modifier etherRequired {if (msg.value == 0) throw; _}
111 
112   function EthereumRoulette() {
113     owner = msg.sender;
114     fraction = 800;
115     owner_time_limit = 7 days;
116     // The contract must always have 2 unrevealed spins. This is why we commit the first
117     // two spins in the constructor. This means that it's not possible to bet on spin #1.
118     bytes32 first_num_hash = 0x3c81cf7279de81901303687979a6b62fdf04ec93480108d2ef38090d6135ad9f;
119     bytes32 second_num_hash = 0xb1540f17822cbe4daef5f1d96662b2dc92c5f9a2411429faaf73555d3149b68e;
120     spins.length++;
121     spins[spins.length - 1].commit_hash = first_num_hash;
122     spins.length++;
123     spins[spins.length - 1].commit_hash = second_num_hash;
124     max_bet_this_spin = address(this).balance / fraction;
125   }
126 
127   function player_make_bet(uint8 spin_result) etherRequired {
128     Spin second_unrevealed_spin = spins[spins.length - 1];
129     if (second_unrevealed_spin.owner_took_too_long
130         || spin_result > 37
131         || msg.value + second_unrevealed_spin.total_bet_on_number[spin_result] > max_bet_this_spin
132         // verify it will be possible to pay the player in the worst case
133         || msg.value * 36 + reserved_funds() > address(this).balance) {
134       throw;
135     }
136     Bet b = second_unrevealed_spin.bets[msg.sender][spin_result];
137     b.amount += msg.value;
138     second_unrevealed_spin.total_bet_on_number[spin_result] += msg.value;
139     second_unrevealed_spin.total_payout += msg.value * 36;
140     if (second_unrevealed_spin.time_of_latest_reveal == 0) {
141       second_unrevealed_spin.time_of_latest_reveal = now + owner_time_limit;
142     }
143     MadeBet(msg.value, spin_result, msg.sender);
144   }
145 
146   function player_collect_winnings(uint spin_num) noEther {
147     Spin s = spins[spin_num];
148     if (spin_num >= spins.length - 2) {
149       throw;
150     }
151     if (s.owner_took_too_long) {
152       bool at_least_one_number_paid = false;
153       for (uint8 roulette_num = 0; roulette_num < 38; roulette_num++) {
154         Bet messed_up_bet = s.bets[msg.sender][roulette_num];
155         if (messed_up_bet.already_paid) {
156           throw;
157         }
158         if (messed_up_bet.amount > 0) {
159           msg.sender.send(messed_up_bet.amount * 36);
160           locked_funds_for_revealed_spins -= messed_up_bet.amount * 36;
161           messed_up_bet.already_paid = true;
162           at_least_one_number_paid = true;
163         }
164       }
165       if (!at_least_one_number_paid) {
166         // If at least one number does not get paid, we let the user know when they try to estimate gas.
167         throw;
168       }
169     } else {
170       Bet b = s.bets[msg.sender][s.spin_result];
171       if (b.already_paid || b.amount == 0) {
172         throw;
173       }
174       msg.sender.send(b.amount * 36);
175       locked_funds_for_revealed_spins -= b.amount * 36;
176       b.already_paid = true;
177     }
178   }
179 
180   function player_declare_taking_too_long() noEther {
181     Spin first_unrevealed_spin = spins[spins.length - 2];
182     bool first_spin_too_long = first_unrevealed_spin.time_of_latest_reveal != 0
183         && now > first_unrevealed_spin.time_of_latest_reveal;
184     Spin second_unrevealed_spin = spins[spins.length - 1];
185     bool second_spin_too_long = second_unrevealed_spin.time_of_latest_reveal != 0
186         && now > second_unrevealed_spin.time_of_latest_reveal;
187     if (!(first_spin_too_long || second_spin_too_long)) {
188       throw;
189     }
190     first_unrevealed_spin.owner_took_too_long = true;
191     second_unrevealed_spin.owner_took_too_long = true;
192     locked_funds_for_revealed_spins += (first_unrevealed_spin.total_payout + second_unrevealed_spin.total_payout);
193   }
194 
195   function () {
196     // Do not allow sending Ether without calling a function.
197     throw;
198   }
199 
200   function commit(bytes32 commit_hash) internal {
201     uint spin_num = spins.length++;
202     Spin second_unrevealed_spin = spins[spins.length - 1];
203     second_unrevealed_spin.commit_hash = commit_hash;
204     max_bet_this_spin = (address(this).balance - reserved_funds()) / fraction;
205   }
206 
207   function owner_reveal_and_commit(uint8 spin_result, bytes32 nonce, bytes32 commit_hash) onlyOwner noEther {
208     Spin first_unrevealed_spin = spins[spins.length - 2];
209     if (!first_unrevealed_spin.owner_took_too_long) {
210       if (sha3(spin_result, nonce) != first_unrevealed_spin.commit_hash || spin_result > 37) {
211         throw;
212       }
213       first_unrevealed_spin.spin_result = spin_result;
214       first_unrevealed_spin.nonce = nonce;
215       locked_funds_for_revealed_spins += first_unrevealed_spin.total_bet_on_number[spin_result] * 36;
216       Revealed(spins.length - 2, spin_result);
217     }
218     // If owner took too long, the spin result and nonce can be ignored because all payers
219     // won.
220     commit(commit_hash);
221   }
222 
223   function owner_set_time_limit(uint new_time_limit) onlyOwner noEther {
224     if (new_time_limit > 2 weeks) {
225       // We don't want the owner to be able to set a time limit of something like 1000
226       // years.
227       throw;
228     }
229     owner_time_limit = new_time_limit;
230   }
231 
232   function owner_deposit() onlyOwner etherRequired {}
233 
234   function owner_withdraw(uint amount) onlyOwner noEther {
235     if (amount > address(this).balance - reserved_funds()) {
236       throw;
237     }
238     owner.send(amount);
239   }
240 
241   function owner_set_fraction(uint _fraction) onlyOwner noEther {
242     if (_fraction == 0) {
243       throw;
244     }
245     fraction = _fraction;
246   }
247 
248   function owner_transfer_ownership(address new_owner) onlyOwner noEther {
249     owner = new_owner;
250   }
251 
252   function seconds_left() constant returns(int) {
253     // Seconds left until player_declare_taking_too_long can be called.
254     Spin s = spins[spins.length - 1];
255     if (s.time_of_latest_reveal == 0) {
256       return -1;
257     }
258     if (now > s.time_of_latest_reveal) {
259       return 0;
260     }
261     return int(s.time_of_latest_reveal - now);
262   }
263 
264   function reserved_funds() constant returns (uint) {
265     // These funds cannot be withdrawn by the owner. This is the amount contract will have
266     // to keep in reserve to be able to pay all players in the worst case.
267     uint total = locked_funds_for_revealed_spins;
268     Spin first_unrevealed_spin = spins[spins.length - 2];
269     if (!first_unrevealed_spin.owner_took_too_long) {
270       total += first_unrevealed_spin.total_payout;
271     }
272     Spin second_unrevealed_spin = spins[spins.length - 1];
273     if (!second_unrevealed_spin.owner_took_too_long) {
274       total += second_unrevealed_spin.total_payout;
275     }
276     return total;
277   }
278 
279   function get_hash(uint8 number, bytes32 nonce) constant returns (bytes32) {
280     return sha3(number, nonce);
281   }
282 
283   function bet_this_spin() constant returns (bool) {
284     // Returns true if there was a bet placed in the latest spin.
285     Spin s = spins[spins.length - 1];
286     return s.time_of_latest_reveal != 0;
287   }
288 
289   function check_bet(uint spin_num, address player_addr, uint8 spin_result) constant returns (uint) {
290     // Returns the amount of ether a player player bet on a spin result in a given spin
291     // number.
292     Spin s = spins[spin_num];
293     Bet b = s.bets[player_addr][spin_result];
294     return b.amount;
295   }
296 
297   function current_spin_number() constant returns (uint) {
298     // Returns the number of the current spin.
299     return spins.length - 1;
300   }
301 }