1 pragma solidity ^0.4.19;
2 contract TrustWallet {
3 
4     struct User {
5         // How many seconds the user has to wait between initiating the
6         // transaction and finalizing the transaction. This cannot be
7         // changed.
8         uint delay;
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
34     }
35 
36     Transaction[] public transactions;
37     mapping (address => User) public users;
38     address[] public userAddresses;
39 
40     modifier onlyActiveUsersAllowed() {
41         require(users[msg.sender].time_added != 0);
42         require(users[msg.sender].time_removed == 0);
43         _;
44     }
45 
46     modifier transactionMustBePending() {
47         require(isTransactionPending());
48         _;
49     }
50 
51     modifier transactionMustNotBePending() {
52         require(!isTransactionPending());
53         _;
54     }
55 
56     // Returns true if there is a transaction pending.
57     function isTransactionPending() internal constant returns (bool) {
58         if (transactions.length == 0) return false;
59         return transactions[transactions.length - 1].time_initiated > 0 &&
60             transactions[transactions.length - 1].time_finalized == 0;
61     }
62 
63     // Constructor. Creates the first user.
64     function TrustWallet(address first_user) public {
65         users[first_user] = User({
66             delay: 0,
67             time_added: now,
68             added_by: 0x0,
69             time_removed: 0,
70             removed_by: 0x0,
71             time_added_another_user: now
72         });
73         userAddresses.push(first_user);
74     }
75 
76     function () public payable {}
77 
78     // Initiates a transaction. There must not be any pending transaction.
79     function initiateTransaction(address _destination, uint _value, bytes _data)
80         public
81         onlyActiveUsersAllowed()
82         transactionMustNotBePending()
83     {
84         transactions.push(Transaction({
85             destination: _destination,
86             value: _value,
87             data: _data,
88             initiated_by: msg.sender,
89             time_initiated: now,
90             finalized_by: 0x0,
91             time_finalized: 0,
92             is_executed: false
93         }));
94     }
95 
96     // Executes the transaction. The delay of the the transaction
97     // initiated_by must have passed in order to call this function. Any active
98     // user is able to call this function.
99     function executeTransaction()
100         public
101         onlyActiveUsersAllowed()
102         transactionMustBePending()
103     {
104         Transaction storage transaction = transactions[transactions.length - 1];
105         require(now > transaction.time_initiated + users[transaction.initiated_by].delay);
106         transaction.is_executed = true;
107         transaction.time_finalized = now;
108         transaction.finalized_by = msg.sender;
109         require(transaction.destination.call.value(transaction.value)(transaction.data));
110     }
111 
112     // Cancels the transaction. The delay of the user who is trying
113     // to cancel must be lower or equal to the delay of the
114     // transaction initiated_by.
115     function cancelTransaction()
116         public
117         onlyActiveUsersAllowed()
118         transactionMustBePending()
119     {
120         Transaction storage transaction = transactions[transactions.length - 1];
121         // Either the sender is a higher priority user, or twice the waiting time of
122         // the user trying to cancel has passed. This is to prevent transactions from
123         // getting "stuck" if the call() fails when trying to execute the transaction.
124         require(users[msg.sender].delay <= users[transaction.initiated_by].delay ||
125             now - transaction.time_initiated > users[msg.sender].delay * 2);
126         transaction.time_finalized = now;
127         transaction.finalized_by = msg.sender;
128     }
129 
130     // Adds a user to the wallet. The waiting time of the new user must
131     // be greater or equal to the delay of the sender. A user that
132     // already exists or was removed cannot be added. To prevent spam,
133     // a user must wait delay before adding another user.
134     function addUser(address new_user, uint new_user_time)
135         public
136         onlyActiveUsersAllowed()
137     {
138         require(users[new_user].time_added == 0);
139         require(users[new_user].time_removed == 0);
140 
141         User storage sender = users[msg.sender];
142         require(now > sender.delay + sender.time_added_another_user);
143         require(new_user_time >= sender.delay);
144 
145         sender.time_added_another_user = now;
146         users[new_user] = User({
147             delay: new_user_time,
148             time_added: now,
149             added_by: msg.sender,
150             time_removed: 0,
151             removed_by: 0x0,
152             // The new user will have to wait one delay before being
153             // able to add a new user.
154             time_added_another_user: now
155         });
156         userAddresses.push(new_user);
157     }
158 
159     // Removes a user. The sender must have a lower or equal delay
160     // as the user that she is trying to remove.
161     function removeUser(address userAddr)
162         public
163         onlyActiveUsersAllowed()
164     {
165         require(users[userAddr].time_added != 0);
166         require(users[userAddr].time_removed == 0);
167 
168         User storage sender = users[msg.sender];
169         require(sender.delay <= users[userAddr].delay);
170 
171         users[userAddr].removed_by = msg.sender;
172         users[userAddr].time_removed = now;
173     }
174 }
175 
176 contract TrustWalletFactory {
177     mapping (address => TrustWallet[]) public wallets;
178 
179     function createWallet() public {
180         wallets[msg.sender].push(new TrustWallet(msg.sender));
181     }
182 }