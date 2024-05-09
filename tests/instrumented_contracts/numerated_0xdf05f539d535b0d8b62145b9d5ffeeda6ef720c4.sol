1 pragma solidity 0.4.18;
2 
3 library SafeMath {
4 
5   // We use `pure` bbecause it promises that the value for the function depends ONLY
6   // on the function arguments
7   function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
8     uint256 c = a * b;
9     require(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     require(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     require(c >= a);
26     return c;
27   }
28 }
29 
30 contract Administration {
31 
32     address     public owner;
33     
34     mapping (address => bool) public moderators;
35     mapping (address => string) privilegeStatus;
36 
37     event AddMod(address indexed _invoker, address indexed _newMod, bool indexed _modAdded);
38     event RemoveMod(address indexed _invoker, address indexed _removeMod, bool indexed _modRemoved);
39 
40     function Administration() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyAdmin() {
45         require(msg.sender == owner || moderators[msg.sender] == true);
46         _;
47     }
48 
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner)
55         public
56         onlyOwner
57         returns (bool success)
58     {
59         owner = _newOwner;
60         return true;
61         
62     }
63 
64     function addModerator(address _newMod)
65         public
66         onlyOwner
67         returns (bool added)
68      {
69         require(_newMod != address(0x0));
70         moderators[_newMod] = true;
71         AddMod(msg.sender, _newMod, true);
72         return true;
73     }
74     
75     function removeModerator(address _removeMod)
76         public
77         onlyOwner
78         returns (bool removed)
79     {
80         require(_removeMod != address(0x0));
81         moderators[_removeMod] = false;
82         RemoveMod(msg.sender, _removeMod, true);
83         return true;
84     }
85 
86     function getRoleStatus(address _addr)
87         public
88         view  // We use view as we promise to not change state, but are reading from a state variable
89         returns (string _role)
90     {
91         return privilegeStatus[_addr];
92     }
93 }
94 
95 contract CoinMarketAlert is Administration {
96     using SafeMath for uint256;
97 
98     address[]   public      userAddresses;
99     uint256     public      totalSupply;
100     uint256     public      usersRegistered;
101     uint8       public      decimals;
102     string      public      name;
103     string      public      symbol;
104     bool        public      tokenTransfersFrozen;
105     bool        public      tokenMintingEnabled;
106     bool        public      contractLaunched;
107 
108 
109     struct AlertCreatorStruct {
110         address alertCreator;
111         uint256 alertsCreated;
112     }
113 
114     AlertCreatorStruct[]   public      alertCreators;
115     
116     // Alert Creator Entered (Used to prevetnt duplicates in creator array)
117     mapping (address => bool) public userRegistered;
118     // Tracks approval
119     mapping (address => mapping (address => uint256)) public allowance;
120     //[addr][balance]
121     mapping (address => uint256) public balances;
122 
123     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
124     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
125     event MintTokens(address indexed _minter, uint256 _amountMinted, bool indexed Minted);
126     event FreezeTransfers(address indexed _freezer, bool indexed _frozen);
127     event ThawTransfers(address indexed _thawer, bool indexed _thawed);
128     event TokenBurn(address indexed _burner, uint256 _amount, bool indexed _burned);
129     event EnableTokenMinting(bool Enabled);
130 
131     function CoinMarketAlert()
132         public {
133         symbol = "CMA";
134         name = "Coin Market Alert";
135         decimals = 18;
136         // 50 Mil in wei
137         totalSupply = 50000000000000000000000000;
138         balances[msg.sender] = 50000000000000000000000000;
139         tokenTransfersFrozen = true;
140         tokenMintingEnabled = false;
141     }
142 
143     /// @notice Used to launch start the contract
144     function launchContract()
145         public
146         onlyAdmin
147         returns (bool launched)
148     {
149         require(!contractLaunched);
150         tokenTransfersFrozen = false;
151         tokenMintingEnabled = true;
152         contractLaunched = true;
153         EnableTokenMinting(true);
154         return true;
155     }
156     
157     /// @dev keeps a list of addresses that are participating in the site
158     function registerUser(address _user) 
159         private
160         returns (bool registered)
161     {
162         usersRegistered = usersRegistered.add(1);
163         AlertCreatorStruct memory acs;
164         acs.alertCreator = _user;
165         alertCreators.push(acs);
166         userAddresses.push(_user);
167         userRegistered[_user] = true;
168         return true;
169     }
170 
171     /// @notice Manual payout for site users
172     /// @param _user Ethereum address of the user
173     /// @param _amount The mount of CMA tokens in wei to send
174     function singlePayout(address _user, uint256 _amount)
175         public
176         onlyAdmin
177         returns (bool paid)
178     {
179         require(!tokenTransfersFrozen);
180         require(_amount > 0);
181         require(transferCheck(owner, _user, _amount));
182         if (!userRegistered[_user]) {
183             registerUser(_user);
184         }
185         balances[_user] = balances[_user].add(_amount);
186         balances[owner] = balances[owner].add(_amount);
187         Transfer(owner, _user, _amount);
188         return true;
189     }
190 
191     /// @dev low-level minting function not accessible externally
192     function tokenMint(address _invoker, uint256 _amount) 
193         private
194         returns (bool raised)
195     {
196         require(balances[owner].add(_amount) > balances[owner]);
197         require(balances[owner].add(_amount) > 0);
198         require(totalSupply.add(_amount) > 0);
199         require(totalSupply.add(_amount) > totalSupply);
200         totalSupply = totalSupply.add(_amount);
201         balances[owner] = balances[owner].add(_amount);
202         MintTokens(_invoker, _amount, true);
203         return true;
204     }
205 
206     /// @notice Used to mint tokens, only usable by the contract owner
207     /// @param _amount The amount of CMA tokens in wei to mint
208     function tokenFactory(uint256 _amount)
209         public
210         onlyAdmin
211         returns (bool success)
212     {
213         require(_amount > 0);
214         require(tokenMintingEnabled);
215         require(tokenMint(msg.sender, _amount));
216         return true;
217     }
218 
219     /// @notice Used to burn tokens
220     /// @param _amount The amount of CMA tokens in wei to burn
221     function tokenBurn(uint256 _amount)
222         public
223         onlyAdmin
224         returns (bool burned)
225     {
226         require(_amount > 0);
227         require(_amount < totalSupply);
228         require(balances[owner] > _amount);
229         require(balances[owner].sub(_amount) >= 0);
230         require(totalSupply.sub(_amount) >= 0);
231         balances[owner] = balances[owner].sub(_amount);
232         totalSupply = totalSupply.sub(_amount);
233         TokenBurn(msg.sender, _amount, true);
234         return true;
235     }
236 
237     /// @notice Used to freeze token transfers
238     function freezeTransfers()
239         public
240         onlyAdmin
241         returns (bool frozen)
242     {
243         tokenTransfersFrozen = true;
244         FreezeTransfers(msg.sender, true);
245         return true;
246     }
247 
248     /// @notice Used to thaw token transfers
249     function thawTransfers()
250         public
251         onlyAdmin
252         returns (bool thawed)
253     {
254         tokenTransfersFrozen = false;
255         ThawTransfers(msg.sender, true);
256         return true;
257     }
258 
259     /// @notice Used to transfer funds
260     /// @param _receiver The destination ethereum address
261     /// @param _amount The amount of CMA tokens in wei to send
262     function transfer(address _receiver, uint256 _amount)
263         public
264         returns (bool _transferred)
265     {
266         require(!tokenTransfersFrozen);
267         require(transferCheck(msg.sender, _receiver, _amount));
268         balances[msg.sender] = balances[msg.sender].sub(_amount);
269         balances[_receiver] = balances[_receiver].add(_amount);
270         Transfer(msg.sender, _receiver, _amount);
271         return true;
272     }
273 
274     /// @notice Used to transfer funds on behalf of one person
275     /// @param _owner Person you are allowed to spend funds on behalf of
276     /// @param _receiver Person to receive the funds
277     /// @param _amount Amoun of CMA tokens in wei to send
278     function transferFrom(address _owner, address _receiver, uint256 _amount)
279         public
280         returns (bool _transferredFrom)
281     {
282         require(!tokenTransfersFrozen);
283         require(allowance[_owner][msg.sender].sub(_amount) >= 0);
284         require(transferCheck(_owner, _receiver, _amount));
285         balances[_owner] = balances[_owner].sub(_amount);
286         balances[_receiver] = balances[_receiver].add(_amount);
287         allowance[_owner][msg.sender] = allowance[_owner][msg.sender].sub(_amount);
288         Transfer(_owner, _receiver, _amount);
289         return true;
290     }
291 
292     /// @notice Used to approve a third-party to send funds on your behalf
293     /// @param _spender The person you are allowing to spend on your behalf
294     /// @param _amount The amount of CMA tokens in wei they are allowed to spend
295     function approve(address _spender, uint256 _amount)
296         public
297         returns (bool approved)
298     {
299         require(_amount > 0);
300         require(balances[msg.sender] > 0);
301         allowance[msg.sender][_spender] = _amount;
302         Approval(msg.sender, _spender, _amount);
303         return true;
304     }
305 
306      //GETTERS//
307     ///////////
308 
309     
310     /// @dev low level function used to do a sanity check of input data for CMA token transfers
311     /// @param _sender This is the msg.sender, the person sending the CMA tokens
312     /// @param _receiver This is the address receiving the CMA tokens
313     /// @param _value This is the amount of CMA tokens in wei to send
314     function transferCheck(address _sender, address _receiver, uint256 _value) 
315         private
316         view
317         returns (bool safe) 
318     {
319         require(_value > 0);
320         require(_receiver != address(0));
321         require(balances[_sender].sub(_value) >= 0);
322         require(balances[_receiver].add(_value) > balances[_receiver]);
323         return true;
324     }
325 
326     /// @notice Used to retrieve total supply
327     function totalSupply()
328         public
329         view
330         returns (uint256 _totalSupply)
331     {
332         return totalSupply;
333     }
334 
335     /// @notice Used to look up balance of a user
336     function balanceOf(address _person)
337         public
338         view
339         returns (uint256 balance)
340     {
341         return balances[_person];
342     }
343 
344     /// @notice Used to look up allowance of a user
345     function allowance(address _owner, address _spender)
346         public
347         view
348         returns (uint256 allowed)
349     {
350         return allowance[_owner][_spender];
351     }
352 }