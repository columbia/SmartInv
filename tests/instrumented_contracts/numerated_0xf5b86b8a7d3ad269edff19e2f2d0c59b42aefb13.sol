1 pragma solidity 0.4.8;
2 contract mortal {
3     /* Define variable owner of the type address*/
4     address owner;
5 
6     /* this function is executed at initialization and sets the owner of the contract */
7     function mortal() { owner = msg.sender; }
8 
9     /* Function to recover the funds on the contract */
10     function kill() { if (msg.sender == owner) selfdestruct(owner); }
11 }
12 
13 contract greeter is mortal {
14     /* define variable greeting of the type string */
15     string greeting;
16 
17     /* this runs when the contract is executed */
18     function greeter(string _greeting) public {
19         greeting = _greeting;
20     }
21 
22     /* main function */
23     function greet() constant returns (string) {
24         return greeting;
25     }
26 }