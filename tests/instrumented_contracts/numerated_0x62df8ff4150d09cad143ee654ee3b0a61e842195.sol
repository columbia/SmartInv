1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-11
3 */
4 
5 pragma solidity ^0.5.10;
6 
7 /*
8  * MintHelper and MultiSend for BSOV Mining Pool
9  * BitcoinSoV (BSOV) Mineable & Deflationary
10  *
11  * https://www.btcsov.com
12  * https://bsov-pool.hashtables.net
13  *
14  * Based off https://github.com/0xbitcoin/mint-helper
15  */
16 
17 
18 contract Ownable {
19     address private _owner;
20     address private _payoutWallet;  // Added to prevent payouts interfering with minting requests. 
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     constructor () internal {
25         _owner = msg.sender;
26         _payoutWallet = msg.sender;
27 
28         emit OwnershipTransferred(address(0), _owner);
29     }
30 
31     function owner() public view returns (address) {
32         return _owner;
33     }
34     
35     function payoutWallet() public view returns (address) {
36         return _payoutWallet;
37     }
38 
39     modifier onlyOwner() {
40         require(msg.sender == _owner, "Ownable: caller is not the owner, minter, or payer.");
41         _;
42     }
43     
44     modifier onlyPayoutWallet() {
45         require(msg.sender == _owner || msg.sender == _payoutWallet, "Ownable: caller is not the owner or payer.");
46         _;
47     }
48 
49     function renounceOwnership() public onlyOwner {
50         emit OwnershipTransferred(_owner, address(0));
51         _owner = address(0);
52     }
53 
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57     
58     function setPayoutWallet(address newAddress) public onlyOwner {
59         _payoutWallet = newAddress;
60     }
61     
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 contract ERC20Interface {
70     function totalSupply() public view returns (uint);
71     function balanceOf(address tokenOwner) public view returns (uint balance);
72     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
73     function transfer(address to, uint tokens) public returns (bool success);
74     function approve(address spender, uint tokens) public returns (bool success);
75     function transferFrom(address from, address to, uint tokens) public returns (bool success);
76 
77     event Transfer(address indexed from, address indexed to, uint tokens);
78     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
79 }
80 
81 contract ERC918Interface {
82   function totalSupply() public view returns (uint);
83   function getMiningDifficulty() public view returns (uint);
84   function getMiningTarget() public view returns (uint);
85   function getMiningReward() public view returns (uint);
86   function balanceOf(address tokenOwner) public view returns (uint balance);
87 
88   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
89 
90   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
91 }
92 
93 /*
94 The mintingWallet will proxy mint requests to be credited to the contract address.
95 The payoutWallet will call the multisend method to send out payments.
96 */
97 
98 contract PoolHelper is Ownable {
99     string public name;
100     address public mintableToken;
101     mapping(bytes32 => bool) successfulPayments;
102 
103     event Payment(bytes32 _paymentId);
104     
105     constructor(address mToken, string memory mName)
106     public
107     {
108       mintableToken = mToken;
109       name = mName;
110     }
111 
112     function setMintableToken(address mToken)
113     public onlyOwner
114     returns (bool)
115     {
116       mintableToken = mToken;
117       return true;
118     }
119 
120     function paymentSuccessful(bytes32 paymentId) public view returns (bool){
121         return (successfulPayments[paymentId] == true);
122     }
123     
124     function proxyMint(uint256 nonce, bytes32 challenge_digest )
125     public
126     returns (bool)
127     {
128       require(ERC918Interface(mintableToken).mint(nonce, challenge_digest), "Could not mint token");
129       return true;
130     }
131 
132     //withdraw any eth inside
133     function withdraw()
134     public onlyOwner
135     {
136         msg.sender.transfer(address(this).balance);
137     }
138     
139     //send tokens out
140     function send(address _tokenAddr, bytes32 paymentId, address dest, uint value)
141     public onlyPayoutWallet
142     returns (bool)
143     {
144         require(successfulPayments[paymentId] != true, "Payment ID already exists and was successful");
145         successfulPayments[paymentId] = true;
146         emit Payment(paymentId);
147         return ERC20Interface(_tokenAddr).transfer(dest, value);
148     }
149 
150     //batch send tokens
151     function multisend(address _tokenAddr, bytes32 paymentId, address[] memory dests, uint256[] memory values)
152     public onlyPayoutWallet
153     returns (uint256)
154     {
155         require(dests.length > 0, "Must have more than 1 destination address");
156         require(values.length >= dests.length, "Address to Value array size mismatch");
157         require(successfulPayments[paymentId] != true, "Payment ID already exists and was successful");
158 
159         uint256 i = 0;
160         while (i < dests.length) {
161            require(ERC20Interface(_tokenAddr).transfer(dests[i], values[i]));
162            i += 1;
163         }
164 
165         successfulPayments[paymentId] = true;
166         emit Payment(paymentId);
167         return (i);
168     }
169 }