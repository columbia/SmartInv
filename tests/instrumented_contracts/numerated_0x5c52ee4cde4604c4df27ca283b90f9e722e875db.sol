1 pragma solidity ^0.5.10;
2 
3 /* MintHelper for BitcoinSoV (BSOV)
4  * Based off https://github.com/0xbitcoin/mint-helper
5  * 1% Burn fee comes from mining pool's fee, allowing miner payout contract to receive its full share.
6  * https://www.btcsov.com
7  */
8 
9 library SafeMath {
10     function add(uint a, uint b) internal pure returns (uint c) {
11         c = a + b;
12         require(c >= a);
13     }
14 
15     function sub(uint a, uint b) internal pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19 
20     function mul(uint a, uint b) internal pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24 
25     function div(uint a, uint b) internal pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 contract Ownable {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor () internal {
50         _owner = msg.sender;
51         emit OwnershipTransferred(address(0), _owner);
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(isOwner(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Returns true if the caller is the current owner.
71      */
72     function isOwner() public view returns (bool) {
73         return msg.sender == _owner;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * > Note: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public onlyOwner {
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      */
99     function _transferOwnership(address newOwner) internal {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         emit OwnershipTransferred(_owner, newOwner);
102         _owner = newOwner;
103     }
104 }
105 
106 
107 contract ERC20Interface {
108     function totalSupply() public view returns (uint);
109     function balanceOf(address tokenOwner) public view returns (uint balance);
110     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
111     function transfer(address to, uint tokens) public returns (bool success);
112     function approve(address spender, uint tokens) public returns (bool success);
113     function transferFrom(address from, address to, uint tokens) public returns (bool success);
114 
115     event Transfer(address indexed from, address indexed to, uint tokens);
116     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
117 }
118 
119 contract ERC918Interface {
120   function totalSupply() public view returns (uint);
121   function getMiningDifficulty() public view returns (uint);
122   function getMiningTarget() public view returns (uint);
123   function getMiningReward() public view returns (uint);
124   function balanceOf(address tokenOwner) public view returns (uint balance);
125 
126   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
127 
128   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
129 }
130 
131 /*
132 The owner (or anyone) will deposit tokens in here
133 The owner calls the multisend method to send out payments
134 */
135 contract MintHelper is Ownable {
136    using SafeMath for uint;
137 
138     string public name;
139     address public mintableToken;
140     mapping(bytes32 => bool) successfulPayments;
141 
142     constructor(address mToken, string memory mName)
143     public
144     {
145       mintableToken = mToken;
146       name = mName;
147     }
148 
149     function setMintableToken(address mToken)
150     public onlyOwner
151     returns (bool)
152     {
153       mintableToken = mToken;
154       return true;
155     }
156 
157     function paymentSuccessful(bytes32 paymentId) public view returns (bool){
158         return (successfulPayments[paymentId] == true);
159     }
160     
161     function proxyMint(uint256 nonce, bytes32 challenge_digest )
162     public
163     returns (bool)
164     {
165       require(ERC918Interface(mintableToken).mint(nonce, challenge_digest), "Could not mint token");
166       return true;
167     }
168 
169     //withdraw any eth inside
170     function withdraw()
171     public onlyOwner
172     {
173         msg.sender.transfer(address(this).balance);
174     }
175 
176     //send tokens out
177     function send(address _tokenAddr, address dest, uint value)
178     public onlyOwner
179     returns (bool)
180     {
181      return ERC20Interface(_tokenAddr).transfer(dest, value);
182     }
183 
184     //batch send tokens
185     function multisend(address _tokenAddr, bytes32 paymentId, address[] memory dests, uint256[] memory values)
186     public onlyOwner
187     returns (uint256)
188     {
189         require(dests.length > 0, "Must have more than 1 destination address");
190         require(values.length >= dests.length, "Address to Value array size mismatch");
191         require(successfulPayments[paymentId] != true, "Payment ID already exists and was successful");
192 
193         uint256 i = 0;
194         while (i < dests.length) {
195            require(ERC20Interface(_tokenAddr).transfer(dests[i], values[i]));
196            i += 1;
197         }
198 
199         successfulPayments[paymentId] = true;
200         return (i);
201     }
202 }