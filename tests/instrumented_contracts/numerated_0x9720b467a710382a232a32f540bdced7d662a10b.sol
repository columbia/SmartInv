1 pragma solidity 0.4.18;
2 /**
3     Used for administrration of the VZT Token Contract
4 */
5 
6 contract Administration {
7 
8     // keeps track of the contract owner
9     address     public  owner;
10     // keeps track of the contract administrator
11     address     public  administrator;
12     // keeps track of hte song token exchange
13     address     public  songTokenExchange;
14     // keeps track of the royalty information contract
15     address     public  royaltyInformationContract;
16     // keeps track of whether or not the admin contract is frozen
17     bool        public  administrationContractFrozen;
18 
19     // keeps track of the contract moderators
20     mapping (address => bool) public moderators;
21 
22     event ModeratorAdded(address indexed _invoker, address indexed _newMod, bool indexed _newModAdded);
23     event ModeratorRemoved(address indexed _invoker, address indexed _removeMod, bool indexed _modRemoved);
24     event AdministratorAdded(address indexed _invoker, address indexed _newAdmin, bool indexed _newAdminAdded);
25     event RoyaltyInformationContractSet(address indexed _invoker, address indexed _newRoyaltyContract, bool indexed _newRoyaltyContractSet);
26     event SongTokenExchangeContractSet(address indexed _invoker, address indexed _newSongTokenExchangeContract, bool indexed _newSongTokenExchangeSet);
27 
28     function Administration() {
29         owner = 0x79926C875f2636808de28CD73a45592587A537De;
30         administrator = 0x79926C875f2636808de28CD73a45592587A537De;
31         administrationContractFrozen = false;
32     }
33 
34     /// @dev checks to see if the contract is frozen
35     modifier isFrozen() {
36         require(administrationContractFrozen);
37         _;
38     }
39 
40     /// @dev checks to see if the contract is not frozen
41     modifier notFrozen() {
42         require(!administrationContractFrozen);
43         _;
44     }
45 
46     /// @dev checks to see if the msg.sender is owner
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     /// @dev checks to see if msg.sender is owner, or admin
53     modifier onlyAdmin() {
54         require(msg.sender == owner || msg.sender == administrator);
55         _;
56     }
57 
58     /// @dev checks to see if msg.sender is owner, admin, or song token exchange
59     modifier onlyAdminOrExchange() {
60         require(msg.sender == owner || msg.sender == songTokenExchange || msg.sender == administrator);
61         _;
62     }
63 
64     /// @dev checks to see if msg.sender is privileged
65     modifier onlyModerator() {
66         if (msg.sender == owner) {_;}
67         if (msg.sender == administrator) {_;}
68         if (moderators[msg.sender]) {_;}
69     }
70 
71     /// @notice used to freeze the administration contract
72     function freezeAdministrationContract() public onlyAdmin notFrozen returns (bool frozen) {
73         administrationContractFrozen = true;
74         return true;
75     }
76 
77     /// @notice used to unfreeze the administration contract
78     function unfreezeAdministrationContract() public onlyAdmin isFrozen returns (bool unfrozen) {
79         administrationContractFrozen = false;
80         return true;
81     }
82 
83     /// @notice used to set the royalty information contract
84     function setRoyaltyInformationContract(address _royaltyInformationContract) public onlyAdmin notFrozen returns (bool set) {
85         royaltyInformationContract = _royaltyInformationContract;
86         RoyaltyInformationContractSet(msg.sender, _royaltyInformationContract, true);
87         return true;
88     }
89 
90     /// @notice used to set the song token exchange
91     function setTokenExchange(address _songTokenExchange) public onlyAdmin notFrozen returns (bool set) {
92         songTokenExchange = _songTokenExchange;
93         SongTokenExchangeContractSet(msg.sender, _songTokenExchange, true);
94         return true;
95     }
96 
97     /// @notice used to add a moderator
98     function addModerator(address _newMod) public onlyAdmin notFrozen returns (bool success) {
99         moderators[_newMod] = true;
100         ModeratorAdded(msg.sender, _newMod, true);
101         return true;
102     }
103 
104     /// @notice used to remove a moderator
105     function removeModerator(address _removeMod) public onlyAdmin notFrozen returns (bool success) {
106         moderators[_removeMod] = false;
107         ModeratorRemoved(msg.sender, _removeMod, true);
108         return true;
109     }
110 
111     /// @notice used to set an administrator
112     function setAdministrator(address _administrator) public onlyOwner notFrozen returns (bool success) {
113         administrator = _administrator;
114         AdministratorAdded(msg.sender, _administrator, true);
115         return true;
116     }
117 
118     /// @notice used to transfer contract ownership
119     function transferOwnership(address _newOwner) public onlyOwner notFrozen returns (bool success) {
120         owner = _newOwner;
121         return true;
122     }
123 }
124 
125 library SafeMath {
126 
127   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a * b;
129     require(a == 0 || c / a == b);
130     return c;
131   }
132 
133   function div(uint256 a, uint256 b) internal pure returns (uint256) {
134     uint256 c = a / b;
135     return c;
136   }
137 
138   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139     require(b <= a);
140     return a - b;
141   }
142 
143   function add(uint256 a, uint256 b) internal pure returns (uint256) {
144     uint256 c = a + b;
145     require(c >= a);
146     return c;
147   }
148 }
149 
150 /**
151     Version: 1.0.1
152 */
153 
154 contract Vezt is Administration {
155     using SafeMath for uint256;
156 
157     uint256                 public  totalSupply;
158     uint8                   public  decimals;
159     string                  public  name;
160     string                  public  symbol;
161     bool                    public  tokenTransfersFrozen;
162     bool                    public  tokenMintingEnabled;
163     bool                    public  contractLaunched;
164 
165     mapping (address => uint256)                        public balances;
166     mapping (address => mapping (address => uint256))   public allowed;
167 
168 
169     event Transfer(address indexed _sender, address indexed _recipient, uint256 _amount);
170     event Approve(address indexed _owner, address indexed _spender, uint256 _amount);
171     event LaunchContract(address indexed _launcher, bool _launched);
172     event FreezeTokenTransfers(address indexed _invoker, bool _frozen);
173     event ThawTokenTransfers(address indexed _invoker, bool _thawed);
174     event MintTokens(address indexed _minter, uint256 _amount, bool indexed _minted);
175     event TokenMintingDisabled(address indexed _invoker, bool indexed _disabled);
176     event TokenMintingEnabled(address indexed _invoker, bool indexed _enabled);
177     event SongTokenAdded(address indexed _songTokenAddress, bool indexed _songTokenAdded);
178     event SongTokenRemoved(address indexed _songTokenAddress, bool indexed _songTokenRemoved);
179 
180     function Vezt() {
181         name = "Vezt";
182         symbol = "VZT";
183         decimals = 18;
184         totalSupply = 125000000000000000000000000;
185         balances[0x79926C875f2636808de28CD73a45592587A537De] = balances[0x79926C875f2636808de28CD73a45592587A537De].add(totalSupply);
186         tokenTransfersFrozen = true;
187         tokenMintingEnabled = false;
188         contractLaunched = false;
189     }
190 
191     /**
192         @dev Used by admin to send bulk amount of transfers, primary purpose to replay tx from the crowdfund to make it easier to do bulk sending
193         @notice Can also be used for general bulk transfers  via the associated python script
194      */
195     function transactionReplay(address _receiver, uint256 _amount)
196         public
197         onlyOwner
198         returns (bool replayed)
199     {
200         require(transferCheck(msg.sender, _receiver, _amount));
201         balances[msg.sender] = balances[msg.sender].sub(_amount);
202         balances[_receiver] = balances[_receiver].add(_amount);
203         Transfer(msg.sender, _receiver, _amount);
204         return true;
205     }
206 
207     /**
208         @notice Used to launch the contract
209      */
210     function launchContract() 
211         public
212         onlyOwner
213         returns (bool launched)
214     {
215         require(!contractLaunched);
216         tokenTransfersFrozen = false;
217         tokenMintingEnabled = true;
218         contractLaunched = true;
219         LaunchContract(msg.sender, true);
220         return true;
221     }
222 
223     /**
224         @notice Used to disable token minting
225      */
226     function disableTokenMinting() 
227         public
228         onlyOwner
229         returns (bool disabled) 
230     {
231         tokenMintingEnabled = false;
232         TokenMintingDisabled(msg.sender, true);
233         return true;
234     }
235 
236     /**
237         @notice Used to enable token minting
238      */
239     function enableTokenMinting() 
240         public
241         onlyOwner
242         returns (bool enabled)
243     {
244         tokenMintingEnabled = true;
245         TokenMintingEnabled(msg.sender, true);
246         return true;
247     }
248 
249     /**
250         @notice Used to freeze token transfers
251      */
252     function freezeTokenTransfers()
253         public
254         onlyOwner
255         returns (bool frozen)
256     {
257         tokenTransfersFrozen = true;
258         FreezeTokenTransfers(msg.sender, true);
259         return true;
260     }
261 
262     /**
263         @notice Used to thaw token tra4nsfers
264      */
265     function thawTokenTransfers()
266         public
267         onlyOwner
268         returns (bool thawed)
269     {
270         tokenTransfersFrozen = false;
271         ThawTokenTransfers(msg.sender, true);
272         return true;
273     }
274 
275     /**
276         @notice Used to transfer funds
277      */
278     function transfer(address _receiver, uint256 _amount)
279         public
280         returns (bool transferred)
281     {
282         require(transferCheck(msg.sender, _receiver, _amount));
283         balances[msg.sender] = balances[msg.sender].sub(_amount);
284         balances[_receiver] = balances[_receiver].add(_amount);
285         Transfer(msg.sender, _receiver, _amount);
286         return true;
287     }
288 
289     /**
290         @notice Used to transfer funds on behalf of someone
291      */
292     function transferFrom(address _owner, address _receiver, uint256 _amount) 
293         public 
294         returns (bool transferred)
295     {
296         require(allowed[_owner][msg.sender] >= _amount);
297         require(transferCheck(_owner, _receiver, _amount));
298         allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(_amount);
299         balances[_owner] = balances[_owner].sub(_amount);
300         balances[_receiver] = balances[_receiver].add(_amount);
301         Transfer(_owner, _receiver, _amount);
302         return true;
303     }
304 
305     /**
306         @notice Used to approve someone to spend funds on your behalf
307      */
308     function approve(address _spender, uint256 _amount)
309         public
310         returns (bool approved)
311     {
312         require(_amount > 0);
313         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_amount);
314         Approve(msg.sender, _spender, _amount);
315         return true;
316     }
317     
318     /**
319         @notice Used to burn tokens
320      */
321     function tokenBurner(uint256 _amount)
322         public
323         onlyOwner
324         returns (bool burned)
325     {
326         require(_amount > 0);
327         require(totalSupply.sub(_amount) >= 0);
328         require(balances[msg.sender] >= _amount);
329         require(balances[msg.sender].sub(_amount) >= 0);
330         totalSupply = totalSupply.sub(_amount);
331         balances[msg.sender] = balances[msg.sender].sub(_amount);
332         Transfer(msg.sender, 0, _amount);
333         return true;
334     }
335 
336     /**
337         @notice Used to mint new tokens
338     */
339     function tokenFactory(uint256 _amount)
340         public 
341         onlyOwner
342         returns (bool minted)
343     {
344         // this calls the token minter function which is used to do a sanity check of the parameters being passed in
345         require(tokenMinter(_amount, msg.sender));
346         totalSupply = totalSupply.add(_amount);
347         balances[msg.sender] = balances[msg.sender].add(_amount);
348         Transfer(0, msg.sender, _amount);
349         return true;
350     }
351 
352     // Internals
353 
354     /**
355         @dev Low level function used to do a sanity check of minting params
356      */
357     function tokenMinter(uint256 _amount, address _sender)
358         internal
359         view
360         returns (bool valid)
361     {
362         require(tokenMintingEnabled);
363         require(_amount > 0);
364         require(_sender != address(0x0));
365         require(totalSupply.add(_amount) > 0);
366         require(totalSupply.add(_amount) > totalSupply);
367         require(balances[_sender].add(_amount) > 0);
368         require(balances[_sender].add(_amount) > balances[_sender]);
369         return true;
370     }
371     
372     /**
373         @dev Prevents people from sending to a  a null address        
374         @notice Low level function used to do a sanity check of transfer parameters
375      */
376     function transferCheck(address _sender, address _receiver, uint256 _amount)
377         internal
378         view
379         returns (bool valid)
380     {
381         require(!tokenTransfersFrozen);
382         require(_amount > 0);
383         require(_receiver != address(0));
384         require(balances[_sender] >= _amount); // added check
385         require(balances[_sender].sub(_amount) >= 0);
386         require(balances[_receiver].add(_amount) > 0);
387         require(balances[_receiver].add(_amount) > balances[_receiver]);
388         return true;
389     }
390 
391     // Getters
392 
393     /**
394         @notice Used to retrieve total supply
395      */
396     function totalSupply() 
397         public
398         view
399         returns (uint256 _totalSupply)
400     {
401         return totalSupply;
402     }
403 
404 
405     /**
406         @notice Used to retrieve balance of a user
407      */
408     function balanceOf(address _person)
409         public
410         view
411         returns (uint256 _balanceOf)
412     {
413         return balances[_person];
414     }
415 
416     /**
417         @notice Used to retrieve the allowed balance of someone
418      */
419     function allowance(address _owner, address _spender)
420         public 
421         view
422         returns (uint256 _allowance)
423     {
424         return allowed[_owner][_spender];
425     }
426 
427 }