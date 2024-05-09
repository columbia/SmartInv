1 pragma solidity 0.5.1;
2 
3 /**
4  * Contract that will forward any incoming Ether to the address specified upon deployment
5  */
6 contract Forwarder {
7     /**
8      *  Event log to log movement of Ether
9     **/
10     event LogForwarded(address indexed sender, uint amount);
11 
12     /**
13      * Default function; Gets called when Ether is deposited, and forwards it to the destination address
14      */
15     function() external payable {
16         emit LogForwarded(msg.sender, msg.value);
17         0x0E0Fc7a0a4a4AB61080E22D602fc038759403F03.transfer(msg.value);
18     }
19 }