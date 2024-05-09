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
63     string public name;
64     string public symbol;
65     uint8 public decimals;
66     uint256 public totalSupply;
67     uint256 public totalDividends;
68     uint256 internal constant MAX_UINT = 2**256 - 1;
69 
70     mapping (address => uint) public balanceOf;
71     mapping (address => mapping (address => uint)) public allowance;
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
121         uint256 owing = internalDividendBalanceOf(msg.sender, tempLastDividends);
122 
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
135         uint256 tempLastDividends = lastDividends[from];
136         lastDividends[from] = totalDividends;
137         uint256 owing = internalDividendBalanceOf(from, tempLastDividends);
138 
139         if (owing > 0) {
140 
141         from.transfer(owing);
142 
143         emit Claim(from, owing);
144         }
145     }
146 
147     /**
148     * @dev Open or close sending address for trade.
149     * @param allow True -> open
150     */
151     function allowTrade(bool allow) external
152     {
153         tradables[msg.sender] = allow;
154     }
155 
156     /**
157     * @dev Transfer tokens
158     * @param to The address of the recipient
159     * @param value the amount to send
160     */
161     function transfer(address payable to, uint256 value) external returns(bool success)
162     {
163         _transfer(msg.sender, to, value);
164         return true;
165     }
166 
167     /**
168     * @dev Transfer tokens. Make sure that both participants have no open dividends left.
169     * @param to The address to transfer to.
170     * @param value The amount to be transferred.
171     */
172     function _transfer(address payable from, address payable to, uint256 value) internal
173     {   
174         require(value > 0, "Transferred value has to be grater than 0.");
175         require(to != address(0), "0x00 address not allowed.");
176         require(value <= balanceOf[from], "Not enough funds on sender address.");
177         require(balanceOf[to] + value >= balanceOf[to], "Overflow protection.");
178  
179         uint256 fromOwing = dividendBalanceOf(from);
180         uint256 toOwing = dividendBalanceOf(to);
181 
182         if (tradables[from] == true && (tradables[to] == true || toOwing == 0)) 
183         {
184 
185             internalClaimDividend(from);
186             internalClaimDividend(to);
187         } else {
188             
189             require(fromOwing == 0 && toOwing == 0, "Unclaimed dividends on sender and/or receiver");
190         }
191         
192         balanceOf[from] -= value;
193         balanceOf[to] += value;
194  
195         lastDividends[to] = lastDividends[from];    // In case of new account, set lastDividends of receiver to totalDividends.
196  
197         emit Transfer(from, to, value);
198     }
199 
200     /**
201     * @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
202     * @param from Address to transfer from.
203     * @param to Address to transfer to.
204     * @param value Amount to transfer.
205     * @return Success of transfer.
206     */
207     function transferFrom(address payable from, address payable to, uint value) external returns (bool success)
208     {
209         uint256 allowanceTemp = allowance[from][msg.sender];
210         
211         require(allowanceTemp >= value, "Funds not approved."); 
212         require(balanceOf[from] >= value, "Not enough funds on sender address.");
213         require(balanceOf[to] + value >= balanceOf[to], "Overflow protection.");
214 
215         if (allowanceTemp < MAX_UINT) 
216         {
217             allowance[from][msg.sender] -= value;
218         }
219         
220         _transfer(from, to, value);
221 
222         return true;
223     }
224 
225     /**
226     * @dev `msg.sender` approves `addr` to spend `value` tokens.
227     * @param spender The address of the account able to transfer the tokens.
228     * @param value The amount of wei to be approved for transfer.
229     */
230     function approve(address spender, uint value) external returns (bool) 
231     {
232         allowance[msg.sender][spender] = value;
233         emit Approval(msg.sender, spender, value);
234         return true;
235     }
236 
237     /**
238     * @dev Set unlimited allowance for other address
239     * @param target The address authorized to spend
240     */   
241     function giveAccess(address target) external
242     {
243         require(target != address(0), "0x00 address not allowed.");
244         allowance[msg.sender][target] = MAX_UINT;
245         emit Approval(msg.sender, target, MAX_UINT);
246     }
247 
248     /**
249     * @dev Set allowance for other address to 0
250     * @param target The address authorized to spend
251     */   
252     function revokeAccess(address target) external
253     {
254         require(target != address(0), "0x00 address not allowed.");
255         allowance[msg.sender][target] = 0;
256     }
257     
258     /**
259     * @dev Get contract ETH amount. 
260     */ 
261     function contractBalance() external view returns(uint256 amount)
262     {
263         return (address(this).balance);
264     }
265     
266     /**
267     * @dev Receive ETH from CONTRACT and increase the total historic amount of dividend eligible earnings.
268     */
269     function receiveETH() external payable
270     {
271         totalDividends = totalDividends.add(msg.value);
272     }
273     
274     /**
275     * @dev Receive ETH and increase the total historic amount of dividend eligible earnings.
276     */
277     function () external payable 
278     {
279         totalDividends = totalDividends.add(msg.value);
280     }
281     
282 }