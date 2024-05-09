1 contract Mortal {
2     /* Define variable owner of the type address */
3     address owner;
4 
5     /* This function is executed at initialization and sets the owner of the contract */
6     constructor() public { owner = msg.sender; }
7 
8     /* Function to recover the funds on the contract */
9     function kill() public { if (msg.sender == owner) selfdestruct(owner); }
10 }
11 
12 contract Greeter is Mortal {
13     /* Define variable greeting of the type string */
14     string greeting;
15 
16     /* This runs when the contract is executed */
17     constructor() public {
18         greeting = "Well, hello there! I am Gruvin's first Ethereum contract!";
19     }
20 
21     /* Main function */
22     function greet() public constant returns (string) {
23         return greeting;
24     }
25 }