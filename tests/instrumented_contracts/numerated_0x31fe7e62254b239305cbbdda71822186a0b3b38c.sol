1 pragma solidity ^0.4.19;
2 
3 /******************************************************************************
4 
5 ILOT - An Interest-paying ERC20 token and Ethereum lottery.
6 
7 Visit us at https://ILOT.io/
8 
9 ERC20 Compatible Token
10 Decimal places: 18
11 Symbol: ILOT
12 
13 *******************************************************************************
14 
15 Copyright (C) 2018 ILOT.io
16 
17 This program is free software: you can redistribute it and/or modify
18 it under the terms of the GNU General Public License as published by
19 the Free Software Foundation, either version 3 of the License, or
20 (at your option) any later version.
21 
22 This program is distributed in the hope that it will be useful,
23 but WITHOUT ANY WARRANTY; without even the implied warranty of
24 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
25 GNU General Public License for more details.
26 
27 You should have received a copy of the GNU General Public License
28 along with this program.  If not, see <http://www.gnu.org/licenses/>.
29 
30 -----
31 
32 If you use this code on your own contracts, please credit the website https://ILOT.io/ - Thank you!
33 
34 -----
35 
36 ////////////////
37 /B/S/B/J/M/A/F/
38 //////////////
39 ////PEACE////
40 ////////////
41 
42 */
43 
44 interface tokenRecipient { function receiveApproval(address _from, uint _value, address _token, bytes _extraData) public; }
45 
46 contract ILOTContract {
47 
48     string public name = "ILOT Interest-Paying Lottery Token";
49     string public symbol = "ILOT";
50     
51     /*
52         We've hardcoded our official website into the blockchain!
53         Please do not send ETH to scams/clones/copies. 
54         The website indicated below is the only official ILOT website.
55     */
56     string public site_url = "https://ILOT.io/";
57 
58     bytes32 private current_jackpot_hash = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
59     uint8 public decimals = 18;
60     uint public totalSupply = 0; // No pre-minted amount.
61     uint public interestRate = 15; // 1.5% fixed monthly interest = 15 / 1000
62     uint tokensPerEthereum = 147000; // 147k tokens per ETH
63     uint public jackpotDifficulty = 6;
64     address public owner;
65 
66     function ILOTContract() public {
67         owner = msg.sender;
68     }
69 
70     mapping (address => uint) public balanceOf;
71     mapping (address => mapping (address => uint)) public allowance;
72     mapping (address => uint) public depositTotal; // total ETH deposited per address
73     mapping (address => uint) public lastBlockInterestPaid;
74 
75     /*
76         Declare ILOT events.
77     */
78     event Transfer(address indexed from, address indexed to, uint bhtc_value);
79     event Burn(address indexed from, uint bhtc_value);
80     event GameResult(address player, uint zeroes);
81     event BonusPaid(address to, uint bhtc_value);
82     event InterestPaid(address to, uint bhtc_value);
83     event Jackpot(address winner, uint eth_amount);
84 
85     uint maintenanceDebt;
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     /*
93         Return an addresse's current unpaid interest amount in ILOT.
94     */
95     function getInterest(address _to) public view returns (uint interest) {
96 
97         if (lastBlockInterestPaid[_to] > 0) {
98             interest = ((block.number - lastBlockInterestPaid[_to]) * balanceOf[_to] * interestRate) / (86400000);
99         } else {
100             interest = 0;
101         }
102 
103         return interest;
104     }
105 
106     /*
107         Allows users to check their current deposit bonus amount.
108         Formula: 1% bonus over lifetime ETH deposit history
109         depositTotal is denominated in ETH
110     */
111     function getBonus(address _to) public view returns (uint interest) {
112         return ((depositTotal[_to] * tokensPerEthereum) / 100);
113     }
114 
115     function _transfer(address _from, address _to, uint _value) internal {
116         require(_to != 0x0);
117         /*
118             Owed interest is paid before transfers/withdrawals.
119             Users may be able to withdraw/transfer more than they publicly see.
120             Use getInterest(ETHEREUM_ADDRESS) to check how much interests
121             will be paid before transfers or future deposits.
122         */
123         payInterest(_from);
124         require(balanceOf[_from] >= _value);
125         require(balanceOf[_to] + _value > balanceOf[_to]);
126         uint previousBalances = balanceOf[_from] + balanceOf[_to];
127         balanceOf[_from] -= _value;
128         balanceOf[_to] += _value;
129         Transfer(_from, _to, _value);
130         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
131     }
132 
133     function transfer(address _to, uint _value) public {
134         _transfer(msg.sender, _to, _value);
135     }
136 
137     function setUrl(string u) public onlyOwner {
138         site_url = u;
139     }
140 
141     function getUrl() public view returns (string) {
142         return site_url;
143     }
144 
145     /*
146         Difficulty adjustment.
147     */
148     function setDifficulty(uint z) public onlyOwner {
149         jackpotDifficulty = z;
150     }
151 
152     /*
153         Get current difficulty.
154         Returns number of zeroes currently required.
155     */
156     function getDifficulty() public view returns (uint) {
157         return jackpotDifficulty;
158     }
159 
160     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
161         require(_value <= allowance[_from][msg.sender]);
162         allowance[_from][msg.sender] -= _value;
163         _transfer(_from, _to, _value);
164         return true;
165     }
166 
167     function approve(address _spender, uint _value) public
168     returns (bool success) {
169         allowance[msg.sender][_spender] = _value;
170         return true;
171     }
172 
173     function approveAndCall(address _spender, uint _value, bytes _extraData)
174     public
175     returns (bool success) {
176         tokenRecipient spender = tokenRecipient(_spender);
177         if (approve(_spender, _value)) {
178             spender.receiveApproval(msg.sender, _value, this, _extraData);
179             return true;
180         }
181     }
182 
183     function chown(address to) public onlyOwner { owner = to; }
184 
185     function burn(uint _value) public returns (bool success) {
186         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
187         balanceOf[msg.sender] -= _value;            // Subtract from the sender
188         totalSupply -= _value;                      // Updates totalSupply
189         Burn(msg.sender, _value);
190         return true;
191     }
192 
193     function burnFrom(address _from, uint _value) public returns (bool success) {
194         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
195         require(_value <= allowance[_from][msg.sender]);    // Check allowance
196         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
197         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
198         totalSupply -= _value;                              // Update totalSupply
199         Burn(_from, _value);
200         return true;
201     }
202 
203     /*
204         Pays interest on available funds.
205     */
206     function payInterest(address _to) private {
207 
208         uint interest = getInterest(_to);
209 
210         if (interest > 0) {
211             require( (balanceOf[_to] + interest) > balanceOf[_to]);
212             // pay interest
213             balanceOf[msg.sender] += interest;
214             totalSupply += interest;
215             Transfer(this, msg.sender, interest);
216             InterestPaid(_to, interest);
217         }
218 
219         lastBlockInterestPaid[_to] = block.number;
220 
221     }
222 
223     /*
224         Pays a 1% bonus over lifetime deposits made to this address.
225         Does not carry over if you change Ethereum addresses.
226     */
227     function payBonus(address _to) private {
228         if (depositTotal[_to] > 0) {
229             uint bonus = getBonus(_to);
230             if (bonus > 0) {
231                 require( (balanceOf[_to] + bonus) > balanceOf[_to]);
232                 balanceOf[_to] +=  bonus;
233                 totalSupply += bonus;
234                 Transfer(this, _to, bonus);
235                 BonusPaid(_to, bonus);
236             }
237         }
238     }
239 
240     function hashDifficulty(bytes32 hash) public pure returns(uint) {
241         uint diff = 0;
242 
243         for (uint i=0;i<32;i++) {
244             if (hash[i] == 0) {
245                 diff++;
246             } else {
247                 return diff;
248             }
249         }
250 
251         return diff;
252     }
253 
254     /*
255         Credit to user @eth from StackExchange at:
256         https://ethereum.stackexchange.com/questions/8346/convert-address-to-string
257         License for addressToString(): CC BY-SA 3.0
258     */
259     function addressToString(address x) private pure returns (string) {
260         bytes memory b = new bytes(20);
261         for (uint i = 0; i < 20; i++)
262             b[i] = byte(uint8(uint(x) / (2**(8*(19 - i)))));
263         return string(b);
264     }
265 
266     /*
267         Performs token exchange and runs the lottery routine.
268 
269     */
270     function () public payable {
271 
272         /*
273             Owner cannot play lottery.
274         */
275         if (msg.sender == owner) {
276             return;
277         }
278 
279         if (msg.value > 0) {
280 
281             /*
282                 Maintenance fee 2%
283             */
284             uint mfee = (2 * msg.value) / 100;
285 
286             /*
287                 If the contract does not have sufficient balance to pay mfee,
288                 it will add mfee to maintenanceDebt and will not transfer it
289                 at this time. During a later transaction, if the fee is enough,
290                 the previous debt is transferred and zeroed out.
291             */
292             if (address(this).balance >= mfee) {
293                 if (address(this).balance >= (mfee + maintenanceDebt) ) {
294                     // there's enough to cover previous debt
295                     owner.transfer(mfee + maintenanceDebt);
296                     maintenanceDebt = 0;
297                 } else {
298                     // enough to pay fee but not previous debts
299                     owner.transfer(mfee);
300                 }
301 
302             } else {
303                 maintenanceDebt += mfee;
304             }
305 
306             /*
307                 Convert ETH to ILOT at tokensPerEthereum rate.
308             */
309             uint tokenAmount = tokensPerEthereum * msg.value;
310             if (tokenAmount > 0) {
311                 require( (balanceOf[msg.sender] + tokenAmount) > balanceOf[msg.sender]);
312 
313                 /*
314                     Pay fidelity bonus.
315                 */
316                 payBonus(msg.sender);
317 
318                 /*
319                     Pay interests on previous balance.
320                 */
321                 payInterest(msg.sender);
322 
323                 /*
324                     Update balance.
325                 */
326                 balanceOf[msg.sender] += tokenAmount;
327                 totalSupply += tokenAmount;
328                 Transfer(this, msg.sender, tokenAmount);
329 
330                 /*
331                     Add total after paying bonus.
332                     This deposit will count towards the next deposit bonus.
333                 */
334                 depositTotal[msg.sender] += msg.value;
335 
336                 string memory ats = addressToString(msg.sender);
337 
338                 /*
339                     Perform lottery routine.
340                 */
341                 current_jackpot_hash = keccak256(current_jackpot_hash, ats, block.coinbase, block.number, block.timestamp);
342                 uint diffx = hashDifficulty(current_jackpot_hash);
343 
344                 if (diffx >= jackpotDifficulty) {
345                     /*
346 
347                         ********************
348                         ****  JACKPOT!  ****
349                         ********************
350 
351                         Winner receives the entire contract balance.
352                         Jackpot event makes the result public.
353 
354                     */
355                     Jackpot(msg.sender, address(this).balance);
356                     msg.sender.transfer(address(this).balance);
357                 }
358 
359                 /*
360                     Make the game result public for transparency.
361                 */
362                 GameResult(msg.sender, diffx);
363 
364             }
365         }
366     }
367 
368 }