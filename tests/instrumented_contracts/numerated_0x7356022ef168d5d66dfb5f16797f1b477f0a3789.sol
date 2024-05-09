1 pragma solidity ^0.4.23;
2 
3 // Ownable contract with CFO
4 contract Ownable {
5     address public owner;
6     address public cfoAddress;
7 
8     constructor() public{
9         owner = msg.sender;
10         cfoAddress = msg.sender;
11     }
12 
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17     
18     modifier onlyCFO() {
19         require(msg.sender == cfoAddress);
20         _;
21     }
22 
23     function transferOwnership(address newOwner) external onlyOwner {
24         if (newOwner != address(0)) {
25             owner = newOwner;
26         }
27     }
28     
29     function setCFO(address newCFO) external onlyOwner {
30         require(newCFO != address(0));
31 
32         cfoAddress = newCFO;
33     }
34 }
35 
36 // Pausable contract which allows children to implement an emergency stop mechanism.
37 contract Pausable is Ownable {
38     event Pause();
39     event Unpause();
40 
41     bool public paused = false;
42 
43     // Modifier to make a function callable only when the contract is not paused.
44     modifier whenNotPaused() {
45         require(!paused);
46         _;
47     }
48 
49     // Modifier to make a function callable only when the contract is paused.
50     modifier whenPaused() {
51         require(paused);
52         _;
53     }
54 
55 
56     // called by the owner to pause, triggers stopped state
57     function pause() onlyOwner whenNotPaused public {
58         paused = true;
59         emit Pause();
60     }
61 
62     // called by the owner to unpause, returns to normal state
63     function unpause() onlyOwner whenPaused public {
64         paused = false;
65         emit Unpause();
66     }
67 }
68 
69 // interface for presale contract
70 contract ParentInterface {
71     function transfer(address _to, uint256 _tokenId) external;
72     function recommendedPrice(uint16 quality) public pure returns(uint256 price);
73     function getPet(uint256 _id) external view returns (uint64 birthTime, uint256 genes,uint64 breedTimeout,uint16 quality,address owner);
74 }
75 contract JackpotInterface {
76     function addPlayer(address player) external;
77     function finished() public returns (bool);
78 }
79 
80 contract AccessControl is Pausable {
81     ParentInterface public parent;
82     JackpotInterface public jackpot;
83     
84     function setParentAddress(address _address) public whenPaused onlyOwner
85     {
86         parent = ParentInterface(_address);
87     }
88     
89     function setJackpotAddress(address _address) public whenPaused onlyOwner
90     {
91         jackpot = JackpotInterface(_address);
92     }
93 }
94 
95 // setting a special price
96 contract Discount is AccessControl {
97     uint128[101] public discount;
98     
99     function setPrice(uint8 _tokenId, uint128 _price) external onlyOwner {
100         discount[_tokenId] = _price;
101     }
102 }
103 
104 contract StoreLimit is AccessControl {
105 	uint8 public saleLimit = 10;
106 	
107 	function setSaleLimit(uint8 _limit) external onlyOwner {
108 		saleLimit = _limit;
109 	}
110 }
111 
112 contract Store is Discount, StoreLimit {
113 
114     constructor(address _presaleAddr) public {
115         parent = ParentInterface(_presaleAddr);
116         paused = true;
117     }
118     
119 	// purchasing a parrot
120     function purchaseParrot(uint256 _tokenId) external payable whenNotPaused
121     {
122 		require(_tokenId <= saleLimit);
123 		
124         uint64 birthTime; uint256 genes; uint64 breedTimeout; uint16 quality; address parrot_owner;
125         (birthTime,  genes, breedTimeout, quality, parrot_owner) = parent.getPet(_tokenId);
126         
127         require(parrot_owner == address(this));
128         
129         if(discount[_tokenId] == 0)
130             require(parent.recommendedPrice(quality) <= msg.value);
131         else
132             require(discount[_tokenId] <= msg.value);
133         
134         parent.transfer(msg.sender, _tokenId);
135         
136         if(!jackpot.finished()) {
137             jackpot.addPlayer(msg.sender);
138             address(jackpot).transfer(msg.value / 2);
139         }
140     }
141     
142     function unpause() public onlyOwner whenPaused {
143 		require(address(jackpot) != address(0));
144 
145         super.unpause();
146     }
147     
148     function gift(uint256 _tokenId, address to) external onlyOwner{
149         parent.transfer(to, _tokenId);
150     }
151 
152     function withdrawBalance(uint256 summ) external onlyCFO {
153         cfoAddress.transfer(summ);
154     }
155 }