1 pragma solidity 0.4.25;
2 
3 /**
4  * Contract that will forward any incoming Ether to the address specified upon deployment
5  */
6 contract Forwarder {
7     /** Address to which any funds sent to this contract will be forwarded
8      *  Event logs to log movement of Ether
9     **/
10     address constant public destinationAddress = 0x609E7e5Db94b3F47a359955a4c823538A5891D48;
11     event LogForwarded(address indexed sender, uint amount);
12 
13     /**
14      * Default function; Gets called when Ether is deposited, and forwards it to the destination address
15      */
16     function() payable public {
17         emit LogForwarded(msg.sender, msg.value);
18         destinationAddress.transfer(msg.value);
19     }
20 }