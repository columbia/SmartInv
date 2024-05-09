1 //////////////////////////////////////////////////////////////////////////////////////////
2 //                                                                                                                          //
3 //  Title:                      bitBond1906 Coin Creation Contract                         //
4 //  Author:                     David                                                                           //
5 //  Version:                    v1.2                                                                              //
6 //  Date of current version:    2018/12/24                                                     //
7 //                                                                                                                          //
8 //////////////////////////////////////////////////////////////////////////////////////////
9 pragma solidity >=0.4.22 <0.6.0;
10 
11 contract owned {
12     address public owner;
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function transferOwnership(address newOwner) onlyOwner public {
24         owner = newOwner;
25     }
26 }
27 
28 library SafeMath {
29    function mul(uint a, uint b) internal pure returns (uint) {
30      if (a == 0) {
31         return 0;
32       }
33 
34       uint c = a * b;
35       assert(c / a == b);
36       return c;
37    }
38 
39    function sub(uint a, uint b) internal pure returns (uint) {
40       assert(b <= a);
41       return a - b;
42    }
43 
44    function add(uint a, uint b) internal pure returns (uint) {
45       uint c = a + b;
46       assert(c >= a);
47       return c;
48    }
49 
50   function div(uint a, uint b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint c = a / b;
53     assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 }
57 
58 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
59 
60 contract TokenERC20 {
61     using SafeMath for uint256;
62     // Public variables of the token
63     string public name;
64     string public symbol;
65     uint8 public decimals = 0;
66     // 18 decimals is the strongly suggested default, avoid changing it
67     uint256 public totalSupply;
68 
69     // This creates an array with all balances
70     mapping (address => uint256) public balanceOf;
71     mapping (address => mapping (address => uint256)) public allowance;
72 
73     // This generates a public event on the blockchain that will notify clients
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     
76     // This generates a public event on the blockchain that will notify clients
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78 
79     // This notifies clients about the amount burnt
80     event Burn(address indexed from, uint256 value);
81 
82     /**
83      * Constrctor function
84      *
85      * Initializes contract with initial supply tokens to the creator of the contract
86      */
87     constructor(
88         uint256 initialSupply,
89         string memory tokenName,
90         string memory tokenSymbol
91     ) public {
92         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
93         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
94         name = tokenName;                                       // Set the name for display purposes
95         symbol = tokenSymbol;                                   // Set the symbol for display purposes
96     }
97 
98     /**
99      * Internal transfer, only can be called by this contract
100      */
101     function _transfer(address _from, address _to, uint _value) internal {
102         // Prevent transfer to 0x0 address. Use burn() instead
103         require(_to != address(0x0));
104         // Check if the sender has enough
105         require(balanceOf[_from] >= _value);
106         // Check for overflows
107         require(balanceOf[_to].add(_value) > balanceOf[_to]);
108         // Save this for an assertion in the future
109         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
110         // Subtract from the sender
111         balanceOf[_from] = balanceOf[_from].sub(_value);
112         // Add the same to the recipient
113         balanceOf[_to] =balanceOf[_to].add(_value);
114         emit Transfer(_from, _to, _value);
115         // Asserts are used to use static analysis to find bugs in your code. They should never fail
116         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
117     }
118 
119     /**
120      * Transfer tokens
121      *
122      * Send `_value` tokens to `_to` from your account
123      *
124      * @param _to The address of the recipient
125      * @param _value the amount to send
126      */
127     function transfer(address _to, uint256 _value) public returns(bool success){
128         _transfer(msg.sender, _to, _value);
129         return true;
130     }
131 
132     /**
133      * Transfer tokens from other address
134      *
135      * Send `_value` tokens to `_to` in behalf of `_from`
136      *
137      * @param _from The address of the sender
138      * @param _to The address of the recipient
139      * @param _value the amount to send
140      */
141     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
142         require(_value <= allowance[_from][msg.sender]);     // Check allowance
143         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
144         _transfer(_from, _to, _value);
145         return true;
146     }
147 
148     /**
149      * Set allowance for other address
150      *
151      * Allows `_spender` to spend no more than `_value` tokens in your behalf
152      *
153      * @param _spender The address authorized to spend
154      * @param _value the max amount they can spend
155      */
156     function approve(address _spender, uint256 _value) public
157         returns (bool success) {
158         allowance[msg.sender][_spender] = _value;
159         emit Approval(msg.sender, _spender, _value);
160         return true;
161     }
162 
163     /**
164      * Set allowance for other address and notify
165      *
166      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
167      *
168      * @param _spender The address authorized to spend
169      * @param _value the max amount they can spend
170      * @param _extraData some extra information to send to the approved contract
171      */
172     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
173         public
174         returns (bool success) {
175         tokenRecipient spender = tokenRecipient(_spender);
176         if (approve(_spender, _value)) {
177             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
178             return true;
179         }
180     }
181 
182     /**
183      * Destroy tokens
184      *
185      * Remove `_value` tokens from the system irreversibly
186      *
187      * @param _value the amount of money to burn
188      */
189     function burn(uint256 _value) public returns (bool success) {
190         require(balanceOf[msg.sender] >= _value);                             // Check if the sender has enough
191         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
192         totalSupply = totalSupply.sub(_value);                                // Updates totalSupply
193         emit Burn(msg.sender, _value);
194         return true;
195     }
196 
197     /**
198      * Destroy tokens from other account
199      *
200      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
201      *
202      * @param _from the address of the sender
203      * @param _value the amount of money to burn
204      */
205     function burnFrom(address _from, uint256 _value) public returns (bool success) {
206         require(balanceOf[_from] >= _value);                                                    // Check if the targeted balance is enough
207         require(_value <= allowance[_from][msg.sender]);                                        // Check allowance
208         balanceOf[_from] = balanceOf[_from].sub(_value);                                        // Subtract from the targeted balance
209         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);                // Subtract from the sender's allowance
210         totalSupply = totalSupply.sub(_value);                                                  // Update totalSupply
211         emit Burn(_from, _value);
212         return true;
213     }
214 }
215 
216 /******************************************/
217 /*       ADVANCED TOKEN STARTS HERE       */
218 /******************************************/
219 
220 contract bitBond1906 is owned, TokenERC20 {
221     using SafeMath for uint256;
222 
223     mapping (address => bool) public frozenAccount;
224 
225     /* This generates a public event on the blockchain that will notify clients */
226     event FrozenFunds(address target, bool frozen);
227 
228     /* Initializes contract with initial supply tokens to the creator of the contract */
229     constructor(
230         uint256 initialSupply,
231         string memory tokenName,
232         string memory tokenSymbol
233     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
234 
235     /* Internal transfer, only can be called by this contract */
236     function _transfer(address _from, address _to, uint _value) internal {
237         require (_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
238         require (balanceOf[_from] >= _value);               // Check if the sender has enough
239         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
240         require(!frozenAccount[_from]);                     // Check if sender is frozen
241         require(!frozenAccount[_to]);                       // Check if recipient is frozen
242         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
243         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
244         emit Transfer(_from, _to, _value);
245     }
246 
247     /// @notice Create `mintedAmount` tokens and send it to `target`
248     /// @param target Address to receive the tokens
249     /// @param mintedAmount the amount of tokens it will receive
250     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
251         balanceOf[target] = balanceOf[target].add(mintedAmount);
252         totalSupply = totalSupply.add(mintedAmount);
253         emit Transfer(address(0), address(this), mintedAmount);
254         emit Transfer(address(this), target, mintedAmount);
255     }
256 
257     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
258     /// @param target Address to be frozen
259     /// @param freeze either to freeze it or not
260     function freezeAccount(address target, bool freeze) onlyOwner public {
261         frozenAccount[target] = freeze;
262         emit FrozenFunds(target, freeze);
263     }
264 
265 }