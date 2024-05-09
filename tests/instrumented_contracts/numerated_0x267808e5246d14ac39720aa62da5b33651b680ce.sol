1 pragma solidity >=0.4.4;
2 
3 //from Zeppelin
4 contract SafeMath {
5     function safeMul(uint a, uint b) internal returns (uint) {
6         uint c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeSub(uint a, uint b) internal returns (uint) {
12         assert(b <= a);
13         return a - b;
14     }
15 
16     function safeAdd(uint a, uint b) internal returns (uint) {
17         uint c = a + b;
18         assert(c>=a && c>=b);
19         return c;
20     }
21 
22     function assert(bool assertion) internal {
23         if (!assertion) throw;
24     }
25 }
26 
27 contract Owned {
28     address public owner;
29 
30     function Owned() {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner() {
35         if (msg.sender != owner) throw;
36         _;
37     }
38 
39     address newOwner;
40 
41     function changeOwner(address _newOwner) onlyOwner {
42         newOwner = _newOwner;
43     }
44 
45     function acceptOwnership() {
46         if (msg.sender == newOwner) {
47             owner = newOwner;
48         }
49     }
50 }
51 
52 contract Finalizable is Owned {
53     bool public finalized;
54 
55     function finalize() onlyOwner {
56         finalized = true;
57     }
58 
59     modifier notFinalized() {
60         if (finalized) throw;
61         _;
62     }
63 }
64 
65 contract IToken {
66     function transfer(address _to, uint _value) returns (bool);
67     function balanceOf(address owner) returns(uint);
68 }
69 
70 contract TokenReceivable is Owned {
71     event logTokenTransfer(address token, address to, uint amount);
72 
73     function claimTokens(address _token, address _to) onlyOwner returns (bool) {
74         IToken token = IToken(_token);
75         uint balance = token.balanceOf(this);
76         if (token.transfer(_to, balance)) {
77             logTokenTransfer(_token, _to, balance);
78             return true;
79         }
80         return false;
81     }
82 }
83 
84 contract EventDefinitions {
85     event Transfer(address indexed from, address indexed to, uint value);
86     event Approval(address indexed owner, address indexed spender, uint value);
87 }
88 
89 contract Token is Finalizable, TokenReceivable, SafeMath, EventDefinitions {
90 
91     string public name = "FunFair";
92     uint8 public decimals = 8;
93     string public symbol = "FUN";
94 
95     Controller controller;
96     address owner;
97 
98     modifier onlyController() {
99         assert(msg.sender == address(controller));
100         _;
101     }
102 
103     function setController(address _c) onlyOwner notFinalized {
104         controller = Controller(_c);
105     }
106 
107     function balanceOf(address a) constant returns (uint) {
108         return controller.balanceOf(a);
109     }
110 
111     function totalSupply() constant returns (uint) {
112         return controller.totalSupply();
113     }
114 
115     function allowance(address _owner, address _spender) constant returns (uint) {
116         return controller.allowance(_owner, _spender);
117     }
118 
119     function transfer(address _to, uint _value)
120     onlyPayloadSize(2)
121     returns (bool success) {
122        success = controller.transfer(msg.sender, _to, _value);
123         if (success) {
124             Transfer(msg.sender, _to, _value);
125         }
126     }
127 
128     function transferFrom(address _from, address _to, uint _value)
129     onlyPayloadSize(3)
130     returns (bool success) {
131        success = controller.transferFrom(msg.sender, _from, _to, _value);
132         if (success) {
133             Transfer(_from, _to, _value);
134         }
135     }
136 
137     function approve(address _spender, uint _value)
138     onlyPayloadSize(2)
139     returns (bool success) {
140         //promote safe user behavior
141         if (controller.allowance(msg.sender, _spender) > 0) throw;
142 
143         success = controller.approve(msg.sender, _spender, _value);
144         if (success) {
145             Approval(msg.sender, _spender, _value);
146         }
147     }
148 
149     function increaseApproval (address _spender, uint _addedValue)
150     onlyPayloadSize(2)
151     returns (bool success) {
152         success = controller.increaseApproval(msg.sender, _spender, _addedValue);
153         if (success) {
154             uint newval = controller.allowance(msg.sender, _spender);
155             Approval(msg.sender, _spender, newval);
156         }
157     }
158 
159     function decreaseApproval (address _spender, uint _subtractedValue)
160     onlyPayloadSize(2)
161     returns (bool success) {
162         success = controller.decreaseApproval(msg.sender, _spender, _subtractedValue);
163         if (success) {
164             uint newval = controller.allowance(msg.sender, _spender);
165             Approval(msg.sender, _spender, newval);
166         }
167     }
168 
169     modifier onlyPayloadSize(uint numwords) {
170         assert(msg.data.length >= numwords * 32 + 4);
171         _;
172     }
173 
174     function burn(uint _amount) {
175         controller.burn(msg.sender, _amount);
176         Transfer(msg.sender, 0x0, _amount);
177     }
178 
179     function controllerTransfer(address _from, address _to, uint _value)
180     onlyController {
181         Transfer(_from, _to, _value);
182     }
183 
184     function controllerApprove(address _owner, address _spender, uint _value)
185     onlyController {
186         Approval(_owner, _spender, _value);
187     }
188 
189     //multi-approve, multi-transfer
190 
191     bool public multilocked;
192 
193     modifier notMultilocked {
194         assert(!multilocked);
195         _;
196     }
197 
198     //do we want lock permanent? I think so.
199     function lockMultis() onlyOwner {
200         multilocked = true;
201     }
202 
203     //multi functions just issue events, to fix initial event history
204 
205     function multiTransfer(uint[] bits) onlyOwner notMultilocked {
206         if (bits.length % 3 != 0) throw;
207         for (uint i=0; i<bits.length; i += 3) {
208             address from = address(bits[i]);
209             address to = address(bits[i+1]);
210             uint amount = bits[i+2];
211             Transfer(from, to, amount);
212         }
213     }
214 
215     function multiApprove(uint[] bits) onlyOwner notMultilocked {
216         if (bits.length % 3 != 0) throw;
217         for (uint i=0; i<bits.length; i += 3) {
218             address owner = address(bits[i]);
219             address spender = address(bits[i+1]);
220             uint amount = bits[i+2];
221             Approval(owner, spender, amount);
222         }
223     }
224 
225     string public motd;
226     event Motd(string message);
227     function setMotd(string _m) onlyOwner {
228         motd = _m;
229         Motd(_m);
230     }
231 }
232 
233 contract Controller is Owned, Finalizable {
234     Ledger public ledger;
235     Token public token;
236     address public oldToken;
237     address public EtherDelta;
238 
239     function setEtherDelta(address _addr) onlyOwner {
240         EtherDelta = _addr;
241     }
242 
243     function setOldToken(address _token) onlyOwner {
244         oldToken = _token;
245     }
246 
247     function setToken(address _token) onlyOwner {
248         token = Token(_token);
249     }
250 
251     function setLedger(address _ledger) onlyOwner {
252         ledger = Ledger(_ledger);
253     }
254 
255     modifier onlyToken() {
256         if (msg.sender != address(token) && msg.sender != oldToken) throw;
257         _;
258     }
259 
260     modifier onlyNewToken() {
261         if (msg.sender != address(token)) throw;
262 	_;
263     }
264 
265     function totalSupply() constant returns (uint) {
266         return ledger.totalSupply();
267     }
268 
269     function balanceOf(address _a) onlyToken constant returns (uint) {
270         return Ledger(ledger).balanceOf(_a);
271     }
272 
273     function allowance(address _owner, address _spender)
274     onlyToken constant returns (uint) {
275         return ledger.allowance(_owner, _spender);
276     }
277 
278     function transfer(address _from, address _to, uint _value)
279     onlyToken
280     returns (bool success) {
281         assert(msg.sender != oldToken || _from == EtherDelta);
282         bool ok = ledger.transfer(_from, _to, _value);
283 	if (ok && msg.sender == oldToken)
284 	    token.controllerTransfer(_from, _to, _value);
285 	return ok;
286     }
287 
288     function transferFrom(address _spender, address _from, address _to, uint _value)
289     onlyToken
290     returns (bool success) {
291         assert(msg.sender != oldToken || _from == EtherDelta);
292         bool ok = ledger.transferFrom(_spender, _from, _to, _value);
293 	if (ok && msg.sender == oldToken)
294 	    token.controllerTransfer(_from, _to, _value);
295 	return ok;
296     }
297 
298     function approve(address _owner, address _spender, uint _value)
299     onlyNewToken
300     returns (bool success) {
301         return ledger.approve(_owner, _spender, _value);
302     }
303 
304     function increaseApproval (address _owner, address _spender, uint _addedValue)
305     onlyNewToken
306     returns (bool success) {
307         return ledger.increaseApproval(_owner, _spender, _addedValue);
308     }
309 
310     function decreaseApproval (address _owner, address _spender, uint _subtractedValue)
311     onlyNewToken
312     returns (bool success) {
313         return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
314     }
315 
316     function burn(address _owner, uint _amount) onlyNewToken {
317         ledger.burn(_owner, _amount);
318     }
319 }
320 
321 contract Ledger is Owned, SafeMath, Finalizable {
322     address public controller;
323     mapping(address => uint) public balanceOf;
324     mapping (address => mapping (address => uint)) public allowance;
325     uint public totalSupply;
326 
327     function setController(address _controller) onlyOwner notFinalized {
328         controller = _controller;
329     }
330 
331     modifier onlyController() {
332         if (msg.sender != controller) throw;
333         _;
334     }
335 
336     function transfer(address _from, address _to, uint _value)
337     onlyController
338     returns (bool success) {
339         if (balanceOf[_from] < _value) return false;
340 
341         balanceOf[_from] = safeSub(balanceOf[_from], _value);
342         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
343         return true;
344     }
345 
346     function transferFrom(address _spender, address _from, address _to, uint _value)
347     onlyController
348     returns (bool success) {
349         if (balanceOf[_from] < _value) return false;
350 
351         var allowed = allowance[_from][_spender];
352         if (allowed < _value) return false;
353 
354         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
355         balanceOf[_from] = safeSub(balanceOf[_from], _value);
356         allowance[_from][_spender] = safeSub(allowed, _value);
357         return true;
358     }
359 
360     function approve(address _owner, address _spender, uint _value)
361     onlyController
362     returns (bool success) {
363         //require user to set to zero before resetting to nonzero
364         if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
365             return false;
366         }
367 
368         allowance[_owner][_spender] = _value;
369         return true;
370     }
371 
372     function increaseApproval (address _owner, address _spender, uint _addedValue)
373     onlyController
374     returns (bool success) {
375         uint oldValue = allowance[_owner][_spender];
376         allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
377         return true;
378     }
379 
380     function decreaseApproval (address _owner, address _spender, uint _subtractedValue)
381     onlyController
382     returns (bool success) {
383         uint oldValue = allowance[_owner][_spender];
384         if (_subtractedValue > oldValue) {
385             allowance[_owner][_spender] = 0;
386         } else {
387             allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
388         }
389         return true;
390     }
391 
392     event LogMint(address indexed owner, uint amount);
393     event LogMintingStopped();
394 
395     function mint(address _a, uint _amount) onlyOwner mintingActive {
396         balanceOf[_a] += _amount;
397         totalSupply += _amount;
398         LogMint(_a, _amount);
399     }
400 
401     /*
402     function multiMint(uint[] bits) onlyOwner mintingActive {
403         for (uint i=0; i<bits.length; i++) {
404 	    address a = address(bits[i]>>96);
405 	    uint amount = bits[i]&((1<<96) - 1);
406 	    mint(a, amount);
407         }
408     }
409     */
410 
411     bool public mintingStopped;
412 
413     function stopMinting() onlyOwner {
414         mintingStopped = true;
415         LogMintingStopped();
416     }
417 
418     modifier mintingActive() {
419         if (mintingStopped) throw;
420         _;
421     }
422 
423     function burn(address _owner, uint _amount) onlyController {
424         balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
425         totalSupply = safeSub(totalSupply, _amount);
426     }
427 }