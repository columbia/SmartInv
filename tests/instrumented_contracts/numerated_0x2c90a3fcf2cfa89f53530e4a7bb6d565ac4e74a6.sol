1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
5 }
6 
7 contract ERC20 {
8     
9     string public name;
10     string public symbol;
11     uint8 public decimals = 2;
12     uint256 public totalSupply;
13 
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16     
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /**
20      * Constrctor function
21      *
22      * Initializes contract with initial supply tokens to the creator of the contract
23      */
24     function ERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
25         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
26         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
27         name = tokenName;                                       // Set the name for display purposes
28         symbol = tokenSymbol;                                   // Set the symbol for display purposes
29     }
30 
31     /**
32      * Internal transfer, only can be called by this contract
33      */
34     function _transfer(address _from, address _to, uint _value) internal {
35         require(_to != 0x0);
36         require(balanceOf[_from] >= _value);
37         require(balanceOf[_to] + _value > balanceOf[_to]);
38 
39         uint previousBalances = balanceOf[_from] + balanceOf[_to];
40         balanceOf[_from] -= _value;
41         balanceOf[_to] += _value;
42         Transfer(_from, _to, _value);
43 
44         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
45     }
46 
47     /**
48      * Transfer tokens
49      *
50      * Send `_value` tokens to `_to` from your account
51      *
52      * @param _to The address of the recipient
53      * @param _value the amount to send
54      */
55     function transfer(address _to, uint256 _value) public {
56         _transfer(msg.sender, _to, _value);
57     }
58 
59     /**
60      * Transfer tokens from other address
61      *
62      * Send `_value` tokens to `_to` in behalf of `_from`
63      *
64      * @param _from The address of the sender
65      * @param _to The address of the recipient
66      * @param _value the amount to send
67      */
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         require(_value <= allowance[_from][msg.sender]);     // Check allowance
70         allowance[_from][msg.sender] -= _value;
71         _transfer(_from, _to, _value);
72         return true;
73     }
74 
75     /**
76      * Set allowance for other address
77      *
78      * Allows `_spender` to spend no more than `_value` tokens in your behalf
79      *
80      * @param _spender The address authorized to spend
81      * @param _value the max amount they can spend
82      */
83     function approve(address _spender, uint256 _value) public returns (bool success) {
84         allowance[msg.sender][_spender] = _value;
85         return true;
86     }
87 
88     /**
89      * Set allowance for other address and notify
90      *
91      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
92      *
93      * @param _spender The address authorized to spend
94      * @param _value the max amount they can spend
95      * @param _extraData some extra information to send to the approved contract
96      */
97     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
98         tokenRecipient spender = tokenRecipient(_spender);
99         if (approve(_spender, _value)) {
100             spender.receiveApproval(msg.sender, _value, this, _extraData);
101             return true;
102         }
103     }
104 
105 }
106 
107 /******************************************/
108 /*       RUSH TOKEN STARTS HERE       */
109 /******************************************/
110 
111 contract RushCoin is ERC20 {
112 
113 
114     /* Initializes contract with initial supply tokens to the creator of the contract */
115     function RushCoin() ERC20(5000000000, "Rush Coin", "RUSH") public {}
116 
117 
118     function multisend(address[] dests, uint256[] values) public returns (uint256) {
119         uint256 i = 0;
120         while (i < dests.length) {
121            transfer(dests[i], values[i]);
122            i += 1;
123         }
124         return(i);
125     }
126     
127 }