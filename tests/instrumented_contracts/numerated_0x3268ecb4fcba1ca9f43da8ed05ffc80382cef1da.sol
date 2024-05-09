1 pragma solidity ^0.4.0;
2 
3 contract Ownable {
4   address owner;
5   function Ownable() {
6     owner = msg.sender;
7   }
8 
9   modifier onlyOwner() {
10     require(msg.sender == owner);
11     _;
12   }
13 }
14 
15 contract AddressLottery is Ownable{
16     struct SeedComponents{
17         address addr;
18         uint additionalSeed1;
19         uint additionalSeed2;
20         uint additionalSeed3;
21     }
22     
23     uint luckyNumber = 13;
24     uint private secretSeed;
25     mapping (address => bool) participated;
26 
27 
28     function AddressLottery() payable {
29         reseed(SeedComponents(msg.sender, 0x12345678, 0x123456789, uint256(block.blockhash(block.number - 1))));
30     }
31     
32     function participate() payable { 
33         require(msg.value == 0.1 ether);
34         
35         // every address can only win once, obviously
36         require(!participated[msg.sender]);
37         
38         if ( luckyNumberOfAddress(msg.sender) == luckyNumber)
39         {
40             participated[msg.sender] = true;
41             require(msg.sender.call.value(this.balance)());
42         }
43     }
44     
45     function luckyNumberOfAddress(address addr) internal returns(uint n){
46         // 1 in 16 chance
47         n = uint(keccak256(addr, secretSeed)[0]) % 16;
48     }
49     
50     function reseed(SeedComponents components) internal{
51         secretSeed = uint256(keccak256(components.addr, components.additionalSeed1, components.additionalSeed2, components.additionalSeed3));
52     }
53     
54     function kill() onlyOwner {
55         suicide(owner);
56     }
57     
58     function forceReseed() onlyOwner{
59         SeedComponents s;
60         s.addr = msg.sender;
61         s.additionalSeed1 = tx.gasprice * 13;
62         s.additionalSeed2 = block.number * 7;
63         s.additionalSeed3 = uint256(block.blockhash(block.number - 1));
64         reseed(s);
65     }
66     
67     function () payable {}
68 }