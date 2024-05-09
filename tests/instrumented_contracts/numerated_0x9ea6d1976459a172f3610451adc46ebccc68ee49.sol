1 pragma solidity ^0.4.19;
2 
3 // File: contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 // File: contracts/ERC20.sol
39 
40 // Abstract contract for the full ERC 20 Token standard
41 // https://github.com/ethereum/EIPs/issues/20
42 pragma solidity ^0.4.19;
43 
44 
45 /*
46 This contract was editted and deploy by ICONEMY - An platform that makes crypto easy! 
47 For more information check: www.iconemy.io
48 
49 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans. 
50 
51 This contract was adapted by Iconemy to suit the EtherMania token.
52 */
53 contract ERC20 {
54     using SafeMath for uint256;
55 
56     /* Public variables of the token */
57     uint256 constant MAX_UINT256 = 2**256 - 1;
58     string public name = "EtherMania Asset";                   
59     uint8 public decimals = 18;                
60     string public symbol = "EMA";                 
61     uint256 public totalSupply = 1200000000000000000000000;  
62     uint256 public multiplier = 100000000;
63     address public initialOwner = 0x715b94a938dC6c3651CD43bd61284719772F3D86;
64     mapping (address => uint256) balances;   
65 
66     function ERC20() public {
67         balances[initialOwner] = totalSupply;               
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
88     // Get the balance of this caller
89     function balanceOf(address _owner) constant public returns (uint256 balance) {
90         return balances[_owner];
91     }
92 
93     function transfer(address _to, uint256 _value) public returns (bool success) {
94         //Call internal transfer method
95         if(_transfer(msg.sender, _to, _value)){
96             return true;
97         } else {
98             return false;
99         }
100     }
101 
102     function _transfer(address _from, address _to, uint256 _value) internal returns(bool success){
103         // Prevent transfer to 0x0 address. Use burn() instead
104         require(_to != 0x0);
105         // Check if the sender has enough
106         require(balances[_from] >= _value);
107         // Check for overflows (as max number is 2**256 - 1 - balances will overflow after that)
108         require(balances[_to] + _value > balances[_to]);
109         // Save this for an assertion in the future
110         uint previousBalances = balances[_from] + balances[_to];
111         // Subtract from the sender
112         balances[_from] = balances[_from].sub(_value);
113         // Add the same to the recipient
114         balances[_to] =  balances[_to].add(_value);
115 
116         Transfer(_from, _to, _value);
117 
118         // Asserts are used to use static analysis to find bugs in your code. They should never fail
119         assert(balances[_from] + balances[_to] == previousBalances);
120 
121         return true;
122     }
123 }
124 
125 // File: contracts/ERC20_allowance.sol
126 
127 // Abstract contract for the full ERC 20 Token standard
128 // https://github.com/ethereum/EIPs/issues/20
129 pragma solidity ^0.4.19;
130 
131 
132 
133 /*
134 This contract was editted and deploy by ICONEMY - An platform that makes crypto easy! 
135 For more information check: www.iconemy.io
136 
137 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
138 
139 This contract was then adapted by Iconemy to suit the EtherMania token 
140 
141 1) Initial Finite Supply (upon creation one specifies how much is minted).
142 2) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
143 */
144 contract ERC20_allowance is ERC20 {
145     using SafeMath for uint256;
146 
147     mapping (address => mapping (address => uint256)) allowed;   
148 
149     // Constructor function which takes in values from migrations and passes to parent contract
150     function ERC20_allowance() public ERC20() {}
151 
152     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
153 
154     // Get the allowance of a spender for a certain account
155     function allowanceOf(address _owner, address _spender) public constant returns (uint256 remaining) {
156         return allowed[_owner][_spender];
157     }
158 
159     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
160         //Check the allowance of the address spending tokens on behalf of account
161         uint256 allowance = allowanceOf(_from, msg.sender);
162         //Require that they must have more in their allowance than they wish to send
163         require(allowance >= _value);
164 
165         //Require that allowance isnt the max integer
166         require(allowance < MAX_UINT256);
167             
168         //If so, take from their allowance and transfer
169         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170 
171         if(_transfer(_from, _to, _value)){
172             return true;
173         } else {
174             return false;
175         } 
176         
177     }
178 
179     // Approve the allowance for a certain spender
180     function approve(address _spender, uint256 _value) public returns (bool success) {
181         allowed[msg.sender][_spender] = _value;
182         Approval(msg.sender, _spender, _value);
183         return true;
184     }
185 
186     function approveAndCall(address _spender, uint256 _value) public returns (bool success) {
187         // This function is used by contracts to allowing the token to notify them when an approval has been made. 
188         tokenSpender spender = tokenSpender(_spender);
189 
190         if(approve(_spender, _value)){
191             spender.receiveApproval();
192             return true;
193         }
194     }
195 }
196 
197 // Interface for Metafusions crowdsale contract
198 contract tokenSpender { 
199     function receiveApproval() external; 
200 }