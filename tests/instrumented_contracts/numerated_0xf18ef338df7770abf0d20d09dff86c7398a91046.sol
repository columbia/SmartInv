1 pragma solidity ^0.4.21;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 /**
36 * @title Ownable
37 * @dev The Ownable contract has an owner address, and provides basic authorization control 
38 * functions, this simplifies the implementation of "user permissions". 
39 */ 
40 contract Ownable {
41     address public owner;
42 
43 /** 
44 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45 * account.
46 */
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     /**
52     * @dev Throws if called by any account other than the owner.
53     */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     /**
60     * @dev Allows the current owner to transfer control of the contract to a newOwner.
61     * @param newOwner The address to transfer ownership to.
62     */
63     function transferOwnership(address newOwner) public onlyOwner {
64         if (newOwner != address(0)) {
65             owner = newOwner;
66         }
67     }
68 }
69 
70 
71 /**
72  * @title ERC20Basic
73     * @dev Simpler version of ERC20 interface
74        * @dev see https://github.com/ethereum/EIPs/issues/179
75           */
76 contract ERC20Basic {
77     uint256 public totalSupply;
78     function balanceOf(address who) public constant returns  (uint256);
79     function transfer(address to, uint256 value) public returns (bool);
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89     using SafeMath for uint256;
90     mapping(address => uint256) balances;
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97     function transfer(address _to, uint256 _value) public returns (bool) {
98         balances[msg.sender] = balances[msg.sender].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100         return true;
101     }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105       * @param _owner The address to query the the balance of.
106           * @return An uint256 representing the amount owned by the passed address.
107               */
108     function balanceOf(address _owner) public constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 }
112 
113 
114 /**
115  * @title ERC20 interface
116     * @dev see https://github.com/ethereum/EIPs/issues/20
117        */
118 contract ERC20 is ERC20Basic {
119     function allowance(address owner, address spender) public constant returns (uint256);
120     function transferFrom(address from, address to, uint256 value) public returns (bool);
121     function approve(address spender, uint256 value) public returns (bool);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 /**
127  * @title Standard ERC20 token
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  */
131 contract StandardToken is ERC20, BasicToken {
132     mapping (address => mapping (address => uint256)) allowed;
133 
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         uint256 _allowance = allowed[_from][msg.sender];
136 
137     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
138     // require (_value <= _allowance);
139 
140         balances[_to] = balances[_to].add(_value);
141         balances[_from] = balances[_from].sub(_value);
142         allowed[_from][msg.sender] = _allowance.sub(_value);
143         return true;
144     }
145 
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         // To change the approve amount you first have to reduce the addresses`
148         //  allowance to zero by calling `approve(_spender, 0)` if it is not
149         //  already 0 to mitigate the race condition described here:
150         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
152 
153         allowed[msg.sender][_spender] = _value;
154         return true;
155     }
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint256 specifing the amount of tokens still avaible for the spender.
162    */
163     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
164         return allowed[_owner][_spender];
165     }
166 }
167 
168 
169 /*Token  Contract*/
170 contract BBBToken is StandardToken, Ownable {
171     using SafeMath for uint256;
172 
173     // Token 資訊
174     string  public constant NAME = "M724 Coin";
175     string  public constant SYMBOL = "M724";
176     uint8   public constant DECIMALS = 18;
177 
178     // Sale period1.
179     uint256 public startDate1;
180     uint256 public endDate1;
181 
182     // Sale period2.
183     uint256 public startDate2;
184     uint256 public endDate2;
185 
186      //目前銷售額
187     uint256 public saleCap;
188 
189     // Address Where Token are keep
190     address public tokenWallet;
191 
192     // Address where funds are collected.
193     address public fundWallet;
194 
195     // Amount of raised money in wei.
196     uint256 public weiRaised;
197 
198     // Event
199     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
200 
201     // Modifiers
202     modifier uninitialized() {
203         require(tokenWallet == 0x0);
204         require(fundWallet == 0x0);
205         _;
206     }
207 
208     constructor() public {}
209     // Trigger with Transfer event
210     // Fallback function can be used to buy tokens
211     function () public payable {
212         buyTokens(msg.sender, msg.value);
213     }
214 
215     function getDate() public view returns(uint256 _date) {
216         _date = getCurrentTimestamp();
217     }
218 
219     //初始化合約
220     function initialize(address _tokenWallet, address _fundWallet, uint256 _start1, uint256 _end1,
221                         uint256 _saleCap, uint256 _totalSupply) public
222                         onlyOwner uninitialized {
223         //require(_start >= getCurrentTimestamp());
224         require(_start1 < _end1);
225         require(_tokenWallet != 0x0);
226         require(_fundWallet != 0x0);
227         require(_totalSupply >= _saleCap);
228 
229         startDate1 = _start1;
230         endDate1 = _end1;
231         saleCap = _saleCap;
232         tokenWallet = _tokenWallet;
233         fundWallet = _fundWallet;
234         totalSupply = _totalSupply;
235 
236         balances[tokenWallet] = saleCap;
237         balances[0xb1] = _totalSupply.sub(saleCap);
238     }
239 
240     //設定銷售期間
241     function setPeriod(uint period, uint256 _start, uint256 _end) public onlyOwner {
242         require(_end > _start);
243         if (period == 1) {
244             startDate1 = _start;
245             endDate1 = _end;
246         }else if (period == 2) {
247             require(_start > endDate1);
248             startDate2 = _start;
249             endDate2 = _end;      
250         }
251     }
252 
253     // For pushing pre-ICO records
254     function sendForPreICO(address buyer, uint256 amount) public onlyOwner {
255         require(saleCap >= amount);
256 
257         saleCap = saleCap - amount;
258         // Transfer
259         balances[tokenWallet] = balances[tokenWallet].sub(amount);
260         balances[buyer] = balances[buyer].add(amount);
261     }
262 
263         //Set SaleCap
264     function setSaleCap(uint256 _saleCap) public onlyOwner {
265         require(balances[0xb1].add(balances[tokenWallet]).sub(_saleCap) > 0);
266         uint256 amount=0;
267         //目前銷售額 大於 新銷售額
268         if (balances[tokenWallet] > _saleCap) {
269             amount = balances[tokenWallet].sub(_saleCap);
270             balances[0xb1] = balances[0xb1].add(amount);
271         } else {
272             amount = _saleCap.sub(balances[tokenWallet]);
273             balances[0xb1] = balances[0xb1].sub(amount);
274         }
275         balances[tokenWallet] = _saleCap;
276         saleCap = _saleCap;
277     }
278 
279     //Calcute Bouns
280     function getBonusByTime(uint256 atTime) public constant returns (uint256) {
281         if (atTime < startDate1) {
282             return 0;
283         } else if (endDate1 > atTime && atTime > startDate1) {
284             return 5000;
285         } else if (endDate2 > atTime && atTime > startDate2) {
286             return 2500;
287         } else {
288             return 0;
289         }
290     }
291 
292     function getBounsByAmount(uint256 etherAmount, uint256 tokenAmount) public pure returns (uint256) {
293         //最高40%
294         uint256 bonusRatio = etherAmount.div(500 ether);
295         if (bonusRatio > 4) {
296             bonusRatio = 4;
297         }
298         uint256 bonusCount = SafeMath.mul(bonusRatio, 10);
299         uint256 bouns = SafeMath.mul(tokenAmount, bonusCount);
300         uint256 realBouns = SafeMath.div(bouns, 100);
301         return realBouns;
302     }
303 
304     //終止合約
305     function finalize() public onlyOwner {
306         require(!saleActive());
307 
308         // Transfer the rest of token to tokenWallet
309         balances[tokenWallet] = balances[tokenWallet].add(balances[0xb1]);
310         balances[0xb1] = 0;
311     }
312     
313     //確認是否正常銷售
314     function saleActive() public constant returns (bool) {
315         return (
316             (getCurrentTimestamp() >= startDate1 &&
317                 getCurrentTimestamp() < endDate1 && saleCap > 0) ||
318             (getCurrentTimestamp() >= startDate2 &&
319                 getCurrentTimestamp() < endDate2 && saleCap > 0)
320                 );
321     }
322    
323     //Get CurrentTS
324     function getCurrentTimestamp() internal view returns (uint256) {
325         return now;
326     }
327 
328      //購買Token
329     function buyTokens(address sender, uint256 value) internal {
330         //Check Sale Status
331         require(saleActive());
332         
333         //Minum buying limit
334         require(value >= 0.5 ether);
335 
336         // Calculate token amount to be purchased
337         uint256 bonus = getBonusByTime(getCurrentTimestamp());
338         uint256 amount = value.mul(bonus);
339         // 第一階段銷售期，每次購買量超過500Ether，多增加10%
340         if (getCurrentTimestamp() >= startDate1 && getCurrentTimestamp() < endDate1) {
341             uint256 p1Bouns = getBounsByAmount(value, amount);
342             amount = amount + p1Bouns;
343         }
344         // We have enough token to sale
345         require(saleCap >= amount);
346 
347         // Transfer
348         balances[tokenWallet] = balances[tokenWallet].sub(amount);
349         balances[sender] = balances[sender].add(amount);
350 
351         saleCap = saleCap - amount;
352 
353         // Update state.
354         weiRaised = weiRaised + value;
355 
356         // Forward the fund to fund collection wallet.
357         //tokenWallet.transfer(msg.value);
358         fundWallet.transfer(msg.value);
359     }   
360 }