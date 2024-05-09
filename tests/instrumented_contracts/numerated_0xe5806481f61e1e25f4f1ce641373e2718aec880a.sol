1 pragma solidity ^0.4.22;
2 
3 /**
4 * Contract that will forward any incoming Ether to a receiver address
5 */
6 contract Forwarder {
7     // Address to which any funds sent to this contract will be forwarded
8     address public destinationAddress;
9     
10     // Events allow light clients to react on
11     // changes efficiently.
12     event Forward(address from, address to, uint amount);
13     
14     /**
15     * Create the contract, and set the destination address to that of the creator
16     */
17     constructor(address receiver) public {
18         destinationAddress = receiver;
19     }
20     
21     /**
22     * Default function; Gets called when Ether is deposited, and forwards it to the destination address
23     */
24     function() public payable {
25         if (!destinationAddress.send(msg.value))
26             revert();
27         
28         emit Forward(msg.sender, destinationAddress, msg.value);
29     }
30 }