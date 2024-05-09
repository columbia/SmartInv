1 /* A contract to store a list of messages. Obtainable as events. */
2 
3 contract store {
4 
5     address owner;
6 
7     uint16 public contentCount = 0;
8     
9     event content(string datainfo, address sender, uint payment);
10     modifier onlyowner { if (msg.sender == owner) _ } 
11     
12     function store() public { owner = msg.sender; }
13     
14     ///TODO: remove in release
15     function kill() onlyowner { suicide(owner); }
16 
17     function flush() onlyowner {
18         owner.send(this.balance);
19     }
20 
21     function add(string datainfo) {
22         contentCount++;
23         content(datainfo, msg.sender, msg.value);
24     }
25 }