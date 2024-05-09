1 contract ERC20Token {
2     /* This is a slight change to the ERC20 base standard.
3     function totalSupply() constant returns (uint256 supply);
4     is replaced with:
5     uint256 public totalSupply;
6     This automatically creates a getter function for the totalSupply.
7     This is moved to the base contract since public getter functions are not
8     currently recognised as an implementation of the matching abstract
9     function by the compiler.
10     */
11     /// total amount of tokens
12     uint256 public totalSupply;
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) public view returns (uint256 balance);
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) public returns (bool success);
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) public returns (bool success);
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  *
51  * Contract source taken from Open Zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/ownership/Ownable.sol
52  */
53 contract Ownable {
54     address public owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60     * account.
61     */
62     function Ownable() public {
63         owner = msg.sender;
64     }
65 
66     /**
67     * @dev Throws if called by any account other than the owner.
68     */
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     /**
75     * @dev Allows the current owner to transfer control of the contract to a newOwner.
76     * @param newOwner The address to transfer ownership to.
77     */
78     function transferOwnership(address newOwner) public onlyOwner {
79         require(newOwner != address(0));
80         OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82     }
83 }
84 
85 library SafeMathLib {
86     //
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         if (a == 0) {
89             return 0;
90         }
91         uint256 c = a * b;
92         assert(c / a == b);
93         return c;
94     }
95 
96     //
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         assert(b > 0 && a > 0);
99         // Solidity automatically throws when dividing by 0
100         uint256 c = a / b;
101         return c;
102     }
103 
104     //
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         assert(b <= a);
107         return a - b;
108     }
109 
110     //
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         assert(c >= a && c >= b);
114         return c;
115     }
116 }
117 
118 contract StandardToken is ERC20Token {
119     using SafeMathLib for uint;
120 
121     mapping(address => uint256) balances;
122     mapping(address => mapping(address => uint256)) allowed;
123 
124     //
125     event Transfer(address indexed from, address indexed to, uint256 value);
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 
128     //
129     function transfer(address _to, uint256 _value) public returns (bool success) {
130         require(_value > 0 && balances[msg.sender] >= _value);
131 
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     //
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
140         require(_value > 0 && balances[_from] >= _value);
141         require(allowed[_from][msg.sender] >= _value);
142 
143         balances[_to] = balances[_to].add(_value);
144         balances[_from] = balances[_from].sub(_value);
145         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146         Transfer(_from, _to, _value);
147         return true;
148     }
149 
150     //
151     function balanceOf(address _owner) public constant returns (uint256 balance) {
152         return balances[_owner];
153     }
154 
155     function approve(address _spender, uint256 _value) public returns (bool success) {
156         allowed[msg.sender][_spender] = _value;
157         Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
162         return allowed[_owner][_spender];
163     }
164 }
165 
166 contract Winchain is StandardToken, Ownable {
167     using SafeMathLib for uint256;
168 
169     uint256 INTERVAL_TIME = 63072000;//Two years
170     uint256 public deadlineToFreedTeamPool;//the deadline to freed the win pool of team
171     string public name = "Winchain";
172     string public symbol = "WIN";
173     uint256 public decimals = 18;
174     uint256 public INITIAL_SUPPLY = (210) * (10 ** 8) * (10 ** 18);//210
175 
176     // WIN which is freezed for the second stage
177     uint256 winPoolForSecondStage;
178     // WIN which is freezed for the third stage
179     uint256 winPoolForThirdStage;
180     // WIN which is freezed in order to reward team
181     uint256 winPoolToTeam;
182     // WIN which is freezed for community incentives, business corporation, developer ecosystem
183     uint256 winPoolToWinSystem;
184 
185     event Freed(address indexed owner, uint256 value);
186 
187     function Winchain(){
188         totalSupply = INITIAL_SUPPLY;
189         deadlineToFreedTeamPool = INTERVAL_TIME.add(block.timestamp);
190 
191         uint256 peerSupply = totalSupply.div(100);
192         //the first stage 15% + community operation 15%
193         balances[msg.sender] = peerSupply.mul(30);
194         //the second stage 15%
195         winPoolForSecondStage = peerSupply.mul(15);
196         //the third stage 20%
197         winPoolForThirdStage = peerSupply.mul(20);
198         //team 15%
199         winPoolToTeam = peerSupply.mul(15);
200         //community incentives and developer ecosystem 20%
201         winPoolToWinSystem = peerSupply.mul(20);
202 
203     }
204 
205     //===================================================================
206     //
207     function balanceWinPoolForSecondStage() public constant returns (uint256 remaining) {
208         return winPoolForSecondStage;
209     }
210 
211     function freedWinPoolForSecondStage() onlyOwner returns (bool success) {
212         require(winPoolForSecondStage > 0);
213         require(balances[msg.sender].add(winPoolForSecondStage) >= balances[msg.sender]
214         && balances[msg.sender].add(winPoolForSecondStage) >= winPoolForSecondStage);
215 
216         balances[msg.sender] = balances[msg.sender].add(winPoolForSecondStage);
217         Freed(msg.sender, winPoolForSecondStage);
218         winPoolForSecondStage = 0;
219         return true;
220     }
221     //
222     function balanceWinPoolForThirdStage() public constant returns (uint256 remaining) {
223         return winPoolForThirdStage;
224     }
225 
226     function freedWinPoolForThirdStage() onlyOwner returns (bool success) {
227         require(winPoolForThirdStage > 0);
228         require(balances[msg.sender].add(winPoolForThirdStage) >= balances[msg.sender]
229         && balances[msg.sender].add(winPoolForThirdStage) >= winPoolForThirdStage);
230 
231         balances[msg.sender] = balances[msg.sender].add(winPoolForThirdStage);
232         Freed(msg.sender, winPoolForThirdStage);
233         winPoolForThirdStage = 0;
234         return true;
235     }
236     //
237     function balanceWinPoolToTeam() public constant returns (uint256 remaining) {
238         return winPoolToTeam;
239     }
240 
241     function freedWinPoolToTeam() onlyOwner returns (bool success) {
242         require(winPoolToTeam > 0);
243         require(balances[msg.sender].add(winPoolToTeam) >= balances[msg.sender]
244         && balances[msg.sender].add(winPoolToTeam) >= winPoolToTeam);
245 
246         require(block.timestamp >= deadlineToFreedTeamPool);
247 
248         balances[msg.sender] = balances[msg.sender].add(winPoolToTeam);
249         Freed(msg.sender, winPoolToTeam);
250         winPoolToTeam = 0;
251         return true;
252     }
253     //
254     function balanceWinPoolToWinSystem() public constant returns (uint256 remaining) {
255         return winPoolToWinSystem;
256     }
257 
258     function freedWinPoolToWinSystem() onlyOwner returns (bool success) {
259         require(winPoolToWinSystem > 0);
260         require(balances[msg.sender].add(winPoolToWinSystem) >= balances[msg.sender]
261         && balances[msg.sender].add(winPoolToWinSystem) >= winPoolToWinSystem);
262 
263         balances[msg.sender] = balances[msg.sender].add(winPoolToWinSystem);
264         Freed(msg.sender, winPoolToWinSystem);
265         winPoolToWinSystem = 0;
266         return true;
267     }
268 
269     function() public payable {
270         revert();
271     }
272 
273 }