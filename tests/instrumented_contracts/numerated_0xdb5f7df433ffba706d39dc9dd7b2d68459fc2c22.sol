1 pragma solidity ^0.4.19;
2 
3 contract TradeIO {
4     address owner;
5     mapping(bytes8 => string) dateToHash;
6     
7     modifier onlyOwner () {
8         require(owner == msg.sender);
9         _;
10     }
11     
12     function TradeIO () public {
13         owner = msg.sender;
14     }
15     
16     function changeOwner(address _newOwner) public onlyOwner {
17         owner = _newOwner;
18     }
19     
20     function saveHash(bytes8 date, string hash) public onlyOwner {
21         require(bytes(dateToHash[date]).length == 0);
22         dateToHash[date] = hash;
23     }
24     
25     function getHash(bytes8 date) public constant returns (string) {
26         require(bytes(dateToHash[date]).length != 0);
27         return dateToHash[date];
28     }
29 }