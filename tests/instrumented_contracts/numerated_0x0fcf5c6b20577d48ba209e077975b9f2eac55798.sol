1 /**
2 Contract interface:
3 1. Standars ERC20 methods: balanceOf, totalSupply, transfer, transferFrom, approve, allowance
4 2. Finction issue, argument amount
5 issue new amount coins to totalSupply
6 3. destroy, argument amount
7 remove amount coins from totalSupply if available in contract
8 used only by contract owner
9 4. sell - argument amount, to
10 Used only by contract owner
11 Send amount coins to address to
12 5. kill
13 Used only by contract owner
14 destroy cantract
15 Contract can be destroyed if totalSupply is empty and all wallets are empty
16 6. setTransferFee arguments numinator, denuminator
17 Used only by contract owner
18 set transfer fee to numinator/denuminator
19 6. setDemurringFee arguments numinator, denuminator
20 Used only by contract owner
21 set demurring fee to numinator/denuminator
22 7. changeDemurringFeeOwner, argument address 
23 Used only by contract owner
24 change demurring fees recipient to address
25 8. changeTransferFeeOwner, argument address 
26 Used only by contract owner
27 change transfer fees recipient to address
28 */
29 
30 pragma solidity ^0.4.11;
31 
32 /* 
33 contract svb_ {
34   struct Block {
35     uint timestamp;
36   }
37 
38   Block block;
39 
40   uint now = 0;
41 
42   function setBlockTime(uint val) {
43     now = val;
44     block.timestamp = val;
45   }
46 
47   function addBlockTime(uint val) {
48     now += val;
49     block.timestamp += val;
50   }
51 }
52 */
53 
54 //contract svb is svb_ {
55 contract svb {
56     // totalSupply is zero by default, owner can issue and destroy coins any amount any time
57     uint constant totalSupplyDefault = 0;
58 
59     string public constant symbol = "SVB";
60     string public constant name = "Silver";
61     uint8 public constant decimals = 5;
62     // minimum fee is 0.00001
63     uint32 public constant minFee = 1;
64     uint32 public constant minTransfer = 10;
65 
66     uint public totalSupply = 0;
67 
68     // transfer fee default = 0.17% (0.0017)
69     uint32 public transferFeeNum = 17;
70     uint32 public transferFeeDenum = 10000;
71 
72     // demurring fee default = 0,7 % per year
73     // 0.007 per year = 0.007 / 365 per day = 0.000019178 per day
74     // 0.000019178 / (24*60) per minute = 0.000000013 per minute
75     uint32 public demurringFeeNum = 13;
76     uint32 public demurringFeeDenum = 1000000000;
77 
78     
79     // Owner of this contract
80     address public owner;
81     modifier onlyOwner() {
82         if (msg.sender != owner) {
83             revert();
84         }
85         _;
86     }
87     address public demurringFeeOwner;
88     address public transferFeeOwner;
89  
90     // Balances for each account
91     mapping(address => uint) balances;
92 
93     // demurring fee deposit payed date for each account
94     mapping(address => uint64) timestamps;
95  
96     // Owner of account approves the transfer of an amount to another account
97     mapping(address => mapping (address => uint)) allowed;
98 
99     event Transfer(address indexed from, address indexed to, uint256 value);
100     event Approval(address indexed from , address indexed to , uint256 value);
101     event DemurringFee(address indexed to , uint256 value);
102     event TransferFee(address indexed to , uint256 value);
103 
104     // if supply provided is 0, then default assigned
105     function svb(uint supply) {
106         if (supply > 0) {
107             totalSupply = supply;
108         } else {
109             totalSupply = totalSupplyDefault;
110         }
111         owner = msg.sender;
112         demurringFeeOwner = owner;
113         transferFeeOwner = owner;
114         balances[this] = totalSupply;
115     }
116 
117     function changeDemurringFeeOwner(address addr) onlyOwner {
118         demurringFeeOwner = addr;
119     }
120     function changeTransferFeeOwner(address addr) onlyOwner {
121         transferFeeOwner = addr;
122     }
123  
124     function balanceOf(address addr) constant returns (uint) {
125         return balances[addr];
126     }
127 
128     // charge demurring fee for previuos period
129     // fee is not applied to owners
130     function chargeDemurringFee(address addr) internal {
131         if (addr != owner && addr != transferFeeOwner && addr != demurringFeeOwner && balances[addr] > 0 && now > timestamps[addr] + 60) {
132             var mins = (now - timestamps[addr]) / 60;
133             var fee = balances[addr] * mins * demurringFeeNum / demurringFeeDenum;
134             if (fee < minFee) {
135                 fee = minFee;
136             } else if (fee > balances[addr]) {
137                 fee = balances[addr];
138             }
139 
140             balances[addr] -= fee;
141             balances[demurringFeeOwner] += fee;
142             Transfer(addr, demurringFeeOwner, fee);
143             DemurringFee(addr, fee);
144 
145             timestamps[addr] = uint64(now);
146         }
147     }
148 
149     // fee is not applied to owners
150     function chargeTransferFee(address addr, uint amount) internal returns (uint) {
151         if (addr != owner && addr != transferFeeOwner && addr != demurringFeeOwner && balances[addr] > 0) {
152             var fee = amount * transferFeeNum / transferFeeDenum;
153             if (fee < minFee) {
154                 fee = minFee;
155             } else if (fee > balances[addr]) {
156                 fee = balances[addr];
157             }
158             amount = amount - fee;
159 
160             balances[addr] -= fee;
161             balances[transferFeeOwner] += fee;
162             Transfer(addr, transferFeeOwner, fee);
163             TransferFee(addr, fee);
164         }
165         return amount;
166     }
167  
168     function transfer(address to, uint amount) returns (bool) {
169         if (amount >= minTransfer
170             && balances[msg.sender] >= amount
171             && balances[to] + amount > balances[to]
172             ) {
173                 chargeDemurringFee(msg.sender);
174 
175                 if (balances[msg.sender] >= amount) {
176                     amount = chargeTransferFee(msg.sender, amount);
177 
178                     // charge recepient with demurring fee
179                     if (balances[to] > 0) {
180                         chargeDemurringFee(to);
181                     } else {
182                         timestamps[to] = uint64(now);
183                     }
184 
185                     balances[msg.sender] -= amount;
186                     balances[to] += amount;
187                     Transfer(msg.sender, to, amount);
188                 }
189                 return true;
190           } else {
191               return false;
192           }
193     }
194  
195     function transferFrom(address from, address to, uint amount) returns (bool) {
196         if ( amount >= minTransfer
197             && allowed[from][msg.sender] >= amount
198             && balances[from] >= amount
199             && balances[to] + amount > balances[to]
200             ) {
201                 allowed[from][msg.sender] -= amount;
202 
203                 chargeDemurringFee(msg.sender);
204 
205                 if (balances[msg.sender] >= amount) {
206                     amount = chargeTransferFee(msg.sender, amount);
207 
208                     // charge recepient with demurring fee
209                     if (balances[to] > 0) {
210                         chargeDemurringFee(to);
211                     } else {
212                         timestamps[to] = uint64(now);
213                     }
214 
215                     balances[msg.sender] -= amount;
216                     balances[to] += amount;
217                     Transfer(msg.sender, to, amount);
218                 }
219                 return true;
220         } else {
221             return false;
222         }
223     }
224  
225     function approve(address spender, uint amount) returns (bool) {
226         allowed[msg.sender][spender] = amount;
227         Approval(msg.sender, spender, amount);
228         return true;
229     }
230  
231     function allowance(address addr, address spender) constant returns (uint) {
232         return allowed[addr][spender];
233     }
234 
235     function setTransferFee(uint32 numinator, uint32 denuminator) onlyOwner {
236         require(denuminator > 0 && numinator < denuminator);
237         transferFeeNum = numinator;
238         transferFeeDenum = denuminator;
239     }
240 
241     function setDemurringFee(uint32 numinator, uint32 denuminator) onlyOwner {
242         require(denuminator > 0 && numinator < denuminator);
243         demurringFeeNum = numinator;
244         demurringFeeDenum = denuminator;
245     }
246 
247     function sell(address to, uint amount) onlyOwner {
248         require(amount > minTransfer && balances[this] >= amount);
249 
250         // charge recepient with demurring fee
251         if (balances[to] > 0) {
252             chargeDemurringFee(to);
253         } else {
254             timestamps[to] = uint64(now);
255         }
256         balances[this] -= amount;
257         balances[to] += amount;
258         Transfer(this, to, amount);
259     }
260 
261     // issue new coins
262     function issue(uint amount) onlyOwner {
263          if (totalSupply + amount > totalSupply) {
264              totalSupply += amount;
265              balances[this] += amount;
266          }
267     }
268 
269     // destroy existing coins
270     function destroy(uint amount) onlyOwner {
271           require(amount>0 && balances[this] >= amount);
272           balances[this] -= amount;
273           totalSupply -= amount;
274     }
275 
276     // kill contract only if all wallets are empty
277     function kill() onlyOwner {
278         require (totalSupply == 0);
279         selfdestruct(owner);
280     }
281 
282     // payments ar reverted back
283     function () payable {
284         revert();
285     }
286 }