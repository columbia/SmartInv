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
33 // ----------------------------------------------------------------------------
34 // ERC Token Standard #20 Interface
35 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
36 // ----------------------------------------------------------------------------
37 contract ERC20Interface {
38     function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 // ----------------------------------------------------------------------------
50 // Dividends implementation interface
51 // ----------------------------------------------------------------------------
52 contract AHF_PreSale is Owned {
53     ERC20Interface public tokenContract;
54     address public vaultAddress;
55     bool public fundingEnabled;
56     uint public totalCollected;         // In wei
57     uint public tokenPrice;         // In wei
58 
59     function setTokenAddress(address _tokenAddress) public onlyOwner {
60         tokenContract = ERC20Interface(_tokenAddress);
61         return;
62     }
63 
64     function setVaultAddress(address _vaultAddress) public onlyOwner {
65         vaultAddress = _vaultAddress;
66         return;
67     }
68 
69     function setFundingEnabled(bool _fundingEnabled) public onlyOwner {
70         fundingEnabled = _fundingEnabled;
71         return;
72     }
73 
74     function updateTokenPrice(uint _newTokenPrice) public onlyOwner {
75         tokenPrice = _newTokenPrice;
76         return;
77     }
78 
79     function () public payable {
80         require (fundingEnabled && (tokenPrice > 0) && (msg.value >= tokenPrice));
81         
82         totalCollected += msg.value;
83 
84         //Send the ether to the vault
85         vaultAddress.transfer(msg.value);
86 
87         uint tokens = (msg.value * 10**18) / tokenPrice;
88         require (tokenContract.transfer(msg.sender, tokens));
89 
90         return;
91     }
92 
93     /// @notice This method can be used by the owner to extract mistakenly
94     ///  sent tokens to this contract.
95     /// @param _token The address of the token contract that you want to recover
96     ///  set to 0 in case you want to extract ether.
97     function claimTokens(address _token) public onlyOwner {
98         if (_token == 0x0) {
99             owner.transfer(address(this).balance);
100             return;
101         }
102 
103         ERC20Interface token = ERC20Interface(_token);
104         uint balance = token.balanceOf(this);
105         token.transfer(owner, balance);
106         emit ClaimedTokens(_token, owner, balance);
107     }
108     
109     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
110 }