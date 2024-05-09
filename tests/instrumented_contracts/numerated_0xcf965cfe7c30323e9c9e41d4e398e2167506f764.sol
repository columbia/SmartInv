1 //! Fundraiser contract. Just records who sent what.
2 //! By Parity Technologies, 2017.
3 //! Released under the Apache Licence 2.
4 //! Modified by the Interchain Foundation.
5 
6 pragma solidity ^0.4.8;
7 
8 /// Will accept Ether "contributions" and record each both as a log and in a
9 /// queryable record.
10 contract Fundraiser {
11 
12 
13     // How much is enough?
14     uint public constant dust = 180 finney;
15 
16 
17     // Special addresses: 
18     //  administrator can halt/unhalt/kill/adjustRate;
19     //  treasury receives all the funds
20     address public admin;
21     address public treasury;
22 
23     // Begin and end block for the fundraising period
24     uint public beginBlock;
25     uint public endBlock;
26 
27     // Number of wei per atom
28     uint public weiPerAtom; 
29 
30     // Are contributions abnormally halted?
31     bool public isHalted = false;
32 
33     // The `record` mapping maps cosmos addresses to the amount of atoms.
34     mapping (address => uint) public record;
35 
36     // The total amount of ether raised
37     uint public totalWei = 0;
38     // The total amount of atoms suggested for allocation
39     uint public totalAtom = 0;
40     // The number of donation
41     uint public numDonations = 0;
42 
43     /// Constructor. `_admin` has the ability to pause the
44     /// contribution period and, eventually, kill this contract. `_treasury`
45     /// receives all funds. `_beginBlock` and `_endBlock` define the begin and
46     /// end of the period. `_weiPerAtom` is the ratio of atoms to ether.
47     function Fundraiser(address _admin, address _treasury, uint _beginBlock, uint _endBlock, uint _weiPerAtom) {
48         admin = _admin;
49         treasury = _treasury;
50         beginBlock = _beginBlock;
51         endBlock = _endBlock;
52 	weiPerAtom = _weiPerAtom;
53     }
54 
55     // Can only be called by _admin.
56     modifier only_admin { if (msg.sender != admin) throw; _; }
57     // Can only be called by prior to the period.
58     modifier only_before_period { if (block.number >= beginBlock) throw; _; }
59     // Can only be called during the period when not halted.
60     modifier only_during_period { if (block.number < beginBlock || block.number >= endBlock || isHalted) throw; _; }
61     // Can only be called during the period when halted.
62     modifier only_during_halted_period { if (block.number < beginBlock || block.number >= endBlock || !isHalted) throw; _; }
63     // Can only be called after the period.
64     modifier only_after_period { if (block.number < endBlock) throw; _; }
65     // The value of the message must be sufficiently large to not be considered dust.
66     modifier is_not_dust { if (msg.value < dust) throw; _; }
67 
68     /// Some contribution `amount` received from `recipient` at rate of `currentRate` with emergency return of `returnAddr`.
69     event Received(address indexed recipient, address returnAddr, uint amount, uint currentRate);
70     /// Period halted abnormally.
71     event Halted();
72     /// Period restarted after abnormal halt.
73     event Unhalted();
74 
75     // Is the fundraiser active?
76     function isActive() constant returns (bool active) {
77 	return (block.number >= beginBlock && block.number < endBlock && !isHalted);
78     }
79 
80     /// Receive a contribution for a donor cosmos address.
81     function donate(address _donor, address _returnAddress, bytes4 checksum) payable only_during_period is_not_dust {
82 	// checksum is the first 4 bytes of the sha3 of the xor of the bytes32 versions of the cosmos address and the return address
83 	if ( !( bytes4(sha3( bytes32(_donor)^bytes32(_returnAddress) )) == checksum )) throw;
84 
85 	// forward the funds to the treasurer
86         if (!treasury.send(msg.value)) throw;
87 
88 	// calculate the number of atoms at the current rate
89 	var atoms = msg.value / weiPerAtom;
90 
91 	// update the donor details
92         record[_donor] += atoms;
93 
94 	// update the totals
95         totalWei += msg.value;
96 	totalAtom += atoms;
97 	numDonations += 1;
98 
99         Received(_donor, _returnAddress, msg.value, weiPerAtom);
100     }
101 
102     /// Adjust the weiPerAtom
103     function adjustRate(uint newRate) only_admin {
104 	weiPerAtom = newRate;
105     }
106 
107     /// Halt the contribution period. Any attempt at contributing will fail.
108     function halt() only_admin only_during_period {
109         isHalted = true;
110         Halted();
111     }
112 
113     /// Unhalt the contribution period.
114     function unhalt() only_admin only_during_halted_period {
115         isHalted = false;
116         Unhalted();
117     }
118 
119     /// Kill this contract.
120     function kill() only_admin only_after_period {
121         suicide(treasury);
122     }
123 }