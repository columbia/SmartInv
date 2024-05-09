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
39     // @dev safe Mul function
40     function safeMul(uint a, uint b) pure internal returns (uint) {
41         uint c = a * b;
42         assert(a == 0 || c / a == b);
43         return c;
44     }
45     
46     // @dev safe Sub function
47     function safeSub(uint a, uint b) pure internal returns (uint) {
48         assert(b <= a);
49         return a - b;
50     }
51     
52     // @dev safe Add function
53     function safeAdd(uint a, uint b) pure internal returns (uint) {
54         uint c = a + b;
55         assert(c>=a && c>=b);
56         return c;
57     }
58 
59 }
60 
61 contract Pausable is Owned{
62     
63     bool private _paused = false;
64     
65     event Paused();
66     event Unpaused();
67     
68     // @dev Modifier to make a function callable only when the contract is not paused.
69     modifier whenNotPaused() {
70         require(!_paused);
71         _;
72     }
73     
74     // @dev Modifier to make a function callable only when the contract is paused.
75     modifier whenPaused() {
76         require(_paused);
77         _;
78     }
79     
80     // @dev called by the owner to pause
81     function pause() whenNotPaused public onlyOwner {
82         _paused = true;
83         emit Paused();
84     } 
85     
86     // @dev called by the owner to unpause, returns to normal state.
87     function unpause() whenPaused public onlyOwner {
88         _paused = false;
89         emit Unpaused();
90     }
91     
92     // @dev return true if the contract is paused, false otherwise.
93     function paused() view public returns(bool) {
94         return _paused;
95     }
96 }
97 
98 
99 contract ERC20Token {
100     /* This is a slight change to the ERC20 base standard.
101     function totalSupply() constant returns (uint256 supply);
102     is replaced with:
103     uint256 public totalSupply;
104     This automatically creates a getter function for the totalSupply.
105     This is moved to the base contract since public getter functions are not
106     currently recognised as an implementation of the matching abstract
107     function by the compiler.
108     */
109     /// total amount of tokens
110     uint256 public totalSupply;
111     
112     /// user tokens
113     mapping (address => uint256) public balances;
114     
115     /// @param _owner The address from which the balance will be retrieved
116     /// @return The balance
117     function balanceOf(address _owner) constant public returns (uint256 balance);
118 
119     /// @notice send `_value` token to `_to` from `msg.sender`
120     /// @param _to The address of the recipient
121     /// @param _value The amount of token to be transferred
122     /// @return Whether the transfer was successful or not
123     function transfer(address _to, uint256 _value) public returns (bool success);
124     
125     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
126     /// @param _from The address of the sender
127     /// @param _to The address of the recipient
128     /// @param _value The amount of token to be transferred
129     /// @return Whether the transfer was successful or not
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
131 
132     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
133     /// @param _spender The address of the account able to transfer the tokens
134     /// @param _value The amount of tokens to be approved for transfer
135     /// @return Whether the approval was successful or not
136     function approve(address _spender, uint256 _value) public returns (bool success);
137 
138     /// @param _owner The address of the account owning tokens
139     /// @param _spender The address of the account able to transfer the tokens
140     /// @return Amount of remaining tokens allowed to spent
141     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
142 
143     event Transfer(address indexed _from, address indexed _to, uint256 _value);
144     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
145 }
146 
147 contract CUSEtoken is ERC20Token, Pausable, SafeMath {
148     
149     string public name = "USE Call Option";
150     string public symbol = "CUSE";
151     uint public decimals = 18;
152     
153     uint256 public totalSupply = 0;
154     
155     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success) {
156     //Default assumes totalSupply can't be over max (2^256 - 1).
157     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
158     //Replace the if with this one instead.
159         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
160             balances[msg.sender] -= _value;
161             balances[_to] += _value;
162             emit Transfer(msg.sender, _to, _value);
163             return true;
164         } else { return false; }
165     }
166     
167     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
168     //same as above. Replace this line with the following if you want to protect against wrapping uints.
169         if (balances[_from] >= _value && allowances[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
170           balances[_to] += _value;
171           balances[_from] -= _value;
172           allowances[_from][msg.sender] -= _value;
173           emit Transfer(_from, _to, _value);
174           return true;
175         } else { return false; }
176     }
177     
178     function balanceOf(address _owner) constant public returns (uint256 balance) {
179         return balances[_owner];
180     }
181     
182     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool success) {
183         allowances[msg.sender][_spender] = _value;
184         emit Approval(msg.sender, _spender, _value);
185         return true;
186     }
187     
188     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
189         return allowances[_owner][_spender];
190     }
191     
192     function increaseAllowance(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
193         allowances[msg.sender][_spender] = safeAdd(allowances[msg.sender][_spender], _addedValue);
194         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
195         return true;
196     }
197     
198     function decreaseAllowance(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
199         allowances[msg.sender][_spender] = safeSub(allowances[msg.sender][_spender], _subtractedValue);
200         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
201         return true;
202     }
203     
204     mapping (address => uint256) public balances;
205     
206     mapping (address => mapping (address => uint256)) allowances;
207 }
208 
209 contract CUSEcontract is CUSEtoken{
210     
211     address public usechainAddress;
212     uint constant public INITsupply = 9e27;
213     uint constant public CUSE12 = 75e24;
214     uint constant public USEsold = 3811759890e18;
215     function () payable public {
216         revert();
217     }
218     
219     constructor(address _usechainAddress) public {
220         usechainAddress = _usechainAddress;
221         totalSupply = INITsupply - CUSE12 - USEsold;
222         balances[usechainAddress] = totalSupply;
223         emit Transfer(address(this), usechainAddress, totalSupply);
224     }
225 
226 }