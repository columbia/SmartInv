1 pragma solidity 0.4.24;
2 
3 /**
4  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b > 0);
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 /**
55  * ERC Token Standard #20 Interface
56  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
57  */
58 contract ERC20Interface {
59     uint256 public totalSupply;
60 
61     function balanceOf(address tokenOwner) public view returns (uint256 balance);
62     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
63     function transfer(address to, uint256 tokens) public returns (bool success);
64     function approve(address spender, uint256 tokens) public returns (bool success);
65     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
66 
67     event Transfer(address indexed from, address indexed to, uint256 tokens);
68     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
69 }
70 
71 contract FixedSupplyToken is ERC20Interface {
72     using SafeMath for uint256;
73 
74     string public symbol;
75     string public name;
76     uint8 public decimals;
77 
78     mapping(address => uint256) public balances;
79     mapping(address => mapping(address => uint256)) public allowed;
80 
81     modifier onlyPayloadSize(uint size) {
82         assert(msg.data.length == size + 4);
83         _;
84     }
85 
86     constructor() public {
87         symbol = "MSH";
88         name = "MinSheng Health";
89         decimals = 18;
90         totalSupply = 10000000000 * 10**uint(decimals);
91         balances[msg.sender] = totalSupply;
92         emit Transfer(address(0), msg.sender, totalSupply);
93     }
94 
95 
96     /**
97      * Get the token balance for account `tokenOwner`
98      */
99     function balanceOf(address tokenOwner) public view returns (uint256 balanceOfOwner) {
100         return balances[tokenOwner];
101     }
102 
103 
104     /**
105      * Transfer the balance from token owner's account to `to` account
106      * - Owner's account must have sufficient balance to transfer
107      * - 0 value transfers are allowed
108      */
109     function transfer(address to, uint256 tokens) onlyPayloadSize(2 * 32) public returns (bool success) {
110         require(to != address(0));
111         require(tokens <= balances[msg.sender]);
112 
113         balances[msg.sender] = balances[msg.sender].sub(tokens);
114         balances[to] = balances[to].add(tokens);
115 
116         emit Transfer(msg.sender, to, tokens);
117 
118         return true;
119     }
120 
121 
122     /**
123      * Token owner can approve for `spender` to transferFrom(...) `tokens`
124      * from the token owner's account
125      *
126      * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
127      * recommends that there are no checks for the approval double-spend attack
128      * as this should be implemented in user interfaces
129      */
130     function approve(address spender, uint256 tokens) public returns (bool success) {
131         allowed[msg.sender][spender] = tokens;
132         emit Approval(msg.sender, spender, tokens);
133         return true;
134     }
135 
136 
137     /**
138      * Transfer `tokens` from the `from` account to the `to` account
139      *
140      * The calling account must already have sufficient tokens approve(...)-d
141      * for spending from the `from` account and
142      * - From account must have sufficient balance to transfer
143      * - Spender must have sufficient allowance to transfer
144      * - 0 value transfers are allowed
145      */
146     function transferFrom(address from, address to, uint256 tokens) onlyPayloadSize(3 * 32) public returns (bool success) {
147         require(to != address(0));
148         require(tokens <= balances[from]);
149         require(tokens <= allowed[from][msg.sender]);
150 
151         balances[from] = balances[from].sub(tokens);
152         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
153         balances[to] = balances[to].add(tokens);
154 
155         emit Transfer(from, to, tokens);
156 
157         return true;
158     }
159 
160 
161     /**
162      * Returns the amount of tokens approved by the owner that can be
163      * transferred to the spender's account
164      */
165     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
166         return allowed[tokenOwner][spender];
167     }
168 
169 
170     /**
171      * Don't accept ETH
172      */
173     function () public payable {
174         revert();
175     }
176 }