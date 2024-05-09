1 pragma solidity 0.4.18;
2 
3 // implement safemath as a library
4 library SafeMath {
5 
6   // We use `pure` bbecause it promises that the value for the function depends ONLY
7   // on the function arguments
8   function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
9     uint256 c = a * b;
10     require(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     require(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     require(c >= a);
27     return c;
28   }
29 }
30 
31 contract Administration {
32 
33     address     public owner;
34     
35     mapping (address => bool) public moderators;
36     mapping (address => string) privilegeStatus;
37 
38     event AddMod(address indexed _invoker, address indexed _newMod, bool indexed _modAdded);
39     event RemoveMod(address indexed _invoker, address indexed _removeMod, bool indexed _modRemoved);
40 
41     function Administration() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyAdmin() {
46         require(msg.sender == owner || moderators[msg.sender] == true);
47         _;
48     }
49 
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner)
56         public
57         onlyOwner
58         returns (bool success)
59     {
60         owner = _newOwner;
61         return true;
62         
63     }
64 
65     function addModerator(address _newMod)
66         public
67         onlyOwner
68         returns (bool added)
69      {
70         require(_newMod != address(0x0));
71         moderators[_newMod] = true;
72         AddMod(msg.sender, _newMod, true);
73         return true;
74     }
75     
76     function removeModerator(address _removeMod)
77         public
78         onlyOwner
79         returns (bool removed)
80     {
81         require(_removeMod != address(0x0));
82         moderators[_removeMod] = false;
83         RemoveMod(msg.sender, _removeMod, true);
84         return true;
85     }
86 
87     function getRoleStatus(address _addr)
88         public
89         view  // We use view as we promise to not change state, but are reading from a state variable
90         returns (string _role)
91     {
92         return privilegeStatus[_addr];
93     }
94 }
95 
96 contract CoinMarketAlert is Administration {
97     using SafeMath for uint256;
98 
99     address[]   public      userAddresses;
100     uint256     public      totalSupply;
101     uint256     public      usersRegistered;
102     uint8       public      decimals;
103     string      public      name;
104     string      public      symbol;
105     bool        public      tokenTransfersFrozen;
106     bool        public      tokenMintingEnabled;
107     bool        public      contractLaunched;
108 
109 
110     struct AlertCreatorStruct {
111         address alertCreator;
112         uint256 alertsCreated;
113     }
114 
115     AlertCreatorStruct[]   public      alertCreators;
116     
117     // Alert Creator Entered (Used to prevetnt duplicates in creator array)
118     mapping (address => bool) public userRegistered;
119     // Tracks approval
120     mapping (address => mapping (address => uint256)) public allowance;
121     //[addr][balance]
122     mapping (address => uint256) public balances;
123 
124     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
125     event Approve(address indexed _owner, address indexed _spender, uint256 _amount);
126     event MintTokens(address indexed _minter, uint256 _amountMinted, bool indexed Minted);
127     event FreezeTransfers(address indexed _freezer, bool indexed _frozen);
128     event ThawTransfers(address indexed _thawer, bool indexed _thawed);
129     event TokenBurn(address indexed _burner, uint256 _amount, bool indexed _burned);
130     event EnableTokenMinting(bool Enabled);
131 
132     function CoinMarketAlert()
133         public {
134         symbol = "CMA";
135         name = "Coin Market Alert";
136         decimals = 18;
137         // 50 Mil in wei
138         totalSupply = 50000000000000000000000000;
139         balances[msg.sender] = 50000000000000000000000000;
140         tokenTransfersFrozen = true;
141         tokenMintingEnabled = false;
142     }
143 
144     /// @notice Used to launch start the contract
145     function launchContract()
146         public
147         onlyAdmin
148         returns (bool launched)
149     {
150         require(!contractLaunched);
151         tokenTransfersFrozen = false;
152         tokenMintingEnabled = true;
153         contractLaunched = true;
154         EnableTokenMinting(true);
155         return true;
156     }
157     
158     /// @dev keeps a list of addresses that are participating in the site
159     function registerUser(address _user) 
160         private
161         returns (bool registered)
162     {
163         usersRegistered = usersRegistered.add(1);
164         AlertCreatorStruct memory acs;
165         acs.alertCreator = _user;
166         alertCreators.push(acs);
167         userAddresses.push(_user);
168         userRegistered[_user] = true;
169         return true;
170     }
171 
172     /// @notice Manual payout for site users
173     /// @param _user Ethereum address of the user
174     /// @param _amount The mount of CMA tokens in wei to send
175     function singlePayout(address _user, uint256 _amount)
176         public
177         onlyAdmin
178         returns (bool paid)
179     {
180         require(!tokenTransfersFrozen);
181         require(_amount > 0);
182         require(transferCheck(owner, _user, _amount));
183         if (!userRegistered[_user]) {
184             registerUser(_user);
185         }
186         balances[_user] = balances[_user].add(_amount);
187         balances[owner] = balances[owner].add(_amount);
188         Transfer(owner, _user, _amount);
189         return true;
190     }
191 
192     /// @dev low-level minting function not accessible externally
193     function tokenMint(address _invoker, uint256 _amount) 
194         private
195         returns (bool raised)
196     {
197         require(balances[owner].add(_amount) > balances[owner]);
198         require(balances[owner].add(_amount) > 0);
199         require(totalSupply.add(_amount) > 0);
200         require(totalSupply.add(_amount) > totalSupply);
201         totalSupply = totalSupply.add(_amount);
202         balances[owner] = balances[owner].add(_amount);
203         MintTokens(_invoker, _amount, true);
204         return true;
205     }
206 
207     /// @notice Used to mint tokens, only usable by the contract owner
208     /// @param _amount The amount of CMA tokens in wei to mint
209     function tokenFactory(uint256 _amount)
210         public
211         onlyAdmin
212         returns (bool success)
213     {
214         require(_amount > 0);
215         require(tokenMintingEnabled);
216         require(tokenMint(msg.sender, _amount));
217         return true;
218     }
219 
220     /// @notice Used to burn tokens
221     /// @param _amount The amount of CMA tokens in wei to burn
222     function tokenBurn(uint256 _amount)
223         public
224         onlyAdmin
225         returns (bool burned)
226     {
227         require(_amount > 0);
228         require(_amount < totalSupply);
229         require(balances[owner] > _amount);
230         require(balances[owner].sub(_amount) >= 0);
231         require(totalSupply.sub(_amount) >= 0);
232         balances[owner] = balances[owner].sub(_amount);
233         totalSupply = totalSupply.sub(_amount);
234         TokenBurn(msg.sender, _amount, true);
235         return true;
236     }
237 
238     /// @notice Used to freeze token transfers
239     function freezeTransfers()
240         public
241         onlyAdmin
242         returns (bool frozen)
243     {
244         tokenTransfersFrozen = true;
245         FreezeTransfers(msg.sender, true);
246         return true;
247     }
248 
249     /// @notice Used to thaw token transfers
250     function thawTransfers()
251         public
252         onlyAdmin
253         returns (bool thawed)
254     {
255         tokenTransfersFrozen = false;
256         ThawTransfers(msg.sender, true);
257         return true;
258     }
259 
260     /// @notice Used to transfer funds
261     /// @param _receiver The destination ethereum address
262     /// @param _amount The amount of CMA tokens in wei to send
263     function transfer(address _receiver, uint256 _amount)
264         public
265         returns (bool _transferred)
266     {
267         require(!tokenTransfersFrozen);
268         require(transferCheck(msg.sender, _receiver, _amount));
269         balances[msg.sender] = balances[msg.sender].sub(_amount);
270         balances[_receiver] = balances[_receiver].add(_amount);
271         Transfer(msg.sender, _receiver, _amount);
272         return true;
273     }
274 
275     /// @notice Used to transfer funds on behalf of one person
276     /// @param _owner Person you are allowed to spend funds on behalf of
277     /// @param _receiver Person to receive the funds
278     /// @param _amount Amoun of CMA tokens in wei to send
279     function transferFrom(address _owner, address _receiver, uint256 _amount)
280         public
281         returns (bool _transferredFrom)
282     {
283         require(!tokenTransfersFrozen);
284         require(allowance[_owner][msg.sender].sub(_amount) >= 0);
285         require(transferCheck(_owner, _receiver, _amount));
286         balances[_owner] = balances[_owner].sub(_amount);
287         balances[_receiver] = balances[_receiver].add(_amount);
288         allowance[_owner][_receiver] = allowance[_owner][_receiver].sub(_amount);
289         Transfer(_owner, _receiver, _amount);
290         return true;
291     }
292 
293     /// @notice Used to approve a third-party to send funds on your behalf
294     /// @param _spender The person you are allowing to spend on your behalf
295     /// @param _amount The amount of CMA tokens in wei they are allowed to spend
296     function approve(address _spender, uint256 _amount)
297         public
298         returns (bool approved)
299     {
300         require(_amount > 0);
301         require(balances[msg.sender] > 0);
302         allowance[msg.sender][_spender] = _amount;
303         Approve(msg.sender, _spender, _amount);
304         return true;
305     }
306 
307      //GETTERS//
308     ///////////
309 
310     
311     /// @dev low level function used to do a sanity check of input data for CMA token transfers
312     /// @param _sender This is the msg.sender, the person sending the CMA tokens
313     /// @param _receiver This is the address receiving the CMA tokens
314     /// @param _value This is the amount of CMA tokens in wei to send
315     function transferCheck(address _sender, address _receiver, uint256 _value) 
316         private
317         view
318         returns (bool safe) 
319     {
320         require(_value > 0);
321         require(_receiver != address(0));
322         require(balances[_sender].sub(_value) >= 0);
323         require(balances[_receiver].add(_value) > balances[_receiver]);
324         return true;
325     }
326 
327     /// @notice Used to retrieve total supply
328     function totalSupply()
329         public
330         view
331         returns (uint256 _totalSupply)
332     {
333         return totalSupply;
334     }
335 
336     /// @notice Used to look up balance of a user
337     function balanceOf(address _person)
338         public
339         view
340         returns (uint256 balance)
341     {
342         return balances[_person];
343     }
344 
345     /// @notice Used to look up allowance of a user
346     function allowance(address _owner, address _spender)
347         public
348         view
349         returns (uint256 allowed)
350     {
351         return allowance[_owner][_spender];
352     }
353 }