1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Token {
6 
7     /// @notice send `_value` token to `_to` from `msg.sender`
8     /// @param _to The address of the recipient
9     /// @param _value The amount of token to be transferred
10     /// @return Whether the transfer was successful or not
11     function transfer(address _to, uint256 _value) returns (bool success);
12 
13     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
14     /// @param _from The address of the sender
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
19 
20     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
21     /// @param _spender The address of the account able to transfer the tokens
22     /// @param _value The amount of wei to be approved for transfer
23     /// @return Whether the approval was successful or not
24     function approve(address _spender, uint256 _value) returns (bool success);
25 }
26 
27 contract TMCToken is Token {
28     
29     string public name;
30     string public symbol;
31     uint8 public decimals = 18;
32     uint256 public totalSupply;
33 
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Burn(address indexed from, uint256 value);
39 
40     function TMCToken (uint256 initialSupply, string tokenName, string tokenSymbol) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);
42         balanceOf[msg.sender] = totalSupply;
43         name = tokenName;
44         symbol = tokenSymbol;
45     }
46 
47     function _transfer(address _from, address _to, uint _value) internal {
48         require(_to != 0x0);
49         require(balanceOf[_from] >= _value);
50         require(balanceOf[_to] + _value > balanceOf[_to]);
51         uint previousBalances = balanceOf[_from] + balanceOf[_to];
52         balanceOf[_from] -= _value;
53         balanceOf[_to] += _value;
54         Transfer(_from, _to, _value);
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58     function transfer(address _to, uint256 _value) public returns (bool success) {
59         _transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
64         require(_value <= allowance[_from][msg.sender]);     // Check allowance
65         allowance[_from][msg.sender] -= _value;
66         _transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function approve(address _spender, uint256 _value) public
71         returns (bool success) {
72         allowance[msg.sender][_spender] = _value;
73         return true;
74     }
75 
76     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
77         tokenRecipient spender = tokenRecipient(_spender);
78         if (approve(_spender, _value)) {
79             spender.receiveApproval(msg.sender, _value, this, _extraData);
80             return true;
81         }
82     }
83 
84     function burn(uint256 _value) public returns (bool success) {
85         require(balanceOf[msg.sender] >= _value);
86         balanceOf[msg.sender] -= _value;
87         totalSupply -= _value;
88         Burn(msg.sender, _value);
89         return true;
90     }
91 
92     function burnFrom(address _from, uint256 _value) public returns (bool success) {
93         require(balanceOf[_from] >= _value);
94         require(_value <= allowance[_from][msg.sender]);
95         balanceOf[_from] -= _value;
96         allowance[_from][msg.sender] -= _value;
97         totalSupply -= _value;
98         Burn(_from, _value);
99         return true;
100     }
101 }