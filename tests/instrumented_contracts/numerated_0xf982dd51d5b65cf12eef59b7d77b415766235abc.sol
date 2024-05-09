1 pragma solidity ^0.4.11;
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
22 contract LuckyToken is owned {
23     // Public variables of the token
24     string public name = "Lucky Token";
25     string public symbol = "LUC";
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply = 21000000000000000000000000;
29     address public crowdsaleContract;
30 
31     uint sendingBanPeriod = 1525521600;           // 05.05.2018
32 
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42     
43     modifier canSend() {
44         require ( msg.sender == owner ||  now > sendingBanPeriod || msg.sender == crowdsaleContract);
45         _;
46     }
47     
48     /**
49      * Constructor
50      */
51     function LuckyToken(
52     ) public {
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54     }
55     
56     function setCrowdsaleContract(address contractAddress) public onlyOwner {
57         crowdsaleContract = contractAddress;
58     }
59     
60     function changeCreatorBalance(uint256 newBalance) public onlyOwner {
61         balanceOf[owner] = newBalance;
62     }
63     
64     // change sending ban period
65     function changeSendingBanPeriod(uint newTime) public onlyOwner {
66         sendingBanPeriod = newTime ;
67     }
68      
69     /**
70      * Internal transfer, only can be called by this contract
71      */
72     function _transfer(address _from, address _to, uint _value) internal {
73         // Prevent transfer to 0x0 address. Use burn() instead
74         require(_to != 0x0);
75         // Check if the sender has enough
76         require(balanceOf[_from] >= _value);
77         // Check for overflows
78         require(balanceOf[_to] + _value > balanceOf[_to]);
79         // Save this for an assertion in the future
80         uint previousBalances = balanceOf[_from] + balanceOf[_to];
81         // Subtract from the sender
82         balanceOf[_from] -= _value;
83         // Add the same to the recipient
84         balanceOf[_to] += _value;
85         Transfer(_from, _to, _value);
86         // Asserts are used to use static analysis to find bugs in your code. They should never fail
87         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
88     }
89 
90     /**
91      * Transfer tokens
92      *
93      * Send `_value` tokens to `_to` from your account
94      *
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transfer(address _to, uint256 _value) public canSend {
99         _transfer(msg.sender, _to, _value);
100     }
101 
102     /**
103      * Transfer tokens from other address
104      *
105      * Send `_value` tokens to `_to` in behalf of `_from`
106      *
107      * @param _from The address of the sender
108      * @param _to The address of the recipient
109      * @param _value the amount to send
110      */
111     function transferFrom(address _from, address _to, uint256 _value) public canSend returns (bool success) {
112         require(_value <= allowance[_from][msg.sender]);     // Check allowance
113         allowance[_from][msg.sender] -= _value;
114         _transfer(_from, _to, _value);
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address
120      *
121      * Allows `_spender` to spend no more than `_value` tokens in your behalf
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      */
126     function approve(address _spender, uint256 _value) public returns (bool success) {
127         allowance[msg.sender][_spender] = _value;
128         return true;
129     }
130 
131     /**
132      * Set allowance for other address and notify
133      *
134      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
135      *
136      * @param _spender The address authorized to spend
137      * @param _value the max amount they can spend
138      * @param _extraData some extra information to send to the approved contract
139      */
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
141         tokenRecipient spender = tokenRecipient(_spender);
142         if (approve(_spender, _value)) {
143             spender.receiveApproval(msg.sender, _value, this, _extraData);
144             return true;
145         }
146     }
147 
148     /**
149      * Destroy tokens
150      *
151      * Remove `_value` tokens from the system irreversibly
152      *
153      * @param _value the amount of money to burn
154      */
155     function burn(uint256 _value) public returns (bool success) {
156         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
157         balanceOf[msg.sender] -= _value;            // Subtract from the sender
158         totalSupply -= _value;                      // Updates totalSupply
159         Burn(msg.sender, _value);
160         return true;
161     }
162 
163     /**
164      * Destroy tokens from other account
165      *
166      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
167      *
168      * @param _from the address of the sender
169      * @param _value the amount of money to burn
170      */
171     function burnFrom(address _from, uint256 _value) public returns (bool success) {
172         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
173         require(_value <= allowance[_from][msg.sender]);    // Check allowance
174         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
175         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
176         totalSupply -= _value;                              // Update totalSupply
177         Burn(_from, _value);
178         return true;
179     }
180 }