1 pragma solidity ^0.4.11;
2 
3 contract Burner {
4     uint256 public totalBurned;
5     
6     function Purge() public {
7         // the caller of purge action receives 0.01% out of the
8         // current balance.
9         msg.sender.transfer(this.balance / 1000);
10         assembly {
11             mstore(0, 0x30ff)
12             // transfer all funds to a new contract that will selfdestruct
13             // and destroy all ether in the process.
14             create(balance(address), 30, 2)
15             pop
16         }
17     }
18     
19     function Burn() payable {
20         totalBurned += msg.value;
21     }
22 }