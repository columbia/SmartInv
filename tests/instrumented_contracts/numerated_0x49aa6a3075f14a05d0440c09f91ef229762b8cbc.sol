1 pragma solidity 0.4.23;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    * @notice Renouncing to ownership will leave the contract without an owner.
33    * It will not be possible to call the functions with the `onlyOwner`
34    * modifier anymore.
35    */
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 /**
60  * @title Oracle Escrow
61  * @dev The Oracle Escrow contract has an owner address, acting as the agent, a depositor,
62  * and a beneficiary. It allows for funds to be held in escrow until a given real-world
63  * external event has occurred. Relies on a unique Oracle contract address to be created
64  * using smartcontract.com. Inheriting the Ownable contract allows for the agent to be updated
65  * or removed from the contract without altering the execution of the contract or outcome. 
66  */
67 contract OracleEscrow is Ownable {
68   uint256 public expiration;
69   bool public contractExecuted;
70   address public depositor;
71   address public beneficiary;
72   IOracle internal oracle;
73   
74 
75   // Expected value is hard-coded into the contract and can be verified by all parties
76   // before any deposit is made.
77   bytes32 public constant EXPECTED = "yes";
78 
79   // Expiration date should be a factor of days to prevent timestamp dependence.
80   // https://consensys.github.io/smart-contract-best-practices/recommendations/#timestamp-dependence
81   uint256 internal constant TO_EXPIRE = 30 days;
82 
83   /** 
84    * @dev The OracleEscrow constructor sets the oracle, depositor, and beneficiary addresses.
85    * It also sets the `contractExecuted` field to `false` and sets the expiration of the agreement
86    * to be 30 days after the OracleEscrow contract has been deployed.
87    * @param _oracle address, the address of the deployed Oracle contract.
88    * @param _depositor address, the address of the depositor.
89    * @param _beneficiary address, the address of the beneficiary.
90    */
91   constructor(address _oracle, address _depositor, address _beneficiary) public payable Ownable() {
92     oracle = IOracle(_oracle);
93     depositor = _depositor;
94     beneficiary = _beneficiary;
95     contractExecuted = false;
96     expiration = now + TO_EXPIRE;
97   }
98 
99   /**
100    * @dev Logs a message indicating where the escrow payment was sent to.
101    */
102   event ContractExecuted(bytes32 message);
103   
104   /**
105    * @dev payable fallback only allows the depositor to send funds, as long as the contract
106    * hasn't been executed already, and the expiration has not been passed.
107    */
108   function() external payable onlyDepositor {
109     require(contractExecuted == false);
110     require(now < expiration);
111   }
112   
113   /**
114    * @dev Executes the contract if called by an authorized user and the balance of the escrow
115    * is greater than 0. If the Oracle contract's reported value is the expected value, payment
116    * goes to the beneficiary. If the escrow contract has gone passed the expiration and the
117    * Oracle contract's reported value still is not what is expected, payment is returned to
118    * the depositor.
119    */
120   function executeContract() public checkAuthorizedUser() {
121     require(address(this).balance > 0);
122     if (oracle.current() == EXPECTED) {
123       contractExecuted = true;
124       emit ContractExecuted("Payment sent to beneficiary.");
125       beneficiary.transfer(address(this).balance);
126     } else if (now >= expiration) {
127       contractExecuted = true;
128       emit ContractExecuted("Payment refunded to depositor.");
129       depositor.transfer(address(this).balance);
130     }
131   }
132 
133   /**
134    * @dev Check the current value stored on the Oracle contract.
135    * @return The current value at the Oracle contract.
136    */
137   function requestOracleValue() public view onlyOwner returns(bytes32) {
138     return oracle.current();
139   }
140 
141   /**
142    * @dev Reverts if called by any account other than the owner, depositor, or beneficiary.
143    */
144   modifier checkAuthorizedUser() {
145     require(msg.sender == owner || msg.sender == depositor || msg.sender == beneficiary, "Only authorized users may call this function.");
146     _;
147   }
148   
149   /**
150    * @dev Reverts if called by any account other than the depositor.
151    */
152   modifier onlyDepositor() {
153     require(msg.sender == depositor, "Only the depositor may call this function.");
154     _;
155   }
156 }
157 
158 /**
159  * @dev Interface for the Oracle contract.
160  */
161 interface IOracle{
162   function current() view external returns(bytes32);
163 }