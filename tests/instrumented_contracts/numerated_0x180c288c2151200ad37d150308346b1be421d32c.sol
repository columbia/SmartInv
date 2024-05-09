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
49     // timestamps for PRE-ICO phase
50     uint public preicoStartDate;
51     uint public preicoEndDate;
52     // timestamps for ICO phase
53     uint public icoStartDate;
54     uint public icoEndDate;
55     
56     using SafeMath for uint256;
57 
58     mapping(address => uint256) balances;
59 
60     /**
61     * @dev transfer token for a specified address
62     * @param _to The address to transfer to.
63     * @param _value The amount to be transferred.
64     */
65     function transfer(address _to, uint256 _value) public returns (bool) {
66         require(now > icoEndDate);
67         balances[_to] = balances[_to].add(_value);
68         balances[msg.sender] = balances[msg.sender].sub(_value);
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     /**
74     * @dev Gets the balance of the specified address.
75     * @param _owner The address to query the the balance of.
76     * @return An uint256 representing the amount owned by the passed address.
77     */
78     function balanceOf(address _owner) public constant returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82 }
83 
84 contract StandardToken is ERC20, BasicToken {
85 
86     mapping (address => mapping (address => uint256)) allowed;
87 
88 
89     /**
90      * @dev Transfer tokens from one address to another
91      * @param _from address The address which you want to send tokens from
92      * @param _to address The address which you want to transfer to
93      * @param _value uint256 the amout of tokens to be transfered
94      */
95     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
96         require(now > icoEndDate);
97         var _allowance = allowed[_from][msg.sender];
98         balances[_to] = balances[_to].add(_value);
99         balances[_from] = balances[_from].sub(_value);
100         allowed[_from][msg.sender] = _allowance.sub(_value);
101         Transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
107      * @param _spender The address which will spend the funds.
108      * @param _value The amount of tokens to be spent.
109      */
110     function approve(address _spender, uint256 _value) public returns (bool) {
111 
112         // To change the approve amount you first have to reduce the addresses`
113         //  allowance to zero by calling `approve(_spender, 0)` if it is not
114         //  already 0 to mitigate the race condition described here:
115         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
117 
118         allowed[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120         return true;
121     }
122 
123     /**
124      * @dev Function to check the amount of tokens that an owner allowed to a spender.
125      * @param _owner address The address which owns the funds.
126      * @param _spender address The address which will spend the funds.
127      * @return A uint256 specifing the amount of tokens still avaible for the spender.
128      */
129     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
130         return allowed[_owner][_spender];
131     }
132 
133 }
134 
135 contract Ownable {
136     address public owner;
137 
138     /**
139      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
140      * account.
141      */
142     function Ownable() public {
143         owner = msg.sender;
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         assert(msg.sender == owner);
151         _;
152     }
153 
154     /**
155      * @dev Allows the current owner to transfer control of the contract to a newOwner.
156      * @param newOwner The address to transfer ownership to.
157      */
158     function transferOwnership(address newOwner) public onlyOwner {
159         if (newOwner != address(0)) {
160             owner = newOwner;
161         }
162     }
163 }
164 
165 contract TheMoveToken is StandardToken, Ownable {
166     string public constant name = "MOVE Token";
167     string public constant symbol = "MOVE";
168     uint public constant decimals = 18;
169     using SafeMath for uint256;
170     // address where funds are collected
171     address public wallet;
172     // how many token units a buyer gets per wei
173     uint256 public rate;
174     uint256 public minTransactionAmount;
175     uint256 public raisedForEther = 0;
176     uint256 private preicoSupply = 3072000000000000000000000;
177     uint256 private icoSupply = 10000000000000000000000000;
178     uint256 private bonusesSupply = 3000000000000000000000000;
179 
180     uint256 public bonusesSold = 0;
181     uint256 public tokensSold = 0;
182 
183     // PRE-ICO stages
184     uint256 public stage1 = 240000000000000000000000;
185     uint256 public stage2 = 360000000000000000000000;
186     uint256 public stage3 = 960000000000000000000000;
187     uint256 public stage4 = 1512000000000000000000000;
188 
189     modifier inActivePeriod() {
190 	   require((preicoStartDate < now && now <= preicoEndDate) || (icoStartDate < now && now <= icoEndDate));
191         _;
192     }
193 
194     function TheMoveToken(uint _preicostart, uint _preicoend,uint _icostart, uint _icoend, address _wallet) public {
195         require(_wallet != 0x0);
196         require(_preicostart < _preicoend);
197         require(_preicoend < _icostart);
198         require(_icostart < _icoend);
199 
200         totalSupply = 21172000000000000000000000;
201         rate = 600;
202 
203         // minimal invest
204         minTransactionAmount = 0.1 ether;
205         icoStartDate = _icostart;
206         icoEndDate = _icoend;
207         preicoStartDate = _preicostart;
208         preicoEndDate = _preicoend;
209         wallet = _wallet;
210 
211 	   // Store the ico funds in the contract and send the rest to the developer wallet
212        uint256 amountInContract = preicoSupply + icoSupply + bonusesSupply;
213 
214 	   balances[this] = balances[this].add(amountInContract);
215        balances[_wallet] = balances[_wallet].add(totalSupply - amountInContract);
216     }
217 
218     function setupPREICOPeriod(uint _start, uint _end) public onlyOwner {
219         require(_start < _end);
220         preicoStartDate = _start;
221         preicoEndDate = _end;
222     }
223 
224     function setupICOPeriod(uint _start, uint _end) public onlyOwner {
225         require(_start < _end);
226         icoStartDate = _start;
227         icoEndDate = _end;
228     }
229 
230     // fallback function can be used to buy tokens
231     function () public inActivePeriod payable {
232         buyTokens(msg.sender);
233     }
234 
235     function burnPREICOTokens() public onlyOwner {
236         int256 amountToBurn = int256(preicoSupply) - int256(tokensSold);
237         if (amountToBurn > 0) {
238             balances[this] = balances[this].sub(uint256(amountToBurn));
239         }
240     }
241 
242     // Use with extreme caution this will burn the rest of the tokens in the contract
243     function burnICOTokens() public onlyOwner {
244         balances[this] = 0;
245     }
246 
247     function burnBonuses() public onlyOwner {
248         int256 amountToBurn = int256(bonusesSupply) - int256(bonusesSold);
249         if (amountToBurn > 0) {
250             balances[this] = balances[this].sub(uint256(amountToBurn));
251         }
252     }
253 
254     // low level token purchase function
255     function buyTokens(address _sender) public inActivePeriod payable {
256         require(_sender != 0x0);
257         require(msg.value >= minTransactionAmount);
258 
259         uint256 weiAmount = msg.value;
260 
261         raisedForEther = raisedForEther.add(weiAmount);
262 
263         // calculate token amount to be issued
264         uint256 tokens = weiAmount.mul(rate);
265         tokens += getBonus(tokens);
266 
267         if (isPREICO()) {
268             require(tokensSold + tokens < preicoSupply);
269         } else if (isICO()) {
270             require(tokensSold + tokens <= (icoSupply + bonusesSupply));
271         }
272 
273         issueTokens(_sender, tokens);
274         tokensSold += tokens;
275     }
276     
277     // High level token issue function
278     // This will be used by the script which distributes tokens
279     // to those who contributed in BTC or LTC.
280     function sendTokens(address _sender, uint256 amount) public inActivePeriod onlyOwner {
281         // calculate token amount to be issued
282         uint256 tokens = amount.mul(rate);
283         tokens += getBonus(tokens);
284 
285         if (isPREICO()) {
286             require(tokensSold + tokens < preicoSupply);
287         } else if (isICO()) {
288             require(tokensSold + tokens <= (icoSupply + bonusesSupply));
289         }
290 
291         issueTokens(_sender, tokens);
292         tokensSold += tokens;
293     }
294 
295     function withdrawEther(uint256 amount) external onlyOwner {
296         owner.transfer(amount);
297     }
298 
299     function isPREICO() public view returns (bool) {
300         return (preicoStartDate < now && now <= preicoEndDate);
301     }
302 
303     function isICO() public view returns (bool) {
304         return (icoStartDate < now && now <= icoEndDate);
305     }
306 
307     function getBonus(uint256 _tokens) public returns (uint256) {
308         require(_tokens != 0);
309         uint256 bonuses = 0;
310         uint256 multiplier = 0;
311 
312         // First case if PRE-ICO is happening
313         if (isPREICO()) {
314             // Bonus depends on the amount of tokens sold.
315             if (tokensSold < stage1) {
316                 // 100% bonus for stage1
317                 multiplier = 100;
318             } else if (stage1 < tokensSold && tokensSold < (stage1 + stage2)) {
319                 // 80% bonus for stage2
320                 multiplier = 80;
321             } else if ((stage1 + stage2) < tokensSold && tokensSold < (stage1 + stage2 + stage3)) {
322                 // 60% bonus for stage2
323                 multiplier = 60;
324             } else if ((stage1 + stage2 + stage3) < tokensSold && tokensSold < (stage1 + stage2 + stage3 + stage4)) {
325                 // 40% bonus for stage2
326                 multiplier = 40;
327             }
328             bonuses = _tokens.mul(multiplier).div(100);
329 
330             return bonuses;
331         }
332 
333         
334         // Second case if ICO is happening
335         else if (isICO()) {
336             // Bonus depends on the week of the ICO and the bonus supply
337             if (icoStartDate < now && now <= icoStartDate + 7 days) {
338                 // 20% bonus week 1
339                 multiplier = 20;
340             } else if (icoStartDate + 7 days < now && now <= icoStartDate + 14 days ) {
341                 // 10% bonus week 2
342                 multiplier = 10;
343             } else if (icoStartDate + 14 days < now && now <= icoStartDate + 21 days ) {
344                 // 5% bonus week 3
345                 multiplier = 5;
346             }
347 
348             bonuses = _tokens.mul(multiplier).div(100);
349 
350             // Bonus supply limit reached.
351             if (bonusesSold + bonuses > bonusesSupply) {
352                 bonuses = 0;
353             } else {
354                 bonusesSold += bonuses;
355             }
356             return bonuses;
357         } 
358     }
359 
360     // This function transfers tokens to the contributor's account.
361     function issueTokens(address _to, uint256 _value) internal returns (bool) {
362         balances[_to] = balances[_to].add(_value);
363         balances[this] = balances[this].sub(_value);
364         Transfer(msg.sender, _to, _value);
365         return true;
366     }
367 }