1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.19;
4 
5 library SafeMath {
6  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8         return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13     }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 contract Token {
36     /* This is a slight change to the ERC20 base standard.
37     function totalSupply() constant returns (uint256 supply);
38     is replaced with:
39     uint256 public totalSupply;
40     This automatically creates a getter function for the totalSupply.
41     This is moved to the base contract since public getter functions are not
42     currently recognised as an implementation of the matching abstract
43     function by the compiler.
44     */
45     /// total amount of tokens
46     uint256 public totalSupply;
47 
48     /// @param _owner The address from which the balance will be retrieved
49     /// @return The balance
50     function balanceOf(address _owner) constant public returns (uint256 balance);
51 
52     /// @notice send `_value` token to `_to` from `msg.sender`
53     /// @param _to The address of the recipient
54     /// @param _value The amount of token to be transferred
55     /// @return Whether the transfer was successful or not
56     function transfer(address _to, uint256 _value) public returns (bool success);
57 
58     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
59     /// @param _from The address of the sender
60     /// @param _to The address of the recipient
61     /// @param _value The amount of token to be transferred
62     /// @return Whether the transfer was successful or not
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
64 
65     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @param _value The amount of tokens to be approved for transfer
68     /// @return Whether the approval was successful or not
69     function approve(address _spender, uint256 _value) public returns (bool success);
70 
71     /// @param _owner The address of the account owning tokens
72     /// @param _spender The address of the account able to transfer the tokens
73     /// @return Amount of remaining tokens allowed to spent
74     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
75 
76     event Transfer(address indexed _from, address indexed _to, uint256 _value);
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78 }
79 
80 /*
81 You should inherit from StandardToken or, for a token like you would want to
82 deploy in something like Mist, see HumanStandardToken.sol.
83 (This implements ONLY the standard functions and NOTHING else.
84 If you deploy this, you won't have anything useful.)
85 
86 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
87 .*/
88 
89 contract StandardToken is Token {
90     using SafeMath for uint256;
91 
92     function transfer(address _to, uint256 _value) public returns (bool success) {
93         require(_to != address(0));
94         require(_value <= balances[msg.sender]);
95 
96         // SafeMath.sub will throw if there is not enough balance.
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         Transfer(msg.sender, _to, _value);
100         return true;
101 
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_to != address(0));
106         require(_value <= balances[_from]);
107         require(_value <= allowed[_from][msg.sender]);
108 
109         balances[_from] = balances[_from].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112         Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     function balanceOf(address _owner) constant public returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120     function approve(address _spender, uint256 _value) public returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
127       return allowed[_owner][_spender];
128     }
129 
130     /**
131    * approve should be called when allowed[_spender] == 0. To increment
132    * allowed value is better to use this function to avoid 2 calls (and wait until
133    * the first transaction is mined)
134    */
135   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
136     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
137     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138     return true;
139   }
140 
141   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
142     uint oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue > oldValue) {
144         allowed[msg.sender][_spender] = 0;
145     } else {
146         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150    }
151 
152 
153     mapping (address => uint256) balances;
154     mapping (address => mapping (address => uint256)) allowed;
155 }
156 
157 contract HumanStandardToken is StandardToken {
158 
159     function () public {
160         //if ether is sent to this address, send it back.
161         throw;
162     }
163 
164     /* Public variables of the token */
165 
166     /*
167     NOTE:
168     The following variables are OPTIONAL vanities. One does not have to include them.
169     They allow one to customise the token contract & in no way influences the core functionality.
170     Some wallets/interfaces might not even bother to look at this information.
171     */
172     string public name;                   
173     uint8 public decimals;                
174     string public symbol;                
175     string public version = 'H0.1';
176 
177     function HumanStandardToken (
178         uint256 _initialAmount,
179         string _tokenName,
180         uint8 _decimalUnits,
181         string _tokenSymbol
182         ) internal {
183         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
184         totalSupply = _initialAmount;                        // Update total supply
185         name = _tokenName;                                   // Set the name for display purposes
186         decimals = _decimalUnits;                            // Amount of decimals for display purposes
187         symbol = _tokenSymbol;                               // Set the symbol for display purposes
188     }
189 
190     /* Approves and then calls the receiving contract */
191     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
192         allowed[msg.sender][_spender] = _value;
193         Approval(msg.sender, _spender, _value);
194 
195         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
196         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
197         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
198         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
199         return true;
200     }
201 }
202 
203 contract CreditCarToken is HumanStandardToken(10000000000000000000000000000,"CreditCar Token",18,"XCAR"){
204  function () public {
205         //if ether is sent to this address, send it back.
206         throw;
207     }
208  
209  function CreditCarToken () public {
210   
211     }
212 }