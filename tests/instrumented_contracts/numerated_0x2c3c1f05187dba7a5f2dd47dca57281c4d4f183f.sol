1 pragma solidity ^0.4.8;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 
6 contract Token {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 /*
52 You should inherit from StandardToken or, for a token like you would want to
53 deploy in something like Mist, see HumanStandardToken.sol.
54 (This implements ONLY the standard functions and NOTHING else.
55 If you deploy this, you won't have anything useful.)
56 
57 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
58 .*/
59 
60 contract StandardToken is Token {
61 
62     uint256 constant MAX_UINT256 = 2**256 - 1;
63 
64     function transfer(address _to, uint256 _value) returns (bool success) {
65         //Default assumes totalSupply can't be over max (2^256 - 1).
66         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
67         //Replace the if with this one instead.
68         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
69         require(balances[msg.sender] >= _value);
70         balances[msg.sender] -= _value;
71         balances[_to] += _value;
72         Transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77         //same as above. Replace this line with the following if you want to protect against wrapping uints.
78         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
79         uint256 allowance = allowed[_from][msg.sender];
80         require(balances[_from] >= _value && allowance >= _value);
81         balances[_to] += _value;
82         balances[_from] -= _value;
83         if (allowance < MAX_UINT256) {
84             allowed[_from][msg.sender] -= _value;
85         }
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function balanceOf(address _owner) constant returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function approve(address _spender, uint256 _value) returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
101       return allowed[_owner][_spender];
102     }
103 
104     mapping (address => uint256) balances;
105     mapping (address => mapping (address => uint256)) allowed;
106 }
107 
108 /*
109 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
110 
111 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
112 Imagine coins, currencies, shares, voting weight, etc.
113 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
114 
115 1) Initial Finite Supply (upon creation one specifies how much is minted).
116 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
117 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
118 
119 .*/
120 
121 contract HumanStandardToken is StandardToken {
122 
123     /* Public variables of the token */
124 
125     /*
126     NOTE:
127     The following variables are OPTIONAL vanities. One does not have to include them.
128     They allow one to customise the token contract & in no way influences the core functionality.
129     Some wallets/interfaces might not even bother to look at this information.
130     */
131     string public name;                   //fancy name: eg Simon Bucks
132     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
133     string public symbol;                 //An identifier: eg SBX
134     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
135 
136     function HumanStandardToken(
137         uint256 _initialAmount,
138         string _tokenName,
139         uint8 _decimalUnits,
140         string _tokenSymbol
141         ) {
142         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
143         totalSupply = _initialAmount;                        // Update total supply
144         name = _tokenName;                                   // Set the name for display purposes
145         decimals = _decimalUnits;                            // Amount of decimals for display purposes
146         symbol = _tokenSymbol;                               // Set the symbol for display purposes
147     }
148 
149     /* Approves and then calls the receiving contract */
150     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
151         allowed[msg.sender][_spender] = _value;
152         Approval(msg.sender, _spender, _value);
153 
154         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
155         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
156         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
157         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
158         return true;
159     }
160 }
161 
162 contract QToken is HumanStandardToken {
163     
164     mapping (address => bool) authorisers;
165     address creator;
166     bool canPay = true;
167     
168     function QToken() HumanStandardToken(0, "Q", 18, "QTQ") public{
169         creator = msg.sender;
170     }
171     
172     /**
173      *  Permissions modifiers
174      */
175     
176     modifier ifCreator(){
177         if(creator != msg.sender){
178             revert();
179         }
180         _;
181     }
182     
183     modifier ifAuthorised(){
184         if(authorisers[msg.sender] || creator == msg.sender){
185             _;
186         }
187         else{
188             revert();
189         }
190     }
191     
192     modifier ifCanPay(){
193         if(!canPay){
194             revert();
195         }
196         _;
197     }
198     
199     /**
200      *  Events
201      */
202      
203     event Authorise(bytes16 _message, address indexed _actioner, address indexed _actionee);
204     
205     /**
206      *  User authorisation management methods
207      */ 
208     
209     function authorise(address _address) public ifAuthorised{
210         authorisers[_address] = true;
211         Authorise('Added', msg.sender, _address);
212     }
213     
214     function unauthorise(address _address) public ifAuthorised{
215         delete authorisers[_address];
216         Authorise('Removed', msg.sender, _address);
217     }
218     
219     function replaceAuthorised(address _toReplace, address _new) public ifAuthorised{
220         delete authorisers[_toReplace];
221         Authorise('Removed', msg.sender, _toReplace);
222         
223         authorisers[_new] = true;
224         Authorise('Added', msg.sender, _new);
225     }
226     
227     function isAuthorised(address _address) public constant returns(bool){
228         return authorisers[_address] || (creator == _address);
229     }
230     
231     /**
232      *  Special transaction methods
233      */ 
234      
235     function pay(address _address, uint256 _value) public ifCanPay ifAuthorised{
236         balances[_address] += _value;
237         totalSupply += _value;
238         
239         Transfer(address(this), _address, _value);
240     }
241     
242     function killPay() public ifCreator{
243         canPay = false;
244     }
245 }