1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 interface TokenUpgraderInterface{
28     function upgradeFor(address _for, uint256 _value) public returns (bool success);
29     function upgradeFrom(address _by, address _for, uint256 _value) public returns (bool success);
30 }
31   
32 contract Token {
33     using SafeMath for uint256;
34 
35     address public owner = msg.sender;
36 
37     string public name = "Cyber credit token";
38     string public symbol = "CYB";
39 
40     bool public upgradable = false;
41     bool public upgraderSet = false;
42     TokenUpgraderInterface public upgrader;
43 
44     bool public locked = false;
45     uint8 public decimals = 18;
46     uint256 public decimalMultiplier = 10**(uint256(decimals));
47 
48     modifier unlocked() {
49         require(!locked);
50         _;
51     }
52 
53     // Ownership
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address newOwner) public onlyOwner returns (bool success) {
63         require(newOwner != address(0));      
64         OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         return true;
67     }
68 
69 
70     // ERC20 related functions
71 
72     uint256 public totalSupply = 0;
73 
74     mapping(address => uint256) balances;
75     mapping(address => mapping (address => uint256)) allowed;
76 
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86 
87     function transfer(address _to, uint256 _value) unlocked public returns (bool) {
88         require(_to != address(0));
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95  /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of. 
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100 
101     function balanceOf(address _owner) view public returns (uint256 bal) {
102         return balances[_owner];
103     }
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amout of tokens to be transfered
110    */
111 
112     function transferFrom(address _from, address _to, uint256 _value) unlocked public returns (bool) {
113         require(_to != address(0));
114         uint256 _allowance = allowed[_from][msg.sender];
115         require(_allowance >= _value);
116         balances[_from] = balances[_from].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         allowed[_from][msg.sender] = _allowance.sub(_value);
119         Transfer(_from, _to, _value);
120         return true;
121     }
122 
123   /**
124    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128 
129     function approve(address _spender, uint256 _value) unlocked public returns (bool) {
130         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136   /**
137    * @dev Function to check the amount of tokens that an owner allowed to a spender.
138    * @param _owner address The address which owns the funds.
139    * @param _spender address The address which will spend the funds.
140    * @return A uint256 specifing the amount of tokens still available for the spender.
141    */
142 
143     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146 
147     function increaseApproval (address _spender, uint _addedValue) unlocked public
148         returns (bool success) {
149             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
150             Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
151             return true;
152     }
153 
154     function decreaseApproval (address _spender, uint _subtractedValue) unlocked public
155         returns (bool success) {
156             uint oldValue = allowed[msg.sender][_spender];
157             if (_subtractedValue > oldValue) {
158                 allowed[msg.sender][_spender] = 0;
159             } else {
160                 allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161             }
162             Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163             return true;
164     }
165 
166   /**
167     * Constructor mints tokens to corresponding addresses
168    */
169 
170     function Token () public {
171         totalSupply = 27000000*decimalMultiplier;  
172         balances[msg.sender] = totalSupply;
173     }
174 
175  
176 
177   /**
178    * @dev Function to lock token transfers
179    * @param _newLockState New lock state
180    * @return A boolean that indicates if the operation was successful.
181    */
182 
183     function setLock(bool _newLockState) onlyOwner public returns (bool success) {
184         require(_newLockState != locked);
185         locked = _newLockState;
186         return true;
187     }
188 
189   /**
190    * @dev Function to allow token upgrades
191    * @param _newState New upgrading allowance state
192    * @return A boolean that indicates if the operation was successful.
193    */
194 
195     function allowUpgrading(bool _newState) onlyOwner public returns (bool success) {
196         upgradable = _newState;
197         return true;
198     }
199 
200     function setUpgrader(address _upgraderAddress) onlyOwner public returns (bool success) {
201         require(!upgraderSet);
202         require(_upgraderAddress != address(0));
203         upgraderSet = true;
204         upgrader = TokenUpgraderInterface(_upgraderAddress);
205         return true;
206     }
207 
208     function upgrade() public returns (bool success) {
209         require(upgradable);
210         require(upgraderSet);
211         require(upgrader != TokenUpgraderInterface(0));
212         uint256 value = balances[msg.sender];
213         assert(value > 0);
214         delete balances[msg.sender];
215         totalSupply = totalSupply.sub(value);
216         assert(upgrader.upgradeFor(msg.sender, value));
217         return true;
218     }
219 
220     function upgradeFor(address _for, uint256 _value) public returns (bool success) {
221         require(upgradable);
222         require(upgraderSet);
223         require(upgrader != TokenUpgraderInterface(0));
224         uint256 _allowance = allowed[_for][msg.sender];
225         require(_allowance >= _value);
226         balances[_for] = balances[_for].sub(_value);
227         allowed[_for][msg.sender] = _allowance.sub(_value);
228         totalSupply = totalSupply.sub(_value);
229         assert(upgrader.upgradeFrom(msg.sender, _for, _value));
230         return true;
231     }
232 
233     function () payable external {
234         if (upgradable) {
235             assert(upgrade());
236             return;
237         }
238         revert();
239     }
240 
241 }