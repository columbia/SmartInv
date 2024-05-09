1 pragma solidity ^0.4.21;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract owned {
6     address public owner;
7     bool public ownershipTransferAllowed = false;
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function allowTransferOwnership(bool flag ) public onlyOwner {
19       ownershipTransferAllowed = flag;
20     }
21  
22     function transferOwnership(address newOwner) public onlyOwner {
23         require( newOwner != 0x0 );                                             // not to 0x0
24         require( ownershipTransferAllowed );                                 
25         owner = newOwner;
26         ownershipTransferAllowed = false;
27     }
28 }
29 
30 contract ECR20HoneycombToken is owned {
31     // Public variables of the token
32     string public name = "Honeycomb";
33     string public symbol = "COMB";
34     uint8 public decimals = 18;
35     
36     // used for buyPrice
37     uint256 private tokenFactor = 10 ** uint256(decimals);
38     uint256 private initialBuyPrice = 3141592650000000000000;                   // PI Token per Finney
39     uint256 private buyConst1 = 10000 * tokenFactor;                            // Faktor for buy price calculation
40     uint256 private buyConst2 = 4;                                              // Faktor for buy price calculation
41     
42     uint256 public minimumPayout = 1000000000000000;							// minimal payout initially to 0.001 ether
43        
44     uint256 public totalSupply;                                                 // total number of issued tokent
45 
46 	// price token are sold/bought
47     uint256 public sellPrice;
48     uint256 public buyPrice;
49 
50     // This creates an array with all balances
51     mapping (address => uint256) public balanceOf;
52     mapping (address => mapping (address => uint256)) public allowance;
53 
54     // This generates a public event on the blockchain that will notify clients
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     /**
58      * Constructor function
59      *
60      * Initializes contract with initial supply tokens to the creator of the contract
61      */
62     constructor() public {
63         totalSupply = 1048576 * tokenFactor;                                    // token total created
64         balanceOf[msg.sender] = totalSupply;                                    // Give the creator all initial tokens
65         owner = msg.sender;			                                            // assign ownership of contract to initial coin holder
66         emit Transfer(0, owner, totalSupply);                                   // notify event owner
67         _transfer(owner, this, totalSupply - (16384*tokenFactor));              // transfer token to contract
68         _setPrices(_newPrice(balanceOf[this]));                                 // set prices according to token left
69     }
70     /**
71      * Calculate new price based on a new token left
72      * 
73      * @param tokenLeft new token left on contract after transaction
74     **/
75     function _newPrice(uint256 tokenLeft) internal view returns (uint256 newPrice) {
76         newPrice = initialBuyPrice 
77             * ( tokenLeft * buyConst1 )
78             / ( totalSupply*buyConst1 + totalSupply*tokenLeft/buyConst2 - tokenLeft*tokenLeft/buyConst2 ); 
79         return newPrice;
80     }
81 
82     function _setPrices(uint256 newPrice) internal {
83         buyPrice = newPrice;
84         sellPrice = buyPrice * 141421356 / 100000000;                           // sellPrice is sqrt(2) higher
85     }
86 
87 	/**
88 	 * Called when token are bought by sending ether
89 	 * 
90 	 * @return amount amount of token bought
91 	 **/
92 	function buy() payable public returns (uint256 amountToken){
93         amountToken = msg.value * buyPrice / tokenFactor;                       // calculates the amount of token
94         uint256 newPrice = _newPrice(balanceOf[this] - amountToken);            // calc new price after transfer
95         require( (2*newPrice) > sellPrice);                                     // check whether new price is not lower than sqrt(2) of old one
96         _transfer(this, msg.sender, amountToken);                               // transfer token from contract to buyer
97         _setPrices( newPrice );                                                 // update prices after transfer
98         return amountToken;
99     }
100 
101     /**
102       Fallback function
103     **/
104 	function () payable public {
105 	    buy();
106     }
107 
108     /**
109      * Sell token back to contract
110      * 
111      * @param amountToken The amount of token in wei 
112      * 
113      * @return eth to receive in wei
114      **/
115     function sell(uint256 amountToken) public returns (uint256 revenue){
116         revenue = amountToken * tokenFactor / sellPrice;                        // calulate the revenue in Wei
117         require( revenue >= minimumPayout );									// check whether selling get more ether than the minimum payout
118         uint256 newPrice = _newPrice(balanceOf[this] + amountToken);            // calc new price after transfer
119         require( newPrice < sellPrice );                                        // check whether new price is more than sell price
120         _transfer(msg.sender, this, amountToken);                               // transfer token back to contract
121         _setPrices( newPrice );                                                 // update prices after transfer
122         msg.sender.transfer(revenue);                                           // send ether to seller
123         return revenue;
124     }
125 		
126     /**
127      * Transfer tokens
128      *
129      * Send `_value` tokens to `_to` from your account
130      *
131      * @param _to The address of the recipient
132      * @param _value the amount to send
133      */
134     function transfer(address _to, uint256 _value) public {
135         if ( _to  == address(this) )
136         {
137           sell(_value);                                                         // sending token to a contract means selling them
138         }
139         else
140         {
141           _transfer(msg.sender, _to, _value);
142         }
143     }
144 
145     /**
146      * Transfer tokens from other address
147      *
148      * Send `_value` tokens to `_to` on behalf of `_from`
149      *
150      * @param _from The address of the sender
151      * @param _to The address of the recipient
152      * @param _value the amount to send
153      */
154     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
155         require(_value <= allowance[_from][msg.sender]);     // Check allowance
156         allowance[_from][msg.sender] -= _value;
157         _transfer(_from, _to, _value);
158         return true;
159     }
160 
161     /**
162      * Set allowance for other address
163      *
164      * Allows `_spender` to spend no more than `_value` tokens on your behalf
165      *
166      * @param _spender The address authorized to spend
167      * @param _value the max amount they can spend
168      */
169     function approve(address _spender, uint256 _value) public
170         returns (bool success) {
171         allowance[msg.sender][_spender] = _value;
172         return true;
173     }
174 
175     /**
176      * Set allowance for other address and notify
177      *
178      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
179      *
180      * @param _spender The address authorized to spend
181      * @param _value the max amount they can spend
182      * @param _extraData some extra information to send to the approved contract
183      */
184     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
185         tokenRecipient spender = tokenRecipient(_spender);
186         if (approve(_spender, _value)) {
187             spender.receiveApproval(msg.sender, _value, this, _extraData);
188             return true;
189         }
190     }
191 
192 	/**
193      * set minimumPayout price
194      * 
195      * @param amount minimumPayout amount in Wei
196      */
197 		function setMinimumPayout(uint256 amount) public onlyOwner {
198 		minimumPayout = amount;
199     }
200 		
201 	/**
202      * save ether to owner account
203      * 
204      * @param amount amount in Wei
205      */
206 		function save(uint256 amount) public onlyOwner {
207         require( amount >= minimumPayout );	
208         owner.transfer( amount);
209     }
210 		
211 	/**
212      * Give back token to contract bypassing selling from owner account
213      * 
214      * @param amount amount of token in wei
215      */
216 		function restore(uint256 amount) public onlyOwner {
217         uint256 newPrice = _newPrice(balanceOf[this] + amount);                 // calc new price after transfer
218         _transfer(owner, this, amount );                                        // transfer token back to contract
219         _setPrices( newPrice );                                                 // update prices after transfer
220     }
221 		
222 	/**
223      * Internal transfer, can be called only by this contract
224      */
225     function _transfer(address _from, address _to, uint _value) internal {
226         // Prevent transfer to 0x0 address. Use burn() instead
227         require(_to != 0x0);
228         // Check if the sender has enough
229         require(balanceOf[_from] >= _value);
230         // Check for overflows
231         require(balanceOf[_to] + _value > balanceOf[_to]);
232         // Save this for an assertion in the future
233         uint previousBalances = balanceOf[_from] + balanceOf[_to];
234         // Subtract from the sender
235         balanceOf[_from] -= _value;
236         // Add the same to the recipient
237         balanceOf[_to] += _value;
238         emit Transfer(_from, _to, _value);
239         // Asserts are used to use static analysis to find bugs in your code. They should never fail
240         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
241     }
242 
243 }