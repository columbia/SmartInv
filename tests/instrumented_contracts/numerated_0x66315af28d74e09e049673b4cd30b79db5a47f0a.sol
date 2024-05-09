1 pragma solidity 0.4.16;
2 
3 // implement safemath as a library
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     require(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     require(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     require(c >= a);
25     return c;
26   }
27 }
28 
29 // Used for function invoke restriction
30 contract Owned {
31 
32     address public owner; // temporary address
33 
34     function Owned() {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         if (msg.sender != owner)
40             revert();
41         _; // function code inserted here
42     }
43 
44     function transferOwnership(address _newOwner) onlyOwner returns (bool success) {
45         if (msg.sender != owner)
46             revert();
47         owner = _newOwner;
48         return true;
49         
50     }
51 }
52 
53 contract Vezt is Owned {
54     using SafeMath for uint256;
55 
56     address[]   public  veztUsers;
57     uint256     public  totalSupply;
58     uint8       public  decimals;
59     string      public  name;
60     string      public  symbol;
61     bool        public  tokenTransfersFrozen;
62     bool        public  tokenMintingEnabled;
63     bool        public  contractLaunched;
64 
65     mapping (address => mapping (address => uint256))   public allowance;
66     mapping (address => uint256)                        public balances;
67     mapping (address => uint256)                        public royaltyTracking;
68     mapping (address => uint256)                        public icoBalances;
69     mapping (address => uint256)                        public veztUserArrayIdentifier;
70     mapping (address => bool)                           public veztUserRegistered;
71 
72     event Transfer(address indexed _sender, address indexed _recipient, uint256 _amount);
73     event Approve(address indexed _owner, address indexed _spender, uint256 _amount);
74     event LaunchContract(address indexed _launcher, bool _launched);
75     event FreezeTokenTransfers(address indexed _invoker, bool _frozen);
76     event ThawTokenTransfers(address indexed _invoker, bool _thawed);
77     event MintTokens(address indexed _minter, uint256 _amount, bool indexed _minted);
78     event TokenMintingDisabled(address indexed _invoker, bool indexed _disabled);
79     event TokenMintingEnabled(address indexed _invoker, bool indexed _enabled);
80 
81     function Vezt() {
82         name = "Vezt";
83         symbol = "VZT";
84         decimals = 18;
85         //125 million in wei 
86         totalSupply = 125000000000000000000000000;
87         balances[msg.sender] = balances[msg.sender].add(totalSupply);
88         tokenTransfersFrozen = true;
89         tokenMintingEnabled = false;
90         contractLaunched = false;
91     }
92 
93     /// @notice Used to log royalties
94     /// @param _receiver The eth address of person to receive VZT Tokens
95     /// @param _amount The amount of VZT Tokens in wei to send
96     function logRoyalty(address _receiver, uint256 _amount)
97         onlyOwner
98         public 
99         returns (bool logged)
100     {
101         require(transferCheck(msg.sender, _receiver, _amount));
102         if (!veztUserRegistered[_receiver]) {
103             veztUsers.push(_receiver);
104             veztUserRegistered[_receiver] = true;
105         }
106         require(royaltyTracking[_receiver].add(_amount) > 0);
107         require(royaltyTracking[_receiver].add(_amount) > royaltyTracking[_receiver]);
108         royaltyTracking[_receiver] = royaltyTracking[_receiver].add(_amount);
109         balances[msg.sender] = balances[msg.sender].sub(_amount);
110         balances[_receiver] = balances[_receiver].add(_amount);
111         Transfer(owner, _receiver, _amount);
112         return true;
113     }
114 
115     function transactionReplay(address _receiver, uint256 _amount)
116         onlyOwner
117         public
118         returns (bool replayed)
119     {
120         require(transferCheck(msg.sender, _receiver, _amount));
121         balances[msg.sender] = balances[msg.sender].sub(_amount);
122         balances[_receiver] = balances[_receiver].add(_amount);
123         Transfer(msg.sender, _receiver, _amount);
124         return true;
125     }
126 
127     /// @notice Used to launch the contract, and enabled token minting
128     function launchContract() onlyOwner {
129         require(!contractLaunched);
130         tokenTransfersFrozen = false;
131         tokenMintingEnabled = true;
132         contractLaunched = true;
133         LaunchContract(msg.sender, true);
134     }
135 
136     function disableTokenMinting() onlyOwner returns (bool disabled) {
137         tokenMintingEnabled = false;
138         TokenMintingDisabled(msg.sender, true);
139         return true;
140     }
141 
142     function enableTokenMinting() onlyOwner returns (bool enabled) {
143         tokenMintingEnabled = true;
144         TokenMintingEnabled(msg.sender, true);
145         return true;
146     }
147 
148     function freezeTokenTransfers() onlyOwner returns (bool success) {
149         tokenTransfersFrozen = true;
150         FreezeTokenTransfers(msg.sender, true);
151         return true;
152     }
153 
154     function thawTokenTransfers() onlyOwner returns (bool success) {
155         tokenTransfersFrozen = false;
156         ThawTokenTransfers(msg.sender, true);
157         return true;
158     }
159 
160     /// @notice Used to transfer funds
161     /// @param _receiver Eth address to send VZT tokens too
162     /// @param _amount The amount of VZT tokens in wei to send
163     function transfer(address _receiver, uint256 _amount)
164         public
165         returns (bool success)
166     {
167         require(transferCheck(msg.sender, _receiver, _amount));
168         balances[msg.sender] = balances[msg.sender].sub(_amount);
169         balances[_receiver] = balances[_receiver].add(_amount);
170         Transfer(msg.sender, _receiver, _amount);
171         return true;
172     }
173 
174     /// @notice Used to transfer funds on behalf of owner to receiver
175     /// @param _owner The person you are allowed to sends funds on bhhalf of
176     /// @param _receiver The person to receive the funds
177     /// @param _amount The amount of VZT tokens in wei to send
178     function transferFrom(address _owner, address _receiver, uint256 _amount) 
179         public 
180         returns (bool success)
181     {
182         require(allowance[_owner][msg.sender] >= _amount);
183         require(transferCheck(_owner, _receiver, _amount));
184         allowance[_owner][msg.sender] = allowance[_owner][msg.sender].sub(_amount);
185         balances[_owner] =  balances[_owner].sub(_amount);
186         balances[_receiver] = balances[_receiver].add(_amount);
187         Transfer(_owner, _receiver, _amount);
188         return true;
189     }
190 
191     /// @notice Used to approve someone to send funds on your behalf
192     /// @param _spender The eth address of the person you are approving
193     /// @param _amount The amount of VZT tokens _spender is allowed to send (in wei)
194     function approve(address _spender, uint256 _amount)
195         public
196         returns (bool approved)
197     {
198         require(_amount > 0);
199         require(balances[msg.sender] >= _amount);
200         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_amount);
201         return true;
202     }
203 
204     /// @notice Used to burn tokens and decrease total supply
205     /// @param _amount The amount of VZT tokens in wei to burn
206     function tokenBurner(uint256 _amount)
207         onlyOwner
208         returns (bool burned)
209     {
210         require(_amount > 0);
211         require(totalSupply.sub(_amount) > 0);
212         require(balances[msg.sender] > _amount);
213         require(balances[msg.sender].sub(_amount) > 0);
214         totalSupply = totalSupply.sub(_amount);
215         balances[msg.sender] = balances[msg.sender].sub(_amount);
216         Transfer(msg.sender, 0, _amount);
217         return true;
218     }
219 
220     /// @notice Low level function Used to create new tokens and increase total supply
221     /// @param _amount The amount of VZT tokens in wei to create
222     function tokenMinter(uint256 _amount)
223         private
224         returns (bool minted)
225     {
226         require(tokenMintingEnabled);
227         require(_amount > 0);
228         require(totalSupply.add(_amount) > 0);
229         require(totalSupply.add(_amount) > totalSupply);
230         require(balances[owner].add(_amount) > 0);
231         require(balances[owner].add(_amount) > balances[owner]);
232         return true;
233     }
234     /// @notice Used to create new tokens and increase total supply
235     /// @param _amount The amount of VZT tokens in wei to create
236     function tokenFactory(uint256 _amount) 
237         onlyOwner
238         returns (bool success)
239     {
240         require(tokenMinter(_amount));
241         totalSupply = totalSupply.add(_amount);
242         balances[msg.sender] = balances[msg.sender].add(_amount);
243         Transfer(0, msg.sender, _amount);
244         return true;
245     }
246 
247     // GETTER //
248 
249     function lookupRoyalty(address _veztUser)
250         public
251         constant
252         returns (uint256 royalties)
253     {
254         return royaltyTracking[_veztUser];
255     }
256 
257     /// @notice Reusable code to do sanity check of transfer variables
258     function transferCheck(address _sender, address _receiver, uint256 _amount)
259         private
260         constant
261         returns (bool success)
262     {
263         require(!tokenTransfersFrozen);
264         require(_amount > 0);
265         require(_receiver != address(0));
266         require(balances[_sender].sub(_amount) >= 0);
267         require(balances[_receiver].add(_amount) > 0);
268         require(balances[_receiver].add(_amount) > balances[_receiver]);
269         return true;
270     }
271 
272     /// @notice Used to retrieve total supply
273     function totalSupply() 
274         public
275         constant
276         returns (uint256 _totalSupply)
277     {
278         return totalSupply;
279     }
280 
281     /// @notice Used to look up balance of a person
282     function balanceOf(address _person)
283         public
284         constant
285         returns (uint256 _balance)
286     {
287         return balances[_person];
288     }
289 
290     /// @notice Used to look up the allowance of someone
291     function allowance(address _owner, address _spender)
292         public
293         constant 
294         returns (uint256 _amount)
295     {
296         return allowance[_owner][_spender];
297     }
298 }