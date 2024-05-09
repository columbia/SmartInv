1 pragma solidity ^0.4.21;
2 
3 contract Etherwow{
4     function userRollDice(uint, address) payable {uint;address;}
5 }
6 
7 /**
8  * @title FixBet16
9  * @dev fix bet num = 16, bet size = 0.5 eth. 
10  */
11 contract FixBet16{
12     
13     modifier onlyOwner{
14         require(msg.sender == owner);
15         _;
16     }
17     
18     address public owner;
19     Etherwow public etherwow;
20     bool public bet;
21 
22     /*
23      * @dev contract initialize
24      * @param new etherwow address
25      */        
26     function FixBet16(){
27         owner = msg.sender;
28     }
29 
30     /*
31      * @dev owner set etherwow contract address
32      * @param new etherwow address
33      */    
34     function ownerSetEtherwowAddress(address newEtherwowAddress) public
35         onlyOwner
36     {
37        etherwow = Etherwow(newEtherwowAddress);
38     }
39 
40     /*
41      * @dev owner set fallback function mode
42      * @param new fallback function mode. true - bet, false - add funds to contract
43      */    
44     function ownerSetMod(bool newMod) public
45         onlyOwner
46     {
47         bet = newMod;
48     }
49 
50     /*
51      * @dev add funds or bet. if bet == false, add funds to this contract for cover the txn gas fee
52      */     
53     function () payable{
54         if (bet == true){
55             require(msg.value == 500000000000000000);
56             etherwow.userRollDice.value(msg.value)(16, msg.sender);  
57         }
58         else return;
59     }
60 }