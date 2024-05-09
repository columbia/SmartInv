1 pragma solidity ^0.4.18;
2 // ----------------------------------------------------------------------------
3 // rev rbs eryk 180908aPOC // Ver Proof of Concept 
4 // 'IGR' 'InGRedient Token with Fixed Supply Token'  contract
5 //
6 // Symbol      : IGR
7 // Name        : InGRedient Token -based on ER20 wiki- Example Fixed Supply Token
8 // Total supply: 1,000,000.000000000000000000
9 // Decimals    : 3
10 //
11 // (c) Erick.yamada@aluno.ufabc.edu.br  & Ricardo.Borges@ufabc.edu.br
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe math
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19 function add(uint a, uint b) internal pure returns (uint c) {
20 c = a + b;
21 require(c >= a);
22 }
23 function sub(uint a, uint b) internal pure returns (uint c) {
24 require(b <= a);
25 c = a - b;
26 }
27 function mul(uint a, uint b) internal pure returns (uint c) {
28 c = a * b;
29 require(a == 0 || c / a == b);
30 }
31 function div(uint a, uint b) internal pure returns (uint c) {
32 require(b > 0);
33 c = a / b;
34 }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43 function totalSupply() public constant returns (uint);
44 function balanceOf(address tokenOwner) public constant returns (uint balance);
45 function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46 function transfer(address to, uint tokens) public returns (bool success);
47 function approve(address spender, uint tokens) public returns (bool success);
48 function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50 event Transfer(address indexed from, address indexed to, uint tokens);
51 event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 // Borrowed from MiniMeToken-
58 // ----------------------------------------------------------------------------
59 contract ApproveAndCallFallBack {
60 function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
61 }
62 
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 contract Owned {
67 address public owner;
68 address public newOwner;
69 
70 event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72 function Owned() public {
73 owner = msg.sender;
74 }
75 
76 modifier onlyOwner {
77 require(msg.sender == owner);
78 _;
79 }
80 
81 function transferOwnership(address _newOwner) public onlyOwner {
82 newOwner = _newOwner;
83 }
84 
85 function acceptOwnership() public {
86 require(msg.sender == newOwner);
87 OwnershipTransferred(owner, newOwner);
88 owner = newOwner;
89 newOwner = address(0);
90 }
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and an
96 // initial fixed supply
97 // ----------------------------------------------------------------------------
98 contract InGRedientToken  is ERC20Interface, Owned {
99 using SafeMath for uint;
100 
101 string public symbol;
102 string public  name;
103 uint8 public decimals;
104 uint public _totalSupply;
105 
106 mapping(address => uint) balances;
107 mapping(address => mapping(address => uint)) allowed;
108 
109 
110 // ------------------------------------------------------------------------
111 // Constructor
112 // ------------------------------------------------------------------------
113 function InGRedientToken() public {
114 symbol = "IGR";
115 name = "InGRedientToken";
116 decimals = 3; //kg is the reference unit but grams is often also used
117 _totalSupply = 1000000000000000000000 * 10**uint(decimals);
118 balances[owner] = _totalSupply;
119 Transfer(address(0), owner, _totalSupply);
120 }
121 
122 
123 // ------------------------------------------------------------------------
124 // Total supply
125 // ------------------------------------------------------------------------
126 function totalSupply() public constant returns (uint) {
127 return _totalSupply  - balances[address(0)];
128 }
129 
130 
131 // ------------------------------------------------------------------------
132 // Get the token balance for account `tokenOwner`
133 // ------------------------------------------------------------------------
134 function balanceOf(address tokenOwner) public constant returns (uint balance) {
135 return balances[tokenOwner];
136 }
137 
138 // ------------------------------------------------------------------------
139 // Token owner can approve for `spender` to transferFrom(...) `tokens`
140 // from the token owner's account
141 //
142 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
143 // recommends that there are no checks for the approval double-spend attack
144 // as this should be implemented in user interfaces
145 // ------------------------------------------------------------------------
146 function approve(address spender, uint tokens) public returns (bool success) {
147 allowed[msg.sender][spender] = tokens;
148 Approval(msg.sender, spender, tokens);
149 return true;
150 }
151 
152 // ------------------------------------------------------------------------
153 // Transfer the balance from token owner's account to `to` account
154 // - Owner's account must have sufficient balance to transfer
155 // - 0 value transfers are allowed
156 // ------------------------------------------------------------------------
157 function transfer(address to, uint tokens) public returns (bool success) {
158 balances[msg.sender] = balances[msg.sender].sub(tokens);
159 balances[to] = balances[to].add(tokens);
160 Transfer(msg.sender, to, tokens);
161 return true;
162 }
163 
164 // ------------------------------------------------------------------------
165 // Transfer `tokens` from the `from` account to the `to` account
166 //
167 // The calling account must already have sufficient tokens approve(...)-d
168 // for spending from the `from` account and
169 // - From account must have sufficient balance to transfer
170 // - Spender must have sufficient allowance to transfer
171 // - 0 value transfers are allowed
172 // ------------------------------------------------------------------------
173 function transferFrom(address from, address to, uint tokens) public returns (bool success) {
174 balances[from] = balances[from].sub(tokens);
175 allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
176 balances[to] = balances[to].add(tokens);
177 Transfer(from, to, tokens);
178 return true;
179 }
180 
181 
182 // ------------------------------------------------------------------------
183 // Returns the amount of tokens approved by the owner that can be
184 // transferred to the spender's account
185 // ------------------------------------------------------------------------
186 function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
187 return allowed[tokenOwner][spender];
188 }
189 
190 
191 // ------------------------------------------------------------------------
192 // Token owner can approve for `spender` to transferFrom(...) `tokens`
193 // from the token owner's account. The `spender` contract function
194 // `receiveApproval(...)` is then executed
195 // ------------------------------------------------------------------------
196 function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
197 allowed[msg.sender][spender] = tokens;
198 Approval(msg.sender, spender, tokens);
199 ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
200 return true;
201 }
202 
203 // ------------------------------------------------------------------------
204 // Don't accept ETH
205 // ------------------------------------------------------------------------
206 function () public payable {
207 revert();
208 }
209 
210 
211 // ------------------------------------------------------------------------
212 // Owner can transfer out any accidentally sent ERC20 tokens
213 // ------------------------------------------------------------------------
214 function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
215 return ERC20Interface(tokenAddress).transfer(owner, tokens);
216 }
217 
218 
219 
220 // ==================================================================
221 // >>>>>>  IGR token specific functions <<<<<<
222 //===================================================================
223 
224 event  FarmerRequestedCertificate(address owner, address certAuth, uint tokens);
225 // --------------------------------------------------------------------------------------------------
226 // routine 10- allows for sale of ingredients along with the respective IGR token transfer
227 // --------------------------------------------------------------------------------------------------
228 function farmerRequestCertificate(address _certAuth, uint _tokens, string _product,string _IngValueProperty, string _localGPSProduction, string  _dateProduction ) public returns (bool success) {
229 // falta implementar uma verif se o end certAuth foi cadastrado anteriormente
230 allowed[owner][_certAuth] = _tokens;
231 Approval(owner, _certAuth, _tokens);
232 FarmerRequestedCertificate(owner, _certAuth, _tokens);
233 return true;
234 }
235 
236 // --------------------------------------------------------------------------------------------------
237 // routine 20-  certAuthIssuesCerticate  certification auth confirms that ingredients are trustworthy
238 // as well as qtty , published url, product, details of IGR value property, location , date of harvest )
239 // --------------------------------------------------------------------------------------------------
240 function certAuthIssuesCerticate(address owner, address farmer, uint tokens, string _url,string product,string IngValueProperty, string localGPSProduction, uint dateProduction ) public returns (bool success) {
241 balances[owner] = balances[owner].sub(tokens);
242 //allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(tokens);//nao faz sentido
243 allowed[owner][msg.sender] = 0;
244 balances[farmer] = balances[farmer].add(tokens);
245 Transfer(owner, farmer, tokens);
246 return true;
247 }
248 
249 // --------------------------------------------------------------------------------------------------
250 // routine 30- allows for simple sale of ingredients along with the respective IGR token transfer ( with url)
251 // --------------------------------------------------------------------------------------------------
252 function sellsIngrWithoutDepletion(address to, uint tokens,string _url) public returns (bool success) {
253 string memory url=_url; // keep the url of the InGRedient for later transfer
254 balances[msg.sender] = balances[msg.sender].sub(tokens);
255 balances[to] = balances[to].add(tokens);
256 Transfer(msg.sender, to, tokens);
257 return true;
258 }
259 
260 // --------------------------------------------------------------------------------------------------
261 // routine 40- allows for sale of intermediate product made from certified ingredients along with
262 // the respective IGR token transfer ( with url)
263 // i.e.: allows only the pro-rata quantity of semi-processed  InGRedient tokens to be transfered
264 // --------------------------------------------------------------------------------------------------
265 function sellsIntermediateGoodWithDepletion(address to, uint tokens,string _url,uint out2inIngredientPercentage ) public returns (bool success) {
266 string memory url=_url; // keep the url of hte InGRedient for later transfer
267 require (out2inIngredientPercentage <= 100); // make sure the depletion percentage is not higher than  100(%)
268 balances[msg.sender] = balances[msg.sender].sub((tokens*(100-out2inIngredientPercentage))/100);// this will kill the tokens for the depleted part //
269 transfer(to, tokens*out2inIngredientPercentage/100);
270 return true;
271 }
272 
273 //--------------------------------------------------------------------------------------------------
274 // aux function to generate a ethereum address from the food item visible numbers ( GTIN-13 + date of validity 
275 // is used by Routine 50- comminglerSellsProductSKUWithProRataIngred
276 // and can be used to query teh blockchain by a consumer App   
277 //--------------------------------------------------------------------------------------------------
278 function genAddressFromGTIN13date(string _GTIN13,string _YYMMDD) constant returns(address c){
279 bytes32 a= keccak256(_GTIN13,_YYMMDD);
280 address b = address(a);
281 return b;
282 }
283 
284 // --------------------------------------------------------------------------------------------------
285 //  transferAndWriteUrl- aux routine -Transfer the balance from token owner's account to `to` account
286 // - Owner's account must have sufficient balance to transfer
287 // - 0 value transfers are allowed
288 // since the -url is passed to the function we achieve that this data be written to the block..nothing else needed
289 // --------------------------------------------------------------------------------------------------
290 function transferAndWriteUrl(address to, uint tokens, string _url) public returns (bool success) {
291 balances[msg.sender] = balances[msg.sender].sub(tokens);
292 balances[to] = balances[to].add(tokens);
293 Transfer(msg.sender, to, tokens);
294 return true;
295 }
296 
297 // --------------------------------------------------------------------------------------------------
298 // routine 50- comminglerSellsProductSKUWithProRataIngred(address _to, int numPSKUsSold, ,string _url, uint _qttyIGRinLLSKU, string GTIN13, string YYMMDD )
299 // allows for sale of final-consumer  product with resp SKU and Lot identification with corresponding IGR transfer  with url
300 // i.e.: allows only the pro-rata quantity of semi-processed  InGRedient tokens to be transfered to the consumer level package(SKU)
301 // --------------------------------------------------------------------------------------------------
302 function comminglerSellsProductSKUWithProRataIngred(address _to, uint _numSKUsSold,string _url,uint _qttyIGRinLLSKU, string _GTIN13, string _YYMMDD ) public returns (bool success) {
303 string memory url=_url; // keep the url of hte InGRedient for later transfer
304 address c= genAddressFromGTIN13date( _GTIN13, _YYMMDD);
305 require (_qttyIGRinLLSKU >0); // qtty of Ingredient may not be negative nor zero
306 //write IGR qtty in one SKU and url  to the blockchain address composed of GTIN-13+YYMMDD 
307 transferAndWriteUrl(c, _qttyIGRinLLSKU, _url);
308 //deduct IGRs sold by commingler  from its balances
309 transferAndWriteUrl(_to, (_numSKUsSold-1)*_qttyIGRinLLSKU,_url);// records the transfer of custody of the qtty of SKU each with qttyIGRinLLSKU
310 return true;
311 }
312 
313 
314 }