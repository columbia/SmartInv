1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Standard ERC20 token
6  *
7  * @dev Implementation of the basic standard token.
8  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md 
9  * @author https://snowfox.tech/
10  */
11  
12  /**
13   * @title Base contract
14   * @dev Implements all the necessary logic for the token distribution (methods are closed. Inherited)
15   */
16 
17 contract ERC20CoreBase {
18 
19     // string public name;
20     // string public symbol;
21     // uint8 public decimals;
22 
23 
24     mapping (address => uint) internal _balanceOf;
25     uint internal _totalSupply; 
26 
27     event Transfer(
28         address indexed from,
29         address indexed to,
30         uint256 value
31     );
32 
33 
34     /**
35     * @dev Total number of tokens in existence
36     */
37 
38     function totalSupply() public view returns(uint) {
39         return _totalSupply;
40     }
41 
42     /**
43     * @dev Gets the balance of the specified address.
44     * @param owner The address to query the balance of.
45     * @return An uint256 representing the amount owned by the passed address.
46     */
47 
48     function balanceOf(address owner) public view returns(uint) {
49         return _balanceOf[owner];
50     }
51 
52 
53 
54     /**
55     * @dev Transfer token for a specified addresses
56     * @param from The address to transfer from.
57     * @param to The address to transfer to.
58     * @param value The amount to be transferred.
59     */
60 
61     function _transfer(address from, address to, uint256 value) internal {
62         _checkRequireERC20(to, value, true, _balanceOf[from]);
63 
64         _balanceOf[from] -= value;
65         _balanceOf[to] += value;
66         emit Transfer(from, to, value);
67     }
68 
69 
70     /**
71     * @dev Internal function that mints an amount of the token and assigns it to
72     * an account. This encapsulates the modification of balances such that the
73     * proper events are emitted.
74     * @param account The account that will receive the created tokens.
75     * @param value The amount that will be created.
76     */
77 
78     function _mint(address account, uint256 value) internal {
79         _checkRequireERC20(account, value, false, 0);
80         _totalSupply += value;
81         _balanceOf[account] += value;
82         emit Transfer(address(0), account, value);
83     }
84 
85     /**
86     * @dev Internal function that burns an amount of the token of a given
87     * account.
88     * @param account The account whose tokens will be burnt.
89     * @param value The amount that will be burnt.
90     */
91 
92     function _burn(address account, uint256 value) internal {
93         _checkRequireERC20(account, value, true, _balanceOf[account]);
94 
95         _totalSupply -= value;
96         _balanceOf[account] -= value;
97         emit Transfer(account, address(0), value);
98     }
99 
100 
101     function _checkRequireERC20(address addr, uint value, bool checkMax, uint max) internal pure {
102         require(addr != address(0), "Empty address");
103         require(value > 0, "Empty value");
104         if (checkMax) {
105             require(value <= max, "Out of value");
106         }
107     }
108 
109 } 
110 
111 
112 
113 /**
114  * @title The logic of trust management (methods closed. Inherited).
115  */
116 contract ERC20WithApproveBase is ERC20CoreBase {
117     mapping (address => mapping (address => uint256)) private _allowed;
118 
119 
120     event Approval(
121         address indexed owner,
122         address indexed spender,
123         uint256 value
124     ); 
125 
126     /**
127     * @dev Function to check the amount of tokens that an owner allowed to a spender.
128     * @param owner address The address which owns the funds.
129     * @param spender address The address which will spend the funds.
130     * @return A uint256 specifying the amount of tokens still available for the spender.
131     */
132     
133     function allowance(address owner, address spender) public view returns(uint) {
134         return _allowed[owner][spender];
135     }
136 
137     /**
138     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139     * Beware that changing an allowance with this method brings the risk that someone may use both the old
140     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143     * @param spender The address which will spend the funds.
144     * @param value The amount of tokens to be spent.
145     */
146 
147     function _approve(address spender, uint256 value) internal {
148         _checkRequireERC20(spender, value, true, _balanceOf[msg.sender]);
149 
150         _allowed[msg.sender][spender] = value;
151         emit Approval(msg.sender, spender, value);
152     }
153 
154     /**
155     * @dev Transfer tokens from one address to another
156     * @param from address The address which you want to send tokens from
157     * @param to address The address which you want to transfer to
158     * @param value uint256 the amount of tokens to be transferred
159     */
160 
161     function _transferFrom(address from, address to, uint256 value) internal {
162         _checkRequireERC20(to, value, true, _allowed[from][msg.sender]);
163 
164         _allowed[from][msg.sender] -= value;
165         _transfer(from, to, value);
166     }
167 
168     /**
169     * @dev Increase the amount of tokens that an owner allowed to a spender.
170     * approve should be called when allowed_[_spender] == 0. To increment
171     * allowed value is better to use this function to avoid 2 calls (and wait until
172     * the first transaction is mined)
173     * @param spender The address which will spend the funds.
174     * @param value The amount of tokens to increase the allowance by.
175     */
176 
177     function _increaseAllowance(address spender, uint256 value)  internal {
178         _checkRequireERC20(spender, value, false, 0);
179         require(_balanceOf[msg.sender] >= (_allowed[msg.sender][spender] + value), "Out of value");
180 
181         _allowed[msg.sender][spender] += value;
182         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
183     }
184 
185 
186 
187     /**
188     * @dev Decrease the amount of tokens that an owner allowed to a spender.
189     * approve should be called when allowed_[_spender] == 0. To decrement
190     * allowed value is better to use this function to avoid 2 calls (and wait until
191     * the first transaction is mined)
192     * @param spender The address which will spend the funds.
193     * @param value The amount of tokens to decrease the allowance by.
194     */
195 
196     function _decreaseAllowance(address spender, uint256 value) internal {
197         _checkRequireERC20(spender, value, true, _allowed[msg.sender][spender]);
198 
199         _allowed[msg.sender][spender] -= value;
200         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
201     }
202 
203 }
204 
205 
206 
207 
208 /**
209  * @title The logic of trust management (public methods).
210  */
211 contract ERC20WithApprove is ERC20WithApproveBase {
212     /**
213     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214     * Beware that changing an allowance with this method brings the risk that someone may use both the old
215     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218     * @param spender The address which will spend the funds.
219     * @param value The amount of tokens to be spent.
220     */
221 
222     function approve(address spender, uint256 value) public {
223         _approve(spender, value);
224     }
225 
226     /**
227     * @dev Transfer tokens from one address to another
228     * @param from address The address which you want to send tokens from
229     * @param to address The address which you want to transfer to
230     * @param value uint256 the amount of tokens to be transferred
231     */
232 
233     function transferFrom(address from, address to, uint256 value) public {
234         _transferFrom(from, to, value);
235     }
236 
237     /**
238     * @dev Increase the amount of tokens that an owner allowed to a spender.
239     * approve should be called when allowed_[_spender] == 0. To increment
240     * allowed value is better to use this function to avoid 2 calls (and wait until
241     * the first transaction is mined)
242     * @param spender The address which will spend the funds.
243     * @param value The amount of tokens to increase the allowance by.
244     */
245 
246     function increaseAllowance(address spender, uint256 value)  public {
247         _increaseAllowance(spender, value);
248     }
249 
250 
251 
252     /**
253     * @dev Decrease the amount of tokens that an owner allowed to a spender.
254     * approve should be called when allowed_[_spender] == 0. To decrement
255     * allowed value is better to use this function to avoid 2 calls (and wait until
256     * the first transaction is mined)
257     * @param spender The address which will spend the funds.
258     * @param value The amount of tokens to decrease the allowance by.
259     */
260 
261     function decreaseAllowance(address spender, uint256 value) public {
262         _decreaseAllowance(spender, value);
263     }
264 } 
265 
266 
267 /**
268  * @title Main contract
269  * @dev Start data and access to transfer method
270  * 
271  */
272 
273 contract ERC20 is ERC20WithApprove {
274 	string public name;
275 	string public symbol;
276 	uint public decimals;
277 
278 	constructor(string _name, string _symbol, uint _decimals, uint total, address target) public {
279 		name = _name;
280 		symbol = _symbol;
281 		decimals = _decimals;
282 
283 		_mint(target, total);
284 	}
285 
286 	function transfer(address to, uint value) public {
287 		_transfer(msg.sender, to, value);
288 	}
289 }