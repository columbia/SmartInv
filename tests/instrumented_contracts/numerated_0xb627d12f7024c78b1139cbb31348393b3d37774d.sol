1 pragma solidity 0.5.7;
2 
3 /**
4  * @title SafeMath 
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
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
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
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
38      * @dev Subtracts two unsigned integers, reverts on underflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 }
57 /**
58  * @title Token
59  * @dev Implementation of the basic standard token.
60  * https://eips.ethereum.org/EIPS/eip-20
61  */
62 contract Token {
63     using SafeMath for uint256;
64     
65     string public constant name = "Game Currency Coin";
66     string public constant symbol = "GCC";
67     uint8 public constant decimals = 8;
68 
69     uint256 private constant INITIAL_SUPPLY = 1000000000;
70     uint256 public constant totalSupply = INITIAL_SUPPLY * 10 ** uint256(decimals);
71 
72     address public constant wallet = 0x0b17d4D3b09A769304157bA2d6dec0FC689681f2;
73 
74     mapping (address => uint256) internal _balances;
75     mapping (address => mapping (address => uint256)) internal _allowed;
76 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 
80     constructor() public {
81         _balances[wallet] = totalSupply;
82         emit Transfer(address(0), wallet, totalSupply);
83     }
84 
85     /**
86      * @dev Gets the balance of the specified address.
87      * @param owner The address to query the balance of.
88      * @return A uint256 representing the amount owned by the passed address.
89      */
90     function balanceOf(address owner) public view returns (uint256) {
91         return _balances[owner];
92     }
93 
94     /**
95      * @dev Function to check the amount of tokens that an owner allowed to a spender.
96      * @param owner address The address which owns the funds.
97      * @param spender address The address which will spend the funds.
98      * @return A uint256 specifying the amount of tokens still available for the spender.
99      */
100     function allowance(address owner, address spender) public view returns (uint256) {
101         return _allowed[owner][spender];
102     }
103 
104     /**
105      * @dev Transfer token to a specified address.
106      * @param to The address to transfer to.
107      * @param value The amount to be transferred.
108      */
109     function transfer(address to, uint256 value) public returns (bool) {
110         _transfer(msg.sender, to, value);
111         return true;
112     }
113 
114     /**
115      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
116      * Beware that changing an allowance with this method brings the risk that someone may use both the old
117      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
118      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
119      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120      * @param spender The address which will spend the funds.
121      * @param value The amount of tokens to be spent.
122      */
123     function approve(address spender, uint256 value) public returns (bool) {
124         _approve(msg.sender, spender, value);
125         return true;
126     }
127 
128     /**
129      * @dev Transfer tokens from one address to another.
130      * Note that while this function emits an Approval event, this is not required as per the specification,
131      * and other compliant implementations may not emit the event.
132      * @param from address The address which you want to send tokens from
133      * @param to address The address which you want to transfer to
134      * @param value uint256 the amount of tokens to be transferred
135      */
136     function transferFrom(address from, address to, uint256 value) public returns (bool) {
137         _transfer(from, to, value);
138         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
139         return true;
140     }
141 
142     /**
143      * @dev Increase the amount of tokens that an owner allowed to a spender.
144      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
145      * allowed value is better to use this function to avoid 2 calls (and wait until
146      * the first transaction is mined)
147      * From MonolithDAO Token.sol
148      * Emits an Approval event.
149      * @param spender The address which will spend the funds.
150      * @param addedValue The amount of tokens to increase the allowance by.
151      */
152     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
153         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
154         return true;
155     }
156 
157     /**
158      * @dev Decrease the amount of tokens that an owner allowed to a spender.
159      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
160      * allowed value is better to use this function to avoid 2 calls (and wait until
161      * the first transaction is mined)
162      * From MonolithDAO Token.sol
163      * Emits an Approval event.
164      * @param spender The address which will spend the funds.
165      * @param subtractedValue The amount of tokens to decrease the allowance by.
166      */
167     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
168         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
169         return true;
170     }
171 
172     /**
173      * @dev Transfer token for a specified address.
174      * @param from The address to transfer from.
175      * @param to The address to transfer to.
176      * @param value The amount to be transferred.
177      */
178     function _transfer(address from, address to, uint256 value) internal {
179         require(to != address(0), "Cannot transfer to zero address");
180 
181         _balances[from] = _balances[from].sub(value);
182         _balances[to] = _balances[to].add(value);
183         emit Transfer(from, to, value);
184     }
185 
186     /**
187      * @dev Approve an address to spend another addresses' tokens.
188      * @param owner The address that owns the tokens.
189      * @param spender The address that will spend the tokens.
190      * @param value The number of tokens that can be spent.
191      */
192     function _approve(address owner, address spender, uint256 value) internal {
193         require(spender != address(0), "Cannot approve to the zero address");
194         require(owner != address(0), "Setter cannot be a zero address");
195 
196         _allowed[owner][spender] = value;
197         emit Approval(owner, spender, value);
198     }
199 }