1 pragma solidity ^0.4.21;
2 
3 contract controlled{
4   address public owner;
5   uint256 public tokenFrozenUntilBlock;
6   uint256 public tokenFrozenSinceBlock;
7   uint256 public blockLock;
8 
9   mapping (address => bool) restrictedAddresses;
10 
11   // @dev Constructor function that sets freeze parameters so they don't unintentionally hinder operations.
12   function controlled() public{
13     owner = 0x24bF9FeCA8894A78d231f525c054048F5932dc6B;
14     tokenFrozenSinceBlock = (2 ** 256) - 1;
15     tokenFrozenUntilBlock = 0;
16     blockLock = 5571500;
17   }
18 
19   /*
20   * @dev Transfers ownership rights to current owner to the new owner.
21   * @param newOwner address Address to become the new SC owner.
22   */
23   function transferOwnership (address newOwner) onlyOwner public{
24     owner = newOwner;
25   }
26 
27   /*
28   * @dev Allows owner to restrict or reenable addresses to use the token.
29   * @param _restrictedAddress address Address of the user whose state we are planning to modify.
30   * @param _restrict bool Restricts uder from using token. true restricts the address while false enables it.
31   */
32   function editRestrictedAddress(address _restrictedAddress, bool _restrict) public onlyOwner{
33     if(!restrictedAddresses[_restrictedAddress] && _restrict){
34       restrictedAddresses[_restrictedAddress] = _restrict;
35     }
36     else if(restrictedAddresses[_restrictedAddress] && !_restrict){
37       restrictedAddresses[_restrictedAddress] = _restrict;
38     }
39     else{
40       revert();
41     }
42   }
43 
44 
45 
46   /************ Modifiers to restrict access to functions. ************/
47 
48   // @dev Modifier to make sure the owner's functions are only called by the owner.
49   modifier onlyOwner{
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /*
55   * @dev Modifier to check whether destination of sender aren't forbidden from using the token.
56   * @param _to address Address of the transfer destination.
57   */
58   modifier instForbiddenAddress(address _to){
59     require(_to != 0x0);
60     require(_to != address(this));
61     require(!restrictedAddresses[_to]);
62     require(!restrictedAddresses[msg.sender]);
63     _;
64   }
65 
66   // @dev Modifier to check if the token is operational at the moment.
67   modifier unfrozenToken{
68     require(block.number >= blockLock || msg.sender == owner);
69     require(block.number >= tokenFrozenUntilBlock);
70     require(block.number <= tokenFrozenSinceBlock);
71     _;
72   }
73 }
74 
75 contract blocktrade is controlled{
76   string public name = "blocktrade.com";
77   string public symbol = "BTT";
78   uint8 public decimals = 18;
79   uint256 public initialSupply = 57746762*(10**18);
80   uint256 public supply;
81   string public tokenFrozenUntilNotice;
82   string public tokenFrozenSinceNotice;
83   bool public airDropFinished;
84 
85   mapping (address => uint256) balances;
86   mapping (address => mapping (address => uint256)) allowances;
87 
88   event Transfer(address indexed from, address indexed to, uint256 value);
89   event TokenFrozenUntil(uint256 _frozenUntilBlock, string _reason);
90   event TokenFrozenSince(uint256 _frozenSinceBlock, string _reason);
91   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92   event Burn(address indexed from, uint256 value);
93 
94   /*
95   * @dev Constructor function.
96   */
97   function blocktrade() public{
98     supply = 57746762*(10**18);
99     airDropFinished = false;
100     balances[owner] = 57746762*(10**18);
101   }
102 
103 
104   /************ Constant return functions ************/
105   //@dev Returns the name of the token.
106   function tokenName() constant public returns(string _tokenName){
107     return name;
108   }
109 
110   //@dev Returns the symbol of the token.
111   function tokenSymbol() constant public returns(string _tokenSymbol){
112     return symbol;
113   }
114 
115   //@dev Returns the number of decimals the token uses - e.g. 8, means to divide the token amount by 100000000 to get its user representation.
116   function tokenDecimals() constant public returns(uint8 _tokenDecimals){
117     return decimals;
118   }
119 
120   //@dev Returns the total supply of the token
121   function totalSupply() constant public returns(uint256 _totalSupply){
122     return supply;
123   }
124 
125   /*
126   * @dev Allows us to view the token balance of the account.
127   * @param _tokenOwner address Address of the user whose token balance we are trying to view.
128   */
129   function balanceOf(address _tokenOwner) constant public returns(uint256 accountBalance){
130     return balances[_tokenOwner];
131   }
132 
133   /*
134   * @dev Allows us to view the token balance of the account.
135   * @param _owner address Address of the user whose token we are allowed to spend from sender address.
136   * @param _spender address Address of the user allowed to spend owner's tokens.
137   */
138   function allowance(address _owner, address _spender) constant public returns(uint256 remaining) {
139     return allowances[_owner][_spender];
140   }
141 
142   // @dev Returns when will the token become operational again and why it was frozen.
143   function getFreezeUntilDetails() constant public returns(uint256 frozenUntilBlock, string notice){
144     return(tokenFrozenUntilBlock, tokenFrozenUntilNotice);
145   }
146 
147   //@dev Returns when will the operations of token stop and why.
148   function getFreezeSinceDetails() constant public returns(uint frozenSinceBlock, string notice){
149     return(tokenFrozenSinceBlock, tokenFrozenSinceNotice);
150   }
151 
152   /*
153   * @dev Returns info whether address can use the token or not.
154   * @param _queryAddress address Address of the account we want to check.
155   */
156   function isRestrictedAddress(address _queryAddress) constant public returns(bool answer){
157     return restrictedAddresses[_queryAddress];
158   }
159 
160 
161   /************ Operational functions ************/
162   /*
163   * @dev Used for sending own tokens to other addresses. Keep in mind that you have to take decimals into account. Multiply the value in tokens with 10^tokenDecimals.
164   * @param _to address Destination where we want to send the tokens to.
165   * @param _value uint256 Amount of tokens we want to sender.
166   */
167   function transfer(address _to, uint256 _value) unfrozenToken instForbiddenAddress(_to) public returns(bool success){
168     require(balances[msg.sender] >= _value);           // Check if the sender has enough
169     require(balances[_to] + _value >= balances[_to]) ;  // Check for overflows
170 
171     balances[msg.sender] -= _value;                     // Subtract from the sender
172     balances[_to] += _value;                            // Add the same to the recipient
173     emit Transfer(msg.sender, _to, _value);                  // Notify anyone listening that this transfer took place
174     return true;
175   }
176 
177   /*
178   * @dev Sets allowance to the spender from our address.
179   * @param _spender address Address of the spender we are giving permissions to.
180   * @param _value uint256 Amount of tokens the spender is allowed to spend from owner's accoun. Note the decimal spaces.
181   */
182   function approve(address _spender, uint256 _value) unfrozenToken public returns (bool success){
183     allowances[msg.sender][_spender] = _value;          // Set allowance
184     emit Approval(msg.sender, _spender, _value);             // Raise Approval event
185     return true;
186   }
187 
188   /*
189   * @dev Used by spender to transfer some one else's tokens.
190   * @param _form address Address of the owner of the tokens.
191   * @param _to address Address where we want to transfer tokens to.
192   * @param _value uint256 Amount of tokens we want to transfer. Note the decimal spaces.
193   */
194   function transferFrom(address _from, address _to, uint256 _value) unfrozenToken instForbiddenAddress(_to) public returns(bool success){
195     require(balances[_from] >= _value);                // Check if the sender has enough
196     require(balances[_to] + _value >= balances[_to]);  // Check for overflows
197     require(_value <= allowances[_from][msg.sender]);  // Check allowance
198 
199     balances[_from] -= _value;                          // Subtract from the sender
200     balances[_to] += _value;                            // Add the same to the recipient
201     allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address
202     emit Transfer(_from, _to, _value);                       // Notify anyone listening that this transfer took place
203     return true;
204   }
205 
206   /*
207   * @dev Ireversibly destroy the specified amount of tokens.
208   * @param _value uint256 Amount of tokens we want to destroy.
209   */
210   function burn(uint256 _value) onlyOwner public returns(bool success){
211     require(balances[msg.sender] >= _value);                 // Check if the sender has enough
212     balances[msg.sender] -= _value;                          // Subtract from the sender
213     supply -= _value;
214     emit Burn(msg.sender, _value);
215     return true;
216   }
217 
218   /*
219   * @dev Freezes transfers untill the specified block. Afterwards all of the operations are carried on as normal.
220   * @param _frozenUntilBlock uint256 Number of block untill which all of the transfers are frozen.
221   * @param _freezeNotice string Reason fot the freeze of operations.
222   */
223   function freezeTransfersUntil(uint256 _frozenUntilBlock, string _freezeNotice) onlyOwner public returns(bool success){
224     tokenFrozenUntilBlock = _frozenUntilBlock;
225     tokenFrozenUntilNotice = _freezeNotice;
226     emit TokenFrozenUntil(_frozenUntilBlock, _freezeNotice);
227     return true;
228   }
229 
230   /*
231   * @dev Freezes all of the transfers after specified block.
232   * @param _frozenSinceBlock uint256 Number of block after which all of the transfers are frozen.
233   * @param _freezeNotice string Reason for the freeze.
234   */
235   function freezeTransfersSince(uint256 _frozenSinceBlock, string _freezeNotice) onlyOwner public returns(bool success){
236     tokenFrozenSinceBlock = _frozenSinceBlock;
237     tokenFrozenSinceNotice = _freezeNotice;
238     emit TokenFrozenSince(_frozenSinceBlock, _freezeNotice);
239     return true;
240   }
241 
242   /*
243   * @dev Reenables the operation before the specified block was reached.
244   * @param _unfreezeNotice string Reason for the unfreeze or explanation of solution.
245   */
246   function unfreezeTransfersUntil(string _unfreezeNotice) onlyOwner public returns(bool success){
247     tokenFrozenUntilBlock = 0;
248     tokenFrozenUntilNotice = _unfreezeNotice;
249     emit TokenFrozenUntil(0, _unfreezeNotice);
250     return true;
251   }
252 
253   /*
254   * @dev Reenabling after the freeze since was initiated.
255   * @param _unfreezeNotice string Reason for the unfreeze or the explanation of solution.
256   */
257   function unfreezeTransfersSince(string _unfreezeNotice) onlyOwner public returns(bool success){
258     tokenFrozenSinceBlock = (2 ** 256) - 1;
259     tokenFrozenSinceNotice = _unfreezeNotice;
260     emit TokenFrozenSince((2 ** 256) - 1, _unfreezeNotice);
261     return true;
262   }
263 
264 
265 
266   /************ AirDrop part of the SC. ************/
267 
268   /*
269   * @dev Allocates the specified amount of tokens to the address.
270   * @param _beneficiary address Address of the ouser that receives the tokens.
271   * @param _tokens uint256 Amount of tokens to allocate.
272   */
273   function airDrop(address _beneficiary, uint256 _tokens) onlyOwner public returns(bool success){
274     require(!airDropFinished);
275     balances[owner] -= _tokens;
276     balances[_beneficiary] += _tokens;
277     return true;
278   }
279 
280   // @dev Function that irreversively disables airDrop and should be called right after airDrop is completed.
281   function endAirDrop() onlyOwner public returns(bool success){
282     require(!airDropFinished);
283     airDropFinished = true;
284     return true;
285   }
286 }
287 //JA