1 pragma solidity ^0.4.23;
2 
3 
4 contract LetsBreakThings {
5     
6     address public creator;
7     address public creatorproxy;
8     
9 
10     // Fallback function
11     function deposit() public payable {
12 
13     }
14     
15     // constructor
16     constructor(address _proxy) public {
17         creator = msg.sender;
18         creatorproxy = _proxy;
19     }
20 
21     
22     /// create events to log everything as cheaply as possible instead of by return values
23     event txSenderDetails(address sender, address origin);
24     event gasDetails(uint remainingGas, uint txGasPrice, uint blockGasLimit);
25     event balanceLog(address balanceHolder, uint256 balance);
26     event blockDetails(address coinbase, uint difficulty, uint blockNumber, uint timestamp);
27     
28 
29     // deprecated in version 0.4.22 and replaced by blockhash(uint blockNumber).
30     function getBlockHash(uint _blockNumber) public view returns (bytes32 _hash) {
31         // blockHash() for later versions
32         logBlockDetails();
33         logGasDetails();
34         logGasDetails();
35         logSenderDetails();
36         return block.blockhash(_blockNumber);
37     }
38     
39     /// @dev Emits details about the origin of a transaction.
40     /// @dev This includes sender and tx origin
41     function logSenderDetails() public view {
42         emit txSenderDetails(msg.sender, tx.origin);
43     }
44     
45     /// @dev logs the gas, gasprice and block gaslimit
46     function logGasDetails() public view {
47         emit gasDetails(msg.gas, tx.gasprice, block.gaslimit);
48         // gasLeft() in later versions
49     }
50     
51     /// @dev logs the coinbase difficulty number and timestamp for the block
52     function logBlockDetails() public view { 
53         emit blockDetails(block.coinbase, block.difficulty, block.number, block.timestamp);
54     }
55     
56     /// @dev Test function number 1
57     function checkBalanceSendEth(address _recipient) public {
58         
59         require(creator == msg.sender, "unauthorized");
60 
61         /// log balance at the start
62         checkBalance(_recipient);
63         
64 
65         /// transfer recipient smallest unit possible
66         /// solium-disable-next-line
67         _recipient.transfer(1);
68 
69         /// log balance
70         checkBalance(_recipient);
71 
72         /// send recipient smallest unit possible
73         _recipient.send(1);
74 
75         /// check final balance
76         checkBalance(_recipient);
77         
78         /// log everything
79         logBlockDetails();
80         logGasDetails();
81         logGasDetails();
82         logSenderDetails();
83         
84         
85     
86     }
87     
88     /// @dev internal function to check balance for an address and emit log event
89     function checkBalance(address _target) internal returns (uint256) {
90         uint256 balance = address(_target).balance;
91         emit balanceLog(_target, balance);
92         return balance;
93     }
94     
95     
96     /// @dev lets verify some block hashes against each other on chain
97     function verifyBlockHash(string memory _hash, uint _blockNumber) public returns (bytes32, bytes32) {
98         bytes32 hash1 = keccak256(_hash);
99         bytes32 hash2 = getBlockHash(_blockNumber);
100         return(hash1, hash2) ;
101     }
102     
103 }
104 
105 /// @dev now lets try this via a proxy
106 
107 /// @dev creator proxy calls the target function
108 /// @dev same test, same tx.origin, different msg.sender
109 contract creatorProxy {
110     function proxyCall(address _target, address _contract) public {
111         LetsBreakThings(_contract).checkBalanceSendEth(_target);
112     }
113 }