1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract StandardToken {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Burn(address indexed from, uint256 value);
16 
17     function _transfer(address _from, address _to, uint _value) internal {
18         require(_to != 0x0);
19         require(balanceOf[_from] >= _value);
20         require(balanceOf[_to] + _value > balanceOf[_to]);
21         uint previousBalances = balanceOf[_from] + balanceOf[_to];
22         balanceOf[_from] -= _value;
23         balanceOf[_to] += _value;
24         Transfer(_from, _to, _value);
25         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
26     }
27 
28     function transfer(address _to, uint256 _value) public {
29         _transfer(msg.sender, _to, _value);
30     }
31 
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
33         require(_value <= allowance[_from][msg.sender]);     // Check allowance
34         allowance[_from][msg.sender] -= _value;
35         _transfer(_from, _to, _value);
36         return true;
37     }
38     
39     function approve(address _spender, uint256 _value) public
40         returns (bool success) {
41         allowance[msg.sender][_spender] = _value;
42         return true;
43     }
44 
45     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
46         public
47         returns (bool success) {
48         tokenRecipient spender = tokenRecipient(_spender);
49         if (approve(_spender, _value)) {
50             spender.receiveApproval(msg.sender, _value, this, _extraData);
51             return true;
52         }
53     }
54     
55     function burn(uint256 _value) public returns (bool success) {
56         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
57         balanceOf[msg.sender] -= _value;            // Subtract from the sender
58         totalSupply -= _value;                      // Updates totalSupply
59         Burn(msg.sender, _value);
60         return true;
61     }
62 
63     function burnFrom(address _from, uint256 _value) public returns (bool success) {
64         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
65         require(_value <= allowance[_from][msg.sender]);    // Check allowance
66         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
67         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
68         totalSupply -= _value;                              // Update totalSupply
69         Burn(_from, _value);
70         return true;
71     }
72 }
73 contract PrestoToken is StandardToken {
74 
75     function PrestoToken() public {
76         totalSupply = 1000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
77         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
78         name = "Presto Token";                                   // Set the name for display purposes
79         symbol = "PRST";                               // Set the symbol for display purposes
80     }
81 
82     /* Internal transfer, only can be called by this contract */
83     function _transfer(address _from, address _to, uint _value) internal {
84         require (_to != 0x0);                                         // Prevent transfer to 0x0 address. Use burn() instead
85         require (balanceOf[_from] > _value);                          // Check if the sender has enough
86         require (balanceOf[_to] + _value > balanceOf[_to]);           // Check for overflows
87         balanceOf[_from] -= _value;                                   // Subtract from the sender
88         balanceOf[_to] += _value;                                     // Add the same to the recipient
89         Transfer(_from, _to, _value);
90     }
91 }