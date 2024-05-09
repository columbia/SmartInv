1 pragma solidity ^0.4.19;
2 contract ERC721 {
3    string constant private tokenName = "ENCRYPTOART";
4    string constant private tokenSymbol = "ENA";
5    uint256 constant private totalTokens = 10000000000;
6    mapping(address => uint) private balances;
7    mapping(uint256 => address) private tokenOwners;
8    mapping(uint256 => bool) private tokenExists;
9    mapping(address => mapping (address => uint256)) private allowed;
10    mapping(address => mapping(uint256 => uint256)) private ownerTokens;
11    
12    mapping(uint256 => string) tokenLinks;
13    function name() public constant returns (string){
14        return tokenName;
15    }
16    function symbol() public constant returns (string) {
17        return tokenSymbol;
18    }
19    function totalSupply() public constant returns (uint256){
20        return totalTokens;
21    }
22    function balanceOf(address _owner) constant returns (uint){
23        return balances[_owner];
24    }
25    function ownerOf(uint256 _tokenId) constant returns (address){
26        require(tokenExists[_tokenId]);
27        return tokenOwners[_tokenId];
28    }
29    function approve(address _to, uint256 _tokenId){
30        require(msg.sender == ownerOf(_tokenId));
31        require(msg.sender != _to);
32        allowed[msg.sender][_to] = _tokenId;
33        Approval(msg.sender, _to, _tokenId);
34    }
35    function takeOwnership(uint256 _tokenId){
36        require(tokenExists[_tokenId]);
37        address oldOwner = ownerOf(_tokenId);
38        address newOwner = msg.sender;
39        require(newOwner != oldOwner);
40        require(allowed[oldOwner][newOwner] == _tokenId);
41        balances[oldOwner] -= 1;
42        tokenOwners[_tokenId] = newOwner;
43        balances[oldOwner] += 1;
44        Transfer(oldOwner, newOwner, _tokenId);
45    }
46    function transfer(address _to, uint256 _tokenId){
47        address currentOwner = msg.sender;
48        address newOwner = _to;
49        require(tokenExists[_tokenId]);
50        require(currentOwner == ownerOf(_tokenId));
51        require(currentOwner != newOwner);
52        require(newOwner != address(0));
53        require(allowed[currentOwner][newOwner] == _tokenId);
54        balances[currentOwner] -= 1;
55        tokenOwners[_tokenId] = newOwner;
56        balances[newOwner] += 1;
57        Transfer(currentOwner, newOwner, _tokenId);
58    }
59    function tokenOfOwnerByIndex(address _owner, uint256 _index) constant returns (uint tokenId){
60        return ownerTokens[_owner][_index];
61    }
62    function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl){
63        return tokenLinks[_tokenId];
64    }
65    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
66    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
67 }