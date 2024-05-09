1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  * World War Goo - Competitive Idle Game
6  * 
7  * https:/ethergoo.io
8  * 
9  */
10 
11 interface ERC20 {
12     function totalSupply() external constant returns (uint);
13     function balanceOf(address tokenOwner) external constant returns (uint balance);
14     function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
15     function transfer(address to, uint tokens) external returns (bool success);
16     function approve(address spender, uint tokens) external returns (bool success);
17     function approveAndCall(address spender, uint tokens, bytes data) external returns (bool success);
18     function transferFrom(address from, address to, uint tokens) external returns (bool success);
19 
20     event Transfer(address indexed from, address indexed to, uint tokens);
21     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
22 }
23 
24 interface ApproveAndCallFallBack {
25     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
26 }
27 
28 contract GooToken is ERC20 {
29     using SafeMath for uint;
30     using SafeMath224 for uint224;
31     
32     string public constant name  = "Vials of Goo";
33     string public constant symbol = "GOO";
34     uint8 public constant decimals = 12;
35     uint224 public constant MAX_SUPPLY = 21000000 * (10 ** 12); // 21 million (to 12 szabo decimals)
36     
37     mapping(address => UserBalance) balances;
38     mapping(address => mapping(address => uint256)) allowed;
39     
40     mapping(address => uint256) public gooProduction; // Store player's current goo production
41     mapping(address => bool) operator;
42     
43     uint224 private totalGoo;
44     uint256 public teamAllocation; // 10% reserve allocation towards exchange-listing negotiations, game costs, and ongoing community contests/aidrops
45     address public owner; // Minor management of game
46     bool public supplyCapHit; // No more production once we hit MAX_SUPPLY
47     
48     struct UserBalance {
49         uint224 goo;
50         uint32 lastGooSaveTime;
51     }
52     
53     constructor() public {
54         teamAllocation = MAX_SUPPLY / 10;
55         owner = msg.sender;
56     }
57     
58     function totalSupply() external view returns(uint) {
59         return totalGoo;
60     }
61     
62     function transfer(address to, uint256 tokens) external returns (bool) {
63         updatePlayersGooInternal(msg.sender);
64         
65         require(tokens <= MAX_SUPPLY); // Prevent uint224 overflow
66         uint224 amount = uint224(tokens); // Goo is uint224 but must comply to ERC20's uint256
67 
68         balances[msg.sender].goo = balances[msg.sender].goo.sub(amount);
69         emit Transfer(msg.sender, to, amount);
70         
71         if (to == address(0)) { // Burn
72             totalGoo -= amount;
73         } else {
74             balances[to].goo = balances[to].goo.add(amount);
75         }
76         return true;
77     }
78     
79     function transferFrom(address from, address to, uint256 tokens) external returns (bool) {
80         updatePlayersGooInternal(from);
81         
82         require(tokens <= MAX_SUPPLY); // Prevent uint224 overflow
83         uint224 amount = uint224(tokens); // Goo is uint224 but must comply to ERC20's uint256
84         
85         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
86         balances[from].goo = balances[from].goo.sub(amount);
87         emit Transfer(from, to, amount);
88         
89         if (to == address(0)) { // Burn
90             totalGoo -= amount;
91         } else {
92             balances[to].goo = balances[to].goo.add(amount);
93         }
94         return true;
95     }
96     
97     function unlockAllocation(uint224 amount, address recipient) external {
98         require(msg.sender == owner);
99         teamAllocation = teamAllocation.sub(amount); // Hard limit
100         
101         totalGoo += amount;
102         balances[recipient].goo = balances[recipient].goo.add(amount);
103         emit Transfer(address(0), recipient, amount);
104     }
105     
106     function setOperator(address gameContract, bool isOperator) external {
107         require(msg.sender == owner);
108         operator[gameContract] = isOperator;
109     }
110     
111     function approve(address spender, uint256 tokens) external returns (bool) {
112         allowed[msg.sender][spender] = tokens;
113         emit Approval(msg.sender, spender, tokens);
114         return true;
115     }
116     
117     function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
118         allowed[msg.sender][spender] = tokens;
119         emit Approval(msg.sender, spender, tokens);
120         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
121         return true;
122     }
123     
124     function allowance(address tokenOwner, address spender) external view returns (uint256) {
125         return allowed[tokenOwner][spender];
126     }
127 
128     function recoverAccidentalTokens(address tokenAddress, uint256 tokens) external {
129         require(msg.sender == owner);
130         require(tokenAddress != address(this)); // Not Goo
131         ERC20(tokenAddress).transfer(owner, tokens);
132     }
133     
134     function balanceOf(address player) public constant returns(uint256) {
135         return balances[player].goo + balanceOfUnclaimedGoo(player);
136     }
137     
138     function balanceOfUnclaimedGoo(address player) internal constant returns (uint224 gooGain) {
139         if (supplyCapHit) return;
140         
141         uint32 lastSave = balances[player].lastGooSaveTime;
142         if (lastSave > 0 && lastSave < block.timestamp) {
143             gooGain = uint224(gooProduction[player] * (block.timestamp - lastSave));
144         }
145         
146         if (totalGoo + gooGain >= MAX_SUPPLY) {
147             gooGain = MAX_SUPPLY - totalGoo;
148         }
149     }
150     
151     function mintGoo(uint224 amount, address player) external {
152         if (supplyCapHit) return;
153         require(operator[msg.sender]);
154         
155         uint224 minted = amount;
156         if (totalGoo.add(amount) >= MAX_SUPPLY) {
157             supplyCapHit = true;
158             minted = MAX_SUPPLY - totalGoo;
159         }
160 
161         balances[player].goo += minted;
162         totalGoo += minted;
163         emit Transfer(address(0), player, minted);
164     }
165     
166     function updatePlayersGoo(address player) external {
167         require(operator[msg.sender]);
168         updatePlayersGooInternal(player);
169     }
170     
171     function updatePlayersGooInternal(address player) internal {
172         uint224 gooGain = balanceOfUnclaimedGoo(player);
173         
174         UserBalance memory balance = balances[player];
175         if (gooGain > 0) {
176             totalGoo += gooGain;
177             if (!supplyCapHit && totalGoo == MAX_SUPPLY) {
178                 supplyCapHit = true;
179             }
180             
181             balance.goo += gooGain;
182             emit Transfer(address(0), player, gooGain);
183         }
184         
185         if (balance.lastGooSaveTime < block.timestamp) {
186             balance.lastGooSaveTime = uint32(block.timestamp); 
187             balances[player] = balance;
188         }
189     }
190     
191     function updatePlayersGooFromPurchase(address player, uint224 purchaseCost) external {
192         require(operator[msg.sender]);
193         uint224 unclaimedGoo = balanceOfUnclaimedGoo(player);
194         
195         UserBalance memory balance = balances[player];
196         balance.lastGooSaveTime = uint32(block.timestamp); 
197         
198         if (purchaseCost > unclaimedGoo) {
199             uint224 gooDecrease = purchaseCost - unclaimedGoo;
200             totalGoo -= gooDecrease;
201             balance.goo = balance.goo.sub(gooDecrease);
202             emit Transfer(player, address(0), gooDecrease);
203         } else {
204             uint224 gooGain = unclaimedGoo - purchaseCost;
205             totalGoo += gooGain;
206             balance.goo += gooGain;
207             if (!supplyCapHit && totalGoo == MAX_SUPPLY) {
208                 supplyCapHit = true;
209             }
210             emit Transfer(address(0), player, gooGain);
211         }
212         balances[player] = balance;
213     }
214     
215     function increasePlayersGooProduction(address player, uint256 increase) external {
216         require(operator[msg.sender]);
217         gooProduction[player] += increase;
218     }
219     
220     function decreasePlayersGooProduction(address player, uint256 decrease) external {
221         require(operator[msg.sender]);
222         gooProduction[player] -= decrease;
223     }
224 
225 }
226 
227 
228 
229 
230 
231 
232 
233 
234 
235 
236 
237 
238 
239 
240 
241 
242 
243 
244 
245 library SafeMath {
246 
247   /**
248   * @dev Multiplies two numbers, throws on overflow.
249   */
250   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251     if (a == 0) {
252       return 0;
253     }
254     uint256 c = a * b;
255     assert(c / a == b);
256     return c;
257   }
258 
259   /**
260   * @dev Integer division of two numbers, truncating the quotient.
261   */
262   function div(uint256 a, uint256 b) internal pure returns (uint256) {
263     // assert(b > 0); // Solidity automatically throws when dividing by 0
264     uint256 c = a / b;
265     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
266     return c;
267   }
268 
269   /**
270   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
271   */
272   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
273     assert(b <= a);
274     return a - b;
275   }
276 
277   /**
278   * @dev Adds two numbers, throws on overflow.
279   */
280   function add(uint256 a, uint256 b) internal pure returns (uint256) {
281     uint256 c = a + b;
282     assert(c >= a);
283     return c;
284   }
285 }
286 
287 
288 
289 
290 library SafeMath224 {
291 
292   /**
293   * @dev Multiplies two numbers, throws on overflow.
294   */
295   function mul(uint224 a, uint224 b) internal pure returns (uint224) {
296     if (a == 0) {
297       return 0;
298     }
299     uint224 c = a * b;
300     assert(c / a == b);
301     return c;
302   }
303 
304   /**
305   * @dev Integer division of two numbers, truncating the quotient.
306   */
307   function div(uint224 a, uint224 b) internal pure returns (uint224) {
308     // assert(b > 0); // Solidity automatically throws when dividing by 0
309     uint224 c = a / b;
310     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
311     return c;
312   }
313 
314   /**
315   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
316   */
317   function sub(uint224 a, uint224 b) internal pure returns (uint224) {
318     assert(b <= a);
319     return a - b;
320   }
321 
322   /**
323   * @dev Adds two numbers, throws on overflow.
324   */
325   function add(uint224 a, uint224 b) internal pure returns (uint224) {
326     uint224 c = a + b;
327     assert(c >= a);
328     return c;
329   }
330 }