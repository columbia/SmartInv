1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 // Abstract contract for the full ERC 20 Token standard
37 // https://github.com/ethereum/EIPs/issues/20
38 pragma solidity ^0.4.19;
39 
40 /*
41 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
42 
43 This contract was then adapted by Iconemy to suit the MetaFusion token 
44 */
45 contract ERC20_mtf{
46     using SafeMath for uint256;
47 
48     /* Public variables of the token */
49 
50     /*
51     NOTE:
52     The following variables are OPTIONAL vanities. One does not have to include them.
53     They allow one to customise the token contract & in no way influences the core functionality.
54     Some wallets/interfaces might not even bother to look at this information.
55     */
56     uint256 constant MAX_UINT256 = 2**256 - 1;
57     string public name = 'MetaFusion';              //fancy name: eg Simon Bucks
58     uint8 public decimals = 5;                      //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
59     string public symbol = 'MTF';                   //An identifier: eg SBX
60     uint256 public totalSupply = 10000000000000;  
61     uint256 public multiplier = 100000;
62     mapping (address => uint256) balances;   
63 
64     function ERC20_mtf(
65         address _owner
66     ) public {
67         balances[_owner] = totalSupply;               // Give the creator all initial tokens
68     }
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Burn(address indexed burner, uint256 value);
72 
73     /**
74      * @dev Burns a specific amount of tokens.
75      * @param _value The amount of token to be burned.
76      */
77     function burn(uint256 _value) public {
78         require(_value <= balances[msg.sender]);
79         // no need to require value <= totalSupply, since that would imply the
80         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
81 
82         address burner = msg.sender;
83         balances[burner] = balances[burner].sub(_value);
84         totalSupply = totalSupply.sub(_value);
85         Burn(burner, _value);
86     }
87 
88 
89     // Get the balance of this caller
90     function balanceOf(address _owner) constant public returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function transfer(address _to, uint256 _value) public returns (bool success) {
95         //Call internal transfer method
96         if(_transfer(msg.sender, _to, _value)){
97             return true;
98         } else {
99             return false;
100         }
101     }
102 
103     function _transfer(address _from, address _to, uint256 _value) internal returns(bool success){
104         // Prevent transfer to 0x0 address. Use burn() instead
105         require(_to != 0x0);
106         // Check if the sender has enough
107         require(balances[_from] >= _value);
108         // Check for overflows (as max number is 2**256 - 1 - balances will overflow after that)
109         require(balances[_to] + _value > balances[_to]);
110         // Save this for an assertion in the future
111         uint previousBalances = balances[_from] + balances[_to];
112         // Subtract from the sender
113         balances[_from] = balances[_from].sub(_value);
114         // Add the same to the recipient
115         balances[_to] =  balances[_to].add(_value);
116 
117         Transfer(_from, _to, _value);
118 
119         // Asserts are used to use static analysis to find bugs in your code. They should never fail
120         assert(balances[_from] + balances[_to] == previousBalances);
121 
122         return true;
123     }
124 }
125 
126 // Abstract contract for the full ERC 20 Token standard
127 // https://github.com/ethereum/EIPs/issues/20
128 pragma solidity ^0.4.19;
129 
130 /*
131 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
132 
133 This contract was then adapted by Iconemy to suit the MetaFusion token 
134 
135 1) Initial Finite Supply (upon creation one specifies how much is minted).
136 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
137 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
138 
139 */
140 contract ERC20_mtf_allowance is ERC20_mtf {
141     using SafeMath for uint256;
142 
143     mapping (address => mapping (address => uint256)) allowed;   
144 
145     // Constructor function which takes in values from migrations and passes to parent contract
146     function ERC20_mtf_allowance(
147         address _owner
148     ) public ERC20_mtf(_owner){}
149 
150     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
151 
152     // Get the allowance of a spender for a certain account
153     function allowanceOf(address _owner, address _spender) public constant returns (uint256 remaining) {
154         return allowed[_owner][_spender];
155     }
156 
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
158         //Check the allowance of the address spending tokens on behalf of account
159         uint256 allowance = allowanceOf(_from, msg.sender);
160         //Require that they must have more in their allowance than they wish to send
161         require(allowance >= _value);
162 
163         //Require that allowance isnt the max integer
164         require(allowance < MAX_UINT256);
165             
166         //If so, take from their allowance and transfer
167         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168 
169         if(_transfer(_from, _to, _value)){
170             return true;
171         } else {
172             return false;
173         } 
174         
175     }
176 
177     // Approve the allowance for a certain spender
178     function approve(address _spender, uint256 _value) public returns (bool success) {
179         allowed[msg.sender][_spender] = _value;
180         Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     function approveAndCall(address _spender, uint256 _value) public returns (bool success) {
185         // This function is used by contracts to allowing the token to notify them when an approval has been made. 
186         tokenSpender spender = tokenSpender(_spender);
187 
188         if(approve(_spender, _value)){
189             spender.receiveApproval();
190             return true;
191         }
192     }
193 }
194 
195 // Interface for Metafusions crowdsale contract
196 contract tokenSpender { 
197     function receiveApproval() external; 
198 }