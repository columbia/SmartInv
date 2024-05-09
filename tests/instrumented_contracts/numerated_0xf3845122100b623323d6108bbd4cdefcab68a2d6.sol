1 pragma solidity ^0.4.15;
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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 contract EthMessage is Ownable {
46 
47     /*
48     The cost of posting a message will be currentPrice.
49 
50     The currentPrice will increase by basePrice every time a message is bought.
51     */
52 
53     uint public constant BASEPRICE = 0.01 ether;
54     uint public currentPrice = 0.01 ether;
55     string public message = "";
56 
57     function withdraw() public payable onlyOwner {
58         msg.sender.transfer(this.balance);
59     }
60     
61     // This is only for messed up things people put.
62     function removeMessage() onlyOwner public {
63         message = "";
64     }
65 
66     modifier requiresPayment () {
67         require(msg.value >= currentPrice);
68         if (msg.value > currentPrice) {
69             msg.sender.transfer(msg.value - currentPrice);
70         }
71         currentPrice += BASEPRICE;
72         _;
73     }
74 
75     function putMessage(string messageToPut) public requiresPayment payable {
76         if (bytes(messageToPut).length > 255) {
77             revert();
78         }
79         message = messageToPut;
80     }
81 
82     function () {
83         revert();
84     }
85 }