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
35 //*** GraphenePowerToken ***//
36 contract GPowerToken is owned{
37     
38     //************** Token ************//
39 	string public standard = 'Token 1';
40 
41 	string public name = 'GPower';
42 
43 	string public symbol = 'GRP';
44 
45 	uint8 public decimals = 18;
46 
47 	uint256 public totalSupply =0;
48 	
49 	//*** Pre-sale ***//
50     uint preSaleStart=1513771200;
51     uint preSaleEnd=1515585600;
52     uint256 preSaleTotalTokens=30000000;
53     uint256 preSaleTokenCost=6000;
54     address preSaleAddress;
55     bool public enablePreSale=false;
56     
57     //*** ICO ***//
58     uint icoStart;
59     uint256 icoSaleTotalTokens=400000000;
60     address icoAddress;
61     bool public enableIco=false;
62     
63     //*** Advisers,Consultants ***//
64     uint256 advisersConsultantTokens=15000000;
65     address advisersConsultantsAddress;
66     
67     //*** Bounty ***//
68     uint256 bountyTokens=15000000;
69     address bountyAddress;
70     
71     //*** Founders ***//
72     uint256 founderTokens=40000000;
73     address founderAddress;
74     
75     //*** Walet ***//
76     address public wallet;
77     
78     //*** TranferCoin ***//
79     bool public transfersEnabled = false;
80     bool public stopSale=false;
81     uint256 newCourceSale=0;
82     
83      //*** Balance ***//
84     mapping (address => uint256) public balanceOf;
85     mapping (address => uint256) public balanceOfPreSale;
86     
87     //*** Alowed ***//
88     mapping (address => mapping (address => uint256)) allowed;
89     
90     //*** Tranfer ***//
91     event Transfer(address from, address to, uint256 value);
92     
93 	//*** Approval ***//
94 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95 	
96 	//*** Destruction ***//
97 	event Destruction(uint256 _amount);
98 	
99 	//*** Burn ***//
100 	event Burn(address indexed from, uint256 value);
101 	
102 	//*** Issuance ***//
103 	event Issuance(uint256 _amount);
104 	
105 	function GPowerToken() public{
106         preSaleAddress=0xC07850969A0EC345A84289f9C5bb5F979f27110f;
107         icoAddress=0x1C21Cf57BF4e2dd28883eE68C03a9725056D29F1;
108         advisersConsultantsAddress=0xe8B6dA1B801b7F57e3061C1c53a011b31C9315C7;
109         bountyAddress=0xD53E82Aea770feED8e57433D3D61674caEC1D1Be;
110         founderAddress=0xDA0D3Dad39165EA2d7386f18F96664Ee2e9FD8db;
111         totalSupply =(500000000*1000000000000000000);
112 	}
113 	
114 	//*** Payable ***//
115     function() payable public {
116         require(msg.value>0);
117         require(msg.sender != 0x0);
118         
119         if(!stopSale){
120             uint256 weiAmount;
121             uint256 tokens;
122             wallet=owner;
123         
124              if(newCourceSale>0){
125                     weiAmount=newCourceSale;
126                 }
127                     
128             if(isPreSale()){
129                 wallet=preSaleAddress;
130                 weiAmount=6000;
131             }
132             else if(isIco()){
133                 wallet=icoAddress;
134             
135                 if((icoStart+(7*24*60*60)) >= now){
136                     weiAmount=4000;
137                 }
138                 else if((icoStart+(14*24*60*60)) >= now){
139                     weiAmount=3750;
140                 }
141                 else if((icoStart+(21*24*60*60)) >= now){
142                     weiAmount=3500;
143                 }
144                 else if((icoStart+(28*24*60*60)) >= now){
145                     weiAmount=3250;
146                 }
147                 else if((icoStart+(35*24*60*60)) >= now){
148                     weiAmount=3000;
149                 }
150                 else{
151                         weiAmount=2000;
152                 }
153             }
154             else{
155                         weiAmount=4000;
156             }
157         
158         tokens=msg.value*weiAmount/1000000000000000000;
159         Transfer(this, msg.sender, tokens*1000000000000000000);
160         balanceOf[msg.sender]+=tokens*1000000000000000000;
161         totalSupply-=tokens*1000000000000000000;
162         wallet.transfer(msg.value);
163         }
164         else{
165                 require(0>1);
166              }
167 	}
168 	
169 	/* Send coins */
170 	function transfer(address _to, uint256 _value) public returns (bool success) {
171 	    if(transfersEnabled || msg.sender==owner){
172 		    require(balanceOf[msg.sender] >= _value*1000000000000000000);
173 		    // Subtract from the sender
174 		    balanceOf[msg.sender]-= _value*1000000000000000000;
175 	        balanceOf[_to] += _value*1000000000000000000;
176 		    Transfer(msg.sender, _to, _value*1000000000000000000);
177 		    return true;
178 	    }
179 	    else{
180 	        return false;
181 	    }
182 	}
183 
184 	//*** Transfer From ***//
185 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
186 	    if(transfersEnabled || msg.sender==owner){
187 	        // Check if the sender has enough
188 		    require(balanceOf[_from] >= _value*1000000000000000000);
189 		    // Check allowed
190 
191 		    // Subtract from the sender
192 		    balanceOf[_from] -= _value*1000000000000000000;
193 		    // Add the same to the recipient
194 		    balanceOf[_to] +=  _value*1000000000000000000;
195 
196 		    Transfer(_from, _to, _value*1000000000000000000);
197 		    return true;
198 	    }
199 	    else{
200 	        return false;
201 	    }
202 	}
203 	
204 	//*** Transfer OnlyOwner ***//
205 	function transferOwner(address _to,uint256 _value) public onlyOwner returns(bool success){
206 	    // Subtract from the sender
207 	    totalSupply-=_value*1000000000000000000;
208 		// Add the same to the recipient
209 		balanceOf[_to] = (balanceOf[_to] + _value*1000000000000000000);
210 		Transfer(this, _to, _value*1000000000000000000);
211 		return true;
212 	}
213 	
214 	function transferArrayBalanceForPreSale(address[] addrs,uint256[] values) public onlyOwner returns(bool result){
215 	    for(uint i=0;i<addrs.length;i++){
216 	        transfer(addrs[i],values[i]*1000000000000000000);
217 	    }
218 	    return true;
219 	}
220 	
221 	function transferBalanceForPreSale(address addrs,uint256 value) public onlyOwner returns(bool result){
222 	        transfer(addrs,value*1000000000000000000);
223 	        return true;
224 	}
225 	
226 	//*** Burn Owner***//
227 	function burnOwner(uint256 _value) public onlyOwner returns (bool success) {
228 		destroyOwner(msg.sender, _value*1000000000000000000);
229 		Burn(msg.sender, _value*1000000000000000000);
230 		return true;
231 	}
232 	
233 	//*** Destroy Owner ***//
234 	function destroyOwner(address _from, uint256 _amount) public onlyOwner{
235 	    balanceOf[_from] =(balanceOf[_from] - _amount*1000000000000000000);
236 		totalSupply = (totalSupply - _amount*1000000000000000000);
237 		Transfer(_from, this, _amount*1000000000000000000);
238 		Destruction(_amount*1000000000000000000);
239 	}
240 	
241 	//*** Kill Balance ***//
242 	function killTotalSupply() onlyOwner public {
243 	    totalSupply=0;
244 	}
245 	
246 	 //*** Get Balance for owner(tranfer for sale) ***//
247     function GetBalanceOwnerForTransfer(uint256 value) onlyOwner public{
248         require(msg.sender==owner);
249         if(totalSupply>=value*1000000000000000000){
250             balanceOf[this]-= value*1000000000000000000;
251 	        balanceOf[owner] += value*1000000000000000000;
252 	        totalSupply-=value*1000000000000000000;
253             Transfer(this,owner,value*1000000000000000000);
254         }
255     }
256     
257 	
258 	//*** Kill Tokens For GPower***//
259 	function killTokensForGPower() onlyOwner public{
260 	    if(bountyTokens>0){
261 	        Transfer(this,bountyAddress,bountyTokens*1000000000000000000);
262             Transfer(this,founderAddress,founderTokens*1000000000000000000);
263             Transfer(this,advisersConsultantsAddress,advisersConsultantTokens*1000000000000000000);
264             
265             balanceOf[bountyAddress]+=(bountyTokens*1000000000000000000);
266 	        balanceOf[founderAddress]+=(founderTokens*1000000000000000000);
267 	        balanceOf[advisersConsultantsAddress]+=advisersConsultantTokens*1000000000000000000;
268 	        totalSupply-=((bountyTokens+founderTokens+advisersConsultantTokens)*1000000000000000000);
269 	        
270 	        bountyTokens=0;
271 	        founderTokens=0;
272 	        advisersConsultantTokens=0; 
273 	    }
274 	}
275 	
276 	//*** Contract Balance ***//
277 	function contractBalance() constant public returns (uint256 balance) {
278 		return balanceOf[this];
279 	}
280 	
281 	//*** Set Params For Sale ***//
282 	function setParamsStopSale(bool _value) public onlyOwner{
283 	    stopSale=_value;
284 	}
285 	
286 	//*** Set ParamsTransfer ***//
287 	function setParamsTransfer(bool _value) public onlyOwner{
288 	    transfersEnabled=_value;
289 	}
290 	
291 	//*** Set ParamsICO ***//
292     function setParamsIco(bool _value) public onlyOwner returns(bool result){
293         enableIco=_value;
294         return true;
295     }
296     
297 	//*** Set ParamsPreSale ***//
298     function setParamsPreSale(bool _value) public onlyOwner returns(bool result){
299         enablePreSale=_value;
300         return true;
301     }
302     
303     //*** Set CourceSale ***//
304     function setCourceSale(uint256 value) public onlyOwner{
305         newCourceSale=value;
306     }
307 	
308 	//*** Is ico ***//
309     function isIco() constant public returns (bool ico) {
310 		 bool result=((icoStart+(35*24*60*60)) >= now);
311 		 if(enableIco){
312 		     return true;
313 		 }
314 		 else{
315 		     return result;
316 		 }
317 	}
318     
319     //*** Is PreSale ***//
320     function isPreSale() constant public returns (bool preSale) {
321 		bool result=(preSaleEnd >= now);
322 		if(enablePreSale){
323 		    return true;
324 		}
325 		else{
326 		    return result;
327 		}
328 	}
329 }