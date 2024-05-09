1 pragma solidity ^0.4.22;
2 
3 contract ERC20Interface {
4     function totalSupply()
5         public
6         view
7         returns (uint256);
8 
9     function balanceOf(
10         address _address)
11         public
12         view
13         returns (uint256 balance);
14 
15     function allowance(
16         address _address,
17         address _to)
18         public
19         view
20         returns (uint256 remaining);
21 
22     function transfer(
23         address _to,
24         uint256 _value)
25         public
26         returns (bool success);
27 
28     function approve(
29         address _to,
30         uint256 _value)
31         public
32         returns (bool success);
33 
34     function transferFrom(
35         address _from,
36         address _to,
37         uint256 _value)
38         public
39         returns (bool success);
40 
41     event Transfer(
42         address indexed _from,
43         address indexed _to,
44         uint256 _value
45     );
46 
47     event Approval(
48         address indexed _owner,
49         address indexed _spender,
50         uint256 _value
51     );
52 }
53 
54 
55 contract Owned {
56     address owner;
57     address newOwner;
58     uint32 transferCount;
59 
60     event TransferOwnership(
61         address indexed _from,
62         address indexed _to
63     );
64 
65     constructor() public {
66         owner = msg.sender;
67         transferCount = 0;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(
76         address _newOwner)
77         public
78         onlyOwner
79     {
80         newOwner = _newOwner;
81     }
82 
83     function viewOwner()
84         public
85         view
86         returns (address)
87     {
88         return owner;
89     }
90 
91     function viewTransferCount()
92         public
93         view
94         onlyOwner
95         returns (uint32)
96     {
97         return transferCount;
98     }
99 
100     function isTransferPending()
101         public
102         view
103         returns (bool) {
104         require(
105             msg.sender == owner ||
106             msg.sender == newOwner);
107         return newOwner != address(0);
108     }
109 
110     function acceptOwnership()
111          public
112     {
113         require(msg.sender == newOwner);
114 
115         owner = newOwner;
116         newOwner = address(0);
117         transferCount++;
118 
119         emit TransferOwnership(
120             owner,
121             newOwner
122         );
123     }
124 }
125 
126 library SafeMath {
127     function add(
128         uint256 a,
129         uint256 b)
130         internal
131         pure
132         returns(uint256 c)
133     {
134         c = a + b;
135         require(c >= a);
136     }
137 
138     function sub(
139         uint256 a,
140         uint256 b)
141         internal
142         pure
143         returns(uint256 c)
144     {
145         require(b <= a);
146         c = a - b;
147     }
148 
149     function mul(
150         uint256 a,
151         uint256 b)
152         internal
153         pure
154         returns(uint256 c) {
155         c = a * b;
156         require(a == 0 || c / a == b);
157     }
158 
159     function div(
160         uint256 a,
161         uint256 b)
162         internal
163         pure
164         returns(uint256 c) {
165         require(b > 0);
166         c = a / b;
167     }
168 }
169 
170 contract ApproveAndCallFallBack {
171     function receiveApproval(
172         address _from,
173         uint256 _value,
174         address token,
175         bytes data)
176         public
177         returns (bool success);
178 }
179 
180 
181 contract Pausable is Owned {
182   event Pause();
183   event Unpause();
184 
185   bool public paused = false;
186 
187   modifier whenNotPaused() {
188     require(!paused);
189     _;
190   }
191 
192   modifier whenPaused() {
193     require(paused);
194     _;
195   }
196 
197   function pause() onlyOwner whenNotPaused public {
198     paused = true;
199     emit Pause();
200   }
201 
202   function unpause() onlyOwner whenPaused public {
203     paused = false;
204     emit Unpause();
205   }
206 }
207 
208 contract Token is ERC20Interface, Owned, Pausable {
209     using SafeMath for uint256;
210 
211     string public symbol;
212     string public name;
213     uint8 public decimals;
214     uint256 public totalSupply;
215 
216     mapping(address => uint256) balances;
217     mapping(address => mapping(address => uint256)) allowed;
218     mapping(address => uint256) incomes;
219     mapping(address => uint256) expenses;
220     mapping(address => bool) frozenAccount;
221 
222     event FreezeAccount(address _address, bool frozen);
223 
224     constructor(
225         uint256 _totalSupply,
226         string _name,
227         string _symbol,
228         uint8 _decimals)
229         public
230     {
231         symbol = _symbol;
232         name = _name;
233         decimals = _decimals;
234         totalSupply = _totalSupply * 10**uint256(_decimals);
235         balances[owner] = totalSupply;
236 
237         emit Transfer(address(0), owner, totalSupply);
238     }
239 
240     function totalSupply()
241         public
242         view
243         returns (uint256)
244     {
245         return totalSupply;
246     }
247 
248     function _transfer(
249         address _from,
250         address _to,
251         uint256 _value)
252         internal
253         returns (bool success)
254     {
255         require (_to != 0x0);
256         require (balances[_from] >= _value);
257         require(!frozenAccount[_from]);
258         require(!frozenAccount[_to]);
259 
260         balances[_from] = balances[_from].sub(_value);
261         balances[_to] = balances[_to].add(_value);
262 
263         incomes[_to] = incomes[_to].add(_value);
264         expenses[_from] = expenses[_from].add(_value);
265 
266         emit Transfer(_from, _to, _value);
267 
268         return true;
269     }
270 
271     function transfer(
272         address _to,
273         uint256 _value)
274         public
275         whenNotPaused
276         returns (bool success)
277     {
278         return _transfer(msg.sender, _to, _value);
279     }
280 
281     function approve(
282         address _spender,
283         uint256 _value)
284         public
285         whenNotPaused
286         returns (bool success)
287     {
288         require (_spender != 0x0);
289         require(!frozenAccount[msg.sender]);
290         require(!frozenAccount[_spender]);
291 
292         allowed[msg.sender][_spender] = _value;
293 
294         emit Approval(msg.sender, _spender, _value);
295 
296         return true;
297     }
298 
299     function transferFrom(
300         address _from,
301         address _to,
302         uint256 _value)
303         public
304         whenNotPaused
305         returns (bool success)
306     {
307         require(!frozenAccount[msg.sender]);
308         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
309         return _transfer(_from, _to, _value);
310     }
311 
312     function balanceOf(
313         address _address)
314         public
315         view
316         returns (uint256 remaining)
317     {
318         require(_address != 0x0);
319 
320         return balances[_address];
321     }
322 
323     function incomeOf(
324         address _address)
325         public
326         view
327         returns (uint256 income)
328     {
329         require(_address != 0x0);
330 
331         return incomes[_address];
332     }
333 
334     function expenseOf(
335         address _address)
336         public
337         view
338         returns (uint256 expense)
339     {
340         require(_address != 0x0);
341 
342         return expenses[_address];
343     }
344 
345     function allowance(
346         address _owner,
347         address _spender)
348         public
349         view
350         returns (uint256 remaining)
351     {
352         require(_owner != 0x0);
353         require(_spender != 0x0);
354         require(_owner == msg.sender || _spender == msg.sender);
355 
356         return allowed[_owner][_spender];
357     }
358 
359     function approveAndCall(
360         address _spender,
361         uint256 _value,
362         bytes _data)
363         public
364         whenNotPaused
365         returns (bool success)
366     {
367         if (approve(_spender, _value)) {
368             require(ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, _data) == true);
369             return true;
370         }
371         return false;
372     }
373 
374     function freezeAccount(
375         address _address,
376         bool freeze)
377         public
378         onlyOwner
379         returns (bool success)
380     {
381         frozenAccount[_address] = freeze;
382         emit FreezeAccount(_address, freeze);
383         return true;
384     }
385 
386     function isFrozenAccount(
387         address _address)
388         public
389         view
390         returns (bool frozen)
391     {
392         require(_address != 0x0);
393         return frozenAccount[_address];
394     }
395 
396     function () public payable {
397         revert();
398     }
399 }