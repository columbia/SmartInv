1 pragma solidity ^0.4.14;
2 
3 /**
4  * Contract that exposes the needed erc20 token functions
5  */
6 
7 contract ERC20Interface {
8   // Send _value amount of tokens to address _to
9   function transfer(address _to, uint256 _value) returns (bool success);
10   // Get the account balance of another account with address _owner
11   function balanceOf(address _owner) constant returns (uint256 balance);
12 }
13 
14 /**
15  * Contract that will forward any incoming Ether to its creator
16  */
17 contract Forwarder {
18   // Address to which any funds sent to this contract will be forwarded
19   address public parentAddress;
20   event ForwarderDeposited(address from, uint value, bytes data);
21 
22   event TokensFlushed(
23     address tokenContractAddress, // The contract address of the token
24     uint value // Amount of token sent
25   );
26 
27   /**
28    * Create the contract, and set the destination address to that of the creator
29    */
30   function Forwarder() {
31     parentAddress = msg.sender;
32   }
33 
34   /**
35    * Modifier that will execute internal code block only if the sender is a parent of the forwarder contract
36    */
37   modifier onlyParent {
38     if (msg.sender != parentAddress) {
39       throw;
40     }
41     _;
42   }
43 
44   /**
45    * Default function; Gets called when Ether is deposited, and forwards it to the destination address
46    */
47   function() payable {
48     if (!parentAddress.call.value(msg.value)(msg.data))
49       throw;
50     // Fire off the deposited event if we can forward it  
51     ForwarderDeposited(msg.sender, msg.value, msg.data);
52   }
53 
54   /**
55    * Execute a token transfer of the full balance from the forwarder token to the main wallet contract
56    * @param tokenContractAddress the address of the erc20 token contract
57    */
58   function flushTokens(address tokenContractAddress) onlyParent {
59     ERC20Interface instance = ERC20Interface(tokenContractAddress);
60     var forwarderAddress = address(this);
61     var forwarderBalance = instance.balanceOf(forwarderAddress);
62     if (forwarderBalance == 0) {
63       return;
64     }
65     if (!instance.transfer(parentAddress, forwarderBalance)) {
66       throw;
67     }
68     TokensFlushed(tokenContractAddress, forwarderBalance);
69   }
70 
71   /**
72    * It is possible that funds were sent to this address before the contract was deployed.
73    * We can flush those funds to the destination address.
74    */
75   function flush() {
76     if (!parentAddress.call.value(this.balance)())
77       throw;
78   }
79 }