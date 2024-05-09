1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   constructor() public {
35     owner = msg.sender;
36   }
37 
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   // уточниьт у МЕноскоп про этот функционал  - убрали  передачу владения (по итогам встречи 20171128)
44   /*
45   function transferOwnership(address newOwner) onlyOwner public {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50   */
51 }
52 
53 //Abstract contract for Calling ERC20 contract
54 contract AbstractCon {
55     function allowance(address _owner, address _spender)  public pure returns (uint256 remaining);
56     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
57     function token_rate() public returns (uint256);
58     function minimum_token_sell() public returns (uint16);
59     function decimals() public returns (uint8);
60     //function approve(address _spender, uint256 _value) public returns (bool); //test
61     //function transfer(address _to, uint256 _value) public returns (bool); //test
62     
63 }
64 
65 //ProxyDeposit
66 contract SynergisProxyDeposit is Ownable {
67     using SafeMath for uint256;
68 
69     ///////////////////////
70     // DATA STRUCTURES  ///
71     ///////////////////////
72     enum Role {Fund, Team, Adviser}
73     struct Partner {
74         Role roleInProject;
75         address account;
76         uint256  amount;
77     }
78 
79     mapping (int16 => Partner)  public partners; //public for dubug only
80     mapping (address => uint8) public special_offer;// % of discount
81 
82 
83     /////////////////////////////////////////
84     // STAKE for partners    - fixed !!!   //
85     /////////////////////////////////////////
86     uint8 constant Stake_Team = 10;
87     uint8 constant Stake_Adv = 5;
88 
89     string public constant name = "SYNERGIS_TOKEN_CHANGE";
90 
91 
92     uint8 public numTeamDeposits = 0; //public for dubug only
93     uint8 public numAdviserDeposits = 0; //public for dubug only
94     int16 public maxId = 1;// public for dubug only
95     uint256 public notDistributedAmount = 0;
96     uint256 public weiRaised; //All raised ether
97     address public ERC20address;
98 
99     ///////////////////////
100     /// EVENTS     ///////
101     //////////////////////
102     event Income(address from, uint256 amount);
103     event NewDepositCreated(address _acc, Role _role, int16 _maxid);
104     event DeletedDeposit(address _acc, Role _role, int16 _maxid, uint256 amount);
105     event DistributeIncome(address who, uint256 notDistrAm, uint256 distrAm);
106     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 weivalue, uint256 tokens);
107     event FundsWithdraw(address indexed who, uint256 amount );
108     event DepositIncome(address indexed _deposit, uint256 _amount );
109     event SpecialOfferAdd(address _acc, uint16 _discount);
110     event SpecialOfferRemove(address _acc);
111      
112 
113     //!!!! Fund Account address must be defind and provided in constructor
114     constructor (address fundAcc) public {
115         //costructor
116         require(fundAcc != address(0)); //Fund must exist
117         partners[0]=Partner(Role.Fund, fundAcc, 0);// Always must be Fund
118     }
119 
120     function() public payable {
121         emit Income(msg.sender, msg.value);
122         sellTokens(msg.sender);
123     }
124 
125         // low level token purchase function
126     function sellTokens(address beneficiary) internal  {  //public payable modificatros- for truffle tests only
127         uint256 weiAmount = msg.value; //local
128         notDistributedAmount = notDistributedAmount.add(weiAmount);//
129         AbstractCon ac = AbstractCon(ERC20address);
130         //calculate token amount for sell -!!!! must check on minimum_token_sell
131         uint256 tokens = weiAmount.mul(ac.token_rate()*(100+uint256(special_offer[beneficiary])))/100;
132         require(beneficiary != address(0));
133         require(ac.token_rate() > 0);//implicit enabling/disabling sell
134         require(tokens >= ac.minimum_token_sell()*(10 ** uint256(ac.decimals())));
135         require(ac.transferFrom(ERC20address, beneficiary, tokens));//!!!token sell/change
136         weiRaised = weiRaised.add(weiAmount);
137         emit TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
138     }
139 
140     //set   erc20 address for token process  with check of allowance 
141     function setERC20address(address currentERC20contract)  public onlyOwner {
142         require(address(currentERC20contract) != 0);
143         AbstractCon ac = AbstractCon(currentERC20contract);
144         require(ac.allowance(currentERC20contract, address(this))>0);
145         ERC20address = currentERC20contract;
146     }    
147 
148     /////////////////////////////////////////
149     // PARTNERS DEPOSIT MANAGE          /////
150     /////////////////////////////////////////
151     //Create new deposit account
152     function newDeposit(Role _role, address _dep) public onlyOwner returns (int16){
153         require(getDepositID(_dep)==-1);//chek double
154         require(_dep != address(0));
155         require(_dep != address(this));
156         int16 depositID = maxId++;//first=, then ++
157         partners[depositID]=Partner(_role, _dep, 0);//new deposit with 0 ether
158         //We need to know number of deposits per Role
159         if (_role==Role.Team) {
160             numTeamDeposits++; // For quick calculate stake
161         }
162         if (_role==Role.Adviser) {
163             numAdviserDeposits++; // For quick calculate stake
164         }
165         emit NewDepositCreated(_dep, _role, depositID);
166         return depositID;
167     }
168 
169     //Delete Team or Adviser accounts
170     function deleteDeposit(address dep) public onlyOwner {
171         int16 depositId = getDepositID(dep);
172         require(depositId>0);
173         //can`t delete Fund deposit account
174         require(partners[depositId].roleInProject != Role.Fund);
175         //Decrease deposits number befor deleting
176         if (partners[depositId].roleInProject==Role.Team) {
177             numTeamDeposits--;
178         }
179         if (partners[depositId].roleInProject==Role.Adviser) {
180             numAdviserDeposits--;
181         }
182         //return current Amount of deleting Deposit  to  notDistributedAmount
183         notDistributedAmount = notDistributedAmount.add(partners[depositId].amount);
184         emit DeletedDeposit(dep, partners[depositId].roleInProject, depositId, partners[depositId].amount);
185         delete(partners[depositId]);
186 
187     }
188 
189     function getDepositID(address dep) internal constant returns (int16 id){
190         //id = -1; //not found
191         for (int16 i=0; i<=maxId; i++) {
192             if (dep==partners[i].account){
193                 //id=i;
194                 //return id;
195                 return i;
196             }
197         }
198         return -1;
199     }
200 
201     //withdraw with pull payee patern
202     function withdraw() external {
203         int16 id = getDepositID(msg.sender);
204         require(id >=0);
205         uint256 amount = partners[id].amount;
206         // set to zero the pending refund before
207         // sending to prevent re-entrancy attacks
208         partners[id].amount = 0;
209         msg.sender.transfer(amount);
210         emit FundsWithdraw(msg.sender, amount);
211     }
212 
213 
214     function distributeIncomeEther() public onlyOwner { 
215         require(notDistributedAmount !=0);
216         uint256 distributed;
217         uint256 sum;
218         uint256 _amount;
219         for (int16 i=0; i<=maxId; i++) {
220             if  (partners[i].account != address(0) ){
221                 sum = 0;
222                 if  (partners[i].roleInProject==Role.Team) {
223                     sum = notDistributedAmount/100*Stake_Team/numTeamDeposits;
224                     emit DepositIncome(partners[i].account, uint256(sum));
225                 }
226                 if  (partners[i].roleInProject==Role.Adviser) {
227                     sum = notDistributedAmount/100*Stake_Adv/numAdviserDeposits;
228                     emit DepositIncome(partners[i].account, uint256(sum));
229                 }
230                 if  (partners[i].roleInProject==Role.Fund) {
231                     int16 fundAccountId=i; //just Remember last id
232                 } else {
233                     partners[i].amount = partners[i].amount.add(sum);
234                     distributed = distributed.add(sum);
235                 }
236             }
237         }
238         //And now Amount for Fund = notDistributedAmount - distributed
239         emit DistributeIncome(msg.sender, notDistributedAmount, distributed);
240         _amount = notDistributedAmount.sub(distributed);
241         partners[fundAccountId].amount =
242                  partners[fundAccountId].amount.add(_amount);
243         emit DepositIncome(partners[fundAccountId].account, uint256(_amount));         
244         notDistributedAmount = 0;
245         //проверить  на  ошибку   округления.
246     }
247 
248 
249     //Check of red_balance
250     function checkBalance() public constant returns (uint256 red_balance) {
251         // this.balance = notDistributedAmount + Sum(all deposits)
252         uint256 allDepositSum;
253         for (int16 i=0; i<=maxId; i++) {
254             allDepositSum = allDepositSum.add(partners[i].amount);
255         }
256         red_balance = address(this).balance.sub(notDistributedAmount).sub(allDepositSum);
257         return red_balance;
258     }
259 
260     //общая практика,  но уменьшает прозрачность и доверие -убрали destroy (по итогам встречи 20171128)
261     /*
262     function destroy() onlyOwner public {
263         selfdestruct(owner);
264     }
265     */
266 
267     //////////////////////////////////////////////////////////////////////
268     /////  SPECIAL OFFER MANAGE - DISCOUNTS        ///////////////////////
269     //////////////////////////////////////////////////////////////////////
270 
271         //For add percent discount for some purchaser - see WhitePaper
272     function addSpecialOffer (address vip, uint8 discount_percent) public onlyOwner {
273         require(discount_percent>0 && discount_percent<100);
274         special_offer[vip] = discount_percent;
275         emit SpecialOfferAdd(vip, discount_percent);
276     }
277 
278     //For remove discount for some purchaser - see WhitePaper
279     function removeSpecialOffer(address was_vip) public onlyOwner {
280         special_offer[was_vip] = 0;
281         emit SpecialOfferRemove(was_vip);
282     }
283   //***************************************************************
284   //Token Change Contract Design by IBERGroup, email:maxsizmobile@iber.group; 
285   //     Telegram: https://t.me/msmobile
286   //
287   ////**************************************************************
288 }