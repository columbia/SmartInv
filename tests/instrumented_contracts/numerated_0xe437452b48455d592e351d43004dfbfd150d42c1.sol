1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Supershop {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     /**
19      * Constrctor function
20      */
21     function Supershop(
22         uint256 initialSupply,
23         string tokenName,
24         string tokenSymbol
25     ) public {
26         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
27         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
28         name = tokenName;                                   // Set the name for display purposes
29         symbol = tokenSymbol;                               // Set the symbol for display purposes
30     }
31 
32     /**
33      * Internal transfer, only can be called by this contract
34      */
35     function _transfer(address _from, address _to, uint _value) internal {
36         // Prevent transfer to 0x0 address. Use burn() instead
37         require(_to != 0x0);
38         require(balanceOf[_from] >= _value);
39         require(balanceOf[_to] + _value > balanceOf[_to]);
40         uint previousBalances = balanceOf[_from] + balanceOf[_to];
41         balanceOf[_from] -= _value;
42         balanceOf[_to] += _value;
43         Transfer(_from, _to, _value);
44         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
45     }
46 
47     /**
48      * Transfer tokens
49      */
50     function transfer(address _to, uint256 _value) public {
51         _transfer(msg.sender, _to, _value);
52     }
53 
54     /**
55      * Transfer tokens from other address with allowance
56      */
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);     // Check allowance
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     /**
65      * Set allowance for other address
66      */
67     function approve(address _spender, uint256 _value) public
68         returns (bool success) {
69         allowance[msg.sender][_spender] = _value;
70         return true;
71     }
72 
73     /**
74      * Set allowance for other address and notify
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
87      * Destroy  own tokens
88      */
89     function burn(uint256 _value) public returns (bool success) {
90         require(balanceOf[msg.sender] >= _value);   
91         balanceOf[msg.sender] -= _value;            
92         totalSupply -= _value;                              // Update totalSupply
93         Burn(msg.sender, _value);
94         return true;
95     }
96 
97     /**
98      * Destroy tokens from other account with allowance
99      */
100     function burnFrom(address _from, uint256 _value) public returns (bool success) {
101         require(balanceOf[_from] >= _value);                
102         require(_value <= allowance[_from][msg.sender]);    // Check allowance
103         balanceOf[_from] -= _value;                         
104         allowance[_from][msg.sender] -= _value;             
105         totalSupply -= _value;                              // Update totalSupply
106         Burn(_from, _value);
107         return true;
108     }
109 }