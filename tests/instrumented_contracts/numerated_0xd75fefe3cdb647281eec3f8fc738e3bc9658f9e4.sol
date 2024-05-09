1 pragma solidity ^0.4.11;
2 
3 contract ParityProofOfSMSInterface {
4     function certified(address _who) constant returns (bool);
5 }
6 
7 contract ProofOfReadToken {
8     ParityProofOfSMSInterface public proofOfSms;
9     
10     //maps reader addresses to a map of story num => have claimed readership
11     mapping (address => mapping(uint256 => bool)) public readingRegister;
12     //article hash to key hash
13     mapping (string => bytes32) articleKeyHashRegister; 
14     //story num to article hash
15     mapping (uint256 => string) public publishedRegister; 
16     //set the max number of claimable tokens for each article
17     mapping (string => uint256) remainingTokensForArticle;
18 
19     uint256 public numArticlesPublished;
20     address public publishingOwner;
21     uint256 public minSecondsBetweenPublishing;
22     uint256 public maxTokensPerArticle;
23     uint public timeOfLastPublish;
24     bool public shieldsUp; //require sms verification
25     string ipfsGateway;
26 
27     /* ERC20 fields */
28     string public standard = "Token 0.1";
29     string public name;
30     string public symbol;
31     uint8 public decimals;
32     uint256 public totalSupply;
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35     
36     event Transfer (address indexed from, address indexed to, uint256 value);
37     event Approval (address indexed _owner, address indexed _spender, uint256 _value);
38     event ClaimResult (uint);
39     event PublishResult (uint);
40 
41     /* Initializes contract with initial supply tokens to the creator of the contract */
42     function ProofOfReadToken(uint256 _minSecondsBetweenPublishing,
43                               uint256 _maxTokensPerArticle,
44                               string tokenName, 
45                               uint8 decimalUnits, 
46                               string tokenSymbol) {
47                                   
48         publishingOwner = msg.sender;
49         minSecondsBetweenPublishing = _minSecondsBetweenPublishing; 
50         maxTokensPerArticle = _maxTokensPerArticle;
51         name = tokenName;
52         symbol = tokenSymbol;
53         decimals = decimalUnits;
54         ipfsGateway = "http://ipfs.io/ipfs/";
55         proofOfSms = ParityProofOfSMSInterface(0x9ae98746EB8a0aeEe5fF2b6B15875313a986f103);
56     }
57     
58     /* Publish article */
59     function publish(string articleHash, bytes32 keyHash, uint256 numTokens) {
60         
61         if (msg.sender != publishingOwner) {
62             PublishResult(1);
63             throw;
64         } else if (numTokens > maxTokensPerArticle) {
65             PublishResult(2);
66             throw;
67         } else if (block.timestamp - timeOfLastPublish < minSecondsBetweenPublishing) {
68             PublishResult(3);
69             throw;
70         } else if (articleKeyHashRegister[articleHash] != 0) {
71             PublishResult(4);  //can't republish same article
72             throw;
73         }
74         
75         timeOfLastPublish = block.timestamp;
76         publishedRegister[numArticlesPublished] = articleHash;
77         articleKeyHashRegister[articleHash] = keyHash;
78         numArticlesPublished++;
79         remainingTokensForArticle[articleHash] = numTokens;
80         PublishResult(3);
81     }
82     
83     /*Claim a token for an article */
84     function claimReadership(uint256 articleNum, string key) {
85         
86         if (shieldsUp && !proofOfSms.certified(msg.sender)) {
87             ClaimResult(1); //missing sms certification
88              throw;
89         } else if (readingRegister[msg.sender][articleNum]) {
90             ClaimResult(2); // user alread claimed
91             throw; 
92         } else if (remainingTokensForArticle[publishedRegister[articleNum]] <= 0) {
93             ClaimResult(3); //article out of tokens
94             throw;
95         } else if (keccak256(key) != articleKeyHashRegister[publishedRegister[articleNum]]) {
96             ClaimResult(4); //incorrect key
97             throw; 
98         } else if (balanceOf[msg.sender] + 1 < balanceOf[msg.sender]) {
99             ClaimResult(5); //overflow error
100             throw;
101         } 
102         
103         remainingTokensForArticle[publishedRegister[articleNum]]--;
104         totalSupply++;
105         readingRegister[msg.sender][articleNum] = true;
106         balanceOf[msg.sender] += 1;
107         
108         ClaimResult(0);
109     }
110     
111     /* Check if an address has read a given article */
112     function hasReadership(address toCheck, uint256 articleNum) public returns (bool) {
113         return readingRegister[toCheck][articleNum];
114     }
115     
116     function getRemainingTokenForArticle(string articleHash) public returns (uint256) {
117         return remainingTokensForArticle[articleHash];
118     }
119     
120     /* Send coins */
121     function transfer(address _to, uint256 _value) returns (bool success) {
122         if (balanceOf[msg.sender] < _value) return false;           // Check if the sender has enough
123         if (balanceOf[_to] + _value < balanceOf[_to]) return false; // Check for overflows
124         balanceOf[msg.sender] -= _value;                            // Subtract from the sender
125         balanceOf[_to] += _value;                                   // Add the same to the recipient
126         /* Notify anyone listening that this transfer took place */
127         Transfer(msg.sender, _to, _value);
128         return true;
129     }
130     
131     /* Allow another contract to spend some tokens in your behalf */
132     function approve(address _spender, uint256 _value) returns (bool success) {
133         allowance[msg.sender][_spender] = _value;
134         return true;
135     }
136     
137     /* A contract attempts to get the coins */
138     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
139         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address.
140         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
141         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
142         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
143         balanceOf[_from] -= _value;                           // Subtract from the sender
144         balanceOf[_to] += _value;                             // Add the same to the recipient
145         allowance[_from][msg.sender] -= _value;
146         Transfer(_from, _to, _value);
147         return true;
148     }
149     
150     function updateIpfsGateway(string gateway) {
151         if (msg.sender == publishingOwner)
152             ipfsGateway = gateway;
153     }
154         
155     function setSmsCertificationRequired(bool enable) {
156         if (msg.sender == publishingOwner)
157             shieldsUp = enable;
158     }
159 }