1 pragma solidity 0.4.18;
2 
3 /// @title Fund Wallet - Fund raising and distribution wallet according to stake and incentive scheme.
4 /// @dev Not fully tested, use only in test environment.
5 
6 
7 interface ERC20 {
8     function totalSupply() public view returns (uint supply);
9     function balanceOf(address _owner) public view returns (uint balance);
10     function transfer(address _to, uint _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
12     function approve(address _spender, uint _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public view returns (uint remaining);
14     function decimals() public view returns(uint digits);
15     event Approval(address indexed _owner, address indexed _spender, uint _value);
16 }
17 
18 contract FwPermissions {
19 
20   address public admin;
21   address public backupAdmin;
22   //Kyber Reserve contract address
23   address public reserve;
24   bool public timePeriodsSet;
25   bool public adminStaked;
26   bool public endBalanceLogged;
27   mapping (address => bool) public isContributor;
28   mapping (address => bool) public hasClaimed;
29   address[] public contributors;
30   //experimental time periods
31   uint public start;
32   uint public adminP;
33   uint public raiseP;
34   uint public opperateP;
35   uint public liquidP;
36 
37   function FwPermissions() public {
38         admin = msg.sender;
39   }
40 
41   //modifiers
42   modifier onlyAdmin() {
43       require(msg.sender == admin);
44       _;
45   }
46 
47   modifier onlyBackupAdmin() {
48       require(msg.sender == backupAdmin);
49       _;
50   }
51 
52   modifier timePeriodsNotSet() {
53       require(timePeriodsSet == false);
54       _;
55   }
56 
57   modifier timePeriodsAreSet() {
58       require(timePeriodsSet == true);
59       _;
60   }
61 
62   modifier onlyReserve() {
63       require(msg.sender == reserve);
64       _;
65   }
66 
67   modifier onlyContributor() {
68       require(isContributor[msg.sender]);
69       _;
70   }
71 
72   modifier adminHasStaked() {
73       require(adminStaked == true);
74       _;
75   }
76 
77   modifier adminHasNotStaked() {
78       require(adminStaked == false);
79       _;
80   }
81 
82   modifier endBalanceNotLogged() {
83       require(endBalanceLogged == false);
84       _;
85   }
86 
87   modifier endBalanceIsLogged() {
88       require(endBalanceLogged == true);
89       _;
90   }
91 
92   modifier hasNotClaimed() {
93       require(!hasClaimed[msg.sender]);
94       _;
95   }
96 
97   modifier inAdminP() {
98       require(now < (start + adminP));
99       _;
100   }
101 
102   modifier inRaiseP() {
103       require(now < (start + adminP + raiseP) && now > (start + adminP));
104       _;
105   }
106 
107   modifier inOpperateP() {
108       require(now < (start + adminP + raiseP + opperateP) && now > (start + adminP + raiseP));
109       _;
110   }
111 
112   modifier inLiquidP() {
113       require(now < (start + adminP + raiseP + opperateP + liquidP) && now > (start + adminP + raiseP + opperateP));
114       _;
115   }
116 
117   modifier inOpAndLiqP() {
118       require(now < (start + adminP + raiseP + opperateP + liquidP) && now > (start + adminP + raiseP));
119       _;
120   }
121 
122   modifier inClaimP() {
123       require(now > (start + adminP + raiseP + opperateP + liquidP));
124       _;
125   }
126 }
127 
128 
129 contract FundWallet is FwPermissions {
130 
131     uint public adminStake;
132     uint public raisedBalance;
133     uint public endBalance;
134     mapping (address => uint) public stake;
135     //admin reward
136     uint public adminCarry; //in basis points (1% = 100bps)
137     
138     //eth address
139     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
140 
141     //events
142     event ContributorAdded(address _contributor);
143     event ContributorRemoval(address _contributor);
144     event ContributorDeposit(address sender, uint value);
145     event ContributorDepositReturn(address _contributor, uint value);
146     event AdminDeposit(address sender, uint value);
147     event AdminDepositReturned(address sender, uint value);
148     event TokenPulled(ERC20 token, uint amount, address sendTo);
149     event EtherPulled(uint amount, address sendTo);
150     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
151     event EtherWithdraw(uint amount, address sendTo);
152 
153 
154     /// @notice Constructor, initialises admin wallets.
155     /// @param _admin Is main opperator address.
156     /// @param _backupAdmin Is an address which can change the admin address - recommend cold wallet.
157     function FundWallet(address _admin, address _backupAdmin) public {
158         require(_admin != address(0));
159         require(_backupAdmin != address(0));
160         admin = _admin;
161         backupAdmin = _backupAdmin;
162     }
163 
164     /// @notice function to set the stake and incentive scheme for the admin;
165     /// @param _adminStake Is the amount that the admin will contribute to the fund.
166     /// @param _adminCarry The admins performance fee in profitable scenario, measured in basis points (1% = 100bps).
167     function setFundScheme(uint _adminStake, uint _adminCarry) public onlyAdmin inAdminP timePeriodsAreSet {
168         require(_adminStake > 0);
169         adminStake = _adminStake;
170         adminCarry = _adminCarry; //bps
171     }
172 
173     /// @notice function to set time periods.
174     /// @param _adminP The amount of time during which the admin can set fund parameters and add contributors.
175     /// @param _raiseP The amount of time during which contributors and admin can contribute to the fund. In minutes for testing.
176     /// @param _opperateP The amount of time during which the fund is actively trading/investing. In minutes for testing.
177     /// @param _liquidP The amount of time the admin has to liquidate the fund into base currency - Ether. In minutes for testing.
178     function setTimePeriods(uint _adminP, uint _raiseP, uint _opperateP, uint _liquidP) public onlyAdmin timePeriodsNotSet {
179         start = now;
180         adminP = _adminP * (60 minutes);
181         raiseP = _raiseP * (60 minutes);
182         opperateP = _opperateP * (60 minutes);
183         liquidP = _liquidP * (60 minutes);
184         timePeriodsSet = true;
185     }
186 
187     /// @dev set or change reserve address
188     /// @param _reserve the address of corresponding kyber reserve.
189     function setReserve (address _reserve) public onlyAdmin inAdminP timePeriodsAreSet {
190         reserve = _reserve;
191     }
192 
193     /// @notice Fallback function - recieves ETH but doesn't alter contributor stakes or raised balance.
194     function() public payable {
195     }
196 
197     /// @notice Function to change the admins address
198     /// @dev Only available to the back up admin.
199     /// @param _newAdmin address of the new admin.
200     function changeAdmin(address _newAdmin) public onlyBackupAdmin {
201         admin = _newAdmin;
202     }
203 
204     /// @notice Function to add contributor address.
205     /// @dev Only available to admin and in the raising period.
206     /// @param _contributor Address of the new contributor.
207     function addContributor(address _contributor) public onlyAdmin inAdminP timePeriodsAreSet {
208         require(!isContributor[ _contributor]); //only new contributor
209         require(_contributor != admin);
210         isContributor[ _contributor] = true;
211         contributors.push( _contributor);
212         ContributorAdded( _contributor);
213     }
214 
215     /// @notice Function to remove contributor address.
216     /// @dev Only available to admin and in the raising period. Returns balance of contributor if they have deposited.
217     /// @param _contributor Address of the contributor to be removed.
218     function removeContributor(address _contributor) public onlyAdmin inAdminP timePeriodsAreSet {
219         require(isContributor[_contributor]);
220         isContributor[_contributor] = false;
221         for (uint i=0; i < contributors.length - 1; i++)
222             if (contributors[i] == _contributor) {
223                 contributors[i] = contributors[contributors.length - 1];
224                 break;
225             }
226         contributors.length -= 1;
227         ContributorRemoval(_contributor);
228     }
229 
230     /// @notice Function to get contributor addresses.
231     function getContributors() public constant returns (address[]){
232         return contributors;
233     }
234 
235     /// @notice Function for contributor to deposit funds.
236     /// @dev Only available to contributors after admin had deposited their stake, and in the raising period.
237     function contributorDeposit() public timePeriodsAreSet onlyContributor adminHasStaked inRaiseP payable {
238         if (adminStake >= msg.value && msg.value > 0 && stake[msg.sender] < adminStake) {
239             raisedBalance += msg.value;
240             stake[msg.sender] += msg.value;
241             ContributorDeposit(msg.sender, msg.value);
242         }
243         else {
244             revert();
245         }
246     }
247 
248     /// @notice Function for contributor to reclaim their deposit.
249     /// @dev Only available to contributor in the raising period. Removes contributor on refund.
250     function contributorRefund() public timePeriodsAreSet onlyContributor inRaiseP {
251         isContributor[msg.sender] = false;
252         for (uint i=0; i < contributors.length - 1; i++)
253             if (contributors[i] == msg.sender) {
254                 contributors[i] = contributors[contributors.length - 1];
255                 break;
256             }
257         contributors.length -= 1;
258         ContributorRemoval(msg.sender);
259 
260         if (stake[msg.sender] > 0) {
261             msg.sender.transfer(stake[msg.sender]);
262             raisedBalance -= stake[msg.sender];
263             delete stake[msg.sender];
264             ContributorDepositReturn(msg.sender, stake[msg.sender]);
265         }
266     }
267 
268     /// @notice Function for admin to deposit their stake.
269     /// @dev Only available to admin and in the raising period.
270     function adminDeposit() public timePeriodsAreSet onlyAdmin adminHasNotStaked inRaiseP payable {
271         if (msg.value == adminStake) {
272             raisedBalance += msg.value;
273             stake[msg.sender] += msg.value;
274             adminStaked = true;
275             AdminDeposit(msg.sender, msg.value);
276         }
277         else {
278             revert();
279         }
280     }
281 
282     /// @notice Funtion for admin to reclaim their contribution/stake.
283     /// @dev Only available to admin and in the raising period and if admin is the only one who has contributed to the fund.
284     function adminRefund() public timePeriodsAreSet onlyAdmin adminHasStaked inRaiseP {
285         require(raisedBalance == adminStake);
286         admin.transfer(adminStake);
287         adminStaked = false;
288         raisedBalance -= adminStake;
289         AdminDepositReturned(msg.sender, adminStake);
290     }
291 
292     /// @notice Funtion for admin to withdraw ERC20 token while fund is opperating.
293     /// @dev Only available to admin and in the opperating period
294     function withdrawToken(ERC20 token, uint amount, address sendTo) external timePeriodsAreSet onlyAdmin inOpperateP {
295         require(token.transfer(sendTo, amount));
296         TokenWithdraw(token, amount, sendTo);
297     }
298 
299     /// @notice Funtion for admin to withdraw ether token while fund is opperating.
300     /// @dev Only available to admin and in the opperating period
301     function withdrawEther(uint amount, address sendTo) external timePeriodsAreSet onlyAdmin inOpperateP {
302         sendTo.transfer(amount);
303         EtherWithdraw(amount, sendTo);
304     }
305 
306     /// @notice Funtion to log the ending balance after liquidation period. Used as point of reference to calculate profit/loss.
307     /// @dev Only available in claim period and only available once.
308     function logEndBal() public inClaimP endBalanceNotLogged timePeriodsAreSet {
309         endBalance = address(this).balance;
310         endBalanceLogged = true;
311     }
312 
313     /// @notice Funtion for admin to calim their payout.
314     /// @dev Only available to admin in claim period and once the ending balance has been logged. Payout depends on profit or loss.
315     function adminClaim() public onlyAdmin timePeriodsAreSet inClaimP endBalanceIsLogged hasNotClaimed {
316         if (endBalance > raisedBalance) {
317             admin.transfer(((endBalance - raisedBalance)*(adminCarry))/10000); //have variable for adminReward
318             admin.transfer(((((endBalance - raisedBalance)*(10000-adminCarry))/10000)*adminStake)/raisedBalance); // profit share
319             admin.transfer(adminStake); //initial stake
320             hasClaimed[msg.sender] = true;
321         }
322         else {
323             admin.transfer((endBalance*adminStake)/raisedBalance);
324             hasClaimed[msg.sender] = true;
325         }
326     }
327 
328     /// @notice Funtion for contributor to claim their payout.
329     /// @dev Only available to contributor in claim period and once the ending balance has been logged. Payout depends on profit or loss.
330     function contributorClaim() public timePeriodsAreSet onlyContributor inClaimP endBalanceIsLogged hasNotClaimed {
331         if (endBalance > raisedBalance) {
332             msg.sender.transfer(((((endBalance - raisedBalance)*(10000-adminCarry))/10000)*stake[msg.sender])/raisedBalance); // profit share
333             msg.sender.transfer(stake[msg.sender]); //initial stake
334             hasClaimed[msg.sender] = true;
335         }
336         else {
337             msg.sender.transfer((endBalance*stake[msg.sender])/raisedBalance);
338             hasClaimed[msg.sender] = true;
339         }
340     }
341 
342     //functions to allow trading with reserve address
343 
344     /// @dev send erc20token to the reserve address
345     /// @param token ERC20 The address of the token contract
346     function pullToken(ERC20 token, uint amount) external onlyReserve inOpAndLiqP returns (bool){
347         require(token.transfer(reserve, amount));
348         TokenPulled(token, amount, reserve);
349         return true;
350     }
351 
352     ///@dev Send ether to the reserve address
353     function pullEther(uint amount) external onlyReserve inOpperateP returns (bool){
354         reserve.transfer(amount);
355         EtherPulled(amount, reserve);
356         return true;
357     }
358 
359     ///@dev function to check balance only returns balances in opperating and liquidating periods
360     function checkBalance(ERC20 token) public view returns (uint) {
361         if (now < (start + adminP +raiseP + opperateP) && now > (start + adminP + raiseP)) {
362             if (token == ETH_TOKEN_ADDRESS) {
363                 return this.balance;
364             }
365             else {
366                 return token.balanceOf(this);
367             }
368         }
369         if (now < (start + adminP + raiseP + opperateP + liquidP) && now > (start + adminP + raiseP + opperateP)) {
370             if (token == ETH_TOKEN_ADDRESS) {
371                 return 0;
372             }
373             else {
374                 return token.balanceOf(this);
375             }
376         }
377         else return 0;
378     }
379 
380 }