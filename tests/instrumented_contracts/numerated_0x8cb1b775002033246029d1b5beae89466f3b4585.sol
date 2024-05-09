1 pragma solidity ^0.4.11;
2 
3 contract SmartDeposit {
4     function SmartDeposit() {
5 
6     }
7 
8     event Received(address from, bytes user_id, uint value);
9 
10     function() payable {
11         if (msg.value > 0 && msg.data.length == 4) {
12             Received(msg.sender, msg.data, msg.value);
13             m_account.transfer(msg.value);
14         } else throw;
15     }
16 
17     address public m_account = 0x0C99a6F86eb73De783Fd5362aA3C9C7Eb7F8Ea16;
18 }