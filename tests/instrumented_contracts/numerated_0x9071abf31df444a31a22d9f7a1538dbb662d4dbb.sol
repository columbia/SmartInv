1 contract Owner {
2     address public owner;
3 
4     modifier onlyOwner() {
5         require(msg.sender == owner);
6         _;
7     }
8 
9     function Owner(address _owner) public {
10         owner = _owner;
11     }
12 
13     function changeOwner(address _newOwnerAddr) public onlyOwner {
14         require(_newOwnerAddr != address(0));
15         owner = _newOwnerAddr;
16     }
17 }
18 
19 contract PIPOTFlip is Owner {
20   
21   uint256 lastHash;
22   uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
23   
24   // Game fee.
25   uint public fee = 5;
26   uint public multLevel1 = 0.01 ether;
27   uint public multLevel2 = 0.05 ether;
28   uint public multLevel3 = 0.1 ether;
29   
30   // Funds distributor address.
31   address public fundsDistributor;
32   
33   event Win(bool guess, uint amount, address winAddress, bool result);
34   event Lose(bool guess, uint amount, address winAddress, bool result);
35   
36   /**
37     * @dev Check sender address and compare it to an owner.
38     */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43     
44   function PIPOTFlip(address _fund) public Owner(msg.sender) {
45      fundsDistributor = _fund;
46   }
47   
48   function () external payable {
49         
50   }
51   
52   function claimEther() public onlyOwner() {
53       uint256 balance = address(this).balance;
54       fundsDistributor.transfer(balance);
55   }
56 
57   function flip(bool _guess) public payable {
58     uint256 blockValue = uint256(block.blockhash(block.number-1));
59     require(msg.value >= multLevel1);
60     
61     if (lastHash == blockValue) {
62       revert();
63     }
64     
65     address player = msg.sender;
66     uint distribute = msg.value * fee / 100;
67     uint loseAmount = msg.value - distribute;
68     uint winAmount = 0;
69     
70     if(msg.value == multLevel1){
71         winAmount = msg.value * 194/100;
72     }
73     
74     if(msg.value >= multLevel2 && msg.value < multLevel3){
75         winAmount = msg.value * 197/100;
76     }
77     
78     if(msg.value >= multLevel3){
79         winAmount = msg.value * 198/100;
80     }
81     
82     fundsDistributor.transfer(distribute);
83     
84     lastHash = blockValue;
85     uint256 coinFlip = blockValue / FACTOR;
86     bool side = coinFlip == 1 ? true : false;
87 
88     if (side == _guess) {
89       player.transfer(winAmount);
90       emit Win(_guess, winAmount, msg.sender, side);
91     }
92     else{
93       fundsDistributor.transfer(loseAmount);  
94       emit Lose(_guess, msg.value, msg.sender, side);
95     }
96   }
97 }