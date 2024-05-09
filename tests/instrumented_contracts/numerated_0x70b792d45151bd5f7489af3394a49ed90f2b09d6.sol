1 //Solidity code for APMA
2 
3 pragma solidity ^0.4.16;
4 
5 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
6 
7 contract TokenERC20 {
8     
9     string public name;
10     string public symbol;
11     uint8 public decimals = 4;
12     uint256 public totalSupply;
13 
14     // This creates an array with all balances of the APMA holders .
15     mapping (address => uint256) public balanceOf;
16 
17     //This creates an array of arrays to store the allowance provided by a contract owner to a given address 
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // This generates a public event on the blockchain that will notify clients the transfer of APMA between different accounts
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     // This notifies clients about the amount of APMA burnt
24     event Burn(address indexed from, uint256 value);
25 
26     
27     // This is the initial function which will be called upon the creation of the APMA contract to generate the supply tokens 
28     
29     
30     function TokenERC20(
31     ) public {
32         totalSupply = 1000000000 * 10 ** uint256(decimals);  // Total supply of APMA
33         balanceOf[msg.sender] = totalSupply;                // Give the creator of the contract all the APMA
34         name = "APMA";                                   // Giving the name "APMA"
35         symbol = "APMA";                               // Setting the symbol of APMA
36     }
37 
38     // Internal function for transfer of tokens between 2 different addresses
39      
40     function _transfer(address _from, address _to, uint _value) internal {
41         // Prevent transfer to 0x0 address. Use burn() instead
42         require(_to != 0x0);
43         // Check if the sender has enough
44         require(balanceOf[_from] >= _value);
45         // Check for overflows
46         require(balanceOf[_to] + _value > balanceOf[_to]);
47         // Save this for an assertion in the future
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49         // Subtract from the sender
50         balanceOf[_from] -= _value;
51         // Add the same to the recipient
52         balanceOf[_to] += _value;
53         Transfer(_from, _to, _value);
54         // Asserts are used to use static analysis to find bugs in your code. They should never fail
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58     
59     // Function to transfer APMAs to a given address from the contract owner 
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64     // Function to transfer APMAs between two given addresses
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         require(_value <= allowance[_from][msg.sender]);     // Check allowance
67         allowance[_from][msg.sender] -= _value;
68         _transfer(_from, _to, _value);
69         return true;
70     }
71 
72     // Setting up the allowance for the spender on the behalf of the contract owner 
73     function approve(address _spender, uint256 _value) public
74         returns (bool success) {
75         allowance[msg.sender][_spender] = _value;
76         return true;
77     }
78 
79     // Notification for allowance of a spender by the contract owner
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
81         public
82         returns (bool success) {
83         tokenRecipient spender = tokenRecipient(_spender);
84         if (approve(_spender, _value)) {
85             spender.receiveApproval(msg.sender, _value, this, _extraData);
86             return true;
87         }
88     }
89 
90     // Depleting the APMA supply 
91     function burn(uint256 _value) public returns (bool success) {
92         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
93         balanceOf[msg.sender] -= _value;            // Subtract from the sender
94         totalSupply -= _value;                      // Updates totalSupply
95         Burn(msg.sender, _value);
96         return true;
97     }
98 
99     // Depleting the APMA supply from a given address
100     function burnFrom(address _from, uint256 _value) public returns (bool success) {
101         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
102         require(_value <= allowance[_from][msg.sender]);    // Check allowance
103         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
104         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
105         totalSupply -= _value;                              // Update totalSupply
106         Burn(_from, _value);
107         return true;
108     }
109 }