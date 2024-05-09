1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title MultiSig
5  * @dev Simple MultiSig using off-chain signing.
6  * @author Julien Niset - <julien@argent.im>
7  */
8 contract MultiSigWallet {
9 
10     uint constant public MAX_OWNER_COUNT = 10;
11 
12     // Incrementing counter to prevent replay attacks
13     uint256 public nonce;   
14     // The threshold           
15     uint256 public threshold; 
16     // The number of owners
17     uint256 public ownersCount;
18     // Mapping to check if an address is an owner
19     mapping (address => bool) public isOwner; 
20 
21     // Events
22     event OwnerAdded(address indexed owner);
23     event OwnerRemoved(address indexed owner);
24     event ThresholdChanged(uint256 indexed newThreshold);
25     event Executed(address indexed destination, uint256 indexed value, bytes data);
26     event Received(uint256 indexed value, address indexed from);
27 
28     /**
29      * @dev Throws is the calling account is not the multisig.
30      */
31     modifier onlyWallet() {
32         require(msg.sender == address(this), "MSW: Calling account is not wallet");
33         _;
34     }
35 
36     /**
37      * @dev Constructor.
38      * @param _threshold The threshold of the multisig.
39      * @param _owners The owners of the multisig.
40      */
41     constructor(uint256 _threshold, address[] _owners) public {
42         require(_owners.length > 0 && _owners.length <= MAX_OWNER_COUNT, "MSW: Not enough or too many owners");
43         require(_threshold > 0 && _threshold <= _owners.length, "MSW: Invalid threshold");
44         ownersCount = _owners.length;
45         threshold = _threshold;
46         for(uint256 i = 0; i < _owners.length; i++) {
47             isOwner[_owners[i]] = true;
48             emit OwnerAdded(_owners[i]);
49         }
50         emit ThresholdChanged(_threshold);
51     }
52 
53     /**
54      * @dev Only entry point of the multisig. The method will execute any transaction provided that it 
55      * receieved enough signatures from the wallet owners.  
56      * @param _to The destination address for the transaction to execute.
57      * @param _value The value parameter for the transaction to execute.
58      * @param _data The data parameter for the transaction to execute.
59      * @param _signatures Concatenated signatures ordered based on increasing signer's address.
60      */
61     function execute(address _to, uint _value, bytes _data, bytes _signatures) public {
62         uint8 v;
63         bytes32 r;
64         bytes32 s;
65         uint256 count = _signatures.length / 65;
66         require(count >= threshold, "MSW: Not enough signatures");
67         bytes32 txHash = keccak256(abi.encodePacked(byte(0x19), byte(0), address(this), _to, _value, _data, nonce));
68         nonce += 1;
69         uint256 valid;
70         address lastSigner = 0;
71         for(uint256 i = 0; i < count; i++) {
72             (v,r,s) = splitSignature(_signatures, i);
73             address recovered = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",txHash)), v, r, s);
74             require(recovered > lastSigner, "MSW: Badly ordered signatures"); // make sure signers are different
75             lastSigner = recovered;
76             if(isOwner[recovered]) {
77                 valid += 1;
78                 if(valid >= threshold) {
79                     require(_to.call.value(_value)(_data), "MSW: External call failed");
80                     emit Executed(_to, _value, _data);
81                     return;
82                 }
83             }
84         }
85         // If we reach that point then the transaction is not executed
86         revert("MSW: Not enough valid signatures");
87     }
88 
89     /**
90      * @dev Adds an owner to the multisig. This method can only be called by the multisig itself 
91      * (i.e. it must go through the execute method and be confirmed by the owners).
92      * @param _owner The address of the new owner.
93      */
94     function addOwner(address _owner) public onlyWallet {
95         require(ownersCount < MAX_OWNER_COUNT, "MSW: MAX_OWNER_COUNT reached");
96         require(isOwner[_owner] == false, "MSW: Already owner");
97         ownersCount += 1;
98         isOwner[_owner] = true;
99         emit OwnerAdded(_owner);
100     }
101 
102     /**
103      * @dev Removes an owner from the multisig. This method can only be called by the multisig itself 
104      * (i.e. it must go through the execute method and be confirmed by the owners).
105      * @param _owner The address of the removed owner.
106      */
107     function removeOwner(address _owner) public onlyWallet {
108         require(ownersCount > threshold, "MSW: Too few owners left");
109         require(isOwner[_owner] == true, "MSW: Not an owner");
110         ownersCount -= 1;
111         delete isOwner[_owner];
112         emit OwnerRemoved(_owner);
113     }
114 
115     /**
116      * @dev Changes the threshold of the multisig. This method can only be called by the multisig itself 
117      * (i.e. it must go through the execute method and be confirmed by the owners).
118      * @param _newThreshold The new threshold.
119      */
120     function changeThreshold(uint256 _newThreshold) public onlyWallet {
121         require(_newThreshold > 0 && _newThreshold <= ownersCount, "MSW: Invalid new threshold");
122         threshold = _newThreshold;
123         emit ThresholdChanged(_newThreshold);
124     }
125 
126     /**
127      * @dev Makes it possible for the multisig to receive ETH.
128      */
129     function () external payable {
130         emit Received(msg.value, msg.sender);        
131     }
132 
133         /**
134      * @dev Parses the signatures and extract (r, s, v) for a signature at a given index.
135      * A signature is {bytes32 r}{bytes32 s}{uint8 v} in compact form and signatures are concatenated.
136      * @param _signatures concatenated signatures
137      * @param _index which signature to read (0, 1, 2, ...)
138      */
139     function splitSignature(bytes _signatures, uint256 _index) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
140         // we jump 32 (0x20) as the first slot of bytes contains the length
141         // we jump 65 (0x41) per signature
142         // for v we load 32 bytes ending with v (the first 31 come from s) tehn apply a mask
143         assembly {
144             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
145             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
146             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
147         }
148         require(v == 27 || v == 28, "MSW: Invalid v"); 
149     }
150 
151 }