1 pragma solidity ^0.5.0;
2 
3 pragma solidity ^0.5.0;
4 
5 // ----------------------------------------------------------------------------
6 contract ERC20Proxy {
7     function totalSupply() external view returns (uint);
8     function balanceOf(address tokenOwner) external view returns (uint balance);
9     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
10     function transfer(address to, uint tokens) external returns (bool success);
11     function approve(address spender, uint tokens) external returns (bool success);
12     function transferFrom(address from, address to, uint tokens) external returns (bool success);
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 
16     function onTransfer(address _from, address _to, uint256 _value) external;
17 }
18 
19 pragma solidity ^0.5.0;
20 
21 contract Operators
22 {
23     mapping (address=>bool) ownerAddress;
24     mapping (address=>bool) operatorAddress;
25 
26     constructor() public
27     {
28         ownerAddress[msg.sender] = true;
29     }
30 
31     modifier onlyOwner()
32     {
33         require(ownerAddress[msg.sender]);
34         _;
35     }
36 
37     function isOwner(address _addr) public view returns (bool) {
38         return ownerAddress[_addr];
39     }
40 
41     function addOwner(address _newOwner) external onlyOwner {
42         require(_newOwner != address(0));
43 
44         ownerAddress[_newOwner] = true;
45     }
46 
47     function removeOwner(address _oldOwner) external onlyOwner {
48         delete(ownerAddress[_oldOwner]);
49     }
50 
51     modifier onlyOperator() {
52         require(isOperator(msg.sender));
53         _;
54     }
55 
56     function isOperator(address _addr) public view returns (bool) {
57         return operatorAddress[_addr] || ownerAddress[_addr];
58     }
59 
60     function addOperator(address _newOperator) external onlyOwner {
61         require(_newOperator != address(0));
62 
63         operatorAddress[_newOperator] = true;
64     }
65 
66     function removeOperator(address _oldOperator) external onlyOwner {
67         delete(operatorAddress[_oldOperator]);
68     }
69 }
70 
71 pragma solidity ^0.5.0;
72 
73 interface BlockchainCutiesERC1155Interface
74 {
75     function mintNonFungibleSingleShort(uint128 _type, address _to) external;
76     function mintNonFungibleSingle(uint256 _type, address _to) external;
77     function mintNonFungibleShort(uint128 _type, address[] calldata _to) external;
78     function mintNonFungible(uint256 _type, address[] calldata _to) external;
79     function mintFungibleSingle(uint256 _id, address _to, uint256 _quantity) external;
80     function mintFungible(uint256 _id, address[] calldata _to, uint256[] calldata _quantities) external;
81     function isNonFungible(uint256 _id) external pure returns(bool);
82     function ownerOf(uint256 _id) external view returns (address);
83     function totalSupplyNonFungible(uint256 _type) view external returns (uint256);
84     function totalSupplyNonFungibleShort(uint128 _type) view external returns (uint256);
85 
86     /**
87         @notice A distinct Uniform Resource Identifier (URI) for a given token.
88         @dev URIs are defined in RFC 3986.
89         The URI may point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
90         @return URI string
91     */
92     function uri(uint256 _id) external view returns (string memory);
93     function proxyTransfer721(address _from, address _to, uint256 _tokenId, bytes calldata _data) external;
94     function proxyTransfer20(address _from, address _to, uint256 _tokenId, uint256 _value) external;
95     /**
96         @notice Get the balance of an account's Tokens.
97         @param _owner  The address of the token holder
98         @param _id     ID of the Token
99         @return        The _owner's balance of the Token type requested
100      */
101     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
102     /**
103         @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
104         @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
105         MUST revert if `_to` is the zero address.
106         MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
107         MUST revert on any other error.
108         MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
109         After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).
110         @param _from    Source address
111         @param _to      Target address
112         @param _id      ID of the token type
113         @param _value   Transfer amount
114         @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
115     */
116     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;
117 }
118 
119 
120 contract Proxy20_1155 is ERC20Proxy, Operators {
121 
122     BlockchainCutiesERC1155Interface public erc1155;
123     uint256 public tokenId;
124     string public tokenName;
125     string public tokenSymbol;
126     bool public canSetup = true;
127     uint256 totalTokens = 0;
128 
129     modifier canBeStoredIn128Bits(uint256 _value)
130     {
131         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
132         _;
133     }
134 
135     function setup(
136         BlockchainCutiesERC1155Interface _erc1155,
137         uint256 _tokenId,
138         string calldata _tokenSymbol,
139         string calldata _tokenName) external onlyOwner canBeStoredIn128Bits(_tokenId)
140     {
141         require(canSetup);
142         erc1155 = _erc1155;
143         tokenId = _tokenId;
144         tokenSymbol = _tokenSymbol;
145         tokenName = _tokenName;
146     }
147 
148     function disableSetup() external onlyOwner
149     {
150         canSetup = false;
151     }
152 
153     /// @notice A descriptive name for a collection of NFTs in this contract
154     function name() external view returns (string memory)
155     {
156         return tokenName;
157     }
158 
159     /// @notice An abbreviated name for NFTs in this contract
160     function symbol() external view returns (string memory)
161     {
162         return tokenSymbol;
163     }
164 
165     function totalSupply() external view returns (uint)
166     {
167         return totalTokens;
168     }
169 
170     function balanceOf(address tokenOwner) external view returns (uint balance)
171     {
172         balance = erc1155.balanceOf(tokenOwner, tokenId);
173     }
174 
175     function allowance(address, address) external view returns (uint)
176     {
177         return 0;
178     }
179 
180     function transfer(address _to, uint _value) external returns (bool)
181     {
182         _transfer(msg.sender, _to, _value);
183         return true;
184     }
185 
186     function _transfer(address _from, address _to, uint256 _value) internal
187     {
188         erc1155.proxyTransfer20(_from, _to, tokenId, _value);
189     }
190 
191     function approve(address, uint) external returns (bool)
192     {
193         revert();
194     }
195 
196     function transferFrom(address _from, address _to, uint _value) external returns (bool)
197     {
198         _transfer(_from, _to, _value);
199         return true;
200     }
201 
202     function onTransfer(address _from, address _to, uint256 _value) external
203     {
204         require(msg.sender == address(erc1155));
205         emit Transfer(_from, _to, _value);
206         if (_from == address(0x0))
207         {
208             totalTokens += _value;
209         }
210         if (_to == address(0x0))
211         {
212             totalTokens -= _value;
213         }
214     }
215 }