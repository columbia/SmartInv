1 // DAO>9000 (http://dao9000.com) under CC0
2 
3 contract Dao9000 {
4     string message; //This is variable is first for easier interaction with outside world (offset 0x0), contains latest member message
5     address[] public members;
6 
7     function Dao9000 () {
8         members.push (msg.sender); //The contact owner is added as the first member
9         message = "Message not yet defined";
10     }
11     
12     //These two functions are for easier external interaction via api.etherscan.io:
13     function getMembers () constant returns (uint256 retVal) {
14         return members.length;
15     }
16     
17     function getMessage () constant returns (string retVal) {
18         return message;
19     }
20     
21     //This is the default function, this is called when normal transaction is made
22     function () {
23         //Since this is a DAO parody, we really do not let people invest more than 1.5 ETH max.
24         if (msg.value < 1500000000000000000 && msg.value > 1) {
25             //RNG happens here: for the "seed" hash of the previous block is taken, and current timestamp is added
26             uint256 randomIndex = (uint256(block.blockhash(block.number-1)) + now) % members.length;
27             if (members[randomIndex].send(msg.value)) {
28                 if (msg.data.length > 0)
29                     message = string(msg.data); //If additional message is defined, we save it here
30                 members.push (msg.sender); //After a successful transaction, new member is added, multiple entries for same member are permitted
31             } else {
32                 throw;
33             }
34         } else {
35             throw;
36         }
37     }
38 }