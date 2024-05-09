1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20 {
5 
6   function balanceOf(address who) constant public returns (uint);
7   function allowance(address owner, address spender) constant public returns (uint);
8 
9   function transfer(address to, uint value) public returns (bool ok);
10   function transferFrom(address from, address to, uint value) public returns (bool ok);
11   function approve(address spender, uint value) public returns (bool ok);
12 
13   event Transfer(address indexed from, address indexed to, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 
16 }
17 
18 // Controller for Token interface
19 // Taken from https://github.com/Giveth/minime/blob/master/contracts/MiniMeToken.sol
20 
21 /// @dev The token controller contract must implement these functions
22 contract TokenController {
23     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
24     /// @param _owner The address that sent the ether to create tokens
25     /// @return True if the ether is accepted, false if it throws
26     function proxyPayment(address _owner) payable public returns(bool);
27 
28     /// @notice Notifies the controller about a token transfer allowing the
29     ///  controller to react if desired
30     /// @param _from The origin of the transfer
31     /// @param _to The destination of the transfer
32     /// @param _amount The amount of the transfer
33     /// @return False if the controller does not authorize the transfer
34     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
35 
36     /// @notice Notifies the controller about an approval allowing the
37     ///  controller to react if desired
38     /// @param _owner The address that calls `approve()`
39     /// @param _spender The spender in the `approve()` call
40     /// @param _amount The amount in the `approve()` call
41     /// @return False if the controller does not authorize the approval
42     function onApprove(address _owner, address _spender, uint _amount) public
43         returns(bool);
44 }
45 
46 
47 
48 // Token implementation
49 // sources
50 //   https://github.com/ConsenSys/Tokens
51 
52 contract Controlled {
53     /// @notice The address of the controller is the only address that can call
54     ///  a function with this modifier
55     modifier onlyController { require(msg.sender == controller); _; }
56 
57     address public controller;
58 
59     function Controlled() public { controller = msg.sender;}
60 
61     /// @notice Changes the controller of the contract
62     /// @param _newController The new controller of the contract
63     function changeController(address _newController) onlyController public {
64         controller = _newController;
65     }
66 }
67 
68 
69 contract ControlledToken is ERC20, Controlled {
70 
71     uint256 constant MAX_UINT256 = 2**256 - 1;
72 
73     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
74 
75     /* Public variables of the token */
76 
77     /*
78     NOTE:
79     The following variables are OPTIONAL vanities. One does not have to include them.
80     They allow one to customise the token contract & in no way influences the core functionality.
81     Some wallets/interfaces might not even bother to look at this information.
82     */
83     string public name;                   //fancy name: eg Simon Bucks
84     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
85     string public symbol;                 //An identifier: eg SBX
86     string public version = '1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
87     uint256 public totalSupply;
88 
89     function ControlledToken(
90         uint256 _initialAmount,
91         string _tokenName,
92         uint8 _decimalUnits,
93         string _tokenSymbol
94         )  {
95         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
96         totalSupply = _initialAmount;                        // Update total supply
97         name = _tokenName;                                   // Set the name for display purposes
98         decimals = _decimalUnits;                            // Amount of decimals for display purposes
99         symbol = _tokenSymbol;                               // Set the symbol for display purposes
100     }
101 
102 
103     function transfer(address _to, uint256 _value) returns (bool success) {
104         //Default assumes totalSupply can't be over max (2^256 - 1).
105         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
106         //Replace the if with this one instead.
107         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
108         require(balances[msg.sender] >= _value);
109 
110         if (isContract(controller)) {
111             require(TokenController(controller).onTransfer(msg.sender, _to, _value));
112         }
113 
114         balances[msg.sender] -= _value;
115         balances[_to] += _value;
116         // Alerts the token controller of the transfer
117 
118         Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
123         //same as above. Replace this line with the following if you want to protect against wrapping uints.
124         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
125         uint256 allowance = allowed[_from][msg.sender];
126         require(balances[_from] >= _value && allowance >= _value);
127 
128         if (isContract(controller)) {
129             require(TokenController(controller).onTransfer(_from, _to, _value));
130         }
131 
132         balances[_to] += _value;
133         balances[_from] -= _value;
134         if (allowance < MAX_UINT256) {
135             allowed[_from][msg.sender] -= _value;
136         }
137         Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     function balanceOf(address _owner) constant returns (uint256 balance) {
142         return balances[_owner];
143     }
144 
145     function approve(address _spender, uint256 _value) returns (bool success) {
146 
147         // Alerts the token controller of the approve function call
148         if (isContract(controller)) {
149             require(TokenController(controller).onApprove(msg.sender, _spender, _value));
150         }
151 
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
158       return allowed[_owner][_spender];
159     }
160 
161     ////////////////
162 // Generate and destroy tokens
163 ////////////////
164 
165     /// @notice Generates `_amount` tokens that are assigned to `_owner`
166     /// @param _owner The address that will be assigned the new tokens
167     /// @param _amount The quantity of tokens generated
168     /// @return True if the tokens are generated correctly
169     function generateTokens(address _owner, uint _amount ) onlyController returns (bool) {
170         uint curTotalSupply = totalSupply;
171         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
172         uint previousBalanceTo = balanceOf(_owner);
173         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
174         totalSupply = curTotalSupply + _amount;
175         balances[_owner]  = previousBalanceTo + _amount;
176         Transfer(0, _owner, _amount);
177         return true;
178     }
179 
180 
181     /// @notice Burns `_amount` tokens from `_owner`
182     /// @param _owner The address that will lose the tokens
183     /// @param _amount The quantity of tokens to burn
184     /// @return True if the tokens are burned correctly
185     function destroyTokens(address _owner, uint _amount
186     ) onlyController returns (bool) {
187         uint curTotalSupply = totalSupply;
188         require(curTotalSupply >= _amount);
189         uint previousBalanceFrom = balanceOf(_owner);
190         require(previousBalanceFrom >= _amount);
191         totalSupply = curTotalSupply - _amount;
192         balances[_owner] = previousBalanceFrom - _amount;
193         Transfer(_owner, 0, _amount);
194         return true;
195     }
196 
197     /// @notice The fallback function: If the contract's controller has not been
198     ///  set to 0, then the `proxyPayment` method is called which relays the
199     ///  ether and creates tokens as described in the token controller contract
200     function ()  payable {
201         require(isContract(controller));
202         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
203     }
204 
205     /// @dev Internal function to determine if an address is a contract
206     /// @param _addr The address being queried
207     /// @return True if `_addr` is a contract
208     function isContract(address _addr) constant internal returns(bool) {
209         uint size;
210         if (_addr == 0) return false;
211         assembly {
212             size := extcodesize(_addr)
213         }
214         return size>0;
215     }
216 
217     /// @notice This method can be used by the controller to extract mistakenly
218     ///  sent tokens to this contract.
219     /// @param _token The address of the token contract that you want to recover
220     ///  set to 0 in case you want to extract ether.
221     function claimTokens(address _token) onlyController {
222         if (_token == 0x0) {
223             controller.transfer(this.balance);
224             return;
225         }
226 
227         ControlledToken token = ControlledToken(_token);
228         uint balance = token.balanceOf(this);
229         token.transfer(controller, balance);
230         ClaimedTokens(_token, controller, balance);
231     }
232 
233 
234     mapping (address => uint256) balances;
235     mapping (address => mapping (address => uint256)) allowed;
236 
237 
238 }
239 
240 
241 
242 contract IZXToken is ControlledToken {
243 
244    function IZXToken() ControlledToken( 1, 'IZX Token', 18, 'IZX' ) public {}
245 
246 }