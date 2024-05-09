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
11 
12 contract store is mortal {
13 
14     uint16 public contentCount = 0;
15     
16     event content(string datainfo); 
17     
18     function store() public {
19     }
20 
21     function add(string datainfo) {
22         contentCount++;
23         content(datainfo);
24     }
25 }