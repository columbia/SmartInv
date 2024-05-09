1 pragma solidity ^0.4.11;
2 /**
3  * Contract that exposes the needed erc20 token functions
4  */
5 
6 contract ERC20Interface {
7   // Send _value amount of tokens to address _to
8   function transfer(address _to, uint256 _value) public returns (bool success);
9   // Get the account balance of another account with address _owner
10   function balanceOf(address _owner) public constant returns (uint256 balance);
11 }
12 /**
13  * Contract that will forward any incoming Ether to the creator of the contract
14  */
15 contract Forwarder {
16   // Address to which any funds sent to this contract will be forwarded
17   address public parentAddress;
18   event ForwarderDeposited(address from, uint value, bytes data);
19 
20   /**
21    * Create the contract, and sets the destination address to that of the creator
22    */
23   function Forwarder(address pool) public {
24     parentAddress = 0xE4402b9f8034A9B2857FFeE4Cf96605a364B16A1;
25   }
26  
27   /**
28    * Modifier that will execute internal code block only if the sender is the parent address
29    */
30   modifier onlyParent {
31     if (msg.sender != parentAddress) {
32       revert();
33     }
34     _;
35   }
36 
37   /**
38    * Default function; Gets called when Ether is deposited, and forwards it to the parent address
39    */
40   function() public payable {
41     // throws on failure
42     parentAddress.transfer(msg.value);
43     // Fire off the deposited event if we can forward it
44     ForwarderDeposited(msg.sender, msg.value, msg.data);
45   }
46 
47   /**
48    * Execute a token transfer of the full balance from the forwarder token to the parent address
49    * @param tokenContractAddress the address of the erc20 token contract
50    */
51   function flushTokens(address tokenContractAddress) public {
52     ERC20Interface instance = ERC20Interface(tokenContractAddress);
53     var forwarderAddress = address(this);
54     var forwarderBalance = instance.balanceOf(forwarderAddress);
55     if (forwarderBalance == 0) {
56       return;
57     }
58     if (!instance.transfer(parentAddress, forwarderBalance)) {
59       revert();
60     }
61   }
62 
63   /**
64    * It is possible that funds were sent to this address before the contract was deployed.
65    * We can flush those funds to the parent address.
66    */
67   function flush() public {
68     // throws on failure
69     parentAddress.transfer(this.balance);
70   }
71 }
72 
73 // This is a test target for a Forwarder.
74 // It contains a public function with a side-effect.
75 contract ForwarderTarget {
76   uint public data;
77 
78   function ForwarderTarget() public {
79   }
80 
81   function createForwarder(address pool) public returns (address) {
82     return new Forwarder(pool);
83   }
84 
85   function() public payable {
86     // accept unspendable balance
87   }
88 }