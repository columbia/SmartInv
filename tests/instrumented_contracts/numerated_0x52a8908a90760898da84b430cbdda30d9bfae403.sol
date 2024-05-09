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
75 
76 contract AccessControl is Pausable {
77     ParentInterface public parent;
78     
79     function setParentAddress(address _address) public whenPaused onlyOwner
80     {
81         ParentInterface candidateContract = ParentInterface(_address);
82 
83         parent = candidateContract;
84     }
85 }
86 
87 // setting a special price
88 contract Discount is AccessControl {
89     uint128[101] public discount;
90     
91     function setPrice(uint8 _tokenId, uint128 _price) external onlyOwner {
92         discount[_tokenId] = _price;
93     }
94 }
95 
96 contract Sales is Discount {
97 
98     constructor(address _address) public {
99         ParentInterface candidateContract = ParentInterface(_address);
100         parent = candidateContract;
101         paused = true;
102     }
103     
104 	// purchasing a parrot
105     function purchaseParrot(uint256 _tokenId) external payable whenNotPaused
106     {
107         uint64 birthTime; uint256 genes; uint64 breedTimeout; uint16 quality; address parrot_owner;
108         (birthTime,  genes, breedTimeout, quality, parrot_owner) = parent.getPet(_tokenId);
109         
110         require(parrot_owner == address(this));
111         
112         if(discount[_tokenId] == 0)
113             require(parent.recommendedPrice(quality) <= msg.value);
114         else
115             require(discount[_tokenId] <= msg.value);
116         
117         parent.transfer(msg.sender, _tokenId);
118     }
119     
120     function gift(uint256 _tokenId, address to) external onlyOwner{
121         parent.transfer(to, _tokenId);
122     }
123 
124     function withdrawBalance(uint256 summ) external onlyCFO {
125         cfoAddress.transfer(summ);
126     }
127 }