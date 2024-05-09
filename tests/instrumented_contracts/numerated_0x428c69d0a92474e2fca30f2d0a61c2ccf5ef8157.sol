1 pragma solidity ^0.4.25;
2 
3 // ---------------------------------------------------------------------
4 // Dex Brokerage Token - DEXB : https://dexbrokerage.com
5 //
6 // Symbol      : DEXB
7 // Name        : Dex Brokerage Token
8 // Total supply: 200,000,000
9 // Decimals    : 18
10 //
11 // Author: Radek Ostrowski / https://startonchain.com
12 // ---------------------------------------------------------------------
13 
14 /**
15  * @title DexBrokerage
16  * @dev Interface function called from `approveAndDeposit` depositing the tokens onto the exchange
17  */
18 contract DexBrokerage {
19     function receiveTokenDeposit(address token, address from, uint256 amount) public;
20 }
21 
22 /**
23  * @title ApproveAndCall
24  * @dev Interface function called from `approveAndCall` notifying that the approval happened
25  */
26 contract ApproveAndCall {
27     function receiveApproval(address _from, uint256 _amount, address _tokenContract, bytes _data) public returns (bool);
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35 
36     /**
37     * @dev Multiplies two numbers, throws on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b);
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two numbers, truncating the quotient.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         require(b > 0);
53         uint256 c = a / b;
54         return c;
55     }
56 
57     /**
58     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59     */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b <= a);
62         return a - b;
63     }
64 
65     /**
66     * @dev Adds two numbers, throws on overflow.
67     */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71         return c;
72     }
73 }
74 
75 /**
76  * @title ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/20
78  */
79 contract ERC20 {
80     function transfer(address to, uint256 value) public returns (bool);
81     function approve(address spender, uint256 value) public returns (bool);
82     function transferFrom(address from, address to, uint256 value) public returns (bool);
83     function balanceOf(address _who) public view returns (uint256);
84     function allowance(address _owner, address _spender) public view returns (uint256);
85 }
86 
87 /**
88  * @title Ownable
89  * @dev The Ownable contract has an owner address, and provides basic authorization control
90  * functions, this simplifies the implementation of "user permissions".
91  */
92 contract Ownable {
93     address public owner;
94 
95     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
96 
97     /**
98      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99      * account.
100      */
101     constructor() public {
102         owner = msg.sender;
103     }
104 
105     /**
106      * @dev Throws if called by any account other than the owner.
107      */
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112 
113     /**
114      * @dev Allows the current owner to transfer control of the contract to a newOwner.
115      * @param _newOwner The address to transfer ownership to.
116      */
117     function transferOwnership(address _newOwner) public onlyOwner {
118         require(_newOwner != address(0));
119         owner = _newOwner;
120         emit OwnershipTransferred(owner, _newOwner);
121     }
122 }
123 
124 /**
125  * @title Dex Brokerage Token
126  * @dev Burnable ERC20 token with initial transfers blocked
127  */
128 contract DexBrokerageToken is Ownable {
129     using SafeMath for uint256;
130 
131     event Transfer(address indexed _from, address indexed _to, uint256 _value);
132     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
133 
134     event TransfersEnabled();
135     event TransferRightGiven(address indexed _to);
136     event TransferRightCancelled(address indexed _from);
137     event WithdrawnERC20Tokens(address indexed _tokenContract, address indexed _owner, uint256 _balance);
138     event WithdrawnEther(address indexed _owner, uint256 _balance);
139 
140     string public constant name = "Dex Brokerage Token";
141     string public constant symbol = "DEXB";
142     uint8 public constant decimals = 18;
143     uint256 public constant initialSupply = 200000000 * (10 ** uint256(decimals));
144     uint256 public totalSupply;
145 
146     mapping(address => uint256) public balances;
147     mapping(address => mapping (address => uint256)) internal allowed;
148 
149     //This mapping is used for the token owner and crowdsale contract to
150     //transfer tokens before they are transferable
151     mapping(address => bool) public transferGrants;
152     //This flag controls the global token transfer
153     bool public transferable;
154 
155     /**
156      * @dev Modifier to check if tokens can be transferred.
157      */
158     modifier canTransfer() {
159         require(transferable || transferGrants[msg.sender]);
160         _;
161     }
162 
163     /**
164      * @dev The constructor sets the original `owner` of the contract
165      * to the sender account and assigns them all tokens.
166      */
167     constructor() public {
168         totalSupply = initialSupply;
169         balances[owner] = totalSupply;
170         transferGrants[owner] = true;
171     }
172 
173     /**
174     * @dev Gets the balance of the specified address.
175     * @param _owner The address to query the the balance of.
176     * @return An uint256 representing the amount owned by the passed address.
177     */
178     function balanceOf(address _owner) public view returns (uint256) {
179         return balances[_owner];
180     }
181 
182     /**
183     * @dev Transfer token for a specified address
184     * @param _to The address to transfer to.
185     * @param _value The amount to be transferred.
186     */
187     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
188         require(_to != address(0));
189         require(_value <= balances[msg.sender]);
190         // SafeMath.sub will throw if there is not enough balance.
191         balances[msg.sender] = balances[msg.sender].sub(_value);
192         balances[_to] = balances[_to].add(_value);
193         emit Transfer(msg.sender, _to, _value);
194         return true;
195     }
196 
197     /**
198      * @dev Transfer tokens from one address to another
199      * @param _from address The address which you want to send tokens from
200      * @param _to address The address which you want to transfer to
201      * @param _value uint256 the amount of tokens to be transferred
202      */
203     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
204         require(_to != address(0));
205         require(_value <= balances[_from]);
206         require(_value <= allowed[_from][msg.sender]);
207         balances[_from] = balances[_from].sub(_value);
208         balances[_to] = balances[_to].add(_value);
209         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210         emit Transfer(_from, _to, _value);
211         return true;
212     }
213 
214     /**
215      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216      *
217      * Beware that changing an allowance with this method brings the risk that someone may use both the old
218      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221      * @param _spender The address which will spend the funds.
222      * @param _value The amount of tokens to be spent.
223      */
224     function approve(address _spender, uint256 _value) canTransfer public returns (bool) {
225         allowed[msg.sender][_spender] = _value;
226         emit Approval(msg.sender, _spender, _value);
227         return true;
228     }
229 
230     /**
231      * @dev Function to check the amount of tokens that an owner allowed to a spender.
232      * @param _owner address The address which owns the funds.
233      * @param _spender address The address which will spend the funds.
234      * @return A uint256 specifying the amount of tokens still available for the spender.
235      */
236     function allowance(address _owner, address _spender) public view returns (uint256) {
237         return allowed[_owner][_spender];
238     }
239 
240     /**
241      * @dev Increase the amount of tokens that an owner allowed to a spender.
242      *
243      * approve should be called when allowed[_spender] == 0. To increment
244      * allowed value is better to use this function to avoid 2 calls (and wait until
245      * the first transaction is mined)
246      * From MonolithDAO Token.sol
247      * @param _spender The address which will spend the funds.
248      * @param _addedValue The amount of tokens to increase the allowance by.
249      */
250     function increaseApproval(address _spender, uint _addedValue) canTransfer public returns (bool) {
251         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253         return true;
254     }
255 
256     /**
257      * @dev Decrease the amount of tokens that an owner allowed to a spender.
258      *
259      * approve should be called when allowed[_spender] == 0. To decrement
260      * allowed value is better to use this function to avoid 2 calls (and wait until
261      * the first transaction is mined)
262      * From MonolithDAO Token.sol
263      * @param _spender The address which will spend the funds.
264      * @param _subtractedValue The amount of tokens to decrease the allowance by.
265      */
266     function decreaseApproval(address _spender, uint _subtractedValue) canTransfer public returns (bool) {
267         uint oldValue = allowed[msg.sender][_spender];
268         if (_subtractedValue > oldValue) {
269             allowed[msg.sender][_spender] = 0;
270         } else {
271             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272         }
273         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274         return true;
275     }
276 
277     /**
278      * @dev Function to approve the transfer of the tokens and to call another contract in one step
279      * @param _recipient The target contract for tokens and function call
280      * @param _value The amount of tokens to send
281      * @param _data Extra data to be sent to the recipient contract function
282      */
283     function approveAndCall(address _recipient, uint _value, bytes _data) canTransfer public returns (bool) {
284         allowed[msg.sender][_recipient] = _value;
285         ApproveAndCall(_recipient).receiveApproval(msg.sender, _value, address(this), _data);
286         emit Approval(msg.sender, _recipient, allowed[msg.sender][_recipient]);
287         return true;
288     }
289 
290     /**
291      * @dev Function to approve the transfer of the tokens and deposit them to DexBrokerage in one step
292      * @param _exchange DexBrokerage exchange address to deposit the tokens to
293      * @param _value The amount of tokens to send
294      */
295     function approveAndDeposit(DexBrokerage _exchange, uint _value) public returns (bool) {
296         allowed[msg.sender][_exchange] = _value;
297         emit Approval(msg.sender, _exchange, _value);
298         _exchange.receiveTokenDeposit(address(this), msg.sender, _value);
299         return true;
300     }
301 
302     /**
303      * @dev Burns a specific amount of tokens.
304      * @param _value The amount of token to be burned.
305      */
306     function burn(uint256 _value) canTransfer public {
307         require(_value <= balances[msg.sender]);
308         address burner = msg.sender;
309         balances[burner] = balances[burner].sub(_value);
310         totalSupply = totalSupply.sub(_value);
311         emit Transfer(burner, address(0), _value);
312     }
313 
314     /**
315      * @dev Enables the transfer of tokens for everyone
316      */
317     function enableTransfers() onlyOwner public {
318         require(!transferable);
319         transferable = true;
320         emit TransfersEnabled();
321     }
322 
323     /**
324      * @dev Assigns the special transfer right, before transfers are enabled
325      * @param _to The address receiving the transfer grant
326      */
327     function grantTransferRight(address _to) onlyOwner public {
328         require(!transferable);
329         require(!transferGrants[_to]);
330         require(_to != address(0));
331         transferGrants[_to] = true;
332         emit TransferRightGiven(_to);
333     }
334 
335     /**
336      * @dev Removes the special transfer right, before transfers are enabled
337      * @param _from The address that the transfer grant is removed from
338      */
339     function cancelTransferRight(address _from) onlyOwner public {
340         require(!transferable);
341         require(transferGrants[_from]);
342         transferGrants[_from] = false;
343         emit TransferRightCancelled(_from);
344     }
345 
346     /**
347      * @dev Allows to transfer out the balance of arbitrary ERC20 tokens from the contract.
348      * @param _token The contract address of the ERC20 token.
349      */
350     function withdrawERC20Tokens(ERC20 _token) onlyOwner public {
351         uint256 totalBalance = _token.balanceOf(address(this));
352         require(totalBalance > 0);
353         _token.transfer(owner, totalBalance);
354         emit WithdrawnERC20Tokens(address(_token), owner, totalBalance);
355     }
356 
357     /**
358      * @dev Allows to transfer out the ether balance that was forced into this contract, e.g with `selfdestruct`
359      */
360     function withdrawEther() onlyOwner public {
361         uint256 totalBalance = address(this).balance;
362         require(totalBalance > 0);
363         owner.transfer(totalBalance);
364         emit WithdrawnEther(owner, totalBalance);
365     }
366 }