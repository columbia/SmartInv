1 pragma solidity ^0.4.11;
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
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances. 
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) returns (bool) {
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of. 
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender) constant returns (uint256);
85   function transferFrom(address from, address to, uint256 value) returns (bool);
86   function approve(address spender, uint256 value) returns (bool);
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * @dev https://github.com/ethereum/EIPs/issues/20
95  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  */
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) allowed;
100 
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still avaible for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 }
149 
150 contract GVOptionToken is StandardToken {
151     
152     address public optionProgram;
153 
154     string public name;
155     string public symbol;
156     uint   public constant decimals = 18;
157 
158     uint TOKEN_LIMIT;
159 
160     // Modifiers
161     modifier optionProgramOnly { require(msg.sender == optionProgram); _; }
162 
163     // Constructor
164     function GVOptionToken(
165         address _optionProgram,
166         string _name,
167         string _symbol,
168         uint _TOKEN_LIMIT
169     ) {
170         require(_optionProgram != 0);        
171         optionProgram = _optionProgram;
172         name = _name;
173         symbol = _symbol;
174         TOKEN_LIMIT = _TOKEN_LIMIT;
175     }
176 
177     // Create tokens
178     function buyOptions(address buyer, uint value) optionProgramOnly {
179         require(value > 0);
180         require(totalSupply + value <= TOKEN_LIMIT);
181 
182         balances[buyer] += value;
183         totalSupply += value;
184         Transfer(0x0, buyer, value);
185     }
186     
187     function remainingTokensCount() returns(uint) {
188         return TOKEN_LIMIT - totalSupply;
189     }
190     
191     // Burn option tokens after execution during ICO
192     function executeOption(address addr, uint optionsCount) 
193         optionProgramOnly
194         returns (uint) {
195         if (balances[addr] < optionsCount) {
196             optionsCount = balances[addr];
197         }
198         if (optionsCount == 0) {
199             return 0;
200         }
201 
202         balances[addr] -= optionsCount;
203         totalSupply -= optionsCount;
204 
205         return optionsCount;
206     }
207 }
208 
209 contract GVOptionProgram {
210 
211     // Constants
212     uint constant option30perCent = 26 * 1e16; // GVOT30 tokens per usd cent during option purchase 
213     uint constant option20perCent = 24 * 1e16; // GVOT20 tokens per usd cent during option purchase
214     uint constant option10perCent = 22 * 1e16; // GVOT10 tokens per usd cent during option purchase
215     uint constant token30perCent  = 13684210526315800;  // GVT tokens per usd cent during execution of GVOT30
216     uint constant token20perCent  = 12631578947368500;  // GVT tokens per usd cent during execution of GVOT20
217     uint constant token10perCent  = 11578947368421100;  // GVT tokens per usd cent during execution of GVOT10
218 
219     string public constant option30name = "30% GVOT";
220     string public constant option20name = "20% GVOT";
221     string public constant option10name = "10% GVOT";
222 
223     string public constant option30symbol = "GVOT30";
224     string public constant option20symbol = "GVOT20";
225     string public constant option10symbol = "GVOT10";
226 
227     uint constant option30_TOKEN_LIMIT = 26 * 1e5 * 1e18;
228     uint constant option20_TOKEN_LIMIT = 36 * 1e5 * 1e18;
229     uint constant option10_TOKEN_LIMIT = 55 * 1e5 * 1e18;
230 
231     // Events
232     event BuyOptions(address buyer, uint amount, string tx, uint8 optionType);
233     event ExecuteOptions(address buyer, uint amount, string tx, uint8 optionType);
234 
235     // State variables
236     address public gvAgent; // payments bot account
237     address public team;    // team account
238     address public ico;     
239 
240     GVOptionToken public gvOptionToken30;
241     GVOptionToken public gvOptionToken20;
242     GVOptionToken public gvOptionToken10;
243 
244     // Modifiers
245     modifier icoOnly { require(msg.sender == ico); _; }
246     
247     // Constructor
248     function GVOptionProgram(address _ico, address _gvAgent, address _team) {
249         gvOptionToken30 = new GVOptionToken(this, option30name, option30symbol, option30_TOKEN_LIMIT);
250         gvOptionToken20 = new GVOptionToken(this, option20name, option20symbol, option20_TOKEN_LIMIT);
251         gvOptionToken10 = new GVOptionToken(this, option10name, option10symbol, option10_TOKEN_LIMIT);
252         gvAgent = _gvAgent;
253         team = _team;
254         ico = _ico;
255     }
256 
257     // Get remaining tokens for all types of option tokens
258     function getBalance() public returns (uint, uint, uint) {
259         return (gvOptionToken30.remainingTokensCount(), gvOptionToken20.remainingTokensCount(), gvOptionToken10.remainingTokensCount());
260     }
261 
262     // Execute options during the ICO token purchase. Priority: GVOT30 -> GVOT20 -> GVOT10
263     function executeOptions(address buyer, uint usdCents, string txHash) icoOnly
264         returns (uint executedTokens, uint remainingCents) {
265         require(usdCents > 0);
266 
267         (executedTokens, remainingCents) = executeIfAvailable(buyer, usdCents, txHash, gvOptionToken30, 0, token30perCent);
268         if (remainingCents == 0) {
269             return (executedTokens, 0);
270         }
271 
272         uint executed20;
273         (executed20, remainingCents) = executeIfAvailable(buyer, remainingCents, txHash, gvOptionToken20, 1, token20perCent);
274         if (remainingCents == 0) {
275             return (executedTokens + executed20, 0);
276         }
277 
278         uint executed10;
279         (executed10, remainingCents) = executeIfAvailable(buyer, remainingCents, txHash, gvOptionToken10, 2, token10perCent);
280         
281         return (executedTokens + executed20 + executed10, remainingCents);
282     }
283 
284     // Buy option tokens. Priority: GVOT30 -> GVOT20 -> GVOT10
285     function buyOptions(address buyer, uint usdCents, string txHash) icoOnly {
286         require(usdCents > 0);
287 
288         var remainUsdCents = buyIfAvailable(buyer, usdCents, txHash, gvOptionToken30, 0, option30perCent);
289         if (remainUsdCents == 0) {
290             return;
291         }
292 
293         remainUsdCents = buyIfAvailable(buyer, remainUsdCents, txHash, gvOptionToken20, 1, option20perCent);
294         if (remainUsdCents == 0) {
295             return;
296         }
297 
298         remainUsdCents = buyIfAvailable(buyer, remainUsdCents, txHash, gvOptionToken10, 2, option10perCent);
299     }   
300 
301     // Private functions
302     
303     function executeIfAvailable(address buyer, uint usdCents, string txHash,
304         GVOptionToken optionToken, uint8 optionType, uint optionPerCent)
305         private returns (uint executedTokens, uint remainingCents) {
306         
307         var optionsAmount = usdCents * optionPerCent;
308         executedTokens = optionToken.executeOption(buyer, optionsAmount);
309         remainingCents = usdCents - (executedTokens / optionPerCent);
310         if (executedTokens > 0) {
311             ExecuteOptions(buyer, executedTokens, txHash, optionType);
312         }
313         return (executedTokens, remainingCents);
314     }
315 
316     function buyIfAvailable(address buyer, uint usdCents, string txHash,
317         GVOptionToken optionToken, uint8 optionType, uint optionsPerCent)
318         private returns (uint) {
319         
320         var availableTokens = optionToken.remainingTokensCount(); 
321         if (availableTokens > 0) {
322             var tokens = usdCents * optionsPerCent;
323             if(availableTokens >= tokens) {
324                 optionToken.buyOptions(buyer, tokens);
325                 BuyOptions(buyer, tokens, txHash, optionType);
326                 return 0;
327             }
328             else {
329                 optionToken.buyOptions(buyer, availableTokens);
330                 BuyOptions(buyer, availableTokens, txHash, optionType);
331                 return usdCents - availableTokens / optionsPerCent;
332             }
333         }
334         return usdCents;
335     }
336 }