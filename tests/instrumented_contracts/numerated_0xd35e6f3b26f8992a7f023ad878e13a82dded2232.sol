1 pragma solidity 0.4.4;
2 
3 contract PayToSHA256 {
4     mapping(bytes32 => uint256) balances;
5 
6     function lock (bytes32 hash) payable {
7         balances[hash] += msg.value;
8     }
9 
10     function release (string password) {
11         bytes32 hash = sha256(password);
12         uint256 amount = balances[hash];
13         if (amount == 0)
14             throw;
15 
16         balances[hash] = 0;
17         if (!msg.sender.send(amount))
18             throw;
19     }
20 }