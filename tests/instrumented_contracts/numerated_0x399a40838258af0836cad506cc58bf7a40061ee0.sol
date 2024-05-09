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
103  * @title Token contract represents any asset in digital economy
104  */
105 contract Token is Object, ERC20 {
106     /* Short description of token */
107     string public name;
108     string public symbol;
109 
110     /* Total count of tokens exist */
111     uint public totalSupply;
112 
113     /* Fixed point position */
114     uint8 public decimals;
115     
116     /* Token approvement system */
117     mapping(address => uint) balances;
118     mapping(address => mapping(address => uint)) allowances;
119  
120     /**
121      * @dev Get balance of plain address
122      * @param _owner is a target address
123      * @return amount of tokens on balance
124      */
125     function balanceOf(address _owner) constant returns (uint256)
126     { return balances[_owner]; }
127  
128     /**
129      * @dev Take allowed tokens
130      * @param _owner The address of the account owning tokens
131      * @param _spender The address of the account able to transfer the tokens
132      * @return Amount of remaining tokens allowed to spent
133      */
134     function allowance(address _owner, address _spender) constant returns (uint256)
135     { return allowances[_owner][_spender]; }
136 
137     /* Token constructor */
138     function Token(string _name, string _symbol, uint8 _decimals, uint _count) {
139         name        = _name;
140         symbol      = _symbol;
141         decimals    = _decimals;
142         totalSupply = _count;
143         balances[msg.sender] = _count;
144     }
145  
146     /**
147      * @dev Transfer self tokens to given address
148      * @param _to destination address
149      * @param _value amount of token values to send
150      * @notice `_value` tokens will be sended to `_to`
151      * @return `true` when transfer done
152      */
153     function transfer(address _to, uint _value) returns (bool) {
154         if (balances[msg.sender] >= _value) {
155             balances[msg.sender] -= _value;
156             balances[_to]        += _value;
157             Transfer(msg.sender, _to, _value);
158             return true;
159         }
160         return false;
161     }
162 
163     /**
164      * @dev Transfer with approvement mechainsm
165      * @param _from source address, `_value` tokens shold be approved for `sender`
166      * @param _to destination address
167      * @param _value amount of token values to send 
168      * @notice from `_from` will be sended `_value` tokens to `_to`
169      * @return `true` when transfer is done
170      */
171     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
172         var avail = allowances[_from][msg.sender]
173                   > balances[_from] ? balances[_from]
174                                     : allowances[_from][msg.sender];
175         if (avail >= _value) {
176             allowances[_from][msg.sender] -= _value;
177             balances[_from] -= _value;
178             balances[_to]   += _value;
179             Transfer(_from, _to, _value);
180             return true;
181         }
182         return false;
183     }
184 
185     /**
186      * @dev Give to target address ability for self token manipulation without sending
187      * @param _spender target address (future requester)
188      * @param _value amount of token values for approving
189      */
190     function approve(address _spender, uint256 _value) returns (bool) {
191         allowances[msg.sender][_spender] += _value;
192         Approval(msg.sender, _spender, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Reset count of tokens approved for given address
198      * @param _spender target address (future requester)
199      */
200     function unapprove(address _spender)
201     { allowances[msg.sender][_spender] = 0; }
202 }
203 
204 contract TokenEmission is Token {
205     function TokenEmission(string _name, string _symbol, uint8 _decimals,
206                            uint _start_count)
207              Token(_name, _symbol, _decimals, _start_count)
208     {}
209 
210     /**
211      * @dev Token emission
212      * @param _value amount of token values to emit
213      * @notice owner balance will be increased by `_value`
214      */
215     function emission(uint _value) onlyOwner {
216         // Overflow check
217         if (_value + totalSupply < totalSupply) throw;
218 
219         totalSupply     += _value;
220         balances[owner] += _value;
221     }
222  
223     /**
224      * @dev Burn the token values from sender balance and from total
225      * @param _value amount of token values for burn 
226      * @notice sender balance will be decreased by `_value`
227      */
228     function burn(uint _value) {
229         if (balances[msg.sender] >= _value) {
230             balances[msg.sender] -= _value;
231             totalSupply      -= _value;
232         }
233     }
234 }
235 
236 /**
237  * @title Asset recipient interface
238  */
239 contract Recipient {
240     /**
241      * @dev On received ethers
242      * @param sender Ether sender
243      * @param amount Ether value
244      */
245     event ReceivedEther(address indexed sender,
246                         uint256 indexed amount);
247 
248     /**
249      * @dev On received custom ERC20 tokens
250      * @param from Token sender
251      * @param value Token value
252      * @param token Token contract address
253      * @param extraData Custom additional data
254      */
255     event ReceivedTokens(address indexed from,
256                          uint256 indexed value,
257                          address indexed token,
258                          bytes extraData);
259 
260     /**
261      * @dev Receive approved ERC20 tokens
262      * @param _from Spender address
263      * @param _value Transaction value
264      * @param _token ERC20 token contract address
265      * @param _extraData Custom additional data
266      */
267     function receiveApproval(address _from, uint256 _value,
268                              ERC20 _token, bytes _extraData) {
269         if (!_token.transferFrom(_from, this, _value)) throw;
270         ReceivedTokens(_from, _value, _token, _extraData);
271     }
272 
273     /**
274      * @dev Catch sended to contract ethers
275      */
276     function () payable
277     { ReceivedEther(msg.sender, msg.value); }
278 }
279 
280 /**
281  * @title Crowdfunding contract
282  */
283 contract Crowdfunding is Object, Recipient {
284     /**
285      * @dev Target fund account address
286      */
287     address public fund;
288 
289     /**
290      * @dev Bounty token address
291      */
292     TokenEmission public bounty;
293     
294     /**
295      * @dev Distribution of donations
296      */
297     mapping(address => uint256) public donations;
298 
299     /**
300      * @dev Total funded value
301      */
302     uint256 public totalFunded;
303 
304     /**
305      * @dev Documentation reference
306      */
307     string public reference;
308 
309     /**
310      * @dev Crowdfunding configuration
311      */
312     Params public config;
313 
314     struct Params {
315         /* start/stop block stamps */
316         uint256 startBlock;
317         uint256 stopBlock;
318 
319         /* Minimal/maximal funded value */
320         uint256 minValue;
321         uint256 maxValue;
322         
323         /**
324          * Bounty ratio equation:
325          *   bountyValue = value * ratio / scale
326          * where
327          *   ratio = R - (block - B) / S * V
328          *  R - start bounty ratio
329          *  B - start block number
330          *  S - bounty reduction step in blocks 
331          *  V - bounty reduction value
332          */
333         uint256 bountyScale;
334         uint256 startRatio;
335         uint256 reductionStep;
336         uint256 reductionValue;
337     }
338 
339     /**
340      * @dev Calculate bounty value by reduction equation
341      * @param _value Input donation value
342      * @param _block Input block number
343      * @return Bounty value
344      */
345     function bountyValue(uint256 _value, uint256 _block) constant returns (uint256) {
346         if (_block < config.startBlock || _block > config.stopBlock)
347             return 0;
348 
349         var R = config.startRatio;
350         var B = config.startBlock;
351         var S = config.reductionStep;
352         var V = config.reductionValue;
353         uint256 ratio = R - (_block - B) / S * V; 
354         return _value * ratio / config.bountyScale; 
355     }
356 
357     /**
358      * @dev Crowdfunding running checks
359      */
360     modifier onlyRunning {
361         bool isRunning = totalFunded + msg.value  < config.maxValue
362                       && block.number > config.startBlock
363                       && block.number < config.stopBlock;
364         if (!isRunning) throw;
365         _;
366     }
367 
368     /**
369      * @dev Crowdfundung failure checks
370      */
371     modifier onlyFailure {
372         bool isFailure = totalFunded  < config.minValue
373                       && block.number > config.stopBlock;
374         if (!isFailure) throw;
375         _;
376     }
377 
378     /**
379      * @dev Crowdfunding success checks
380      */
381     modifier onlySuccess {
382         bool isSuccess = totalFunded >= config.minValue
383                       && block.number > config.stopBlock;
384         if (!isSuccess) throw;
385         _;
386     }
387 
388     /**
389      * @dev Crowdfunding contract initial 
390      * @param _fund Destination account address
391      * @param _bounty Bounty token address
392      * @param _reference Reference documentation link
393      * @param _startBlock Funding start block number
394      * @param _stopBlock Funding stop block nubmer
395      * @param _minValue Minimal funded value in wei 
396      * @param _maxValue Maximal funded value in wei
397      * @param _scale Bounty scaling factor by funded value
398      * @param _startRatio Initial bounty ratio
399      * @param _reductionStep Bounty reduction step in blocks 
400      * @param _reductionValue Bounty reduction value
401      * @notice this contract should be owner of bounty token
402      */
403     function Crowdfunding(
404         address _fund,
405         address _bounty,
406         string  _reference,
407         uint256 _startBlock,
408         uint256 _stopBlock,
409         uint256 _minValue,
410         uint256 _maxValue,
411         uint256 _scale,
412         uint256 _startRatio,
413         uint256 _reductionStep,
414         uint256 _reductionValue
415     ) {
416         fund      = _fund;
417         bounty    = TokenEmission(_bounty);
418         reference = _reference;
419 
420         config.startBlock     = _startBlock;
421         config.stopBlock      = _stopBlock;
422         config.minValue       = _minValue;
423         config.maxValue       = _maxValue;
424         config.bountyScale    = _scale;
425         config.startRatio     = _startRatio;
426         config.reductionStep  = _reductionStep;
427         config.reductionValue = _reductionValue;
428     }
429 
430     /**
431      * @dev Receive Ether token and send bounty
432      */
433     function () payable onlyRunning {
434         ReceivedEther(msg.sender, msg.value);
435 
436         totalFunded           += msg.value;
437         donations[msg.sender] += msg.value;
438 
439         var bountyVal = bountyValue(msg.value, block.number);
440         bounty.emission(bountyVal);
441         bounty.transfer(msg.sender, bountyVal);
442     }
443 
444     /**
445      * @dev Withdrawal balance on successfull finish
446      */
447     function withdraw() onlySuccess
448     { if (!fund.send(this.balance)) throw; }
449 
450     /**
451      * @dev Refund donations when no minimal value achieved
452      */
453     function refund() onlyFailure {
454         var donation = donations[msg.sender];
455         donations[msg.sender] = 0;
456         if (!msg.sender.send(donation)) throw;
457     }
458 
459     /**
460      * @dev Disable receive another tokens
461      */
462     function receiveApproval(address _from, uint256 _value,
463                              ERC20 _token, bytes _extraData)
464     { throw; }
465 }