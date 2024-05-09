1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenATEC {
6     string public name          = "ATEC";
7     string public symbol        = "ATEC";
8     uint8 public decimals       = 18;
9     uint256 public totalSupply  = 177000000 * 10 ** uint256(decimals);
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     constructor() public {
19         balanceOf[msg.sender] = totalSupply;
20     }
21 
22     function _transfer(address _from, address _to, uint _value) internal {
23         require(_to != 0x0);
24         require(balanceOf[_from] >= _value);
25         require(balanceOf[_to] + _value >= balanceOf[_to]);
26         uint previousBalances = balanceOf[_from] + balanceOf[_to];
27         balanceOf[_from] -= _value;
28         balanceOf[_to] += _value;
29         emit Transfer(_from, _to, _value);
30         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
31     }
32 
33     function transfer(address _to, uint256 _value) public {
34         _transfer(msg.sender, _to, _value);
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
38         require(_value <= allowance[_from][msg.sender]);     // Check allowance
39         allowance[_from][msg.sender] -= _value;
40         _transfer(_from, _to, _value);
41         return true;
42     }
43 
44     function approve(address _spender, uint256 _value) public
45         returns (bool success) {
46         allowance[msg.sender][_spender] = _value;
47         return true;
48     }
49 
50     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
51         public
52         returns (bool success) {
53         tokenRecipient spender = tokenRecipient(_spender);
54         if (approve(_spender, _value)) {
55             spender.receiveApproval(msg.sender, _value, this, _extraData);
56             return true;
57         }
58     }
59 
60     function burn(uint256 _value) public returns (bool success) {
61         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
62         balanceOf[msg.sender] -= _value;            // Subtract from the sender
63         totalSupply -= _value;                      // Updates totalSupply
64         emit Burn(msg.sender, _value);
65         return true;
66     }
67 
68     function burnFrom(address _from, uint256 _value) public returns (bool success) {
69         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
70         require(_value <= allowance[_from][msg.sender]);    // Check allowance
71         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
72         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
73         totalSupply -= _value;                              // Update totalSupply
74         emit Burn(_from, _value);
75         return true;
76     }
77 }