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
118 contract EthLendToken is StdToken
119 {
120 /// Fields:
121     string public constant name = "EthLend Token";
122     string public constant symbol = "LEND";
123     uint public constant decimals = 18;
124 
125     // this includes DEVELOPERS_BONUS
126     uint public constant TOTAL_SUPPLY = 1300000000 * (1 ether / 1 wei);
127     uint public constant DEVELOPERS_BONUS = 300000000 * (1 ether / 1 wei);
128 
129     uint public constant PRESALE_PRICE = 30000;  // per 1 Ether
130     uint public constant PRESALE_MAX_ETH = 2000;
131     // 60 mln tokens sold during presale
132     uint public constant PRESALE_TOKEN_SUPPLY_LIMIT = PRESALE_PRICE * PRESALE_MAX_ETH * (1 ether / 1 wei);
133 
134     uint public constant ICO_PRICE1 = 27500;     // per 1 Ether
135     uint public constant ICO_PRICE2 = 26250;     // per 1 Ether
136     uint public constant ICO_PRICE3 = 25000;     // per 1 Ether
137 
138     // 1bln - this includes presale tokens
139     uint public constant TOTAL_SOLD_TOKEN_SUPPLY_LIMIT = 1000000000* (1 ether / 1 wei);
140 
141     enum State{
142        Init,
143        Paused,
144 
145        PresaleRunning,
146        PresaleFinished,
147 
148        ICORunning,
149        ICOFinished
150     }
151 
152     State public currentState = State.Init;
153     bool public enableTransfers = false;
154 
155     address public teamTokenBonus = 0;
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
167 
168 /// Modifiers:
169     modifier onlyTokenManager()
170     {
171         require(msg.sender==tokenManager); 
172         _; 
173     }
174 
175     modifier onlyInState(State state)
176     {
177         require(state==currentState); 
178         _; 
179     }
180 
181 /// Events:
182     event LogBuy(address indexed owner, uint value);
183     event LogBurn(address indexed owner, uint value);
184 
185 /// Functions:
186     /// @dev Constructor
187     /// @param _tokenManager Token manager address.
188     function EthLendToken(address _tokenManager, address _escrow, address _teamTokenBonus) 
189     {
190         tokenManager = _tokenManager;
191         teamTokenBonus = _teamTokenBonus;
192         escrow = _escrow;
193 
194         // send team bonus immediately
195         uint teamBonus = DEVELOPERS_BONUS;
196         balances[_teamTokenBonus] += teamBonus;
197         supply+= teamBonus;
198 
199         assert(PRESALE_TOKEN_SUPPLY_LIMIT==60000000 * (1 ether / 1 wei));
200         assert(TOTAL_SOLD_TOKEN_SUPPLY_LIMIT==1000000000 * (1 ether / 1 wei));
201     }
202 
203     function buyTokens() public payable
204     {
205         require(currentState==State.PresaleRunning || currentState==State.ICORunning);
206 
207         if(currentState==State.PresaleRunning){
208             return buyTokensPresale();
209         }else{
210             return buyTokensICO();
211         }
212     }
213 
214     function buyTokensPresale() public payable onlyInState(State.PresaleRunning)
215     {
216         // min - 1 ETH
217         require(msg.value >= (1 ether / 1 wei));
218         uint newTokens = msg.value * PRESALE_PRICE;
219 
220         require(presaleSoldTokens + newTokens <= PRESALE_TOKEN_SUPPLY_LIMIT);
221 
222         balances[msg.sender] += newTokens;
223         supply+= newTokens;
224         presaleSoldTokens+= newTokens;
225         totalSoldTokens+= newTokens;
226 
227         LogBuy(msg.sender, newTokens);
228     }
229 
230     function buyTokensICO() public payable onlyInState(State.ICORunning)
231     {
232         // min - 0.01 ETH
233         require(msg.value >= ((1 ether / 1 wei) / 100));
234         uint newTokens = msg.value * getPrice();
235 
236         require(totalSoldTokens + newTokens <= TOTAL_SOLD_TOKEN_SUPPLY_LIMIT);
237 
238         balances[msg.sender] += newTokens;
239         supply+= newTokens;
240         icoSoldTokens+= newTokens;
241         totalSoldTokens+= newTokens;
242 
243         LogBuy(msg.sender, newTokens);
244     }
245 
246     function getPrice()constant returns(uint)
247     {
248         if(currentState==State.ICORunning){
249              if(icoSoldTokens<(200000000 * (1 ether / 1 wei))){
250                   return ICO_PRICE1;
251              }
252              
253              if(icoSoldTokens<(300000000 * (1 ether / 1 wei))){
254                   return ICO_PRICE2;
255              }
256 
257              return ICO_PRICE3;
258         }else{
259              return PRESALE_PRICE;
260         }
261     }
262 
263     function setState(State _nextState) public onlyTokenManager
264     {
265         //setState() method call shouldn't be entertained after ICOFinished
266         require(currentState != State.ICOFinished);
267         
268         currentState = _nextState;
269         // enable/disable transfers
270         //enable transfers only after ICOFinished, disable otherwise
271         enableTransfers = (currentState==State.ICOFinished);
272     }
273 
274     function withdrawEther() public onlyTokenManager
275     {
276         if(this.balance > 0) 
277         {
278             require(escrow.send(this.balance));
279         }
280     }
281 
282 /// Overrides:
283     function transfer(address _to, uint256 _value) returns(bool){
284         require(enableTransfers);
285         return super.transfer(_to,_value);
286     }
287 
288     function transferFrom(address _from, address _to, uint256 _value) returns(bool){
289         require(enableTransfers);
290         return super.transferFrom(_from,_to,_value);
291     }
292 
293     function approve(address _spender, uint256 _value) returns (bool) {
294         require(enableTransfers);
295         return super.approve(_spender,_value);
296     }
297 
298 /// Setters/getters
299     function setTokenManager(address _mgr) public onlyTokenManager
300     {
301         tokenManager = _mgr;
302     }
303 
304     // Default fallback function
305     function() payable 
306     {
307         buyTokens();
308     }
309 }