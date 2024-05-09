1 pragma solidity ^0.4.18;
2 
3 /* taking ideas from Zeppelin solidity module */
4 contract SafeMath {
5 
6     // it is recommended to define functions which can neither read the state of blockchain nor write in it as pure instead of constant
7 
8     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
9         uint256 z = x + y;
10         assert((z >= x));
11         return z;
12     }
13 
14     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
15         assert(x >= y);
16         return x - y;
17     }
18 
19     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
20         uint256 z = x * y;
21         assert((x == 0)||(z/x == y));
22         return z;
23     }
24 
25     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
26         uint256 z = x / y;
27         return z;
28     }
29 
30     // mitigate short address attack
31     // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
32     // TODO: doublecheck implication of >= compared to ==
33     modifier onlyPayloadSize(uint numWords) {
34         assert(msg.data.length >= numWords * 32 + 4);
35         _;
36     }
37 
38 }
39 
40 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 contract ERC20 {
42     uint256 public totalSupply;
43 
44     /*
45      *  Public functions
46      */
47     function balanceOf(address _owner) constant public returns (uint256 balance);
48     function transfer(address _to, uint256 _value) public returns (bool success);
49     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
50     function approve(address _spender, uint256 _value) public returns (bool success);
51     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
52 
53     /*
54      *  Events
55      */
56     // this generates a public event on blockchain that will notify clients
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59     // This notifies clients about the amount burnt
60     event Burn(address indexed from, uint256 value);
61 
62 
63 }
64 
65 
66 /*  ERC 20 token */
67 contract StandardToken is ERC20,SafeMath {
68 
69     /*
70      *  Storage
71     */
72 
73     mapping (address => uint256) balances;
74     mapping (address => mapping (address => uint256)) allowed;
75 
76 
77     /*
78      *  Public functions
79      */
80     /// @dev Transfers sender's tokens to a given address. Returns success
81     /// @param _to Address of token receiver
82     /// @param _value Number of tokens to transfer
83     /// @return Was transfer successful?
84 
85     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool success) {
86       if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
87         balances[msg.sender] -= _value;
88         balances[_to] += _value;
89         Transfer(msg.sender, _to, _value);
90         return true;
91       } else {
92         return false;
93       }
94     }
95 
96 
97     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
98     /// @param _from Address from where tokens are withdrawn
99     /// @param _to Address to where tokens are sent
100     /// @param _value Number of tokens to transfer
101     /// @return Was transfer successful?
102 
103     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool success) {
104       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
105         balances[_to] += _value;
106         balances[_from] -= _value;
107         allowed[_from][msg.sender] -= _value;
108         Transfer(_from, _to, _value);
109         return true;
110       } else {
111         return false;
112       }
113     }
114 
115 
116     /// @dev Returns number of tokens owned by given address
117     /// @param _owner Address of token owner
118     /// @return Balance of owner
119 
120     // it is recommended to define functions which can read the state of blockchain but cannot write in it as view instead of constant
121 
122     function balanceOf(address _owner) view public returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126     /// @dev Sets approved amount of tokens for spender. Returns success
127     /// @param _spender Address of allowed account
128     /// @param _value Number of approved tokens
129     /// @return Was approval successful?
130 
131     function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool success) {
132         // To change the approve amount you first have to reduce the addresses`
133         //  allowance to zero by calling `approve(_spender, 0)` if it is not
134         //  already 0 to mitigate the race condition described here:
135         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136 
137         require(_value == 0 && (allowed[msg.sender][_spender] == 0));
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143 
144     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) public returns (bool success) {
145         require(allowed[msg.sender][_spender] == _oldValue);
146         allowed[msg.sender][_spender] = _newValue;
147         Approval(msg.sender, _spender, _newValue);
148 
149         return true;
150     }
151 
152 
153     /// @dev Returns number of allowed tokens for given address
154     /// @param _owner Address of token owner
155     /// @param _spender Address of token spender
156     /// @return Remaining allowance for spender
157     function allowance(address _owner, address _spender) public  view returns (uint256 remaining) {
158       return allowed[_owner][_spender];
159     }
160 
161     /**
162     * @dev Burns a specific amount of tokens.
163     * @param _value The amount of token to be burned.
164     */
165 
166     function burn(uint256 _value) public returns (bool burnSuccess) {
167         require(_value > 0);
168         require(_value <= balances[msg.sender]);
169         // no need to require value <= totalSupply, since that would imply the
170         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
171 
172         address burner = msg.sender;
173         balances[burner] =  safeSubtract(balances[burner],_value);
174         totalSupply = safeSubtract(totalSupply,_value);
175         Burn(burner, _value);
176         return true;
177     }
178 
179 
180 }
181 
182 
183 contract TrakToken is StandardToken {
184     // FIELDS
185     string constant public  name = "TrakInvest Token" ;
186     string constant public  symbol = "TRAK";
187     uint256 constant public  decimals = 18;
188 
189     // The flag indicates if the crowdsale contract is in Funding state.
190     bool public fundraising = true;
191 
192     // who created smart contract
193     address public creator;
194     // owns the total supply of tokens - it would be DAO
195     address public tokensOwner;
196     mapping (address => bool) public frozenAccounts;
197 
198   /// events
199     event FrozenFund(address target ,bool frozen);
200 
201   /// modifiers
202 
203     modifier isCreator() { 
204       require(msg.sender == creator);  
205       _; 
206     }
207 
208     modifier onlyPayloadSize(uint size) {
209         assert(msg.data.length >= size + 4);
210         _;
211     }
212 
213 
214     modifier onlyOwner() {
215         require(msg.sender == tokensOwner);
216         _;
217     }
218 
219     modifier manageTransfer() {
220         if (msg.sender == tokensOwner) {
221             _;
222         }
223         else {
224             require(fundraising == false);
225             _;
226         }
227     }
228 
229   /// constructor
230     function TrakToken(
231       address _fundsWallet,
232       uint256 initialSupply
233       ) public {
234       creator = msg.sender;
235 
236       if (_fundsWallet !=0) {
237         tokensOwner = _fundsWallet;
238       }
239       else {
240         tokensOwner = msg.sender;
241       }
242 
243       totalSupply = initialSupply * (uint256(10) ** decimals);
244       balances[tokensOwner] = totalSupply;
245       Transfer(0x0, tokensOwner, totalSupply);
246     }
247 
248 
249   /// overriden methods
250 
251     function transfer(address _to, uint256 _value)  public manageTransfer onlyPayloadSize(2 * 32) returns (bool success) {
252       require(!frozenAccounts[msg.sender]);
253       require(_to != address(0));
254       return super.transfer(_to, _value);
255     }
256 
257     function transferFrom(address _from, address _to, uint256 _value)  public manageTransfer onlyPayloadSize(3 * 32) returns (bool success) {
258       require(!frozenAccounts[msg.sender]);
259       require(_to != address(0));
260       require(_from != address(0));
261       return super.transferFrom(_from, _to, _value);
262     }
263 
264 
265     function freezeAccount (address target ,bool freeze) public onlyOwner {
266       frozenAccounts[target] = freeze;
267       FrozenFund(target,freeze);  
268     }
269 
270     function burn(uint256 _value) public onlyOwner returns (bool burnSuccess) {
271         require(fundraising == false);
272         return super.burn(_value);
273     }
274 
275     /// @param newAddress Address of new owner.
276     function changeTokensWallet(address newAddress) public onlyOwner returns (bool)
277     {
278         require(newAddress != address(0));
279         tokensOwner = newAddress;
280     }
281 
282     function finalize() public  onlyOwner {
283         require(fundraising != false);
284         // Switch to Operational state. This is the only place this can happen.
285         fundraising = false;
286     }
287 
288 
289     function() public {
290         revert();
291     }
292 
293 }