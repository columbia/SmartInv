1 pragma solidity ^0.4.21;
2 
3 /**
4 * 0XCoin (0XC)
5 * Visit Play0x.com to get more profit
6 */
7 
8 
9 /**
10 * @title SafeMath
11 * @dev Math operations with safety checks that throw on error
12 */
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a * b;
16         assert(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a / b;
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 
38 /**
39 * @title Ownable
40 * @dev The Ownable contract has an owner address, and provides basic authorization control 
41 * functions, this simplifies the implementation of "user permissions". 
42 */ 
43 contract Ownable {
44     address public owner;
45 
46 /** 
47 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48 * account.
49 */
50     constructor() public {
51         owner = msg.sender;
52     }
53 
54     /**
55     * @dev Throws if called by any account other than the owner.
56     */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63     * @dev Allows the current owner to transfer control of the contract to a newOwner.
64     * @param newOwner The address to transfer ownership to.
65     */
66     function transferOwnership(address newOwner) public onlyOwner {
67         if (newOwner != address(0)) {
68             owner = newOwner;
69         }
70     }
71 }
72 
73 
74 /**
75 * @title ERC20Basic
76 * @dev Simpler version of ERC20 interface
77 * @dev see https://github.com/ethereum/EIPs/issues/179
78 */
79 contract ERC20Basic {
80     uint256 public totalSupply;
81     function balanceOf(address who) public constant returns  (uint256);
82     function transfer(address to, uint256 value) public returns (bool);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 
87 /**
88 * @title Basic token
89 * @dev Basic version of StandardToken, with no allowances. 
90 */
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) balances;
95 
96     /**
97     * @dev transfer token for a specified address
98     * @param _to The address to transfer to.
99     * @param _value The amount to be transferred.
100     */
101     function transfer(address _to, uint256 _value) public returns (bool) {
102         balances[msg.sender] = balances[msg.sender].sub(_value);
103         balances[_to] = balances[_to].add(_value);
104         emit Transfer(msg.sender, _to, _value);
105         return true;
106     }
107 
108     /**
109     * @dev Gets the balance of the specified address.
110     * @param _owner The address to query the the balance of. 
111     * @return An uint256 representing the amount owned by the passed address.
112     */
113     function balanceOf(address _owner) public constant returns (uint256 balance) {
114         return balances[_owner];
115     }
116 }
117 
118 
119 /**
120 * @title ERC20 interface
121 * @dev see https://github.com/ethereum/EIPs/issues/20
122 */
123 contract ERC20 is ERC20Basic {
124     function allowance(address owner, address spender) public constant returns (uint256);
125     function transferFrom(address from, address to, uint256 value) public returns (bool);
126     function approve(address spender, uint256 value) public returns (bool);
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 
131 /**
132 * @title Standard ERC20 token
133 *
134 * @dev Implementation of the basic standard token.
135 * @dev https://github.com/ethereum/EIPs/issues/20
136 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137 */
138 contract StandardToken is ERC20, BasicToken {
139 
140     mapping (address => mapping (address => uint256)) internal allowed;
141 
142     /**
143     * @dev Transfer tokens from one address to another
144     * @param _from address The address which you want to send tokens from
145     * @param _to address The address which you want to transfer to
146     * @param _value uint256 the amout of tokens to be transfered
147     */
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
150     // require (_value <= _allowance);
151 
152         balances[_to] = balances[_to].add(_value);
153         balances[_from] = balances[_from].sub(_value);
154         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
155         emit Transfer(_from, _to, _value);
156         return true;
157     }       
158 
159     /**
160     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
161     * @param _spender The address which will spend the funds.
162     * @param _value The amount of tokens to be spent.
163     */
164     function approve(address _spender, uint256 _value) public returns (bool) {
165 
166     // To change the approve amount you first have to reduce the addresses`
167     //  allowance to zero by calling `approve(_spender, 0)` if it is not
168     //  already 0 to mitigate the race condition described here:
169     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
171 
172         allowed[msg.sender][_spender] = _value;
173         emit Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 
177     /**
178     * @dev Function to check the amount of tokens that an owner allowed to a spender.
179     * @param _owner address The address which owns the funds.
180     * @param _spender address The address which will spend the funds.
181     * @return A uint256 specifing the amount of tokens still avaible for the spender.
182     */
183     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
184         return allowed[_owner][_spender];
185     }
186 }
187 
188 
189 /*Token  Contract*/
190 contract ZXCoin is StandardToken, Ownable {
191     using SafeMath for uint256;
192 
193     // Token Information
194     string  public constant name = "0XCoin";
195     string  public constant symbol = "0XC";
196     uint8   public constant decimals = 18;
197 
198     // Sale period1.
199     uint256 public startDate1;
200     uint256 public endDate1;
201 
202     // Sale period2.
203     uint256 public startDate2;
204     uint256 public endDate2;
205 
206     //SaleCap
207     uint256 public saleCap;
208 
209     // Address Where Token are keep
210     address public tokenWallet;
211 
212     // Address where funds are collected.
213     address public fundWallet;
214 
215     // Amount of raised money in wei.
216     uint256 public weiRaised;
217 
218     // Event
219     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
220     event PreICOTokenPushed(address indexed buyer, uint256 amount);
221 
222     // Modifiers
223     modifier uninitialized() {
224         require(tokenWallet == 0x0);
225         require(fundWallet == 0x0);
226         _;
227     }
228 
229     constructor() public {}
230     // Trigger with Transfer event
231     // Fallback function can be used to buy tokens
232     function () public payable {
233         buyTokens(msg.sender, msg.value);
234     }
235 
236     //Initial Contract
237     function initialize(address _tokenWallet, address _fundWallet, uint256 _start1, uint256 _end1,
238                         uint256 _saleCap, uint256 _totalSupply) public
239                         onlyOwner uninitialized {
240         require(_start1 < _end1);
241         require(_tokenWallet != 0x0);
242         require(_fundWallet != 0x0);
243         require(_totalSupply >= _saleCap);
244 
245         startDate1 = _start1;
246         endDate1 = _end1;
247         saleCap = _saleCap;
248         tokenWallet = _tokenWallet;
249         fundWallet = _fundWallet;
250         totalSupply = _totalSupply;
251 
252         balances[tokenWallet] = saleCap;
253         balances[0xb1] = _totalSupply.sub(saleCap);
254     }
255 
256     //Set PreSale Time
257     function setPeriod(uint period, uint256 _start, uint256 _end) public onlyOwner {
258         require(_end > _start);
259         if (period == 1) {
260             startDate1 = _start;
261             endDate1 = _end;
262         }else if (period == 2) {
263             require(_start > endDate1);
264             startDate2 = _start;
265             endDate2 = _end;      
266         }
267     }
268 
269     // For pushing pre-ICO records
270     function sendForPreICO(address buyer, uint256 amount) public onlyOwner {
271         require(saleCap >= amount);
272 
273         saleCap = saleCap - amount;
274         // Transfer
275         balances[tokenWallet] = balances[tokenWallet].sub(amount);
276         balances[buyer] = balances[buyer].add(amount);
277         emit PreICOTokenPushed(buyer, amount);
278         emit Transfer(tokenWallet, buyer, amount);
279     }
280 
281     //Set SaleCap
282     function setSaleCap(uint256 _saleCap) public onlyOwner {
283         require(balances[0xb1].add(balances[tokenWallet]).sub(_saleCap) > 0);
284         uint256 amount=0;
285         //Check SaleCap
286         if (balances[tokenWallet] > _saleCap) {
287             amount = balances[tokenWallet].sub(_saleCap);
288             balances[0xb1] = balances[0xb1].add(amount);
289         } else {
290             amount = _saleCap.sub(balances[tokenWallet]);
291             balances[0xb1] = balances[0xb1].sub(amount);
292         }
293         balances[tokenWallet] = _saleCap;
294         saleCap = _saleCap;
295     }
296 
297     //Calcute Bouns
298     function getBonusByTime(uint256 atTime) public constant returns (uint256) {
299         if (atTime < startDate1) {
300             return 0;
301         } else if (endDate1 > atTime && atTime > startDate1) {
302             return 5000;
303         } else if (endDate2 > atTime && atTime > startDate2) {
304             return 2500;
305         } else {
306             return 0;
307         }
308     }
309 
310     function getBounsByAmount(uint256 etherAmount, uint256 tokenAmount) public pure returns (uint256) {
311         //Max 40%
312         uint256 bonusRatio = etherAmount.div(500 ether);
313         if (bonusRatio > 4) {
314             bonusRatio = 4;
315         }
316         uint256 bonusCount = SafeMath.mul(bonusRatio, 10);
317         uint256 bouns = SafeMath.mul(tokenAmount, bonusCount);
318         uint256 realBouns = SafeMath.div(bouns, 100);
319         return realBouns;
320     }
321 
322     //Stop Contract
323     function finalize() public onlyOwner {
324         require(!saleActive());
325 
326         // Transfer the rest of token to tokenWallet
327         balances[tokenWallet] = balances[tokenWallet].add(balances[0xb1]);
328         balances[0xb1] = 0;
329     }
330     
331     //Check SaleActive
332     function saleActive() public constant returns (bool) {
333         return (
334             (getCurrentTimestamp() >= startDate1 &&
335                 getCurrentTimestamp() < endDate1 && saleCap > 0) ||
336             (getCurrentTimestamp() >= startDate2 &&
337                 getCurrentTimestamp() < endDate2 && saleCap > 0)
338                 );
339     }
340    
341     //Get CurrentTS
342     function getCurrentTimestamp() internal view returns (uint256) {
343         return now;
344     }
345 
346      //Buy Token
347     function buyTokens(address sender, uint256 value) internal {
348         //Check Sale Status
349         require(saleActive());
350         
351         //Minum buying limit
352         require(value >= 0.1 ether);
353 
354         // Calculate token amount to be purchased
355         uint256 bonus = getBonusByTime(getCurrentTimestamp());
356         uint256 amount = value.mul(bonus);
357         // If ETH > 500 the add 10%
358         if (getCurrentTimestamp() >= startDate1 && getCurrentTimestamp() < endDate1) {
359             uint256 p1Bouns = getBounsByAmount(value, amount);
360             amount = amount + p1Bouns;
361         }
362         // We have enough token to sale
363         require(saleCap >= amount);
364 
365         // Transfer
366         balances[tokenWallet] = balances[tokenWallet].sub(amount);
367         balances[sender] = balances[sender].add(amount);
368         emit TokenPurchase(sender, value, amount);
369         emit Transfer(tokenWallet, sender, amount);
370         
371         saleCap = saleCap - amount;
372 
373         // Update state.
374         weiRaised = weiRaised + value;
375 
376         // Forward the fund to fund collection wallet.
377         fundWallet.transfer(msg.value);
378     }   
379 }