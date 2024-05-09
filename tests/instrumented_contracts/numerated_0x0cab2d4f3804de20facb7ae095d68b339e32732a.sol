1 pragma solidity ^0.5.2;
2 // ----------------------------------------------------------------------------
3 // rev rbs eryk 190105.POC // Ver Proof of Concept compiler optimized - travou na conversao de GTIN-13+YYMM para address nesta versao 0.5---droga
4 // 'IGR' 'InGRedient Token with Fixed Supply Token'  contract
5 //
6 // Symbol      : IGR
7 // Name        : InGRedient Token -based on ER20 wiki- Example Fixed Supply Token
8 // Total supply: 1,000,000.000000000000000000
9 // Decimals    : 3
10 //
11 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
12 //
13 // (c) Erick.yamada@aluno.ufabc.edu.br  & Ricardo.Borges@ufabc.edu.br
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function mul(uint a, uint b) internal pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function div(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36 }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45 function totalSupply() public view returns (uint);
46 function balanceOf(address tokenOwner) public view returns (uint balance);
47 function allowance(address tokenOwner, address spender) public view returns (uint remaining);
48 function transfer(address to, uint tokens) public returns (bool success);
49 function approve(address spender, uint tokens) public returns (bool success);
50 function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52 event Transfer(address indexed from, address indexed to, uint tokens);
53 event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63 function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
64 }
65 
66 // ----------------------------------------------------------------------------
67 // Owned contract
68 // ----------------------------------------------------------------------------
69 contract Owned {
70     address public owner;
71     address public newOwner;
72     
73     event OwnershipTransferred(address indexed _from, address indexed _to);
74     
75     constructor() public {
76         owner = msg.sender;
77     }
78     
79     modifier onlyOwner {
80         require(msg.sender == owner);
81     _;
82     }
83     
84     function transferOwnership(address _newOwner) public onlyOwner {
85         newOwner = _newOwner;
86     }
87     function acceptOwnership() public {
88         require(msg.sender == newOwner);
89         emit OwnershipTransferred(owner, newOwner);
90         owner = newOwner;
91         newOwner = address(0);
92     }
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 // ERC20 Token, with the addition of symbol, name and decimals and a
98 // fixed supply
99 // ----------------------------------------------------------------------------
100 
101 contract InGRedientToken  is ERC20Interface, Owned {
102     using SafeMath for uint;
103     
104     string public symbol;
105     string public  name;
106     uint8 public decimals;
107     uint public _totalSupply;
108     
109     mapping(address => uint) balances;
110     mapping(address => mapping(address => uint)) allowed;
111     
112     
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     constructor() public {
117         symbol = "IGR";
118         name = "InGRedientToken";
119         decimals = 3;//kg is the official  unit but grams is mostly  used
120         _totalSupply = 1000000000000000000000 * 10**uint(decimals);
121         balances[owner] = _totalSupply;
122         emit Transfer(address(0), owner, _totalSupply);
123     }
124     
125     
126     // ------------------------------------------------------------------------
127     // Total supply
128     // ------------------------------------------------------------------------
129     function totalSupply() public view returns (uint) {
130         return _totalSupply.sub(balances[address(0)]);
131     }
132     
133     
134     // ------------------------------------------------------------------------
135     // Get the token balance for account `tokenOwner`
136     // ------------------------------------------------------------------------
137     function balanceOf(address tokenOwner) public view returns (uint balance) {
138         return balances[tokenOwner];
139     }
140     
141     
142     // ------------------------------------------------------------------------
143     // Transfer the balance from token owner's account to `to` account
144     // - Owner's account must have sufficient balance to transfer
145     // - 0 value transfers are allowed
146     // ------------------------------------------------------------------------
147     function transfer(address to, uint tokens) public returns (bool success) {
148         balances[msg.sender] = balances[msg.sender].sub(tokens);
149         balances[to] = balances[to].add(tokens);
150         emit Transfer(msg.sender, to, tokens);
151         return true;
152     }
153     
154     
155     // ------------------------------------------------------------------------
156     // Token owner can approve for `spender` to transferFrom(...) `tokens`
157     // from the token owner's account
158     //
159     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
160     // recommends that there are no checks for the approval double-spend attack
161     // as this should be implemented in user interfaces
162     // ------------------------------------------------------------------------
163     function approve(address spender, uint tokens) public returns (bool success) {
164         allowed[msg.sender][spender] = tokens;
165         emit Approval(msg.sender, spender, tokens);
166         return true;
167     }
168     
169     
170     // ------------------------------------------------------------------------
171     // Transfer `tokens` from the `from` account to the `to` account
172     //
173     // The calling account must already have sufficient tokens approve(...)-d
174     // for spending from the `from` account and
175     // - From account must have sufficient balance to transfer
176     // - Spender must have sufficient allowance to transfer
177     // - 0 value transfers are allowed
178     // ------------------------------------------------------------------------
179     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
180         balances[from] = balances[from].sub(tokens);
181         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
182         balances[to] = balances[to].add(tokens);
183         emit Transfer(from, to, tokens);
184         return true;
185     }
186     
187     
188     // ------------------------------------------------------------------------
189     // Returns the amount of tokens approved by the owner that can be
190     // transferred to the spender's account
191     // ------------------------------------------------------------------------
192     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
193         return allowed[tokenOwner][spender];
194     }
195     
196     
197     // ------------------------------------------------------------------------
198     // Token owner can approve for `spender` to transferFrom(...) `tokens`
199     // from the token owner's account. The `spender` contract function
200     // `receiveApproval(...)` is then executed
201     // ------------------------------------------------------------------------
202     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
203         allowed[msg.sender][spender] = tokens;
204         emit Approval(msg.sender, spender, tokens);
205         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
206         return true;
207     }
208     
209     
210     // ------------------------------------------------------------------------
211     // Don't accept ETH
212     // ------------------------------------------------------------------------
213     function () external payable {
214         revert();
215     }
216     
217     
218     // ------------------------------------------------------------------------
219     // Owner can transfer out any accidentally sent ERC20 tokens
220     // ------------------------------------------------------------------------
221     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
222         return ERC20Interface(tokenAddress).transfer(owner, tokens);
223     }
224     
225     
226     
227     
228     
229     // ==================================================================
230     // >>>>>>  IGR token specific functions <<<<<<
231     //===================================================================
232     
233     event  FarmerRequestedCertificate(address owner, address certAuth, uint tokens);
234     // --------------------------------------------------------------------------------------------------
235     // routine 10- allows for sale of ingredients along with the respective IGR token transfer
236     // --------------------------------------------------------------------------------------------------
237     function farmerRequestCertificate(address _certAuth, uint _tokens, string memory  _product, string memory _IngValueProperty, string memory _localGPSProduction, string memory  _dateProduction ) public returns (bool success) {
238         // falta implementar uma verif se o end certAuth foi cadastrado anteriormente
239         allowed[owner][_certAuth] = _tokens;
240         emit Approval(owner, _certAuth, _tokens);
241         emit FarmerRequestedCertificate(owner, _certAuth, _tokens);
242         return true;
243     }
244     
245     // --------------------------------------------------------------------------------------------------
246     // routine 20-  certAuthIssuesCerticate  certification auth confirms that ingredients are trustworthy
247     // as well as qtty , published url, product, details of IGR value property, location , date of harvest )
248     // --------------------------------------------------------------------------------------------------
249     function certAuthIssuesCerticate(address owner, address farmer, uint tokens, string memory _url,string memory product,string memory IngValueProperty, string memory localGPSProduction, uint dateProduction ) public returns (bool success) {
250         balances[owner] = balances[owner].sub(tokens);
251         //allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(tokens);//nao faz sentido
252         allowed[owner][msg.sender] = 0;
253         balances[farmer] = balances[farmer].add(tokens);
254         emit Transfer(owner, farmer, tokens);
255         return true;
256     }
257     
258     // --------------------------------------------------------------------------------------------------
259     // routine 30- allows for simple sale of ingredients along with the respective IGR token transfer ( with url)
260     // --------------------------------------------------------------------------------------------------
261     function sellsIngrWithoutDepletion(address to, uint tokens,string memory _url) public returns (bool success) {
262         string memory url=_url; // keep the url of the InGRedient for later transfer
263         balances[msg.sender] = balances[msg.sender].sub(tokens);
264         balances[to] = balances[to].add(tokens);
265         emit Transfer(msg.sender, to, tokens);
266         return true;
267     }
268     
269     // --------------------------------------------------------------------------------------------------
270     // routine 40- allows for sale of intermediate product made from certified ingredients along with
271     // the respective IGR token transfer ( with url)
272     // i.e.: allows only the pro-rata quantity of semi-processed  InGRedient tokens to be transfered
273     // --------------------------------------------------------------------------------------------------
274     function sellsIntermediateGoodWithDepletion(address to, uint tokens,string memory _url,uint out2inIngredientPercentage ) public returns (bool success) {
275         string memory url=_url; // keep the url of hte InGRedient for later transfer
276         require (out2inIngredientPercentage <= 100); // make sure the depletion percentage is not higher than  100(%)
277         balances[msg.sender] = balances[msg.sender].sub((tokens*(100-out2inIngredientPercentage))/100);// this will kill the tokens for the depleted part //
278         transfer(to, tokens*out2inIngredientPercentage/100);
279         return true;
280     }
281     
282     //--------------------------------------------------------------------------------------------------
283     // aux function to generate a ethereum address from the food item visible numbers ( GTIN-13 + date of validity
284     // is used by Routine 50- comminglerSellsProductSKUWithProRataIngred
285     // and can be used to query teh blockchain by a consumer App
286     //--------------------------------------------------------------------------------------------------
287     function genAddressFromGTIN13date(string memory _GTIN13,string memory _YYMMDD) public pure returns(address b){
288     //address b = bytes32(keccak256(abi.encodePacked(_GTIN13,_YYMMDD)));
289     // address b = address(a);
290         
291         bytes32 a = keccak256(abi.encodePacked(_GTIN13,_YYMMDD));
292         
293         assembly{
294         mstore(0,a)
295         b:= mload(0)
296         }
297         
298         return b;
299     }
300     
301     // --------------------------------------------------------------------------------------------------
302     //  transferAndWriteUrl- aux routine -Transfer the balance from token owner's account to `to` account
303     // - Owner's account must have sufficient balance to transfer
304     // - 0 value transfers are allowed
305     // since the -url is passed to the function we achieve that this data be written to the block..nothing else needed
306     // --------------------------------------------------------------------------------------------------
307     function transferAndWriteUrl(address to, uint tokens, string memory _url) public returns (bool success) {
308         balances[msg.sender] = balances[msg.sender].sub(tokens);
309         balances[to] = balances[to].add(tokens);
310         emit Transfer(msg.sender, to, tokens);
311         return true;
312     }
313     
314     // --------------------------------------------------------------------------------------------------
315     // routine 50- comminglerSellsProductSKUWithProRataIngred(address _to, int numPSKUsSold, ,string _url, uint _qttyIGRinLLSKU, string GTIN13, string YYMMDD )
316     // allows for sale of final-consumer  product with resp SKU and Lot identification with corresponding IGR transfer  with url
317     // i.e.: allows only the pro-rata quantity of semi-processed  InGRedient tokens to be transfered to the consumer level package(SKU)
318     // --------------------------------------------------------------------------------------------------
319     function comminglerSellsProductSKUWithProRataIngred(address _to, uint _numSKUsSold,string memory _url,uint _qttyIGRinLLSKU, string memory _GTIN13, string memory _YYMMDD ) public returns (bool success) {
320         string memory url=_url; // keep the url of hte InGRedient for later transfer
321         address c= genAddressFromGTIN13date( _GTIN13, _YYMMDD);
322         require (_qttyIGRinLLSKU >0); // qtty of Ingredient may not be negative nor zero
323         //write IGR qtty in one SKU and url  to the blockchain address composed of GTIN-13+YYMMDD
324         transferAndWriteUrl(c, _qttyIGRinLLSKU, _url);
325         //deduct IGRs sold by commingler  from its balances
326         transferAndWriteUrl(_to, (_numSKUsSold-1)*_qttyIGRinLLSKU,_url);// records the transfer of custody of the qtty of SKU each with qttyIGRinLLSKU
327         return true;
328     }
329 
330 
331 }