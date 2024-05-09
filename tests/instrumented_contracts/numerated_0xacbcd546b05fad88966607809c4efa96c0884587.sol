1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract PurxERC20 {
6     
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     uint256 public totalSupply;
11 
12     
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Burn(address indexed from, uint256 value);
19 
20     /** Constrctor **/
21     
22     function PurxERC20(
23         uint256 initialSupply,
24         string tokenName,
25         string tokenSymbol
26     ) public {
27         totalSupply = initialSupply * 10 ** uint256(decimals);
28         balanceOf[msg.sender] = totalSupply;
29         name = tokenName;
30         symbol = tokenSymbol;
31     }
32 
33     /** Internal transfer **/
34     
35     function _transfer(address _from, address _to, uint _value) internal {
36         // Prevent transfer to 0x0 address. Use burn() instead
37         require(_to != 0x0);
38         // Check if the sender has enough
39         require(balanceOf[_from] >= _value);
40         // Check for overflows
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42         // Save this for an assertion in the future
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         // Subtract from the sender
45         balanceOf[_from] -= _value;
46         // Add the same to the recipient
47         balanceOf[_to] += _value;
48         Transfer(_from, _to, _value);
49         // Asserts are used to use static analysis to find bugs in your code. They should never fail
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     /** Transfer tokens
54      * Send `_value` tokens to `_to` from your account
55      * @param _to The address of the recipient
56      * @param _value the amount to send
57      */
58     
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63     /**
64      * Transfer tokens from other address
65      *
66      * Send `_value` tokens to `_to` on behalf of `_from`
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
82      * Allows `_spender` to spend no more than `_value` tokens on your behalf
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
96      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
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
112     /* Burn tokens **/
113     function burn(uint256 _value) public returns (bool success) {
114         require(balanceOf[msg.sender] >= _value);
115         balanceOf[msg.sender] -= _value;
116         totalSupply -= _value;
117         Burn(msg.sender, _value);
118         return true;
119     }
120 }