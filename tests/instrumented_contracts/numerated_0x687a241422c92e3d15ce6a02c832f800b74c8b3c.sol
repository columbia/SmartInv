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
40     /**
41      * @dev Lodge deposits for a set of address hashes. Automatically uses
42      *      expired deposits to pay for new ones.
43      * @param values A list of hashes of addresses to place deposits for.
44      *        Each value is the first 16 bytes of the keccak-256 hash of the
45      *        address the deposit is for.
46      * @param deposit The amount of the deposit on each address.
47      */
48     function deposit(bytes16[] values, uint64 deposit) owner_only {
49         uint required = values.length * deposit;
50         if(msg.value < required) {
51             throw;
52         } else if(msg.value > required) {
53             if(!msg.sender.send(msg.value - required))
54                 throw;
55         }
56 
57         extend(values, uint64(deposit));
58     }
59 
60     function extend(bytes16[] values, uint64 deposit) private {
61         uint64 expires = uint64(now + GUARANTEE_PERIOD);
62 
63         if(oldestHash == 0) {
64             oldestHash = values[0];
65             newestHash = values[0];
66         } else {
67             entries[newestHash].next = values[0];
68         }
69         
70         for(uint i = 0; i < values.length - 1; i++) {
71             if(entries[values[i]].expires != 0)
72                 throw;
73             entries[values[i]] = Entry(values[i + 1], deposit, expires);
74         }
75         
76         newestHash = values[values.length - 1];
77         if(entries[newestHash].expires != 0)
78             throw;
79         entries[newestHash] = Entry(0, deposit, expires);
80         
81         depositCount += values.length;
82     }
83 
84     /**
85      * @dev Withdraw funds held for expired deposits.
86      * @param max Maximum number of deposits to claim.
87      */
88     function withdraw(uint max) owner_only {
89         uint recovered = recover(max);
90         if(!msg.sender.send(recovered))
91             throw;
92     }
93 
94     function recover(uint max) private returns(uint recovered) {
95         // Iterate through entries deleting them, until we find one
96         // that's new enough, or hit the limit.
97         bytes16 ptr = oldestHash;
98         uint count;
99         for(uint i = 0; i < max && ptr != 0 && entries[ptr].expires < now; i++) {
100             recovered += entries[ptr].deposit;
101             ptr = entries[ptr].next;
102             count += 1;
103         }
104 
105         oldestHash = ptr;
106         if(oldestHash == 0)
107             newestHash = 0;
108         
109         // Deduct any outstanding payouts from the recovered funds
110         if(paidOut > 0) {
111             if(recovered > paidOut) {
112                 recovered -= paidOut;
113                 paidOut = 0;
114             } else {
115                 paidOut -= recovered;
116                 recovered = 0;
117             }
118         }
119         
120         depositCount -= count;
121     }
122 
123     /**
124      * @dev Fetches information on a future withdrawal event
125      * @param hash The point at which to start scanning; 0 for the first event.
126      * @return when Unix timestamp at which a withdrawal can next happen.
127      * @return count Number of addresses expiring at this time
128      * @return value Total amount withdrawable at this time
129      * @return next Hash of the start of the next withdrawal event, if any.
130      */
131     function nextWithdrawal(bytes16 hash) constant returns(uint when, uint count, uint value, bytes16 next) {
132         if(hash == 0) {
133             hash = oldestHash;
134         }
135         next = hash;
136         when = entries[hash].expires;
137         while(next != 0 && entries[next].expires == when) {
138             count += 1;
139             value += entries[next].deposit;
140             next = entries[next].next;
141         }
142     }
143 
144     /**
145      * @dev Checks if a deposit is held for the provided address.
146      * @param addr The address to check.
147      * @return expires The unix timestamp at which the deposit on this address
148      *         expires, or 0 if there is no deposit.
149      * @return deposit The amount deposited against this address.
150      */
151     function check(address addr) constant returns (uint expires, uint deposit) {
152         Entry storage entry = entries[bytes16(sha3(addr))];
153         expires = entry.expires;
154         deposit = entry.deposit;
155     }
156     
157     /**
158      * @dev Pays out a claim.
159      * @param addr The address to pay.
160      * @param amount The amount to send.
161      */
162     function disburse(address addr, uint amount) auditor_only {
163         paidOut += amount;
164         totalPaidOut += amount;
165         Claim(addr, amount);
166         if(!addr.send(amount))
167             throw;
168     }
169     
170     /**
171      * @dev Deletes the contract, if no deposits are held.
172      */
173     function destroy() owner_only {
174         if(depositCount > 0)
175             throw;
176         selfdestruct(msg.sender);
177     }
178 }