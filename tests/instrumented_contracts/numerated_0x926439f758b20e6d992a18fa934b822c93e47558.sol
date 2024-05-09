1 pragma solidity ^0.4.21;
2 
3 interface Token {
4     function totalSupply() constant external returns (uint256 ts);
5     function balanceOf(address _owner) constant external returns (uint256 balance);
6     function transfer(address _to, uint256 _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
8     function approve(address _spender, uint256 _value) external returns (bool success);
9     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
10     
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract SafeMath {
16     function safeAdd(uint x, uint y)
17         internal
18         pure
19     returns(uint) {
20       uint256 z = x + y;
21       require((z >= x) && (z >= y));
22       return z;
23     }
24 
25     function safeSub(uint x, uint y)
26         internal
27         pure
28     returns(uint) {
29       require(x >= y);
30       uint256 z = x - y;
31       return z;
32     }
33 
34     function safeMul(uint x, uint y)
35         internal
36         pure
37     returns(uint) {
38       uint z = x * y;
39       require((x == 0) || (z / x == y));
40       return z;
41     }
42     
43     function safeDiv(uint x, uint y)
44         internal
45         pure
46     returns(uint) {
47         require(y > 0);
48         return x / y;
49     }
50 
51     function random(uint N, uint salt)
52         internal
53         view
54     returns(uint) {
55       bytes32 hash = keccak256(block.number, msg.sender, salt);
56       return uint(hash) % N;
57     }
58 }
59 
60 contract Authorization {
61     mapping(address => bool) internal authbook;
62     address[] public operators;
63     address public owner;
64     bool public powerStatus = true;
65     function Authorization()
66         public
67         payable
68     {
69         owner = msg.sender;
70         assignOperator(msg.sender);
71     }
72     modifier onlyOwner
73     {
74         assert(msg.sender == owner);
75         _;
76     }
77     modifier onlyOperator
78     {
79         assert(checkOperator(msg.sender));
80         _;
81     }
82     modifier onlyActive
83     {
84         assert(powerStatus);
85         _;
86     }
87     function powerSwitch(
88         bool onOff_
89     )
90         public
91         onlyOperator
92     {
93         powerStatus = onOff_;
94     }
95     function transferOwnership(address newOwner_)
96         onlyOwner
97         public
98     {
99         owner = newOwner_;
100     }
101     
102     function assignOperator(address user_)
103         public
104         onlyOwner
105     {
106         if(user_ != address(0) && !authbook[user_]) {
107             authbook[user_] = true;
108             operators.push(user_);
109         }
110     }
111     
112     function dismissOperator(address user_)
113         public
114         onlyOwner
115     {
116         delete authbook[user_];
117         for(uint i = 0; i < operators.length; i++) {
118             if(operators[i] == user_) {
119                 operators[i] = operators[operators.length - 1];
120                 operators.length -= 1;
121             }
122         }
123     }
124 
125     function checkOperator(address user_)
126         public
127         view
128     returns(bool) {
129         return authbook[user_];
130     }
131 }
132 
133 contract StandardToken is SafeMath {
134     mapping(address => uint256) balances;
135     mapping(address => mapping (address => uint256)) allowed;
136     uint256 public totalSupply;
137 
138     event Transfer(address indexed _from, address indexed _to, uint256 _value);
139     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
140     event Issue(address indexed _to, uint256 indexed _value);
141     event Burn(address indexed _from, uint256 indexed _value);
142 
143     /* constructure */
144     function StandardToken() public payable {}
145 
146     /* Send coins */
147     function transfer(
148         address to_,
149         uint256 amount_
150     )
151         public
152     returns(bool success) {
153         if(balances[msg.sender] >= amount_ && amount_ > 0) {
154             balances[msg.sender] = safeSub(balances[msg.sender], amount_);
155             balances[to_] = safeAdd(balances[to_], amount_);
156             emit Transfer(msg.sender, to_, amount_);
157             return true;
158         } else {
159             return false;
160         }
161     }
162 
163     /* A contract attempts to get the coins */
164     function transferFrom(
165         address from_,
166         address to_,
167         uint256 amount_
168     ) public returns(bool success) {
169         if(balances[from_] >= amount_ && allowed[from_][msg.sender] >= amount_ && amount_ > 0) {
170             balances[to_] = safeAdd(balances[to_], amount_);
171             balances[from_] = safeSub(balances[from_], amount_);
172             allowed[from_][msg.sender] = safeSub(allowed[from_][msg.sender], amount_);
173             emit Transfer(from_, to_, amount_);
174             return true;
175         } else {
176             return false;
177         }
178     }
179 
180     function balanceOf(
181         address _owner
182     )
183         constant
184         public
185     returns (uint256 balance) {
186         return balances[_owner];
187     }
188 
189     /* Allow another contract to spend some tokens in your behalf */
190     function approve(
191         address _spender,
192         uint256 _value
193     )
194         public
195     returns (bool success) {
196         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
197         allowed[msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 
202     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
203         return allowed[_owner][_spender];
204     }
205 }
206 
207 contract XPAAssetToken is StandardToken, Authorization {
208     // metadata
209     address[] public burners;
210     string public name;
211     string public symbol;
212     uint256 public defaultExchangeRate;
213     uint256 public constant decimals = 18;
214 
215     // constructor
216     function XPAAssetToken(
217         string symbol_,
218         string name_,
219         uint256 defaultExchangeRate_
220     )
221         public
222     {
223         totalSupply = 0;
224         symbol = symbol_;
225         name = name_;
226         defaultExchangeRate = defaultExchangeRate_ > 0 ? defaultExchangeRate_ : 0.01 ether;
227     }
228 
229     function transferOwnership(
230         address newOwner_
231     )
232         onlyOwner
233         public
234     {
235         owner = newOwner_;
236     }
237 
238     function create(
239         address user_,
240         uint256 amount_
241     )
242         public
243         onlyOperator
244     returns(bool success) {
245         if(amount_ > 0 && user_ != address(0)) {
246             totalSupply = safeAdd(totalSupply, amount_);
247             balances[user_] = safeAdd(balances[user_], amount_);
248             emit Issue(owner, amount_);
249             emit Transfer(owner, user_, amount_);
250             return true;
251         }
252     }
253 
254     function burn(
255         uint256 amount_
256     )
257         public
258     returns(bool success) {
259         require(allowToBurn(msg.sender));
260         if(amount_ > 0 && balances[msg.sender] >= amount_) {
261             balances[msg.sender] = safeSub(balances[msg.sender], amount_);
262             totalSupply = safeSub(totalSupply, amount_);
263             emit Transfer(msg.sender, owner, amount_);
264             emit Burn(owner, amount_);
265             return true;
266         }
267     }
268 
269     function burnFrom(
270         address user_,
271         uint256 amount_
272     )
273         public
274     returns(bool success) {
275         require(allowToBurn(msg.sender));
276         if(balances[user_] >= amount_ && allowed[user_][msg.sender] >= amount_ && amount_ > 0) {
277             balances[user_] = safeSub(balances[user_], amount_);
278             totalSupply = safeSub(totalSupply, amount_);
279             allowed[user_][msg.sender] = safeSub(allowed[user_][msg.sender], amount_);
280             emit Transfer(user_, owner, amount_);
281             emit Burn(owner, amount_);
282             return true;
283         }
284     }
285 
286     function getDefaultExchangeRate(
287     )
288         public
289         view
290     returns(uint256) {
291         return defaultExchangeRate;
292     }
293 
294     function getSymbol(
295     )
296         public
297         view
298     returns(bytes32) {
299         return keccak256(symbol);
300     }
301 
302     function assignBurner(
303         address account_
304     )
305         public
306         onlyOperator
307     {
308         require(account_ != address(0));
309         for(uint256 i = 0; i < burners.length; i++) {
310             if(burners[i] == account_) {
311                 return;
312             }
313         }
314         burners.push(account_);
315     }
316 
317     function dismissBunner(
318         address account_
319     )
320         public
321         onlyOperator
322     {
323         require(account_ != address(0));
324         for(uint256 i = 0; i < burners.length; i++) {
325             if(burners[i] == account_) {
326                 burners[i] = burners[burners.length - 1];
327                 burners.length -= 1;
328             }
329         }
330     }
331 
332     function allowToBurn(
333         address account_
334     )
335         public
336         view
337     returns(bool) {
338         if(checkOperator(account_)) {
339             return true;
340         }
341         for(uint256 i = 0; i < burners.length; i++) {
342             if(burners[i] == account_) {
343                 return true;
344             }
345         }
346     }
347 }