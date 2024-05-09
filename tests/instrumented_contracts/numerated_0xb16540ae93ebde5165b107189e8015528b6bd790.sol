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
40 contract TokenPriveProviderInterface {
41     function tokenPrice() public constant returns (uint);
42 }
43 
44 // ----------------------------------------------------------------------------
45 // Dividends implementation interface
46 // ----------------------------------------------------------------------------
47 contract SNcoin_AgentsSale is Owned {
48     MinimalTokenInterface public tokenContract;
49     address public spenderAddress;
50     address public vaultAddress;
51     bool public fundingEnabled;
52     uint public totalCollected;         // In wei
53     TokenPriveProviderInterface public tokenPriceProvider;         // In wei
54     mapping(address => address) agents;
55 
56     // ------------------------------------------------------------------------
57     // Constructor
58     // ------------------------------------------------------------------------
59     constructor(address _tokenAddress, address _spenderAddress, address _vaultAddress, bool _fundingEnabled, address _tokenPriceProvider) public {
60         require (_tokenAddress != 0);
61         require (_spenderAddress != 0);
62         require (_vaultAddress != 0);
63         require (_tokenPriceProvider != 0);
64         tokenContract = MinimalTokenInterface(_tokenAddress);
65         spenderAddress = _spenderAddress;
66         vaultAddress = _vaultAddress;
67         fundingEnabled = _fundingEnabled;
68         tokenPriceProvider = TokenPriveProviderInterface(_tokenPriceProvider);
69     }
70 
71     function setSpenderAddress(address _spenderAddress) public onlyOwner {
72         require (_spenderAddress != 0);
73         spenderAddress = _spenderAddress;
74         return;
75     }
76 
77     function setVaultAddress(address _vaultAddress) public onlyOwner {
78         require (_vaultAddress != 0);
79         vaultAddress = _vaultAddress;
80         return;
81     }
82 
83     function setFundingEnabled(bool _fundingEnabled) public onlyOwner {
84         fundingEnabled = _fundingEnabled;
85         return;
86     }
87 
88     function updateTokenPriceProvider(address _newTokenPriceProvider) public onlyOwner {
89         require(_newTokenPriceProvider != 0);
90         tokenPriceProvider = TokenPriveProviderInterface(_newTokenPriceProvider);
91         require(tokenPriceProvider.tokenPrice() > 10**9);
92         return;
93     }
94 
95     function setAgentAddress(address _agentSigner, address _agentAddress) public onlyOwner {
96         require (_agentSigner != 0);
97         agents[_agentSigner] = _agentAddress;
98         return;
99     }
100 
101     function buy(uint _discount, bytes _promocode) public payable {
102         require (fundingEnabled);
103         uint tokenPrice = tokenPriceProvider.tokenPrice(); // In wei
104         require (tokenPrice > 10**9);
105         require (msg.value >= tokenPrice);
106         require (_discount <= 20);
107         require (_promocode.length == 97);
108 
109 
110         bytes32 r;
111         bytes32 s;
112         uint8 v;
113         bytes32 h;
114         assembly {
115           r := mload(add(_promocode, 32))
116           s := mload(add(_promocode, 64))
117           v := and(mload(add(_promocode, 65)), 255)
118           h := mload(add(_promocode, 97))
119         }
120 
121         // https://github.com/ethereum/go-ethereum/issues/2053
122         if (v < 27) {
123           v += 27;
124         }
125         require ((v == 27) || (v == 28));
126 
127         address agentSigner = ecrecover(h, v, r, s);
128         require (agentSigner != 0);
129         require (agents[agentSigner] != 0);
130         bytes32 check_h = keccak256(abi.encodePacked(_discount, msg.sender));
131         require (check_h == h);
132 
133         uint remVal = ((20 - _discount)*msg.value)/100;
134         totalCollected += msg.value - remVal;
135         uint discountedPrice = ((100 - _discount)*tokenPrice)/100;
136         uint tokens = (msg.value * 10**uint256(tokenContract.decimals())) / discountedPrice;
137 
138         require (tokenContract.transferFrom(spenderAddress, msg.sender, tokens));
139         //Send the ether to the vault
140         vaultAddress.transfer(msg.value - remVal);
141         agents[agentSigner].transfer(remVal);
142 
143         return;
144     }
145 
146     // ------------------------------------------------------------------------
147     // Don't accept plain ETH transfers
148     // ------------------------------------------------------------------------
149     function () public payable {
150         revert();
151     }
152 
153     /// @notice This method can be used by the owner to extract mistakenly
154     ///  sent tokens to this contract.
155     /// @param _token The address of the token contract that you want to recover
156     ///  set to 0 in case you want to extract ether.
157     function claimTokens(address _token) public onlyOwner {
158         if (_token == 0x0) {
159             owner.transfer(address(this).balance);
160             return;
161         }
162 
163         MinimalTokenInterface token = MinimalTokenInterface(_token);
164         uint balance = token.balanceOf(this);
165         token.transfer(owner, balance);
166         emit ClaimedTokens(_token, owner, balance);
167     }
168 
169     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
170 }