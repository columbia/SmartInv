1 pragma solidity 0.5.7;
2 
3 
4 library SafeMath 
5 {
6     /**
7     * @dev Multiplies two unsigned integers, reverts on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11         // benefit is lost if 'b' is also tested.
12         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
13         if (a == 0) {
14             return 0;
15         }
16 
17         uint256 c = a * b;
18         require(c / a == b);
19 
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // Solidity only automatically asserts when dividing by 0
28         require(b > 0);
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31 
32         return c;
33     }
34 
35     /**
36     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a);
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     /**
46     * @dev Adds two unsigned integers, reverts on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a);
51 
52         return c;
53     }
54 }
55 
56 
57 /******************************************/
58 /*       nerveShares starts here          */
59 /******************************************/
60 
61 contract nerveShares {
62 
63     string name;
64     string public symbol;
65     uint8 public decimals;
66     uint256 public totalSupply;
67     uint256 public totalDividends;
68     uint256 internal constant MAX_UINT = 2**256 - 1;
69 
70     mapping (address => uint) public balanceOf;
71     mapping (address => mapping (address => uint)) allowance;
72     mapping (address => uint256) internal lastDividends;
73     mapping (address => bool) public tradables;
74     
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77     event Claim(address indexed _to, uint256 value);
78 
79     using SafeMath for uint256;
80 
81     constructor() public
82     {
83         decimals = 18;                              // decimals  
84         totalSupply = 1000000*10**18;               // initialSupply
85         name = "Nerve";                             // Set the name for display purposes
86         symbol = "NRV";                             // Set the symbol for display purposes
87 
88         balanceOf[msg.sender] = totalSupply;
89         emit Transfer(address(0), msg.sender, totalSupply);
90     }
91 
92     /**
93     * @dev Get the dividends of a user. Take prior payoffs into account.
94     * @param account The address of the user.
95     */
96     function dividendBalanceOf(address account) public view returns (uint256) 
97     {
98         uint256 newDividends = totalDividends.sub(lastDividends[account]);
99         uint256 product = balanceOf[account].mul(newDividends);
100         return product.div(totalSupply);
101     }   
102 
103     /**
104     * @dev Get the dividends of a user. Take prior payoffs into account.
105     * @param account The address of the user.
106     */
107     function internalDividendBalanceOf(address account, uint256 tempLastDividends) internal view returns (uint256) 
108     {
109         uint256 newDividends = totalDividends.sub(tempLastDividends);
110         uint256 product = balanceOf[account].mul(newDividends);
111         return product.div(totalSupply);
112     }   
113 
114     /**
115     * @dev Claim dividends. Restrict dividends to new income.
116     */
117     function claimDividend() external 
118     {
119         uint256 tempLastDividends = lastDividends[msg.sender];
120         lastDividends[msg.sender] = totalDividends;
121 
122         uint256 owing = internalDividendBalanceOf(msg.sender, tempLastDividends);
123         require(owing > 0, "No dividends to claim.");
124 
125         msg.sender.transfer(owing);
126         
127         emit Claim(msg.sender, owing);
128     }
129 
130     /**
131     * @dev Claim dividends internally. Get called on addresses opened for trade.
132     */
133     function internalClaimDividend(address payable from) internal 
134     {
135         uint256 owing = dividendBalanceOf(from);
136         if (owing > 0) {
137 
138         lastDividends[from] = totalDividends;
139         from.transfer(owing);
140         }
141     }
142 
143     /**
144     * @dev Open or close sending address for trade.
145     * @param allow True -> open
146     */
147     function allowTrade(bool allow) external
148     {
149         tradables[msg.sender] = allow;
150     }
151 
152     /**
153     * @dev Transfer tokens
154     * @param to The address of the recipient
155     * @param value the amount to send
156     */
157     function transfer(address payable to, uint256 value) external returns(bool success)
158     {
159         _transfer(msg.sender, to, value);
160         return true;
161     }
162 
163     /**
164     * @dev Transfer tokens. Make sure that both participants have no open dividends left.
165     * @param to The address to transfer to.
166     * @param value The amount to be transferred.
167     */
168     function _transfer(address payable from, address payable to, uint256 value) internal
169     {   
170         require(value > 0, "Transferred value has to be grater than 0.");
171         require(to != address(0), "0x00 address not allowed.");
172         require(value <= balanceOf[from], "Not enough funds on sender address.");
173         require(balanceOf[to] + value >= balanceOf[to], "Overflow protection.");
174  
175         uint256 fromOwing = dividendBalanceOf(from);
176         uint256 toOwing = dividendBalanceOf(to);
177 
178         if (tradables[from] == true && (tradables[to] == true || toOwing == 0)) 
179         {
180 
181             internalClaimDividend(from);
182             internalClaimDividend(to);
183         } else {
184             
185             require(fromOwing == 0 && toOwing == 0, "Unclaimed dividends on sender and/or receiver");
186         }
187         
188         balanceOf[from] = balanceOf[from].sub(value);
189         balanceOf[to] = balanceOf[to].add(value);
190  
191         lastDividends[to] = lastDividends[from];    // In case of new account, set lastDividends of receiver to totalDividends.
192  
193         emit Transfer(from, to, value);
194     }
195 
196     /**
197     * @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
198     * @param from Address to transfer from.
199     * @param to Address to transfer to.
200     * @param value Amount to transfer.
201     * @return Success of transfer.
202     */
203     function transferFrom(address payable from, address payable to, uint value) external returns (bool success)
204     {
205         uint256 allowanceTemp = allowance[from][msg.sender];
206         
207         require(allowanceTemp >= value, "Funds not approved."); 
208         require(balanceOf[from] >= value, "Not enough funds on sender address.");
209         require(balanceOf[to] + value >= balanceOf[to], "Overflow protection.");
210 
211         if (allowanceTemp < MAX_UINT) 
212         {
213             allowance[from][msg.sender] -= value;
214         }
215         
216         _transfer(from, to, value);
217 
218         return true;
219     }
220 
221     /**
222     * @dev `msg.sender` approves `addr` to spend `value` tokens.
223     * @param spender The address of the account able to transfer the tokens.
224     * @param value The amount of wei to be approved for transfer.
225     */
226     function approve(address spender, uint value) external returns (bool) 
227     {
228         allowance[msg.sender][spender] = value;
229         emit Approval(msg.sender, spender, value);
230         return true;
231     }
232 
233     /**
234     * @dev Set unlimited allowance for other address
235     * @param target The address authorized to spend
236     */   
237     function giveAccess(address target) external
238     {
239         require(target != address(0), "0x00 address not allowed.");
240         allowance[msg.sender][target] = MAX_UINT;
241         emit Approval(msg.sender, target, MAX_UINT);
242     }
243 
244     /**
245     * @dev Set allowance for other address to 0
246     * @param target The address authorized to spend
247     */   
248     function revokeAccess(address target) external
249     {
250         require(target != address(0), "0x00 address not allowed.");
251         allowance[msg.sender][target] = 0;
252     }
253     
254     /**
255     * @dev Get contract ETH amount. 
256     */ 
257     function contractBalance() external view returns(uint256 amount)
258     {
259         return (address(this).balance);
260     }
261     
262     /**
263     * @dev Receive ETH from CONTRACT and increase the total historic amount of dividend eligible earnings.
264     */
265     function receiveETH() external payable
266     {
267         totalDividends = totalDividends.add(msg.value);
268     }
269     
270     /**
271     * @dev Receive ETH and increase the total historic amount of dividend eligible earnings.
272     */
273     function () external payable 
274     {
275         totalDividends = totalDividends.add(msg.value);
276     }
277     
278 }