1 pragma solidity ^0.4.25;
2 
3 /**
4 * @notice Green Contract
5 * Deployed to : 0xE8E90A87392218e01C4DA185e75F4210681926Dd
6 * Symbol      : GREEN
7 * Name        : Green
8 * Total supply: 0
9 * Decimals    : 8
10 */
11 
12 contract SafeMath {
13     function safeAdd(uint a, uint b) public pure returns (uint c) {
14         c = a + b;
15         require(c >= a, "unable to safe add");
16     }
17     function safeSub(uint a, uint b) public pure returns (uint c) {
18         require(b <= a, "unable to safe subtract");
19         c = a - b;
20     }
21 }
22 
23 /**
24 * @notice ERC Token Standard #20 Interface
25 */
26 contract ERC20Interface {
27     function totalSupply() public view returns (uint);
28     function balanceOf(address tokenOwner) public view returns (uint balance);
29     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36     event Burn(address indexed from, uint256 value);
37 }
38 
39 /**
40 * @notice Contract function to receive approval and execute function in one call
41 */
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 /**
47 * @notice Owned contract
48 */
49 contract Owned {
50     address public owner;
51     address public newOwner;
52 
53     event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55     constructor () public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner, "sender is not owner");
61         _;
62     }
63 
64     function transferOwnership(address _newOwner) public onlyOwner {
65         newOwner = _newOwner;
66     }
67     function acceptOwnership() public {
68         require(msg.sender == newOwner, "sender is not new owner");
69         emit OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71         newOwner = address(0);
72     }
73 }
74 
75 /**
76 * @notice ERC20 Token, with the addition of symbol, name and decimals and assisted token transfers
77 */
78 contract Green is ERC20Interface, Owned, SafeMath {
79     string public symbol;
80     string public  name;
81     uint8 public decimals;
82     uint public _totalSupply;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87     constructor () public {
88         symbol = "GREEN";
89         name = "Green";
90         decimals = 8;
91         _totalSupply = 0;
92         balances[0xE8E90A87392218e01C4DA185e75F4210681926Dd] = _totalSupply;
93         emit Transfer(address(0), 0xE8E90A87392218e01C4DA185e75F4210681926Dd, _totalSupply);
94     }
95 
96     /**
97     * @notice Get the total supply of Green
98     */
99     function totalSupply() public view returns (uint) {
100         return _totalSupply - balances[address(0)];
101     }
102 
103     /**
104     * @notice Get the token balance for a specified address
105     *
106     * @param tokenOwner address to get balance of
107     */
108     function balanceOf(address tokenOwner) public view returns (uint balance) {
109         return balances[tokenOwner];
110     }
111 
112     /**
113     * @notice Transfer the balance from token owner's account to to account
114     *
115     * @param to transfer to this address
116     * @param tokens number of tokens to transfer
117     */
118     function transfer(address to, uint tokens) public returns (bool success) {
119         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
120         balances[to] = safeAdd(balances[to], tokens);
121         emit Transfer(msg.sender, to, tokens);
122         return true;
123     }
124 
125     /**
126     * @notice Token owner can approve for spender to transferFrom(...) tokens from the token owner's account
127     *
128     * @param spender spender address
129     * @param tokens number of tokens allowed to transfer
130     */
131     function approve(address spender, uint tokens) public returns (bool success) {
132         allowed[msg.sender][spender] = tokens;
133         emit Approval(msg.sender, spender, tokens);
134         return true;
135     }
136 
137     /**
138     * @notice Transfer tokens from one account to the other
139     *
140     * @param from transfer from this address
141     * @param to transfer to this address
142     * @param tokens amount of tokens to transfer
143     */
144     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
145         balances[from] = safeSub(balances[from], tokens);
146         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
147         balances[to] = safeAdd(balances[to], tokens);
148         emit Transfer(from, to, tokens);
149         return true;
150     }
151 
152     /**
153     * @notice Returns the amount of tokens approved by the owner that can be transferred to the spender's account
154     *
155     * @param tokenOwner token owner address
156     * @param spender spender address
157     */
158     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
159         return allowed[tokenOwner][spender];
160     }
161 
162     /**
163     * @notice Token owner can approve for spender to transferFrom(...) tokens from the token owner's account. The spender contract function receiveApproval(...) is then executed
164     *
165     * @param spender address of the spender
166     * @param tokens number of tokens
167     * @param data add extra data
168     */
169     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
170         allowed[msg.sender][spender] = tokens;
171         emit Approval(msg.sender, spender, tokens);
172         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
173         return true;
174     }
175 
176     /**
177     * @notice ETH not accepted
178     */
179     function () public payable {
180         revert("ETH not accepted");
181     }
182 
183     /**
184     * @notice Transfer ERC20 tokens that were accidentally sent
185     *
186     * @param tokenAddress Address to send token to
187     * @param tokens Number of tokens to transfer
188     */
189     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
190         return ERC20Interface(tokenAddress).transfer(owner, tokens);
191     }
192 
193     /**
194     * @notice Burn tokens belonging to the sender
195     *
196     * @param _value the amount of tokens to burn
197     */
198     function burn(uint256 _value) public returns (bool success) {
199         require(balances[msg.sender] >= _value, "insufficient sender balance");
200         balances[msg.sender] = safeSub(balances[msg.sender], _value);
201         _totalSupply = safeSub(_totalSupply, _value);
202         emit Burn(msg.sender, _value);
203         return true;
204     }
205 
206     /**
207     * @notice Mint and Distribute Green
208     *
209     * @param distAddresses The list of addresses to distribute to
210     * @param distValues The list of values to be distributed to addresses based on index
211     */
212     function distributeMinting(address[] distAddresses, uint[] distValues) public onlyOwner returns (bool success) {
213         require(msg.sender == owner, "sender is not owner");
214         require(distAddresses.length == distValues.length, "address listed and values listed are not equal lengths");
215         for (uint i = 0; i < distAddresses.length; i++) {
216             mintToken(distAddresses[i], distValues[i]);
217         }
218         return true;
219     }
220 
221     /**
222     * @notice Internal function for minting and distributing to a single address
223     *
224     * @param target Address to distribute minted tokens to
225     * @param mintAmount Amount of tokens to mint and distribute
226     */
227     function mintToken(address target, uint mintAmount) internal {
228         balances[target] = safeAdd(balances[target], mintAmount);
229         _totalSupply = safeAdd(_totalSupply, mintAmount);
230         emit Transfer(owner, target, mintAmount);
231     }
232 }