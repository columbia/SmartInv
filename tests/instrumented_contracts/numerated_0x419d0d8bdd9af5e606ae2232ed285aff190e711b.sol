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
189     // multi-approve, multi-transfer
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
203     // multi functions just issue events, to fix initial event history
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
235     address public token;
236 
237     function setToken(address _token) onlyOwner {
238         token = _token;
239     }
240 
241     function setLedger(address _ledger) onlyOwner {
242         ledger = Ledger(_ledger);
243     }
244 
245     modifier onlyToken() {
246         if (msg.sender != token) throw;
247         _;
248     }
249 
250     function totalSupply() constant returns (uint) {
251         return ledger.totalSupply();
252     }
253 
254     function balanceOf(address _a) onlyToken constant returns (uint) {
255         return Ledger(ledger).balanceOf(_a);
256     }
257 
258     function allowance(address _owner, address _spender)
259     onlyToken constant returns (uint) {
260         return ledger.allowance(_owner, _spender);
261     }
262 
263     function transfer(address _from, address _to, uint _value)
264     onlyToken
265     returns (bool success) {
266         return ledger.transfer(_from, _to, _value);
267     }
268 
269     function transferFrom(address _spender, address _from, address _to, uint _value)
270     onlyToken
271     returns (bool success) {
272         return ledger.transferFrom(_spender, _from, _to, _value);
273     }
274 
275     function approve(address _owner, address _spender, uint _value)
276     onlyToken
277     returns (bool success) {
278         return ledger.approve(_owner, _spender, _value);
279     }
280 
281     function increaseApproval (address _owner, address _spender, uint _addedValue)
282     onlyToken
283     returns (bool success) {
284         return ledger.increaseApproval(_owner, _spender, _addedValue);
285     }
286 
287     function decreaseApproval (address _owner, address _spender, uint _subtractedValue)
288     onlyToken
289     returns (bool success) {
290         return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
291     }
292 
293 
294     function burn(address _owner, uint _amount) onlyToken {
295         ledger.burn(_owner, _amount);
296     }
297 }
298 
299 contract Ledger is Owned, SafeMath, Finalizable {
300     address public controller;
301     mapping(address => uint) public balanceOf;
302     mapping (address => mapping (address => uint)) public allowance;
303     uint public totalSupply;
304 
305     function setController(address _controller) onlyOwner notFinalized {
306         controller = _controller;
307     }
308 
309     modifier onlyController() {
310         if (msg.sender != controller) throw;
311         _;
312     }
313 
314     function transfer(address _from, address _to, uint _value)
315     onlyController
316     returns (bool success) {
317         if (balanceOf[_from] < _value) return false;
318 
319         balanceOf[_from] = safeSub(balanceOf[_from], _value);
320         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
321         return true;
322     }
323 
324     function transferFrom(address _spender, address _from, address _to, uint _value)
325     onlyController
326     returns (bool success) {
327         if (balanceOf[_from] < _value) return false;
328 
329         var allowed = allowance[_from][_spender];
330         if (allowed < _value) return false;
331 
332         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
333         balanceOf[_from] = safeSub(balanceOf[_from], _value);
334         allowance[_from][_spender] = safeSub(allowed, _value);
335         return true;
336     }
337 
338     function approve(address _owner, address _spender, uint _value)
339     onlyController
340     returns (bool success) {
341         //require user to set to zero before resetting to nonzero
342         if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
343             return false;
344         }
345 
346         allowance[_owner][_spender] = _value;
347         return true;
348     }
349 
350     function increaseApproval (address _owner, address _spender, uint _addedValue)
351     onlyController
352     returns (bool success) {
353         uint oldValue = allowance[_owner][_spender];
354         allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
355         return true;
356     }
357 
358     function decreaseApproval (address _owner, address _spender, uint _subtractedValue)
359     onlyController
360     returns (bool success) {
361         uint oldValue = allowance[_owner][_spender];
362         if (_subtractedValue > oldValue) {
363             allowance[_owner][_spender] = 0;
364         } else {
365             allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
366         }
367         return true;
368     }
369 
370     event LogMint(address indexed owner, uint amount);
371     event LogMintingStopped();
372 
373     function mint(address _a, uint _amount) onlyOwner mintingActive {
374         balanceOf[_a] += _amount;
375         totalSupply += _amount;
376         LogMint(_a, _amount);
377     }
378 
379     bool public mintingStopped;
380 
381     function stopMinting() onlyOwner {
382         mintingStopped = true;
383         LogMintingStopped();
384     }
385 
386     modifier mintingActive() {
387         if (mintingStopped) throw;
388         _;
389     }
390 
391     function burn(address _owner, uint _amount) onlyController {
392         balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
393         totalSupply = safeSub(totalSupply, _amount);
394     }
395 }