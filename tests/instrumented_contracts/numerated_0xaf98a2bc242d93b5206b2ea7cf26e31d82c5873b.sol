1 pragma solidity ^0.4.19;
2 contract TrustWallet {
3 
4     struct User {
5         // How many seconds the user has to wait between initiating the
6         // transaction and finalizing the transaction. This cannot be
7         // changed.
8         uint waiting_time;
9 
10         address added_by;
11         uint time_added;
12 
13         address removed_by;
14         uint time_removed;
15 
16         // When this user added another user. (This is to prevent a user from
17         // adding many users too quickly).
18         uint time_added_another_user;
19     }
20 
21     struct Transaction {
22         address destination;
23         uint value;
24         bytes data;
25 
26         address initiated_by;
27         uint time_initiated;
28 
29         address finalized_by;
30         uint time_finalized;
31 
32         // True if this trasaction was executed. If false, this means it was canceled.
33         bool is_executed;
34         // True if the execution call was successful
35         bool execution_successful;
36     }
37 
38     Transaction[] public transactions;
39     mapping (address => User) public users;
40     address[] public userAddresses;
41 
42     modifier onlyActiveUsersAllowed() {
43         require(users[msg.sender].time_added != 0);
44         require(users[msg.sender].time_removed == 0);
45         _;
46     }
47 
48     modifier transactionMustBePending() {
49         require(isTransactionPending());
50         _;
51     }
52 
53     modifier transactionMustNotBePending() {
54         require(!isTransactionPending());
55         _;
56     }
57 
58     // Returns true if there is a transaction pending.
59     function isTransactionPending() public constant returns (bool) {
60         if (transactions.length == 0) return false;
61         return transactions[transactions.length - 1].time_initiated > 0 &&
62             transactions[transactions.length - 1].time_finalized == 0;
63     }
64 
65     // Returns the balance of this contract.
66     function balance() public constant returns (uint) {
67         return address(this).balance;
68     }
69 
70     // Returns the balance of this contract.
71     function transactionCount() public constant returns (uint) {
72         return transactions.length;
73     }
74 
75     // Constructor. Creates the first user.
76     function TrustWallet(address first_user) public {
77         users[first_user] = User({
78             waiting_time: 0,
79             time_added: now,
80             added_by: 0x0,
81             time_removed: 0,
82             removed_by: 0x0,
83             time_added_another_user: now
84         });
85         userAddresses.push(first_user);
86     }
87 
88     function () public payable {}
89 
90     // Initiates a transaction. There must not be any pending transaction.
91     function initiateTransaction(address _destination, uint _value, bytes _data)
92         public
93         onlyActiveUsersAllowed()
94         transactionMustNotBePending()
95     {
96         transactions.push(Transaction({
97             destination: _destination,
98             value: _value,
99             data: _data,
100             initiated_by: msg.sender,
101             time_initiated: now,
102             finalized_by: 0x0,
103             time_finalized: 0,
104             is_executed: false,
105             execution_successful: false
106         }));
107     }
108 
109     // Executes the transaction. The waiting_time of the the transaction
110     // initiated_by must have passed in order to call this function. Any active
111     // user is able to call this function.
112     function executeTransaction()
113         public
114         onlyActiveUsersAllowed()
115         transactionMustBePending()
116     {
117         Transaction storage transaction = transactions[transactions.length - 1];
118         require(now > transaction.time_initiated + users[transaction.initiated_by].waiting_time);
119         transaction.is_executed = true;
120         transaction.time_finalized = now;
121         transaction.finalized_by = msg.sender;
122         transaction.execution_successful = transaction.destination.call.value(
123             transaction.value)(transaction.data);
124     }
125 
126     // Cancels the transaction. The waiting_time of the user who is trying
127     // to cancel must be lower or equal to the waiting_time of the
128     // transaction initiated_by.
129     function cancelTransaction()
130         public
131         onlyActiveUsersAllowed()
132         transactionMustBePending()
133     {
134         // Users with a higher priority can do this
135         Transaction storage transaction = transactions[transactions.length - 1];
136         // Either the sender is a higher priority user
137         require(users[msg.sender].waiting_time <=
138             users[transaction.initiated_by].waiting_time);
139         transaction.time_finalized = now;
140         transaction.finalized_by = msg.sender;
141     }
142 
143     // Adds a user to the wallet. The waiting time of the new user must
144     // be greater or equal to the waiting_time of the sender. A user that
145     // already exists or was removed cannot be added. To prevent spam,
146     // a user must wait waiting_time before adding another user.
147     function addUser(address new_user, uint new_user_time)
148         public
149         onlyActiveUsersAllowed()
150     {
151         require(users[new_user].time_added == 0);
152         require(users[new_user].time_removed == 0);
153 
154         User storage sender = users[msg.sender];
155         require(now > sender.waiting_time + sender.time_added_another_user);
156         require(new_user_time >= sender.waiting_time);
157 
158         sender.time_added_another_user = now;
159         users[new_user] = User({
160             waiting_time: new_user_time,
161             time_added: now,
162             added_by: msg.sender,
163             time_removed: 0,
164             removed_by: 0x0,
165             // The new user will have to wait one waiting_time before being
166             // able to add a new user.
167             time_added_another_user: now
168         });
169         userAddresses.push(new_user);
170     }
171 
172     // Removes a user. The sender must have a lower or equal waiting_time
173     // as the user that she is trying to remove.
174     function removeUser(address userAddr)
175         public
176         onlyActiveUsersAllowed()
177     {
178         require(users[userAddr].time_removed == 0);
179         require(users[userAddr].time_added != 0);
180 
181         User storage sender = users[msg.sender];
182         require(sender.waiting_time <= users[userAddr].waiting_time);
183 
184         users[userAddr].removed_by = msg.sender;
185         users[userAddr].time_removed = now;
186     }
187 }
188 
189 contract TrustWalletFactory {
190     mapping (address => TrustWallet[]) public wallets;
191 
192     function createWallet() public {
193         wallets[msg.sender].push(new TrustWallet(msg.sender));
194     }
195 }