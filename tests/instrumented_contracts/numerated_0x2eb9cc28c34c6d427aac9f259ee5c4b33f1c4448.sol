1 pragma solidity ^0.4.13;
2 
3 contract owned { 
4     address public owner;
5     
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }
19 contract doftManaged { 
20     address public doftManager;
21     
22     function doftManaged() {
23         doftManager = msg.sender;
24     }
25 
26     modifier onlyDoftManager {
27         require(msg.sender == doftManager);
28         _;
29     }
30 
31     function transferDoftManagment(address newDoftManager) onlyDoftManager {
32         doftManager = newDoftManager;
33 	//coins for mining should be transferred after transferring of doftManagment
34     }
35 }
36 
37 contract ERC20 {
38     function totalSupply() constant returns (uint totalSupply);
39     function balanceOf(address _owner) constant returns (uint balance);
40     function transfer(address _to, uint _value) returns (bool success);
41     function transferFrom(address _from, address _to, uint _value) returns (bool success);
42     function approve(address _spender, uint _value) returns (bool success);
43     function allowance(address _owner, address _spender) constant returns (uint remaining);
44     event Transfer(address indexed _from, address indexed _to, uint _value);
45     event Approval(address indexed _owner, address indexed _spender, uint _value);
46 }
47 
48 contract BasicToken is ERC20 { 
49     uint256 _totalSupply;
50     
51     mapping (address => uint256) public balanceOf;
52     mapping (address => mapping (address => uint256)) public allowance;
53 
54     event Transfer(address indexed _from, address indexed _to, uint _value);
55     event Approval(address indexed _owner, address indexed _spender, uint _value);
56 
57     /// @return total amount of tokens
58     function totalSupply() constant returns (uint totalSupply){
59 	totalSupply = _totalSupply;
60     }
61 
62     /// @param _owner The address from which the balance will be retrieved
63     /// @return The balance
64     function balanceOf(address _owner) constant returns (uint balance){
65         return balanceOf[_owner];
66     }
67 
68     /* Internal transfer, only can be called by this contract */
69     function _transfer(address _from, address _to, uint _value) internal {
70         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
71         require (balanceOf[_from] > _value);                // Check if the sender has enough
72         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
73 
74         balanceOf[_from] -= _value;                         // Subtract from the sender
75         balanceOf[_to] += _value;                           // Add the same to the recipient
76         Transfer(_from, _to, _value);
77     }
78 
79     /// @notice send `_value` token to `_to` from `msg.sender`
80     /// @param _to The address of the recipient
81     /// @param _value The amount of token to be transferred
82     /// @return Whether the transfer was successful or not
83     function transfer(address _to, uint _value) returns (bool success) {
84         _transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
89     /// @param _from The address of the sender
90     /// @param _to The address of the recipient
91     /// @param _value The amount of token to be transferred
92     /// @return Whether the transfer was successful or not
93     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
94         require (_value <= allowance[_from][msg.sender]);     // Check allowance
95         allowance[_from][msg.sender] -= _value;
96         _transfer(_from, _to, _value);
97         return true;
98     }
99 
100     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
101     /// @param _spender The address of the account able to transfer the tokens
102     /// @param _value The amount of wei to be approved for transfer
103     /// @return Whether the approval was successful or not
104     function approve(address _spender, uint _value) returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106 	    Approval(msg.sender, _spender, _value);
107         return true;
108     }
109     
110     /// @param _owner The address of the account owning tokens
111     /// @param _spender The address of the account able to transfer the tokens
112     /// @return Amount of remaining tokens allowed to spent
113     function allowance(address _owner, address _spender) constant returns (uint remaining) {
114         return allowance[_owner][_spender];
115     }
116 }
117 
118 contract Doftcoin is BasicToken, owned, doftManaged { 
119     string public name; 
120     string public symbol; 
121     uint256 public decimals; 
122     uint256 public sellPrice;
123     uint256 public buyPrice;
124     uint256 public miningStorage;
125     string public version; 
126 
127     event Mine(address target, uint256 minedAmount);
128 
129     function Doftcoin() {
130         decimals = 18;
131         _totalSupply = 5000000 * (10 ** decimals);  // Update total supply
132         miningStorage = _totalSupply / 2;
133         name = "Doftcoin";                                   // Set the name for display purposes
134         symbol = "DFC";                               // Set the symbol for display purposes
135 
136         balanceOf[msg.sender] = _totalSupply;              // Give the creator all initial tokens
137 	version = "1.0";
138     }
139 
140     /// @notice Create `_mintedAmount` tokens and send it to `_target`
141     /// @param _target Address to receive the tokens
142     /// @param _mintedAmount the amount of tokens it will receive
143     function mintToken(address _target, uint256 _mintedAmount) onlyOwner {
144         require (_target != 0x0);
145 
146 	//ownership will be given to ICO after creation
147         balanceOf[_target] += _mintedAmount;
148         _totalSupply += _mintedAmount;
149         Transfer(0, this, _mintedAmount);
150         Transfer(this, _target, _mintedAmount);
151     }
152 
153     /// @notice Buy tokens from contract by sending ether
154     function buy() payable {
155 	    require(buyPrice > 0);
156         uint amount = msg.value / buyPrice;               // calculates the amount
157         _transfer(this, msg.sender, amount);              // makes the transfers
158     }
159 
160     /// @notice Sell `_amount` tokens to contract
161     /// @param _amount Amount of tokens to be sold
162     function sell(uint256 _amount) {
163 	    require(sellPrice > 0);
164         require(this.balance >= _amount * sellPrice);      // checks if the contract has enough ether to buy
165         _transfer(msg.sender, this, _amount);              // makes the transfers
166         msg.sender.transfer(_amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
167     }
168 
169     /// @notice Allow users to buy tokens for `_newBuyPrice` eth and sell tokens for `_newSellPrice` eth
170     /// @param _newSellPrice Price the users can sell to the contract
171     /// @param _newBuyPrice Price users can buy from the contract
172     function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) onlyDoftManager {
173         sellPrice = _newSellPrice;
174         buyPrice = _newBuyPrice;
175     }
176 
177     /// @notice Send `_minedAmount` to `_target` as a reward for mining
178     /// @param _target The address of the recipient
179     /// @param _minedAmount The amount of reward tokens
180     function mine(address _target, uint256 _minedAmount) onlyDoftManager {
181 	require (_minedAmount > 0);
182         require (_target != 0x0);
183         require (miningStorage - _minedAmount >= 0);
184         require (balanceOf[doftManager] >= _minedAmount);                // Check if the sender has enough
185         require (balanceOf[_target] + _minedAmount > balanceOf[_target]); // Check for overflows
186 
187 	    balanceOf[doftManager] -= _minedAmount;
188 	    balanceOf[_target] += _minedAmount;
189 	    miningStorage -= _minedAmount;
190 
191 	    Mine(_target, _minedAmount);
192     } 
193 }