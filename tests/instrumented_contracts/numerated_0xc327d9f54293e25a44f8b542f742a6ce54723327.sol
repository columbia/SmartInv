1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  */
6 library SafeMath {
7 
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract Token {
49 
50     /// @return total amount of tokens
51     function totalSupply() constant returns (uint256 supply) {}
52     
53 
54     /// @param _owner The address from which the balance will be retrieved
55     /// @return The balance
56     function balanceOf(address _owner) constant returns (uint256 balance) {}
57 
58     /// @notice send `_value` token to `_to` from `msg.sender`
59     /// @param _to The address of the recipient
60     /// @param _value The amount of token to be transferred
61     /// @return Whether the transfer was successful or not
62     function transfer(address _to, uint256 _value) returns (bool success) {}
63 
64 
65 
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67 
68 }
69 
70 contract StandardToken is Token {
71 
72     function transfer(address _to, uint256 _value) returns (bool success) {
73         //Default assumes totalSupply can't be over max (2^256 - 1).
74         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
75         //Replace the if with this one instead.
76         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
77         if (balances[msg.sender] >= _value && _value > 0) {
78             balances[msg.sender] -= _value;
79             balances[_to] += _value;
80             emit Transfer(msg.sender, _to, _value);
81             return true;
82         } else { return false; }
83     }
84 
85 
86     function balanceOf(address _owner) constant returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90 
91     mapping (address => uint256) balances;
92     mapping (address => mapping (address => uint256)) allowed;
93     uint256 public totalSupply;
94 }
95 
96 contract ERC20 is StandardToken {
97     function allowance(address owner, address spender) public constant returns (uint256);
98     function transferFrom(address from, address to, uint256 value) public returns (bool);
99     function approve(address spender, uint256 value) public returns (bool);
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 contract Plumix is ERC20 { 
103 
104     /* Public variables of the token */
105 
106     using SafeMath for uint256;
107     string public name;                   
108     uint8 public decimals;                
109     string public symbol;                 
110     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
111     uint256 public minSales;                 // Minimum amount to be bought (0.01ETH)
112     uint256 public totalEthInWei;         
113     address internal fundsWallet;           
114     uint256 public airDropBal;
115     uint256 public icoSales;
116     uint256 public icoSalesBal;
117     uint256 public icoSalesCount;
118     bool public distributionClosed;
119 
120     
121     modifier canDistr() {
122         require(!distributionClosed);
123         _;
124     }
125     
126     address owner = msg.sender;
127     
128      modifier onlyOwner() {
129         require(msg.sender == owner);
130         _;
131     }
132     
133     
134     event Airdrop(address indexed _owner, uint _amount, uint _balance);
135     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
136     event DistrClosed();
137     event DistrStarted();
138     event Burn(address indexed burner, uint256 value);
139     
140     
141     function endDistribution() onlyOwner canDistr public returns (bool) {
142         distributionClosed = true;
143         emit DistrClosed();
144         return true;
145     }
146     
147     function startDistribution() onlyOwner public returns (bool) {
148         distributionClosed = false;
149         emit DistrStarted();
150         return true;
151     }
152     
153 
154     function Plumix() {
155         balances[msg.sender] = 10000000000e18;               
156         totalSupply = 10000000000e18;                        
157         airDropBal = 1500000000e18;
158         icoSales = 5000000000e18;
159         icoSalesBal = 5000000000e18;
160         name = "Plumix";                                   
161         decimals = 18;                                               
162         symbol = "PLXT";                                             
163         unitsOneEthCanBuy = 10000000;
164         minSales = 1 ether / 100; // 0.01ETH
165         icoSalesCount = 0;
166         fundsWallet = msg.sender;                                   
167         distributionClosed = true;
168         
169     }
170 
171     function() public canDistr payable{
172         totalEthInWei = totalEthInWei.add(msg.value);
173         uint256 amount = msg.value.mul(unitsOneEthCanBuy);
174         require(msg.value >= minSales);
175         require(amount <= icoSalesBal);
176         
177 
178         balances[fundsWallet] = balances[fundsWallet].sub(amount);
179         balances[msg.sender] = balances[msg.sender].add(amount);
180 
181         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
182 
183         
184         fundsWallet.transfer(msg.value);
185         
186         icoSalesCount = icoSalesCount.add(amount);
187         icoSalesBal = icoSalesBal.sub(amount);
188         if (icoSalesCount >= icoSales) {
189             distributionClosed = true;
190         }
191     }
192 
193     function transferMul(address _to, uint256 _value) internal returns (bool success) {
194         //Default assumes totalSupply can't be over max (2^256 - 1).
195         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
196         //Replace the if with this one instead.
197         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
198         if (balances[msg.sender] >= _value && _value > 0) {
199             require( _value <= airDropBal );
200             balances[msg.sender] -= _value;
201             balances[_to] += _value;
202             airDropBal = airDropBal.sub(_value);
203             emit Transfer(msg.sender, _to, _value);
204             emit Airdrop(msg.sender, _value, balances[msg.sender]);
205             return true;
206         } else { return false; }
207     }
208     
209     function payAirdrop(address[] _addresses, uint256 _value) public onlyOwner {        
210         for (uint i = 0; i < _addresses.length; i++) transferMul(_addresses[i], _value);
211     }
212  
213     
214     function burn(uint256 _value) onlyOwner public {
215         require(_value <= balances[msg.sender]);
216 
217 
218         address burner = msg.sender;
219         balances[burner] = balances[burner].sub(_value);
220         totalSupply = totalSupply.sub(_value);
221         emit Burn(burner, _value);
222     }
223     
224     // mitigates the ERC20 short address attack
225     modifier onlyPayloadSize(uint size) {
226         assert(msg.data.length >= size + 4);
227         _;
228     }
229     
230     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
231 
232         require(_to != address(0));
233         require(_amount <= balances[_from]);
234         require(_amount <= allowed[_from][msg.sender]);
235         
236         balances[_from] = balances[_from].sub(_amount);
237         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
238         balances[_to] = balances[_to].add(_amount);
239         emit Transfer(_from, _to, _amount);
240         return true;
241     }
242     
243     function approve(address _spender, uint256 _value) public returns (bool success) {
244         // mitigates the ERC20 spend/approval race condition
245         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
246         allowed[msg.sender][_spender] = _value;
247         emit Approval(msg.sender, _spender, _value);
248         return true;
249     }
250     
251     function allowance(address _owner, address _spender) constant public returns (uint256) {
252         return allowed[_owner][_spender];
253     }
254 
255 }