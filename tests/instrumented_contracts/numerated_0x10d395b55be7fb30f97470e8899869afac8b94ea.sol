1 contract ERC20Token {
2     /* This is a slight change to the ERC20 base standard.
3     function totalSupply() constant returns (uint256 supply);
4     is replaced with:
5     uint256 public totalSupply;
6     This automatically creates a getter function for the totalSupply.
7     This is moved to the base contract since public getter functions are not
8     currently recognised as an implementation of the matching abstract
9     function by the compiler.
10     */
11     /// total amount of tokens
12     uint256 public totalSupply;
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) constant returns (uint256 balance);
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) returns (bool success);
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30 
31     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) returns (bool success);
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 contract Owned {
47     /// @dev `owner` is the only address that can call a function with this
48     /// modifier
49     modifier onlyOwner() {
50         require(msg.sender == owner) ;
51         _;
52     }
53 
54     address public owner;
55 
56     /// @notice The Constructor assigns the message sender to be `owner`
57     function Owned() {
58         owner = msg.sender;
59     }
60 
61     address public newOwner;
62 
63     /// @notice `owner` can step down and assign some other address to this role
64     /// @param _newOwner The address of the new owner. 0x0 can be used to create
65     ///  an unowned neutral vault, however that cannot be undone
66     function changeOwner(address _newOwner) onlyOwner {
67         newOwner = _newOwner;
68     }
69 
70     function acceptOwnership() {
71         if (msg.sender == newOwner) {
72             owner = newOwner;
73         }
74     }
75 }
76 contract StandardToken is ERC20Token {
77     function transfer(address _to, uint256 _value) returns (bool success) {
78         if (balances[msg.sender] >= _value && _value > 0) {
79             balances[msg.sender] -= _value;
80             balances[_to] += _value;
81             Transfer(msg.sender, _to, _value);
82             return true;
83         } else {
84             return false;
85         }
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
90             balances[_to] += _value;
91             balances[_from] -= _value;
92             allowed[_from][msg.sender] -= _value;
93             Transfer(_from, _to, _value);
94             return true;
95         } else {
96             return false;
97         }
98     }
99 
100     function balanceOf(address _owner) constant returns (uint256 balance) {
101         return balances[_owner];
102     }
103 
104     function approve(address _spender, uint256 _value) returns (bool success) {
105         // To change the approve amount you first have to reduce the addresses`
106         //  allowance to zero by calling `approve(_spender,0)` if it is not
107         //  already 0 to mitigate the race condition described here:
108         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
109         require ((_value==0) || (allowed[msg.sender][_spender] ==0));
110 
111         allowed[msg.sender][_spender] = _value;
112         Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
117         return allowed[_owner][_spender];
118     }
119 
120     mapping (address => uint256) public balances;
121     mapping (address => mapping (address => uint256)) allowed;
122 }
123 contract USEToken is StandardToken, Owned {
124     // metadata
125     string public constant name = "US Ethereum Token";
126     string public constant symbol = "USET";
127     string public version = "1.0";
128     uint256 public constant decimals = 8;
129     bool public disabled = false;
130     uint256 public constant MILLION = (10**6 * 10**decimals);
131     // constructor
132     function USEToken(uint256 _amount) {
133         totalSupply = 5000 * MILLION; 
134         balances[msg.sender] = _amount;
135     }
136 
137     function getUSETTotalSupply() external constant returns(uint256) {
138         return totalSupply;
139     }
140 
141     function setDisabled(bool flag) external onlyOwner {
142         disabled = flag;
143     }
144 
145     function transfer(address _to, uint256 _value) returns (bool success) {
146         require(!disabled);
147         return super.transfer(_to, _value);
148     }
149 
150     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
151         require(!disabled);
152         return super.transferFrom(_from, _to, _value);
153     }
154 
155     function mintToken(address target, uint256 mintedAmount) onlyOwner {
156         require(!disabled);
157         balances[target] += mintedAmount;
158         totalSupply += mintedAmount;
159         Transfer(0, owner, mintedAmount);
160         Transfer(owner, target, mintedAmount);
161     }
162 
163     function kill() external onlyOwner {
164         selfdestruct(owner);
165     }
166 }