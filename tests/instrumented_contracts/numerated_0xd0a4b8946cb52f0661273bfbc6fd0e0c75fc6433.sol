1 pragma solidity ^0.4.13;
2 
3 contract ItokenRecipient {
4   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
5 }
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Owned {
34     address public owner;
35     address public newOwner;
36 
37     function Owned() {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner {
42         assert(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address _newOwner) public onlyOwner {
47         require(_newOwner != owner);
48         newOwner = _newOwner;
49     }
50 
51     function acceptOwnership() public {
52         require(msg.sender == newOwner);
53         OwnerUpdate(owner, newOwner);
54         owner = newOwner;
55         newOwner = 0x0;
56     }
57 
58     event OwnerUpdate(address _prevOwner, address _newOwner);
59 }
60 
61 contract IERC20Token {
62   function totalSupply() constant returns (uint256 totalSupply);
63   function balanceOf(address _owner) constant returns (uint256 balance) {}
64   function transfer(address _to, uint256 _value) returns (bool success) {}
65   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
66   function approve(address _spender, uint256 _value) returns (bool success) {}
67   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
68 
69   event Transfer(address indexed _from, address indexed _to, uint256 _value);
70   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 }
72 
73 contract Token is IERC20Token, Owned {
74 
75   using SafeMath for uint256;
76 
77   /* Public variables of the token */
78   string public standard;
79   string public name;
80   string public symbol;
81   uint8 public decimals;
82 
83   address public crowdsaleContractAddress;
84 
85   /* Private variables of the token */
86   uint256 supply = 0;
87   mapping (address => uint256) balances;
88   mapping (address => mapping (address => uint256)) allowances;
89 
90   /* Events */
91   event Mint(address indexed _to, uint256 _value);
92 
93   // validates address is the crowdsale owner
94   modifier onlyCrowdsaleOwner() {
95       require(msg.sender == crowdsaleContractAddress);
96       _;
97   }
98 
99   /* Returns total supply of issued tokens */
100   function totalSupply() constant returns (uint256) {
101     return supply;
102   }
103 
104   /* Returns balance of address */
105   function balanceOf(address _owner) constant returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109   /* Transfers tokens from your address to other */
110   function transfer(address _to, uint256 _value) returns (bool success) {
111     require(_to != 0x0 && _to != address(this));
112     balances[msg.sender] = balances[msg.sender].sub(_value); // Deduct senders balance
113     balances[_to] = balances[_to].add(_value);               // Add recivers blaance
114     Transfer(msg.sender, _to, _value);                       // Raise Transfer event
115     return true;
116   }
117 
118   /* Approve other address to spend tokens on your account */
119   function approve(address _spender, uint256 _value) returns (bool success) {
120     allowances[msg.sender][_spender] = _value;        // Set allowance
121     Approval(msg.sender, _spender, _value);           // Raise Approval event
122     return true;
123   }
124 
125   /* Approve and then communicate the approved contract in a single tx */
126   function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
127     ItokenRecipient spender = ItokenRecipient(_spender);            // Cast spender to tokenRecipient contract
128     approve(_spender, _value);                                      // Set approval to contract for _value
129     spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
130     return true;
131   }
132 
133   /* A contract attempts to get the coins */
134   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
135     require(_to != 0x0 && _to != address(this));
136     balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance
137     balances[_to] = balances[_to].add(_value);                                  // Add recipient blaance
138     allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);  // Deduct allowance for this address
139     Transfer(_from, _to, _value);                                               // Raise Transfer event
140     return true;
141   }
142 
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowances[_owner][_spender];
145   }
146 
147   function mintTokens(address _to, uint256 _amount) onlyCrowdsaleOwner {
148     supply = supply.add(_amount);
149     balances[_to] = balances[_to].add(_amount);
150     Mint(_to, _amount);
151     Transfer(msg.sender, _to, _amount);
152   }
153 
154   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner {
155     IERC20Token(_tokenAddress).transfer(_to, _amount);
156   }
157 }
158 
159 contract StormToken is Token {
160 
161 	bool public transfersEnabled = false;    // true if transfer/transferFrom are enabled, false if not
162 
163 	// triggered when the total supply is increased
164 	event Issuance(uint256 _amount);
165 	// triggered when the total supply is decreased
166 	event Destruction(uint256 _amount);
167 
168 
169   /* Initializes contract */
170   function StormToken(address _crowdsaleAddress) public {
171     standard = "Storm Token v1.0";
172     name = "Storm Token";
173     symbol = "STORM"; // token symbol
174     decimals = 18;
175     crowdsaleContractAddress = _crowdsaleAddress;
176   }
177 
178     // validates an address - currently only checks that it isn't null
179     modifier validAddress(address _address) {
180         require(_address != 0x0);
181         _;
182     }
183 
184     // verifies that the address is different than this contract address
185     modifier notThis(address _address) {
186         require(_address != address(this));
187         _;
188     }
189 
190     // allows execution only when transfers aren't disabled
191     modifier transfersAllowed {
192         assert(transfersEnabled);
193         _;
194     }
195 
196    /**
197         @dev disables/enables transfers
198         can only be called by the contract owner
199 
200         @param _disable    true to disable transfers, false to enable them
201     */
202     function disableTransfers(bool _disable) public onlyOwner {
203         transfersEnabled = !_disable;
204     }
205 
206     /**
207         @dev increases the token supply and sends the new tokens to an account
208         can only be called by the contract owner
209 
210         @param _to         account to receive the new amount
211         @param _amount     amount to increase the supply by
212     */
213     function issue(address _to, uint256 _amount)
214         public
215         onlyOwner
216         validAddress(_to)
217         notThis(_to)
218     {
219         supply = supply.add(_amount);
220         balances[_to] = balances[_to].add(_amount);
221 
222         Issuance(_amount);
223         Transfer(this, _to, _amount);
224     }
225 
226     /**
227         @dev removes tokens from an account and decreases the token supply
228         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
229 
230         @param _from       account to remove the amount from
231         @param _amount     amount to decrease the supply by
232     */
233     function destroy(address _from, uint256 _amount) public {
234         require(msg.sender == _from || msg.sender == owner); // validate input
235 
236         balances[_from] = balances[_from].sub(_amount);
237         supply = supply.sub(_amount);
238 
239         Transfer(_from, this, _amount);
240         Destruction(_amount);
241     }
242 
243     // ERC20 standard method overrides with some extra functionality
244 
245     /**
246         @dev send coins
247         throws on any error rather then return a false flag to minimize user errors
248         in addition to the standard checks, the function throws if transfers are disabled
249 
250         @param _to      target address
251         @param _value   transfer amount
252 
253         @return true if the transfer was successful, false if it wasn't
254     */
255     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
256         assert(super.transfer(_to, _value));
257         return true;
258     }
259   
260     function transfers(address[] _recipients, uint256[] _values) public transfersAllowed onlyOwner returns (bool success) {
261         require(_recipients.length == _values.length); // Check if input data is correct
262 
263         for (uint cnt = 0; cnt < _recipients.length; cnt++) {
264             assert(super.transfer(_recipients[cnt], _values[cnt]));
265         }
266         return true;
267     }
268 
269     /**
270         @dev an account/contract attempts to get the coins
271         throws on any error rather then return a false flag to minimize user errors
272         in addition to the standard checks, the function throws if transfers are disabled
273 
274         @param _from    source address
275         @param _to      target address
276         @param _value   transfer amount
277 
278         @return true if the transfer was successful, false if it wasn't
279     */
280     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
281         assert(super.transferFrom(_from, _to, _value));
282         return true;
283     }
284 }