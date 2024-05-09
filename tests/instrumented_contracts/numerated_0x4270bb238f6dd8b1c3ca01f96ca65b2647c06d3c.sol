1 pragma solidity ^0.4.18;
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
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
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
50         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint256 _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != 0x0);
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /**
78      * Transfer tokens
79      *
80      * Send `_value` tokens to `_to` from your account
81      *
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transfer(address _to, uint256 _value) public returns (bool ok){
86         _transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     /**
91      * Transfer tokens from other address
92      *
93      * Send `_value` tokens to `_to` in behalf of `_from`
94      *
95      * @param _from The address of the sender
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         require(_value <= allowance[_from][msg.sender]);     // Check allowance
101         allowance[_from][msg.sender] -= _value;
102         _transfer(_from, _to, _value);
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address
108      *
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      */
114     function approve(address _spender, uint256 _value) 
115         public
116         returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 
140     /**
141      * Destroy tokens
142      *
143      * Remove `_value` tokens from the system irreversibly
144      *
145      * @param _value the amount of money to burn
146      */
147     function burn(uint256 _value) public returns (bool success) {
148         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
149         balanceOf[msg.sender] -= _value;            // Subtract from the sender
150         totalSupply -= _value;                      // Updates totalSupply
151         Burn(msg.sender, _value);
152         return true;
153     }
154 
155     /**
156      * Destroy tokens from other account
157      *
158      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
159      *
160      * @param _from the address of the sender
161      * @param _value the amount of money to burn
162      */
163     function burnFrom(address _from, uint256 _value) public returns (bool success) {
164         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
165         require(_value <= allowance[_from][msg.sender]);    // Check allowance
166         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
167         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
168         totalSupply -= _value;                              // Update totalSupply
169         Burn(_from, _value);
170         return true;
171     }
172 }
173 
174 contract SafeMath {
175     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
176         uint256 c = a * b;
177         assert(a == 0 || c / a == b);
178         return c;
179     }
180 
181     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
182         assert(b > 0);
183         uint256 c = a / b;
184         assert(a == b * c + a % b);
185         return c;
186     }
187 
188     function safeSub(uint256 a, uint256 b) internal  pure returns (uint256) {
189         assert(b <= a);
190         return a - b;
191     }
192 
193     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         assert(c>=a && c>=b);
196         return c;
197     }
198 }
199 
200 contract LockedToken is owned, TokenERC20, SafeMath {
201 
202     struct TokenLocked {
203         uint256 amount;
204         uint256 startDate;
205         uint256 lastDate;  
206         uint256 batches;
207     }
208 
209     mapping (address => TokenLocked) internal lockedTokenOf;
210     mapping (address => bool) internal isLocked;
211 
212     modifier canTransfer(address _sender, uint256 _value) {
213         require(_value <= spendableBalanceOf(_sender));
214         _;
215     }   
216 
217     function LockedToken (
218         uint256 initialSupply,
219         string tokenName,
220         string tokenSymbol
221     )TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
222 
223     function transfer(address _to, uint256 _value)
224             canTransfer(msg.sender, _value)
225             public
226             returns (bool success) {
227         return super.transfer(_to, _value);
228     }
229 
230     function transferFrom(address _from, address _to, uint256 _value)
231             canTransfer(_from, _value)
232             public
233             returns (bool success) {
234         return super.transferFrom(_from, _to, _value);
235     }
236 
237     function transferAndLock(
238             address _to, 
239             uint256 _value,
240             uint256 _startDate,
241             uint256 _lastDate,
242             uint256 _batches) 
243             onlyOwner public {
244         //doLock
245         require(_to != 0x0);
246         require(_startDate < _lastDate);
247         require(_batches > 0);
248         TokenLocked memory tokenLocked = TokenLocked(_value, _startDate, _lastDate, _batches);
249         lockedTokenOf[_to] = tokenLocked;
250         isLocked[_to] = true;
251 
252         //doTransfer
253         super.transfer(_to, _value);
254     }
255 
256     function spendableBalanceOf(address _holder) constant public returns (uint) {
257         return transferableTokens(_holder, uint64(now));
258     }
259 
260     function transferableTokens(address holder, uint256 time) constant public returns (uint256) {
261         
262         TokenLocked storage tokenLocked = lockedTokenOf[holder];
263 
264         if (!isLocked[holder]) return balanceOf[holder];
265 
266         uint256 amount = tokenLocked.amount;
267         uint256 startDate = tokenLocked.startDate;
268         uint256 lastDate = tokenLocked.lastDate;
269         uint256 batches = tokenLocked.batches;
270 
271         if (time < startDate) return 0;
272         if (time >= lastDate) return balanceOf[holder]; 
273 
274         //caculate transferableTokens     
275         uint256 originalTransferableTokens = safeMul(safeDiv(amount, batches), 
276                                         safeDiv(
277                                         safeMul(safeSub(time, startDate), batches),
278                                         safeSub(lastDate, startDate)
279                                         ));
280 
281         uint256 lockedAmount = safeSub(amount, originalTransferableTokens);
282 
283         if (balanceOf[holder] <= lockedAmount) return 0;
284 
285         uint256 actualTransferableTokens = safeSub(balanceOf[holder], lockedAmount);                             
286 
287         return  actualTransferableTokens;
288     }
289 
290     function  lastTokenIsTransferableDate(address holder) constant public returns(uint256 date) {
291         date = uint256(now);
292         if (!isLocked[holder]) return date;
293         
294         TokenLocked storage tokenLocked = lockedTokenOf[holder];       
295         return tokenLocked.lastDate;
296     }
297 
298     function ()  payable public {
299         revert();
300     }
301 }