1 pragma solidity ^0.4.21;
2 
3 /******************************************/
4 /*       Netkiller ADVANCED TOKEN         */
5 /******************************************/
6 /* Author netkiller <netkiller@msn.com>   */
7 /* Home http://www.netkiller.cn           */
8 /* Version 2018-05-09 - Add Global lock   */
9 /******************************************/
10 
11 contract NetkillerToken {
12     address public owner;
13     // Public variables of the token
14     string public name;
15     string public symbol;
16     uint public decimals;
17     // 18 decimals is the strongly suggested default, avoid changing it
18     uint256 public totalSupply;
19 
20     // This creates an array with all balances
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowance;
23 
24     // This generates a public event on the blockchain that will notify clients
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     // This notifies clients about the amount burnt
28     event Burn(address indexed from, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30     
31     mapping (address => bool) public frozenAccount;
32 
33     /* This generates a public event on the blockchain that will notify clients */
34     event FrozenFunds(address target, bool frozen);
35 
36     bool lock = false;
37 
38     /**
39      * Constrctor function
40      *
41      * Initializes contract with initial supply tokens to the creator of the contract
42      */
43     function NetkillerToken(
44         uint256 initialSupply,
45         string tokenName,
46         string tokenSymbol,
47         uint decimalUnits
48     ) public {
49         owner = msg.sender;
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol; 
52         decimals = decimalUnits;
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial token
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     modifier isLock {
63         require(!lock);
64         _;
65     }
66     
67     function setLock(bool _lock) onlyOwner public{
68         lock = _lock;
69     }
70 
71     function transferOwnership(address newOwner) onlyOwner public {
72         if (newOwner != address(0)) {
73             owner = newOwner;
74         }
75     }
76  
77     /* Internal transfer, only can be called by this contract */
78     function _transfer(address _from, address _to, uint _value) isLock internal {
79         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
80         require (balanceOf[_from] >= _value);               // Check if the sender has enough
81         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
82         require(!frozenAccount[_from]);                     // Check if sender is frozen
83         require(!frozenAccount[_to]);                       // Check if recipient is frozen
84         balanceOf[_from] -= _value;                         // Subtract from the sender
85         balanceOf[_to] += _value;                           // Add the same to the recipient
86         emit Transfer(_from, _to, _value);
87     }
88 
89     /**
90      * Transfer tokens
91      *
92      * Send `_value` tokens to `_to` from your account
93      *
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transfer(address _to, uint256 _value) public {
98         _transfer(msg.sender, _to, _value);
99     }
100 
101     /**
102      * Transfer tokens from other address
103      *
104      * Send `_value` tokens to `_to` in behalf of `_from`
105      *
106      * @param _from The address of the sender
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         require(_value <= allowance[_from][msg.sender]);     // Check allowance
112         allowance[_from][msg.sender] -= _value;
113         _transfer(_from, _to, _value);
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      */
125     function approve(address _spender, uint256 _value) public returns (bool success) {
126         allowance[msg.sender][_spender] = _value;
127         emit Approval(msg.sender, _spender, _value);
128         return true;
129     }
130 
131     /**
132      * Destroy tokens
133      *
134      * Remove `_value` tokens from the system irreversibly
135      *
136      * @param _value the amount of money to burn
137      */
138     function burn(uint256 _value) onlyOwner public returns (bool success) {
139         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
140         balanceOf[msg.sender] -= _value;            // Subtract from the sender
141         totalSupply -= _value;                      // Updates totalSupply
142         emit Burn(msg.sender, _value);
143         return true;
144     }
145 
146     /**
147      * Destroy tokens from other account
148      *
149      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
150      *
151      * @param _from the address of the sender
152      * @param _value the amount of money to burn
153      */
154     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
155         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
156         require(_value <= allowance[_from][msg.sender]);    // Check allowance
157         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
158         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
159         totalSupply -= _value;                              // Update totalSupply
160         emit Burn(_from, _value);
161         return true;
162     }
163 
164     /// @notice Create `mintedAmount` tokens and send it to `target`
165     /// @param target Address to receive the tokens
166     /// @param mintedAmount the amount of tokens it will receive
167     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
168         uint256 _amount = mintedAmount * 10 ** uint256(decimals);
169         balanceOf[target] += _amount;
170         totalSupply += _amount;
171         emit Transfer(this, target, _amount);
172     }
173 
174     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
175     /// @param target Address to be frozen
176     /// @param freeze either to freeze it or not
177     function freezeAccount(address target, bool freeze) onlyOwner public {
178         frozenAccount[target] = freeze;
179         emit FrozenFunds(target, freeze);
180     }
181 }