1 pragma solidity 0.5.3; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11 
12 ██████╗ ███████╗██████╗  ██████╗ ███████╗██╗████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗
13 ██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔════╝██║╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║
14 ██║  ██║█████╗  ██████╔╝██║   ██║███████╗██║   ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║
15 ██║  ██║██╔══╝  ██╔═══╝ ██║   ██║╚════██║██║   ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║
16 ██████╔╝███████╗██║     ╚██████╔╝███████║██║   ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║
17 ╚═════╝ ╚══════╝╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝
18                                                                                         
19 
20 
21 
22 // ----------------------------------------------------------------------------
23 // 'DeposiToken (DT10)' contract with following functionalities:
24 //      => Higher control of owner
25 //      => SafeMath implementation 
26 //      => Referral system - 3 level
27 //
28 // Name             : DeposiToken
29 // Symbol           : DT10
30 // Decimals         : 15
31 //
32 // Copyright (c) 2018 FIRST DECENTRALIZED DEPOSIT PLATFORM ( https://fddp.io )
33 // Contract designed by: EtherAuthority ( https://EtherAuthority.io ) 
34 // ----------------------------------------------------------------------------
35 */ 
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43     
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function subsafe(uint256 a, uint256 b) internal pure returns (uint256) {
63     if(b <= a){
64         return a - b;
65     }else{
66         return 0;
67     }
68   }
69 
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }
75   
76 }
77 
78 
79 contract DepositToken_10 {
80     
81     using SafeMath for uint;
82     
83     string public constant name = "DeposiToken";
84     
85     string public constant symbol = "DT10";
86     
87     uint32 public constant decimals = 15;
88     
89     uint public _money = 0;
90     uint public _tokens = 0;
91     uint public _sellprice;
92     
93     // Адрес контракта Акций
94     address payable public theStocksTokenContract;
95     
96     // сохранить баланс на счетах пользователя
97     
98     mapping (address => uint) private balances;
99     
100     event FullEventLog(
101         address indexed user,
102         bytes32 status,
103         uint sellprice,
104         uint buyprice, 
105         uint time,
106         uint tokens,
107         uint ethers);
108         
109     
110     event Transfer(
111         address indexed from,
112         address indexed to,
113         uint256 value);
114         
115     // OK
116     constructor (address payable _tstc) public {
117         uint s = 10**13; // start price
118         _sellprice = s.mul(90).div(100);
119         theStocksTokenContract = _tstc;
120         
121         /* 1000 token belongs to the contract */
122         uint _value = 1000 * 10**15; 
123         
124         _tokens += _value;
125         balances[address(this)] += _value;
126         
127         emit Transfer(address(0x0), address(this), _value);
128     }
129     
130     // OK
131     function totalSupply () public view returns (uint256 tokens) {
132         return _tokens;
133     }
134     
135     // OK
136     function balanceOf(address addr) public view returns(uint){
137         return balances[addr];
138     }
139     
140     // OK
141     function transfer(address _to, uint256 _value) public returns (bool success) {
142         address addressContract = address(this);
143         require(_to == addressContract);
144         sell(_value);
145         success = true;
146     }
147     
148     // OK
149     function () external payable {
150         buy(address(0x0));
151     }
152     
153     
154     //***************************************************//
155     //--------------- REFERAL SYSTEM CODE ---------------//
156     //***************************************************//
157     
158     /** TECHNICAL SPECIFICATIONS
159      * 
160      * Because this is multi-level (3 level) referral system, we have to fix referrals.
161      * Which means once a user is fixed under someone as referral, then that can not be changed.
162      * Referral will be fixed at their first deposit.
163      * This also means. If a person have used referral link to deposit and got fixed. Then if he does not use any links to deposit again, referral bonus paid to their referrers.
164      * 
165      * 
166      * USE CASES
167      * 
168      * Case 1: depositor have used referral links, as well as depositor has existing direct referrer.
169      * In this case, ether will be sent to existing referrer, it will ignore the new link he used.
170      * 
171      * Case 2: depositor has existing referrer/up-line/direct sponsor, but he did not use any referrer link or sent ether directly to smart contract.
172      * In this case, ether will be sent to existing referrer.
173      * 
174      * Case 3: depositor does not have any existing direct referrer, but used referral link.
175      * In this case, referral bonus will be paid to address in the referral link.
176      * 
177      * All other cases apart from above, referral bonus will not be paid to anyone.
178      * And Entire platform fee (5% of deposit) will be sent to stock contract.
179      */
180     
181     /* Mapping to track referrer. The second address is the address of referrer, the Up-line/ Sponsor */
182     mapping (address => address payable) public referrers;
183     
184     /* Mapping to track referrer bonus for all the referrers */
185     mapping (address => uint) public referrerBonusBalance;
186     
187     /* Events to track ether transfer to referrers */
188     event ReferrerBonus(address indexed referer, address indexed depositor, uint256 depositAmount , uint256 etherReceived, uint256 timestamp );
189     
190     /* Events to track referral bonus claims */
191     event ReferralBonusClaim(address indexed referrar, uint256 bonus, uint256 timestamp);
192     /* Function to distribute bonuses to referrers, as well as calculating finaPlatformFee */
193     function distributeReferrerBonus(address payable _directReferrer, uint platformFee) internal returns (uint){
194         
195         // 60% of the Platform fee will be distributed to referrers, which is 3% of deposited ether
196         uint finaPlatformFee = platformFee;
197         
198         // Sending ether to level 1 (direct) referrer and deducting that amount from platformFee
199         uint _valueLevel1 = platformFee.mul(40).div(100);
200         referrerBonusBalance[_directReferrer] += _valueLevel1;  //40% of Platform Fee, equivilent to 2% of deposited ether
201         finaPlatformFee = finaPlatformFee.sub(_valueLevel1);
202         emit ReferrerBonus(_directReferrer, msg.sender, msg.value , _valueLevel1, now );
203     
204         
205         // If there is level 2 referrer, then sending ether to him/her as well
206         if(referrers[_directReferrer] != address(0x0)){
207             // Sending ether to level 2 referrer and deducting that amount from platformFee
208             uint _valueLevel2 = platformFee.mul(10).div(100);
209             referrerBonusBalance[referrers[_directReferrer]] += _valueLevel2;  //10% of Platform Fee, equivilent to 0.5% of deposited ether
210             finaPlatformFee = finaPlatformFee.sub(_valueLevel2);
211             emit ReferrerBonus(referrers[_directReferrer], msg.sender, msg.value , _valueLevel2, now );
212         }
213         
214         // If there is level 3 referrer, then sending ether to him/her as well
215         if(referrers[referrers[_directReferrer]] != address(0x0)){
216             // Sending ether to level 2 referrer and deducting that amount from platformFee
217             uint _valueLevel3 = platformFee.mul(10).div(100);
218             referrerBonusBalance[referrers[referrers[_directReferrer]]] += _valueLevel3;  //10% of Platform Fee, equivilent to 0.5% of deposited ether
219             finaPlatformFee = finaPlatformFee.sub(_valueLevel3);
220             emit ReferrerBonus(referrers[referrers[_directReferrer]], msg.sender, msg.value , _valueLevel3, now );
221         }
222         
223         // Returns final platform fee which would be sent to stock contract
224         return finaPlatformFee;
225     }
226     
227     /* Function will allow users to withdraw their referrer bonus  */
228     function claimReferrerBonus() public {
229         uint256 referralBonus = referrerBonusBalance[msg.sender];
230         require(referralBonus > 0, 'Insufficient referrer bonus');
231         referrerBonusBalance[msg.sender] = 0;
232         msg.sender.transfer(referralBonus);
233         emit ReferralBonusClaim(msg.sender,referralBonus,now);
234     }
235     
236     
237     // OK
238     function buy(address payable _referrer) public payable {
239         uint _value = msg.value.mul(10**15).div(_sellprice.mul(100).div(90));
240         
241         // общий баланс Эфиров на контракте
242         _money = _money.add(msg.value.mul(95).div(100));
243         
244         // Platform fee - 5% of the ether deposit
245         uint platformFee = msg.value.mul(50).div(1000);
246         
247         // Final platform Fee, is after all the referrer payout deductions (as many as applicable).
248         uint finaPlatformFee; 
249         
250         
251         /** Processing referral system fund distribution **/
252         // Case 1: depositor have used referral links, as well as depositor has existing direct referrer
253         // In this case, ether will be sent to existing referrer, it will ignore the new link he used.
254         if(_referrer != address(0x0) && referrers[msg.sender] != address(0x0)){
255             finaPlatformFee = distributeReferrerBonus(referrers[msg.sender], platformFee);
256         }
257         
258         // Case 2: depositor has existing referrer/up-line/direct sponsor, but he did not use any referrer link or sent ether directly to smart contract
259         // In this case, ether will be sent to existing referrer
260         else if(_referrer == address(0x0) && referrers[msg.sender] != address(0x0)){
261             finaPlatformFee = distributeReferrerBonus(referrers[msg.sender], platformFee);
262         }
263         
264         // Case 3: depositor does not have any existing direct referrer, but used referral link
265         // In this case, referral bonus will be paid to address in the referral link
266         else if(_referrer != address(0x0) && referrers[msg.sender] == address(0x0)){
267             finaPlatformFee = distributeReferrerBonus(_referrer, platformFee);
268             //adding referral details in both the mappings
269             referrers[msg.sender]=_referrer;
270         }
271         
272         // All other cases apart from above, referral bonus will not be paid to anyone
273         // And Entire platform fee (5% of deposit) will be sent to stock contract
274         else {
275             finaPlatformFee = platformFee;
276         }
277         
278         // отправить прибыль на контракт собствеников системы
279         (bool success, ) =    theStocksTokenContract.call.value(finaPlatformFee).gas(53000)("");
280         
281         // This checks if ether transfer to stock contract is successful, otherwise revert
282         require(success, 'Ether transfer to DA Token contract failed');
283         
284         // всего токенов в системе
285         _tokens = _tokens.add(_value);
286         
287         // добавить токены, на баланс пользователя
288         balances[msg.sender] = balances[msg.sender].add(_value);
289         
290         // Логируем событие с курсом / датой / 
291         emit FullEventLog(msg.sender, "buy", _sellprice, _sellprice.mul(100).div(90), now, _value, msg.value);
292         
293         _sellprice = _money.mul(10**15).mul(98).div(_tokens).div(100);
294         
295         
296         emit Transfer(address(this), msg.sender, _value);
297     }
298 
299     // OK
300     function sell (uint256 countTokens) public {
301         // проверка на отрицательный баланс
302         require(balances[msg.sender] >= countTokens);
303         
304         uint _value = countTokens.mul(_sellprice).div(10**15);
305         
306         _money = _money.sub(_value);
307         
308         _tokens = _tokens.subsafe(countTokens);
309         
310         balances[msg.sender] = balances[msg.sender].subsafe(countTokens);
311         
312         emit FullEventLog(msg.sender, "sell", _sellprice, _sellprice.mul(100).div(90), now, countTokens, _value);
313         
314         if(_tokens > 0) {
315             _sellprice = _money.mul(10**15).mul(98).div(_tokens).div(100);
316         }
317 
318     	emit Transfer(msg.sender, address(this), countTokens);
319         msg.sender.transfer(_value);
320     }
321     // OK
322     function getPrice() public view returns (uint bid, uint ask) {
323         bid = _sellprice.mul(100).div(90);
324         ask = _sellprice;
325     }
326 }