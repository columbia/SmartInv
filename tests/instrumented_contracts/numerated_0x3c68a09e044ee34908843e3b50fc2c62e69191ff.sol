1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract MTCoin {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 8;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18     event Burn(address indexed from, uint256 value);
19 
20     constructor(uint256 initialSupply,
21         string tokenName,
22         string tokenSymbol
23     ) public {
24         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
25         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
26         name = tokenName;                                   // Set the name for display purposes
27         symbol = tokenSymbol;                               // Set the symbol for display purposes
28     }
29 
30     function _transfer(address _from, address _to, uint _value) internal {
31         require(_to != 0x0);
32         require(balanceOf[_from] >= _value);
33         require(balanceOf[_to] + _value >= balanceOf[_to]);
34         uint previousBalances = balanceOf[_from] + balanceOf[_to];
35         balanceOf[_from] -= _value;
36         balanceOf[_to] += _value;
37         emit Transfer(_from, _to, _value);
38         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
39     }
40 
41     function transfer(address _to, uint256 _value) public returns (bool success) {
42         _transfer(msg.sender, _to, _value);
43         return true;
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
47         require(_value <= allowance[_from][msg.sender]);     // Check allowance
48         allowance[_from][msg.sender] -= _value;
49         _transfer(_from, _to, _value);
50         return true;
51     }
52 
53     function approve(address _spender, uint256 _value) public
54         returns (bool success) {
55         allowance[msg.sender][_spender] = _value;
56         emit Approval(msg.sender, _spender, _value);
57         return true;
58     }
59 
60     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
61         public
62         returns (bool success) {
63         tokenRecipient spender = tokenRecipient(_spender);
64         if (approve(_spender, _value)) {
65             spender.receiveApproval(msg.sender, _value, this, _extraData);
66             return true;
67         }
68     }
69 
70     function burn(uint256 _value) public returns (bool success) {
71         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
72         balanceOf[msg.sender] -= _value;            // Subtract from the sender
73         totalSupply -= _value;                      // Updates totalSupply
74         emit Burn(msg.sender, _value);
75         return true;
76     }
77 
78     function burnFrom(address _from, uint256 _value) public returns (bool success) {
79         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
80         require(_value <= allowance[_from][msg.sender]);    // Check allowance
81         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
82         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
83         totalSupply -= _value;                              // Update totalSupply
84         emit Burn(_from, _value);
85         return true;
86     }
87 }