1 pragma solidity ^0.4.19;
2 
3 /**
4 * @title Ownable
5 * @dev The Ownable contract has an owner address, and provides basic authorization control
6 * functions, this simplifies the implementation of "user permissions".
7 */
8 contract Ownable {
9 
10     address private owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16     * account.
17     */
18     function Ownable() public {
19         owner = msg.sender;
20     }
21 
22     /**
23     * @dev Throws if called by any account other than the owner.
24     */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     /**
31     * @dev Allows the current owner to transfer control of the contract to a newOwner.
32     * @param _newOwner The address to transfer ownership to.
33     */
34     function transferOwnership(address _newOwner) onlyOwner external {
35         require(_newOwner != address(0));
36         OwnershipTransferred(owner, _newOwner);
37         owner = _newOwner;
38     }
39 
40 }
41 
42 /**
43  * @title Upgradable
44  * @dev The contract can be deprecated and the owner can set - only once - another address to advertise
45  * clients of the existence of another more recent contract.
46  */
47 contract Upgradable is Ownable {
48 
49     address public newAddress;
50 
51     uint    public deprecatedSince;
52 
53     string  public version;
54     string  public newVersion;
55     string  public reason;
56 
57     event Deprecated(address newAddress, string newVersion, string reason);
58 
59     /**
60      */
61     function Upgradable(string _version) public {
62         version = _version;
63     }
64 
65     /**
66      */
67     function setDeprecated(address _newAddress, string _newVersion, string _reason) external onlyOwner returns (bool success) {
68         require(!isDeprecated());
69         address _currentAddress = this;
70         require(_newAddress != _currentAddress);
71         deprecatedSince = block.timestamp;
72         newAddress = _newAddress;
73         newVersion = _newVersion;
74         reason = _reason;
75         Deprecated(_newAddress, _newVersion, _reason);
76         require(!Upgradable(_newAddress).isDeprecated());
77         return true;
78     }
79 
80     /**
81      * @notice check if the contract is deprecated
82      */
83     function isDeprecated() public view returns (bool deprecated) {
84         return (deprecatedSince != 0);
85     }
86 }
87 
88 contract TokenERC20 {
89 
90     event Transfer(address indexed _from, address indexed _to, uint256 _value);
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92 
93     function transfer(address _to, uint256 _value) public returns (bool success);
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
95     function approve(address _spender, uint256 _value) public returns (bool success);
96     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
97     function balanceOf(address _owner) public view returns (uint256 balance);
98 }
99 
100 contract Managed is Upgradable {
101 
102     function Managed (string _version) Upgradable (_version) internal { }
103 
104     /**
105     *
106     */    
107     function redeemEthers(address _to, uint _amount) onlyOwner external returns (bool success) {
108         _to.transfer(_amount);
109         return true;
110     }
111 
112     /**
113      *
114      */
115     function redeemTokens(TokenERC20 _tokenAddress, address _to, uint _amount) onlyOwner external returns (bool success) {
116         return _tokenAddress.transfer(_to, _amount);
117     }
118 
119 }
120 
121 
122 /**
123  * @title Airdrop
124  * @notice Generic contract for token airdrop, initially used for BTL token (0x2accaB9cb7a48c3E82286F0b2f8798D201F4eC3f)
125  */
126 contract TokenGiveaway is Managed {
127     
128     address private tokenContract   = 0x2accaB9cb7a48c3E82286F0b2f8798D201F4eC3f;
129     address private donor           = 0xeA03Ee7110FAFb324d4a931979eF4578bffB6a00;
130     uint    private etherAmount     = 0.0005 ether;
131     uint    private tokenAmount     = 500;
132     uint    private decimals        = 10**18;
133     
134     mapping (address => mapping (address => bool)) private receivers;
135 
136     event Airdropped(address indexed tokenContract, address receiver, uint tokenReceived);
137 
138     function TokenGiveaway () Managed("1.0.0") public { }
139 
140     /**
141      *
142      */
143     function transferBatch(address[] _addresses) onlyOwner external {
144         uint length = _addresses.length;
145         for (uint i = 0; i < length; i++) {
146             if (isOpenFor(_addresses[i])) {
147                 transferTokens(_addresses[i], tokenAmount * decimals);
148             }            
149         }
150     }
151 
152     /**
153      */
154     function transferTokens(address _receiver, uint _tokenAmount) private {
155         receivers[tokenContract][_receiver] = TokenERC20(tokenContract).transferFrom(donor, _receiver, _tokenAmount);
156     }
157         
158 
159     /**
160      *
161      */
162     function isOpen() public view returns (bool open) {
163         return TokenERC20(tokenContract).allowance(donor, this) >= tokenAmount * decimals;
164     }
165 
166     /**
167      *
168      */
169     function isOpenFor(address _receiver) public view returns (bool open) {
170         return !receivers[tokenContract][_receiver] && isOpen();
171     }
172 
173     /**
174      */
175     function () external payable {
176         require(msg.value >= etherAmount && isOpenFor(msg.sender));
177         transferTokens(msg.sender, tokenAmount * decimals);     
178     }
179 
180     function updateTokenContract(address _tokenContract) external onlyOwner { tokenContract = _tokenContract; }
181 
182     function updateDonor(address _donor) external onlyOwner { donor = _donor; }
183     
184     function updateEtherAmount(uint _etherAmount) external onlyOwner { etherAmount = _etherAmount; }
185     
186     function updateTokenAmount(uint _tokenAmount) external onlyOwner { tokenAmount = _tokenAmount; }
187     
188     function updateDecimals(uint _decimals) external onlyOwner { decimals = _decimals; }
189     
190     function updateEtherAndtokenAmount(uint _etherAmount, uint _tokenAmount) external onlyOwner {
191         etherAmount = _etherAmount;
192         tokenAmount = _tokenAmount;
193     }
194 
195     function updateEtherAndtokenAmount(address _donor, uint _etherAmount, uint _tokenAmount) external onlyOwner {
196         donor = _donor;
197         etherAmount = _etherAmount;
198         tokenAmount = _tokenAmount;
199     }
200 
201     function updateParameters(address _tokenContract, address _donor, uint _etherAmount, uint _tokenAmount, uint _decimals) external onlyOwner {
202         tokenContract = _tokenContract;
203         donor = _donor;
204         etherAmount = _etherAmount;
205         tokenAmount = _tokenAmount;
206         decimals = _decimals;
207     }
208 
209 }