1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 result = a * b;
6         assert(a == 0 || result / a == b);
7         return result;
8     }
9  
10     function div(uint256 a, uint256 b)internal pure returns (uint256) {
11         uint256 result = a / b;
12         return result;
13     }
14  
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a); 
17         return a - b; 
18     } 
19   
20     function add(uint256 a, uint256 b) internal pure returns (uint256) { 
21         uint256 result = a + b; 
22         assert(result >= a);
23         return result;
24     }
25  
26 }
27 
28 contract ERC20Basic {
29     uint256 public totalSupply;
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     function balanceOf(address who) public view returns(uint256);
32     function transfer(address to, uint256 value) public returns(bool);
33 }
34 
35 contract ERC20 is ERC20Basic {
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37     function allowance(address owner, address spender) public view returns (uint256);
38     function approve(address spender, uint256 value) public returns (bool);
39     function transferFrom(address from, address to, uint256 value) public returns (bool);
40 }
41 
42 contract BasicToken is ERC20Basic {
43     using SafeMath for uint256;
44 
45     struct WalletData {
46         uint256 tokensAmount;  //Tokens amount on wallet
47         uint256 freezedAmount;  //Freezed tokens amount on wallet.
48         bool canFreezeTokens;  //Is wallet can freeze tokens or not.
49         uint unfreezeDate; // Date when we can unfreeze tokens on wallet.
50     }
51    
52     mapping(address => WalletData) wallets;
53 
54     function transfer(address _to, uint256 _value) public notSender(_to) returns(bool) {    
55         require(_to != address(0) 
56         && wallets[msg.sender].tokensAmount >= _value 
57         && checkIfCanUseTokens(msg.sender, _value)); 
58 
59         uint256 amount = wallets[msg.sender].tokensAmount.sub(_value);
60         wallets[msg.sender].tokensAmount = amount;
61         wallets[_to].tokensAmount = wallets[_to].tokensAmount.add(_value);
62         
63         emit Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function balanceOf(address _owner) public view returns(uint256 balance) {
68         return wallets[_owner].tokensAmount;
69     }
70     // Check wallet on unfreeze tokens amount
71     function checkIfCanUseTokens(address _owner, uint256 _amount) internal view returns(bool) {
72         uint256 unfreezedAmount = wallets[_owner].tokensAmount - wallets[_owner].freezedAmount;
73         return _amount <= unfreezedAmount;
74     }
75     
76     // Prevents user to send transaction on his own address
77     modifier notSender(address _owner) {
78         require(msg.sender != _owner);
79         _;
80     }
81 }
82 
83 contract StandartToken is ERC20, BasicToken{
84     mapping (address => mapping (address => uint256)) allowed;
85   
86     function approve(address _spender, uint256 _value) public returns (bool) { 
87         allowed[msg.sender][_spender] = _value; 
88         emit Approval(msg.sender, _spender, _value); 
89         return true; 
90     }
91   
92     function allowance(address _owner, address _spender) public view returns (uint256 remaining) { 
93         return allowed[_owner][_spender]; 
94     } 
95   
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
97         require(_to != address(0) &&
98         checkIfCanUseTokens(_from, _value) &&
99         _value <= wallets[_from].tokensAmount &&
100         _value <= allowed[_from][msg.sender]); 
101         wallets[_from].tokensAmount = wallets[_from].tokensAmount.sub(_value); 
102         wallets[_to].tokensAmount = wallets[_to].tokensAmount.add(_value); 
103         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
104         emit Transfer(_from, _to, _value); 
105         return true; 
106    } 
107     
108 }
109 
110 contract Ownable {
111     
112     constructor() public {
113         owner = msg.sender;
114     }
115 
116     event TransferOwnership(address indexed _previousOwner, address indexed _newOwner);
117     address public owner = 0x0;
118     //wallet that can change owner
119     address internal masterKey = 0x4977A392d8D207B49c7fDE8A6B91C23bCebE7291;
120    
121     function transferOwnership(address _newOwner) public returns(bool);
122     
123     modifier onlyOwner() {
124         require(msg.sender == owner);
125         _;
126     }
127 }
128 
129 contract FreezableToken is StandartToken, Ownable {
130     event ChangeFreezePermission(address indexed _owner, bool _permission);
131     event FreezeTokens(address indexed _owner, uint256 _freezeAmount);
132     event UnfreezeTokens(address indexed _owner, uint256 _unfreezeAmount);
133     
134     // Give\deprive permission to a wallet for freeze tokens.
135     function giveFreezePermission(address[] _owners, bool _permission) public onlyOwner returns(bool) {
136         for (uint i = 0; i < _owners.length; i++) {
137         wallets[_owners[i]].canFreezeTokens = _permission;
138         emit ChangeFreezePermission(_owners[i], _permission);
139         }
140         return true;
141     }
142     
143     function freezeAllowance(address _owner) public view returns(bool) { 
144         return wallets[_owner].canFreezeTokens;   
145     }
146     // Freeze tokens on sender wallet if have permission.
147     function freezeTokens(uint256 _amount, uint _unfreezeDate) public isFreezeAllowed returns(bool) {
148         //We can freeze tokens only if there are no frozen tokens on the wallet.
149         require(wallets[msg.sender].freezedAmount == 0
150         && wallets[msg.sender].tokensAmount >= _amount); 
151         wallets[msg.sender].freezedAmount = _amount;
152         wallets[msg.sender].unfreezeDate = _unfreezeDate;
153         emit FreezeTokens(msg.sender, _amount);
154         return true;
155     }
156     
157     function showFreezedTokensAmount(address _owner) public view returns(uint256) {
158         return wallets[_owner].freezedAmount;
159     }
160     
161     function unfreezeTokens() public returns(bool) {
162         require(wallets[msg.sender].freezedAmount > 0
163         && now >= wallets[msg.sender].unfreezeDate);
164         emit UnfreezeTokens(msg.sender, wallets[msg.sender].freezedAmount);
165         wallets[msg.sender].freezedAmount = 0; // Unfreeze all tokens.
166         wallets[msg.sender].unfreezeDate = 0;
167         return true;
168     }
169     //Show date in UNIX time format.
170     function showTokensUnfreezeDate(address _owner) public view returns(uint) {
171         //If wallet don't have freezed tokens - function will return 0.
172         return wallets[_owner].unfreezeDate;
173     }
174     
175     function getUnfreezedTokens(address _owner) internal view returns(uint256) {
176         return wallets[_owner].tokensAmount - wallets[_owner].freezedAmount;
177     }
178     
179     modifier isFreezeAllowed() {
180         require(freezeAllowance(msg.sender));
181         _;
182     }
183 }
184 
185 contract MultisendableToken is FreezableToken {
186 
187     function massTransfer(address[] _addresses, uint[] _values) public onlyOwner returns(bool) {
188         for (uint i = 0; i < _addresses.length; i++) {
189             transferFromOwner(_addresses[i], _values[i]);
190         }
191         return true;
192     }
193 
194     function massApprove(address[] _spenders, uint256[] _values) public returns (bool succes) {
195         for(uint i = 0; i < _spenders.length; i++) {
196         approve(_spenders[i], _values[i]);
197         }
198         return true;
199     }
200 
201     function transferFromOwner(address _to, uint256 _value) internal notSender(_to) onlyOwner {
202         require(_to != address(0)
203         && wallets[owner].tokensAmount >= _value
204         && checkIfCanUseTokens(owner, _value));
205         wallets[owner].tokensAmount = wallets[owner].tokensAmount.sub(_value); 
206         wallets[_to].tokensAmount = wallets[_to].tokensAmount.add(_value);
207         emit Transfer(owner, _to, _value);
208     }
209     
210 }
211 
212 contract CryptosoulToken is MultisendableToken {
213     
214     event AllowMinting();
215     event Burn(address indexed _from, uint256 _value);
216     event Mint(address indexed _to, uint256 _value);
217     
218     string constant public name = "CryptoSoul";
219     string constant public symbol = "SOUL";
220     uint constant public decimals = 18;
221     
222     uint256 constant public START_TOKENS = 500000000 * 10**decimals; //500M start
223     uint256 constant public MINT_AMOUNT = 1370000 * 10**decimals;
224     uint256 constant public MINT_INTERVAL = 1 days; // 24 hours
225     uint256 constant private MAX_BALANCE_VALUE = 10000000000 * 10**decimals;
226     
227     uint256 public nextMintPossibleDate = 0;
228     bool public canMint = false;
229     
230     constructor() public {
231         wallets[owner].tokensAmount = START_TOKENS;
232         wallets[owner].canFreezeTokens = true;
233         totalSupply = START_TOKENS;
234         nextMintPossibleDate = 1538352000; //01.10.2018 (DD, MM, YYYY)
235         emit Mint(owner, START_TOKENS);
236     }
237 
238     function allowMinting() public onlyOwner {
239         // Can start minting token after 01.10.2018
240         require(!canMint
241         && now >= nextMintPossibleDate);
242         nextMintPossibleDate = now;
243         canMint = true;
244         emit AllowMinting();
245     }
246 
247     function mint() public onlyOwner returns(bool) {
248         require(canMint
249         && now >= nextMintPossibleDate
250         && totalSupply + MINT_AMOUNT <= MAX_BALANCE_VALUE);
251         nextMintPossibleDate = nextMintPossibleDate.add(MINT_INTERVAL);
252         wallets[owner].tokensAmount = wallets[owner].tokensAmount.
253                                              add(MINT_AMOUNT);  
254         totalSupply = totalSupply.add(MINT_AMOUNT);
255         emit Mint(owner, MINT_AMOUNT);
256         return true;
257     }
258 
259     function burn(uint256 value) public onlyOwner returns(bool) {
260         require(checkIfCanUseTokens(owner, value)
261         && wallets[owner].tokensAmount >= value);
262         wallets[owner].tokensAmount = wallets[owner].
263                                              tokensAmount.sub(value);
264         totalSupply = totalSupply.sub(value);                             
265         emit Burn(owner, value);
266         return true;
267     }
268     
269     function transferOwnership(address _newOwner) public notSender(_newOwner) returns(bool) {
270         require(msg.sender == masterKey 
271         && _newOwner != address(0));
272         emit TransferOwnership(owner, _newOwner);
273         owner = _newOwner;
274         return true;
275     }
276     
277     function() public payable {
278         revert();
279     }
280 }