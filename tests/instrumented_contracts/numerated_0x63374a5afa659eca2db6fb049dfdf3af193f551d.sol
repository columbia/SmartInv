1 pragma solidity ^0.4.18;
2 
3 contract TBsell{
4     TBCoin TBSC =TBCoin(0x6158e3F89b4398f5fb20D20DbFc5a5c955F0F6dd);
5     address public wallet = 0x61C8C6d0119Cdc3fFFB4E49ebf0899887e49761D;
6     address public TBowner;
7     uint public TBrate = 1200;
8     function TBsell() public{
9         TBowner = msg.sender;
10     }
11     function () public payable{
12         require(TBSC.balanceOf(this) >= msg.value*TBrate);
13         TBSC.transfer(msg.sender,msg.value*TBrate);
14         wallet.transfer(msg.value);
15     }
16     function getbackTB(uint amount) public{
17         assert(msg.sender == TBowner);
18         TBSC.transfer(TBowner,amount);
19     }
20     function changeTBrate(uint rate) public{
21         assert(msg.sender == TBowner);
22         TBrate = rate;
23     }
24 }
25 
26 
27 /**
28  * @title SafeMath
29     * @dev Math operations with safety checks that throw on error
30        */
31 library SafeMath {
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 /**
58  * @title Ownable
59     * @dev The Ownable contract has an owner address, and provides basic authorization control 
60        * functions, this simplifies the implementation of "user permissions". 
61           */
62 contract Ownable {
63   address public owner;
64 
65 
66   /** 
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68         * account.
69              */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74 
75   /**
76    * @dev Throws if called by any account other than the owner. 
77         */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86         * @param newOwner The address to transfer ownership to. 
87              */
88   function transferOwnership(address newOwner) public onlyOwner {
89     if (newOwner != address(0)) {
90       owner = newOwner;
91     }
92   }
93 
94 }
95 
96 /**
97  * @title Standard ERC20 token
98     *
99       * @dev Implementation of the basic standard token.
100          * @dev https://github.com/ethereum/EIPs/issues/20
101             * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102                */
103 contract StandardToken {
104   using SafeMath for uint256;
105   mapping (address => mapping (address => uint256)) allowed;
106   mapping(address => uint256) balances;
107   mapping(address => bool) preICO_address;
108   uint256 public totalSupply;
109   uint256 public endDate;
110   /**
111   * @dev transfer token for a specified address
112       * @param _to The address to transfer to.
113           * @param _value The amount to be transferred.
114               */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116 
117     if( preICO_address[msg.sender] ) require( now > endDate + 120 days ); //Lock coin
118     else require( now > endDate ); //Lock coin
119 
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125   event Transfer(address indexed from, address indexed to, uint256 value);
126 
127   /**
128   * @dev Gets the balance of the specified address.
129       * @param _owner The address to query the the balance of. 
130           * @return An uint256 representing the amount owned by the passed address.
131               */
132   function balanceOf(address _owner) constant public returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136   /**
137    * @dev Transfer tokens from one address to another
138         * @param _from address The address which you want to send tokens from
139              * @param _to address The address which you want to transfer to
140                   * @param _value uint256 the amout of tokens to be transfered
141                        */
142   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143     var _allowance = allowed[_from][msg.sender];
144 
145     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
146     // require (_value <= _allowance);
147 
148     if( preICO_address[_from] ) require( now > endDate + 120 days ); //Lock coin
149     else require( now > endDate ); //Lock coin
150 
151     balances[_to] = balances[_to].add(_value);
152     balances[_from] = balances[_from].sub(_value);
153     allowed[_from][msg.sender] = _allowance.sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
160         * @param _spender The address which will spend the funds.
161              * @param _value The amount of tokens to be spent.
162                   */
163   function approve(address _spender, uint256 _value) public returns (bool) {
164 
165     // To change the approve amount you first have to reduce the addresses`
166     //  allowance to zero by calling `approve(_spender, 0)` if it is not
167     //  already 0 to mitigate the race condition described here:
168     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
170 
171     if( preICO_address[msg.sender] ) require( now > endDate + 120 days ); //Lock coin
172     else require( now > endDate ); //Lock coin
173 
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176     return true;
177   }
178   event Approval(address indexed owner, address indexed spender, uint256 value);
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182         * @param _owner address The address which owns the funds.
183              * @param _spender address The address which will spend the funds.
184                   * @return A uint256 specifing the amount of tokens still avaible for the spender.
185                        */
186   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
187     return allowed[_owner][_spender];
188   }
189 
190 }
191 
192 contract TBCoin is StandardToken, Ownable {
193     using SafeMath for uint256;
194 
195     // Token Info.
196     string  public constant name = "TimeBox Coin";
197     string  public constant symbol = "TB";
198     uint8   public constant decimals = 18;
199 
200     // Sale period.
201     uint256 public startDate;
202     // uint256 public endDate;
203 
204     // Token Cap for each rounds
205     uint256 public saleCap;
206 
207     // Address where funds are collected.
208     address public wallet;
209 
210     // Amount of raised money in wei.
211     uint256 public weiRaised;
212 
213     // Event
214     event TokenPurchase(address indexed purchaser, uint256 value,
215                         uint256 amount);
216     event PreICOTokenPushed(address indexed buyer, uint256 amount);
217 
218     // Modifiers
219     modifier uninitialized() {
220         require(wallet == 0x0);
221         _;
222     }
223 
224     function TBCoin() public{
225     }
226 // 
227     function initialize(address _wallet, uint256 _start, uint256 _end,
228                         uint256 _saleCap, uint256 _totalSupply)
229                         public onlyOwner uninitialized {
230         require(_start >= getCurrentTimestamp());
231         require(_start < _end);
232         require(_wallet != 0x0);
233         require(_totalSupply > _saleCap);
234 
235         startDate = _start;
236         endDate = _end;
237         saleCap = _saleCap;
238         wallet = _wallet;
239         totalSupply = _totalSupply;
240 
241         balances[wallet] = _totalSupply.sub(saleCap);
242         balances[0xb1] = saleCap;
243     }
244 
245     function supply() internal view returns (uint256) {
246         return balances[0xb1];
247     }
248 
249     function getCurrentTimestamp() internal view returns (uint256) {
250         return now;
251     }
252 
253     function getRateAt(uint256 at) public constant returns (uint256) {
254         if (at < startDate) {
255             return 0;
256         } else if (at < (startDate + 3 days)) {
257             return 1500;
258         } else if (at < (startDate + 9 days)) {
259             return 1440;
260         } else if (at < (startDate + 15 days)) {
261             return 1380;
262         } else if (at < (startDate + 21 days)) {
263             return 1320;
264         } else if (at < (startDate + 27 days)) {
265             return 1260;
266         } else if (at <= endDate) {
267             return 1200;
268         } else {
269             return 0;
270         }
271     }
272 
273     // Fallback function can be used to buy tokens
274     function () public payable {
275         buyTokens(msg.sender, msg.value);
276     }
277 
278     // For pushing pre-ICO records
279     function push(address buyer, uint256 amount) public onlyOwner { //b753a98c
280         require(balances[wallet] >= amount);
281         require(now < startDate);
282         require(buyer != wallet);
283 
284         preICO_address[ buyer ] = true;
285 
286         // Transfer
287         balances[wallet] = balances[wallet].sub(amount);
288         balances[buyer] = balances[buyer].add(amount);
289         PreICOTokenPushed(buyer, amount);
290     }
291 
292     function buyTokens(address sender, uint256 value) internal {
293         require(saleActive());
294 
295         uint256 weiAmount = value;
296         uint256 updatedWeiRaised = weiRaised.add(weiAmount);
297 
298         // Calculate token amount to be purchased
299         uint256 actualRate = getRateAt(getCurrentTimestamp());
300         uint256 amount = weiAmount.mul(actualRate);
301 
302         // We have enough token to sale
303         require(supply() >= amount);
304 
305         // Transfer
306         balances[0xb1] = balances[0xb1].sub(amount);
307         balances[sender] = balances[sender].add(amount);
308         TokenPurchase(sender, weiAmount, amount);
309 
310         // Update state.
311         weiRaised = updatedWeiRaised;
312 
313         // Forward the fund to fund collection wallet.
314         wallet.transfer(msg.value);
315     }
316 
317     function finalize() public onlyOwner {
318         require(!saleActive());
319 
320         // Transfer the rest of token to TB team
321         balances[wallet] = balances[wallet].add(balances[0xb1]);
322         balances[0xb1] = 0;
323     }
324 
325     function saleActive() public constant returns (bool) {
326         return (getCurrentTimestamp() >= startDate &&
327                 getCurrentTimestamp() < endDate && supply() > 0);
328     }
329     
330 }