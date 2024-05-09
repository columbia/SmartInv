1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract Ownable {
33     address public owner;
34 
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39     /**
40      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41      * account.
42      */
43     function Ownable() public {
44         owner = msg.sender;
45     }
46 
47 
48     /**
49      * @dev Throws if called by any account other than the owner.
50      */
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55 
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         require(newOwner != address(0));
63         OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65     }
66 
67 }
68 
69 contract Pausable is Ownable {
70     event Pause();
71     event Unpause();
72 
73     bool public paused = false;
74 
75 
76     /**
77      * @dev Modifier to make a function callable only when the contract is not paused.
78      */
79     modifier whenNotPaused() {
80         require(!paused);
81         _;
82     }
83 
84     /**
85      * @dev Modifier to make a function callable only when the contract is paused.
86      */
87     modifier whenPaused() {
88         require(paused);
89         _;
90     }
91 
92     /**
93      * @dev called by the owner to pause, triggers stopped state
94      */
95     function pause() onlyOwner whenNotPaused public {
96         paused = true;
97         Pause();
98     }
99 
100     /**
101      * @dev called by the owner to unpause, returns to normal state
102      */
103     function unpause() onlyOwner whenPaused public {
104         paused = false;
105         Unpause();
106     }
107 }
108 
109 contract ERC20Basic {
110     uint256 public totalSupply;
111     function balanceOf(address who) public view returns (uint256);
112     function transfer(address to, uint256 value) public returns (bool);
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 contract BasicToken is ERC20Basic {
117     using SafeMath for uint256;
118 
119     mapping(address => uint256) balances;
120 
121     /**
122      * @dev transfer token for a specified address
123      * @param _to The address to transfer to.
124      * @param _value The amount to be transferred.
125      */
126     function transfer(address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[msg.sender]);
129 
130         // SafeMath.sub will throw if there is not enough balance.
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         Transfer(msg.sender, _to, _value);
134         return true;
135     }
136 
137     /**
138      * @dev Gets the balance of the specified address.
139      * @param _owner The address to query the the balance of.
140      * @return An uint256 representing the amount owned by the passed address.
141      */
142     function balanceOf(address _owner) public view returns (uint256 balance) {
143         return balances[_owner];
144     }
145 
146 }
147 
148 contract ERC20 is ERC20Basic {
149     function allowance(address owner, address spender) public view returns (uint256);
150     function transferFrom(address from, address to, uint256 value) public returns (bool);
151     function approve(address spender, uint256 value) public returns (bool);
152     event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 contract StandardToken is ERC20, BasicToken {
156 
157     mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160     /**
161      * @dev Transfer tokens from one address to another
162      * @param _from address The address which you want to send tokens from
163      * @param _to address The address which you want to transfer to
164      * @param _value uint256 the amount of tokens to be transferred
165      */
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167         require(_to != address(0));
168         require(_value <= balances[_from]);
169         require(_value <= allowed[_from][msg.sender]);
170 
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         Transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180      *
181      * Beware that changing an allowance with this method brings the risk that someone may use both the old
182      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      * @param _spender The address which will spend the funds.
186      * @param _value The amount of tokens to be spent.
187      */
188     function approve(address _spender, uint256 _value) public returns (bool) {
189         allowed[msg.sender][_spender] = _value;
190         Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Function to check the amount of tokens that an owner allowed to a spender.
196      * @param _owner address The address which owns the funds.
197      * @param _spender address The address which will spend the funds.
198      * @return A uint256 specifying the amount of tokens still available for the spender.
199      */
200     function allowance(address _owner, address _spender) public view returns (uint256) {
201         return allowed[_owner][_spender];
202     }
203 
204     /**
205      * approve should be called when allowed[_spender] == 0. To increment
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      */
210     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
211         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
217         uint oldValue = allowed[msg.sender][_spender];
218         if (_subtractedValue > oldValue) {
219             allowed[msg.sender][_spender] = 0;
220         } else {
221             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222         }
223         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 
227 }
228 
229 contract PausableToken is StandardToken, Pausable {
230 
231     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
232         return super.transfer(_to, _value);
233     }
234 
235     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
236         return super.transferFrom(_from, _to, _value);
237     }
238 
239     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
240         return super.approve(_spender, _value);
241     }
242 
243     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
244         return super.increaseApproval(_spender, _addedValue);
245     }
246 
247     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
248         return super.decreaseApproval(_spender, _subtractedValue);
249     }
250 }
251 
252 contract EEToken is PausableToken {
253     string public name = "EE";
254     string public symbol = "EE";
255     uint public decimals = 18;
256     uint public INITIAL_SUPPLY = 100000000000000000000000000000;
257 
258     function EEToken() public {
259         totalSupply = INITIAL_SUPPLY;
260         balances[msg.sender] = INITIAL_SUPPLY;
261     }
262 }