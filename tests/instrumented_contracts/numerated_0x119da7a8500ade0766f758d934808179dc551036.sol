1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /// @notice The BrokerVerifier interface defines the functions that a settlement
66 /// layer's broker verifier contract must implement.
67 interface BrokerVerifier {
68 
69     /// @notice The function signature that will be called when a trader opens
70     /// an order.
71     ///
72     /// @param _trader The trader requesting the withdrawal.
73     /// @param _signature The 65-byte signature from the broker.
74     /// @param _orderID The 32-byte order ID.
75     function verifyOpenSignature(
76         address _trader,
77         bytes _signature,
78         bytes32 _orderID
79     ) external returns (bool);
80 }
81 
82 /// @notice The Settlement interface defines the functions that a settlement
83 /// layer must implement.
84 /// Docs: https://github.com/republicprotocol/republic-sol/blob/nightly/docs/05-settlement.md
85 interface Settlement {
86     function submitOrder(
87         bytes _details,
88         uint64 _settlementID,
89         uint64 _tokens,
90         uint256 _price,
91         uint256 _volume,
92         uint256 _minimumVolume
93     ) external;
94 
95     function submissionGasPriceLimit() external view returns (uint256);
96 
97     function settle(
98         bytes32 _buyID,
99         bytes32 _sellID
100     ) external;
101 
102     /// @notice orderStatus should return the status of the order, which should
103     /// be:
104     ///     0  - Order not seen before
105     ///     1  - Order details submitted
106     ///     >1 - Order settled, or settlement no longer possible
107     function orderStatus(bytes32 _orderID) external view returns (uint8);
108 }
109 
110 /// @notice SettlementRegistry allows a Settlement layer to register the
111 /// contracts used for match settlement and for broker signature verification.
112 contract SettlementRegistry is Ownable {
113     string public VERSION; // Passed in as a constructor parameter.
114 
115     struct SettlementDetails {
116         bool registered;
117         Settlement settlementContract;
118         BrokerVerifier brokerVerifierContract;
119     }
120 
121     // Settlement IDs are 64-bit unsigned numbers
122     mapping(uint64 => SettlementDetails) public settlementDetails;
123 
124     // Events
125     event LogSettlementRegistered(uint64 settlementID, Settlement settlementContract, BrokerVerifier brokerVerifierContract);
126     event LogSettlementUpdated(uint64 settlementID, Settlement settlementContract, BrokerVerifier brokerVerifierContract);
127     event LogSettlementDeregistered(uint64 settlementID);
128 
129     /// @notice The contract constructor.
130     ///
131     /// @param _VERSION A string defining the contract version.
132     constructor(string _VERSION) public {
133         VERSION = _VERSION;
134     }
135 
136     /// @notice Returns the settlement contract of a settlement layer.
137     function settlementRegistration(uint64 _settlementID) external view returns (bool) {
138         return settlementDetails[_settlementID].registered;
139     }
140 
141     /// @notice Returns the settlement contract of a settlement layer.
142     function settlementContract(uint64 _settlementID) external view returns (Settlement) {
143         return settlementDetails[_settlementID].settlementContract;
144     }
145 
146     /// @notice Returns the broker verifier contract of a settlement layer.
147     function brokerVerifierContract(uint64 _settlementID) external view returns (BrokerVerifier) {
148         return settlementDetails[_settlementID].brokerVerifierContract;
149     }
150 
151     /// @param _settlementID A unique 64-bit settlement identifier.
152     /// @param _settlementContract The address to use for settling matches.
153     /// @param _brokerVerifierContract The decimals to use for verifying
154     ///        broker signatures.
155     function registerSettlement(uint64 _settlementID, Settlement _settlementContract, BrokerVerifier _brokerVerifierContract) public onlyOwner {
156         bool alreadyRegistered = settlementDetails[_settlementID].registered;
157         
158         settlementDetails[_settlementID] = SettlementDetails({
159             registered: true,
160             settlementContract: _settlementContract,
161             brokerVerifierContract: _brokerVerifierContract
162         });
163 
164         if (alreadyRegistered) {
165             emit LogSettlementUpdated(_settlementID, _settlementContract, _brokerVerifierContract);
166         } else {
167             emit LogSettlementRegistered(_settlementID, _settlementContract, _brokerVerifierContract);
168         }
169     }
170 
171     /// @notice Deregisteres a settlement layer, clearing the details.
172     /// @param _settlementID The unique 64-bit settlement identifier.
173     function deregisterSettlement(uint64 _settlementID) external onlyOwner {
174         require(settlementDetails[_settlementID].registered, "not registered");
175 
176         delete settlementDetails[_settlementID];
177 
178         emit LogSettlementDeregistered(_settlementID);
179     }
180 }