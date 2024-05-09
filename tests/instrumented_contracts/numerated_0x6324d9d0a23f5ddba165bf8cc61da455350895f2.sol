1 pragma solidity ^0.4.0;
2 
3 contract AddressLottery{
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
15     uint luckyNumber = 13;
16         
17     mapping (address => bool) participated;
18 
19 
20     function AddressLottery() {
21         owner = msg.sender;
22         reseed(SeedComponents(12345678, 0x12345678, 0xabbaeddaacdc, 0x333333));
23     }
24     
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29   
30     function participate() payable { 
31         require(msg.value == 0.1 ether);
32         
33         // every address can only win once, obviously
34         require(!participated[msg.sender]);
35         
36         if ( luckyNumberOfAddress(msg.sender) == luckyNumber)
37         {
38             participated[msg.sender] = true;
39             require(msg.sender.call.value(this.balance)());
40         }
41     }
42     
43     function luckyNumberOfAddress(address addr) internal returns(uint n){
44         // 1 in 16 chance
45         n = uint(keccak256(uint(addr), secretSeed)[0]) % 16;
46     }
47     
48     function reseed(SeedComponents components) internal{
49         secretSeed = uint256(keccak256(
50             components.component1,
51             components.component2,
52             components.component3,
53             components.component4
54         ));
55         lastReseed = block.number;
56     }
57     
58     function kill() onlyOwner {
59         suicide(owner);
60     }
61     
62     function forceReseed() onlyOwner{
63         SeedComponents s;
64         s.component1 = uint(msg.sender);
65         s.component2 = uint256(block.blockhash(block.number - 1));
66         s.component3 = block.number * 1337;
67         s.component4 = tx.gasprice * 13;
68         reseed(s);
69     }
70     
71     function () payable {}
72 }