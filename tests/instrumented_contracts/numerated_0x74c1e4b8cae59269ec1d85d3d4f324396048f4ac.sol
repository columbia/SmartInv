1 /**
2  * Author: Nick Johnson (arachnid at notdot.net)
3  * Copyright 2016; licensed CC-BY-SA.
4  * 
5  * BeerCoin is a new cryptocurrency intended to encapsulate and record the
6  * concept of "I owe you a beer". Did someone answer a difficult question you
7  * had? Send them a BeerCoin. Did they help you carry something heavy? Send
8  * them a BeerCoin. Someone buy you a beer? Send them a BeerCoin.
9  * 
10  * Unlike traditional currency, anyone can issue BeerCoin simply by sending it
11  * to someone else. A person's BeerCoin is only as valuable as the recipient's
12  * belief that they're good for the beer, should it ever be redeemed; a beer
13  * owed to you by Vitalik Buterin is probably worth more than a beer owed to you
14  * by the DAO hacker (but your opinions may differ on that point).
15  * 
16  * BeerCoin is implemented as an ERC20 compatible token, with a few extensions.
17  * Regular ERC20 transfers will create or resolve obligations between the two
18  * parties; they will never transfer third-party BeerCoins. Additional methods
19  * are provided to allow you transfer beers someone owes you to a third party;
20  * if Satoshi Nakamoto owes you a beer, you can transfer that obligation to your
21  * friend who just bought you one down at the pub. Methods are also provided for
22  * determining the total number of beers a person owes, to help determine if
23  * they're good for it, and for getting a list of accounts that owe someone a
24  * beer.
25  * 
26  * BeerCoin may confuse some wallets, such as Mist, that expect you can only
27  * send currency up to your current total balance; since BeerCoin operates as
28  * individual IOUs, that restriction doesn't apply. As a result, you will
29  * sometimes need to call the 'transfer' function on the contract itself
30  * instead of using the wallet's built in token support.
31  * 
32  * If anyone finds a bug in the contract, I'll buy you a beer. If you find a bug
33  * you can exploit to adjust balances without users' consent, I'll buy you two
34  * (or more).
35  * 
36  * If you feel obliged to me for creating this, send me a ? at
37  * 0x5fC8A61e097c118cE43D200b3c4dcf726Cf783a9. Don't do it unless you mean it;
38  * if we meet I'll surely redeem it.
39  */
40 contract BeerCoin {
41     using Itmap for Itmap.AddressUintMap;
42     
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46     struct UserAccount {
47         bool exists;
48         Itmap.AddressUintMap debtors; // People who owe you a beer
49         mapping(address=>uint) allowances;
50         uint maxCredit; // Most beers any individual may owe you
51         uint beersOwed; // Beers owed by this person
52         uint beersOwing; // Beers owed to this person
53     }
54     uint beersOwing;
55     uint defaultMaxCredit;
56     
57     function() {
58         throw;
59     }
60     
61     function BeerCoin(uint _defaultMaxCredit) {
62         defaultMaxCredit = _defaultMaxCredit;
63     }
64     
65     mapping(address=>UserAccount) accounts;
66 
67     function maximumCredit(address owner) constant returns (uint) {
68         if(accounts[owner].exists) {
69             return accounts[owner].maxCredit;
70         } else {
71             return defaultMaxCredit;
72         }
73     }
74 
75     function setMaximumCredit(uint credit) {
76         //640k ought to be enough for anyone
77         if(credit > 655360)
78             return;
79 
80         if(!accounts[msg.sender].exists)
81             accounts[msg.sender].exists = true;
82         accounts[msg.sender].maxCredit = credit;
83     }
84     
85     function numDebtors(address owner) constant returns (uint) {
86         return accounts[owner].debtors.size();
87     }
88     
89     function debtor(address owner, uint idx) constant returns (address) {
90         return accounts[owner].debtors.index(idx);
91     }
92     
93     function debtors(address owner) constant returns (address[]) {
94         return accounts[owner].debtors.keys;
95     }
96 
97     function totalSupply() constant returns (uint256 supply) {
98         return beersOwing;   
99     }
100     
101     function balanceOf(address owner) constant returns (uint256 balance) {
102         return accounts[owner].beersOwing;
103     }
104     
105     function balanceOf(address owner, address debtor) constant returns (uint256 balance) {
106         return accounts[owner].debtors.get(debtor);
107     }
108     
109     function totalDebt(address owner) constant returns (uint256 balance) {
110         return accounts[owner].beersOwed;
111     }
112     
113     function transfer(address to, uint256 value) returns (bool success) {
114         return doTransfer(msg.sender, to, value);
115     }
116     
117     function transferFrom(address from, address to, uint256 value) returns (bool) {
118         if(accounts[from].allowances[msg.sender] >= value && doTransfer(from, to, value)) {
119             accounts[from].allowances[msg.sender] -= value;
120             return true;
121         }
122         return false;
123     }
124     
125     function doTransfer(address from, address to, uint value) internal returns (bool) {
126         if(from == to)
127             return false;
128             
129         if(!accounts[to].exists) {
130             accounts[to].exists = true;
131             accounts[to].maxCredit = defaultMaxCredit;
132         }
133         
134         // Don't allow transfers that would exceed the recipient's credit limit.
135         if(value > accounts[to].maxCredit + accounts[from].debtors.get(to))
136             return false;
137         
138         Transfer(from, to, value);
139 
140         value -= reduceDebt(to, from, value);
141         createDebt(from, to, value);
142 
143         return true;
144     }
145     
146     // Transfers beers owed to you by `debtor` to `to`.
147     function transferOther(address to, address debtor, uint value) returns (bool) {
148         return doTransferOther(msg.sender, to, debtor, value);
149     }
150 
151     // Allows a third party to transfer debt owed to you by `debtor` to `to`.    
152     function transferOtherFrom(address from, address to, address debtor, uint value) returns (bool) {
153         if(accounts[from].allowances[msg.sender] >= value && doTransferOther(from, to, debtor, value)) {
154             accounts[from].allowances[msg.sender] -= value;
155             return true;
156         }
157         return false;
158     }
159     
160     function doTransferOther(address from, address to, address debtor, uint value) internal returns (bool) {
161         if(from == to || to == debtor)
162             return false;
163             
164         if(!accounts[to].exists) {
165             accounts[to].exists = true;
166             accounts[to].maxCredit = defaultMaxCredit;
167         }
168         
169         if(transferDebt(from, to, debtor, value)) {
170             Transfer(from, to, value);
171             return true;
172         } else {
173             return false;
174         }
175     }
176     
177     // Creates debt owed by `debtor` to `creditor` of amount `value`.
178     // Returns false without making changes if this would exceed `creditor`'s
179     // credit limit.
180     function createDebt(address debtor, address creditor, uint value) internal returns (bool) {
181         if(value == 0)
182             return true;
183         
184         if(value > accounts[creditor].maxCredit)
185             return false;
186 
187         accounts[creditor].debtors.set(
188             debtor, accounts[creditor].debtors.get(debtor) + value);
189         accounts[debtor].beersOwed += value;
190         accounts[creditor].beersOwing += value;
191         beersOwing += value;
192         
193         return true;
194     }
195     
196     // Reduces debt owed by `debtor` to `creditor` by `value` or the total amount,
197     // whichever is less. Returns the amount of debt erased.
198     function reduceDebt(address debtor, address creditor, uint value) internal returns (uint) {
199         var owed = accounts[creditor].debtors.get(debtor);
200         if(value >= owed) {
201             value = owed;
202             
203             accounts[creditor].debtors.remove(debtor);
204         } else {
205             accounts[creditor].debtors.set(debtor, owed - value);
206         }
207         
208         accounts[debtor].beersOwed -= value;
209         accounts[creditor].beersOwing -= value;
210         beersOwing -= value;
211         
212         return value;
213     }
214     
215     // Transfers debt owed by `debtor` from `oldCreditor` to `newCreditor`.
216     // Returns false without making any changes if `value` exceeds the amount
217     // owed or if the transfer would exceed `newCreditor`'s credit limit.
218     function transferDebt(address oldCreditor, address newCreditor, address debtor, uint value) internal returns (bool) {
219         var owedOld = accounts[oldCreditor].debtors.get(debtor);
220         if(owedOld < value)
221             return false;
222         
223         var owedNew = accounts[newCreditor].debtors.get(debtor);
224         if(value + owedNew > accounts[newCreditor].maxCredit)
225             return false;
226         
227         
228         if(owedOld == value) {
229             accounts[oldCreditor].debtors.remove(debtor);
230         } else {
231             accounts[oldCreditor].debtors.set(debtor, owedOld - value);
232         }
233         accounts[oldCreditor].beersOwing -= value;
234         
235         accounts[newCreditor].debtors.set(debtor, owedNew + value);
236         accounts[newCreditor].beersOwing += value;
237         
238         return true;
239     }
240 
241     function approve(address spender, uint256 value) returns (bool) {
242         accounts[msg.sender].allowances[spender] = value;
243         Approval(msg.sender, spender, value);
244         return true;
245     }
246     
247     function allowance(address owner, address spender) constant returns (uint256) {
248         return accounts[owner].allowances[spender];
249     }
250 }
251 
252 
253 library Itmap {
254     struct AddressUintMapEntry {
255         uint value;
256         uint idx;
257     }
258     
259     struct AddressUintMap {
260         mapping(address=>AddressUintMapEntry) entries;
261         address[] keys;
262     }
263     
264     function set(AddressUintMap storage self, address k, uint v) internal {
265         var entry = self.entries[k];
266         if(entry.idx == 0) {
267             entry.idx = self.keys.length + 1;
268             self.keys.push(k);
269         }
270         entry.value = v;
271     }
272     
273     function get(AddressUintMap storage self, address k) internal returns (uint) {
274         return self.entries[k].value;
275     }
276     
277     function contains(AddressUintMap storage self, address k) internal returns (bool) {
278         return self.entries[k].idx > 0;
279     }
280     
281     function remove(AddressUintMap storage self, address k) internal {
282         var entry = self.entries[k];
283         if(entry.idx > 0) {
284             var otherkey = self.keys[self.keys.length - 1];
285             self.keys[entry.idx - 1] = otherkey;
286             self.keys.length -= 1;
287             
288             self.entries[otherkey].idx = entry.idx;
289             entry.idx = 0;
290             entry.value = 0;
291         }
292     }
293     
294     function size(AddressUintMap storage self) internal returns (uint) {
295         return self.keys.length;
296     }
297     
298     function index(AddressUintMap storage self, uint idx) internal returns (address) {
299         return self.keys[idx];
300     }
301 }