1 pragma solidity 0.5.7;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value)
11         external returns (bool);
12 
13     function transferFrom(address from, address to, uint256 value)
14         external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender)
21         external view returns (uint256);
22 
23     event Transfer(
24         address indexed from,
25         address indexed to,
26         uint256 value
27     );
28 
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42     /**
43     * @dev Multiplies two numbers, reverts on overflow.
44     */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61     */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b > 0); // Solidity only automatically asserts when dividing by 0
64         uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67         return c;
68     }
69 
70     /**
71     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72     */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b <= a);
75         uint256 c = a - b;
76 
77         return c;
78     }
79 
80     /**
81     * @dev Adds two numbers, reverts on overflow.
82     */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a);
86 
87         return c;
88     }
89 
90     /**
91     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92     * reverts when dividing by zero.
93     */
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0);
96         return a % b;
97     }
98 }
99 
100 /* Copyright (C) 2017 NexusMutual.io
101 
102   This program is free software: you can redistribute it and/or modify
103     it under the terms of the GNU General Public License as published by
104     the Free Software Foundation, either version 3 of the License, or
105     (at your option) any later version.
106 
107   This program is distributed in the hope that it will be useful,
108     but WITHOUT ANY WARRANTY; without even the implied warranty of
109     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
110     GNU General Public License for more details.
111 
112   You should have received a copy of the GNU General Public License
113     along with this program.  If not, see http://www.gnu.org/licenses/ */
114 
115 
116 
117 
118 
119 
120 
121 contract NXMToken is IERC20 {
122     using SafeMath for uint256;
123 
124     event WhiteListed(address indexed member);
125 
126     event BlackListed(address indexed member);
127 
128     mapping (address => uint256) private _balances;
129 
130     mapping (address => mapping (address => uint256)) private _allowed;
131 
132     mapping (address => bool) public whiteListed;
133 
134     mapping(address => uint) public isLockedForMV;
135 
136     uint256 private _totalSupply;
137 
138     string public name = "NXM";
139     string public symbol = "NXM";
140     uint8 public decimals = 18;
141     address public operator;
142 
143     modifier canTransfer(address _to) {
144         require(whiteListed[_to]);
145         _;
146     }
147 
148     modifier onlyOperator() {
149         if (operator != address(0))
150             require(msg.sender == operator);
151         _;
152     }
153 
154     constructor(address _founderAddress, uint _initialSupply) public {
155         _mint(_founderAddress, _initialSupply);
156     }
157 
158     /**
159     * @dev Total number of tokens in existence
160     */
161     function totalSupply() public view returns (uint256) {
162         return _totalSupply;
163     }
164 
165     /**
166     * @dev Gets the balance of the specified address.
167     * @param owner The address to query the balance of.
168     * @return An uint256 representing the amount owned by the passed address.
169     */
170     function balanceOf(address owner) public view returns (uint256) {
171         return _balances[owner];
172     }
173 
174     /**
175     * @dev Function to check the amount of tokens that an owner allowed to a spender.
176     * @param owner address The address which owns the funds.
177     * @param spender address The address which will spend the funds.
178     * @return A uint256 specifying the amount of tokens still available for the spender.
179     */
180     function allowance(
181         address owner,
182         address spender
183     )
184         public
185         view
186         returns (uint256)
187     {
188         return _allowed[owner][spender];
189     }
190 
191     /**
192     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193     * Beware that changing an allowance with this method brings the risk that someone may use both the old
194     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197     * @param spender The address which will spend the funds.
198     * @param value The amount of tokens to be spent.
199     */
200     function approve(address spender, uint256 value) public returns (bool) {
201         require(spender != address(0));
202 
203         _allowed[msg.sender][spender] = value;
204         emit Approval(msg.sender, spender, value);
205         return true;
206     }
207 
208     /**
209     * @dev Increase the amount of tokens that an owner allowed to a spender.
210     * approve should be called when allowed_[_spender] == 0. To increment
211     * allowed value is better to use this function to avoid 2 calls (and wait until
212     * the first transaction is mined)
213     * From MonolithDAO Token.sol
214     * @param spender The address which will spend the funds.
215     * @param addedValue The amount of tokens to increase the allowance by.
216     */
217     function increaseAllowance(
218         address spender,
219         uint256 addedValue
220     )
221         public
222         returns (bool)
223     {
224         require(spender != address(0));
225 
226         _allowed[msg.sender][spender] = (
227         _allowed[msg.sender][spender].add(addedValue));
228         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
229         return true;
230     }
231 
232     /**
233     * @dev Decrease the amount of tokens that an owner allowed to a spender.
234     * approve should be called when allowed_[_spender] == 0. To decrement
235     * allowed value is better to use this function to avoid 2 calls (and wait until
236     * the first transaction is mined)
237     * From MonolithDAO Token.sol
238     * @param spender The address which will spend the funds.
239     * @param subtractedValue The amount of tokens to decrease the allowance by.
240     */
241     function decreaseAllowance(
242         address spender,
243         uint256 subtractedValue
244     )
245         public
246         returns (bool)
247     {
248         require(spender != address(0));
249 
250         _allowed[msg.sender][spender] = (
251         _allowed[msg.sender][spender].sub(subtractedValue));
252         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
253         return true;
254     }
255 
256     /**
257     * @dev Adds a user to whitelist
258     * @param _member address to add to whitelist
259     */
260     function addToWhiteList(address _member) public onlyOperator returns (bool) {
261         whiteListed[_member] = true;
262         emit WhiteListed(_member);
263         return true;
264     }
265 
266     /**
267     * @dev removes a user from whitelist
268     * @param _member address to remove from whitelist
269     */
270     function removeFromWhiteList(address _member) public onlyOperator returns (bool) {
271         whiteListed[_member] = false;
272         emit BlackListed(_member);
273         return true;
274     }
275 
276     /**
277     * @dev change operator address 
278     * @param _newOperator address of new operator
279     */
280     function changeOperator(address _newOperator) public onlyOperator returns (bool) {
281         operator = _newOperator;
282         return true;
283     }
284 
285     /**
286     * @dev burns an amount of the tokens of the message sender
287     * account.
288     * @param amount The amount that will be burnt.
289     */
290     function burn(uint256 amount) public returns (bool) {
291         _burn(msg.sender, amount);
292         return true;
293     }
294 
295     /**
296     * @dev Burns a specific amount of tokens from the target address and decrements allowance
297     * @param from address The address which you want to send tokens from
298     * @param value uint256 The amount of token to be burned
299     */
300     function burnFrom(address from, uint256 value) public returns (bool) {
301         _burnFrom(from, value);
302         return true;
303     }
304 
305     /**
306     * @dev function that mints an amount of the token and assigns it to
307     * an account.
308     * @param account The account that will receive the created tokens.
309     * @param amount The amount that will be created.
310     */
311     function mint(address account, uint256 amount) public onlyOperator {
312         _mint(account, amount);
313     }
314 
315     /**
316     * @dev Transfer token for a specified address
317     * @param to The address to transfer to.
318     * @param value The amount to be transferred.
319     */
320     function transfer(address to, uint256 value) public canTransfer(to) returns (bool) {
321 
322         require(isLockedForMV[msg.sender] < now); // if not voted under governance
323         require(value <= _balances[msg.sender]);
324         _transfer(to, value); 
325         return true;
326     }
327 
328     /**
329     * @dev Transfer tokens to the operator from the specified address
330     * @param from The address to transfer from.
331     * @param value The amount to be transferred.
332     */
333     function operatorTransfer(address from, uint256 value) public onlyOperator returns (bool) {
334         require(value <= _balances[from]);
335         _transferFrom(from, operator, value);
336         return true;
337     }
338 
339     /**
340     * @dev Transfer tokens from one address to another
341     * @param from address The address which you want to send tokens from
342     * @param to address The address which you want to transfer to
343     * @param value uint256 the amount of tokens to be transferred
344     */
345     function transferFrom(
346         address from,
347         address to,
348         uint256 value
349     )
350         public
351         canTransfer(to)
352         returns (bool)
353     {
354         require(isLockedForMV[from] < now); // if not voted under governance
355         require(value <= _balances[from]);
356         require(value <= _allowed[from][msg.sender]);
357         _transferFrom(from, to, value);
358         return true;
359     }
360 
361     /**
362      * @dev Lock the user's tokens 
363      * @param _of user's address.
364      */
365     function lockForMemberVote(address _of, uint _days) public onlyOperator {
366         if (_days.add(now) > isLockedForMV[_of])
367             isLockedForMV[_of] = _days.add(now);
368     }
369 
370     /**
371     * @dev Transfer token for a specified address
372     * @param to The address to transfer to.
373     * @param value The amount to be transferred.
374     */
375     function _transfer(address to, uint256 value) internal {
376         _balances[msg.sender] = _balances[msg.sender].sub(value);
377         _balances[to] = _balances[to].add(value);
378         emit Transfer(msg.sender, to, value);
379     }
380 
381     /**
382     * @dev Transfer tokens from one address to another
383     * @param from address The address which you want to send tokens from
384     * @param to address The address which you want to transfer to
385     * @param value uint256 the amount of tokens to be transferred
386     */
387     function _transferFrom(
388         address from,
389         address to,
390         uint256 value
391     )
392         internal
393     {
394         _balances[from] = _balances[from].sub(value);
395         _balances[to] = _balances[to].add(value);
396         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
397         emit Transfer(from, to, value);
398     }
399 
400     /**
401     * @dev Internal function that mints an amount of the token and assigns it to
402     * an account. This encapsulates the modification of balances such that the
403     * proper events are emitted.
404     * @param account The account that will receive the created tokens.
405     * @param amount The amount that will be created.
406     */
407     function _mint(address account, uint256 amount) internal {
408         require(account != address(0));
409         _totalSupply = _totalSupply.add(amount);
410         _balances[account] = _balances[account].add(amount);
411         emit Transfer(address(0), account, amount);
412     }
413 
414     /**
415     * @dev Internal function that burns an amount of the token of a given
416     * account.
417     * @param account The account whose tokens will be burnt.
418     * @param amount The amount that will be burnt.
419     */
420     function _burn(address account, uint256 amount) internal {
421         require(amount <= _balances[account]);
422 
423         _totalSupply = _totalSupply.sub(amount);
424         _balances[account] = _balances[account].sub(amount);
425         emit Transfer(account, address(0), amount);
426     }
427 
428     /**
429     * @dev Internal function that burns an amount of the token of a given
430     * account, deducting from the sender's allowance for said account. Uses the
431     * internal burn function.
432     * @param account The account whose tokens will be burnt.
433     * @param value The amount that will be burnt.
434     */
435     function _burnFrom(address account, uint256 value) internal {
436         require(value <= _allowed[account][msg.sender]);
437 
438         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
439         // this function needs to emit an event with the updated approval.
440         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
441         value);
442         _burn(account, value);
443     }
444 }