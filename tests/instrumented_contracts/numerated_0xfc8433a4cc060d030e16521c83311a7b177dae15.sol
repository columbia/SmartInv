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
39         totalSupply = 100000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
40         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
41         name = "WaraCoin";                                   // Set the name for display purposes
42         symbol = "WAC";                               // Set the symbol for display purposes
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
130     
131     uint256 public waracoin_per_ether;
132     
133     address waracoin_corp;
134     uint256 presale_deadline_count;
135     uint256 crowdsale_deadline_count;
136     
137     /* Save product's genuine information */
138     struct Product_genuine
139     {
140         address m_made_from_who;  // who made this product 
141         
142         string m_Product_GUID;    // product's unique code
143         string m_Product_Description; // product's description
144         address m_who_have;       // who have this product now
145         address m_send_to_who;    // when product move to agency - if it is different with seller, it means that seller have no genuine  
146         string m_hash;  // need to check hash of description
147         
148         uint256 m_moved_count;  // how many times moved this product
149     }
150     
151     mapping (address => mapping (uint256 => Product_genuine)) public MyProducts;
152     
153     
154     /* Initializes contract with initial supply tokens to the creator of the contract */
155     function WaraCoin() TokenERC20()  public 
156     {
157         presale_deadline_count = 25000000 * 10 ** uint256(decimals);  // after sale this counts will close presale 
158         crowdsale_deadline_count = 50000000 * 10 ** uint256(decimals);    // after sale this counts will close crowdsale
159         waracoin_corp = msg.sender;
160         waracoin_per_ether = 10000;
161     }
162 
163     /**
164      * Set Waracoin sale price
165      *
166      * @param coincount One counts per one ether
167      */
168     function setWaracoinPerEther(uint256 coincount) onlyOwner public 
169     {
170         waracoin_per_ether = coincount;
171     }
172 
173     /* Set Waracoin sale price */
174     function () payable 
175     {
176         if ( msg.sender != owner )  // If owner send Ether, it will use for dApp operation
177         {
178             uint amount = 0;
179             uint nowprice = 0;
180             
181             if ( presale_deadline_count > 0  )
182                 nowprice = 10000;   // presale price
183             else
184                 if ( crowdsale_deadline_count > 0)
185                     nowprice = 5000;    // crowdsale price
186                 else
187                     nowprice = 1000;    // normalsale price
188                     
189             amount = msg.value * nowprice; 
190             
191             if ( presale_deadline_count != 0 )
192             {
193                 if ( presale_deadline_count > amount )
194                     presale_deadline_count -= amount;
195                 else
196                     presale_deadline_count = 0;
197             }
198             else
199                 if ( crowdsale_deadline_count != 0 )
200                 {
201                     if ( crowdsale_deadline_count > amount )
202                         crowdsale_deadline_count -= amount;
203                     else
204                         crowdsale_deadline_count = 0;
205                 }
206                 else
207                     totalSupply += amount;
208     
209             balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
210             require(waracoin_corp.send(msg.value));
211             Transfer(this, msg.sender, amount);               // execute an event reflecting the change
212         }
213     }
214 
215     /**
216      * Seller will send WaraCoin to buyer
217      *
218      * @param _to The address of backers who have WaraCoin
219      * @param coin_amount How many WaraCoin will send
220      */
221     function waraCoinTransfer(address _to, uint256 coin_amount) public
222     {
223         uint256 amount = coin_amount * 10 ** uint256(decimals);
224 
225         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
226         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
227         balanceOf[_to] += amount;                  // subtracts the amount from seller's balance
228         Transfer(msg.sender, _to, amount);               // executes an event reflecting on the change
229     }
230 
231     /**
232      * Owner will buy back WaraCoin from backers
233      *
234      * @param _from The address of backers who have WaraCoin
235      * @param coin_amount How many WaraCoin will buy back from him
236      */
237     function buyFrom(address _from, uint256 coin_amount) onlyOwner public 
238     {
239         uint256 amount = coin_amount * 10 ** uint256(decimals);
240         uint need_to_pay = amount / waracoin_per_ether;
241         
242         require(this.balance >= need_to_pay);
243         require(balanceOf[_from] >= amount);         // checks if the sender has enough to sell
244         balanceOf[_from] -= amount;                  // subtracts the amount from seller's balance
245         _from.transfer(need_to_pay);                // sends ether to the seller: it's important to do this last to prevent recursion attacks
246         Transfer(_from, this, amount);               // executes an event reflecting on the change
247     }    
248     
249     /**
250      * Here is WaraCoin's Genuine dApp functions
251     */
252     
253     /* When creator made product, must need to use this fuction for register his product first */
254     function registerNewProduct(uint256 product_idx,string new_guid,string product_descriptions,string hash) public returns(bool success)
255     {
256         uint256 amount = 1 * 10 ** uint256(decimals);        
257         
258         require(balanceOf[msg.sender]>=amount);   // Need to use one WaraCoin for make product code
259         
260         Product_genuine storage mine = MyProducts[msg.sender][product_idx];
261         
262         require(mine.m_made_from_who!=msg.sender);
263         
264         mine.m_made_from_who = msg.sender;
265         mine.m_who_have = msg.sender;
266         mine.m_Product_GUID = new_guid;
267         mine.m_Product_Description = product_descriptions;
268         mine.m_hash = hash;
269 
270         balanceOf[msg.sender] -= amount;
271         return true;        
272     }
273     
274     /* If product's owner want to move, he need to use this fuction for setting receiver : must use by sender */  
275     function setMoveProductToWhom(address who_made_this,uint256 product_idx,address moveto) public returns (bool success)
276     {
277         Product_genuine storage mine = MyProducts[who_made_this][product_idx];
278         
279         require(mine.m_who_have==msg.sender);
280         
281         mine.m_send_to_who = moveto;
282 
283         return true;
284     }
285     
286     /* Product's buyer need to use this function for save his genuine */
287     function moveProduct(address who_made_this,address who_have_this,uint256 product_idx) public returns (bool success)
288     {
289         uint256 amount = 1 * 10 ** uint256(decimals);        
290 
291         require(balanceOf[msg.sender]>=amount);   // Need to use one WaraCoin for move product
292         
293         Product_genuine storage mine = MyProducts[who_made_this][product_idx];
294         
295         require(mine.m_who_have==who_have_this);    // if sender have no product, break
296         require(mine.m_send_to_who==msg.sender);    // if receiver is not me, break
297 
298         mine.m_who_have = msg.sender;
299         mine.m_moved_count += 1;
300         
301         balanceOf[msg.sender] -= amount;
302         
303         return true;
304     }
305 
306     /* Check Genuine of owner */
307     function checkProductGenuine(address who_made_this,address who_have_this,uint256 product_idx) public returns (bool success)
308     {
309         Product_genuine storage mine = MyProducts[who_made_this][product_idx];
310         require(mine.m_who_have==who_have_this);    // if checker have no product, break
311         
312         return true;
313     }
314     
315 }