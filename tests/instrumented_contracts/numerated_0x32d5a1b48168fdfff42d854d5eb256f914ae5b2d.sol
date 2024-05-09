1 pragma solidity 0.4.23;
2 
3 /**
4 
5  * ╦═╦    ╔══════╗╔══════╗ ╔══════╗ ╔══════╗ ╔══════╗     ╔══════╗ ╔══════╗ ╔═╗    ╔═╗
6  * ║ ║    ║ ╔══╗ ║║ ╔════╝ ║ ╔══╗ ║ ║ ╔══╗ ║ ║ ╔══╗ ║     ║ ╔══╗ ║ ║ ╔══╗ ║ ║ ╚╗  ╔╝ ║
7  * ║ ║    ║ ║  ╚═╝║ ╚═══╗  ║ ╚══╝ ║ ║ ╚══╝ ║ ║ ╚══╝ ║     ║ ║  ╚═╝ ║ ║  ║ ║ ║  ╚╗╔╝  ║ 
8  * ║ ║    ║ ║  ╔═╗║ ╔═══╝  ╚════╗ ║ ╚════╗ ║ ╚════╗ ║     ║ ║  ╔═╗ ║ ║  ║ ║ ║   ╚╝   ║ 
9  * ║ ╚═══╣║ ╚══╝ ║║ ╚════╗ ╔════╝ ║ ╔════╝ ║ ╔════╝ ║ ╔═╗ ║ ╚══╝ ║ ║ ╚══╝ ║ ║ ╔╗  ╔╗ ║ 
10  * ╩═════╝╚══════╝╚══════╝ ╚══════╝ ╚══════╝ ╚══════╝ ╚═╝ ╚══════╝ ╚══════╝ ╩═╝╚══╝╚═╩
11  * 
12  */
13  
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 }
47 
48 
49 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
50 
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 
92 contract token is Pausable{
93     string public standard = 'Token 0.1';
94     string public name;
95     string public symbol;
96     uint8 public decimals;
97     uint256 public totalSupply;
98     event Burn(address indexed from, uint256 value);
99 
100     mapping (address => uint256) public balanceOf;
101     mapping (address => mapping (address => uint256)) public allowance;
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     function token(
106         uint256 initialSupply,
107         string tokenName,
108         uint8 decimalUnits,
109         string tokenSymbol
110         ) {
111         balanceOf[msg.sender] = initialSupply;
112         totalSupply = initialSupply;
113         name = tokenName;
114         symbol = tokenSymbol;
115         decimals = decimalUnits;
116     }
117 
118     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool)   {
119         if (balanceOf[msg.sender] < _value) throw;
120         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
121         balanceOf[msg.sender] -= _value;
122         balanceOf[_to] += _value;
123         Transfer(msg.sender, _to, _value);
124     }
125 
126     function approve(address _spender, uint256 _value)
127         returns (bool success) {
128         allowance[msg.sender][_spender] = _value;
129         return true;
130     }
131 
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         returns (bool success) {    
134         tokenRecipient spender = tokenRecipient(_spender);
135         if (approve(_spender, _value)) {
136             spender.receiveApproval(msg.sender, _value, this, _extraData);
137             return true;
138         }
139     }
140 
141     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
142         if (balanceOf[_from] < _value) throw;
143         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
144         if (_value > allowance[_from][msg.sender]) throw;
145         balanceOf[_from] -= _value;
146         balanceOf[_to] += _value;
147         allowance[_from][msg.sender] -= _value;
148         Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     function () {
153         throw;
154     }
155 }
156 
157 contract MyAdvancedToken is Ownable, token{
158 
159     mapping (address => bool) public frozenAccount;
160     bool frozen = false; 
161     event FrozenFunds(address target, bool frozen);
162 
163     function MyAdvancedToken(
164         uint256 initialSupply,
165         string tokenName,
166         uint8 decimalUnits,
167         string tokenSymbol
168     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
169 
170     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool)  {
171         if (balanceOf[msg.sender] < _value) throw;
172         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
173         if (frozenAccount[msg.sender]) throw;
174         balanceOf[msg.sender] -= _value;
175         balanceOf[_to] += _value;
176         Transfer(msg.sender, _to, _value);
177     }
178 
179     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
180         if (frozenAccount[_from]) throw;
181         if (balanceOf[_from] < _value) throw;
182         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
183         if (_value > allowance[_from][msg.sender]) throw;
184         balanceOf[_from] -= _value;
185         balanceOf[_to] += _value;
186         allowance[_from][msg.sender] -= _value;
187         Transfer(_from, _to, _value);
188         return true;
189     }
190 
191     function freezeAccount(address target, bool isFrozen) onlyOwner public {
192         frozenAccount[target] = isFrozen;
193         FrozenFunds(target, isFrozen);
194     }
195     function unfreezeAccount(address target, bool isFrozen) onlyOwner public {
196         frozenAccount[target] = !isFrozen;
197         FrozenFunds(target, !isFrozen);
198     }
199     
200     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
201         require(targets.length > 0);
202 
203         for (uint j = 0; j < targets.length; j++) {
204             require(targets[j] != 0x0);
205             frozenAccount[targets[j]] = isFrozen;
206             FrozenFunds(targets[j], isFrozen);
207         }
208     }
209 
210     function unfreezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
211         require(targets.length > 0);
212 
213         for (uint j = 0; j < targets.length; j++) {
214             require(targets[j] != 0x0);
215             frozenAccount[targets[j]] = !isFrozen;
216             FrozenFunds(targets[j], !isFrozen);
217         }
218     }
219 
220   function freezeTransfers () {
221     require (msg.sender == owner);
222 
223     if (!frozen) {
224       frozen = true;
225       Freeze ();
226     }
227   }
228 
229   function unfreezeTransfers () {
230     require (msg.sender == owner);
231 
232     if (frozen) {
233       frozen = false;
234       Unfreeze ();
235     }
236   }
237 
238 
239   event Freeze ();
240 
241   event Unfreeze ();
242 
243     function burn(uint256 _value) public returns (bool success) {        
244         require(balanceOf[msg.sender] >= _value);
245         balanceOf[msg.sender] -= _value;
246         totalSupply -= _value;
247         Burn(msg.sender, _value);        
248         return true;
249     }
250     
251     function burnFrom(address _from, uint256 _value) public returns (bool success) {        
252         require(balanceOf[_from] >= _value);
253         require(_value <= allowance[_from][msg.sender]);
254         balanceOf[_from] -= _value;
255         allowance[_from][msg.sender] -= _value;
256         totalSupply -= _value;
257         Burn(_from, _value);        
258         return true;
259     }
260 
261 }