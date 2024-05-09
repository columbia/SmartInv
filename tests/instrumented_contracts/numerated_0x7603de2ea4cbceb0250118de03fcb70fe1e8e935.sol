1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.5;
3 contract Token {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8     
9     uint public constant MAX_SUPPLY = 400000000e18;
10 
11     address public owner;
12     modifier restricted {
13         require(msg.sender == owner, "This function is restricted to owner");
14         _;
15     }
16     modifier issuerOnly {
17         require(isIssuer[msg.sender], "You do not have issuer rights");
18         _;
19     }
20 
21     mapping(address => uint256) public balanceOf;
22     mapping(address => mapping(address => uint256)) public allowance;
23     mapping(address => bool) public isIssuer;
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27     event IssuerRights(address indexed issuer, bool value);
28     event TransferOwnership(address indexed previousOwner, address indexed newOwner);
29 
30     function getOwner() public view returns (address) {
31         return owner;
32     }
33 
34     function mint(address _to, uint256 _amount) public issuerOnly returns (bool success) {
35         require(_amount + totalSupply <= MAX_SUPPLY, "AMC: maxcap reached");
36         totalSupply += _amount;
37         balanceOf[_to] += _amount;
38         emit Transfer(address(0), _to, _amount);
39         return true;
40     }
41 
42     function burn(uint256 _amount) public issuerOnly returns (bool success) {
43         totalSupply -= _amount;
44         balanceOf[msg.sender] -= _amount;
45         emit Transfer(msg.sender, address(0), _amount);
46         return true;
47     }
48 
49     function burnFrom(address _from, uint256 _amount) public issuerOnly returns (bool success) {
50         allowance[_from][msg.sender] -= _amount;
51         balanceOf[_from] -= _amount;
52         totalSupply -= _amount;
53         emit Transfer(_from, address(0), _amount);
54         return true;
55     }
56 
57     function approve(address _spender, uint256 _amount) public returns (bool success) {
58         allowance[msg.sender][_spender] = _amount;
59         emit Approval(msg.sender, _spender, _amount);
60         return true;
61     }
62 
63     function transfer(address _to, uint256 _amount) public returns (bool success) {
64         balanceOf[msg.sender] -= _amount;
65         balanceOf[_to] += _amount;
66         emit Transfer(msg.sender, _to, _amount);
67         return true;
68     }
69 
70     function transferFrom( address _from, address _to, uint256 _amount) public returns (bool success) {
71         allowance[_from][msg.sender] -= _amount;
72         balanceOf[_from] -= _amount;
73         balanceOf[_to] += _amount;
74         emit Transfer(_from, _to, _amount);
75         return true;
76     }
77 
78     function transferOwnership(address _newOwner) public restricted {
79         require(_newOwner != address(0), "Invalid address: should not be 0x0");
80         emit TransferOwnership(owner, _newOwner);
81         owner = _newOwner;
82     }
83 
84     function setIssuerRights(address _issuer, bool _value) public restricted {
85         isIssuer[_issuer] = _value;
86         emit IssuerRights(_issuer, _value);
87     }
88 
89     constructor(string memory _name, string memory _symbol, uint8 _decimals) {
90         name = _name;
91         symbol = _symbol;
92         decimals = _decimals;
93         owner = msg.sender;
94         emit TransferOwnership(address(0), msg.sender);
95     }
96 }