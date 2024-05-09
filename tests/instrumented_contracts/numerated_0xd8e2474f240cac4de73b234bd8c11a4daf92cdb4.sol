1 pragma solidity 0.4.23;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     emit OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 }
37 
38 
39 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
40 
41 contract Pausable is Ownable {
42   event Pause();
43   event Unpause();
44 
45   bool public paused = false;
46 
47 
48   /**
49    * @dev Modifier to make a function callable only when the contract is not paused.
50    */
51   modifier whenNotPaused() {
52     require(!paused);
53     _;
54   }
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is paused.
58    */
59   modifier whenPaused() {
60     require(paused);
61     _;
62   }
63 
64   /**
65    * @dev called by the owner to pause, triggers stopped state
66    */
67   function pause() onlyOwner whenNotPaused public {
68     paused = true;
69     emit Pause();
70   }
71 
72   /**
73    * @dev called by the owner to unpause, returns to normal state
74    */
75   function unpause() onlyOwner whenPaused public {
76     paused = false;
77     emit Unpause();
78   }
79 }
80 
81 
82 contract token is Pausable{
83     string public standard = 'Token 0.1';
84     string public name;
85     string public symbol;
86     uint8 public decimals;
87     uint256 public totalSupply;
88     event Burn(address indexed from, uint256 value);
89 
90     mapping (address => uint256) public balanceOf;
91     mapping (address => mapping (address => uint256)) public allowance;
92 
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     function token(
96         uint256 initialSupply,
97         string tokenName,
98         uint8 decimalUnits,
99         string tokenSymbol
100         ) {
101         balanceOf[msg.sender] = initialSupply;
102         totalSupply = initialSupply;
103         name = tokenName;
104         symbol = tokenSymbol;
105         decimals = decimalUnits;
106     }
107 
108     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool)   {
109         if (balanceOf[msg.sender] < _value) throw;
110         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
111         balanceOf[msg.sender] -= _value;
112         balanceOf[_to] += _value;
113         Transfer(msg.sender, _to, _value);
114     }
115 
116     function approve(address _spender, uint256 _value)
117         returns (bool success) {
118         allowance[msg.sender][_spender] = _value;
119         return true;
120     }
121 
122     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
123         returns (bool success) {    
124         tokenRecipient spender = tokenRecipient(_spender);
125         if (approve(_spender, _value)) {
126             spender.receiveApproval(msg.sender, _value, this, _extraData);
127             return true;
128         }
129     }
130 
131     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
132         if (balanceOf[_from] < _value) throw;
133         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
134         if (_value > allowance[_from][msg.sender]) throw;
135         balanceOf[_from] -= _value;
136         balanceOf[_to] += _value;
137         allowance[_from][msg.sender] -= _value;
138         Transfer(_from, _to, _value);
139         return true;
140     }
141 
142     function () {
143         throw;
144     }
145 }
146 
147 contract MyAdvancedToken is Ownable, token{
148 
149     mapping (address => bool) public frozenAccount;
150     bool frozen = false; 
151     event FrozenFunds(address target, bool frozen);
152 
153     function MyAdvancedToken(
154         uint256 initialSupply,
155         string tokenName,
156         uint8 decimalUnits,
157         string tokenSymbol
158     ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}
159 
160     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool)  {
161         if (balanceOf[msg.sender] < _value) throw;
162         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
163         if (frozenAccount[msg.sender]) throw;
164         balanceOf[msg.sender] -= _value;
165         balanceOf[_to] += _value;
166         Transfer(msg.sender, _to, _value);
167     }
168 
169     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
170         if (frozenAccount[_from]) throw;
171         if (balanceOf[_from] < _value) throw;
172         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
173         if (_value > allowance[_from][msg.sender]) throw;
174         balanceOf[_from] -= _value;
175         balanceOf[_to] += _value;
176         allowance[_from][msg.sender] -= _value;
177         Transfer(_from, _to, _value);
178         return true;
179     }
180 
181     function freezeAccount(address target, bool isFrozen) onlyOwner public {
182         frozenAccount[target] = isFrozen;
183         FrozenFunds(target, isFrozen);
184     }
185     function unfreezeAccount(address target, bool isFrozen) onlyOwner public {
186         frozenAccount[target] = !isFrozen;
187         FrozenFunds(target, !isFrozen);
188     }
189     
190     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
191         require(targets.length > 0);
192 
193         for (uint j = 0; j < targets.length; j++) {
194             require(targets[j] != 0x0);
195             frozenAccount[targets[j]] = isFrozen;
196             FrozenFunds(targets[j], isFrozen);
197         }
198     }
199 
200     function unfreezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
201         require(targets.length > 0);
202 
203         for (uint j = 0; j < targets.length; j++) {
204             require(targets[j] != 0x0);
205             frozenAccount[targets[j]] = !isFrozen;
206             FrozenFunds(targets[j], !isFrozen);
207         }
208     }
209 
210   function freezeTransfers () {
211     require (msg.sender == owner);
212 
213     if (!frozen) {
214       frozen = true;
215       Freeze ();
216     }
217   }
218 
219   function unfreezeTransfers () {
220     require (msg.sender == owner);
221 
222     if (frozen) {
223       frozen = false;
224       Unfreeze ();
225     }
226   }
227 
228 
229   event Freeze ();
230 
231   event Unfreeze ();
232 
233     function burn(uint256 _value) public returns (bool success) {        
234         require(balanceOf[msg.sender] >= _value);
235         balanceOf[msg.sender] -= _value;
236         totalSupply -= _value;
237         Burn(msg.sender, _value);        
238         return true;
239     }
240     
241     function burnFrom(address _from, uint256 _value) public returns (bool success) {        
242         require(balanceOf[_from] >= _value);
243         require(_value <= allowance[_from][msg.sender]);
244         balanceOf[_from] -= _value;
245         allowance[_from][msg.sender] -= _value;
246         totalSupply -= _value;
247         Burn(_from, _value);        
248         return true;
249     }
250 
251 }