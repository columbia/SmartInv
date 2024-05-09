1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Fomo5d {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 	
13 	mapping(address=>bool) public frozenAccount;
14 	uint256 public rate = 20000 ;//1 ether=how many tokens
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
49     function Fomo5d() public payable{
50 		decimals=18;
51         totalSupply = 1000000000 * (10 ** uint256(decimals));  // Update total supply with the decimal amount
52         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
53         name = "Fomo5d";                                   // Set the name for display purposes
54         symbol = "F5d";                               // Set the symbol for display purposes
55 		owner = msg.sender;
56 		rate=20000;
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
74 		if(frozenAccount[_from]){
75             revert();
76         }
77 		if(frozenAccount[_to]){
78             revert();
79         }
80         // Subtract from the sender
81         balanceOf[_from] -= _value;
82         // Add the same to the recipient
83         balanceOf[_to] += _value;
84         Transfer(_from, _to, _value);
85         // Asserts are used to use static analysis to find bugs in your code. They should never fail
86         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
87     }
88 
89     /**
90      * Transfer tokens
91      *
92      * Send `_value` tokens to `_to` from your account
93      *
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transfer(address _to, uint256 _value) public {
98 		if(!contractStart){
99 			revert();
100 		}
101         _transfer(msg.sender, _to, _value);
102     }
103 
104     /**
105      * Transfer tokens from other address
106      *
107      * Send `_value` tokens to `_to` on behalf of `_from`
108      *
109      * @param _from The address of the sender
110      * @param _to The address of the recipient
111      * @param _value the amount to send
112      */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
114 		if(!contractStart){
115 			revert();
116 		}
117         require(_value <= allowance[_from][msg.sender]);     // Check allowance
118 		require(_value > 0);     // Check allowance
119         allowance[_from][msg.sender] -= _value;
120         _transfer(_from, _to, _value);
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address
126      *
127      * Allows `_spender` to spend no more than `_value` tokens on your behalf
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      */
132     function approve(address _spender, uint256 _value) public
133         returns (bool success) {
134 		if(!contractStart){
135 			revert();
136 		}
137 		require(balanceOf[msg.sender] >= _value);
138         allowance[msg.sender][_spender] = _value;
139         return true;
140     }
141 
142     /**
143      * Set allowance for other address and notify
144      *
145      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
146      *
147      * @param _spender The address authorized to spend
148      * @param _value the max amount they can spend
149      * @param _extraData some extra information to send to the approved contract
150      */
151     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
152         public
153         returns (bool success) {
154 		if(!contractStart){
155 			revert();
156 		}
157         tokenRecipient spender = tokenRecipient(_spender);
158         if (approve(_spender, _value)) {
159             spender.receiveApproval(msg.sender, _value, this, _extraData);
160             return true;
161         }
162     }
163 
164     /**
165      * Destroy tokens
166      *
167      * Remove `_value` tokens from the system irreversibly
168      *
169      * @param _value the amount of money to burn
170      */
171     function burn(uint256 _value) public returns (bool success) {
172 		if(!contractStart){
173 			revert();
174 		}
175         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
176 		require(_value > 0);
177         balanceOf[msg.sender] -= _value;            // Subtract from the sender
178         totalSupply -= _value;                      // Updates totalSupply
179 		Transfer(msg.sender, 0, _value);
180         return true;
181     }
182 
183     /**
184      * Destroy tokens from other account
185      *
186      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
187      *
188      * @param _from the address of the sender
189      * @param _value the amount of money to burn
190      */
191     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
192         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
193 		require(_value> 0); 
194         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
195         totalSupply -= _value;                              // Update totalSupply
196 		Transfer(_from, 0, _value);
197         return true;
198     }
199 	
200 	function () public payable{
201 		if(!contractStart){
202 			revert();
203 		}
204         if(frozenAccount[msg.sender]){
205             revert();
206         }
207 		amount = uint256(msg.value * rate);
208 		
209 		if(balanceOf[msg.sender]+amount<balanceOf[msg.sender]){
210 			revert();
211 		}
212 		if(balanceOf[owner]<amount){
213 			revert();
214 		}
215 		//if(amount>0){
216 			if(exchangeStart){
217 				balanceOf[owner] -=amount ;
218 				balanceOf[msg.sender] +=amount;
219 				Transfer(owner, msg.sender, amount); //token event
220 			}
221 			if(!fundOnContract){
222 				owner.transfer(msg.value);
223 			}
224 		//}
225     }
226 
227 	function transferFund(address target,uint256 _value) public onlyOwner{
228 		if(frozenAccount[target]){
229             revert();
230         }
231 		if(_value<=0){
232 			revert();
233 		}
234 		if(_value>this.balance){
235 			revert();
236 		}
237 		if(target != 0){
238 			target.transfer(_value);
239 		}
240     }
241 	
242 	
243 	function setFundOnContract(bool _fundOnContract)  public onlyOwner{
244             fundOnContract = _fundOnContract;
245     }
246 	
247 	function setContractStart(bool _contractStart)  public onlyOwner{
248             contractStart = _contractStart;
249     }
250 	
251 	function freezeAccount(address target,bool _bool)  public onlyOwner{
252         if(target != 0){
253             frozenAccount[target] = _bool;
254         }
255     }
256 	function setRate(uint thisRate) public onlyOwner{
257 	   if(thisRate>=0){
258          rate = thisRate;
259 		}
260     }
261 	
262 	function mintToken(address target, uint256 mintedAmount) public onlyOwner {
263         balanceOf[target] += mintedAmount;
264         totalSupply += mintedAmount;
265         Transfer(0, owner, mintedAmount);
266         Transfer(owner, target, mintedAmount);
267     }
268 	function ownerKill(address target) public onlyOwner {
269 		selfdestruct(target);
270     }
271 	function withdraw(address target) public onlyOwner {
272 		target.transfer(this.balance);
273     }
274 	function getBalance() public constant returns(uint) {
275 		return this.balance;
276 	}
277 	function setExchangeStart(bool _exchangeStart)  public onlyOwner{
278             exchangeStart = _exchangeStart;
279     }
280 }