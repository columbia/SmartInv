1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 
11 contract Owned {
12     address private _owner;
13     address private _newOwner;
14 
15     event TransferredOwner(
16         address indexed previousOwner,
17         address indexed newOwner
18     );
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24     constructor() internal {
25         _owner = msg.sender;
26         emit TransferredOwner(address(0), _owner);
27     }
28 
29   /**
30    * @return the address of the owner.
31    */
32 
33     function owner() public view returns(address) {
34         return _owner;
35     }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40     modifier onlyOwner() {
41         require(isOwner(), "Access is denied");
42         _;
43     }
44 
45   /**
46    * @return true if `msg.sender` is the owner of the contract.
47    */
48     function isOwner() public view returns(bool) {
49         return msg.sender == _owner;
50     }
51 
52   /**
53    * @dev Allows the current owner to relinquish control of the contract.
54    * @notice Renouncing to ownership will leave the contract without an owner.
55    * It will not be possible to call the functions with the `onlyOwner`
56    * modifier anymore.
57    */
58     function renounceOwner() public onlyOwner {
59         emit TransferredOwner(_owner, address(0));
60         _owner = address(0);
61     }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67     function transferOwner(address newOwner) public onlyOwner {
68         require(newOwner != address(0), "Empty address");
69         _newOwner = newOwner;
70     }
71 
72 
73     function cancelOwner() public onlyOwner {
74         _newOwner = address(0);
75     }
76 
77     function confirmOwner() public {
78         require(msg.sender == _newOwner, "Access is denied");
79         emit TransferredOwner(_owner, _newOwner);
80         _owner = _newOwner;
81     }
82 }
83 
84 
85 
86 
87 /**
88  * @title Standard ERC20 token
89  *
90  * @dev Implementation of the basic standard token.
91  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
92  */
93 
94 contract ERC20CoreBase {
95 
96     // string public name;
97     // string public symbol;
98     // uint8 public decimals;
99 
100 
101     mapping (address => uint) internal _balanceOf;
102     uint internal _totalSupply; 
103 
104     event Transfer(
105         address indexed from,
106         address indexed to,
107         uint256 value
108     );
109 
110 
111     /**
112     * @dev Total number of tokens in existence
113     */
114 
115     function totalSupply() public view returns(uint) {
116         return _totalSupply;
117     }
118 
119     /**
120     * @dev Gets the balance of the specified address.
121     * @param owner The address to query the balance of.
122     * @return An uint256 representing the amount owned by the passed address.
123     */
124 
125     function balanceOf(address owner) public view returns(uint) {
126         return _balanceOf[owner];
127     }
128 
129 
130 
131     /**
132     * @dev Transfer token for a specified addresses
133     * @param from The address to transfer from.
134     * @param to The address to transfer to.
135     * @param value The amount to be transferred.
136     */
137 
138     function _transfer(address from, address to, uint256 value) internal {
139         _checkRequireERC20(to, value, true, _balanceOf[from]);
140 
141         _balanceOf[from] -= value;
142         _balanceOf[to] += value;
143         emit Transfer(from, to, value);
144     }
145 
146 
147     /**
148     * @dev Internal function that mints an amount of the token and assigns it to
149     * an account. This encapsulates the modification of balances such that the
150     * proper events are emitted.
151     * @param account The account that will receive the created tokens.
152     * @param value The amount that will be created.
153     */
154 
155     function _mint(address account, uint256 value) internal {
156         _checkRequireERC20(account, value, false, 0);
157         _totalSupply += value;
158         _balanceOf[account] += value;
159         emit Transfer(address(0), account, value);
160     }
161 
162     /**
163     * @dev Internal function that burns an amount of the token of a given
164     * account.
165     * @param account The account whose tokens will be burnt.
166     * @param value The amount that will be burnt.
167     */
168 
169     function _burn(address account, uint256 value) internal {
170         _checkRequireERC20(account, value, true, _balanceOf[account]);
171 
172         _totalSupply -= value;
173         _balanceOf[account] -= value;
174         emit Transfer(account, address(0), value);
175     }
176 
177 
178     function _checkRequireERC20(address addr, uint value, bool checkMax, uint max) internal pure {
179         require(addr != address(0), "Empty address");
180         require(value > 0, "Empty value");
181         if (checkMax) {
182             require(value <= max, "Out of value");
183         }
184     }
185 
186 }
187 
188 
189 contract ERC20 is ERC20CoreBase {
190     mapping (address => mapping (address => uint256)) private _allowed;
191 
192 
193     event Approval(
194         address indexed owner,
195         address indexed spender,
196         uint256 value
197     ); 
198 
199 
200 	constructor(address to, uint value) public {
201 		_mint(to, value);
202 	}
203 
204     /**
205     * @dev Function to check the amount of tokens that an owner allowed to a spender.
206     * @param owner address The address which owns the funds.
207     * @param spender address The address which will spend the funds.
208     * @return A uint256 specifying the amount of tokens still available for the spender.
209     */
210     
211     function allowance(address owner, address spender) public view returns(uint) {
212         return _allowed[owner][spender];
213     }
214 
215     /**
216     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217     * Beware that changing an allowance with this method brings the risk that someone may use both the old
218     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221     * @param spender The address which will spend the funds.
222     * @param value The amount of tokens to be spent.
223     */
224 
225     function approve(address spender, uint256 value) public {
226         _checkRequireERC20(spender, value, true, _balanceOf[msg.sender]);
227 
228         _allowed[msg.sender][spender] = value;
229         emit Approval(msg.sender, spender, value);
230     }
231 
232     /**
233     * @dev Transfer tokens from one address to another
234     * @param from address The address which you want to send tokens from
235     * @param to address The address which you want to transfer to
236     * @param value uint256 the amount of tokens to be transferred
237     */
238 
239     function transferFrom(address from, address to, uint256 value) public {
240         _checkRequireERC20(to, value, true, _allowed[from][msg.sender]);
241 
242         _allowed[from][msg.sender] -= value;
243         _transfer(from, to, value);
244     }
245 
246 
247 
248 
249 
250 
251  
252     /**
253     * @dev Transfer token for a specified address
254     * @param to The address to transfer to.
255     * @param value The amount to be transferred.
256     */
257 
258     function transfer(address to, uint256 value) public {
259         _transfer(msg.sender, to, value);
260     }
261 }
262 
263 
264 contract LineAxis is Owned, ERC20 {
265 	string public name;
266 	string public symbol;
267 	uint public decimals;
268 	bool public frozen;
269 
270 
271 	/**
272 	* Logged when token transfers were frozen/unfrozen.
273 	*/
274 	event Freeze ();
275 	event Unfreeze ();
276 	
277     modifier onlyUnfreeze() {
278         require(!frozen, "Action temporarily paused");
279         _;
280     }
281 
282 	constructor(string _name, string _symbol, uint _decimals, uint _total, bool _frozen) public ERC20(msg.sender, _total) {
283 		name = _name;
284 		symbol = _symbol;
285 		decimals = _decimals;
286 		frozen = _frozen;
287 	}
288 
289 	function mint(address to, uint value) public onlyOwner {
290 		_mint(to, value);
291 	}
292 
293 
294 
295 
296 
297 	function freezeTransfers () public onlyOwner {
298 		if (!frozen) {
299 			frozen = true;
300 			emit Freeze();
301 		}
302 	}
303 
304 	/**
305 	* Unfreeze token transfers.
306 	* May only be called by smart contract owner.
307 	*/
308 	function unfreezeTransfers () public onlyOwner {
309 		if (frozen) {
310 			frozen = false;
311 			emit Unfreeze();
312 		}
313 	}
314 
315 	function transfer(address to, uint value) public onlyUnfreeze {
316 		super.transfer(to, value);
317 	}
318 
319 
320 	function transferFrom(address from, address to, uint value) public onlyUnfreeze {
321 		super.transferFrom(from, to, value);
322 	}
323 }