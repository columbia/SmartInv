1 /**
2 Contract interface:
3 1. Standars ERC20 methods: balanceOf, totalSupply, transfer, transferFrom, approve, allowance
4 
5 */
6 
7 pragma solidity ^0.4.11;
8 
9 /* 
10 contract Gold {
11   struct FakeBlock {
12     uint timestamp;
13   }
14 
15   FakeBlock block;
16 
17   uint now = 0;
18 
19   function setBlockTime(uint val) {
20     now = val;
21     block.timestamp = val;
22   }
23 
24   function addBlockTime(uint val) {
25     now += val;
26     block.timestamp += val;
27   }
28 }
29 */
30 
31 //contract Gold is Gold_ {
32 contract Gold {
33     // totalSupply is zero by default, owner can issue and destroy coins any amount any time
34     uint constant totalSupplyDefault = 0;
35 
36     string public constant symbol = "Gold";
37     string public constant name = "AssetBase Gold";
38     uint8 public constant decimals = 7;
39     // minimum fee is 0.00001
40     uint32 public constant minFee = 1;
41     uint32 public constant minTransfer = 10;
42 
43     uint public totalSupply = 0;
44 
45     // transfer fee default = 0.17% (0.0017)
46     uint32 public transferFeeNum = 17;
47     uint32 public transferFeeDenum = 10000;
48 
49     // demurring fee default = 0,7 % per year
50     // 0.007 per year = 0.007 / 365 per day = 0.000019178 per day
51     // 0.000019178 / (24*60) per minute = 0.000000013 per minute
52     uint32 public demurringFeeNum = 13;
53     uint32 public demurringFeeDenum = 1000000000;
54 
55     
56     // Owner of this contract
57     address public owner;
58     modifier onlyOwner() {
59         if (msg.sender != owner) {
60             revert();
61         }
62         _;
63     }
64     address public demurringFeeOwner;
65     address public transferFeeOwner;
66  
67     // Balances for each account
68     mapping(address => uint) balances;
69 
70     // demurring fee deposit payed date for each account
71     mapping(address => uint64) timestamps;
72  
73     // Owner of account approves the transfer of an amount to another account
74     mapping(address => mapping (address => uint)) allowed;
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed from , address indexed to , uint256 value);
78     event DemurringFee(address indexed to , uint256 value);
79     event TransferFee(address indexed to , uint256 value);
80 
81     // if supply provided is 0, then default assigned
82     function Gold(uint supply) {
83         if (supply > 0) {
84             totalSupply = supply;
85         } else {
86             totalSupply = totalSupplyDefault;
87         }
88         owner = msg.sender;
89         demurringFeeOwner = owner;
90         transferFeeOwner = owner;
91         balances[this] = totalSupply;
92     }
93 
94     function changeDemurringFeeOwner(address addr) onlyOwner {
95         demurringFeeOwner = addr;
96     }
97     function changeTransferFeeOwner(address addr) onlyOwner {
98         transferFeeOwner = addr;
99     }
100  
101     function balanceOf(address addr) constant returns (uint) {
102         return balances[addr];
103     }
104 
105     // charge demurring fee for previuos period
106     // fee is not applied to owners
107     function chargeDemurringFee(address addr) internal {
108         if (addr != owner && addr != transferFeeOwner && addr != demurringFeeOwner && balances[addr] > 0 && now > timestamps[addr] + 60) {
109             var mins = (now - timestamps[addr]) / 60;
110             var fee = balances[addr] * mins * demurringFeeNum / demurringFeeDenum;
111             if (fee < minFee) {
112                 fee = minFee;
113             } else if (fee > balances[addr]) {
114                 fee = balances[addr];
115             }
116 
117             balances[addr] -= fee;
118             balances[demurringFeeOwner] += fee;
119             Transfer(addr, demurringFeeOwner, fee);
120             DemurringFee(addr, fee);
121 
122             timestamps[addr] = uint64(now);
123         }
124     }
125 
126     // fee is not applied to owners
127     function chargeTransferFee(address addr, uint amount) internal returns (uint) {
128         if (addr != owner && addr != transferFeeOwner && addr != demurringFeeOwner && balances[addr] > 0) {
129             var fee = amount * transferFeeNum / transferFeeDenum;
130             if (fee < minFee) {
131                 fee = minFee;
132             } else if (fee > balances[addr]) {
133                 fee = balances[addr];
134             }
135             amount = amount - fee;
136 
137             balances[addr] -= fee;
138             balances[transferFeeOwner] += fee;
139             Transfer(addr, transferFeeOwner, fee);
140             TransferFee(addr, fee);
141         }
142         return amount;
143     }
144  
145     function transfer(address to, uint amount) returns (bool) {
146         if (amount >= minTransfer
147             && balances[msg.sender] >= amount
148             && balances[to] + amount > balances[to]
149             ) {
150                 chargeDemurringFee(msg.sender);
151 
152                 if (balances[msg.sender] >= amount) {
153                     amount = chargeTransferFee(msg.sender, amount);
154 
155                     // charge recepient with demurring fee
156                     if (balances[to] > 0) {
157                         chargeDemurringFee(to);
158                     } else {
159                         timestamps[to] = uint64(now);
160                     }
161 
162                     balances[msg.sender] -= amount;
163                     balances[to] += amount;
164                     Transfer(msg.sender, to, amount);
165                 }
166                 return true;
167           } else {
168               return false;
169           }
170     }
171  
172     function transferFrom(address from, address to, uint amount) returns (bool) {
173         if ( amount >= minTransfer
174             && allowed[from][msg.sender] >= amount
175             && balances[from] >= amount
176             && balances[to] + amount > balances[to]
177             ) {
178                 allowed[from][msg.sender] -= amount;
179 
180                 chargeDemurringFee(msg.sender);
181 
182                 if (balances[msg.sender] >= amount) {
183                     amount = chargeTransferFee(msg.sender, amount);
184 
185                     // charge recepient with demurring fee
186                     if (balances[to] > 0) {
187                         chargeDemurringFee(to);
188                     } else {
189                         timestamps[to] = uint64(now);
190                     }
191 
192                     balances[msg.sender] -= amount;
193                     balances[to] += amount;
194                     Transfer(msg.sender, to, amount);
195                 }
196                 return true;
197         } else {
198             return false;
199         }
200     }
201  
202     function approve(address spender, uint amount) returns (bool) {
203         allowed[msg.sender][spender] = amount;
204         Approval(msg.sender, spender, amount);
205         return true;
206     }
207  
208     function allowance(address addr, address spender) constant returns (uint) {
209         return allowed[addr][spender];
210     }
211 
212     function setTransferFee(uint32 numinator, uint32 denuminator) onlyOwner {
213         require(denuminator > 0 && numinator < denuminator);
214         transferFeeNum = numinator;
215         transferFeeDenum = denuminator;
216     }
217 
218     function setDemurringFee(uint32 numinator, uint32 denuminator) onlyOwner {
219         require(denuminator > 0 && numinator < denuminator);
220         demurringFeeNum = numinator;
221         demurringFeeDenum = denuminator;
222     }
223 
224     function sell(address to, uint amount) onlyOwner {
225         require(amount > minTransfer && balances[this] >= amount);
226 
227         // charge recepient with demurring fee
228         if (balances[to] > 0) {
229             chargeDemurringFee(to);
230         } else {
231             timestamps[to] = uint64(now);
232         }
233         balances[this] -= amount;
234         balances[to] += amount;
235         Transfer(this, to, amount);
236     }
237 
238     // issue new coins
239     function issue(uint amount) onlyOwner {
240          if (totalSupply + amount > totalSupply) {
241              totalSupply += amount;
242              balances[this] += amount;
243          }
244     }
245 
246     // destroy existing coins
247     function destroy(uint amount) onlyOwner {
248           require(amount>0 && balances[this] >= amount);
249           balances[this] -= amount;
250           totalSupply -= amount;
251     }
252 
253     // kill contract only if all wallets are empty
254     function kill() onlyOwner {
255         require (totalSupply == 0);
256         selfdestruct(owner);
257     }
258 
259     // payments ar reverted back
260     function () payable {
261         revert();
262     }
263 }