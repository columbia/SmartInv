1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender) public constant returns (uint256);
92   function transferFrom(address from, address to, uint256 value) public returns (bool);
93   function approve(address spender, uint256 value) public returns (bool);
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 /**
99  * @title NonZero
100  */
101 contract NonZero {
102 
103 // Functions with this modifier fail if he 
104     modifier nonZeroAddress(address _to) {
105         require(_to != 0x0);
106         _;
107     }
108 
109     modifier nonZeroAmount(uint _amount) {
110         require(_amount > 0);
111         _;
112     }
113 
114     modifier nonZeroValue() {
115         require(msg.value > 0);
116         _;
117     }
118 
119 }
120 
121 
122 contract TripCoin is ERC20, Ownable, NonZero {
123 
124     using SafeMath for uint;
125 
126 /////////////////////// TOKEN INFORMATION ///////////////////////
127     string public constant name = "TripCoin";
128     string public constant symbol = "TRIP";
129 
130     uint8 public decimals = 3;
131     
132     // Mapping to keep user's balances
133     mapping (address => uint256) balances;
134     // Mapping to keep user's allowances
135     mapping (address => mapping (address => uint256)) allowed;
136 
137 /////////////////////// VARIABLE INITIALIZATION ///////////////////////
138     
139     // Allocation for the TripCoin Team
140     uint256 public TripCoinTeamSupply;
141     // Reserve supply
142     uint256 public ReserveSupply;
143     // Amount of TripCoin for the presale
144     uint256 public presaleSupply;
145 
146     uint256 public icoSupply;
147     // Community incentivisation supply
148     uint256 public incentivisingEffortsSupply;
149     // Crowdsale End Timestamp
150     uint256 public presaleStartsAt;
151     uint256 public presaleEndsAt;
152     uint256 public icoStartsAt;
153     uint256 public icoEndsAt;
154    
155     // TripCoin team address
156     address public TripCoinTeamAddress;
157     // Reserve address
158     address public ReserveAddress;
159     // Community incentivisation address
160     address public incentivisingEffortsAddress;
161 
162     // Flag keeping track of presale status. Ensures functions can only be called once
163     bool public presaleFinalized = false;
164     // Flag keeping track of crowdsale status. Ensures functions can only be called once
165     bool public icoFinalized = false;
166     // Amount of wei currently raised
167     uint256 public weiRaised = 0;
168 
169 /////////////////////// EVENTS ///////////////////////
170 
171     // Event called when crowdfund is done
172     event icoFinalized(uint tokensRemaining);
173     // Event called when presale is done
174     event PresaleFinalized(uint tokensRemaining);
175     // Emitted upon crowdfund being finalized
176     event AmountRaised(address beneficiary, uint amountRaised);
177     // Emmitted upon purchasing tokens
178     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
179 
180 /////////////////////// MODIFIERS ///////////////////////
181 
182  
183 
184     // Ensure only crowdfund can call the function
185     modifier onlypresale() {
186         require(msg.sender == owner);
187         _;
188     }
189     modifier onlyico() {
190         require(msg.sender == owner);
191         _;
192     }
193 
194 /////////////////////// ERC20 FUNCTIONS ///////////////////////
195 
196     // Transfer
197     function transfer(address _to, uint256 _amount) returns (bool success) {
198         require(balanceOf(msg.sender) >= _amount);
199         addToBalance(_to, _amount);
200         decrementBalance(msg.sender, _amount);
201         Transfer(msg.sender, _to, _amount);
202         return true;
203     }
204 
205     // Transfer from one address to another (need allowance to be called first)
206     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
207         require(allowance(_from, msg.sender) >= _amount);
208         decrementBalance(_from, _amount);
209         addToBalance(_to, _amount);
210         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
211         Transfer(_from, _to, _amount);
212         return true;
213     }
214 
215     // Approve another address a certain amount of TripCoin
216     function approve(address _spender, uint256 _value) returns (bool success) {
217         require((_value == 0) || (allowance(msg.sender, _spender) == 0));
218         allowed[msg.sender][_spender] = _value;
219         Approval(msg.sender, _spender, _value);
220         return true;
221     }
222 
223     // Get an address's TripCoin allowance
224     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
225         return allowed[_owner][_spender];
226     }
227 
228     // Get the TripCoin balance of any address
229     function balanceOf(address _owner) constant returns (uint256 balance) {
230         return balances[_owner];
231     }
232 
233 /////////////////////// TOKEN FUNCTIONS ///////////////////////
234 
235     // Constructor
236     function TripCoin() {
237         presaleStartsAt = 1509271200;                                          //Oct 29 2017,10 AM GMT
238         presaleEndsAt = 1509875999;                                          //Nov 05 2017,9:59:59 AM GMT
239         icoStartsAt = 1509876000;                                             //Nov 05 2017,10 AM GMT
240         icoEndsAt = 1511863200;                                               //Nov 28 2017,10 AM GMT
241            
242 
243         totalSupply = 200000000000;                                                   // 100% - 200m
244         TripCoinTeamSupply = 20000000000;                                              // 10%
245         ReserveSupply = 60000000000;                                                // 30% 
246         incentivisingEffortsSupply = 20000000000;                                    // 10% 
247         presaleSupply = 60000000000;                                                // 30%
248         icoSupply = 40000000000;                                                    // 20%
249        
250        
251         TripCoinTeamAddress = 0xD7741E3819434a91F25b8C8e30Ba124D1EDe6B03;             // TripCoin Team Address
252         ReserveAddress = 0x51Ff33A5C5350E62F9a974108e4B93EDC5C26359;               // Reserve Address
253         incentivisingEffortsAddress = 0x4B8849c93b90Fe2446D8fc27FEc25Dc3386b1e75;   // Community incentivisation address
254 
255         addToBalance(incentivisingEffortsAddress, incentivisingEffortsSupply);     
256         addToBalance(ReserveAddress, ReserveSupply); 
257         addToBalance(owner, presaleSupply.add(icoSupply)); 
258         
259         addToBalance(TripCoinTeamAddress, TripCoinTeamSupply); 
260     }
261 
262   
263 
264     // Function for the presale to transfer tokens
265     function transferFromPresale(address _to, uint256 _amount) onlyOwner nonZeroAmount(_amount) nonZeroAddress(_to) returns (bool success) {
266         require(balanceOf(owner) >= _amount);
267         decrementBalance(owner, _amount);
268         addToBalance(_to, _amount);
269         Transfer(0x0, _to, _amount);
270         return true;
271     }
272       // Function for the ico to transfer tokens
273     function transferFromIco(address _to, uint256 _amount) onlyOwner nonZeroAmount(_amount) nonZeroAddress(_to) returns (bool success) {
274         require(balanceOf(owner) >= _amount);
275         decrementBalance(owner, _amount);
276         addToBalance(_to, _amount);
277         Transfer(0x0, _to, _amount);
278         return true;
279     }
280     function getRate() public constant returns (uint price) {
281         if (now > presaleStartsAt && now < presaleEndsAt ) {
282            return 1500; 
283         } else if (now > icoStartsAt && now < icoEndsAt) {
284            return 1000; 
285         } 
286     }       
287     
288      function buyTokens(address _to) nonZeroAddress(_to) nonZeroValue payable {
289         uint256 weiAmount = msg.value;
290         uint256 tokens = weiAmount * getRate();
291         weiRaised = weiRaised.add(weiAmount);
292         
293         owner.transfer(msg.value);
294         TokenPurchase(_to, weiAmount, tokens);
295     }
296     
297      function () payable {
298         buyTokens(msg.sender);
299     }
300    
301 
302     
303 
304     // Add to balance
305     function addToBalance(address _address, uint _amount) internal {
306     	balances[_address] = balances[_address].add(_amount);
307     }
308 
309     // Remove from balance
310     function decrementBalance(address _address, uint _amount) internal {
311     	balances[_address] = balances[_address].sub(_amount);
312     }
313 }