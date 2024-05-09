1 pragma solidity ^0.4.19;
2 library SafeMath {
3     function add(uint a, uint b) internal pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function sub(uint a, uint b) internal pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11     function mul(uint a, uint b) internal pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     function div(uint a, uint b) internal pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }
20 // ----------------------------------------------------------------------------
21 // Based on the final ERC20 specification at:
22 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
23 // ----------------------------------------------------------------------------
24 contract ERC20Interface {
25 
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 
29     function name() public view returns (string);
30     function symbol() public view returns (string);
31     function decimals() public view returns (uint8);
32     function totalSupply() public view returns (uint256);
33 
34     function balanceOf(address _owner) public view returns (uint256 balance);
35     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
36 
37     function transfer(address _to, uint256 _value) public returns (bool success);
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 }
41 
42 contract ERC20Token is ERC20Interface {
43 
44     using SafeMath for uint256;
45 
46     string  private tokenName;
47     string  private tokenSymbol;
48     uint8   private tokenDecimals;
49     uint256 internal tokenTotalSupply;
50     uint256 public publicReservedToken;
51     uint256 public tokenConversionFactor = 10**4;
52     mapping(address => uint256) internal balances;
53 
54     // Owner of account approves the transfer of an amount to another account
55     mapping(address => mapping (address => uint256)) internal allowed;
56 
57 
58     function ERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply,address _publicReserved,uint256 _publicReservedPersentage,address[] boardReserved,uint256[] boardReservedPersentage) public {
59         tokenName = _name;
60         tokenSymbol = _symbol;
61         tokenDecimals = _decimals;
62         tokenTotalSupply = _totalSupply;
63 
64         // The initial Public Reserved balance of tokens is assigned to the given token holder address.
65         // from total supple 90% tokens assign to public reserved  holder
66         publicReservedToken = _totalSupply.mul(_publicReservedPersentage).div(tokenConversionFactor);
67         balances[_publicReserved] = publicReservedToken;
68 
69         //10 persentage token available for board members
70         uint256 boardReservedToken = _totalSupply.sub(publicReservedToken);
71 
72         // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
73         Transfer(0x0, _publicReserved, publicReservedToken);
74 
75         // The initial Board Reserved balance of tokens is assigned to the given token holder address.
76         uint256 persentageSum = 0;
77         for(uint i=0; i<boardReserved.length; i++){
78             //
79             persentageSum = persentageSum.add(boardReservedPersentage[i]);
80             require(persentageSum <= 10000);
81             //assigning board members persentage tokens to particular board member address.
82             uint256 token = boardReservedToken.mul(boardReservedPersentage[i]).div(tokenConversionFactor);
83             balances[boardReserved[i]] = token;
84             Transfer(0x0, boardReserved[i], token);
85         }
86 
87     }
88 
89 
90     function name() public view returns (string) {
91         return tokenName;
92     }
93 
94 
95     function symbol() public view returns (string) {
96         return tokenSymbol;
97     }
98 
99 
100     function decimals() public view returns (uint8) {
101         return tokenDecimals;
102     }
103 
104 
105     function totalSupply() public view returns (uint256) {
106         return tokenTotalSupply;
107     }
108 
109     // Get the token balance for account `tokenOwner`
110     function balanceOf(address _owner) public view returns (uint256 balance) {
111         return balances[_owner];
112     }
113 
114 
115     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
116         return allowed[_owner][_spender];
117     }
118 
119 
120     function transfer(address _to, uint256 _value) public returns (bool success) {
121         uint256 fromBalance = balances[msg.sender];
122         if (fromBalance < _value) return false;
123         if (_value > 0 && msg.sender != _to) {
124           balances[msg.sender] = fromBalance.sub(_value);
125           balances[_to] = balances[_to].add(_value);
126         }
127         Transfer(msg.sender, _to, _value);
128 
129         return true;
130     }
131 
132     // Send `tokens` amount of tokens from address `from` to address `to`
133     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
134     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
135     // fees in sub-currencies; the command should fail unless the _from account has
136     // deliberately authorized the sender of the message via some mechanism; we propose
137     // these standardized APIs for approval:
138     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
139         
140         uint256 spenderAllowance = allowed [_from][msg.sender];
141         if (spenderAllowance < _value) return false;
142         uint256 fromBalance = balances [_from];
143         if (fromBalance < _value) return false;
144     
145         allowed [_from][msg.sender] = spenderAllowance.sub(_value);
146     
147         if (_value > 0 && _from != _to) {
148           balances [_from] = fromBalance.add(_value);
149           balances [_to] = balances[_to].add(_value);
150         }
151 
152         Transfer(_from, _to, _value);
153 
154         return true;
155     }
156 
157     // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
158     // If this function is called again it overwrites the current allowance with _value.
159     function approve(address _spender, uint256 _value) public returns (bool success) {
160         allowed[msg.sender][_spender] = _value;
161 
162         Approval(msg.sender, _spender, _value);
163 
164         return true;
165     }
166 }
167 
168 contract Owned {
169 
170     address public owner;
171     address public proposedOwner = address(0);
172 
173     event OwnershipTransferInitiated(address indexed _proposedOwner);
174     event OwnershipTransferCompleted(address indexed _newOwner);
175     event OwnershipTransferCanceled();
176 
177 
178     function Owned() public
179     {
180         owner = msg.sender;
181     }
182 
183 
184     modifier onlyOwner() {
185         require(isOwner(msg.sender));
186         _;
187     }
188 
189 
190     function isOwner(address _address) public view returns (bool) {
191         return (_address == owner);
192     }
193 
194 
195     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
196         require(_proposedOwner != address(0));
197         require(_proposedOwner != address(this));
198         require(_proposedOwner != owner);
199 
200         proposedOwner = _proposedOwner;
201 
202         OwnershipTransferInitiated(proposedOwner);
203 
204         return true;
205     }
206 
207 
208     function cancelOwnershipTransfer() public onlyOwner returns (bool) {
209         //if proposedOwner address already address(0) then it will return true.
210         if (proposedOwner == address(0)) {
211             return true;
212         }
213         //if not then first it will do address(0) then it will return true.
214         proposedOwner = address(0);
215 
216         OwnershipTransferCanceled();
217 
218         return true;
219     }
220 
221 
222     function completeOwnershipTransfer() public returns (bool) {
223 
224         require(msg.sender == proposedOwner);
225 
226         owner = msg.sender;
227         proposedOwner = address(0);
228 
229         OwnershipTransferCompleted(owner);
230 
231         return true;
232     }
233 }
234 
235 contract FinalizableToken is ERC20Token, Owned {
236 
237     using SafeMath for uint256;
238 
239 
240     /**
241          * @dev Call publicReservedAddress - library function exposed for testing.
242     */
243     address public publicReservedAddress;
244 
245     //board members time list
246     mapping(address=>uint) private boardReservedAccount;
247     uint256[] public BOARD_RESERVED_YEARS = [1 years,2 years,3 years,4 years,5 years,6 years,7 years,8 years,9 years,10 years];
248     
249     event Burn(address indexed burner,uint256 value);
250 
251     // The constructor will assign the initial token supply to the owner (msg.sender).
252     function FinalizableToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply,address _publicReserved,uint256 _publicReservedPersentage,address[] _boardReserved,uint256[] _boardReservedPersentage) public
253     ERC20Token(_name, _symbol, _decimals, _totalSupply, _publicReserved, _publicReservedPersentage, _boardReserved, _boardReservedPersentage)
254     Owned(){
255         publicReservedAddress = _publicReserved;
256         for(uint i=0; i<_boardReserved.length; i++){
257             boardReservedAccount[_boardReserved[i]] = currentTime() + BOARD_RESERVED_YEARS[i];
258         }
259     }
260 
261 
262     function transfer(address _to, uint256 _value) public returns (bool success) {
263         require(validateTransfer(msg.sender, _to));
264         return super.transfer(_to, _value);
265     }
266 
267 
268     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
269         require(validateTransfer(msg.sender, _to));
270         return super.transferFrom(_from, _to, _value);
271     }
272 
273 
274     function validateTransfer(address _sender, address _to) private view returns(bool) {
275         //check null address
276         require(_to != address(0));
277         
278         //check board member address
279         uint256 time = boardReservedAccount[_sender];
280         if (time == 0) {
281             //if not then return and allow for transfer
282             return true;
283         }else{
284             // else  then check allowed token for board member
285             return currentTime() > time;
286         }
287     }
288 
289     /**
290      * @dev Burns a specific amount of tokens.
291      * @param _value The amount of token to be burned.
292      */
293     function burn(uint256 _value) public {
294         require(_value > 0);
295         require(_value <= balances[msg.sender]);
296 
297 
298         address burner = msg.sender;
299         balances[burner] = balances[burner].sub(_value);
300         tokenTotalSupply = tokenTotalSupply.sub(_value);
301         Burn(burner, _value);
302     }
303     
304      //get current time
305     function currentTime() public constant returns (uint256) {
306         return now;
307     }
308 
309 }
310 
311 contract DOCTokenConfig {
312 
313     string  public constant TOKEN_SYMBOL      = "DOC";
314     string  public constant TOKEN_NAME        = "DOMUSCOINS Token";
315     uint8   public constant TOKEN_DECIMALS    = 18;
316 
317     uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);
318     uint256 public constant TOKEN_TOTALSUPPLY = 1000000000 * DECIMALSFACTOR;
319 
320     address public constant PUBLIC_RESERVED = 0xcd6b3d0c0dd850bad071cd20e428940d2e25120f;
321     uint256 public constant PUBLIC_RESERVED_PERSENTAGE = 9000;
322 
323     address[] public BOARD_RESERVED = [ 0x91cdb4c96d43591432fba178b672800b30266d63,
324     0x5a4dd8f6fc098869fa306c4143b281f214384de4,
325     0x2e067592283a463f9b425165c3bde40bc6cf8309,
326     0x49cbdc6c74b57eeccd6487999c2170a723193851,
327     0xd6c723a5fbe81e9744ac1a72767ba0744f67e713,
328     0x81409970ed8b78769eb58d62c0bf0371dad772e1,
329     0x13505e4fe6bdc6813b5e6fb63c44ac9ed4ac44ac,
330     0x87da1a7e6d460cad057740ef56f0c223dc572ebb,
331     0x05cb91a12b8da165f19cd4f81002566b0383cef7,
332     0xaf68b2dc937301d84d6d350d9beec880448dbac0
333     ];
334 
335     uint256[] public BOARD_RESERVED_PERSENTAGE = [200,200,200,500,500,1000,1000,2000,2000,2400];
336 
337 }
338 
339 contract DOCToken is FinalizableToken, DOCTokenConfig {
340 
341     using SafeMath for uint256;
342     event TokensReclaimed(uint256 _amount);
343 
344     function DOCToken() public
345     FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY, PUBLIC_RESERVED, PUBLIC_RESERVED_PERSENTAGE, BOARD_RESERVED, BOARD_RESERVED_PERSENTAGE)
346     {
347 
348     }
349 
350 
351     // Allows the owner to reclaim tokens that have been sent to the token address itself.
352     function reclaimTokens() public onlyOwner returns (bool) {
353 
354         address account = address(this);
355         uint256 amount  = balanceOf(account);
356 
357         if (amount == 0) {
358             return false;
359         }
360 
361         balances[account] = balances[account].sub(amount);
362         balances[owner] = balances[owner].add(amount);
363 
364         Transfer(account, owner, amount);
365 
366         TokensReclaimed(amount);
367 
368         return true;
369     }
370 }