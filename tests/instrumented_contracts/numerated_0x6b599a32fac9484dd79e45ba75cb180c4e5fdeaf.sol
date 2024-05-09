1 pragma solidity ^0.4.11;
2 
3 contract Deposit {
4     /* Constructor */
5     function Deposit() {
6 
7     }
8 
9     event Received(address from, address to, uint value);
10 
11     function() payable {
12         if (msg.value > 0) {
13             Received(msg.sender, this, msg.value);
14             m_account.transfer(msg.value);
15         }
16     }
17 
18     address public m_account = 0x0C99a6F86eb73De783Fd5362aA3C9C7Eb7F8Ea16;
19 }