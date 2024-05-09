1 pragma solidity ^0.4.21;
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
61     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
62     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
63     function transfer(address to, uint256 tokens) public returns (bool success);
64     function approve(address spender, uint256 tokens) public returns (bool success);
65     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
66 
67     event Transfer(address indexed from, address indexed to, uint256 tokens);
68     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
69 }
70 
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     constructor() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         emit OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 contract FixedSupplyToken is ERC20Interface, Owned {
98     using SafeMath for uint256;
99 
100     string public symbol;
101     string public name;
102     uint8 public decimals;
103 
104     mapping(address => uint256) balances;
105     mapping(address => mapping(address => uint256)) allowed;
106 
107     modifier onlyPayloadSize(uint size) {
108         assert(msg.data.length == size + 4);
109         _;
110     }
111 
112     constructor() public {
113         symbol = "CARPWO";
114         name = "CarblockPWOToken";
115         decimals = 18;
116         totalSupply = 1800000000 * 10**uint(decimals);
117         balances[owner] = totalSupply;
118         emit Transfer(address(0), owner, totalSupply);
119     }
120 
121     function balanceOf(address tokenOwner) public constant returns (uint256 balanceOfOwner) {
122         return balances[tokenOwner];
123     }
124 
125 
126     /**
127      * Transfer the balance from token owner's account to `to` account
128      * - Owner's account must have sufficient balance to transfer
129      * - 0 value transfers are allowed
130      */
131     function transfer(address to, uint256 tokens) onlyPayloadSize(2 * 32) public returns (bool success) {
132         balances[msg.sender] = balances[msg.sender].sub(tokens);
133         balances[to] = balances[to].add(tokens);
134         emit Transfer(msg.sender, to, tokens);
135         return true;
136     }
137 
138 
139     /**
140      * Token owner can approve for `spender` to transferFrom(...) `tokens`
141      * from the token owner's account
142      *
143      * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
144      * recommends that there are no checks for the approval double-spend attack
145      * as this should be implemented in user interfaces 
146      */
147     function approve(address spender, uint256 tokens) onlyPayloadSize(3 * 32) public returns (bool success) {
148         allowed[msg.sender][spender] = tokens;
149         emit Approval(msg.sender, spender, tokens);
150         return true;
151     }
152 
153 
154     /**
155      * Transfer `tokens` from the `from` account to the `to` account
156      *
157      * The calling account must already have sufficient tokens approve(...)-d
158      * for spending from the `from` account and
159      * - From account must have sufficient balance to transfer
160      * - Spender must have sufficient allowance to transfer
161      * - 0 value transfers are allowed
162      */
163     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
164         balances[from] = balances[from].sub(tokens);
165         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
166         balances[to] = balances[to].add(tokens);
167         emit Transfer(from, to, tokens);
168         return true;
169     }
170 
171 
172     /**
173      * Returns the amount of tokens approved by the owner that can be
174      * transferred to the spender's account
175      */
176     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
177         return allowed[tokenOwner][spender];
178     }
179 
180 
181     /**
182      * Don't accept ETH
183      */
184     function () public payable {
185         revert();
186     }
187 
188 
189     /**
190      * Owner can transfer out any accidentally sent ERC20 tokens
191      */
192     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
193         return ERC20Interface(tokenAddress).transfer(owner, tokens);
194     }
195 }