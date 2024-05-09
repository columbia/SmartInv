1 pragma solidity ^0.4.11;
2 
3 //#importRegion
4     /**
5      * @title SafeMath
6      * @dev Math operations with safety checks that throw on error
7      */
8     library SafeMath {
9       function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13       }
14 
15       function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20       }
21 
22       function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25       }
26 
27       function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31       }
32     }
33 
34     /**
35      * @title ERC20Basic
36      * @dev Simpler version of ERC20 interface
37      * @dev see https://github.com/ethereum/EIPs/issues/179
38      */
39     contract ERC20Basic {
40       uint256 public totalSupply;
41       function balanceOf(address who) constant returns (uint256);
42       function transfer(address to, uint256 value) returns (bool);
43       event Transfer(address indexed from, address indexed to, uint256 value);
44     }
45 
46     /**
47      * @title ERC20 interface
48      * @dev see https://github.com/ethereum/EIPs/issues/20
49      */
50     contract ERC20 is ERC20Basic {
51       function allowance(address owner, address spender) constant returns (uint256);
52       function transferFrom(address from, address to, uint256 value) returns (bool);
53       function approve(address spender, uint256 value) returns (bool);
54       event Approval(address indexed owner, address indexed spender, uint256 value);
55     }
56 
57     /**
58      * @title Basic token
59      * @dev Basic version of StandardToken, with no allowances. 
60      */
61     contract BasicToken is ERC20Basic {
62       using SafeMath for uint256;
63 
64       mapping(address => uint256) balances;
65 
66       /**
67       * @dev transfer token for a specified address
68       * @param _to The address to transfer to.
69       * @param _value The amount to be transferred.
70       */
71       function transfer(address _to, uint256 _value) returns (bool) {
72         require(_to != address(0));
73 
74         // SafeMath.sub will throw if there is not enough balance.
75         balances[msg.sender] = balances[msg.sender].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77         Transfer(msg.sender, _to, _value);
78         return true;
79       }
80 
81       /**
82       * @dev Gets the balance of the specified address.
83       * @param _owner The address to query the the balance of. 
84       * @return An uint256 representing the amount owned by the passed address.
85       */
86       function balanceOf(address _owner) constant returns (uint256 balance) {
87         return balances[_owner];
88       }
89 
90     }
91 
92     /**
93      * @title Standard ERC20 token
94      *
95      * @dev Implementation of the basic standard token.
96      * @dev https://github.com/ethereum/EIPs/issues/20
97      * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98      */
99     contract StandardToken is ERC20, BasicToken {
100 
101       mapping (address => mapping (address => uint256)) allowed;
102 
103 
104       /**
105        * @dev Transfer tokens from one address to another
106        * @param _from address The address which you want to send tokens from
107        * @param _to address The address which you want to transfer to
108        * @param _value uint256 the amount of tokens to be transferred
109        */
110       function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
111         require(_to != address(0));
112 
113         var _allowance = allowed[_from][msg.sender];
114 
115         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116         // require (_value <= _allowance);
117 
118         balances[_from] = balances[_from].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         allowed[_from][msg.sender] = _allowance.sub(_value);
121         Transfer(_from, _to, _value);
122         return true;
123       }
124 
125       /**
126        * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127        * @param _spender The address which will spend the funds.
128        * @param _value The amount of tokens to be spent.
129        */
130       function approve(address _spender, uint256 _value) returns (bool) {
131 
132         // To change the approve amount you first have to reduce the addresses`
133         //  allowance to zero by calling `approve(_spender, 0)` if it is not
134         //  already 0 to mitigate the race condition described here:
135         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
137 
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141       }
142 
143       /**
144        * @dev Function to check the amount of tokens that an owner allowed to a spender.
145        * @param _owner address The address which owns the funds.
146        * @param _spender address The address which will spend the funds.
147        * @return A uint256 specifying the amount of tokens still available for the spender.
148        */
149       function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
150         return allowed[_owner][_spender];
151       }
152       
153       /**
154        * approve should be called when allowed[_spender] == 0. To increment
155        * allowed value is better to use this function to avoid 2 calls (and wait until 
156        * the first transaction is mined)
157        * From MonolithDAO Token.sol
158        */
159       function increaseApproval (address _spender, uint _addedValue) 
160         returns (bool success) {
161         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164       }
165 
166       function decreaseApproval (address _spender, uint _subtractedValue) 
167         returns (bool success) {
168         uint oldValue = allowed[msg.sender][_spender];
169         if (_subtractedValue > oldValue) {
170           allowed[msg.sender][_spender] = 0;
171         } else {
172           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173         }
174         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175         return true;
176       }
177 
178     }
179 
180     /**
181      * @title Ownable
182      * @dev The Ownable contract has an owner address, and provides basic authorization control
183      * functions, this simplifies the implementation of "user permissions".
184      */
185     contract Ownable {
186       address public owner;
187 
188 
189       event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191 
192       /**
193        * @dev The Ownable constructor sets the original `owner` of the contract to the sender
194        * account.
195        */
196       function Ownable() {
197         owner = msg.sender;
198       }
199 
200 
201       /**
202        * @dev Throws if called by any account other than the owner.
203        */
204       modifier onlyOwner() {
205         require(msg.sender == owner);
206         _;
207       }
208 
209 
210       /**
211        * @dev Allows the current owner to transfer control of the contract to a newOwner.
212        * @param newOwner The address to transfer ownership to.
213        */
214       function transferOwnership(address newOwner) onlyOwner {
215         require(newOwner != address(0));      
216         OwnershipTransferred(owner, newOwner);
217         owner = newOwner;
218       }
219 
220     }
221 //#endImportRegion
222 
223 contract RewardToken is StandardToken, Ownable {
224     bool public payments = false;
225     mapping(address => uint256) public rewards;
226     uint public payment_time = 0;
227     uint public payment_amount = 0;
228 
229     event Reward(address indexed to, uint256 value);
230 
231     function payment() payable onlyOwner {
232         require(payments);
233         require(msg.value >= 0.01 * 1 ether);
234 
235         payment_time = now;
236         payment_amount = this.balance;
237     }
238 
239     function _reward(address _to) private returns (bool) {
240         require(payments);
241         require(rewards[_to] < payment_time);
242 
243         if(balances[_to] > 0) {
244 			uint amount = payment_amount * balances[_to] / totalSupply;
245 
246 			require(_to.send(amount));
247 
248 			Reward(_to, amount);
249 		}
250 
251         rewards[_to] = payment_time;
252 
253         return true;
254     }
255 
256     function reward() returns (bool) {
257         return _reward(msg.sender);
258     }
259 
260     function transfer(address _to, uint256 _value) returns (bool) {
261 		if(payments) {
262 			if(rewards[msg.sender] < payment_time) require(_reward(msg.sender));
263 			if(rewards[_to] < payment_time) require(_reward(_to));
264 		}
265 
266         return super.transfer(_to, _value);
267     }
268 
269 	function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
270 		if(payments) {
271 			if(rewards[_from] < payment_time) require(_reward(_from));
272 			if(rewards[_to] < payment_time) require(_reward(_to));
273 		}
274 
275         return super.transferFrom(_from, _to, _value);
276     }
277 }
278 
279 contract LoriToken is RewardToken {
280     using SafeMath for uint;
281 
282     string public name = "LORI Invest Token";
283     string public symbol = "LORI";
284     uint256 public decimals = 18;
285 
286     bool public mintingFinished = false;
287     bool public commandGetBonus = false;
288     uint public commandGetBonusTime = 1543932000;       // 04.12.2018 14:00 +0
289 
290     event Mint(address indexed holder, uint256 tokenAmount);
291     event MintFinished();
292     event MintCommandBonus();
293 
294     function _mint(address _to, uint256 _amount) onlyOwner private returns(bool) {
295         totalSupply = totalSupply.add(_amount);
296         balances[_to] = balances[_to].add(_amount);
297 
298         Mint(_to, _amount);
299         Transfer(address(0), _to, _amount);
300 
301         return true;
302     }
303 
304     function mint(address _to, uint256 _amount) onlyOwner returns(bool) {
305         require(!mintingFinished);
306         return _mint(_to, _amount);
307     }
308 
309     function finishMinting() onlyOwner returns(bool) {
310         mintingFinished = true;
311         payments = true;
312 
313         MintFinished();
314 
315         return true;
316     }
317 
318     function commandMintBonus(address _to) onlyOwner {
319         require(mintingFinished && !commandGetBonus);
320         require(now > commandGetBonusTime);
321 
322         commandGetBonus = true;
323 
324         require(_mint(_to, totalSupply * 5 / 100));
325 
326         MintCommandBonus();
327     }
328 }
329 
330 contract Crowdsale is Ownable {
331     using SafeMath for uint;
332 
333     LoriToken public token;
334     address public beneficiary = 0xdA6273CBF8DFB22f4A55A6F87bb1A91C57e578db;
335 
336     uint public collected;
337 
338     uint public preICOstartTime = 1507644000;     // 10.10.2017 14:00 +0
339     uint public preICOendTime = 1508853600;     // 24.10.2017 14:00 +0
340     uint public ICOstartTime = 1510322400;    // 10.11.2017 14:00 +0
341     uint public ICOendTime = 1512396000;       // 04.12.2017 14:00 +0
342     bool public crowdsaleFinished = false;
343 
344     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
345 
346     function Crowdsale() {
347         token = new LoriToken();
348     }
349 
350     function() payable {
351         doPurchase();
352     }
353 
354     function doPurchase() payable {
355         assert((now > preICOstartTime && now < preICOendTime) || (now > ICOstartTime && now < ICOendTime));
356         require(msg.value >= 0.01 * 1 ether);
357         require(!crowdsaleFinished);
358 
359         uint tokens = msg.value * (now >= ICOstartTime ? 100 : 120);
360 
361         require(token.mint(msg.sender, tokens));
362         require(beneficiary.send(msg.value));
363 
364         collected = collected.add(msg.value);
365 
366         NewContribution(msg.sender, tokens, msg.value);
367     }
368 
369     function withdraw() onlyOwner {
370         require(token.finishMinting());
371         require(beneficiary.send(this.balance));
372         token.transferOwnership(beneficiary);
373 
374         crowdsaleFinished = true;
375     }
376 }