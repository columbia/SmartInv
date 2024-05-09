1 pragma solidity ^0.4.24;
2 library SafeMath {
3 
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     
31     address public owner;
32     
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34     
35     constructor() public {
36         owner = msg.sender;
37     }
38     
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43     
44     function transferOwnership(address newOwner) public onlyOwner {
45         require(newOwner != address(0));
46         emit OwnershipTransferred(owner, newOwner);
47         owner = newOwner;
48     }
49 
50 }
51 
52 contract NetkillerAdvancedToken is Ownable {
53     
54     using SafeMath for uint256;
55     
56     string public name;
57     string public symbol;
58     uint public decimals;
59     // 18 decimals is the strongly suggested default, avoid changing it
60     uint256 public totalSupply;
61     
62     // This creates an array with all balances
63     mapping (address => uint256) internal balances;
64     mapping (address => mapping (address => uint256)) internal allowed;
65 
66     // This generates a public event on the blockchain that will notify clients
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69     // This notifies clients about the amount burnt
70     event Burn(address indexed from, uint256 value);
71     
72     
73     mapping (address => bool) public frozenAccount;
74     event FrozenFunds(address indexed target, bool frozen);
75 
76     bool public lock = false;                   // Global lock
77 
78     /**
79      * Constrctor function
80      * Initializes contract with initial supply tokens to the creator of the contract
81      */
82     constructor(
83         uint256 initialSupply,
84         string tokenName,
85         string tokenSymbol,
86         uint decimalUnits
87     ) public {
88         owner = msg.sender;
89         name = tokenName;                                   // Set the name for display purposes
90         symbol = tokenSymbol; 
91         decimals = decimalUnits;
92         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
93         balances[msg.sender] = totalSupply;                // Give the creator all initial token
94     }
95 
96     modifier isLock {
97         require(!lock);
98         _;
99     }
100     
101     function setLock(bool _lock) onlyOwner public returns (bool status){
102         lock = _lock;
103         return lock;
104     }
105 
106     function balanceOf(address _address) view public returns (uint256 balance) {
107         return balances[_address];
108     }
109     
110     /* Internal transfer, only can be called by this contract */
111     function _transfer(address _from, address _to, uint256 _value) isLock internal {
112         require (_to != address(0));                        // Prevent transfer to 0x0 address. Use burn() instead
113         require (balances[_from] >= _value);                // Check if the sender has enough
114         require (balances[_to] + _value > balances[_to]);   // Check for overflows
115         require(!frozenAccount[_from]);                     // Check if sender is frozen
116         //require(!frozenAccount[_to]);                       // Check if recipient is frozen
117         balances[_from] = balances[_from].sub(_value);      // Subtract from the sender
118         balances[_to] = balances[_to].add(_value);          // Add the same to the recipient
119         emit Transfer(_from, _to, _value);
120     }
121 
122      function transfer(address _to, uint256 _value) public returns (bool success) {
123         _transfer(msg.sender, _to, _value);
124         return true;
125     }
126 
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
128         require(_value <= balances[_from]);
129         require(_value <= allowed[_from][msg.sender]);     // Check allowance
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131         _transfer(_from, _to, _value);
132         return true;
133     }
134 
135     function approve(address _spender, uint256 _value) public returns (bool success) {
136         allowed[msg.sender][_spender] = _value;
137         emit Approval(msg.sender, _spender, _value);
138         return true;
139     }
140     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
141         return allowed[_owner][_spender];
142     }
143 
144     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
145         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
146         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147         return true;
148     }
149 
150     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
151         uint oldValue = allowed[msg.sender][_spender];
152         if (_subtractedValue > oldValue) {
153             allowed[msg.sender][_spender] = 0;
154         } else {
155             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
156         }
157         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158         return true;
159     }
160 
161     function burn(uint256 _value) onlyOwner public returns (bool success) {
162         require(balances[msg.sender] >= _value);                    // Check if the sender has enough
163         balances[msg.sender] = balances[msg.sender].sub(_value);    // Subtract from the sender
164         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
165         emit Burn(msg.sender, _value);
166         return true;
167     }
168 
169     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
170         require(balances[_from] >= _value);                                      // Check if the targeted balance is enough
171         require(_value <= allowed[_from][msg.sender]);                           // Check allowance
172         balances[_from] = balances[_from].sub(_value);                           // Subtract from the targeted balance
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);     // Subtract from the sender's allowance
174         totalSupply = totalSupply.sub(_value);                                   // Update totalSupply
175         emit Burn(_from, _value);
176         return true;
177     }
178 
179     function mintToken(address _to, uint256 _amount) onlyOwner public {
180         uint256 amount = _amount * 10 ** uint256(decimals);
181         totalSupply = totalSupply.add(amount);
182         balances[_to] = balances[_to].add(amount);
183         emit Transfer(this, _to, amount);
184     }
185 
186     function freezeAccount(address target, bool freeze) onlyOwner public {
187         frozenAccount[target] = freeze;
188         emit FrozenFunds(target, freeze);
189     }
190     
191     uint256 public buyPrice;
192     function setPrices(uint256 _buyPrice) onlyOwner public {
193         buyPrice = _buyPrice;
194     }
195     
196   
197     uint256 public airdropTotalSupply;          // Airdrop Total Supply
198     uint256 public airdropCurrentTotal;    	    // Airdrop Current Total 
199     uint256 public airdropAmount;        		// Airdrop amount
200     mapping(address => bool) public touched;    // Airdrop history account
201     event Airdrop(address indexed _address, uint256 indexed _value);
202     
203     function setAirdropTotalSupply(uint256 _amount) onlyOwner public {
204         airdropTotalSupply = _amount * 10 ** uint256(decimals);
205     }
206     
207     function setAirdropAmount(uint256 _amount) onlyOwner public{
208         airdropAmount = _amount * 10 ** uint256(decimals);
209     }
210     
211     function () public payable {
212         if (msg.value == 0 && !touched[msg.sender] && airdropAmount > 0 && airdropCurrentTotal < airdropTotalSupply) {
213             touched[msg.sender] = true;
214             airdropCurrentTotal = airdropCurrentTotal.add(airdropAmount);
215             _transfer(owner, msg.sender, airdropAmount); 
216             emit Airdrop(msg.sender, airdropAmount);
217     
218         }else{
219             owner.transfer(msg.value);
220             _transfer(owner, msg.sender, msg.value * buyPrice);    
221         }
222     }
223 }