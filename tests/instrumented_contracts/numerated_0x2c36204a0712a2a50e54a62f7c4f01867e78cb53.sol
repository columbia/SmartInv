1 pragma solidity 0.4.25;
2 
3 contract Owned {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9     *  Constructor
10     *
11     *  Sets contract owner to address of constructor caller
12     */
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     /**
23     *  Change Owner
24     *
25     *  Changes ownership of this contract. Only owner can call this method.
26     *
27     * @param newOwner - new owner's address
28     */
29     function changeOwner(address newOwner) onlyOwner public {
30         require(newOwner != address(0));
31         require(newOwner != owner);
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 }
36 
37 contract TokenParameters {
38     uint256 internal initialSupply = 828179381000000000000000000;
39 
40     // Production
41     address internal constant initialTokenOwnerAddress = 0x68433cFb33A7Fdbfa74Ea5ECad0Bc8b1D97d82E9;
42 }
43 
44 contract TANToken is Owned, TokenParameters {
45     /* Public variables of the token */
46     string public standard = 'ERC-20';
47     string public name = 'Taklimakan';
48     string public symbol = 'TAN';
49     uint8 public decimals = 18;
50 
51     /* Arrays of all balances, vesting, approvals, and approval uses */
52     mapping (address => uint256) private _balances;   // Total token balances
53     mapping (address => mapping (address => uint256)) private _allowed;
54 
55     /* This generates a public event on the blockchain that will notify clients */
56     event Transfer(address indexed from, address indexed to, uint256 tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
58     event Destruction(uint256 _amount); // triggered when the total supply is decreased
59     event NewTANToken(address _token);
60 
61     /* Miscellaneous */
62     uint256 public totalSupply = 0;
63     address private _admin;
64 
65     /**
66     *  Constructor
67     *
68     *  Initializes contract with initial supply tokens to the creator of the contract
69     */
70     constructor()
71         public
72     {
73         owner = msg.sender;
74         _admin = msg.sender;
75         mintToken(TokenParameters.initialTokenOwnerAddress, TokenParameters.initialSupply);
76         emit NewTANToken(address(this));
77     }
78 
79     modifier onlyOwnerOrAdmin() {
80         require((msg.sender == owner) || (msg.sender == _admin));
81         _;
82     }
83 
84     /**
85     *  Function to set new admin for automated setting of exchange rate
86     *
87     */
88     function setAdmin(address newAdmin)
89         external
90         onlyOwner
91     {
92         require(newAdmin != address(0));
93         _admin = newAdmin;
94     }
95 
96     /**
97     *  Get token balance of an address
98     *
99     * @param addr - address to query
100     * @return Token balance of address
101     */
102     function balanceOf(address addr)
103         public
104         view
105         returns (uint256)
106     {
107         return _balances[addr];
108     }
109 
110     /**
111     *  Get token amount allocated for a transaction from _owner to _spender addresses
112     *
113     * @param tokenOwner - owner address, i.e. address to transfer from
114     * @param tokenSpender - spender address, i.e. address to transfer to
115     * @return Remaining amount allowed to be transferred
116     */
117     function allowance(address tokenOwner, address tokenSpender)
118         public
119         view
120         returns (uint256)
121     {
122         return _allowed[tokenOwner][tokenSpender];
123     }
124 
125     /**
126     *  Send coins from sender's address to address specified in parameters
127     *
128     * @param to - address to send to
129     * @param value - amount to send in Wei
130     */
131     function transfer(address to, uint256 value)
132         public
133         returns (bool)
134     {
135         require(_balances[msg.sender] >= value, "Insufficient balance for transfer");
136 
137         // Subtract from the sender
138         // _value is never greater than balance of input validation above
139         _balances[msg.sender] -= value;
140 
141         // Overflow is never possible due to input validation above
142         _balances[to] += value;
143 
144         emit Transfer(msg.sender, to, value);
145         return true;
146     }
147 
148     /**
149     *  Create token and credit it to target address
150     *  Created tokens need to vest
151     *
152     */
153     function mintToken(address tokenOwner, uint256 amount)
154         internal
155     {
156         // Mint happens right here: Balance becomes non-zero from zero
157         _balances[tokenOwner] += amount;
158         totalSupply += amount;
159 
160         // Emit Transfer event
161         emit Transfer(address(0), tokenOwner, amount);
162     }
163 
164     /**
165     *  Allow another contract to spend some tokens on your behalf
166     *
167     * @param spender - address to allocate tokens for
168     * @param value - number of tokens to allocate
169     * @return True in case of success, otherwise false
170     */
171     function approve(address spender, uint256 value)
172         public
173         returns (bool)
174     {
175         require(_balances[msg.sender] >= value, "Insufficient balance for approval");
176 
177         _allowed[msg.sender][spender] = value;
178         emit Approval(msg.sender, spender, value);
179         return true;
180     }
181 
182     /**
183     *  A contract attempts to get the coins. Tokens should be previously allocated
184     *
185     * @param to - address to transfer tokens to
186     * @param from - address to transfer tokens from
187     * @param value - number of tokens to transfer
188     * @return True in case of success, otherwise false
189     */
190     function transferFrom(address from, address to, uint256 value)
191         public
192         returns (bool)
193     {
194         // Check allowed
195         require(value <= _allowed[from][msg.sender]);
196         require(_balances[from] >= value);
197 
198         // Subtract from the sender
199         // _value is never greater than balance because of input validation above
200         _balances[from] -= value;
201         // Add the same to the recipient
202         // Overflow is not possible because of input validation above
203         _balances[to] += value;
204 
205         // Deduct allocation
206         // _value is never greater than allowed amount because of input validation above
207         _allowed[from][msg.sender] -= value;
208 
209         emit Transfer(from, to, value);
210         return true;
211     }
212 
213     /**
214     *  Default method
215     *
216     *  This unnamed function is called whenever someone tries to send ether to
217     *  it. Just revert transaction because there is nothing that Token can do
218     *  with incoming ether.
219     *
220     *  Missing payable modifier prevents accidental sending of ether
221     */
222     function() public {
223     }
224 
225     /**
226     *  Destruction (burning) of owner tokens. Only owner of this contract can
227     *  use it to burn their tokens.
228     *
229     *  Total Supply is decreased by the amount of burned tokens
230     *
231     * @param amount - Wei amount of tokens to burn
232     */
233     function destroy(uint256 amount)
234         external
235         onlyOwnerOrAdmin
236     {
237         require(amount <= _balances[msg.sender]);
238 
239         // Destroyed amount is never greater than total supply,
240         // so no underflow possible here
241         totalSupply -= amount;
242         _balances[msg.sender] -= amount;
243         emit Destruction(amount);
244     }
245 
246     /**
247     *  Mass distribution of token
248     *
249     *  Transfers token from admin address to multiple addresses
250     *
251     * @param _recipients - array of recipient addresses
252     * @param _tokenAmounts - array of amounts of tokens to send
253     */
254     function multiTransfer(address[] _recipients, uint[] _tokenAmounts)
255         external
256         onlyOwnerOrAdmin
257     {
258         uint256 totalAmount = 0;
259         uint256 len = _recipients.length;
260         uint256 i;
261 
262         // Calculate total amount
263         for (i=0; i<len; i++)
264         {
265             totalAmount += _tokenAmounts[i];
266         }
267         require(_balances[msg.sender] >= totalAmount);
268         
269         // Decrease sender balance by total amount
270         _balances[msg.sender] -= totalAmount;
271 
272         for (i=0; i<len; i++)
273         {
274             // Increase balance of each recipient
275             _balances[_recipients[i]] += _tokenAmounts[i];
276 
277             // Emit Transfer event
278             emit Transfer(msg.sender, _recipients[i], _tokenAmounts[i]);
279         }
280     }
281 
282 }