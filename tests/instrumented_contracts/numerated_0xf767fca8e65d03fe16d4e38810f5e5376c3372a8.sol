1 contract LuckyDoubler {
2 //##########################################################
3 //#### LuckyDoubler: A doubler with random payout order ####
4 //#### Deposit 1 ETHER to participate                   ####
5 //##########################################################
6 //COPYRIGHT 2016 KATATSUKI ALL RIGHTS RESERVED
7 //No part of this source code may be reproduced, distributed,
8 //modified or transmitted in any form or by any means without
9 //the prior written permission of the creator.
10 
11     address private owner;
12     
13     //Stored variables
14     uint private balance = 0;
15     uint private fee = 5;
16     uint private multiplier = 125;
17 
18     mapping (address => User) private users;
19     Entry[] private entries;
20     uint[] private unpaidEntries;
21     
22     //Set owner on contract creation
23     function LuckyDoubler() {
24         owner = msg.sender;
25     }
26 
27     modifier onlyowner { if (msg.sender == owner) _ }
28     
29     struct User {
30         address id;
31         uint deposits;
32         uint payoutsReceived;
33     }
34     
35     struct Entry {
36         address entryAddress;
37         uint deposit;
38         uint payout;
39         bool paid;
40     }
41 
42     //Fallback function
43     function() {
44         init();
45     }
46     
47     function init() private{
48         
49         if (msg.value < 1 ether) {
50              msg.sender.send(msg.value);
51             return;
52         }
53         
54         join();
55     }
56     
57     function join() private {
58         
59         //Limit deposits to 1ETH
60         uint dValue = 1 ether;
61         
62         if (msg.value > 1 ether) {
63             
64         	msg.sender.send(msg.value - 1 ether);	
65         	dValue = 1 ether;
66         }
67       
68         //Add new users to the users array
69         if (users[msg.sender].id == address(0))
70         {
71             users[msg.sender].id = msg.sender;
72             users[msg.sender].deposits = 0;
73             users[msg.sender].payoutsReceived = 0;
74         }
75         
76         //Add new entry to the entries array
77         entries.push(Entry(msg.sender, dValue, (dValue * (multiplier) / 100), false));
78         users[msg.sender].deposits++;
79         unpaidEntries.push(entries.length -1);
80         
81         //Collect fees and update contract balance
82         balance += (dValue * (100 - fee)) / 100;
83         
84         uint index = unpaidEntries.length > 1 ? rand(unpaidEntries.length) : 0;
85         Entry theEntry = entries[unpaidEntries[index]];
86         
87         //Pay pending entries if the new balance allows for it
88         if (balance > theEntry.payout) {
89             
90             uint payout = theEntry.payout;
91             
92             theEntry.entryAddress.send(payout);
93             theEntry.paid = true;
94             users[theEntry.entryAddress].payoutsReceived++;
95 
96             balance -= payout;
97             
98             if (index < unpaidEntries.length - 1)
99                 unpaidEntries[index] = unpaidEntries[unpaidEntries.length - 1];
100            
101             unpaidEntries.length--;
102             
103         }
104         
105         //Collect money from fees and possible leftovers from errors (actual balance untouched)
106         uint fees = this.balance - balance;
107         if (fees > 0)
108         {
109                 owner.send(fees);
110         }      
111        
112     }
113     
114     //Generate random number between 0 & max
115     uint256 constant private FACTOR =  1157920892373161954235709850086879078532699846656405640394575840079131296399;
116     function rand(uint max) constant private returns (uint256 result){
117         uint256 factor = FACTOR * 100 / max;
118         uint256 lastBlockNumber = block.number - 1;
119         uint256 hashVal = uint256(block.blockhash(lastBlockNumber));
120     
121         return uint256((uint256(hashVal) / factor)) % max;
122     }
123     
124     
125     //Contract management
126     function changeOwner(address newOwner) onlyowner {
127         owner = newOwner;
128     }
129     
130     function changeMultiplier(uint multi) onlyowner {
131         if (multi < 110 || multi > 150) throw;
132         
133         multiplier = multi;
134     }
135     
136     function changeFee(uint newFee) onlyowner {
137         if (fee > 5) 
138             throw;
139         fee = newFee;
140     }
141     
142     
143     //JSON functions
144     function multiplierFactor() constant returns (uint factor, string info) {
145         factor = multiplier;
146         info = 'The current multiplier applied to all deposits. Min 110%, max 150%.'; 
147     }
148     
149     function currentFee() constant returns (uint feePercentage, string info) {
150         feePercentage = fee;
151         info = 'The fee percentage applied to all deposits. It can change to speed payouts (max 5%).';
152     }
153     
154     function totalEntries() constant returns (uint count, string info) {
155         count = entries.length;
156         info = 'The number of deposits.';
157     }
158     
159     function userStats(address user) constant returns (uint deposits, uint payouts, string info)
160     {
161         if (users[user].id != address(0x0))
162         {
163             deposits = users[user].deposits;
164             payouts = users[user].payoutsReceived;
165             info = 'Users stats: total deposits, payouts received.';
166         }
167     }
168     
169     function entryDetails(uint index) constant returns (address user, uint payout, bool paid, string info)
170     {
171         if (index < entries.length) {
172             user = entries[index].entryAddress;
173             payout = entries[index].payout / 1 finney;
174             paid = entries[index].paid;
175             info = 'Entry info: user address, expected payout in Finneys, payout status.';
176         }
177     }
178     
179     
180 }