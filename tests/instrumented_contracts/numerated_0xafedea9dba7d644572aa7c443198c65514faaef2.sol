1 pragma solidity 0.4.16;
2 
3 // Used for function invoke restriction
4 contract Owned {
5 
6     address public owner; // temporary address
7 
8     function Owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         if (msg.sender != owner)
14             revert();
15         _; // function code inserted here
16     }
17 
18     function transferOwnership(address _newOwner) onlyOwner returns (bool success) {
19         if (msg.sender != owner)
20             revert();
21         owner = _newOwner;
22         return true;
23         
24     }
25 }
26 
27 contract SafeMath {
28 
29     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
30         uint256 c = a * b;
31         require(a == 0 || c / a == b);
32         return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal constant returns (uint256) {
36         // assert(b > 0); // Solidity automatically throws when dividing by 0
37         uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
43         require(b <= a);
44         return a - b;
45     }
46 
47     function add(uint256 a, uint256 b) internal constant returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a);
50         return c;
51     }
52 }
53 
54 
55 contract CoinMarketAlert is Owned, SafeMath {
56 
57     address[]   public      userAddresses;
58     uint256     public      totalSupply;
59     uint256     public      usersRegistered;
60     uint8       public      decimals;
61     string      public      name;
62     string      public      symbol;
63     bool        public      tokenTransfersFrozen;
64     bool        public      tokenMintingEnabled;
65     bool        public      contractLaunched;
66 
67 
68     struct AlertCreatorStruct {
69         address alertCreator;
70         uint256 alertsCreated;
71     }
72 
73     AlertCreatorStruct[]   public      alertCreators;
74     
75     // Alert Creator Entered (Used to prevetnt duplicates in creator array)
76     mapping (address => bool) public userRegistered;
77     // Tracks approval
78     mapping (address => mapping (address => uint256)) public allowance;
79     //[addr][balance]
80     mapping (address => uint256) public balances;
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
83     event Approve(address indexed _owner, address indexed _spender, uint256 _amount);
84     event MintTokens(address indexed _minter, uint256 _amountMinted, bool indexed Minted);
85     event FreezeTransfers(address indexed _freezer, bool indexed _frozen);
86     event ThawTransfers(address indexed _thawer, bool indexed _thawed);
87     event TokenBurn(address indexed _burner, uint256 _amount, bool indexed _burned);
88     event EnableTokenMinting(bool Enabled);
89 
90     function CoinMarketAlert() {
91         symbol = "CMA";
92         name = "Coin Market Alert";
93         decimals = 18;
94         // 50 Mil in wei
95         totalSupply = 50000000000000000000000000;
96         balances[msg.sender] = add(balances[msg.sender], totalSupply);
97         tokenTransfersFrozen = true;
98         tokenMintingEnabled = false;
99     }
100 
101     /// @notice Used to launch start the contract
102     function launchContract() onlyOwner returns (bool launched) {
103         require(!contractLaunched);
104         tokenTransfersFrozen = false;
105         tokenMintingEnabled = true;
106         contractLaunched = true;
107         EnableTokenMinting(true);
108         return true;
109     }
110     
111     /// @dev keeps a list of addresses that are participating in the site
112     function registerUser(address _user) private returns (bool registered) {
113         usersRegistered = add(usersRegistered, 1);
114         AlertCreatorStruct memory acs;
115         acs.alertCreator = _user;
116         alertCreators.push(acs);
117         userAddresses.push(_user);
118         userRegistered[_user] = true;
119         return true;
120     }
121 
122     /// @notice Manual payout for site users
123     /// @param _user Ethereum address of the user
124     /// @param _amount The mount of CMA tokens in wei to send
125     function singlePayout(address _user, uint256 _amount) onlyOwner returns (bool paid) {
126         require(!tokenTransfersFrozen);
127         require(_amount > 0);
128         require(transferCheck(owner, _user, _amount));
129         if (!userRegistered[_user]) {
130             registerUser(_user);
131         }
132         balances[_user] = add(balances[_user], _amount);
133         balances[owner] = sub(balances[owner], _amount);
134         Transfer(owner, _user, _amount);
135         return true;
136     }
137 
138     /// @dev low-level minting function not accessible externally
139     function tokenMint(address _invoker, uint256 _amount) private returns (bool raised) {
140         require(add(balances[owner], _amount) > balances[owner]);
141         require(add(balances[owner], _amount) > 0);
142         require(add(totalSupply, _amount) > 0);
143         require(add(totalSupply, _amount) > totalSupply);
144         totalSupply = add(totalSupply, _amount);
145         balances[owner] = add(balances[owner], _amount);
146         MintTokens(_invoker, _amount, true);
147         return true;
148     }
149 
150     /// @notice Used to mint tokens, only usable by the contract owner
151     /// @param _amount The amount of CMA tokens in wei to mint
152     function tokenFactory(uint256 _amount) onlyOwner returns (bool success) {
153         require(_amount > 0);
154         require(tokenMintingEnabled);
155         if (!tokenMint(msg.sender, _amount))
156             revert();
157         return true;
158     }
159 
160     /// @notice Used to burn tokens
161     /// @param _amount The amount of CMA tokens in wei to burn
162     function tokenBurn(uint256 _amount) onlyOwner returns (bool burned) {
163         require(_amount > 0);
164         require(_amount < totalSupply);
165         require(balances[owner] > _amount);
166         require(sub(balances[owner], _amount) > 0);
167         require(sub(totalSupply, _amount) > 0);
168         balances[owner] = sub(balances[owner], _amount);
169         totalSupply = sub(totalSupply, _amount);
170         TokenBurn(msg.sender, _amount, true);
171         return true;
172     }
173 
174     /// @notice Used to freeze token transfers
175     function freezeTransfers() onlyOwner returns (bool frozen) {
176         tokenTransfersFrozen = true;
177         FreezeTransfers(msg.sender, true);
178         return true;
179     }
180 
181     /// @notice Used to thaw token transfers
182     function thawTransfers() onlyOwner returns (bool thawed) {
183         tokenTransfersFrozen = false;
184         ThawTransfers(msg.sender, true);
185         return true;
186     }
187 
188     /// @notice Used to transfer funds
189     /// @param _receiver The destination ethereum address
190     /// @param _amount The amount of CMA tokens in wei to send
191     function transfer(address _receiver, uint256 _amount) {
192         require(!tokenTransfersFrozen);
193         if (transferCheck(msg.sender, _receiver, _amount)) {
194             balances[msg.sender] = sub(balances[msg.sender], _amount);
195             balances[_receiver] = add(balances[_receiver], _amount);
196             Transfer(msg.sender, _receiver, _amount);
197         } else {
198             // ensure we refund gas costs
199             revert();
200         }
201     }
202 
203     /// @notice Used to transfer funds on behalf of one person
204     /// @param _owner Person you are allowed to spend funds on behalf of
205     /// @param _receiver Person to receive the funds
206     /// @param _amount Amoun of CMA tokens in wei to send
207     function transferFrom(address _owner, address _receiver, uint256 _amount) {
208         require(!tokenTransfersFrozen);
209         require(sub(allowance[_owner][msg.sender], _amount) >= 0);
210         if (transferCheck(_owner, _receiver, _amount)) {
211             balances[_owner] = sub(balances[_owner], _amount);
212             balances[_receiver] = add(balances[_receiver], _amount);
213             allowance[_owner][_receiver] = sub(allowance[_owner][_receiver], _amount);
214             Transfer(_owner, _receiver, _amount);
215         } else {
216             // ensure we refund gas costs
217             revert();
218         }
219     }
220 
221     /// @notice Used to approve a third-party to send funds on your behalf
222     /// @param _spender The person you are allowing to spend on your behalf
223     /// @param _amount The amount of CMA tokens in wei they are allowed to spend
224     function approve(address _spender, uint256 _amount) returns (bool approved) {
225         require(_amount > 0);
226         require(balances[msg.sender] > 0);
227         allowance[msg.sender][_spender] = _amount;
228         Approve(msg.sender, _spender, _amount);
229         return true;
230     }
231 
232      //GETTERS//
233     ///////////
234 
235     
236     /// @dev low level function used to do a sanity check of input data for CMA token transfers
237     /// @param _sender This is the msg.sender, the person sending the CMA tokens
238     /// @param _receiver This is the address receiving the CMA tokens
239     /// @param _value This is the amount of CMA tokens in wei to send
240     function transferCheck(address _sender, address _receiver, uint256 _value) 
241         private
242         constant 
243         returns (bool safe) 
244     {
245         require(_value > 0);
246         // prevents empty receiver
247         require(_receiver != address(0));
248         require(sub(balances[_sender], _value) >= 0);
249         require(add(balances[_receiver], _value) > balances[_receiver]);
250         return true;
251     }
252 
253     /// @notice Used to retrieve total supply
254     function totalSupply() constant returns (uint256 _totalSupply) {
255         return totalSupply;
256     }
257 
258     /// @notice Used to look up balance of a user
259     function balanceOf(address _person) constant returns (uint256 balance) {
260         return balances[_person];
261     }
262 
263     /// @notice Used to look up allowance of a user
264     function allowance(address _owner, address _spender) constant returns (uint256 allowed) {
265         return allowance[_owner][_spender];
266     }
267 }