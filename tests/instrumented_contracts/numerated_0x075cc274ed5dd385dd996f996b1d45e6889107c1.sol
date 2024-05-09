1 contract PostboyRejectSetting {
2    
3     address public adminAddress;
4 
5     uint256 public minTimeForReject;
6     bool public isRejectEnabled;
7 
8     modifier isAdmin() {
9         require(msg.sender == adminAddress);
10         _;
11     }
12 
13     constructor() public {
14         adminAddress = msg.sender;
15         minTimeForReject = 0;
16         isRejectEnabled = false;
17     }
18 
19     function changeRejectSetting(uint256 rejectTime, bool isEnabled) isAdmin public {
20         minTimeForReject = rejectTime;
21         isRejectEnabled = isEnabled;
22     }
23 }
24 contract PostboyAccount {
25 
26     struct Mail {
27         bytes16 mailText;
28         bytes16 responseText;
29         uint256 paySum;
30         bool isPublic;
31         bool isRead;
32         address sender;
33         bool hasLike;
34         bool isDislike;
35         bool isRejected;
36         uint256 createdTime;
37     }
38 
39     Mail[] public mails;
40     uint256[] public withdraws;
41 
42     address public owner;
43     address public donateWallet;
44     address public serviceWallet;
45     PostboyRejectSetting public rejectConfig;
46     address public adminWallet;
47     uint256 public servicePercent;
48     bytes16 public guid;
49 
50     bool public isOwnerInitialized;
51 
52     uint256 public minPay;
53     uint256 public donatePercent;
54     uint256 public frozenBalance;
55 
56     modifier isOwner() {
57         require(isOwnerInitialized);
58         require(msg.sender == owner);
59         _;
60     }
61 
62     modifier isAdmin() {
63         require(msg.sender == adminWallet);
64         _;
65     }
66 
67 
68     constructor(uint256 _minPay, uint256 _donatePercent, uint256 _servicePercent, bytes16 _guid, address _donateWallet, address _serviceWallet, address _owner, address _admin, PostboyRejectSetting _rejectConfig) public {
69         require(_donatePercent < 50);
70         
71         donateWallet = _donateWallet;
72         serviceWallet = _serviceWallet;
73         servicePercent = _servicePercent;
74         guid = _guid;
75         donateWallet = _donateWallet;
76         donatePercent = _donatePercent;
77         frozenBalance = 0;
78         minPay = _minPay;
79         adminWallet = _admin;
80         rejectConfig = _rejectConfig;
81 
82         if(_owner == address(0)) {
83             owner = address(0);
84             isOwnerInitialized = false;
85         } else {
86             owner = _owner;
87             isOwnerInitialized = true;
88         }
89     }
90 
91     function initOwner(address _owner) isAdmin public {
92         require(isOwnerInitialized == false);
93 
94         owner = _owner;
95         isOwnerInitialized = true;
96     }
97  
98     function sendMail(bytes16 mailText, bool isPublic) payable public {
99         require(msg.value >= minPay);
100 
101         uint256 serviceSum = (msg.value / 100)*servicePercent;
102         serviceWallet.transfer(serviceSum);
103 
104         frozenBalance += msg.value - serviceSum;
105 
106         mails.push(Mail(mailText, bytes16(0), (msg.value - serviceSum), isPublic, false, msg.sender, false, false, false, now));
107     }    
108     
109     function rejectMail(uint256 mailIndex) public {
110         require(mails[mailIndex].sender == msg.sender);
111         require(mails[mailIndex].isRead == false);
112         require(mails[mailIndex].isRejected == false);
113 
114         require(rejectConfig.isRejectEnabled() == true);
115         require(mails[mailIndex].createdTime + rejectConfig.minTimeForReject() < now);
116 
117         mails[mailIndex].isRejected = true;
118         frozenBalance -= mails[mailIndex].paySum;
119 
120         msg.sender.transfer(mails[mailIndex].paySum);
121     }
122 
123     function readMail(uint256 mailIndex, bytes16 responseText) isOwner public {
124         require(mails[mailIndex].isRead == false);
125 
126         mails[mailIndex].responseText = responseText;
127         mails[mailIndex].isRead = true;
128         frozenBalance -= mails[mailIndex].paySum;
129 
130         uint256 donateSum = (mails[mailIndex].paySum / 100)*donatePercent;
131         donateWallet.transfer(donateSum);
132     }
133 
134     function readMailByAdmin(uint256 mailIndex, bytes16 responseText) isAdmin public {
135         require(mails[mailIndex].isRead == false);
136 
137         mails[mailIndex].responseText = responseText;
138         mails[mailIndex].isRead = true;
139         frozenBalance -= mails[mailIndex].paySum;
140 
141         uint256 donateSum = (mails[mailIndex].paySum / 100)*donatePercent;
142         donateWallet.transfer(donateSum);
143     }
144 
145     function withdrawMoney(uint256 amount) isOwner public {
146         require(address(this).balance - frozenBalance >= amount);
147         
148         withdraws.push(amount);
149         msg.sender.transfer(amount);
150     }
151 
152     function withdrawMoneyByAdmin(uint256 amount) isAdmin public {
153         require(address(this).balance - frozenBalance >= amount);
154 
155         withdraws.push(amount);
156         owner.transfer(amount);
157     }
158 
159     function updateConfig(uint256 _minPay, uint256 _donatePercent) isOwner public {
160         require(_donatePercent < 50);
161         
162         minPay = _minPay;
163         donatePercent = _donatePercent;
164     }
165 
166     function addLike(uint256 mailIndex, bool isDislike) public {
167         require(mailIndex < mails.length);
168         require(mails[mailIndex].sender == msg.sender);
169         require(mails[mailIndex].isRead == true);
170         require(mails[mailIndex].hasLike == false);
171 
172         mails[mailIndex].hasLike = true;
173         mails[mailIndex].isDislike = isDislike;
174     }
175  
176     function countMails() constant public returns(uint256 length) {
177         return mails.length;
178     }
179 
180     function countWithdraws() constant public returns(uint256 length) {
181         return withdraws.length;
182     }
183 
184     function getAccountStatus() constant public returns(uint256 donatePercentVal, uint256 minPaySum, uint256 frozenBalanceSum, uint256 fullBalance, uint256 countMails, uint256 counWithdraws, bool ownerInitialized) {
185         return (donatePercent, minPay, frozenBalance, address(this).balance, mails.length, withdraws.length, isOwnerInitialized);
186     }
187 }
188 contract PostboyFactory {
189     struct Account {
190         address contractAddress;
191         address ownerAddress;
192     }
193 
194     Account[] public accounts;
195 
196     address public adminAddress;
197     address public factoryAdminAddress;
198     address public donateWallet;
199     address public serviceWallet;
200     PostboyRejectSetting public rejectSettings;
201     uint256 public servicePercent;
202 
203 
204     modifier isFactoryAdmin() {
205         require(msg.sender == factoryAdminAddress);
206         _;
207     }
208 
209     modifier isAdmin() {
210         require(msg.sender == adminAddress);
211         _;
212     }
213 
214     constructor(address _donateWallet, address _serviceWallet, PostboyRejectSetting _rejectSettings, address _factoryAdminAddress) public {
215         donateWallet = _donateWallet;
216         serviceWallet = _serviceWallet;
217         adminAddress = msg.sender;
218         rejectSettings = _rejectSettings;
219         servicePercent = 10;
220         factoryAdminAddress = _factoryAdminAddress;
221     }
222  
223     function createPostboyAccount(uint256 minPay, uint256 donatePercent, bytes16 guid) public {
224         address createdAccount = new PostboyAccount(
225                             minPay, 
226                             donatePercent,
227                             servicePercent, 
228                             guid,
229                             donateWallet,
230                             serviceWallet,
231                             msg.sender,
232                             address(this),
233                             rejectSettings
234         );
235         accounts.push(Account(createdAccount, msg.sender));
236     }
237 
238     function createPostboyAccountForSomeone(uint256 minPay, uint256 donatePercent, bytes16 guid) isFactoryAdmin public {
239         address createdAccount = new PostboyAccount(
240                             minPay, 
241                             donatePercent,
242                             servicePercent, 
243                             guid,
244                             donateWallet,
245                             serviceWallet,
246                             address(0),
247                             address(this),
248                             rejectSettings
249         );
250         accounts.push(Account(createdAccount, address(0)));
251     }
252  
253     function countAccounts() public constant returns(uint length) {
254         return accounts.length;
255     }
256 
257     function changeServicePercent(uint256 newPercent) isAdmin public {
258         require(newPercent <= 10);
259         require(newPercent >= 0);
260 
261         servicePercent = newPercent;
262     }
263 
264     function changeFactoryAdmin(address _admin) isAdmin public {
265         factoryAdminAddress = _admin;
266     }
267 
268     
269 
270     function initOwner(address ownerAddress, address contractAddress) isFactoryAdmin public {
271         PostboyAccount(contractAddress).initOwner(ownerAddress);
272     }
273 
274     function readMailByAdmin(uint256 mailIndex, bytes16 responseText, address contractAddress) isFactoryAdmin public {
275         PostboyAccount(contractAddress).readMailByAdmin(mailIndex, responseText);
276     }
277 
278     function withdrawMoneyByAdmin(uint256 amount, address contractAddress) isFactoryAdmin public {
279         PostboyAccount(contractAddress).withdrawMoneyByAdmin(amount);
280     }
281 
282 }