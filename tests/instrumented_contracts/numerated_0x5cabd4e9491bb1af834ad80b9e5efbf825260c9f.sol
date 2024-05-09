1 pragma solidity ^0.4.24;
2 
3 contract ERC20Token {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) public view returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  *
53  * Contract source taken from Open Zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/ownership/Ownable.sol
54  */
55 contract Ownable {
56     address public owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62     * account.
63     */
64     function Ownable() public {
65         owner = msg.sender;
66     }
67 
68     /**
69     * @dev Throws if called by any account other than the owner.
70     */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77     * @dev Allows the current owner to transfer control of the contract to a newOwner.
78     * @param newOwner The address to transfer ownership to.
79     */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0));
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 }
86 
87 library SafeMathLib {
88     //
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         if (a == 0) {
91             return 0;
92         }
93         uint256 c = a * b;
94         assert(c / a == b);
95         return c;
96     }
97 
98     //
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         assert(b > 0 && a > 0);
101         // Solidity automatically throws when dividing by 0
102         uint256 c = a / b;
103         return c;
104     }
105 
106     //
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         assert(b <= a);
109         return a - b;
110     }
111 
112     //
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         assert(c >= a && c >= b);
116         return c;
117     }
118 }
119 
120 contract StandardToken is ERC20Token {
121     using SafeMathLib for uint;
122 
123     mapping(address => uint256) balances;
124     mapping(address => mapping(address => uint256)) allowed;
125 
126     //
127     event Transfer(address indexed from, address indexed to, uint256 value);
128     event Approval(address indexed owner, address indexed spender, uint256 value);
129 
130     //
131     function transfer(address _to, uint256 _value) public returns (bool success) {
132         require(_value > 0 && balances[msg.sender] >= _value);
133 
134         balances[msg.sender] = balances[msg.sender].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         Transfer(msg.sender, _to, _value);
137         return true;
138     }
139 
140     //
141     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
142         require(_value > 0 && balances[_from] >= _value);
143         require(allowed[_from][msg.sender] >= _value);
144 
145         balances[_to] = balances[_to].add(_value);
146         balances[_from] = balances[_from].sub(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     //
153     function balanceOf(address _owner) public constant returns (uint256 balance) {
154         return balances[_owner];
155     }
156 
157     function approve(address _spender, uint256 _value) public returns (bool success) {
158         allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160         return true;
161     }
162 
163     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
164         return allowed[_owner][_spender];
165     }
166 }
167 
168 contract WOS is StandardToken, Ownable {
169     using SafeMathLib for uint256;
170 
171     uint256 INTERVAL_TIME = 63072000;//Two years
172     uint256 public deadlineToFreedTeamPool=1591198931;//the deadline to freed the Wos pool of team
173     string public name = "WOS";
174     string public symbol = "WOS";
175     uint256 public decimals = 18;
176     uint256 public INITIAL_SUPPLY = (210) * (10 ** 8) * (10 ** 18);//21
177 
178     // WOS which is freezed for the second stage
179     uint256 wosPoolForSecondStage;
180     // WOS which is freezed for the third stage
181     uint256 wosPoolForThirdStage;
182     // WOS which is freezed in order to reward team
183     uint256 wosPoolToTeam;
184     // WOS which is freezed for community incentives, business corporation, developer ecosystem
185     uint256 wosPoolToWosSystem;
186 
187     event Freed(address indexed owner, uint256 value);
188 
189     function WOS(){
190         totalSupply = INITIAL_SUPPLY;
191 
192         uint256 peerSupply = totalSupply.div(100);
193         //the first stage 15% + community operation 15%
194         balances[msg.sender] = peerSupply.mul(30);
195         //the second stage 15%
196         wosPoolForSecondStage = peerSupply.mul(15);
197         //the third stage 20%
198         wosPoolForThirdStage = peerSupply.mul(20);
199         //team 15%
200         wosPoolToTeam = peerSupply.mul(15);
201         //community incentives and developer ecosystem 20%
202         wosPoolToWosSystem = peerSupply.mul(20);
203 
204     }
205 
206     //===================================================================
207     //
208     function balanceWosPoolForSecondStage() public constant returns (uint256 remaining) {
209         return wosPoolForSecondStage;
210     }
211 
212     function freedWosPoolForSecondStage() onlyOwner returns (bool success) {
213         require(wosPoolForSecondStage > 0);
214         require(balances[msg.sender].add(wosPoolForSecondStage) >= balances[msg.sender]
215             && balances[msg.sender].add(wosPoolForSecondStage) >= wosPoolForSecondStage);
216 
217         balances[msg.sender] = balances[msg.sender].add(wosPoolForSecondStage);
218         Freed(msg.sender, wosPoolForSecondStage);
219         wosPoolForSecondStage = 0;
220         return true;
221     }
222     //
223     function balanceWosPoolForThirdStage() public constant returns (uint256 remaining) {
224         return wosPoolForThirdStage;
225     }
226 
227     function freedWosPoolForThirdStage() onlyOwner returns (bool success) {
228         require(wosPoolForThirdStage > 0);
229         require(balances[msg.sender].add(wosPoolForThirdStage) >= balances[msg.sender]
230             && balances[msg.sender].add(wosPoolForThirdStage) >= wosPoolForThirdStage);
231 
232         balances[msg.sender] = balances[msg.sender].add(wosPoolForThirdStage);
233         Freed(msg.sender, wosPoolForThirdStage);
234         wosPoolForThirdStage = 0;
235         return true;
236     }
237     //
238     function balanceWosPoolToTeam() public constant returns (uint256 remaining) {
239         return wosPoolToTeam;
240     }
241 
242     function freedWosPoolToTeam() onlyOwner returns (bool success) {
243         require(wosPoolToTeam > 0);
244         require(balances[msg.sender].add(wosPoolToTeam) >= balances[msg.sender]
245             && balances[msg.sender].add(wosPoolToTeam) >= wosPoolToTeam);
246 
247         require(block.timestamp >= deadlineToFreedTeamPool);
248 
249         balances[msg.sender] = balances[msg.sender].add(wosPoolToTeam);
250         Freed(msg.sender, wosPoolToTeam);
251         wosPoolToTeam = 0;
252         return true;
253     }
254     //
255     function balanceWosPoolToWosSystem() public constant returns (uint256 remaining) {
256         return wosPoolToWosSystem;
257     }
258 
259     function freedWosPoolToWosSystem() onlyOwner returns (bool success) {
260         require(wosPoolToWosSystem > 0);
261         require(balances[msg.sender].add(wosPoolToWosSystem) >= balances[msg.sender]
262             && balances[msg.sender].add(wosPoolToWosSystem) >= wosPoolToWosSystem);
263 
264         balances[msg.sender] = balances[msg.sender].add(wosPoolToWosSystem);
265         Freed(msg.sender, wosPoolToWosSystem);
266         wosPoolToWosSystem = 0;
267         return true;
268     }
269 
270     function() public payable {
271         revert();
272     }
273 
274 }