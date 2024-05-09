1 contract PIPOTFlip {
2   
3   uint256 lastHash;
4   uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
5   
6   // Game fee.
7   uint public fee = 5;
8   uint public multLevel1 = 0.01 ether;
9   uint public multLevel2 = 0.05 ether;
10   uint public multLevel3 = 0.1 ether;
11   
12   // Funds distributor address.
13   address public fundsDistributor;
14   
15   event Win(bool guess, uint amount, address winAddress, bool result);
16   event Lose(bool guess, uint amount, address winAddress, bool result);
17   
18   function PIPOTFlip(address _fund) public {
19      fundsDistributor = _fund;
20   }
21   
22   function () external payable {
23         
24   }
25 
26   function flip(bool _guess) public payable {
27     uint256 blockValue = uint256(block.blockhash(block.number-1));
28     require(msg.value >= multLevel1);
29     
30     if (lastHash == blockValue) {
31       revert();
32     }
33     
34     address player = msg.sender;
35     uint distribute = msg.value * fee / 100;
36     uint loseAmount = msg.value - distribute;
37     uint winAmount = 0;
38     
39     if(msg.value == multLevel1){
40         winAmount = msg.value * 194/100;
41     }
42     
43     if(msg.value >= multLevel2 && msg.value < multLevel3){
44         winAmount = msg.value * 197/100;
45     }
46     
47     if(msg.value >= multLevel3){
48         winAmount = msg.value * 198/100;
49     }
50     
51     fundsDistributor.transfer(distribute);
52     
53     lastHash = blockValue;
54     uint256 coinFlip = blockValue / FACTOR;
55     bool side = coinFlip == 1 ? true : false;
56 
57     if (side == _guess) {
58       player.transfer(winAmount);
59       emit Win(_guess, winAmount, msg.sender, side);
60     }
61     else{
62       fundsDistributor.transfer(loseAmount);  
63       emit Lose(_guess, msg.value, msg.sender, side);
64     }
65   }
66 }