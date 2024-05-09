1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Burn(address indexed from, uint256 value);
14 
15     
16     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
17         totalSupply = initialSupply * 10 ** uint256(decimals);
18         balanceOf[msg.sender] = totalSupply;  
19         name = tokenName;
20         symbol = tokenSymbol;
21     }
22 
23    
24     function _transfer(address _from, address _to, uint _value) internal {
25         require(_to != 0x0);
26         require(balanceOf[_from] >= _value);
27         require(balanceOf[_to] + _value > balanceOf[_to]);
28 
29         
30         uint previousBalances = balanceOf[_from] + balanceOf[_to];
31         balanceOf[_from] -= _value;
32         balanceOf[_to] += _value;
33         Transfer(_from, _to, _value);
34         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
35     }
36 
37     
38     function transfer(address _to, uint256 _value) public {
39         _transfer(msg.sender, _to, _value);
40     }
41 
42     
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
44         require(_value <= allowance[_from][msg.sender]);     // Check allowance
45         allowance[_from][msg.sender] -= _value;
46         _transfer(_from, _to, _value);
47         return true;
48     }
49 
50     
51     function approve(address _spender, uint256 _value) public
52         returns (bool success) {
53         allowance[msg.sender][_spender] = _value;
54         return true;
55     }
56 
57     
58     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
59         public
60         returns (bool success) {
61         tokenRecipient spender = tokenRecipient(_spender);
62         if (approve(_spender, _value)) {
63             spender.receiveApproval(msg.sender, _value, this, _extraData);
64             return true;
65         }
66     }
67 
68     
69     function burn(uint256 _value) public returns (bool success) {
70         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
71         balanceOf[msg.sender] -= _value;            // Subtract from the sender
72         totalSupply -= _value;                      // Updates totalSupply
73         Burn(msg.sender, _value);
74         return true;
75     }
76 
77     
78     function burnFrom(address _from, uint256 _value) public returns (bool success) {
79         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
80         require(_value <= allowance[_from][msg.sender]);    // Check allowance
81         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
82         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
83         totalSupply -= _value;                              // Update totalSupply
84         Burn(_from, _value);
85         return true;
86     }
87 }