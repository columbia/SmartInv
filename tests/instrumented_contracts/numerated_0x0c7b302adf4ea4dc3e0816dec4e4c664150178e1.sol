1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28 }
29 
30 contract ERC20Basic {
31     uint256 public totalSupply;
32 
33     bool public transfersEnabled;
34 
35     function balanceOf(address who) public view returns (uint256);
36 
37     function transfer(address to, uint256 value) public returns (bool);
38 
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 contract ERC20 {
43     uint256 public totalSupply;
44 
45     bool public transfersEnabled;
46 
47     function balanceOf(address _owner) public constant returns (uint256 balance);
48 
49     function transfer(address _to, uint256 _value) public returns (bool success);
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
52 
53     function approve(address _spender, uint256 _value) public returns (bool success);
54 
55     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
56 
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58 
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 }
61 
62 contract BasicToken is ERC20Basic {
63     using SafeMath for uint256;
64 
65     mapping(address => uint256) balances;
66 
67     /**
68     * @dev protection against short address attack
69     */
70     modifier onlyPayloadSize(uint numwords) {
71         assert(msg.data.length == numwords * 32 + 4);
72         _;
73     }
74 
75 
76     /**
77     * @dev transfer token for a specified address
78     * @param _to The address to transfer to.
79     * @param _value The amount to be transferred.
80     */
81     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool) {
82         require(_to != address(0));
83         require(_value <= balances[msg.sender]);
84         require(transfersEnabled);
85 
86         // SafeMath.sub will throw if there is not enough balance.
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     /**
94     * @dev Gets the balance of the specified address.
95     * @param _owner The address to query the the balance of.
96     * @return An uint256 representing the amount owned by the passed address.
97     */
98     function balanceOf(address _owner) public constant returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102 }
103 
104 contract StandardToken is ERC20, BasicToken {
105 
106     mapping(address => mapping(address => uint256)) internal allowed;
107 
108     /**
109      * @dev Transfer tokens from one address to another
110      * @param _from address The address which you want to send tokens from
111      * @param _to address The address which you want to transfer to
112      * @param _value uint256 the amount of tokens to be transferred
113      */
114     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
115         require(_to != address(0));
116         require(_value <= balances[_from]);
117         require(_value <= allowed[_from][msg.sender]);
118         require(transfersEnabled);
119 
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123         Transfer(_from, _to, _value);
124         return true;
125     }
126 
127     /**
128      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129      *
130      * Beware that changing an allowance with this method brings the risk that someone may use both the old
131      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      * @param _spender The address which will spend the funds.
135      * @param _value The amount of tokens to be spent.
136      */
137     function approve(address _spender, uint256 _value) public returns (bool) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     /**
144      * @dev Function to check the amount of tokens that an owner allowed to a spender.
145      * @param _owner address The address which owns the funds.
146      * @param _spender address The address which will spend the funds.
147      * @return A uint256 specifying the amount of tokens still available for the spender.
148      */
149     function allowance(address _owner, address _spender) public onlyPayloadSize(2) constant returns (uint256 remaining) {
150         return allowed[_owner][_spender];
151     }
152 
153     /**
154      * approve should be called when allowed[_spender] == 0. To increment
155      * allowed value is better to use this function to avoid 2 calls (and wait until
156      * the first transaction is mined)
157      * From MonolithDAO Token.sol
158      */
159     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
160         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 
165     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
166         uint oldValue = allowed[msg.sender][_spender];
167         if (_subtractedValue > oldValue) {
168             allowed[msg.sender][_spender] = 0;
169         } else {
170             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171         }
172         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173         return true;
174     }
175 
176 }
177 
178 contract ETHernitymining is StandardToken {
179 
180     string public constant name = "ETHernitymining";
181     string public constant symbol = "ETM";
182     uint8 public constant decimals = 18;
183     uint256 public constant INITIAL_SUPPLY = 150 * 10**6 * (10**uint256(decimals));
184     address public owner;
185 
186     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
187     event Transfer(address indexed _from, address indexed _to, uint256 _value);
188 
189     function ETHernitymining(address _owner) public {
190         totalSupply = INITIAL_SUPPLY;
191         owner = _owner;
192         //owner = msg.sender; // for testing
193         balances[owner] = INITIAL_SUPPLY;
194         transfersEnabled = true;
195     }
196 
197     // fallback function can be used to buy tokens
198     function() payable public {
199         revert();
200     }
201 
202     modifier onlyOwner() {
203         require(msg.sender == owner);
204         _;
205     }
206 
207     function changeOwner(address _newOwner) onlyOwner public returns (bool){
208         require(_newOwner != address(0));
209         OwnerChanged(owner, _newOwner);
210         owner = _newOwner;
211         return true;
212     }
213 
214     function enableTransfers(bool _transfersEnabled) onlyOwner public {
215         transfersEnabled = _transfersEnabled;
216     }
217 
218     /**
219      * Peterson's Law Protection
220      * Claim tokens
221      */
222     function claimTokens(address _token) public onlyOwner returns(bool result) {
223         ETHernitymining token = ETHernitymining(_token);
224         uint256 balances = token.balanceOf(this);
225         result = token.transfer(owner, balances);
226     }
227 }