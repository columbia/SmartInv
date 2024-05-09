1 pragma solidity 0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint a, uint b) internal pure returns (uint) {
13         if (a == 0) {
14             return 0;
15         }
16         uint c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint a, uint b) internal pure returns (uint) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint a, uint b) internal pure returns (uint) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint a, uint b) internal pure returns (uint) {
43         uint c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 contract Ownable {
51     address public owner;
52     address public ICO; // ICO contract
53     address public DAO; // DAO contract
54 
55     function Ownable() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address _owner) public onlyOwner {
65         owner = _owner;
66     }
67 
68     function setDAO(address _DAO) onlyMasters public {
69         DAO = _DAO;
70     }
71 
72     function setICO(address _ICO) onlyMasters public {
73         ICO = _ICO;
74     }
75 
76     modifier onlyDAO() {
77         require(msg.sender == DAO);
78         _;
79     }
80 
81     modifier onlyMasters() {
82         require(msg.sender == ICO || msg.sender == owner || msg.sender == DAO);
83         _;
84     }
85 }
86 
87 
88 contract hasHolders {
89     mapping(address => uint) private holdersId;
90     // holder id starts at 1
91     mapping(uint => address) public holders;
92     uint public holdersCount = 0;
93 
94     event AddHolder(address indexed holder, uint index);
95     event DelHolder(address indexed holder);
96     event UpdHolder(address indexed holder, uint index);
97 
98     // add new token holder
99     function _addHolder(address _holder) internal returns (bool) {
100         if (holdersId[_holder] == 0) {
101             holdersId[_holder] = ++holdersCount;
102             holders[holdersCount] = _holder;
103             emit AddHolder(_holder, holdersCount);
104             return true;
105         }
106         return false;
107     }
108 
109     // delete token holder
110     function _delHolder(address _holder) internal returns (bool){
111         uint id = holdersId[_holder];
112         if (id != 0 && holdersCount > 0) {
113             //replace with last
114             holders[id] = holders[holdersCount];
115             // delete Holder element
116             delete holdersId[_holder];
117             //delete last id and decrease count
118             delete holders[holdersCount--];
119             emit DelHolder(_holder);
120             emit UpdHolder(holders[id], id);
121             return true;
122         }
123         return false;
124     }
125 }
126 
127 contract Force is Ownable, hasHolders {
128     using SafeMath for uint;
129     string public name = "Force";
130     string public symbol = "4TH";
131     uint8 public decimals = 0;
132     uint public totalSupply = 100000000;
133 
134     mapping(address => uint) private balances;
135     mapping(address => mapping(address => uint)) private allowed;
136 
137     string public information; // info
138 
139     event Transfer(address indexed _from, address indexed _to, uint _value);
140     event Approval(address indexed _owner, address indexed _spender, uint _value);
141     event Mint(address indexed _to, uint _amount);
142 
143     function Force() public {
144         balances[address(this)] = totalSupply;
145         emit Transfer(address(0), address(this), totalSupply);
146         _addHolder(this);
147     }
148 
149     /**
150     * @dev set public information
151     */
152     function setInformation(string _information) external onlyMasters {
153         information = _information;
154     }
155 
156     /**
157     * @dev internal transfer function
158     */
159     function _transfer(address _from, address _to, uint _value) internal returns (bool){
160         require(_to != address(0));
161         require(_value > 0);
162         require(balances[_from] >= _value);
163 
164         // SafeMath.sub will throw if there is not enough balance.
165         balances[_from] = balances[_from].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167         emit Transfer(_from, _to, _value);
168 
169         _addHolder(_to);
170         if (balances[_from] == 0) {
171             _delHolder(_from);
172         }
173         return true;
174     }
175 
176     /**
177     * @dev service transfer token function, allowed only from masters
178     */
179     function serviceTransfer(address _from, address _to, uint _value) external onlyMasters returns (bool success) {
180         return _transfer(_from, _to, _value);
181     }
182 
183     /**
184     * @dev transfer token for a specified address
185     */
186     function transfer(address _to, uint _value) external returns (bool) {
187         return _transfer(msg.sender, _to, _value);
188     }
189 
190     /**
191     * @dev Gets the balance of the specified address.
192     */
193     function balanceOf(address _owner) public view returns (uint) {
194         return balances[_owner];
195     }
196     /**
197      * @dev Transfer tokens from one address to another
198      */
199     function transferFrom(address _from, address _to, uint _value) external returns (bool) {
200         require(_value <= allowed[_from][_to]);
201         allowed[_from][_to] = allowed[_from][_to].sub(_value);
202         return _transfer(_from, _to, _value);
203     }
204 
205     /**
206      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207      */
208     function approve(address _spender, uint _value) external returns (bool) {
209         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
210         allowed[msg.sender][_spender] = _value;
211         emit Approval(msg.sender, _spender, _value);
212         return true;
213     }
214 
215     /**
216      * @dev Function to check the amount of tokens that an owner allowed to a spender.
217      */
218     function allowance(address _owner, address _spender) public view returns (uint) {
219         return allowed[_owner][_spender];
220     }
221 
222     /**
223      * @dev Increase the amount of tokens that an owner allowed to a spender.
224      */
225     function increaseApproval(address _spender, uint _addedValue) external returns (bool) {
226         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228         return true;
229     }
230 
231     /**
232      * @dev Decrease the amount of tokens that an owner allowed to a spender.
233      */
234     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool) {
235         uint oldValue = allowed[msg.sender][_spender];
236         if (_subtractedValue > oldValue) {
237             allowed[msg.sender][_spender] = 0;
238         } else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245     function mint(address _to, uint _amount) external onlyDAO returns (bool) {
246         require(_amount > 0);
247         totalSupply = totalSupply.add(_amount);
248         balances[_to] = balances[_to].add(_amount);
249         emit Mint(_to, _amount);
250         emit Transfer(address(0), _to, _amount);
251         return true;
252     }
253 
254     // disable ether transfer
255     function() external {}
256 
257 }