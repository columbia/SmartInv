1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5     * @dev Math operations with safety checks that throw on error
6        */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35     * @dev The Ownable contract has an owner address, and provides basic authorization control 
36        * functions, this simplifies the implementation of "user permissions". 
37           */
38 contract Ownable {
39   address public owner;
40 
41 
42   /** 
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44         * account.
45              */
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner. 
53         */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62         * @param newOwner The address to transfer ownership to. 
63              */
64   function transferOwnership(address newOwner) public onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 /**
73  * @title Standard ERC20 token
74     *
75       * @dev Implementation of the basic standard token.
76          * @dev https://github.com/ethereum/EIPs/issues/20
77             * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
78                */
79 contract StandardToken {
80   using SafeMath for uint256;
81   mapping (address => mapping (address => uint256)) allowed;
82   mapping(address => uint256) balances;
83   mapping(address => bool) preICO_address;
84   uint256 public totalSupply;
85   uint256 public endDate;
86   /**
87   * @dev transfer token for a specified address
88       * @param _to The address to transfer to.
89           * @param _value The amount to be transferred.
90               */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92 
93     if( preICO_address[msg.sender] ) require( now > endDate + 120 days ); //Lock coin
94     else require( now > endDate ); //Lock coin
95 
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100   }
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 
103   /**
104   * @dev Gets the balance of the specified address.
105       * @param _owner The address to query the the balance of. 
106           * @return An uint256 representing the amount owned by the passed address.
107               */
108   function balanceOf(address _owner) constant public returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112   /**
113    * @dev Transfer tokens from one address to another
114         * @param _from address The address which you want to send tokens from
115              * @param _to address The address which you want to transfer to
116                   * @param _value uint256 the amout of tokens to be transfered
117                        */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     var _allowance = allowed[_from][msg.sender];
120 
121     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
122     // require (_value <= _allowance);
123 
124     if( preICO_address[_from] ) require( now > endDate + 120 days ); //Lock coin
125     else require( now > endDate ); //Lock coin
126 
127     balances[_to] = balances[_to].add(_value);
128     balances[_from] = balances[_from].sub(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
136         * @param _spender The address which will spend the funds.
137              * @param _value The amount of tokens to be spent.
138                   */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140 
141     // To change the approve amount you first have to reduce the addresses`
142     //  allowance to zero by calling `approve(_spender, 0)` if it is not
143     //  already 0 to mitigate the race condition described here:
144     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
146 
147     if( preICO_address[msg.sender] ) require( now > endDate + 120 days ); //Lock coin
148     else require( now > endDate ); //Lock coin
149 
150     allowed[msg.sender][_spender] = _value;
151     Approval(msg.sender, _spender, _value);
152     return true;
153   }
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 
156   /**
157    * @dev Function to check the amount of tokens that an owner allowed to a spender.
158         * @param _owner address The address which owns the funds.
159              * @param _spender address The address which will spend the funds.
160                   * @return A uint256 specifing the amount of tokens still avaible for the spender.
161                        */
162   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
163     return allowed[_owner][_spender];
164   }
165 
166 }
167 
168 contract TBCoin is StandardToken, Ownable {
169     using SafeMath for uint256;
170 
171     // Token Info.
172     string  public constant name = "TimeBox Coin";
173     string  public constant symbol = "TB";
174     uint8   public constant decimals = 18;
175 
176     // Sale period.
177     uint256 public startDate;
178     // uint256 public endDate;
179 
180     // Token Cap for each rounds
181     uint256 public saleCap;
182 
183     // Address where funds are collected.
184     address public wallet;
185 
186     // Amount of raised money in wei.
187     uint256 public weiRaised;
188 
189     // Event
190     event TokenPurchase(address indexed purchaser, uint256 value,
191                         uint256 amount);
192     event PreICOTokenPushed(address indexed buyer, uint256 amount);
193 
194     // Modifiers
195     modifier uninitialized() {
196         require(wallet == 0x0);
197         _;
198     }
199 
200     function TBCoin() public{
201     }
202 // 
203     function initialize(address _wallet, uint256 _start, uint256 _end,
204                         uint256 _saleCap, uint256 _totalSupply)
205                         public onlyOwner uninitialized {
206         require(_start >= getCurrentTimestamp());
207         require(_start < _end);
208         require(_wallet != 0x0);
209         require(_totalSupply > _saleCap);
210 
211         startDate = _start;
212         endDate = _end;
213         saleCap = _saleCap;
214         wallet = _wallet;
215         totalSupply = _totalSupply;
216 
217         balances[wallet] = _totalSupply.sub(saleCap);
218         balances[0xb1] = saleCap;
219     }
220 
221     function supply() internal view returns (uint256) {
222         return balances[0xb1];
223     }
224 
225     function getCurrentTimestamp() internal view returns (uint256) {
226         return now;
227     }
228 
229     function getRateAt(uint256 at) public constant returns (uint256) {
230         if (at < startDate) {
231             return 0;
232         } else if (at < (startDate + 3 days)) {
233             return 1500;
234         } else if (at < (startDate + 9 days)) {
235             return 1440;
236         } else if (at < (startDate + 15 days)) {
237             return 1380;
238         } else if (at < (startDate + 21 days)) {
239             return 1320;
240         } else if (at < (startDate + 27 days)) {
241             return 1260;
242         } else if (at <= endDate) {
243             return 1200;
244         } else {
245             return 0;
246         }
247     }
248 
249     // Fallback function can be used to buy tokens
250     function () public payable {
251         buyTokens(msg.sender, msg.value);
252     }
253 
254     // For pushing pre-ICO records
255     function push(address buyer, uint256 amount) public onlyOwner { //b753a98c
256         require(balances[wallet] >= amount);
257         require(now < startDate);
258         require(buyer != wallet);
259 
260         preICO_address[ buyer ] = true;
261 
262         // Transfer
263         balances[wallet] = balances[wallet].sub(amount);
264         balances[buyer] = balances[buyer].add(amount);
265         PreICOTokenPushed(buyer, amount);
266     }
267 
268     function buyTokens(address sender, uint256 value) internal {
269         require(saleActive());
270 
271         uint256 weiAmount = value;
272         uint256 updatedWeiRaised = weiRaised.add(weiAmount);
273 
274         // Calculate token amount to be purchased
275         uint256 actualRate = getRateAt(getCurrentTimestamp());
276         uint256 amount = weiAmount.mul(actualRate);
277 
278         // We have enough token to sale
279         require(supply() >= amount);
280 
281         // Transfer
282         balances[0xb1] = balances[0xb1].sub(amount);
283         balances[sender] = balances[sender].add(amount);
284         TokenPurchase(sender, weiAmount, amount);
285 
286         // Update state.
287         weiRaised = updatedWeiRaised;
288 
289         // Forward the fund to fund collection wallet.
290         wallet.transfer(msg.value);
291     }
292 
293     function finalize() public onlyOwner {
294         require(!saleActive());
295 
296         // Transfer the rest of token to TB team
297         balances[wallet] = balances[wallet].add(balances[0xb1]);
298         balances[0xb1] = 0;
299     }
300 
301     function saleActive() public constant returns (bool) {
302         return (getCurrentTimestamp() >= startDate &&
303                 getCurrentTimestamp() < endDate && supply() > 0);
304     }
305     
306 }