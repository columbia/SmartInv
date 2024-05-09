1 pragma solidity ^0.5.0;
2 
3 
4 // ----------------------------------------------------------------------------
5 // ERC Token Standard #20 Interface
6 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
7 // ----------------------------------------------------------------------------
8 // ERC20 interface
9 interface IERC20 {
10   function balanceOf(address _owner) external view returns (uint256);
11   function allowance(address _owner, address _spender) external view returns (uint256);
12   function transfer(address _to, uint256 _value) external returns (bool);
13   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
14   function approve(address _spender, uint256 _value) external returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract ERC20 is IERC20 {
49     using SafeMath for uint256;
50 
51     mapping (address => uint256) private _balances;
52 
53     mapping (address => mapping (address => uint256)) private _allowances;
54 
55     string public symbol;
56     string public  name;
57     uint8 public decimals;
58     uint _totalSupply;
59     
60     constructor() public {
61         symbol = "BPK";
62         name = "Bitpacket Token";
63         decimals = 18;
64         _totalSupply = 1000000 * 10**uint(decimals);
65         _balances[msg.sender] = _totalSupply;
66         emit Transfer(address(0), msg.sender, _totalSupply);
67     }
68 
69     /**
70      * @dev Total number of tokens in existence.
71      */
72     function totalSupply() public view returns (uint256) {
73         return _totalSupply;
74     }
75 
76     /**
77      * @dev Gets the balance of the specified address.
78      * @param owner The address to query the balance of.
79      * @return A uint256 representing the amount owned by the passed address.
80      */
81     function balanceOf(address owner) public view returns (uint256) {
82         return _balances[owner];
83     }
84 
85     /**
86      * @dev Function to check the amount of tokens that an owner allowed to a spender.
87      * @param owner address The address which owns the funds.
88      * @param spender address The address which will spend the funds.
89      * @return A uint256 specifying the amount of tokens still available for the spender.
90      */
91     function allowance(address owner, address spender) public view returns (uint256) {
92         return _allowances[owner][spender];
93     }
94 
95     /**
96      * @dev Transfer token to a specified address.
97      * @param to The address to transfer to.
98      * @param value The amount to be transferred.
99      */
100     function transfer(address to, uint256 value) public returns (bool) {
101         _transfer(msg.sender, to, value);
102         return true;
103     }
104 
105     /**
106      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
107      * Beware that changing an allowance with this method brings the risk that someone may use both the old
108      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
109      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
110      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111      * @param spender The address which will spend the funds.
112      * @param value The amount of tokens to be spent.
113      */
114     function approve(address spender, uint256 value) public returns (bool) {
115         _approve(msg.sender, spender, value);
116         return true;
117     }
118 
119     /**
120      * @dev Transfer tokens from one address to another.
121      * Note that while this function emits an Approval event, this is not required as per the specification,
122      * and other compliant implementations may not emit the event.
123      * @param from address The address which you want to send tokens from
124      * @param to address The address which you want to transfer to
125      * @param value uint256 the amount of tokens to be transferred
126      */
127     function transferFrom(address from, address to, uint256 value) public returns (bool) {
128         _transfer(from, to, value);
129         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
130         return true;
131     }
132 
133     /**
134      * @dev Increase the amount of tokens that an owner allowed to a spender.
135      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
136      * allowed value is better to use this function to avoid 2 calls (and wait until
137      * the first transaction is mined)
138      * From MonolithDAO Token.sol
139      * Emits an Approval event.
140      * @param spender The address which will spend the funds.
141      * @param addedValue The amount of tokens to increase the allowance by.
142      */
143     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
144         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
145         return true;
146     }
147 
148     /**
149      * @dev Decrease the amount of tokens that an owner allowed to a spender.
150      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
151      * allowed value is better to use this function to avoid 2 calls (and wait until
152      * the first transaction is mined)
153      * From MonolithDAO Token.sol
154      * Emits an Approval event.
155      * @param spender The address which will spend the funds.
156      * @param subtractedValue The amount of tokens to decrease the allowance by.
157      */
158     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
159         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
160         return true;
161     }
162 
163     /**
164      * @dev Transfer token for a specified addresses.
165      * @param from The address to transfer from.
166      * @param to The address to transfer to.
167      * @param value The amount to be transferred.
168      */
169     function _transfer(address from, address to, uint256 value) internal {
170         require(from != address(0), "ERC20: transfer from the zero address");
171         require(to != address(0), "ERC20: transfer to the zero address");
172 
173         _balances[from] = _balances[from].sub(value);
174         _balances[to] = _balances[to].add(value);
175         emit Transfer(from, to, value);
176     }
177 
178     /**
179      * @dev Internal function that mints an amount of the token and assigns it to
180      * an account. This encapsulates the modification of balances such that the
181      * proper events are emitted.
182      * @param account The account that will receive the created tokens.
183      * @param value The amount that will be created.
184      */
185     function _mint(address account, uint256 value) internal {
186         require(account != address(0), "ERC20: mint to the zero address");
187 
188         _totalSupply = _totalSupply.add(value);
189         _balances[account] = _balances[account].add(value);
190         emit Transfer(address(0), account, value);
191     }
192 
193     /**
194      * @dev Internal function that burns an amount of the token of a given
195      * account.
196      * @param account The account whose tokens will be burnt.
197      * @param value The amount that will be burnt.
198      */
199     function _burn(address account, uint256 value) internal {
200         require(account != address(0), "ERC20: burn from the zero address");
201 
202         _totalSupply = _totalSupply.sub(value);
203         _balances[account] = _balances[account].sub(value);
204         emit Transfer(account, address(0), value);
205     }
206 
207     /**
208      * @dev Approve an address to spend another addresses' tokens.
209      * @param owner The address that owns the tokens.
210      * @param spender The address that will spend the tokens.
211      * @param value The number of tokens that can be spent.
212      */
213     function _approve(address owner, address spender, uint256 value) internal {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216 
217         _allowances[owner][spender] = value;
218         emit Approval(owner, spender, value);
219     }
220 
221     /**
222      * @dev Internal function that burns an amount of the token of a given
223      * account, deducting from the sender's allowance for said account. Uses the
224      * internal burn function.
225      * Emits an Approval event (reflecting the reduced allowance).
226      * @param account The account whose tokens will be burnt.
227      * @param value The amount that will be burnt.
228      */
229     function _burnFrom(address account, uint256 value) internal {
230         _burn(account, value);
231         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
232     }
233 }