1 contract EthereumButton {
2     address private owner;
3     address private lastPresser;
4     uint256 private targetBlock;
5     uint256 private pressCount;
6     bool private started = false;
7 
8     event Pressed(address _presser, uint256 _timestamp);
9     
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     modifier onlyWhenStarted() {
16         require(started == true);
17         _;
18     }
19 
20     modifier onlyWhenPaused() {
21         require(started == false);
22         _;
23     }
24     
25     function EthereumButton() public {
26         owner = msg.sender;
27     }
28     
29     function start() public onlyOwner onlyWhenPaused {
30         started = true;
31         targetBlock = block.number + 240;
32         pressCount = 0;
33         lastPresser = 0x0;
34     }
35 
36     function() public payable {
37         revert();
38     }   
39 
40     function pressButton() public onlyWhenStarted payable {
41         require(msg.value == 10000000000000000 && block.number <= targetBlock);
42 
43         lastPresser = msg.sender;
44         targetBlock = targetBlock + 240;
45         pressCount++;
46 
47         Pressed(msg.sender, now);
48     }
49 
50     function getPressCount() public view returns(uint256) {
51         return pressCount;
52     }
53 
54     function getTargetBlock() public view returns(uint256) {
55         return targetBlock;
56     }
57 
58     function getLastPresser() public view returns(address) {
59         return lastPresser;
60     }
61     
62     function claimPrize() public onlyWhenStarted {
63         require(block.number > targetBlock && (msg.sender == lastPresser || msg.sender == owner));
64 
65         // In case of nobody pressed it, the owner can call this to set started to false
66         if (pressCount == 0) {
67             started = false;
68             return;
69         }
70 
71         uint256 amount = pressCount * 9500000000000000;
72         
73         lastPresser.transfer(amount);
74 
75         started = false;
76     }
77 
78     function depositEther() public payable onlyOwner { } 
79 
80     function kill() public onlyOwner onlyWhenPaused {
81         selfdestruct(owner);
82     }
83 
84     function withdrawBalance() public onlyOwner onlyWhenPaused {
85         owner.transfer(this.balance);
86     }
87 }