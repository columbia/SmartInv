1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract SoundTribeToken is owned{
23     // Public variables
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28 
29     // Balances array
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     //ERC20 events
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37     /**
38      * Constrctor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     function SoundTribeToken(
43         uint256 initialSupply
44     ) public {
45         totalSupply = initialSupply * 10 ** uint256(decimals);
46         balanceOf[msg.sender] = totalSupply;
47         name = "Sound Tribe Token"; 
48         symbol = "STS9";
49         decimals = 18;
50     }
51 
52     /**
53      * ERC20 balance function
54      */
55     function balanceOf(address _owner) public constant returns (uint256 balance) {
56         return balanceOf[_owner];
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Check if the sender has enough
64         require(balanceOf[_from] >= _value);
65         // Prevent transfer to 0x0 address. Use burn() instead
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balanceOf[_from] >= _value);
69         // Check for overflows
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71         // Save this for an assertion in the future
72         uint previousBalances = balanceOf[_from] + balanceOf[_to];
73         // Subtract from the sender
74         balanceOf[_from] -= _value;
75         // Add the same to the recipient
76         balanceOf[_to] += _value;
77         Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80         // Failsafe logic that should never be false
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public {
93         _transfer(msg.sender, _to, _value);
94     }
95 
96     /**
97      * Transfer tokens from other address
98      *
99      * Send `_value` tokens to `_to` in behalf of `_from`
100      *
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address
114      *
115      * Allows `_spender` to spend no more than `_value` tokens on your behalf
116      *
117      * @param _spender the address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public returns (bool success) {
121         
122         allowance[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     /**
128      * Set allowance for other address and notify
129      *
130      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
131      *
132      * @param _spender the address authorized to spend
133      * @param _value the max amount they can spend
134      * @param _extraData some extra information to send to the approved contract
135      */
136     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
137         tokenRecipient spender = tokenRecipient(_spender);
138         if (approve(_spender, _value)) {
139             spender.receiveApproval(msg.sender, _value, this, _extraData);
140             return true;
141         }
142     }
143 
144 }
145 
146 contract AdvSoundTribeToken is owned, SoundTribeToken {
147 
148 
149     /* Initializes contract with initial supply tokens to the creator of the contract */
150     function AdvSoundTribeToken(
151         uint256 initialSupply
152     ) SoundTribeToken(initialSupply) public {}
153 
154     /* Internal transfer, only can be called by this contract */
155     function _transfer(address _from, address _to, uint _value) internal {
156         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
157         require (balanceOf[_from] >= _value);               // Check if the sender has enough
158         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
159         balanceOf[_from] -= _value;                         // Subtract from the sender
160         balanceOf[_to] += _value;                           // Add the same to the recipient
161         Transfer(_from, _to, _value);
162     }
163 
164     /// @notice Create `mintedAmount` tokens and send it to `target`
165     /// @param target Address to receive the tokens
166     /// @param mintedAmount the amount of tokens it will receive
167     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
168         balanceOf[target] += mintedAmount;
169         totalSupply += mintedAmount;
170         Transfer(0, this, mintedAmount);
171         Transfer(this, target, mintedAmount);
172     }
173 
174 }