1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 interface IERC20 {
74   function totalSupply() external view returns (uint256);
75 
76   function balanceOf(address who) external view returns (uint256);
77 
78   function allowance(address owner, address spender)
79     external view returns (uint256);
80 
81   function transfer(address to, uint256 value) external payable returns (bool);
82 
83   function approve(address spender, uint256 value)
84     external returns (bool);
85 
86   function transferFrom(address from, address to, uint256 value)
87     external returns (bool);
88 
89   event Transfer(
90     address indexed from,
91     address indexed to,
92     uint256 value
93   );
94 
95   event Approval(
96     address indexed owner,
97     address indexed spender,
98     uint256 value
99   );
100 }
101 
102 
103 contract Owned {
104     address public owner;
105     address public newOwner;
106 
107     event OwnershipTransferred(address indexed _from, address indexed _to);
108 
109     constructor() public {
110         owner = msg.sender;
111     }
112 
113     modifier onlyOwner {
114         require(msg.sender == owner);
115         _;
116     }
117 
118     function transferOwnership(address _newOwner) public onlyOwner {
119         newOwner = _newOwner;
120     }
121     function acceptOwnership() public {
122         require(msg.sender == newOwner);
123         emit OwnershipTransferred(owner, newOwner);
124         owner = newOwner;
125         newOwner = address(0);
126     }
127 }
128 
129 
130 contract Mortal is Owned {
131     // This contract inherits the `onlyOwner` modifier from
132     // `owned` and applies it to the `close` function, which
133     // causes that calls to `close` only have an effect if
134     // they are made by the stored owner.
135     function close() public onlyOwner {
136         selfdestruct(owner);
137     }
138 }
139 
140 
141 contract Angelium is IERC20, Mortal {
142     using SafeMath for uint256;
143     
144     mapping (address => uint256) private _balances;
145     
146     mapping (address => mapping (address => uint256)) private _allowed;
147     
148     uint256 private _totalSupply;
149     string public symbol;
150     string public  name;
151     uint8 public decimals;
152     
153     constructor() public {
154         symbol = "ANL";
155         name = "ANGELIUM";
156         decimals = 8;
157         _totalSupply = 8400000000 * 10**uint(decimals);
158         _balances[owner] = _totalSupply;
159         emit Transfer(address(0), owner, _totalSupply);
160     }
161     
162     /**
163     * @dev Total number of tokens in existence
164     */
165     function totalSupply() public view returns (uint256) {
166         return _totalSupply;
167     }
168     
169     /**
170     * @dev Gets the balance of the specified address.
171     * @param owner The address to query the balance of.
172     * @return An uint256 representing the amount owned by the passed address.
173     */
174     function balanceOf(address owner) public view returns (uint256) {
175         return _balances[owner];
176     }
177     
178     /**
179     * @dev Function to check the amount of tokens that an owner allowed to a spender.
180     * @param owner address The address which owns the funds.
181     * @param spender address The address which will spend the funds.
182     * @return A uint256 specifying the amount of tokens still available for the spender.
183     */
184     function allowance(address owner, address spender) public view returns (uint256)
185     {
186         return _allowed[owner][spender];
187     }
188     
189     /**
190     * @dev Transfer token for a specified address
191     * @param to The address to transfer to.
192     * @param value The amount to be transferred.
193     */
194     function transfer(address to, uint256 value) public returns (bool) {
195         require(value <= _balances[msg.sender]);
196         require(to != address(0));
197         
198         _balances[msg.sender] = _balances[msg.sender].sub(value);
199         _balances[to] = _balances[to].add(value);
200         emit Transfer(msg.sender, to, value);
201         return true;
202     }
203     
204     /**
205     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206     * Beware that changing an allowance with this method brings the risk that someone may use both the old
207     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards
209     * @param spender The address which will spend the funds.
210     * @param value The amount of tokens to be spent.
211     */
212     function approve(address spender, uint256 value) public returns (bool) {
213         require(value <= _balances[msg.sender]);
214         require(spender != address(0));
215         
216         _allowed[msg.sender][spender] = value;
217         emit Approval(msg.sender, spender, value);
218         return true;
219     }
220     
221     /**
222     * @dev Transfer tokens from one address to another
223     * @param from address The address which you want to send tokens from
224     * @param to address The address which you want to transfer to
225     * @param value uint256 the amount of tokens to be transferred
226     */
227     function transferFrom(address from, address to, uint256 value) public returns (bool)
228     {
229         require(value <= _balances[from]);
230         require(value <= _allowed[from][msg.sender]);
231         require(to != address(0));
232         
233         _balances[from] = _balances[from].sub(value);
234         _balances[to] = _balances[to].add(value);
235         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
236         emit Transfer(from, to, value);
237         return true;
238     }
239   
240     // ------------------------------------------------------------------------
241     // Don't accept ETH
242     // ------------------------------------------------------------------------
243     function () public payable {
244         revert();
245     }
246 
247     // ------------------------------------------------------------------------
248     // Owner can transfer out any accidentally sent ERC20 tokens
249     // ------------------------------------------------------------------------
250     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
251         return IERC20(tokenAddress).transfer(owner, tokens);
252     }
253 }