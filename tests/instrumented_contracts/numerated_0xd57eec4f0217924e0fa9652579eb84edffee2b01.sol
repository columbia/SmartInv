1 pragma solidity ^0.4.22;
2 
3 contract Reservation {
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
18         string country;
19         string city;
20         string reserved_date;
21         string picture_link;
22         uint256 price;
23         bool for_sale;
24     }
25 
26     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
27     event Approval(address indexed _from, address indexed _to, uint256 _tokenId);
28 
29     constructor() public {
30         _admin = msg.sender;
31     }
32     
33     function admin() public view returns (address) {
34         return _admin;
35     }
36     
37     function name() public pure returns (string) {
38         return "Reservation Token";
39     }
40 
41     function symbol() public pure returns (string) {
42         return "ReT";
43     }
44 
45     function totalSupply() public view returns (uint256) {
46         return _totalSupply;
47     }
48 
49     function balanceOf(address _address) public view returns (uint) {
50         return balances[_address];
51     }
52 
53     function ownerOf(uint256 _tokenId) public view returns (address) {
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
90     function tokenMetadata(uint256 _tokenId) public view returns (string, string, string, string, string, uint256, bool) {
91         return (tokens[_tokenId].name, tokens[_tokenId].country, tokens[_tokenId].city, tokens[_tokenId].reserved_date, tokens[_tokenId].picture_link, tokens[_tokenId].price, tokens[_tokenId].for_sale);
92     }
93     
94     function createtoken(string _name, string _country, string _city, string _reserved_date, string _picture_link, uint256 _price) public returns (bool success) {
95         require(msg.sender == _admin);
96         tokens[index] = token(_name, _country, _city, _reserved_date, _picture_link, _price, false);
97         tokenOwners[index] = msg.sender;
98         tokenExists[index] = true;
99         index += 1;
100         balances[msg.sender] += 1;
101         _totalSupply += 1;
102         return true;
103     }
104 
105     function updatetoken(uint256 _tokenId, string _name, string _country, string _city, string _reserved_date, string _picture_link, uint256 _price, bool _for_sale) public returns (bool success) {
106         require(msg.sender == _admin);
107         require(tokenExists[_tokenId]);
108         tokens[_tokenId] = token(_name, _country, _city, _reserved_date, _picture_link, _price, _for_sale);
109         return true;
110     }
111 
112     function buytoken(uint256 _tokenId) payable public {
113         address newOwner = msg.sender;
114         address oldOwner = tokenOwners[_tokenId];
115         require(tokenExists[_tokenId]);
116         require(newOwner != ownerOf(_tokenId));
117         require(msg.value >= tokens[_tokenId].price);
118         uint256 _remainder = msg.value - tokens[_tokenId].price;
119         newOwner.transfer(_remainder);
120         //uint256 price20 = tokens[_tokenId].price/5;
121         //_admin.transfer(price20/20);
122         //oldOwner.transfer(tokens[_tokenId].price - price20/20);
123         oldOwner.transfer(tokens[_tokenId].price);
124         //tokens[_tokenId].price += price20; 
125         tokenOwners[_tokenId] = newOwner;
126         balances[oldOwner] -= 1;
127         balances[newOwner] += 1;
128         tokens[_tokenId].for_sale = false;
129         emit Transfer(oldOwner, newOwner, _tokenId);
130     }
131 
132     function selltoken(uint256 _tokenId) public {
133         require(tokenExists[_tokenId]);
134         require(ownerOf(_tokenId) == msg.sender);
135         tokens[_tokenId].for_sale = true;
136     }
137     
138     function changeadmin(address _new_admin) public {
139         require(msg.sender == _admin);
140         _admin = _new_admin;
141     }
142 }