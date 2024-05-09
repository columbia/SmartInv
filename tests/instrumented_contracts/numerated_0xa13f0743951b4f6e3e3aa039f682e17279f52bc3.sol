1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // SencTokenSale - SENC Token Sale Contract
5 //
6 // Copyright (c) 2018 InfoCorp Technologies Pte Ltd.
7 // http://www.sentinel-chain.org/
8 //
9 // The MIT Licence.
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // The SENC token is an ERC20 token that:
14 // 1. Token is paused by default and is only allowed to be unpaused once the
15 //    Vesting contract is activated.
16 // 2. Tokens are created on demand up to TOTALSUPPLY or until minting is
17 //    disabled.
18 // 3. Token can airdropped to a group of recipients as long as the contract
19 //    has sufficient balance.
20 // ----------------------------------------------------------------------------
21 
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28   function Ownable() public {
29     owner = msg.sender;
30   }
31 
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 contract Pausable is Ownable {
46   event Pause();
47   event Unpause();
48 
49   bool public paused = false;
50 
51   modifier whenNotPaused() {
52     require(!paused);
53     _;
54   }
55 
56   modifier whenPaused() {
57     require(paused);
58     _;
59   }
60 
61   function pause() onlyOwner whenNotPaused public {
62     paused = true;
63     Pause();
64   }
65 
66   function unpause() onlyOwner whenPaused public {
67     paused = false;
68     Unpause();
69   }
70 }
71 
72 contract ERC20Basic {
73   function totalSupply() public view returns (uint256);
74   function balanceOf(address who) public view returns (uint256);
75   function transfer(address to, uint256 value) public returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77 }
78 
79 contract ERC20 is ERC20Basic {
80   function allowance(address owner, address spender) public view returns (uint256);
81   function transferFrom(address from, address to, uint256 value) public returns (bool);
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91   uint256 totalSupply_;
92 
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     // SafeMath.sub will throw if there is not enough balance.
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   function balanceOf(address _owner) public view returns (uint256 balance) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 contract StandardToken is ERC20, BasicToken {
115 
116   mapping (address => mapping (address => uint256)) internal allowed;
117 
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[_from]);
121     require(_value <= allowed[_from][msg.sender]);
122 
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   function approve(address _spender, uint256 _value) public returns (bool) {
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133     return true;
134   }
135  
136   function allowance(address _owner, address _spender) public view returns (uint256) {
137     return allowed[_owner][_spender];
138   }
139 
140   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
141     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
142     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
147     uint oldValue = allowed[msg.sender][_spender];
148     if (_subtractedValue > oldValue) {
149       allowed[msg.sender][_spender] = 0;
150     } else {
151       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
152     }
153     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154     return true;
155   }
156 
157 }
158 
159 contract PausableToken is StandardToken, Pausable {
160 
161   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
162     return super.transfer(_to, _value);
163   }
164 
165   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
166     return super.transferFrom(_from, _to, _value);
167   }
168 
169   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
170     return super.approve(_spender, _value);
171   }
172 
173   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
174     return super.increaseApproval(_spender, _addedValue);
175   }
176 
177   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
178     return super.decreaseApproval(_spender, _subtractedValue);
179   }
180 }
181 
182 contract OperatableBasic {
183     function setPrimaryOperator (address addr) public;
184     function setSecondaryOperator (address addr) public;
185     function isPrimaryOperator(address addr) public view returns (bool);
186     function isSecondaryOperator(address addr) public view returns (bool);
187 }
188 
189 contract Operatable is Ownable, OperatableBasic {
190     address public primaryOperator;
191     address public secondaryOperator;
192 
193     modifier canOperate() {
194         require(msg.sender == primaryOperator || msg.sender == secondaryOperator || msg.sender == owner);
195         _;
196     }
197 
198     function Operatable() public {
199         primaryOperator = owner;
200         secondaryOperator = owner;
201     }
202 
203     function setPrimaryOperator (address addr) public onlyOwner {
204         primaryOperator = addr;
205     }
206 
207     function setSecondaryOperator (address addr) public onlyOwner {
208         secondaryOperator = addr;
209     }
210 
211     function isPrimaryOperator(address addr) public view returns (bool) {
212         return (addr == primaryOperator);
213     }
214 
215     function isSecondaryOperator(address addr) public view returns (bool) {
216         return (addr == secondaryOperator);
217     }
218 }
219 
220 contract Salvageable is Operatable {
221     // Salvage other tokens that are accidentally sent into this token
222     function emergencyERC20Drain(ERC20 oddToken, uint amount) public canOperate {
223         if (address(oddToken) == address(0)) {
224             owner.transfer(amount);
225             return;
226         }
227         oddToken.transfer(owner, amount);
228     }
229 }
230 
231 library SafeMath {
232 
233   /**
234   * @dev Multiplies two numbers, throws on overflow.
235   */
236   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237     if (a == 0) {
238       return 0;
239     }
240     uint256 c = a * b;
241     assert(c / a == b);
242     return c;
243   }
244 
245   /**
246   * @dev Integer division of two numbers, truncating the quotient.
247   */
248   function div(uint256 a, uint256 b) internal pure returns (uint256) {
249     // assert(b > 0); // Solidity automatically throws when dividing by 0
250     uint256 c = a / b;
251     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
252     return c;
253   }
254 
255   /**
256   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
257   */
258   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
259     assert(b <= a);
260     return a - b;
261   }
262 
263   /**
264   * @dev Adds two numbers, throws on overflow.
265   */
266   function add(uint256 a, uint256 b) internal pure returns (uint256) {
267     uint256 c = a + b;
268     assert(c >= a);
269     return c;
270   }
271 }
272 
273 
274 contract SencTokenConfig {
275     string public constant NAME = "Sentinel Chain Token";
276     string public constant SYMBOL = "SENC";
277     uint8 public constant DECIMALS = 18;
278     uint public constant DECIMALSFACTOR = 10 ** uint(DECIMALS);
279     uint public constant TOTALSUPPLY = 500000000 * DECIMALSFACTOR;
280 }
281 
282 contract SencToken is PausableToken, SencTokenConfig, Salvageable {
283     using SafeMath for uint;
284 
285     string public name = NAME;
286     string public symbol = SYMBOL;
287     uint8 public decimals = DECIMALS;
288     bool public mintingFinished = false;
289 
290     event Mint(address indexed to, uint amount);
291     event MintFinished();
292 
293     modifier canMint() {
294         require(!mintingFinished);
295         _;
296     }
297 
298     function SencToken() public {
299         paused = true;
300     }
301 
302     function pause() onlyOwner public {
303         revert();
304     }
305 
306     function unpause() onlyOwner public {
307         super.unpause();
308     }
309 
310     function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
311         require(totalSupply_.add(_amount) <= TOTALSUPPLY);
312         totalSupply_ = totalSupply_.add(_amount);
313         balances[_to] = balances[_to].add(_amount);
314         Mint(_to, _amount);
315         Transfer(address(0), _to, _amount);
316         return true;
317     }
318 
319     function finishMinting() onlyOwner canMint public returns (bool) {
320         mintingFinished = true;
321         MintFinished();
322         return true;
323     }
324 
325     // Airdrop tokens from bounty wallet to contributors as long as there are enough balance
326     function airdrop(address bountyWallet, address[] dests, uint[] values) public onlyOwner returns (uint) {
327         require(dests.length == values.length);
328         uint i = 0;
329         while (i < dests.length && balances[bountyWallet] >= values[i]) {
330             this.transferFrom(bountyWallet, dests[i], values[i]);
331             i += 1;
332         }
333         return(i);
334     }
335 }