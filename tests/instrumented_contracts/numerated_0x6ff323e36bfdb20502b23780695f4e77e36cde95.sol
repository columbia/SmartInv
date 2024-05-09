1 // Single-owner wallet that keeps ETC and ETH separately and helps preventing
2 // replaying both, incoming and outgoing transactions.
3 //
4 // Once instantiated, the contract sets up three addressed:
5 // 1. Address to be used to send and receive ETC.  This address will reject all
6 //    incoming ETH transfers, so its ETH balance will always be zero;
7 // 2. Address to be used to send and receive ETH.  This address will reject all
8 //    incoming ETC transfers, so its ETC balance will always be zero;
9 // 3. Address to be used to receive payments in both flavors of ether or even
10 //    unsplit replayable ETC+ETH payments.  Ether coming to this address will
11 //    be automatically classified and distributed among address 1 and address 2.
12 contract TriWallet {
13   // Is set to true in the forked branch and to false in classic branch.
14   bool public thisIsFork;
15 
16   // Address of ETC subwallet.
17   address public etcWallet;
18 
19   // Address of ETH subwallet.
20   address public ethWallet;
21 
22   // Log address of ETC subwallet
23   event ETCWalletCreated(address etcWalletAddress);
24 
25   // Log address of ETH subwallet
26   event ETHWalletCreated(address ethWalletAddress);
27 
28   // Instantiate the contract.
29   function TriWallet () {
30     // Check whether we are in fork branch or in classic one
31     thisIsFork = BranchSender (0x23141df767233776f7cbbec497800ddedaa4c684).isRightBranch ();
32     
33     // Create ETC subwallet
34     etcWallet = new BranchWallet (msg.sender, !thisIsFork);
35     
36     // Create ETH subwallet
37     ethWallet = new BranchWallet (msg.sender, thisIsFork);
38   
39     // Log address of ETC subwallet
40     ETCWalletCreated (etcWallet);
41 
42     // Log address of ETH subwallet
43     ETHWalletCreated (ethWallet);
44   }
45 
46   // Distribute pending balance between ETC and ETH subwallets.
47   function distribute () {
48     if (thisIsFork) {
49       // Send all ETH to ETH subwallet
50       if (!ethWallet.send (this.balance)) throw;
51     } else {
52       // Send all ETC to ETC subwallet
53       if (!etcWallet.send (this.balance)) throw;
54     }
55   }
56 }
57 
58 // Wallet contract that operates only in "right" branch.
59 contract BranchWallet {
60   // Owner of the wallet
61   address public owner;
62     
63   // Is set to true if and only if we are currently in the "right" branch of
64   // the blockchain, i.e. the branch this wallet is operating in.
65   bool public isRightBranch;
66 
67   // Instantiate the contract.
68   //
69   // @param owner owner of the contract
70   // @isRightBranch whether we are currently in the "right" branch
71   function BranchWallet (address _owner, bool _isRightBranch) {
72     owner = _owner;
73     isRightBranch = _isRightBranch;
74   }
75 
76   // Only accept money in "right" branch.
77   function () {
78     if (!isRightBranch) throw;
79   }
80 
81   // Execute a transaction using money from this wallet.
82   //
83   // @param to transaction destination
84   // @param value transaction value
85   // @param data transaction data
86   function send (address _to, uint _value) {
87     if (!isRightBranch) throw;
88     if (msg.sender != owner) throw;
89     if (!_to.send (_value)) throw;
90   }
91 
92   // Execute a transaction using money from this wallet.
93   //
94   // @param to transaction destination
95   // @param value transaction value
96   // @param data transaction data
97   function execute (address _to, uint _value, bytes _data) {
98     if (!isRightBranch) throw;
99     if (msg.sender != owner) throw;
100     if (!_to.call.value (_value)(_data)) throw;
101   }
102 }
103 
104 // Simple smart contract that allows anyone to tell where we are currently in the
105 // "right" branch of blockchain.
106 contract BranchSender {
107   // Is set to true if and only if we are currently in the "right" branch of
108   // the blockchain.
109   bool public isRightBranch;
110 }