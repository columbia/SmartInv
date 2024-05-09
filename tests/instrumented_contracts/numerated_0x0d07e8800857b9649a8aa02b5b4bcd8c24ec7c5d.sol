1 pragma solidity ^0.4.24;
2 
3 contract Owned {
4     
5     /// 'owner' is the only address that can call a function with 
6     /// this modifier
7     address public owner;
8     address internal newOwner;
9     
10     ///@notice The constructor assigns the message sender to be 'owner'
11     constructor() public {
12         owner = msg.sender;
13     }
14     
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19     
20     event updateOwner(address _oldOwner, address _newOwner);
21     
22     ///change the owner
23     function changeOwner(address _newOwner) public onlyOwner returns(bool) {
24         require(owner != _newOwner);
25         newOwner = _newOwner;
26         return true;
27     }
28     
29     /// accept the ownership
30     function acceptNewOwner() public returns(bool) {
31         require(msg.sender == newOwner);
32         emit updateOwner(owner, newOwner);
33         owner = newOwner;
34         return true;
35     }
36 }
37 
38 contract SafeMath {
39     function safeMul(uint a, uint b) pure internal returns (uint) {
40         uint c = a * b;
41         assert(a == 0 || c / a == b);
42         return c;
43     }
44     
45     function safeSub(uint a, uint b) pure internal returns (uint) {
46         assert(b <= a);
47         return a - b;
48     }
49     
50     function safeAdd(uint a, uint b) pure internal returns (uint) {
51         uint c = a + b;
52         assert(c>=a && c>=b);
53         return c;
54     }
55 
56 }
57 
58 contract ERC20Token {
59     /* This is a slight change to the ERC20 base standard.
60     function totalSupply() constant returns (uint256 supply);
61     is replaced with:
62     uint256 public totalSupply;
63     This automatically creates a getter function for the totalSupply.
64     This is moved to the base contract since public getter functions are not
65     currently recognised as an implementation of the matching abstract
66     function by the compiler.
67     */
68     /// total amount of tokens
69     uint256 public totalSupply;
70     
71     /// user tokens
72     mapping (address => uint256) public balances;
73     
74     /// @param _owner The address from which the balance will be retrieved
75     /// @return The balance
76     function balanceOf(address _owner) constant public returns (uint256 balance);
77 
78     /// @notice send `_value` token to `_to` from `msg.sender`
79     /// @param _to The address of the recipient
80     /// @param _value The amount of token to be transferred
81     /// @return Whether the transfer was successful or not
82     function transfer(address _to, uint256 _value) public returns (bool success);
83     
84     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
85     /// @param _from The address of the sender
86     /// @param _to The address of the recipient
87     /// @param _value The amount of token to be transferred
88     /// @return Whether the transfer was successful or not
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
90 
91     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
92     /// @param _spender The address of the account able to transfer the tokens
93     /// @param _value The amount of tokens to be approved for transfer
94     /// @return Whether the approval was successful or not
95     function approve(address _spender, uint256 _value) public returns (bool success);
96 
97     /// @param _owner The address of the account owning tokens
98     /// @param _spender The address of the account able to transfer the tokens
99     /// @return Amount of remaining tokens allowed to spent
100     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
101 
102     event Transfer(address indexed _from, address indexed _to, uint256 _value);
103     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
104 }
105 
106 contract CUSE is ERC20Token {
107     
108     string public name = "USE Call Option";
109     string public symbol = "CUSE12";
110     uint public decimals = 0;
111     
112     uint256 public totalSupply = 75000000;
113     
114     function transfer(address _to, uint256 _value) public returns (bool success) {
115     //Default assumes totalSupply can't be over max (2^256 - 1).
116     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
117     //Replace the if with this one instead.
118         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
119             balances[msg.sender] -= _value;
120             balances[_to] += _value;
121             emit Transfer(msg.sender, _to, _value);
122             return true;
123         } else { return false; }
124     }
125     
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
127     //same as above. Replace this line with the following if you want to protect against wrapping uints.
128         if (balances[_from] >= _value && allowances[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
129           balances[_to] += _value;
130           balances[_from] -= _value;
131           allowances[_from][msg.sender] -= _value;
132           emit Transfer(_from, _to, _value);
133           return true;
134         } else { return false; }
135     }
136     
137     function balanceOf(address _owner) constant public returns (uint256 balance) {
138         return balances[_owner];
139     }
140     
141     function approve(address _spender, uint256 _value) public returns (bool success) {
142         allowances[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value);
144         return true;
145     }
146     
147     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
148         return allowances[_owner][_spender];
149     }
150     
151     mapping(address => uint256) public balances;
152     
153     mapping (address => mapping (address => uint256)) allowances;
154 }
155 
156 contract ExchangeCUSE is SafeMath, Owned, CUSE {
157     
158     // Exercise End Time 1/1/2019 0:0:0
159     uint public ExerciseEndTime = 1546272000;
160     uint public exchangeRate = 13333 * 10**9 wei; //percentage times (1 ether)
161     
162     //mapping (address => uint) ustValue; //mapping of token addresses to mapping of account balances (token=0 means Ether)
163     
164     // UST address
165     address public USEaddress = address(0xd9485499499d66B175Cf5ED54c0a19f1a6Bcb61A);
166     
167     // offical Address
168     address public officialAddress = address(0x89Ead717c9DC15a222926221897c68F9486E7229);
169 
170     function execCUSEOption() public payable returns (bool) {
171         require (now < ExerciseEndTime);
172         
173         // ETH user send
174         uint _ether = msg.value;
175         (uint _use, uint _refoundETH) = calcUSE(balances[msg.sender], _ether);
176         
177         // do exercise
178         balances[msg.sender] = safeSub(balances[msg.sender], _use/(10**18));
179         balances[officialAddress] = safeAdd(balances[officialAddress], _use/(10**18));
180         require (CUSE(USEaddress).transferFrom(officialAddress, msg.sender, _use) == true);
181 
182         emit Transfer(msg.sender, officialAddress, _use/(10**18)); 
183         
184         // refound ETH
185         needRefoundETH(_refoundETH);
186         officialAddress.transfer(safeSub(_ether, _refoundETH));
187     }
188     
189     // Calculate
190     function calcUSE(uint _cuse, uint _ether) internal view returns (uint _use, uint _refoundETH) {
191         uint _amount = _ether / exchangeRate;
192         require (safeMul(_amount, exchangeRate) <= _ether);
193         
194         // Check Whether msg.sender Have Enough CUSE
195         if (_amount <= _cuse) {
196             _use = safeMul(_amount, 10**18);
197             _refoundETH = 0;
198             
199         } else {
200             _use = safeMul(_cuse, 10**18);
201             _refoundETH = safeMul(safeSub(_amount, _cuse), exchangeRate);
202         }
203         
204     }
205     
206     function needRefoundETH(uint _refoundETH) internal {
207         if (_refoundETH > 0) {
208             msg.sender.transfer(_refoundETH);
209         }
210     }
211     
212     function changeOfficialAddress(address _newAddress) public onlyOwner {
213          officialAddress = _newAddress;
214     }
215 }
216 
217 contract USECallOption is ExchangeCUSE {
218 
219     function () payable public {
220         revert();
221     }
222 
223     // Allocate candy token
224     function allocateCandyToken(address[] _owners, uint256[] _values) public onlyOwner {
225        for(uint i = 0; i < _owners.length; i++){
226 		   balances[_owners[i]] = safeAdd(balances[_owners[i]], _values[i]); 
227 		   emit Transfer(address(this), _owners[i], _values[i]);  		  
228         }
229     }
230 
231     // only end time, onwer can transfer contract's ether out.
232     function WithdrawETH() payable public onlyOwner {
233         officialAddress.transfer(address(this).balance);
234     } 
235     
236 }