1 pragma solidity ^0.4.19;
2 contract ERC721 {
3    string constant private tokenName = "My ERC721 Token";
4    string constant private tokenSymbol = "MET";
5    uint256 constant private totalTokens = 1000000;
6    mapping(address => uint) private balances;
7    mapping(uint256 => address) private tokenOwners;
8    mapping(uint256 => bool) private tokenExists;
9    mapping(address => mapping (address => uint256)) private allowed;
10    mapping(address => mapping(uint256 => uint256)) private ownerTokens;
11    
12    mapping(uint256 => string) tokenLinks;
13    function removeFromTokenList(address owner, uint256 _tokenId) private {
14      for(uint256 i = 0;ownerTokens[owner][i] != _tokenId;i++){
15        ownerTokens[owner][i] = 0;
16      }
17    }
18    function name() public constant returns (string){
19        return tokenName;
20    }
21    function symbol() public constant returns (string) {
22        return tokenSymbol;
23    }
24    function totalSupply() public constant returns (uint256){
25        return totalTokens;
26    }
27    function balanceOf(address _owner) constant returns (uint){
28        return balances[_owner];
29    }
30    function ownerOf(uint256 _tokenId) constant returns (address){
31        require(tokenExists[_tokenId]);
32        return tokenOwners[_tokenId];
33    }
34    function approve(address _to, uint256 _tokenId){
35        require(msg.sender == ownerOf(_tokenId));
36        require(msg.sender != _to);
37        allowed[msg.sender][_to] = _tokenId;
38        Approval(msg.sender, _to, _tokenId);
39    }
40    function takeOwnership(uint256 _tokenId){
41        require(tokenExists[_tokenId]);
42        address oldOwner = ownerOf(_tokenId);
43        address newOwner = msg.sender;
44        require(newOwner != oldOwner);
45        require(allowed[oldOwner][newOwner] == _tokenId);
46        balances[oldOwner] -= 1;
47        tokenOwners[_tokenId] = newOwner;
48        balances[oldOwner] += 1;
49        Transfer(oldOwner, newOwner, _tokenId);
50    }
51    function transfer(address _to, uint256 _tokenId){
52        address currentOwner = msg.sender;
53        address newOwner = _to;
54        require(tokenExists[_tokenId]);
55        require(currentOwner == ownerOf(_tokenId));
56        require(currentOwner != newOwner);
57        require(newOwner != address(0));
58        removeFromTokenList(_to,_tokenId);
59        balances[currentOwner] -= 1;
60        tokenOwners[_tokenId] = newOwner;
61        balances[newOwner] += 1;
62        Transfer(currentOwner, newOwner, _tokenId);
63    }
64    function tokenOfOwnerByIndex(address _owner, uint256 _index) constant returns (uint tokenId){
65        return ownerTokens[_owner][_index];
66    }
67    function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl){
68        return tokenLinks[_tokenId];
69    }
70    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
71    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
72 }