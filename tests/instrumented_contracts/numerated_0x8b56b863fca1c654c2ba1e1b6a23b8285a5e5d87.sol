1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
17 
18 contract TokenERC20 {
19     // Public variables of the token
20     string public name;
21     string public symbol;
22     uint8 public decimals = 18;
23     // 18 decimals is the strongly suggested default, avoid changing it
24     uint256 public totalSupply;
25 
26     // This creates an array with all balances
27     mapping (address => uint256) public balanceOf;
28     mapping (address => mapping (address => uint256)) public allowance;
29 
30     // This generates a public event on the blockchain that will notify clients
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     /**
34      * Constrctor function
35      *
36      * Initializes contract with initial supply tokens to the creator of the contract
37      */
38     function TokenERC20() public {
39         totalSupply = 200000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
40         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
41         name = "WaraCoin2";                                   // Set the name for display purposes
42         symbol = "WAC2";                               // Set the symbol for display purposes
43     }
44 
45     /**
46      * Internal transfer, only can be called by this contract
47      */
48     function _transfer(address _from, address _to, uint _value) internal {
49         // Prevent transfer to 0x0 address. Use burn() instead
50         require(_to != 0x0);
51         // Check if the sender has enough
52         require(balanceOf[_from] >= _value);
53         // Check for overflows
54         require(balanceOf[_to] + _value > balanceOf[_to]);
55         // Save this for an assertion in the future
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         // Subtract from the sender
58         balanceOf[_from] -= _value;
59         // Add the same to the recipient
60         balanceOf[_to] += _value;
61         Transfer(_from, _to, _value);
62         // Asserts are used to use static analysis to find bugs in your code. They should never fail
63         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
64     }
65 
66     /**
67      * Transfer tokens
68      *
69      * Send `_value` tokens to `_to` from your account
70      *
71      * @param _to The address of the recipient
72      * @param _value the amount to send
73      */
74     function transfer(address _to, uint256 _value) public {
75         _transfer(msg.sender, _to, _value);
76     }
77 
78     /**
79      * Transfer tokens from other address
80      *
81      * Send `_value` tokens to `_to` in behalf of `_from`
82      *
83      * @param _from The address of the sender
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]);     // Check allowance
89         allowance[_from][msg.sender] -= _value;
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 
94     /**
95      * Set allowance for other address
96      *
97      * Allows `_spender` to spend no more than `_value` tokens in your behalf
98      *
99      * @param _spender The address authorized to spend
100      * @param _value the max amount they can spend
101      */
102     function approve(address _spender, uint256 _value) public
103         returns (bool success) {
104         allowance[msg.sender][_spender] = _value;
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address and notify
110      *
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      * @param _extraData some extra information to send to the approved contract
116      */
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
118         public
119         returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, this, _extraData);
123             return true;
124         }
125     }
126 }
127 
128 contract  WaraCoin is owned, TokenERC20 {
129     
130     uint256 public sale_step;
131     
132     address waracoin_corp;
133 
134     /* Save product's genuine information */
135     struct Product_genuine
136     {
137         address m_made_from_who;  // who made this product 
138         
139         string m_Product_GUID;    // product's unique code
140         string m_Product_Description; // product's description
141         address m_who_have;       // who have this product now
142         address m_send_to_who;    // when product move to agency - if it is different with seller, it means that seller have no genuine  
143         string m_hash;  // need to check hash of description
144         
145         uint256 m_moved_count;  // how many times moved this product
146     }
147     
148     mapping (address => mapping (uint256 => Product_genuine)) public MyProducts;
149     
150     
151     /* Initializes contract with initial supply tokens to the creator of the contract */
152     function WaraCoin() TokenERC20()  public 
153     {
154         sale_step = 0;  // 0 : No sale, 1 : Presale, 2 : Crowdsale, 3 : Normalsale 
155         waracoin_corp = msg.sender;
156     }
157     
158     function SetSaleStep(uint256 step) onlyOwner public
159     {
160         sale_step = step;
161     }
162 
163     /* Set Waracoin sale price */
164     function () payable 
165     {
166         require(sale_step!=0);
167         
168         if ( msg.sender != owner )  // If owner send Ether, it will use for dApp operation
169         {
170             uint amount = 0;
171             uint nowprice = 0;
172             
173             if ( sale_step == 1  )
174                 nowprice = 10000;   // presale price
175             else
176                 if ( sale_step == 2 )
177                     nowprice = 5000;    // crowdsale price
178                 else
179                     nowprice = 1000;    // normalsale price
180                     
181             amount = msg.value * nowprice; 
182             
183             require(balanceOf[waracoin_corp]>=amount);
184             
185             balanceOf[waracoin_corp] -= amount;
186             balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
187             require(waracoin_corp.send(msg.value));
188             Transfer(this, msg.sender, amount);               // execute an event reflecting the change
189         }
190     }
191 
192     /**
193      * Seller will send WaraCoin to buyer
194      *
195      * @param _to The address of backers who have WaraCoin
196      * @param coin_amount How many WaraCoin will send
197      */
198     function waraCoinTransfer(address _to, uint256 coin_amount) public
199     {
200         uint256 amount = coin_amount * 10 ** uint256(decimals);
201 
202         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
203         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
204         balanceOf[_to] += amount;                  // subtracts the amount from seller's balance
205         Transfer(msg.sender, _to, amount);               // executes an event reflecting on the change
206     }
207 
208     /**
209      * Owner will buy back WaraCoin from backers
210      *
211      * @param _from The address of backers who have WaraCoin
212      * @param coin_amount How many WaraCoin will buy back from him
213      */
214     function DestroyCoin(address _from, uint256 coin_amount) onlyOwner public 
215     {
216         uint256 amount = coin_amount * 10 ** uint256(decimals);
217 
218         require(balanceOf[_from] >= amount);         // checks if the sender has enough to sell
219         balanceOf[_from] -= amount;                  // subtracts the amount from seller's balance
220         Transfer(_from, this, amount);               // executes an event reflecting on the change
221     }    
222     
223     /**
224      * Here is WaraCoin's Genuine dApp functions
225     */
226     
227     /* When creator made product, must need to use this fuction for register his product first */
228     function registerNewProduct(uint256 product_idx,string new_guid,string product_descriptions,string hash) public returns(bool success)
229     {
230         uint256 amount = 1 * 10 ** uint256(decimals-2);        
231         
232         require(balanceOf[msg.sender]>=amount);   // Need to use one WaraCoin for make product code
233         
234         Product_genuine storage mine = MyProducts[msg.sender][product_idx];
235         
236         require(mine.m_made_from_who!=msg.sender);
237         
238         mine.m_made_from_who = msg.sender;
239         mine.m_who_have = msg.sender;
240         mine.m_Product_GUID = new_guid;
241         mine.m_Product_Description = product_descriptions;
242         mine.m_hash = hash;
243 
244         balanceOf[msg.sender] -= amount;
245         return true;        
246     }
247     
248     /* If product's owner want to move, he need to use this fuction for setting receiver : must use by sender */  
249     function setMoveProductToWhom(address who_made_this,uint256 product_idx,address moveto) public returns (bool success)
250     {
251         Product_genuine storage mine = MyProducts[who_made_this][product_idx];
252         
253         require(mine.m_who_have==msg.sender);
254         
255         mine.m_send_to_who = moveto;
256 
257         return true;
258     }
259     
260     /* Product's buyer need to use this function for save his genuine */
261     function moveProduct(address who_made_this,address who_have_this,uint256 product_idx) public returns (bool success)
262     {
263         uint256 amount = 1 * 10 ** uint256(decimals-2);        
264 
265         require(balanceOf[msg.sender]>=amount);   // Need to use one WaraCoin for move product
266         
267         Product_genuine storage mine = MyProducts[who_made_this][product_idx];
268         
269         require(mine.m_who_have==who_have_this);    // if sender have no product, break
270         require(mine.m_send_to_who==msg.sender);    // if receiver is not me, break
271 
272         mine.m_who_have = msg.sender;
273         mine.m_moved_count += 1;
274         
275         balanceOf[msg.sender] -= amount;
276         
277         return true;
278     }
279 
280     /* Check Genuine of owner */
281     function checkProductGenuine(address who_made_this,address who_have_this,uint256 product_idx) public returns (bool success)
282     {
283         success = false;
284         
285         Product_genuine storage mine = MyProducts[who_made_this][product_idx];
286         if ( mine.m_who_have==who_have_this )    // if checker have no product, break
287             success = true;
288             
289         return success;
290     }
291     
292 }