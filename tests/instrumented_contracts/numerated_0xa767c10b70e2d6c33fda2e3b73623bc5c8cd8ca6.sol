1 contract DFNTokens {
2   // An identifying string, set by the constructor
3   string public name;
4 
5   // mapping from address to balance
6   mapping(address => uint) public balance;
7 
8   // set of addresses that are authorized to transfer
9   mapping(address => bool) public authorizedToTransfer;
10 
11   // owner (authorized to do anything)
12   address public owner;
13 
14   // list of notarizations
15   bytes32[] public notarizationList;
16 
17   // frozen flag
18   bool public frozen = false;
19 
20   // freeze requested at height
21   uint public freezeHeight = 0;
22 
23   // For convenience of external contracts only (not used here)
24   // list of addresses with balances
25   address[] public addrList;
26   // test if address has ever had a non-zero balance
27   mapping(address => bool) public seen;
28   // number of addresses that ever had a non-zero balance
29   uint public nAddresses = 0;
30 
31   // Constructor
32   function DFNTokens() public {
33       name = "DFINITY Genesis";
34 
35       // set owner
36       owner = msg.sender;
37 
38       // genesis balance
39       balance[0x0] = 469213710;
40 
41       // first three accounts
42       TransferDFN(0x0, 0x1, 44575302);
43       TransferDFN(0x0, 0x2, 115986694);
44       TransferDFN(0x0, 0x3, 308651714);
45   }
46 
47   // Modifier
48   modifier onlyowner {
49       require(msg.sender == owner);
50       _;
51   }
52 
53   modifier onlyauthorized {
54       require(msg.sender == owner || authorizedToTransfer[msg.sender] == true);
55       _;
56   }
57 
58   modifier alive {
59       require(!frozen);
60       _;
61   }
62 
63   // Transfer DFN
64   function TransferDFN(address from, address to, uint amt) onlyauthorized alive public {
65     require(0 < amt && amt <= balance[from]);
66 
67     // transfer balance
68     balance[to] += amt;
69     balance[from] -= amt;
70 
71     // maintain records for convenience of external contracts
72     if (!seen[to]) {
73         addrList.push(to);
74         seen[to] = true;
75         nAddresses += 1;
76     }
77   }
78 
79 // Authorize external contract to transfer 
80 function AuthorizeToTransfer(address newAddr) onlyowner alive public {
81     authorizedToTransfer[newAddr] = true;
82 }
83 
84 // Unauthorize external contract to transfer 
85 function UnauthorizeToTransfer(address addr) onlyowner alive public {
86     authorizedToTransfer[addr] = false;
87 }
88 
89 // Record notarization string (hash)
90 function Notarize(bytes32 hash) onlyowner alive public {
91     notarizationList.push(hash);
92 }
93 
94 // Freeze contract
95 function Freeze() onlyowner alive public {
96     // Freeze if this is the second call within 20 blocks
97     if (freezeHeight > 0 && block.number < freezeHeight + 20) { frozen = true; }
98 
99     // Otherwise set block number of latest freeze request
100     freezeHeight = block.number;
101 }
102 
103 // Empty out funds that accidentally end up on this contract
104 function emptyTo(address addr) onlyowner public {
105     addr.transfer(address(this).balance);
106 }
107 
108 }