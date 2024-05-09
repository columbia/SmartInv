1 contract Owned {
2 
3     address public owner;
4     mapping (address => bool) public isAdmin;
5 
6     function Owned() {
7         owner = msg.sender;
8         isAdmin[msg.sender] = true;
9     }
10 
11     modifier onlyOwner {
12         if (msg.sender != owner) throw;
13         _;
14     }
15 
16     modifier onlyAdmin() {
17         assert(isAdmin[msg.sender]);
18         _;
19     }
20 
21     function addAdmin(address user) onlyAdmin {
22         isAdmin[user] = true;
23     }
24 
25     function removeAdmin(address user) onlyAdmin {
26         if (user == owner) {
27             throw; //cant remove the owner
28         }
29         isAdmin[user] = false;
30     }
31 
32     function transferOwnership(address newOwner) onlyOwner {
33         owner = newOwner;
34     }
35 
36 
37 }
38 
39 
40 contract SoupToken is Owned {
41 
42 
43     string public standard = 'SoupToken 30/06';
44 
45     string public name;
46 
47     string public symbol;
48 
49     uint256 public totalSupply;
50 
51     uint public minBalanceForAccounts = 5 finney;
52 
53     mapping (address => uint256) public balanceOf;
54 
55     mapping (uint => address[]) public ordersFor;
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58 
59     event Burn(address indexed from, uint256 value);
60 
61     event BurnFrom(address _from, uint256 _value);
62 
63     event LogDepositReceived(address sender);
64 
65     function SoupToken(string tokenName, string tokenSymbol) payable {
66         name = tokenName;
67         // Set the name for display purposes
68         symbol = tokenSymbol;
69         // Set the symbol for display purposes
70     }
71 
72     function() payable {
73         LogDepositReceived(msg.sender);
74     }
75 
76     function mintToken(address target, uint256 mintedAmount) onlyAdmin {
77         balanceOf[target] += mintedAmount;
78         totalSupply += mintedAmount;
79         Transfer(0, owner, mintedAmount);
80         Transfer(owner, target, mintedAmount);
81         if (target.balance < minBalanceForAccounts) target.transfer(minBalanceForAccounts - target.balance);
82     }
83 
84     function transfer(address _to, uint256 _value){
85         if (_to == 0x0) throw;
86         // Prevent transfer to 0x0 address. Use burn() instead
87         if (balanceOf[msg.sender] < _value) throw;
88         // Check if the sender has enough
89         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
90         // Check for overflows
91         balanceOf[msg.sender] -= _value;
92         // Subtract from the sender
93         balanceOf[_to] += _value;
94         // Add the same to the recipient
95         Transfer(msg.sender, _to, _value);
96         // Notify anyone listening that this transfer took place
97     }
98 
99     function transferFrom(address _from, address _to, uint256 _value) onlyAdmin returns (bool success){
100         if (_to == 0x0) throw;
101         // Prevent transfer to 0x0 address. Use burn() instead
102         if (balanceOf[_from] < _value) throw;
103         // Check if the sender has enough
104         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
105         // Check for overflows
106         balanceOf[_from] -= _value;
107         // Subtract from the sender
108         balanceOf[_to] += _value;
109         // Add the same to the recipient
110         Transfer(_from, _to, _value);
111         return true;
112     }
113 
114     function burnFrom(address _from, uint256 _value) onlyAdmin returns (bool success) {
115         if (balanceOf[_from] < _value) throw;
116         // Check if the sender has enough
117         balanceOf[_from] -= _value;
118         // Subtract from the sender
119         totalSupply -= _value;
120         // Updates totalSupply
121         Burn(_from, _value);
122         return true;
123     }
124 
125     function checkIfAlreadyOrderedForDay(uint day, address user) internal constant returns (bool){
126         var orders = ordersFor[day];
127         for (uint i = 0; i < orders.length; i++) {
128             if (orders[i] == user) {
129                 return true;
130             }
131         }
132         return false;
133     }
134 
135     function findOrderIndexForAddress(uint day, address user) internal constant returns (uint){
136         var orders = ordersFor[day];
137         for (uint i = 0; i < orders.length; i++) {
138             if (orders[i] == user) {
139                 return i;
140             }
141         }
142         //this throw will never be reached. This function is only called for users
143         //where we absolutely know they are in the list
144         throw;
145     }
146 
147     function orderForDays(bool[] weekdays) returns (bool success) {
148 
149         uint totalOrders = 0;
150         for (uint i = 0; i < weekdays.length; i++) {
151             var isOrdering = weekdays[i];
152             //check if the user already ordered for that day
153             if (checkIfAlreadyOrderedForDay(i, msg.sender)) {
154                 //if so we remove the order if the user changed his mind
155                 if (!isOrdering) {
156                     var useridx = findOrderIndexForAddress(i, msg.sender);
157                     delete ordersFor[i][useridx];
158                 }
159                 //if he still wants to buy for the change we dont do anything
160             }
161             else {
162                 if (isOrdering) {
163                     //add the user to the list of purchases that day
164                     ordersFor[i].push(msg.sender);
165                     totalOrders++;
166                 }
167                 //do nothing otherwise
168             }
169             // rollback transaction if totalOrders exceeds balance
170             if (balanceOf[msg.sender] < totalOrders) {
171                 throw;
172             }
173         }
174         return true;
175     }
176 
177     function burnSoupTokensForDay(uint day) onlyAdmin returns (bool success) {
178 
179         for (uint i = 0; i < ordersFor[day].length; i++) {
180             if (ordersFor[day][i] == 0x0) {
181                 continue;
182             }
183             burnFrom(ordersFor[day][i], 1);
184             delete ordersFor[day][i];
185         }
186         return true;
187     }
188 
189     function getOrderAddressesForDay(uint day) constant returns (address[]) {
190         return ordersFor[day];
191     }
192 
193     function getAmountOrdersForDay(uint day) constant returns (uint){
194         return ordersFor[day].length;
195     }
196 
197     function setMinBalance(uint minimumBalanceInFinney) onlyAdmin {
198         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
199     }
200 
201     function kill() onlyOwner {
202         suicide(owner);
203     }
204 
205 
206 }