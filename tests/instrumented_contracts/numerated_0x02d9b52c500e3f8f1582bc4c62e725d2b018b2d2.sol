1 pragma solidity 0.4.18;
2 
3 
4 contract Owned {
5 
6    /** GitHub Repository https://github.com/VoiceOfCoins/VOCTOP25
7     */
8     
9     address internal _owner;
10     
11     /**
12      * Constrctor function
13      *
14      * Initializes contract with owner
15      */
16     function Owned() public {
17         
18         _owner = msg.sender;
19         
20     }
21     
22     function owner() public view returns (address) {
23         
24         return _owner;
25         
26     }
27     
28     modifier onlyOwner {
29         
30         require(msg.sender == _owner);
31         _;
32         
33     }
34     
35     function transferOwnership(address _newOwner) public onlyOwner {
36         
37         require(_newOwner != address(0));
38         _owner = _newOwner;
39         
40     }
41 }
42 
43 
44 contract VOCTOP25 is Owned {
45     
46     // Internal variables of the token
47     string  internal _name;
48     string  internal _symbol;
49     uint8   internal _decimals;
50     uint256 internal _totalSupply;
51     
52     // This creates an array with all balances
53     mapping (address => uint256)  internal _balanceOf;
54     mapping (address => mapping (address => uint256)) internal _allowance;
55     mapping (address => bool) internal _frozenAccount;
56     
57     // This generates a public event on the blockchain that will notify clients
58     event Transfer(address indexed _from, address indexed _to, uint _value);
59     // This notifies clients about the amount minted
60     event Mint(address indexed _to, uint256 _value);
61     // This notifies clients about the amount burnt
62     event Burn(address indexed _from, uint256 _value);
63     // This notifies clients about approval for other address
64     event Approval(address indexed _owner, address indexed _spender, uint _value);
65     // This notifies clients frozen accounts
66     event AccountFrozen(address indexed _account, bool _value);
67        
68     /**
69      * Constrctor function
70      *
71      * Initializes contract with initial supply tokens to the creator of the contract
72      */
73     function VOCTOP25() public {
74         
75         //Set decimals
76         _decimals = 18;
77         
78         // Update total supply with the decimal amount
79         _totalSupply = 0 * 10 ** uint256(_decimals);
80         
81         // Give the creator all initial tokens
82         _balanceOf[msg.sender] = _totalSupply;
83         
84         // Set the name for display purposes
85         _name = "Voice Of Coins TOP 25 Index Fund";   
86         
87         // Set the symbol for display purposes
88         _symbol = "VOC25";   
89         
90     }
91       
92     /**
93      * Returns token's name
94      *
95      */
96     function name() public view returns (string) {
97         
98         return _name;
99         
100     }
101     
102     /**
103      * Returns token's symbol
104      *
105      */
106     function symbol() public view returns (string) {
107         
108         return _symbol;
109         
110     }
111     
112     /**
113      * Returns token's decimals
114      *
115      */
116     function decimals() public view returns (uint8) {
117         
118         return _decimals;
119         
120     }
121     
122     /**
123      * Returns token's total supply
124      *
125      */
126     function totalSupply() public view returns (uint256) {
127         
128         return _totalSupply;
129         
130     }
131     
132     /**
133      * Returns balance of the give address
134      * @param _tokenHolder Tokens holder address
135      */
136     function balanceOf(address _tokenHolder) public view returns (uint256) {
137         
138         return _balanceOf[_tokenHolder];
139         
140     }
141     
142     /**
143      * Transfer tokens
144      *
145      * Send `_value` tokens to `_to` from your account
146      *
147      * @param _to The address of the recipient
148      * @param _value the amount to send
149      */
150     function transfer(address _to, uint256 _value) public returns (bool success) {
151         
152         //Do actual transfer
153         bool transferResult = _transfer(msg.sender, _to, _value);  
154 
155         return transferResult;
156         
157     }
158     
159     /**
160      * Transfer tokens from other address
161      *
162      * Send `_value` tokens to `_to` in behalf of `_from`
163      *
164      * @param _from The address of the sender
165      * @param _to The address of the recipient
166      * @param _value the amount to send
167      */
168     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
169         
170         // Check allowance if transfer not from own
171         if (msg.sender != _from) {
172             require(_allowance[_from][msg.sender] >= _value);     
173             _allowance[_from][msg.sender] -= _value;
174         }
175         
176         // Do actual transfer
177         bool transferResult = _transfer(_from, _to, _value); 
178 
179         return transferResult;
180     }
181     
182     /**
183      * Set allowance for other address
184      *
185      * Allows `_spender` to spend no more than `_value` tokens in your behalf
186      *  
187      * Beware that changing an allowance with this method brings the risk that someone may use both the old
188      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * @param _spender The address authorized to spend
193      * @param _value the max amount they can spend
194      */
195     function approve(address _spender, uint256 _value) public returns (bool success) {
196         
197         //set value 
198         _allowance[msg.sender][_spender] = _value;
199 
200         //Notify Listeners
201         Approval(msg.sender, _spender, _value);
202 
203         return true;
204         
205     }
206     
207     /**
208      * Returns allowance for the given owner and spender
209      * @param _tokenOwner Tokens owner address
210      * @param _spender Spender address
211      */
212     function allowance(address _tokenOwner, address _spender) public view returns (uint256) {
213         
214         return _allowance[_tokenOwner][_spender];
215         
216     }
217     
218     /**
219    * approve should be called when allowed[_spender] == 0. To increment
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    */
224     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
225       
226         //check overflow
227         require(_allowance[msg.sender][_spender] + _addedValue >= _allowance[msg.sender][_spender]);
228 
229         //upate value
230         _allowance[msg.sender][_spender] += _addedValue;
231 
232         //Notify Listeners
233         Approval(msg.sender, _spender, _allowance[msg.sender][_spender]);
234 
235         return true;
236     }
237 
238     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
239     
240         //check if subtractedValue greater than available, if so set to zero
241         //otherwise decrease by subtractedValue
242         if (_subtractedValue > _allowance[msg.sender][_spender]) {
243 
244             _allowance[msg.sender][_spender] = 0;
245 
246         } else {
247 
248             _allowance[msg.sender][_spender] -= _subtractedValue;
249 
250         }
251 
252         //Notify Listeners
253         Approval(msg.sender, _spender, _allowance[msg.sender][_spender]);
254 
255         return true;
256     }
257     
258     /**
259      * @notice Destroy tokens from owener account, can be run only by owner
260      *
261      * Remove `_value` tokens from the system irreversibly
262      *
263      * @param _value the amount of money to burn
264      */
265     function burn(uint256 _value) public onlyOwner returns (bool success) {
266         
267         //Check if FrozenFunds
268         require(!_frozenAccount[_owner]);
269         
270         // Check if the targeted balance is enough
271         require(_balanceOf[_owner] >= _value);
272         
273         // Subtract from the targeted balance and total supply
274         _balanceOf[_owner] -= _value;
275         _totalSupply -= _value;
276         
277         //Notify Listeners
278         Burn(_owner, _value);
279         
280         return true;
281         
282     }
283     
284     /**
285      * @notice Destroy tokens from other account, can be run only by owner
286      *
287      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
288      *
289      * @param _from the address of the sender
290      * @param _value the amount of money to burn
291      */
292     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
293         
294         // Save frozen state
295         bool bAccountFrozen = frozenAccount(_from);
296         
297         //Unfreeze account if was frozen
298         if (bAccountFrozen) {
299             //Allow transfers
300             freezeAccount(_from, false);
301         }
302         
303         // Transfer to owners account
304         _transfer(_from, _owner, _value);
305         
306         //Freeze again if was frozen before
307         if (bAccountFrozen) {
308             freezeAccount(_from, bAccountFrozen);
309         }
310         
311         // Burn from owners account
312         burn(_value);
313         
314         return true;
315         
316     }
317     
318     /**
319     * @notice Create `mintedAmount` tokens and send it to `owner`, can be run only by owner
320     * @param _mintedAmount the amount of tokens it will receive
321     */
322     function mintToken(uint256 _mintedAmount) public onlyOwner {
323         
324         //Check if FrozenFunds
325         require(!_frozenAccount[_owner]);
326         
327         // Check for overflows
328         require(_balanceOf[_owner] + _mintedAmount >= _balanceOf[_owner]);
329         
330         // Check for overflows
331         require(_totalSupply + _mintedAmount >= _totalSupply);
332         
333         _balanceOf[_owner] += _mintedAmount;
334         _totalSupply += _mintedAmount;
335         
336         // Notify Listeners
337         Mint(_owner, _mintedAmount);
338         // Notify Listeners
339         Transfer(0, _owner, _mintedAmount);
340         
341     }
342     
343     /**
344     * @notice Freeze or unfreeze account, can be run only by owner
345     * @param _target Account
346     * @param _freeze True to freeze, False to unfreeze
347     */
348     function freezeAccount(address _target, bool _freeze) public onlyOwner returns (bool) {
349         
350         //set freeze value 
351         _frozenAccount[_target] = _freeze;
352         
353         
354         //Notify Listeners
355         AccountFrozen(_target, _freeze);
356         
357         return true;
358     }
359     
360     /**
361      * Check if the address is frozen
362      * @param _account Address to be checked
363      */
364     function frozenAccount(address _account) public view returns (bool) {
365         
366         return _frozenAccount[_account];
367         
368     }
369 
370     /**
371      * Internal transfer, only can be called by this contract
372      */
373     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
374         
375         // Prevent transfer to 0x0 address. Use burn() instead
376         require(_to != 0x0);
377         
378         //Check if FrozenFunds
379         require(!_frozenAccount[_from]);
380         require(!_frozenAccount[_to]);
381         
382         // Check if the sender has enough
383         require(_balanceOf[_from] >= _value);
384         
385         // Check for overflows
386         require(_balanceOf[_to] + _value >= _balanceOf[_to]);
387         
388         // Subtract from the sender
389         _balanceOf[_from] -= _value;
390         
391         // Add the same to the recipient
392         _balanceOf[_to] += _value;
393             
394         //Notify Listeners
395         Transfer(_from, _to, _value);    
396 
397         return true;
398         
399     }
400     
401 }