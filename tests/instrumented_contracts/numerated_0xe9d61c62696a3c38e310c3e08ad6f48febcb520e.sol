1 pragma solidity ^0.4.4;
2 
3 /**
4  * @title Contract for object that have an owner
5  */
6 contract Owned {
7     /**
8      * Contract owner address
9      */
10     address public owner;
11 
12     /**
13      * @dev Delegate contract to another person
14      * @param _owner New owner address 
15      */
16     function setOwner(address _owner) onlyOwner
17     { owner = _owner; }
18 
19     /**
20      * @dev Owner check modifier
21      */
22     modifier onlyOwner { if (msg.sender != owner) throw; _; }
23 }
24 
25 /**
26  * @title Common pattern for destroyable contracts 
27  */
28 contract Destroyable {
29     address public hammer;
30 
31     /**
32      * @dev Hammer setter
33      * @param _hammer New hammer address
34      */
35     function setHammer(address _hammer) onlyHammer
36     { hammer = _hammer; }
37 
38     /**
39      * @dev Destroy contract and scrub a data
40      * @notice Only hammer can call it 
41      */
42     function destroy() onlyHammer
43     { suicide(msg.sender); }
44 
45     /**
46      * @dev Hammer check modifier
47      */
48     modifier onlyHammer { if (msg.sender != hammer) throw; _; }
49 }
50 
51 /**
52  * @title Generic owned destroyable contract
53  */
54 contract Object is Owned, Destroyable {
55     function Object() {
56         owner  = msg.sender;
57         hammer = msg.sender;
58     }
59 }
60 
61 // Standard token interface (ERC 20)
62 // https://github.com/ethereum/EIPs/issues/20
63 contract ERC20 
64 {
65 // Functions:
66     /// @return total amount of tokens
67     uint256 public totalSupply;
68 
69     /// @param _owner The address from which the balance will be retrieved
70     /// @return The balance
71     function balanceOf(address _owner) constant returns (uint256);
72 
73     /// @notice send `_value` token to `_to` from `msg.sender`
74     /// @param _to The address of the recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transfer(address _to, uint256 _value) returns (bool);
78 
79     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
80     /// @param _from The address of the sender
81     /// @param _to The address of the recipient
82     /// @param _value The amount of token to be transferred
83     /// @return Whether the transfer was successful or not
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
85 
86     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
87     /// @param _spender The address of the account able to transfer the tokens
88     /// @param _value The amount of wei to be approved for transfer
89     /// @return Whether the approval was successful or not
90     function approve(address _spender, uint256 _value) returns (bool);
91 
92     /// @param _owner The address of the account owning tokens
93     /// @param _spender The address of the account able to transfer the tokens
94     /// @return Amount of remaining tokens allowed to spent
95     function allowance(address _owner, address _spender) constant returns (uint256);
96 
97 // Events:
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 }
101 
102 /**
103  * @title Asset recipient interface
104  */
105 contract Recipient {
106     /**
107      * @dev On received ethers
108      * @param sender Ether sender
109      * @param amount Ether value
110      */
111     event ReceivedEther(address indexed sender,
112                         uint256 indexed amount);
113 
114     /**
115      * @dev On received custom ERC20 tokens
116      * @param from Token sender
117      * @param value Token value
118      * @param token Token contract address
119      * @param extraData Custom additional data
120      */
121     event ReceivedTokens(address indexed from,
122                          uint256 indexed value,
123                          address indexed token,
124                          bytes extraData);
125 
126     /**
127      * @dev Receive approved ERC20 tokens
128      * @param _from Spender address
129      * @param _value Transaction value
130      * @param _token ERC20 token contract address
131      * @param _extraData Custom additional data
132      */
133     function receiveApproval(address _from, uint256 _value,
134                              ERC20 _token, bytes _extraData) {
135         if (!_token.transferFrom(_from, this, _value)) throw;
136         ReceivedTokens(_from, _value, _token, _extraData);
137     }
138 
139     /**
140      * @dev Catch sended to contract ethers
141      */
142     function () payable
143     { ReceivedEther(msg.sender, msg.value); }
144 }
145 
146 
147 /**
148  * @title Token contract represents any asset in digital economy
149  */
150 contract Token is Object, ERC20 {
151     /* Short description of token */
152     string public name;
153     string public symbol;
154 
155     /* Total count of tokens exist */
156     uint public totalSupply;
157 
158     /* Fixed point position */
159     uint8 public decimals;
160     
161     /* Token approvement system */
162     mapping(address => uint) balances;
163     mapping(address => mapping(address => uint)) allowances;
164  
165     /**
166      * @dev Get balance of plain address
167      * @param _owner is a target address
168      * @return amount of tokens on balance
169      */
170     function balanceOf(address _owner) constant returns (uint256)
171     { return balances[_owner]; }
172  
173     /**
174      * @dev Take allowed tokens
175      * @param _owner The address of the account owning tokens
176      * @param _spender The address of the account able to transfer the tokens
177      * @return Amount of remaining tokens allowed to spent
178      */
179     function allowance(address _owner, address _spender) constant returns (uint256)
180     { return allowances[_owner][_spender]; }
181 
182     /* Token constructor */
183     function Token(string _name, string _symbol, uint8 _decimals, uint _count) {
184         name        = _name;
185         symbol      = _symbol;
186         decimals    = _decimals;
187         totalSupply = _count;
188         balances[msg.sender] = _count;
189     }
190  
191     /**
192      * @dev Transfer self tokens to given address
193      * @param _to destination address
194      * @param _value amount of token values to send
195      * @notice `_value` tokens will be sended to `_to`
196      * @return `true` when transfer done
197      */
198     function transfer(address _to, uint _value) returns (bool) {
199         if (balances[msg.sender] >= _value) {
200             balances[msg.sender] -= _value;
201             balances[_to]        += _value;
202             Transfer(msg.sender, _to, _value);
203             return true;
204         }
205         return false;
206     }
207 
208     /**
209      * @dev Transfer with approvement mechainsm
210      * @param _from source address, `_value` tokens shold be approved for `sender`
211      * @param _to destination address
212      * @param _value amount of token values to send 
213      * @notice from `_from` will be sended `_value` tokens to `_to`
214      * @return `true` when transfer is done
215      */
216     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
217         var avail = allowances[_from][msg.sender]
218                   > balances[_from] ? balances[_from]
219                                     : allowances[_from][msg.sender];
220         if (avail >= _value) {
221             allowances[_from][msg.sender] -= _value;
222             balances[_from] -= _value;
223             balances[_to]   += _value;
224             Transfer(_from, _to, _value);
225             return true;
226         }
227         return false;
228     }
229 
230     /**
231      * @dev Give to target address ability for self token manipulation without sending
232      * @param _spender target address (future requester)
233      * @param _value amount of token values for approving
234      */
235     function approve(address _spender, uint256 _value) returns (bool) {
236         allowances[msg.sender][_spender] += _value;
237         Approval(msg.sender, _spender, _value);
238         return true;
239     }
240 
241     /**
242      * @dev Reset count of tokens approved for given address
243      * @param _spender target address (future requester)
244      */
245     function unapprove(address _spender)
246     { allowances[msg.sender][_spender] = 0; }
247 }
248 
249 contract TokenEmission is Token {
250     function TokenEmission(string _name, string _symbol, uint8 _decimals,
251                            uint _start_count)
252              Token(_name, _symbol, _decimals, _start_count)
253     {}
254 
255     /**
256      * @dev Token emission
257      * @param _value amount of token values to emit
258      * @notice owner balance will be increased by `_value`
259      */
260     function emission(uint _value) onlyOwner {
261         // Overflow check
262         if (_value + totalSupply < totalSupply) throw;
263 
264         totalSupply     += _value;
265         balances[owner] += _value;
266     }
267  
268     /**
269      * @dev Burn the token values from sender balance and from total
270      * @param _value amount of token values for burn 
271      * @notice sender balance will be decreased by `_value`
272      */
273     function burn(uint _value) {
274         if (balances[msg.sender] >= _value) {
275             balances[msg.sender] -= _value;
276             totalSupply      -= _value;
277         }
278     }
279 }
280 
281 /**
282  * @title Crowdfunding contract
283  */
284 contract Crowdfunding is Object, Recipient {
285     /**
286      * @dev Target fund account address
287      */
288     address public fund;
289 
290     /**
291      * @dev Bounty token address
292      */
293     TokenEmission public bounty;
294     
295     /**
296      * @dev Distribution of donations
297      */
298     mapping(address => uint256) public donations;
299 
300     /**
301      * @dev Total funded value
302      */
303     uint256 public totalFunded;
304 
305     /**
306      * @dev Documentation reference
307      */
308     string public reference;
309 
310     /**
311      * @dev Crowdfunding configuration
312      */
313     Params public config;
314 
315     struct Params {
316         /* start/stop block stamps */
317         uint256 startBlock;
318         uint256 stopBlock;
319 
320         /* Minimal/maximal funded value */
321         uint256 minValue;
322         uint256 maxValue;
323         
324         /**
325          * Bounty ratio equation:
326          *   bountyValue = value * ratio / scale
327          * where
328          *   ratio = R - (block - B) / S * V
329          *  R - start bounty ratio
330          *  B - start block number
331          *  S - bounty reduction step in blocks 
332          *  V - bounty reduction value
333          */
334         uint256 bountyScale;
335         uint256 startRatio;
336         uint256 reductionStep;
337         uint256 reductionValue;
338     }
339 
340     /**
341      * @dev Calculate bounty value by reduction equation
342      * @param _value Input donation value
343      * @param _block Input block number
344      * @return Bounty value
345      */
346     function bountyValue(uint256 _value, uint256 _block) constant returns (uint256) {
347         if (_block < config.startBlock || _block > config.stopBlock)
348             return 0;
349 
350         var R = config.startRatio;
351         var B = config.startBlock;
352         var S = config.reductionStep;
353         var V = config.reductionValue;
354         uint256 ratio = R - (_block - B) / S * V; 
355         return _value * ratio / config.bountyScale; 
356     }
357 
358     /**
359      * @dev Crowdfunding running checks
360      */
361     modifier onlyRunning {
362         bool isRunning = totalFunded + msg.value <= config.maxValue
363                       && block.number >= config.startBlock
364                       && block.number <= config.stopBlock;
365         if (!isRunning) throw;
366         _;
367     }
368 
369     /**
370      * @dev Crowdfundung failure checks
371      */
372     modifier onlyFailure {
373         bool isFailure = totalFunded  < config.minValue
374                       && block.number > config.stopBlock;
375         if (!isFailure) throw;
376         _;
377     }
378 
379     /**
380      * @dev Crowdfunding success checks
381      */
382     modifier onlySuccess {
383         bool isSuccess = totalFunded >= config.minValue
384                       && block.number > config.stopBlock;
385         if (!isSuccess) throw;
386         _;
387     }
388 
389     /**
390      * @dev Crowdfunding contract initial 
391      * @param _fund Destination account address
392      * @param _bounty Bounty token address
393      * @param _reference Reference documentation link
394      * @param _startBlock Funding start block number
395      * @param _stopBlock Funding stop block nubmer
396      * @param _minValue Minimal funded value in wei 
397      * @param _maxValue Maximal funded value in wei
398      * @param _scale Bounty scaling factor by funded value
399      * @param _startRatio Initial bounty ratio
400      * @param _reductionStep Bounty reduction step in blocks 
401      * @param _reductionValue Bounty reduction value
402      * @notice this contract should be owner of bounty token
403      */
404     function Crowdfunding(
405         address _fund,
406         address _bounty,
407         string  _reference,
408         uint256 _startBlock,
409         uint256 _stopBlock,
410         uint256 _minValue,
411         uint256 _maxValue,
412         uint256 _scale,
413         uint256 _startRatio,
414         uint256 _reductionStep,
415         uint256 _reductionValue
416     ) {
417         fund      = _fund;
418         bounty    = TokenEmission(_bounty);
419         reference = _reference;
420 
421         config.startBlock     = _startBlock;
422         config.stopBlock      = _stopBlock;
423         config.minValue       = _minValue;
424         config.maxValue       = _maxValue;
425         config.bountyScale    = _scale;
426         config.startRatio     = _startRatio;
427         config.reductionStep  = _reductionStep;
428         config.reductionValue = _reductionValue;
429     }
430 
431     /**
432      * @dev Receive Ether token and send bounty
433      */
434     function () payable onlyRunning {
435         ReceivedEther(msg.sender, msg.value);
436 
437         totalFunded           += msg.value;
438         donations[msg.sender] += msg.value;
439 
440         var bountyVal = bountyValue(msg.value, block.number);
441         if (bountyVal == 0) throw;
442 
443         bounty.emission(bountyVal);
444         bounty.transfer(msg.sender, bountyVal);
445     }
446 
447     /**
448      * @dev Withdrawal balance on successfull finish
449      */
450     function withdraw() onlySuccess
451     { if (!fund.send(this.balance)) throw; }
452 
453     /**
454      * @dev Refund donations when no minimal value achieved
455      */
456     function refund() onlyFailure {
457         var donation = donations[msg.sender];
458         donations[msg.sender] = 0;
459         if (!msg.sender.send(donation)) throw;
460     }
461 
462     /**
463      * @dev Disable receive another tokens
464      */
465     function receiveApproval(address _from, uint256 _value,
466                              ERC20 _token, bytes _extraData)
467     { throw; }
468 }