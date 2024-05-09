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
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37     function decimals() public returns (uint8);
38 }
39 
40 // ----------------------------------------------------------------------------
41 // Dividends implementation interface
42 // ----------------------------------------------------------------------------
43 contract SNcoin_CountrySale is Owned {
44     MinimalTokenInterface public tokenContract;
45     address public spenderAddress;
46     address public vaultAddress;
47     address public ambassadorAddress;
48     bool public fundingEnabled;
49     uint public totalCollected;         // In wei
50     uint public tokenPrice;         // In wei
51     string public country;
52 
53 
54     // ------------------------------------------------------------------------
55     // Constructor
56     // ------------------------------------------------------------------------
57     constructor(address _tokenAddress, address _spenderAddress, address _vaultAddress, address _ambassadorAddress, bool _fundingEnabled, uint _newTokenPrice, string _country) public {
58         require (_tokenAddress != 0);
59         require (_spenderAddress != 0);
60         require (_vaultAddress != 0);
61         require (_newTokenPrice > 0);
62         require (bytes(_country).length > 0);
63         tokenContract = MinimalTokenInterface(_tokenAddress);
64         spenderAddress = _spenderAddress;
65         vaultAddress = _vaultAddress;
66         ambassadorAddress = _ambassadorAddress;
67         fundingEnabled = _fundingEnabled;
68         tokenPrice = _newTokenPrice;
69         country = _country;
70     }
71 
72     function setSpenderAddress(address _spenderAddress) public onlyOwner {
73         require (_spenderAddress != 0);
74         spenderAddress = _spenderAddress;
75         return;
76     }
77 
78     function setVaultAddress(address _vaultAddress) public onlyOwner {
79         require (_vaultAddress != 0);
80         vaultAddress = _vaultAddress;
81         return;
82     }
83 
84     function setAmbassadorAddress(address _ambassadorAddress) public onlyOwner {
85         require (_ambassadorAddress != 0);
86         ambassadorAddress = _ambassadorAddress;
87         return;
88     }
89 
90     function setFundingEnabled(bool _fundingEnabled) public onlyOwner {
91         fundingEnabled = _fundingEnabled;
92         return;
93     }
94 
95     function updateTokenPrice(uint _newTokenPrice) public onlyOwner {
96         require(_newTokenPrice > 10**9);
97         tokenPrice = _newTokenPrice;
98         return;
99     }
100 
101     function () public payable {
102         require (fundingEnabled);
103         require (ambassadorAddress != 0);
104         require (tokenPrice > 10**9);
105         require (msg.value >= tokenPrice);
106 
107         totalCollected += msg.value;
108         uint ambVal = (20 * msg.value)/100;
109         uint tokens = (msg.value * 10**uint256(tokenContract.decimals())) / tokenPrice;
110 
111         require (tokenContract.transferFrom(spenderAddress, msg.sender, tokens));
112 
113         //Send the ether to the vault
114         ambassadorAddress.transfer(ambVal);
115         vaultAddress.transfer(msg.value - ambVal);
116 
117         return;
118     }
119 
120     /// @notice This method can be used by the owner to extract mistakenly
121     ///  sent tokens to this contract.
122     /// @param _token The address of the token contract that you want to recover
123     ///  set to 0 in case you want to extract ether.
124     function claimTokens(address _token) public onlyOwner {
125         if (_token == 0x0) {
126             owner.transfer(address(this).balance);
127             return;
128         }
129 
130         MinimalTokenInterface token = MinimalTokenInterface(_token);
131         uint balance = token.balanceOf(this);
132         token.transfer(owner, balance);
133         emit ClaimedTokens(_token, owner, balance);
134     }
135     
136     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
137 }