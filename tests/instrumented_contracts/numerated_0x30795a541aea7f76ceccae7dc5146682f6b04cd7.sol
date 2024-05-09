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
36 contract GraphenePowerToken is owned{
37     
38     //************** Token ************//
39 	string public standard = 'Token 1';
40 
41 	string public name = 'Graphene Power';
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
80     
81      //*** Balance ***//
82     mapping (address => uint256) public balanceOf;
83     
84     //*** Alowed ***//
85     mapping (address => mapping (address => uint256)) allowed;
86     
87     //*** Tranfer ***//
88     event Transfer(address from, address to, uint256 value);
89     
90 	//*** Approval ***//
91 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92 	
93 	//*** Destruction ***//
94 	event Destruction(uint256 _amount);
95 	
96 	//*** Burn ***//
97 	event Burn(address indexed from, uint256 value);
98 	
99 	//*** Issuance ***//
100 	event Issuance(uint256 _amount);
101 	
102 	function GraphenePowerToken() public{
103         preSaleAddress=0xC07850969A0EC345A84289f9C5bb5F979f27110f;
104         icoAddress=0x1C21Cf57BF4e2dd28883eE68C03a9725056D29F1;
105         advisersConsultantsAddress=0xe8B6dA1B801b7F57e3061C1c53a011b31C9315C7;
106         bountyAddress=0xD53E82Aea770feED8e57433D3D61674caEC1D1Be;
107         founderAddress=0xDA0D3Dad39165EA2d7386f18F96664Ee2e9FD8db;
108         totalSupply =500000000;
109         balanceOf[msg.sender]=totalSupply;
110 	}
111 
112 	//*** Payable ***//
113     function() payable public {
114         require(msg.value>0);
115         require(msg.sender != 0x0);
116         
117         uint256 weiAmount;
118         uint256 tokens;
119         wallet=owner;
120         
121         if(isPreSale()){
122             wallet=preSaleAddress;
123             weiAmount=6000;
124         }
125         else if(isIco()){
126             wallet=icoAddress;
127             
128             if((icoStart+(7*24*60*60)) >= now){
129                weiAmount=4000;
130             }
131             else if((icoStart+(14*24*60*60)) >= now){
132                  weiAmount=3750;
133             }
134             else if((icoStart+(21*24*60*60)) >= now){
135                  weiAmount=3500;
136             }
137             else if((icoStart+(28*24*60*60)) >= now){
138                  weiAmount=3250;
139             }
140             else if((icoStart+(35*24*60*60)) >= now){
141                  weiAmount=3000;
142             }
143             else{
144                 weiAmount=2000;
145             }
146         }
147         else{
148             weiAmount=4000;
149         }
150         
151         tokens=msg.value*weiAmount/1000000000000000000;
152         Transfer(this, msg.sender, tokens);
153         balanceOf[msg.sender]+=tokens;
154         totalSupply=(totalSupply-tokens);
155         wallet.transfer(msg.value);
156         balanceOf[this]+=msg.value;
157 	}
158 	
159 	/* Send coins */
160 	function transfer(address _to, uint256 _value) public returns (bool success) {
161 	    if(transfersEnabled){
162 		    require(balanceOf[_to] >= _value);
163 		    // Subtract from the sender
164 		    balanceOf[msg.sender] = (balanceOf[msg.sender] -_value);
165 	        balanceOf[_to] =(balanceOf[_to] + _value);
166 		    Transfer(msg.sender, _to, _value);
167 		    return true;
168 	    }
169 	    else{
170 	        return false;
171 	    }
172 	
173 	}
174 
175 	//*** Transfer From ***//
176 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
177 	    if(transfersEnabled){
178 	        // Check if the sender has enough
179 		    require(balanceOf[_from] >= _value);
180 		    // Check allowed
181 		    require(_value <= allowed[_from][msg.sender]);
182 
183 		    // Subtract from the sender
184 		    balanceOf[_from] = (balanceOf[_from] - _value);
185 		    // Add the same to the recipient
186 		    balanceOf[_to] = (balanceOf[_to] + _value);
187 
188 		    allowed[_from][msg.sender] = (allowed[_from][msg.sender] - _value);
189 		    Transfer(_from, _to, _value);
190 		    return true;
191 	    }
192 	    else{
193 	        return false;
194 	    }
195 	}
196 	
197 	//*** Transfer OnlyOwner ***//
198 	function transferOwner(address _to,uint256 _value) public onlyOwner returns(bool success){
199 	    // Subtract from the sender
200 	    totalSupply=(totalSupply-_value);
201 		// Add the same to the recipient
202 		balanceOf[_to] = (balanceOf[_to] + _value);
203 		Transfer(this, _to, _value);
204 	}
205 	
206 	//*** Allowance ***//
207 	function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
208 		return allowed[_owner][_spender];
209 	}
210 	
211 	//*** Approve ***//
212 	function approve(address _spender, uint256 _value) public returns (bool success) {
213 		allowed[msg.sender][_spender] = _value;
214 		Approval(msg.sender, _spender, _value);
215 		return true;
216 	}
217 	
218 	//*** Burn Owner***//
219 	function burnOwner(uint256 _value) public onlyOwner returns (bool success) {
220 		destroyOwner(msg.sender, _value);
221 		Burn(msg.sender, _value);
222 		return true;
223 	}
224 	
225 	//*** Destroy Owner ***//
226 	function destroyOwner(address _from, uint256 _amount) public onlyOwner{
227 	    balanceOf[_from] =(balanceOf[_from] - _amount);
228 		totalSupply = (totalSupply - _amount);
229 		Transfer(_from, this, _amount);
230 		Destruction(_amount);
231 	}
232 	
233 	//*** Kill Balance ***//
234 	function killBalance(uint256 _value) onlyOwner public {
235 		if(this.balance > 0) {
236 		    if(_value==1){
237 		        preSaleAddress.transfer(this.balance);
238 		        balanceOf[this]=0;
239 		    }
240 		    else if(_value==2){
241 		        icoAddress.transfer(this.balance);
242 		         balanceOf[this]=0;
243 		    }
244 		    else{
245 		        owner.transfer(this.balance);
246 		         balanceOf[this]=0;
247 		    }
248 		}
249 		else{
250 		    owner.transfer(this.balance);
251 		     balanceOf[this]=0;
252 		}
253 	}
254 	
255 	//*** Kill Tokens ***//
256 	function killTokens() onlyOwner public{
257 	    Transfer(this, bountyAddress, bountyTokens);
258 	    Transfer(this, founderAddress, founderTokens);
259 	    Transfer(this, advisersConsultantsAddress, advisersConsultantTokens);
260 	    totalSupply=totalSupply-(bountyTokens+founderTokens+advisersConsultantTokens);
261 	    bountyTokens=0;
262 	    founderTokens=0;
263 	    advisersConsultantTokens=0;
264 	}
265 	
266 	//*** Contract Balance ***//
267 	function contractBalance() constant public returns (uint256 balance) {
268 		return balanceOf[this];
269 	}
270 	
271 	//*** Set ParamsTransfer ***//
272 	function setParamsTransfer(bool _value) public onlyOwner{
273 	    transfersEnabled=_value;
274 	}
275 	
276 	//*** Set ParamsICO ***//
277     function setParamsIco(bool _value) public onlyOwner returns(bool result){
278         enableIco=_value;
279     }
280     
281 	//*** Set ParamsPreSale ***//
282     function setParamsPreSale(bool _value) public onlyOwner returns(bool result){
283         enablePreSale=_value;
284     }
285 	
286 	//*** Is ico ***//
287     function isIco() constant public returns (bool ico) {
288 		 bool result=((icoStart+(35*24*60*60)) >= now);
289 		 if(enableIco){
290 		     return true;
291 		 }
292 		 else{
293 		     return result;
294 		 }
295 	}
296     
297     //*** Is PreSale ***//
298     function isPreSale() constant public returns (bool preSale) {
299 		bool result=(preSaleEnd >= now);
300 		if(enablePreSale){
301 		    return true;
302 		}
303 		else{
304 		    return result;
305 		}
306 	}
307 }