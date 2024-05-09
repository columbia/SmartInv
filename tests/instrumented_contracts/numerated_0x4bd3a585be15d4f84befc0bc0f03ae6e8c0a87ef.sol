1 pragma solidity >=0.4.21 <0.7.0;
2 
3 contract Besunray {
4   address payable public owner;
5   struct User { //Used to store user details
6     uint uid;
7     address payable wallet;
8     uint package;
9     uint256 etherValue;
10     address payable refferer;
11     uint level;
12     bool status;
13     uint commissions;
14   }
15   struct Plan { //Used to store commission configuration
16     uint level;
17     uint package;
18     uint percentage;
19   }
20   struct Qualification{
21     uint status;
22     uint level_1;
23     uint level_2;
24     uint level_3;
25     uint level_4;
26     uint level_5;
27     uint level_6;
28     uint level_7;
29     uint level_8;
30     uint level_9;
31     uint level_10;
32   }
33   mapping(address => User) private users;
34   mapping(address => Qualification) private qualifications;
35   mapping(uint => Plan) private plans;
36 
37   event DistributeCommission(
38     address to,
39     address from,
40     uint amount
41   );
42   event UserRegistration(
43     uint uid,
44     address wallet,
45     address refferer,
46     uint package,
47     uint256 etherValue,
48     uint256 commissions
49   );
50   event EmQualification(
51     address wallet,
52     uint level
53   );
54   event MissedCommission(
55     address to,
56     address from
57   );
58   event UserActivated(
59     address wallet,
60     bool status
61   );
62   event UserDeactivated(
63     address wallet,
64     bool status
65   );
66   event PackageUpgraded(
67     address wallet,
68     uint package,
69     uint256 _etherValue
70   );
71   event UserDetailsUpdated(
72     address _wallet,
73     uint _package,
74     uint256 _etherValue,
75     address _refferer
76   );
77   event DistributionStarted(
78       uint256 rid
79   );
80   event DistCommission(
81         address wallet,
82         uint256 amount,
83         uint256 rid
84     );
85   /**
86   * @dev Constructor sets admin.
87   *
88   * This is public constructor.
89   *
90   *
91   * Requirements:
92   *
93   * -
94   */
95   constructor() public {
96     owner = msg.sender;
97     plans[1] = Plan(1, 200, 10);
98     plans[2] = Plan(2, 200, 6);
99     plans[3] = Plan(3, 200, 4);
100     plans[4] = Plan(4, 200, 2);
101     plans[5] = Plan(5, 500, 2);
102     plans[6] = Plan(6, 500, 2);
103     plans[7] = Plan(7, 500, 1);
104     plans[8] = Plan(8, 500, 1);
105     plans[9] = Plan(9, 1000, 1);
106     plans[10] = Plan(10, 1000, 1);
107   }
108 /**
109   * @dev fallback for .
110   *
111   * This is public fallback.
112   *
113   *
114   * Requirements:
115   *
116   * -
117   */
118   function() external payable {}
119   /**
120   * @dev access modifier.
121   *
122   * restrict access this enables sensitive information available only for admin.
123   *
124   *
125   * Requirements:
126   *
127   * - `msg.sender` must be an admin.
128   */
129   modifier onlyAdmin() { //Admin modifier
130     require(
131       msg.sender == owner,
132       "This function can only invoked by admin"
133       );
134       _;
135   }
136   /**
137   * @dev register users in to blockchain.
138   *
139   * This is public function.
140   *
141   *
142   * Requirements:
143   *
144   * - `msg.sender` must be admin.
145   * - `_wallet` must be a valid address.
146   * - `_package` must be a valid address.
147   * - `_etherValue` must be a valid address.
148   * - `_status` must be a valid address.
149   */
150   function registerUser(
151     uint _uid,
152     address payable _wallet,
153     uint _package,
154     uint256 _etherValue,
155     address payable _refferer,
156     bool _status,
157     uint256 _commissions
158     ) private onlyAdmin {
159     require(users[_wallet].wallet != _wallet,"User is already registered");
160     uint level = users[_refferer].level + 1;
161     users[_wallet] = User(_uid, _wallet, _package,_etherValue, _refferer, level, _status, _commissions);
162     emit UserRegistration(_uid, _wallet, _refferer, _package, _etherValue, _commissions);
163   }
164   /**
165   * @dev Deactivate user
166   *
167   * This is public function onlyAdmin.
168   *
169   *
170   * Requirements:
171   *
172   * - `_wallet` should be a registered user.
173   */
174   function deactivateUser(address _wallet) private onlyAdmin {
175     require(users[_wallet].wallet == _wallet,"User is not registered in blockchain");
176     users[_wallet].status = false;
177     emit UserDeactivated(_wallet, false);
178   }
179   /**
180   * @dev Activate user
181   *
182   * This is public function onlyAdmin.
183   *
184   *
185   * Requirements:
186   *
187   * - `_wallet` should be a registered user.
188   */
189   function activateUser(address _wallet) private onlyAdmin {
190     require(users[_wallet].wallet == _wallet,"User is not registered in blockchain");
191     users[_wallet].status = true;
192     emit UserActivated(_wallet, true);
193   }
194   /**
195   * @dev Upgrade user package
196   * Access modified with OnlyAdmin
197   *
198   *
199   * Requirements:
200   *
201   * - `_wallet` should be a registered user.
202   * - `_package` should be a registered user.
203   */
204   function upgradePackage(address _wallet, uint _package, uint256 _etherValue) private onlyAdmin {
205     require(users[_wallet].wallet == _wallet,"User is not registered in blockchain");
206     require(users[_wallet].package < _package, 'perform upgarde only');
207     users[_wallet].package = _package;
208     users[_wallet].etherValue = _etherValue;
209     emit PackageUpgraded(_wallet, _package, _etherValue);
210   }
211 
212   /**
213   * @dev Update user details
214   * Access modified with OnlyAdmin
215   *
216   *
217   * Requirements:
218   *
219   * - `_wallet` should be a registered user.
220   * - `_package` should be a registered user.
221   */
222   function updateUser(address _wallet, uint _package, uint256 _etherValue, address payable _refferer) private onlyAdmin {
223     require(users[_wallet].wallet == _wallet,"User is not registered in blockchain");
224     users[_wallet].package = _package;
225     users[_wallet].etherValue = _etherValue;
226     users[_wallet].refferer = _refferer;
227     emit UserDetailsUpdated(_wallet, _package, _etherValue, _refferer);
228   }
229   /**
230   * @dev Enables admin to set compensation plan.
231   *
232   * This is public function.
233   ** Access modified with OnlyAdmin
234   *
235   * Requirements:
236   *
237   * - `_level` cannot be the zero.
238   * - `_package` cannot be the zero.
239   * - `_percentage` cannot be the zero.
240   */
241   function setPlan(uint _level, uint _package, uint _percentage) private onlyAdmin {
242     plans[_level] = Plan(_level, _package, _percentage);
243   }
244   /**
245   * @dev Withdraws contract balance to owner waller
246   *
247   ** Access modified with OnlyAdmin
248   *
249   * Requirements:
250   *
251   */
252   function withdraw() public onlyAdmin {
253         owner.transfer(address(this).balance);
254   }
255   /**
256   * @dev Sets user qualification.
257   *
258   * Access modified with OnlyAdmin
259   * This is public function.
260   *
261   *
262   * Requirements:
263   *
264   * - `_level` cannot be the zero.
265   * - `_wallet` cannot be the zero.
266   */
267   function setQualification(address _wallet,uint _level) private onlyAdmin{
268     require(users[_wallet].status == true, 'User is not active or not registered');
269     if(qualifications[_wallet].status <= 0 && _level == 1){
270         qualifications[_wallet] = Qualification(1,1,0,0,0,0,0,0,0,0,0);
271     }else{
272       if(_level == 1){
273         qualifications[_wallet].level_1 = 1;
274       }
275       if(_level == 2){
276         qualifications[_wallet].level_2 = 1;
277       }
278       if(_level == 3){
279         qualifications[_wallet].level_3 = 1;
280       }
281       if(_level == 4){
282         qualifications[_wallet].level_4 = 1;
283       }
284       if(_level == 5){
285         qualifications[_wallet].level_5 = 1;
286       }
287       if(_level == 6){
288         qualifications[_wallet].level_6 = 1;
289       }
290       if(_level == 7){
291         qualifications[_wallet].level_7 = 1;
292       }
293       if(_level == 8){
294         qualifications[_wallet].level_8 = 1;
295       }
296       if(_level == 9){
297         qualifications[_wallet].level_9 = 1;
298       }
299       if(_level == 10){
300         qualifications[_wallet].level_10 = 1;
301       }
302     }
303     emit EmQualification(_wallet, _level);
304   }
305   function migrateQualification(address _wallet,
306     uint _level1, uint _level2, uint _level3, uint _level4, uint _level5,
307     uint _level6, uint _level7, uint _level8, uint _level9, uint _level10
308     ) private onlyAdmin{
309     qualifications[_wallet] = Qualification(1, _level1, _level2, _level3, _level4, _level5, _level6, _level7, _level8, _level9, _level10);
310   }
311 /**
312   * @dev gets user qualification.
313   *
314   * Access modified with OnlyAdmin
315   * This is public function.
316   *
317   *
318   * Requirements:
319   *
320   * - `_level` cannot be the zero.
321   * - `_wallet` cannot be the zero.
322   */
323   function getQualification(address _wallet, uint _level) internal view returns(uint) {
324       uint qualified;
325       if(_level == 1){
326         qualified = qualifications[_wallet].level_1;
327       }
328       if(_level == 2){
329         qualified = qualifications[_wallet].level_2;
330       }
331       if(_level == 3){
332         qualified = qualifications[_wallet].level_3;
333       }
334       if(_level == 4){
335         qualified = qualifications[_wallet].level_4;
336       }
337       if(_level == 5){
338         qualified = qualifications[_wallet].level_5;
339       }
340       if(_level == 6){
341         qualified = qualifications[_wallet].level_6;
342       }
343       if(_level == 7){
344         qualified = qualifications[_wallet].level_7;
345       }
346       if(_level == 8){
347         qualified = qualifications[_wallet].level_8;
348       }
349       if(_level == 9){
350         qualified = qualifications[_wallet].level_9;
351       }
352       if(_level == 10){
353         qualified = qualifications[_wallet].level_10;
354       }
355       return qualified;
356   }
357   /**
358   * @dev calculates commission for uplines.
359   *
360   * Access modified with OnlyAdmin
361   *
362   *
363   * Requirements:
364   *
365   * - `_wallet` cannot be the zero.
366   */
367   function calculateLevelCommission(address payable _wallet) private onlyAdmin {
368     address payable parentWallet = users[_wallet].refferer;
369     uint256 etherValue = users[_wallet].etherValue;
370     uint256 expValue = (etherValue * 30)/100;
371     require(address(this).balance > expValue,"Unable to execute please contact admin");
372     uint level = 1;
373     while(level <= 10)
374     {
375         uint256 amount = 0;
376         User memory parent = users[parentWallet];
377         if(parentWallet == parent.refferer){
378           break;
379         }
380         //checks user have package
381         if(parent.package <= 0){
382           break;
383         }
384         Plan memory levelCommission = plans[level];
385         uint qualified = getQualification(parentWallet, level);
386         if(parent.package >= levelCommission.package && parent.status && qualified > 0){
387           amount = etherValue * levelCommission.percentage / 100;
388           uint256 maxCommission = (parent.etherValue * 2) - parent.commissions;
389           if(maxCommission <= amount )
390           {
391             amount = maxCommission;
392           }
393           amount = amount;
394           parent.wallet.transfer(amount);
395           users[parent.wallet].commissions += amount;
396           emit DistributeCommission(parent.wallet, _wallet, amount);
397         }else{
398           emit MissedCommission(parent.wallet, _wallet);
399         }
400         if(parent.status){
401           level++;
402         }
403          parentWallet = parent.refferer;
404     }
405     }
406         /**
407     * @dev Distributes commission
408     *
409     ** Access modified with OnlyAdmin
410     *
411     * Requirements:
412     *
413     */
414     function distributeCommission(address[] memory addresses, uint256[] memory amounts, uint256 rid) public payable onlyAdmin {
415         require(addresses.length > 0, "Atleast one address should be passed");
416         require(amounts.length == addresses.length, "address and amount data missmatch");
417         emit DistributionStarted(rid);
418         for (uint256 i; i < addresses.length; i++) {
419             uint256 value = amounts[i];
420             address _to = addresses[i];
421             require(value > 0, "Minimum amount need to transfer");
422             address(uint160(_to)).transfer(value);
423             emit DistCommission(_to, value, rid);
424         }
425     }
426 }