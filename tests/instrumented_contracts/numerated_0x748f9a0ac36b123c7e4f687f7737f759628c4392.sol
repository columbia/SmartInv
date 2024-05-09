1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20 {
10     uint256 public totalSupply;
11     function balanceOf(address who) public constant returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     function allowance(address owner, address spender) public constant returns (uint256);
14     function transferFrom(address from, address to, uint256 value) public returns (bool);
15     function approve(address spender, uint256 value) public returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a * b;
28         assert(a == 0 || c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal constant returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal constant returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     mapping(address => bool)  internal owners;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     function Ownable() {
67         owners[msg.sender] = true;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owners[msg.sender] == true);
75         _;
76     }
77 
78     function addOwner(address newAllowed) onlyOwner public {
79         owners[newAllowed] = true;
80     }
81 
82     function removeOwner(address toRemove) onlyOwner public {
83         owners[toRemove] = false;
84     }
85 
86 }
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BigToken is ERC20, Ownable {
93     using SafeMath for uint256;
94 
95     string public name = "Big Token";
96     string public symbol = "BIG";
97     uint256 public decimals = 18;
98     uint256 public mintPerBlock = 333333333333333;
99 
100     struct BigTransaction {
101         uint blockNumber;
102         uint256 amount;
103     }
104 
105     uint public commissionPercent = 10;
106     uint256 public totalTransactions = 0;
107     bool public enabledMint = true;
108     uint256 public totalMembers;
109 
110     mapping(address => mapping (address => uint256)) internal allowed;
111     mapping(uint256 => BigTransaction) public transactions;
112     mapping(address => uint256) public balances;
113     mapping(address => uint) public lastMint;
114     mapping(address => bool) invested;
115     mapping(address => bool) public confirmed;
116     mapping(address => bool) public members;
117 
118     event Mint(address indexed to, uint256 amount);
119     event Commission(uint256 amount);
120 
121     /**
122      * @dev transfer token for a specified address
123      * @param _to The address to transfer to.
124      * @param _value The amount to be transferred.
125      */
126     function transfer(address _to, uint256 _value) public returns (bool)  {
127         require(_to != address(0));
128 
129         uint256 currentBalance = balances[msg.sender];
130         uint256 balanceToMint = getBalanceToMint(msg.sender);
131         uint256 commission = _value * commissionPercent / 100;
132         require((_value + commission) <= (currentBalance + balanceToMint));
133 
134         if(balanceToMint > 0){
135             currentBalance = currentBalance.add(balanceToMint);
136             Mint(msg.sender, balanceToMint);
137             lastMint[msg.sender] = block.number;
138             totalSupply = totalSupply.add(balanceToMint);
139         }
140         
141         
142 
143         if(block.number == transactions[totalTransactions - 1].blockNumber) {
144             transactions[totalTransactions - 1].amount = transactions[totalTransactions - 1].amount + (commission / totalMembers);
145         } else {
146             uint transactionID = totalTransactions++;
147             transactions[transactionID] = BigTransaction(block.number, commission / totalMembers);
148         }
149         
150         balances[msg.sender] = currentBalance.sub(_value + commission);
151         balances[_to] = balances[_to].add(_value);
152         Transfer(msg.sender, _to, _value);
153         return true;
154     }
155 
156     /**
157      * @dev Transfer tokens from one address to another
158      * @param _from address The address which you want to send tokens from
159      * @param _to address The address which you want to transfer to
160      * @param _value uint256 the amount of tokens to be transferred
161      */
162     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163         require(_to != address(0));
164         require(_value <= allowed[_from][msg.sender]);
165 
166         uint256 currentBalance = balances[_from];
167         uint256 balanceToMint = getBalanceToMint(_from);
168         uint256 commission = _value * commissionPercent / 100;
169         require((_value + commission) <= (currentBalance + balanceToMint));
170 
171         if(balanceToMint > 0){
172             currentBalance = currentBalance.add(balanceToMint);
173             Mint(_from, balanceToMint);
174             lastMint[_from] = block.number;
175             totalSupply = totalSupply.add(balanceToMint);
176         }
177         
178         
179         if(block.number == transactions[totalTransactions - 1].blockNumber) {
180             transactions[totalTransactions - 1].amount = transactions[totalTransactions - 1].amount + (commission / totalMembers);
181         } else {
182             uint transactionID = totalTransactions++;
183             transactions[transactionID] = BigTransaction(block.number, commission / totalMembers);
184         }
185 
186         balances[_from] = currentBalance.sub(_value + commission);
187         balances[_to] = balances[_to].add(_value);
188         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189         Transfer(_from, _to, _value);
190         return true;
191     }
192 
193 
194     /**
195      * @dev Gets the balance of the specified address.
196      * @param _owner The address to query the the balance of.
197      * @return An uint256 representing the amount owned by the passed address.
198      */
199     function balanceOf(address _owner) public constant returns (uint256 balance) {
200         if(lastMint[_owner] != 0){
201             return balances[_owner] + getBalanceToMint(_owner);
202         } else {
203             return balances[_owner];
204         }
205     }
206 
207     /**
208      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209      *
210      * Beware that changing an allowance with this method brings the risk that someone may use both the old
211      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214      * @param _spender The address which will spend the funds.
215      * @param _value The amount of tokens to be spent.
216      */
217     function approve(address _spender, uint256 _value) public returns (bool) {
218         allowed[msg.sender][_spender] = _value;
219         Approval(msg.sender, _spender, _value);
220         return true;
221     }
222 
223     /**
224      * @dev Function to check the amount of tokens that an owner allowed to a spender.
225      * @param _owner address The address which owns the funds.
226      * @param _spender address The address which will spend the funds.
227      * @return A uint256 specifying the amount of tokens still available for the spender.
228      */
229     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
230         return allowed[_owner][_spender];
231     }
232 
233     /**
234      * approve should be called when allowed[_spender] == 0. To increment
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * From MonolithDAO Token.sol
238      */
239     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
240         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
241         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
246         uint oldValue = allowed[msg.sender][_spender];
247         if (_subtractedValue > oldValue) {
248             allowed[msg.sender][_spender] = 0;
249         } else {
250             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251         }
252         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253         return true;
254     }
255 
256     function refreshBalance(address _address) public returns (uint256){
257         if(!members[_address]) return;
258         
259         uint256 balanceToMint = getBalanceToMint(_address);
260         totalSupply = totalSupply.add(balanceToMint);
261         balances[_address] = balances[_address] + balanceToMint;
262         lastMint[_address] = block.number;
263     }
264 
265     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
266         totalSupply = totalSupply.add(_amount);
267         balances[_to] = balances[_to].add(_amount);
268         Mint(_to, _amount);
269         Transfer(0x0, _to, _amount);
270         return true;
271     }
272 
273     function getBalanceToMint(address _address) public constant returns (uint256){
274         if(!enabledMint) return 0;
275         if(!members[_address]) return 0;
276         if(lastMint[_address] == 0) return 0;
277 
278         uint256 balanceToMint = (block.number - lastMint[_address]) * mintPerBlock;
279         
280         for(uint i = totalTransactions - 1; i >= 0; i--){
281             if(block.number == transactions[i].blockNumber) continue;
282             if(transactions[i].blockNumber < lastMint[_address]) return balanceToMint;
283             if(transactions[i].amount > mintPerBlock) {
284                 balanceToMint = balanceToMint.add(transactions[i].amount - mintPerBlock);
285             }
286         }
287 
288         return balanceToMint;
289     }
290 
291     function stopMint() public onlyOwner{
292         enabledMint = false;
293     }
294 
295     function startMint() public onlyOwner{
296         enabledMint = true;
297     }
298 
299     function confirm(address _address) onlyOwner public {
300         confirmed[_address] = true;
301         if(!members[_address] && invested[_address]){
302             members[_address] = true;
303             totalMembers = totalMembers.add(1);
304             setLastMint(_address, block.number);
305         }
306     }
307 
308     function unconfirm(address _address) onlyOwner public {
309         confirmed[_address] = false;
310         if(members[_address]){
311             members[_address] = false;
312             totalMembers = totalMembers.sub(1);
313         }
314     }
315     
316     function setLastMint(address _address, uint _block) onlyOwner public{
317         lastMint[_address] = _block;
318     }
319 
320     function setCommission(uint _commission) onlyOwner public{
321         commissionPercent = _commission;
322     }
323 
324     function setMintPerBlock(uint256 _mintPerBlock) onlyOwner public{
325         mintPerBlock = _mintPerBlock;
326     }
327 
328     function setInvested(address _address) onlyOwner public{
329         invested[_address] = true;
330         if(confirmed[_address] && !members[_address]){
331             members[_address] = true;
332             totalMembers = totalMembers.add(1);
333             refreshBalance(_address);
334         }
335     }
336 
337     function isMember(address _address) public constant returns(bool){
338         return members[_address];
339     }
340 
341 }
342 
343 
344 contract Crowdsale is Ownable{
345 
346     using SafeMath for uint;
347 
348     BigToken public token;
349     uint public collected;
350     address public benefeciar;
351 
352     function Crowdsale(address _token, address _benefeciar){
353         token = BigToken(_token);
354         benefeciar = _benefeciar;
355         owners[msg.sender] = true;
356     }
357 
358     function () payable {
359         require(msg.value >= 0.01 ether);
360         uint256 amount = msg.value / 0.01 ether * 1 ether;
361 
362         if(msg.value >= 100 ether && msg.value < 500 ether) amount = amount * 11 / 10;
363         if(msg.value >= 500 ether && msg.value < 1000 ether) amount = amount * 12 / 10;
364         if(msg.value >= 1000 ether && msg.value < 5000 ether) amount = amount * 13 / 10;
365         if(msg.value >= 5000 ether && msg.value < 10000 ether) amount = amount * 14 / 10;
366         if(msg.value >= 10000 ether) amount = amount * 15 / 10;
367 
368         collected = collected.add(msg.value);
369 
370         token.mint(msg.sender, amount);
371         token.setInvested(msg.sender);
372     }
373 
374 
375     function confirmAddress(address _address) public onlyOwner{
376         token.confirm(_address);
377     }
378 
379     function unconfirmAddress(address _address) public onlyOwner{
380         token.unconfirm(_address);
381     }
382 
383     function setBenefeciar(address _benefeciar) public onlyOwner{
384         benefeciar = _benefeciar;
385     }
386 
387     function withdraw() public onlyOwner{
388         benefeciar.transfer(this.balance);
389     }
390 
391 }