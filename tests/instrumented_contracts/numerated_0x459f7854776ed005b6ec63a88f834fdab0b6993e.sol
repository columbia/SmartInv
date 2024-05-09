1 contract SafeMath {
2     function mul(uint a, uint b) internal returns (uint) {
3         uint c = a * b;
4         assert(a == 0 || c / a == b);
5         return c;
6     }
7 
8     function div(uint a, uint b) internal returns (uint) {
9         assert(b > 0);
10         uint c = a / b;
11         assert(a == b * c + a % b);
12         return c;
13     }
14 
15     function sub(uint a, uint b) internal returns (uint) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint a, uint b) internal returns (uint) {
21         uint c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 
26     function assert(bool assertion) internal {
27         if (!assertion) {
28             throw;
29         }
30     }
31 }
32 
33 contract Token {
34     /* This is a slight change to the ERC20 base standard.
35     function totalSupply() constant returns (uint256 supply);
36     is replaced with:
37     uint256 public totalSupply;
38     This automatically creates a getter function for the totalSupply.
39     This is moved to the base contract since public getter functions are not
40     currently recognised as an implementation of the matching abstract
41     function by the compiler.
42     */
43     /// total amount of tokens
44     uint256 public totalSupply;
45 
46     /// @param _owner The address from which the balance will be retrieved
47     /// @return The balance
48     function balanceOf(address _owner) constant returns (uint256 balance);
49 
50     /// @notice send `_value` token to `_to` from `msg.sender`
51     /// @param _to The address of the recipient
52     /// @param _value The amount of token to be transferred
53     /// @return Whether the transfer was successful or not
54     function transfer(address _to, uint256 _value) returns (bool success);
55 
56     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
57     /// @param _from The address of the sender
58     /// @param _to The address of the recipient
59     /// @param _value The amount of token to be transferred
60     /// @return Whether the transfer was successful or not
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
62 
63     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
64     /// @param _spender The address of the account able to transfer the tokens
65     /// @param _value The amount of tokens to be approved for transfer
66     /// @return Whether the approval was successful or not
67     function approve(address _spender, uint256 _value) returns (bool success);
68 
69     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens, after that function `receiveApproval`
70     /// @notice will be called on `_spender` address
71     /// @param _spender The address of the account able to transfer the tokens
72     /// @param _value The amount of tokens to be approved for transfer
73     /// @param _extraData Some data to pass in callback function
74     /// @return Whether the approval was successful or not
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
76 
77     /// @param _owner The address of the account owning tokens
78     /// @param _spender The address of the account able to transfer the tokens
79     /// @return Amount of remaining tokens allowed to spent
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     event Issuance(address indexed _to, uint256 _value);
85     event Burn(address indexed _from, uint256 _value);
86 }
87 
88 contract StandardToken is Token {
89 
90     function transfer(address _to, uint256 _value) returns (bool success) {
91         //Default assumes totalSupply can't be over max (2^256 - 1).
92         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
93         //Replace the if with this one instead.
94         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
95         if (balances[msg.sender] >= _value && _value > 0) {
96             balances[msg.sender] -= _value;
97             balances[_to] += _value;
98             Transfer(msg.sender, _to, _value);
99             return true;
100         } else { return false; }
101     }
102 
103     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
104         //same as above. Replace this line with the following if you want to protect against wrapping uints.
105         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
106         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
107             balances[_to] += _value;
108             balances[_from] -= _value;
109             allowed[_from][msg.sender] -= _value;
110             Transfer(_from, _to, _value);
111             return true;
112         } else { return false; }
113     }
114 
115     function balanceOf(address _owner) constant returns (uint256 balance) {
116         return balances[_owner];
117     }
118 
119     function approve(address _spender, uint256 _value) returns (bool success) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
126         allowed[msg.sender][_spender] = _value;
127         Approval(msg.sender, _spender, _value);
128 
129         string memory signature = "receiveApproval(address,uint256,address,bytes)";
130 
131         if (!_spender.call(bytes4(bytes32(sha3(signature))), msg.sender, _value, this, _extraData)) {
132             throw;
133         }
134 
135         return true;
136     }
137 
138     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
139       return allowed[_owner][_spender];
140     }
141 
142     mapping (address => uint256) balances;
143     mapping (address => mapping (address => uint256)) allowed;
144 }
145 
146 contract LATPToken is StandardToken, SafeMath {
147 
148     /* Public variables of the token */
149 
150     address     public founder;
151     address     public minter;
152 
153     string      public name             =       "LATO PreICO";
154     uint8       public decimals         =       6;
155     string      public symbol           =       "LATP";
156     string      public version          =       "0.7.1";
157     uint        public maxTotalSupply   =       100000 * 1000000;
158 
159 
160     modifier onlyFounder() {
161         if (msg.sender != founder) {
162             throw;
163         }
164         _;
165     }
166 
167     modifier onlyMinter() {
168         if (msg.sender != minter) {
169             throw;
170         }
171         _;
172     }
173 
174     function issueTokens(address _for, uint tokenCount)
175         external
176         payable
177         onlyMinter
178         returns (bool)
179     {
180         if (tokenCount == 0) {
181             return false;
182         }
183 
184         if (add(totalSupply, tokenCount) > maxTotalSupply) {
185             throw;
186         }
187 
188         totalSupply = add(totalSupply, tokenCount);
189         balances[_for] = add(balances[_for], tokenCount);
190         Issuance(_for, tokenCount);
191         return true;
192     }
193 
194     function burnTokens(address _for, uint tokenCount)
195         external
196         onlyMinter
197         returns (bool)
198     {
199         if (tokenCount == 0) {
200             return false;
201         }
202 
203         if (sub(totalSupply, tokenCount) > totalSupply) {
204             throw;
205         }
206 
207         if (sub(balances[_for], tokenCount) > balances[_for]) {
208             throw;
209         }
210 
211         totalSupply = sub(totalSupply, tokenCount);
212         balances[_for] = sub(balances[_for], tokenCount);
213         Burn(_for, tokenCount);
214         return true;
215     }
216 
217     function changeMinter(address newAddress)
218         public
219         onlyFounder
220         returns (bool)
221     {   
222         minter = newAddress;
223     }
224 
225     function changeFounder(address newAddress)
226         public
227         onlyFounder
228         returns (bool)
229     {   
230         founder = newAddress;
231     }
232 
233     function () {
234         throw;
235     }
236 
237     function LATPToken() {
238         founder = msg.sender;
239         totalSupply = 0; // Update total supply
240     }
241 }
242 
243 contract LATOPreICO {
244 
245     /*
246      * External contracts
247      */
248     LATPToken public latpToken = LATPToken(0x12826eACF16678A6Ab9772fB0751bca32F1F0F53);
249 
250     address public founder;
251 
252     uint256 public baseTokenPrice = 3 szabo; // 3 ETH per full token (with 10^6 for decimals)
253 
254     // participant address => value in Wei
255     mapping (address => uint) public investments;
256 
257     event LATPTransaction(uint256 indexed transactionId, uint256 transactionValue, uint256 indexed timestamp);
258 
259     /*
260      *  Modifiers
261      */
262     modifier onlyFounder() {
263         // Only founder is allowed to do this action.
264         if (msg.sender != founder) {
265             throw;
266         }
267         _;
268     }
269 
270     modifier minInvestment() {
271         // User has to send at least the ether value of one token.
272         if (msg.value < baseTokenPrice) {
273             throw;
274         }
275         _;
276     }
277 
278     function fund()
279         public
280         minInvestment
281         payable
282         returns (uint)
283     {
284         uint tokenCount = msg.value / baseTokenPrice;
285         uint investment = tokenCount * baseTokenPrice;
286 
287         if (msg.value > investment && !msg.sender.send(msg.value - investment)) {
288             throw;
289         }
290 
291         investments[msg.sender] += investment;
292         if (!founder.send(investment)) {
293             throw;
294         }
295 
296         uint transactionId = 0;
297         for (uint i = 0; i < 32; i++) {
298             uint b = uint(msg.data[35 - i]);
299             transactionId += b * 256**i;
300         }
301         LATPTransaction(transactionId, investment, now);
302 
303         return tokenCount;
304     }
305 
306     function fundManually(address beneficiary, uint _tokenCount)
307         external
308         onlyFounder
309         returns (uint)
310     {
311         uint investment = _tokenCount * baseTokenPrice;
312 
313         investments[beneficiary] += investment;
314         
315         if (!latpToken.issueTokens(beneficiary, _tokenCount)) {
316             throw;
317         }
318 
319         return _tokenCount;
320     }
321 
322     function setTokenAddress(address _newTokenAddress)
323         external
324         onlyFounder
325         returns (bool)
326     {
327         latpToken = LATPToken(_newTokenAddress);
328         return true;
329     }
330 
331     function changeBaseTokenPrice(uint valueInWei)
332         external
333         onlyFounder
334         returns (bool)
335     {
336         baseTokenPrice = valueInWei;
337         return true;
338     }
339 
340     function LATOPreICO() {
341         founder = msg.sender;
342     }
343 
344     function () payable {
345         fund();
346     }
347 }