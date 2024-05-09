1 pragma solidity ^0.4.18;
2 
3 
4 contract Owned {
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12 
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function setOwner(address _newOwner) public onlyOwner {
18         owner = _newOwner;
19     }
20 
21 
22 }
23 
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a * b;
32         assert(a == 0 || c / a == b);
33         return c;
34     }
35 
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // assert(b > 0); // Solidity automatically throws when dividing by 0
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         assert(b <= a);
45         return a - b;
46     }
47 
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 
54 }
55 
56 
57 contract Token {
58     /* This is a slight change to the ERC20 base standard.
59     function totalSupply() constant returns (uint256 supply);
60     is replaced with:
61     uint256 public totalSupply;
62     This automatically creates a getter function for the totalSupply.
63     This is moved to the base contract since public getter functions are not
64     currently recognised as an implementation of the matching abstract
65     function by the compiler.
66     */
67     /// total amount of tokens
68     //uint256 public totalSupply;
69     function totalSupply() view public returns (uint256 supply);
70 
71     /// @param _owner The address from which the balance will be retrieved
72     /// @return The balance
73     function balanceOf(address _owner) view public returns (uint256 balance);
74 
75     /// @notice send `_value` token to `_to` from `msg.sender`
76     /// @param _to The address of the recipient
77     /// @param _value The amount of token to be transferred
78     /// @return Whether the transfer was successful or not
79     function transfer(address _to, uint256 _value) public;
80 
81     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
82     /// @param _from The address of the sender
83     /// @param _to The address of the recipient
84     /// @param _value The amount of token to be transferred
85     /// @return Whether the transfer was successful or not
86     function transferFrom(address _from, address _to, uint256 _value) public;
87 
88     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
89     /// @param _spender The address of the account able to transfer the tokens
90     /// @param _value The amount of wei to be approved for transfer
91     /// @return Whether the approval was successful or not
92     function approve(address _spender, uint256 _value) public;
93 
94     /// @param _owner The address of the account owning tokens
95     /// @param _spender The address of the account able to transfer the tokens
96     /// @return Amount of remaining tokens allowed to spent
97     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
98 
99     event Transfer(address indexed _from, address indexed _to, uint256 _value);
100     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
101 }
102 
103 
104 contract WBC is Token, Owned {
105     /// wbc token, ERC20 compliant
106     using SafeMath for uint256;
107 
108     string public constant name    = "WEBIC Token";  //The Token's name
109     uint8 public constant decimals = 6;               //Number of decimals of the smallest unit
110     string public constant symbol  = "WEBIC";            //An identifier
111 
112 
113     uint totoals=0;
114     // Balances for each account
115     mapping(address => uint256) balances;
116     // Owner of account approves the transfer of an amount to another account
117     mapping(address => mapping(address => uint256)) allowed;
118 
119 
120 
121     // Constructor
122     constructor() public {
123     }
124 
125 
126     function totalSupply() public view returns (uint256 supply){
127         return totoals;
128     }
129 
130 
131     function () public {
132         revert();
133     }
134 
135     // What is the balance of a particular account?
136     function balanceOf(address _owner) public view returns (uint256 balance) {
137         return balances[_owner];
138     }
139 
140 
141     // Transfer the balance from owner's account to another account
142     function transfer(address _to, uint256 _amount) public {
143         require(_amount > 0);
144         balances[msg.sender] = balances[msg.sender].sub(_amount);
145         balances[_to] = balances[_to].add(_amount);
146         emit Transfer(msg.sender, _to, _amount);
147 
148     }
149     
150     
151     // Send _value amount of tokens from address _from to address _to
152 
153     function transferFrom(
154         address _from,
155         address _to,
156         uint256 _amount
157     ) public {
158 
159         require(allowed[_from][msg.sender] >= _amount && _amount > 0);
160         balances[_from] = balances[_from].sub(_amount);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
162         balances[_to] = balances[_to].add(_amount);
163         emit  Transfer(_from, _to, _amount);
164     }
165 
166     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
167     // If this function is called again it overwrites the current allowance with _value.
168     function approve(address _spender, uint256 _amount) public {
169         allowed[msg.sender][_spender] = _amount;
170         emit  Approval(msg.sender, _spender, _amount);
171     }
172 
173 
174     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
175         return allowed[_owner][_spender];
176     }
177 
178     // Mint tokens
179     function mint(address _owner, uint256 _amount) public onlyOwner  {
180         balances[_owner] = balances[_owner].add(_amount);
181         totoals = totoals.add(_amount);
182         emit  Transfer(0, _owner, _amount);
183     }
184 
185 }
186 
187 
188 
189 contract wbcSale is Owned {
190   
191     using SafeMath for uint256;
192 
193     uint256 public constant totalSupply         = (12*10 ** 8) * (10 ** 6); // 12亿 WBC, decimals set to 6
194     uint256 constant raiseSupply                =  totalSupply * 35 / 100; 
195     uint256 constant reservedForTeam1           = totalSupply * 10 / 100;  
196     uint256 constant reservedForTeam2           = totalSupply * 40 / 100; 
197     uint256 constant reservedForTeam3           = totalSupply * 15 / 100; 
198 
199     WBC wbc; 
200     address raiseAccount; // 
201     address team1Account; // 
202     address team2Account; // 
203     address team3Account; //
204     uint32 startTime=1533283200;
205 
206     bool public initialized=false;
207     bool public finalized=false;
208 
209 
210 
211     constructor() public {
212 
213     }
214 
215 
216 
217 
218 
219     function blockTime() public view returns (uint32) {
220         return uint32(block.timestamp);
221     }
222 
223 
224 
225 
226     
227 
228   
229 
230 
231     function () public payable {
232         revert();
233     }
234 
235 
236 
237     function mintToTeamAccounts() internal onlyOwner{
238         require(!initialized);
239         wbc.mint(raiseAccount,raiseSupply);
240         wbc.mint(team1Account,reservedForTeam1);
241         wbc.mint(team2Account,reservedForTeam2);
242         wbc.mint(team3Account,reservedForTeam3);
243     }
244 
245     /// @notice initialize to prepare for sale
246     /// @param _wbc The address wbc token contract following ERC20 standard
247     function initialize (
248         WBC _wbc,address raiseAcc,address team1Acc,address team2Acc,address team3Acc) public onlyOwner {
249         require(blockTime()>=startTime);
250         // ownership of token contract should already be this
251         require(_wbc.owner() == address(this));
252         require(raiseAcc!=0&&team1Acc != 0&&team2Acc != 0&&team3Acc != 0);
253         wbc = _wbc;
254         raiseAccount = raiseAcc;
255         team1Account = team1Acc;
256         team2Account = team2Acc;
257         team3Account = team3Acc;
258         mintToTeamAccounts();
259         initialized = true;
260         emit onInitialized();
261     }
262 
263     /// @notice finalize
264     function finalize() public onlyOwner {
265         require(!finalized);
266         // only after closed stage
267         finalized = true;
268         emit onFinalized();
269     }
270 
271     event onInitialized();
272     event onFinalized();
273 }