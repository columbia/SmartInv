1 pragma solidity ^0.4.11;
2  
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10  function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() public {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72   uint256 public totalSupply;
73   function balanceOf(address who) constant public returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) tokenBalances;
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) public returns (bool) {
93     require(tokenBalances[msg.sender]>=_value);
94     tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);
95     tokenBalances[_to] = tokenBalances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) constant public returns (uint256 balance) {
106     return tokenBalances[_owner];
107   }
108   
109 }
110 
111 contract RevolutionCoin is BasicToken,Ownable {
112 
113    using SafeMath for uint256;
114    
115    string public constant name = "R-evolutioncoin";
116    string public constant symbol = "RVL";
117    uint256 public constant decimals = 18;
118    uint256 public preIcoBuyPrice = 222222222222222;   // per token the price is 2.2222*10^-4 eth, this price is equivalent in wei
119    uint256 public IcoPrice = 1000000000000000;
120    uint256 public bonusPhase1 = 30;
121    uint256 public bonusPhase2 = 20;
122    uint256 public bonusPhase3 = 10;
123    uint256 public TOKENS_SOLD;
124   
125    address public ethStore = 0xDd64EF0c8a41d8a17F09ce2279D79b3397184A10;
126    uint256 public constant INITIAL_SUPPLY = 100000000;
127    event Debug(string message, address addr, uint256 number);
128    event log(string message, uint256 number);
129    /**
130    * @dev Contructor that gives msg.sender all of existing tokens.
131    */
132    //TODO: Change the name of the constructor
133     function RevolutionCoin() public {
134         owner = ethStore;
135         totalSupply = INITIAL_SUPPLY;
136         tokenBalances[ethStore] = INITIAL_SUPPLY * (10 ** uint256(decimals));   //Since we divided the token into 10^18 parts
137         TOKENS_SOLD = 0;
138     }
139     
140     
141     // fallback function can be used to buy tokens
142       function () public payable {
143        // require(msg.sender != owner);   //owner should not be buying any tokens
144         buy(msg.sender);
145     }
146     
147     function calculateTokens(uint amt) internal returns (uint tokensYouCanGive, uint returnAmount) {
148         uint bonus = 0;
149         uint tokensRequired = 0;
150         uint tokensWithoutBonus = 0;
151         uint priceCharged = 0;
152         
153         //pre-ico phase
154         if (TOKENS_SOLD <4500000)
155         {
156             tokensRequired = amt.div(preIcoBuyPrice);
157             if (tokensRequired + TOKENS_SOLD > 4500000)
158             {
159                 tokensYouCanGive = 4500000 - TOKENS_SOLD;
160                 returnAmount = tokensRequired - tokensYouCanGive;
161                 returnAmount = returnAmount.mul(preIcoBuyPrice);
162                 log("Tokens being bought exceed the limit of pre-ico. Returning remaining amount",returnAmount);
163             }
164             else
165             {
166                 tokensYouCanGive = tokensRequired;
167                 returnAmount = 0;
168             }
169             require (tokensYouCanGive + TOKENS_SOLD <= 4500000);
170         }
171         //ico phase 1 with 30% bonus
172         else if (TOKENS_SOLD >=4500000 && TOKENS_SOLD <24000000)
173         {
174              tokensRequired = amt.div(IcoPrice);
175              bonus = tokensRequired.mul(bonusPhase1);
176              bonus = bonus.div(100);
177              tokensRequired = tokensRequired.add(bonus);
178              if (tokensRequired + TOKENS_SOLD > 24000000)
179              {
180                 tokensYouCanGive = 24000000 - TOKENS_SOLD;
181                 tokensWithoutBonus = tokensYouCanGive.mul(10);
182                 tokensWithoutBonus = tokensWithoutBonus.div(13);
183                 
184                 priceCharged = tokensWithoutBonus.mul(IcoPrice); 
185                 returnAmount = amt - priceCharged;
186                 
187                 log("Tokens being bought exceed the limit of ico phase 1. Returning remaining amount",returnAmount);
188              }
189              else
190             {
191                 tokensYouCanGive = tokensRequired;
192                 returnAmount = 0;
193             }
194             require (tokensYouCanGive + TOKENS_SOLD <= 24000000);
195         }
196         //ico phase 2 with 20% bonus
197         if (TOKENS_SOLD >=24000000 && TOKENS_SOLD <42000000)
198         {
199              tokensRequired = amt.div(IcoPrice);
200              bonus = tokensRequired.mul(bonusPhase2);
201              bonus = bonus.div(100);
202              tokensRequired = tokensRequired.add(bonus);
203              if (tokensRequired + TOKENS_SOLD > 42000000)
204              {
205                 tokensYouCanGive = 42000000 - TOKENS_SOLD;
206                 tokensWithoutBonus = tokensYouCanGive.mul(10);
207                 tokensWithoutBonus = tokensWithoutBonus.div(13);
208                 
209                 priceCharged = tokensWithoutBonus.mul(IcoPrice); 
210                 returnAmount = amt - priceCharged;
211                 log("Tokens being bought exceed the limit of ico phase 2. Returning remaining amount",returnAmount);
212              }
213               else
214             {
215                 tokensYouCanGive = tokensRequired;
216                 returnAmount = 0;
217             }
218              require (tokensYouCanGive + TOKENS_SOLD <= 42000000);
219         }
220         //ico phase 3 with 10% bonus
221         if (TOKENS_SOLD >=42000000 && TOKENS_SOLD <58500000)
222         {
223              tokensRequired = amt.div(IcoPrice);
224              bonus = tokensRequired.mul(bonusPhase3);
225              bonus = bonus.div(100);
226              tokensRequired = tokensRequired.add(bonus);
227               if (tokensRequired + TOKENS_SOLD > 58500000)
228              {
229                 tokensYouCanGive = 58500000 - TOKENS_SOLD;
230                 tokensWithoutBonus = tokensYouCanGive.mul(10);
231                 tokensWithoutBonus = tokensWithoutBonus.div(13);
232                 
233                 priceCharged = tokensWithoutBonus.mul(IcoPrice); 
234                 returnAmount = amt - priceCharged;
235                 log("Tokens being bought exceed the limit of ico phase 3. Returning remaining amount",returnAmount);
236              }
237             else
238             {
239                 tokensYouCanGive = tokensRequired;
240                 returnAmount = 0;
241             }
242              require (tokensYouCanGive + TOKENS_SOLD <= 58500000);
243         }
244         if (TOKENS_SOLD == 58500000)
245         {
246             log("ICO has ended. All tokens sold.", 58500000);
247             tokensYouCanGive = 0;
248             returnAmount = amt;
249         }
250         require(TOKENS_SOLD <=58500000);
251     }
252     
253     function buy(address beneficiary) payable public returns (uint tokens) {
254         uint paymentToGiveBack = 0;
255         (tokens,paymentToGiveBack) = calculateTokens(msg.value);
256         
257         TOKENS_SOLD += tokens;
258         tokens = tokens * (10 ** uint256(decimals));
259         
260         require(tokenBalances[owner] >= tokens);               // checks if it has enough to sell
261         
262         tokenBalances[beneficiary] = tokenBalances[beneficiary].add(tokens);                  // adds the amount to buyer's balance
263         tokenBalances[owner] = tokenBalances[owner].sub(tokens);                        // subtracts amount from seller's balance
264         
265         Transfer(owner, beneficiary, tokens);               // execute an event reflecting the change
266     
267         if (paymentToGiveBack >0)
268         {
269             beneficiary.transfer(paymentToGiveBack);
270         }
271     
272         ethStore.transfer(msg.value - paymentToGiveBack);                       //send the eth to the address where eth should be collected
273         
274         return tokens;                                    // ends function and returns
275     }
276     
277    function getTokenBalance(address yourAddress) constant public returns (uint256 balance) {
278         return tokenBalances[yourAddress].div (10**decimals); // show token balance in full tokens not part
279     }
280 }