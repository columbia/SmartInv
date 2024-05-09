1 pragma solidity ^0.4.24;
2 
3 library CheckOverflows {
4     function add(uint256 n1, uint256 n2) internal pure returns(uint256 n3) {
5         n3 = n1 + n2;
6         require(n3 >= n1);
7         return n3;
8     }
9 
10     function sub(uint256 n1, uint256 n2) internal pure returns(uint256) {
11         require(n2 <= n1);
12         return n1 - n2;
13     }
14 
15     function mul(uint256 n1, uint256 n2) internal pure returns(uint256 n3) {
16         if (n1 == 0 || n2 == 0) {
17             return 0;
18         }
19 
20         n3 = n1 * n2;
21         require(n3 / n1 == n2);
22         return n3;
23     }
24 
25     function div(uint256 n1, uint256 n2) internal pure returns(uint256) {
26         return n1 / n2;
27     }
28 }
29 
30 // PolynomialBonding curve
31 // Each meme is independent on its own on the eth blockchain
32 contract Meme {
33     string public ipfsHash;
34     address public creator; // aka owner
35     uint256 exponent;
36     uint256 PRECISION;
37     uint256 public totalSupply;
38     string public name;
39     uint256 public decimals;
40 
41     // amount of wei the smart contract holds
42     uint256 public poolBalance;
43 
44     using CheckOverflows for uint256;
45 
46     constructor(string _ipfsHash, address _creator, string _name, uint256 _decimals, uint256 _exponent, uint256 _precision) public {
47         ipfsHash = _ipfsHash;
48         creator = _creator;
49         name = _name;
50         decimals = _decimals;        // 18
51         exponent = _exponent;        // 1
52         PRECISION = _precision;      // experimenting with: 10 billion > 10000000000
53 
54         // to reward creators automatically give tokens 100 * 1000
55         totalSupply = 100000;
56         tokenBalances[msg.sender] = 100000;
57     }
58 
59     // tokens owned by each address
60     mapping(address => uint256) public tokenBalances;
61 
62     // Calculate the integral from 0 to t (number to integrate to)
63     // https://github.com/CryptoAgainstHumanity/crypto-against-humanity/blob/master/ethereum/contracts/WhiteCard.sol#L249
64     function curveIntegral(uint256 _t) internal returns(uint256) {
65         uint256 nexp = exponent.add(1);
66         // calculate integral t^exponent
67         return PRECISION.div(nexp).mul(_t ** nexp).div(PRECISION);
68     }
69 
70     // minting new tokens > aka voting
71     function mint(uint256 _numTokens) public payable {
72         uint256 priceForTokens = getMintingPrice(_numTokens);
73         require(msg.value >= priceForTokens, "Not enough value for total price of tokens");
74 
75         totalSupply = totalSupply.add(_numTokens);
76         tokenBalances[msg.sender] = tokenBalances[msg.sender].add(_numTokens);
77         poolBalance = poolBalance.add(priceForTokens);
78 
79         // send back the change
80         if (msg.value > priceForTokens) {
81             msg.sender.transfer(msg.value.sub(priceForTokens));
82         }
83     }
84 
85     function getMintingPrice(uint256 _numTokens) public view returns(uint256) {
86         return curveIntegral(totalSupply.add(_numTokens)).sub(poolBalance);
87     }
88 
89     // burning tokens >> eth to return
90     function burn(uint256 _numTokens) public {
91         require(tokenBalances[msg.sender] >= _numTokens, "Not enough owned tokens to burn");
92 
93         uint256 ethToReturn = getBurningReward(_numTokens);
94 
95         totalSupply = totalSupply.sub(_numTokens);
96         poolBalance = poolBalance.sub(ethToReturn);
97 
98         // 3% fee go to site creators, the rest to former tokens owner
99         uint256 fee = ethToReturn.div(100).mul(3);
100 
101         address(0x45405DAa47EFf12Bc225ddcAC932Ce5ef965B39b).transfer(fee);
102         msg.sender.transfer(ethToReturn.sub(fee));
103     }
104 
105     function getBurningReward(uint256 _numTokens) public view returns(uint256) {
106         return poolBalance.sub(curveIntegral(totalSupply.sub(_numTokens)));
107     }
108 
109     function kill() public {
110         // I give myself the ability to kill any contracts, though will only do so with duplicates aka cheaters
111         require(msg.sender == address(0xE76197fAa1C8c4973087d9d79064d2bb6F940946));
112         selfdestruct(this);
113     }
114 }
115 
116 // Factory contract: keeps track of meme for only leaderboard and view purposes
117 contract MemeRecorder {
118     address[] public memeContracts;
119 
120     constructor() public {}
121 
122     function addMeme(string _ipfsHash, string _name) public {
123         Meme newMeme;
124         newMeme = new Meme(_ipfsHash, msg.sender, _name, 18, 1, 10000000000);
125         memeContracts.push(newMeme);
126     }
127 
128     function getMemes() public view returns(address[]) {
129         return memeContracts;
130     }
131 }