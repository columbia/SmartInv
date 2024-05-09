1 pragma solidity ^0.4.19;
2 
3 
4    
5    
6    
7    
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15 function div(uint256 a, uint256 b) internal returns (uint256) {
16     
17     uint256 c = a / b;
18     
19     return c;
20     }
21  
22 function sub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25     }
26 
27 function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31     }
32 } 
33 
34 contract ERC20Basic {
35     uint256 public totalSupply;
36     function balanceOf(address who) constant returns (uint256);
37     function transfer(address to, uint256 value);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Burn(address indexed from, uint256 value);
40 }
41 
42 
43 contract ERC20 is ERC20Basic {
44     function allowance(address owner, address spender) constant returns (uint256);
45     function transferFrom(address from, address to, uint256 value);
46     function approve(address spender, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 
51 contract BasicToken is ERC20Basic {
52     using SafeMath for uint256;
53     
54     mapping(address => uint256) balances;
55 
56 
57 
58 
59 
60 
61 function transfer(address _to, uint256 _value) {
62     
63     require ( balances[msg.sender] >= _value);
64     require ( balances[_to] + _value >= balances[_to]);
65     
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69 }
70 
71 
72 function burn(uint256 _value) {
73     
74     require ( balances[msg.sender] >= _value);
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     totalSupply = totalSupply.sub(_value);
77     
78     Burn(msg.sender, _value);
79 }
80 
81 
82 
83 
84 
85 
86 
87 function balanceOf(address _owner) constant returns (uint256 balance) {
88     return balances[_owner];
89 }
90 
91 }
92 
93 
94 contract StandardToken is ERC20, BasicToken {
95    
96     mapping (address => mapping (address => uint256)) allowed;
97    
98    
99    
100    
101    
102    
103    
104    
105    function transferFrom(address _from, address _to, uint256 _value) {
106        var _allowance = allowed[_from][msg.sender];
107        
108        
109        
110        
111        balances[_to] = balances[_to].add(_value);
112        balances[_from] = balances[_from].sub(_value);
113        allowed[_from][msg.sender] = _allowance.sub(_value);
114        Transfer(_from, _to, _value);
115    } 
116    
117 
118 
119 
120 
121 
122    function approve(address _spender, uint256 _value) {
123     
124     
125     
126     
127     
128     require ( !((_value !=0) && (allowed[msg.sender][_spender] !=0)));
129     
130     
131     allowed[msg.sender][_spender] = _value;
132     Approval(msg.sender, _spender, _value);
133 }
134 
135 
136 
137 
138 
139 
140 
141 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
142     return allowed[_owner][_spender];
143 }
144 
145 }
146 
147 contract Ownable {
148     address public owner;
149     
150     
151     
152     
153     
154     
155     function Ownable() {
156         owner = msg.sender;
157     }
158 
159 
160 
161 
162 
163 modifier onlyOwner() {
164     require(msg.sender == owner);
165     
166     _;
167 }
168 
169 
170 
171 
172 
173 
174 function transferOwnership(address newOwner) onlyOwner {
175     if (newOwner != address(0)) {
176         owner = newOwner;
177     }
178 }
179 
180 }
181 
182 contract MintableToken is StandardToken, Ownable {
183     event Mint(address indexed to, uint256 amount);
184     event MintFinished();
185     string public name = "Electron World Money";
186     string public symbol = "EWM";
187     uint256 public decimals = 18;
188     
189     bool public mintingFinished = false;
190     
191     
192     modifier canMint() {
193         require(!mintingFinished);
194         _;
195     }
196     
197     function MintableToken() {
198         mint(msg.sender, 1000000000000000000000000000);
199      finishMinting();   
200     }
201     
202     
203     
204     
205     
206     
207     
208     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
209         totalSupply = totalSupply.add(_amount);
210         balances[_to] = balances[_to].add(_amount);
211         Mint(_to, _amount);
212         Transfer(0, _to, _amount);
213         return true;
214     }
215     
216     
217     
218     
219     
220     
221     function finishMinting() onlyOwner returns (bool) {
222         mintingFinished = true;
223         MintFinished();
224         return true;
225     }
226     
227      
228 }
229 
230 contract SwapToken is MintableToken {
231     MintableToken BasicToken;
232     mapping(address => bool) migrated;
233     
234     function SwapToken (MintableToken _basicToken) {
235         BasicToken = _basicToken;
236         totalSupply = 1000000000000000000000000000;
237     }
238     
239     function migration (address _owner) internal {
240         if (!migrated[_owner]) {
241             balances[_owner] = balances[_owner].add(BasicToken.balanceOf(_owner));
242             migrated[_owner] = true;
243         }
244         
245     }
246     
247     function transfer(address _to, uint256 _value) {
248         migration (msg.sender);
249         require ( balances[msg.sender] >= _value);
250         require ( balances[_to] + _value >= balances[_to]);
251         
252         balances[msg.sender] = balances[msg.sender].sub(_value);
253         balances[_to] = balances[_to].add(_value);
254         Transfer(msg.sender, _to, _value);
255     }
256     
257     
258     function burn(uint256 _value) {
259         migration (msg.sender);
260         require ( balances[msg.sender] >= _value);
261         balances[msg.sender] = balances[msg.sender].sub(_value);
262         totalSupply = totalSupply.sub(_value);
263         
264         Burn(msg.sender, _value);
265     }
266     
267     function balanceOf(address _owner) constant returns (uint256 balance) {
268         migration(_owner);
269         return balances[_owner];
270     }
271     
272     function transferFrom(address _from, address _to, uint256 _value) {
273         var _allowance = allowed[_from][msg.sender];
274         
275         migration (msg.sender);
276         
277         
278         
279         balances[_to] = balances[_to].add(_value);
280         balances[_from] = balances[_from].sub(_value);
281         allowed[_from][msg.sender] = _allowance.sub(_value);
282         Transfer(_from, _to, _value);
283     }
284     
285     
286     
287     
288     
289     
290     function approve(address _spender, uint256 _value) {
291         
292         migration (msg.sender);
293         
294         
295         
296         
297         require ( !((_value != 0) && (allowed[msg.sender][_spender] != 0)));
298         
299         
300         allowed[msg.sender][_spender] = _value;
301         Approval(msg.sender, _spender, _value);
302     }
303 
304 
305 }
306 
307 contract Crowdsale is Ownable {
308     using SafeMath for uint256;
309     
310     
311     MintableToken public token;
312     
313     
314     uint256 public deadline;
315     
316     
317     address public wallet;
318     
319     
320     uint256 public rate;
321     
322     
323     uint256 public weiRaised;
324     
325     
326     uint256 public tokensSold;
327     
328     
329     
330     
331     
332     
333     
334     
335     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
336     
337     
338     function Crowdsale(MintableToken tokenContract, uint256 durationInWeeks, uint256 _rate, address _wallet) {
339         
340         require(_rate > 0);
341         require(_wallet != 0x0);
342         
343         
344         token = tokenContract;
345         
346         deadline = now + durationInWeeks * 1 weeks;
347         rate = _rate;
348         wallet = _wallet;
349         
350         
351         
352         
353     }
354     
355     
356     function setNewTokenOwner(address newOwner) onlyOwner {
357         token.transferOwnership(newOwner);
358     }
359     
360     
361     
362     function createTokenContract() internal returns (MintableToken) {
363         return new MintableToken();
364     }
365     
366     
367     
368     function () payable {
369         buyTokens(msg.sender);
370     }
371     
372     
373     function buyTokens(address beneficiary) payable {
374         require(beneficiary != 0x0);
375         require(validPurchase());
376         
377         uint256 weiAmount = msg.value;
378         uint256 updatedweiRaised = weiRaised.add(weiAmount);
379         
380         
381         uint256 tokens = weiAmount.mul(rate);
382         
383         
384         require ( tokens <= token.balanceOf(this) );
385         
386         
387         weiRaised = updatedweiRaised;
388         
389         
390         token.transfer(beneficiary, tokens);
391         
392         tokensSold = tokensSold.add(tokens);
393         
394         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
395         
396         forwardFunds();
397     }
398     
399     
400     
401     function forwardFunds() internal {
402         wallet.transfer(msg.value);
403     }
404     
405     
406     function validPurchase() internal constant returns (bool) {
407         uint256 current = block.number;
408         bool withinPeriod = now <= deadline;
409         bool nonZeroPurchase = msg.value != 0;
410         
411         return withinPeriod && nonZeroPurchase;
412     }
413     
414     
415     function hasEnded() public constant returns (bool) {
416         return ( now > deadline);
417         
418         
419     }
420     
421     function tokenResend() onlyOwner {
422         
423         
424         
425         token.transfer(owner, token.balanceOf(this));
426     }
427     
428 }