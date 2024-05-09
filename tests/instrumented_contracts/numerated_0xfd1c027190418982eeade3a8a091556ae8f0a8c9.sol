1 pragma solidity ^0.5.1;
2 
3 contract transferable { function transfer(address to, uint256 value) public returns (bool); }
4 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public; }
5 
6 contract HoteliumToken {
7     string public name = "Hotelium";
8     string public symbol = "HTL";
9     uint8 public decimals = 8;
10     address public owner;
11     uint256 public _totalSupply = 49000000000000000;
12 
13     mapping (address => uint256) public balances;
14     mapping (address => mapping (address => uint256)) public allowances;
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Burn(address indexed from, uint256 value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     constructor() public {
21         balances[0xf115c4bE4C298cA9166BBB7C1922435fd3E87084] = 40000000000000000;
22 
23         balances[0x8d68e0FBea987B480C81EcB2B67B5f106786747f] = 1000000000000000;
24         balances[0x34c1baf2bF700C963AE21090236D90CA9f4a317e] = 1000000000000000;
25         balances[0x9FDcA6eDd5C0B5eD9ed5131835Cee0413EF5b91f] = 1000000000000000;
26         balances[0xb150864c2B4F7181a8d72bA10ED6Ad834BFcEBf1] = 1000000000000000;
27         balances[0x53C7e935350615DCad91957C64F070d950a1a410] = 1000000000000000;
28         balances[0x63346d5b073310a704440802C1b5666a7F57b553] = 1000000000000000;
29         balances[0x9b150527964699A6DB9dDB0006432208Cd41d594] = 1000000000000000;
30         balances[0xC09118e41F08B317d2aDa4f5433ebFCEd83E490A] = 1000000000000000;
31 
32 
33         balances[0xe3Ea7413D30E1fdB6Ab4f32ecDBa3F6eaC925401] = 190000000000000;
34         balances[0x0B0F2674401cE36816452476f19f004a1b1E68c2] = 190000000000000;
35         balances[0xB439dacB0Be7B5efEaf1f28F30c39F8e25239195] = 190000000000000;
36         balances[0xD6Cf1038638E1C4F021E979B0e8cAc660a523Be5] = 190000000000000;
37         balances[0xB8B4E2cF8314Dad106bADB28C2cfe735FC7616fD] = 190000000000000;
38 
39 
40         balances[0x97b9155feE365cCD805aE080d986DB0E43a9C0E9] = 50000000000000;
41         owner = 0xf115c4bE4C298cA9166BBB7C1922435fd3E87084;
42         
43         emit Transfer(address(0), 0xf115c4bE4C298cA9166BBB7C1922435fd3E87084, 40000000000000000);
44 
45         emit Transfer(address(0), 0x8d68e0FBea987B480C81EcB2B67B5f106786747f, 1000000000000000);
46         emit Transfer(address(0), 0x34c1baf2bF700C963AE21090236D90CA9f4a317e, 1000000000000000);
47         emit Transfer(address(0), 0x9FDcA6eDd5C0B5eD9ed5131835Cee0413EF5b91f, 1000000000000000);
48         emit Transfer(address(0), 0xb150864c2B4F7181a8d72bA10ED6Ad834BFcEBf1, 1000000000000000);
49         emit Transfer(address(0), 0x53C7e935350615DCad91957C64F070d950a1a410, 1000000000000000);
50         emit Transfer(address(0), 0x63346d5b073310a704440802C1b5666a7F57b553, 1000000000000000);
51         emit Transfer(address(0), 0x9b150527964699A6DB9dDB0006432208Cd41d594, 1000000000000000);
52         emit Transfer(address(0), 0xC09118e41F08B317d2aDa4f5433ebFCEd83E490A, 1000000000000000);
53 
54 
55         emit Transfer(address(0), 0xe3Ea7413D30E1fdB6Ab4f32ecDBa3F6eaC925401, 190000000000000);
56         emit Transfer(address(0), 0x0B0F2674401cE36816452476f19f004a1b1E68c2, 190000000000000);
57         emit Transfer(address(0), 0xB439dacB0Be7B5efEaf1f28F30c39F8e25239195, 190000000000000);
58         emit Transfer(address(0), 0xD6Cf1038638E1C4F021E979B0e8cAc660a523Be5, 190000000000000);
59         emit Transfer(address(0), 0xB8B4E2cF8314Dad106bADB28C2cfe735FC7616fD, 190000000000000);
60 
61         emit Transfer(address(0), 0x97b9155feE365cCD805aE080d986DB0E43a9C0E9, 50000000000000);
62     }
63 
64     function balanceOf(address _owner) public view returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
69         return allowances[_owner][_spender];
70     }
71 
72     function totalSupply() public view returns (uint256 supply) {
73         return _totalSupply;
74     }
75 
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         if (_to == address(0x0)) return false;
78         if (balances[msg.sender] < _value) return false;
79         if (balances[_to] + _value < balances[_to]) return false;
80         balances[msg.sender] -= _value;
81         balances[_to] += _value;
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function approve(address _spender, uint256 _value) public returns (bool success) {
87         allowances[msg.sender][_spender] = _value;
88         emit Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
93         tokenRecipient spender = tokenRecipient(_spender);
94         if (approve(_spender, _value)) {
95             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
96             return true;
97         }
98     }        
99 
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         if (_to == address(0x0)) return false;
102         if (balances[_from] < _value) return false;
103         if (balances[_to] + _value < balances[_to]) return false;
104         if (_value > allowances[_from][msg.sender]) return false;
105         balances[_from] -= _value;
106         balances[_to] += _value;
107         allowances[_from][msg.sender] -= _value;
108         emit Transfer(_from, _to, _value);
109         return true;
110     }
111 
112     function burn(uint256 _value) public returns (bool success) {
113         if (balances[msg.sender] < _value) return false;
114         balances[msg.sender] -= _value;
115         _totalSupply -= _value;
116         emit Burn(msg.sender, _value);
117         return true;
118     }
119 
120     function burnFrom(address _from, uint256 _value) public returns (bool success) {
121         if (balances[_from] < _value) return false;
122         if (_value > allowances[_from][msg.sender]) return false;
123         balances[_from] -= _value;
124         _totalSupply -= _value;
125         emit Burn(_from, _value);
126         return true;
127     }
128 
129     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
130         return transferable(tokenAddress).transfer(owner, tokens);
131     }
132 }