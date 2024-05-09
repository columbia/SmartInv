1 contract mortal {
2     /* Define variable owner of the type address*/
3     address owner;
4 
5     /* this function is executed at initialization and sets the owner of the contract */
6     function mortal() { owner = msg.sender; }
7 
8     /* Function to recover the funds on the contract */
9     function kill() { if (msg.sender == owner) suicide(owner); }
10 }