1 pragma solidity ^0.4.25 ;
2 
3 interface IERC20Token {                                     
4     function balanceOf(address owner) external returns (uint256);
5     function transfer(address to, uint256 amount) external returns (bool);
6     function decimals() external returns (uint256);
7 }
8 
9 contract LupeMining {
10     
11     using SafeMath for uint ; 
12     using Limit for uint ; 
13     
14     IERC20Token public tokenContract ;
15     address public owner;
16     
17     mapping(bytes32 => bytes32) public solutionForChallenge ; 
18     
19     uint public blockNumber  = 0 ; 
20     
21     uint public LUPX_BLOCKS_PER_EPOCH_TARGET = 5 ;
22     uint public LUPX_BLOCK_TIME = 600 ; 
23     uint public ETHER_BLOCK_TIME = 15 ; 
24     uint public halvingBlockAmount = 25000 ; 
25     
26     uint public ETHER_BLOCKS_PER_EPOCH_TARGET = (LUPX_BLOCK_TIME.div(ETHER_BLOCK_TIME)).mul(LUPX_BLOCKS_PER_EPOCH_TARGET) ;
27     
28     uint public MIN_TARGET = 2 ** 16 ; 
29     uint public MAX_TARGET = 2 ** 252 ; 
30     
31     uint public target  = MAX_TARGET.div(10**4) ; 
32     bytes32 public challenge ; 
33     
34     address public lastRewardedMiner ; 
35     uint public lastRewardAmount ; 
36     uint public lastRewardETHBlock ; 
37     
38     uint public ETHBlockDiffAdjusted  = block.number ; 
39     
40     uint public minedTokensAmount  = 0 ; 
41     
42     uint public blockReward = 200 ; 
43     
44     bool public locked = false ; 
45     
46     event newBlock(address miner, uint reward) ; 
47     
48     constructor(IERC20Token _tokenContract) public {
49         tokenContract = _tokenContract ;
50         owner = msg.sender ; 
51         
52         newBlockChallenge() ; 
53     }
54     
55     function lockContract() public onlyOwner returns (bool success) {
56         locked = true ; 
57         return true ; 
58     }
59     
60     function mine(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
61         require(!locked) ; 
62         require(tokenContract.balanceOf(address(this)) > blockReward) ;
63         
64         bytes32 digest =  keccak256(challenge, msg.sender, nonce); 
65         
66         if (digest != challenge_digest) {
67             revert() ; 
68         }
69         
70         if (uint256(challenge_digest) > target) {
71             revert() ; 
72         }
73         
74 
75         bytes32 solution = solutionForChallenge[challenge];
76         solutionForChallenge[challenge] = digest;
77         if(solution != 0x0) {
78             revert();
79         }
80         
81         minedTokensAmount = minedTokensAmount.add(blockReward) ; 
82         
83         lastRewardedMiner = msg.sender ; 
84         lastRewardAmount = blockReward ; 
85         lastRewardETHBlock = block.number ; 
86         
87         emit newBlock(msg.sender, blockReward) ; 
88         
89         tokenContract.transfer(msg.sender, blockReward * 10 ** tokenContract.decimals()) ; 
90         
91         newBlockChallenge() ; 
92         
93         return true ; 
94     }
95 
96     function newBlockChallenge() internal {
97         blockNumber = blockNumber.add(1) ; 
98         
99         if (blockNumber % LUPX_BLOCKS_PER_EPOCH_TARGET == 0) {
100             adjustDifficulty() ; 
101         }
102         
103         if (blockNumber % halvingBlockAmount == 0) {
104             blockReward = blockReward.div(2) ; 
105         }
106         
107         challenge = blockhash(block.number - 1) ; 
108     }
109     
110     function adjustDifficulty() internal {
111         uint blocksSinceLastBlock = block.number - ETHBlockDiffAdjusted ; 
112           
113         if (blocksSinceLastBlock < ETHER_BLOCKS_PER_EPOCH_TARGET) { 
114             
115             uint excs_percentage = (ETHER_BLOCKS_PER_EPOCH_TARGET.mul(100)).div(blocksSinceLastBlock) ;
116 
117             uint excs_percentage_extra = excs_percentage.sub(100).limitLessThan(1000) ;  
118           
119             target = target.sub(target.div(2000).mul(excs_percentage_extra)) ;      
120         }
121         
122         else {      
123             
124             uint short_percentage = (blocksSinceLastBlock.mul(100)).div(ETHER_BLOCKS_PER_EPOCH_TARGET) ;
125 
126             uint short_percentage_extra = short_percentage.sub(100).limitLessThan(1000) ;
127 
128             target = target.add(target.div(2000).mul(short_percentage_extra)) ;
129         }
130         
131         
132         ETHBlockDiffAdjusted = block.number ; 
133         
134         
135         if(target < MIN_TARGET) {target = MIN_TARGET ;}
136 
137         if(target > MAX_TARGET) {target = MAX_TARGET ;}
138     }
139     
140     function getChallenge() public view returns (bytes32) {
141         return challenge;
142     }
143 
144      function getMiningDifficulty() public view returns (uint) {
145         return MAX_TARGET.div(target);
146     }
147 
148     function getMiningTarget() public view returns (uint) {
149        return target;
150    }
151    
152    function testHASH(uint256 nonce, bytes32 challenge_digest) public view returns (bool success) {
153         bytes32 digest =  keccak256(challenge, msg.sender, nonce); 
154         
155         if (digest != challenge_digest) {
156             revert() ; 
157         }
158         
159         if (uint256(challenge_digest) > target) {
160             revert() ; 
161         }
162         
163         return true ; 
164    }
165    
166     modifier onlyOwner {
167         require(msg.sender == owner);
168         _;
169     }
170 
171     function transferOwnership(address newOwner) public onlyOwner {
172         owner = newOwner;
173     }
174     
175     function destroyOwnership() public onlyOwner {
176         owner = address(0) ; 
177     }
178     
179     function stopMining() public onlyOwner {
180         tokenContract.transfer(msg.sender, tokenContract.balanceOf(address(this))) ;
181         msg.sender.transfer(address(this).balance) ;  
182     }
183 }
184 
185 library SafeMath {
186   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187     if (a == 0) {
188       return 0;
189     }
190     uint256 c = a * b;
191     assert(c / a == b);
192     return c;
193   }
194 
195   function div(uint256 a, uint256 b) internal pure returns (uint256) {
196     uint256 c = a / b;
197     return c;
198   }
199 
200   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201     assert(b <= a);
202     return a - b;
203   }
204 
205   function add(uint256 a, uint256 b) internal pure returns (uint256) {
206     uint256 c = a + b;
207     assert(c >= a);
208     return c;
209   }
210 }
211 
212 library Limit {
213     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
214 
215         if(a > b) {
216             return b;
217         } else {
218             return a;
219         }
220     }
221 }