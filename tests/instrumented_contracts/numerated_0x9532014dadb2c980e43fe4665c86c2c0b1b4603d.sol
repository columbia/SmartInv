1 contract SafeMath {
2     
3     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
4 
5     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
6         require(x <= MAX_UINT256 - y);
7         return x + y;
8     }
9 
10     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
11         require(x >= y);
12         return x - y;
13     }
14 
15     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
16         if (y == 0) {
17             return 0;
18         }
19         require(x <= (MAX_UINT256 / y));
20         return x * y;
21     }
22 }
23 
24 contract Owned {
25     address public owner;
26     address public newOwner;
27 
28     function Owned() {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         assert(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address _newOwner) public onlyOwner {
38         require(_newOwner != owner);
39         newOwner = _newOwner;
40     }
41 
42     function acceptOwnership() public {
43         require(msg.sender == newOwner);
44         OwnerUpdate(owner, newOwner);
45         owner = newOwner;
46         newOwner = 0x0;
47     }
48 
49     event OwnerUpdate(address _prevOwner, address _newOwner);
50 }
51 
52 
53 contract Lockable is Owned {
54 
55     uint256 public lockedUntilBlock;
56 
57     event ContractLocked(uint256 _untilBlock, string _reason);
58 
59     modifier lockAffected {
60         require(block.number > lockedUntilBlock);
61         _;
62     }
63 
64     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
65         lockedUntilBlock = _untilBlock;
66         ContractLocked(_untilBlock, _reason);
67     }
68 
69 
70     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
71         lockedUntilBlock = _untilBlock;
72         ContractLocked(_untilBlock, _reason);
73     }
74 }
75 
76 
77 contract ERC20PrivateInterface {
78     uint256 supply;
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowances;
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84 }
85 
86 contract tokenRecipientInterface {
87   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
88 }
89 
90 contract OwnedInterface {
91     address public owner;
92     address public newOwner;
93 
94     modifier onlyOwner {
95         _;
96     }
97 }
98 
99 contract ERC20TokenInterface {
100   function totalSupply() public constant returns (uint256 _totalSupply);
101   function balanceOf(address _owner) public constant returns (uint256 balance);
102   function transfer(address _to, uint256 _value) public returns (bool success);
103   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
104   function approve(address _spender, uint256 _value) public returns (bool success);
105   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
106 
107   event Transfer(address indexed _from, address indexed _to, uint256 _value);
108   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
109 }
110 
111 
112 
113 contract MintableTokenInterface {
114     function mint(address _to, uint256 _amount) public;
115 }
116 
117 contract MintingContract is Owned {
118     
119     address public tokenAddress;
120     enum state { crowdsaleMinintg, teamMinting, finished}
121 
122     state public mintingState; 
123     uint public crowdsaleMintingCap;
124     uint public tokensAlreadyMinted;
125     
126     uint public teamTokensPercent;
127     address public teamTokenAddress;
128     uint public communityTokens;
129     uint public communityTokens2;
130     address public communityAddress;
131     
132     constructor() public {
133         crowdsaleMintingCap = 570500000 * 10**18;
134         teamTokensPercent = 27;
135         teamTokenAddress = 0xc2180bC387B7944FabE5E5e25BFaC69Af2Dc888A;
136         communityTokens = 24450000 * 10**18;
137         communityTokens2 = 5705000 * 10**18;
138         communityAddress = 0x4FAAc921781122AA61cfE59841A7669840821b86;
139     }
140     
141     function doCrowdsaleMinting(address _destination, uint _tokensToMint) onlyOwner public {
142         require(mintingState == state.crowdsaleMinintg);
143         require(tokensAlreadyMinted + _tokensToMint <= crowdsaleMintingCap);
144         MintableTokenInterface(tokenAddress).mint(_destination, _tokensToMint);
145         tokensAlreadyMinted += _tokensToMint;
146     }
147     
148     function finishCrowdsaleMinting() onlyOwner public {
149         mintingState = state.teamMinting;
150     }
151     
152     function doTeamMinting() public {
153         require(mintingState == state.teamMinting);
154         uint onePercent = tokensAlreadyMinted/70;
155         MintableTokenInterface(tokenAddress).mint(communityAddress, communityTokens2);
156         MintableTokenInterface(tokenAddress).mint(teamTokenAddress, communityTokens - communityTokens2);
157         MintableTokenInterface(tokenAddress).mint(teamTokenAddress, (teamTokensPercent * onePercent));
158         mintingState = state.finished;
159     }
160 
161     function setTokenAddress(address _tokenAddress) onlyOwner public {
162         tokenAddress = _tokenAddress;
163     }
164 }