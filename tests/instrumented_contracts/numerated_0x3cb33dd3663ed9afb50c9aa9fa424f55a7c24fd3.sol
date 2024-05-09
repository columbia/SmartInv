1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         c = a + b;
6         require(c >= a);
7     }
8 
9     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         require(b <= a);
11         c = a - b;
12     }
13 
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract Queue {
26     using SafeMath for uint256;
27     address[] users;
28     mapping(address => bool) usersExist;
29     mapping(address => address) users2users;
30     mapping(address => uint256) collectBalances;
31     mapping(address => uint256) balances;
32     mapping(address => uint256) balancesTotal;
33     uint256 nextForwardUserId = 0;
34     uint256 nextBackUserId = 0;
35     uint256 cyles = 50;
36     uint256 interes = 10 finney;
37     uint256 reminder=0;
38     uint256 price = 20 finney;
39     uint256 referalBonus = 5 finney;
40     uint256 queueInteres = 100 szabo;
41     address to;
42     uint256 collect = 30 finney;
43     
44     event QueueStart(address indexed user, address indexed parentUser, uint256 indexed timeshtamp);
45     event BalanceUp(address indexed user, uint256 amount, uint256 indexed timeshtamp);
46     event GetMyMoney(address indexed user, uint256 amount, uint256 indexed timeshtamp);
47     
48     function () payable public {
49         msg.sender.transfer(msg.value);
50     }
51     
52     function startQueue(address parentUser) payable public {
53         require(msg.value == price);
54         require(msg.sender != address(0));
55         require(parentUser != address(0));
56         require(!usersExist[msg.sender]);
57         _queue(msg.sender, parentUser);
58     }
59     
60     function serchIndexByAddress(address a) public view returns (uint256 index) {
61         for(index=0; index<users.length; index++) {
62             if(a == users[index]){
63                 return index;
64             }
65         }
66     }
67     
68     function _removeIndex(uint256 indexToRemove) internal {
69         if (indexToRemove >= users.length) return;
70 
71         for (uint i = indexToRemove; i<users.length-1; i++){
72             users[i] = users[i+1];
73         }
74         delete users[users.length-1];
75         users.length--;
76     }
77     
78     function _queue(address user, address parentUser) internal {
79         if (user != address(0x9a965e5e9c3A0F062C80a7f3d1B0972201b2F19f) ) {
80             require(parentUser!=user);
81             require(usersExist[parentUser]);
82         }
83         users.push(user);
84         usersExist[user]=true;
85         users2users[user]=parentUser;
86         emit QueueStart(user, parentUser, now);
87         
88         if (collectBalances[parentUser].add(referalBonus) >= collect){
89             reminder = collectBalances[parentUser].add(referalBonus) - collect;
90             balancesTotal[parentUser] = balancesTotal[parentUser].add(interes);
91             balances[parentUser] = balances[parentUser].add(interes);
92             emit BalanceUp(parentUser, interes, now);
93             collectBalances[parentUser] = reminder;
94             to = parentUser;
95             _removeIndex(serchIndexByAddress(parentUser));
96             _queue(to, users2users[to]);
97         }else{
98             collectBalances[parentUser] = collectBalances[parentUser].add(referalBonus);
99         }
100         
101         if (collectBalances[users2users[parentUser]].add(referalBonus) >= collect){
102             reminder = collectBalances[users2users[parentUser]].add(referalBonus) - collect;
103             balancesTotal[users2users[parentUser]] = balancesTotal[users2users[parentUser]].add(interes);
104             balances[users2users[parentUser]] = balances[users2users[parentUser]].add(interes);
105             emit BalanceUp(users2users[parentUser], interes, now);
106             collectBalances[users2users[parentUser]] = reminder;
107             to = users2users[parentUser];
108             _removeIndex(serchIndexByAddress(users2users[parentUser]));
109             _queue(to, users2users[to]);
110         }else{
111             collectBalances[users2users[parentUser]] = collectBalances[users2users[parentUser]].add(referalBonus);
112         }
113         
114         uint256 length = users.length;
115         uint256 existLastIndex = length.sub(1);
116         uint256 firstHalfEnd = 0;
117         uint256 secondHalfStart = 0;
118         
119         if (length == 1 ){
120             collectBalances[users[0]] = collectBalances[users[0]].add(queueInteres.mul(cyles.mul(2)));
121         }else{
122             if (length % 2 != 0) {
123                 firstHalfEnd  = length.div(2);
124                 secondHalfStart  = length.div(2);
125             }else{
126                 firstHalfEnd  = length.div(2).sub(1);
127                 secondHalfStart  = length.div(2);
128             }
129             
130             for (uint i = 1; i <= cyles; i++) {
131                 if(collectBalances[users[nextForwardUserId]].add(queueInteres) >= collect){
132                     reminder = collectBalances[users[nextForwardUserId]].add(queueInteres) - collect;
133                     balancesTotal[users[nextForwardUserId]] = balancesTotal[users[nextForwardUserId]].add(interes);
134                     balances[users[nextForwardUserId]] = balances[users[nextForwardUserId]].add(interes);
135                     collectBalances[users[nextForwardUserId]] = reminder;
136                     emit BalanceUp(users[nextForwardUserId], interes, now);
137                     to = users[nextForwardUserId];
138                     _removeIndex(serchIndexByAddress(users[nextForwardUserId]));
139                     _queue(to, users2users[to]);
140                     if (nextForwardUserId == 0){
141                         nextForwardUserId = firstHalfEnd;
142                     }else{
143                         nextForwardUserId = nextForwardUserId.sub(1);
144                     }
145                 }else{
146                     collectBalances[users[nextForwardUserId]] = collectBalances[users[nextForwardUserId]].add(queueInteres);
147                 }
148                 if(collectBalances[users[nextBackUserId]].add(queueInteres) == collect){
149                     reminder = collectBalances[users[nextBackUserId]].add(queueInteres) - collect;
150                     balancesTotal[users[nextBackUserId]] = balancesTotal[users[nextBackUserId]].add(interes);
151                     balances[users[nextBackUserId]] = balances[users[nextBackUserId]].add(interes);
152                     collectBalances[users[nextBackUserId]] = reminder;
153                     emit BalanceUp(users[nextBackUserId], interes, now);
154                     to = users[nextBackUserId];
155                     _removeIndex(serchIndexByAddress(users[nextBackUserId]));
156                     _queue(to, users2users[to]);
157                     if (nextBackUserId == existLastIndex){
158                         nextBackUserId = secondHalfStart;
159                     }else{
160                         nextBackUserId = nextBackUserId.add(1);
161                     }
162                 }else{
163                     collectBalances[users[nextBackUserId]] = collectBalances[users[nextBackUserId]].add(queueInteres);
164                 }
165             }
166         }
167     }
168     
169     function getMyMoney() public {
170         require(balances[msg.sender]>0);
171         msg.sender.transfer(balances[msg.sender]);
172         emit GetMyMoney(msg.sender, balances[msg.sender], now);
173         balances[msg.sender]=0;
174     }
175     
176     function balanceOf(address who) public view returns (uint256 balance) {
177         return balances[who];
178     }
179     
180     function balanceTotalOf(address who) public view returns (uint256 balanceTotal) {
181         return balancesTotal[who];
182     }
183     
184     function getNextForwardUserId() public view returns (uint256) {
185         return nextForwardUserId;
186     }
187     
188     function getNextBackUserId() public view returns (uint256) {
189         return nextBackUserId;
190     }
191     
192     function getLastIndex() public view returns (uint256) {
193         uint256 length = users.length;
194         return length.sub(1);
195     }
196     
197     function getUserAddressById(uint256 id) public view returns (address userAddress) {
198         return users[id];
199     }
200     
201     function checkExistAddress(address user) public view returns (bool) {
202         return usersExist[user];
203     }
204     
205     function getParentUser(address user) public view returns (address) {
206         return users2users[user];
207     }
208 }