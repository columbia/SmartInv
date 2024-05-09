1 pragma solidity ^ 0.4.16;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
5 }
6 
7 contract TokenERC20 {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18; 
11     uint256 public totalSupply;
12 
13     mapping(address => uint256) public balanceOf;
14     mapping(address => mapping(address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Burn(address indexed from, uint256 value);
18 
19     constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
20         totalSupply = initialSupply * 10 ** uint256(decimals);
21         balanceOf[msg.sender] = totalSupply;
22         name = tokenName; 
23         symbol = tokenSymbol;
24     }
25 
26     function _transfer(address _from, address _to, uint _value) internal {
27         require(_to != 0x0);
28         require(balanceOf[_from] >= _value);
29         require(balanceOf[_to] + _value > balanceOf[_to]);
30 
31         uint previousBalances = balanceOf[_from] + balanceOf[_to];
32         // Subtract from the sender
33         balanceOf[_from] -= _value;
34         // Add the same to the recipient
35         balanceOf[_to] += _value;
36         emit Transfer(_from, _to, _value);
37 
38         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
39     }
40 
41     function transfer(address _to, uint256 _value) public {
42         _transfer(msg.sender, _to, _value);
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
46         require(_value <= allowance[_from][msg.sender]); // Check allowance
47         allowance[_from][msg.sender] -= _value;
48         _transfer(_from, _to, _value);
49         return true;
50     }
51 
52     function approve(address _spender, uint256 _value) public
53     returns(bool success) {
54         allowance[msg.sender][_spender] = _value;
55         return true;
56     }
57 
58     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
59     public
60     returns(bool success) {
61         tokenRecipient spender = tokenRecipient(_spender);
62         if (approve(_spender, _value)) {
63             spender.receiveApproval(msg.sender, _value, this, _extraData);
64             return true;
65         }
66     }
67 
68     function burn(uint256 _value) public returns(bool success) {
69         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
70         balanceOf[msg.sender] -= _value; // Subtract from the sender
71         totalSupply -= _value; // Updates totalSupply
72         emit Burn(msg.sender, _value);
73         return true;
74     }
75 
76     function burnFrom(address _from, uint256 _value) public returns(bool success) {
77         require(balanceOf[_from] >= _value); // Check if the targeted balance is enough
78         require(_value <= allowance[_from][msg.sender]); // Check allowance
79         balanceOf[_from] -= _value; // Subtract from the targeted balance
80         allowance[_from][msg.sender] -= _value; // Subtract from the sender's allowance
81         totalSupply -= _value; // Update totalSupply
82         emit Burn(_from, _value);
83         return true;
84     }
85 }