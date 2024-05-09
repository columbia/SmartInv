1 contract Token { 
2     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
3 }
4 
5 // replay protection
6 contract ReplayProtection {
7     bool public isMainChain;
8 
9     function ReplayProtection() {
10         bytes32 blockHash = 0xcf9055c648b3689a2b74e980fc6fa27817622fa9ac0749d60a6489a7fbcfe831;
11         // creates a unique signature with the latest 16 blocks
12         for (uint i = 1; i < 64; i++) {
13             if (blockHash == block.blockhash(block.number - i)) isMainChain = true;
14         }
15     }
16 
17     // Splits the funds into 2 addresses
18     function etherSplit(address recipient, address altChainRecipient) returns(bool) {
19         if (isMainChain && recipient.send(msg.value)) {
20             return true;
21         } else if (!isMainChain && altChainRecipient > 0 && altChainRecipient.send(msg.value)) {
22             return true;
23         }
24         throw; // don't accept value transfer, otherwise it would be trapped.
25     }
26 
27 
28     function tokenSplit(address recipient, address altChainRecipient, address tokenAddress, uint amount) returns (bool) {
29         if (msg.value > 0 ) throw;
30 
31         Token token = Token(tokenAddress);
32 
33         if (isMainChain && token.transferFrom(msg.sender, recipient, amount)) {
34             return true;
35         } else if (!isMainChain && altChainRecipient > 0 && token.transferFrom(msg.sender, altChainRecipient, amount)) {
36             return true;
37         }
38         throw;
39     }
40 
41     function () {
42         throw;
43     }
44 }