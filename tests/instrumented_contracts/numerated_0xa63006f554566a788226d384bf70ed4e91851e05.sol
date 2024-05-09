1 pragma solidity >=0.4.0 <0.7.0;
2 // ----------------------------------------------------------------------------
3 // rev rbs erky 190101.POC 
4 //
5 // 'IGR' 'InGRedient Token with Fixed Supply Token'  contract
6 //
7 // Symbol      : IGR
8 // Name        : InGRedient Token Certification of Value Ingredients for Recipe based Foods  
9 // Total supply: 1,000,000.000000000000000000
10 // Decimals    : 3
11 //
12 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
13 //
14 // (c) Erick.yamada@aluno.ufabc.edu.br  & Ricardo.Borges@ufabc.edu.br
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 library SafeMath {
22     function add(uint a, uint b) internal pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function sub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function mul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function div(uint a, uint b) internal pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37 }
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // ERC Token Standard #20 Interface
43 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
44 // ----------------------------------------------------------------------------
45 contract ERC20Interface {
46 function totalSupply() public view returns (uint);
47 function balanceOf(address tokenOwner) public view returns (uint balance);
48 function allowance(address tokenOwner, address spender) public view returns (uint remaining);
49 function transfer(address to, uint tokens) public returns (bool success);
50 function approve(address spender, uint tokens) public returns (bool success);
51 function transferFrom(address from, address to, uint tokens) public returns (bool success);
52 
53 event Transfer(address indexed from, address indexed to, uint tokens);
54 event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Contract function to receive approval and execute function in one call
60 //
61 // Borrowed from MiniMeToken
62 // ----------------------------------------------------------------------------
63 contract ApproveAndCallFallBack {
64 function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
65 }
66 
67 // ----------------------------------------------------------------------------
68 // Owned contract
69 // ----------------------------------------------------------------------------
70 contract Owned {
71     address public owner;
72     address public newOwner;
73     
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75     
76     constructor() public {
77         owner = msg.sender;
78     }
79     
80     modifier onlyOwner {
81         require(msg.sender == owner);
82     _;
83     }
84     
85     function transferOwnership(address _newOwner) public onlyOwner {
86         newOwner = _newOwner;
87     }
88     function acceptOwnership() public {
89         require(msg.sender == newOwner);
90         emit OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92         newOwner = address(0);
93     }
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Token, with the addition of symbol, name and decimals and a
99 // fixed supply
100 // ----------------------------------------------------------------------------
101 
102 contract InGRedientToken  is ERC20Interface, Owned {
103     using SafeMath for uint;
104     
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108     uint public _totalSupply;
109     
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112     
113     
114     // ------------------------------------------------------------------------
115     // Constructor
116     // ------------------------------------------------------------------------
117     constructor() public {
118         symbol = "IGR";
119         name = "InGRedientToken Certification of Value Ingredients for Recipe Based Foods";
120         decimals = 3;//kg is the official  unit but grams is mostly  used
121         _totalSupply = 1000000000000000000000 * 10**uint(decimals);
122         balances[owner] = _totalSupply;
123         emit Transfer(address(0), owner, _totalSupply);
124     }
125     
126     
127     // ------------------------------------------------------------------------
128     // Total supply
129     // ------------------------------------------------------------------------
130     function totalSupply() public view returns (uint) {
131         return _totalSupply.sub(balances[address(0)]);
132     }
133     
134     
135     // ------------------------------------------------------------------------
136     // Get the token balance for account `tokenOwner`
137     // ------------------------------------------------------------------------
138     function balanceOf(address tokenOwner) public view returns (uint balance) {
139         return balances[tokenOwner];
140     }
141     
142     
143     // ------------------------------------------------------------------------
144     // Transfer the balance from token owner's account to `to` account
145     // - Owner's account must have sufficient balance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transfer(address to, uint tokens) public returns (bool success) {
149         balances[msg.sender] = balances[msg.sender].sub(tokens);
150         balances[to] = balances[to].add(tokens);
151         emit Transfer(msg.sender, to, tokens);
152         return true;
153     }
154     
155     
156     // ------------------------------------------------------------------------
157     // Token owner can approve for `spender` to transferFrom(...) `tokens`
158     // from the token owner's account
159     //
160     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
161     // recommends that there are no checks for the approval double-spend attack
162     // as this should be implemented in user interfaces
163     // ------------------------------------------------------------------------
164     function approve(address spender, uint tokens) public returns (bool success) {
165         allowed[msg.sender][spender] = tokens;
166         emit Approval(msg.sender, spender, tokens);
167         return true;
168     }
169     
170     
171     // ------------------------------------------------------------------------
172     // Transfer `tokens` from the `from` account to the `to` account
173     //
174     // The calling account must already have sufficient tokens approve(...)-d
175     // for spending from the `from` account and
176     // - From account must have sufficient balance to transfer
177     // - Spender must have sufficient allowance to transfer
178     // - 0 value transfers are allowed
179     // ------------------------------------------------------------------------
180     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
181         balances[from] = balances[from].sub(tokens);
182         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
183         balances[to] = balances[to].add(tokens);
184         emit Transfer(from, to, tokens);
185         return true;
186     }
187     
188     
189     // ------------------------------------------------------------------------
190     // Returns the amount of tokens approved by the owner that can be
191     // transferred to the spender's account
192     // ------------------------------------------------------------------------
193     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
194         return allowed[tokenOwner][spender];
195     }
196     
197     
198     // ------------------------------------------------------------------------
199     // Token owner can approve for `spender` to transferFrom(...) `tokens`
200     // from the token owner's account. The `spender` contract function
201     // `receiveApproval(...)` is then executed
202     // ------------------------------------------------------------------------
203     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
204         allowed[msg.sender][spender] = tokens;
205         emit Approval(msg.sender, spender, tokens);
206         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
207         return true;
208     }
209     
210     
211     // ------------------------------------------------------------------------
212     // Don't accept ETH
213     // ------------------------------------------------------------------------
214     function () external payable {
215         revert();
216     }
217     
218     
219     // ------------------------------------------------------------------------
220     // Owner can transfer out any accidentally sent ERC20 tokens
221     // ------------------------------------------------------------------------
222     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
223         return ERC20Interface(tokenAddress).transfer(owner, tokens);
224     }
225 
226     
227     
228     // ==================================================================
229     // >>>>>>  IGR token specific functions <<<<<<
230     //===================================================================
231     mapping(address => mapping(address=>uint)) public balancesNFT;
232     mapping(address => mapping(address=>string)) urlNFT;
233     
234     
235     
236     event  FarmerRequestedCertificate(address owner, address certAuth, uint tokens);
237     // --------------------------------------------------------------------------------------------------
238     // routine 10- allows for sale of ingredients along with the respective IGR token transfer
239     // --------------------------------------------------------------------------------------------------
240     function farmerRequestCertificate(address _certAuth, uint _tokens, string memory  _product, string memory _IngValueProperty, string memory _localGPSProduction, string memory  _dateProduction ) public returns (bool success) {
241         // falta implementar uma verif se o end certAuth foi cadastrado anteriormente
242         allowed[owner][_certAuth] = _tokens;
243         emit Approval(owner, _certAuth, _tokens);
244         emit FarmerRequestedCertificate(owner, _certAuth, _tokens);
245         
246         
247     
248         return true;
249     }
250     
251     function urlToKeccak (string memory _url) public pure returns (address b){
252         bytes32 a = keccak256(abi.encodePacked(_url));
253         
254         assembly{
255         mstore(0,a)
256         b:= mload(0)
257         }
258         
259         return b;
260     }
261     
262     
263     // --------------------------------------------------------------------------------------------------
264     // routine 20-  certAuthIssuesCerticate  certification auth confirms that ingredients are trustworthy
265     // as well as qtty , published url, product, details of IGR value property, location , date of harvest )
266     // --------------------------------------------------------------------------------------------------
267     function certAuthIssuesCerticate(address owner, address _farmer, uint _tokens, string memory _url,string memory product,string memory IngValueProperty, string memory localGPSProduction, string memory  _dateProduction) public returns (bool success) {
268         balances[owner] = balances[owner].sub(_tokens);
269         //allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(tokens);
270         allowed[owner][msg.sender] = 0;
271         balances[_farmer] = balances[_farmer].add(_tokens);
272         emit Transfer(owner, _farmer, _tokens);
273     
274         address a = urlToKeccak(_url);
275         balancesNFT[_farmer][a]=_tokens;
276         urlNFT[_farmer][a]=_url;
277     
278         return true;
279     }
280     
281     
282     
283     
284     // --------------------------------------------------------------------------------------------------
285     // routine 30- allows for simple sale of ingredients along with the respective IGR token transfer ( with url)
286     // --------------------------------------------------------------------------------------------------
287     function sellsIngrWithoutDepletion(address _to, uint _tokens,string memory _url) public returns (bool success) {
288         string memory url=_url; // keep the url of the InGRedient for later transfer
289         balances[msg.sender] = balances[msg.sender].sub(_tokens);
290         balances[_to] = balances[_to].add(_tokens);
291         emit Transfer(msg.sender, _to, _tokens);
292         
293         address a = urlToKeccak(_url);
294         require(balancesNFT[msg.sender][a]>_tokens);
295         balancesNFT[msg.sender][a]=balancesNFT[msg.sender][a].sub(_tokens);
296         balancesNFT[_to][a]=balancesNFT[_to][a].add(_tokens);
297         urlNFT[_to][a]=_url;
298         
299         
300         return true;
301     }
302     
303     // --------------------------------------------------------------------------------------------------
304     // routine 40- allows for sale of intermediate product made from certified ingredients along with
305     // the respective IGR token transfer ( with url)
306     // i.e.: allows only the pro-rata quantity of semi-processed  InGRedient tokens to be transfered
307     // --------------------------------------------------------------------------------------------------
308     function sellsIntermediateGoodWithDepletion(address _to, uint _tokens,string memory _url,uint _out2inIngredientPercentage ) public returns (bool success) {
309         string memory url=_url; // keep the url of hte InGRedient for later transfer
310         require (_out2inIngredientPercentage <= 100); // make sure the depletion percentage is not higher than  100(%)
311         balances[msg.sender] = balances[msg.sender].sub(_tokens);
312         
313         transfer(_to, _tokens*_out2inIngredientPercentage/100);
314         
315         address a = urlToKeccak(_url);
316         uint c =  _tokens*_out2inIngredientPercentage/100;
317         require(balancesNFT[msg.sender][a]>_tokens);
318         balancesNFT[msg.sender][a]=balancesNFT[msg.sender][a].sub(_tokens);
319         balancesNFT[_to][a]=balancesNFT[_to][a].add(c);
320         urlNFT[_to][a]=_url;
321        
322         return true;
323     }
324     
325     //--------------------------------------------------------------------------------------------------
326     // aux function to generate a ethereum address from the food item visible numbers 
327     //( GTIN-13 + date of validity
328     // is used by Routine 50- comminglerSellsProductSKUWithProRataIngred
329     // and can be used to query teh blockchain by a consumer App
330     //--------------------------------------------------------------------------------------------------
331     function genAddressFromGTIN13date(string memory _GTIN13,string memory _YYMMDD) public pure returns(address b){
332     //address b = bytes32(keccak256(abi.encodePacked(_GTIN13,_YYMMDD)));
333     // address b = address(a);
334         
335         bytes32 a = keccak256(abi.encodePacked(_GTIN13,_YYMMDD));
336         
337         assembly{
338         mstore(0,a)
339         b:= mload(0)
340         }
341         
342         return b;
343     }
344     
345     // --------------------------------------------------------------------------------------------------
346     //  transferAndWriteUrl- aux routine -Transfer the balance from token owner's account to `to` account
347     // - Owner's account must have sufficient balance to transfer
348     // - 0 value transfers are allowed
349     // since the -url is passed to the function we achieve that this data be written to the block..nothing else needed
350     // --------------------------------------------------------------------------------------------------
351     function transferAndWriteUrl(address _to, uint _tokens, string memory _url) public returns (bool success) {
352         balances[msg.sender] = balances[msg.sender].sub(_tokens);
353         balances[_to] = balances[_to].add(_tokens);
354         emit Transfer(msg.sender, _to, _tokens);
355         
356         address a = urlToKeccak(_url);
357         require(balancesNFT[msg.sender][a]>_tokens);
358         balancesNFT[msg.sender][a]=balancesNFT[msg.sender][a].sub(_tokens);
359         balancesNFT[_to][a]=balancesNFT[_to][a].add(_tokens);
360         urlNFT[_to][a]=_url;
361         
362         
363         return true;
364     }
365     
366     // --------------------------------------------------------------------------------------------------
367     // routine 50- comminglerSellsProductSKUWithProRataIngred(address _to, int numPSKUsSold, ,string _url, uint _qttyIGRinLLSKU, string GTIN13, string YYMMDD )
368     // allows for sale of final-consumer  product with resp SKU and Lot identification with corresponding IGR transfer  with url
369     // i.e.: allows only the pro-rata quantity of semi-processed  InGRedient tokens to be transfered to the consumer level package(SKU)
370     // --------------------------------------------------------------------------------------------------
371     function comminglerSellsProductSKUWithProRataIngred(address _to, uint _numSKUsSold,string memory _url,uint _qttyIGRinLLSKU, string memory _GTIN13, string memory _YYMMDD ) public returns (bool success) {
372         string memory url=_url; // keep the url of hte InGRedient for later transfer
373         address c= genAddressFromGTIN13date( _GTIN13, _YYMMDD);
374         require (_qttyIGRinLLSKU >0); // qtty of Ingredient may not be negative nor zero
375         //write IGR qtty in one SKU and url  to the blockchain address composed of GTIN-13+YYMMDD
376         transferAndWriteUrl(c, _qttyIGRinLLSKU, _url);
377         //deduct IGRs sold by commingler  from its balances
378         transferAndWriteUrl(_to, (_numSKUsSold-1)*_qttyIGRinLLSKU,_url);// records the transfer of custody of the qtty of SKU each with qttyIGRinLLSKU
379         
380         
381         return true;
382     }
383 
384 
385 }