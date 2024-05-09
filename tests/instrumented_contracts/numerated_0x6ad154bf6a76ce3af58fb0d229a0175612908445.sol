1 contract SafeMath {
2     
3     uint256 constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
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
24 contract ReentrancyHandlingContract{
25 
26     bool locked;
27 
28     modifier noReentrancy() {
29         require(!locked);
30         locked = true;
31         _;
32         locked = false;
33     }
34 }
35 
36 contract Owned {
37     address public owner;
38     address public newOwner;
39 
40     function Owned() {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         assert(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) public onlyOwner {
50         require(_newOwner != owner);
51         newOwner = _newOwner;
52     }
53 
54     function acceptOwnership() public {
55         require(msg.sender == newOwner);
56         OwnerUpdate(owner, newOwner);
57         owner = newOwner;
58         newOwner = 0x0;
59     }
60 
61     event OwnerUpdate(address _prevOwner, address _newOwner);
62 }
63 
64 contract Lockable is Owned {
65 
66     uint256 public lockedUntilBlock;
67 
68     event ContractLocked(uint256 _untilBlock, string _reason);
69 
70     modifier lockAffected {
71         require(block.number > lockedUntilBlock);
72         _;
73     }
74 
75     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
76         lockedUntilBlock = _untilBlock;
77         ContractLocked(_untilBlock, _reason);
78     }
79 
80 
81     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
82         lockedUntilBlock = _untilBlock;
83         ContractLocked(_untilBlock, _reason);
84     }
85 }
86 
87 contract ERC20TokenInterface {
88   function totalSupply() public constant returns (uint256 _totalSupply);
89   function balanceOf(address _owner) public constant returns (uint256 balance);
90   function transfer(address _to, uint256 _value) public returns (bool success);
91   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
92   function approve(address _spender, uint256 _value) public returns (bool success);
93   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
94 
95   event Transfer(address indexed _from, address indexed _to, uint256 _value);
96   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }
98 
99 contract InsurePalTokenInterface {
100     function mint(address _to, uint256 _amount) public;
101 }
102 
103 contract tokenRecipientInterface {
104   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
105 }
106 
107 contract KycContractInterface {
108     function isAddressVerified(address _address) public view returns (bool);
109 }
110 
111 
112 
113 
114 
115 
116 
117 
118 
119 contract KycContract is Owned {
120     
121     mapping (address => bool) verifiedAddresses;
122     
123     function isAddressVerified(address _address) public view returns (bool) {
124         return verifiedAddresses[_address];
125     }
126     
127     function addAddress(address _newAddress) public onlyOwner {
128         require(!verifiedAddresses[_newAddress]);
129         
130         verifiedAddresses[_newAddress] = true;
131     }
132     
133     function removeAddress(address _oldAddress) public onlyOwner {
134         require(verifiedAddresses[_oldAddress]);
135         
136         verifiedAddresses[_oldAddress] = false;
137     }
138     
139     function batchAddAddresses(address[] _addresses) public onlyOwner {
140         for (uint cnt = 0; cnt < _addresses.length; cnt++) {
141             assert(!verifiedAddresses[_addresses[cnt]]);
142             verifiedAddresses[_addresses[cnt]] = true;
143         }
144     }
145     
146     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) public onlyOwner{
147         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
148     }
149     
150     function killContract() public onlyOwner {
151         selfdestruct(owner);
152     }
153 }