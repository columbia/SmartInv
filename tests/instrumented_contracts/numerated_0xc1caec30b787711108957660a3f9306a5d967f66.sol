1 // Wallet contract that operates only in "right" branch.
2 contract BranchWallet {
3   // Owner of the wallet
4   address public owner;
5     
6   // Is set to true if and only if we are currently in the "right" branch of
7   // the blockchain, i.e. the branch this wallet is operating in.
8   bool public isRightBranch;
9 
10   // Instantiate the contract.
11   //
12   // @param owner owner of the contract
13   // @isRightBranch whether we are currently in the "right" branch
14   function BranchWallet (address _owner, bool _isRightBranch) {
15     owner = _owner;
16     isRightBranch = _isRightBranch;
17   }
18 
19   // Only accept money in "right" branch.
20   function () {
21     if (!isRightBranch) throw;
22   }
23 
24   // Execute a transaction using money from this wallet.
25   //
26   // @param to transaction destination
27   // @param value transaction value
28   // @param data transaction data
29   function send (address _to, uint _value) {
30     if (!isRightBranch) throw;
31     if (msg.sender != owner) throw;
32     if (!_to.send (_value)) throw;
33   }
34 
35   // Execute a transaction using money from this wallet.
36   //
37   // @param to transaction destination
38   // @param value transaction value
39   // @param data transaction data
40   function execute (address _to, uint _value, bytes _data) {
41     if (!isRightBranch) throw;
42     if (msg.sender != owner) throw;
43     if (!_to.call.value (_value)(_data)) throw;
44   }
45 }
46 
47 // Simple smart contract that allows anyone to tell where we are currently in the
48 // "right" branch of blockchain.
49 contract BranchSender {
50   // Is set to true if and only if we are currently in the "right" branch of
51   // the blockchain.
52   bool public isRightBranch;
53 }