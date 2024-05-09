1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
5 }
6 
7 contract ShiftCashExtraBonus {
8     // Public variables of the token
9     string public name = 'ShiftCashExtraBonus';
10     string public symbol = 'SCB';
11     uint8 public decimals = 0;
12     uint256 public totalSupply;
13 
14     // This creates an array with all balances
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Burn(address indexed from, uint256 value);
20 
21     /**
22      * Constrctor function
23      */
24     function ShiftCashExtraBonus() public {
25         totalSupply = 1000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
26         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
27     }
28 
29     /**
30      * Internal transfer, only can be called by this contract
31      */
32     function _transfer(address _from, address _to, uint _value) internal {
33         require(_to != 0x0);
34         require(balanceOf[_from] >= _value);
35         require(balanceOf[_to] + _value > balanceOf[_to]);
36         uint previousBalances = balanceOf[_from] + balanceOf[_to];
37         balanceOf[_from] -= _value;
38         balanceOf[_to] += _value;
39         Transfer(_from, _to, _value);
40         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
41     }
42 
43     /**
44      * Transfer tokens
45      * Send `_value` tokens to `_to` from your account
46      */
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50 
51     /**
52      * Transfer tokens from other address
53      * Send `_value` tokens to `_to` on behalf of `_from`
54      */
55     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
56         require(_value <= allowance[_from][msg.sender]);     // Check allowance
57         allowance[_from][msg.sender] -= _value;
58         _transfer(_from, _to, _value);
59         return true;
60     }
61 
62     /**
63      * Set allowance for other address
64      * Allows `_spender` to spend no more than `_value` tokens on your behalf
65      */
66     function approve(address _spender, uint256 _value) public
67         returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         return true;
70     }
71 
72     /**
73      * Set allowance for other address and notify
74      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
75      */
76     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
77         public
78         returns (bool success) {
79         tokenRecipient spender = tokenRecipient(_spender);
80         if (approve(_spender, _value)) {
81             spender.receiveApproval(msg.sender, _value, this, _extraData);
82             return true;
83         }
84     }
85 
86     /**
87      * Destroy tokens
88      * Remove `_value` tokens from the system irreversibly
89      */
90     function burn(uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);
92         balanceOf[msg.sender] -= _value;
93         totalSupply -= _value;
94         Burn(msg.sender, _value);
95         return true;
96     }
97 
98     /**
99      * Destroy tokens from other account
100      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
101      */
102     function burnFrom(address _from, uint256 _value) public returns (bool success) {
103         require(balanceOf[_from] >= _value);
104         require(_value <= allowance[_from][msg.sender]);
105         balanceOf[_from] -= _value; 
106         allowance[_from][msg.sender] -= _value;
107         totalSupply -= _value;
108         Burn(_from, _value);
109         return true;
110     }
111 }