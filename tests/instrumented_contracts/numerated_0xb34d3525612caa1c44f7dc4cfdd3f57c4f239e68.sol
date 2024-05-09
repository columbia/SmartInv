1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks (over / under flow) that revert on error
7  */
8 library SafeMath {
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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
24     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         require(b > 0);
28         uint256 c = a / b;
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two numbers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 }
53 
54 // interface standard erc20
55 contract ERC20Basic {
56     uint256 public totalSupply;
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 contract Ownable {
63     address public owner;
64 
65     event transferOwner(address indexed existingOwner, address indexed newOwner);
66 
67     constructor() public {
68         owner = msg.sender;
69     }
70 
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function transferOwnership(address newOwner) onlyOwner public {
77         if (newOwner != address(0)) {
78             owner = newOwner;
79             emit transferOwner(msg.sender, owner);
80         }
81     }
82 }
83 
84 // more common interface erc20
85 contract ERC20 is ERC20Basic {
86     function allowance(address owner, address spender) public view returns (uint256);
87     function transferFrom(address from, address to, uint256 value) public returns (bool);
88     function approve(address spender, uint256 value) public returns (bool);
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 contract BasicToken is ERC20Basic {
93     using SafeMath for uint256;
94 
95     mapping(address => uint256) balances;
96 
97     // implementation of transfer token
98     function transfer(address _to, uint256 _value) public returns (bool) {
99         require(_value > 0);
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102 
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         emit Transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     // check balance user (map)
110     function balanceOf(address _owner) public view returns (uint256 balance) {
111         return balances[_owner];
112     }
113 
114 }
115 
116 
117 contract StandardToken is ERC20, BasicToken {
118     mapping (address => mapping (address => uint256)) internal allowed;
119 
120     // implementation transfer from another user
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122         require(_value > 0);
123         require(_to != address(0));
124         require(_value <= balances[_from]);
125         require(_value <= allowed[_from][msg.sender]);
126 
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130         emit Transfer(_from, _to, _value);
131         return true;
132     }
133 
134     // implementation approval to allowed transfer
135     function approve(address _spender, uint256 _value) public returns (bool) {
136         require(_value > 0);
137         allowed[msg.sender][_spender] = _value;
138         emit Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     // check total allowance particular user
143     function allowance(address _owner, address _spender) public view returns (uint256) {
144         return allowed[_owner][_spender];
145     }
146 
147   // implementation increase total approval from particular user
148     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
149         require(_addedValue > 0);
150         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152         return true;
153     }
154 
155     // implementation decrease total approval from particular user
156     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
157         require(_subtractedValue > 0);
158         uint oldValue = allowed[msg.sender][_spender];
159         if (_subtractedValue > oldValue) {
160             allowed[msg.sender][_spender] = 0;
161         } else {
162             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163         }
164         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168 }
169 
170 contract Pausable is Ownable {
171     event Pause();
172     event Unpause();
173 
174     // set paused as true as the requirement
175     bool public paused = true;
176     
177   //@dev Modifier to make a function callable only when the contract is not paused.
178     modifier whenNotPaused() {
179         require(!paused);
180         _;
181     }
182 
183 
184   //@dev Modifier to make a function callable only when the contract is paused.
185     modifier whenPaused() {
186         require(paused);
187         _;
188     }
189 
190 
191   //@dev called by the owner to pause, triggers stopped state
192     function pause() onlyOwner whenNotPaused public {
193         paused = true;
194         emit Pause();
195     }
196 
197 
198   //@dev called by the owner to unpause, returns to normal state
199     function unpause() onlyOwner whenPaused public {
200         paused = false;
201         emit Unpause();
202     }
203 }
204 
205 // implementation pauseable erc20
206 contract PausableToken is StandardToken, Pausable {
207 
208   // call whenNotPaused modifier to check next state
209   
210     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
211         return super.transfer(_to, _value);
212     }
213 
214     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
215         return super.transferFrom(_from, _to, _value);
216     }
217 
218     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
219         return super.approve(_spender, _value);
220     }
221 
222     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
223         return super.increaseApproval(_spender, _addedValue);
224     }
225 
226     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
227         return super.decreaseApproval(_spender, _subtractedValue);
228     }
229     
230     // for distributing purposes
231     function distributeToken(address _to, uint256 _value) public onlyOwner returns (bool) {
232         return super.transfer(_to, _value);
233     }
234 }
235 
236 contract PNPToken is PausableToken {  
237     string public constant name = "LogisticsX";
238     string public constant symbol = "PNP";
239     uint8 public constant decimals = 18;
240 
241     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
242 
243     constructor(address reserve) public {
244         totalSupply = INITIAL_SUPPLY;
245         balances[reserve] = INITIAL_SUPPLY;
246         emit Transfer(address(0), reserve, INITIAL_SUPPLY);
247     }
248 
249 }