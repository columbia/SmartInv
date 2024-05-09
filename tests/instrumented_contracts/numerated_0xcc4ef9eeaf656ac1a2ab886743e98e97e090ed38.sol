1 pragma solidity ^0.4.11;
2 
3 
4 /*
5  * Ownable
6  *
7  * Base contract with an owner.
8  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
9  */
10 contract Ownable {
11   address public owner;
12 
13   function Ownable() {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     if (msg.sender != owner) {
19       throw;
20     }
21     _;
22   }
23 
24   function transferOwnership(address newOwner) onlyOwner {
25     if (newOwner != address(0)) {
26       owner = newOwner;
27     }
28   }
29 
30 }
31 
32 /* taking ideas from FirstBlood token */
33 contract SafeMath {
34 
35     /* function assert(bool assertion) internal { */
36     /*   if (!assertion) { */
37     /*     throw; */
38     /*   } */
39     /* }      // assert no longer needed once solidity is on 0.4.10 */
40 
41     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
42       uint256 z = x + y;
43       assert((z >= x) && (z >= y));
44       return z;
45     }
46 
47     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
48       assert(x >= y);
49       uint256 z = x - y;
50       return z;
51     }
52 
53     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
54       uint256 z = x * y;
55       assert((x == 0)||(z/x == y));
56       return z;
57     }
58 
59 }
60 
61 contract Token {
62     uint256 public totalSupply;
63     function balanceOf(address _owner) constant returns (uint256 balance);
64     function transfer(address _to, uint256 _value) returns (bool success);
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
66     function approve(address _spender, uint256 _value) returns (bool success);
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 }
71 
72 
73 /*  ERC 20 token */
74 contract StandardToken is Token {
75 
76   modifier onlyPayloadSize(uint size) {
77      if(msg.data.length < size + 4) {
78        throw;
79      }
80      _;
81   }
82 
83 
84     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
85       if (balances[msg.sender] >= _value && _value > 0) {
86         balances[msg.sender] -= _value;
87         balances[_to] += _value;
88         Transfer(msg.sender, _to, _value);
89         return true;
90       } else {
91         return false;
92       }
93     }
94 
95     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
96       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
97         balances[_to] += _value;
98         balances[_from] -= _value;
99         allowed[_from][msg.sender] -= _value;
100         Transfer(_from, _to, _value);
101         return true;
102       } else {
103         return false;
104       }
105     }
106 
107     function balanceOf(address _owner) constant returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     function approve(address _spender, uint256 _value) returns (bool success) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
118       return allowed[_owner][_spender];
119     }
120 
121     mapping (address => uint256) balances;
122     mapping (address => mapping (address => uint256)) allowed;
123 }
124 
125 contract splitterContract is Ownable{
126 
127     event ev(string msg, address whom, uint256 val);
128 
129     struct xRec {
130         bool inList;
131         address next;
132         address prev;
133         uint256 val;
134     }
135 
136     struct l8r {
137         address whom;
138         uint256 val;
139     }
140     address public myAddress = this;
141     address public first;
142     address public last;
143     address public ddf;
144     bool    public thinkMode;
145     uint256 public pos;
146 
147     mapping (address => xRec) public theList;
148 
149     l8r[]  afterParty;
150 
151     modifier onlyMeOrDDF() {
152         if (msg.sender == ddf || msg.sender == myAddress || msg.sender == owner) {
153             _;
154             return;
155         }
156     }
157 
158     function setDDF(address ddf_) onlyOwner {
159         ddf = ddf_;
160     }
161 
162     function splitterContract(address seed, uint256 seedVal) {
163         first = seed;
164         last = seed;
165         theList[seed] = xRec(true,0x0,0x0,seedVal);
166     }
167 
168     function startThinking() onlyOwner {
169         thinkMode = true;
170         pos = 0;
171     }
172 
173     function stopThinking(uint256 num) onlyOwner {
174         thinkMode = false;
175         for (uint256 i = 0; i < num; i++) {
176             if (pos >= afterParty.length) {
177                 delete afterParty;
178                 return;
179             }
180             update(afterParty[pos].whom,afterParty[pos].val);
181             pos++;
182         }
183         thinkMode = true;
184     } 
185 
186     function thinkLength() constant returns (uint256) {
187         return afterParty.length;
188     }
189 
190     function addRec4L8R(address whom, uint256 val) internal {
191         afterParty.push(l8r(whom,val));
192     }
193 
194     function add(address whom, uint256 value) internal {
195         theList[whom] = xRec(true,0x0,last,value);
196         theList[last].next = whom;
197         last = whom;
198         ev("add",whom,value);
199     }
200 
201     function remove(address whom) internal {
202         if (first == whom) {
203             first = theList[whom].next;
204             theList[whom] = xRec(false,0x0,0x0,0);
205             return;
206         }
207         address next = theList[whom].next;
208         address prev = theList[whom].prev;
209         if (prev != 0x0) {
210             theList[prev].next = next;
211         }
212         if (next != 0x0) {
213             theList[next].prev = prev;
214         }
215         theList[whom] = xRec(false,0x0,0x0,0);
216         ev("remove",whom,0);
217     }
218 
219     function update(address whom, uint256 value) onlyMeOrDDF {
220         if (thinkMode) {
221             addRec4L8R(whom,value);
222             return;
223         }
224         if (value != 0) {
225             if (!theList[whom].inList) {
226                 add(whom,value);
227             } else {
228                 theList[whom].val = value;
229                 ev("update",whom,value);
230             }
231             return;
232         }
233         if (theList[whom].inList) {
234                 remove(whom);
235         }
236     }
237 
238 }
239 
240 
241 
242 contract DDFToken is StandardToken, SafeMath {
243 
244     // metadata
245     string public constant name = "Digital Developers Fund Token";
246     string public constant symbol = "DDF";
247     uint256 public constant decimals = 18;
248     string public version = "1.0";
249 
250     // contracts
251     address public ethFundDeposit;      // deposit address for ETH for Domain Development Fund
252     address public ddftFundDeposit;     // deposit address for Domain Development Fund reserve
253     address public splitter;          // DA 8/6/2017 - splitter contract
254 
255     // crowdsale parameters
256     bool public isFinalized;              // switched to true in operational state
257     uint256 public fundingStartTime;
258     uint256 public fundingEndTime;
259     uint256 public constant ddftFund = 25 * (10**5) * 10**decimals;   // 1m DDFT reserved for DDF use
260     uint256 public constant tokenExchangeRate = 1000;               // 1000 DDFT tokens per 1 ETH
261     uint256 public constant tokenCreationCap =  250 * (10**6) * 10**decimals;
262     uint256 public constant tokenCreationMin =  1 * (10**6) * 10**decimals;
263 
264 
265     // events
266     event LogRefund(address indexed _to, uint256 _value);
267     event CreateDDFT(address indexed _to, uint256 _value);
268 
269     // constructor
270     function DDFToken(
271         address _ethFundDeposit,
272         address _ddftFundDeposit,
273         address _splitter, // DA 8/6/2017
274         uint256 _fundingStartTime,
275         uint256 duration)
276     {
277       isFinalized = false;                   //controls pre through crowdsale state
278       ethFundDeposit = _ethFundDeposit;
279       ddftFundDeposit = _ddftFundDeposit;
280       splitter =  _splitter ;                  // DA 8/6/2017
281       fundingStartTime = _fundingStartTime;
282       fundingEndTime = fundingStartTime + duration * 1 days;
283       totalSupply = ddftFund;
284       balances[ddftFundDeposit] = ddftFund;    // Deposit DDF share
285       CreateDDFT(ddftFundDeposit, ddftFund);  // logs DDF fund
286     }
287 
288     function () payable {           // DA 8/6/2017 prefer to use fallback function
289       createTokens(msg.value);
290     }
291 
292     /// @dev Accepts ether and creates new DDFT tokens.
293     function createTokens(uint256 _value)  internal {
294       if (isFinalized) throw;
295       if (now < fundingStartTime) throw;
296       if (now > fundingEndTime) throw;
297       if (msg.value == 0) throw;
298 
299       uint256 tokens = safeMult(_value, tokenExchangeRate); // check that we're not over totals
300       uint256 checkedSupply = safeAdd(totalSupply, tokens);
301 
302       // DA 8/6/2017 to fairly allocate the last few tokens
303       if (tokenCreationCap < checkedSupply) {
304         if (tokenCreationCap <= totalSupply) throw;  // CAP reached no more please
305         uint256 tokensToAllocate = safeSubtract(tokenCreationCap,totalSupply);
306         uint256 tokensToRefund   = safeSubtract(tokens,tokensToAllocate);
307         totalSupply = tokenCreationCap;
308         balances[msg.sender] += tokensToAllocate;  // safeAdd not needed; bad semantics to use here
309         uint256 etherToRefund = tokensToRefund / tokenExchangeRate;
310         msg.sender.transfer(etherToRefund);
311         CreateDDFT(msg.sender, tokensToAllocate);  // logs token creation
312         LogRefund(msg.sender,etherToRefund);
313         splitterContract(splitter).update(msg.sender,balances[msg.sender]);
314         return;
315       }
316       // DA 8/6/2017 end of fair allocation code
317       totalSupply = checkedSupply;
318       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
319       CreateDDFT(msg.sender, tokens);  // logs token creation
320       splitterContract(splitter).update(msg.sender,balances[msg.sender]);
321     }
322 
323     /// @dev Ends the funding period and sends the ETH home
324     function finalize() external {
325       if (isFinalized) throw;
326       if (msg.sender != ethFundDeposit) throw; // locks finalize to the ultimate ETH owner
327       if(totalSupply < tokenCreationMin + ddftFund) throw;      // have to sell minimum to move to operational
328       if(now <= fundingEndTime && totalSupply != tokenCreationCap) throw;
329       // move to operational
330       isFinalized = true;
331       // DA 8/6/2017 change send/throw to transfer
332       ethFundDeposit.transfer(this.balance);  // send the eth to DDF
333     }
334 
335     /// @dev Allows contributors to recover their ether in the case of a failed funding campaign.
336     function refund() external {
337       if(isFinalized) throw;                       // prevents refund if operational
338       if (now <= fundingEndTime) throw; // prevents refund until sale period is over
339       if(totalSupply >= tokenCreationMin + ddftFund) throw;  // no refunds if we sold enough
340       if(msg.sender == ddftFundDeposit) throw;    // DDF not entitled to a refund
341       uint256 ddftVal = balances[msg.sender];
342       if (ddftVal == 0) throw;
343       balances[msg.sender] = 0;
344       totalSupply = safeSubtract(totalSupply, ddftVal); // extra safe
345       uint256 ethVal = ddftVal / tokenExchangeRate;     // should be safe; previous throws covers edges
346       LogRefund(msg.sender, ethVal);               // log it 
347       // DA 8/6/2017 change send/throw to transfer
348       msg.sender.transfer(ethVal);                 // if you're using a contract; make sure it works with .send gas limits
349     }
350 
351     // DA 8/6/2017
352     /// @dev Updates splitter contract with ownership changes
353     function transfer(address _to, uint _value) returns (bool success)  {
354       success = super.transfer(_to,_value);
355       splitterContract sc = splitterContract(splitter);
356       sc.update(msg.sender,balances[msg.sender]);
357       sc.update(_to,balances[_to]);
358       return;
359     }
360 
361 }