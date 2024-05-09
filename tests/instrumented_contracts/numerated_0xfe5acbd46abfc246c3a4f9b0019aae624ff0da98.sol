1 pragma solidity 0.4.25;
2 /**
3 * @title VSTER ICO Contract
4 * @dev VSTER is an ERC-20 Standar Compliant Token
5 */
6 
7 /**
8  * @title SafeMath by OpenZeppelin
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a * b;
15         assert(a == 0 || c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a / b;
21         return c;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35 }
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44     function totalSupply() public view returns (uint256);
45     function balanceOf(address who) public view returns (uint256);
46     function transfer(address to, uint256 value) public;
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 /**
52  * @title admined
53  * @notice This contract is administered
54  */
55 contract admined {
56     //mapping to user levels
57     mapping(address => uint8) public level;
58     //0 normal user
59     //1 basic admin
60     //2 master admin
61 
62     /**
63     * @dev This contructor takes the msg.sender as the first master admin
64     */
65     constructor() internal {
66         level[msg.sender] = 2; //Set initial admin to contract creator
67         emit AdminshipUpdated(msg.sender,2); //Log the admin set
68     }
69 
70     /**
71     * @dev This modifier limits function execution to the admin
72     */
73     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
74         require(level[msg.sender] >= _level ); //It require the user level to be more or equal than _level
75         _;
76     }
77 
78     /**
79     * @notice This function transfer the adminship of the contract to _newAdmin
80     * @param _newAdmin The new admin of the contract
81     */
82     function adminshipLevel(address _newAdmin, uint8 _level) onlyAdmin(2) public { //Admin can be set
83         require(_newAdmin != address(0)); //The new admin must not be zero address
84         level[_newAdmin] = _level; //New level is set
85         emit AdminshipUpdated(_newAdmin,_level); //Log the admin set
86     }
87 
88     /**
89     * @dev Log Events
90     */
91     event AdminshipUpdated(address _newAdmin, uint8 _level);
92 
93 }
94 
95 contract VSTERICO is admined {
96 
97     using SafeMath for uint256;
98     //This ico have these possible states
99     enum State {
100         PRESALE,
101         MAINSALE,
102         Successful
103     }
104     //Public variables
105 
106     //Time-state Related
107     State public state = State.PRESALE; //Set initial stage
108     uint256 constant public PRESALEStart = 1548979200; //Human time (GMT): Friday, 1 February 2019 0:00:00
109     uint256 constant public MAINSALEStart = 1554163200; //Human time (GMT): Tuesday, 2 April 2019 0:00:00
110     uint256 constant public SaleDeadline = 1564531200; //Human time (GMT): Wednesday, 31 July 2019 0:00:00
111     uint256 public completedAt; //Set when ico finish
112     //Token-eth related
113     uint256 public totalRaised; //eth collected in wei
114     uint256 public totalRefDistributed; //total tokens distributed to referrals
115     uint256 public totalEthRefDistributed; //total eth distributed to specified referrals
116     uint256 public totalDistributed; //Sale tokens distributed
117     ERC20Basic public tokenReward = ERC20Basic(0xA2e13c4f0431B6f2B06BBE61a24B61CCBe13136A); //Token contract address
118     mapping(address => bool) referral; //Determine the referral type
119 
120     //Contract details
121     address public creator; //Creator address
122     address public fundsWallet = 0x62e0b52F0a7AD4bB7b87Ce41e132bCBC7173EB96;
123     string public version = '0.2'; //Contract version
124 
125     //Price related
126     uint256 public USDPriceInWei; // 0.1 cent (0.001$) in wei
127     string public USDPrice;
128 
129     //events for log
130     event LogFundrisingInitialized(address indexed _creator);
131     event LogFundingReceived(address indexed _addr, uint _amount, uint _currentTotal, address _referral);
132     event LogBeneficiaryPaid(address indexed _beneficiaryAddress);
133     event LogContributorsPayout(address indexed _addr, uint _amount);
134     event LogFundingSuccessful(uint _totalRaised);
135 
136     //Modifier to prevent execution if ico has ended or is holded
137     modifier notFinished() {
138         require(state != State.Successful);
139         _;
140     }
141 
142     /**
143     * @notice ICO constructor
144     * @param _initialUSDInWei initial usd value on wei
145     */
146     constructor(uint _initialUSDInWei) public {
147 
148         creator = msg.sender; //Creator is set from deployer address
149         USDPriceInWei = _initialUSDInWei;
150 
151         emit LogFundrisingInitialized(creator); //Log contract initialization
152 
153     }
154 
155     function setReferralType(address _user, bool _type) onlyAdmin(1) public {
156       referral[_user] = _type;
157     }
158 
159     /**
160     * @notice contribution handler
161     */
162     function contribute(address _target, uint256 _value, address _reff) public notFinished payable {
163         require(now > PRESALEStart); //This time must be equal or greater than the start time
164 
165         address user;
166         uint remaining;
167         uint256 tokenBought;
168         uint256 temp;
169         uint256 refBase;
170 
171         //If the address is not zero the caller must be an admin
172         if(_target != address(0) && level[msg.sender] >= 1){
173           user = _target; //user is set by admin
174           remaining = _value.mul(1e18); //value contributed is set by admin
175           refBase = _value; //value for referral calc
176         } else { //If the address is zero or the caller is not an admin
177           user = msg.sender; //user is same as caller
178           remaining = msg.value.mul(1e18); //value is same as sent
179           refBase = msg.value; //value for referral calc
180         }
181 
182         totalRaised = totalRaised.add(remaining.div(1e18)); //ether received updated
183 
184         //Tokens bought calculation
185         while(remaining > 0){
186 
187           (temp,remaining) = tokenBuyCalc(remaining);
188           tokenBought = tokenBought.add(temp);
189 
190         }
191 
192         temp = 0; //Clear temporal variable
193 
194         totalDistributed = totalDistributed.add(tokenBought); //Whole tokens sold updated
195 
196         //Check for presale limit
197         if(state == State.PRESALE){
198           require(totalDistributed <= 5000000 * (10**18));
199         }
200 
201         //Transfer tokens to user
202         tokenReward.transfer(user,tokenBought);
203 
204         //Referral checks
205         if(_reff != address(0) && _reff != user){ //referral cannot be zero or self
206 
207           //Check if referral receives eth or tokens
208           if(referral[_reff] == true){ //If eth
209             //Check current rate
210             if(state == State.PRESALE){//Presale Rate
211               //100%/10 = 10%
212               _reff.transfer(refBase.div(10));
213               totalEthRefDistributed = totalEthRefDistributed.add(refBase.div(10));
214 
215             } else {//Mainsale rate
216               //100%/20= 5%
217               _reff.transfer(refBase.div(20));
218               totalEthRefDistributed = totalEthRefDistributed.add(refBase.div(20));
219 
220             }
221           } else {//if tokens
222             //Check current rate
223             if(state == State.PRESALE){//Presale Rate
224               //100%/10 = 10%
225               tokenReward.transfer(_reff,tokenBought.div(10));
226               totalRefDistributed = totalRefDistributed.add(tokenBought.div(10));
227             } else {//Mainsale rate
228               //100%/20= 5%
229               tokenReward.transfer(_reff,tokenBought.div(20));
230               totalRefDistributed = totalRefDistributed.add(tokenBought.div(20));
231             }
232           }
233         }
234 
235         emit LogFundingReceived(user, msg.value, totalRaised, _reff); //Log the purchase
236 
237         fundsWallet.transfer(address(this).balance); //Eth is send to fundsWallet
238         emit LogBeneficiaryPaid(fundsWallet); //Log transaction
239 
240         checkIfFundingCompleteOrExpired(); //Execute state checks
241     }
242 
243 
244     /**
245     * @notice tokenBought calculation function
246     * @param _value is the amount of eth multiplied by 1e18
247     */
248     function tokenBuyCalc(uint _value) internal view returns (uint sold,uint remaining) {
249 
250       uint256 tempPrice = USDPriceInWei; //0.001$ in wei
251 
252       //Determine state to set current price
253       if(state == State.PRESALE){ //Presale price
254 
255             tempPrice = tempPrice.mul(400); //0.001$ * 400 = 0.4$
256             sold = _value.div(tempPrice); //here occurs decimal correction
257 
258             return (sold,0);
259 
260       } else { //state == State.MAINSALE - Mainsale price
261 
262             tempPrice = tempPrice.mul(600); //0.001$ * 600 = 0.6$
263             sold = _value.div(tempPrice); //here occurs decimal correction
264 
265             return (sold,0);
266 
267         }
268 }
269 
270     /**
271     * @notice Process to check contract current status
272     */
273     function checkIfFundingCompleteOrExpired() public {
274 
275         if ( now > SaleDeadline && state != State.Successful){ //If deadline is reached and not yet successful
276 
277             state = State.Successful; //ICO becomes Successful
278             completedAt = now; //ICO is complete
279 
280             emit LogFundingSuccessful(totalRaised); //we log the finish
281             successful(); //and execute closure
282 
283         } else if(state == State.PRESALE && now >= MAINSALEStart ) {
284 
285             state = State.MAINSALE; //We get on next stage
286 
287         }
288 
289     }
290 
291     /**
292     * @notice successful closure handler
293     */
294     function successful() public {
295         require(state == State.Successful); //When successful
296 
297         uint256 temp = tokenReward.balanceOf(address(this)); //Remanent tokens handle
298 
299         tokenReward.transfer(creator,temp); //Transfer remanent tokens
300         emit LogContributorsPayout(creator,temp); //Log transaction
301 
302         fundsWallet.transfer(address(this).balance); //Eth is send to fundsWallet
303         emit LogBeneficiaryPaid(fundsWallet); //Log transaction
304     }
305 
306     /**
307     * @notice set usd price on wei
308     * @param _value wei value
309     */
310     function setPrice(uint _value, string _price) public onlyAdmin(2) {
311 
312       USDPriceInWei = _value;
313       USDPrice = _price;
314 
315     }
316 
317     /**
318     * @notice Function to claim any token stuck on contract
319     * @param _address Address of target token
320     */
321     function externalTokensRecovery(ERC20Basic _address) onlyAdmin(2) public{
322         require(state == State.Successful); //Only when sale finish
323 
324         uint256 remainder = _address.balanceOf(address(this)); //Check remainder tokens
325         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
326 
327     }
328 
329     /*
330     * @dev Direct payments handler
331     */
332     function () public payable {
333 
334         //Forward to contribute function
335         //zero address, no custom value, no referral
336         contribute(address(0),0,address(0));
337 
338     }
339 }