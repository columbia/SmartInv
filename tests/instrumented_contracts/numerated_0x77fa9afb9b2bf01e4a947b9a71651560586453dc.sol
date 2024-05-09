1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-12
3 */
4 
5 //................................................................
6 //.....SSSSSSSSSSS......EEEEEEEEEEEEEEEEEE........AAAAAAAA........
7 //....SSSSSSSSSSSSSS....EEEEEEEEEEEEEEEEEE........AAAAAAAA........
8 //...SSSSSSSSSSSSSSS....EEEEEEEEEEEEEEEEEE.......AAAAAAAAA........
9 //...SSSSSSSSSSSSSSSS...EEEEEEEEEEEEEEEEEE.......AAAAAAAAAA.......
10 //..SSSSSSSS.SSSSSSSS...EEEEEE...................AAAAAAAAAA.......
11 //..SSSSSS.....SSSSSS...EEEEEE..................AAAAAAAAAAA.......
12 //..SSSSSSS.............EEEEEE..................AAAAAAAAAAAA......
13 //..SSSSSSSSS...........EEEEEE.................AAAAAA.AAAAAA......
14 //..SSSSSSSSSSSS........EEEEEE.................AAAAAA.AAAAAA......
15 //...SSSSSSSSSSSSSS.....EEEEEEEEEEEEEEEEE......AAAAAA..AAAAAA.....
16 //....SSSSSSSSSSSSSS....EEEEEEEEEEEEEEEEE.....AAAAAA...AAAAAA.....
17 //.....SSSSSSSSSSSSSS...EEEEEEEEEEEEEEEEE.....AAAAAA...AAAAAAA....
18 //.......SSSSSSSSSSSSS..EEEEEEEEEEEEEEEEE.....AAAAAA....AAAAAA....
19 //...........SSSSSSSSS..EEEEEE...............AAAAAAAAAAAAAAAAA....
20 //.............SSSSSSS..EEEEEE...............AAAAAAAAAAAAAAAAAA...
21 //.SSSSSS.......SSSSSS..EEEEEE...............AAAAAAAAAAAAAAAAAA...
22 //..SSSSSS......SSSSSS..EEEEEE..............AAAAAAAAAAAAAAAAAAA...
23 //..SSSSSSSS..SSSSSSSS..EEEEEE..............AAAAAA.......AAAAAAA..
24 //..SSSSSSSSSSSSSSSSSS..EEEEEEEEEEEEEEEEEE.AAAAAA.........AAAAAA..
25 //...SSSSSSSSSSSSSSSS...EEEEEEEEEEEEEEEEEE.AAAAAA.........AAAAAA..
26 //....SSSSSSSSSSSSSS....EEEEEEEEEEEEEEEEEE.AAAAAA.........AAAAAA..
27 //.....SSSSSSSSSSSS.....EEEEEEEEEEEEEEEEEE.AAAAA...........AAAAA..
28 //................................................................
29 
30 
31 // SPDX-License-Identifier: MIT
32 pragma solidity 0.8.9;
33 
34 interface IERC20 {
35     event Approval(
36         address indexed owner,
37         address indexed spender,
38         uint256 value
39     );
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     function name() external view returns (string memory);
44 
45     function symbol() external view returns (string memory);
46 
47     function decimals() external view returns (uint8);
48 
49     function totalSupply() external view returns (uint256);
50 
51     function balanceOf(address owner) external view returns (uint256);
52 
53     function allowance(address owner, address spender)
54         external
55         view
56         returns (uint256);
57 
58     function approve(address spender, uint256 value) external;
59 
60     function transfer(address to, uint256 value) external;
61 
62     function transferFrom(
63         address from,
64         address to,
65         uint256 value
66     ) external;
67 }
68 
69 contract SEA {
70     IERC20 public usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
71 
72     address public admin = 0xE4a5c6730Bc5a2eEcA95bEe21b44c075Db02A892;
73     address public registerer = 0xD6a4E44ED60D96701041Ee2f1E00B3E0069F6616;
74     address public BOT_A = 0xAe67CE453947501fe35365D54CD91B0cE883954c;
75     address public BOT_B = 0xD92f1Ed3FE687eB7D447017eD154827A77F6a91A;
76     address public companyWallet = 0x276BB2894F30898fD6f3DdA3BA5cd752C0FF205e;
77 
78     uint256 public totalUsers;
79     uint256 public registrationFee1;
80     uint256 public registrationFee2;
81 
82     mapping(address => User) public user;
83     mapping(address => Register) public registered;
84     mapping(address => bool) public isAuthorized;
85     mapping(address => uint256) public approvedAmount;
86     mapping(address => bool) public paid;
87 
88     mapping(string => uint256) public plan;
89       string[] plannames = ["BASIC0250",
90                             "BASIC0500","BASIC01000", "MIX02000", "MIX04000", "MIX06000", "MIX08000", 
91                            "BUSINESS010000", "BUSINESS015000", "BUSINESS020000", "BUSINESS025000", "EMPIRE01000", "EMPIRE02000", 
92                            "EMPIRE04000", "EMPIRE06000", "EMPIRE08000", "EMPIRE010000", "EMPIRE015000", "EMPIRE020000", "EMPIRE025000",
93                             "POSEIDON01000", "POSEIDON02000", "POSEIDON04000", "POSEIDON06000", "POSEIDON08000", "POSEIDON010000", 
94                             "POSEIDON015000", "POSEIDON020000", "POSEIDON025000", "POSEIDON050000", "POSEIDON0100000", "BASIC100250", 
95                             "BASIC100500", "BASIC1001000" ,"BASIC250250", "BASIC250500", "BASIC2501000", "MIX20002000", 
96                             "MIX20004000", "MIX20006000", "MIX20008000", "BUSINESS1000010000", "BUSINESS1000015000", 
97                             "BUSINESS1000020000", "BUSINESS1000025000", "EMPIRE10001000", "EMPIRE10002000", "EMPIRE10004000", 
98                             "EMPIRE10006000", "EMPIRE10008000", "EMPIRE100010000", "EMPIRE100015000", "EMPIRE100020000", 
99                             "EMPIRE100025000", "POSEIDON10001000", "POSEIDON10002000", "POSEIDON10004000", "POSEIDON10006000",
100                              "POSEIDON10008000", "POSEIDON100010000", "POSEIDON100015000", "POSEIDON100020000", "POSEIDON100025000",
101                               "POSEIDON100050000", "POSEIDON1000100000"];
102     
103       uint[] planvalues =  [250,500,1000,2000, 4000, 6000, 8000, 10000, 15000, 20000, 25000, 1000, 2000, 
104                            4000, 6000, 8000, 10000, 15000, 20000, 25000,
105                             1000, 2000, 4000, 6000, 8000, 10000, 
106                             15000, 20000, 25000, 50000, 100000, 250, 
107                             500, 1000 ,250, 500, 1000, 2000, 
108                             4000, 6000, 8000, 10000, 15000, 
109                             20000, 25000, 1000, 2000, 4000, 
110                             6000, 8000, 10000, 15000, 20000, 
111                             25000, 1000, 2000, 4000, 6000,
112                              8000, 10000, 15000, 20000, 25000,
113                               50000, 100000];
114     struct Register {
115         string name;
116         address UserAddress;
117         bool alreadyExists;
118     }
119 
120     struct User {
121         string name;
122         address userAddress;
123         uint256 amountDeposit;
124     }
125     modifier onlyAuthorized() {
126         require(isAuthorized[msg.sender] == true, "Not an Authorized");
127         _;
128         
129     }
130     modifier onlyRegisterer() {
131         require(msg.sender == registerer, "Not an Authorized");
132         _;
133     }
134     event Deposit(address user, uint256 amount);
135 
136     constructor(
137         // address _admin,
138         // address _registerer,
139         // address _usdt,
140         // address _BOT_A,
141         // address _BOT_B,
142         // address _Company
143     ) {
144         // admin = _admin;
145         // registerer = _registerer;
146         isAuthorized[admin] = true;
147         isAuthorized[registerer] = true;
148         // BOT_A = _BOT_A;
149         // BOT_B = _BOT_B;
150         // companyWallet = _Company;
151         // usdt = IERC20(_usdt);
152         registrationFee1 = 45 * 10**usdt.decimals();
153         registrationFee2 = 27 * 10**usdt.decimals();
154 
155     for(uint i; i<plannames.length; i++){
156             plan[plannames[i]] = planvalues[i];
157         }
158 
159         
160 
161 
162     }
163 
164     function register(string memory _name, address users)
165         public
166         onlyRegisterer
167     {
168         require(!registered[users].alreadyExists, "User already registered");
169         registered[users].name = _name;
170         registered[users].UserAddress = users;
171         registered[users].alreadyExists = true;
172     }
173 
174     function addRegisterData(string memory _name, address users)
175         public
176         onlyAuthorized
177     {
178         require(!registered[users].alreadyExists, "User already registered");
179         registered[users].name = _name;
180         registered[users].UserAddress = users;
181         registered[users].alreadyExists = true;
182     }
183 
184     function updateRegisterData2(
185         string memory _name,
186         address newUser
187     ) public  {
188         require(registered[msg.sender].alreadyExists, "User not registered");
189         require(!registered[newUser].alreadyExists, "User already registered");
190         registered[newUser].name = _name;
191         registered[newUser].UserAddress = newUser;
192         registered[newUser].alreadyExists = true;
193         user[newUser] = user[msg.sender];
194         approvedAmount[newUser] = approvedAmount[msg.sender];
195         isAuthorized[newUser] = isAuthorized[msg.sender];
196         paid[newUser] = paid[msg.sender];
197         delete registered[msg.sender];
198         delete user[msg.sender];
199         delete approvedAmount[msg.sender];
200         delete isAuthorized[msg.sender];
201         delete paid[msg.sender];
202 
203     }
204 
205     function DeletRegisterData(address users) public onlyAuthorized {
206         delete registered[users];
207         paid[users]  = false;
208     }
209 
210     function deposit(
211         uint256 amount,
212         string memory _name,
213         string memory _planname
214     ) public {
215         require(plan[_planname] > 0, "plan not found");
216         require(amount >= 0, "amount should be more than 0");
217         require(
218             amount == plan[_planname] * (10**usdt.decimals()),
219             "amount should be according to the plan"
220         );
221         require(registered[msg.sender].alreadyExists, "User not registered");
222         uint256 trasnferamount;
223         if (!paid[msg.sender]) {
224             trasnferamount = registrationFee1;
225             paid[msg.sender] = true;
226         } else {
227             trasnferamount = registrationFee2;
228         }
229         usdt.transferFrom(msg.sender, BOT_A, amount);
230         usdt.transferFrom(msg.sender, companyWallet, trasnferamount);
231 
232         user[msg.sender].name = _name;
233         user[msg.sender].userAddress = msg.sender;
234         user[msg.sender].amountDeposit =
235             user[msg.sender].amountDeposit +
236             (amount);
237         emit Deposit(msg.sender, amount);
238     }
239 
240     function AuthorizeUser(address _user, bool _state) public {
241         require(admin == msg.sender, "Only admin can authorize user");
242         isAuthorized[_user] = _state;
243     }
244 
245     function distribute(address[] memory recivers, uint256[] memory amount)
246         public
247         onlyAuthorized
248     {
249         require(recivers.length == amount.length, "unMatched Data");
250 
251         for (uint256 i; i < recivers.length; i++) {
252             require(
253                 registered[recivers[i]].alreadyExists,
254                 "User not registered"
255             );
256             approvedAmount[recivers[i]] += amount[i]; 
257         }
258     }
259 
260     function claim() public {
261         require(approvedAmount[msg.sender] > 0, "not authorized");
262         uint256 amount = approvedAmount[msg.sender];
263         usdt.transfer( msg.sender, amount);
264         approvedAmount[msg.sender] = 0;
265     }
266 
267     function changeAdmin(address newAdmin) public {
268         require(msg.sender == admin, "Not an admin");
269         admin = newAdmin;
270     }
271 
272     function changeToken(address newToken) public onlyAuthorized {
273         usdt = IERC20(newToken);
274     }
275 
276     function changeBOT_A(address newBOT_A) public onlyAuthorized {
277         BOT_A = newBOT_A;
278     }
279 
280     function changeBOT_B(address newBOT_B) public onlyAuthorized {
281         BOT_B = newBOT_B;
282     }
283 
284     function changeCompanyWallet(address newCompany) public onlyAuthorized {
285         companyWallet = newCompany;
286     }
287 
288     function changeregistrer(address newRegistrar) public onlyAuthorized {
289         registerer = newRegistrar;
290     }
291 
292     function setplan(string calldata _planname, uint256 amount)
293         public
294         onlyAuthorized
295     {
296         require(plan[_planname] > 0, "plan not found");
297         plan[_planname] = amount;
298     }
299 
300     function addplan(string calldata _planname, uint256 amount)
301         public
302         onlyAuthorized
303     {
304         require(!checkplanexists(_planname), "plan already exists");
305         plan[_planname] = amount;
306         plannames.push(_planname);
307     }
308 
309     function changeregiestrationFee1(uint256 amount) public onlyAuthorized {
310         registrationFee1 = amount;
311     }
312 
313     function changeregiestrationFee2(uint256 amount) public onlyAuthorized {
314         registrationFee2 = amount;
315     }
316 
317     function checkplanexists(string memory _planname)
318         public
319         view
320         returns (bool val)
321     {
322         for (uint256 i = 0; i < plannames.length; i++) {
323             if (keccak256(bytes(plannames[i])) == keccak256(bytes(_planname))) {
324                 return true;
325             }
326         }
327     }
328 
329     function getplannames() public view returns (string[] memory names) {
330         return plannames;
331     }
332 
333     function removeplan(string memory _planname) public onlyAuthorized {
334         require(checkplanexists(_planname), "plan not found");
335         for (uint256 i = 0; i < plannames.length; i++) {
336             if (keccak256(bytes(plannames[i])) == keccak256(bytes(_planname))) {
337                 delete plannames[i];
338                 delete plan[_planname];
339                 return;
340             }
341         }
342     }
343 
344     function withdrawStukFunds(IERC20 token) public onlyAuthorized {
345         token.transfer(msg.sender, token.balanceOf(address(this)));
346     }
347     function withdrawStuckFunds() public onlyAuthorized {
348         payable(msg.sender).transfer(address(this).balance);
349     }
350     
351 }