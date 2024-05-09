1 // File: contracts/GodMode.sol
2 
3 /****************************************************
4  *
5  * Copyright 2018 BurzNest LLC. All rights reserved.
6  *
7  * The contents of this file are provided for review
8  * and educational purposes ONLY. You MAY NOT use,
9  * copy, distribute, or modify this software without
10  * explicit written permission from BurzNest LLC.
11  *
12  ****************************************************/
13 
14 pragma solidity ^0.4.24;
15 
16 /// @title God Mode
17 /// @author Anthony Burzillo <burz@burznest.com>
18 /// @dev This contract provides a basic interface for God
19 ///  in a contract as well as the ability for God to pause
20 ///  the contract
21 contract GodMode {
22     /// @dev Is the contract paused?
23     bool public isPaused;
24 
25     /// @dev God's address
26     address public god;
27 
28     /// @dev Only God can run this function
29     modifier onlyGod()
30     {
31         require(god == msg.sender);
32         _;
33     }
34 
35     /// @dev This function can only be run while the contract
36     ///  is not paused
37     modifier notPaused()
38     {
39         require(!isPaused);
40         _;
41     }
42 
43     /// @dev This event is fired when the contract is paused
44     event GodPaused();
45 
46     /// @dev This event is fired when the contract is unpaused
47     event GodUnpaused();
48 
49     constructor() public
50     {
51         // Make the creator of the contract God
52         god = msg.sender;
53     }
54 
55     /// @dev God can change the address of God
56     /// @param _newGod The new address for God
57     function godChangeGod(address _newGod) public onlyGod
58     {
59         god = _newGod;
60     }
61 
62     /// @dev God can pause the game
63     function godPause() public onlyGod
64     {
65         isPaused = true;
66 
67         emit GodPaused();
68     }
69 
70     /// @dev God can unpause the game
71     function godUnpause() public onlyGod
72     {
73         isPaused = false;
74 
75         emit GodUnpaused();
76     }
77 }
78 
79 // File: contracts/KingOfEthResourcesInterfaceReferencer.sol
80 
81 /****************************************************
82  *
83  * Copyright 2018 BurzNest LLC. All rights reserved.
84  *
85  * The contents of this file are provided for review
86  * and educational purposes ONLY. You MAY NOT use,
87  * copy, distribute, or modify this software without
88  * explicit written permission from BurzNest LLC.
89  *
90  ****************************************************/
91 
92 pragma solidity ^0.4.24;
93 
94 
95 /// @title King of Eth: Resources Interface Referencer
96 /// @author Anthony Burzillo <burz@burznest.com>
97 /// @dev Provides functionality to reference the resource interface contract
98 contract KingOfEthResourcesInterfaceReferencer is GodMode {
99     /// @dev The interface contract's address
100     address public interfaceContract;
101 
102     /// @dev Only the interface contract can run this function
103     modifier onlyInterfaceContract()
104     {
105         require(interfaceContract == msg.sender);
106         _;
107     }
108 
109     /// @dev God can set the realty contract
110     /// @param _interfaceContract The new address
111     function godSetInterfaceContract(address _interfaceContract)
112         public
113         onlyGod
114     {
115         interfaceContract = _interfaceContract;
116     }
117 }
118 
119 // File: contracts/KingOfEthResource.sol
120 
121 /****************************************************
122  *
123  * Copyright 2018 BurzNest LLC. All rights reserved.
124  *
125  * The contents of this file are provided for review
126  * and educational purposes ONLY. You MAY NOT use,
127  * copy, distribute, or modify this software without
128  * explicit written permission from BurzNest LLC.
129  *
130  ****************************************************/
131 
132 pragma solidity ^0.4.24;
133 
134 
135 
136 /// @title ERC20Interface
137 /// @dev ERC20 token interface contract
138 contract ERC20Interface {
139     function totalSupply() public constant returns(uint);
140     function balanceOf(address _tokenOwner) public constant returns(uint balance);
141     function allowance(address _tokenOwner, address _spender) public constant returns(uint remaining);
142     function transfer(address _to, uint _tokens) public returns(bool success);
143     function approve(address _spender, uint _tokens) public returns(bool success);
144     function transferFrom(address _from, address _to, uint _tokens) public returns(bool success);
145 
146     event Transfer(address indexed from, address indexed to, uint tokens);
147     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
148 }
149 
150 /// @title King of Eth: Resource
151 /// @author Anthony Burzillo <burz@burznest.com>
152 /// @dev Common contract implementation for resources
153 contract KingOfEthResource is
154       ERC20Interface
155     , GodMode
156     , KingOfEthResourcesInterfaceReferencer
157 {
158     /// @dev Current resource supply
159     uint public resourceSupply;
160 
161     /// @dev ERC20 token's decimals
162     uint8 public constant decimals = 0;
163 
164     /// @dev mapping of addresses to holdings
165     mapping (address => uint) holdings;
166 
167     /// @dev mapping of addresses to amount of tokens frozen
168     mapping (address => uint) frozenHoldings;
169 
170     /// @dev mapping of addresses to mapping of allowances for an address
171     mapping (address => mapping (address => uint)) allowances;
172 
173     /// @dev ERC20 total supply
174     /// @return The current total supply of the resource
175     function totalSupply()
176         public
177         constant
178         returns(uint)
179     {
180         return resourceSupply;
181     }
182 
183     /// @dev ERC20 balance of address
184     /// @param _tokenOwner The address to look up
185     /// @return The balance of the address
186     function balanceOf(address _tokenOwner)
187         public
188         constant
189         returns(uint balance)
190     {
191         return holdings[_tokenOwner];
192     }
193 
194     /// @dev Total resources frozen for an address
195     /// @param _tokenOwner The address to look up
196     /// @return The frozen balance of the address
197     function frozenTokens(address _tokenOwner)
198         public
199         constant
200         returns(uint balance)
201     {
202         return frozenHoldings[_tokenOwner];
203     }
204 
205     /// @dev The allowance for a spender on an account
206     /// @param _tokenOwner The account that allows withdrawels
207     /// @param _spender The account that is allowed to withdraw
208     /// @return The amount remaining in the allowance
209     function allowance(address _tokenOwner, address _spender)
210         public
211         constant
212         returns(uint remaining)
213     {
214         return allowances[_tokenOwner][_spender];
215     }
216 
217     /// @dev Only run if player has at least some amount of tokens
218     /// @param _owner The owner of the tokens
219     /// @param _tokens The amount of tokens required
220     modifier hasAvailableTokens(address _owner, uint _tokens)
221     {
222         require(holdings[_owner] - frozenHoldings[_owner] >= _tokens);
223         _;
224     }
225 
226     /// @dev Only run if player has at least some amount of tokens frozen
227     /// @param _owner The owner of the tokens
228     /// @param _tokens The amount of frozen tokens required
229     modifier hasFrozenTokens(address _owner, uint _tokens)
230     {
231         require(frozenHoldings[_owner] >= _tokens);
232         _;
233     }
234 
235     /// @dev Set up the exact same state in each resource
236     constructor() public
237     {
238         // God gets 200 to put on exchange
239         holdings[msg.sender] = 200;
240 
241         resourceSupply = 200;
242     }
243 
244     /// @dev The resources interface can burn tokens for building
245     ///  roads or houses
246     /// @param _owner The owner of the tokens
247     /// @param _tokens The amount of tokens to burn
248     function interfaceBurnTokens(address _owner, uint _tokens)
249         public
250         onlyInterfaceContract
251         hasAvailableTokens(_owner, _tokens)
252     {
253         holdings[_owner] -= _tokens;
254 
255         resourceSupply -= _tokens;
256 
257         // Pretend the tokens were sent to 0x0
258         emit Transfer(_owner, 0x0, _tokens);
259     }
260 
261     /// @dev The resources interface contract can mint tokens for houses
262     /// @param _owner The owner of the tokens
263     /// @param _tokens The amount of tokens to burn
264     function interfaceMintTokens(address _owner, uint _tokens)
265         public
266         onlyInterfaceContract
267     {
268         holdings[_owner] += _tokens;
269 
270         resourceSupply += _tokens;
271 
272         // Pretend the tokens were sent from the interface contract
273         emit Transfer(interfaceContract, _owner, _tokens);
274     }
275 
276     /// @dev The interface can freeze tokens
277     /// @param _owner The owner of the tokens
278     /// @param _tokens The amount of tokens to freeze
279     function interfaceFreezeTokens(address _owner, uint _tokens)
280         public
281         onlyInterfaceContract
282         hasAvailableTokens(_owner, _tokens)
283     {
284         frozenHoldings[_owner] += _tokens;
285     }
286 
287     /// @dev The interface can thaw tokens
288     /// @param _owner The owner of the tokens
289     /// @param _tokens The amount of tokens to thaw
290     function interfaceThawTokens(address _owner, uint _tokens)
291         public
292         onlyInterfaceContract
293         hasFrozenTokens(_owner, _tokens)
294     {
295         frozenHoldings[_owner] -= _tokens;
296     }
297 
298     /// @dev The interface can transfer tokens
299     /// @param _from The owner of the tokens
300     /// @param _to The new owner of the tokens
301     /// @param _tokens The amount of tokens to transfer
302     function interfaceTransfer(address _from, address _to, uint _tokens)
303         public
304         onlyInterfaceContract
305     {
306         assert(holdings[_from] >= _tokens);
307 
308         holdings[_from] -= _tokens;
309         holdings[_to]   += _tokens;
310 
311         emit Transfer(_from, _to, _tokens);
312     }
313 
314     /// @dev The interface can transfer frozend tokens
315     /// @param _from The owner of the tokens
316     /// @param _to The new owner of the tokens
317     /// @param _tokens The amount of frozen tokens to transfer
318     function interfaceFrozenTransfer(address _from, address _to, uint _tokens)
319         public
320         onlyInterfaceContract
321         hasFrozenTokens(_from, _tokens)
322     {
323         // Make sure to deduct the tokens from both the total and frozen amounts
324         holdings[_from]       -= _tokens;
325         frozenHoldings[_from] -= _tokens;
326         holdings[_to]         += _tokens;
327 
328         emit Transfer(_from, _to, _tokens);
329     }
330 
331     /// @dev ERC20 transfer
332     /// @param _to The address to transfer to
333     /// @param _tokens The amount of tokens to transfer
334     function transfer(address _to, uint _tokens)
335         public
336         hasAvailableTokens(msg.sender, _tokens)
337         returns(bool success)
338     {
339         holdings[_to]        += _tokens;
340         holdings[msg.sender] -= _tokens;
341 
342         emit Transfer(msg.sender, _to, _tokens);
343 
344         return true;
345     }
346 
347     /// @dev ERC20 approve
348     /// @param _spender The address to approve
349     /// @param _tokens The amount of tokens to approve
350     function approve(address _spender, uint _tokens)
351         public
352         returns(bool success)
353     {
354         allowances[msg.sender][_spender] = _tokens;
355 
356         emit Approval(msg.sender, _spender, _tokens);
357 
358         return true;
359     }
360 
361     /// @dev ERC20 transfer from
362     /// @param _from The address providing the allowance
363     /// @param _to The address using the allowance
364     /// @param _tokens The amount of tokens to transfer
365     function transferFrom(address _from, address _to, uint _tokens)
366         public
367         hasAvailableTokens(_from, _tokens)
368         returns(bool success)
369     {
370         require(allowances[_from][_to] >= _tokens);
371 
372         holdings[_to]          += _tokens;
373         holdings[_from]        -= _tokens;
374         allowances[_from][_to] -= _tokens;
375 
376         emit Transfer(_from, _to, _tokens);
377 
378         return true;
379     }
380 }
381 
382 // File: contracts/resources/KingOfEthResourceWood.sol
383 
384 /****************************************************
385  *
386  * Copyright 2018 BurzNest LLC. All rights reserved.
387  *
388  * The contents of this file are provided for review
389  * and educational purposes ONLY. You MAY NOT use,
390  * copy, distribute, or modify this software without
391  * explicit written permission from BurzNest LLC.
392  *
393  ****************************************************/
394 
395 pragma solidity ^0.4.24;
396 
397 
398 /// @title King of Eth Resource: Wood
399 /// @author Anthony Burzillo <burz@burznest.com>
400 /// @dev ERC20 contract for the wood resource
401 contract KingOfEthResourceWood is KingOfEthResource {
402     /// @dev The ERC20 token name
403     string public constant name   = "King of Eth Resource: Wood";
404 
405     /// @dev The ERC20 token symbol
406     string public constant symbol = "KEWO";
407 }