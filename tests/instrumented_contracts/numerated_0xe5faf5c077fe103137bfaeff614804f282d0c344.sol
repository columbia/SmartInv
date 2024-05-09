1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 /**
8  * Simple ERC20 compatible contract that allows basic operations
9  * on a currency like token.
10  */
11 contract TokenHEL20 {
12     // the public variables of the token, includes things like
13     // name symbol and number of decimal places
14     string public name;
15     string public symbol;
16     uint8 public decimals = 18;
17 
18     // 18 decimals is the strongly suggested default, avoid changing it
19     uint256 public totalSupply;
20 
21     // this creates an array with all balances
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24 
25     // this generates a public event on the blockchain that will notify clients
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     // this notifies clients about the amount burnt
29     event Burn(address indexed from, uint256 value);
30 
31     /**
32      * Constructor function
33      *
34      * Initializes contract with initial supply tokens to the creator of the contract.
35      * The token should be compatible with ERC20 https://github.com/ethereum/EIPs/issues/20.
36      */
37     function TokenHEL20(
38         uint256 initialSupply,
39         string tokenName,
40         string tokenSymbol
41     ) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);
43         balanceOf[msg.sender] = totalSupply;
44         name = tokenName;
45         symbol = tokenSymbol;
46     }
47 
48     /**
49      * Internal transfer, only can be called by this contract.
50      */
51     function _transfer(address _from, address _to, uint _value) internal {
52         // prevents transfer to 0x0 address, should use burn() instead
53         require(_to != 0x0);
54 
55         // checks if there's enought from the sender and
56         // then checks for overflows in the target buffer
57         require(balanceOf[_from] >= _value);
58         require(balanceOf[_to] + _value > balanceOf[_to]);
59 
60         // saves this for an assertion in the future
61         // this is basically the sum of both balances
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63 
64         // subtracts from the sender and adds the same ammount
65         // to the receiver
66         balanceOf[_from] -= _value;
67         balanceOf[_to] += _value;
68 
69         // triggers the transfer event to the blockchain with
70         // the description of the tranfer operation
71         Transfer(_from, _to, _value);
72 
73         // asserts are used to use static analysis to find bugs in your code,
74         // they should never fail under normal conditions
75         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
76     }
77 
78     /**
79      * Transfer tokens
80      *
81      * Send `_value` tokens to `_to` from your account.
82      *
83      * @param _to The address of the recipient.
84      * @param _value The amount to send.
85      */
86     function transfer(address _to, uint256 _value) public {
87         _transfer(msg.sender, _to, _value);
88     }
89 
90     /**
91      * Transfer tokens from other address
92      *
93      * Send `_value` tokens to `_to` in behalf of `_from`.
94      *
95      * @param _from The address of the sender.
96      * @param _to The address of the recipient.
97      * @param _value The amount to send.
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         // checks for proper allowance and if there's enought
101         // proceeds with the transfer operation
102         require(_value <= allowance[_from][msg.sender]);
103         allowance[_from][msg.sender] -= _value;
104         _transfer(_from, _to, _value);
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address.
110      *
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf.
112      *
113      * @param _spender The address authorized to spend.
114      * @param _value the max amount they can spend.
115      */
116     function approve(address _spender, uint256 _value) public
117         returns (bool success) {
118         allowance[msg.sender][_spender] = _value;
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address and notify.
124      *
125      * Allows `_spender` to spend no more than `_value` tokens in your behalf,
126      * and then ping the contract about it.
127      *
128      * @param _spender The address authorized to spend.
129      * @param _value The max amount they can spend.
130      * @param _extraData Some extra information to send to the approved contract.
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         public
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly.
146      *
147      * @param _value The amount of money to burn.
148      */
149     function burn(uint256 _value) public returns (bool success) {
150         require(balanceOf[msg.sender] >= _value);
151         balanceOf[msg.sender] -= _value;
152         totalSupply -= _value;
153         Burn(msg.sender, _value);
154         return true;
155     }
156 
157     /**
158      * Destroy tokens from other account.
159      *
160      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
161      *
162      * @param _from The address of the sender.
163      * @param _value The amount of money to burn.
164      */
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(balanceOf[_from] >= _value);
167         require(_value <= allowance[_from][msg.sender]);
168         balanceOf[_from] -= _value;
169         allowance[_from][msg.sender] -= _value;
170         totalSupply -= _value;
171         Burn(_from, _value);
172         return true;
173     }
174 }