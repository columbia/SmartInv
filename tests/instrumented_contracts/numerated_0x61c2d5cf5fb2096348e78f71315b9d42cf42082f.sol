1 pragma solidity ^0.4.16;
2 
3 contract TestERC721 {
4     
5     address private _admin;
6 
7     uint256 private _totalSupply;
8     mapping(address => uint) private balances;
9     uint256 private index;
10 
11     mapping(uint256 => address) private tokenOwners;
12     mapping(uint256 => bool) private tokenExists;
13     mapping(address => mapping (address => uint256)) allowed;
14     mapping(uint256 => token) tokens;
15 
16     struct token {
17         string name;
18         string link;
19         uint256 price;
20     }
21 
22     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
23     event Approval(address indexed _from, address indexed _to, uint256 _tokenId);
24 
25     constructor() public {
26         _admin = 0xa06507041083cFfC7aB1E89f3c59d0AD49Bf384D;
27     }
28     
29     function admin() public constant returns (address) {
30         return _admin;
31     }
32     
33     function name() public pure returns (string) {
34         return "Test Token";
35     }
36 
37     function symbol() public pure returns (string) {
38         return "TTE";
39     }
40 
41     function totalSupply() public constant returns (uint256) {
42         return _totalSupply;
43     }
44 
45     function balanceOf(address _address) public constant returns (uint) {
46         return balances[_address];
47     }
48 
49     function changeAdmin(address _address) public {
50         require(msg.sender == _admin);
51         _admin = _address;
52     }
53     function ownerOf(uint256 _tokenId) public constant returns (address) {
54         require(tokenExists[_tokenId]);
55         return tokenOwners[_tokenId];
56     }
57 
58     function approve(address _to, uint256 _tokenId) public {
59         require(msg.sender == ownerOf(_tokenId));
60         require(msg.sender != _to);
61         allowed[msg.sender][_to] = _tokenId;
62         emit Approval(msg.sender, _to, _tokenId);
63     }
64 
65     function takeOwnership(uint256 _tokenId) public {
66         require(tokenExists[_tokenId]);
67         address oldOwner = ownerOf(_tokenId);
68         address newOwner = msg.sender;
69         require(newOwner != oldOwner);
70         require(allowed[oldOwner][newOwner] == _tokenId);
71         balances[oldOwner] -= 1;
72         tokenOwners[_tokenId] = newOwner;
73         balances[newOwner] += 1;
74         emit Transfer(oldOwner, newOwner, _tokenId);
75     }
76 
77     function transfer(address _to, uint256 _tokenId) public {
78         address currentOwner = msg.sender;
79         address newOwner = _to;
80         require(tokenExists[_tokenId]);
81         require(currentOwner == ownerOf(_tokenId));
82         require(currentOwner != newOwner);
83         require(newOwner != address(0));
84         balances[currentOwner] -= 1;
85         tokenOwners[_tokenId] = newOwner;
86         balances[newOwner] += 1;
87         emit Transfer(currentOwner, newOwner, _tokenId);
88     }
89 
90     function tokenMetadata(uint256 _tokenId) public constant returns (string, string, uint256) {
91         return (tokens[_tokenId].name, tokens[_tokenId].link, tokens[_tokenId].price);
92     }
93     
94     function createtoken(string _name, string _link, uint256 _price) public returns (bool success) {
95         require(msg.sender == _admin);
96         tokens[index] = token(_name, _link, _price);
97         tokenOwners[index] = msg.sender;
98         tokenExists[index] = true;
99         index += 1;
100         balances[msg.sender] += 1;
101         _totalSupply += 1;
102         return true;
103     }
104 
105     function updatetoken(uint256 _tokenId, string _name, string _link, uint256 _price) public returns (bool success) {
106         require(tokenExists[_tokenId]);
107         tokens[_tokenId] = token(_name, _link, _price);
108         return true;
109     }
110 
111     function buytoken(uint256 _tokenId) payable public {
112         address newOwner = msg.sender;
113         address oldOwner = tokenOwners[_tokenId];
114         require(tokenExists[_tokenId]);
115         require(newOwner != ownerOf(_tokenId));
116         require(msg.value >= tokens[_tokenId].price);
117         uint256 _remainder = msg.value - tokens[_tokenId].price;
118         newOwner.transfer(_remainder);
119         uint256 price20 = tokens[_tokenId].price/5;
120         _admin.transfer(price20/20);
121         oldOwner.transfer(tokens[_tokenId].price - price20/20);
122         tokens[_tokenId].price += price20; 
123         tokenOwners[_tokenId] = newOwner;
124         balances[oldOwner] -= 1;
125         balances[newOwner] += 1;
126         emit Transfer(oldOwner, newOwner, _tokenId);
127     }
128 }