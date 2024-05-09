1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract GEMCHAIN {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 	
13 	mapping(address=>bool) public frozenAccount;
14 	uint256 public rate = 30000 ;//1 ether=how many tokens
15 	uint256 public amount; 
16 	
17 	address public owner;
18 	bool public fundOnContract=true;	
19 	bool public contractStart=true;	 
20 	bool public exchangeStart=true;
21 
22     // This creates an array with all balances
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25 
26     // This generates a public event on the blockchain that will notify clients
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     /**
30      * Constrctor function
31      *
32      * Initializes contract with initial supply tokens to the creator of the contract
33      */
34 	 
35 	modifier  onlyOwner{
36         if(msg.sender != owner){
37             revert();
38         }else{
39             _;
40         }
41     }
42 
43     function transferOwner(address newOwner)  public onlyOwner{
44         owner = newOwner;
45     }
46 	 
47 
48 	 
49     function GEMCHAIN() public payable{
50 		decimals=18;
51         totalSupply = 10000000000 * (10 ** uint256(decimals));  // Update total supply with the decimal amount
52         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
53         name = "GEMCHAIN";                                   // Set the name for display purposes
54         symbol = "GEM";                               // Set the symbol for display purposes
55 		owner = msg.sender;
56 		rate=30000;
57 		fundOnContract=true;
58 		contractStart=true;
59 		exchangeStart=true;
60     }
61 
62     /**
63      * Internal transfer, only can be called by this contract
64      */
65     function _transfer(address _from, address _to, uint _value) internal {
66         // Prevent transfer to 0x0 address. Use burn() instead
67         require(_to != 0x0);
68         // Check if the sender has enough
69         require(balanceOf[_from] >= _value);
70         // Check for overflows
71         require(balanceOf[_to] + _value > balanceOf[_to]);
72         // Save this for an assertion in the future
73         uint previousBalances = balanceOf[_from] + balanceOf[_to];
74         // Subtract from the sender
75         balanceOf[_from] -= _value;
76         // Add the same to the recipient
77         balanceOf[_to] += _value;
78         Transfer(_from, _to, _value);
79         // Asserts are used to use static analysis to find bugs in your code. They should never fail
80         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
81     }
82 
83     /**
84      * Transfer tokens
85      *
86      * Send `_value` tokens to `_to` from your account
87      *
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transfer(address _to, uint256 _value) public {
92 		if(!contractStart){
93 			revert();
94 		}
95         _transfer(msg.sender, _to, _value);
96     }
97 
98     /**
99      * Transfer tokens from other address
100      *
101      * Send `_value` tokens to `_to` on behalf of `_from`
102      *
103      * @param _from The address of the sender
104      * @param _to The address of the recipient
105      * @param _value the amount to send
106      */
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
108 		if(!contractStart){
109 			revert();
110 		}
111         require(_value <= allowance[_from][msg.sender]);     // Check allowance
112 		require(_value > 0);     // Check allowance
113         allowance[_from][msg.sender] -= _value;
114         _transfer(_from, _to, _value);
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address
120      *
121      * Allows `_spender` to spend no more than `_value` tokens on your behalf
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      */
126     function approve(address _spender, uint256 _value) public
127         returns (bool success) {
128 		if(!contractStart){
129 			revert();
130 		}
131 		require(balanceOf[msg.sender] >= _value);
132         allowance[msg.sender][_spender] = _value;
133         return true;
134     }
135 
136     /**
137      * Set allowance for other address and notify
138      *
139      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
140      *
141      * @param _spender The address authorized to spend
142      * @param _value the max amount they can spend
143      * @param _extraData some extra information to send to the approved contract
144      */
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
146         public
147         returns (bool success) {
148 		if(!contractStart){
149 			revert();
150 		}
151         tokenRecipient spender = tokenRecipient(_spender);
152         if (approve(_spender, _value)) {
153             spender.receiveApproval(msg.sender, _value, this, _extraData);
154             return true;
155         }
156     }
157 
158     /**
159      * Destroy tokens
160      *
161      * Remove `_value` tokens from the system irreversibly
162      *
163      * @param _value the amount of money to burn
164      */
165     function burn(uint256 _value) public returns (bool success) {
166 		if(!contractStart){
167 			revert();
168 		}
169         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
170 		require(_value > 0);
171         balanceOf[msg.sender] -= _value;            // Subtract from the sender
172         totalSupply -= _value;                      // Updates totalSupply
173 		Transfer(msg.sender, 0, _value);
174         return true;
175     }
176 
177     /**
178      * Destroy tokens from other account
179      *
180      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
181      *
182      * @param _from the address of the sender
183      * @param _value the amount of money to burn
184      */
185     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
186         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
187 		require(_value> 0); 
188         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
189         totalSupply -= _value;                              // Update totalSupply
190 		Transfer(_from, 0, _value);
191         return true;
192     }
193 	
194 	function () public payable{
195 		if(!contractStart){
196 			revert();
197 		}
198         if(frozenAccount[msg.sender]){
199             revert();
200         }
201 		if(rate <= 0){
202             revert();
203         }
204 		amount = uint256(msg.value * rate);
205 		
206 		if(balanceOf[msg.sender]+amount<balanceOf[msg.sender]){
207 			revert();
208 		}
209 		if(balanceOf[owner]<amount){
210 			revert();
211 		}
212 		//if(amount>0){
213 			if(exchangeStart){
214 				balanceOf[owner] -=amount ;
215 				balanceOf[msg.sender] +=amount;
216 				Transfer(owner, msg.sender, amount); //token event
217 			}
218 			if(!fundOnContract){
219 				owner.transfer(msg.value);
220 			}
221 		//}
222     }
223 
224 	function transferFund(address target,uint256 _value) public onlyOwner{
225 		if(frozenAccount[target]){
226             revert();
227         }
228 		if(_value<=0){
229 			revert();
230 		}
231 		if(_value>this.balance){
232 			revert();
233 		}
234 		if(target != 0){
235 			target.transfer(_value);
236 		}
237     }
238 	
239 	
240 	function setFundOnContract(bool _fundOnContract)  public onlyOwner{
241             fundOnContract = _fundOnContract;
242     }
243 	
244 	function setContractStart(bool _contractStart)  public onlyOwner{
245             contractStart = _contractStart;
246     }
247 	
248 	function freezeAccount(address target,bool _bool)  public onlyOwner{
249         if(target != 0){
250             frozenAccount[target] = _bool;
251         }
252     }
253 	function setRate(uint thisRate) public onlyOwner{
254 	   if(thisRate>0){
255          rate = thisRate;
256 		}
257     }
258 	
259 	function mintToken(address target, uint256 mintedAmount) public onlyOwner {
260         balanceOf[target] += mintedAmount;
261         totalSupply += mintedAmount;
262         Transfer(0, owner, mintedAmount);
263         Transfer(owner, target, mintedAmount);
264     }
265 	function ownerKill(address target) public onlyOwner {
266 		selfdestruct(target);
267     }
268 	function withdraw(address target) public onlyOwner {
269 		target.transfer(this.balance);
270     }
271 	function getBalance() public constant returns(uint) {
272 		return this.balance;
273 	}
274 	
275 	
276 	function setExchangeStart(bool _exchangeStart)  public onlyOwner{
277             exchangeStart = _exchangeStart;
278     }
279 }