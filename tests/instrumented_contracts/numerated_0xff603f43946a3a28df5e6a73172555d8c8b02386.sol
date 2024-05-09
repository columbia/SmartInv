1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4 
5     /// `owner` is the only address that can call a function with this
6     /// modifier
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     address public owner;
13 
14     /// @notice The Constructor assigns the message sender to be `owner`
15     function Owned() {
16         owner = msg.sender;
17     }
18 
19     address newOwner=0x0;
20 
21     event OwnerUpdate(address _prevOwner, address _newOwner);
22 
23     ///change the owner
24     function changeOwner(address _newOwner) public onlyOwner {
25         require(_newOwner != owner);
26         newOwner = _newOwner;
27     }
28 
29     /// accept the ownership
30     function acceptOwnership() public{
31         require(msg.sender == newOwner);
32         OwnerUpdate(owner, newOwner);
33         owner = newOwner;
34         newOwner = 0x0;
35     }
36 }
37 
38 contract Token {
39     /* This is a slight change to the ERC20 base standard.
40     function totalSupply() constant returns (uint256 supply);
41     is replaced with:
42     uint256 public totalSupply;
43     This automatically creates a getter function for the totalSupply.
44     This is moved to the base contract since public getter functions are not
45     currently recognised as an implementation of the matching abstract
46     function by the compiler.
47     */
48     /// total amount of tokens
49     uint256 public totalSupply;
50 
51     /// @param _owner The address from which the balance will be retrieved
52     /// @return The balance
53     function balanceOf(address _owner) constant returns (uint256 balance);
54 
55     /// @notice send `_value` token to `_to` from `msg.sender`
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transfer(address _to, uint256 _value) returns (bool success);
60 
61     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
62     /// @param _from The address of the sender
63     /// @param _to The address of the recipient
64     /// @param _value The amount of token to be transferred
65     /// @return Whether the transfer was successful or not
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
67 
68     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @param _value The amount of tokens to be approved for transfer
71     /// @return Whether the approval was successful or not
72     function approve(address _spender, uint256 _value) returns (bool success);
73 
74     /// @param _owner The address of the account owning tokens
75     /// @param _spender The address of the account able to transfer the tokens
76     /// @return Amount of remaining tokens allowed to spent
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81 }
82 
83 contract Controlled is Owned{
84 
85     function Controlled() {
86        setExclude(msg.sender);
87     }
88 
89     // Flag that determines if the token is transferable or not.
90     bool public transferEnabled = false;
91 
92     // flag that makes locked address effect
93     bool lockFlag=true;
94     mapping(address => bool) locked;
95     mapping(address => bool) exclude;
96 
97     function enableTransfer(bool _enable) 
98     public onlyOwner{
99         transferEnabled=_enable;
100     }
101     function disableLock(bool _enable)
102     onlyOwner
103     returns (bool success){
104         lockFlag=_enable;
105         return true;
106     }
107     function addLock(address _addr) 
108     onlyOwner 
109     returns (bool success){
110         require(_addr!=msg.sender);
111         locked[_addr]=true;
112         return true;
113     }
114 
115     function setExclude(address _addr) 
116     onlyOwner 
117     returns (bool success){
118         exclude[_addr]=true;
119         return true;
120     }
121     function removeLock(address _addr)
122     onlyOwner
123     returns (bool success){
124         locked[_addr]=false;
125         return true;
126     }
127 
128     modifier transferAllowed {
129         if (!exclude[msg.sender]) {
130             assert(transferEnabled);
131             if(lockFlag){
132                 assert(!locked[msg.sender]);
133             }
134         }
135         
136         _;
137     }
138   
139 }
140 
141 /*
142 You should inherit from StandardToken or, for a token like you would want to
143 deploy in something like Mist, see HumanStandardToken.sol.
144 (This implements ONLY the standard functions and NOTHING else.
145 If you deploy this, you won't have anything useful.)
146 
147 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
148 .*/
149 
150 contract StandardToken is Token,Controlled {
151 
152     function transfer(address _to, uint256 _value) transferAllowed returns (bool success) {
153         //Default assumes totalSupply can't be over max (2^256 - 1).
154         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
155         //Replace the if with this one instead.
156         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
157         if (balances[msg.sender] >= _value && _value > 0) {
158             balances[msg.sender] -= _value;
159             balances[_to] += _value;
160             Transfer(msg.sender, _to, _value);
161             return true;
162         } else { return false; }
163     }
164 
165     function transferFrom(address _from, address _to, uint256 _value) transferAllowed returns (bool success) {
166         //same as above. Replace this line with the following if you want to protect against wrapping uints.
167         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
168         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
169             balances[_to] += _value;
170             balances[_from] -= _value;
171             allowed[_from][msg.sender] -= _value;
172             Transfer(_from, _to, _value);
173             return true;
174         } else { return false; }
175     }
176 
177     function balanceOf(address _owner) constant returns (uint256 balance) {
178         return balances[_owner];
179     }
180 
181     function approve(address _spender, uint256 _value) returns (bool success) {
182         allowed[msg.sender][_spender] = _value;
183         Approval(msg.sender, _spender, _value);
184         return true;
185     }
186 
187     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
188       return allowed[_owner][_spender];
189     }
190 
191     mapping (address => uint256) balances;
192     mapping (address => mapping (address => uint256)) allowed;
193 }
194 
195 contract HumanStandardToken is StandardToken {
196 
197     function () {
198         //if ether is sent to this address, send it back.
199         throw;
200     }
201 
202     /* Public variables of the token */
203 
204     /*
205     NOTE:
206     The following variables are OPTIONAL vanities. One does not have to include them.
207     They allow one to customise the token contract & in no way influences the core functionality.
208     Some wallets/interfaces might not even bother to look at this information.
209     */
210     string public name;                   //fancy name: eg Simon Bucks
211     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
212     string public symbol;                 //An identifier: eg SBX
213     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
214 
215     function HumanStandardToken() {
216         totalSupply = 400000000 * (10 ** 18); 
217         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
218         name = "OneRoot Network Token";                                   // Set the name for display purposes
219         decimals = 18;                            // Amount of decimals for display purposes
220         symbol = "RNT";                               // Set the symbol for display purposes
221     }
222 
223     /* Approves and then calls the receiving contract */
224     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
225         allowed[msg.sender][_spender] = _value;
226         Approval(msg.sender, _spender, _value);
227 
228         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
229         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
230         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
231         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
232         return true;
233     }
234 }