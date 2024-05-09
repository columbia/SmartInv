1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 contract Token {
5     string public name = "Wrapped ETHO";
6     string public symbol = "ETHO";
7     uint8 public decimals = 18;
8     uint256 public totalSupply = 0;
9 
10     address owner;
11     modifier restricted {
12         require(msg.sender == owner, "This function is restricted to owner");
13         _;
14     }
15     modifier issuerOnly {
16         require(isIssuer[msg.sender], "You do not have issuer rights");
17         _;
18     }
19 
20     mapping(address => uint256) public balanceOf;
21     mapping(address => mapping(address => uint256)) public allowance;
22     mapping(address => bool) isIssuer;
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(
26         address indexed owner,
27         address indexed spender,
28         uint256 value
29     );
30     event IssuerRights(address indexed issuer, bool value);
31     event TransferOwnership(
32         address indexed previousOwner,
33         address indexed newOwner
34     );
35 
36     function mint(address _to, uint256 _amount)
37         public
38         issuerOnly
39         returns (bool success)
40     {
41         totalSupply += _amount;
42         balanceOf[_to] += _amount;
43         emit Transfer(address(0), _to, _amount);
44         return true;
45     }
46 
47     function burn(uint256 _amount) public issuerOnly returns (bool success) {
48         totalSupply -= _amount;
49         balanceOf[msg.sender] -= _amount;
50         emit Transfer(msg.sender, address(0), _amount);
51         return true;
52     }
53 
54     function burnFrom(address _from, uint256 _amount)
55         public
56         issuerOnly
57         returns (bool success)
58     {
59         allowance[_from][msg.sender] -= _amount;
60         balanceOf[_from] -= _amount;
61         totalSupply -= _amount;
62         emit Transfer(_from, address(0), _amount);
63         return true;
64     }
65 
66     function approve(address _spender, uint256 _amount)
67         public
68         returns (bool success)
69     {
70         allowance[msg.sender][_spender] = _amount;
71         emit Approval(msg.sender, _spender, _amount);
72         return true;
73     }
74 
75     function transfer(address _to, uint256 _amount)
76         public
77         returns (bool success)
78     {
79         balanceOf[msg.sender] -= _amount;
80         balanceOf[_to] += _amount;
81         emit Transfer(msg.sender, _to, _amount);
82         return true;
83     }
84 
85     function transferFrom(
86         address _from,
87         address _to,
88         uint256 _amount
89     ) public returns (bool success) {
90         allowance[_from][msg.sender] -= _amount;
91         balanceOf[_from] -= _amount;
92         balanceOf[_to] += _amount;
93         emit Transfer(_from, _to, _amount);
94         return true;
95     }
96 
97     function transferOwnership(address _newOwner) public restricted {
98         require(_newOwner != address(0), "Invalid address: should not be 0x0");
99         emit TransferOwnership(owner, _newOwner);
100         owner = _newOwner;
101     }
102 
103     function setIssuerRights(address _issuer, bool _value) public restricted {
104         isIssuer[_issuer] = _value;
105         emit IssuerRights(_issuer, _value);
106     }
107 
108     constructor() {
109         owner = msg.sender;
110         emit TransferOwnership(address(0), msg.sender);
111     }
112 }