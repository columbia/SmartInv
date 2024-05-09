1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     
10     address public owner;
11 
12     /**
13     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14     * account.
15     */
16     function Ownable() public {
17         owner = msg.sender;
18     }
19     
20     /**
21     * @dev Throws if called by any account other than the owner.
22     */
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27 
28 }
29 
30 /**
31  * @title TenTimesToken
32  * @dev An ERC20 token which doubles the balance each 2 million blocks.
33  */
34 contract TenTimesToken is Ownable {
35     
36     uint256 public totalSupply;
37     mapping(address => uint256) startBalances;
38     mapping(address => mapping(address => uint256)) allowed;
39     mapping(address => uint256) startBlocks;
40     
41     string public constant name = "Ten Times";
42     string public constant symbol = "TENT";
43     uint32 public constant decimals = 10;
44 
45     function TenTimesToken() public {
46         totalSupply = 1000000 * 10**uint256(decimals);
47         startBalances[owner] = totalSupply;
48         startBlocks[owner] = block.number;
49         Transfer(address(0), owner, totalSupply);
50     }
51 
52     /**
53      * @dev Computes `k * (1+1/q) ^ N`, with precision `p`. The higher
54      * the precision, the higher the gas cost. It should be
55      * something around the log of `n`. When `p == n`, the
56      * precision is absolute (sans possible integer overflows). <edit: NOT true, see comments>
57      * Much smaller values are sufficient to get a great approximation.
58      * from https://ethereum.stackexchange.com/questions/10425/is-there-any-efficient-way-to-compute-the-exponentiation-of-a-fraction-and-an-in
59      */
60     function fracExp(uint256 k, uint256 q, uint256 n, uint256 p) pure public returns (uint256) {
61         uint256 s = 0;
62         uint256 N = 1;
63         uint256 B = 1;
64         for (uint256 i = 0; i < p; ++i) {
65             s += k * N / B / (q**i);
66             N = N * (n-i);
67             B = B * (i+1);
68         }
69         return s;
70     }
71 
72 
73     /**
74      * @dev Computes the compound interest for an account since the block stored in startBlock
75      * about factor 10 for 2 million blocks.
76      */
77     function compoundInterest(address tokenOwner) view public returns (uint256) {
78         require(startBlocks[tokenOwner] > 0);
79         uint256 start = startBlocks[tokenOwner];
80         uint256 current = block.number;
81         uint256 blockCount = current - start;
82         uint256 balance = startBalances[tokenOwner];
83         return fracExp(balance, 867598, blockCount, 8) - balance;
84     }
85 
86 
87     /**
88      * @dev Get the token balance for account 'tokenOwner'
89      */
90     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
91         return startBalances[tokenOwner] + compoundInterest(tokenOwner);
92     }
93 
94     
95     /**
96      * @dev Add the compound interest to the startBalance, update the start block,
97      * and update totalSupply
98      */
99     function updateBalance(address tokenOwner) private {
100         if (startBlocks[tokenOwner] == 0) {
101             startBlocks[tokenOwner] = block.number;
102         }
103         uint256 ci = compoundInterest(tokenOwner);
104         startBalances[tokenOwner] = startBalances[tokenOwner] + ci;
105         totalSupply = totalSupply + ci;
106         startBlocks[tokenOwner] = block.number;
107     }
108     
109 
110     /**
111      * @dev Transfer the balance from token owner's account to `to` account
112      * - Owner's account must have sufficient balance to transfer
113      * - 0 value transfers are allowed
114      */
115     function transfer(address to, uint256 tokens) public returns (bool) {
116         updateBalance(msg.sender);
117         updateBalance(to);
118         require(tokens <= startBalances[msg.sender]);
119 
120         startBalances[msg.sender] = startBalances[msg.sender] - tokens;
121         startBalances[to] = startBalances[to] + tokens;
122         Transfer(msg.sender, to, tokens);
123         return true;
124     }
125 
126 
127     /**
128      * @dev Transfer `tokens` from the `from` account to the `to` account
129      * 
130      * The calling account must already have sufficient tokens approve(...)-d
131      * for spending from the `from` account and
132      * - From account must have sufficient balance to transfer
133      * - Spender must have sufficient allowance to transfer
134      * - 0 value transfers are allowed
135      */
136     function transferFrom(address from, address to, uint256 tokens) public returns (bool) {
137         updateBalance(from);
138         updateBalance(to);
139         require(tokens <= startBalances[from]);
140 
141         startBalances[from] = startBalances[from] - tokens;
142         allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
143         startBalances[to] = startBalances[to] + tokens;
144         Transfer(from, to, tokens);
145         return true;
146     }
147 
148     /**
149      * @dev Allow `spender` to withdraw from your account, multiple times, up to the 'tokens' amount.
150      * If this function is called again it overwrites the current allowance with 'tokens'.
151      */
152     function approve(address spender, uint256 tokens) public returns (bool) {
153         allowed[msg.sender][spender] = tokens;
154         Approval(msg.sender, spender, tokens);
155         return true;
156     }
157 
158     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
159         return allowed[tokenOwner][spender];
160     }
161    
162     event Transfer(address indexed from, address indexed to, uint256 tokens);
163 
164     event Approval(address indexed owner, address indexed spender, uint256 tokens);
165 
166 }