1 pragma solidity ^0.4.20;
2 
3 contract owned {
4     address public owner;
5     address public tokenContract;
6     constructor() public{
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     modifier onlyOwnerAndtokenContract {
16         require(msg.sender == owner || msg.sender == tokenContract);
17         _;
18     }
19 
20 
21     function transferOwnership(address newOwner) onlyOwner public {
22         if (newOwner != address(0)) {
23             owner = newOwner;
24         }
25     }
26     
27     function transfertokenContract(address newOwner) onlyOwner public {
28         if (newOwner != address(0)) {
29             tokenContract = newOwner;
30         }
31     }
32 }
33 
34 contract DataContract is owned {
35     struct Good {
36         bytes32 preset;
37         uint price;
38         uint decision;
39         uint time;
40     }
41 
42     mapping (bytes32 => Good) public goods;
43 
44     function setGood(bytes32 _preset, uint _price,uint _decision) onlyOwnerAndtokenContract external {
45         goods[_preset] = Good({preset: _preset, price: _price, decision:_decision, time: now});
46     }
47 
48     function getGoodPreset(bytes32 _preset) view public returns (bytes32) {
49         return goods[_preset].preset;
50     }
51     function getGoodDecision(bytes32 _preset) view public returns (uint) {
52         return goods[_preset].decision;
53     }
54     function getGoodPrice(bytes32 _preset) view public returns (uint) {
55         return goods[_preset].price;
56     }
57 }
58 
59 
60 contract Token is owned {
61 
62     DataContract DC;
63 
64     constructor(address _dataContractAddr) public{
65         DC = DataContract(_dataContractAddr);
66     }
67 
68     event Decision(uint decision,bytes32 preset);
69 
70     function postGood(bytes32 _preset, uint _price) onlyOwner public {
71         require(DC.getGoodPreset(_preset) == "");
72         uint _decision = uint(keccak256(keccak256(blockhash(block.number),_preset),now))%(_price);
73         DC.setGood(_preset, _price, _decision);
74         Decision(_decision, _preset);
75     }
76 }