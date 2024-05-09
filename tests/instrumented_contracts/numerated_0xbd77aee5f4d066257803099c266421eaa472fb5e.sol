1 pragma solidity ^0.4.15;
2 
3 contract owned {
4     function owned() public { owner = msg.sender; }
5     address public owner;
6 
7     // This contract only defines a modifier but does not use
8     // it - it will be used in derived contracts.
9     // The function body is inserted where the special symbol
10     // "_;" in the definition of a modifier appears.
11     // This means that if the owner calls this function, the
12     // function is executed and otherwise, an exception is
13     // thrown.
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 }
19 
20 contract ERC20 {
21     function balanceOf(address _owner) public constant returns (uint balance);
22     function transfer(address _to, uint _value) public returns (bool success);
23     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
24     function approve(address _spender, uint _value) public returns (bool success);
25     function allowance(address _owner, address _spender) public constant returns (uint remaining);
26     event Transfer(address indexed _from, address indexed _to, uint _value);
27     event Approval(address indexed _owner, address indexed _spender, uint _value);
28 }
29 
30 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
31 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
32 contract ERC721 {
33     // Required methods
34     function totalSupply() public returns (uint256 total);
35     function balanceOf(address _owner) public returns (uint256 balance);
36     function ownerOf(uint256 _tokenId) external returns (address owner);
37     function approve(address _to, uint256 _tokenId) external;
38     function transfer(address _to, uint256 _tokenId) external;
39     function transferFrom(address _from, address _to, uint256 _tokenId) external;
40 
41     // Events
42     event Transfer(address from, address to, uint256 tokenId);
43     event Approval(address owner, address approved, uint256 tokenId);
44 
45     // Optional
46     // function name() public view returns (string name);
47     // function symbol() public view returns (string symbol);
48     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
49     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
50 
51     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
52     function supportsInterface(bytes4 _interfaceID) external returns (bool);
53 }
54 
55 contract AutoWallet is owned {
56     function changeOwner(address _newOwner) external onlyOwner {
57         owner = _newOwner;
58     }
59     
60     function () external payable {
61         // this is the fallback function; it is called whenever the contract receives ether
62         // forward that ether onto the contract owner immediately
63         owner.transfer(msg.value);
64         // and emit the EtherReceived event in case anyone is watching it
65         EtherReceived(msg.sender, msg.value);
66     }
67     
68     function sweep() external returns (bool success) {
69         // this can be called by anyone (who wants to pay for gas), but that's safe because it will only sweep
70         // funds to the owner's account. it sweeps the entire ether balance
71         require(this.balance > 0);
72         return owner.send(this.balance);
73     }
74     
75     function transferToken(address _tokenContractAddress, address _to, uint256 _amount) external onlyOwner returns (bool success) {
76         // this can only be called by the owner. it sends some amount of an ERC-20 token to some address
77         ERC20 token = ERC20(_tokenContractAddress);
78         return token.transfer(_to, _amount);
79     }
80     
81     function sweepToken(address _tokenContractAddress) external returns (bool success) {
82         // like sweep(), this can be called by anyone. it sweeps the full balance of an ERC-20 token to the owner's account
83         ERC20 token = ERC20(_tokenContractAddress);
84         uint bal = token.balanceOf(this);
85         require(bal > 0);
86         return token.transfer(owner, bal);
87     }
88     
89     function transferTokenFrom(address _tokenContractAddress, address _from, address _to, uint256 _amount) external onlyOwner returns (bool success) {
90         ERC20 token = ERC20(_tokenContractAddress);
91         return token.transferFrom(_from, _to, _amount);
92     }
93     
94     function approveTokenTransfer(address _tokenContractAddress, address _spender, uint256 _amount) external onlyOwner returns (bool success) {
95         ERC20 token = ERC20(_tokenContractAddress);
96         return token.approve(_spender, _amount);
97     }
98     
99     function transferNonFungibleToken(address _tokenContractAddress, address _to, uint256 _tokenId) external onlyOwner {
100         // for cryptokitties etc
101         ERC721 token = ERC721(_tokenContractAddress);
102         token.transfer(_to, _tokenId);
103     }
104     
105     function transferNonFungibleTokenFrom(address _tokenContractAddress, address _from, address _to, uint256 _tokenId) external onlyOwner {
106         ERC721 token = ERC721(_tokenContractAddress);
107         token.transferFrom(_from, _to, _tokenId);
108     }
109     
110     function transferNonFungibleTokenMulti(address _tokenContractAddress, address _to, uint256[] _tokenIds) external onlyOwner {
111         ERC721 token = ERC721(_tokenContractAddress);
112         for (uint i = 0; i < _tokenIds.length; i++) {
113             token.transfer(_to, _tokenIds[i]);
114         }
115     }
116     
117     event EtherReceived(address _sender, uint256 _value);
118 }