1 contract owned {
2   function owned() {
3     owner = msg.sender;
4   }
5   modifier onlyowner() {
6     if (msg.sender == owner)
7     _
8   }
9   function kill() {  //remove in production
10     if (msg.sender == owner)
11     suicide(owner);
12   }
13   function transfer(address addr) { 
14     if (msg.sender == owner)
15       owner = addr;
16   }
17   address public owner;
18 }