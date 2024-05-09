1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
5 }
6 
7 contract ERC20 {
8     
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
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
24     function ERC20(
25         uint256 initialSupply,
26         string tokenName,
27         string tokenSymbol
28     ) public {
29         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
30         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
31         name = tokenName;                                       // Set the name for display purposes
32         symbol = tokenSymbol;                                   // Set the symbol for display purposes
33     }
34 
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39         require(_to != 0x0);
40         require(balanceOf[_from] >= _value);
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42 
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         balanceOf[_from] -= _value;
45         balanceOf[_to] += _value;
46         Transfer(_from, _to, _value);
47 
48         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
49     }
50 
51     /**
52      * Transfer tokens
53      *
54      * Send `_value` tokens to `_to` from your account
55      *
56      * @param _to The address of the recipient
57      * @param _value the amount to send
58      */
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63     /**
64      * Transfer tokens from other address
65      *
66      * Send `_value` tokens to `_to` in behalf of `_from`
67      *
68      * @param _from The address of the sender
69      * @param _to The address of the recipient
70      * @param _value the amount to send
71      */
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_value <= allowance[_from][msg.sender]);     // Check allowance
74         allowance[_from][msg.sender] -= _value;
75         _transfer(_from, _to, _value);
76         return true;
77     }
78 
79     /**
80      * Set allowance for other address
81      *
82      * Allows `_spender` to spend no more than `_value` tokens in your behalf
83      *
84      * @param _spender The address authorized to spend
85      * @param _value the max amount they can spend
86      */
87     function approve(address _spender, uint256 _value) public
88         returns (bool success) {
89         allowance[msg.sender][_spender] = _value;
90         return true;
91     }
92 
93     /**
94      * Set allowance for other address and notify
95      *
96      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
97      *
98      * @param _spender The address authorized to spend
99      * @param _value the max amount they can spend
100      * @param _extraData some extra information to send to the approved contract
101      */
102     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
103         public
104         returns (bool success) {
105         tokenRecipient spender = tokenRecipient(_spender);
106         if (approve(_spender, _value)) {
107             spender.receiveApproval(msg.sender, _value, this, _extraData);
108             return true;
109         }
110     }
111 
112 }
113 
114 /******************************************/
115 /*       TLC TOKEN STARTS HERE       */
116 /******************************************/
117 
118 contract TLCoin is ERC20 {
119 
120 
121     /* Initializes contract with initial supply tokens to the creator of the contract */
122     function TLCoin() ERC20(100000000, "TL Coin", "TLC") public {}
123 
124 
125     function multisend(address[] dests, uint256[] values) public returns (uint256) {
126         uint256 i = 0;
127         while (i < dests.length) {
128            transfer(dests[i], values[i]);
129            i += 1;
130         }
131         return(i);
132     }
133     
134 }