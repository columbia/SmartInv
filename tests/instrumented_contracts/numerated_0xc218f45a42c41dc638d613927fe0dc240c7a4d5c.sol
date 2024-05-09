1 pragma solidity 0.4.25;
2 
3 contract PackInterface {
4     
5     function purchaseFor(address user, uint16 packCount, address referrer) public payable;
6     
7     function calculatePrice(uint base, uint16 packCount) public view returns (uint);
8     
9     function basePrice() public returns (uint);
10 }
11 
12 contract MultiPurchaser {
13     
14     function purchaseFor(address pack, address[] memory users, uint16 packCount, address referrer) public payable {
15         
16         uint price = PackInterface(pack).calculatePrice(PackInterface(pack).basePrice(), packCount);
17         
18         for (uint i = 0; i < users.length; i++) {
19             
20             PackInterface(pack).purchaseFor.value(price)(users[i], packCount, referrer);
21         }
22     }
23     
24 }