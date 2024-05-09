1 pragma solidity ^0.4.18;
2 
3 //*** Owner ***//
4 contract owned {
5 	address public owner;
6     
7     //*** OwnershipTransferred ***//
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 	function owned() public {
11 		owner = msg.sender;
12 	}
13 
14     //*** Change Owner ***//
15 	function changeOwner(address newOwner) onlyOwner public {
16 		owner = newOwner;
17 	}
18     
19     //*** Transfer OwnerShip ***//
20     function transferOwnership(address newOwner) onlyOwner public {
21         require(newOwner != address(0));
22         OwnershipTransferred(owner, newOwner);
23         owner = newOwner;
24     }
25     
26     //*** Only Owner ***//
27 	modifier onlyOwner {
28 		require(msg.sender == owner);
29 		_;
30 	}
31 }
32 
33 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
34 
35 //*** Utils ***//
36 contract Utils {
37     
38 	// validates an address - currently only checks that it isn't null
39 	modifier validAddress(address _address) {
40 		require(_address != 0x0);
41 		_;
42 	}
43 
44 	// verifies that the address is different than this contract address
45 	modifier notThis(address _address) {
46 		require(_address != address(this));
47 		_;
48 	}
49 }
50 
51 //*** GraphenePowerToken ***//
52 contract GraphenePowerToken is owned,Utils{
53     
54     //************** Token ************//
55 	string public standard = 'Token 0.1';
56 
57 	string public name = 'Graphene Power';
58 
59 	string public symbol = 'GRP';
60 
61 	uint8 public decimals = 18;
62 
63 	uint256 _totalSupply =0;
64 	
65 	//*** Pre-sale ***//
66     uint preSaleStart=1513771200;
67     uint preSaleEnd=1515585600;
68     uint256 preSaleTotalTokens=30000000;
69     uint256 preSaleTokenCost=6000;
70     address preSaleAddress;
71     bool enablePreSale=false;
72     
73     //*** ICO ***//
74     uint icoStart;
75     uint256 icoSaleTotalTokens=400000000;
76     address icoAddress;
77     bool enableIco=false;
78     
79     //*** Advisers,Consultants ***//
80     uint256 advisersConsultantTokens=15000000;
81     address advisersConsultantsAddress;
82     
83     //*** Bounty ***//
84     uint256 bountyTokens=15000000;
85     address bountyAddress;
86     
87     //*** Founders ***//
88     uint256 founderTokens=40000000;
89     address founderAddress;
90     
91     //*** Walet ***//
92     address public wallet;
93     
94     //*** Mint ***//
95     bool enableMintTokens=true;
96     
97     //*** TranferCoin ***//
98     bool public transfersEnabled = false;
99     
100      //*** Balance ***//
101     mapping (address => uint256) balanceOf;
102     
103     //*** Alowed ***//
104     mapping (address => mapping (address => uint256)) allowed;
105     
106     //*** Tranfer ***//
107     event Transfer(address from, address to, uint256 value);
108     
109 	//*** Approval ***//
110 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
111 	
112 	//*** Destruction ***//
113 	event Destruction(uint256 _amount);
114 	
115 	//*** Burn ***//
116 	event Burn(address indexed from, uint256 value);
117 	
118 	//*** Issuance ***//
119 	event Issuance(uint256 _amount);
120 	
121 	function GraphenePowerToken() public{
122         preSaleAddress=0xC07850969A0EC345A84289f9C5bb5F979f27110f;
123         icoAddress=0x1C21Cf57BF4e2dd28883eE68C03a9725056D29F1;
124         advisersConsultantsAddress=0xe8B6dA1B801b7F57e3061C1c53a011b31C9315C7;
125         bountyAddress=0xD53E82Aea770feED8e57433D3D61674caEC1D1Be;
126         founderAddress=0xDA0D3Dad39165EA2d7386f18F96664Ee2e9FD8db;
127         _totalSupply =500000000;
128         balanceOf[this]=_totalSupply;
129 	}
130 	
131 	 //*** Check Transfer ***//
132     modifier transfersAllowed {
133 		assert(transfersEnabled);
134 		_;
135 	}
136 	
137 	//*** ValidAddress ***//
138 	modifier validAddress(address _address) {
139 		require(_address != 0x0);
140 		_;
141 	}
142 
143 	//*** Not This ***//
144 	modifier notThis(address _address) {
145 		require(_address != address(this));
146 		_;
147 	}
148 	
149 	   //*** Payable ***//
150     function() payable public {
151         require(msg.value>0);
152         buyTokens(msg.sender);
153 	}
154 	
155 	//*** Buy Tokens ***//
156 	function buyTokens(address beneficiary) payable public {
157         require(beneficiary != 0x0);
158 
159         uint256 weiAmount;
160         uint256 tokens;
161         wallet=owner;
162         
163         if(isPreSale()){
164             wallet=preSaleAddress;
165             weiAmount=6000;
166         }
167         else if(isIco()){
168             wallet=icoAddress;
169             
170             if((icoStart+(7*24*60*60)) >= now){
171                weiAmount=4000;
172             }
173             else if((icoStart+(14*24*60*60)) >= now){
174                  weiAmount=3750;
175             }
176             else if((icoStart+(21*24*60*60)) >= now){
177                  weiAmount=3500;
178             }
179             else if((icoStart+(28*24*60*60)) >= now){
180                  weiAmount=3250;
181             }
182             else if((icoStart+(35*24*60*60)) >= now){
183                  weiAmount=3000;
184             }
185             else{
186                 weiAmount=2000;
187             }
188         }
189         else{
190             weiAmount=6000;
191         }
192         
193         forwardFunds();
194         tokens=msg.value*weiAmount/1000000000000000000;
195         mintToken(beneficiary, tokens);
196         Transfer(this, beneficiary, tokens);
197      }
198     
199     //*** ForwardFunds ***//
200     function forwardFunds() internal {
201         wallet.transfer(msg.value);
202     }
203     
204     //*** GetTokensForGraphenePower ***//
205 	function getTokensForGraphenePower() onlyOwner public returns(bool result){
206 	    require(enableMintTokens);
207 	    mintToken(bountyAddress, bountyTokens);
208 	    Transfer(this, bountyAddress, bountyTokens);
209 	    mintToken(founderAddress, founderTokens);
210 	    Transfer(this, founderAddress, founderTokens);
211 	    mintToken(advisersConsultantsAddress, advisersConsultantTokens);
212         Transfer(this, advisersConsultantsAddress, advisersConsultantTokens);
213 	    return true;
214 	}
215 	
216 	//*** Allowance ***//
217 	function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
218 		return allowed[_owner][_spender];
219 	}
220 	
221 	/* Send coins */
222 	function transfer(address _to, uint256 _value) transfersAllowed public returns (bool success) {
223 		require(balanceOf[_to] >= _value);
224 		// Subtract from the sender
225 		balanceOf[msg.sender] = (balanceOf[msg.sender] -_value);
226 		balanceOf[_to] =(balanceOf[_to] + _value);
227 		Transfer(msg.sender, _to, _value);
228 		return true;
229 	}
230 	
231 	//*** MintToken ***//
232 	function mintToken(address target, uint256 mintedAmount) onlyOwner public returns(bool result) {
233 	    if(enableMintTokens){
234 	        balanceOf[target] += mintedAmount;
235 		    _totalSupply =(_totalSupply-mintedAmount);
236 		    Transfer(this, target, mintedAmount);
237 		    return true;
238 	    }
239 	    else{
240 	        return false;
241 	    }
242 	}
243 	
244 	//*** Approve ***//
245 	function approve(address _spender, uint256 _value) public returns (bool success) {
246 		allowed[msg.sender][_spender] = _value;
247 		Approval(msg.sender, _spender, _value);
248 		return true;
249 	}
250 	
251 	//*** Transfer From ***//
252 	function transferFrom(address _from, address _to, uint256 _value) transfersAllowed public returns (bool success) {
253 	    require(transfersEnabled);
254 		// Check if the sender has enough
255 		require(balanceOf[_from] >= _value);
256 		// Check allowed
257 		require(_value <= allowed[_from][msg.sender]);
258 
259 		// Subtract from the sender
260 		balanceOf[_from] = (balanceOf[_from] - _value);
261 		// Add the same to the recipient
262 		balanceOf[_to] = (balanceOf[_to] + _value);
263 
264 		allowed[_from][msg.sender] = (allowed[_from][msg.sender] - _value);
265 		Transfer(_from, _to, _value);
266 		return true;
267 	}
268 	
269 	//*** Issue ***//
270 	function issue(address _to, uint256 _amount) public onlyOwner validAddress(_to) notThis(_to) {
271 		_totalSupply = (_totalSupply - _amount);
272 		balanceOf[_to] = (balanceOf[_to] + _amount);
273 		Issuance(_amount);
274 		Transfer(this, _to, _amount);
275 	}
276 	
277 	//*** Burn ***//
278 	function burn(uint256 _value) public returns (bool success) {
279 		destroy(msg.sender, _value);
280 		Burn(msg.sender, _value);
281 		return true;
282 	}
283 	
284 	//*** Destroy ***//
285 	function destroy(address _from, uint256 _amount) public {
286 	    require(msg.sender == _from);
287 	    require(balanceOf[_from] >= _amount);
288 		balanceOf[_from] =(balanceOf[_from] - _amount);
289 		_totalSupply = (_totalSupply - _amount);
290 		Transfer(_from, this, _amount);
291 		Destruction(_amount);
292 	}
293 	
294 	//Kill
295 	function killBalance() onlyOwner public {
296 		require(!enablePreSale && !enableIco);
297 		if(this.balance > 0) {
298 			owner.transfer(this.balance);
299 		}
300 	}
301 	
302 	//Mint tokens
303 	function enabledMintTokens(bool value) onlyOwner public returns(bool result) {
304 		enableMintTokens = value;
305 		return enableMintTokens;
306 	}
307 	
308 	//*** Contract Balance ***//
309 	function contractBalance() constant public returns (uint256 balance) {
310 		return balanceOf[this];
311 	}
312 	
313 	//Satart PreSale
314 	function startPreSale() onlyOwner public returns(bool result){
315 	    enablePreSale=true;
316 	    return enablePreSale;
317 	}
318 	
319 	//End PreSale
320 	function endPreSale() onlyOwner public returns(bool result){
321 	     enablePreSale=false;
322 	    return enablePreSale;
323 	}
324 	
325 	//Start ICO
326 	function startIco() onlyOwner public returns(bool result){
327 	    enableIco=true;
328 	    return enableIco;
329 	}
330 	
331 	//End ICO
332 	function endIco() onlyOwner public returns(bool result){
333 	     enableIco=false;
334 	     return enableIco;
335 	}
336 	
337 	//*** Is ico closed ***//
338     function isIco() constant public returns (bool closed) {
339 		 bool result=((icoStart+(35*24*60*60)) >= now);
340 		 if(enableIco){
341 		     return true;
342 		 }
343 		 else{
344 		     return result;
345 		 }
346 	}
347     
348     //*** Is preSale closed ***//
349     function isPreSale() constant public returns (bool closed) {
350 		bool result=(preSaleEnd >= now);
351 		if(enablePreSale){
352 		    return true;
353 		}
354 		else{
355 		    return result;
356 		}
357 	}
358 }