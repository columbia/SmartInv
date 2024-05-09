1 pragma solidity 0.5.9;
2 
3 /**
4  * @title SafeMath 
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplie two unsigned integers, revert on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, revert on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtract two unsigned integers, revert on underflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Add two unsigned integers, revert on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 
58 
59 /**
60  * @title ERC20 interface
61  * @dev See https://eips.ethereum.org/EIPS/eip-20
62  */
63 interface IERC20 {
64     function transfer(address to, uint256 value) external returns (bool); 
65 
66     function approve(address spender, uint256 value) external returns (bool); 
67 
68     function transferFrom(address from, address to, uint256 value) external returns (bool); 
69 
70     function totalSupply() external view returns (uint256); 
71 
72     function balanceOf(address who) external view returns (uint256);
73 
74     function allowance(address owner, address spender) external view returns (uint256); 
75 
76     event Transfer(address indexed from, address indexed to, uint256 value); 
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value); 
79 }
80 
81 
82 /**
83  * @title Standard ERC20 token
84  * @dev Implementation of the basic standard token.
85  */
86 contract StandardToken is IERC20 {
87     using SafeMath for uint256; 
88     
89     mapping (address => uint256) internal _balances; 
90     mapping (address => mapping (address => uint256)) internal _allowed; 
91     
92     uint256 internal _totalSupply; 
93     
94     /**
95      * @dev Total number of tokens in existence.
96      */
97     function totalSupply() public view returns (uint256) {
98         return _totalSupply; 
99     }
100 
101     /**
102      * @dev Get the balance of the specified address.
103      * @param owner The address to query the balance of.
104      * @return A uint256 representing the amount owned by the passed address.
105      */
106     function balanceOf(address owner) public view returns (uint256) {
107         return _balances[owner];
108     }
109 
110     /**
111      * @dev Function to check the amount of tokens that an owner allowed to a spender.
112      * @param owner The address which owns the funds.
113      * @param spender The address which will spend the funds.
114      * @return A uint256 specifying the amount of tokens still available for the spender.
115      */
116     function allowance(address owner, address spender) public view returns (uint256) {
117         return _allowed[owner][spender];
118     }
119 
120     /**
121      * @dev Transfer tokens to a specified address.
122      * @param to The address to transfer to.
123      * @param value The amount to be transferred.
124      */
125     function transfer(address to, uint256 value) public returns (bool) {
126         _transfer(msg.sender, to, value);
127         return true;
128     }
129 
130     /**
131      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      * Beware that changing an allowance with this method brings the risk that someone may use both the old
133      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      * @param spender The address which will spend the funds.
137      * @param value The amount of tokens to be spent.
138      */
139     function approve(address spender, uint256 value) public returns (bool) {
140         _approve(msg.sender, spender, value); 
141         return true;
142     }
143 
144     /**
145      * @dev Transfer tokens from one address to another.
146      * Note that while this function emits an Approval event, this is not required as per the specification,
147      * and other compliant implementations may not emit the event.
148      * @param from The address which you want to send tokens from.
149      * @param to The address which you want to transfer to.
150      * @param value The amount of tokens to be transferred.
151      */
152     function transferFrom(address from, address to, uint256 value) public returns (bool) {
153         _transfer(from, to, value); 
154         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value)); 
155         return true;
156     }
157 
158     /**
159      * @dev Increase the amount of tokens that an owner allowed to a spender.
160      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
161      * allowed value is better to use this function to avoid 2 calls (and wait until
162      * the first transaction is mined)
163      * From MonolithDAO Token.sol
164      * Emits an Approval event.
165      * @param spender The address which will spend the funds.
166      * @param addedValue The amount of tokens to increase the allowance by.
167      */
168     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
169         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue)); 
170         return true;
171     }
172 
173     /**
174      * @dev Decrease the amount of tokens that an owner allowed to a spender.
175      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
176      * allowed value is better to use this function to avoid 2 calls (and wait until
177      * the first transaction is mined)
178      * From MonolithDAO Token.sol
179      * Emits an Approval event.
180      * @param spender The address which will spend the funds.
181      * @param subtractedValue The amount of tokens to decrease the allowance by.
182      */
183     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
184         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
185         return true;
186     }
187 
188     /**
189      * @dev Transfer tokens for a specified address.
190      * @param from The address to transfer from.
191      * @param to The address to transfer to.
192      * @param value The amount to be transferred.
193      */
194     function _transfer(address from, address to, uint256 value) internal {
195         require(to != address(0), "Cannot transfer to the zero address"); 
196         _balances[from] = _balances[from].sub(value); 
197         _balances[to] = _balances[to].add(value); 
198         emit Transfer(from, to, value); 
199     }
200 
201     /**
202      * @dev Approve an address to spend another addresses' tokens.
203      * @param owner The address that owns the tokens.
204      * @param spender The address that will spend the tokens.
205      * @param value The number of tokens that can be spent.
206      */
207     function _approve(address owner, address spender, uint256 value) internal {
208         require(spender != address(0), "Cannot approve to the zero address"); 
209         require(owner != address(0), "Setter cannot be the zero address"); 
210 	    _allowed[owner][spender] = value;
211         emit Approval(owner, spender, value); 
212     }
213 }
214 
215 
216 contract GABAToken is StandardToken {
217     string public constant name = "Global Alliance of Cultural and Art Block Chains";  
218     string public constant symbol = "GABA";  
219     uint8 public constant decimals = 18;
220     uint256 internal constant INIT_TOTALSUPPLY = 210000000; 
221     address public constant tokenWallet = 0x94A1aB2335577C80ef79f4E4D94BebB49B6a5285;
222     
223     /**
224      * @dev Constructor, initialize the basic information of contract.
225      */
226     constructor() public {
227         _totalSupply = INIT_TOTALSUPPLY * 10 ** uint256(decimals);
228         _balances[tokenWallet] = _totalSupply;
229         emit Transfer(address(0), tokenWallet, _totalSupply);
230     }
231 }