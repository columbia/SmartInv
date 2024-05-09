1 pragma solidity ^0.5.10;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transfer(address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16   /**
17      * @dev Returns the addition of two unsigned integers, reverting on
18      * overflow.
19      *
20      * Counterpart to Solidity's `+` operator.
21      *
22      * Requirements:
23      * - Addition cannot overflow.
24      */
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28 
29         return c;
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, reverting on
34      * overflow (when the result is negative).
35      *
36      * Counterpart to Solidity's `-` operator.
37      *
38      * Requirements:
39      * - Subtraction cannot overflow.
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a, "SafeMath: subtraction overflow");
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Returns the multiplication of two unsigned integers, reverting on
50      * overflow.
51      *
52      * Counterpart to Solidity's `*` operator.
53      *
54      * Requirements:
55      * - Multiplication cannot overflow.
56      */
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59         // benefit is lost if 'b' is also tested.
60         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61         if (a == 0) {
62             return 0;
63         }
64 
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the integer division of two unsigned integers. Reverts on
73      * division by zero. The result is rounded towards zero.
74      *
75      * Counterpart to Solidity's `/` operator. Note: this function uses a
76      * `revert` opcode (which leaves remaining gas untouched) while Solidity
77      * uses an invalid opcode to revert (consuming all remaining gas).
78      *
79      * Requirements:
80      * - The divisor cannot be zero.
81      */
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Solidity only automatically asserts when dividing by 0
84         require(b > 0, "SafeMath: division by zero");
85         uint256 c = a / b;
86         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87 
88         return c;
89     }
90   
91 }
92 
93 contract ERC20Detailed is IERC20 {
94 
95   uint8 private _Tokendecimals;
96   string private _Tokenname;
97   string private _Tokensymbol;
98 
99   constructor(string memory name, string memory symbol, uint8 decimals) public {
100    
101    _Tokendecimals = decimals;
102     _Tokenname = name;
103     _Tokensymbol = symbol;
104     
105   }
106 
107   function name() public view returns(string memory) {
108     return _Tokenname;
109   }
110 
111   function symbol() public view returns(string memory) {
112     return _Tokensymbol;
113   }
114 
115   function decimals() public view returns(uint8) {
116     return _Tokendecimals;
117   }
118  
119 }
120 
121 contract BLVD is ERC20Detailed {
122     //ERC20 contract for rewards within the BULVRD ecosystem
123     //https://bulvrdapp.com
124 
125     using SafeMath for uint256;
126 
127     //The oracle checks the authenticity of the rewards
128     address public oracle;
129     
130     //The maintainer is in charge of keeping the oracle running
131     address public maintainer;
132     
133     //The owner can replace the oracle or maintainer if they are compromised
134     address public owner;
135 
136     //Set max tokens that can be minted
137     uint256 public maxMintable;
138 
139     mapping(address => uint256) private _balanceOf;
140     mapping(address => mapping (address => uint256)) private _allowed;
141     
142     string public constant tokenSymbol = "BLVD";
143     string public constant tokenName = "BULVRD";
144     uint8 public constant tokenDecimals = 18;
145     uint256 public _totalSupply = 0;
146     
147     //Constant values for rewards
148     uint256 public limiter = 5;
149     uint256 public referral = 35;
150     uint256 public ar_drive = 15;
151     uint256 public closure = 15;
152     uint256 public map_drive = 10;
153     uint256 public dash_drive = 10;
154     uint256 public odb2_drive = 10;
155     uint256 public police = 10;
156     uint256 public hazard = 10;
157     uint256 public accident = 10;
158     uint256 public traffic = 5;
159     uint256 public twitter_share = 5;
160     uint256 public mastodon_share = 5;
161     uint256 public base_report = 5;
162     uint256 public validated_poi = 5;
163     uint256 public speed_sign = 1;
164     uint256 public report_init = 1;
165  
166     //Keep track of BULVRD users and their redeemed rewards
167     mapping(address => uint256) redeemedRewards;
168     mapping(address => uint256) latestWithdrawBlock;
169     
170     event Transfer(address indexed _from, address indexed _to, uint256 _value);
171     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
172     //The Redeem event is activated when a BULVRD user redeems rewards
173     event RedeemRewards(address indexed addr, uint256 rewards);
174     
175     constructor() public ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
176         owner = msg.sender;
177         maintainer = msg.sender;
178         oracle = msg.sender;
179         maxMintable = 50000000000 * 10**uint256(tokenDecimals);
180         //initial grant
181         redeemRewards(87500000000 * 10**uint256(tokenDecimals), owner);
182     }
183     
184     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
185         require(owner == msg.sender);
186         return IERC20(tokenAddress).transfer(owner, tokens);
187     }
188     
189     function totalSupply() public view returns (uint256) {
190         return _totalSupply;
191     }
192 
193     function balanceOf(address _owner) public view returns (uint256) {
194         return _balanceOf[_owner];
195     }
196 
197     function allowance(address _owner, address spender) public view returns (uint256) {
198         return _allowed[_owner][spender];
199     }
200 
201     function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
202         for (uint256 i = 0; i < receivers.length; i++) {
203             transfer(receivers[i], amounts[i]);
204         }
205     }
206   
207     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
208         require(spender != address(0));
209         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
210         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
211         return true;
212     }
213 
214     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
215         require(spender != address(0));
216         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
217         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218         return true;
219     }
220   
221      function transfer(address to, uint tokens) public returns (bool success) {
222         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(tokens);
223         _balanceOf[to] = _balanceOf[to].add(tokens);
224         emit Transfer(msg.sender, to, tokens);
225         return true;
226     }
227  
228     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
229         _balanceOf[from] = _balanceOf[from].sub(tokens);
230         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);
231         _balanceOf[to] = _balanceOf[to].add(tokens);
232         emit Transfer(from, to, tokens);
233         return true;
234     }
235  
236     function approve(address spender, uint tokens) public returns (bool success) {
237         _allowed[msg.sender][spender] = tokens;
238         emit Approval(msg.sender, spender, tokens);
239         return true;
240     }
241     
242     //The owner can transfer ownership
243     function transferOwnership(address newOwner) public {
244         require(owner == msg.sender);
245         require(newOwner != address(0));
246         owner = newOwner;
247     }
248     
249     //The owner can change the oracle
250     //This works only if removeOracle() was never called
251     function changeOracle(address newOracle) public {
252         require(owner == msg.sender);
253         require(oracle != address(0) && newOracle != address(0));
254         oracle = newOracle;
255     }
256     
257     //The owner can change the maintainer
258     function changeMaintainer(address newMaintainer) public {
259         require(owner == msg.sender);
260         maintainer = newMaintainer;
261     }
262     
263     //Allow address to redeem rewards verified from BULVRD
264     function redeemRewards(uint256 rewards, address destination) public {
265         
266         //Must be oracle 
267         require(msg.sender == oracle, "Must be Oracle to complete");
268 
269         //Make sure we have moved on since the last transaction of the give
270         require(block.number > latestWithdrawBlock[destination], "Have not moved on from last block");
271         
272         //rewards to token conversion
273         uint256 reward = SafeMath.div(rewards, limiter);
274         
275         //The amount of rewards needs to be more than the previous redeemed amount
276         require(reward > redeemedRewards[destination], "Has not earned since last redeem");
277         
278         //check if reward amount can be redeemed against supply
279         uint256 total = SafeMath.add(_totalSupply, reward);
280         require(total <= maxMintable, "Max Mintable Reached");
281 
282         //The new rewards that is available to be redeemed
283         uint256 newUserRewards = SafeMath.sub(reward, redeemedRewards[destination]);
284         
285         //The user's rewards balance is updated with the new reward
286         _balanceOf[destination] = SafeMath.add(_balanceOf[destination], newUserRewards);
287         
288         //The total supply (ERC20) is updated
289         _totalSupply = SafeMath.add(_totalSupply, newUserRewards);
290         
291         //The amount of rewards redeemed by a user is updated
292         redeemedRewards[destination] = reward;
293         
294         //Set block status for user transaction
295         latestWithdrawBlock[destination] = block.number;
296         
297         //The Redeem event is triggered
298         emit RedeemRewards(destination, newUserRewards);
299         //Update token holder balance on chain explorers
300         emit Transfer(oracle, destination, newUserRewards);
301     }
302     
303     //This function is a workaround because this.redeemedRewards cannot be public
304     //This is the limitation of the current Solidity compiler
305     function redeemedRewardsOf(address destination) public view returns(uint256) {
306         return redeemedRewards[destination];
307     }
308     
309     
310     //Helper methods to update rewards
311      function updateLimiter(uint256 value) public{
312          require(maintainer == msg.sender);
313          limiter = value;
314      }
315      
316      function updateReferral(uint256 value) public {
317          require(maintainer == msg.sender);
318          referral = value;
319      }
320      
321      function updateTwitterShare(uint256 value) public {
322          require(maintainer == msg.sender);
323          twitter_share = value;
324      }
325      
326      function updateMastodonShare(uint256 value) public {
327          require(maintainer == msg.sender);
328          mastodon_share = value;
329      }
330      
331      function updateArDrive(uint256 value) public {
332          require(maintainer == msg.sender);
333          ar_drive = value;
334      }
335      
336      function updateMapDrive(uint256 value) public {
337          require(maintainer == msg.sender);
338          map_drive = value;
339      }
340     
341     function updateDashDrive(uint256 value) public {
342         require(maintainer == msg.sender);
343          dash_drive = value;
344      }
345      
346      function updateObd2Drive(uint256 value) public {
347          require(maintainer == msg.sender);
348          odb2_drive = value;
349      }
350      
351      function updatePolice(uint256 value) public {
352          require(maintainer == msg.sender);
353          police = value;
354      }
355      
356      function updateClosure(uint256 value) public {
357         require(maintainer == msg.sender);
358          closure = value;
359      }
360      
361      function updateHazard(uint256 value) public {
362          require(maintainer == msg.sender);
363          hazard = value;
364      }
365      
366      function updateTraffic(uint256 value) public {
367          require(maintainer == msg.sender);
368          traffic = value;
369      }
370      
371      function updateAccident(uint256 value) public {
372          require(maintainer == msg.sender);
373          accident = value;
374      }
375      
376      function updateSpeedSign(uint256 value) public {
377          require(maintainer == msg.sender);
378          speed_sign = value;
379      }
380      
381      function updateBaseReport(uint256 value) public {
382          require(maintainer == msg.sender);
383          base_report = value;
384      }
385      
386      function updateValidatedPoi(uint256 value) public {
387          require(maintainer == msg.sender);
388          validated_poi = value;
389      }
390      
391      function updateReportInit(uint256 value) public {
392          require(maintainer == msg.sender);
393          report_init = value;
394      }
395 }