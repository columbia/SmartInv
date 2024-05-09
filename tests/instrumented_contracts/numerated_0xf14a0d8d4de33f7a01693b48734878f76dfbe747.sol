1 pragma solidity >=0.4.0 <0.6.0;
2 
3 contract Coin {
4     function getOwner(uint index) public view returns (address, uint256);
5     function getOwnerCount() public view returns (uint);
6 }
7 
8 contract Caller {
9     event console(address addr, uint256 amount);
10     function f() public {
11         Coin c = Coin(0x003FfEFeFBC4a6F34a62A3cA7b7937a880065BCB);
12         for (uint256 i = 0; i < c.getOwnerCount(); i++) {
13             address addr;
14             uint256 amount;
15                 (addr, amount)  = c.getOwner(i);
16                  emit console(addr, amount);
17         }
18     }
19 }