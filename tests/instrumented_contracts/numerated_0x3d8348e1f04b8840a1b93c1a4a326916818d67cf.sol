1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract ToGoConcert {
6 
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     uint256 public totalSupply;
11 
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     event Burn(address indexed from, uint256 value);
18 
19     function ToGoConcert (
20         uint256 initialSupply,
21         string tokenName,
22         string tokenSymbol
23     ) public {
24         totalSupply = initialSupply * 10 ** uint256(decimals);  
25         balanceOf[msg.sender] = totalSupply;                
26         name = tokenName;                                   
27         symbol = tokenSymbol;                       
28     }
29 
30     function _transfer(address _from, address _to, uint _value) internal {
31         
32         require(_to != 0x0);
33         
34         require(balanceOf[_from] >= _value);
35         
36         require(balanceOf[_to] + _value > balanceOf[_to]);
37         
38         uint previousBalances = balanceOf[_from] + balanceOf[_to];
39         
40         balanceOf[_from] -= _value;
41         
42         balanceOf[_to] += _value;
43         Transfer(_from, _to, _value);
44         
45         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
46     }
47 
48     function transfer(address _to, uint256 _value) public {
49         _transfer(msg.sender, _to, _value);
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         require(_value <= allowance[_from][msg.sender]);     // Check allowance
54         allowance[_from][msg.sender] -= _value;
55         _transfer(_from, _to, _value);
56         return true;
57     }
58 
59     function approve(address _spender, uint256 _value) public
60         returns (bool success) {
61         allowance[msg.sender][_spender] = _value;
62         return true;
63     }
64 
65     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
66         public
67         returns (bool success) {
68         tokenRecipient spender = tokenRecipient(_spender);
69         if (approve(_spender, _value)) {
70             spender.receiveApproval(msg.sender, _value, this, _extraData);
71             return true;
72         }
73     }
74 
75     function burn(uint256 _value) public returns (bool success) {
76         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
77         balanceOf[msg.sender] -= _value;            // Subtract from the sender
78         totalSupply -= _value;                      // Updates totalSupply
79         Burn(msg.sender, _value);
80         return true;
81     }
82 
83     function burnFrom(address _from, uint256 _value) public returns (bool success) {
84         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
85         require(_value <= allowance[_from][msg.sender]);    // Check allowance
86         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
87         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
88         totalSupply -= _value;                              // Update totalSupply
89         Burn(_from, _value);
90         return true;
91     }
92 }