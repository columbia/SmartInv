1 pragma solidity >=0.4.22 <0.6.0;
2 
3   // ----------------------------------------------------------------------------------------------
4   // UCoin Token Contract
5   // UNIVERSAL COIN INTERNATIONAL INC
6   // V.1.4 Fixed (FINAL)
7   // ----------------------------------------------------------------------------------------------
8 
9 // ----------------------------------------------------------------------------
10 // Safe maths
11 // ----------------------------------------------------------------------------
12 contract SafeMath {
13     function safeAdd(uint a, uint b) public pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function safeSub(uint a, uint b) public pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function safeMul(uint a, uint b) public pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function safeDiv(uint a, uint b) public pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 contract Owned {
32     
33     address public owner;
34     
35     function owned() public  {
36         owner = msg.sender;
37 
38     }
39     constructor() payable public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48 }
49 
50 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData)  external; }
51 
52 contract TokenERC20 is SafeMath{
53     // Public variables of the token
54     string public name  ;
55     string public symbol  ;
56     uint8 public decimals = 18;
57     // 18 decimals is the strongly suggested default, avoid changing it
58     uint256 public totalSupply ;
59 
60     // This creates an array with all balances
61     mapping (address => uint256) public balanceOf;
62     mapping (address => mapping (address => uint256)) public allowance;
63 
64     // This generates a public event on the blockchain that will notify clients
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     // This notifies clients about the amount burnt
68     event Burn(address indexed from, uint256 value);
69 
70     /**
71      * Constructor function
72      *
73      * Initializes contract with initial supply tokens to the creator of the contract
74      */
75     function TokenERC20(
76         uint256 initialSupply,
77         string tokenName,
78         string tokenSymbol
79     ) public {
80         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
81         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
82         name = tokenName;                                   // Set the name for display purposes
83         symbol = tokenSymbol;                               // Set the symbol for display purposes
84         emit Transfer(address(0), msg.sender, totalSupply);
85 
86     }
87 
88     /**
89      * Transfer tokens
90      *
91      * Send `_value` tokens to `to` from your account
92      *
93      * @param to The address of the recipient
94      * @param tokens the amount to send
95      */
96   
97     function transfer(address to, uint tokens) payable public returns (bool success) {
98         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], tokens);
99         balanceOf[to] = safeAdd(balanceOf[to], tokens);
100         emit Transfer(msg.sender, to, tokens);
101         return true;
102     }
103 
104     
105     /**
106      * Transfer tokens from other address
107      *
108      * Send `tokens` tokens to `to` in behalf of `from`
109      *
110      * @param from The address of the sender
111      * @param to The address of the recipient
112      * @param tokens the amount to send
113      */
114 
115     function transferFrom(address from, address to, uint tokens) payable public returns (bool success) {
116         balanceOf[from] = safeSub(balanceOf[from], tokens);
117         allowance[from][msg.sender] = safeSub(allowance[from][msg.sender], tokens);
118         balanceOf[to] = safeAdd(balanceOf[to], tokens);
119         emit Transfer(from, to, tokens);
120         return true;
121     }
122 
123 
124     /**
125      * Set allowance for other address
126      *
127      * Allows `_spender` to spend no more than `_value` tokens in your behalf
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      */
132     function approve(address _spender, uint256 _value) public
133         returns (bool success) {
134         allowance[msg.sender][_spender] = _value;
135         return true;
136     }
137 
138     /**
139      * Set allowance for other address and notify
140      *
141      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
142      *
143      * @param _spender The address authorized to spend
144      * @param _value the max amount they can spend
145      * @param _extraData some extra information to send to the approved contract
146      */
147     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
148         public
149         returns (bool success) {
150         tokenRecipient spender = tokenRecipient(_spender);
151         if (approve(_spender, _value)) {
152             spender.receiveApproval(msg.sender, _value, this, _extraData);
153             return true;
154         }
155     }
156  
157 }
158 
159 contract UCoinToken is Owned, TokenERC20 {
160 
161     mapping (address => bool) public frozenAccount;
162 
163     /* This generates a public event on the blockchain that will notify clients */
164     event FrozenFunds(address target, bool frozen);
165 
166     /* Initializes contract with initial supply tokens to the creator of the contract */
167     function UCoinToken(
168 
169     ) 
170 
171     TokenERC20(5000000000, "UCoin", "UCoin") public {}
172 
173     
174     /// @notice Will cause a certain `_value` of coins minted for `_to`.
175     /// @param _to The address that will receive the coin.
176      /// @param _value The amount of coin they will receive.
177     function mint(address _to, uint _value) payable public {
178         require(msg.sender == owner); // assuming you have a contract owner
179         mintToken(_to, _value);
180     }
181  
182     function mintToken(address target, uint256 mintedAmount) internal {
183         //balanceOf[target] += mintedAmount;
184         balanceOf[target] = safeAdd(balanceOf[target], mintedAmount);
185         
186     }
187     
188     /// @notice Will allow multiple minting within a single call to save gas.
189     /// @param _to_list A list of addresses to mint for.
190     /// @param _values The list of values for each respective `_to` address.
191     function airdropMinting(address[] _to_list, uint[] _values) payable public  {
192         require(msg.sender == owner); // assuming you have a contract owner
193         require(_to_list.length == _values.length);
194         for (uint i = 0; i < _to_list.length; i++) {
195             mintToken(_to_list[i], _values[i]);
196         }
197     }
198 
199     function  freezeAccount(address target, bool freeze) payable public {
200         require(msg.sender == owner); // assuming you have a contract owner
201         frozenAccount[target] = freeze;
202         emit FrozenFunds(target, freeze);
203     }
204     /**
205      * Destroy tokens
206      *
207      * Remove `_value` tokens from the system irreversibly
208      *
209      * @param _value the amount of money to burn
210      */
211     function burn(uint256 _value) payable public  returns (bool success) {
212         require(msg.sender == owner); // assuming you have a contract owner
213         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
214         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);  // Subtract from the sender
215         totalSupply = safeSub(totalSupply, _value);   // Updates totalSupply
216         emit Burn(msg.sender, _value); //event
217         return true;
218     }
219 
220     /**
221      * Destroy tokens from other account
222      *
223      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
224      *
225      * @param _from the address of the sender
226      * @param _value the amount of money to burn
227      */
228     function burnFrom(address _from, uint256 _value) payable public returns (bool success) {
229         require(msg.sender == owner); // assuming you have a contract owner
230         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
231         require(_value <= allowance[_from][msg.sender]);    // Check allowance
232         balanceOf[_from] = safeSub(balanceOf[_from], _value); // Subtract from the targeted balance
233         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value); // Subtract from the sender's allowance  
234         totalSupply = safeSub(totalSupply, _value);  // Update totalSupply
235         emit Burn(_from, _value); //event
236         return true;
237     }
238 
239 }