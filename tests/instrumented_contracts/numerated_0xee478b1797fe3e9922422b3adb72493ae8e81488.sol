1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // @Project FunkeyCoin (FNK)
5 // @Creator FunkeyRyu
6 // ----------------------------------------------------------------------------
7 
8 // ----------------------------------------------------------------------------
9 // @Name SafeMath
10 // @Desc Math operations with safety checks that throw on error
11 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
12 // ----------------------------------------------------------------------------
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 // ----------------------------------------------------------------------------
58 // @Name Lockable
59 // @Desc Admin Lock
60 // ----------------------------------------------------------------------------
61 contract Lockable {
62     bool public    m_bIsLock;
63     
64     // Admin Address
65     address public m_aOwner;
66     mapping( address => bool ) public m_mLockAddress;
67 
68     event Locked(address a_aLockAddress, bool a_bStatus);
69 
70     modifier IsOwner {
71         require(m_aOwner == msg.sender);
72         _;
73     }
74 
75     modifier CheckAllLock {
76         require(!m_bIsLock);
77         _;
78     }
79 
80     modifier CheckLockAddress {
81         if (m_mLockAddress[msg.sender]) {
82             revert();
83         }
84         _;
85     }
86 
87     constructor() public {
88         m_bIsLock   = true;
89         m_aOwner    = msg.sender;
90     }
91 
92     function SetAllLock(bool a_bStatus)
93     public
94     IsOwner
95     {
96         m_bIsLock = a_bStatus;
97     }
98 
99     // Lock Address
100     function SetLockAddress(address a_aLockAddress, bool a_bStatus)
101     external
102     IsOwner
103     {
104         require(m_aOwner != a_aLockAddress);
105 
106         m_mLockAddress[a_aLockAddress] = a_bStatus;
107         
108         emit Locked(a_aLockAddress, a_bStatus);
109     }
110 }
111 // ----------------------------------------------------------------------------
112 // ERC Token Standard #20 Interface
113 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
114 // ----------------------------------------------------------------------------
115 contract ERC20Interface {
116     function totalSupply() public constant returns (uint);
117     function balanceOf(address tokenOwner) public constant returns (uint balance);
118     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
119     function transfer(address to, uint tokens) public returns (bool success);
120     function approve(address spender, uint tokens) public returns (bool success);
121     function transferFrom(address from, address to, uint tokens) public returns (bool success);
122 
123     event Transfer(address indexed from, address indexed to, uint tokens);
124     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
125 }
126 // ----------------------------------------------------------------------------
127 // @Name FunkeyCoinBase
128 // @Desc ERC20-based token
129 // ----------------------------------------------------------------------------
130 contract FunkeyCoinBase is ERC20Interface, Lockable {
131     using SafeMath for uint;
132 
133     uint                                                _totalSupply;
134     mapping(address => uint256)                         _balances;
135     mapping(address => mapping(address => uint256))     _allowed;
136 
137     function totalSupply() public constant returns (uint) {
138         return _totalSupply;
139     }
140 
141     function balanceOf(address tokenOwner) public constant returns (uint balance) {
142         return _balances[tokenOwner];
143     }
144 
145     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
146         return _allowed[tokenOwner][spender];
147     }
148 
149     function transfer(address to, uint tokens) 
150     CheckAllLock
151     CheckLockAddress
152     public returns (bool success) {
153         require( _balances[msg.sender] >= tokens);
154 
155         _balances[msg.sender] = _balances[msg.sender].sub(tokens);
156         _balances[to] = _balances[to].add(tokens);
157 
158         emit Transfer(msg.sender, to, tokens);
159         return true;
160     }
161 
162     function approve(address spender, uint tokens)
163     CheckAllLock
164     CheckLockAddress
165     public returns (bool success) {
166         _allowed[msg.sender][spender] = tokens;
167 
168         emit Approval(msg.sender, spender, tokens);
169         return true;
170     }
171 
172     function transferFrom(address from, address to, uint tokens)
173     CheckAllLock
174     CheckLockAddress
175     public returns (bool success) {
176         require(tokens <= _balances[from]);
177         require(tokens <= _allowed[from][msg.sender]);
178         
179         _balances[from] = _balances[from].sub(tokens);
180         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);
181         _balances[to] = _balances[to].add(tokens);
182 
183         emit Transfer(from, to, tokens);
184         return true;
185     }
186 }
187 // ----------------------------------------------------------------------------
188 // @Name FunkeyCoin (FNK)
189 // @Desc Funkey Admin Ryu
190 // ----------------------------------------------------------------------------
191 contract FunkeyCoin is FunkeyCoinBase {
192     string  public   name;
193     uint8   public   decimals;
194     string  public   symbol;
195 
196     event EventBurnCoin(address a_burnAddress, uint a_amount);
197 
198     constructor (uint a_totalSupply, string a_tokenName, string a_tokenSymbol, uint8 a_decimals) public {
199         m_aOwner = msg.sender;
200         
201         _totalSupply = a_totalSupply;
202         _balances[msg.sender] = a_totalSupply;
203 
204         name = a_tokenName;
205         symbol = a_tokenSymbol;
206         decimals = a_decimals;
207     }
208 
209     function burnCoin(uint a_coinAmount)
210     external
211     IsOwner
212     {
213         require(_balances[msg.sender] >= a_coinAmount);
214 
215         _balances[msg.sender] = _balances[msg.sender].sub(a_coinAmount);
216         _totalSupply = _totalSupply.sub(a_coinAmount);
217 
218         emit EventBurnCoin(msg.sender, a_coinAmount);
219     }
220 
221     // Allocate tokens to the users
222     function allocateCoins(address[] a_receiver, uint[] a_values)
223     external
224     IsOwner{
225         require(a_receiver.length == a_values.length);
226 
227         uint    receiverLength = a_receiver.length;
228         address to;
229         uint    value;
230 
231         for(uint ui = 0; ui < receiverLength; ui++){
232             to      = a_receiver[ui];
233             value   = a_values[ui].mul(10**uint(decimals));
234 
235             require(_balances[msg.sender] >= value);
236 
237             _balances[msg.sender] = _balances[msg.sender].sub(value);
238             _balances[to] = _balances[to].add(value);
239         }
240     }
241 }