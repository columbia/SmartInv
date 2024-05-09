1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 pragma solidity ^0.4.18;
7 
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) public constant returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract ERC20 is ERC20Basic {
16     function allowance(address owner, address spender) public constant returns (uint256);
17     function transferFrom(address from, address to, uint256 value) public returns (bool);
18     function approve(address spender, uint256 value) public returns (bool);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract BasicToken is ERC20Basic {
49     using SafeMath for uint256;
50 
51     mapping(address => uint256) balances;
52 
53     /**
54     * @dev transfer token for a specified address
55     * @param _to The address to transfer to.
56     * @param _value The amount to be transferred.
57     */
58     function transfer(address _to, uint256 _value) public returns (bool) {
59         balances[_to] = balances[_to].add(_value);
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         Transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     /**
66     * @dev Gets the balance of the specified address.
67     * @param _owner The address to query the the balance of.
68     * @return An uint256 representing the amount owned by the passed address.
69     */
70     function balanceOf(address _owner) public constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74 }
75 
76 contract StandardToken is ERC20, BasicToken {
77 
78     mapping (address => mapping (address => uint256)) allowed;
79 
80 
81     /**
82      * @dev Transfer tokens from one address to another
83      * @param _from address The address which you want to send tokens from
84      * @param _to address The address which you want to transfer to
85      * @param _value uint256 the amout of tokens to be transfered
86      */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
88         var _allowance = allowed[_from][msg.sender];
89 
90         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
91         // require (_value <= _allowance);
92 
93         balances[_to] = balances[_to].add(_value);
94         balances[_from] = balances[_from].sub(_value);
95         allowed[_from][msg.sender] = _allowance.sub(_value);
96         Transfer(_from, _to, _value);
97         return true;
98     }
99 
100     /**
101      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
102      * @param _spender The address which will spend the funds.
103      * @param _value The amount of tokens to be spent.
104      */
105     function approve(address _spender, uint256 _value) public returns (bool) {
106 
107         // To change the approve amount you first have to reduce the addresses`
108         //  allowance to zero by calling `approve(_spender, 0)` if it is not
109         //  already 0 to mitigate the race condition described here:
110         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
112 
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     /**
119      * @dev Function to check the amount of tokens that an owner allowed to a spender.
120      * @param _owner address The address which owns the funds.
121      * @param _spender address The address which will spend the funds.
122      * @return A uint256 specifing the amount of tokens still avaible for the spender.
123      */
124     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
125         return allowed[_owner][_spender];
126     }
127 
128 }
129 
130 contract Ownable {
131     address public owner;
132 
133     /**
134      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
135      * account.
136      */
137     function Ownable() public {
138         owner = msg.sender;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         assert(msg.sender == owner);
146         _;
147     }
148 
149     /**
150      * @dev Allows the current owner to transfer control of the contract to a newOwner.
151      * @param newOwner The address to transfer ownership to.
152      */
153     function transferOwnership(address newOwner) public onlyOwner {
154         if (newOwner != address(0)) {
155             owner = newOwner;
156         }
157     }
158 }
159 
160 contract TheMoveToken is StandardToken, Ownable {
161     string public constant name = "MOVE Token";
162     string public constant symbol = "MOVE";
163     uint public constant decimals = 18;
164     using SafeMath for uint256;
165     // timestamps for PRE-ICO phase
166     uint public preicoStartDate;
167     uint public preicoEndDate;
168     // timestamps for ICO phase
169     uint public icoStartDate;
170     uint public icoEndDate;
171     // address where funds are collected
172     address public wallet;
173     // how many token units a buyer gets per wei
174     uint256 public rate;
175     uint256 public minTransactionAmount;
176     uint256 public raisedForEther = 0;
177     uint256 private preicoSupply = 3072000000000000000000000;
178     uint256 private icoSupply = 10000000000000000000000000;
179     uint256 private bonusesSupply = 3000000000000000000000000;
180 
181     uint256 public bonusesSold = 0;
182     uint256 public tokensSold = 0;
183 
184     // PRE-ICO stages
185     uint256 public stage1 = 240000000000000000000000;
186     uint256 public stage2 = 360000000000000000000000;
187     uint256 public stage3 = 960000000000000000000000;
188     uint256 public stage4 = 1512000000000000000000000;
189 
190     modifier inActivePeriod() {
191 	   require((preicoStartDate < now && now <= preicoEndDate) || (icoStartDate < now && now <= icoEndDate));
192         _;
193     }
194 
195     function TheMoveToken(uint _preicostart, uint _preicoend,uint _icostart, uint _icoend, address _wallet) public {
196         require(_wallet != 0x0);
197         require(_preicostart < _preicoend);
198         require(_preicoend < _icostart);
199         require(_icostart < _icoend);
200 
201         totalSupply = 21172000000000000000000000;
202         rate = 3600;
203 
204         // minimal invest
205         minTransactionAmount = 0.1 ether;
206         icoStartDate = _icostart;
207         icoEndDate = _icoend;
208         preicoStartDate = _preicostart;
209         preicoEndDate = _preicoend;
210         wallet = _wallet;
211 
212 	   // Store the ico funds in the contract and send the rest to the developer wallet
213        uint256 amountInContract = preicoSupply + icoSupply + bonusesSupply;
214        uint256 amountDevelopers = totalSupply - amountInContract;
215        
216 	   balances[this] = balances[this].add(amountInContract);
217 	   Transfer(_wallet, _wallet, amountDevelopers);
218        balances[_wallet] = balances[_wallet].add(totalSupply - amountInContract);
219        Transfer(_wallet, this, amountInContract);
220     }
221 
222     function setupPREICOPeriod(uint _start, uint _end) public onlyOwner {
223         require(_start < _end);
224         preicoStartDate = _start;
225         preicoEndDate = _end;
226     }
227 
228     function setupICOPeriod(uint _start, uint _end) public onlyOwner {
229         require(_start < _end);
230         icoStartDate = _start;
231         icoEndDate = _end;
232     }
233     
234     function setRate(uint256 _rate) public onlyOwner {
235         rate = _rate;
236     }
237 
238     // fallback function can be used to buy tokens
239     function () public inActivePeriod payable {
240         buyTokens(msg.sender);
241     }
242 
243     function burnPREICOTokens() public onlyOwner {
244         int256 amountToBurn = int256(preicoSupply) - int256(tokensSold);
245         if (amountToBurn > 0) {
246             balances[this] = balances[this].sub(uint256(amountToBurn));
247         }
248     }
249     
250     function sendTokens(address _sender, uint256 amount) public inActivePeriod onlyOwner {
251         // calculate token amount to be issued
252         uint256 tokens = amount.mul(rate);
253         tokens += getBonus(tokens);
254 
255         if (isPREICO()) {
256             require(tokensSold + tokens < preicoSupply);
257         } else if (isICO()) {
258             require(tokensSold + tokens <= (icoSupply + bonusesSupply));
259         }
260 
261         issueTokens(_sender, tokens);
262         tokensSold += tokens;
263     }
264 
265     // Use with extreme caution this will burn the rest of the tokens in the contract
266     function burnICOTokens() public onlyOwner {
267         balances[this] = 0;
268     }
269 
270     function burnBonuses() public onlyOwner {
271         int256 amountToBurn = int256(bonusesSupply) - int256(bonusesSold);
272         if (amountToBurn > 0) {
273             balances[this] = balances[this].sub(uint256(amountToBurn));
274         }
275     }
276 
277     // low level token purchase function
278     function buyTokens(address _sender) public inActivePeriod payable {
279         require(_sender != 0x0);
280         require(msg.value >= minTransactionAmount);
281 
282         uint256 weiAmount = msg.value;
283 
284         raisedForEther = raisedForEther.add(weiAmount);
285 
286         // calculate token amount to be created
287         uint256 tokens = weiAmount.mul(rate);
288         tokens += getBonus(tokens);
289 
290         if (isPREICO()) {
291             require(tokensSold + tokens < preicoSupply);
292         } else if (isICO()) {
293             require(tokensSold + tokens <= (icoSupply + bonusesSupply));
294         }
295 
296         issueTokens(_sender, tokens);
297         tokensSold += tokens;
298     }
299 
300     function withdrawEther(uint256 amount) external onlyOwner {
301         owner.transfer(amount);
302     }
303 
304     function isPREICO() public view returns (bool) {
305         return (preicoStartDate < now && now <= preicoEndDate);
306     }
307 
308     function isICO() public view returns (bool) {
309         return (icoStartDate < now && now <= icoEndDate);
310     }
311     
312     function setTokensSold(uint256 amount) public onlyOwner {
313         tokensSold = amount;
314     }
315 
316     function getBonus(uint256 _tokens) public returns (uint256) {
317         require(_tokens != 0);
318         uint256 bonuses = 0;
319         uint256 multiplier = 0;
320 
321         // First case if PRE-ICO is happening
322         if (isPREICO()) {
323             // Bonus depends on the amount of tokens sold.
324             if (tokensSold < stage1) {
325                 // 100% bonus for stage1
326                 multiplier = 100;
327             } else if (stage1 < tokensSold && tokensSold < (stage1 + stage2)) {
328                 // 80% bonus for stage2
329                 multiplier = 80;
330             } else if ((stage1 + stage2) < tokensSold && tokensSold < (stage1 + stage2 + stage3)) {
331                 // 60% bonus for stage2
332                 multiplier = 60;
333             } else if ((stage1 + stage2 + stage3) < tokensSold && tokensSold < (stage1 + stage2 + stage3 + stage4)) {
334                 // 40% bonus for stage2
335                 multiplier = 40;
336             }
337             bonuses = _tokens.mul(multiplier).div(100);
338 
339             return bonuses;
340         }
341 
342         
343         // Second case if ICO is happening
344         else if (isICO()) {
345             // Bonus depends on the week of the ICO and the bonus supply
346             if (icoStartDate < now && now <= icoStartDate + 7 days) {
347                 // 20% bonus week 1
348                 multiplier = 20;
349             } else if (icoStartDate + 7 days < now && now <= icoStartDate + 14 days ) {
350                 // 10% bonus week 2
351                 multiplier = 10;
352             } else if (icoStartDate + 14 days < now && now <= icoStartDate + 21 days ) {
353                 // 5% bonus week 3
354                 multiplier = 5;
355             }
356 
357             bonuses = _tokens.mul(multiplier).div(100);
358 
359             // Bonus supply limit reached.
360             if (bonusesSold + bonuses > bonusesSupply) {
361                 bonuses = 0;
362             } else {
363                 bonusesSold += bonuses;
364             }
365             return bonuses;
366         } 
367     }
368 
369     function issueTokens(address _to, uint256 _value) internal returns (bool) {
370         balances[_to] = balances[_to].add(_value);
371         balances[this] = balances[this].sub(_value);
372         Transfer(msg.sender, _to, _value);
373         return true;
374     }
375 }