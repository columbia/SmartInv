1 pragma solidity ^0.5.10;
2 
3 /*
4  * MintHelper and MultiSend for BSOV Mining Pool
5  * BitcoinSoV (BSOV) Mineable & Deflationary
6  *
7  * https://www.btcsov.com
8  * https://bsov-pool.hashtables.net
9  *
10  * Based off https://github.com/0xbitcoin/mint-helper
11  */
12 
13 
14 contract Ownable {
15     address private _owner;
16     address private _payoutWallet;  // Added to prevent payouts interfering with minting requests. 
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor () internal {
21         _owner = msg.sender;
22         _payoutWallet = msg.sender;
23 
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     function owner() public view returns (address) {
28         return _owner;
29     }
30     
31     function payoutWallet() public view returns (address) {
32         return _payoutWallet;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == _owner, "Ownable: caller is not the owner, minter, or payer.");
37         _;
38     }
39     
40     modifier onlyPayoutWallet() {
41         require(msg.sender == _owner || msg.sender == _payoutWallet, "Ownable: caller is not the owner or payer.");
42         _;
43     }
44 
45     function renounceOwnership() public onlyOwner {
46         emit OwnershipTransferred(_owner, address(0));
47         _owner = address(0);
48     }
49 
50     function transferOwnership(address newOwner) public onlyOwner {
51         _transferOwnership(newOwner);
52     }
53     
54     function setPayoutWallet(address newAddress) public onlyOwner {
55         _payoutWallet = newAddress;
56     }
57     
58     function _transferOwnership(address newOwner) internal {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         emit OwnershipTransferred(_owner, newOwner);
61         _owner = newOwner;
62     }
63 }
64 
65 contract ERC20Interface {
66     function totalSupply() public view returns (uint);
67     function balanceOf(address tokenOwner) public view returns (uint balance);
68     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
69     function transfer(address to, uint tokens) public returns (bool success);
70     function approve(address spender, uint tokens) public returns (bool success);
71     function transferFrom(address from, address to, uint tokens) public returns (bool success);
72 
73     event Transfer(address indexed from, address indexed to, uint tokens);
74     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
75 }
76 
77 contract ERC918Interface {
78   function totalSupply() public view returns (uint);
79   function getMiningDifficulty() public view returns (uint);
80   function getMiningTarget() public view returns (uint);
81   function getMiningReward() public view returns (uint);
82   function balanceOf(address tokenOwner) public view returns (uint balance);
83 
84   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
85 
86   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
87 }
88 
89 /*
90 The mintingWallet will proxy mint requests to be credited to the contract address.
91 The payoutWallet will call the multisend method to send out payments.
92 */
93 
94 contract PoolHelper is Ownable {
95     string public name;
96     address public mintableToken;
97     mapping(bytes32 => bool) successfulPayments;
98 
99     event Payment(bytes32 _paymentId);
100     
101     constructor(address mToken, string memory mName)
102     public
103     {
104       mintableToken = mToken;
105       name = mName;
106     }
107 
108     function setMintableToken(address mToken)
109     public onlyOwner
110     returns (bool)
111     {
112       mintableToken = mToken;
113       return true;
114     }
115 
116     function paymentSuccessful(bytes32 paymentId) public view returns (bool){
117         return (successfulPayments[paymentId] == true);
118     }
119     
120     function proxyMint(uint256 nonce, bytes32 challenge_digest )
121     public
122     returns (bool)
123     {
124       require(ERC918Interface(mintableToken).mint(nonce, challenge_digest), "Could not mint token");
125       return true;
126     }
127 
128     //withdraw any eth inside
129     function withdraw()
130     public onlyOwner
131     {
132         msg.sender.transfer(address(this).balance);
133     }
134     
135     //send tokens out
136     function send(address _tokenAddr, bytes32 paymentId, address dest, uint value)
137     public onlyPayoutWallet
138     returns (bool)
139     {
140         require(successfulPayments[paymentId] != true, "Payment ID already exists and was successful");
141         successfulPayments[paymentId] = true;
142         emit Payment(paymentId);
143         return ERC20Interface(_tokenAddr).transfer(dest, value);
144     }
145 
146     //batch send tokens
147     function multisend(address _tokenAddr, bytes32 paymentId, address[] memory dests, uint256[] memory values)
148     public onlyPayoutWallet
149     returns (uint256)
150     {
151         require(dests.length > 0, "Must have more than 1 destination address");
152         require(values.length >= dests.length, "Address to Value array size mismatch");
153         require(successfulPayments[paymentId] != true, "Payment ID already exists and was successful");
154 
155         uint256 i = 0;
156         while (i < dests.length) {
157            require(ERC20Interface(_tokenAddr).transfer(dests[i], values[i]));
158            i += 1;
159         }
160 
161         successfulPayments[paymentId] = true;
162         emit Payment(paymentId);
163         return (i);
164     }
165 }