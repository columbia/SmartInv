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
98     function setController(address _c) onlyOwner notFinalized {
99         controller = Controller(_c);
100     }
101 
102     function balanceOf(address a) constant returns (uint) {
103         return controller.balanceOf(a);
104     }
105 
106     function totalSupply() constant returns (uint) {
107         return controller.totalSupply();
108     }
109 
110     function allowance(address _owner, address _spender) constant returns (uint) {
111         return controller.allowance(_owner, _spender);
112     }
113 
114     function transfer(address _to, uint _value)
115     onlyPayloadSize(2)
116     returns (bool success) {
117        success = controller.transfer(msg.sender, _to, _value);
118         if (success) {
119             Transfer(msg.sender, _to, _value);
120         }
121     }
122 
123     function transferFrom(address _from, address _to, uint _value)
124     onlyPayloadSize(3)
125     returns (bool success) {
126        success = controller.transferFrom(msg.sender, _from, _to, _value);
127         if (success) {
128             Transfer(_from, _to, _value);
129         }
130     }
131 
132     function approve(address _spender, uint _value)
133     onlyPayloadSize(2)
134     returns (bool success) {
135         //promote safe user behavior
136         if (controller.allowance(msg.sender, _spender) > 0) throw;
137 
138         success = controller.approve(msg.sender, _spender, _value);
139         if (success) {
140             Approval(msg.sender, _spender, _value);
141         }
142     }
143 
144     function increaseApproval (address _spender, uint _addedValue)
145     onlyPayloadSize(2)
146     returns (bool success) {
147         success = controller.increaseApproval(msg.sender, _spender, _addedValue);
148         if (success) {
149             uint newval = controller.allowance(msg.sender, _spender);
150             Approval(msg.sender, _spender, newval);
151         }
152     }
153 
154     function decreaseApproval (address _spender, uint _subtractedValue)
155     onlyPayloadSize(2)
156     returns (bool success) {
157         success = controller.decreaseApproval(msg.sender, _spender, _subtractedValue);
158         if (success) {
159             uint newval = controller.allowance(msg.sender, _spender);
160             Approval(msg.sender, _spender, newval);
161         }
162     }
163 
164     modifier onlyPayloadSize(uint numwords) {
165     assert(msg.data.length == numwords * 32 + 4);
166         _;
167     }
168 
169     function burn(uint _amount) {
170         controller.burn(msg.sender, _amount);
171         Transfer(msg.sender, 0x0, _amount);
172     }
173 }
174 
175 contract Controller is Owned, Finalizable {
176     Ledger public ledger;
177     address public token;
178 
179     function setToken(address _token) onlyOwner {
180         token = _token;
181     }
182 
183     function setLedger(address _ledger) onlyOwner {
184         ledger = Ledger(_ledger);
185     }
186 
187     modifier onlyToken() {
188         if (msg.sender != token) throw;
189         _;
190     }
191 
192     function totalSupply() constant returns (uint) {
193         return ledger.totalSupply();
194     }
195 
196     function balanceOf(address _a) onlyToken constant returns (uint) {
197         return Ledger(ledger).balanceOf(_a);
198     }
199 
200     function allowance(address _owner, address _spender)
201     onlyToken constant returns (uint) {
202         return ledger.allowance(_owner, _spender);
203     }
204 
205     function transfer(address _from, address _to, uint _value)
206     onlyToken
207     returns (bool success) {
208         return ledger.transfer(_from, _to, _value);
209     }
210 
211     function transferFrom(address _spender, address _from, address _to, uint _value)
212     onlyToken
213     returns (bool success) {
214         return ledger.transferFrom(_spender, _from, _to, _value);
215     }
216 
217     function approve(address _owner, address _spender, uint _value)
218     onlyToken
219     returns (bool success) {
220         return ledger.approve(_owner, _spender, _value);
221     }
222 
223     function increaseApproval (address _owner, address _spender, uint _addedValue)
224     onlyToken
225     returns (bool success) {
226         return ledger.increaseApproval(_owner, _spender, _addedValue);
227     }
228 
229     function decreaseApproval (address _owner, address _spender, uint _subtractedValue)
230     onlyToken
231     returns (bool success) {
232         return ledger.decreaseApproval(_owner, _spender, _subtractedValue);
233     }
234 
235 
236     function burn(address _owner, uint _amount) onlyToken {
237         ledger.burn(_owner, _amount);
238     }
239 }
240 
241 contract Ledger is Owned, SafeMath, Finalizable {
242     address public controller;
243     mapping(address => uint) public balanceOf;
244     mapping (address => mapping (address => uint)) public allowance;
245     uint public totalSupply;
246 
247     function setController(address _controller) onlyOwner notFinalized {
248         controller = _controller;
249     }
250 
251     modifier onlyController() {
252         if (msg.sender != controller) throw;
253         _;
254     }
255 
256     function transfer(address _from, address _to, uint _value)
257     onlyController
258     returns (bool success) {
259         if (balanceOf[_from] < _value) return false;
260 
261         balanceOf[_from] = safeSub(balanceOf[_from], _value);
262         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
263         return true;
264     }
265 
266     function transferFrom(address _spender, address _from, address _to, uint _value)
267     onlyController
268     returns (bool success) {
269         if (balanceOf[_from] < _value) return false;
270 
271         var allowed = allowance[_from][_spender];
272         if (allowed < _value) return false;
273 
274         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
275         balanceOf[_from] = safeSub(balanceOf[_from], _value);
276         allowance[_from][_spender] = safeSub(allowed, _value);
277         return true;
278     }
279 
280     function approve(address _owner, address _spender, uint _value)
281     onlyController
282     returns (bool success) {
283         //require user to set to zero before resetting to nonzero
284         if ((_value != 0) && (allowance[_owner][_spender] != 0)) {
285             return false;
286         }
287 
288         allowance[_owner][_spender] = _value;
289         return true;
290     }
291 
292     function increaseApproval (address _owner, address _spender, uint _addedValue)
293     onlyController
294     returns (bool success) {
295         uint oldValue = allowance[_owner][_spender];
296         allowance[_owner][_spender] = safeAdd(oldValue, _addedValue);
297         return true;
298     }
299 
300     function decreaseApproval (address _owner, address _spender, uint _subtractedValue)
301     onlyController
302     returns (bool success) {
303         uint oldValue = allowance[_owner][_spender];
304         if (_subtractedValue > oldValue) {
305             allowance[_owner][_spender] = 0;
306         } else {
307             allowance[_owner][_spender] = safeSub(oldValue, _subtractedValue);
308         }
309         return true;
310     }
311 
312     event LogMint(address indexed owner, uint amount);
313     event LogMintingStopped();
314 
315     function mint(address _a, uint _amount) onlyOwner mintingActive {
316         balanceOf[_a] += _amount;
317         totalSupply += _amount;
318         LogMint(_a, _amount);
319     }
320 
321     function multiMint(uint[] bits) onlyOwner mintingActive {
322         for (uint i=0; i<bits.length; i++) {
323 	    address a = address(bits[i]>>96);
324 	    uint amount = bits[i]&((1<<96) - 1);
325 	    mint(a, amount);
326         }
327     }
328 
329     bool public mintingStopped;
330 
331     function stopMinting() onlyOwner {
332         mintingStopped = true;
333         LogMintingStopped();
334     }
335 
336     modifier mintingActive() {
337         if (mintingStopped) throw;
338         _;
339     }
340 
341     function burn(address _owner, uint _amount) onlyController {
342         balanceOf[_owner] = safeSub(balanceOf[_owner], _amount);
343         totalSupply = safeSub(totalSupply, _amount);
344     }
345 }