1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 
30 }
31 
32 contract Ownable {
33 
34     address public owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     function Ownable() public {
39         owner = msg.sender;
40     }
41 
42     modifier isOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     function transferOwnership(address newOwner) public isOwner {
48         require(newOwner != address(0));
49         OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51     }
52 
53 }
54 
55 contract StandardToken {
56 
57     using SafeMath for uint256;
58 
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
61     event Burn(address indexed from, uint256 value);
62     
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65 
66     uint256 public totalSupply;
67 
68     function totalSupply() public constant returns (uint256 supply) {
69         return totalSupply;
70     }
71 
72     function transfer(address _to, uint256 _value) public returns (bool success) {
73         if (balances[msg.sender] >= _value && _value > 0) {
74             balances[msg.sender] = balances[msg.sender].sub(_value);
75             balances[_to] = balances[_to].add(_value);
76             Transfer(msg.sender, _to, _value);
77             return true;
78         } else { return false; }
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
82         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
83             balances[_to] = balances[_to].add(_value);
84             balances[_from] = balances[_from].sub(_value);
85             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86             Transfer(_from, _to, _value);
87             return true;
88         } else { return false; }
89     }
90 
91     function balanceOf(address _owner) public constant returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95     function approve(address _spender, uint256 _value) public returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
102         return allowed[_owner][_spender];
103     }
104 	/**
105      * Destroy tokens
106      *
107      * Remove `_value` tokens from the system irreversibly
108      *
109      * @param _value the amount of money to burn
110      */
111     function burn(uint256 _value) public returns (bool success) {
112         require(balances[msg.sender] >= _value);   // Check if the sender has enough
113         balances[msg.sender] -= _value;            // Subtract from the sender
114         totalSupply -= _value;                      // Updates totalSupply
115         emit Burn(msg.sender, _value);
116         return true;
117     }
118 
119     /**
120      * Destroy tokens from other account
121      *
122      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
123      *
124      * @param _from the address of the sender
125      * @param _value the amount of money to burn
126      */
127     function burnFrom(address _from, uint256 _value) public returns (bool success) {
128         require(balances[_from] >= _value);                // Check if the targeted balance is enough
129         require(_value <= allowed[_from][msg.sender]);    // Check allowance
130         balances[_from] -= _value;                         // Subtract from the targeted balance
131         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
132         totalSupply -= _value;                              // Update totalSupply
133         emit Burn(_from, _value);
134         return true;
135     }
136 
137 }
138 
139 contract ERC20Token is StandardToken, Ownable {
140 
141     using SafeMath for uint256;
142 
143     string public name;
144     string public symbol;
145     string public version = '1.0';
146     uint256 public totalCoin;
147     uint8 public decimals;
148     uint256 public min;
149     uint256 public exchangeRate;
150     
151     mapping (address => bool) public frozenAccount;
152 
153     event TokenNameChanged(string indexed previousName, string indexed newName);
154     event TokenSymbolChanged(string indexed previousSymbol, string indexed newSymbol);
155     event ExhangeRateChanged(uint256 indexed previousRate, uint8 indexed newRate);
156 	event FrozenFunds(address target, bool frozen);
157 
158     function ERC20Token() public {
159         decimals        = 18;
160         totalCoin       = 20000000000;                       // Total Supply of Coin
161         totalSupply     = totalCoin * 10**uint(decimals); // Total Supply of Coin
162         balances[owner] = totalSupply;                    // Total Supply sent to Owner's Address
163         exchangeRate    = 12500000;                            // 100 Coins per ETH   (changable)
164         min        = 10000000000000000;
165         symbol          = "ICS";                       // Your Ticker Symbol  (changable)
166         name            = "iConsort Token";             // Your Coin Name      (changable)
167     }
168 
169     function changeTokenName(string newName) public isOwner returns (bool success) {
170         TokenNameChanged(name, newName);
171         name = newName;
172         return true;
173     }
174 
175     function changeTokenSymbol(string newSymbol) public isOwner returns (bool success) {
176         TokenSymbolChanged(symbol, newSymbol);
177         symbol = newSymbol;
178         return true;
179     }
180 
181     function changeExhangeRate(uint8 newRate) public isOwner returns (bool success) {
182         ExhangeRateChanged(exchangeRate, newRate);
183         exchangeRate = newRate;
184         return true;
185     }
186 	function freezeAccount(address target, bool freeze) isOwner public {
187         frozenAccount[target] = freeze;
188         emit FrozenFunds(target, freeze);
189     }
190 
191     function () public payable {
192         fundTokens();
193     }
194 
195     function fundTokens() public payable {
196         require(msg.value >= min);
197 		require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
198         uint256 tokens = msg.value.mul(exchangeRate);
199         require(balances[owner].sub(tokens) > 0);
200         balances[msg.sender] = balances[msg.sender].add(tokens);
201         balances[owner] = balances[owner].sub(tokens);
202         Transfer(msg.sender, owner, msg.value);
203         forwardFunds();
204     }
205 
206     function forwardFunds() internal {
207         owner.transfer(msg.value);
208     }
209 
210     function approveAndCall(
211         address _spender,
212         uint256 _value,
213         bytes _extraData
214     ) public returns (bool success) {
215         allowed[msg.sender][_spender] = _value;
216         Approval(msg.sender, _spender, _value);
217         if(!_spender.call(
218             bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))),
219             msg.sender,
220             _value,
221             this,
222             _extraData
223         )) { revert(); }
224         return true;
225     }
226 
227 }