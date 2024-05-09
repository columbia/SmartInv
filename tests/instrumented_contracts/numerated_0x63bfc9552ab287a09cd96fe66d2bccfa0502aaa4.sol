1 pragma solidity ^0.4.8;                  //specify compiler version
2 //this is a comment!
3 
4 contract Josephtoken {                     //this is a smart contract!
5     
6     address owner;                       //which account gets the 1000 josephtoken to begin with
7     mapping (address => uint) balances;  //keep track of the number of josephtoken in each account
8     
9     function Josephtoken() public {
10         owner = msg.sender;              //msg.sender is the address of the account that called the function
11                                          //here, msg.sender is the account that deployed the contract
12         balances[owner] = 1000;          //mint the owner 1000 josephtoken and put it in the mapping
13     }
14     
15     function transfer(uint amount, address recipient) public {      //move josephtoken between accounts
16         require(balances[msg.sender] >= amount);
17         require(balances[msg.sender] - amount <= balances[msg.sender]);
18         require(balances[recipient] + amount >= balances[recipient]);
19         balances[msg.sender] -= amount;
20         balances[recipient] += amount;
21         //hmm, how might evil attacker Jennifer try to exploit this function?
22     }
23 }