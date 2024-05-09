1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Owned contract
5 // ----------------------------------------------------------------------------
6 contract Owned {
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner {
22         newOwner = _newOwner;
23     }
24 
25     function acceptOwnership() public {
26         require(msg.sender == newOwner);
27         emit OwnershipTransferred(owner, newOwner);
28         owner = newOwner;
29         newOwner = address(0);
30     }
31 }
32 
33 contract MinimalTokenInterface {
34     function balanceOf(address tokenOwner) public constant returns (uint balance);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function decimals() public returns (uint8);
37 }
38 
39 // ----------------------------------------------------------------------------
40 // Dividends implementation interface
41 // ----------------------------------------------------------------------------
42 contract SNcoin_Sale is Owned {
43     MinimalTokenInterface public tokenContract;
44     address public vaultAddress;
45     bool public fundingEnabled;
46     uint public totalCollected;         // In wei
47     uint public tokenPrice;         // In wei
48 
49     // ------------------------------------------------------------------------
50     // Constructor
51     // ------------------------------------------------------------------------
52     constructor(address _tokenAddress, address _vaultAddress, bool _fundingEnabled, uint _newTokenPrice) public {
53         require((_tokenAddress != 0) && (_vaultAddress != 0) && (_newTokenPrice > 0));
54         tokenContract = MinimalTokenInterface(_tokenAddress);
55         vaultAddress = _vaultAddress;
56         fundingEnabled = _fundingEnabled;
57         tokenPrice = _newTokenPrice;
58     }
59 
60     function setVaultAddress(address _vaultAddress) public onlyOwner {
61         vaultAddress = _vaultAddress;
62         return;
63     }
64 
65     function setFundingEnabled(bool _fundingEnabled) public onlyOwner {
66         fundingEnabled = _fundingEnabled;
67         return;
68     }
69 
70     function updateTokenPrice(uint _newTokenPrice) public onlyOwner {
71         require(_newTokenPrice > 0);
72         tokenPrice = _newTokenPrice;
73         return;
74     }
75 
76     function () public payable {
77         require (fundingEnabled && (tokenPrice > 0) && (msg.value >= tokenPrice));
78         
79         totalCollected += msg.value;
80 
81         //Send the ether to the vault
82         vaultAddress.transfer(msg.value);
83 
84         uint tokens = (msg.value * 10**uint256(tokenContract.decimals())) / tokenPrice;
85         require (tokenContract.transfer(msg.sender, tokens));
86 
87         return;
88     }
89 
90     /// @notice This method can be used by the owner to extract mistakenly
91     ///  sent tokens to this contract.
92     /// @param _token The address of the token contract that you want to recover
93     ///  set to 0 in case you want to extract ether.
94     function claimTokens(address _token) public onlyOwner {
95         if (_token == 0x0) {
96             owner.transfer(address(this).balance);
97             return;
98         }
99 
100         MinimalTokenInterface token = MinimalTokenInterface(_token);
101         uint balance = token.balanceOf(this);
102         token.transfer(owner, balance);
103         emit ClaimedTokens(_token, owner, balance);
104     }
105     
106     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
107 }