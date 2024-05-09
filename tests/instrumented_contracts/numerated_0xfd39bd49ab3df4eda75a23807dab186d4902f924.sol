1 /* A contract to store only messages approved by owner */
2 contract self_store {
3 
4     address owner;
5 
6     uint16 public contentCount = 0;
7     
8     event content(string datainfo);
9     modifier onlyowner { if (msg.sender == owner) _ }
10     
11     function self_store() public { owner = msg.sender; }
12     
13     ///TODO: remove in release
14     function kill() onlyowner { suicide(owner); }
15 
16     function flush() onlyowner {
17         owner.send(this.balance);
18     }
19 
20     function add(string datainfo) onlyowner {
21         contentCount++;
22         content(datainfo);
23     }
24 }