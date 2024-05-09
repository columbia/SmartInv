1 // Simple smart contract that allows anyone to send ether from one address to
2 // another in certain branch of the blockchain only.  This contract is supposed
3 // to be used after hard forks to clearly separate "classic" ether from "new"
4 // ether.
5 contract BranchSender {
6   // Is set to true if and only if we are currently in the "right" branch of
7   // the blockchain, i.e. the branch this contract allows sending money in.
8   bool public isRightBranch;
9 
10   // Instantiate the contract.
11   //
12   // @param blockNumber number of block in the "right" blockchain whose hash is
13   //        known
14   // @param blockHash known hash of the given block in the "right" blockchain
15   function BranchSender(uint blockNumber, bytes32 blockHash) {
16     if (msg.value > 0) throw; // We do not accept any money here
17 
18     isRightBranch = (block.number < 256 || blockNumber > block.number - 256) &&
19                     (blockNumber < block.number) &&
20                     (block.blockhash (blockNumber) == blockHash);
21   }
22 
23   // Default function just throw.
24   function () {
25     throw;
26   }
27 
28   // If we are currently in the "right" branch of the blockchain, send money to
29   // the given recipient.  Otherwise, throw.
30   //
31   // @param recipient address to send money to if we are currently in the
32   //                  "right" branch of the blockchain
33   function send (address recipient) {
34     if (!isRightBranch) throw;
35     if (!recipient.send (msg.value)) throw;
36   }
37 }