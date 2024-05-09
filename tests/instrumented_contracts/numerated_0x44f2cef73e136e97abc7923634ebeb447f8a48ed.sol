1 pragma solidity ^0.4.25;
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
58     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply,address _publicReserved,uint256 _publicReservedPersentage/*,address[] boardReserved,uint256[] boardReservedPersentage*/) public {
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
70         //uint256 boardReservedToken = _totalSupply.sub(publicReservedToken);
71 
72         // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
73         emit Transfer(0x0, _publicReserved, publicReservedToken);
74 
75 		/*
76         // The initial Board Reserved balance of tokens is assigned to the given token holder address.
77         uint256 persentageSum = 0;
78         for(uint i=0; i<boardReserved.length; i++){
79             //
80             persentageSum = persentageSum.add(boardReservedPersentage[i]);
81             require(persentageSum <= 10000);
82             //assigning board members persentage tokens to particular board member address.
83             uint256 token = boardReservedToken.mul(boardReservedPersentage[i]).div(tokenConversionFactor);
84             balances[boardReserved[i]] = token;
85             Transfer(0x0, boardReserved[i], token);
86         }
87 		*/
88 
89     }
90 
91 
92     function name() public view returns (string) {
93         return tokenName;
94     }
95 
96 
97     function symbol() public view returns (string) {
98         return tokenSymbol;
99     }
100 
101 
102     function decimals() public view returns (uint8) {
103         return tokenDecimals;
104     }
105 
106 
107     function totalSupply() public view returns (uint256) {
108         return tokenTotalSupply;
109     }
110 
111     // Get the token balance for account `tokenOwner`
112     function balanceOf(address _owner) public view returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116 
117     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
118         return allowed[_owner][_spender];
119     }
120 
121 
122     function transfer(address _to, uint256 _value) public returns (bool success) {
123         uint256 fromBalance = balances[msg.sender];
124         if (fromBalance < _value) return false;
125         if (_value > 0 && msg.sender != _to) {
126           balances[msg.sender] = fromBalance.sub(_value);
127           balances[_to] = balances[_to].add(_value);
128         }
129         emit Transfer(msg.sender, _to, _value);
130 
131         return true;
132     }
133 
134     // Send `tokens` amount of tokens from address `from` to address `to`
135     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
136     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
137     // fees in sub-currencies; the command should fail unless the _from account has
138     // deliberately authorized the sender of the message via some mechanism; we propose
139     // these standardized APIs for approval:
140     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
141         
142         uint256 spenderAllowance = allowed [_from][msg.sender];
143         if (spenderAllowance < _value) return false;
144         uint256 fromBalance = balances [_from];
145         if (fromBalance < _value) return false;
146     
147         allowed [_from][msg.sender] = spenderAllowance.sub(_value);
148     
149         if (_value > 0 && _from != _to) {
150           balances [_from] = fromBalance.sub(_value);
151           balances [_to] = balances[_to].add(_value);
152         }
153 
154         emit Transfer(_from, _to, _value);
155 
156         return true;
157     }
158 
159     // Allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
160     // If this function is called again it overwrites the current allowance with _value.
161     function approve(address _spender, uint256 _value) public returns (bool success) {
162         allowed[msg.sender][_spender] = _value;
163 
164         emit Approval(msg.sender, _spender, _value);
165 
166         return true;
167     }
168 }
169 
170 contract Owned {
171 
172     address public owner;
173     address public proposedOwner = address(0);
174 
175     event OwnershipTransferInitiated(address indexed _proposedOwner);
176     event OwnershipTransferCompleted(address indexed _newOwner);
177     event OwnershipTransferCanceled();
178 
179 
180     constructor() public
181     {
182         owner = msg.sender;
183     }
184 
185 
186     modifier onlyOwner() {
187         require(isOwner(msg.sender));
188         _;
189     }
190 
191 
192     function isOwner(address _address) public view returns (bool) {
193         return (_address == owner);
194     }
195 
196 
197     function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
198         require(_proposedOwner != address(0));
199         require(_proposedOwner != address(this));
200         require(_proposedOwner != owner);
201 
202         proposedOwner = _proposedOwner;
203 
204         emit OwnershipTransferInitiated(proposedOwner);
205 
206         return true;
207     }
208 
209 
210     function cancelOwnershipTransfer() public onlyOwner returns (bool) {
211         //if proposedOwner address already address(0) then it will return true.
212         if (proposedOwner == address(0)) {
213             return true;
214         }
215         //if not then first it will do address(0) then it will return true.
216         proposedOwner = address(0);
217 
218         emit OwnershipTransferCanceled();
219 
220         return true;
221     }
222 
223 
224     function completeOwnershipTransfer() public returns (bool) {
225 
226         require(msg.sender == proposedOwner);
227 
228         owner = msg.sender;
229         proposedOwner = address(0);
230 
231         emit OwnershipTransferCompleted(owner);
232 
233         return true;
234     }
235 }
236 
237 contract FinalizableToken is ERC20Token, Owned {
238 
239     using SafeMath for uint256;
240 
241 
242     /**
243          * @dev Call publicReservedAddress - library function exposed for testing.
244     */
245     address public publicReservedAddress;
246 
247 
248     event Burn(address indexed burner,uint256 value);
249 
250     // The constructor will assign the initial token supply to the owner (msg.sender).
251     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply,address _publicReserved,uint256 _publicReservedPersentage) public
252     ERC20Token(_name, _symbol, _decimals, _totalSupply, _publicReserved, _publicReservedPersentage)
253     Owned(){
254         publicReservedAddress = _publicReserved;
255     }
256 
257 
258     function transfer(address _to, uint256 _value) public returns (bool success) {
259         return super.transfer(_to, _value);
260     }
261 
262 
263     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
264 
265         return super.transferFrom(_from, _to, _value);
266     }
267 
268 
269 
270     /**
271      * @dev Burns a specific amount of tokens.
272      * @param _value The amount of token to be burned.
273      */
274     function burn(uint256 _value) public {
275         require(_value > 0);
276         require(_value <= balances[msg.sender]);
277 
278 
279         address burner = msg.sender;
280         balances[burner] = balances[burner].sub(_value);
281         tokenTotalSupply = tokenTotalSupply.sub(_value);
282         emit Burn(burner, _value);
283     }
284     
285      //get current time
286     function currentTime() public constant returns (uint256) {
287         return now;
288     }
289 
290 }
291 
292 contract HCXTokenConfig {
293 
294     string  public constant TOKEN_SYMBOL      = "HCX";
295     string  public constant TOKEN_NAME        = "HOLIDAY CAPITAL Token";
296     uint8   public constant TOKEN_DECIMALS    = 18;
297 
298     uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);
299     uint256 public constant TOKEN_TOTALSUPPLY = 1000000000 * DECIMALSFACTOR;
300 
301     address public constant PUBLIC_RESERVED = 0x6E22277b9A32a88cba52d5108ca7E836d994859f;
302     uint256 public constant PUBLIC_RESERVED_PERSENTAGE = 10000;
303 
304 }
305 
306 // Holiday Capital issues vouchers in the form of blockchain tokens to spend in all of its apartments around the world.
307 contract HCXToken is FinalizableToken, HCXTokenConfig {
308 
309     using SafeMath for uint256;
310     event TokensReclaimed(uint256 _amount);
311 
312     constructor() public
313     FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY, PUBLIC_RESERVED, PUBLIC_RESERVED_PERSENTAGE)
314     {
315 
316     }
317 
318 
319     // Allows the owner to reclaim tokens that have been sent to the token address itself.
320     function reclaimTokens() public onlyOwner returns (bool) {
321 
322         address account = address(this);
323         uint256 amount  = balanceOf(account);
324 
325         if (amount == 0) {
326             return false;
327         }
328 
329         balances[account] = balances[account].sub(amount);
330         balances[owner] = balances[owner].add(amount);
331 
332         emit Transfer(account, owner, amount);
333 
334         emit TokensReclaimed(amount);
335 
336         return true;
337     }
338 }