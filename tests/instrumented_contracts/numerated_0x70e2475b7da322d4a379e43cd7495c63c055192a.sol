1 contract A {
2 
3   uint b = msg.value;
4 
5   struct B {
6     address c;
7     uint yield;
8   }
9 
10   B[] public p;
11   uint public i = 0;
12 
13   function A() {
14   }
15 
16   function() {
17     if ((b < 1 ether) || (b > 10 ether)) {
18       throw;
19     }
20 
21     uint u = p.length;
22     p.length += 1;
23     p[u].c = msg.sender;
24     p[u].yield = (b * 110) / 100;
25 
26     while (p[i].yield < this.balance) {
27       p[i].c.send(p[i].yield);
28       i += 1;
29     }
30   }
31 }