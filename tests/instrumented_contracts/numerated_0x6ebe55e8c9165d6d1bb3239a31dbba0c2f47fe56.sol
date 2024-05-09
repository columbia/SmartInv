1 pragma solidity ^0.4.23;
2 ///////////////////////////////////////////////////
3 //  
4 //  `iCashweb` ICW Token Contract
5 //
6 //  Total Tokens: 300,000,000.000000000000000000
7 //  Name: iCashweb
8 //  Symbol: ICWeb
9 //  Decimal Scheme: 18
10 //  
11 //  by Nishad Vadgama
12 ///////////////////////////////////////////////////
13 
14 library iMath {
15     function mul(
16         uint256 a, uint256 b
17     ) 
18     internal 
19     pure 
20     returns(uint256) {
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     function div(
30         uint256 a, uint256 b
31     ) 
32     internal 
33     pure 
34     returns(uint256) {
35         uint256 c = a / b;
36         return c;
37     }
38 
39     function sub(
40         uint256 a, uint256 b
41     ) 
42     internal 
43     pure 
44     returns(uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49     function add(
50         uint256 a, uint256 b
51     ) 
52     internal 
53     pure 
54     returns(uint256) {
55         uint256 c = a + b;
56         assert(c >= a);
57         return c;
58     }
59 }
60 contract iSimpleContract {
61     function changeRate(
62         uint256 value
63     ) 
64     public 
65     returns(bool);
66 
67     function startMinting(
68         bool status
69     ) 
70     public 
71     returns(bool);  
72 
73     function changeOwnerShip(
74         address toWhom
75     ) 
76     public 
77     returns(bool);
78 
79     function releaseMintTokens() 
80     public 
81     returns(bool);
82 
83     function transferMintTokens(
84         address to, uint256 value
85     ) 
86     public 
87     returns(bool);
88 
89     function moveMintTokens(
90         address from, address to, uint256 value
91     ) 
92     public 
93     returns(bool);
94 
95     function manageOperable(
96         address _from, bool _value
97     ) 
98     public 
99     returns(bool);
100 
101     function isOperable(
102         address _from
103     ) 
104     public 
105     view 
106     returns(bool);
107 
108     event Release(
109         address indexed from, uint256 value
110     );
111 
112     event Operable(
113         address indexed from, address indexed to, bool value
114     );
115 }
116 contract iERC01Basic is iSimpleContract {
117     function totalSupply() 
118     public 
119     view 
120     returns(uint256);
121 
122     function balanceOf(
123         address who
124     ) 
125     public 
126     view 
127     returns(uint256);
128 
129     function transfer(
130         address to, uint256 value
131     ) 
132     public 
133     returns(bool);
134 
135     function transferTokens()
136     public 
137     payable;
138 
139     event Transfer(
140         address indexed from, address indexed to, uint256 value
141     );
142 }
143 contract iERC20 is iERC01Basic {
144     function allowance(
145         address owner, address spender
146     ) 
147     public 
148     view 
149     returns(uint256);
150 
151     function transferFrom(
152         address from, address to, uint256 value
153     ) 
154     public 
155     returns(bool);
156 
157     function approve(
158         address spender, uint256 value
159     ) 
160     public 
161     returns(bool);
162     event Approval(
163         address indexed owner, address indexed spender, uint256 value
164     );
165 }
166 contract ICWToken is iERC01Basic {
167     using iMath for uint256;
168     mapping(address => uint256)     balances;
169     mapping(address => bool)        operable;
170     address public                  contractModifierAddress;
171     uint256                         _totalSupply;
172     uint256                         _totalMintSupply;
173     uint256                         _maxMintable;
174     uint256                         _rate = 100;
175     bool                            _mintingStarted;
176     bool                            _minted;
177 
178     uint8 public constant           decimals = 18;
179     uint256 public constant         INITIAL_SUPPLY = 150000000 * (10 ** uint256(decimals));
180 
181     modifier onlyByOwned() 
182     {
183         require(msg.sender == contractModifierAddress || operable[msg.sender] == true);
184         _;
185     }
186 
187     function getMinted() 
188     public 
189     view 
190     returns(bool) {
191         return _minted;
192     }
193 
194     function getOwner() 
195     public 
196     view 
197     returns(address) {
198         return contractModifierAddress;
199     }
200     
201     function getMintingStatus() 
202     public 
203     view 
204     returns(bool) {
205         return _mintingStarted;
206     }
207 
208     function getRate() 
209     public 
210     view 
211     returns(uint256) {
212         return _rate;
213     }
214 
215     function totalSupply() 
216     public 
217     view 
218     returns(uint256) {
219         return _totalSupply;
220     }
221 
222     function totalMintSupply() 
223     public 
224     view 
225     returns(uint256) {
226         return _totalMintSupply;
227     }
228 
229     function balanceOf(
230         address _owner
231     ) 
232     public 
233     view 
234     returns(uint256 balance) {
235         return balances[_owner];
236     }
237 
238     function destroyContract() 
239     public {
240         require(msg.sender == contractModifierAddress);
241         selfdestruct(contractModifierAddress);
242     }
243 
244     function changeRate(
245         uint256 _value
246     ) 
247     public 
248     onlyByOwned 
249     returns(bool) {
250         require(_value > 0);
251         _rate = _value;
252         return true;
253     }
254 
255     function startMinting(
256         bool status_
257     ) 
258     public 
259     onlyByOwned 
260     returns(bool) {
261         _mintingStarted = status_;
262         return true;
263     }
264 
265     function changeOwnerShip(
266         address _to
267     ) 
268     public 
269     onlyByOwned 
270     returns(bool) {
271         address oldOwner = contractModifierAddress;
272         uint256 balAmount = balances[oldOwner];
273         balances[_to] = balances[_to].add(balAmount);
274         balances[oldOwner] = 0;
275         contractModifierAddress = _to;
276         emit Transfer(oldOwner, contractModifierAddress, balAmount);
277         return true;
278     }
279 
280     function releaseMintTokens() 
281     public 
282     onlyByOwned 
283     returns(bool) {
284         require(_minted == false);
285         uint256 releaseAmount = _maxMintable.sub(_totalMintSupply);
286         uint256 totalReleased = _totalMintSupply.add(releaseAmount);
287         require(_maxMintable >= totalReleased);
288         _totalMintSupply = _totalMintSupply.add(releaseAmount);
289         balances[contractModifierAddress] = balances[contractModifierAddress].add(releaseAmount);
290         emit Transfer(0x0, contractModifierAddress, releaseAmount);
291         emit Release(contractModifierAddress, releaseAmount);
292         return true;
293     }
294 
295     function transferMintTokens(
296         address _to, uint256 _value
297     ) 
298     public 
299     onlyByOwned
300     returns(bool) {
301         uint totalToken = _totalMintSupply.add(_value);
302         require(_maxMintable >= totalToken);
303         balances[_to] = balances[_to].add(_value);
304         _totalMintSupply = _totalMintSupply.add(_value);
305         emit Transfer(0x0, _to, _value);
306         return true;
307     }
308 
309     function moveMintTokens(
310         address _from, address _to, uint256 _value
311     ) 
312     public 
313     onlyByOwned 
314     returns(bool) {
315         require(_to != _from);
316         require(_value <= balances[_from]);
317         balances[_from] = balances[_from].sub(_value);
318         balances[_to] = balances[_to].add(_value);
319         emit Transfer(_from, _to, _value);
320         return true;
321     }
322 
323     function manageOperable(
324         address _from, bool _value
325     ) 
326     public returns(bool) {
327         require(msg.sender == contractModifierAddress);
328         operable[_from] = _value;
329         emit Operable(msg.sender, _from, _value);
330         return true;
331     }
332 
333     function isOperable(
334         address _from
335     ) 
336     public 
337     view 
338     returns(bool) {
339         return operable[_from];
340     }
341 
342     function transferTokens()
343     public 
344     payable {
345         require(_mintingStarted == true && msg.value > 0);
346         uint tokens = msg.value.mul(_rate);
347         uint totalToken = _totalMintSupply.add(tokens);
348         require(_maxMintable >= totalToken);
349         balances[msg.sender] = balances[msg.sender].add(tokens);
350         _totalMintSupply = _totalMintSupply.add(tokens);
351         contractModifierAddress.transfer(msg.value);
352         emit Transfer(0x0, msg.sender, tokens);
353     }
354 
355     function transfer(
356         address _to, uint256 _value
357     ) 
358     public 
359     returns(bool) {
360         require(_to != msg.sender);
361         require(_value <= balances[msg.sender]);
362         balances[msg.sender] = balances[msg.sender].sub(_value);
363         balances[_to] = balances[_to].add(_value);
364         emit Transfer(msg.sender, _to, _value);
365         return true;
366     }
367 }
368 contract iCashwebToken is iERC20, ICWToken {
369     mapping(
370         address => mapping(address => uint256)
371     ) internal _allowed;
372 
373     function transferFrom(
374         address _from, address _to, uint256 _value
375     ) 
376     public 
377     returns(bool) {
378         require(_to != msg.sender);
379         require(_value <= balances[_from]);
380         require(_value <= _allowed[_from][msg.sender]);
381         balances[_from] = balances[_from].sub(_value);
382         balances[_to] = balances[_to].add(_value);
383         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
384         emit Transfer(_from, _to, _value);
385         return true;
386     }
387 
388     function approve(
389         address _spender, uint256 _value
390     ) 
391     public 
392     returns(bool) {
393         _allowed[msg.sender][_spender] = _value;
394         emit Approval(msg.sender, _spender, _value);
395         return true;
396     }
397 
398     function allowance(
399         address _owner, address _spender
400     ) 
401     public 
402     view 
403     returns(uint256) {
404         return _allowed[_owner][_spender];
405     }
406 
407     function increaseApproval(
408         address _spender, uint _addedValue
409     ) 
410     public 
411     returns(bool) {
412         _allowed[msg.sender][_spender] = _allowed[msg.sender][_spender].add(_addedValue);
413         emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
414         return true;
415     }
416 
417     function decreaseApproval(
418         address _spender, uint _subtractedValue
419     ) 
420     public 
421     returns(bool) {
422         uint oldValue = _allowed[msg.sender][_spender];
423         if (_subtractedValue > oldValue) {
424             _allowed[msg.sender][_spender] = 0;
425         } else {
426             _allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
427         }
428         emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
429         return true;
430     }
431 }
432 
433 contract iCashweb is iCashwebToken {
434     string public constant name = "iCashweb";
435     string public constant symbol = "ICWeb";
436     constructor() 
437     public {
438         _mintingStarted = false;
439         _minted = false;
440         contractModifierAddress = msg.sender;
441         _totalSupply = INITIAL_SUPPLY * 2;
442         _maxMintable = INITIAL_SUPPLY;
443         balances[msg.sender] = INITIAL_SUPPLY;
444     }
445     function () 
446     public 
447     payable {
448         transferTokens();
449     }
450 }