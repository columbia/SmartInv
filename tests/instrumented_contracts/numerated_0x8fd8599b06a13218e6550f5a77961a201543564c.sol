1 pragma solidity ^0.4.25;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
38     constructor() public {
39         totalSupply = 12000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
40         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
41         name = "DCETHER";                                   // Set the name for display purposes
42         symbol = "DCETH";                               // Set the symbol for display purposes
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
128 contract  DCETHER is owned, TokenERC20 {
129     
130     uint public sale_step;
131     
132     address dcether_corp;
133     address public Coin_manager;
134 
135     mapping (address => address) public followup;
136 
137     /* Initializes contract with initial supply tokens to the creator of the contract */
138     constructor() TokenERC20()  public 
139     {
140         sale_step = 0;  // 0 : No sale, 1 : Presale, 2 : Crowdsale, 3 : Normalsale 
141         dcether_corp = msg.sender;
142         Coin_manager = 0x0;
143     }
144     
145     function SetCoinManager(address manager) onlyOwner public
146     {
147         require(manager != 0x0);
148         
149         uint amount = balanceOf[dcether_corp];
150         
151         Coin_manager = manager;
152         balanceOf[Coin_manager] += amount;
153         balanceOf[dcether_corp] = 0;
154         Transfer(dcether_corp, Coin_manager, amount);               // execute an event reflecting the change
155     }
156     
157     function SetSaleStep(uint256 step) onlyOwner public
158     {
159         sale_step = step;
160     }
161 
162     function () payable public
163     {
164         require(sale_step!=0);
165 
166         uint nowprice = 10000;   // Token Price per ETher
167         address follower_1st = 0x0; // 1st follower
168         address follower_2nd = 0x0; // 2nd follower
169         
170         uint amount = 0;    // Total token buyed
171         uint amount_1st = 0;    // Bonus token for 1st follower
172         uint amount_2nd = 0;    // Bonus token for 2nd follower
173         uint all_amount = 0;
174 
175         amount = msg.value * nowprice;  
176         
177         follower_1st = followup[msg.sender];
178         
179         if ( follower_1st != 0x0 )
180         {
181             amount_1st = amount;    // 100% bonus give to 1st follower
182             if ( balanceOf[follower_1st] < amount_1st ) // if he has smaller than bonus
183                 amount_1st = balanceOf[follower_1st];   // cannot get bonus all
184                 
185             follower_2nd = followup[follower_1st];
186             
187             if ( follower_2nd != 0x0 )
188             {
189                 amount_2nd = amount / 2;    // 50% bonus give to 2nd follower
190                 
191                 if ( balanceOf[follower_2nd] < amount_2nd ) // if he has smaller than bonus
192                 amount_2nd = balanceOf[follower_2nd];   // cannot get bonus all
193             }
194         }
195         
196         all_amount = amount + amount_1st + amount_2nd;
197             
198         address manager = Coin_manager;
199         
200         if ( manager == 0x0 )
201             manager = dcether_corp;
202         
203         require(balanceOf[manager]>=all_amount);
204         
205         require(balanceOf[msg.sender] + amount > balanceOf[msg.sender]);
206         balanceOf[manager] -= amount;
207         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
208         require(manager.send(msg.value));
209         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
210 
211         if ( amount_1st > 0 )   // first follower give bonus
212         {
213             require(balanceOf[follower_1st] + amount_1st > balanceOf[follower_1st]);
214             
215             balanceOf[manager] -= amount_1st;
216             balanceOf[follower_1st] += amount_1st;                  // adds the amount to buyer's balance
217             
218             Transfer(this, follower_1st, amount_1st);               // execute an event reflecting the change
219         }
220 
221         if ( amount_2nd > 0 )   // second follower give bonus
222         {
223             require(balanceOf[follower_2nd] + amount_2nd > balanceOf[follower_2nd]);
224             
225             balanceOf[manager] -= amount_2nd;
226             balanceOf[follower_2nd] += amount_2nd;                  // adds the amount to buyer's balance
227             
228             Transfer(this, follower_2nd, amount_2nd);               // execute an event reflecting the change
229         }
230     }
231 
232     function BuyFromFollower(address follow_who) payable public
233     {
234         require(sale_step!=0);
235 
236         uint nowprice = 10000;   // Token Price per ETher
237         address follower_1st = 0x0; // 1st follower
238         address follower_2nd = 0x0; // 2nd follower
239         
240         uint amount = 0;    // Total token buyed
241         uint amount_1st = 0;    // Bonus token for 1st follower
242         uint amount_2nd = 0;    // Bonus token for 2nd follower
243         uint all_amount = 0;
244 
245         amount = msg.value * nowprice;  
246         
247         follower_1st = follow_who;
248         followup[msg.sender] = follower_1st;
249         
250         if ( follower_1st != 0x0 )
251         {
252             amount_1st = amount;    // 100% bonus give to 1st follower
253             if ( balanceOf[follower_1st] < amount_1st ) // if he has smaller than bonus
254                 amount_1st = balanceOf[follower_1st];   // cannot get bonus all
255                 
256             follower_2nd = followup[follower_1st];
257             
258             if ( follower_2nd != 0x0 )
259             {
260                 amount_2nd = amount / 2;    // 50% bonus give to 2nd follower
261                 
262                 if ( balanceOf[follower_2nd] < amount_2nd ) // if he has smaller than bonus
263                 amount_2nd = balanceOf[follower_2nd];   // cannot get bonus all
264             }
265         }
266         
267         all_amount = amount + amount_1st + amount_2nd;
268             
269         address manager = Coin_manager;
270         
271         if ( manager == 0x0 )
272             manager = dcether_corp;
273         
274         require(balanceOf[manager]>=all_amount);
275         
276         require(balanceOf[msg.sender] + amount > balanceOf[msg.sender]);
277         balanceOf[manager] -= amount;
278         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
279         require(manager.send(msg.value));
280         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
281 
282         if ( amount_1st > 0 )   // first follower give bonus
283         {
284             require(balanceOf[follower_1st] + amount_1st > balanceOf[follower_1st]);
285             
286             balanceOf[manager] -= amount_1st;
287             balanceOf[follower_1st] += amount_1st;                  // adds the amount to buyer's balance
288             
289             Transfer(this, follower_1st, amount_1st);               // execute an event reflecting the change
290         }
291 
292         if ( amount_2nd > 0 )   // second follower give bonus
293         {
294             require(balanceOf[follower_2nd] + amount_2nd > balanceOf[follower_2nd]);
295             
296             balanceOf[manager] -= amount_2nd;
297             balanceOf[follower_2nd] += amount_2nd;                  // adds the amount to buyer's balance
298             
299             Transfer(this, follower_2nd, amount_2nd);               // execute an event reflecting the change
300         }
301     }
302 
303 
304     /**
305      * Owner can move ChalletValue from backers to another forcely
306      *
307      * @param _from The address of backers who send ChalletValue
308      * @param _to The address of backers who receive ChalletValue
309      * @param amount How many ChalletValue will buy back from him
310      */
311     function ForceCoinTransfer(address _from, address _to, uint amount) onlyOwner public
312     {
313         uint coin_amount = amount * 10 ** uint256(decimals);
314 
315         require(_from != 0x0);
316         require(_to != 0x0);
317         require(balanceOf[_from] >= coin_amount);         // checks if the sender has enough to sell
318 
319         balanceOf[_from] -= coin_amount;                  // subtracts the amount from seller's balance
320         balanceOf[_to] += coin_amount;                  // subtracts the amount from seller's balance
321         Transfer(_from, _to, coin_amount);               // executes an event reflecting on the change
322     }
323 
324     /**
325      * Owner will buy back ChalletValue from backers
326      *
327      * @param _from The address of backers who have ChalletValue
328      * @param coin_amount How many ChalletValue will buy back from him
329      */
330     function DestroyCoin(address _from, uint256 coin_amount) onlyOwner public 
331     {
332         uint256 amount = coin_amount * 10 ** uint256(decimals);
333 
334         require(balanceOf[_from] >= amount);         // checks if the sender has enough to sell
335         balanceOf[_from] -= amount;                  // subtracts the amount from seller's balance
336         Transfer(_from, this, amount);               // executes an event reflecting on the change
337     }    
338     
339 
340 }