1 pragma solidity ^0.4.16;
2 
3 // SafeMath
4 contract SafeMath {
5      function safeMul(uint a, uint b) internal returns (uint) {
6           uint c = a * b;
7           assert(a == 0 || c / a == b);
8           return c;
9      }
10 
11      function safeSub(uint a, uint b) internal returns (uint) {
12           assert(b <= a);
13           return a - b;
14      }
15 
16      function safeAdd(uint a, uint b) internal returns (uint) {
17           uint c = a + b;
18           assert(c>=a && c>=b);
19           return c;
20      }
21 }
22 
23 // Standard token interface (ERC 20)
24 // https://github.com/ethereum/EIPs/issues/20
25 // Token
26 contract Token is SafeMath {
27      // Functions:
28      /// @return total amount of tokens
29      function totalSupply() constant returns (uint256 supply);
30 
31      /// @param _owner The address from which the balance will be retrieved
32      /// @return The balance
33      function balanceOf(address _owner) constant returns (uint256 balance);
34 
35      /// @notice send `_value` token to `_to` from `msg.sender`
36      /// @param _to The address of the recipient
37      /// @param _value The amount of token to be transferred
38      function transfer(address _to, uint256 _value) returns(bool);
39 
40      /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41      /// @param _from The address of the sender
42      /// @param _to The address of the recipient
43      /// @param _value The amount of token to be transferred
44      /// @return Whether the transfer was successful or not
45      function transferFrom(address _from, address _to, uint256 _value) returns(bool);
46 
47      /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
48      /// @param _spender The address of the account able to transfer the tokens
49      /// @param _value The amount of wei to be approved for transfer
50      /// @return Whether the approval was successful or not
51      function approve(address _spender, uint256 _value) returns (bool success);
52 
53      /// @param _owner The address of the account owning tokens
54      /// @param _spender The address of the account able to transfer the tokens
55      /// @return Amount of remaining tokens allowed to spent
56      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
57 
58      // Events:
59      event Transfer(address indexed _from, address indexed _to, uint256 _value);
60      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61 }
62 //StdToken
63 contract StdToken is Token {
64      // Fields:
65      mapping(address => uint256) balances;
66      mapping (address => mapping (address => uint256)) allowed;
67      uint public supply = 0;
68 
69      // Functions:
70      function transfer(address _to, uint256 _value) returns(bool) {
71           require(balances[msg.sender] >= _value);
72           require(balances[_to] + _value > balances[_to]);
73 
74           balances[msg.sender] = safeSub(balances[msg.sender],_value);
75           balances[_to] = safeAdd(balances[_to],_value);
76 
77           Transfer(msg.sender, _to, _value);
78           return true;
79      }
80 
81      function transferFrom(address _from, address _to, uint256 _value) returns(bool){
82           require(balances[_from] >= _value);
83           require(allowed[_from][msg.sender] >= _value);
84           require(balances[_to] + _value > balances[_to]);
85 
86           balances[_to] = safeAdd(balances[_to],_value);
87           balances[_from] = safeSub(balances[_from],_value);
88           allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
89 
90           Transfer(_from, _to, _value);
91           return true;
92      }
93 
94      function totalSupply() constant returns (uint256) {
95           return supply;
96      }
97 
98      function balanceOf(address _owner) constant returns (uint256) {
99           return balances[_owner];
100      }
101 
102      function approve(address _spender, uint256 _value) returns (bool) {
103           // To change the approve amount you first have to reduce the addresses`
104           //  allowance to zero by calling `approve(_spender, 0)` if it is not
105           //  already 0 to mitigate the race condition described here:
106           //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
107           require((_value == 0) || (allowed[msg.sender][_spender] == 0));
108 
109           allowed[msg.sender][_spender] = _value;
110           Approval(msg.sender, _spender, _value);
111 
112           return true;
113      }
114 
115      function allowance(address _owner, address _spender) constant returns (uint256) {
116           return allowed[_owner][_spender];
117      }
118 }
119 // UHubToken
120 contract UHubToken is StdToken
121 {
122 /// Fields:
123     string public constant name = "UHUB";
124     string public constant symbol = "HUB";
125     uint public constant decimals = 18;
126 
127     uint public constant TOTAL_SUPPLY = 1156789000 * (1 ether / 1 wei); //1B156M789K
128     // this includes DEVELOPERS_BONUS
129     uint public constant DEVELOPERS_BONUS = 476787800 * (1 ether / 1 wei); //476M787K
130 	
131 	// 100M1k2 tokens sold during presale
132     uint public constant PRESALE_PRICE = 5200;  // per 1 Ether
133     uint public constant PRESALE_MAX_ETH = 19231;
134     uint public constant PRESALE_TOKEN_SUPPLY_LIMIT = PRESALE_PRICE * PRESALE_MAX_ETH * (1 ether / 1 wei);
135 
136 
137     uint public constant ICO_PRICE1 = 4600;     // per 1 Ether
138     uint public constant ICO_PRICE2 = 4200;     // per 1 Ether
139     uint public constant ICO_PRICE3 = 4000;     // per 1 Ether
140 
141     // 680M2k2 - this includes presale tokens
142     uint public constant TOTAL_SOLD_TOKEN_SUPPLY_LIMIT = 680001200* (1 ether / 1 wei);
143 
144     enum State{
145        Init,
146        Paused,
147 
148        PresaleRunning,
149        PresaleFinished,
150 
151        ICORunning,
152        ICOFinished
153     }
154 
155     State public currentState = State.Init;
156     bool public enableTransfers = true;
157 
158     address public teamTokenBonus = 0;
159 
160     // Gathered funds can be withdrawn only to escrow's address.
161     address public escrow = 0;
162 
163     // Token manager has exclusive priveleges to call administrative
164     // functions on this contract.
165     address public tokenManager = 0;
166 
167     uint public presaleSoldTokens = 0;
168     uint public icoSoldTokens = 0;
169     uint public totalSoldTokens = 0;
170 
171 /// Modifiers:
172     modifier onlyTokenManager()
173     {
174         require(msg.sender==tokenManager); 
175         _; 
176     }
177     
178     modifier onlyTokenCrowner()
179     {
180         require(msg.sender==escrow); 
181         _; 
182     }
183 
184     modifier onlyInState(State state)
185     {
186         require(state==currentState); 
187         _; 
188     }
189 
190 /// Events:
191     event LogBuy(address indexed owner, uint value);
192     event LogBurn(address indexed owner, uint value);
193 
194 /// Functions:
195     /// @dev Constructor
196     /// @param _tokenManager Token manager address.
197     function UHubToken(address _tokenManager, address _escrow, address _teamTokenBonus) 
198     {
199         tokenManager = _tokenManager;
200         teamTokenBonus = _teamTokenBonus;
201         escrow = _escrow;
202 
203         // send team bonus immediately
204         uint teamBonus = DEVELOPERS_BONUS;
205         balances[_teamTokenBonus] += teamBonus;
206         supply+= teamBonus;
207         
208         assert(PRESALE_TOKEN_SUPPLY_LIMIT==100001200 * (1 ether / 1 wei));
209         assert(TOTAL_SOLD_TOKEN_SUPPLY_LIMIT==680001200 * (1 ether / 1 wei));
210     }
211 
212     function buyTokens() public payable
213     {
214         require(currentState==State.PresaleRunning || currentState==State.ICORunning);
215 
216         if(currentState==State.PresaleRunning){
217             return buyTokensPresale();
218         }else{
219             return buyTokensICO();
220         }
221     }
222 
223     function buyTokensPresale() public payable onlyInState(State.PresaleRunning)
224     {
225         // min - 1 ETH
226         //require(msg.value >= (1 ether / 1 wei));
227         // min - 0.01 ETH
228         require(msg.value >= ((1 ether / 1 wei) / 100));
229         uint newTokens = msg.value * PRESALE_PRICE;
230 
231         require(presaleSoldTokens + newTokens <= PRESALE_TOKEN_SUPPLY_LIMIT);
232 
233         balances[msg.sender] += newTokens;
234         supply+= newTokens;
235         presaleSoldTokens+= newTokens;
236         totalSoldTokens+= newTokens;
237 
238         LogBuy(msg.sender, newTokens);
239     }
240 
241     function buyTokensICO() public payable onlyInState(State.ICORunning)
242     {
243         // min - 0.01 ETH
244         require(msg.value >= ((1 ether / 1 wei) / 100));
245         uint newTokens = msg.value * getPrice();
246 
247         require(totalSoldTokens + newTokens <= TOTAL_SOLD_TOKEN_SUPPLY_LIMIT);
248 
249         balances[msg.sender] += newTokens;
250         supply+= newTokens;
251         icoSoldTokens+= newTokens;
252         totalSoldTokens+= newTokens;
253 
254         LogBuy(msg.sender, newTokens);
255     }
256 
257     function getPrice()constant returns(uint)
258     {
259         if(currentState==State.ICORunning){
260              if(icoSoldTokens<(200000000 * (1 ether / 1 wei))){
261                   return ICO_PRICE1;
262              }
263              
264              if(icoSoldTokens<(300000000 * (1 ether / 1 wei))){
265                   return ICO_PRICE2;
266              }
267 
268              return ICO_PRICE3;
269         }else{
270              return PRESALE_PRICE;
271         }
272     }
273 
274     function setState(State _nextState) public onlyTokenManager
275     {
276         //setState() method call shouldn't be entertained after ICOFinished
277         require(currentState != State.ICOFinished);
278         
279         currentState = _nextState;
280         // enable/disable transfers
281         //enable transfers only after ICOFinished, disable otherwise
282         //enableTransfers = (currentState==State.ICOFinished);
283     }
284     
285     function DisableTransfer() public onlyTokenManager
286     {
287         enableTransfers = false;
288     }
289     
290     
291     function EnableTransfer() public onlyTokenManager
292     {
293         enableTransfers = true;
294     }
295 
296     function withdrawEther() public onlyTokenManager
297     {
298         if(this.balance > 0) 
299         {
300             require(escrow.send(this.balance));
301         }
302     }
303 
304 /// Overrides:
305     function transfer(address _to, uint256 _value) returns(bool){
306         require(enableTransfers);
307         return super.transfer(_to,_value);
308     }
309 
310     function transferFrom(address _from, address _to, uint256 _value) returns(bool){
311         require(enableTransfers);
312         return super.transferFrom(_from,_to,_value);
313     }
314 
315     function approve(address _spender, uint256 _value) returns (bool) {
316         require(enableTransfers);
317         return super.approve(_spender,_value);
318     }
319 
320 /// Setters/getters
321     function ChangeTokenManager(address _mgr) public onlyTokenManager
322     {
323         tokenManager = _mgr;
324     }
325     
326     function ChangeCrowner(address _mgr) public onlyTokenCrowner
327     {
328         escrow = _mgr;
329     }
330 
331     // Default fallback function
332     function() payable 
333     {
334         buyTokens();
335     }
336 }