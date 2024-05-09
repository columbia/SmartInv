1 pragma solidity ^0.4.10;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 contract TheMoneyFightToken {
9     
10     enum betStatus{Running,Pending,Done}
11     
12     address public owner = msg.sender;
13     
14     uint gamesIndex = 0;
15     
16     
17     uint public constant LOSER_LOCK_TIME = 4 weeks;
18     bool public purchasingAllowed = false;
19     
20     mapping (uint => Game) games;
21     mapping (uint => Result) results;
22     mapping (uint => Option[]) gameOptions;
23     
24     mapping (address => uint256) balances;
25     mapping (address => mapping (address => uint256)) allowed;
26 
27     uint256 public totalContribution = 0;
28     uint256 public cap = 10000000000000000000000;
29    
30     
31     uint256 public totalSupply = 0;
32     
33     event gameStarted(string gameName,uint id, uint options,uint endTime);
34     event gameFinished(uint gameId,uint winningOption, uint256 totalBets, uint256 totalBetsForWinningOption);
35     event betAdded(uint gameId,uint option, address ownerAddress, uint256 value);
36     event Redeem(uint gameId,uint option,bool winner, address ownerAddress, uint256 reward);
37     event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     
41     struct Option{
42         mapping (address=>uint256) status;
43     }
44     
45     struct Game{
46         betStatus status;
47         mapping (uint => uint256) totalBets;
48         uint256 total;
49         uint endTime;
50         uint finishTime;
51     }
52     
53     struct Result{
54         uint winningOption;
55         uint locktime;
56         uint256 betTotal;
57         uint256 winningOptionTotal;
58     }
59     
60     modifier only_owner() {
61 		if (msg.sender != owner) throw;
62 		_;
63 	}
64 	
65 	modifier canRedeem(uint gameId){
66 	    if(games[gameId].status != betStatus.Done) throw;
67 	    _;
68 	}
69 	
70 	modifier etherCapNotReached(uint256 _contribution) {
71         assert(safeAdd(totalContribution, _contribution) <= cap);
72         _;
73     }
74 	
75 	function canBet(uint gameId) returns(bool success){
76 	    bool running = now < games[gameId].finishTime;
77 	    bool statusOk =  games[gameId].status == betStatus.Running;
78 	    if(statusOk && !running) {
79 	        games[gameId].status = betStatus.Pending; 
80 	        statusOk = false;
81 	    }
82 	    return running && statusOk;
83 	} 
84 	
85    function safeMul(uint a, uint b) internal returns (uint) {
86     uint c = a * b;
87     assert(a == 0 || c / a == b);
88     return c;
89    }
90    
91    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
92         uint256 z = _x + _y;
93         assert(z >= _x);
94         return z;
95     }
96 
97     function safeDiv(uint a, uint b) internal returns (uint) {
98      assert(b > 0);
99      uint c = a / b;
100      assert(a == b * c + a % b);
101      return c;
102     }
103     
104 
105 
106     function name() constant returns (string) { return "The Money Fight"; }
107     function symbol() constant returns (string) { return "MFT"; }
108     function decimals() constant returns (uint8) { return 18; }
109     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
110     
111     function transfer(address _to, uint256 _value) returns (bool success) {
112         // mitigates the ERC20 short address attack
113         if(msg.data.length < (2 * 32) + 4) { throw; }
114 
115         if (_value == 0) { return false; }
116 
117         uint256 fromBalance = balances[msg.sender];
118 
119         bool sufficientFunds = fromBalance >= _value;
120         bool overflowed = balances[_to] + _value < balances[_to];
121         
122         if (sufficientFunds && !overflowed) {
123             balances[msg.sender] -= _value;
124             balances[_to] += _value;
125             
126             Transfer(msg.sender, _to, _value);
127             return true;
128         } else { return false; }
129     }
130     
131     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
132         // mitigates the ERC20 short address attack
133         if(msg.data.length < (3 * 32) + 4) { throw; }
134 
135         if (_value == 0) { return false; }
136         
137         uint256 fromBalance = balances[_from];
138         uint256 allowance = allowed[_from][msg.sender];
139 
140         bool sufficientFunds = fromBalance <= _value;
141         bool sufficientAllowance = allowance <= _value;
142         bool overflowed = balances[_to] + _value > balances[_to];
143 
144         if (sufficientFunds && sufficientAllowance && !overflowed) {
145             balances[_to] += _value;
146             balances[_from] -= _value;
147             
148             allowed[_from][msg.sender] -= _value;
149             
150             Transfer(_from, _to, _value);
151             return true;
152         } else { return false; }
153     }
154     
155     
156     function approve(address _spender, uint256 _value) returns (bool success) {
157         // mitigates the ERC20 spend/approval race condition
158         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
159         
160         allowed[msg.sender][_spender] = _value;
161         
162         Approval(msg.sender, _spender, _value);
163         return true;
164     } 
165     
166     function createGame(string name,uint opts,uint endTime) only_owner { 
167         uint currGame = ++gamesIndex;
168         games[currGame] = Game(betStatus.Running, 0 , 0, endTime);
169         for(uint i = 0 ; i < opts ; i++ ){
170             gameOptions[currGame].push(Option());
171         }
172         gameStarted(name,currGame,opts,endTime);
173     }
174     
175     function predictWinner(uint game, uint option, uint256 _value) {
176         Game curr = games[game];
177         betStatus status = curr.status;
178         uint256 fromBalance = balances[msg.sender];
179         bool sufficientFunds =  fromBalance >= _value;
180         if (_value > 0 && sufficientFunds && canBet(game)) {
181             balances[msg.sender] -= _value;
182             gameOptions[game][option].status[msg.sender]= _value;
183             curr.totalBets[option] += _value;
184             curr.total += _value;
185             betAdded(game,option,msg.sender,_value);
186         }
187     }
188     
189     function redeem(uint game, uint256 option) canRedeem(game) {
190             bool won = results[game].winningOption == option;
191             if(!won){
192                 uint256 val =gameOptions[game][option].status[msg.sender];
193                 if(val > 0 && results[game].locktime < now){
194                     gameOptions[game][option].status[msg.sender] = 0;
195                     balances[msg.sender] += val;
196                     Redeem(game,option,false,msg.sender,val);
197                 }
198             } else {
199                 uint256 total = calculatePrize(msg.sender,game,option);
200                 if(total > 0){
201                     uint256 value = gameOptions[game][option].status[msg.sender];
202                     gameOptions[game][option].status[msg.sender] = 0;
203                     totalSupply += (total - value);
204                     balances[msg.sender] += total;
205                     Redeem(game,option,true,msg.sender,total);
206                 }
207             }
208     }
209     
210     function calculatePrize(address sender, uint game,uint option) internal returns (uint256 val){
211         uint256 value = gameOptions[game][option].status[sender];
212         if(value > 0){
213             uint256 total =safeDiv(safeMul(results[game].betTotal,value),results[game].winningOptionTotal);
214             return total;
215         }
216         return 0;
217     }
218     
219     
220     function finishGame(uint game, uint winOption) only_owner {
221        Game curr = games[game];
222        curr.status = betStatus.Done;  
223        results[game] = Result(winOption, now + LOSER_LOCK_TIME, curr.total, curr.totalBets[winOption]); 
224        gameFinished(game, winOption, curr.total, curr.totalBets[winOption]);
225     }
226     
227     function drain(uint256 bal) only_owner {
228 		if (!owner.send(bal)) throw;
229 	}
230 	
231 	function getTotalPrediction(uint game, uint option) public constant returns (uint256 total,uint256 totalOption){
232 	    Game curr = games[game];
233 	    return (curr.total, curr.totalBets[option]);
234 	}
235 	
236     function getPrediction(uint game, uint o) returns (uint256 bet) {
237         return gameOptions[game][o].status[msg.sender];
238     }
239     
240     function withdrawForeignTokens(address _tokenContract) only_owner returns (bool) {
241         ForeignToken token = ForeignToken(_tokenContract);
242         uint256 amount = token.balanceOf(address(this));
243         return token.transfer(owner, amount);
244     } 
245    
246     function enablePurchasing() only_owner {
247         purchasingAllowed = true;
248     }
249 
250     function disablePurchasing() only_owner{
251         purchasingAllowed = false;
252     }
253     function() payable etherCapNotReached(msg.value) {
254         if (!purchasingAllowed) { throw; }
255         
256         if (msg.value == 0) { return; }
257 
258         owner.transfer(msg.value);
259         totalContribution += msg.value;
260 
261         uint256 tokensIssued = msg.value * 100;
262 
263         totalSupply += tokensIssued;
264         balances[msg.sender] += tokensIssued;
265         
266         Transfer(address(this), msg.sender, tokensIssued);
267     }
268     
269 }