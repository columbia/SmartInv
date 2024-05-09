1 pragma solidity ^0.4.11;
2 
3     /**
4      * @title SafeMath
5      * @dev Math operations with safety checks that throw on error
6      */
7     library SafeMath {
8       function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12       }
13 
14       function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19       }
20 
21       function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24       }
25 
26       function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30       }
31     }
32 
33     /**
34      * @title ERC20Basic
35      * @dev Simpler version of ERC20 interface
36      * @dev see https://github.com/ethereum/EIPs/issues/179
37      */
38     contract ERC20Basic {
39       uint256 public totalSupply;
40       function balanceOf(address who) constant returns (uint256);
41       function transfer(address to, uint256 value) returns (bool);
42       event Transfer(address indexed from, address indexed to, uint256 value);
43     }
44 
45     /**
46      * @title ERC20 interface
47      * @dev see https://github.com/ethereum/EIPs/issues/20
48      */
49     contract ERC20 is ERC20Basic {
50       function allowance(address owner, address spender) constant returns (uint256);
51       function transferFrom(address from, address to, uint256 value) returns (bool);
52       function approve(address spender, uint256 value) returns (bool);
53       event Approval(address indexed owner, address indexed spender, uint256 value);
54     }
55 
56     /**
57      * @title Basic token
58      * @dev Basic version of StandardToken, with no allowances. 
59      */
60     contract BasicToken is ERC20Basic {
61       using SafeMath for uint256;
62 
63       mapping(address => uint256) balances;
64 
65       /**
66       * @dev transfer token for a specified address
67       * @param _to The address to transfer to.
68       * @param _value The amount to be transferred.
69       */
70       function transfer(address _to, uint256 _value) returns (bool) {
71         require(_to != address(0));
72 
73         // SafeMath.sub will throw if there is not enough balance.
74         balances[msg.sender] = balances[msg.sender].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         Transfer(msg.sender, _to, _value);
77         return true;
78       }
79 
80       /**
81       * @dev Gets the balance of the specified address.
82       * @param _owner The address to query the the balance of. 
83       * @return An uint256 representing the amount owned by the passed address.
84       */
85       function balanceOf(address _owner) constant returns (uint256 balance) {
86         return balances[_owner];
87       }
88 
89     }
90 
91     /**
92      * @title Standard ERC20 token
93      *
94      * @dev Implementation of the basic standard token.
95      * @dev https://github.com/ethereum/EIPs/issues/20
96      * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97      */
98     contract StandardToken is ERC20, BasicToken {
99 
100       mapping (address => mapping (address => uint256)) allowed;
101 
102 
103       /**
104        * @dev Transfer tokens from one address to another
105        * @param _from address The address which you want to send tokens from
106        * @param _to address The address which you want to transfer to
107        * @param _value uint256 the amount of tokens to be transferred
108        */
109       function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
110         require(_to != address(0));
111 
112         var _allowance = allowed[_from][msg.sender];
113 
114         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115         // require (_value <= _allowance);
116 
117         balances[_from] = balances[_from].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         allowed[_from][msg.sender] = _allowance.sub(_value);
120         Transfer(_from, _to, _value);
121         return true;
122       }
123 
124       /**
125        * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126        * @param _spender The address which will spend the funds.
127        * @param _value The amount of tokens to be spent.
128        */
129       function approve(address _spender, uint256 _value) returns (bool) {
130 
131         // To change the approve amount you first have to reduce the addresses`
132         //  allowance to zero by calling `approve(_spender, 0)` if it is not
133         //  already 0 to mitigate the race condition described here:
134         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136 
137         allowed[msg.sender][_spender] = _value;
138         Approval(msg.sender, _spender, _value);
139         return true;
140       }
141 
142       /**
143        * @dev Function to check the amount of tokens that an owner allowed to a spender.
144        * @param _owner address The address which owns the funds.
145        * @param _spender address The address which will spend the funds.
146        * @return A uint256 specifying the amount of tokens still available for the spender.
147        */
148       function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149         return allowed[_owner][_spender];
150       }
151       
152       /**
153        * approve should be called when allowed[_spender] == 0. To increment
154        * allowed value is better to use this function to avoid 2 calls (and wait until 
155        * the first transaction is mined)
156        * From MonolithDAO Token.sol
157        */
158       function increaseApproval (address _spender, uint _addedValue) 
159         returns (bool success) {
160         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163       }
164 
165       function decreaseApproval (address _spender, uint _subtractedValue) 
166         returns (bool success) {
167         uint oldValue = allowed[msg.sender][_spender];
168         if (_subtractedValue > oldValue) {
169           allowed[msg.sender][_spender] = 0;
170         } else {
171           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172         }
173         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174         return true;
175       }
176 
177     }
178 
179     /**
180      * @title Ownable
181      * @dev The Ownable contract has an owner address, and provides basic authorization control
182      * functions, this simplifies the implementation of "user permissions".
183      */
184     contract Ownable {
185       address public owner;
186 
187 
188       event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190 
191       /**
192        * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193        * account.
194        */
195       function Ownable() {
196         owner = msg.sender;
197       }
198 
199 
200       /**
201        * @dev Throws if called by any account other than the owner.
202        */
203       modifier onlyOwner() {
204         require(msg.sender == owner);
205         _;
206       }
207 
208 
209       /**
210        * @dev Allows the current owner to transfer control of the contract to a newOwner.
211        * @param newOwner The address to transfer ownership to.
212        */
213       function transferOwnership(address newOwner) onlyOwner {
214         require(newOwner != address(0));      
215         OwnershipTransferred(owner, newOwner);
216         owner = newOwner;
217       }
218 
219     }
220 //#endImportRegion
221 
222 contract RewardToken is StandardToken, Ownable {
223     bool public payments = false;
224     mapping(address => uint256) public rewards;
225     uint public payment_time = 0;
226     uint public payment_amount = 0;
227 
228     event Reward(address indexed to, uint256 value);
229 
230     function payment() payable onlyOwner {
231         require(payments);
232         require(msg.value >= 0.01 * 1 ether);
233 
234         payment_time = now;
235         payment_amount = this.balance;
236     }
237 
238     function _reward(address _to) private returns (bool) {
239         require(payments);
240         require(rewards[_to] < payment_time);
241 
242         if(balances[_to] > 0) {
243 			uint amount = payment_amount.mul(balances[_to]).div( totalSupply);
244 
245 			require(_to.send(amount));
246 
247 			Reward(_to, amount);
248 		}
249 		
250         rewards[_to] = payment_time;
251 
252         return true;
253     }
254 
255     function reward() returns (bool) {
256         return _reward(msg.sender);
257     }
258 
259     function transfer(address _to, uint256 _value) returns (bool) {
260 		if(payments) {
261 			if(rewards[msg.sender] < payment_time) require(_reward(msg.sender));
262 			if(rewards[_to] < payment_time) require(_reward(_to));
263 		}
264 
265         return super.transfer(_to, _value);
266     }
267 
268     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
269 		if(payments) {
270 			if(rewards[_from] < payment_time) require(_reward(_from));
271 			if(rewards[_to] < payment_time) require(_reward(_to));
272 		}
273 
274         return super.transferFrom(_from, _to, _value);
275     }
276 }
277 
278 contract CottageToken is RewardToken {
279     using SafeMath for uint;
280 
281     string public name = "Cottage Token";
282     string public symbol = "CTG";
283     uint256 public decimals = 18;
284 
285     bool public mintingFinished = false;
286     bool public commandGetBonus = false;
287     uint public commandGetBonusTime = 1519884000;
288 
289     event Mint(address indexed holder, uint256 tokenAmount);
290     event MintFinished();
291     event MintCommandBonus();
292 
293     function _mint(address _to, uint256 _amount) onlyOwner private returns(bool) {
294         totalSupply = totalSupply.add(_amount);
295         balances[_to] = balances[_to].add(_amount);
296 
297         Mint(_to, _amount);
298         Transfer(address(0), _to, _amount);
299 
300         return true;
301     }
302 
303     function mint(address _to, uint256 _amount) onlyOwner returns(bool) {
304         require(!mintingFinished);
305         return _mint(_to, _amount);
306     }
307 
308     function finishMinting() onlyOwner returns(bool) {
309         mintingFinished = true;
310         payments = true;
311 
312         MintFinished();
313 
314         return true;
315     }
316 
317     function commandMintBonus(address _to) onlyOwner {
318         require(mintingFinished && !commandGetBonus);
319         require(now > commandGetBonusTime);
320 
321         commandGetBonus = true;
322 
323         require(_mint(_to, totalSupply.mul(15).div(100)));
324 
325         MintCommandBonus();
326     }
327 }
328 
329 contract Crowdsale is Ownable {
330     using SafeMath for uint;
331 
332     CottageToken public token;
333     address public beneficiary = 0xd358Bd183C8E85C56d84C1C43a785DfEE0236Ca2; 
334 
335     uint public collectedFunds = 0;
336     uint public hardCap = 230000 * 1000000000000000000; // hardCap = 230000 ETH
337     uint public tokenETHAmount = 600; // Amount of tokens per 1 ETH
338     
339     uint public startPreICO = 1511762400; // Mon, 27 Nov 2017 06:00:00 GMT
340     uint public endPreICO = 1514354400; // Wed, 27 Dec 2017 06:00:00 GMT
341     uint public bonusPreICO = 200  ether; // If > 200 ETH - bonus 20%, if < 200 ETH - bonus 12% 
342      
343     uint public startICO = 1517464800; // Thu, 01 Feb 2018 06:00:00 GMT
344     uint public endICOp1 = 1518069600; //  Thu, 08 Feb 2018 06:00:00 GMT
345     uint public endICOp2 = 1518674400; // Thu, 15 Feb 2018 06:00:00 GMT
346     uint public endICOp3 = 1519279200; // Thu, 22 Feb 2018 06:00:00 GMT
347     uint public endICO = 1519884000; // Thu, 01 Mar 2018 06:00:00 GMT
348     
349     bool public crowdsaleFinished = false;
350 
351     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
352 
353     function Crowdsale() {
354         // beneficiary =  msg.sender; // if beneficiary = contract creator
355 
356         token = new CottageToken();
357     }
358 
359     function() payable {
360         doPurchase();
361     }
362 
363     function doPurchase() payable {
364         
365         require((now >= startPreICO && now < endPreICO) || (now >= startICO && now < endICO));
366         require(collectedFunds < hardCap);
367         require(msg.value > 0);
368         require(!crowdsaleFinished);
369         
370         uint rest = 0;
371         uint tokensAmount = 0;
372         uint sum = msg.value;
373         
374         if(sum > hardCap.sub(collectedFunds) ) {
375            sum =  hardCap.sub(collectedFunds);
376            rest =  msg.value - sum; 
377         }
378         
379         if(now >= startPreICO && now < endPreICO){
380             if(msg.value >= bonusPreICO){
381                 tokensAmount = sum.mul(tokenETHAmount).mul(120).div(100); // Bonus 20% 
382             } else {
383                 tokensAmount = sum.mul(tokenETHAmount).mul(112).div(100); // Bonus 12%
384             }
385         }
386         
387         if(now >= startICO && now < endICOp1){
388              tokensAmount = sum.mul(tokenETHAmount).mul(110).div(100);  // Bonus 10%
389         } else if (now >= endICOp1 && now < endICOp2) {
390             tokensAmount = sum.mul(tokenETHAmount).mul(108).div(100);   // Bonus 8%
391         } else if (now >= endICOp2 && now < endICOp3) {
392             tokensAmount = sum.mul(tokenETHAmount).mul(105).div(100);  // Bonus 5%
393         } else if (now >= endICOp3 && now < endICO) {
394             tokensAmount = sum.mul(tokenETHAmount);
395         }
396 
397         require(token.mint(msg.sender, tokensAmount));
398         beneficiary.transfer(sum);
399         msg.sender.transfer(rest);
400 
401         collectedFunds = collectedFunds.add(sum);
402 
403         NewContribution(msg.sender, tokensAmount, tokenETHAmount);
404     }
405 
406     function withdraw() onlyOwner {
407         require(token.finishMinting());
408         require(beneficiary.send(this.balance)); // If we store ETH on contract
409         token.transferOwnership(beneficiary);
410 
411         crowdsaleFinished = true;
412     }
413 }