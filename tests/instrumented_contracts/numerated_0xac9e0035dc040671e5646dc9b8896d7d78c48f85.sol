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
37     string public name = "Hint";
38     string public symbol = "HINT";
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
171         
172         address publicSaleReserveAddress = 0x11f104b59d90A00F4bDFF0Bed317c8573AA0a968;
173         mint(publicSaleReserveAddress, 100000000);
174 
175           address hintPlatformReserveAddress = 0xE46C2C7e4A53bdC3D91466b6FB45Ac9Bc996a3Dc;
176         mint(hintPlatformReserveAddress, 21000000000);
177 
178         address advisorsReserveAddress = 0xdc9aea710D5F8169AFEDA4bf6F1d6D64548951AF;
179         mint(advisorsReserveAddress, 50000000);
180         
181         address frozenHintEcosystemReserveAddress = 0xfeC2C0d053E9D6b1A7098F17b45b48102C8890e5;
182         mint(frozenHintEcosystemReserveAddress, 77600000000);
183 
184         address teamReserveAddress = 0xeE162d1CCBb1c14169f26E5b35e3ca44C8bDa4a0;
185         mint(teamReserveAddress, 50000000);
186         
187         address preICOReserveAddress = 0xD2c395e12174630993572bf4Cbb5b9a93384cdb2;
188         mint(preICOReserveAddress, 100000000);
189         
190         address foundationReserveAddress = 0x7A5d4e184f10b63C27ad772D17bd3b7393933142;
191         mint(foundationReserveAddress, 100000000);
192         
193         address hintPrivateOfferingReserve = 0x3f851952ACbEd98B39B913a5c8a2E55b2E28c8F4;
194         mint(hintPrivateOfferingReserve, 1000000000);
195 
196         assert(totalSupply == 100000000000*decimalMultiplier);
197     }
198 
199   /**
200    * @dev Function to mint tokens
201    * @param _for The address that will recieve the minted tokens.
202    * @param _amount The amount of tokens to mint.
203    * @return A boolean that indicates if the operation was successful.
204    */
205 
206     function mint(address _for, uint256 _amount) internal returns (bool success) {
207         _amount = _amount*decimalMultiplier;
208         balances[_for] = balances[_for].add(_amount);
209         totalSupply = totalSupply.add(_amount);
210         Transfer(0, _for, _amount);
211         return true;
212     }
213 
214   /**
215    * @dev Function to lock token transfers
216    * @param _newLockState New lock state
217    * @return A boolean that indicates if the operation was successful.
218    */
219 
220     function setLock(bool _newLockState) onlyOwner public returns (bool success) {
221         require(_newLockState != locked);
222         locked = _newLockState;
223         return true;
224     }
225 
226   /**
227    * @dev Function to allow token upgrades
228    * @param _newState New upgrading allowance state
229    * @return A boolean that indicates if the operation was successful.
230    */
231 
232     function allowUpgrading(bool _newState) onlyOwner public returns (bool success) {
233         upgradable = _newState;
234         return true;
235     }
236 
237     function setUpgrader(address _upgraderAddress) onlyOwner public returns (bool success) {
238         require(!upgraderSet);
239         require(_upgraderAddress != address(0));
240         upgraderSet = true;
241         upgrader = TokenUpgraderInterface(_upgraderAddress);
242         return true;
243     }
244 
245     function upgrade() public returns (bool success) {
246         require(upgradable);
247         require(upgraderSet);
248         require(upgrader != TokenUpgraderInterface(0));
249         uint256 value = balances[msg.sender];
250         assert(value > 0);
251         delete balances[msg.sender];
252         totalSupply = totalSupply.sub(value);
253         assert(upgrader.upgradeFor(msg.sender, value));
254         return true;
255     }
256 
257     function upgradeFor(address _for, uint256 _value) public returns (bool success) {
258         require(upgradable);
259         require(upgraderSet);
260         require(upgrader != TokenUpgraderInterface(0));
261         uint256 _allowance = allowed[_for][msg.sender];
262         require(_allowance >= _value);
263         balances[_for] = balances[_for].sub(_value);
264         allowed[_for][msg.sender] = _allowance.sub(_value);
265         totalSupply = totalSupply.sub(_value);
266         assert(upgrader.upgradeFrom(msg.sender, _for, _value));
267         return true;
268     }
269 
270     function () payable external {
271         if (upgradable) {
272             assert(upgrade());
273             return;
274         }
275         revert();
276     }
277 
278 }