1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) constant returns (uint256);
32   function transfer(address to, uint256 value) returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) constant returns (uint256);
38   function transferFrom(address from, address to, uint256 value) returns (bool);
39   function approve(address spender, uint256 value) returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   /**
49   * @dev transfer token for a specified address
50   * @param _to The address to transfer to.
51   * @param _value The amount to be transferred.
52   */
53   function transfer(address _to, uint256 _value) returns (bool) {
54     require(_to != address(0));
55 
56     // SafeMath.sub will throw if there is not enough balance.
57     balances[msg.sender] = balances[msg.sender].sub(_value);
58     balances[_to] = balances[_to].add(_value);
59     Transfer(msg.sender, _to, _value);
60     return true;
61   }
62 
63   /**
64   * @dev Gets the balance of the specified address.
65   * @param _owner The address to query the the balance of.
66   * @return An uint256 representing the amount owned by the passed address.
67   */
68   function balanceOf(address _owner) constant returns (uint256 balance) {
69     return balances[_owner];
70   }
71 }
72 
73 contract StandardToken is ERC20, BasicToken {
74 
75   mapping (address => mapping (address => uint256)) allowed;
76 
77 
78   /**
79    * @dev Transfer tokens from one address to another
80    * @param _from address The address which you want to send tokens from
81    * @param _to address The address which you want to transfer to
82    * @param _value uint256 the amount of tokens to be transferred
83    */
84   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
85     require(_to != address(0));
86 
87     var _allowance = allowed[_from][msg.sender];
88 
89     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
90     // require (_value <= _allowance);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = _allowance.sub(_value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   /**
100    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
101    * @param _spender The address which will spend the funds.
102    * @param _value The amount of tokens to be spent.
103    */
104   function approve(address _spender, uint256 _value) returns (bool) {
105 
106     // To change the approve amount you first have to reduce the addresses`
107     //  allowance to zero by calling `approve(_spender, 0)` if it is not
108     //  already 0 to mitigate the race condition described here:
109     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
110     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
111 
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124     return allowed[_owner][_spender];
125   }
126 
127   /**
128    * approve should be called when allowed[_spender] == 0. To increment
129    * allowed value is better to use this function to avoid 2 calls (and wait until
130    * the first transaction is mined)
131    * From MonolithDAO Token.sol
132    */
133   function increaseApproval (address _spender, uint _addedValue)
134     returns (bool success) {
135     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137     return true;
138   }
139 
140   function decreaseApproval (address _spender, uint _subtractedValue)
141     returns (bool success) {
142     uint oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue > oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 }
152 
153 contract Santacoin is StandardToken {
154 
155     using SafeMath for uint256;
156 
157     // Santa Coin meta data
158     string constant public name = "SCS";
159     string constant public symbol = "SCS";
160     uint8 constant public decimals = 0; // 1 SCS = 1 SCS
161 
162     // North Pole Address
163     address public NorthPoleAddress;
164 
165     // North Pole
166     uint256 public NorthPoleAF = 1000000000000000;
167 
168     // Santa Coin Holder ETH Balances
169     mapping(address => uint256) private ETHAmounts;
170 
171     // Rewards per contributing address
172     mapping(address => uint256) private SantaCoinRewardsInETH;
173 
174     // Total amount held to date by North Pole
175     uint256 public TotalETHGivenToNorthPole = 0;
176 
177     // Total amount of santa coins issued to date
178     uint256 public TotalSantaCoinsGivenByNorthPole = 0;
179 
180     // Max Sata Reward (will be set once north pole stops minting)
181     uint256 public MaxSantaRewardPerToken = 0;
182 
183     // Santa Coin minimum
184     uint256 private minimumSantaCoinContribution = 0.01 ether;
185 
186     // Santa Coin Minting Range
187     uint256 private santaCoinMinterLowerBound = 1;
188     uint256 private santaCoinMinterUpperBound = 5;
189 
190     // Allows the north pole to issue santa coins
191     // to boys and girls around the world
192     bool public NorthPoleMintingEnabled = true;
193 
194     // Make sure either Santa or an Elf is
195     // performing this task
196     modifier onlySantaOrElf()
197     {
198         require (msg.sender == NorthPoleAddress);
199         _;
200     }
201 
202     // Determines random number between range
203     function determineRandomNumberBetween(uint min, uint max)
204         private
205         returns (uint256)
206     {
207         return (uint256(keccak256(block.blockhash(block.number-min), min ))%max);
208     }
209 
210     // Determines amount of Santa Coins to issue (alias)
211     function askSantaForCoinAmountBetween(uint min, uint max)
212         private
213         returns (uint256)
214     {
215         return determineRandomNumberBetween(min, max);
216     }
217 
218     // Determines amount of Santa Coins to issue (alias)
219     function askSantaForPresent(uint min, uint max)
220         private
221         returns (uint256)
222     {
223         return determineRandomNumberBetween(min, max);
224     }
225 
226     // Allows North Pole to issue Santa Coins
227     function setNorthPoleAddress(address newNorthPoleAddress)
228         public
229         onlySantaOrElf
230     {
231         NorthPoleAddress = newNorthPoleAddress;
232     }
233 
234     // Allows North Pole to issue Santa Coins
235     function allowNorthPoleMinting()
236         public
237         onlySantaOrElf
238     {
239         require(NorthPoleMintingEnabled == false);
240         NorthPoleMintingEnabled = true;
241     }
242 
243     // Prevents North Pole from issuing Santa Coins
244     function disallowNorthPoleMinting()
245         public
246         onlySantaOrElf
247     {
248         require(NorthPoleMintingEnabled == true);
249         NorthPoleMintingEnabled = false;
250 
251         if (this.balance > 0 && totalSupply > 0) {
252             MaxSantaRewardPerToken = this.balance.div(totalSupply);
253         }
254     }
255 
256     function hasSantaCoins(address holderAddress)
257       public
258       returns (bool)
259     {
260         return balances[holderAddress] > 0;
261     }
262 
263     function openGiftFromSanta(address holderAddress)
264       public
265       returns (uint256)
266     {
267         return SantaCoinRewardsInETH[holderAddress];
268     }
269 
270     function haveIBeenNaughty(address holderAddress)
271       public
272       returns (bool)
273     {
274         return (ETHAmounts[holderAddress] > 0 && SantaCoinRewardsInETH[holderAddress] == 0);
275     }
276 
277     // Initializes Santa coin
278     function Santacoin()
279     {
280         totalSupply = uint256(0);
281         NorthPoleAddress = msg.sender;
282     }
283 
284     // Used to get Santa Coins or
285     function () payable {
286 
287         // Open gifts if user has coins
288         if (msg.value == 0 && hasSantaCoins(msg.sender) == true && NorthPoleMintingEnabled == false && MaxSantaRewardPerToken > 0) {
289             balances[msg.sender] -= 1;
290             totalSupply -= 1;
291             uint256 santasGift = MaxSantaRewardPerToken-NorthPoleAF;
292             uint256 santaSecret = determineRandomNumberBetween(1, 20);
293             uint256 senderSantaSecretGuess = determineRandomNumberBetween(1, 20);
294             if (santaSecret == senderSantaSecretGuess) {
295                 msg.sender.transfer(santasGift);
296                 NorthPoleAddress.transfer(NorthPoleAF);
297                 SantaCoinRewardsInETH[msg.sender] += santasGift;
298             }
299         }
300 
301         // Get SantaCoins
302         else if (msg.value >= minimumSantaCoinContribution && NorthPoleMintingEnabled == true) {
303             uint256 tokensToCredit = askSantaForCoinAmountBetween(santaCoinMinterLowerBound, santaCoinMinterUpperBound);
304             tokensToCredit = tokensToCredit == 0 ? 1 : tokensToCredit;
305 
306             totalSupply += tokensToCredit;
307             ETHAmounts[msg.sender] += msg.value;
308             TotalETHGivenToNorthPole += msg.value;
309             balances[msg.sender] += tokensToCredit;
310             TotalSantaCoinsGivenByNorthPole += balances[msg.sender];
311         }
312 
313         else {
314             revert();
315         }
316     }
317 }