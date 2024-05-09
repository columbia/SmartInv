1 pragma solidity ^0.4.19;
2 contract Owned {
3     /// @dev `owner` is the only address that can call a function with this
4     /// modifier
5     modifier onlyOwner() {
6         require(msg.sender == owner) ;
7         _;
8     }
9 
10     address public owner;
11 
12     /// @notice The Constructor assigns the message sender to be `owner`
13     function Owned() public {
14         owner = msg.sender;
15     }
16 
17     address public newOwner;
18 
19     /// @notice `owner` can step down and assign some other address to this role
20     /// @param _newOwner The address of the new owner. 0x0 can be used to create
21     ///  an unowned neutral vault, however that cannot be undone
22     function changeOwner(address _newOwner) public onlyOwner {
23         newOwner = _newOwner;
24     }
25 
26     function acceptOwnership() public {
27         if (msg.sender == newOwner) {
28             owner = newOwner;
29         }
30     }
31 }
32 
33 contract ERC20Token {
34     /* This is a slight change to the ERC20 base standard.
35     function totalSupply() constant returns (uint256 supply);
36     is replaced with:
37     uint256 public totalSupply;
38     This automatically creates a getter function for the totalSupply.
39     This is moved to the base contract since public getter functions are not
40     currently recognised as an implementation of the matching abstract
41     function by the compiler.
42     */
43     /// total amount of tokens
44     uint256 public totalSupply;
45 
46     /// @param _owner The address from which the balance will be retrieved
47     /// @return The balance
48     function balanceOf(address _owner) public view returns (uint256 balance);
49 
50     /// @notice send `_value` token to `_to` from `msg.sender`
51     /// @param _to The address of the recipient
52     /// @param _value The amount of token to be transferred
53     /// @return Whether the transfer was successful or not
54     function transfer(address _to, uint256 _value) public returns (bool success);
55 
56     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
57     /// @param _from The address of the sender
58     /// @param _to The address of the recipient
59     /// @param _value The amount of token to be transferred
60     /// @return Whether the transfer was successful or not
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
62 
63     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
64     /// @param _spender The address of the account able to transfer the tokens
65     /// @param _value The amount of tokens to be approved for transfer
66     /// @return Whether the approval was successful or not
67     function approve(address _spender, uint256 _value) public returns (bool success);
68 
69     /// @param _owner The address of the account owning tokens
70     /// @param _spender The address of the account able to transfer the tokens
71     /// @return Amount of remaining tokens allowed to spent
72     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
73 
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 }
77 
78 /*  ERC 20 token */
79 contract StandardToken is ERC20Token {
80     
81     mapping (address => uint256) internal balances;
82     mapping (address => mapping (address => uint256)) internal allowed;
83 
84     
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         assert(b <= a);
87         return a - b;
88     }
89 
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         assert(c >= a);
93         return c;
94     }
95     
96     function transfer(address _to, uint256 _value) public returns (bool success) 
97     {
98         if (balances[msg.sender] >= _value && _value > 0) {
99             balances[msg.sender] -= _value;
100             balances[_to] += _value;
101             Transfer(msg.sender, _to, _value);
102             return true;
103         } else {
104             return false;
105         }
106     }
107 
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
109     {
110         require(_to != address(0));
111         require(_value <= balances[_from]);
112         require(_value <= allowed[_from][msg.sender]);
113 
114         balances[_from] = sub(balances[_from],_value);
115         balances[_to] = add(balances[_to],_value);
116         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_value);
117         Transfer(_from, _to, _value);
118         return true;
119     }
120 
121     function balanceOf(address _owner) public constant returns (uint256 balance) {
122         return balances[_owner];
123     }
124 
125     function approve(address _spender, uint256 _value) public returns (bool success) {
126         // To change the approve amount you first have to reduce the addresses`
127         //  allowance to zero by calling `approve(_spender,0)` if it is not
128         //  already 0 to mitigate the race condition described here:
129         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130         require ((_value==0) || (allowed[msg.sender][_spender] ==0));
131 
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
138         return allowed[_owner][_spender];
139     }
140 
141     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
142         allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender],_addedValue);
143         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144         return true;
145     }
146 
147     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
148         uint oldValue = allowed[msg.sender][_spender];
149         if (_subtractedValue > oldValue) {
150             allowed[msg.sender][_spender] = 0;
151         } else {
152             allowed[msg.sender][_spender] = sub(oldValue,_subtractedValue);
153         }
154         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155         return true;
156   }
157 
158 }
159 
160 contract SuperWalletToken is StandardToken, Owned
161 {
162     // metadata
163     string public constant name = "Super Wallet Token";
164     string public constant symbol = "SW";
165     string public version = "1.0";
166     uint256 public constant decimals = 8;
167     bool public disabled;
168     // constructor
169     function SuperWalletToken() public 
170     {
171         uint256 amount = 84000000*100000000;
172         totalSupply = amount;
173         balances[msg.sender] = amount;
174     }
175 
176     function getTotalSupply() external view returns(uint256) 
177     {
178         return totalSupply;
179     }
180     //在数据迁移时,需要先停止ATM交易
181     function setDisabled(bool flag) external onlyOwner {
182         disabled = flag;
183     }
184     function transfer(address _to, uint256 _value) public returns (bool success) {
185         require(!disabled);
186         return super.transfer(_to, _value);
187     }
188 
189     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
190         require(!disabled);
191         return super.transferFrom(_from, _to, _value);
192     }
193 
194     function kill() external onlyOwner {
195         selfdestruct(owner);
196     }
197 
198 }