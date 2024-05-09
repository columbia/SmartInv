1 pragma solidity ^0.5.0;
2 
3 contract Lock {
4     // address owner; slot #0
5     // address unlockTime; slot #1
6     constructor (address owner, uint256 unlockTime) public payable {
7         assembly {
8             sstore(0x00, owner)
9             sstore(0x01, unlockTime)
10         }
11     }
12     
13     /**
14      * @dev        Withdraw function once timestamp has passed unlock time
15      */
16     function () external payable { // payable so solidity doesn't add unnecessary logic
17         assembly {
18             switch gt(timestamp, sload(0x01))
19             case 0 { revert(0, 0) }
20             case 1 {
21                 switch call(gas, sload(0x00), balance(address), 0, 0, 0, 0)
22                 case 0 { revert(0, 0) }
23             }
24         }
25     }
26 }
27 
28 contract Lockdrop {
29     enum Term {
30         ThreeMo,
31         SixMo,
32         TwelveMo
33     }
34     // Time constants
35     uint256 constant public LOCK_DROP_PERIOD = 1 days * 92; // 3 months
36     uint256 public LOCK_START_TIME;
37     uint256 public LOCK_END_TIME;
38     // ETH locking events
39     event Locked(address indexed owner, uint256 eth, Lock lockAddr, Term term, bytes edgewareAddr, bool isValidator, uint time);
40     event Signaled(address indexed contractAddr, bytes edgewareAddr, uint time);
41     
42     constructor(uint startTime) public {
43         LOCK_START_TIME = startTime;
44         LOCK_END_TIME = startTime + LOCK_DROP_PERIOD;
45     }
46 
47     /**
48      * @dev        Locks up the value sent to contract in a new Lock
49      * @param      term         The length of the lock up
50      * @param      edgewareAddr The bytes representation of the target edgeware key
51      * @param      isValidator  Indicates if sender wishes to be a validator
52      */
53     function lock(Term term, bytes calldata edgewareAddr, bool isValidator)
54         external
55         payable
56         didStart
57         didNotEnd
58     {
59         uint256 eth = msg.value;
60         address owner = msg.sender;
61         uint256 unlockTime = unlockTimeForTerm(term);
62         // Create ETH lock contract
63         Lock lockAddr = (new Lock).value(eth)(owner, unlockTime);
64         // ensure lock contract has all ETH, or fail
65         assert(address(lockAddr).balance == msg.value);
66         emit Locked(owner, eth, lockAddr, term, edgewareAddr, isValidator, now);
67     }
68 
69     /**
70      * @dev        Signals a contract's (or address's) balance decided after lock period
71      * @param      contractAddr  The contract address from which to signal the balance of
72      * @param      nonce         The transaction nonce of the creator of the contract
73      * @param      edgewareAddr   The bytes representation of the target edgeware key
74      */
75     function signal(address contractAddr, uint32 nonce, bytes calldata edgewareAddr)
76         external
77         didStart
78         didNotEnd
79         didCreate(contractAddr, msg.sender, nonce)
80     {
81         emit Signaled(contractAddr, edgewareAddr, now);
82     }
83 
84     function unlockTimeForTerm(Term term) internal view returns (uint256) {
85         if (term == Term.ThreeMo) return now + 92 days;
86         if (term == Term.SixMo) return now + 183 days;
87         if (term == Term.TwelveMo) return now + 365 days;
88         
89         revert();
90     }
91 
92     /**
93      * @dev        Ensures the lockdrop has started
94      */
95     modifier didStart() {
96         require(now >= LOCK_START_TIME);
97         _;
98     }
99 
100     /**
101      * @dev        Ensures the lockdrop has not ended
102      */
103     modifier didNotEnd() {
104         require(now <= LOCK_END_TIME);
105         _;
106     }
107 
108     /**
109      * @dev        Rebuilds the contract address from a normal address and transaction nonce
110      * @param      _origin  The non-contract address derived from a user's public key
111      * @param      _nonce   The transaction nonce from which to generate a contract address
112      */
113     function addressFrom(address _origin, uint32 _nonce) public pure returns (address) {
114         if(_nonce == 0x00)     return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), _origin, byte(0x80))))));
115         if(_nonce <= 0x7f)     return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd6), byte(0x94), _origin, uint8(_nonce))))));
116         if(_nonce <= 0xff)     return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd7), byte(0x94), _origin, byte(0x81), uint8(_nonce))))));
117         if(_nonce <= 0xffff)   return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd8), byte(0x94), _origin, byte(0x82), uint16(_nonce))))));
118         if(_nonce <= 0xffffff) return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xd9), byte(0x94), _origin, byte(0x83), uint24(_nonce))))));
119         return address(uint160(uint256(keccak256(abi.encodePacked(byte(0xda), byte(0x94), _origin, byte(0x84), uint32(_nonce)))))); // more than 2^32 nonces not realistic
120     }
121 
122     /**
123      * @dev        Ensures the target address was created by a parent at some nonce
124      * @param      target  The target contract address (or trivially the parent)
125      * @param      parent  The creator of the alleged contract address
126      * @param      nonce   The creator's tx nonce at the time of the contract creation
127      */
128     modifier didCreate(address target, address parent, uint32 nonce) {
129         // Trivially let senders "create" themselves
130         if (target == parent) {
131             _;
132         } else {
133             require(target == addressFrom(parent, nonce));
134             _;
135         }
136     }
137 }