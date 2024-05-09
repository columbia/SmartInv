1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5     function owned() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 
17 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
18 
19 /// ERC20 standard，Define the minimum unit of money to 18 decimal places,
20 /// transfer out, destroy coins, others use your account spending pocket money.
21 contract TokenERC20 {
22     uint256 public totalSupply;
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Burn(address indexed from, uint256 value);
27 
28     /**
29      * Internal transfer, only can be called by this contract.
30      */
31     function _transfer(address _from, address _to, uint _value) internal {
32         require(_to != 0x0);
33         require(balanceOf[_from] >= _value);
34         require(balanceOf[_to] + _value > balanceOf[_to]);
35         uint previousBalances = balanceOf[_from] + balanceOf[_to];
36         balanceOf[_from] -= _value;
37         balanceOf[_to] += _value;
38         emit Transfer(_from, _to, _value);
39         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
40     }
41 
42     /**
43      * Transfer tokens
44      *
45      * Send `_value` tokens to `_to` from your account.
46      *
47      * @param _to The address of the recipient.
48      * @param _value the amount to send.
49      */
50     function transfer(address _to, uint256 _value) public {
51         _transfer(msg.sender, _to, _value);
52     }
53 
54     /**
55      * Transfer tokens from other address.
56      *
57      * Send `_value` tokens to `_to` in behalf of `_from`.
58      *
59      * @param _from The address of the sender.
60      * @param _to The address of the recipient.
61      * @param _value the amount to send.
62      */
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
64         require(_value <= allowance[_from][msg.sender]);
65         allowance[_from][msg.sender] -= _value;
66         _transfer(_from, _to, _value);
67         return true;
68     }
69 
70     /**
71      * Set allowance for other address.
72      *
73      * Allows `_spender` to spend no more than `_value` tokens in your behalf.
74      *
75      * @param _spender The address authorized to spend.
76      * @param _value the max amount they can spend.
77      */
78     function approve(address _spender, uint256 _value) public
79         returns (bool success) {
80         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
81         allowance[msg.sender][_spender] = _value;
82         return true;
83     }
84 
85     /**
86      * Set allowance for other address and notify.
87      *
88      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it.
89      *
90      * @param _spender The address authorized to spend.
91      * @param _value the max amount they can spend.
92      * @param _extraData some extra information to send to the approved contract.
93      */
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
95         public
96         returns (bool success) {
97         tokenRecipient spender = tokenRecipient(_spender);
98         if (approve(_spender, _value)) {
99             spender.receiveApproval(msg.sender, _value, this, _extraData);
100             return true;
101         }
102     }
103 
104      /**
105      * Destroy tokens
106      *
107      * Remove `_value` tokens from the system irreversibly.
108      *
109      * @param _value the amount of money to burn.
110      */
111     function burn(uint256 _value) public returns (bool success) {
112         require(balanceOf[msg.sender] >= _value);
113         balanceOf[msg.sender] -= _value;
114         totalSupply -= _value;
115         emit Burn(msg.sender, _value);
116         return true;
117     }
118 
119     /**
120      * Destroy tokens from other account.
121      *
122      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
123      *
124      * @param _from the address of the sender.
125      * @param _value the amount of money to burn.
126      */
127     function burnFrom(address _from, uint256 _value) public returns (bool success) {
128         require(balanceOf[_from] >= _value);
129         require(_value <= allowance[_from][msg.sender]);
130         balanceOf[_from] -= _value;
131         allowance[_from][msg.sender] -= _value;
132         totalSupply -= _value;
133         emit Burn(_from, _value);
134         return true;
135     }
136 }
137 
138 /****************************/
139 /*       NBS TOKEN        */
140 /**************************/
141 
142 /// NBS Protocol Token.
143 contract NBSToken is owned, TokenERC20 {
144 
145     string public constant name = "Nirvana";
146     string public constant symbol = "NBS";
147     uint8 public constant decimals = 18;
148     uint256 public totalSupply = 1000000000 * 10 ** uint256(decimals);
149 
150     /* Initializes contract with initial supply tokens to the creator of the contract. */
151     function NBSToken() public {
152         balanceOf[msg.sender] = totalSupply;
153     }
154 }