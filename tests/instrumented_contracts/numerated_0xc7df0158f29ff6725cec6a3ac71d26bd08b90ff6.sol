1 pragma solidity ^0.4.18;
2 contract owned {
3     
4     address _owner;
5     
6     function owner() public  constant returns (address) {
7         return _owner;
8     }
9     
10     function owned() public {
11         _owner = msg.sender;
12     }
13     
14     modifier onlyOwner {
15         require(msg.sender == _owner);
16         _;
17     }
18     
19     function transferOwnership(address _newOwner) onlyOwner public {
20         require(_newOwner != address(0));
21         _owner = _newOwner;
22     }
23 }
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 contract MyTokenEVC is owned {
26     
27     // Internal variables of the token
28     string  _name;
29     string _symbol;
30     uint8  _decimals = 18;
31     uint256 _totalSupply;
32     
33     // This creates an array with all balances
34     mapping (address => uint256)  _balanceOf;
35     mapping (address => mapping (address => uint256)) _allowance;
36     mapping (address => bool) _frozenAccount;
37     
38     // This generates a public event on the blockchain that will notify clients
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42     // This notifies clients frozen accounts
43     event FrozenFunds(address target, bool frozen);
44        
45     /**
46      * Constrctor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     function MyTokenEVC() public {
51         
52         // Update total supply with the decimal amount
53         _totalSupply = 0 * 10 ** uint256(_decimals);
54         
55         // Give the creator all initial tokens
56         _balanceOf[msg.sender] = _totalSupply;
57         
58         // Set the name for display purposes
59         _name = "MyTokenEVC 4";   
60         
61         // Set the symbol for display purposes
62         _symbol = "MEVC4";                    
63         
64     }
65     
66     /**
67      * Returns token's name
68      *
69      */
70     
71     function name() public  constant returns (string) {
72         return _name;
73     }
74     
75     /**
76      * Returns token's symbol
77      *
78      */
79     function symbol() public constant returns (string) {
80         return _symbol;
81     }
82     
83     /**
84      * Returns token's total supply
85      *
86      */
87     function decimals() public constant returns (uint8) {
88         return _decimals;
89     }
90     
91     function totalSupply() public constant returns (uint256) {
92         return _totalSupply;
93     }
94     
95     /**
96      * Returns balance of the give address
97      * @param _tokenHolder Tokens holder address
98      */
99     function balanceOf(address _tokenHolder) public constant returns (uint256) {
100         return _balanceOf[_tokenHolder];
101     }
102     
103     /**
104      * Returns allowance for the given owner and spender
105      * @param _tokenOwner Tokens owner address
106      * @param _spender Spender address
107      */
108     function allowance(address _tokenOwner, address _spender) public constant returns (uint256) {
109         return _allowance[_tokenOwner][_spender];
110     }
111     
112     /**
113      * Check if the address is frozen
114      * @param _account Address to be checked
115      */
116     function frozenAccount(address _account) public constant returns (bool) {
117         return _frozenAccount[_account];
118     }
119     
120     /**
121      * Internal transfer, only can be called by this contract
122      */
123     function _transfer(address _from, address _to, uint256 _value) internal {
124         
125         // Prevent transfer to 0x0 address. Use burn() instead
126         require(_to != 0x0);
127         
128         //Check if FrozenFunds
129         require(!_frozenAccount[msg.sender]);
130         
131         // Check if the sender has enough
132         require(_balanceOf[_from] >= _value);
133         
134         // Check for overflows
135         require(_balanceOf[_to] + _value > _balanceOf[_to]);
136         
137         // Save this for an assertion in the future
138         uint256 previousBalances = _balanceOf[_from] + _balanceOf[_to];
139         
140         // Subtract from the sender
141         _balanceOf[_from] -= _value;
142         
143         // Add the same to the recipient
144         _balanceOf[_to] += _value;
145         
146         Transfer(_from, _to, _value);
147         
148         // Asserts are used to use static analysis to find bugs in your code. They should never fail
149         assert(_balanceOf[_from] + _balanceOf[_to] == previousBalances);
150         
151     }
152     
153     /**
154      * Transfer tokens
155      *
156      * Send `_value` tokens to `_to` from your account
157      *
158      * @param _to The address of the recipient
159      * @param _value the amount to send
160      */
161     function transfer(address _to, uint256 _value) public {
162         
163         _transfer(msg.sender, _to, _value);
164         
165     }
166     
167     /**
168      * Transfer tokens from other address
169      *
170      * Send `_value` tokens to `_to` in behalf of `_from`
171      *
172      * @param _from The address of the sender
173      * @param _to The address of the recipient
174      * @param _value the amount to send
175      */
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
177         
178         // Check allowance if transfer not from own
179         if (msg.sender != _from) {
180             require(_allowance[_from][msg.sender] >= _value);     
181             _allowance[_from][msg.sender] -= _value;
182         }
183         
184         _transfer(_from, _to, _value);
185         return true;
186     }
187     
188     /**
189      * Set allowance for other address
190      *
191      * Allows `_spender` to spend no more than `_value` tokens in your behalf
192      *
193      * @param _spender The address authorized to spend
194      * @param _value the max amount they can spend
195      */
196     function approve(address _spender, uint256 _value) public returns (bool success) {
197         
198         //Check the balance
199         require(_balanceOf[msg.sender] >= _value);
200         
201         _allowance[msg.sender][_spender] = _value;
202         return true;
203         
204     }
205     
206     /**
207      * Set allowance for other address and notify
208      *
209      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
210      *
211      * @param _spender The address authorized to spend
212      * @param _value the max amount they can spend
213      * @param _extraData some extra information to send to the approved contract
214      */
215     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
216         tokenRecipient spender = tokenRecipient(_spender);
217         if (approve(_spender, _value)) {
218             spender.receiveApproval(msg.sender, _value, this, _extraData);
219             return true;
220         }
221     }
222     
223     
224     
225     /**
226      * @notice Destroy tokens from owener account, can be run only by owner
227      *
228      * Remove `_value` tokens from the system irreversibly
229      *
230      * @param _value the amount of money to burn
231      */
232     function burn(uint256 _value) onlyOwner public returns (bool success) {
233         
234         // Check if the targeted balance is enough
235         require(_balanceOf[_owner] >= _value);
236         
237         // Check total Supply
238         require(_totalSupply >= _value);
239         // Subtract from the targeted balance and total supply
240         _balanceOf[_owner] -= _value;
241         _totalSupply -= _value;
242         
243         Burn(_owner, _value);
244         return true;
245         
246     }
247     
248     /**
249      * @notice Destroy tokens from other account, can be run only by owner
250      *
251      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
252      *
253      * @param _from the address of the sender
254      * @param _value the amount of money to burn
255      */
256     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
257         
258         // Save frozen state
259         bool bAccountFrozen = frozenAccount(_from);
260         
261         //Unfreeze account if was frozen
262         if (bAccountFrozen) {
263             //Allow transfers
264             freezeAccount(_from,false);
265         }
266         
267         // Transfer to owners account
268         _transfer(_from, _owner, _value);
269         
270         //Freeze again if was frozen before
271         if (bAccountFrozen) {
272             freezeAccount(_from,bAccountFrozen);
273         }
274         
275         // Burn from owners account
276         burn(_value);
277         
278         return true;
279     }
280     
281     /**
282     * @notice Create `mintedAmount` tokens and send it to `owner`, can be run only by owner
283     * @param mintedAmount the amount of tokens it will receive
284     */
285     function mintToken(uint256 mintedAmount) onlyOwner public {
286         
287         // Check for overflows
288         require(_balanceOf[_owner] + mintedAmount >= _balanceOf[_owner]);
289         
290         // Check for overflows
291         require(_totalSupply + mintedAmount >= _totalSupply);
292         
293         _balanceOf[_owner] += mintedAmount;
294         _totalSupply += mintedAmount;
295         
296         Transfer(0, _owner, mintedAmount);
297         
298     }
299     
300     /**
301     * @notice Freeze or unfreeze account, can be run only by owner
302     * @param target Account
303     * @param freeze True to freeze, False to unfreeze
304     */
305     function freezeAccount (address target, bool freeze) onlyOwner public {
306         
307         _frozenAccount[target] = freeze;
308         FrozenFunds(target, freeze);
309         
310     }
311     
312 }