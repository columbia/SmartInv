1 pragma solidity 0.6.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         return sub(a, b, "SafeMath: subtraction overflow");
12     }
13     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
14         require(b <= a, errorMessage);
15         uint256 c = a - b;
16 
17         return c;
18     }
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23         uint256 c = a * b;
24         require(c / a == b, "SafeMath: multiplication overflow");
25 
26         return c;
27     }
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         return div(a, b, "SafeMath: division by zero");
30     }
31     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b > 0, errorMessage);
33         uint256 c = a / b;
34         return c;
35     }
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         return mod(a, b, "SafeMath: modulo by zero");
38     }
39     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b != 0, errorMessage);
41         return a % b;
42     }
43 }
44 
45 //  voting contract 
46 interface Nest_3_VoteFactory {
47     //  Check address 
48 	function checkAddress(string calldata name) external view returns (address contractAddress);
49 	//  check whether the administrator 
50 	function checkOwners(address man) external view returns (bool);
51 }
52 
53 /**
54  * @title NToken contract 
55  * @dev Include standard erc20 method, mining method, and mining data 
56  */
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59     function balanceOf(address who) external view returns (uint256);
60     function allowance(address owner, address spender) external view returns (uint256);
61     function transfer(address to, uint256 value) external returns (bool);
62     function approve(address spender, uint256 value) external returns (bool);
63     function transferFrom(address from, address to, uint256 value) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract Nest_NToken is IERC20 {
69     using SafeMath for uint256;
70     
71     mapping (address => uint256) private _balances;                                 //  Balance ledger 
72     mapping (address => mapping (address => uint256)) private _allowed;             //  Approval ledger 
73     uint256 private _totalSupply = 0 ether;                                         //  Total supply 
74     string public name;                                                             //  Token name 
75     string public symbol;                                                           //  Token symbol 
76     uint8 public decimals = 18;                                                     //  Precision
77     uint256 public _createBlock;                                                    //  Create block number
78     uint256 public _recentlyUsedBlock;                                              //  Recently used block number
79     Nest_3_VoteFactory _voteFactory;                                                //  Voting factory contract
80     address _bidder;                                                                //  Owner
81     
82     /**
83     * @dev Initialization method
84     * @param _name Token name
85     * @param _symbol Token symbol
86     * @param voteFactory Voting factory contract address
87     * @param bidder Successful bidder address
88     */
89     constructor (string memory _name, string memory _symbol, address voteFactory, address bidder) public {
90     	name = _name;                                                               
91     	symbol = _symbol;
92     	_createBlock = block.number;
93     	_recentlyUsedBlock = block.number;
94     	_voteFactory = Nest_3_VoteFactory(address(voteFactory));
95     	_bidder = bidder;
96     }
97     
98     /**
99     * @dev Reset voting contract method
100     * @param voteFactory Voting contract address
101     */
102     function changeMapping (address voteFactory) public onlyOwner {
103     	_voteFactory = Nest_3_VoteFactory(address(voteFactory));
104     }
105     
106     /**
107     * @dev Additional issuance
108     * @param value Additional issuance amount
109     */
110     function increaseTotal(uint256 value) public {
111         address offerMain = address(_voteFactory.checkAddress("nest.nToken.offerMain"));
112         require(address(msg.sender) == offerMain, "No authority");
113         _balances[offerMain] = _balances[offerMain].add(value);
114         _totalSupply = _totalSupply.add(value);
115         _recentlyUsedBlock = block.number;
116     }
117 
118     /**
119     * @dev Check the total amount of tokens
120     * @return Total supply
121     */
122     function totalSupply() override public view returns (uint256) {
123         return _totalSupply;
124     }
125 
126     /**
127     * @dev Check address balance
128     * @param owner Address to be checked
129     * @return Return the balance of the corresponding address
130     */
131     function balanceOf(address owner) override public view returns (uint256) {
132         return _balances[owner];
133     }
134     
135     /**
136     * @dev Check block information
137     * @return createBlock Initial block number
138     * @return recentlyUsedBlock Recently mined and issued block
139     */
140     function checkBlockInfo() public view returns(uint256 createBlock, uint256 recentlyUsedBlock) {
141         return (_createBlock, _recentlyUsedBlock);
142     }
143 
144     /**
145      * @dev Check owner's approved allowance to the spender
146      * @param owner Approving address
147      * @param spender Approved address
148      * @return Approved amount
149      */
150     function allowance(address owner, address spender) override public view returns (uint256) {
151         return _allowed[owner][spender];
152     }
153 
154     /**
155     * @dev Transfer method
156     * @param to Transfer target
157     * @param value Transfer amount
158     * @return Whether the transfer is successful
159     */
160     function transfer(address to, uint256 value) override public returns (bool) {
161         _transfer(msg.sender, to, value);
162         return true;
163     }
164 
165     /**
166      * @dev Approval method
167      * @param spender Approval target
168      * @param value Approval amount
169      * @return Whether the approval is successful
170      */
171     function approve(address spender, uint256 value) override public returns (bool) {
172         require(spender != address(0));
173 
174         _allowed[msg.sender][spender] = value;
175         emit Approval(msg.sender, spender, value);
176         return true;
177     }
178 
179     /**
180      * @dev Transfer tokens when approved
181      * @param from Transfer-out account address
182      * @param to Transfer-in account address
183      * @param value Transfer amount
184      * @return Whether approved transfer is successful
185      */
186     function transferFrom(address from, address to, uint256 value) override public returns (bool) {
187         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
188         _transfer(from, to, value);
189         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
190         return true;
191     }
192 
193     /**
194      * @dev Increase the allowance
195      * @param spender Approval target
196      * @param addedValue Amount to increase
197      * @return whether increase is successful
198      */
199     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
200         require(spender != address(0));
201 
202         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
203         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
204         return true;
205     }
206 
207     /**
208      * @dev Decrease the allowance
209      * @param spender Approval target
210      * @param subtractedValue Amount to decrease
211      * @return Whether decrease is successful
212      */
213     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
214         require(spender != address(0));
215 
216         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
217         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218         return true;
219     }
220 
221     /**
222     * @dev Transfer method
223     * @param to Transfer target
224     * @param value Transfer amount
225     */
226     function _transfer(address from, address to, uint256 value) internal {
227         _balances[from] = _balances[from].sub(value);
228         _balances[to] = _balances[to].add(value);
229         emit Transfer(from, to, value);
230     }
231     
232     /**
233     * @dev Check the creator
234     * @return Creator address
235     */
236     function checkBidder() public view returns(address) {
237         return _bidder;
238     }
239     
240     /**
241     * @dev Transfer creator
242     * @param bidder New creator address
243     */
244     function changeBidder(address bidder) public {
245         require(address(msg.sender) == _bidder);
246         _bidder = bidder; 
247     }
248     
249     // Administrator only
250     modifier onlyOwner(){
251         require(_voteFactory.checkOwners(msg.sender));
252         _;
253     }
254 }