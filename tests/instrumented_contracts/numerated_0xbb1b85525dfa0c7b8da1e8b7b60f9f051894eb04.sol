1 /*! axl.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.25;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
7         if(a == 0) {
8             return 0;
9         }
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         return a / b;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
25         c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract Ownable {
32     address public owner;
33 
34     event OwnershipRenounced(address indexed previousOwner);
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     modifier onlyOwner() { require(msg.sender == owner); _;  }
38 
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     function _transferOwnership(address _newOwner) internal {
44         require(_newOwner != address(0));
45         emit OwnershipTransferred(owner, _newOwner);
46         owner = _newOwner;
47     }
48 
49     function renounceOwnership() public onlyOwner {
50         emit OwnershipRenounced(owner);
51         owner = address(0);
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         _transferOwnership(_newOwner);
56     }
57 }
58 
59 contract ERC20 {
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 
63     function totalSupply() public view returns(uint256);
64     function balanceOf(address who) public view returns(uint256);
65     function transfer(address to, uint256 value) public returns(bool);
66     function transferFrom(address from, address to, uint256 value) public returns(bool);
67     function allowance(address owner, address spender) public view returns(uint256);
68     function approve(address spender, uint256 value) public returns(bool);
69 }
70 
71 contract StandardToken is ERC20 {
72     using SafeMath for uint256;
73 
74     uint256 totalSupply_;
75 
76     string public name;
77     string public symbol;
78     uint8 public decimals;
79 
80     mapping(address => uint256) balances;
81     mapping(address => mapping(address => uint256)) internal allowed;
82 
83     constructor(string _name, string _symbol, uint8 _decimals) public {
84         name = _name;
85         symbol = _symbol;
86         decimals = _decimals;
87     }
88 
89     function totalSupply() public view returns(uint256) {
90         return totalSupply_;
91     }
92 
93     function balanceOf(address _owner) public view returns(uint256) {
94         return balances[_owner];
95     }
96 
97     function transfer(address _to, uint256 _value) public returns(bool) {
98         require(_to != address(0));
99         require(_value <= balances[msg.sender]);
100 
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         
104         emit Transfer(msg.sender, _to, _value);
105         return true;
106     }
107 
108     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
109         require(_to.length == _value.length);
110 
111         for(uint i = 0; i < _to.length; i++) {
112             transfer(_to[i], _value[i]);
113         }
114 
115         return true;
116     }
117 
118     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
119         require(_to != address(0));
120         require(_value <= balances[_from]);
121         require(_value <= allowed[_from][msg.sender]);
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126 
127         emit Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     function allowance(address _owner, address _spender) public view returns(uint256) {
132         return allowed[_owner][_spender];
133     }
134 
135     function approve(address _spender, uint256 _value) public returns(bool) {
136         allowed[msg.sender][_spender] = _value;
137 
138         emit Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
143         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
144 
145         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146         return true;
147     }
148 
149     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
150         uint oldValue = allowed[msg.sender][_spender];
151 
152         if(_subtractedValue > oldValue) {
153             allowed[msg.sender][_spender] = 0;
154         }
155         else {
156             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
157         }
158 
159         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 }
163 
164 contract MintableToken is StandardToken, Ownable {
165     bool public mintingFinished = false;
166 
167     event Mint(address indexed to, uint256 amount);
168     event MintFinished();
169 
170     modifier canMint() { require(!mintingFinished); _; }
171     modifier canNotMint() { require(mintingFinished); _; }
172     modifier hasMintPermission() { require(msg.sender == owner); _; }
173 
174     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
175         totalSupply_ = totalSupply_.add(_amount);
176         balances[_to] = balances[_to].add(_amount);
177 
178         emit Mint(_to, _amount);
179         emit Transfer(address(0), _to, _amount);
180         return true;
181     }
182 
183     function finishMinting() onlyOwner canMint public returns(bool) {
184         mintingFinished = true;
185 
186         emit MintFinished();
187         return true;
188     }
189 }
190 
191 contract CappedToken is MintableToken {
192     uint256 public cap;
193 
194     constructor(uint256 _cap) public {
195         require(_cap > 0);
196         cap = _cap;
197     }
198 
199     function mint(address _to, uint256 _amount) public returns(bool) {
200         require(totalSupply_.add(_amount) <= cap);
201 
202         return super.mint(_to, _amount);
203     }
204 }
205 
206 contract BurnableToken is StandardToken {
207     event Burn(address indexed burner, uint256 value);
208 
209     function _burn(address _who, uint256 _value) internal {
210         require(_value <= balances[_who]);
211 
212         balances[_who] = balances[_who].sub(_value);
213         totalSupply_ = totalSupply_.sub(_value);
214 
215         emit Burn(_who, _value);
216         emit Transfer(_who, address(0), _value);
217     }
218 
219     function burn(uint256 _value) public {
220         _burn(msg.sender, _value);
221     }
222 
223     function burnFrom(address _from, uint256 _value) public {
224         require(_value <= allowed[_from][msg.sender]);
225         
226         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227         _burn(_from, _value);
228     }
229 }
230 
231 contract Pausable is Ownable {
232     bool public paused = false;
233 
234     event Pause();
235     event Unpause();
236 
237     modifier whenNotPaused() { require(!paused); _; }
238     modifier whenPaused() { require(paused); _; }
239 
240     function pause() onlyOwner whenNotPaused public {
241         paused = true;
242         emit Pause();
243     }
244 
245     function unpause() onlyOwner whenPaused public {
246         paused = false;
247         emit Unpause();
248     }
249 }
250 
251 
252 /*
253     ADVEXCEL ICO
254 */
255 contract Token is CappedToken, BurnableToken {
256     constructor() CappedToken(15500000 * 1e8) StandardToken("ADVEXCEL", "AXL", 8) public {
257         
258     }
259 }
260 
261 contract Crowdsale is Pausable {
262     using SafeMath for uint;
263 
264     uint constant TOKENS_FOR_SALE = 10850000 * 1e8;
265     uint constant TOKENS_FOR_MANUAL = 4650000 * 1e8;
266 
267     Token public token;
268     address public beneficiary = 0x9a41fCFAef459F82a779D9a16baaaed41D52Ef84;    // multisig
269     bool public crowdsaleClosed = false;
270 
271     uint public ethPriceUsd = 23000;
272     uint public tokenPriceUsd = 1725;
273 
274     uint public collectedWei;
275     uint public tokensSold;
276     uint public tokensMint;
277 
278     event NewEtherPriceUSD(uint256 value);
279     event NewTokenPriceUSD(uint256 value);
280     event Rurchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount, uint256 returnEther);
281     event Mint(address indexed holder, uint256 tokenAmount);
282     event CloseCrowdsale();
283    
284     constructor() public {
285         token = new Token();
286     }
287     
288     function() payable public {
289         purchase();
290     }
291 
292     function setEtherPriceUSD(uint _value) onlyOwner public {
293         ethPriceUsd = _value;
294         emit NewEtherPriceUSD(_value);
295     }
296 
297     function setTokenPriceUSD(uint _value) onlyOwner public {
298         tokenPriceUsd = _value;
299         emit NewTokenPriceUSD(_value);
300     }
301 
302     function purchase() whenNotPaused payable public {
303         require(!crowdsaleClosed, "Crowdsale closed");
304         require(tokensSold < TOKENS_FOR_SALE, "All tokens sold");
305         require(msg.value >= 0.01 ether, "Too small amount");
306 
307         uint sum = msg.value;
308         uint amount = sum.mul(ethPriceUsd).div(tokenPriceUsd).div(1e10);
309         uint retSum = 0;
310         
311         if(tokensSold.add(amount) > TOKENS_FOR_SALE) {
312             uint retAmount = tokensSold.add(amount).sub(TOKENS_FOR_SALE);
313             retSum = retAmount.mul(1e10).mul(tokenPriceUsd).div(ethPriceUsd);
314 
315             amount = amount.sub(retAmount);
316             sum = sum.sub(retSum);
317         }
318 
319         tokensSold = tokensSold.add(amount);
320         collectedWei = collectedWei.add(sum);
321 
322         beneficiary.transfer(sum);
323         token.mint(msg.sender, amount);
324 
325         if(retSum > 0) {
326             msg.sender.transfer(retSum);
327         }
328 
329         emit Rurchase(msg.sender, amount, sum, retSum);
330     }
331 
332     function mint(address _to, uint _value) onlyOwner public {
333         require(!crowdsaleClosed, "Crowdsale closed");
334         require(tokensMint < TOKENS_FOR_MANUAL, "All tokens mint");
335         require(tokensMint.add(_value) < TOKENS_FOR_MANUAL, "Amount exceeds allowed limit");
336 
337         tokensMint = tokensMint.add(_value);
338 
339         token.mint(_to, _value);
340 
341         emit Mint(_to, _value);
342     }
343 
344     function closeCrowdsale(address _to) onlyOwner public {
345         require(!crowdsaleClosed, "Crowdsale already closed");
346 
347         token.finishMinting();
348         token.transferOwnership(_to);
349 
350         crowdsaleClosed = true;
351 
352         emit CloseCrowdsale();
353     }
354 }