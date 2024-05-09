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
59         _name = "MyTokenEVC 3";   
60         
61         // Set the symbol for display purposes
62         _symbol = "MEVC3";                    
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
124         // Prevent transfer to 0x0 address. Use burn() instead
125         require(_to != 0x0);
126         //Check for negative amount
127         require(_value >= 0);
128         // Check if the sender has enough
129         require(_balanceOf[_from] >= _value);
130         // Check for overflows
131         require(_balanceOf[_to] + _value > _balanceOf[_to]);
132         //Check if FrozenFunds
133         require(!_frozenAccount[msg.sender]);
134         // Save this for an assertion in the future
135         uint previousBalances = _balanceOf[_from] + _balanceOf[_to];
136         // Subtract from the sender
137         _balanceOf[_from] -= _value;
138         // Add the same to the recipient
139         _balanceOf[_to] += _value;
140         Transfer(_from, _to, _value);
141         // Asserts are used to use static analysis to find bugs in your code. They should never fail
142         assert(_balanceOf[_from] + _balanceOf[_to] == previousBalances);
143     }
144     
145     /**
146      * Transfer tokens
147      *
148      * Send `_value` tokens to `_to` from your account
149      *
150      * @param _to The address of the recipient
151      * @param _value the amount to send
152      */
153     function transfer(address _to, uint256 _value) public {
154         _transfer(msg.sender, _to, _value);
155     }
156     
157     /**
158      * Transfer tokens from other address
159      *
160      * Send `_value` tokens to `_to` in behalf of `_from`
161      *
162      * @param _from The address of the sender
163      * @param _to The address of the recipient
164      * @param _value the amount to send
165      */
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
167         
168         // Check allowance if transfer not from own
169         if (msg.sender != _from) {
170             require(_allowance[_from][msg.sender] >= _value);     
171             _allowance[_from][msg.sender] -= _value;
172         }
173         
174         _transfer(_from, _to, _value);
175         return true;
176     }
177     
178     /**
179      * Set allowance for other address
180      *
181      * Allows `_spender` to spend no more than `_value` tokens in your behalf
182      *
183      * @param _spender The address authorized to spend
184      * @param _value the max amount they can spend
185      */
186     function approve(address _spender, uint256 _value) public returns (bool success) {
187         
188         //Check for negative amount
189         require(_value >= 0);  
190         //Check the balance
191         require(_balanceOf[msg.sender] >= _value);
192         
193         _allowance[msg.sender][_spender] = _value;
194         return true;
195         
196     }
197     
198     /**
199      * Set allowance for other address and notify
200      *
201      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
202      *
203      * @param _spender The address authorized to spend
204      * @param _value the max amount they can spend
205      * @param _extraData some extra information to send to the approved contract
206      */
207     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
208         tokenRecipient spender = tokenRecipient(_spender);
209         if (approve(_spender, _value)) {
210             spender.receiveApproval(msg.sender, _value, this, _extraData);
211             return true;
212         }
213     }
214     
215     
216     
217     /**
218      * @notice Destroy tokens from owener account, can be run only by owner
219      *
220      * Remove `_value` tokens from the system irreversibly
221      *
222      * @param _value the amount of money to burn
223      */
224     function burn(uint256 _value) onlyOwner public returns (bool success) {
225         
226         burnFrom(_owner, _value);
227         return true;
228         
229     }
230     
231     /**
232      * @notice Destroy tokens from other account, can be run only by owner
233      *
234      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
235      *
236      * @param _from the address of the sender
237      * @param _value the amount of money to burn
238      */
239     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
240         
241         //Check for negative amount
242         require(_value >= 0);
243         // Check if the targeted balance is enough
244         require(_balanceOf[_from] >= _value);
245         // Check total Supply
246         require(_totalSupply >= _value);
247         
248         // Subtract from the targeted balance
249         _balanceOf[_from] -= _value;
250           
251         // Update totalSupply
252         _totalSupply -= _value;  
253         
254         Burn(_from, _value);
255         
256         return true;
257     }
258     
259     /**
260     * @notice Create `mintedAmount` tokens and send it to `owner`, can be run only by owner
261     * @param mintedAmount the amount of tokens it will receive
262     */
263     function mintToken(uint256 mintedAmount) onlyOwner public {
264         
265         //Check for positive amount
266         require(mintedAmount >= 0);
267         
268         _balanceOf[_owner] += mintedAmount;
269         _totalSupply += mintedAmount;
270         Transfer(0, _owner, mintedAmount);
271         
272     }
273     
274     /**
275     * @notice Freeze or unfreeze account, can be run only by owner
276     * @param target Account
277     * @param freeze True to freeze, False to unfreeze
278     */
279     function freezeAccount (address target, bool freeze) onlyOwner public {
280         
281         _frozenAccount[target] = freeze;
282         FrozenFunds(target, freeze);
283         
284     }
285     
286 }