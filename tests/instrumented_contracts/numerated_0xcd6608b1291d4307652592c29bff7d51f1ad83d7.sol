1 pragma solidity ^0.3.5;
2 
3 contract DepositHolder {
4     uint constant GUARANTEE_PERIOD = 365 days;
5     
6     event Claim(address addr, uint amount);
7     
8     struct Entry {
9         bytes16 next;
10         uint64 deposit;
11         uint64 expires;
12     }
13 
14     address owner;
15     address auditor;
16     
17     mapping(bytes16=>Entry) entries;
18     bytes16 oldestHash;
19     bytes16 newestHash;
20     
21     uint public paidOut;
22     uint public totalPaidOut;
23     uint public depositCount;
24     
25     function DepositHolder() {
26         owner = msg.sender;
27         auditor = owner;
28     }
29     
30     modifier owner_only {
31         if(msg.sender != owner) throw;
32         _;
33     }
34     
35     modifier auditor_only {
36         if(msg.sender != auditor) throw;
37         _;
38     }
39     
40     function setOwner(address newOwner) owner_only {
41         owner = newOwner;
42     }
43     
44     function setAuditor(address newAuditor) auditor_only {
45         auditor = newAuditor;
46     }
47 
48     /**
49      * @dev Lodge deposits for a set of address hashes. Automatically uses
50      *      expired deposits to pay for new ones.
51      * @param values A list of hashes of addresses to place deposits for.
52      *        Each value is the first 16 bytes of the keccak-256 hash of the
53      *        address the deposit is for.
54      * @param deposit The amount of the deposit on each address.
55      */
56     function deposit(bytes16[] values, uint64 deposit) owner_only {
57         uint required = values.length * deposit;
58         if(msg.value < required) {
59             throw;
60         } else if(msg.value > required) {
61             if(!msg.sender.send(msg.value - required))
62                 throw;
63         }
64 
65         extend(values, uint64(deposit));
66     }
67 
68     function extend(bytes16[] values, uint64 deposit) private {
69         uint64 expires = uint64(now + GUARANTEE_PERIOD);
70 
71         if(oldestHash == 0) {
72             oldestHash = values[0];
73             newestHash = values[0];
74         } else {
75             entries[newestHash].next = values[0];
76         }
77         
78         for(uint i = 0; i < values.length - 1; i++) {
79             if(entries[values[i]].expires != 0)
80                 throw;
81             entries[values[i]] = Entry(values[i + 1], deposit, expires);
82         }
83         
84         newestHash = values[values.length - 1];
85         if(entries[newestHash].expires != 0)
86             throw;
87         entries[newestHash] = Entry(0, deposit, expires);
88         
89         depositCount += values.length;
90     }
91 
92     /**
93      * @dev Withdraw funds held for expired deposits.
94      * @param max Maximum number of deposits to claim.
95      */
96     function withdraw(uint max) owner_only {
97         uint recovered = recover(max);
98         if(!msg.sender.send(recovered))
99             throw;
100     }
101 
102     function recover(uint max) private returns(uint recovered) {
103         // Iterate through entries deleting them, until we find one
104         // that's new enough, or hit the limit.
105         bytes16 ptr = oldestHash;
106         uint count;
107         for(uint i = 0; i < max && ptr != 0 && entries[ptr].expires < now; i++) {
108             recovered += entries[ptr].deposit;
109             ptr = entries[ptr].next;
110             count += 1;
111         }
112 
113         oldestHash = ptr;
114         if(oldestHash == 0)
115             newestHash = 0;
116         
117         // Deduct any outstanding payouts from the recovered funds
118         if(paidOut > 0) {
119             if(recovered > paidOut) {
120                 recovered -= paidOut;
121                 paidOut = 0;
122             } else {
123                 paidOut -= recovered;
124                 recovered = 0;
125             }
126         }
127         
128         depositCount -= count;
129     }
130 
131     /**
132      * @dev Fetches information on a future withdrawal event
133      * @param hash The point at which to start scanning; 0 for the first event.
134      * @return when Unix timestamp at which a withdrawal can next happen.
135      * @return count Number of addresses expiring at this time
136      * @return value Total amount withdrawable at this time
137      * @return next Hash of the start of the next withdrawal event, if any.
138      */
139     function nextWithdrawal(bytes16 hash) constant returns(uint when, uint count, uint value, bytes16 next) {
140         if(hash == 0) {
141             hash = oldestHash;
142         }
143         next = hash;
144         when = entries[hash].expires;
145         while(next != 0 && entries[next].expires == when) {
146             count += 1;
147             value += entries[next].deposit;
148             next = entries[next].next;
149         }
150     }
151 
152     /**
153      * @dev Checks if a deposit is held for the provided address.
154      * @param addr The address to check.
155      * @return expires The unix timestamp at which the deposit on this address
156      *         expires, or 0 if there is no deposit.
157      * @return deposit The amount deposited against this address.
158      */
159     function check(address addr) constant returns (uint expires, uint deposit) {
160         Entry storage entry = entries[bytes16(sha3(addr))];
161         expires = entry.expires;
162         deposit = entry.deposit;
163     }
164     
165     /**
166      * @dev Pays out a claim.
167      * @param addr The address to pay.
168      * @param amount The amount to send.
169      */
170     function disburse(address addr, uint amount) auditor_only {
171         paidOut += amount;
172         totalPaidOut += amount;
173         Claim(addr, amount);
174         if(!addr.send(amount))
175             throw;
176     }
177     
178     /**
179      * @dev Deletes the contract, if no deposits are held.
180      */
181     function destroy() owner_only {
182         if(depositCount > 0)
183             throw;
184         selfdestruct(msg.sender);
185     }
186 }