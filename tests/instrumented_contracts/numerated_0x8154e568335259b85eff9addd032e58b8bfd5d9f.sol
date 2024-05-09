1 pragma solidity ^0.4.25;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     function Ownable() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 contract EVERCOIN is Ownable {
25     struct Token {
26         address owner;
27         uint8 tokenType;
28         uint32 amount;
29     }
30 
31     Token[] public tokens;
32     bool public implementsERC721 = true;
33     string public name = "EVERCOIN";
34     string public symbol = "EC";
35     mapping(uint256 => address) public approved;
36     mapping(address => uint256) public balances;
37 
38     modifier onlyTokenOwner(uint256 _tokenId) {
39         require(tokens[_tokenId].owner == msg.sender);
40         _;
41     }
42 
43     function mintToken(address _owner) public onlyOwner() {
44         tokens.length ++;
45         Token storage Token_demo = tokens[tokens.length - 1];
46         Token_demo.owner = _owner;
47         Transfer(address(0), _owner, tokens.length - 1);
48     }
49 
50     function getTokenType(uint256 _tokenId) view public returns (uint8 tokenType) {
51         tokenType = tokens[_tokenId].tokenType;
52     }
53 
54     function getTokenAmount(uint256 _tokenId) view public returns (uint32 tokenAmount) {
55         tokenAmount = tokens[_tokenId].amount;
56     }
57 
58     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
59     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
60 
61     function totalSupply() public view returns (uint256 total) {
62         total = tokens.length;
63     }
64 
65     function balanceOf(address _owner) public view returns (uint256 balance){
66         balance = balances[_owner];
67     }
68 
69     function ownerOf(uint256 _tokenId) public view returns (address owner){
70         owner = tokens[_tokenId].owner;
71     }
72 
73     function _transfer(address _from, address _to, uint256 _tokenId) internal {
74         require(tokens[_tokenId].owner == _from);
75         tokens[_tokenId].owner = _to;
76         approved[_tokenId] = address(0);
77         balances[_from] -= 1;
78         balances[_to] += 1;
79         Transfer(_from, _to, _tokenId);
80     }
81 
82     function transfer(address _to, uint256 _tokenId) public onlyTokenOwner(_tokenId) returns (bool){
83         _transfer(msg.sender, _to, _tokenId);
84         return true;
85     }
86 
87     function approve(address _to, uint256 _tokenId) public onlyTokenOwner(_tokenId){
88         approved[_tokenId] = _to;
89         Approval(msg.sender, _to, _tokenId);
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {
93         require(approved[_tokenId] == msg.sender);
94         _transfer(_from, _to, _tokenId);
95         return true;
96     }
97 
98 
99     function takeOwnership(uint256 _tokenId) public {
100         require(approved[_tokenId] == msg.sender);
101         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
102     }
103 }