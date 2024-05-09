1 pragma solidity ^0.4.0;
2 
3 contract test{
4     struct SeedComponents{
5         uint component1;
6         uint component2;
7         uint component3;
8         uint component4;
9     }
10     
11     address owner;
12     uint private secretSeed;
13     uint private lastReseed;
14     
15     uint public winnerLuckyNumber = 7;
16         
17     mapping (address => bool) participated;
18 
19     event showme(uint luckyNumberOfAddress, uint winnerLuckyNumber, uint n);
20 
21     
22     function showNumber() constant returns (uint winnerLuckyNumber){}
23     
24     function test() {
25         owner = msg.sender;
26         reseed(SeedComponents(12345678, 0x12345678, 0xabbaeddaacdc, 0x22222222));
27     }
28     
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33   
34     modifier onlyHuman() {
35         require(msg.sender == tx.origin);
36         _;
37     }
38     
39     function participate() payable onlyHuman { 
40         require(msg.value == 0.1 ether);
41         
42         // every address can only win once, obviously
43        require(!participated[msg.sender]);
44          showme(luckyNumberOfAddress(msg.sender), winnerLuckyNumber, _myLuckyNumber());
45         if ( luckyNumberOfAddress(msg.sender) == winnerLuckyNumber)
46         {
47             participated[msg.sender] = true;
48             require(msg.sender.call.value(this.balance)());
49         }
50     }
51     
52     function luckyNumberOfAddress(address addr) constant returns(uint n){
53         // 1 in 8 chance
54         n = uint(keccak256(uint(addr), secretSeed)[0]) % 8;
55        
56     }
57     
58     function reseed(SeedComponents components) internal {
59         secretSeed = uint256(keccak256(
60             components.component1,
61             components.component2,
62             components.component3,
63             components.component4
64         ));
65         lastReseed = block.number;
66     }
67     
68     function kill() onlyOwner {
69         suicide(owner);
70     }
71     
72     function forceReseed() onlyOwner{
73         SeedComponents s;
74         s.component1 = uint(msg.sender);
75         s.component2 = uint256(block.blockhash(block.number - 1));
76         s.component3 = block.number * 1337;
77         s.component4 = tx.gasprice * 7;
78         reseed(s);
79     }
80     
81     function () payable {}
82     
83     // DEBUG, DELETE BEFORE DEPLOYMENT!!
84     function _myLuckyNumber() constant returns(uint n){
85         n = luckyNumberOfAddress(msg.sender);
86     }
87 }