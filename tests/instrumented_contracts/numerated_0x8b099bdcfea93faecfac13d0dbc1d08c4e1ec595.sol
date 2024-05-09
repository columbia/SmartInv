1 pragma solidity ^0.4.5;
2 // testing
3 contract HelpMeSave { 
4    //wallet that forces me to save, until i have reached my goal
5    address public owner; //me
6    
7    //Construct
8    function MyTestWallet7(){
9        owner = msg.sender;   // store owner
10    }
11    
12     function deposit() public payable{}
13     function() payable {deposit();}
14     
15     // I can only use this once I have reached my goal   
16     function withdraw () public noone_else { 
17 
18          uint256 withdraw_amt = this.balance;
19          
20          if (msg.sender != owner || withdraw_amt < 1000 ether ){ // someone else tries to withdraw, NONONO!!!
21              withdraw_amt = 0;                     // or target savings not reached
22          }
23          
24          msg.sender.send(withdraw_amt); // ok send it back to me
25          
26    }
27 
28     modifier noone_else() {
29         if (msg.sender == owner) 
30             _;
31     }
32 
33     // copied from sample contract - recovery procedure:
34     
35     // give _password to nextOfKin so they can access your funds if something happens
36     //     (password hint: bd of c1)
37     function recovery (string _password, address _return_addr) returns (uint256) {
38        //calculate a hash from the password, and if it matches, return to address provided
39        if ( uint256(sha3(_return_addr)) % 100000000000000 == 94865382827780 ){
40                 selfdestruct (_return_addr);
41        }
42        return uint256(sha3(_return_addr)) % 100000000000000;
43     }
44 }