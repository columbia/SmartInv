1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55     address public owner;
56 
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     /**
69      * @dev Allows the current owner to transfer control of the contract to a newOwner.
70      * @param newOwner The address to transfer ownership to.
71      */
72     function transferOwnership(address newOwner) public onlyOwner {
73         require(newOwner != address(0));
74         emit OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76     }
77 
78 }
79 
80 /**
81  * @title StandardToken
82  @ @dev Standard ERC20 token
83  */
84 contract StandardToken {
85     using SafeMath for uint256;
86 
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 
90     mapping(address => uint256) internal balances_;
91     mapping(address => mapping(address => uint256)) internal allowed_;
92 
93     uint256 internal totalSupply_;
94     string public name;
95     string public symbol;
96     uint8 public decimals;
97 
98     /**
99     * @dev total number of tokens in existence
100     */
101     function totalSupply() public view returns (uint256) {
102         return totalSupply_;
103     }
104 
105     /**
106     * @dev Gets the balance of the specified address.
107     * @param _owner The address to query the the balance of.
108     * @return An uint256 representing the amount owned by the passed address.
109     */
110     function balanceOf(address _owner) public view returns (uint256) {
111         return balances_[_owner];
112     }
113 
114     /**
115      * @dev Function to check the amount of tokens that an owner allowed_ to a spender.
116      * @param _owner address The address which owns the funds.
117      * @param _spender address The address which will spend the funds.
118      * @return A uint256 specifying the amount of tokens still available for the spender.
119      */
120     function allowance(address _owner, address _spender) public view returns (uint256) {
121         return allowed_[_owner][_spender];
122     }
123 
124     /**
125     * @dev transfer token for a specified address
126     * @param _to The address to transfer to.
127     * @param _value The amount to be transferred.
128     */
129     function transfer(address _to, uint256 _value) public returns (bool) {
130         require(_to != address(0));
131         require(_value <= balances_[msg.sender]);
132 
133         balances_[msg.sender] = balances_[msg.sender].sub(_value);
134         balances_[_to] = balances_[_to].add(_value);
135         emit Transfer(msg.sender, _to, _value);
136         return true;
137     }
138 
139 
140     /**
141      * @dev Transfer tokens from one address to another
142      * @param _from address The address which you want to send tokens from
143      * @param _to address The address which you want to transfer to
144      * @param _value uint256 the amount of tokens to be transferred
145      */
146     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147         require(_to != address(0));
148         require(_value <= balances_[_from]);
149         require(_value <= allowed_[_from][msg.sender]);
150 
151         balances_[_from] = balances_[_from].sub(_value);
152         balances_[_to] = balances_[_to].add(_value);
153         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
154         emit Transfer(_from, _to, _value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      *
161      * Beware that changing an allowance with this method brings the risk that someone may use both the old
162      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      * @param _spender The address which will spend the funds.
166      * @param _value The amount of tokens to be spent.
167      */
168     function approve(address _spender, uint256 _value) public returns (bool) {
169         allowed_[msg.sender][_spender] = _value;
170         emit Approval(msg.sender, _spender, _value);
171         return true;
172     }
173 }
174 
175 /**
176  * @title TeamToken
177  @ @dev The team token. One token represents a team. TeamToken is also a ERC20 standard token.
178  */
179 contract TeamToken is StandardToken, Ownable {
180     event Buy(address indexed token, address indexed from, uint256 value, uint256 weiValue);
181     event Sell(address indexed token, address indexed from, uint256 value, uint256 weiValue);
182     event BeginGame(address indexed team1, address indexed team2, uint64 gameTime);
183     event EndGame(address indexed team1, address indexed team2, uint8 gameResult);
184     event ChangeStatus(address indexed team, uint8 status);
185 
186     /**
187     * @dev Token price based on ETH
188     */
189     uint256 public price;
190     /**
191     * @dev status=0 buyable & sellable, user can buy or sell the token.
192     * status=1 not buyable & not sellable, user cannot buy or sell the token.
193     */
194     uint8 public status;
195     /**
196     * @dev The game start time. gameTime=0 means game time is not enabled or not started.
197     */
198     uint64 public gameTime;
199     /**
200     * @dev The fee owner. The fee will send to this address.
201     */
202     address public feeOwner;
203     /**
204     * @dev Game opponent, gameOpponent is also a TeamToken.
205     */
206     address public gameOpponent;
207 
208     /**
209     * @dev Team name and team symbol will be ERC20 token name and symbol. Token decimals will be 3.
210     * Token total supply will be 0. The initial price will be 1 szabo (1000000000000 Wei)
211     */
212     function TeamToken(string _teamName, string _teamSymbol, address _feeOwner) public {
213         name = _teamName;
214         symbol = _teamSymbol;
215         decimals = 3;
216         totalSupply_ = 0;
217         price = 1 szabo;
218         feeOwner = _feeOwner;
219         owner = msg.sender;
220     }
221 
222     /**
223     * @dev Sell Or Transfer the token.
224     *
225     * Override ERC20 transfer token function. If the _to address is not this TeamToken,
226     * then call the super transfer function, which will be ERC20 token transfer.
227     * Otherwise, the user want to sell the token (TeamToken -> ETH).
228     * @param _to address The address which you want to transfer/sell to
229     * @param _value uint256 the amount of tokens to be transferred/sold
230     */
231     function transfer(address _to, uint256 _value) public returns (bool) {
232         if (_to != address(this)) {
233             return super.transfer(_to, _value);
234         }
235         require(_value <= balances_[msg.sender] && status == 0);
236         // If gameTime is enabled (larger than 1514764800 (2018-01-01))
237         if (gameTime > 1514764800) {
238             // We will not allowed to sell after 5 minutes (300 seconds) before game start
239             require(gameTime - 300 > block.timestamp);
240         }
241         balances_[msg.sender] = balances_[msg.sender].sub(_value);
242         totalSupply_ = totalSupply_.sub(_value);
243         uint256 weiAmount = price.mul(_value);
244         msg.sender.transfer(weiAmount);
245         emit Transfer(msg.sender, _to, _value);
246         emit Sell(_to, msg.sender, _value, weiAmount);
247         return true;
248     }
249 
250     /**
251     * @dev Buy token using ETH
252     * User send ETH to this TeamToken, then his token balance will be increased based on price.
253     * The total supply will also be increased.
254     */
255     function() payable public {
256         require(status == 0 && price > 0);
257         // If gameTime is enabled (larger than 1514764800 (2018-01-01))
258         if (gameTime > 1514764800) {
259             // We will not allowed to sell after 5 minutes (300 seconds) before game start
260             require(gameTime - 300 > block.timestamp);
261         }
262         uint256 amount = msg.value.div(price);
263         balances_[msg.sender] = balances_[msg.sender].add(amount);
264         totalSupply_ = totalSupply_.add(amount);
265         emit Transfer(address(this), msg.sender, amount);
266         emit Buy(address(this), msg.sender, amount, msg.value);
267     }
268 
269     /**
270     * @dev The the game status.
271     *
272     * status = 0 buyable & sellable, user can buy or sell the token.
273     * status=1 not buyable & not sellable, user cannot buy or sell the token.
274     * @param _status The game status.
275     */
276     function changeStatus(uint8 _status) onlyOwner public {
277         require(status != _status);
278         status = _status;
279         emit ChangeStatus(address(this), _status);
280     }
281 
282     /**
283     * @dev Finish the game
284     *
285     * If the time is older than one month after 2017-18 UEFA Champions league (2018-05-26 19:45:00 UTC)
286     * The owner has permission to transfer the balance to the feeOwner.
287     * The user can get back the balance using the website after this time.
288     */
289     function finish() onlyOwner public {
290         // 2018-06-25 18:45:00 UTC
291         require(block.timestamp >= 1529952300);
292         feeOwner.transfer(address(this).balance);
293     }
294 
295     /**
296     * @dev Start the game
297     *
298     * Start a new game. Initialize game opponent, game time and status.
299     * @param _gameOpponent The game opponent contract address
300     * @param _gameTime The game begin time. optional
301     */
302     function beginGame(address _gameOpponent, uint64 _gameTime) onlyOwner public {
303         require(_gameOpponent != address(0) && _gameOpponent != address(this) && gameOpponent == address(0));
304         // 1514764800 = 2018-01-01
305         // 1546300800 = 2019-01-01
306         require(_gameTime == 0 || (_gameTime > 1514764800 && _gameTime < 1546300800));
307         gameOpponent = _gameOpponent;
308         gameTime = _gameTime;
309         status = 0;
310         emit BeginGame(address(this), _gameOpponent, _gameTime);
311     }
312 
313     /**
314     * @dev End the game with game final result.
315     *
316     * The function only allow to be called with the lose team or the draw team with large balance.
317     * We have this rule because the lose team or draw team will large balance need transfer balance to opposite side.
318     * This function will also change status of opposite team by calling transferFundAndEndGame function.
319     * So the function only need to be called one time for the home and away team.
320     * The new price will be recalculated based on the new balance and total supply.
321     *
322     * Balance transfer rule:
323     * 1. The rose team will transfer all balance to opposite side.
324     * 2. If the game is draw, the balances of two team will go fifty-fifty.
325     * 3. If game is canceled, the balance is not touched and the game states will be reset to initial states.
326     * 4. The fee will be 5% of each transfer amount.
327     * @param _gameOpponent The game opponent contract address
328     * @param _gameResult game result. 1=lose, 2=draw, 3=cancel, 4=win (not allow)
329     */
330     function endGame(address _gameOpponent, uint8 _gameResult) onlyOwner public {
331         require(gameOpponent != address(0) && gameOpponent == _gameOpponent);
332         uint256 amount = address(this).balance;
333         uint256 opAmount = gameOpponent.balance;
334         require(_gameResult == 1 || (_gameResult == 2 && amount >= opAmount) || _gameResult == 3);
335         TeamToken op = TeamToken(gameOpponent);
336         if (_gameResult == 1) {
337             // Lose
338             if (amount > 0 && totalSupply_ > 0) {
339                 uint256 lostAmount = amount;
340                 // If opponent has supply
341                 if (op.totalSupply() > 0) {
342                     // fee is 5%
343                     uint256 feeAmount = lostAmount.div(20);
344                     lostAmount = lostAmount.sub(feeAmount);
345                     feeOwner.transfer(feeAmount);
346                     op.transferFundAndEndGame.value(lostAmount)();
347                 } else {
348                     // If opponent has not supply, then send the lose money to fee owner.
349                     feeOwner.transfer(lostAmount);
350                     op.transferFundAndEndGame();
351                 }
352             } else {
353                 op.transferFundAndEndGame();
354             }
355         } else if (_gameResult == 2) {
356             // Draw
357             if (amount > opAmount) {
358                 lostAmount = amount.sub(opAmount).div(2);
359                 if (op.totalSupply() > 0) {
360                     // fee is 5%
361                     feeAmount = lostAmount.div(20);
362                     lostAmount = lostAmount.sub(feeAmount);
363                     op = TeamToken(gameOpponent);
364                     feeOwner.transfer(feeAmount);
365                     op.transferFundAndEndGame.value(lostAmount)();
366                 } else {
367                     feeOwner.transfer(lostAmount);
368                     op.transferFundAndEndGame();
369                 }
370             } else if (amount == opAmount) {
371                 op.transferFundAndEndGame();
372             } else {
373                 // should not happen
374                 revert();
375             }
376         } else if (_gameResult == 3) {
377             //canceled
378             op.transferFundAndEndGame();
379         } else {
380             // should not happen
381             revert();
382         }
383         endGameInternal();
384         if (totalSupply_ > 0) {
385             price = address(this).balance.div(totalSupply_);
386         }
387         emit EndGame(address(this), _gameOpponent, _gameResult);
388     }
389 
390     /**
391     * @dev Reset team token states
392     *
393     */
394     function endGameInternal() private {
395         gameOpponent = address(0);
396         gameTime = 0;
397         status = 0;
398     }
399 
400     /**
401     * @dev Reset team states and recalculate the price.
402     *
403     * This function will be called by opponent team token after end game.
404     * It accepts the ETH transfer and recalculate the new price based on
405     * new balance and total supply.
406     */
407     function transferFundAndEndGame() payable public {
408         require(gameOpponent != address(0) && gameOpponent == msg.sender);
409         if (msg.value > 0 && totalSupply_ > 0) {
410             price = address(this).balance.div(totalSupply_);
411         }
412         endGameInternal();
413     }
414 }