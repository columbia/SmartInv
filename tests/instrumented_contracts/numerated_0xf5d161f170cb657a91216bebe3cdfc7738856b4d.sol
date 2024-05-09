1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4      function safeMul(uint a, uint b) internal returns (uint) {
5           uint c = a * b;
6           assert(a == 0 || c / a == b);
7           return c;
8      }
9 
10      function safeSub(uint a, uint b) internal returns (uint) {
11           assert(b <= a);
12           return a - b;
13      }
14 
15      function safeAdd(uint a, uint b) internal returns (uint) {
16           uint c = a + b;
17           assert(c>=a && c>=b);
18           return c;
19      }
20 }
21 
22 // Standard token interface (ERC 20)
23 // https://github.com/ethereum/EIPs/issues/20
24 contract Token is SafeMath {
25      // Functions:
26      /// @return total amount of tokens
27      function totalSupply() constant returns (uint256 supply);
28 
29      /// @param _owner The address from which the balance will be retrieved
30      /// @return The balance
31      function balanceOf(address _owner) constant returns (uint256 balance);
32 
33      /// @notice send `_value` token to `_to` from `msg.sender`
34      /// @param _to The address of the recipient
35      /// @param _value The amount of token to be transferred
36      function transfer(address _to, uint256 _value) returns(bool);
37 
38      /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
39      /// @param _from The address of the sender
40      /// @param _to The address of the recipient
41      /// @param _value The amount of token to be transferred
42      /// @return Whether the transfer was successful or not
43      function transferFrom(address _from, address _to, uint256 _value) returns(bool);
44 
45      /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
46      /// @param _spender The address of the account able to transfer the tokens
47      /// @param _value The amount of wei to be approved for transfer
48      /// @return Whether the approval was successful or not
49      function approve(address _spender, uint256 _value) returns (bool success);
50 
51      /// @param _owner The address of the account owning tokens
52      /// @param _spender The address of the account able to transfer the tokens
53      /// @return Amount of remaining tokens allowed to spent
54      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
55 
56      // Events:
57      event Transfer(address indexed _from, address indexed _to, uint256 _value);
58      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 }
60 
61 contract StdToken is Token {
62      // Fields:
63      mapping(address => uint256) balances;
64      mapping (address => mapping (address => uint256)) allowed;
65      uint public supply = 0;
66 
67      // Functions:
68      function transfer(address _to, uint256 _value) returns(bool) {
69           require(balances[msg.sender] >= _value);
70           require(balances[_to] + _value > balances[_to]);
71 
72           balances[msg.sender] = safeSub(balances[msg.sender],_value);
73           balances[_to] = safeAdd(balances[_to],_value);
74 
75           Transfer(msg.sender, _to, _value);
76           return true;
77      }
78 
79      function transferFrom(address _from, address _to, uint256 _value) returns(bool){
80           require(balances[_from] >= _value);
81           require(allowed[_from][msg.sender] >= _value);
82           require(balances[_to] + _value > balances[_to]);
83 
84           balances[_to] = safeAdd(balances[_to],_value);
85           balances[_from] = safeSub(balances[_from],_value);
86           allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
87 
88           Transfer(_from, _to, _value);
89           return true;
90      }
91 
92      function totalSupply() constant returns (uint256) {
93           return supply;
94      }
95 
96      function balanceOf(address _owner) constant returns (uint256) {
97           return balances[_owner];
98      }
99 
100      function approve(address _spender, uint256 _value) returns (bool) {
101           // To change the approve amount you first have to reduce the addresses`
102           //  allowance to zero by calling `approve(_spender, 0)` if it is not
103           //  already 0 to mitigate the race condition described here:
104           //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105           require((_value == 0) || (allowed[msg.sender][_spender] == 0));
106 
107           allowed[msg.sender][_spender] = _value;
108           Approval(msg.sender, _spender, _value);
109 
110           return true;
111      }
112 
113      function allowance(address _owner, address _spender) constant returns (uint256) {
114           return allowed[_owner][_spender];
115      }
116 }
117 
118 contract ZupplyToken is StdToken
119 {
120 /// Fields:
121     string public name = "ZupplyToken";
122     string public symbol = "ZUP";
123     uint public constant decimals = 18;
124 
125     // this includes DEVELOPERS_BONUS
126     uint public constant TOTAL_SUPPLY = 750000000 * (1 ether / 1 wei);
127     uint public constant DEVELOPERS_BONUS = 100000000 * (1 ether / 1 wei);
128     uint public constant EARLY_INV_BONUS = 50000000 * (1 ether / 1 wei);
129 
130     uint public constant PRESALE_PRICE = 40000;  // per 1 Ether
131     uint public constant PRESALE_MAX_ETH = 2500;
132     // 100 mln tokens sold during presale
133     uint public constant PRESALE_TOKEN_SUPPLY_LIMIT = PRESALE_PRICE * PRESALE_MAX_ETH * (1 ether / 1 wei);
134 
135     uint public constant ICO_PRICE = 20000;     // per 1 Ether
136 
137     // 600 mln - this includes presale tokens
138     uint public constant TOTAL_SOLD_TOKEN_SUPPLY_LIMIT = 600000000* (1 ether / 1 wei);
139 
140     enum State{
141        Init,
142        Paused,
143 
144        PresaleRunning,
145        PresaleFinished,
146 
147        ICORunning,
148        ICOFinished
149     }
150 
151     State public currentState = State.Init;
152     bool public enableTransfers = false;
153 
154     address public teamTokenBonus = 0;
155     address public earlyInvestorsBonus = 0;
156 
157     // Gathered funds can be withdrawn only to escrow's address.
158     address public escrow = 0;
159 
160     // Token manager has exclusive priveleges to call administrative
161     // functions on this contract.
162     address public tokenManager = 0;
163 
164     uint public presaleSoldTokens = 0;
165     uint public icoSoldTokens = 0;
166     uint public totalSoldTokens = 0;
167     uint public totalWitdrowedToken = 0;
168 
169 /// Modifiers:
170     modifier onlyTokenManager()
171     {
172         require(msg.sender==tokenManager); 
173         _; 
174     }
175 
176     modifier onlyInState(State state)
177     {
178         require(state==currentState); 
179         _; 
180     }
181 
182 /// Events:
183     event LogBuy(address indexed owner, uint value);
184     event LogBurn(address indexed owner, uint value);
185 
186 /// Functions:
187     /// @dev Constructor
188     /// @param _tokenManager Token manager address.
189     function ZupplyToken(address _tokenManager, address _escrow, address _teamTokenBonus, address _eralyInvestorBonus) 
190     {
191         tokenManager = _tokenManager;
192         teamTokenBonus = _teamTokenBonus;
193         escrow = _escrow;
194         earlyInvestorsBonus = _eralyInvestorBonus; 
195 
196         // send team + early investors bonus immediately
197         uint teamBonus = DEVELOPERS_BONUS;
198         balances[_teamTokenBonus] += teamBonus;
199         uint earlyBonus = EARLY_INV_BONUS;
200         balances[_eralyInvestorBonus] += earlyBonus;
201         supply+= teamBonus;
202         supply+= earlyBonus;
203 
204         assert(PRESALE_TOKEN_SUPPLY_LIMIT==100000000 * (1 ether / 1 wei));
205         assert(TOTAL_SOLD_TOKEN_SUPPLY_LIMIT==600000000 * (1 ether / 1 wei));
206     }
207 
208     function buyTokens() public payable
209     {
210         require(currentState==State.PresaleRunning || currentState==State.ICORunning);
211 
212         if(currentState==State.PresaleRunning){
213             return buyTokensPresale();
214         }else{
215             return buyTokensICO();
216         }
217     }
218 
219     function buyTokensPresale() public payable onlyInState(State.PresaleRunning)
220     {
221         // min - 0.1 ETH
222         require(msg.value >= (1 ether / 1 wei) /10 );
223         uint newTokens = msg.value * PRESALE_PRICE;
224 
225         require(presaleSoldTokens + newTokens + totalWitdrowedToken <= PRESALE_TOKEN_SUPPLY_LIMIT);
226 
227         balances[msg.sender] += newTokens;
228         supply+= newTokens;
229         presaleSoldTokens+= newTokens;
230         totalSoldTokens+= newTokens;
231 
232         LogBuy(msg.sender, newTokens);
233     }
234 
235     function buyTokensICO() public payable onlyInState(State.ICORunning)
236     {
237         // min - 0.01 ETH
238         require(msg.value >= ((1 ether / 1 wei) / 100));
239         uint newTokens = msg.value * getPrice();
240 
241         require(totalSoldTokens + newTokens + totalWitdrowedToken <= TOTAL_SOLD_TOKEN_SUPPLY_LIMIT);
242 
243         balances[msg.sender] += newTokens;
244         supply+= newTokens;
245         icoSoldTokens+= newTokens;
246         totalSoldTokens+= newTokens;
247 
248         LogBuy(msg.sender, newTokens);
249     }
250 
251     function getPrice()constant returns(uint)
252     {
253         if(currentState==State.ICORunning){
254              return ICO_PRICE;
255         }else{
256              return PRESALE_PRICE;
257         }
258     }
259 
260     function setState(State _nextState) public onlyTokenManager
261     {
262         //setState() method call shouldn't be entertained after ICOFinished
263         require(currentState != State.ICOFinished);
264         
265         currentState = _nextState;
266         // enable/disable transfers
267         //enable transfers only after ICOFinished, disable otherwise
268         enableTransfers = (currentState==State.ICOFinished);
269     }
270 
271     function withdrawETH() public onlyTokenManager
272     {
273         if(this.balance > 0) 
274         {
275             require(escrow.send(this.balance));
276         }
277         
278     }
279     
280     function withdrawTokens(uint256 _value) public onlyTokenManager
281     {
282         require(currentState == State.ICOFinished);
283         if((totalSoldTokens + totalWitdrowedToken + _value) <= TOTAL_SOLD_TOKEN_SUPPLY_LIMIT) 
284         {
285             require(_value <= TOTAL_SOLD_TOKEN_SUPPLY_LIMIT - totalSoldTokens - totalWitdrowedToken);
286             
287             balances[escrow] += _value;
288             
289             totalWitdrowedToken += _value;
290             supply += _value;
291         }
292         
293     }
294 
295 /// Overrides:
296     function transfer(address _to, uint256 _value) returns(bool){
297         require(enableTransfers || msg.sender == tokenManager || msg.sender == teamTokenBonus || msg.sender == earlyInvestorsBonus );
298         return super.transfer(_to,_value);
299         
300     }
301 
302     function transferFrom(address _from, address _to, uint256 _value) returns(bool){
303         require(enableTransfers || msg.sender == tokenManager || msg.sender == teamTokenBonus || msg.sender == earlyInvestorsBonus );
304         return super.transferFrom(_from,_to,_value);
305             
306     }
307 
308     function approve(address _spender, uint256 _value) returns (bool) {
309         require(enableTransfers || msg.sender == tokenManager || msg.sender == teamTokenBonus || msg.sender == earlyInvestorsBonus );
310         return super.approve(_spender,_value);
311         
312     }
313     
314     function setNewAttributes(string _newName, string _newSymbol) public onlyTokenManager{
315         name = _newName;
316         symbol = _newSymbol;
317     }
318 
319 /// Setters/getters
320     function setTokenManager(address _mgr) public onlyTokenManager
321     {
322         tokenManager = _mgr;
323     }
324 
325     // Default fallback function
326     function() payable 
327     {
328         buyTokens();
329     }
330 }