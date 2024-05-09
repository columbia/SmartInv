1 pragma solidity ^0.4.16;
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
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29     uint256 public MaxICOSellSupply;
30     uint256 public CoinsRemainAfterICO;
31     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
32     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
33     address public fundsWallet;           // Where should the raised ETH go?
34     uint public deadline;
35 
36     // This creates an array with all balances
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     // This generates a public event on the blockchain that will notify clients
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     function TokenERC20() public {
50 
51         totalSupply = 10000000 * 1 ether;                        // Update total supply (1000 for example) (CHANGE THIS)
52         MaxICOSellSupply = 9000000 * 1 ether;
53         CoinsRemainAfterICO = totalSupply - MaxICOSellSupply;
54         balanceOf[msg.sender] = totalSupply;               // Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (CHANGE THIS)
55         name = "Reference Line Coin";                                   // Set the name for display purposes (CHANGE THIS)
56         decimals = 18;                                               // Amount of decimals for display purposes (CHANGE THIS)
57         symbol = "RECO";                                             // Set the symbol for display purposes (CHANGE THIS)
58         unitsOneEthCanBuy = 10000;                                      // Set the price of your token for the ICO (CHANGE THIS)
59         fundsWallet = msg.sender;                                    // The owner of the contract gets ETH
60         deadline = now + 90000 * 1 minutes;  //ca 2 Monate ICO Periode
61     }
62 
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         // Prevent transfer to 0x0 address. Use burn() instead
68         require(_to != 0x0);
69         // Check if the sender has enough
70         require(balanceOf[_from] >= _value);
71         // Check for overflows
72         require(balanceOf[_to] + _value > balanceOf[_to]);
73         // Save this for an assertion in the future
74         uint previousBalances = balanceOf[_from] + balanceOf[_to];
75         // Subtract from the sender
76         balanceOf[_from] -= _value;
77         // Add the same to the recipient
78         balanceOf[_to] += _value;
79         Transfer(_from, _to, _value);
80         // Asserts are used to use static analysis to find bugs in your code. They should never fail
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
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public
121         returns (bool success) {
122         allowance[msg.sender][_spender] = _value;
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address and notify
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
130      *
131      * @param _spender The address authorized to spend
132      * @param _value the max amount they can spend
133      * @param _extraData some extra information to send to the approved contract
134      */
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
136         public
137         returns (bool success) {
138         tokenRecipient spender = tokenRecipient(_spender);
139         if (approve(_spender, _value)) {
140             spender.receiveApproval(msg.sender, _value, this, _extraData);
141             return true;
142         }
143     }
144 
145     function() payable public{
146         uint256 amount = msg.value * unitsOneEthCanBuy;
147         require(now < deadline);
148         require(balanceOf[fundsWallet] > amount);
149         require(balanceOf[fundsWallet]-amount > CoinsRemainAfterICO ); //Change CAD-KAS: do not sell CoinsRemainAfterICO tokens at the ICO
150 
151         totalEthInWei = totalEthInWei + msg.value;
152 
153         balanceOf[fundsWallet] = balanceOf[fundsWallet] - amount;
154         balanceOf[msg.sender] = balanceOf[msg.sender] + amount;
155 
156         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
157 
158         //Transfer ether to fundsWallet
159         fundsWallet.transfer(msg.value);
160     }
161 
162 }