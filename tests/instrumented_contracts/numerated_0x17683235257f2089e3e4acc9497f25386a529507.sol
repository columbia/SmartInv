1 //
2 //  Custom Wallet Contract that forces me to save, until i have reached my goal
3 //  and prevents me from withdrawing my funds before I have reached my personal goal
4 //
5 //  Motivation is to stop my bad trading habbits to sell ether everytime the price drops...
6 //  :D :D
7 //
8 //  This contract is Public Domain, please feel free to copy / modify
9 //  Questions/Comments/Feedback welcome: drether00@gmail.com
10 //
11 pragma solidity ^0.4.5;
12 
13 contract HelpMeSave { 
14    
15    address public me;    // me, only I can interact with this contract
16    uint256 public savings_goal; // how much I want to save
17    
18    // Constructor / Initialize (only runs at contract creation)
19    function MyTestWallet7(){
20        me = msg.sender;   // store owner, so only I can withdraw
21        set_savings_goal(1000 ether);
22    }
23    
24    // set new savings goal if I want to, once I have reached my goal
25    function set_savings_goal(uint256 new_goal) noone_else { 
26        if (this.balance >= savings_goal) savings_goal = new_goal;
27    }
28    
29    // these functions I can use to deposit money into this account
30     function deposit() public payable {} //
31     function() payable {deposit();} //
32     
33     // Only I can use this once I have reached my goal   
34     function withdraw () public noone_else { 
35 
36          uint256 withdraw_amt = this.balance;
37          
38          if (msg.sender != me || withdraw_amt < savings_goal ){ // someone else tries to withdraw, NONONO!!!
39              withdraw_amt = 0;                     // or target savings not reached
40          }
41 
42          if (!msg.sender.send(withdraw_amt)) throw; // everything ok, send it back to me
43 
44    }
45 
46     // This modifier stops anyone else from using this contract
47     modifier noone_else() { // most functions can only be used by original creator
48         if (msg.sender == me) 
49             _;
50     }
51 
52     // Killing of contract only possible with password (--> large number, give to nextofkin/solicitor)
53     function recovery (uint256 _password) noone_else {
54        //calculate a hash from the password, and if it matches, return to contract owner
55        if ( uint256(sha3(_password)) % 10000000000000000000 == 49409376313952921 ){
56                 selfdestruct (me);
57        } else throw;
58     }
59 }