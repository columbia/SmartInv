1 pragma solidity ^0.5;
2 
3 contract ERC20xVariables {
4     address public creator;
5     address public lib;
6 
7     uint256 constant public MAX_UINT256 = 2**256 - 1;
8     mapping(address => uint) public balances;
9     mapping(address => mapping(address => uint)) public allowed;
10 
11     uint8 public constant decimals = 18;
12     string public name;
13     string public symbol;
14     uint public totalSupply;
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 
19     event Created(address creator, uint supply);
20 
21     function balanceOf(address _owner) public view returns (uint256 balance) {
22         return balances[_owner];
23     }
24 
25     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
26         return allowed[_owner][_spender];
27     }
28 }
29 
30 contract ERC20x is ERC20xVariables {
31 
32     function transfer(address _to, uint256 _value) public returns (bool success) {
33         _transferBalance(msg.sender, _to, _value);
34         emit Transfer(msg.sender, _to, _value);
35         return true;
36     }
37 
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
39         uint256 allowance = allowed[_from][msg.sender];
40         require(allowance >= _value);
41         _transferBalance(_from, _to, _value);
42         if (allowance < MAX_UINT256) {
43             allowed[_from][msg.sender] -= _value;
44         }
45         emit Transfer(_from, _to, _value);
46         return true;
47     }
48 
49     function approve(address _spender, uint256 _value) public returns (bool success) {
50         allowed[msg.sender][_spender] = _value;
51         emit Approval(msg.sender, _spender, _value);
52         return true;
53     }
54 
55     function transferToContract(address _to, uint256 _value, bytes memory data) public returns (bool) {
56         _transferBalance(msg.sender, _to, _value);
57         bytes4 sig = bytes4(keccak256("receiveTokens(address,uint256,bytes)"));
58         (bool result,) = _to.call(abi.encodePacked(sig, msg.sender, _value, data));
59         require(result);
60         emit Transfer(msg.sender, _to, _value);
61         return true;
62     }
63 
64     function _transferBalance(address _from, address _to, uint _value) internal {
65         require(balances[_from] >= _value);
66         balances[_from] -= _value;
67         balances[_to] += _value;
68     }
69 }
70 
71 contract BidderInterface {
72     function receiveETH(address series, uint256 amount) public;
73     function receiveUSD(address series, uint256 amount) public;
74 }
75 
76 contract VariableSupplyToken is ERC20x {
77     function grant(address to, uint256 amount) public returns (bool) {
78         require(msg.sender == creator);
79         require(balances[to] + amount >= amount);
80         balances[to] += amount;
81         totalSupply += amount;
82         return true;
83     }
84 
85     function burn(address from, uint amount) public returns (bool) {
86         require(msg.sender == creator);
87         require(balances[from] >= amount);
88         balances[from] -= amount;
89         totalSupply -= amount;
90         return true;
91     }
92 }
93 
94 contract OptionToken is VariableSupplyToken {
95     constructor(string memory _name, string memory _symbol) public {
96         creator = msg.sender;
97         name = _name;
98         symbol = _symbol;
99     }
100 }
101 
102 contract Protocol {
103     
104     address public lib;
105     ERC20x public usdERC20;
106     ERC20x public protocolToken;
107 
108     // We use "flavor" because type is a reserved word in many programming languages
109     enum Flavor {
110         Call,
111         Put
112     }
113 
114     struct OptionSeries {
115         uint expiration;
116         Flavor flavor;
117         uint strike;
118     }
119 
120     uint public constant DURATION = 12 hours;
121     uint public constant HALF_DURATION = DURATION / 2;
122 
123     mapping(address => uint) public openInterest;
124     mapping(address => uint) public earlyExercised;
125     mapping(address => uint) public totalInterest;
126     mapping(address => mapping(address => uint)) public writers;
127     mapping(address => OptionSeries) public seriesInfo;
128     mapping(address => uint) public holdersSettlement;
129 
130     mapping(address => uint) public expectValue;
131     bool isAuction;
132 
133     uint public constant ONE_MILLION = 1000000;
134 
135     // maximum token holder rights capped at 3.7% of total supply?
136     // Why 3.7%?
137     // I could make up some fancy explanation
138     // and use the phrase "byzantine fault tolerance" somehow
139     // Or I could just say that 3.7% allows for a total of 27 independent actors
140     // that are all receiving the maximum benefit, and it solves all the other
141     // issues of disincentivizing centralization and "rich get richer" mechanics, so I chose 27 'cause it just has a nice "decentralized" feel to it.
142     // 21 would have been fine, as few as ten probably would have been ok 'cause people can just pool anyways
143     // up to a thousand or so probably wouldn't have hurt either.
144     // In the end it really doesn't matter as long as the game ends up being played fairly.
145 
146     // I'm sure someone will take my system and parameterize it differently at some point and bill it as a totally new product.
147     uint public constant PREFERENCE_MAX = 0.037 ether;
148 
149     constructor(address _token, address _usd) public {
150         lib = address(new VariableSupplyToken());
151         protocolToken = ERC20x(_token);
152         usdERC20 = ERC20x(_usd);
153     }
154 
155     function() external payable {
156         revert();
157     }
158 
159     event SeriesIssued(address series);
160 
161     function issue(string memory name, string memory symbol, uint expiration, Flavor flavor, uint strike) public returns (address) {
162         address series = address(new OptionToken(name, symbol));
163         seriesInfo[series] = OptionSeries(expiration, flavor, strike);
164         emit SeriesIssued(series);
165         return series;
166     }
167 
168     function open(address _series, uint amount) public payable returns (bool) {
169         OptionSeries memory series = seriesInfo[_series];
170         require(now < series.expiration);
171 
172         VariableSupplyToken(_series).grant(msg.sender, amount);
173 
174         if (series.flavor == Flavor.Call) {
175             require(msg.value == amount);
176         } else {
177             require(msg.value == 0);
178             uint escrow = amount * series.strike;
179             require(escrow / amount == series.strike);
180             escrow /= 1 ether;
181             require(usdERC20.transferFrom(msg.sender, address(this), escrow));
182         }
183         
184         openInterest[_series] += amount;
185         totalInterest[_series] += amount;
186         writers[_series][msg.sender] += amount;
187 
188         return true;
189     }
190 
191     function close(address _series, uint amount) public returns (bool) {
192         OptionSeries memory series = seriesInfo[_series];
193 
194         require(now < series.expiration);
195         require(openInterest[_series] >= amount);
196         VariableSupplyToken(_series).burn(msg.sender, amount);
197 
198         require(writers[_series][msg.sender] >= amount);
199         writers[_series][msg.sender] -= amount;
200         openInterest[_series] -= amount;
201         totalInterest[_series] -= amount;
202         
203         if (series.flavor == Flavor.Call) {
204             msg.sender.transfer(amount);
205         } else {
206             usdERC20.transfer(msg.sender, amount * series.strike / 1 ether);
207         }
208         return true;
209     }
210     
211     function exercise(address _series, uint amount) public payable {
212         OptionSeries memory series = seriesInfo[_series];
213 
214         require(now < series.expiration);
215         require(openInterest[_series] >= amount);
216         VariableSupplyToken(_series).burn(msg.sender, amount);
217 
218         uint usd = amount * series.strike;
219         require(usd / amount == series.strike);
220         usd /= 1 ether;
221 
222         openInterest[_series] -= amount;
223         earlyExercised[_series] += amount;
224 
225         if (series.flavor == Flavor.Call) {
226             msg.sender.transfer(amount);
227             require(msg.value == 0);
228             usdERC20.transferFrom(msg.sender, address(this), usd);
229         } else {
230             require(msg.value == amount);
231             usdERC20.transfer(msg.sender, usd);
232         }
233     }
234     
235     function receive() public payable returns (bool) {
236         require(expectValue[msg.sender] == msg.value);
237         expectValue[msg.sender] = 0;
238         return true;
239     }
240 
241     function bid(address _series, uint amount) public payable returns (bool) {
242 
243         require(isAuction == false);
244         isAuction = true;
245 
246         OptionSeries memory series = seriesInfo[_series];
247 
248         uint start = series.expiration;
249         uint time = now + _timePreference(msg.sender);
250 
251         require(time > start);
252         require(time < start + DURATION);
253 
254         uint elapsed = time - start;
255 
256         amount = _min(amount, openInterest[_series]);
257 
258         openInterest[_series] -= amount;
259 
260         uint offer;
261         uint givGet;
262         
263         BidderInterface bidder = BidderInterface(msg.sender);
264 
265         if (series.flavor == Flavor.Call) {
266             require(msg.value == 0);
267 
268             offer = (series.strike * DURATION) / elapsed;
269             givGet = offer * amount / 1 ether;
270             holdersSettlement[_series] += givGet - amount * series.strike / 1 ether;
271 
272             bool hasFunds = usdERC20.balanceOf(msg.sender) >= givGet && usdERC20.allowance(msg.sender, address(this)) >= givGet;
273 
274             if (hasFunds) {
275                 msg.sender.transfer(amount);
276             } else {
277                 bidder.receiveETH(_series, amount);
278             }
279 
280             require(usdERC20.transferFrom(msg.sender, address(this), givGet));
281         } else {
282             offer = (DURATION * 1 ether * 1 ether) / (series.strike * elapsed);
283             givGet = (amount * 1 ether) / offer;
284 
285             holdersSettlement[_series] += amount * series.strike / 1 ether - givGet;
286             usdERC20.transfer(msg.sender, givGet);
287 
288             if (msg.value == 0) {
289                 require(expectValue[msg.sender] == 0);
290                 expectValue[msg.sender] = amount;
291                 
292                 bidder.receiveUSD(_series, givGet);
293                 require(expectValue[msg.sender] == 0);
294             } else {
295                 require(msg.value >= amount);
296                 msg.sender.transfer(msg.value - amount);
297             }
298         }
299 
300         isAuction = false;
301         return true;
302     }
303 
304     function redeem(address _series) public returns (bool) {
305         OptionSeries memory series = seriesInfo[_series];
306 
307         require(now > series.expiration + DURATION);
308 
309         uint unsettledPercent = openInterest[_series] * 1 ether / totalInterest[_series];
310         uint exercisedPercent = (totalInterest[_series] - openInterest[_series]) * 1 ether / totalInterest[_series];
311         uint owed;
312 
313         if (series.flavor == Flavor.Call) {
314             owed = writers[_series][msg.sender] * unsettledPercent / 1 ether;
315             if (owed > 0) {
316                 msg.sender.transfer(owed);
317             }
318 
319             owed = writers[_series][msg.sender] * exercisedPercent / 1 ether;
320             owed = owed * series.strike / 1 ether;
321             if (owed > 0) {
322                 usdERC20.transfer(msg.sender, owed);
323             }
324         } else {
325             owed = writers[_series][msg.sender] * unsettledPercent / 1 ether;
326             owed = owed * series.strike / 1 ether;
327             if (owed > 0) {
328                 usdERC20.transfer(msg.sender, owed);
329             }
330 
331             owed = writers[_series][msg.sender] * exercisedPercent / 1 ether;
332             if (owed > 0) {
333                 msg.sender.transfer(owed);
334             }
335         }
336 
337         writers[_series][msg.sender] = 0;
338         return true;
339     }
340 
341     function settle(address _series) public returns (bool) {
342         OptionSeries memory series = seriesInfo[_series];
343         require(now > series.expiration + DURATION);
344 
345         uint bal = ERC20x(_series).balanceOf(msg.sender);
346         VariableSupplyToken(_series).burn(msg.sender, bal);
347 
348         uint percent = bal * 1 ether / (totalInterest[_series] - earlyExercised[_series]);
349         uint owed = holdersSettlement[_series] * percent / 1 ether;
350         usdERC20.transfer(msg.sender, owed);
351         return true;
352     }
353 
354     function _timePreference(address from) public view returns (uint) {
355         return (_unsLn(_preference(from) * 1000000 + 1 ether) * 171) / 1 ether;
356     }
357 
358     function _preference(address from) public view returns (uint) {
359         return _min(
360             protocolToken.balanceOf(from) * 1 ether / protocolToken.totalSupply(),
361             PREFERENCE_MAX
362         );
363     }
364 
365     function _min(uint a, uint b) pure public returns (uint) {
366         if (a > b)
367             return b;
368         return a;
369     }
370 
371     function _max(uint a, uint b) pure public returns (uint) {
372         if (a > b)
373             return a;
374         return b;
375     }
376     
377     function _unsLn(uint x) pure public returns (uint log) {
378         log = 0;
379         
380         // not a true ln function, we can't represent the negatives
381         if (x < 1 ether)
382             return 0;
383 
384         while (x >= 1.5 ether) {
385             log += 0.405465 ether;
386             x = x * 2 / 3;
387         }
388         
389         x = x - 1 ether;
390         uint y = x;
391         uint i = 1;
392 
393         while (i < 10) {
394             log += (y / i);
395             i = i + 1;
396             y = y * x / 1 ether;
397             log -= (y / i);
398             i = i + 1;
399             y = y * x / 1 ether;
400         }
401          
402         return(log);
403     }
404 }