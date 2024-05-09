1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, reverts on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15 
16     uint256 c = a * b;
17     require(c / a == b);
18 
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     require(b > 0); 
24     uint256 c = a / b;
25 
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b <= a);
31     uint256 c = a - b;
32 
33     return c;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     require(c >= a);
39 
40     return c;
41   }
42 
43   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
44     require(b != 0);
45     return a % b;
46   }
47 }
48 
49 /**
50  * @title Roles
51  */
52 library Roles {
53   struct Role {
54     mapping (address => bool) bearer;
55   }
56 
57   function add(Role storage role, address account) internal {
58     require(account != address(0));
59     role.bearer[account] = true;
60   }
61 
62   function remove(Role storage role, address account) internal {
63     require(account != address(0));
64     role.bearer[account] = false;
65   }
66 
67   function has(Role storage role, address account)
68   internal
69   view
70   returns (bool)
71   {
72     require(account != address(0));
73     return role.bearer[account];
74   }
75 }
76 
77 /**
78  * @title ERC20 interface
79  */
80 interface ERC20 {
81   function totalSupply() external view returns (uint256);
82 
83   function balanceOf(address who) external view returns (uint256);
84 
85   function allowance(address owner, address spender)
86   external view returns (uint256);
87 
88   function transfer(address to, uint256 value) external returns (bool);
89 
90   function approve(address spender, uint256 value)
91   external returns (bool);
92 
93   event Transfer(
94     address indexed from,
95     address indexed to,
96     uint256 value
97   );
98 
99   event Approval(
100     address indexed owner,
101     address indexed spender,
102     uint256 value
103   );
104 }
105 
106 
107 
108 /**
109  * @title TokenBasic ERC20 token
110  */
111 contract TokenBasic is ERC20 {
112   using SafeMath for uint256;
113   mapping (address => uint256) private _balances;
114   mapping (address => mapping (address => uint256)) private _allowed;
115   uint256 private _totalSupply;
116 
117   function totalSupply() public view returns (uint256) {
118     return _totalSupply;
119   }
120 
121   function balanceOf(address owner) public view returns (uint256) {
122     return _balances[owner];
123   }
124 
125   function allowance(
126     address owner,
127     address spender
128   )
129   public
130   view
131   returns (uint256)
132   {
133     return _allowed[owner][spender];
134   }
135 
136   function transfer(address to, uint256 value) public returns (bool) {
137     _transfer(msg.sender, to, value);
138     return true;
139   }
140 
141   function approve(address spender, uint256 value) public returns (bool) {
142     require(spender != address(0));
143 
144     _allowed[msg.sender][spender] = value;
145     emit Approval(msg.sender, spender, value);
146     return true;
147   }
148 
149   function increaseAllowance(
150     address spender,
151     uint256 addedValue
152   )
153   public
154   returns (bool)
155   {
156     require(spender != address(0));
157 
158     _allowed[msg.sender][spender] = (
159     _allowed[msg.sender][spender].add(addedValue));
160     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
161     return true;
162   }
163 
164   function decreaseAllowance(
165     address spender,
166     uint256 subtractedValue
167   )
168   public
169   returns (bool)
170   {
171     require(spender != address(0));
172 
173     _allowed[msg.sender][spender] = (
174     _allowed[msg.sender][spender].sub(subtractedValue));
175     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
176     return true;
177   }
178 
179   function _transfer(address from, address to, uint256 value) internal {
180     require(value <= _balances[from]);
181     require(to != address(0));
182 
183     _balances[from] = _balances[from].sub(value);
184     _balances[to] = _balances[to].add(value);
185     emit Transfer(from, to, value);
186   }
187 
188   function _mint(address account, uint256 value) internal {
189     require(account != 0);
190     _totalSupply = _totalSupply.add(value);
191     _balances[account] = _balances[account].add(value);
192     emit Transfer(address(0), account, value);
193   }
194 
195   function _burn(address account, uint256 value) internal {
196     require(account != 0);
197     require(value <= _balances[account]);
198 
199     _totalSupply = _totalSupply.sub(value);
200     _balances[account] = _balances[account].sub(value);
201     emit Transfer(account, address(0), value);
202   }
203 
204   function _burnFrom(address account, uint256 value) internal {
205     require(value <= _allowed[account][msg.sender]);
206 
207     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
208       value);
209     _burn(account, value);
210   }
211 }
212 
213 contract MinterRole {
214   using Roles for Roles.Role;
215 
216   event MinterAdded(address indexed account);
217   event MinterRemoved(address indexed account);
218 
219   Roles.Role private minters;
220 
221   constructor() public {
222     _addMinter(msg.sender);
223   }
224 
225   modifier onlyMinter() {
226     require(isMinter(msg.sender));
227     _;
228   }
229 
230   function isMinter(address account) public view returns (bool) {
231     return minters.has(account);
232   }
233 
234   function addMinter(address account) public onlyMinter {
235     _addMinter(account);
236   }
237 
238   function renounceMinter() public {
239     _removeMinter(msg.sender);
240   }
241 
242   function _addMinter(address account) internal {
243     minters.add(account);
244     emit MinterAdded(account);
245   }
246 
247   function _removeMinter(address account) internal {
248     minters.remove(account);
249     emit MinterRemoved(account);
250   }
251 }
252 
253 
254 /**
255  * @title Mintable
256  */
257 contract Mintable is TokenBasic, MinterRole {
258   function mint(
259     address to,
260     uint256 value
261   )
262   public
263   onlyMinter
264   returns (bool)
265   {
266     _mint(to, value);
267     return true;
268   }
269 }
270 
271 
272 /**
273  * @title Burnable Token
274  */
275 contract Burnable is TokenBasic {
276 
277   function burn(uint256 value) public {
278     _burn(msg.sender, value);
279   }
280 
281   function burnFrom(address from, uint256 value) public {
282     _burnFrom(from, value);
283   }
284 }
285 
286 
287 
288 /**
289  * @title NTON
290  */
291 contract NTON is Burnable, Mintable {
292 
293   string public constant name = "NTON";
294   string public constant symbol = "NTON";
295   uint8 public constant decimals = 18;
296   uint256 public constant INITIAL_SUPPLY = 3500000000 * (10 ** uint256(decimals));
297 
298   constructor(address _owner) public {
299     _mint(_owner, INITIAL_SUPPLY);
300   }
301 
302 }