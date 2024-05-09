1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 
31 contract Ownable {
32     address public owner;
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34     
35     constructor() public {
36         owner = msg.sender;
37     }
38 
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45 
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 }
52 
53 
54 contract TokenERC20 is Ownable {
55     using SafeMath for uint;
56 
57     string public name;
58     string public symbol;
59     uint256 public decimals = 18;
60     uint256 DEC = 10 ** uint256(decimals); 
61     address public owner;
62 
63     uint256 public totalSupply;
64     uint256 public avaliableSupply;
65     uint256 public buyPrice = 12000 szabo;
66 
67     mapping (address => uint256) public balanceOf;
68     mapping (address => mapping (address => uint256)) public allowance;
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Burn(address indexed from, uint256 value);
72     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
73 
74     constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
75         totalSupply = initialSupply * DEC;  // Update total supply with the decimal amount
76         balanceOf[this] = totalSupply;                // Give the creator all initial tokens
77         avaliableSupply = balanceOf[this];            // Show how much tokens on contract
78         name = tokenName;                                   // Set the name for display purposes
79         symbol = tokenSymbol;                               // Set the symbol for display purposes
80         owner = msg.sender;
81     }
82 
83 
84     function _transfer(address _from, address _to, uint256 _value) internal {
85         require(_to != 0x0);
86         require(balanceOf[_from] >= _value);
87         require(balanceOf[_to] + _value > balanceOf[_to]);
88         uint previousBalances = balanceOf[_from] + balanceOf[_to];
89         balanceOf[_from] -= _value;
90         balanceOf[_to] += _value;
91 
92         emit Transfer(_from, _to, _value);
93         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
94     }
95 
96 
97     function transfer(address _to, uint256 _value) public {
98         _transfer(msg.sender, _to, _value);
99     }
100 
101 
102     function transferFrom(address _from, address _to, uint256 _value) public
103         returns (bool success) {
104         require(_value <= allowance[_from][msg.sender]);    
105         allowance[_from][msg.sender] -= _value;
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110 
111     function approve(address _spender, uint256 _value) public returns (bool success) {
112         allowance[msg.sender][_spender] = _value;
113         return true;
114     }
115 
116    
117     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
118         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
119         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
120         return true;
121     }
122 
123 
124     function decreaseApproval (address _spender, uint _subtractedValue) public
125         returns (bool success) {
126         uint oldValue = allowance[msg.sender][_spender];
127         if (_subtractedValue > oldValue) {
128             allowance[msg.sender][_spender] = 0;
129         } else {
130             allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
131         }
132         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
133         return true;
134     }
135     
136     
137     function burn(uint256 _value) public onlyOwner returns (bool success) {
138         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
139         balanceOf[msg.sender] -= _value;            // Subtract from the sender
140         totalSupply -= _value;                      // Updates totalSupply
141         avaliableSupply -= _value;
142         emit Burn(msg.sender, _value);
143         return true;
144     }
145     
146     
147     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
148         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
149         require(_value <= allowance[_from][msg.sender]);    // Check allowance
150         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
151         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
152         totalSupply -= _value;                              // Update totalSupply
153         avaliableSupply -= _value;
154         emit Burn(_from, _value);
155         return true;
156     }
157 }
158 
159 
160 contract Pauseble is TokenERC20 {
161     event EPause();
162     event EUnpause();
163 
164     bool public paused = true;
165   
166     modifier whenNotPaused() {
167       require(!paused);
168       _;
169     }
170 
171 
172     modifier whenPaused() {
173           require(paused);
174         _;
175     }
176 
177 
178     function pause() public onlyOwner {
179         paused = true;
180         emit EPause();
181     }
182 
183 
184     function pauseInternal() internal {
185         paused = true;
186         emit EPause();
187     }
188 
189 
190     function unpause() public onlyOwner {
191         paused = false;
192         emit EUnpause();
193     }
194 }
195 
196 
197 contract BarbarossaContract is Pauseble {
198 
199     using SafeMath for uint;
200   
201     uint public weisRaised; 
202 
203     constructor() public TokenERC20(50000000, "Barbarossa Invest Token", "BIT") {} 
204 
205 
206     function () public payable {
207         require(paused == false);
208         owner.transfer(msg.value); 
209         sell(msg.sender, msg.value);
210         weisRaised = weisRaised.add(msg.value);  
211     }
212     
213     
214     function sell(address _investor, uint256 amount) internal {
215         uint256 _amount = amount.mul(DEC).div(buyPrice);
216         avaliableSupply -= _amount;
217         _transfer(this, _investor, _amount);
218     }
219     
220     
221      function transferTokensFromContract(address _to, uint256 _value) public onlyOwner {   
222         avaliableSupply -= _value;
223         _value = _value*DEC; 
224         _transfer(this, _to, _value);
225     }
226 
227 
228     function setPrices(uint256 newPrice) public onlyOwner {
229         buyPrice = newPrice;
230     }
231 }