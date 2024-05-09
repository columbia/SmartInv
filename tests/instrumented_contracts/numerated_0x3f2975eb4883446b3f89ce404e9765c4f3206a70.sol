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
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 /**
34 * @title Ownable
35 * @dev The Ownable contract has an owner address, and provides basic authorization control 
36 * functions, this simplifies the implementation of "user permissions". 
37 */ 
38 contract Ownable {
39     address public owner;
40 
41 /** 
42 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43 * account.
44 */
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     /**
50     * @dev Throws if called by any account other than the owner.
51     */
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     /**
58     * @dev Allows the current owner to transfer control of the contract to a newOwner.
59     * @param newOwner The address to transfer ownership to.
60     */
61     function transferOwnership(address newOwner) public onlyOwner {
62         if (newOwner != address(0)) {
63             owner = newOwner;
64         }
65     }
66 }
67 
68 
69 /**
70 * @title ERC20Basic
71 * @dev Simpler version of ERC20 interface
72 * @dev see https://github.com/ethereum/EIPs/issues/179
73 */
74 contract ERC20Basic {
75     uint256 public totalSupply;
76     function balanceOf(address who) public constant returns  (uint256);
77     function transfer(address to, uint256 value) public returns (bool);
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 
82 /**
83 * @title Basic token
84 * @dev Basic version of StandardToken, with no allowances. 
85 */
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91     /**
92     * @dev transfer token for a specified address
93     * @param _to The address to transfer to.
94     * @param _value The amount to be transferred.
95     */
96     function transfer(address _to, uint256 _value) public returns (bool) {
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         emit Transfer(msg.sender, _to, _value);
100         return true;
101     }
102 
103     /**
104     * @dev Gets the balance of the specified address.
105     * @param _owner The address to query the the balance of. 
106     * @return An uint256 representing the amount owned by the passed address.
107     */
108     function balanceOf(address _owner) public constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 }
112 
113 
114     /**
115     * @title ERC20 interface
116     * @dev see https://github.com/ethereum/EIPs/issues/20
117     */
118 contract ERC20 is ERC20Basic {
119     function allowance(address owner, address spender) public constant returns (uint256);
120     function transferFrom(address from, address to, uint256 value) public returns (bool);
121     function approve(address spender, uint256 value) public returns (bool);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 /**
127 * @title Standard ERC20 token
128 *
129 * @dev Implementation of the basic standard token.
130 * @dev https://github.com/ethereum/EIPs/issues/20
131 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132 */
133 contract StandardToken is ERC20, BasicToken {
134 
135     mapping (address => mapping (address => uint256)) internal allowed;
136 
137     /**
138     * @dev Transfer tokens from one address to another
139     * @param _from address The address which you want to send tokens from
140     * @param _to address The address which you want to transfer to
141     * @param _value uint256 the amout of tokens to be transfered
142     */
143     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
145     // require (_value <= _allowance);
146 
147         balances[_to] = balances[_to].add(_value);
148         balances[_from] = balances[_from].sub(_value);
149         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150         emit Transfer(_from, _to, _value);
151         return true;
152     }       
153 
154     /**
155     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
156     * @param _spender The address which will spend the funds.
157     * @param _value The amount of tokens to be spent.
158     */
159     function approve(address _spender, uint256 _value) public returns (bool) {
160 
161     // To change the approve amount you first have to reduce the addresses`
162     //  allowance to zero by calling `approve(_spender, 0)` if it is not
163     //  already 0 to mitigate the race condition described here:
164     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
166 
167         allowed[msg.sender][_spender] = _value;
168         emit Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     /**
173     * @dev Function to check the amount of tokens that an owner allowed to a spender.
174     * @param _owner address The address which owns the funds.
175     * @param _spender address The address which will spend the funds.
176     * @return A uint256 specifing the amount of tokens still avaible for the spender.
177     */
178     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
179         return allowed[_owner][_spender];
180     }
181 }
182 
183 
184 /*Token  Contract*/
185 contract ZXCToken is StandardToken, Ownable {
186     using SafeMath for uint256;
187 
188     // Token Information
189     string  public constant name = "MK7 Coin";
190     string  public constant symbol = "MK7";
191     uint8   public constant decimals = 18;
192 
193     // Sale period1.
194     uint256 public startDate1;
195     uint256 public endDate1;
196 
197     // Sale period2.
198     uint256 public startDate2;
199     uint256 public endDate2;
200 
201     //SaleCap
202     uint256 public saleCap;
203 
204     // Address Where Token are keep
205     address public tokenWallet;
206 
207     // Address where funds are collected.
208     address public fundWallet;
209 
210     // Amount of raised money in wei.
211     uint256 public weiRaised;
212 
213     // Event
214     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
215     event PreICOTokenPushed(address indexed buyer, uint256 amount);
216 
217     // Modifiers
218     modifier uninitialized() {
219         require(tokenWallet == 0x0);
220         require(fundWallet == 0x0);
221         _;
222     }
223 
224     constructor() public {}
225     // Trigger with Transfer event
226     // Fallback function can be used to buy tokens
227     function () public payable {
228         buyTokens(msg.sender, msg.value);
229     }
230 
231     //Initial Contract
232     function initialize(address _tokenWallet, address _fundWallet, uint256 _start1, uint256 _end1,
233                         uint256 _saleCap, uint256 _totalSupply) public
234                         onlyOwner uninitialized {
235         require(_start1 < _end1);
236         require(_tokenWallet != 0x0);
237         require(_fundWallet != 0x0);
238         require(_totalSupply >= _saleCap);
239 
240         startDate1 = _start1;
241         endDate1 = _end1;
242         saleCap = _saleCap;
243         tokenWallet = _tokenWallet;
244         fundWallet = _fundWallet;
245         totalSupply = _totalSupply;
246 
247         balances[tokenWallet] = saleCap;
248         balances[0xb1] = _totalSupply.sub(saleCap);
249     }
250 
251     //Set PreSale Time
252     function setPeriod(uint period, uint256 _start, uint256 _end) public onlyOwner {
253         require(_end > _start);
254         if (period == 1) {
255             startDate1 = _start;
256             endDate1 = _end;
257         }else if (period == 2) {
258             require(_start > endDate1);
259             startDate2 = _start;
260             endDate2 = _end;      
261         }
262     }
263 
264     // For pushing pre-ICO records
265     function sendForPreICO(address buyer, uint256 amount) public onlyOwner {
266         require(saleCap >= amount);
267 
268         saleCap = saleCap - amount;
269         // Transfer
270         balances[tokenWallet] = balances[tokenWallet].sub(amount);
271         balances[buyer] = balances[buyer].add(amount);
272         emit PreICOTokenPushed(buyer, amount);
273         emit Transfer(tokenWallet, buyer, amount);
274     }
275 
276     //Set SaleCap
277     function setSaleCap(uint256 _saleCap) public onlyOwner {
278         require(balances[0xb1].add(balances[tokenWallet]).sub(_saleCap) > 0);
279         uint256 amount=0;
280         //Check SaleCap
281         if (balances[tokenWallet] > _saleCap) {
282             amount = balances[tokenWallet].sub(_saleCap);
283             balances[0xb1] = balances[0xb1].add(amount);
284         } else {
285             amount = _saleCap.sub(balances[tokenWallet]);
286             balances[0xb1] = balances[0xb1].sub(amount);
287         }
288         balances[tokenWallet] = _saleCap;
289         saleCap = _saleCap;
290     }
291 
292     //Calcute Bouns
293     function getBonusByTime(uint256 atTime) public constant returns (uint256) {
294         if (atTime < startDate1) {
295             return 0;
296         } else if (endDate1 > atTime && atTime > startDate1) {
297             return 5000;
298         } else if (endDate2 > atTime && atTime > startDate2) {
299             return 2500;
300         } else {
301             return 0;
302         }
303     }
304 
305     function getBounsByAmount(uint256 etherAmount, uint256 tokenAmount) public pure returns (uint256) {
306         //Max 40%
307         uint256 bonusRatio = etherAmount.div(500 ether);
308         if (bonusRatio > 4) {
309             bonusRatio = 4;
310         }
311         uint256 bonusCount = SafeMath.mul(bonusRatio, 10);
312         uint256 bouns = SafeMath.mul(tokenAmount, bonusCount);
313         uint256 realBouns = SafeMath.div(bouns, 100);
314         return realBouns;
315     }
316 
317     //Stop Contract
318     function finalize() public onlyOwner {
319         require(!saleActive());
320 
321         // Transfer the rest of token to tokenWallet
322         balances[tokenWallet] = balances[tokenWallet].add(balances[0xb1]);
323         balances[0xb1] = 0;
324     }
325     
326     //Check SaleActive
327     function saleActive() public constant returns (bool) {
328         return (
329             (getCurrentTimestamp() >= startDate1 &&
330                 getCurrentTimestamp() < endDate1 && saleCap > 0) ||
331             (getCurrentTimestamp() >= startDate2 &&
332                 getCurrentTimestamp() < endDate2 && saleCap > 0)
333                 );
334     }
335    
336     //Get CurrentTS
337     function getCurrentTimestamp() internal view returns (uint256) {
338         return now;
339     }
340 
341      //Buy Token
342     function buyTokens(address sender, uint256 value) internal {
343         //Check Sale Status
344         require(saleActive());
345         
346         //Minum buying limit
347         require(value >= 0.5 ether);
348 
349         // Calculate token amount to be purchased
350         uint256 bonus = getBonusByTime(getCurrentTimestamp());
351         uint256 amount = value.mul(bonus);
352         // If ETH > 500 the add 10%
353         if (getCurrentTimestamp() >= startDate1 && getCurrentTimestamp() < endDate1) {
354             uint256 p1Bouns = getBounsByAmount(value, amount);
355             amount = amount + p1Bouns;
356         }
357         // We have enough token to sale
358         require(saleCap >= amount);
359 
360         // Transfer
361         balances[tokenWallet] = balances[tokenWallet].sub(amount);
362         balances[sender] = balances[sender].add(amount);
363         emit TokenPurchase(sender, value, amount);
364         emit Transfer(tokenWallet, sender, amount);
365         
366         saleCap = saleCap - amount;
367 
368         // Update state.
369         weiRaised = weiRaised + value;
370 
371         // Forward the fund to fund collection wallet.
372         fundWallet.transfer(msg.value);
373     }   
374 }