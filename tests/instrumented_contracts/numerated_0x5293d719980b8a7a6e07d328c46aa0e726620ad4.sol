1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function transferOwnership(address newOwner) public onlyOwner {
75         require(newOwner != address(0));
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78     }
79 
80 }
81 
82 /**
83  * @title StandardToken
84  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
85  * @dev Standard ERC20 token
86  */
87 contract StandardToken {
88     using SafeMath for uint256;
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 
93     mapping(address => uint256) internal balances_;
94     mapping(address => mapping(address => uint256)) internal allowed_;
95 
96     uint256 internal totalSupply_;
97     string public name;
98     string public symbol;
99     uint8 public decimals;
100 
101     /**
102     * @dev total number of tokens in existence
103     */
104     function totalSupply() public view returns (uint256) {
105         return totalSupply_;
106     }
107 
108     /**
109     * @dev Gets the balance of the specified address.
110     * @param _owner The address to query the the balance of.
111     * @return An uint256 representing the amount owned by the passed address.
112     */
113     function balanceOf(address _owner) public view returns (uint256) {
114         return balances_[_owner];
115     }
116 
117     /**
118      * @dev Function to check the amount of tokens that an owner allowed_ to a spender.
119      * @param _owner address The address which owns the funds.
120      * @param _spender address The address which will spend the funds.
121      * @return A uint256 specifying the amount of tokens still available for the spender.
122      */
123     function allowance(address _owner, address _spender) public view returns (uint256) {
124         return allowed_[_owner][_spender];
125     }
126 
127     /**
128     * @dev transfer token for a specified address
129     * @param _to The address to transfer to.
130     * @param _value The amount to be transferred.
131     */
132     function transfer(address _to, uint256 _value) public returns (bool) {
133         require(_to != address(0));
134         require(_value <= balances_[msg.sender]);
135 
136         balances_[msg.sender] = balances_[msg.sender].sub(_value);
137         balances_[_to] = balances_[_to].add(_value);
138         emit Transfer(msg.sender, _to, _value);
139         return true;
140     }
141 
142 
143     /**
144      * @dev Transfer tokens from one address to another
145      * @param _from address The address which you want to send tokens from
146      * @param _to address The address which you want to transfer to
147      * @param _value uint256 the amount of tokens to be transferred
148      */
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150         require(_to != address(0));
151         require(_value <= balances_[_from]);
152         require(_value <= allowed_[_from][msg.sender]);
153 
154         balances_[_from] = balances_[_from].sub(_value);
155         balances_[_to] = balances_[_to].add(_value);
156         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
157         emit Transfer(_from, _to, _value);
158         return true;
159     }
160 
161     /**
162      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163      *
164      * Beware that changing an allowance with this method brings the risk that someone may use both the old
165      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      * @param _spender The address which will spend the funds.
169      * @param _value The amount of tokens to be spent.
170      */
171     function approve(address _spender, uint256 _value) public returns (bool) {
172         allowed_[msg.sender][_spender] = _value;
173         emit Approval(msg.sender, _spender, _value);
174         return true;
175     }
176 }
177 
178 /**
179  * @title EthTeamContract
180  * @dev The team token. One token represents a team. EthTeamContract is also a ERC20 standard token.
181  */
182 contract EthTeamContract is StandardToken, Ownable {
183     event Buy(address indexed token, address indexed from, uint256 value, uint256 weiValue);
184     event Sell(address indexed token, address indexed from, uint256 value, uint256 weiValue);
185     event BeginGame(address indexed team1, address indexed team2, uint64 gameTime);
186     event EndGame(address indexed team1, address indexed team2, uint8 gameResult);
187     event ChangeStatus(address indexed team, uint8 status);
188 
189     /**
190     * @dev Token price based on ETH
191     */
192     uint256 public price;
193     /**
194     * @dev status=0 buyable & sellable, user can buy or sell the token.
195     * status=1 not buyable & not sellable, user cannot buy or sell the token.
196     */
197     uint8 public status;
198     /**
199     * @dev The game start time. gameTime=0 means game time is not enabled or not started.
200     */
201     uint64 public gameTime;
202     /**
203     * @dev If the time is older than FinishTime (usually one month after game).
204     * The owner has permission to transfer the balance to the feeOwner.
205     * The user can get back the balance using the website after this time.
206     */
207     uint64 public finishTime;
208     /**
209     * @dev The fee owner. The fee will send to this address.
210     */
211     address public feeOwner;
212     /**
213     * @dev Game opponent, gameOpponent is also a EthTeamContract.
214     */
215     address public gameOpponent;
216 
217     /**
218     * @dev Team name and team symbol will be ERC20 token name and symbol. Token decimals will be 3.
219     * Token total supply will be 0. The initial price will be 1 szabo (1000000000000 Wei)
220     */
221     function EthTeamContract(
222         string _teamName, string _teamSymbol, address _gameOpponent, uint64 _gameTime, uint64 _finishTime, address _feeOwner
223     ) public {
224         name = _teamName;
225         symbol = _teamSymbol;
226         decimals = 3;
227         totalSupply_ = 0;
228         price = 1 szabo;
229         gameOpponent = _gameOpponent;
230         gameTime = _gameTime;
231         finishTime = _finishTime;
232         feeOwner = _feeOwner;
233         owner = msg.sender;
234     }
235 
236     /**
237     * @dev Sell Or Transfer the token.
238     *
239     * Override ERC20 transfer token function. If the _to address is not this EthTeamContract,
240     * then call the super transfer function, which will be ERC20 token transfer.
241     * Otherwise, the user want to sell the token (EthTeamContract -> ETH).
242     * @param _to address The address which you want to transfer/sell to
243     * @param _value uint256 the amount of tokens to be transferred/sold
244     */
245     function transfer(address _to, uint256 _value) public returns (bool) {
246         if (_to != address(this)) {
247             return super.transfer(_to, _value);
248         }
249         // We are only allowed to sell after end of game
250         require(_value <= balances_[msg.sender] && status == 0 && gameTime == 0);
251         balances_[msg.sender] = balances_[msg.sender].sub(_value);
252         totalSupply_ = totalSupply_.sub(_value);
253         uint256 weiAmount = price.mul(_value);
254         msg.sender.transfer(weiAmount);
255         emit Transfer(msg.sender, _to, _value);
256         emit Sell(_to, msg.sender, _value, weiAmount);
257         return true;
258     }
259 
260     /**
261     * @dev Buy token using ETH
262     * User send ETH to this EthTeamContract, then his token balance will be increased based on price.
263     * The total supply will also be increased.
264     */
265     function() payable public {
266         // We are not allowed to buy after game start
267         require(status == 0 && price > 0 && gameTime > block.timestamp);
268         uint256 amount = msg.value.div(price);
269         balances_[msg.sender] = balances_[msg.sender].add(amount);
270         totalSupply_ = totalSupply_.add(amount);
271         emit Transfer(address(this), msg.sender, amount);
272         emit Buy(address(this), msg.sender, amount, msg.value);
273     }
274 
275     /**
276     * @dev The the game status.
277     *
278     * status = 0 buyable & sellable, user can buy or sell the token.
279     * status=1 not buyable & not sellable, user cannot buy or sell the token.
280     * @param _status The game status.
281     */
282     function changeStatus(uint8 _status) onlyOwner public {
283         require(status != _status);
284         status = _status;
285         emit ChangeStatus(address(this), _status);
286     }
287 
288     /**
289     * @dev Change the fee owner.
290     *
291     * @param _feeOwner The new fee owner.
292     */
293     function changeFeeOwner(address _feeOwner) onlyOwner public {
294         require(_feeOwner != feeOwner && _feeOwner != address(0));
295         feeOwner = _feeOwner;
296     }
297 
298     /**
299     * @dev Finish the game
300     *
301     * If the time is older than FinishTime (usually one month after game).
302     * The owner has permission to transfer the balance to the feeOwner.
303     * The user can get back the balance using the website after this time.
304     */
305     function finish() onlyOwner public {
306         require(block.timestamp >= finishTime);
307         feeOwner.transfer(address(this).balance);
308     }
309 
310     /**
311     * @dev Start the game
312     *
313     * Start a new game. Initialize game opponent, game time and status.
314     * @param _gameOpponent The game opponent contract address
315     * @param _gameTime The game begin time. optional
316     */
317     function beginGame(address _gameOpponent, uint64 _gameTime) onlyOwner public {
318         require(_gameOpponent != address(this));
319         // 1514764800 = 2018-01-01
320         require(_gameTime == 0 || (_gameTime > 1514764800));
321         gameOpponent = _gameOpponent;
322         gameTime = _gameTime;
323         status = 0;
324         emit BeginGame(address(this), _gameOpponent, _gameTime);
325     }
326 
327     /**
328     * @dev End the game with game final result.
329     *
330     * The function only allow to be called with the lose team or the draw team with large balance.
331     * We have this rule because the lose team or draw team will large balance need transfer balance to opposite side.
332     * This function will also change status of opposite team by calling transferFundAndEndGame function.
333     * So the function only need to be called one time for the home and away team.
334     * The new price will be recalculated based on the new balance and total supply.
335     *
336     * Balance transfer rule:
337     * 1. The rose team will transfer all balance to opposite side.
338     * 2. If the game is draw, the balances of two team will go fifty-fifty.
339     * 3. If game is canceled, the balance is not touched and the game states will be reset to initial states.
340     * 4. The fee will be 5% of each transfer amount.
341     * @param _gameOpponent The game opponent contract address
342     * @param _gameResult game result. 1=lose, 2=draw, 3=cancel, 4=win (not allow)
343     */
344     function endGame(address _gameOpponent, uint8 _gameResult) onlyOwner public {
345         require(gameOpponent != address(0) && gameOpponent == _gameOpponent);
346         uint256 amount = address(this).balance;
347         uint256 opAmount = gameOpponent.balance;
348         require(_gameResult == 1 || (_gameResult == 2 && amount >= opAmount) || _gameResult == 3);
349         EthTeamContract op = EthTeamContract(gameOpponent);
350         if (_gameResult == 1) {
351             // Lose
352             if (amount > 0 && totalSupply_ > 0) {
353                 uint256 lostAmount = amount;
354                 // If opponent has supply
355                 if (op.totalSupply() > 0) {
356                     // fee is 5%
357                     uint256 feeAmount = lostAmount.div(20);
358                     lostAmount = lostAmount.sub(feeAmount);
359                     feeOwner.transfer(feeAmount);
360                     op.transferFundAndEndGame.value(lostAmount)();
361                 } else {
362                     // If opponent has not supply, then send the lose money to fee owner.
363                     feeOwner.transfer(lostAmount);
364                     op.transferFundAndEndGame();
365                 }
366             } else {
367                 op.transferFundAndEndGame();
368             }
369         } else if (_gameResult == 2) {
370             // Draw
371             if (amount > opAmount) {
372                 lostAmount = amount.sub(opAmount).div(2);
373                 if (op.totalSupply() > 0) {
374                     // fee is 5%
375                     feeAmount = lostAmount.div(20);
376                     lostAmount = lostAmount.sub(feeAmount);
377                     feeOwner.transfer(feeAmount);
378                     op.transferFundAndEndGame.value(lostAmount)();
379                 } else {
380                     feeOwner.transfer(lostAmount);
381                     op.transferFundAndEndGame();
382                 }
383             } else if (amount == opAmount) {
384                 op.transferFundAndEndGame();
385             } else {
386                 // should not happen
387                 revert();
388             }
389         } else if (_gameResult == 3) {
390             //canceled
391             op.transferFundAndEndGame();
392         } else {
393             // should not happen
394             revert();
395         }
396         endGameInternal();
397         if (totalSupply_ > 0) {
398             price = address(this).balance.div(totalSupply_);
399         }
400         emit EndGame(address(this), _gameOpponent, _gameResult);
401     }
402 
403     /**
404     * @dev Reset team token states
405     *
406     */
407     function endGameInternal() private {
408         gameOpponent = address(0);
409         gameTime = 0;
410         status = 0;
411     }
412 
413     /**
414     * @dev Reset team states and recalculate the price.
415     *
416     * This function will be called by opponent team token after end game.
417     * It accepts the ETH transfer and recalculate the new price based on
418     * new balance and total supply.
419     */
420     function transferFundAndEndGame() payable public {
421         require(gameOpponent != address(0) && gameOpponent == msg.sender);
422         if (msg.value > 0 && totalSupply_ > 0) {
423             price = address(this).balance.div(totalSupply_);
424         }
425         endGameInternal();
426     }
427 }