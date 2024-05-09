1 pragma solidity ^0.4.24;
2 
3 /******************************************/
4 /*       Netkiller ADVANCED TOKEN         */
5 /******************************************/
6 /* Author netkiller <netkiller@msn.com>   */
7 /* Home http://www.netkiller.cn           */
8 /* Version 2018-08-09  airdrop & exchange */
9 /******************************************/
10 library SafeMath {
11 
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a / b;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
31         c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 contract Ownable {
38     
39     address public owner;
40     
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42     
43     constructor() public {
44         owner = msg.sender;
45     }
46     
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51     
52     function transferOwnership(address newOwner) public onlyOwner {
53         require(newOwner != address(0));
54         emit OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56     }
57 
58 }
59 
60 contract NetkillerAdvancedToken is Ownable {
61     
62     using SafeMath for uint256;
63     
64     string public name;
65     string public symbol;
66     uint public decimals;
67     // 18 decimals is the strongly suggested default, avoid changing it
68     uint256 public totalSupply;
69     
70     // This creates an array with all balances
71     mapping (address => uint256) internal balances;
72     mapping (address => mapping (address => uint256)) internal allowed;
73 
74     // This generates a public event on the blockchain that will notify clients
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77     // This notifies clients about the amount burnt
78     event Burn(address indexed from, uint256 value);
79     
80     
81     mapping (address => bool) public frozenAccount;
82     event FrozenFunds(address indexed target, bool frozen);
83 
84     bool public lock = false;                   // Global lock
85 
86     /**
87      * Constrctor function
88      * Initializes contract with initial supply tokens to the creator of the contract
89      */
90     constructor(
91         uint256 initialSupply,
92         string tokenName,
93         string tokenSymbol,
94         uint decimalUnits
95     ) public {
96         owner = msg.sender;
97         name = tokenName;                                   // Set the name for display purposes
98         symbol = tokenSymbol; 
99         decimals = decimalUnits;
100         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
101         balances[msg.sender] = totalSupply;                // Give the creator all initial token
102     }
103 
104     modifier isLock {
105         require(!lock);
106         _;
107     }
108     
109     function setLock(bool _lock) onlyOwner public returns (bool status){
110         lock = _lock;
111         return lock;
112     }
113 
114     function balanceOf(address _address) view public returns (uint256 balance) {
115         return balances[_address];
116     }
117     
118     /* Internal transfer, only can be called by this contract */
119     function _transfer(address _from, address _to, uint256 _value) isLock internal {
120         require (_to != address(0));                        // Prevent transfer to 0x0 address. Use burn() instead
121         require (balances[_from] >= _value);                // Check if the sender has enough
122         require (balances[_to] + _value > balances[_to]);   // Check for overflows
123         require(!frozenAccount[_from]);                     // Check if sender is frozen
124         //require(!frozenAccount[_to]);                       // Check if recipient is frozen
125         balances[_from] = balances[_from].sub(_value);      // Subtract from the sender
126         balances[_to] = balances[_to].add(_value);          // Add the same to the recipient
127         emit Transfer(_from, _to, _value);
128     }
129 
130      function transfer(address _to, uint256 _value) public returns (bool success) {
131         _transfer(msg.sender, _to, _value);
132         return true;
133     }
134 
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);     // Check allowance
138         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139         _transfer(_from, _to, _value);
140         return true;
141     }
142 
143     function approve(address _spender, uint256 _value) public returns (bool success) {
144         allowed[msg.sender][_spender] = _value;
145         emit Approval(msg.sender, _spender, _value);
146         return true;
147     }
148     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
149         return allowed[_owner][_spender];
150     }
151 
152     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
153         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
154         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155         return true;
156     }
157 
158     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
159         uint oldValue = allowed[msg.sender][_spender];
160         if (_subtractedValue > oldValue) {
161             allowed[msg.sender][_spender] = 0;
162         } else {
163             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164         }
165         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166         return true;
167     }
168 
169     function burn(uint256 _value) onlyOwner public returns (bool success) {
170         require(balances[msg.sender] >= _value);                    // Check if the sender has enough
171         balances[msg.sender] = balances[msg.sender].sub(_value);    // Subtract from the sender
172         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
173         emit Burn(msg.sender, _value);
174         return true;
175     }
176 
177     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
178         require(balances[_from] >= _value);                                      // Check if the targeted balance is enough
179         require(_value <= allowed[_from][msg.sender]);                           // Check allowance
180         balances[_from] = balances[_from].sub(_value);                           // Subtract from the targeted balance
181         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);     // Subtract from the sender's allowance
182         totalSupply = totalSupply.sub(_value);                                   // Update totalSupply
183         emit Burn(_from, _value);
184         return true;
185     }
186 
187     function mintToken(address _to, uint256 _amount) onlyOwner public {
188         uint256 amount = _amount * 10 ** uint256(decimals);
189         totalSupply = totalSupply.add(amount);
190         balances[_to] = balances[_to].add(amount);
191         emit Transfer(this, _to, amount);
192     }
193 
194     function freezeAccount(address target, bool freeze) onlyOwner public {
195         frozenAccount[target] = freeze;
196         emit FrozenFunds(target, freeze);
197     }
198     
199     uint256 public buyPrice;
200     function setPrices(uint256 _buyPrice) onlyOwner public {
201         buyPrice = _buyPrice;
202     }
203     
204   
205     uint256 public airdropTotalSupply;          // Airdrop Total Supply
206     uint256 public airdropCurrentTotal;    	    // Airdrop Current Total 
207     uint256 public airdropAmount;        		// Airdrop amount
208     mapping(address => bool) public touched;    // Airdrop history account
209     event Airdrop(address indexed _address, uint256 indexed _value);
210     
211     function setAirdropTotalSupply(uint256 _amount) onlyOwner public {
212         airdropTotalSupply = _amount * 10 ** uint256(decimals);
213     }
214     
215     function setAirdropAmount(uint256 _amount) onlyOwner public{
216         airdropAmount = _amount * 10 ** uint256(decimals);
217     }
218     
219     function () public payable {
220         if (msg.value == 0 && !touched[msg.sender] && airdropAmount > 0 && airdropCurrentTotal < airdropTotalSupply) {
221             touched[msg.sender] = true;
222             airdropCurrentTotal = airdropCurrentTotal.add(airdropAmount);
223             _transfer(owner, msg.sender, airdropAmount); 
224             emit Airdrop(msg.sender, airdropAmount);
225     
226         }else{
227             owner.transfer(msg.value);
228             _transfer(owner, msg.sender, msg.value * buyPrice);    
229         }
230     }
231 
232     function batchFreezeAccount(address[] _target, bool _freeze) public returns (bool success) {
233         for (uint i=0; i<_target.length; i++) {
234             freezeAccount(_target[i], _freeze);
235         }
236         return true;
237     }
238 
239     function airdrop(address[] _to, uint256 _value) public returns (bool success) {
240         
241         require(_value > 0 && balanceOf(msg.sender) >= _value.mul(_to.length));
242         
243         for (uint i=0; i<_to.length; i++) {
244             _transfer(msg.sender, _to[i], _value);
245         }
246         return true;
247     }
248     
249     function batchTransfer(address[] _to, uint256[] _value) public returns (bool success) {
250         require(_to.length == _value.length);
251 
252         uint256 amount = 0;
253         for(uint n=0;n<_value.length;n++){
254             amount = amount.add(_value[n]);
255         }
256         
257         require(amount > 0 && balanceOf(msg.sender) >= amount);
258         
259         for (uint i=0; i<_to.length; i++) {
260             transfer(_to[i], _value[i]);
261         }
262         return true;
263     }
264 }