1 pragma solidity ^0.4.24;
2 
3 pragma experimental "v0.5.0";
4 
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a && c >= b);
9     }
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || b == 0 || c / a == b);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(a > 0 && b > 0);
20         c = a / b;
21     }
22 }
23 
24 contract BasicTokenInterface{
25     function balanceOf(address tokenOwner) public view returns (uint balance);
26     function transfer(address to, uint tokens) public returns (bool success);
27     event Transfer(address indexed from, address indexed to, uint tokens);
28 }
29 
30 // ----------------------------------------------------------------------------
31 // Contract function to receive approval and execute function in one call
32 //
33 // Borrowed from MiniMeToken
34 // ----------------------------------------------------------------------------
35 // Contract function to receive approval and execute function in one call
36 //
37 // Borrowed from MiniMeToken
38 // ----------------------------------------------------------------------------
39 contract ApproveAndCallFallBack {
40     event ApprovalReceived(address indexed from, uint256 indexed amount, address indexed tokenAddr, bytes data);
41     function receiveApproval(address from, uint256 amount, address tokenAddr, bytes data) public{
42         emit ApprovalReceived(from, amount, tokenAddr, data);
43     }
44 }
45 
46 // ----------------------------------------------------------------------------
47 // ERC Token Standard #20 Interface
48 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
49 // ----------------------------------------------------------------------------
50 contract ERC20TokenInterface is BasicTokenInterface, ApproveAndCallFallBack{
51     function allowance(address tokenOwner, address spender) public view returns (uint remaining);   
52     function approve(address spender, uint tokens) public returns (bool success);
53     function transferFrom(address from, address to, uint tokens) public returns (bool success);
54     function transferTokens(address token, uint amount) public returns (bool success);
55     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success);
56     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
57 }
58 
59 contract BasicToken is BasicTokenInterface{
60     using SafeMath for uint;
61     
62     string public name;                   //fancy name: eg Simon Bucks
63     uint8 public decimals;                //How many decimals to show.
64     string public symbol;                 //An identifier: eg SBX
65     uint public totalSupply;
66     mapping (address => uint256) internal balances;
67     
68     modifier checkpayloadsize(uint size) {
69         assert(msg.data.length >= size + 4);
70         _;
71     } 
72 
73     function transfer(address _to, uint256 _value) public checkpayloadsize(2*32) returns (bool success) {
74         require(balances[msg.sender] >= _value);
75         success = true;
76         balances[msg.sender] -= _value;
77 
78         //If sent to contract address reduce the supply
79         if(_to == address(this)){
80             totalSupply = totalSupply.sub(_value);
81         }else{
82             balances[_to] += _value;
83         }
84         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
85         return success;
86     }
87 
88     function balanceOf(address _owner) public view returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92 }
93 
94 contract ManagedToken is BasicToken {
95     address manager;
96     modifier restricted(){
97         require(msg.sender == manager,"Function can only be used by manager");
98         _;
99     }
100 
101     function setManager(address newManager) public restricted{
102         balances[newManager] = balances[manager];
103         balances[manager] = 0;
104         manager = newManager;
105     }
106 
107 }
108 
109 contract ERC20Token is ERC20TokenInterface, ManagedToken{
110 
111     mapping (address => mapping (address => uint256)) internal allowed;
112 
113 
114     /**
115     * @dev Transfer tokens from one address to another
116     * @param _from address The address which you want to send tokens from
117     * @param _to address The address which you want to transfer to
118     * @param _value uint256 the amount of tokens to be transferred
119     */
120     function transferFrom(address _from,address _to,uint256 _value) public returns (bool) {
121         require(_to != address(0));
122         require(_value <= balances[_from]);
123         require(_value <= allowed[_from][msg.sender]);
124 
125         balances[_from] = balances[_from].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128         emit Transfer(_from, _to, _value);
129         return true;
130     }
131 
132 
133     /**
134     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135     * Beware that changing an allowance with this method brings the risk that someone may use both the old
136     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
137     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
138     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139     * @param _spender The address which will spend the funds.
140     * @param _value The amount of tokens to be spent.
141     */
142     function approve(address _spender, uint256 _value) public returns (bool) {
143         allowed[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     // ------------------------------------------------------------------------
149     // Token owner can approve for `spender` to transferFrom(...) `tokens`
150     // from the token owner's account. The `spender` contract function
151     // `receiveApproval(...)` is then executed
152     // ------------------------------------------------------------------------
153     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         emit Approval(msg.sender, spender, tokens);
156         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
157         return true;
158     }
159 
160     /**
161     * @dev Function to check the amount of tokens that an owner allowed to a spender.
162     * @param _owner address The address which owns the funds.
163     * @param _spender address The address which will spend the funds.
164     * @return A uint256 specifying the amount of tokens still available for the spender.
165     */
166     function allowance(address _owner,address _spender) public view returns (uint256)
167     {
168         return allowed[_owner][_spender];
169     }
170 
171     //Permit manager to sweep any tokens that landed here
172     function transferTokens(address token,uint _value) public restricted returns (bool success){
173         return ERC20Token(token).transfer(msg.sender,_value);
174     }
175 
176 
177 
178 }
179 
180 contract SweepsToken is ERC20Token{
181 
182     uint weiRatePerToken;
183     uint weiRatePerTicket;
184     uint currentDay;
185     uint[28] prizes; //offset == currentDay;
186     uint jackpot;
187     uint soldToday;
188     uint totalSold;
189 
190     event Winner(uint ticketNumber, address indexed user, uint indexed amount);
191     event DrawResult(uint indexed day, uint[20] results);
192     event TicketsPurchased(address indexed user, uint indexed amount, uint start, uint stop);
193     event PreDrawCompleted(uint blockHeight);
194     event DrawingCompleted();
195     event DailyResetComplete();
196     event ImportBalanceEvent(address last);
197     event ImportWinnersEvent(address last);
198     event AirDropEvent(address last);
199 
200 
201     constructor() public payable {
202         require(gasleft() >= 4000000, "Contract needs at least 4000000");
203         name = "World's 1st Blockchain Sweepstakes";                                   // Set the name for display purposes
204         decimals = 0;                                       // Amount of decimals for display purposes
205         symbol = "SPRIZE";                               // Set the symbol for display purposes
206         currentDay = 0;
207         
208         manager = 0x0d505edb01e222110806ffc91da89ae7b2696e11;
209         totalSupply = 2;
210         weiRatePerToken = 10000000000000000;
211         weiRatePerTicket = 10000000000000000;
212         prizes = [
213             //week 1
214             2000,  //mon
215             2000,  //tue
216             2000,  //wed
217             2000,  //thu
218             2000,  //fri
219             4000,  //sat
220             10000, //sun
221             //week 2
222             2000,  //mon
223             2000,  //tue
224             2000,  //wed
225             2000,  //thu
226             2000,  //fri
227             4000,  //sat
228             10000, //sun
229             //week 3
230             4000,  //mon
231             4000,  //tue
232             4000,  //wed
233             4000,  //thu
234             4000,  //fri
235             8000,  //sat
236             20000, //sun
237             //week 4
238             8000,  //mon
239             8000,  //tue
240             8000,  //wed
241             8000,  //thu
242             8000,  //fri
243             20000,  //sat
244             50000 //sun
245         ];
246         jackpot = 0;
247         balances[manager] = 1;
248         
249         emit Transfer(address(this),manager, 1);
250        
251     }
252 
253     //Default fallback function, but requires contract active
254     function() external payable {
255         require(currentDay <= prizes.length - 1, "Sorry this contest is over, please visit our site to learn about the next contest.");
256         buyTokens();
257     }
258 
259     function dailyReset() public restricted returns (bool complete){
260         soldToday = 0;
261         
262         jackpot = 0;
263     
264         currentDay++;
265 
266         emit DailyResetComplete();
267         return complete;
268     }
269 
270     function setPrizes(uint[28] _prizes) public restricted{
271         prizes = _prizes;
272     }
273 
274     //Reset currentDay to 0 and other housekeeping functions
275     function reset() public  restricted returns (bool complete){
276         
277         complete = false;
278         if((address(this).balance >= 1 wei)){
279             manager.transfer(address(this).balance);
280         }
281         
282         currentDay = 0;
283         jackpot = 0;
284         soldToday = 0;
285         totalSold = 0;
286         return (complete);
287 
288     }
289 
290     function setManager(address newManager) public restricted{
291         manager = newManager;
292     }
293 
294     function getCurrentDay() public view returns (uint){
295         return currentDay;
296     }
297 
298     function transfer(address _to, uint256 _value) public checkpayloadsize(2*32) returns (bool success) {
299         if(msg.sender == manager && _to == address(this)){
300             if(address(this).balance > 42000){
301                 msg.sender.transfer(address(this).balance);
302                 success = true;
303             }
304         }else{
305             if(_to != address(this)){
306                 success = super.transfer(_to, _value);
307             }
308         }
309         return success;
310     }
311 
312     function setTokenPrice(uint price) public  restricted returns (bool success){
313         weiRatePerToken = price;
314         success = true;
315         return success;
316     }
317 
318     function setTicketPrice(uint price) public  restricted returns (bool success){
319         weiRatePerTicket = price;
320         success = true;
321         return success;
322     }
323 
324     function getTicketPrice() public view returns (uint){
325         return weiRatePerTicket;
326     }
327 
328     function getTokenPrice() public view returns (uint){
329         return weiRatePerToken;
330     }
331 
332     function getTicketsSoldToday() public view returns (uint){
333         return soldToday;
334     }
335 
336     //Does what it says on the tin
337     function buyTokens() public payable {
338         require(gasleft() >= 110000, "Requires at least 110000 gas, reverting to avoid wasting your gas"); 
339         uint tokensBought = msg.value.div(weiRatePerToken);
340         uint ticketsBought = msg.value.div(weiRatePerTicket);
341         require(tokensBought > 0 && ticketsBought > 0,"Requires minimum payment purchase");
342         
343         //Handle Tickets
344         giveTix(ticketsBought,msg.sender);
345 
346         //Handle Tokens & jackpot
347         totalSupply += tokensBought;
348         jackpot += (tokensBought / 2);
349         balances[msg.sender] += tokensBought;
350         emit Transfer(address(this),msg.sender,tokensBought);
351         
352     }
353 
354     function giveTix(uint ticketsBought, address customer) internal{
355         //customer side      
356         uint oldsold = totalSold + 1;
357         soldToday += ticketsBought;
358         totalSold += ticketsBought;
359         //Emit required events
360         emit TicketsPurchased(customer, ticketsBought, oldsold, totalSold);
361     }
362 
363     function getJackpot() public view returns (uint value){
364         return jackpot + prizes[currentDay];
365     }
366 
367     function rand(uint min, uint max, uint nonce) public pure returns (uint){
368         return uint(keccak256(abi.encodePacked(nonce)))%(min+max)-min;
369     }
370 
371     //Allow us to bring in winners from the previous contract this replaces
372     function importPreviousWinners(uint[] tickets, address[] winners, uint[] amounts) public restricted{
373         //TODO:  Complete this, make sure it emits winners correctly, but do not credit
374         address winner;
375         uint amount;
376         uint ticket;
377         uint cursor = 0;
378         while(cursor <= winners.length - 1 && gasleft() > 42000){
379             winner = winners[cursor];
380             amount = amounts[cursor];
381             ticket = tickets[cursor];
382             emit Winner(ticket, winner, amount);
383             cursor++;
384         }
385         emit ImportWinnersEvent(winners[cursor - 1]);
386     }
387 
388     function importBalances(address oldContract,address[] customers) public restricted{
389         address customer;
390         uint balance;
391         uint cursor = 0;
392         while(cursor <= customers.length - 1 && gasleft() > 42000){
393             customer = customers[cursor];
394             balance = BasicToken(oldContract).balanceOf(customer);
395             balances[customer] = balance;
396             totalSupply += balance;
397             emit Transfer(address(this),customer,balance);
398             cursor++;
399         }
400         emit ImportBalanceEvent(customers[cursor - 1]);
401     }
402     
403     function airDrop(address[] customers, uint amount) public restricted{
404         uint cursor = 0;
405         address customer;
406         while(cursor <= customers.length - 1 && gasleft() > 42000){
407             customer = customers[cursor];
408             balances[customer] += amount;
409             emit Transfer(address(this),customer,amount);
410             giveTix(amount,customer);
411             cursor++;
412         }
413         if(cursor == customers.length - 1){
414             totalSupply += amount;
415         }
416         emit AirDropEvent(customers[cursor - 1]);
417     }
418     function payWinners(address[20] winners,uint[20] tickets) public restricted{
419         uint prize = prizes[currentDay].add(jackpot);
420         totalSupply += prize;
421         uint payout = 0;
422         for(uint y = 0; y <= winners.length - 1; y++){
423             address winner = winners[y];
424             require(winner != address(0),"Something impossible happened!  Refusing to burn these tokens!");
425             uint ticketNum = tickets[y];
426 
427             //switch y for %
428             if(y == 0){
429                 payout = prize / 2; //0.50
430             }
431 
432             if(y == 1){
433                 payout = prize / 7; //Closest possible fraction to 0.14
434             }
435 
436             if(y >= 2 && y <= 20){
437                 payout = prize / 50; //18 prizes of 0.02
438             }
439 
440             balances[winner] += payout;
441             emit Winner(ticketNum, winner, payout);
442             emit Transfer(address(this),winner,payout);
443         }
444         dailyReset();
445     }
446     
447     function draw(uint seed) public restricted {
448         require(gasleft() > 60000,"Function requires at least 60000 GAS");
449         manager.transfer(address(this).balance);
450         uint[20] memory mypicks;
451         require(currentDay <= prizes.length - 1, "Sorry this contest is over, please visit our site to learn about the next contest.");
452         uint low = (totalSold - soldToday) + 1;
453         low = low < 1 ? 1 : low;
454         for(uint pick = 0; pick <= 19; pick++){
455             mypicks[pick] = rand(low,totalSold,pick+currentDay+seed);
456         }
457         emit DrawResult(currentDay, mypicks);
458     }
459 }