1 /**
2  * Source Code first verified at https://etherscan.io on Saturday, October 13, 2018
3  (UTC) */
4 
5 pragma solidity ^0.4.25;
6 
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 
32     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
33         return a >= b ? a : b;
34     }
35 
36     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
37         return a < b ? a : b;
38     }
39 
40     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a >= b ? a : b;
42     }
43 
44     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a < b ? a : b;
46     }
47 }
48 
49 contract ERC20Basic {
50     uint256 public totalSupply;
51 
52     bool public transfersEnabled;
53 
54     function balanceOf(address who) public view returns (uint256);
55 
56     function transfer(address to, uint256 value) public returns (bool);
57 
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 contract ERC20 {
62     uint256 public totalSupply;
63 
64     bool public transfersEnabled;
65 
66     function balanceOf(address _owner) public constant returns (uint256 balance);
67 
68     function transfer(address _to, uint256 _value) public returns (bool success);
69 
70     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
71 
72     function approve(address _spender, uint256 _value) public returns (bool success);
73 
74     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
75 
76     event Transfer(address indexed _from, address indexed _to, uint256 _value);
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78 }
79 
80 contract BasicToken is ERC20Basic {
81     using SafeMath for uint256;
82 
83     mapping(address => uint256) balances;
84 
85     /**
86     * @dev protection against short address attack
87     */
88     modifier onlyPayloadSize(uint numwords) {
89         assert(msg.data.length == numwords * 32 + 4);
90         _;
91     }
92 
93 
94     /**
95     * @dev transfer token for a specified address
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     */
99     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102         require(transfersEnabled);
103 
104         // SafeMath.sub will throw if there is not enough balance.
105         balances[msg.sender] = balances[msg.sender].sub(_value);
106         balances[_to] = balances[_to].add(_value);
107         Transfer(msg.sender, _to, _value);
108         return true;
109     }
110 
111     /**
112     * @dev Gets the balance of the specified address.
113     * @param _owner The address to query the the balance of.
114     * @return An uint256 representing the amount owned by the passed address.
115     */
116     function balanceOf(address _owner) public constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120 }
121 
122 contract StandardToken is ERC20, BasicToken {
123 
124     mapping(address => mapping(address => uint256)) internal allowed;
125 
126     /**
127      * @dev Transfer tokens from one address to another
128      * @param _from address The address which you want to send tokens from
129      * @param _to address The address which you want to transfer to
130      * @param _value uint256 the amount of tokens to be transferred
131      */
132     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
133         require(_to != address(0));
134         require(_value <= balances[_from]);
135         require(_value <= allowed[_from][msg.sender]);
136         require(transfersEnabled);
137 
138         balances[_from] = balances[_from].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141         Transfer(_from, _to, _value);
142         return true;
143     }
144 
145     /**
146      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147      *
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      * @param _spender The address which will spend the funds.
153      * @param _value The amount of tokens to be spent.
154      */
155     function approve(address _spender, uint256 _value) public returns (bool) {
156         allowed[msg.sender][_spender] = _value;
157         Approval(msg.sender, _spender, _value);
158         return true;
159     }
160 
161     /**
162      * @dev Function to check the amount of tokens that an owner allowed to a spender.
163      * @param _owner address The address which owns the funds.
164      * @param _spender address The address which will spend the funds.
165      * @return A uint256 specifying the amount of tokens still available for the spender.
166      */
167     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
168         return allowed[_owner][_spender];
169     }
170 
171     /**
172      * approve should be called when allowed[_spender] == 0. To increment
173      * allowed value is better to use this function to avoid 2 calls (and wait until
174      * the first transaction is mined)
175      * From MonolithDAO Token.sol
176      */
177     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
178         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
179         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180         return true;
181     }
182 
183     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
184         uint oldValue = allowed[msg.sender][_spender];
185         if (_subtractedValue > oldValue) {
186             allowed[msg.sender][_spender] = 0;
187         } else {
188             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189         }
190         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193 
194 }
195 
196 contract PlanetagroExchange is StandardToken {
197 
198     string public constant name = "Planetagro-Exchange";
199     string public constant symbol = "BANANA";
200     uint8 public constant decimals = 18;
201     uint256 public constant INITIAL_SUPPLY = 1000000 * 10**3 * (10**uint256(decimals));
202 
203     address public owner;
204 
205     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
206 
207     function PlanetagroExchange(address _owner) public {
208         totalSupply = INITIAL_SUPPLY;
209         owner = _owner;
210         //owner = msg.sender; // for testing
211         balances[owner] = INITIAL_SUPPLY;
212         transfersEnabled = true;
213     }
214 
215     modifier onlyOwner() {
216         require(msg.sender == owner);
217         _;
218     }
219 
220     function changeOwner(address newOwner) onlyOwner public returns (bool){
221         require(newOwner != address(0));
222         OwnerChanged(owner, newOwner);
223         owner = newOwner;
224         return true;
225     }
226 
227     function enableTransfers(bool _transfersEnabled) onlyOwner public {
228         transfersEnabled = _transfersEnabled;
229     }
230 
231     /**
232      * Peterson's Law Protection
233      * Claim tokens
234      */
235     function claimTokens() public onlyOwner {
236         owner.transfer(this.balance);
237         uint256 balance = balanceOf(this);
238         transfer(owner, balance);
239         Transfer(this, owner, balance);
240     }
241 }