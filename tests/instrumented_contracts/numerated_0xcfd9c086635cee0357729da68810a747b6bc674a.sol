1 pragma solidity ^0.4.26;
2 
3 //This is the public contract for the NebliDex decentralized exchange
4 //This exchange can be used to trade cryptocurrencies in a decentralized way without intermediaries or proxy tokens
5 //As of June 26th, 2019, the exchange website can be found at www.neblidex.xyz
6 
7 //Contract source based on code provided from: https://github.com/jchittoda/eth-atomic-swap/
8 
9 contract NebliDex_AtomicSwap {
10   struct Swap {
11     uint256 timelock;
12     uint256 value;
13     address ethTrader;
14     address withdrawTrader;
15     bytes32 secretLock;
16     bytes secretKey;
17   }
18 
19   enum States {
20     INVALID,
21     OPEN,
22     CLOSED,
23     EXPIRED
24   }
25 
26   mapping (bytes32 => Swap) private swaps;
27   mapping (bytes32 => States) private swapStates;
28 
29   event Open(bytes32 _swapID, address _withdrawTrader);
30   event Expire(bytes32 _swapID);
31   event Close(bytes32 _swapID, bytes _secretKey);
32 
33   modifier onlyInvalidSwaps(bytes32 _swapID) {
34     require (swapStates[_swapID] == States.INVALID);
35     _;
36   }
37 
38   modifier onlyOpenSwaps(bytes32 _swapID) {
39     require (swapStates[_swapID] == States.OPEN);
40     _;
41   }
42 
43   modifier onlyClosedSwaps(bytes32 _swapID) {
44     require (swapStates[_swapID] == States.CLOSED);
45     _;
46   }
47 
48   modifier onlyExpiredSwaps(bytes32 _swapID) {
49     require (now >= swaps[_swapID].timelock);
50     _;
51   }
52 
53   // Cannot redeem amount if timelock has expired
54   modifier onlyNotExpiredSwaps(bytes32 _swapID) {
55     require (now < swaps[_swapID].timelock);
56     _;
57   }
58 
59   modifier onlyWithSecretKey(bytes32 _swapID, bytes _secretKey) {
60     require (_secretKey.length == 33); // The key must be this length across the board
61     require (swaps[_swapID].secretLock == sha256(_secretKey));
62     _;
63   }
64 
65   function open(bytes32 _swapID, address _withdrawTrader, uint256 _timelock) public onlyInvalidSwaps(_swapID) payable {
66     // Store the details of the swap.
67     // The secret lock is the swapID
68     Swap memory swap = Swap({
69       timelock: _timelock,
70       value: msg.value,
71       ethTrader: msg.sender,
72       withdrawTrader: _withdrawTrader,
73       secretLock: _swapID,
74       secretKey: new bytes(0)
75     });
76     swaps[_swapID] = swap;
77     swapStates[_swapID] = States.OPEN;
78 
79     // Trigger open event.
80     emit Open(_swapID, _withdrawTrader);
81   }
82 
83   function redeem(bytes32 _swapID, bytes _secretKey) public onlyOpenSwaps(_swapID) onlyNotExpiredSwaps(_swapID) onlyWithSecretKey(_swapID, _secretKey) {
84     // Redeem the value from the contract.
85     Swap memory swap = swaps[_swapID];
86     swaps[_swapID].secretKey = _secretKey;
87     swapStates[_swapID] = States.CLOSED;
88 
89     // Transfer the ETH funds from this contract to the withdrawing trader.
90     swap.withdrawTrader.transfer(swap.value);
91 
92     // Trigger close event.
93     emit Close(_swapID, _secretKey);
94   }
95 
96   function refund(bytes32 _swapID) public onlyOpenSwaps(_swapID) onlyExpiredSwaps(_swapID) {
97     // Expire the swap.
98     Swap memory swap = swaps[_swapID];
99     swapStates[_swapID] = States.EXPIRED;
100 
101     // Transfer the ETH value from this contract back to the ETH trader.
102    swap.ethTrader.transfer(swap.value);
103 
104      // Trigger expire event.
105     emit Expire(_swapID);
106   }
107 
108   function check(bytes32 _swapID) public view returns (uint256 timelock, uint256 value, address withdrawTrader, bytes32 secretLock) {
109     Swap memory swap = swaps[_swapID];
110     return (swap.timelock, swap.value, swap.withdrawTrader, swap.secretLock);
111   }
112 
113   function checkSecretKey(bytes32 _swapID) public view onlyClosedSwaps(_swapID) returns (bytes secretKey) {
114     Swap memory swap = swaps[_swapID];
115     return swap.secretKey;
116   }
117 }