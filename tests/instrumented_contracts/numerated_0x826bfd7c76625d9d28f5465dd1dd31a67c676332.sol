1 pragma solidity ^0.4.25;
2 
3 
4 contract Ownable {
5     
6     address public owner;
7     mapping (address => bool) public superUsers;
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9     
10     constructor() public {
11         owner = msg.sender;
12         superUsers[msg.sender] = true;
13     }
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner);
17         _;
18     }
19     
20      modifier onlySuperUser() {
21         require(superUsers[msg.sender] == true);
22         _;
23     }
24     
25     function setSuperUser(address user) public onlyOwner {
26         superUsers[user] = true;
27     }
28     
29     function transferOwnership(address newOwner) public onlyOwner {
30         require(newOwner != address(0));
31         emit OwnershipTransferred(owner, newOwner);
32         owner = newOwner;
33     }
34 }
35 
36 contract SuperToken is Ownable {
37     struct Token {
38         address owner;
39         uint8 tokenType;
40         uint32 amount;
41     }
42 
43     Token[] public tokens;
44     bool public implementsERC721 = true;
45     string public name = "ever test token";
46     string public symbol = "ST";
47     mapping(uint256 => address) public approved;
48     mapping(address => uint256) public balances;
49     
50     
51     modifier onlyTokenOwner(uint256 _tokenId) {
52         require(tokens[_tokenId].owner == msg.sender);
53         _;
54     }
55    
56     function mintToken(address _owner) public onlyOwner() {
57         tokens.length ++;
58         Token storage Token_demo = tokens[tokens.length - 1];
59         Token_demo.owner = _owner;
60         balances[_owner] += 1;
61         emit Transfer(address(0), _owner, tokens.length - 1);
62     }
63 
64     function getTokenType(uint256 _tokenId) view public returns (uint8 tokenType) {
65         tokenType = tokens[_tokenId].tokenType;
66     }
67 
68     function getTokenAmount(uint256 _tokenId) view public returns (uint32 tokenAmount) {
69         tokenAmount = tokens[_tokenId].amount;
70     }
71 
72     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
73     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
74 
75     function totalSupply() public view returns (uint256 total) {
76         total = tokens.length;
77     }
78 
79     function balanceOf(address _owner) public view returns (uint256 balance){
80         balance = balances[_owner];
81     }
82 
83     function ownerOf(uint256 _tokenId) public view returns (address owner){
84         owner = tokens[_tokenId].owner;
85     }
86 
87     function _transfer(address _from, address _to, uint256 _tokenId) internal {
88         require(tokens[_tokenId].owner == _from);
89         tokens[_tokenId].owner = _to;
90         approved[_tokenId] = address(0);
91         balances[_from] -= 1;
92         balances[_to] += 1;
93         emit Transfer(_from, _to, _tokenId);
94     }
95 
96     function transfer(address _to, uint256 _tokenId) public onlyTokenOwner(_tokenId) returns (bool){
97         _transfer(msg.sender, _to, _tokenId);
98         return true;
99     }
100     
101     function superTransfer(address _from, address _to, uint256 _tokenId) public onlySuperUser returns(bool){
102         _transfer(_from, _to, _tokenId);
103         return true;
104     }
105     
106     function approve(address _to, uint256 _tokenId) public onlyTokenOwner(_tokenId){
107         approved[_tokenId] = _to;
108         emit Approval(msg.sender, _to, _tokenId);
109     }
110 
111     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {
112         require(approved[_tokenId] == msg.sender);
113         _transfer(_from, _to, _tokenId);
114         return true;
115     }
116 
117 
118     function takeOwnership(uint256 _tokenId) public {
119         require(approved[_tokenId] == msg.sender);
120         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
121     }
122 }