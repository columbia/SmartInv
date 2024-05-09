1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract owned {
6     address public owner;
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 }
21 
22 contract TokenERC20 is owned {
23 
24     // Public variables of the token
25     string public name;
26     string public symbol;
27     uint8 public decimals = 8;
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 10 ** uint256(decimals);      // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;                        // Give the creator all initial tokens
52         name = tokenName;                                           // Set the name for display purposes
53         symbol = tokenSymbol;                                       // Set the symbol for display purposes
54     }
55 
56     /* Returns total supply of issued tokens */
57     function totalSupply() constant public returns (uint256 supply) {
58         return totalSupply;
59     }
60 
61 
62 
63 
64     /**
65      * Internal transfer, only can be called by this contract
66      */
67     function _transfer(address _from, address _to, uint _value) internal {
68         // Prevent transfer to 0x0 address. Use burn() instead
69         require(_to != 0x0);
70         // Check if the sender has enough
71         require(balanceOf[_from] >= _value);
72         // Check for overflows
73         require(balanceOf[_to] + _value > balanceOf[_to]);
74         // Save this for an assertion in the future
75         uint previousBalances = balanceOf[_from] + balanceOf[_to];
76         // Subtract from the sender
77         balanceOf[_from] -= _value;
78         // Add the same to the recipient
79         balanceOf[_to] += _value;
80         Transfer(_from, _to, _value);
81         // Asserts are used to use static analysis to find bugs in your code. They should never fail
82         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
83     }
84 
85     /**
86      * Transfer tokens
87      *
88      * Send `_value` tokens to `_to` from your account
89      *
90      * @param _to The address of the recipient
91      * @param _value the amount to send
92      */
93     function transfer(address _to, uint256 _value) public {
94         // Master Lock: Allow transfer by other users only after 1511308799
95        if (msg.sender != owner) require(now > 1511308799);   
96        _transfer(msg.sender, _to, _value);
97     }
98 
99     /**
100      * Transfer tokens from other address
101      *
102      * Send `_value` tokens to `_to` in behalf of `_from`
103      *
104      * @param _from The address of the sender
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
109         require(_value <= allowance[_from][msg.sender]);     // Check allowance
110         allowance[_from][msg.sender] -= _value;
111         _transfer(_from, _to, _value);
112         return true;
113     }
114 
115     /**
116      * Set allowance for other address
117      *
118      * Allows `_spender` to spend no more than `_value` tokens in your behalf
119      *
120      * @param _spender The address authorized to spend
121      * @param _value the max amount they can spend
122      */
123     function approve(address _spender, uint256 _value) public
124         returns (bool success) {
125         allowance[msg.sender][_spender] = _value;
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address and notify
131      *
132      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      * @param _extraData some extra information to send to the approved contract
137      */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
139         tokenRecipient spender = tokenRecipient(_spender);
140         if (approve(_spender, _value)) {
141             spender.receiveApproval(msg.sender, _value, this, _extraData);
142             return true;
143         }
144     }
145 
146     /**
147      * Destroy tokens
148      *
149      * Remove `_value` tokens from the system irreversibly
150      *
151      * @param _value the amount of money to burn
152      */
153     function burn(uint256 _value) public returns (bool success) {
154         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
155         balanceOf[msg.sender] -= _value;            // Subtract from the sender
156         totalSupply -= _value;                      // Updates totalSupply
157         Burn(msg.sender, _value);
158         return true;
159     }
160 
161     /**
162      * Destroy tokens from other account
163      *
164      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
165      *
166      * @param _from the address of the sender
167      * @param _value the amount of money to burn
168      */
169     function burnFrom(address _from, uint256 _value) public returns (bool success) {
170         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
171         require(_value <= allowance[_from][msg.sender]);    // Check allowance
172         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
173         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
174         totalSupply -= _value;                              // Update totalSupply
175         Burn(_from, _value);
176         return true;
177     }
178 }
179 
180 contract CDRTToken is TokenERC20 {
181 
182     uint256 public buyBackPrice;
183     // Snapshot of PE balances by Ethereum Address and by year
184     mapping (uint256 => mapping (address => uint256)) public snapShot;
185     // This is time for next Profit Equivalent
186     uint256 public nextPE = 1539205199;
187     // List of Team and Founders account's frozen till 15 November 2018
188     mapping (address => uint256) public frozenAccount;
189 
190     // List of all years when snapshots were made
191     uint[] internal yearsPast = [17];  
192     // Holds current year PE balance
193     uint256 public peBalance;       
194     // Holds full Buy Back balance
195     uint256 public bbBalance;       
196     // Holds unclaimed PE balance from last periods
197     uint256 internal peLastPeriod;       
198     // All ever used in transactions Ethereum Addresses' positions in list
199     mapping (address => uint256) internal ownerPos;              
200     // Total number of Ethereum Addresses used in transactions 
201     uint256 internal pos;                                      
202     // All ever used in transactions Ethereum Addresses list
203     mapping (uint256 => address) internal addressList;   
204     
205     /* Handles incoming payments to contract's address */
206     function() payable public {
207     }
208 
209     /* Initializes contract with initial supply tokens to the creator of the contract */
210     function CDRTToken(
211         uint256 initialSupply,
212         string tokenName,
213         string tokenSymbol
214     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
215 
216     /* Internal insertion in list of all Ethereum Addresses used in transactions, called by contract */
217     function _insert(address _to) internal {
218             if (ownerPos[_to] == 0) {
219                 pos++;
220                 addressList[pos] = _to;
221                 ownerPos[_to] = pos;
222             }
223     }
224 
225     /* Internal transfer, only can be called by this contract */
226     function _transfer(address _from, address _to, uint _value) internal {
227         require (_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
228         require (balanceOf[_from] >= _value);                // Check if the sender has enough
229         require (balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
230         require(frozenAccount[_from] < now);                 // Check if sender is frozen
231          _insert(_to);
232         balanceOf[_from] -= _value;                          // Subtract from the sender
233         balanceOf[_to] += _value;                            // Add the same to the recipient
234         Transfer(_from, _to, _value);
235     }
236 
237     /**
238       * @notice Freezes from sending & receiving tokens. For users protection can't be used after 1542326399
239       * and will not allow corrections.
240       *     
241       * Will set freeze to 1542326399
242       *
243       * @param _from  Founders and Team account we are freezing from sending
244       *
245       */
246    function freezeAccount(address _from) onlyOwner public {
247         require(now < 1542326400);
248         require(frozenAccount[_from] == 0);
249         frozenAccount[_from] = 1542326399;                  
250     }
251 
252     /**
253       * @notice Allow owner to set tokens price for Buy-Back Campaign. Can not be executed until 1539561600
254       *
255       * @param _newPrice market value of 1 CDRT Token
256       *
257       */
258     function setPrice(uint256 _newPrice) onlyOwner public {
259         require(now > 1539561600);                          
260         buyBackPrice = _newPrice;
261     }
262 
263     /**
264       * @notice Contract owner can take snapshot of current balances and issue PE to each balance
265       *
266       * @param _year year of the snapshot to take, must be greater than existing value
267       *
268       * @param _nextPE set new Profit Equivalent date
269       *
270       */
271    function takeSnapshot(uint256 _year, uint256 _nextPE) onlyOwner public {
272         require(_year > yearsPast[yearsPast.length-1]);                             
273         uint256 reward = peBalance / totalSupply;
274         for (uint256 k=1; k <= pos; k++){
275             snapShot[_year][addressList[k]] = balanceOf[addressList[k]] * reward;
276         }
277         yearsPast.push(_year);
278         peLastPeriod += peBalance;     // Transfer new balance to unclaimed
279         peBalance = 0;                 // Zero current balance;
280         nextPE = _nextPE;
281     }
282 
283     /**
284       *  @notice Allow user to claim his PE on his Ethereum Address. Should be called manualy by user
285       *
286       */
287     function claimProfitEquivalent() public{
288         uint256 toPay;
289         for (uint k=0; k <= yearsPast.length-1; k++){
290             toPay += snapShot[yearsPast[k]][msg.sender];
291             snapShot[yearsPast[k]][msg.sender] = 0;
292         }
293         msg.sender.transfer(toPay);
294         peLastPeriod -= toPay;
295    }
296     /**
297       * @notice Allow user to sell CDRT tokens and destroy them. Can not be executed until 1539561600
298       *
299       * @param _qty amount to sell and destroy
300       */
301     function execBuyBack(uint256 _qty) public{
302         require(now > 1539561600);                          
303         uint256 toPay = _qty*buyBackPrice;                                        
304         require(balanceOf[msg.sender] >= _qty);                     // check if user has enough CDRT Tokens 
305         require(buyBackPrice > 0);                                  // check if sale price set
306         require(bbBalance >= toPay);                        
307         require(frozenAccount[msg.sender] < now);                   // Check if sender is frozen
308         msg.sender.transfer(toPay);
309         bbBalance -= toPay;
310         burn(_qty);
311     }   
312    /**
313       * @notice Allow owner to set balances
314       *
315       *
316       */
317     function setBalances(uint256 _peBalance, uint256 _bbBalance) public{
318       peBalance = _peBalance;
319       bbBalance = _bbBalance;
320     }
321 }