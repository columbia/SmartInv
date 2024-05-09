1 /* A contract to store only messages approved by owner */
2 contract self_store {
3 
4     address owner;
5 
6     uint16 public contentCount = 0;
7     
8     event content(string datainfo); 
9     
10     function self_store() public { owner = msg.sender; }
11     
12     ///TODO: remove in release
13     function kill() { if (msg.sender == owner) suicide(owner); }
14 
15     function add(string datainfo) {
16         if (msg.sender != owner) return;
17         contentCount++;
18         content(datainfo);
19     }
20 
21     function flush() {
22         owner.send(this.balance);
23     }
24 }