1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract BrcpToken {
23     string public name = 'BRCP';
24     string public symbol = 'BRCP';
25     uint8 public decimals = 18;
26     uint256 public totalSupply = 250000000;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Burn(address indexed from, uint256 value);
34 
35     function BrcpToken(
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);
41         balanceOf[msg.sender] = totalSupply;
42         name = tokenName;
43         symbol = tokenSymbol;
44     }
45 
46     function _transfer(address _from, address _to, uint _value) internal {
47 
48         require(_to != 0x0);
49 
50         require(balanceOf[_from] >= _value);
51 
52         require(balanceOf[_to] + _value > balanceOf[_to]);
53 
54         uint previousBalances = balanceOf[_from] + balanceOf[_to];
55 
56         balanceOf[_from] -= _value;
57 
58         balanceOf[_to] += _value;
59         Transfer(_from, _to, _value);
60 
61         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
62     }
63 
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         require(_value <= allowance[_from][msg.sender]);
70         allowance[_from][msg.sender] -= _value;
71         _transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function approve(address _spender, uint256 _value) public
76         returns (bool success) {
77         allowance[msg.sender][_spender] = _value;
78         return true;
79     }
80 
81     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
82         public
83         returns (bool success) {
84         tokenRecipient spender = tokenRecipient(_spender);
85         if (approve(_spender, _value)) {
86             spender.receiveApproval(msg.sender, _value, this, _extraData);
87             return true;
88         }
89     }
90 
91     function burn(uint256 _value) public returns (bool success) {
92         require(balanceOf[msg.sender] >= _value);
93         balanceOf[msg.sender] -= _value;
94         totalSupply -= _value;
95         Burn(msg.sender, _value);
96         return true;
97     }
98 
99     function burnFrom(address _from, uint256 _value) public returns (bool success) {
100         require(balanceOf[_from] >= _value);
101         require(_value <= allowance[_from][msg.sender]);
102         balanceOf[_from] -= _value;
103         allowance[_from][msg.sender] -= _value;
104         totalSupply -= _value;
105         Burn(_from, _value);
106         return true;
107     }
108 }