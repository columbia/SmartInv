1 pragma solidity ^0.4.24;
2 /**
3  * Math operations with safety checks
4  */
5 contract SafeMath {
6 
7     function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
8         uint256 c = a * b;
9         judgement(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
14         judgement(b > 0);
15         uint256 c = a / b;
16         judgement(a == b * c + a % b);
17         return c;
18     }
19 
20     function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
21         judgement(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
26         uint256 c = a + b;
27         judgement(c>=a && c>=b);
28         return c;
29     }
30     function safeMulWithPresent(uint256 a , uint256 b) pure internal returns (uint256){
31         uint256 c = safeDiv(safeMul(a,b),100);
32         judgement(b == (c*100)/a);
33         return c;
34     }
35     function judgement(bool assertion) pure internal {
36         if (!assertion) {
37             revert();
38         }
39     }
40 }
41 contract BBZZXUCAuth{
42     address public owner;
43     constructor () public{
44         owner = msg.sender;
45     }
46     event LogOwnerChanged (address msgSender );
47 
48     ///@notice check if the msgSender is owner
49     modifier onlyOwner{
50         assert(msg.sender == owner);
51         _;
52     }//TODO need double check the authority checking
53 
54     function setOwner (address newOwner) public onlyOwner returns (bool){
55         if (owner == msg.sender){
56             owner = newOwner;
57             emit LogOwnerChanged(msg.sender);
58             return true;
59         }else{
60             return false;
61         }
62     }
63 
64 }
65 contract BBZZXUCStop is BBZZXUCAuth{
66     bool internal stopped = false;
67 
68     modifier stoppable {
69         assert (!stopped);
70         _;
71     }
72 
73     function _status() view public returns (bool){
74         return stopped;
75     }
76     function stop() public onlyOwner{
77         stopped = true;
78     }
79     function start() public onlyOwner{
80         stopped = false;
81     }
82 
83 }
84 contract Token is SafeMath {//TODO need review the oo
85     /*
86 		Standard ERC20 token
87 	*/
88     uint256 public totalSupply;                                 /// total amount of tokens
89     /// @param _owner The address from which the balance will be retrieved
90     /// @return The balance
91     function balanceOf(address _owner) public view returns (uint256 balance);
92 
93     /// @notice send `_value` token to `_to` from `msg.sender`
94     /// @param _to The address of the recipient
95     /// @param _value The amount of token to be transferred
96     /// @return Whether the transfer was successful or not
97     function transfer(address _to, uint256 _value) public returns (bool success);
98 
99     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
100     /// @param _from The address of the sender
101     /// @param _to The address of the recipient
102     /// @param _value The amount of token to be transferred
103     /// @return Whether the transfer was successful or not
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
105 
106     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
107     /// @param _spender The address of the account able to transfer the tokens
108     /// @param _value The amount of tokens to be approved for transfer
109     /// @return Whether the approval was successful or not
110     function approve(address _spender, uint256 _value) public returns (bool success);
111 
112     /// @param _owner The address of the account owning tokens
113     /// @param _spender The address of the account able to transfer the tokens
114     /// @return Amount of remaining tokens allowed to spent
115     function allowance(address _owner, address _spender) view public returns (uint256 remaining);
116 
117     function push(address _to,uint256 amount) public returns (bool);
118     /*
119 		function _transfer(address to ,uint256 amount) public returns (bool);
120 	*/
121     function burn(uint256 amount) public returns (bool);
122 
123     function mint(uint256 amount) public;
124 
125     function frozenCheck(address _from , address _to) view private returns (bool);
126 
127     function freezeAccount(address target , bool freeze) public;
128 
129     event Transfer(address indexed _from, address indexed _to, uint256 _value);
130     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
131     event Burn    (address indexed _owner , uint256 _value);
132     event Minted  (uint256 amount);
133 }
134 contract StandardToken is Token ,BBZZXUCStop{
135 
136     function transfer(address _to, uint256 _value) stoppable public returns (bool ind) {
137         //Default assumes totalSupply can't be over max (2^256 - 1).
138         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
139         //Replace the if with this one instead.
140         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
141         require(frozenCheck(msg.sender,_to));
142         if (balances[msg.sender] >= _value && _value > 0) {
143             balances[msg.sender] = safeSub(balances[msg.sender] , _value);
144             balances[_to]  = safeAdd(balances[_to],_value);
145             emit Transfer(msg.sender, _to, _value);
146             return true;
147         } else { return false; }
148     }
149 
150     function transferFrom(address _from, address _to, uint256 _value) stoppable public returns (bool success) {
151         //same as above. Replace this line with the following if you want to protect against wrapping uints.
152         require(frozenCheck(_from,_to));
153         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
154             balances[_to]  = safeAdd(balances[_to],_value);
155             balances[_from] = safeSub(balances[_from] , _value);
156             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
157             emit Transfer(_from, _to, _value);
158             return true;
159         } else { return false; }
160     }
161 
162     function balanceOf(address _owner) public view returns (uint256 balance) {
163         return balances[_owner];
164     }
165 
166     function approve(address _spender, uint256 _value) stoppable public returns (bool success) {
167         require(frozenCheck(_spender,msg.sender));
168         allowed[msg.sender][_spender] = _value;
169         emit Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
174         return allowed[_owner][_spender];
175     }
176     function burn(uint256 amount) stoppable onlyOwner public returns (bool){
177         if(balances[msg.sender] > amount ){
178             balances[msg.sender] = safeSub(balances[msg.sender],amount);
179             totalSupply = safeSub(totalSupply,amount);
180             emit Burn(msg.sender,amount);
181             return true;
182         }else{
183             return false;
184         }
185     }
186     function push(address _to , uint256 amount) onlyOwner public returns (bool){         ///only run once at initialize
187         balances[_to] = safeAdd(balances[_to] ,amount);
188         return true;
189     }
190     function mint(uint256 amount) onlyOwner public{
191         totalSupply = safeAdd(totalSupply, amount);
192         emit Minted(amount);
193     }
194     function frozenCheck(address _from , address _to) view private returns (bool){
195         require(!frozenAccount[_from]);
196         require(!frozenAccount[_to]);
197         return true;
198     }
199     function freezeAccount(address target , bool freeze) onlyOwner public{
200         frozenAccount[target] = freeze;
201     }
202 
203     mapping (address => uint256)                      private  balances;
204     mapping (address => mapping (address => uint256)) private  allowed;
205     mapping (address => bool)                         private  frozenAccount;    //Save frozen account
206 
207 }
208 contract BBZZXUCToken is StandardToken{
209 
210     string public name = "BBZZXUC";                                   /// Set the full name of this contract
211     uint256 public decimals = 18;                                 /// Set the decimal
212     string public symbol = "BBZZXUC";                                 /// Set the symbol of this contract
213 
214     constructor() public {                    /// Should have sth in this
215         owner = msg.sender;
216     }
217 
218     function () stoppable public {
219         revert();
220     }
221 
222 }