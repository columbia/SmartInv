1 pragma solidity ^0.5.4;
2 
3 contract NiftyWallet {
4     
5     /**
6      * The Nifty Wallet - the niftiest wallet around!
7      * Author - Duncan Cock Foster. duncan@niftygateway.com 
8      */ 
9 
10     /**
11      * Constants 
12      * The address of the master contract, and the account ID for this wallet
13      * Account ID is used to retrieve the signing private key for this wallet
14      */ 
15 
16     address masterContractAdd = 0x4CADB4bAd0e2a49CC5D6CE26D8628C8f451dA346;
17     uint userAccountID = 0;
18     uint walletTxCount = 0;
19 
20     /**
21     / Events
22     */
23 
24     event Execution(address indexed destinationAddress, uint value, bytes txData);
25     event ExecutionFailure(address indexed destinationAddress, uint value, bytes txData);
26     event Deposit(address indexed sender, uint value);
27 
28     /**
29     * @dev returns signing private key that controls this wallet
30     */
31 
32     function returnUserAccountAddress() public view returns(address) {
33         MasterContract m_c_instance = MasterContract(masterContractAdd);
34         return (m_c_instance.returnUserControlAddress(userAccountID));
35     }
36     
37     function returnWalletTxCount() public view returns(uint) {
38         return(walletTxCount);
39     }
40     
41     /**
42      * Modifier to check msg.sender
43      */
44      
45     modifier onlyValidSender() {
46         MasterContract m_c_instance = MasterContract(masterContractAdd);
47         require(m_c_instance.returnIsValidSendingKey(msg.sender) == true);
48         _;
49       }
50 
51     /** 
52      * Fall back function - get paid and static calls
53      */ 
54 
55     function()
56         payable
57         external
58     {
59         if (msg.value > 0)
60             emit Deposit(msg.sender, msg.value);
61         else if (msg.data.length > 0) {
62             //static call 
63             MasterContract m_c_instance = MasterContract(masterContractAdd);
64             address loc =  (m_c_instance.returnStaticContractAddress());
65                 assembly {
66                     calldatacopy(0, 0, calldatasize())
67                     let result := staticcall(gas, loc, 0, calldatasize(), 0, 0)
68                     returndatacopy(0, 0, returndatasize())
69                     switch result 
70                     case 0 {revert(0, returndatasize())} 
71                     default {return (0, returndatasize())}
72                 }
73         }
74     }
75     
76     /**
77      * @dev function to call any on chain transaction
78      * @dev verifies that the transaction data has been signed by the wallets controlling private key
79      * @dev and that the transaction has been sent from an approved sending wallet
80      * @param  _signedData bytes - signature of txData + wallet address
81      * @param destination address - destination for this transaction
82      * @param value uint - value of this transaction
83      * @param data bytes - transaction data 
84      */ 
85 
86     function callTx(bytes memory _signedData,
87                      address destination,
88                      uint value,
89                      bytes memory data)
90     public onlyValidSender returns (bool) {
91         address userSigningAddress = returnUserAccountAddress();
92         MasterContract m_c_instance = MasterContract(masterContractAdd);
93         bytes32 dataHash = m_c_instance.returnTxMessageToSign(data, destination, value, walletTxCount);
94         address recoveredAddress = m_c_instance.recover(dataHash, _signedData);
95         if (recoveredAddress==userSigningAddress) {
96             if (external_call(destination, value, data.length, data)) {
97                 emit Execution(destination, value, data);
98                 walletTxCount = walletTxCount + 1;
99             } else {
100                 emit ExecutionFailure(destination, value, data);
101                 walletTxCount = walletTxCount +1;
102             }
103             return(true);
104         } else {
105             revert();
106         }
107     }
108     
109     /** External call function 
110      * Taken from Gnosis Mutli Sig wallet
111      * https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
112      */ 
113 
114     // call has been separated into its own function in order to take advantage
115     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
116     function external_call(address destination, uint value, uint dataLength, bytes memory data) private returns (bool) {
117         bool result;
118         assembly {
119             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
120             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
121             result := call(
122                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
123                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
124                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
125                 destination,
126                 value,
127                 d,
128                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
129                 x,
130                 0                  // Output is ignored, therefore the output size is zero
131             )
132         }
133         return result;
134     }
135 
136 }
137 
138 contract MasterContract {
139     function returnUserControlAddress(uint account_id) public view returns (address);
140     function returnIsValidSendingKey(address sending_key) public view returns (bool);
141     function returnStaticContractAddress() public view returns (address);
142     function recover(bytes32 hash, bytes memory sig) public pure returns (address);
143     function returnTxMessageToSign(bytes memory txData, address des_add, uint value, uint tx_count)
144     public view returns(bytes32);
145 }