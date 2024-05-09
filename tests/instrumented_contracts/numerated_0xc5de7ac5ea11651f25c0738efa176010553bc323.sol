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
119 
120 contract NEOCASHToken is StdToken
121 {
122 /// Fields:
123     string public constant name = "NEO CASH";
124     string public constant symbol = "NEOC";
125     uint public constant decimals = 18;
126 
127     uint public constant TOTAL_SUPPLY = 100000000 * (1 ether / 1 wei);
128     // this includes DEVELOPERS_BONUS
129     uint public constant DEVELOPERS_BONUS = 65000000 * (1 ether / 1 wei);
130 	
131     uint public constant PRESALE_PRICE = 50;  // per 1 Ether
132     uint public constant PRESALE_MAX_ETH = 100000;
133     uint public constant PRESALE_TOKEN_SUPPLY_LIMIT = PRESALE_PRICE * PRESALE_MAX_ETH * (1 ether / 1 wei);
134 
135 
136     uint public constant ICO_PRICE1 = 40;     // per 1 Ether
137     uint public constant ICO_PRICE2 = 30;     // per 1 Ether
138     uint public constant ICO_PRICE3 = 10;     // per 1 Ether
139 
140     // 680M2k2 - this includes presale tokens
141     uint public constant TOTAL_SOLD_TOKEN_SUPPLY_LIMIT = 35000000* (1 ether / 1 wei);
142 
143     enum State{
144        Init,
145        Paused,
146 
147        PresaleRunning,
148        PresaleFinished,
149 
150        ICORunning,
151        ICOFinished
152     }
153 
154     State public currentState = State.Init;
155     bool public enableTransfers = true;
156 
157     address public teamTokenBonus = 0;
158 
159     // Gathered funds can be withdrawn only to escrow's address.
160     address public escrow = 0;
161 
162     // Token manager has exclusive priveleges to call administrative
163     // functions on this contract.
164     address public tokenManager = 0;
165 
166     uint public presaleSoldTokens = 0;
167     uint public icoSoldTokens = 0;
168     uint public totalSoldTokens = 0;
169 
170 /// Modifiers:
171     modifier onlyTokenManager()
172     {
173         require(msg.sender==tokenManager); 
174         _; 
175     }
176     
177     modifier onlyTokenCrowner()
178     {
179         require(msg.sender==escrow); 
180         _; 
181     }
182 
183     modifier onlyInState(State state)
184     {
185         require(state==currentState); 
186         _; 
187     }
188 
189 /// Events:
190     event LogBuy(address indexed owner, uint value);
191     event LogBurn(address indexed owner, uint value);
192 
193 /// Functions:
194     /// @dev Constructor
195     /// @param _tokenManager Token manager address.
196     function NEOCASHToken(address _tokenManager, address _escrow, address _teamTokenBonus) 
197     {
198         tokenManager = _tokenManager;
199         teamTokenBonus = _teamTokenBonus;
200         escrow = _escrow;
201 
202         // send team bonus immediately
203         uint teamBonus = DEVELOPERS_BONUS;
204         balances[_teamTokenBonus] += teamBonus;
205         supply+= teamBonus;
206         
207         assert(PRESALE_TOKEN_SUPPLY_LIMIT==5000000 * (1 ether / 1 wei));
208         assert(TOTAL_SOLD_TOKEN_SUPPLY_LIMIT==35000000 * (1 ether / 1 wei));
209     }
210 
211     function buyTokens() public payable
212     {
213         require(currentState==State.PresaleRunning || currentState==State.ICORunning);
214 
215         if(currentState==State.PresaleRunning){
216             return buyTokensPresale();
217         }else{
218             return buyTokensICO();
219         }
220     }
221 
222     function buyTokensPresale() public payable onlyInState(State.PresaleRunning)
223     {
224         // min - 1 ETH
225         //require(msg.value >= (1 ether / 1 wei));
226         // min - 0.01 ETH
227         require(msg.value >= ((1 ether / 1 wei) / 100));
228         uint newTokens = msg.value * PRESALE_PRICE;
229 
230         require(presaleSoldTokens + newTokens <= PRESALE_TOKEN_SUPPLY_LIMIT);
231 
232         balances[msg.sender] += newTokens;
233         supply+= newTokens;
234         presaleSoldTokens+= newTokens;
235         totalSoldTokens+= newTokens;
236 
237         LogBuy(msg.sender, newTokens);
238     }
239 
240     function buyTokensICO() public payable onlyInState(State.ICORunning)
241     {
242         // min - 0.01 ETH
243         require(msg.value >= ((1 ether / 1 wei) / 100));
244         uint newTokens = msg.value * getPrice();
245 
246         require(totalSoldTokens + newTokens <= TOTAL_SOLD_TOKEN_SUPPLY_LIMIT);
247 
248         balances[msg.sender] += newTokens;
249         supply+= newTokens;
250         icoSoldTokens+= newTokens;
251         totalSoldTokens+= newTokens;
252 
253         LogBuy(msg.sender, newTokens);
254     }
255 
256     function getPrice()constant returns(uint)
257     {
258         if(currentState==State.ICORunning){
259              if(icoSoldTokens<(10000000 * (1 ether / 1 wei))){
260                   return ICO_PRICE1;
261              }
262              
263              if(icoSoldTokens<(15000000 * (1 ether / 1 wei))){
264                   return ICO_PRICE2;
265              }
266 
267              return ICO_PRICE3;
268         }else{
269              return PRESALE_PRICE;
270         }
271     }
272 
273     function setState(State _nextState) public onlyTokenManager
274     {
275         //setState() method call shouldn't be entertained after ICOFinished
276         require(currentState != State.ICOFinished);
277         
278         currentState = _nextState;
279         // enable/disable transfers
280         //enable transfers only after ICOFinished, disable otherwise
281         //enableTransfers = (currentState==State.ICOFinished);
282     }
283     
284     function DisableTransfer() public onlyTokenManager
285     {
286         enableTransfers = false;
287     }
288     
289     
290     function EnableTransfer() public onlyTokenManager
291     {
292         enableTransfers = true;
293     }
294 
295     function withdrawEther() public onlyTokenManager
296     {
297         if(this.balance > 0) 
298         {
299             require(escrow.send(this.balance));
300         }
301     }
302 
303 /// Overrides:
304     function transfer(address _to, uint256 _value) returns(bool){
305         require(enableTransfers);
306         return super.transfer(_to,_value);
307     }
308 
309     function transferFrom(address _from, address _to, uint256 _value) returns(bool){
310         require(enableTransfers);
311         return super.transferFrom(_from,_to,_value);
312     }
313 
314     function approve(address _spender, uint256 _value) returns (bool) {
315         require(enableTransfers);
316         return super.approve(_spender,_value);
317     }
318 
319 /// Setters/getters
320     function ChangeTokenManager(address _mgr) public onlyTokenManager
321     {
322         tokenManager = _mgr;
323     }
324     
325     function ChangeCrowner(address _mgr) public onlyTokenCrowner
326     {
327         escrow = _mgr;
328     }
329 
330     // Default fallback function
331     function() payable 
332     {
333         buyTokens();
334     }
335 }