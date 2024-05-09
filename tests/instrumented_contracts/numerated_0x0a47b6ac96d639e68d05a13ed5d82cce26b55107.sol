1 pragma solidity ^0.4.20;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract DiaoCoin {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     // 18 decimals is the strongly suggested default, avoid changing it
10     uint256 public totalSupply;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     
19     // This generates a public event on the blockchain that will notify clients
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 
22     // This notifies clients about the amount burnt
23     event Burn(address indexed from, uint256 value);
24 
25     function DiaoCoin(
26         uint256 initialSupply,
27         string tokenName,
28         string tokenSymbol
29     ) public {
30         totalSupply = initialSupply * 10 ** uint256(decimals);  
31         balanceOf[msg.sender] = totalSupply;               
32         name = tokenName;                                  
33         symbol = tokenSymbol;                              
34     }
35 
36     /**
37      * Internal transfer, only can be called by this contract
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         require(_to != 0x0);
41         // Check if the sender has enough
42         require(balanceOf[_from] >= _value);
43         // Check for overflows
44         require(balanceOf[_to] + _value >= balanceOf[_to]);
45         // Save this for an assertion in the future
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         // Subtract from the sender
48         balanceOf[_from] -= _value;
49         // Add the same to the recipient
50         balanceOf[_to] += _value;
51         emit Transfer(_from, _to, _value);
52         // Asserts are used to use static analysis to find bugs in your code. They should never fail
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56     /**
57      * Transfer tokens
58      *
59      * Send `_value` tokens to `_to` from your account
60      *
61      * @param _to The address of the recipient
62      * @param _value the amount to send
63      */
64     function transfer(address _to, uint256 _value) public returns (bool success) {
65         _transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         require(_value <= allowance[_from][msg.sender]);     // Check allowance
71         allowance[_from][msg.sender] -= _value;
72         _transfer(_from, _to, _value);
73         return true;
74     }
75 
76     function approve(address _spender, uint256 _value) public
77         returns (bool success) {
78         allowance[msg.sender][_spender] = _value;
79         emit Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
84         public
85         returns (bool success) {
86         tokenRecipient spender = tokenRecipient(_spender);
87         if (approve(_spender, _value)) {
88             spender.receiveApproval(msg.sender, _value, this, _extraData);
89             return true;
90         }
91     }
92 
93 
94     function burn(uint256 _value) public returns (bool success) {
95         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
96         balanceOf[msg.sender] -= _value;            // Subtract from the sender
97         totalSupply -= _value;                      // Updates totalSupply
98         emit Burn(msg.sender, _value);
99         return true;
100     }
101 
102 
103     function burnFrom(address _from, uint256 _value) public returns (bool success) {
104         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
105         require(_value <= allowance[_from][msg.sender]);    // Check allowance
106         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
107         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
108         totalSupply -= _value;                              // Update totalSupply
109         emit Burn(_from, _value);
110         return true;
111     }
112 }