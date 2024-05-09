1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev Adds onlyOwner modifier. Subcontracts should implement checkOwner to check if caller is owner.
6  */
7 contract Ownable {
8     modifier onlyOwner() {
9         checkOwner();
10         _;
11     }
12 
13     function checkOwner() internal;
14 }
15 
16 /**
17  * @title OwnableImpl
18  * @dev The Ownable contract has an owner address, and provides basic authorization control
19  * functions, this simplifies the implementation of "user permissions".
20  */
21 contract OwnableImpl is Ownable {
22     address public owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     /**
27      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28      * account.
29      */
30     function OwnableImpl() public {
31         owner = msg.sender;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     function checkOwner() internal {
38         require(msg.sender == owner);
39     }
40 
41     /**
42      * @dev Allows the current owner to transfer control of the contract to a newOwner.
43      * @param newOwner The address to transfer ownership to.
44      */
45     function transferOwnership(address newOwner) onlyOwner public {
46         require(newOwner != address(0));
47         OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 }
51 
52 contract EtherReceiver {
53 	function receiveWithData(bytes _data) payable public;
54 }
55 
56 contract Forwarder is OwnableImpl {
57 	function withdraw(address to, uint256 value) onlyOwner public {
58 		to.transfer(value);
59 	}
60 
61 	function forward(address to, bytes data, uint256 value) payable public {
62 		uint256 toTransfer = value - value / 100;
63 		if (msg.value > toTransfer) {
64 			EtherReceiver(to).receiveWithData.value(toTransfer)(data);
65 		} else {
66 			EtherReceiver(to).receiveWithData.value(msg.value)(data);
67 		}
68 	}
69 }