1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
5 }
6 
7 contract KJC {
8     // Public variables of the token
9     string public name = "KimJ Coin";
10     string public symbol = "KJC";
11     uint8 public decimals = 18;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply =2000000* (10 ** 18);
14     uint256 public totaldivineTokensIssued = 0;
15     
16     address owner = msg.sender;
17 
18     // This creates an array with all balances
19     mapping (address => uint256) public balanceOf;
20     // Owner to authorized 
21     mapping (address => mapping (address => uint256)) public allowance;
22 
23     // ICO Variables 
24     bool public saleEnabled = true;
25     uint256 public totalEthereumRaised = 0;
26     uint256 public KJCPerEthereum = 10000;
27     
28     function KJC() public {
29         balanceOf[owner] += totalSupply;              // Give the creator all initial tokens
30     }
31 
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38 
39     /**
40      * Internal transfer, only can be called by this contract
41      */
42     function _transfer(address _from, address _to, uint _value) internal 
43     {
44         // Prevent transfer to 0x0 address. Use burn() instead
45         require(_to != 0x0);
46         // Check if the sender has enough
47         require(balanceOf[_from] >= _value);
48         // Check for overflows
49         require(balanceOf[_to] + _value > balanceOf[_to]);
50         // Save this for an assertion in the future
51         uint previousBalances = balanceOf[_from] + balanceOf[_to];
52         // Subtract from the sender
53         balanceOf[_from] -= _value;
54         // Add the same to the recipient
55         balanceOf[_to] += _value;
56         // Fire Event
57         Transfer(_from, _to, _value);
58         // Asserts are used to use static analysis to find bugs in your code. They should never fail
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     /**
63      * Transfer tokens
64      * Send `_value` tokens to `_to` from your account
65      * @param _to The address of the recipient
66      * @param _value the amount to send
67      */
68     function transfer(address _to, uint256 _value) public 
69     {
70         _transfer(msg.sender, _to, _value);
71     }
72 
73     /**
74      * Transfer tokens from other address
75      * Send `_value` tokens to `_to` on behalf of `_from`
76      * @param _from The address of the sender
77      * @param _to The address of the recipient
78      * @param _value the amount to send
79      */
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
81      {
82         require(_value <= allowance[_from][msg.sender]);     // Check allowance
83         allowance[_from][msg.sender] -= _value;
84         _transfer(_from, _to, _value);
85         return true;
86     }
87 
88     /**
89      * Set allowance for other address
90      * Allows `_spender` to spend no more than `_value` tokens on your behalf
91      * @param _spender The address authorized to spend
92      * @param _value the max amount they can spend
93      */
94     function approve(address _spender, uint256 _value) public returns (bool success) 
95     {
96         // mitigates the ERC20 spend/approval race condition
97         if (_value != 0 && allowance[msg.sender][_spender] != 0) { return false; }
98  
99         allowance[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     /**
105      * Set allowance for other address and notify
106      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
107      * @param _spender The address authorized to spend
108      * @param _value the max amount they can spend
109      * @param _extraData some extra information to send to the approved contract
110      */
111     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) 
112     {
113         tokenRecipient spender = tokenRecipient(_spender);
114         if (approve(_spender, _value)) {
115             spender.receiveApproval(msg.sender, _value, this, _extraData);
116             return true;
117         }
118     }
119 
120     // ICO 
121     function() public payable {
122         require(saleEnabled);
123         
124         if (msg.value == 0) { return; }
125 
126         owner.transfer(msg.value);
127         totalEthereumRaised += msg.value;
128 
129         uint256 tokensIssued = (msg.value * KJCPerEthereum);
130 
131         // The user buys at least 10 finney to qualify for divine multiplication
132         if (msg.value >= 10 finney) 
133         {
134 
135             bytes20 divineHash = ripemd160(block.coinbase, block.number, block.timestamp);
136             if (divineHash[0] == 0 || divineHash[0] == 1) 
137             {
138                 uint8 divineMultiplier =
139                     ((divineHash[1] & 0x01 != 0) ? 1 : 0) + ((divineHash[1] & 0x02 != 0) ? 1 : 0) +
140                     ((divineHash[1] & 0x04 != 0) ? 1 : 0) + ((divineHash[1] & 0x08 != 0) ? 1 : 0);
141                 
142                 uint256 divineTokensIssued = (msg.value * KJCPerEthereum) * divineMultiplier;
143                 tokensIssued += divineTokensIssued;
144 
145                 totaldivineTokensIssued += divineTokensIssued;
146             }
147         }
148 
149         totalSupply += tokensIssued;
150         balanceOf[msg.sender] += tokensIssued;
151         
152         Transfer(address(this), msg.sender, tokensIssued);
153     }
154 
155     function disablePurchasing() public
156     {
157         require(msg.sender == owner);
158         saleEnabled = false;
159     }
160 
161     function getStats() public constant returns (uint256, uint256, uint256, bool) {
162         return (totalEthereumRaised, totalSupply, totaldivineTokensIssued, saleEnabled);
163     }
164 }